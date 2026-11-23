; ------------------------------------------------------------
; Description: Custom navigation shortcuts for ZBrush.
; Author: Leo Vitalis
; Version: 1.0.0
; GitHub: https://github.com/Leo-Vitalis/zbrush-navigation-hotkeys
; License: MIT
; ------------------------------------------------------------

#Requires AutoHotkey v2.0

IsZBrushAltState(*)
{
    return GetKeyState("LAlt", "P") && WinActive("ahk_exe ZBrush.exe")
}

HotIf IsZBrushAltState
Hotkey "LButton", zNav
HotIf

global zOneDown := 0
global zTwoDown := 0
global zThreeDown := 0

zNav(*)
{
	global zOneDown, zTwoDown, zThreeDown
    if zOneDown
    {
        ; Pan
        Send "{Alt Down}{RButton Down}"
		KeyWait "LButton"
		Send "{RButton Up}"
		Sleep 50
		Send "{Blind}{Alt Up}"
		zOneDown := 0
    }
    else if zTwoDown
    {
        ; Zoom
        Send "{Alt Down}{RButton Down}"
        Send "{Blind}{Alt Up}"
        KeyWait "LButton"
        Send "{RButton Up}"
		zTwoDown := 0
    }
	else if zThreeDown
    {
        ; Rotate around Z-axis
		Send "{Shift Down}{RButton Down}{Shift Up}"
		KeyWait "LButton"
		Send "{RButton Up}"
		zThreeDown := 0
    }
    else
    {
        ; Orbit
		Send "{RButton Down}"
		KeyWait "LButton"
		Send "{RButton Up}"
    }
}


#HotIf WinActive("ahk_exe ZBrush.exe")

; *Alt and *LAlt hotkeys autorepeat without using either KeyWait or a state variable to prevent it.
*LAlt::
{
	global zOneDown, zTwoDown, zThreeDown	

	; Release logical Alt.
	if GetKeyState("Alt")
	{
		Send "{Blind}{Alt Up}"
	}

	zOneDown := 0
	zTwoDown := 0
	zThreeDown := 0

	KeyWait "LAlt"

	zOneDown := 0
	zTwoDown := 0
	zThreeDown := 0
}

*LWin::
{
    Send "{Alt Down}"
    KeyWait "LWin"
    Send "{Alt Up}"
}

*1::
{
    global zOneDown

    if zOneDown
        return

    zOneDown := 1

    if GetKeyState("Alt", "P")
        return

    Send "{Blind}{1}"
    KeyWait "1"
    zOneDown := 0
}

*2::
{
    global zTwoDown

    if zTwoDown
        return

    zTwoDown := 1

    if GetKeyState("Alt", "P")
        return

    Send "{Blind}{2}"
    KeyWait "2"
    zTwoDown := 0
}

*3::
{
    global zThreeDown

    if zThreeDown
        return

    zThreeDown := 1

    if GetKeyState("Alt", "P")
        return

    Send "{Blind}{3}"
    KeyWait "3"
    zThreeDown := 0
}

; Prevent autorepeat from flooding the slider input field with number 4. 
$4::
{
	Send "{4}"
	Keywait "4"
}

*1 Up::
{
    global zOneDown
    zOneDown := 0
}

*2 Up::
{
    global zTwoDown
    zTwoDown := 0
}

*3 Up::
{
    global zThreeDown
    zThreeDown := 0
}


; Do not remove! AHK treats Alt differently, when the `~Alt` hotkey isn't defined somewhere in the script.
#HotIf WinActive("ahk_exe Photoshop.exe")

; Prevent focusing the menu bar. 
~Alt:: 
{
	Send "{Blind}{vkE8}"
}