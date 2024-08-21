; Clickclickclick
;
; AutoHotkey Version: 2.0.18
; Language:       English
; Author:         Komodo
;
; Script Function:
;	This script clicks or right clicks very rapidly while the extra mouse button 2 or 1 is held,
;	respectively. Allows intervals and click delays to be changed, and individual modes to be
;	disabled.
;

#Requires AutoHotkey v2.0

InstallMouseHook()

SetMouseDelay(-1)
SendMode("Event")

; Default values
EnableLeft := true
EnableRight := true
DownTime := 5
EnablePlain := true
PlainInterval := 25
PlainDelay := Max(PlainInterval - DownTime, 0)
EnableCtrl := false
CtrlInterval := 50
CtrlDelay := Max(CtrlInterval - DownTime, 0)
EnableShift := false
ShiftInterval := 5
ShiftDelay := Max(ShiftInterval - DownTime, 0)

A_TrayMenu.Add()
A_TrayMenu.Add("Change time button spends down", ChangeDownTime)
A_TrayMenu.Add("Change plain interval", ChangeInterval)
A_TrayMenu.Add("Change Ctrl interval", ChangeInterval)
A_TrayMenu.Add("Change Shift interval", ChangeInterval)
A_TrayMenu.Add("Enable plain autoclicking", ToggleMode)
if EnablePlain {
	A_TrayMenu.Check("Enable plain autoclicking")
}
A_TrayMenu.Add("Enable Ctrl autoclicking", ToggleMode)
if EnableCtrl {
	A_TrayMenu.Check("Enable Ctrl autoclicking")
}
A_TrayMenu.Add("Enable Shift autoclicking", ToggleMode)
if EnableShift {
	A_TrayMenu.Check("Enable Shift autoclicking")
}
A_TrayMenu.Add("Enable left clicking", ToggleMode)
A_TrayMenu.Check("Enable left clicking")
A_TrayMenu.Add("Enable right clicking", ToggleMode)
A_TrayMenu.Check("Enable right clicking")
if FileExist("cursor.ico")
{
	TraySetIcon("cursor.ico")
}

ChangeDownTime(ItemName, ItemPos, MyMenu) {
	global DownTime
	NewValue := InputBox("Change the amount of time the button is held down.`nTime in ms:", "Down time", , DownTime)
	if NewValue.Result == "OK" {
		if IsNumber(NewValue.Value) {
			DownTime := Number(NewValue.Value)
			PlainDelay := Max(PlainInterval - DownTime, 0)
			CtrlDelay := Max(CtrlInterval - DownTime, 0)
			ShiftDelay := Max(ShiftInterval - DownTime, 0)
		} else {
			TrayTip(NewValue.Value " is not a number")
			Sleep(1000)
			TrayTip()
		}
	}
}

ChangeInterval(ItemName, ItemPos, MyMenu) {
	global PlainInterval
	global CtrlInterval
	global ShiftInterval
	if ItemName == "Change plain interval" {
		NewValue := InputBox("Change the interval between clicks when not using any modifiers.`nTime in ms:", "Plain interval", , PlainInterval)
	} else if ItemName == "Change Ctrl interval" {
		NewValue := InputBox("Change the interval between clicks when holding down Ctrl.`nTime in ms:", "Ctrl interval", , CtrlInterval)
	} else if ItemName == "Change Shift interval" {
		NewValue := InputBox("Change the interval between clicks when holding down Shift.`nTime in ms:", "Shift interval", , ShiftInterval)
	}
	if NewValue.Result == "OK" {
		if IsNumber(NewValue.Value) {
			if ItemName == "Change plain interval" {
				PlainInterval := Number(NewValue.Value)
				PlainDelay := Max(PlainInterval - DownTime, 0)
			} else if ItemName == "Change Ctrl interval" {
				CtrlInterval := Number(NewValue.Value)
				CtrlDelay := Max(CtrlInterval - DownTime, 0)
			} else if ItemName == "Change Shift interval" {
				ShiftInterval := Number(NewValue.Value)
				ShiftDelay := Max(ShiftInterval - DownTime, 0)
			}
		} else {
			TrayTip(NewValue.Value " is not a number")
			Sleep(1000)
			TrayTip()
		}
	}
}

ToggleMode(ItemName, ItemPos, MyMenu) {
	global EnablePlain
	global EnableCtrl
	global EnableShift
	global EnableLeft
	global EnableRight
	switch ItemName {
		case "Enable plain autoclicking": EnablePlain := !EnablePlain
		case "Enable Ctrl autoclicking": EnableCtrl := !EnableCtrl
		case "Enable Shift autoclicking": EnableShift := !EnableShift
		case "Enable left clicking": EnableLeft := !EnableLeft
		case "Enable right clicking": EnableRight := !EnableRight
	}
	A_TrayMenu.ToggleCheck(ItemName)
}

#HotIf EnableShift && EnableLeft
+XButton2:: {
	while GetKeyState("XButton2", "P")
	{
		Click("Down")
		Sleep(DownTime)
		Click("Up")
		Sleep(ShiftDelay)
	} }

#HotIf EnableShift && EnableRight
+XButton1:: {
	while GetKeyState("XButton1", "P")
	{
		Click("Down Right")
		Sleep(DownTime)
		Click("Up Right")
		Sleep(ShiftDelay)
	}
}

#HotIf EnableCtrl && EnableLeft
^XButton2:: {
	while GetKeyState("XButton2", "P")
	{
		Click("Down")
		Sleep(DownTime)
		Click("Up")
		Sleep(CtrlDelay)
	} }

#HotIf EnableCtrl && EnableRight
^XButton1:: {
	while GetKeyState("XButton1", "P")
	{
		Click("Down Right")
		Sleep(DownTime)
		Click("Up Right")
		Sleep(CtrlDelay)
	} }

#HotIf EnablePlain && EnableLeft
XButton2:: {
	Click
	while GetKeyState("XButton2", "P")
	{
		Click("Down")
		Sleep(DownTime)
		Click("Up")
		Sleep(PlainDelay)
	} }

#HotIf EnablePlain && EnableRight
XButton1:: {
	while GetKeyState("XButton1", "P")
	{
		Click("Down Right")
		Sleep(DownTime)
		Click("Up Right")
		Sleep(PlainDelay)
		if !GetKeyState("XButton2", "P") {
			break
		}
	} }