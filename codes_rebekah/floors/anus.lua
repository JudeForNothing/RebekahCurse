local AnusGrid = StageAPI.GridGfx()
AnusGrid:AddDoors("gfx/grid/liminal/doors/door_liminal.png", StageAPI.DefaultDoorSpawn)
AnusGrid:AddDoors("gfx/grid/liminal/doors/liminal_hole.png", StageAPI.SecretDoorSpawn)
AnusGrid:AddDoors("gfx/grid/door_07_devilroomdoor.png", {RequireEither = {RoomType.ROOM_DEVIL}})
AnusGrid:AddDoors("gfx/grid/door_07_holyroomdoor.png", {RequireEither = {RoomType.ROOM_ANGEL}})
AnusGrid:AddDoors("gfx/grid/liminal/doors/garden_treasure.png", {RequireEither = {RoomType.ROOM_TREASURE}})
AnusGrid:AddDoors("gfx/grid/liminal/doors/garden_boss_2.png", {RequireEither = {RoomType.ROOM_BOSS}})
AnusGrid:AddDoors("gfx/grid/door_05_arcaderoomdoor.png", {RequireEither = {RoomType.ROOM_ARCADE}})
AnusGrid:AddDoors("gfx/grid/door_04_selfsacrificeroomdoor.png", {RequireEither = {RoomType.ROOM_CURSE}})
AnusGrid:AddDoors("gfx/grid/liminal/doors/garden_ambush.png", {RequireEither = {RoomType.ROOM_CHALLENGE}, IsBossAmbush = false})
AnusGrid:AddDoors("gfx/grid/liminal/doors/garden_boss_ambush.png", {RequireEither = {RoomType.ROOM_CHALLENGE}, IsBossAmbush = true})


AnusGrid:SetRocks("gfx/grid/liminal/rocks_liminal.png")
AnusGrid:SetPits("gfx/grid/liminal/grid_pit_liminal.png")
AnusGrid:SetDecorations("gfx/grid/liminal/props_liminal.png")
AnusGrid:SetGrid("gfx/grid/grid_poop.png", GridEntityType.GRID_POOP, StageAPI.PoopVariant.Normal)
AnusGrid:SetGrid("gfx/grid/liminal/rocks_liminal.png", GridEntityType.GRID_PILLAR)
AnusGrid:SetBridges("gfx/grid/liminal/garden_bridge.png")

local AnusBackdrop = StageAPI.BackdropHelper({
    Walls = {"room_1", "room_1", "room_1"},
    NFloors = {"nfloor"},
    LFloors = {"lfloor"},
    Corners = {"main_corner"}
}, "gfx/backdrop/anus/", ".png")

local AnusBackdropBoss = StageAPI.BackdropHelper({
    Walls = {"room_1"},
    NFloors = {"nfloor"},
    LFloors = {"lfloor"},
    Corners = {"main_corner"}
}, "gfx/backdrop/anus/", ".png")

local AnusChallengeBackdrop = StageAPI.BackdropHelper({
    Walls = {"room_1"},
	NFloors = {"nfloor"},
    LFloors = {"lfloor"},
    Corners = {"main_corner"}
}, "gfx/backdrop/anus/", ".png")

local AnusSacrificeBackdrop = StageAPI.BackdropHelper({
    Walls = {"room_1"},
    NFloors = {"nfloor"},
    LFloors = {"lfloor"},
    Corners = {"main_corner"}
}, "gfx/backdrop/anus/", ".png")


--[[local AnusRoomList = StageAPI.RoomsList("Basic Anuss", {
    Name = "Basic Anuss",
    Rooms = require('resources.luarooms.liminal.backrooms')
})]]

--[[
local AnusExperimentalRoomList = StageAPI.RoomsList("Garden Experimental", {
    Name = "Garden Experimental",
    Rooms = require('resources.luarooms.greedexperimental')
})

]]
--special room, remembers
--[[local SpecialRoomList = StageAPI.RoomsList("Treasure", {
    Name = "Treasure",
    Rooms = require('resources.luarooms.special_room')
})]]

yandereWaifu.AnusRoomGfx = StageAPI.RoomGfx(AnusBackdrop, AnusGrid, "_default", "stageapi/shading/shading")

yandereWaifu.AnusBossRoomGfx = StageAPI.RoomGfx(AnusBackdropBoss, AnusGrid, "_default", "stageapi/shading/shading")
yandereWaifu.AnusChallengeRoomGfx = StageAPI.RoomGfx(AnusBackdrop, AnusGrid, "_default", "stageapi/shading/shading")
yandereWaifu.AnusSacrificeRoomGfx = StageAPI.RoomGfx(AnusBackdrop, AnusGrid, "_default", "stageapi/shading/shading")

yandereWaifu.STAGE.Anus = StageAPI.CustomStage("Anus") --Nametag of the floor itself

yandereWaifu.STAGE.Anus:SetReplace(StageAPI.StageOverride.UteroOne)

yandereWaifu.STAGE.Anus:SetDisplayName("Anus")
--yandereWaifu.STAGE.Anus:SetRooms(AnusRoomList)
--yandereWaifu.STAGE.Anus:SetPregenerationEnabled(true)
yandereWaifu.STAGE.Anus:SetRoomGfx(yandereWaifu.AnusRoomGfx, {RoomType.ROOM_DEFAULT, RoomType.ROOM_TREASURE, RoomType.ROOM_MINIBOSS, RoomType.ROOM_GREED_EXIT})
yandereWaifu.STAGE.Anus:SetRoomGfx(yandereWaifu.AnusBossRoomGfx, {RoomType.ROOM_BOSS})
yandereWaifu.STAGE.Anus:SetRoomGfx(yandereWaifu.AnusChallengeRoomGfx, {RoomType.ROOM_DEVIL, RoomType.ROOM_CURSE, RoomType.ROOM_CHALLENGE})
yandereWaifu.STAGE.Anus:SetRoomGfx(yandereWaifu.AnusSacrificeRoomGfx, {RoomType.ROOM_SACRIFICE})

--yandereWaifu.STAGE.Anus:SetMusic(Isaac.GetMusicIdByName("Garden Floor"), RoomType.ROOM_DEFAULT)
--yandereWaifu.STAGE.Anus:SetBossMusic(Isaac.GetMusicIdByName("Garden Boss"), Music.MUSIC_BOSS_OVER)

--yandereWaifu.STAGE.Anus:SetSpots("gfx/ui/boss/bossspot_19_void.png", "gfx/ui/boss/playerspot_19_void.png")
yandereWaifu.STAGE.Anus:OverrideRockAltEffects()
--yandereWaifu.STAGE.Anus:SetTransitionIcon("gfx/ui/stage/AnusIcon.png")

yandereWaifu.STAGE.Anus:SetDisplayName("")

local AnusXL = yandereWaifu.STAGE.Anus("Anus XL")
AnusXL:SetDisplayName("")
--AnusXL:SetNextStage("Anus2")
AnusXL.IsSecondStage = true

yandereWaifu.STAGE.Anus:SetXLStage(AnusXL)

local AnusTwo = yandereWaifu.STAGE.Anus("Anus 2")

AnusTwo:SetDisplayName("")
yandereWaifu.STAGE.Anus:SetNextStage(yandereWaifu.STAGE.Anus)
AnusTwo:SetReplace(StageAPI.StageOverride.UteroTwo)
AnusTwo.IsSecondStage = true

yandereWaifu:AddCallback(ModCallbacks.MC_POST_RENDER, function()
	if yandereWaifu.STAGE.Anus:IsStage() then
		for i = 0, 7 do
			local door = InutilLib.game:GetRoom():GetDoor(i)
			if door then
				if door.TargetRoomType == RoomType.ROOM_SECRET_EXIT then
					InutilLib.room:RemoveDoor(i)
					InutilLib.room:TrySpawnSpecialQuestDoor(true)
					break
				end
			end
		end
	end
end)
