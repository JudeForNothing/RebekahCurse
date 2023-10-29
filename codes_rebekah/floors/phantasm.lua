local steam = "gfx/backdrop/phantasms/steam.anm2"

yandereWaifu.OVERLAY = {
  Springs1 = StageAPI.Overlay(steam, Vector(1,-1)),
  Springs2 = StageAPI.Overlay(steam, Vector(0.66,-0.66), Vector(-10,-10)),
  Springs3 = StageAPI.Overlay(steam, Vector(-0.66,-0.66), Vector(-2,-2)),
}

local SteamOverlays = {
    yandereWaifu.OVERLAY.Springs1,
    yandereWaifu.OVERLAY.Springs2,
    yandereWaifu.OVERLAY.Springs3
}

--[[StageAPI.AddCallback("yandereWaifu", "PRE_TRANSITION_RENDER", 1, function()
    local room = Game():GetRoom()
    local level = Game():GetLevel()
    if yandereWaifu.STAGE.Phantasm:IsStage() then
        for _, overlay in ipairs(SteamOverlays) do
            if not ((level:GetCurses() & LevelCurse.CURSE_OF_DARKNESS ~= 0) and overlay.Sprite:GetFilename() == steam) then
                overlay:Render(false, room:GetRenderScrollOffset())
            end
        end
    end
end)]]

yandereWaifu:AddCallback("POST_SHADING_INIT", function(_, room)
    if yandereWaifu.STAGE.Phantasm:IsStage() then
        InutilLib.ChangeShading("_none")
        print("loadsecond")
    end
end)

local PhantasmGrid = StageAPI.GridGfx()
PhantasmGrid:AddDoors("gfx/grid/phantasm/doors/door_phantasm.png", StageAPI.DefaultDoorSpawn)
PhantasmGrid:AddDoors("gfx/grid/phantasm/doors/phantasm_hole.png", StageAPI.SecretDoorSpawn)
PhantasmGrid:AddDoors("gfx/grid/door_07_devilroomdoor.png", {RequireEither = {RoomType.ROOM_DEVIL}})
PhantasmGrid:AddDoors("gfx/grid/door_07_holyroomdoor.png", {RequireEither = {RoomType.ROOM_ANGEL}})
PhantasmGrid:AddDoors("gfx/grid/phantasm/doors/garden_treasure.png", {RequireEither = {RoomType.ROOM_TREASURE}})
PhantasmGrid:AddDoors("gfx/grid/phantasm/doors/garden_boss_2.png", {RequireEither = {RoomType.ROOM_BOSS}})
PhantasmGrid:AddDoors("gfx/grid/door_05_arcaderoomdoor.png", {RequireEither = {RoomType.ROOM_ARCADE}})
PhantasmGrid:AddDoors("gfx/grid/door_04_selfsacrificeroomdoor.png", {RequireEither = {RoomType.ROOM_CURSE}})
PhantasmGrid:AddDoors("gfx/grid/phantasm/doors/garden_ambush.png", {RequireEither = {RoomType.ROOM_CHALLENGE}, IsBossAmbush = false})
PhantasmGrid:AddDoors("gfx/grid/phantasm/doors/garden_boss_ambush.png", {RequireEither = {RoomType.ROOM_CHALLENGE}, IsBossAmbush = true})


PhantasmGrid:SetRocks("gfx/grid/phantasm/rocks_phantasm.png")
PhantasmGrid:SetPits("gfx/grid/phantasm/grid_pit_phantasm.png")
PhantasmGrid:SetDecorations("gfx/grid/phantasm/props_phantasm.png")
PhantasmGrid:SetGrid("gfx/grid/grid_poop.png", GridEntityType.GRID_POOP, StageAPI.PoopVariant.Normal)
PhantasmGrid:SetGrid("gfx/grid/phantasm/rocks_phantasm.png", GridEntityType.GRID_PILLAR)
PhantasmGrid:SetBridges("gfx/grid/phantasm/garden_bridge.png")

local PhantasmBackdrop = StageAPI.BackdropHelper({
    Walls = {"room_1", "room_1", "room_1"},
    NFloors = {"nfloor"},
    LFloors = {"lfloor"},
    Corners = {"main_corner"}
}, "gfx/backdrop/phantasms/", ".png")

local PhantasmBackdropBoss = StageAPI.BackdropHelper({
    Walls = {"room_1"},
    NFloors = {"nfloor"},
    LFloors = {"lfloor"},
    Corners = {"main_corner"}
}, "gfx/backdrop/phantasms/", ".png")

local PhantasmChallengeBackdrop = StageAPI.BackdropHelper({
    Walls = {"room_1"},
	NFloors = {"nfloor"},
    LFloors = {"lfloor"},
    Corners = {"main_corner"}
}, "gfx/backdrop/phantasms/", ".png")

local PhantasmSacrificeBackdrop = StageAPI.BackdropHelper({
    Walls = {"room_1"},
    NFloors = {"nfloor"},
    LFloors = {"lfloor"},
    Corners = {"main_corner"}
}, "gfx/backdrop/phantasms/", ".png")


--[[local PhantasmRoomList = StageAPI.RoomsList("Basic Phantasms", {
    Name = "Basic Phantasms",
    Rooms = require('resources.luarooms.phantasm.backrooms')
})]]

--[[
local PhantasmExperimentalRoomList = StageAPI.RoomsList("Garden Experimental", {
    Name = "Garden Experimental",
    Rooms = require('resources.luarooms.greedexperimental')
})

]]
--special room, remembers
--[[local SpecialRoomList = StageAPI.RoomsList("Treasure", {
    Name = "Treasure",
    Rooms = require('resources.luarooms.special_room')
})]]

yandereWaifu.PhantasmRoomGfx = StageAPI.RoomGfx(PhantasmBackdrop, PhantasmGrid, "_default", "stageapi/shading/shading2")

yandereWaifu.PhantasmBossRoomGfx = StageAPI.RoomGfx(PhantasmBackdropBoss, PhantasmGrid, "_default", "stageapi/shading/shading")
yandereWaifu.PhantasmChallengeRoomGfx = StageAPI.RoomGfx(PhantasmBackdrop, PhantasmGrid, "_default", "stageapi/shading/shading")
yandereWaifu.PhantasmSacrificeRoomGfx = StageAPI.RoomGfx(PhantasmBackdrop, PhantasmGrid, "_default", "stageapi/shading/shading")

yandereWaifu.STAGE.Phantasm = StageAPI.CustomStage("Phantasm") --Nametag of the floor itself

yandereWaifu.STAGE.Phantasm:SetReplace(StageAPI.StageOverride.NecropolisOne)

yandereWaifu.STAGE.Phantasm:SetDisplayName("Phantasm")
--yandereWaifu.STAGE.Phantasm:SetRooms(PhantasmRoomList)
--yandereWaifu.STAGE.Phantasm:SetPregenerationEnabled(true)
yandereWaifu.STAGE.Phantasm:SetRoomGfx(yandereWaifu.PhantasmRoomGfx, {RoomType.ROOM_DEFAULT, RoomType.ROOM_TREASURE, RoomType.ROOM_MINIBOSS, RoomType.ROOM_GREED_EXIT})
yandereWaifu.STAGE.Phantasm:SetRoomGfx(yandereWaifu.PhantasmBossRoomGfx, {RoomType.ROOM_BOSS})
yandereWaifu.STAGE.Phantasm:SetRoomGfx(yandereWaifu.PhantasmChallengeRoomGfx, {RoomType.ROOM_DEVIL, RoomType.ROOM_CURSE, RoomType.ROOM_CHALLENGE})
yandereWaifu.STAGE.Phantasm:SetRoomGfx(yandereWaifu.PhantasmSacrificeRoomGfx, {RoomType.ROOM_SACRIFICE})

--yandereWaifu.STAGE.Phantasm:SetMusic(Isaac.GetMusicIdByName("Garden Floor"), RoomType.ROOM_DEFAULT)
--yandereWaifu.STAGE.Phantasm:SetBossMusic(Isaac.GetMusicIdByName("Garden Boss"), Music.MUSIC_BOSS_OVER)

--yandereWaifu.STAGE.Phantasm:SetSpots("gfx/ui/boss/bossspot_19_void.png", "gfx/ui/boss/playerspot_19_void.png")
yandereWaifu.STAGE.Phantasm:OverrideRockAltEffects()
--yandereWaifu.STAGE.Phantasm:SetTransitionIcon("gfx/ui/stage/PhantasmIcon.png")

yandereWaifu.STAGE.Phantasm:SetDisplayName("")

local PhantasmXL = yandereWaifu.STAGE.Phantasm("Phantasm XL")
PhantasmXL:SetDisplayName("")
--PhantasmXL:SetNextStage("Phantasm2")
PhantasmXL.IsSecondStage = true

yandereWaifu.STAGE.Phantasm:SetXLStage(PhantasmXL)

local PhantasmTwo = yandereWaifu.STAGE.Phantasm("Phantasm 2")

PhantasmTwo:SetDisplayName("")
yandereWaifu.STAGE.Phantasm:SetNextStage(yandereWaifu.STAGE.Phantasm)
PhantasmTwo:SetReplace(StageAPI.StageOverride.NecropolisTwo)
PhantasmTwo.IsSecondStage = true

yandereWaifu:AddCallback(ModCallbacks.MC_POST_RENDER, function()
	if yandereWaifu.STAGE.Phantasm:IsStage() then
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
