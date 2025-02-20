^!c::  ; Hotkey: Ctrl+Alt+C
    ;turn the mouse ponter to crosshairs
    hCross := DllCall("LoadCursor", "UInt", 0, "Int", 32515, "Ptr")
    DllCall("SetSystemCursor", "Ptr", hCross, "UInt", 32512)

    wasClicked := false
    SetTimer, WatchMouse, 10
return

WatchMouse:
    MouseGetPos, mx, my
    if (!wasClicked && GetKeyState("LButton", "P"))
    {
        wasClicked := true
        SetTimer, WatchMouse, Off

        PixelGetColor, color, %mx%, %my%, RGB ;get the pixel color at the mouse position
        hexColor := "#" . SubStr(color, 3) ;convert it to #RRGGBB
        Clipboard := hexColor ;copy it to the clipboard

        ;restore the normal cursor
        DllCall("SystemParametersInfo", "UInt", 0x57, "UInt", 0, "UInt", 0, "UInt", 0)
    }
    else if (!GetKeyState("LButton", "P"))
    {
        wasClicked := false
    }
return
