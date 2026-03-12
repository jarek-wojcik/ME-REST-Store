#include "OverlayHost.h"

// ---------------------------------------------------------------------------
// Public API
// ---------------------------------------------------------------------------

bool OverlayHost::Initialize(HMODULE hModule)
{
    // ---- 1. Compute overlay geometry ----
    const int screenW = GetSystemMetrics(SM_CXSCREEN);
    const int screenH = GetSystemMetrics(SM_CYSCREEN);

    const int winW = screenW / 5;          // 20% of screen width
    const int winH = screenH;              // 100% of screen height
    const int winX = screenW - winW;       // right-aligned (80% from left)
    const int winY = 0;

    // ---- 2. Register window class (once per process) ----
    WNDCLASSEXW wc{};
    wc.cbSize        = sizeof(wc);
    wc.style         = CS_HREDRAW | CS_VREDRAW;
    wc.lpfnWndProc   = OverlayHost::WndProc;
    wc.hInstance     = hModule;
    wc.hCursor       = LoadCursor(nullptr, IDC_ARROW);
    wc.hbrBackground = reinterpret_cast<HBRUSH>(COLOR_WINDOW + 1);
    wc.lpszClassName = k_ClassName;

    // RegisterClassExW returns 0 if the class is already registered;
    // that is acceptable (second Initialize call would reuse the class).
    RegisterClassExW(&wc);

    // ---- 3. Create the overlay window ----
    // WS_POPUP gives us a borderless top-level window.
    m_hwnd = CreateWindowExW(
        WS_EX_TOPMOST | WS_EX_TOOLWINDOW,   // always on top, no taskbar button
        k_ClassName,
        L"SFS Overlay",
        WS_POPUP | WS_VISIBLE,
        winX, winY, winW, winH,
        nullptr,            // no parent
        nullptr,            // no menu
        hModule,
        this                // pass 'this' so WndProc can retrieve it
    );

    if (!m_hwnd)
        return false;

    // ---- 4. Start async WebView2 initialisation ----
    HRESULT hr = CreateCoreWebView2EnvironmentWithOptions(
        nullptr,  // use default browser installation
        nullptr,  // use default user-data folder
        nullptr,  // no extra options
        Microsoft::WRL::Callback<ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler>(
            [this](HRESULT result, ICoreWebView2Environment* env) -> HRESULT
            {
                OnEnvironmentCreated(result, env);
                return S_OK;
            }
        ).Get()
    );

    if (FAILED(hr))
        return false;

    m_initialized = true;
    return true;
}

void OverlayHost::Show()
{
    if (m_hwnd)
        ShowWindow(m_hwnd, SW_SHOW);
}

void OverlayHost::Hide()
{
    if (m_hwnd)
        ShowWindow(m_hwnd, SW_HIDE);
}

void OverlayHost::Shutdown()
{
    // Release WebView2 resources first
    if (m_controller)
    {
        m_controller->Close();
        m_controller.Reset();
    }
    m_webView.Reset();
    m_env.Reset();

    if (m_hwnd)
    {
        DestroyWindow(m_hwnd);
        m_hwnd = nullptr;
    }

    m_initialized = false;
}

// ---------------------------------------------------------------------------
// Window procedure
// ---------------------------------------------------------------------------

// static
LRESULT CALLBACK OverlayHost::WndProc(HWND hwnd, UINT msg, WPARAM wp, LPARAM lp)
{
    OverlayHost* self = nullptr;

    if (msg == WM_NCCREATE)
    {
        // Stash the 'this' pointer that was passed to CreateWindowExW
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

    case WM_DESTROY:
        // Window was destroyed externally; clean up COM pointers
        if (m_controller) { m_controller->Close(); m_controller.Reset(); }
        m_webView.Reset();
        m_env.Reset();
        m_hwnd        = nullptr;
        m_initialized = false;
        return 0;

    case WM_CLOSE:
        // Just hide on close rather than destroying
        Hide();
        return 0;
    }

    return DefWindowProcW(hwnd, msg, wp, lp);
}

// ---------------------------------------------------------------------------
// WebView2 async callbacks
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
    if (FAILED(result) || !controller || !m_hwnd)
        return;

    m_controller = controller;

    // Get the underlying ICoreWebView2 interface
    controller->get_CoreWebView2(m_webView.GetAddressOf());

    if (!m_webView)
        return;

    // Size the WebView to fill the window
    ResizeWebView();

    // Navigate to the proof-of-concept URL
    m_webView->Navigate(L"https://www.google.com");
}

void OverlayHost::ResizeWebView()
{
    if (!m_controller || !m_hwnd)
        return;

    RECT rc{};
    GetClientRect(m_hwnd, &rc);
    m_controller->put_Bounds(rc);
}