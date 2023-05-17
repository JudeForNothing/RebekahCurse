local UndercroftGrid = StageAPI.GridGfx()
UndercroftGrid:AddDoors("gfx/grid/liminal/doors/door_liminal.png", StageAPI.DefaultDoorSpawn)
UndercroftGrid:AddDoors("gfx/grid/liminal/doors/liminal_hole.png", StageAPI.SecretDoorSpawn)
UndercroftGrid:AddDoors("gfx/grid/door_07_devilroomdoor.png", {RequireEither = {RoomType.ROOM_DEVIL}})
UndercroftGrid:AddDoors("gfx/grid/door_07_holyroomdoor.png", {RequireEither = {RoomType.ROOM_ANGEL}})
UndercroftGrid:AddDoors("gfx/grid/liminal/doors/garden_treasure.png", {RequireEither = {RoomType.ROOM_TREASURE}})
UndercroftGrid:AddDoors("gfx/grid/liminal/doors/garden_boss_2.png", {RequireEither = {RoomType.ROOM_BOSS}})
UndercroftGrid:AddDoors("gfx/grid/door_05_arcaderoomdoor.png", {RequireEither = {RoomType.ROOM_ARCADE}})
UndercroftGrid:AddDoors("gfx/grid/door_04_selfsacrificeroomdoor.png", {RequireEither = {RoomType.ROOM_CURSE}})
UndercroftGrid:AddDoors("gfx/grid/liminal/doors/garden_ambush.png", {RequireEither = {RoomType.ROOM_CHALLENGE}, IsBossAmbush = false})
UndercroftGrid:AddDoors("gfx/grid/liminal/doors/garden_boss_ambush.png", {RequireEither = {RoomType.ROOM_CHALLENGE}, IsBossAmbush = true})


UndercroftGrid:SetRocks("gfx/grid/liminal/rocks_liminal.png")
UndercroftGrid:SetPits("gfx/grid/liminal/grid_pit_liminal.png")
UndercroftGrid:SetDecorations("gfx/grid/liminal/props_liminal.png")
UndercroftGrid:SetGrid("gfx/grid/grid_poop.png", GridEntityType.GRID_POOP, StageAPI.PoopVariant.Normal)
UndercroftGrid:SetGrid("gfx/grid/liminal/rocks_liminal.png", GridEntityType.GRID_PILLAR)
UndercroftGrid:SetBridges("gfx/grid/liminal/garden_bridge.png")

local UndercroftBackdrop = StageAPI.BackdropHelper({
    Walls = {"room_3", "room_3", "room_3"},
    NFloors = {"nfloor"},
    LFloors = {"lfloor"},
    Corners = {"main_corner"}
}, "gfx/backdrop/undercrofts/", ".png")

local UndercroftBackdropBoss = StageAPI.BackdropHelper({
    Walls = {"room_1"},
    NFloors = {"nfloor"},
    LFloors = {"lfloor"},
    Corners = {"main_corner"}
}, "gfx/backdrop/undercrofts/", ".png")

local UndercroftChallengeBackdrop = StageAPI.BackdropHelper({
    Walls = {"room_1"},
	NFloors = {"nfloor"},
    LFloors = {"lfloor"},
    Corners = {"main_corner"}
}, "gfx/backdrop/undercrofts/", ".png")

local UndercroftSacrificeBackdrop = StageAPI.BackdropHelper({
    Walls = {"room_1"},
    NFloors = {"nfloor"},
    LFloors = {"lfloor"},
    Corners = {"main_corner"}
}, "gfx/backdrop/undercrofts/", ".png")


--[[local UndercroftRoomList = StageAPI.RoomsList("Basic Undercrofts", {
    Name = "Basic Undercrofts",
    Rooms = require('resources.luarooms.liminal.backrooms')
})]]

--[[
local UndercroftExperimentalRoomList = StageAPI.RoomsList("Garden Experimental", {
    Name = "Garden Experimental",
    Rooms = require('resources.luarooms.greedexperimental')
})

]]
--special room, remembers
--[[local SpecialRoomList = StageAPI.RoomsList("Treasure", {
    Name = "Treasure",
    Rooms = require('resources.luarooms.special_room')
})]]

yandereWaifu.UndercroftRoomGfx = StageAPI.RoomGfx(UndercroftBackdrop, UndercroftGrid, "_default", "stageapi/shading/shading")

yandereWaifu.UndercroftBossRoomGfx = StageAPI.RoomGfx(UndercroftBackdropBoss, UndercroftGrid, "_default", "stageapi/shading/shading")
yandereWaifu.UndercroftChallengeRoomGfx = StageAPI.RoomGfx(UndercroftBackdrop, UndercroftGrid, "_default", "stageapi/shading/shading")
yandereWaifu.UndercroftSacrificeRoomGfx = StageAPI.RoomGfx(UndercroftBackdrop, UndercroftGrid, "_default", "stageapi/shading/shading")

yandereWaifu.STAGE.Undercroft = StageAPI.CustomStage("Undercroft") --Nametag of the floor itself

yandereWaifu.STAGE.Undercroft:SetReplace(StageAPI.StageOverride.NecropolisOne)

yandereWaifu.STAGE.Undercroft:SetDisplayName("Undercroft")
--yandereWaifu.STAGE.Undercroft:SetRooms(UndercroftRoomList)
--yandereWaifu.STAGE.Undercroft:SetPregenerationEnabled(true)
yandereWaifu.STAGE.Undercroft:SetRoomGfx(yandereWaifu.UndercroftRoomGfx, {RoomType.ROOM_DEFAULT, RoomType.ROOM_TREASURE, RoomType.ROOM_MINIBOSS, RoomType.ROOM_GREED_EXIT})
yandereWaifu.STAGE.Undercroft:SetRoomGfx(yandereWaifu.UndercroftBossRoomGfx, {RoomType.ROOM_BOSS})
yandereWaifu.STAGE.Undercroft:SetRoomGfx(yandereWaifu.UndercroftChallengeRoomGfx, {RoomType.ROOM_DEVIL, RoomType.ROOM_CURSE, RoomType.ROOM_CHALLENGE})
yandereWaifu.STAGE.Undercroft:SetRoomGfx(yandereWaifu.UndercroftSacrificeRoomGfx, {RoomType.ROOM_SACRIFICE})

--yandereWaifu.STAGE.Undercroft:SetMusic(Isaac.GetMusicIdByName("Garden Floor"), RoomType.ROOM_DEFAULT)
--yandereWaifu.STAGE.Undercroft:SetBossMusic(Isaac.GetMusicIdByName("Garden Boss"), Music.MUSIC_BOSS_OVER)

--yandereWaifu.STAGE.Undercroft:SetSpots("gfx/ui/boss/bossspot_19_void.png", "gfx/ui/boss/playerspot_19_void.png")
yandereWaifu.STAGE.Undercroft:OverrideRockAltEffects()
--yandereWaifu.STAGE.Undercroft:SetTransitionIcon("gfx/ui/stage/UndercroftIcon.png")

yandereWaifu.STAGE.Undercroft:SetDisplayName("")

local UndercroftXL = yandereWaifu.STAGE.Undercroft("Undercroft XL")
UndercroftXL:SetDisplayName("")
--UndercroftXL:SetNextStage("Undercroft2")
UndercroftXL.IsSecondStage = true

yandereWaifu.STAGE.Undercroft:SetXLStage(UndercroftXL)

local UndercroftTwo = yandereWaifu.STAGE.Undercroft("Undercroft 2")

UndercroftTwo:SetDisplayName("")
yandereWaifu.STAGE.Undercroft:SetNextStage(yandereWaifu.STAGE.Undercroft)
UndercroftTwo:SetReplace(StageAPI.StageOverride.NecropolisTwo)
UndercroftTwo.IsSecondStage = true

yandereWaifu:AddCallback(ModCallbacks.MC_POST_RENDER, function()
	if yandereWaifu.STAGE.Undercroft:IsStage() then
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
