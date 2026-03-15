#pragma once

#include <windows.h>
#include <shellapi.h>
#include <commctrl.h>
#include <wrl.h>
#include <string>
#include <WebView2.h>

class OverlayHost
{
public:
    OverlayHost() = default;
    ~OverlayHost() = default;

    bool Initialize(HMODULE hModule);

    void Show();           // shows both overlay panel and toggle tab
    void ShowToggleOnly(); // shows only the toggle tab; panel stays hidden
    void Hide();
    void Shutdown();

    bool IsInitialized() const { return m_initialized; }

private:
    static DWORD WINAPI OverlayThreadProc(LPVOID param);
    void OverlayThread();

    // Main overlay window
    static LRESULT CALLBACK WndProc(HWND hwnd, UINT msg, WPARAM wp, LPARAM lp);
    LRESULT HandleMessage(HWND hwnd, UINT msg, WPARAM wp, LPARAM lp);

    // Toggle tab window (sits just to the left of the overlay)
    static LRESULT CALLBACK ToggleWndProc(HWND hwnd, UINT msg, WPARAM wp, LPARAM lp);
    LRESULT HandleToggleMessage(HWND hwnd, UINT msg, WPARAM wp, LPARAM lp);
    void CreateToggleWindow(int overlayX, int overlayY, int overlayH);

    void OnEnvironmentCreated(HRESULT result, ICoreWebView2Environment* env);
    void OnControllerCreated(HRESULT result, ICoreWebView2Controller* controller);
    void ResizeWebView();

    // Subclass all Chromium child HWNDs under m_hwnd so that WM_MOUSEACTIVATE
    // returns MA_NOACTIVATE, preventing them from stealing focus from the game.
    void SubclassChromiumChildren();
    static BOOL CALLBACK   EnumChromiumChildren(HWND hwnd, LPARAM lp);
    static LRESULT CALLBACK ChromiumChildSubclassProc(
        HWND hwnd, UINT msg, WPARAM wp, LPARAM lp, UINT_PTR uid, DWORD_PTR ref);

    // Low-level keyboard hook — intercepts keystrokes on the overlay thread
    // and forwards them to the Chromium render HWND when the panel is visible.
    // WH_KEYBOARD_LL always fires on the installing thread, so no cross-thread
    // focus manipulation (and no game minimize) is needed.
    static LRESULT CALLBACK LowLevelKeyProc(int nCode, WPARAM wParam, LPARAM lParam);
    static OverlayHost* s_instance;  // for access inside the static hook proc

    // ---- Data members ----
    HWND        m_hwnd          = nullptr;
    HWND        m_toggleHwnd    = nullptr;  // the small close-tab
    HANDLE      m_thread        = nullptr;
    DWORD       m_threadId      = 0;
    HHOOK       m_llKeyHook     = nullptr;  // WH_KEYBOARD_LL hook handle
    bool        m_initialized   = false;
    bool        m_showPending   = false;
    HMODULE     m_hModule       = nullptr;

    // Desired visibility state — used by the monitor timer to restore windows
    // after the game un-minimizes.
    bool        m_toggleVisible = false;  // toggle tab should be on-screen
    bool        m_panelVisible  = false;  // main overlay panel is open

    Microsoft::WRL::ComPtr<ICoreWebView2Environment>  m_env;
    Microsoft::WRL::ComPtr<ICoreWebView2Controller>   m_controller;
    Microsoft::WRL::ComPtr<ICoreWebView2>             m_webView;

    static constexpr wchar_t k_ClassName[]             = L"SFSOverlayHostWnd";
    static constexpr wchar_t k_ToggleClassName[]       = L"SFSOverlayToggleWnd";
    static constexpr int     k_ToggleW                 = 60;  // width of the tab in pixels
    static constexpr int     k_OverlayWidthPercent     = 100;  // percentage of game window width
};
