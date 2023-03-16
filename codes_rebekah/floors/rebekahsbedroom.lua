if StageAPI and StageAPI.Loaded then

local RebekahCurseRoomBackdrop = StageAPI.BackdropHelper({
    Walls = {"room_1", "room_2", "room_3"},
	NFloors = {"nfloor"}
}, "gfx/backdrop/rebekahsroom/", ".png")


local replacesong = false
local RebekahsRoomCurseGrid = StageAPI.GridGfx()
RebekahsRoomCurseGrid:AddDoors("gfx/backdrop/rebekahsroom/door_curse_door.png", {RequireEither = {RoomType.ROOM_CURSE}, NotEither = {RoomType.ROOM_SECRET, RoomType.ROOM_SUPERSECRET}})

local RebekahsRoomCurseFlatGrid = StageAPI.GridGfx()
RebekahsRoomCurseFlatGrid:AddDoors("gfx/backdrop/rebekahsroom/door_curse_door_flat.png", {RequireEither = {RoomType.ROOM_CURSE}, NotEither = {RoomType.ROOM_SECRET, RoomType.ROOM_SUPERSECRET}})

RebekahsRoomCurseGrid:SetRocks("gfx/grid/rebekahsroom/rocks.png")
RebekahsRoomCurseGrid:SetPits("gfx/grid/liminal/grid_pit_liminal.png", _, true)
RebekahsRoomCurseGrid:SetDecorations("gfx/grid/liminal/props_liminal.png")
--RebekahsRoomCurseGrid:SetGrid("gfx/grid/rebekahsroom/rocks.png", GridEntityType.GRID_PILLAR)
RebekahsRoomCurseGrid:SetBridges("gfx/grid/rebekahsroom/rocks.png")

RebekahsRoomCurseFlatGrid:SetRocks("gfx/grid/rebekahsroom/rocks.png")
RebekahsRoomCurseFlatGrid:SetPits("gfx/grid/liminal/grid_pit_liminal.png", _, true)
RebekahsRoomCurseFlatGrid:SetDecorations("gfx/grid/liminal/props_liminal.png")
--RebekahsRoomCurseFlatGrid:SetGrid("gfx/grid/rebekahsroom/rocks.png", GridEntityType.GRID_PILLAR)
RebekahsRoomCurseFlatGrid:SetBridges("gfx/grid/rebekahsroom/rocks.png")

local RebekahsRoomCurseGfx = StageAPI.RoomGfx(RebekahCurseRoomBackdrop, RebekahsRoomCurseGrid, "_default", "stageapi/shading/shading")
local RebekahsRoomCurseFlatGfx = StageAPI.RoomGfx(RebekahCurseRoomBackdrop, RebekahsRoomCurseFlatGrid, "_default", "stageapi/shading/shading")


local LiminalRoomList = StageAPI.RoomsList("Rebekah's Room", {
    Name = "Rebekah's Room",
    Rooms = require('resources.luarooms.rebekahsroom.rebekahsroom')
})

local function ChangeLoveDoorDynamically(flatfile)
	if flatfile then
		StageAPI.ChangeDoors(RebekahsRoomCurseFlatGrid)
	else
		StageAPI.ChangeDoors(RebekahsRoomCurseGrid)
	end
end

local function ReplaceCurseDoorstoMirrors()
	local flatfile = false
	for p = 0, InutilLib.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		if player:HasTrinket(TrinketType.TRINKET_FLAT_FILE) then
			flatfile = true
			break
		end
	end
    for i = 0, 7 do
		local door = InutilLib.game:GetRoom():GetDoor(i)
		if door and (door:IsRoomType(RoomType.ROOM_CURSE)) then --vardata 1 is when curse room has no spike --[[or newRoom:GetType("Love Curse Room")]]) then
			--StageAPI.ChangeDoorSprite(door, RebekahsRoomCurseGfx)
			--StageAPI.ChangeDoor(door, RebekahsRoomCurseGrid, false)
			if door.VarData == 1 then
				flatfile = true
			end
			ChangeLoveDoorDynamically(flatfile)
		end
	end
end


--Replace curse rooms
StageAPI.AddCallback("RebekahCurse", "PRE_STAGEAPI_NEW_ROOM_GENERATION", 0, function(currentRoom, justGenerated, currentListIndex)
	if yandereWaifu.WillSpawnLoveRoom() then
		ReplaceCurseDoorstoMirrors()
		if (InutilLib.room:GetType() == RoomType.ROOM_CURSE) and not currentRoom --[[and InutilLib.room:IsFirstVisit()]] then
			local testRoom = StageAPI.LevelRoom("Love Curse Room", LiminalRoomList, InutilLib.room:GetSpawnSeed(), InutilLib.room:GetRoomShape(), InutilLib.room.Type, nil, nil, nil, nil, nil, StageAPI.GetCurrentRoomID())
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
	local flatfile = false
	for p = 0, InutilLib.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		if player:HasTrinket(TrinketType.TRINKET_FLAT_FILE) then
			flatfile = true
			break
		end
	end

    if newRoom.LayoutName == "Love Curse Room" then --(newRoom:GetType() == "Love Room") 
        --if newRoom.Layout.Name and string.sub(string.lower(newRoom.Layout.Name), 1, 4) == "trap" then
        newRoom:SetTypeOverride("Love Room")
		newRoom.Data.RoomGfx = RebekahsRoomCurseGfx
		for i = 0, 7 do
			local door = InutilLib.game:GetRoom():GetDoor(i)
			if door and (door:IsRoomType(RoomType.ROOM_CURSE)) then --vardata 1 is when curse room has no spike --[[or newRoom:GetType("Love Curse Room")]]) then
				--StageAPI.ChangeDoorSprite(door, RebekahsRoomCurseGfx)
				--StageAPI.ChangeDoor(door, RebekahsRoomCurseGrid, false)
				if door.VarData == 1 then
					flatfile = true
					newRoom.Data.RoomGfx = RebekahsRoomCurseFlatGfx
					break --this is gonna assume each door is filed
				end
			end
		end

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

	--[[for i = 0, 7 do
		local door = InutilLib.game:GetRoom():GetDoor(i)
		if door then
		print("apol")
		print(door.State)
		print(door.VarData)
		print(door:GetVariant())
		end
	end]]
end)

if MMC then
MMC.AddMusicCallback(yandereWaifu, function(self, music)
	if replacesong then
        return RebekahCurseMusic.MUSIC_HEARTROOM
	end
end)
end
end