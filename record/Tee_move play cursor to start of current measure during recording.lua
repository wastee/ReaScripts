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
--   https://forum.reaget.com/t/topic/2740
--

-----------------------------------------------------------------------------------------------

local function print(text)
    reaper.ShowConsoleMsg(tostring(text))
end

reaper.PreventUIRefresh(1)

local project_status = reaper.GetAllProjectPlayStates(0)

if (project_status == 5) or (project_status == 6) then
    local position = reaper.GetCursorPosition() -- Get origianl cursor position
    reaper.Main_OnCommand(40434, 0) -- View: Move edit cursor to play cursor
    local position2 = reaper.GetCursorPosition() -- Get play cursor position
    reaper.Main_OnCommand(40667, 0) -- Transport: Stop (save all recorded media)
    reaper.Main_OnCommand(41041, 0) -- Move edit cursor to start of current measure

    local retval, measures, cml, fullbeats, cdenom = reaper.TimeMap2_timeToBeats(0, position)
    local retval2, measures2, cml2, fullbeats2, cdenom2 = reaper.TimeMap2_timeToBeats(0, position2)
    if (fullbeats % cml == 0 and measures == measures2) then -- If cursor position is already at start of measure at first
        reaper.Main_OnCommand(41041, 0) -- Move edit cursor to start of current measure
    end

    reaper.Main_OnCommand(1013, 0) -- Transport: Record
else
    reaper.Main_OnCommand(41041, 0) -- Move edit cursor to start of current measure
end

reaper.PreventUIRefresh(-1)
