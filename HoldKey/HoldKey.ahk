#Requires AutoHotkey v2.0

global keys := [
    ; Basic keys
    "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U",
    "V", "W", "X", "Y", "Z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
    ; General keys
    "CapsLock", ;"Space",
    "Tab", "Enter", ;"Escape",
    "Backspace",
    ; Cursor control keys
    "ScrollLock", "Delete", "Insert", "Home", "End", "PgUp", "PgDn", "Up", "Down", "Left", "Right",
    ; Numpad keys
    "Numpad0", "Numpad0", "Numpad1", "Numpad2", "Numpad3", "Numpad4", "Numpad5", "Numpad6", "Numpad7", "Numpad8",
    "Numpad9", "NumpadDot", "NumpadIns", "NumpadEnd", "NumpadDown", "NumpadPgDn", "NumpadLeft", "NumpadClear",
    "NumpadRight", "NumpadHome", "NumpadUp", "NumpadPgUp", "NumpadDel", "NumLock", "NumpadDiv", "NumpadMult",
    "NumpadAdd", "NumpadSub", "NumpadEnter",
    ; Function keys
    "F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", "F10", "F11", "F12", "F13", "F14", "F15", "F16", "F17", "F18",
    "F19", "F20", "F21", "F22", "F23", "F24",
    ; Modifier keys
    "LWin", "RWin", "Control", "Alt", "Shift", "LControl", "RControl", "LShift", "RShift", "LAlt", "RAlt",
    ; Multimedia keys
    "Browser_Back", "Browser_Forward", "Browser_Refresh", "Browser_Stop", "Browser_Search", "Browser_Favorites",
    "Browser_Home", "Volume_Mute", "Volume_Down", "Volume_Up", "Media_Next", "Media_Prev", "Media_Stop",
    "Media_Play_Pause", "Launch_Mail", "Launch_Media", "Launch_App1", "Launch_App2",
    ; Other keys
    "AppsKey", "PrintScreen", "CtrlBreak", "Pause", "Help", "Sleep",
    ; Mouse buttons
    "LButton", "RButton", "MButton", ;"XButton1", "XButton2",
]
global enabled := []
enabled.Length := keys.Length
global classes := []
classes.length := keys.length
global config_file := "config.ini"

; 0 is off, 1 is enable mode, 2 is disable mode
global edit_mode := 0

IsEnableModeOn(*) {
    global edit_mode
    return edit_mode == 1
}

IsDisableModeOn(*) {
    global edit_mode
    return edit_mode == 2
}

;InstallKeybdHook()

class HoldableKey {
    index := 0
    __New(index) {
        ;this.key := keys[index]
        this.index := index
    }
    Key => keys[this.index]
    Enabled => enabled[this.index]
    HotkeyAction() {
        Action(*) {
            ToolTip("hello" this.Key)
            Send("{" this.key " down}")
        }
        return Action
    }
    SetEnabled() {
        EnableAction(*) {
            enabled[this.index] := 1
            ToolTip("Enabled " this.key)
        }
        return EnableAction
    }
    SetDisabled() {
        DisableAction(*) {
            enabled[this.index] := 0
            ToolTip("Disabled " this.key)
        }
        return DisableAction
    }
}

ReadConfig() {
    loop keys.Length {
        enabled[A_Index] := IniRead(config_file, "enabled", keys[A_Index], 0) == 1
    }
}

WriteConfig() {
    IniDelete(config_file, "enabled")
    local pairs := ""
    loop keys.Length {
        if enabled[A_Index] {
            pairs := pairs keys[A_Index] "=1`n"
        }
        IniWrite(pairs, config_file, "enabled")
    }
}

WriteFullConfig(*) {
    IniDelete(config_file, "enabled")
    local pairs := ""
    loop keys.Length {
        pairs := pairs keys[A_Index] "=" enabled[A_Index] "`n"
        IniWrite(pairs, config_file, "enabled")
    }
	TrayTip("Done")
	Sleep(2000)
	TrayTip()
}

CreateHotkeys() {
    loop keys.Length {
        local class := HoldableKey(A_Index)
        classes[A_Index] := class
        HotIf(IsEnableModeOn)
        Hotkey(keys[A_Index], class.SetEnabled())
        HotIf(IsDisableModeOn)
        Hotkey(keys[A_Index], class.SetDisabled())
        HotIf()
        Hotkey("XButton1 & " keys[A_Index], classes[A_Index].HotkeyAction(), "Off")
    }
    ApplyEnabledState()
}

ApplyEnabledState() {
    HotIf()
    loop keys.Length {
        local on_off
        if enabled[A_Index] {
            on_off := "On"
        } else {
            on_off := "Off"
        }
        Hotkey("XButton1 & " keys[A_Index], on_off)
    }
}

StartEnableMode(item_name, item_pos, my_menu) {
    global edit_mode
    edit_mode := 1
    ToolTip("Press keys to enable")
}
StartDisableMode(item_name, item_pos, my_menu) {
    global edit_mode
    edit_mode := 2
    ToolTip("Press keys to disable")
}

A_TrayMenu.Add()
A_TrayMenu.Add("Start enabling", StartEnableMode)
A_TrayMenu.Add("Start disabling", StartDisableMode)
A_TrayMenu.Add("Write all supported keys to config file", WriteFullConfig)

ReadConfig()
CreateHotkeys()

#HotIf edit_mode > 0
Space:: {
    global edit_mode
    edit_mode := 0
    WriteConfig()
    ApplyEnabledState()
    ToolTip("Saved")
    Sleep(2000)
    ToolTip()
}

#HotIf
Escape:: {
    ExitApp()
}

*XButton2:: {
    loop keys.Length {
        if enabled[A_Index] && GetKeyState(keys[A_Index]) && !GetKeyState(keys[A_Index], "P") {
            Send("{" keys[A_Index] "} up")
        }
    }
}
