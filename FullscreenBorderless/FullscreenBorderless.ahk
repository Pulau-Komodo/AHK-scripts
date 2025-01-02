; Fullscreen borderless
;
; AutoHotkey Version: 2.0.18
; Language:       English
; Author:         Komodo
;
; Script Function:
;	When this script is started, a tooltip will communicate whether the window the cursor is
;	currently over is borderless or not. If it is borderless, clicking will turn the border on. If
;	it has a border, clicking will remove the border, move the window to the top left and make it
;	1920x1080. Esc or RMB will close the script without doing anything.
;

#Requires AutoHotkey v2.0

CoordMode("Mouse", "Screen")
CoordMode("ToolTip", "Screen")

loop {
    MouseGetPos(, , &window, &control)
    window_status := WinGetStyle("ahk_id " window)
    if window_status & 0xC00000 {
        ToolTip("border")
    } else {
        ToolTip("borderless")
    }
    Sleep(50)
}

MoveAndResize(x, y, window) {
    found_screen := false
    loop MonitorGetCount() {
        MonitorGet(A_Index, &left, &top, &right, &bottom)
        if x >= left && x < right && y >= top && y < bottom {
            found_screen := true
            break
        }
    }
    if !found_screen {
        ExitWithMessage("Failed to find the correct screen. Was the cursor outside of any screen somehow?", 3000, 1)
    }
    WinMove(left, top, right - left, bottom - top, window)
}

ExitWithMessage(message, duration := 1000, code := 0) {
    ToolTip(message)
    Suspend(1)
    Sleep(duration)
    ExitApp(code)
}

LButton:: {
    MouseGetPos(&x, &y, &window)
    window := "ahk_id " window
    window_status := WinGetStyle(window)
    if window_status & 0xC00000 {
        WinSetStyle(-0xC00000, window)
        MoveAndResize(x, y, window)
        ExitWithMessage("Now borderless")
    } else {
        WinSetStyle(+0xC00000, window)
        ExitWithMessage("Now with border")
    }
}

Esc::
RButton:: {
    ExitWithMessage("closing")
}
