; Set a custom icon for the tray
Menu, Tray, Icon, hextractor.ico

; Create a GUI for displaying the hex color
Gui, +AlwaysOnTop -Caption +ToolWindow
Gui, Color, White
Gui, Font, cBlack s10 Bold, Arial
Gui, Add, Text, vHexDisplay w100 h20 Center, #FFFFFF
Gui, Show, x10 y10 NoActivate, Hex Color

^!c::  ; Hotkey: Ctrl+Alt+C

    ; Show the GUI at the top-left corner
    Gui, Show, x10 y10 NoActivate, Hex Color
    SetTimer, UpdateHexDisplay, 10 ; Start real-time update

    ;turn the mouse ponter to crosshairs
    hCross := DllCall("LoadCursor", "UInt", 0, "Int", 32515, "Ptr")
    DllCall("SetSystemCursor", "Ptr", hCross, "UInt", 32512)

    wasClicked := false
    SetTimer, WatchMouse, 10 ;refresh cursor every 10milli seconds
return

UpdateHexDisplay:
    MouseGetPos, mx, my
    PixelGetColor, color, %mx%, %my%, RGB ; Get the pixel color at the mouse position
    hexColor := "#" . SubStr(color, 3) ; Convert it to #RRGGBB
    GuiControl,, HexDisplay, %hexColor% ; Update the GUI with the current hex color

    if (GetKeyState("LButton", "P")) ; If the left mouse button is clicked
    {
        SetTimer, UpdateHexDisplay, Off
        Clipboard := hexColor ; Copy the hex color to the clipboard

        ; Restore the normal cursor
        DllCall("SystemParametersInfo", "UInt", 0x57, "UInt", 0, "UInt", 0, "UInt", 0)

        ; Hide the GUI
        Gui, Hide
    }
return

WatchMouse:
    MouseGetPos, mx, my
    if (!wasClicked && GetKeyState("LButton", "P"))
    {
        wasClicked := true
        SetTimer, WatchMouse, Off
        SetTimer, UpdateHexDisplay, Off ; Stop real-time update after clicking

        PixelGetColor, color, %mx%, %my%, RGB ;get the pixel color at the mouse position
        hexColor := "#" . SubStr(color, 3) ;convert it to #RRGGBB
        Clipboard := hexColor ;copy it to the clipboard

        ;restore the normal cursor
        DllCall("SystemParametersInfo", "UInt", 0x57, "UInt", 0, "UInt", 0, "UInt", 0)

        Gui, Hide ; Hide the GUI after selection
    }
    else if (!GetKeyState("LButton", "P"))
    {
        wasClicked := false
    }
return
