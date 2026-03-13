#include "OverlayHost.h"
#include <cstdio>

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

void OverlayHost::Hide()
{
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
// Overlay thread — owns the window and runs the message loop
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
    // We do NOT parent to gameWnd — parenting a popup to a D3D fullscreen
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
    case WM_PAINT:
    {
        PAINTSTRUCT ps;
        HDC hdc = BeginPaint(hwnd, &ps);

        RECT rc;
        GetClientRect(hwnd, &rc);

        // Background
        HBRUSH bg = CreateSolidBrush(RGB(30, 30, 30));
        FillRect(hdc, &rc, bg);
        DeleteObject(bg);

        // Choose label based on whether the overlay is currently shown
        const wchar_t* label = (m_hwnd && IsWindowVisible(m_hwnd))
                               ? L"Hide overlay"
                               : L"Show overlay";

        // Rotated font: escapement + orientation both 90 degrees (= 900 tenths)
        HFONT font = CreateFontW(
            13, 0,          // height, width
            900, 900,       // escapement, orientation (90 degrees)
            FW_NORMAL, FALSE, FALSE, FALSE,
            DEFAULT_CHARSET, OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS,
            CLEARTYPE_QUALITY, DEFAULT_PITCH | FF_SWISS,
            L"Segoe UI"
        );
        HFONT oldFont = static_cast<HFONT>(SelectObject(hdc, font));
        SetBkMode(hdc, TRANSPARENT);
        SetTextColor(hdc, RGB(220, 220, 220));

        // Measure the rotated text (GetTextExtentPoint32 measures in logical
        // units before rotation, so cx = rendered height, cy = rendered width)
        SIZE sz{};
        GetTextExtentPoint32W(hdc, label, static_cast<int>(wcslen(label)), &sz);

        // With 90° CCW rotation (escapement=900):
        //   text runs upward from the baseline point
        //   sz.cx = length of the text run (maps to vertical screen span)
        //   sz.cy = cap height (maps to horizontal screen span)
        // Centre the run vertically: baseline y = midpoint + half the run length
        // Centre horizontally:       baseline x = midpoint + half the cap height
        int x = (rc.right  + sz.cy) / 2;
        int y = (rc.bottom + sz.cx) / 2;

        TextOutW(hdc, x, y, label, static_cast<int>(wcslen(label)));

        SelectObject(hdc, oldFont);
        DeleteObject(font);
        EndPaint(hwnd, &ps);
        return 0;
    }

    case WM_LBUTTONUP:
    {
        bool nowVisible = IsWindowVisible(m_hwnd);
        OvLog("[Overlay] Toggle clicked — overlay was %s.\n", nowVisible ? "visible" : "hidden");

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
            RECT or_{};
            GetWindowRect(m_hwnd, &or_);
            SetWindowPos(m_toggleHwnd, HWND_TOPMOST,
                         or_.left - k_ToggleW, tabY,
                         k_ToggleW, tabH,
                         SWP_NOACTIVATE | SWP_SHOWWINDOW);
            ShowWindow(m_hwnd, SW_SHOW);
        }
        InvalidateRect(hwnd, nullptr, TRUE);
        return 0;
    }

    case WM_USER + 1:   // Show (called at startup)
        ShowWindow(hwnd, SW_SHOW);
        return 0;

    case WM_USER + 2:   // Hide
        ShowWindow(hwnd, SW_HIDE);
        return 0;

    case WM_DESTROY:
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
        ShowWindow(hwnd, SW_SHOW);
        return 0;

    case WM_USER + 2:   // Hide()
        ShowWindow(hwnd, SW_HIDE);
        return 0;

    case WM_CLOSE:
        ShowWindow(hwnd, SW_HIDE);
        return 0;

    case WM_DESTROY:
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

    // Explicitly mark the controller as visible — this is separate from
    // the window being shown and must be set for rendering to occur.
    m_controller->put_IsVisible(TRUE);

    // Set a solid white background so the webview paints immediately
    // rather than leaving the default transparent/blank state.
    COREWEBVIEW2_COLOR bg{ 255, 255, 255, 255 };
    Microsoft::WRL::ComPtr<ICoreWebView2Controller2> ctrl2;
    if (SUCCEEDED(m_controller.As(&ctrl2)))
        ctrl2->put_DefaultBackgroundColor(bg);

    HRESULT navHr = m_webView->Navigate(L"https://www.reddit.com");
    OvLog("[Overlay] Navigate hr=0x%08X\n", navHr);

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
}