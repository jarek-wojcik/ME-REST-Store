#pragma once

#include <windows.h>
#include <shellapi.h>
#include <wrl.h>
#include <string>
#include <WebView2.h>

class OverlayHost
{
public:
    OverlayHost() = default;
    ~OverlayHost() = default;

    bool Initialize(HMODULE hModule);

    void Show();
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

    // ---- Data members ----
    HWND        m_hwnd          = nullptr;
    HWND        m_toggleHwnd    = nullptr;  // the small close-tab
    HANDLE      m_thread        = nullptr;
    DWORD       m_threadId      = 0;
    bool        m_initialized   = false;
    bool        m_showPending   = false;
    HMODULE     m_hModule       = nullptr;

    Microsoft::WRL::ComPtr<ICoreWebView2Environment>  m_env;
    Microsoft::WRL::ComPtr<ICoreWebView2Controller>   m_controller;
    Microsoft::WRL::ComPtr<ICoreWebView2>             m_webView;

    static constexpr wchar_t k_ClassName[]       = L"SFSOverlayHostWnd";
    static constexpr wchar_t k_ToggleClassName[] = L"SFSOverlayToggleWnd";
    static constexpr int     k_ToggleW           = 28;  // width of the tab in pixels
};
