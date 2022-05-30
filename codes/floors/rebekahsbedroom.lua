if StageAPI and StageAPI.Loaded then

local RebekahCurseRoomBackdrop = StageAPI.BackdropHelper({
    Walls = {"room_2", "room_1", "room_2"},
	NFloors = {"nfloor"}
}, "gfx/backdrop/rebekahsroom/", ".png")


local replacesong = false
local RebekahsRoomCurseGrid = StageAPI.GridGfx()
RebekahsRoomCurseGrid:AddDoors("gfx/backdrop/rebekahsroom/door_curse_door.png", {RequireEither = {RoomType.ROOM_CURSE}, NotEither = {RoomType.ROOM_SECRET, RoomType.ROOM_SUPERSECRET}})

local RebekahsRoomCurseGfx = StageAPI.RoomGfx(RebekahCurseRoomBackdrop, RebekahsRoomCurseGrid, "_default", "stageapi/shading/shading")

local LiminalRoomList = StageAPI.RoomsList("Rebekah's Room", {
    Name = "Rebekah's Room",
    Rooms = require('resources.luarooms.rebekahsroom.rebekahsroom')
})


local function ReplaceCurseDoorstoMirrors()
    for i = 0, 7 do
		local door = ILIB.game:GetRoom():GetDoor(i)
		if door and (door:IsRoomType(RoomType.ROOM_CURSE) --[[or newRoom:GetType("Love Curse Room")]]) then
			--StageAPI.ChangeDoorSprite(door, RebekahsRoomCurseGfx)
			--StageAPI.ChangeDoor(door, RebekahsRoomCurseGrid, false)
			StageAPI.ChangeDoors(RebekahsRoomCurseGrid)
		end
	end
end


--Replace curse rooms
StageAPI.AddCallback("RebekahCurse", "PRE_STAGEAPI_NEW_ROOM_GENERATION", 0, function(currentRoom, justGenerated, currentListIndex)
	if yandereWaifu.WillSpawnLoveRoom() then
		ReplaceCurseDoorstoMirrors()
		if (ILIB.room:GetType() == RoomType.ROOM_CURSE) and not currentRoom --[[and ILIB.room:IsFirstVisit()]] then
			local testRoom = StageAPI.LevelRoom("Love Curse Room", LiminalRoomList, ILIB.room:GetSpawnSeed(), ILIB.room:GetRoomShape(), ILIB.room.Type, nil, nil, nil, nil, nil, StageAPI.GetCurrentRoomID())
			MusicManager():Play(RebekahCurseMusic.MUSIC_HEARTROOM, 0.1)
			MusicManager():Queue(RebekahCurseMusic.MUSIC_HEARTROOM)
			MusicManager():UpdateVolume()
			replacesong = true
			
			RebekahLocalSavedata.savedloveRoomDepletePercent = RebekahLocalSavedata.savedloveRoomDepletePercent - 45
			return testRoom
		end
	end
end)

--replace curse room door sprites
StageAPI.AddCallback("RebekahCurse", "POST_UPDATE_GRID_GFX", 0, function(gridGfx)
	if yandereWaifu.WillSpawnLoveRoom() then
		ReplaceCurseDoorstoMirrors()
	end
end)

StageAPI.AddCallback("RebekahCurse", "POST_ROOM_LOAD", 0, function(newRoom) --POST_ROOM_INIT
    if newRoom.LayoutName == "Love Curse Room" then --(newRoom:GetType() == "Love Room") 
        --if newRoom.Layout.Name and string.sub(string.lower(newRoom.Layout.Name), 1, 4) == "trap" then
        newRoom:SetTypeOverride("Love Room")
		newRoom.Data.RoomGfx = RebekahsRoomCurseGfx
       -- end
	    --MusicManager():Stop()
	    MusicManager():Play(RebekahCurseMusic.MUSIC_HEARTROOM, 0.1)
        MusicManager():Queue(RebekahCurseMusic.MUSIC_HEARTROOM)
        MusicManager():UpdateVolume()
		replacesong = true
    end
end)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	replacesong = false
end)

if MMC then
MMC.AddMusicCallback(yandereWaifu, function(self, music)
	if replacesong then
        return RebekahCurseMusic.MUSIC_HEARTROOM
	end
end)
end
end