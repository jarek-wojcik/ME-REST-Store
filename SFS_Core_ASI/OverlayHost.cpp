#include "OverlayHost.h"
#include <cstdio>

#pragma comment(lib, "comctl32.lib")

// Static instance pointer used by the WH_KEYBOARD_LL hook proc.
OverlayHost* OverlayHost::s_instance = nullptr;

// Simple append-only log used by the overlay thread.
// Written to the same directory as the ASI.
static FILE* s_log = nullptr;

static void OvLog(const char* fmt, ...)
{
    if (!s_log) return;
    va_list args;
    va_start(args, fmt);
    vfprintf(s_log, fmt, args);
    va_end(args);
    fflush(s_log);
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

static bool IsWebView2RuntimeInstalled()
{
    LPWSTR version = nullptr;
    HRESULT hr = GetAvailableCoreWebView2BrowserVersionString(nullptr, &version);
    if (SUCCEEDED(hr) && version)
    {
        CoTaskMemFree(version);
        return true;
    }
    return false;
}

// Finds the Mass Effect 3 game window and returns its screen rect.
// Falls back to the primary monitor work area if the window isn't found yet.
static RECT GetGameWindowRect()
{
    // ME3 window title contains "Mass Effect 3"
    HWND gameWnd = FindWindowW(nullptr, L"Mass Effect 3");
    if (!gameWnd)
    {
        // Fallback: use the primary monitor
        RECT rc{};
        SystemParametersInfoW(SPI_GETWORKAREA, 0, &rc, 0);
        return rc;
    }

    RECT rc{};
    GetWindowRect(gameWnd, &rc);
    return rc;
}

// ---------------------------------------------------------------------------
// Public API
// ---------------------------------------------------------------------------

bool OverlayHost::Initialize(HMODULE hModule)
{
    if (m_initialized)
        return true;

    if (!IsWebView2RuntimeInstalled())
        return false;

    // Open overlay-specific log next to the ASI
    if (!s_log)
    {
        wchar_t logPath[MAX_PATH]{};
        GetModuleFileNameW(hModule, logPath, MAX_PATH);
        // Replace filename with OverlayLog.txt
        wchar_t* slash = wcsrchr(logPath, L'\\');
        if (slash)
        {
            wcscpy_s(slash + 1, MAX_PATH - (slash - logPath) - 1, L"OverlayLog.txt");
            _wfopen_s(&s_log, logPath, L"w");
        }
    }

    OvLog("[Overlay] Initialize called.\n");

    m_hModule     = hModule;
    m_initialized = true;

    m_thread = CreateThread(nullptr, 0, OverlayHost::OverlayThreadProc, this, 0, &m_threadId);
    if (!m_thread)
    {
        OvLog("[Overlay] CreateThread failed GLE=%lu\n", GetLastError());
        m_initialized = false;
        return false;
    }
    OvLog("[Overlay] Thread created id=%lu\n", m_threadId);
    return true;
}

void OverlayHost::Show()
{
    OvLog("[Overlay] Show() called. m_webView=%p m_hwnd=%p\n",
          static_cast<void*>(m_webView.Get()), static_cast<void*>(m_hwnd));

    m_toggleVisible = true;
    m_panelVisible  = true;

    if (!m_webView)
    {
        OvLog("[Overlay] WebView2 not ready yet, setting m_showPending.\n");
        m_showPending = true;
        return;
    }
    if (m_hwnd)
    {
        OvLog("[Overlay] Posting WM_USER+1 to show window.\n");
        PostMessage(m_hwnd, WM_USER + 1, 0, 0);
    }
    if (m_toggleHwnd)
        PostMessage(m_toggleHwnd, WM_USER + 1, 0, 0);
}

void OverlayHost::ShowToggleOnly()
{
    OvLog("[Overlay] ShowToggleOnly() called. m_toggleHwnd=%p\n",
          static_cast<void*>(m_toggleHwnd));

    if (!m_toggleHwnd)
        return;

    m_toggleVisible = true;

    // Position the tab at the right edge of the game window since the
    // overlay panel is hidden � same position as after hiding the panel.
    HWND gameWnd = FindWindowW(nullptr, L"Mass Effect 3");
    if (gameWnd)
    {
        RECT gc{};
        GetClientRect(gameWnd, &gc);
        POINT pt{ gc.left, gc.top };
        ClientToScreen(gameWnd, &pt);
        const int tabH = gc.bottom - gc.top;
        SetWindowPos(m_toggleHwnd, HWND_TOPMOST,
                     pt.x + gc.right - k_ToggleW, pt.y,
                     k_ToggleW, tabH,
                     SWP_NOACTIVATE | SWP_SHOWWINDOW);
    }
    else
    {
        PostMessage(m_toggleHwnd, WM_USER + 1, 0, 0);
    }
}

void OverlayHost::Hide()
{
    m_toggleVisible = false;
    m_panelVisible  = false;
    if (m_hwnd)       PostMessage(m_hwnd,      WM_USER + 2, 0, 0);
    if (m_toggleHwnd) PostMessage(m_toggleHwnd, WM_USER + 2, 0, 0);
}

void OverlayHost::Shutdown()
{
    if (m_toggleHwnd) PostMessage(m_toggleHwnd, WM_DESTROY, 0, 0);
    if (m_hwnd)       PostMessage(m_hwnd,        WM_DESTROY, 0, 0);

    if (m_thread)
    {
        WaitForSingleObject(m_thread, 5000);
        CloseHandle(m_thread);
        m_thread = nullptr;
    }

    m_initialized = false;
}

// ---------------------------------------------------------------------------
// Overlay thread � owns the window and runs the message loop
// ---------------------------------------------------------------------------

// static
DWORD WINAPI OverlayHost::OverlayThreadProc(LPVOID param)
{
    static_cast<OverlayHost*>(param)->OverlayThread();
    return 0;
}

void OverlayHost::OverlayThread()
{
    OvLog("[Overlay] Thread started.\n");

    // WebView2 requires COM to be initialized on this thread.
    HRESULT comHr = CoInitializeEx(nullptr, COINIT_APARTMENTTHREADED);
    OvLog("[Overlay] CoInitializeEx hr=0x%08X\n", comHr);
    if (FAILED(comHr))
        return;

    // ---- 1. Find game window and compute geometry ----
    // Wait until the window exists AND is not minimized (minimized windows
    // return rect -32000,-32000 which would place the overlay off-screen).
    HWND gameWnd = nullptr;
    for (int i = 0; i < 60; i++)
    {
        gameWnd = FindWindowW(nullptr, L"Mass Effect 3");
        if (gameWnd && !IsIconic(gameWnd))
            break;
        gameWnd = nullptr;
        Sleep(500);
    }

    RECT gameRect{};
    if (gameWnd)
        GetWindowRect(gameWnd, &gameRect);
    else
        SystemParametersInfoW(SPI_GETWORKAREA, 0, &gameRect, 0);

    const int gameX = gameRect.left;
    const int gameY = gameRect.top;
    const int gameW = gameRect.right  - gameRect.left;
    const int gameH = gameRect.bottom - gameRect.top;
    const int winW  = gameW / 2;   // 50% of game window width
    const int winH  = gameH;
    const int winX  = gameX + gameW - winW;
    const int winY  = gameY;

    OvLog("[Overlay] gameWnd=%p Game rect: %d,%d  %dx%d\n",
          static_cast<void*>(gameWnd), gameX, gameY, gameW, gameH);
    OvLog("[Overlay] Overlay rect: %d,%d  %dx%d\n", winX, winY, winW, winH);

    // ---- 2. Register window class ----
    WNDCLASSEXW wc{};
    wc.cbSize        = sizeof(wc);
    wc.style         = CS_HREDRAW | CS_VREDRAW;
    wc.lpfnWndProc   = OverlayHost::WndProc;
    wc.hInstance     = m_hModule;
    wc.hCursor       = LoadCursor(nullptr, IDC_ARROW);
    wc.hbrBackground = reinterpret_cast<HBRUSH>(COLOR_WINDOW + 1);
    wc.lpszClassName = k_ClassName;
    ATOM atom = RegisterClassExW(&wc);
    OvLog("[Overlay] RegisterClassExW atom=%u GLE=%lu\n", atom, GetLastError());

    // ---- 3. Create window ----
    // WS_EX_NOACTIVATE stops the overlay stealing focus from the game.
    // We do NOT parent to gameWnd � parenting a popup to a D3D fullscreen
    // window causes it to be clipped. Instead we use HWND_TOPMOST and
    // position it on the same monitor.
    m_hwnd = CreateWindowExW(
        WS_EX_TOPMOST | WS_EX_TOOLWINDOW | WS_EX_NOACTIVATE,
        k_ClassName,
        L"SFS Overlay",
        WS_POPUP,
        winX, winY, winW, winH,
        nullptr, nullptr,
        m_hModule,
        this
    );

    OvLog("[Overlay] CreateWindowExW hwnd=%p GLE=%lu\n",
          static_cast<void*>(m_hwnd), GetLastError());

    if (!m_hwnd)
    {
        CoUninitialize();
        return;
    }

    // Create the toggle tab just to the left of the main overlay.
    // Use the overlay's own position/height so the tab always matches it exactly.
    CreateToggleWindow(winX, winY, winH);
    OvLog("[Overlay] Toggle hwnd=%p\n", static_cast<void*>(m_toggleHwnd));

    // Start the game-window monitor timer on the toggle window so we can
    // reposition / show / hide the overlay pair as the game minimizes and restores.
    SetTimer(m_toggleHwnd, 1 /*id*/, 250 /*ms*/, nullptr);

    // ---- 4. Build a writable user-data path for WebView2 ----
    // Using the default (nullptr) path can fail when the host process has
    // restricted write access. Explicitly point it at a temp folder.
    wchar_t udPath[MAX_PATH]{};
    GetModuleFileNameW(m_hModule, udPath, MAX_PATH);
    wchar_t* sl = wcsrchr(udPath, L'\\');
    if (sl) wcscpy_s(sl + 1, MAX_PATH - (sl - udPath) - 1, L"WebView2Data");
    OvLog("[Overlay] UserDataFolder: %ls\n", udPath);

    // ---- 5. Create WebView2 environment with explicit user-data folder ----
    OvLog("[Overlay] Calling CreateCoreWebView2EnvironmentWithOptions...\n");
    HRESULT hr = CreateCoreWebView2EnvironmentWithOptions(
        nullptr,
        udPath,     // explicit writable user-data folder
        nullptr,
        Microsoft::WRL::Callback<ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler>(
            [this](HRESULT result, ICoreWebView2Environment* env) -> HRESULT
            {
                OvLog("[Overlay] Environment callback hr=0x%08X env=%p\n",
                      result, static_cast<void*>(env));
                OnEnvironmentCreated(result, env);
                return S_OK;
            }
        ).Get()
    );
    OvLog("[Overlay] CreateCoreWebView2EnvironmentWithOptions returned hr=0x%08X\n", hr);
    if (FAILED(hr))
    {
        CoUninitialize();
        return;
    }

    // ---- 6. Message loop ----
    // Install a low-level keyboard hook BEFORE entering the loop.
    // WH_KEYBOARD_LL always fires on the installing thread (here), so it
    // will be serviced by the GetMessage loop below without any cross-thread
    // focus magic that would minimize ME3's fullscreen D3D window.
    s_instance = this;
    m_llKeyHook = SetWindowsHookEx(WH_KEYBOARD_LL, LowLevelKeyProc, m_hModule, 0);
    OvLog("[Overlay] SetWindowsHookEx(WH_KEYBOARD_LL) hook=%p GLE=%lu\n",
          static_cast<void*>(m_llKeyHook), GetLastError());

    OvLog("[Overlay] Entering message loop.\n");
    MSG msg{};
    while (GetMessageW(&msg, nullptr, 0, 0))
    {
        TranslateMessage(&msg);
        DispatchMessageW(&msg);
    }
    OvLog("[Overlay] Message loop exited.\n");

    CoUninitialize();
}

// ---------------------------------------------------------------------------
// Toggle tab window
// ---------------------------------------------------------------------------

void OverlayHost::CreateToggleWindow(int overlayX, int overlayY, int overlayH)
{
    WNDCLASSEXW wc{};
    wc.cbSize        = sizeof(wc);
    wc.style         = CS_HREDRAW | CS_VREDRAW;
    wc.lpfnWndProc   = OverlayHost::ToggleWndProc;
    wc.hInstance     = m_hModule;
    wc.hCursor       = LoadCursor(nullptr, IDC_HAND);
    wc.hbrBackground = nullptr;  // painted manually
    wc.lpszClassName = k_ToggleClassName;
    RegisterClassExW(&wc);

    m_toggleHwnd = CreateWindowExW(
        WS_EX_TOPMOST | WS_EX_TOOLWINDOW | WS_EX_NOACTIVATE,
        k_ToggleClassName,
        L"SFS Toggle",
        WS_POPUP,
        overlayX - k_ToggleW, overlayY,  // immediately left of the overlay
        k_ToggleW, overlayH,
        nullptr, nullptr,
        m_hModule,
        this
    );
}

// static
LRESULT CALLBACK OverlayHost::ToggleWndProc(HWND hwnd, UINT msg, WPARAM wp, LPARAM lp)
{
    OverlayHost* self = nullptr;

    if (msg == WM_NCCREATE)
    {
        auto* cs = reinterpret_cast<CREATESTRUCTW*>(lp);
        self = static_cast<OverlayHost*>(cs->lpCreateParams);
        SetWindowLongPtrW(hwnd, GWLP_USERDATA, reinterpret_cast<LONG_PTR>(self));
    }
    else
    {
        self = reinterpret_cast<OverlayHost*>(GetWindowLongPtrW(hwnd, GWLP_USERDATA));
    }

    if (self)
        return self->HandleToggleMessage(hwnd, msg, wp, lp);

    return DefWindowProcW(hwnd, msg, wp, lp);
}

LRESULT OverlayHost::HandleToggleMessage(HWND hwnd, UINT msg, WPARAM wp, LPARAM lp)
{
    switch (msg)
    {
    // Prevent the overlay from stealing focus / activating the game-losing-focus path.
    case WM_MOUSEACTIVATE:
        return MA_NOACTIVATE;

    case WM_ACTIVATE:
        // If Windows somehow activates us anyway, immediately hand focus back.
        if (LOWORD(wp) != WA_INACTIVE)
        {
            HWND gameWnd = FindWindowW(nullptr, L"Mass Effect 3");
            if (gameWnd) SetForegroundWindow(gameWnd);
        }
        return 0;

    // Monitor the game window and keep the overlay pair in sync with its lifecycle.
    case WM_TIMER:
    {
        if (wp != 1 || !m_toggleVisible) break;

        HWND gameWnd = FindWindowW(nullptr, L"Mass Effect 3");
        if (!gameWnd) break;

        if (IsIconic(gameWnd))
        {
            // Game is minimized — hide our windows so they don't float over the desktop.
            if (IsWindowVisible(hwnd))   ShowWindow(hwnd,   SW_HIDE);
            if (IsWindowVisible(m_hwnd)) ShowWindow(m_hwnd, SW_HIDE);
        }
        else
        {
            // Game is visible — reposition and (re)show the overlay pair.
            RECT gc{};
            GetClientRect(gameWnd, &gc);
            POINT pt{ 0, 0 };
            ClientToScreen(gameWnd, &pt);
            const int cW = gc.right  - gc.left;
            const int cH = gc.bottom - gc.top;
            const int overlayW = cW / 2;

            if (m_panelVisible)
            {
                // Panel is open: overlay fills right half, toggle is left of overlay.
                const int overlayX = pt.x + cW - overlayW;
                SetWindowPos(m_hwnd, HWND_TOPMOST,
                             overlayX, pt.y, overlayW, cH,
                             SWP_NOACTIVATE | SWP_SHOWWINDOW);
                SetWindowPos(hwnd, HWND_TOPMOST,
                             overlayX - k_ToggleW, pt.y, k_ToggleW, cH,
                             SWP_NOACTIVATE | SWP_SHOWWINDOW);
            }
            else
            {
                // Panel closed: toggle sits at right edge of game window.
                SetWindowPos(hwnd, HWND_TOPMOST,
                             pt.x + cW - k_ToggleW, pt.y, k_ToggleW, cH,
                             SWP_NOACTIVATE | SWP_SHOWWINDOW);
            }
        }
        break;
    }

    case WM_PAINT:
    {
        PAINTSTRUCT ps;
        HDC hdc = BeginPaint(hwnd, &ps);

        RECT rc;
        GetClientRect(hwnd, &rc);
        const int tabW = rc.right;
        const int tabH = rc.bottom;

        // Background
        HBRUSH bg = CreateSolidBrush(RGB(30, 30, 30));
        FillRect(hdc, &rc, bg);
        DeleteObject(bg);

        const wchar_t* label = L"Spectre Portal";

        // Use a non-rotated font and apply a world transform to rotate.
        // This gives reliable centring since DrawText works in pre-rotation space.
        HFONT font = CreateFontW(
            26, 0, 0, 0,
            FW_SEMIBOLD, FALSE, FALSE, FALSE,
            DEFAULT_CHARSET, OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS,
            CLEARTYPE_QUALITY, DEFAULT_PITCH | FF_SWISS,
            L"Segoe UI"
        );
        HFONT oldFont = static_cast<HFONT>(SelectObject(hdc, font));
        SetBkMode(hdc, TRANSPARENT);
        SetTextColor(hdc, RGB(220, 220, 220));

        // Measure text in normal (unrotated) space
        SIZE sz{};
        GetTextExtentPoint32W(hdc, label, static_cast<int>(wcslen(label)), &sz);

        // Enable world transforms
        SetGraphicsMode(hdc, GM_ADVANCED);

        // Rotate 90� CCW around the centre of the tab:
        //   1. Translate so tab-centre is at origin
        //   2. Rotate -90� (CCW): x'=-y, y'=x
        //   3. Translate back
        // The text rect in rotated space is centred at origin,
        // so in pre-rotation space we centre it at (0,0).
        // Pre-rotation text rect: width=sz.cx, height=sz.cy
        // Centred draw origin (top-left of text): (-sz.cx/2, -sz.cy/2)

        // cos(-90�)=0  sin(-90�)=-1
        XFORM xf{};
        xf.eM11 =  0.0f;  xf.eM12 = -1.0f;
        xf.eM21 =  1.0f;  xf.eM22 =  0.0f;
        // After rotation, translate to tab centre
        xf.eDx  = static_cast<float>(tabW / 2);
        xf.eDy  = static_cast<float>(tabH / 2);
        SetWorldTransform(hdc, &xf);

        // Draw centred at (0,0) in pre-rotation space
        RECT textRc{};
        textRc.left   = -sz.cx / 2;
        textRc.top    = -sz.cy / 2;
        textRc.right  =  sz.cx / 2;
        textRc.bottom =  sz.cy / 2;
        DrawTextW(hdc, label, -1, &textRc, DT_CENTER | DT_VCENTER | DT_SINGLELINE);

        // Restore identity transform
        XFORM identity{ 1,0,0,1,0,0 };
        SetWorldTransform(hdc, &identity);
        SetGraphicsMode(hdc, GM_COMPATIBLE);

        SelectObject(hdc, oldFont);
        DeleteObject(font);
        EndPaint(hwnd, &ps);
        return 0;
    }

    case WM_LBUTTONUP:
    {
        bool nowVisible = IsWindowVisible(m_hwnd);
        OvLog("[Overlay] Toggle clicked � overlay was %s.\n", nowVisible ? "visible" : "hidden");

        HWND gameWnd = FindWindowW(nullptr, L"Mass Effect 3");
        RECT gameClient{};
        RECT gameWin{};
        if (gameWnd)
        {
            GetWindowRect(gameWnd, &gameWin);
            GetClientRect(gameWnd, &gameClient);
            // Map client rect to screen coords
            POINT pt{ gameClient.left, gameClient.top };
            ClientToScreen(gameWnd, &pt);
            gameClient.left   = pt.x;
            gameClient.top    = pt.y;
            gameClient.right  = pt.x + gameClient.right;
            gameClient.bottom = pt.y + gameClient.bottom;
        }

        const int tabH = gameWnd ? (gameClient.bottom - gameClient.top) : 720;
        const int tabY = gameWnd ? gameClient.top : 0;

        if (nowVisible)
        {
            m_panelVisible = false;
            ShowWindow(m_hwnd, SW_HIDE);
            if (gameWnd)
            {
                SetWindowPos(m_toggleHwnd, HWND_TOPMOST,
                             gameClient.right - k_ToggleW, tabY,
                             k_ToggleW, tabH,
                             SWP_NOACTIVATE | SWP_SHOWWINDOW);
            }
        }
        else
        {
            m_panelVisible = true;
            RECT or_{};
            GetWindowRect(m_hwnd, &or_);
            SetWindowPos(m_toggleHwnd, HWND_TOPMOST,
                         or_.left - k_ToggleW, tabY,
                         k_ToggleW, tabH,
                         SWP_NOACTIVATE | SWP_SHOWWINDOW);
            ShowWindow(m_hwnd, SW_SHOW);
            if (m_controller)
                m_controller->MoveFocus(COREWEBVIEW2_MOVE_FOCUS_REASON_PROGRAMMATIC);
        }
        InvalidateRect(hwnd, nullptr, TRUE);
        return 0;
    }

    case WM_USER + 1:   // Show (called at startup)
        m_toggleVisible = true;
        ShowWindow(hwnd, SW_SHOW);
        return 0;

    case WM_USER + 2:   // Hide
        m_toggleVisible = false;
        ShowWindow(hwnd, SW_HIDE);
        return 0;

    case WM_DESTROY:
        KillTimer(hwnd, 1);
        m_toggleHwnd = nullptr;
        return 0;
    }

    return DefWindowProcW(hwnd, msg, wp, lp);
}

// ---------------------------------------------------------------------------
// Main overlay window procedure
// ---------------------------------------------------------------------------


// static
LRESULT CALLBACK OverlayHost::WndProc(HWND hwnd, UINT msg, WPARAM wp, LPARAM lp)
{
    OverlayHost* self = nullptr;

    if (msg == WM_NCCREATE)
    {
        auto* cs = reinterpret_cast<CREATESTRUCTW*>(lp);
        self = static_cast<OverlayHost*>(cs->lpCreateParams);
        SetWindowLongPtrW(hwnd, GWLP_USERDATA, reinterpret_cast<LONG_PTR>(self));
    }
    else
    {
        self = reinterpret_cast<OverlayHost*>(GetWindowLongPtrW(hwnd, GWLP_USERDATA));
    }

    if (self)
        return self->HandleMessage(hwnd, msg, wp, lp);

    return DefWindowProcW(hwnd, msg, wp, lp);
}

LRESULT OverlayHost::HandleMessage(HWND hwnd, UINT msg, WPARAM wp, LPARAM lp)
{
    switch (msg)
    {
    case WM_SIZE:
        ResizeWebView();
        return 0;

    case WM_USER + 1:   // Show()
        m_panelVisible = true;
        ShowWindow(hwnd, SW_SHOW);
        if (m_controller)
            m_controller->MoveFocus(COREWEBVIEW2_MOVE_FOCUS_REASON_PROGRAMMATIC);
        return 0;

    case WM_USER + 2:   // Hide()
        m_panelVisible = false;
        ShowWindow(hwnd, SW_HIDE);
        return 0;

    case WM_CLOSE:
        ShowWindow(hwnd, SW_HIDE);
        return 0;

    case WM_DESTROY:
        if (m_llKeyHook) { UnhookWindowsHookEx(m_llKeyHook); m_llKeyHook = nullptr; }
        s_instance = nullptr;
        if (m_controller) { m_controller->Close(); m_controller.Reset(); }
        m_webView.Reset();
        m_env.Reset();
        m_hwnd = nullptr;
        PostQuitMessage(0);     // exits the GetMessage loop
        return 0;
    }

    return DefWindowProcW(hwnd, msg, wp, lp);
}

// ---------------------------------------------------------------------------
// WebView2 callbacks (fire on the overlay thread)
// ---------------------------------------------------------------------------

void OverlayHost::OnEnvironmentCreated(HRESULT result, ICoreWebView2Environment* env)
{
    if (FAILED(result) || !env || !m_hwnd)
        return;

    m_env = env;

    env->CreateCoreWebView2Controller(
        m_hwnd,
        Microsoft::WRL::Callback<ICoreWebView2CreateCoreWebView2ControllerCompletedHandler>(
            [this](HRESULT res, ICoreWebView2Controller* controller) -> HRESULT
            {
                OnControllerCreated(res, controller);
                return S_OK;
            }
        ).Get()
    );
}

void OverlayHost::OnControllerCreated(HRESULT result, ICoreWebView2Controller* controller)
{
    OvLog("[Overlay] OnControllerCreated hr=0x%08X controller=%p\n",
          result, static_cast<void*>(controller));

    if (FAILED(result) || !controller || !m_hwnd)
        return;

    m_controller = controller;
    controller->get_CoreWebView2(m_webView.GetAddressOf());

    if (!m_webView)
    {
        OvLog("[Overlay] get_CoreWebView2 returned null.\n");
        return;
    }

    ResizeWebView();

    // Explicitly mark the controller as visible � this is separate from
    // the window being shown and must be set for rendering to occur.
    m_controller->put_IsVisible(TRUE);

    // Set a solid white background so the webview paints immediately
    // rather than leaving the default transparent/blank state.
    COREWEBVIEW2_COLOR bg{ 255, 255, 255, 255 };
    Microsoft::WRL::ComPtr<ICoreWebView2Controller2> ctrl2;
    if (SUCCEEDED(m_controller.As(&ctrl2)))
        ctrl2->put_DefaultBackgroundColor(bg);

    HRESULT navHr = m_webView->Navigate(L"http://localhost:6060/spectreportal/");
    OvLog("[Overlay] Navigate hr=0x%08X\n", navHr);

    // Subclass Chromium child windows now that the controller is ready.
    // This is called again from ResizeWebView() to catch any windows
    // Chromium creates later.
    SubclassChromiumChildren();

    OvLog("[Overlay] m_showPending=%d\n", m_showPending);
    if (m_showPending)
    {
        m_showPending = false;
        OvLog("[Overlay] Honouring pending Show().\n");
        PostMessage(m_hwnd, WM_USER + 1, 0, 0);
        if (m_toggleHwnd) PostMessage(m_toggleHwnd, WM_USER + 1, 0, 0);
    }
}

void OverlayHost::ResizeWebView()
{
    if (!m_controller || !m_hwnd)
        return;

    RECT rc{};
    GetClientRect(m_hwnd, &rc);
    m_controller->put_Bounds(rc);

    // Chromium may recreate compositor HWNDs after a resize — re-subclass.
    SubclassChromiumChildren();
}

// ---------------------------------------------------------------------------
// Chromium child-window subclassing (focus-steal prevention)
// ---------------------------------------------------------------------------

// Subclass proc installed on every Chromium child HWND under m_hwnd.
// Returns MA_NOACTIVATE so that clicking the WebView2 surface never activates
// the overlay window chain and never causes a fullscreen D3D game to minimize.
// The click itself is NOT consumed — Chromium still receives it and routes it
// to the correct input element, so keyboard focus inside WebView2 works fine.
// static
LRESULT CALLBACK OverlayHost::ChromiumChildSubclassProc(
    HWND hwnd, UINT msg, WPARAM wp, LPARAM lp, UINT_PTR uid, DWORD_PTR /*ref*/)
{
    if (msg == WM_MOUSEACTIVATE)
        return MA_NOACTIVATE;

    if (msg == WM_NCDESTROY)
    {
        // Clean up the subclass when the window is destroyed.
        RemoveWindowSubclass(hwnd, ChromiumChildSubclassProc, uid);
    }

    return DefSubclassProc(hwnd, msg, wp, lp);
}

// EnumChildWindows callback — subclasses each direct and indirect child.
// static
BOOL CALLBACK OverlayHost::EnumChromiumChildren(HWND hwnd, LPARAM /*lp*/)
{
    // SetWindowSubclass is idempotent with the same (proc, uid) pair, so
    // calling it again on an already-subclassed window is safe.
    SetWindowSubclass(hwnd, ChromiumChildSubclassProc,
                      reinterpret_cast<UINT_PTR>(ChromiumChildSubclassProc), 0);
    return TRUE;  // continue enumeration
}

void OverlayHost::SubclassChromiumChildren()
{
    if (!m_hwnd) return;
    OvLog("[Overlay] SubclassChromiumChildren called.\n");
    EnumChildWindows(m_hwnd, EnumChromiumChildren, 0);
}

// ---------------------------------------------------------------------------
// Low-level keyboard hook — keyboard input forwarding
// ---------------------------------------------------------------------------

// Finds the Chromium render widget HWND that actually processes key events.
// WebView2 creates a child HWND with class "Chrome_RenderWidgetHostHWND"
// under the host window; keyboard messages must be dispatched there.
static HWND FindRenderWidget(HWND host)
{
    HWND h = FindWindowExW(host, nullptr, L"Chrome_RenderWidgetHostHWND", nullptr);
    if (!h)
    {
        // Some WebView2 versions nest the widget further down; do a full search.
        struct Find { static BOOL CALLBACK cb(HWND w, LPARAM lp) {
            wchar_t cls[64]{};
            GetClassNameW(w, cls, 64);
            if (wcscmp(cls, L"Chrome_RenderWidgetHostHWND") == 0) {
                *reinterpret_cast<HWND*>(lp) = w;
                return FALSE; // stop
            }
            return TRUE;
        }};
        EnumChildWindows(host, Find::cb, reinterpret_cast<LPARAM>(&h));
    }
    return h;
}

// static
LRESULT CALLBACK OverlayHost::LowLevelKeyProc(int nCode, WPARAM wParam, LPARAM lParam)
{
    // Modifier state tracked explicitly inside the hook.
    // The LL hook always fires on the installing (overlay) thread, so these
    // statics are only ever touched from one thread — no synchronisation needed.
    // We cannot rely on GetAsyncKeyState or GetKeyboardState here: when we
    // suppress a key by returning 1, Windows may not update either state table
    // before the next hook invocation fires for the following key.
    static bool s_shiftDown   = false;
    static bool s_ctrlDown    = false;
    static bool s_altDown     = false;  // VK_MENU (used for AltGr detection)
    static bool s_capsLockOn  = false;  // toggle state
    static bool s_numlockOn   = true;   // toggle state (on by default)

    if (nCode != HC_ACTION)
        return CallNextHookEx(nullptr, nCode, wParam, lParam);

    KBDLLHOOKSTRUCT* kb = reinterpret_cast<KBDLLHOOKSTRUCT*>(lParam);
    UINT uMsg = static_cast<UINT>(wParam);
    bool isDown = (uMsg == WM_KEYDOWN || uMsg == WM_SYSKEYDOWN);
    bool isUp   = (uMsg == WM_KEYUP   || uMsg == WM_SYSKEYUP);

    // --- Always update our modifier tracking, even when panel is closed ---
    // This keeps state consistent so that when the panel opens mid-session
    // the modifier state is already correct.
    if (!(kb->flags & LLKHF_INJECTED))
    {
        switch (kb->vkCode)
        {
        case VK_SHIFT: case VK_LSHIFT: case VK_RSHIFT:
            s_shiftDown = isDown;
            break;
        case VK_CONTROL: case VK_LCONTROL: case VK_RCONTROL:
            s_ctrlDown = isDown;
            break;
        case VK_MENU: case VK_LMENU: case VK_RMENU:
            s_altDown = isDown;
            break;
        case VK_CAPITAL:
            if (isDown) s_capsLockOn = !s_capsLockOn;
            break;
        case VK_NUMLOCK:
            if (isDown) s_numlockOn = !s_numlockOn;
            break;
        }
    }

    if (s_instance && s_instance->m_panelVisible && !(kb->flags & LLKHF_INJECTED))
    {
        HWND target = FindRenderWidget(s_instance->m_hwnd);
        if (!target) target = s_instance->m_hwnd;

        // Build lParam for WM_KEYDOWN/WM_KEYUP messages.
        LPARAM keyLp = 1 | (static_cast<LPARAM>(kb->scanCode & 0xFF) << 16);
        if (kb->flags & LLKHF_EXTENDED)  keyLp |= (1UL << 24);
        if (isUp)                         keyLp |= (3UL << 30);

        if (isDown)
        {
            // Build a keyboard state array from our tracked modifier state.
            // This is reliable because we maintained it ourselves for every
            // key event, so Shift/CapsLock/AltGr are always current.
            BYTE ks[256]{};
            if (s_shiftDown)  { ks[VK_SHIFT]   = 0x80; ks[VK_LSHIFT]   = 0x80; }
            if (s_ctrlDown)   { ks[VK_CONTROL] = 0x80; ks[VK_LCONTROL] = 0x80; }
            if (s_altDown)    { ks[VK_MENU]    = 0x80; ks[VK_LMENU]    = 0x80; }
            if (s_capsLockOn) { ks[VK_CAPITAL] = 0x01; }
            if (s_numlockOn)  { ks[VK_NUMLOCK] = 0x01; }

            WCHAR ch[8]{};
            int n = ToUnicodeEx(kb->vkCode, kb->scanCode, ks,
                                ch, _countof(ch), 0, GetKeyboardLayout(0));

            // Printable = ToUnicodeEx returned a non-control glyph.
            bool isPrintable = (n > 0 && static_cast<unsigned>(ch[0]) >= 0x20u);

            if (!isPrintable || s_ctrlDown)
            {
                // Non-printable (arrows, backspace, enter, escape, F-keys, tab)
                // or keyboard shortcut: forward as WM_KEYDOWN so Chromium handles
                // the virtual key directly.
                PostMessage(target, uMsg, static_cast<WPARAM>(kb->vkCode), keyLp);
            }
            else
            {
                // Printable character: post WM_CHAR with the correctly-cased
                // character we computed. Skip WM_KEYDOWN to avoid Chromium
                // generating a second WM_CHAR from its own TranslateMessage call.
                LPARAM charLp = 1 | (static_cast<LPARAM>(kb->scanCode & 0xFF) << 16);
                for (int i = 0; i < n; ++i)
                    PostMessage(target, WM_CHAR, static_cast<WPARAM>(ch[i]), charLp);
            }
        }
        else
        {
            // WM_KEYUP / WM_SYSKEYUP: always forward so Chromium releases
            // its internal modifier/key state correctly.
            PostMessage(target, uMsg, static_cast<WPARAM>(kb->vkCode), keyLp);
        }

        // Suppress the keystroke so ME3 does not also react to it while
        // the overlay panel is open.
        return 1;
    }
    return CallNextHookEx(nullptr, nCode, wParam, lParam);
}