; Fullscreen borderless
;
; AutoHotkey Version: 2.0.18
; Language:       English
; Author:         Komodo
;
; Script Function:
;	When this script is started, a tooltip will communicate whether the window the cursor is
;	currently over is borderless or not. If it is borderless, left clicking will turn the border on.
;	If it has a border, left clicking will remove the border, as well as resize and move the window
;	to fit the screen the cursor was on at the time. Holding shift when removing the border will
;	move and resize the window to fill the work area instead. This is the screen minus toolbars. Esc
;	or right click will close the script without doing anything.
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

MoveAndResize(x, y, window, avoid_taskbar) {
    found_screen := false
    screen := 0
    loop MonitorGetCount() {
        MonitorGet(A_Index, &left, &top, &right, &bottom)
        if x >= left && x < right && y >= top && y < bottom {
            found_screen := true
            screen := A_Index
            break
        }
    }
    if !found_screen {
        ExitWithMessage("Failed to find the correct screen. Was the cursor outside of any screen somehow?", 3000, 1)
    }
    if avoid_taskbar {
        MonitorGetWorkArea(A_Index, &left, &top, &right, &bottom)
    }
    WinMove(left, top, right - left, bottom - top, window)
}

ExitWithMessage(message, duration := 1000, code := 0) {
    ToolTip(message)
    Suspend(1)
    Sleep(duration)
    ExitApp(code)
}

ToggleWindow(avoid_taskbar) {
    MouseGetPos(&x, &y, &window)
    window := "ahk_id " window
    window_status := WinGetStyle(window)
    if window_status & 0xC00000 { ; Has a border
        WinSetStyle("-0xC00000", window)
        MoveAndResize(x, y, window, avoid_taskbar)
        ExitWithMessage("Now borderless")
    } else {
        WinSetStyle("+0xC00000", window)
        if window_status & 0x10000 { ; Has a maximize button (or would, if it had a title bar)
            WinMaximize(window)
            ExitWithMessage("Now with border and maximized")
        } else {
            MoveAndResize(x, y, window, true)
            ExitWithMessage("Now with border")
        }
    }
}

LButton:: {
    ToggleWindow(false)
}

+LButton:: {
    ToggleWindow(true)
}

Esc::
RButton:: {
    ExitWithMessage("closing")
}
