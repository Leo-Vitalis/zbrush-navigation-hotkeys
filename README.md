# Introduction

A quick search reveals the extent of dissatisfaction expressed over the years concerning the standard ZBrush navigation options. With right-button navigation style the precision of movements is compromised by having to hover the pen over the surface of the tablet. The classic left-button navigation, on the other hand, necessitates moving the pen over to the free canvas area for each and every navigation gesture, which is very questionable in terms of efficiency and speed. I believe it is hard to beat keyboard at convenience, precision and speed. I propose my AutoHotkey remapping solution, which has been partially inspired by Cinema4D navigation style, which uses **1**, **2** and **3** keyboard keys in combination with left mouse button. My remapping is a modification of that idea:

| Key         | Mouse button             | Action         |
| ----------- | ------------------------ | -------------- |
| **Alt**     | Left mouse button + drag | Orbit (Rotate) |
| **Alt + 1** | Left mouse button + drag | Pan (Move)     |
| **Alt + 2** | Left mouse button + drag | Zoom (Scale)   |
| **Win**     |                          | Alt            |
 
 To turbo-charge the efficiency, I suggest additionally assigning **1** and **2** keys to **Draw Size** and **Z Intensity** sliders (this can be done in ZBrush the usual way). The remapping is not set in stone, however. I believe the script is simple and transparent enough to allow experimentation with different keyboard combinations. Drop a comment if you have any issues and don't forget to star the script if you find it helpful.

# Set-Up

1. Install AutoHotkey. Download the script and place it into the `%userprofile%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Start-up` folder to make it run on system start-up. 

2. **Right-Click Navigation** should be turned on in **Preferences > Interface > Navigation**. 

3. To allow performing several Pan or Zoom gestures in succession without releasing the keyboard keys, the script relies on Windows autorepeat function to return the state variables `zOneDown` and `zTwoDown` back to `1`. The default initial delay may not be sufficient. Open the keyboard auto-repeat settings in Windows by pressing **Win + R** and typing `control keyboard`. Set the repeat delay to shortest. It is also a good idea to lower the repeat rate. Each time windows sends a synthetic key press event, AHK has to evaluate the corresponding hotkey unless the hotkey uses `KeyWait` to suspend the thread. Lowering the rate of "bombardment" with synthetic key presses should minimize the probability of issues.

<img width="368" height="173" alt="Autorepeat_settings" src="https://github.com/user-attachments/assets/9bef4324-3789-4094-aade-7c27e8baa398" />

# Possible Issues

1. Although I have tested the reliability of the script, AutoHotkey by its nature doesn't guarantee that the original key strokes never reach ZBrush. By default, the **1** key is assigned to **Stroke > ReplayLast**. It is better to assign the keys engaged in navigation to something inoffensive. I've chosen to dedicate the number keys to sliders: **1**, **2**, **3** and **4** to **Draw Size**, **Z Intensity**, **RGB Intensity** and **Focal Shift** respectively. Therefore, **Alt + 1** and **Alt + 2** will activate navigation gestures, whereas **1** and **2** pressed alone will call up sliders, which, you have to agree, is quite convenient. 

2. The Pan section of the `zNav` function introduces 50 ms delay before releasing synthetic Alt. This is necessary to prevent ZBrush from switching to Zoom mode. If you experience unexpected jumps at the end of panning, setting this delay to a higher value should resolve it. 

3. Do not remove the `~Alt` hotkey defined for Photoshop! AutoHotkey treats Alt differently, depending on whether this hotkey (with tilde prefix) is present in the script or not. The hotkey can be defined for any other program, it doesn't have to be Photoshop.

4. The majority of issues happen when switching back to ZBrush from another application. Before pressing the navigation shortcuts, make sure to bring ZBrush to focus by left-clicking once on an empty canvas area. You might choose to try the following approach to automate this. 

# Hotkeys Activation on Hover

The hotkeys can be activated just by hovering the cursor over ZBrush window, without the need to first bring focus to it. This can be useful when you often switch between different applications (ZBrush and PureRef, for example). However, I haven't tested this approach extensively. 

1. Add the following function to the script before `IsZBrushAltState(*)`:

```ahk
; Check whether the application is active or the cursor is currently over its window.
IsAppActiveOrUnderCursor(exeName)
{
    if WinActive("ahk_exe " exeName)
        return true

    MouseGetPos(,, &winUnderCursor)

    try
        return WinGetProcessName("ahk_id " winUnderCursor) = exeName
    catch
        return false
}
```

2. Replace `IsZBrushAltState(*)` function with:

```ahk
IsZBrushAltState(*)
{
    return GetKeyState("LAlt", "P") && IsAppActiveOrUnderCursor("ZBrush.exe")
}
```

3. Replace `#HotIf WinActive("ahk_exe ZBrush.exe")` with `#HotIf IsAppActiveOrUnderCursor("ZBrush.exe")`

