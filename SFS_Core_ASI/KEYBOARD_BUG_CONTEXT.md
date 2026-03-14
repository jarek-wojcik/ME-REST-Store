# Context for fixing the WebView2 overlay keyboard input bug

## What this project is
A Mass Effect 3 ASI plugin (32-bit injected DLL renamed .asi). It hooks UE3's ProcessEvent via Microsoft Detours. On the first `IsPrivateMatch` ProcessEvent call it shows an overlay UI. The overlay is implemented in `OverlayHost.h` / `OverlayHost.cpp`. The UI itself is served by a Go HTTP sidecar on `http://localhost:6060/spectreportal/` and rendered inside a WebView2 view.

## Current overlay architecture
- `OverlayHost::Initialize()` spawns a dedicated thread (`OverlayThread`).
- `OverlayThread` waits for the ME3 window, creates a `WS_EX_TOPMOST | WS_EX_TOOLWINDOW | WS_EX_NOACTIVATE | WS_POPUP` window (`m_hwnd`), then asynchronously creates a WebView2 environment and controller parented to `m_hwnd`. On success it navigates to `http://localhost:6060/spectreportal/`.
- A second small window (`m_toggleHwnd`) is a painted toggle tab sitting at the right edge of the game window. Clicking it shows/hides `m_hwnd`.
- Both windows use `WS_EX_NOACTIVATE` to prevent stealing focus from ME3's D3D window.
- `SubclassChromiumChildren()` enumerates all child HWNDs under `m_hwnd` and installs a subclass proc (`ChromiumChildSubclassProc`) that returns `MA_NOACTIVATE` on every `WM_MOUSEACTIVATE`. This was added to prevent Chromium's internal HWNDs from activating the window chain and causing ME3 (exclusive fullscreen) to minimize.

## The keyboard bug
The `WS_EX_NOACTIVATE` flag and the `MA_NOACTIVATE` subclass fix the minimize/focus-steal problem, but they also prevent keyboard input from reaching the WebView2 view. WebView2 uses Windows keyboard focus (the active window receiving `WM_KEYDOWN` etc.) to route input. Because the overlay window is never activated (by design), keyboard events typed by the user while the overlay panel is open are still routed to ME3, not the WebView2 content.

The comment in `ChromiumChildSubclassProc` that says "The click itself is NOT consumed — Chromium still receives it and routes it to the correct input element, so keyboard focus inside WebView2 works fine" is INCORRECT. Mouse clicks visually work (HTMX navigation, button presses) but text input fields do not receive keyboard events.

## The correct fix
WebView2 exposes `ICoreWebView2Controller::MoveFocus(COREWEBVIEW2_MOVE_FOCUS_REASON reason)`. When called with `COREWEBVIEW2_MOVE_FOCUS_REASON_PROGRAMMATIC` this gives WebView2 internal keyboard focus WITHOUT triggering a Windows `WM_ACTIVATE` on the host HWND. It bypasses the normal activation mechanism entirely.

### Changes required

**1. In `HandleToggleMessage` → `WM_LBUTTONUP` handler (the toggle click that shows the panel):**
After the `ShowWindow(m_hwnd, SW_SHOW)` call, add:
```cpp
if (m_controller)
    m_controller->MoveFocus(COREWEBVIEW2_MOVE_FOCUS_REASON_PROGRAMMATIC);
```

**2. In `HandleMessage` → `WM_USER + 1` case (the Show() path):**
After `ShowWindow(hwnd, SW_SHOW)`, add:
```cpp
if (m_controller)
    m_controller->MoveFocus(COREWEBVIEW2_MOVE_FOCUS_REASON_PROGRAMMATIC);
```

**3. When the panel is hidden (toggle click hiding, WM_USER+2), optionally restore ME3 focus:**
After `ShowWindow(m_hwnd, SW_HIDE)`:
```cpp
HWND gameWnd = FindWindowW(nullptr, L"Mass Effect 3");
if (gameWnd) SetForegroundWindow(gameWnd);
```
This is optional but ensures ME3 cleanly recovers keyboard input after the overlay is dismissed.

**4. In `OnControllerCreated`, after the existing `SubclassChromiumChildren()` call:**
If `m_showPending` was true and the panel is about to be shown, MoveFocus should also be called there:
```cpp
if (m_showPending)
{
    m_showPending = false;
    PostMessage(m_hwnd, WM_USER + 1, 0, 0);
    if (m_toggleHwnd) PostMessage(m_toggleHwnd, WM_USER + 1, 0, 0);
    // WM_USER+1 handler will call MoveFocus after ShowWindow
}
```
No extra change needed here if WM_USER+1 already calls MoveFocus (from change #2 above).

## What NOT to change
- Do NOT remove `WS_EX_NOACTIVATE` from either window. Removing it causes ME3 in exclusive fullscreen to minimize when the overlay is clicked.
- Do NOT remove `ChromiumChildSubclassProc` or the `MA_NOACTIVATE` return. Without it, Chromium's child HWNDs steal activation and minimize ME3.
- Do NOT call `SetForegroundWindow` on the overlay window. That activates it fully and minimizes ME3.
- The `MoveFocus(PROGRAMMATIC)` call must use `m_controller` (the `ICoreWebView2Controller` pointer), not `m_webView`. The controller owns focus; the webview is the document.

## Relevant data members (ICoreWebView2Controller is the key interface)
- `m_controller` — `Microsoft::WRL::ComPtr<ICoreWebView2Controller>` — call `MoveFocus` on this
- `m_webView`    — `Microsoft::WRL::ComPtr<ICoreWebView2>` — document/navigation, not focus
- `m_hwnd`       — the overlay panel HWND (WebView2 host window)
- `m_toggleHwnd` — the painted toggle tab HWND

## Files to edit
- `SFS_Core_ASI/OverlayHost.cpp` — all changes are here
- `SFS_Core_ASI/OverlayHost.h`   — no changes needed

## Build notes
- Project: `SFS_Core_ASI/SFSCoreASI.vcxproj`, Win32 (32-bit), MSVC v143
- WebView2 NuGet package: `packages/Microsoft.Web.WebView2.1.0.3800.47`
- WebView2Loader.dll must live next to MassEffect3.exe (the host process exe directory), NOT next to the ASI
