-- @description Remove selected items if active take is not mono
-- @author Tee
-- @version 1.02
-- @changelog
--   version 1: init
--   version 1.01: fix provides
--   version 1.02: fix delete logic
-- @about
--  # Remove selected items if active take is not mono
--
--  This script is use in mouse modifiers.
-- @provides [main=main] .
-- @link
--   https://forum.reaget.com/

-----------------------------------------------------------------------------------------------

local function print(text)
    reaper.ShowConsoleMsg(tostring(text))
end

reaper.Undo_BeginBlock()

reaper.PreventUIRefresh(1)

local del_table = {}
local item_cnt = reaper.CountSelectedMediaItems(0)
for i = 0, item_cnt - 1 do
    local item = reaper.GetSelectedMediaItem(0, i)
    local track = reaper.GetMediaItemTrack(item)
    local take = reaper.GetActiveTake(item)
    local chans_mode = reaper.GetMediaItemTakeInfo_Value(take, "I_CHANMODE")
    if (chans_mode == 0 and chans_mode == 1) then
        del_table[item] = track
    end
end

for item, track in pairs(del_table) do
    reaper.DeleteTrackMediaItem(track, item)
end

reaper.PreventUIRefresh(-1)
reaper.UpdateArrange()

reaper.Undo_EndBlock("Remove selected items if active take is not mono", -1)
