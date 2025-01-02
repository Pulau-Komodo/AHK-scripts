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

LButton:: {
    MouseGetPos(, , &window, &control)
    window_status := WinGetStyle("ahk_id " window)
    if window_status & 0xC00000 {
        WinSetStyle(-0xC00000, "ahk_id " window)
        WinMove(0, 0, 1920, 1080, "ahk_id " window)
        ToolTip("Now borderless")
    } else {
        WinSetStyle(+0xC00000, "ahk_id " window)
        ToolTip("Now with border")
    }
    Suspend(1)
    Sleep(1000)
    ExitApp()
}

Esc::
RButton:: {
    ToolTip("closing")
    Suspend(1)
    Sleep(1000)
    ExitApp()
}
