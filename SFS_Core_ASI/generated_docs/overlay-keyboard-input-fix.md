# WebView2 Overlay Keyboard Input Fix

## Problem

The Spectre Portal overlay rendered via WebView2 inside Mass Effect 3 (a UE3 exclusive-fullscreen D3D game) could not receive keyboard input. Text input fields were completely unresponsive: clicking into them showed no cursor, and every keystroke was consumed by the game.

## Root Cause Analysis

### Why the obvious fixes don't work

WebView2 uses Windows **keyboard focus** — the window designated to receive `WM_KEYDOWN` / `WM_CHAR` messages — to route input into the web page. The overlay windows are created with `WS_EX_NOACTIVATE` to prevent them from stealing focus from ME3's D3D window (which would cause the fullscreen game to minimize to the taskbar). This flag, by design, means Windows never gives our windows keyboard focus, so WebView2 never receives any key events.

Approaches that were tried and failed:

| Approach | Why it failed |
|---|---|
| `ICoreWebView2Controller::MoveFocus(PROGRAMMATIC)` | Tells WebView2's compositor it has *content* focus, but `WM_KEYDOWN` messages are still dispatched by Windows to whatever window has real keyboard focus — ME3, not the overlay. No key messages ever arrived at the overlay thread queue. |
| `SetFocus(m_hwnd)` from the overlay thread | `SetFocus` across different threads is silently ignored for keyboard routing unless `AttachThreadInput` has been called first to synchronise the two threads' input queues. Without it the call is a no-op. |
| `AttachThreadInput` + `SetFocus` | `AttachThreadInput` merged the input queues (allowing `SetFocus` to work), but calling `SetFocus` on the overlay window — even without `SetForegroundWindow` — caused ME3's exclusive-fullscreen D3D window to minimize and become unrestorable. |

### The actual constraint

In a Win32 exclusive-fullscreen D3D application, **any** change to the active/focused window state (even an in-process `SetFocus`) can cause the D3D runtime to receive a `WM_ACTIVATE`/`WM_KILLFOCUS` pair that tears down the swap chain and minimizes the window. We cannot safely direct Windows keyboard focus to the overlay HWND.

---

## Solution: `WH_KEYBOARD_LL` Low-Level Keyboard Hook

This is the same technique used by Steam Overlay, Discord Overlay, and other in-game overlays.

`SetWindowsHookEx(WH_KEYBOARD_LL, ...)` installs a **global** keyboard hook that fires on the installing thread for every keystroke system-wide — **before** Windows routes the event to any window. This means:

- No window focus change is required.
- No `WM_ACTIVATE` is sent.
- ME3 never minimizes.
- The hook fires on the overlay thread, serviced naturally by its `GetMessage` loop.

When the overlay panel is visible, the hook intercepts keystrokes, forwards them directly to Chromium's render HWND inside the overlay, and **suppresses** them from ME3 by returning `1`.

---

## Files Changed

### `SFS_Core_ASI/OverlayHost.h`

1. Added `static OverlayHost* s_instance` — a static pointer used inside the static hook proc to access the live `OverlayHost` instance.
2. Added `HHOOK m_llKeyHook = nullptr` — stores the hook handle so it can be uninstalled on shutdown.
3. Added `static LRESULT CALLBACK LowLevelKeyProc(int nCode, WPARAM wParam, LPARAM lParam)` declaration.

### `SFS_Core_ASI/OverlayHost.cpp`

#### 1. Static instance definition (top of file)
```cpp
OverlayHost* OverlayHost::s_instance = nullptr;
```

#### 2. Hook installation in `OverlayThread()` (before the message loop)
```cpp
s_instance = this;
m_llKeyHook = SetWindowsHookEx(WH_KEYBOARD_LL, LowLevelKeyProc, m_hModule, 0);
```
The hook must be installed **before** `GetMessage` starts running, on the same thread that will run the message loop. `WH_KEYBOARD_LL` always fires on the installing thread.

#### 3. Hook removal in `HandleMessage` → `WM_DESTROY`
```cpp
if (m_llKeyHook) { UnhookWindowsHookEx(m_llKeyHook); m_llKeyHook = nullptr; }
s_instance = nullptr;
```

#### 4. `FindRenderWidget()` helper (file-scope static)
WebView2 creates a child HWND with class `Chrome_RenderWidgetHostHWND` inside the host window that is the actual Chromium input target. Keyboard messages must be dispatched there, not to the host HWND.

```cpp
static HWND FindRenderWidget(HWND host)
{
    HWND h = FindWindowExW(host, nullptr, L"Chrome_RenderWidgetHostHWND", nullptr);
    if (!h)
    {
        // Fallback: some WebView2 versions nest the widget further down.
        EnumChildWindows(host, [](HWND w, LPARAM lp) -> BOOL {
            wchar_t cls[64]{};
            GetClassNameW(w, cls, 64);
            if (wcscmp(cls, L"Chrome_RenderWidgetHostHWND") == 0) {
                *reinterpret_cast<HWND*>(lp) = w;
                return FALSE;
            }
            return TRUE;
        }, reinterpret_cast<LPARAM>(&h));
    }
    return h;
}
```

#### 5. `LowLevelKeyProc()` — the hook implementation

The hook proc does three things:

**A. Maintains its own modifier state.** `GetKeyboardState` and `GetAsyncKeyState` are both unreliable inside a suppressing LL hook — when we return `1` to swallow a keystroke, Windows may not update either state table before the next hook invocation fires. Instead, we track Shift, Ctrl, Alt, CapsLock, and NumLock ourselves with `static bool` variables updated on every key event (even when the panel is closed, so the state is correct the moment the panel opens).

**B. Splits keystrokes into two categories:**

| Category | Detection | Message sent |
|---|---|---|
| **Printable character** | `ToUnicodeEx` returns a glyph with code point ≥ 0x20, and Ctrl is not held | `WM_CHAR` with the correctly-cased Unicode character computed from our modifier state |
| **Non-printable / shortcut** | Arrows, Backspace, Enter, Escape, Tab, F-keys, or any key while Ctrl is held | `WM_KEYDOWN` so Chromium handles the virtual key directly |

Sending `WM_CHAR` directly for printable characters is necessary because Chromium does **not** call Windows' `TranslateMessage` in its message loop — it generates characters from `WM_KEYDOWN` using its own keyboard layout code. That code does not know about our modifier state, so forwarding `WM_KEYDOWN` for printable keys produced only lowercase output regardless of Shift/CapsLock, and sometimes doubled the character.

**C. Suppresses the keystroke from ME3** by returning `1`, so the game does not also react while the overlay panel is open. Key-up events are always forwarded (even when returning 1 to suppress) so Chromium can correctly release its internal modifier state.

---

## Invariants Preserved

- `WS_EX_NOACTIVATE` remains on both overlay windows — ME3 still never minimizes on click.
- `ChromiumChildSubclassProc` returning `MA_NOACTIVATE` on `WM_MOUSEACTIVATE` remains — Chromium's child HWNDs still cannot activate the window chain.
- `MoveFocus(COREWEBVIEW2_MOVE_FOCUS_REASON_PROGRAMMATIC)` is retained in the show paths — it notifies WebView2's compositor that its content has focus, which is required for correct cursor rendering and caret behaviour in text fields even though key routing now comes through the hook.
- The hook is only **suppressing** (returns `1`) when `m_panelVisible` is true — game keyboard input is unaffected when the overlay is closed.
