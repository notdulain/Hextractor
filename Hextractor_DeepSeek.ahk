; Define the hotkey to activate the color picker
^+c:: ; Ctrl+Shift+C
; Change the cursor to crosshairs
Cursor := DllCall("LoadCursor", "UInt", 0, "UInt", 32515) ; IDC_CROSS
DllCall("SetCursor", "UInt", Cursor)

; Create a GUI window to display the hex code
Gui, ColorPicker: New, +AlwaysOnTop + ToolWindow - Caption + LastFound
Gui, ColorPicker: Add, Text, vHexCode w100, #FFFFFF
Gui, ColorPicker: Add, Button, gCopyHexCode, Copy
Gui, ColorPicker: Show, x0 y0 NoActivate

; Loop to track the mouse position and color
loop {
    ; Get the mouse position
    MouseGetPos, MouseX, MouseY

    ; Get the color under the mouse cursor
    PixelGetColor, Color, %MouseX%, %MouseY%, RGB

    ; Update the GUI with the hex code
    GuiControl, ColorPicker:, HexCode, %Color%

    ; Break the loop if the mouse is clicked
    if GetKeyState("LButton", "P")
        break

    ; Sleep for a short time to reduce CPU usage
    Sleep, 10
}

; Revert the cursor to normal
DllCall("SetCursor", "UInt", DllCall("LoadCursor", "UInt", 0, "UInt", 32512)) ; IDC_ARROW

; Stop the GUI from updating
Gui, ColorPicker: Show, NoActivate

return

; Function to copy the hex code to the clipboard
CopyHexCode:
    GuiControlGet, HexCode, ColorPicker:, HexCode
    Clipboard := HexCode
    return

    ; Close the GUI when the script exits
GuiClose:
    ExitApp