#include "OverlayHost.h"
#include <cstdio>
#include "sciter-x.h"

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

    // Build the full path to sciter.dll relative to the ASI itself.
    // LoadLibrary with a bare name searches the ME3 exe directory, not the
    // ASI directory — we need the explicit path so sciter.dll can live
    // alongside the ASI rather than next to MassEffect3.exe.
    // Pre-loading it here also ensures _SAPI()'s own LoadLibrary("sciter.dll")
    // call finds the already-loaded module instead of searching again.
    wchar_t sciterPath[MAX_PATH]{};
    GetModuleFileNameW(hModule, sciterPath, MAX_PATH);
    wchar_t* sl = wcsrchr(sciterPath, L'\\');
    if (sl) wcscpy_s(sl + 1, MAX_PATH - (sl - sciterPath) - 1, L"sciter.dll");

    m_hSciter = LoadLibraryW(sciterPath);
    if (!m_hSciter)
    {
        OvLog("[Overlay] sciter.dll not found next to ASI (looked for: %ls).\n", sciterPath);
        return false;
    }

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
    OvLog("[Overlay] Show() called. m_hwnd=%p\n", static_cast<void*>(m_hwnd));

    m_toggleVisible = true;
    m_panelVisible  = true;

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
    // overlay panel is hidden ï¿½ same position as after hiding the panel.
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

    if (m_hSciter)
    {
        FreeLibrary(m_hSciter);
        m_hSciter = nullptr;
    }

    m_initialized = false;
}

// ---------------------------------------------------------------------------
// Overlay thread ï¿½ owns the window and runs the message loop
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
    // We do NOT parent to gameWnd ï¿½ parenting a popup to a D3D fullscreen
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
        return;
    }

    // Create the toggle tab just to the left of the main overlay.
    // Use the overlay's own position/height so the tab always matches it exactly.
    CreateToggleWindow(winX, winY, winH);
    OvLog("[Overlay] Toggle hwnd=%p\n", static_cast<void*>(m_toggleHwnd));

    // Start the game-window monitor timer on the toggle window so we can
    // reposition / show / hide the overlay pair as the game minimizes and restores.
    SetTimer(m_toggleHwnd, 1 /*id*/, 250 /*ms*/, nullptr);

    // ---- 4. Load the Spectre Portal into the Sciter view ----
    // SciterProcND (called from WndProc) already associated Sciter with this
    // HWND during WM_CREATE. SciterLoadFile starts loading immediately;
    // rendering happens on the first WM_PAINT once the window is shown.
    SBOOL loaded = SciterLoadFile(m_hwnd, L"http://localhost:6060/spectreportal/");
    OvLog("[Overlay] SciterLoadFile returned %d\n", loaded);

    // ---- 5. Message loop ----
    OvLog("[Overlay] Entering message loop.\n");
    MSG msg{};
    while (GetMessageW(&msg, nullptr, 0, 0))
    {
        TranslateMessage(&msg);
        DispatchMessageW(&msg);
    }
    OvLog("[Overlay] Message loop exited.\n");
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
            // Game is minimized â€” hide our windows so they don't float over the desktop.
            if (IsWindowVisible(hwnd))   ShowWindow(hwnd,   SW_HIDE);
            if (IsWindowVisible(m_hwnd)) ShowWindow(m_hwnd, SW_HIDE);
        }
        else
        {
            // Game is visible â€” reposition and (re)show the overlay pair.
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

        // Rotate 90ï¿½ CCW around the centre of the tab:
        //   1. Translate so tab-centre is at origin
        //   2. Rotate -90ï¿½ (CCW): x'=-y, y'=x
        //   3. Translate back
        // The text rect in rotated space is centred at origin,
        // so in pre-rotation space we centre it at (0,0).
        // Pre-rotation text rect: width=sz.cx, height=sz.cy
        // Centred draw origin (top-left of text): (-sz.cx/2, -sz.cy/2)

        // cos(-90ï¿½)=0  sin(-90ï¿½)=-1
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
        OvLog("[Overlay] Toggle clicked ï¿½ overlay was %s.\n", nowVisible ? "visible" : "hidden");

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
    // Handle WM_DESTROY first so PostQuitMessage is always guaranteed to
    // fire even if Sciter consumes the message internally.
    if (msg == WM_DESTROY)
    {
        m_hwnd = nullptr;
        PostQuitMessage(0);
        return 0;
    }

    // Route all messages through Sciter. This covers WM_CREATE (binding),
    // WM_SIZE (reflow), WM_PAINT (rendering), WM_ERASEBKGND, and all
    // mouse/keyboard input, replacing the old WebView2 controller layer.
    SBOOL handled = FALSE;
    LRESULT lr = SciterProcND(hwnd, msg, wp, lp, &handled);
    if (handled)
        return lr;

    switch (msg)
    {
    case WM_USER + 1:   // Show()
        m_panelVisible = true;
        ShowWindow(hwnd, SW_SHOW);
        return 0;

    case WM_USER + 2:   // Hide()
        m_panelVisible = false;
        ShowWindow(hwnd, SW_HIDE);
        return 0;

    case WM_CLOSE:
        ShowWindow(hwnd, SW_HIDE);
        return 0;
    }

    return DefWindowProcW(hwnd, msg, wp, lp);
}

