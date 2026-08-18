#Requires AutoHotkey v2.0

#SuspendExempt true
^Space:: Suspend()
#SuspendExempt false

#HotIf (!GetKeyState("Shift"))
; ''''''''''''''''''''
~' & e:: {
	Send("{BackSpace}é")
}

; ````````````````````
~` & a:: {
	Send("{BackSpace}à")
}
~` & e:: {
	Send("{BackSpace}è")
}
~` & u:: {
	Send("{BackSpace}ù")
}

; ^^^^^^^^^^^^^^^^^^^^
~6 & a:: {
	Send("{BackSpace}å")
}
~6 & e:: {
	Send("{BackSpace}ê")
}
~6 & i:: {
	Send("{BackSpace}î")
}
~6 & o:: {
	Send("{BackSpace}ô")
}
~6 & u:: {
	Send("{BackSpace}û")
}

; ::::::::::::::::::::
~; & a:: {
	Send("{BackSpace}ä")
}
~; & e:: {
	Send("{BackSpace}ë")
}
~; & i:: {
	Send("{BackSpace}ï")
}
~; & o:: {
	Send("{BackSpace}ö")
}
~; & u:: {
	Send("{BackSpace}ü")
}

; ,,,,,,,,,,,,,,,,,,,,
~, & c:: {
	Send("{BackSpace}ç")
}

#HotIf (GetKeyState("Shift"))
; ''''''''''''''''''''
~' & e:: {
	Send("{BackSpace}É")
}

; ````````````````````
~` & a:: {
	Send("{BackSpace}À")
}
~` & e:: {
	Send("{BackSpace}È")
}
~' & u:: {
	Send("{BackSpace}Ù")
}

; ^^^^^^^^^^^^^^^^^^^^
~6 & a:: {
	Send("{BackSpace}Â")
}
~6 & e:: {
	Send("{BackSpace}Ê")
}
~6 & i:: {
	Send("{BackSpace}Î")
}
~6 & o:: {
	Send("{BackSpace}Ô")
}
~6 & u:: {
	Send("{BackSpace}Û")
}

; ::::::::::::::::::::
~; & a:: {
	Send("{BackSpace}Ä")
}
~; & e:: {
	Send("{BackSpace}Ë")
}
~; & i:: {
	Send("{BackSpace}Ï")
}
~; & o:: {
	Send("{BackSpace}Ö")
}
~; & u:: {
	Send("{BackSpace}Ü")
}

; ,,,,,,,,,,,,,,,,,,,,
~, & c:: {
	Send("{BackSpace}Ç")
}