; Alt + LMB will put the colour of the pixel under the cursor into clipboard, and shift + LMB will
; append it to clipboard instead (with a line break if it had contents already). The colour format
; is like DA3287.

#Requires AutoHotkey v2.0

!LButton:: {
    A_Clipboard := GetColour()
}

+LButton:: {
    if A_Clipboard != "" {
        A_Clipboard := A_Clipboard . "`r`n"
    }
    A_Clipboard := A_Clipboard . GetColour()
}

GetColour() {
    MouseGetPos(&x, &y)
    colour := PixelGetColor(x, y)
    return SubStr(colour, 3)
}
