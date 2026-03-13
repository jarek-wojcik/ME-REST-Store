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
    // Entry point for the dedicated overlay thread
    static DWORD WINAPI OverlayThreadProc(LPVOID param);
    void OverlayThread();

    static LRESULT CALLBACK WndProc(HWND hwnd, UINT msg, WPARAM wp, LPARAM lp);
    LRESULT HandleMessage(HWND hwnd, UINT msg, WPARAM wp, LPARAM lp);

    void OnEnvironmentCreated(HRESULT result, ICoreWebView2Environment* env);
    void OnControllerCreated(HRESULT result, ICoreWebView2Controller* controller);
    void ResizeWebView();

    // ---- Data members ----
    HWND        m_hwnd          = nullptr;
    HANDLE      m_thread        = nullptr;
    DWORD       m_threadId      = 0;
    bool        m_initialized   = false;
    bool        m_showPending   = false;   // Show() was called before WebView2 was ready
    HMODULE     m_hModule       = nullptr;

    Microsoft::WRL::ComPtr<ICoreWebView2Environment>  m_env;
    Microsoft::WRL::ComPtr<ICoreWebView2Controller>   m_controller;
    Microsoft::WRL::ComPtr<ICoreWebView2>             m_webView;

    static constexpr wchar_t k_ClassName[] = L"SFSOverlayHostWnd";
};