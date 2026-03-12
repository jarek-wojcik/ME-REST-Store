#include "OverlayHost.h"

// ---------------------------------------------------------------------------
// Runtime check
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

// ---------------------------------------------------------------------------
// Public API
// ---------------------------------------------------------------------------

bool OverlayHost::Initialize(HMODULE hModule)
{
    // Guard: only initialise once
    if (m_initialized)
        return true;

    if (!IsWebView2RuntimeInstalled())
        return false;

    m_hModule     = hModule;
    m_initialized = true;

    // Spin up a dedicated thread that owns the window and message loop.
    // WebView2 async callbacks require a pumped message loop on the same
    // thread that called CreateCoreWebView2EnvironmentWithOptions.
    m_thread = CreateThread(
        nullptr, 0,
        OverlayHost::OverlayThreadProc,
        this,
        0,
        &m_threadId
    );

    return m_thread != nullptr;
}

void OverlayHost::Show()
{
    if (m_hwnd)
        PostMessage(m_hwnd, WM_USER + 1, 0, 0); // signal the overlay thread
}

void OverlayHost::Hide()
{
    if (m_hwnd)
        PostMessage(m_hwnd, WM_USER + 2, 0, 0);
}

void OverlayHost::Shutdown()
{
    if (m_hwnd)
        PostMessage(m_hwnd, WM_DESTROY, 0, 0);

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
    // ---- 1. Compute geometry ----
    const int screenW = GetSystemMetrics(SM_CXSCREEN);
    const int screenH = GetSystemMetrics(SM_CYSCREEN);
    const int winW    = screenW / 5;
    const int winH    = screenH;
    const int winX    = screenW - winW;
    const int winY    = 0;

    // ---- 2. Register window class ----
    WNDCLASSEXW wc{};
    wc.cbSize        = sizeof(wc);
    wc.style         = CS_HREDRAW | CS_VREDRAW;
    wc.lpfnWndProc   = OverlayHost::WndProc;
    wc.hInstance     = m_hModule;
    wc.hCursor       = LoadCursor(nullptr, IDC_ARROW);
    wc.hbrBackground = reinterpret_cast<HBRUSH>(COLOR_WINDOW + 1);
    wc.lpszClassName = k_ClassName;
    RegisterClassExW(&wc);

    // ---- 3. Create window ----
    m_hwnd = CreateWindowExW(
        WS_EX_TOPMOST | WS_EX_TOOLWINDOW,
        k_ClassName,
        L"SFS Overlay",
        WS_POPUP,           // start hidden; Show() will reveal it
        winX, winY, winW, winH,
        nullptr, nullptr,
        m_hModule,
        this
    );

    if (!m_hwnd)
        return;

    // ---- 4. Start WebView2 async init (callbacks fire on this thread) ----
    CreateCoreWebView2EnvironmentWithOptions(
        nullptr, nullptr, nullptr,
        Microsoft::WRL::Callback<ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler>(
            [this](HRESULT result, ICoreWebView2Environment* env) -> HRESULT
            {
                OnEnvironmentCreated(result, env);
                return S_OK;
            }
        ).Get()
    );

    // ---- 5. Message loop — keeps the thread alive and pumps WebView2 ----
    MSG msg{};
    while (GetMessageW(&msg, nullptr, 0, 0))
    {
        TranslateMessage(&msg);
        DispatchMessageW(&msg);
    }
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
    if (FAILED(result) || !controller || !m_hwnd)
        return;

    m_controller = controller;
    controller->get_CoreWebView2(m_webView.GetAddressOf());

    if (!m_webView)
        return;

    ResizeWebView();
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