local LiminalGrid = StageAPI.GridGfx()
LiminalGrid:AddDoors("gfx/grid/liminal/doors/door_liminal.png", StageAPI.DefaultDoorSpawn)
LiminalGrid:AddDoors("gfx/grid/liminal/doors/liminal_hole.png", StageAPI.SecretDoorSpawn)
LiminalGrid:AddDoors("gfx/grid/door_07_devilroomdoor.png", {RequireEither = {RoomType.ROOM_DEVIL}})
LiminalGrid:AddDoors("gfx/grid/door_07_holyroomdoor.png", {RequireEither = {RoomType.ROOM_ANGEL}})
LiminalGrid:AddDoors("gfx/grid/liminal/doors/garden_treasure.png", {RequireEither = {RoomType.ROOM_TREASURE}})
LiminalGrid:AddDoors("gfx/grid/liminal/doors/garden_boss_2.png", {RequireEither = {RoomType.ROOM_BOSS}})
LiminalGrid:AddDoors("gfx/grid/door_05_arcaderoomdoor.png", {RequireEither = {RoomType.ROOM_ARCADE}})
LiminalGrid:AddDoors("gfx/grid/door_04_selfsacrificeroomdoor.png", {RequireEither = {RoomType.ROOM_CURSE}})
LiminalGrid:AddDoors("gfx/grid/liminal/doors/garden_ambush.png", {RequireEither = {RoomType.ROOM_CHALLENGE}, IsBossAmbush = false})
LiminalGrid:AddDoors("gfx/grid/liminal/doors/garden_boss_ambush.png", {RequireEither = {RoomType.ROOM_CHALLENGE}, IsBossAmbush = true})


LiminalGrid:SetRocks("gfx/grid/liminal/rocks_liminal.png")
LiminalGrid:SetPits("gfx/grid/liminal/grid_pit_liminal.png")
LiminalGrid:SetDecorations("gfx/grid/liminal/props_liminal.png")
LiminalGrid:SetGrid("gfx/grid/grid_poop.png", GridEntityType.GRID_POOP, StageAPI.PoopVariant.Normal)
LiminalGrid:SetGrid("gfx/grid/liminal/rocks_liminal.png", GridEntityType.GRID_PILLAR)
LiminalGrid:SetBridges("gfx/grid/liminal/garden_bridge.png")

local LiminalBackdrop = StageAPI.BackdropHelper({
    Walls = {"room_2", "room_2", "room_2"},
    NFloors = {"nfloor"},
    LFloors = {"lfloor"},
    Corners = {"main_corner"}
}, "gfx/backdrop/liminal/", ".png")

local LiminalBackdropBoss = StageAPI.BackdropHelper({
    Walls = {"room_1"},
    NFloors = {"nfloor"},
    LFloors = {"lfloor"},
    Corners = {"main_corner"}
}, "gfx/backdrop/liminal/", ".png")

local LiminalChallengeBackdrop = StageAPI.BackdropHelper({
    Walls = {"room_1"},
	NFloors = {"nfloor"},
    LFloors = {"lfloor"},
    Corners = {"main_corner"}
}, "gfx/backdrop/liminal/", ".png")

local LiminalSacrificeBackdrop = StageAPI.BackdropHelper({
    Walls = {"room_1"},
    NFloors = {"nfloor"},
    LFloors = {"lfloor"},
    Corners = {"main_corner"}
}, "gfx/backdrop/liminal/", ".png")


local LiminalRoomList = StageAPI.RoomsList("Basic Backrooms", {
    Name = "Basic Backrooms",
    Rooms = require('resources.luarooms.liminal.backrooms')
})

--[[
local LiminalExperimentalRoomList = StageAPI.RoomsList("Garden Experimental", {
    Name = "Garden Experimental",
    Rooms = require('resources.luarooms.greedexperimental')
})

]]
--special room, remembers
--[[local SpecialRoomList = StageAPI.RoomsList("Treasure", {
    Name = "Treasure",
    Rooms = require('resources.luarooms.special_room')
})]]

yandereWaifu.LiminalRoomGfx = StageAPI.RoomGfx(LiminalBackdrop, LiminalGrid, "_default", "stageapi/shading/shading")

yandereWaifu.LiminalBossRoomGfx = StageAPI.RoomGfx(LiminalBackdropBoss, LiminalGrid, "_default", "stageapi/shading/shading")
yandereWaifu.LiminalChallengeRoomGfx = StageAPI.RoomGfx(LiminalBackdrop, LiminalGrid, "_default", "stageapi/shading/shading")
yandereWaifu.LiminalSacrificeRoomGfx = StageAPI.RoomGfx(LiminalBackdrop, LiminalGrid, "_default", "stageapi/shading/shading")

yandereWaifu.STAGE = {}

yandereWaifu.STAGE.Liminal = StageAPI.CustomStage("Liminal") --Nametag of the floor itself

yandereWaifu.STAGE.Liminal:SetReplace(StageAPI.StageOverride.NecropolisOne)

yandereWaifu.STAGE.Liminal:SetDisplayName("Liminal")
yandereWaifu.STAGE.Liminal:SetRooms(LiminalRoomList)
--yandereWaifu.STAGE.Liminal:SetPregenerationEnabled(true)
yandereWaifu.STAGE.Liminal:SetRoomGfx(yandereWaifu.LiminalRoomGfx, {RoomType.ROOM_DEFAULT, RoomType.ROOM_TREASURE, RoomType.ROOM_MINIBOSS, RoomType.ROOM_GREED_EXIT})
yandereWaifu.STAGE.Liminal:SetRoomGfx(yandereWaifu.LiminalBossRoomGfx, {RoomType.ROOM_BOSS})
yandereWaifu.STAGE.Liminal:SetRoomGfx(yandereWaifu.LiminalChallengeRoomGfx, {RoomType.ROOM_DEVIL, RoomType.ROOM_CURSE, RoomType.ROOM_CHALLENGE})
yandereWaifu.STAGE.Liminal:SetRoomGfx(yandereWaifu.LiminalSacrificeRoomGfx, {RoomType.ROOM_SACRIFICE})

yandereWaifu.STAGE.Liminal:SetMusic(Isaac.GetMusicIdByName("Garden Floor"), RoomType.ROOM_DEFAULT)
yandereWaifu.STAGE.Liminal:SetBossMusic(Isaac.GetMusicIdByName("Garden Boss"), Music.MUSIC_BOSS_OVER)

--yandereWaifu.STAGE.Liminal:SetSpots("gfx/ui/boss/bossspot_19_void.png", "gfx/ui/boss/playerspot_19_void.png")
yandereWaifu.STAGE.Liminal:OverrideRockAltEffects()
--yandereWaifu.STAGE.Liminal:SetTransitionIcon("gfx/ui/stage/LiminalIcon.png")

yandereWaifu.STAGE.Liminal:SetDisplayName("The Backrooms")

local LiminalXL = yandereWaifu.STAGE.Liminal("Liminal XL")
LiminalXL:SetDisplayName("The Backrooms")
--LiminalXL:SetNextStage("Liminal2")
LiminalXL.IsSecondStage = true

yandereWaifu.STAGE.Liminal:SetXLStage(LiminalXL)

local LiminalTwo = yandereWaifu.STAGE.Liminal("Liminal 2")

LiminalTwo:SetDisplayName("Liminal II")
yandereWaifu.STAGE.Liminal:SetNextStage(yandereWaifu.STAGE.Liminal)
LiminalTwo:SetReplace(StageAPI.StageOverride.NecropolisTwo)
LiminalTwo.IsSecondStage = true

yandereWaifu:AddCallback(ModCallbacks.MC_POST_RENDER, function()
	if yandereWaifu.STAGE.Liminal:IsStage() then
		for i = 0, 7 do
			local door = ILIB.game:GetRoom():GetDoor(i)
			if door then
				if door.TargetRoomType == RoomType.ROOM_SECRET_EXIT then
					ILIB.room:RemoveDoor(i)
					ILIB.room:TrySpawnSpecialQuestDoor(true)
					break
				end
			end
		end
	end
end)