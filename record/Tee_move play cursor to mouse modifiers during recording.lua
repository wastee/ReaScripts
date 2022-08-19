-- @description Move play cursor to mouse modifiers during recording
-- @author Tee
-- @version 1.0
-- @changelog
--   Init
-- @about
--  # Move play cursor to mouse cursor and continue recording
--
--  This script is use in mouse modifiers.
-- @provides [main=main,midi_editor] .
-- @link
--   https://forum.reaget.com/t/topic/2736
--

-----------------------------------------------------------------------------------------------

local function print(text)
    reaper.ShowConsoleMsg(tostring(text))
end

local function startswith(text, prefix)
    return text:find(prefix, 1, true) == 1
end

local lang = os.getenv("LANG")

if (startswith(lang, "zh_CN")) then
    title = "操作错误"
    msg = "本脚本只能用在 Ruler 或 MIDI ruler 的 mouse modifiers 里"
else
    title = "ERROR"
    msg = "This script only use in Ruler or MIDI ruler in mouse modifiers"
end

local function move_cursor_to_mouse()
    window, segment, details = reaper.BR_GetMouseCursorContext()
    if (window == "midi_editor") then
        hwnd_focus = reaper.BR_Win32_GetFocus()
        reaper.MIDIEditor_OnCommand(hwnd_focus, 40443) -- move cursor to mouse
    elseif (window == "ruler") then
        reaper.Main_OnCommand(40513, 0) -- move cursor to mouse
    else
        reaper.ShowMessageBox(msg, title, 0)
    end
end

reaper.PreventUIRefresh(1)

local project_status = reaper.GetAllProjectPlayStates(0)

-- project_status
-- 5 recording; 6 recording & pause

if (project_status == 5) or (project_status == 6) then
    reaper.Main_OnCommand(40667, 0) -- Transport: Stop (save all recorded media)
    move_cursor_to_mouse()
    reaper.Main_OnCommand(1013, 0) -- Transport: Record
else
    move_cursor_to_mouse()
end

reaper.PreventUIRefresh(-1)
