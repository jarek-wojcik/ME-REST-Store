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

    // Registers the window class, creates the overlay window, and starts
    // async WebView2 initialization. Returns false if the window cannot
    // be created.
    bool Initialize(HMODULE hModule);

    void Show();
    void Hide();
    void Shutdown();

    bool IsInitialized() const { return m_initialized; }

private:
    // Window procedure (static trampoline -> instance method)
    static LRESULT CALLBACK WndProc(HWND hwnd, UINT msg, WPARAM wp, LPARAM lp);
    LRESULT HandleMessage(HWND hwnd, UINT msg, WPARAM wp, LPARAM lp);

    // Called once the WebView2 environment is ready
    void OnEnvironmentCreated(
        HRESULT result,
        ICoreWebView2Environment* env);

    // Called once the WebView2 controller is ready
    void OnControllerCreated(
        HRESULT result,
        ICoreWebView2Controller* controller);

    // Resize the WebView2 bounds to fill the client area
    void ResizeWebView();

    // ---- Data members ----
    HWND        m_hwnd        = nullptr;
    bool        m_initialized = false;

    Microsoft::WRL::ComPtr<ICoreWebView2Environment>  m_env;
    Microsoft::WRL::ComPtr<ICoreWebView2Controller>   m_controller;
    Microsoft::WRL::ComPtr<ICoreWebView2>             m_webView;

    static constexpr wchar_t k_ClassName[] = L"SFSOverlayHostWnd";
};