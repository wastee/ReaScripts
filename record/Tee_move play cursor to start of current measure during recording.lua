-- @description Move play cursor to start of current measure during recording
-- @author Tee
-- @version 1.0
-- @changelog
--   Init
-- @about
--  # Move play cursor to start of current measure during recording
--
--  This script is in Main window. Please pass through key to main window if you want to use in MIDI editor.
-- @provides [main=main] .
-- @link
--   https://forum.reaget.com/t/topic/2736
--

-----------------------------------------------------------------------------------------------

local function print(text)
    reaper.ShowConsoleMsg(tostring(text))
end

reaper.PreventUIRefresh(1)

local project_status = reaper.GetAllProjectPlayStates(0)

if (project_status == 5) or (project_status == 6) then
    reaper.Main_OnCommand(40434, 0) -- View: Move edit cursor to play cursor
    reaper.Main_OnCommand(40667, 0) -- Transport: Stop (save all recorded media)
    reaper.Main_OnCommand(41041, 0) -- Move edit cursor to start of current measure
    reaper.Main_OnCommand(1013, 0) -- Transport: Record
else
    reaper.Main_OnCommand(41041, 0) -- Move edit cursor to start of current measure
end

reaper.PreventUIRefresh(-1)
