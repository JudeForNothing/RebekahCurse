local steam = "gfx/backdrop/shop/steam.anm2"

local TartarusGrid = StageAPI.GridGfx()
TartarusGrid:AddDoors("gfx/grid/tartarus/doors/door_tartarus.png", StageAPI.DefaultDoorSpawn)
TartarusGrid:AddDoors("gfx/grid/tartarus/doors/tartarus_hole.png", StageAPI.SecretDoorSpawn)
TartarusGrid:AddDoors("gfx/grid/door_07_devilroomdoor.png", {RequireEither = {RoomType.ROOM_DEVIL}})
TartarusGrid:AddDoors("gfx/grid/door_07_holyroomdoor.png", {RequireEither = {RoomType.ROOM_ANGEL}})
TartarusGrid:AddDoors("gfx/grid/tartarus/doors/garden_treasure.png", {RequireEither = {RoomType.ROOM_TREASURE}})
TartarusGrid:AddDoors("gfx/grid/tartarus/doors/garden_boss_2.png", {RequireEither = {RoomType.ROOM_BOSS}})
TartarusGrid:AddDoors("gfx/grid/door_05_arcaderoomdoor.png", {RequireEither = {RoomType.ROOM_ARCADE}})
TartarusGrid:AddDoors("gfx/grid/door_04_selfsacrificeroomdoor.png", {RequireEither = {RoomType.ROOM_CURSE}})
TartarusGrid:AddDoors("gfx/grid/tartarus/doors/garden_ambush.png", {RequireEither = {RoomType.ROOM_CHALLENGE}, IsBossAmbush = false})
TartarusGrid:AddDoors("gfx/grid/tartarus/doors/garden_boss_ambush.png", {RequireEither = {RoomType.ROOM_CHALLENGE}, IsBossAmbush = true})


TartarusGrid:SetRocks("gfx/grid/tartarus/rocks_tartarus.png")
TartarusGrid:SetPits("gfx/grid/tartarus/grid_pit_tartarus.png")
TartarusGrid:SetDecorations("gfx/grid/tartarus/props_tartarus.png")
TartarusGrid:SetGrid("gfx/grid/grid_poop.png", GridEntityType.GRID_POOP, StageAPI.PoopVariant.Normal)
TartarusGrid:SetGrid("gfx/grid/tartarus/rocks_tartarus.png", GridEntityType.GRID_PILLAR)
TartarusGrid:SetBridges("gfx/grid/tartarus/garden_bridge.png")

local TartarusBackdrop = StageAPI.BackdropHelper({
    Walls = {"room_1", "room_1", "room_1"},
    NFloors = {"nfloor"},
    LFloors = {"lfloor"},
    Corners = {"main_corner"}
}, "gfx/backdrop/tartarus/", ".png")

local TartarusBackdropBoss = StageAPI.BackdropHelper({
    Walls = {"room_1"},
    NFloors = {"nfloor"},
    LFloors = {"lfloor"},
    Corners = {"main_corner"}
}, "gfx/backdrop/tartarus/", ".png")

local TartarusChallengeBackdrop = StageAPI.BackdropHelper({
    Walls = {"room_1"},
	NFloors = {"nfloor"},
    LFloors = {"lfloor"},
    Corners = {"main_corner"}
}, "gfx/backdrop/tartarus/", ".png")

local TartarusSacrificeBackdrop = StageAPI.BackdropHelper({
    Walls = {"room_1"},
    NFloors = {"nfloor"},
    LFloors = {"lfloor"},
    Corners = {"main_corner"}
}, "gfx/backdrop/tartarus/", ".png")


--[[local TartarusRoomList = StageAPI.RoomsList("Basic Tartaruss", {
    Name = "Basic Tartaruss",
    Rooms = require('resources.luarooms.tartarus.backrooms')
})]]

--[[
local TartarusExperimentalRoomList = StageAPI.RoomsList("Garden Experimental", {
    Name = "Garden Experimental",
    Rooms = require('resources.luarooms.greedexperimental')
})

]]
--special room, remembers
--[[local SpecialRoomList = StageAPI.RoomsList("Treasure", {
    Name = "Treasure",
    Rooms = require('resources.luarooms.special_room')
})]]

yandereWaifu.TartarusRoomGfx = StageAPI.RoomGfx(TartarusBackdrop, TartarusGrid, "_default", "stageapi/shading/shading")

yandereWaifu.TartarusBossRoomGfx = StageAPI.RoomGfx(TartarusBackdropBoss, TartarusGrid, "_default", "stageapi/shading/shading")
yandereWaifu.TartarusChallengeRoomGfx = StageAPI.RoomGfx(TartarusBackdrop, TartarusGrid, "_default", "stageapi/shading/shading")
yandereWaifu.TartarusSacrificeRoomGfx = StageAPI.RoomGfx(TartarusBackdrop, TartarusGrid, "_default", "stageapi/shading/shading")

yandereWaifu.STAGE.Tartarus = StageAPI.CustomStage("Tartarus") --Nametag of the floor itself

yandereWaifu.STAGE.Tartarus:SetReplace(StageAPI.StageOverride.NecropolisOne)

yandereWaifu.STAGE.Tartarus:SetDisplayName("Tartarus")
--yandereWaifu.STAGE.Tartarus:SetRooms(TartarusRoomList)
--yandereWaifu.STAGE.Tartarus:SetPregenerationEnabled(true)
yandereWaifu.STAGE.Tartarus:SetRoomGfx(yandereWaifu.TartarusRoomGfx, {RoomType.ROOM_DEFAULT, RoomType.ROOM_TREASURE, RoomType.ROOM_MINIBOSS, RoomType.ROOM_GREED_EXIT})
yandereWaifu.STAGE.Tartarus:SetRoomGfx(yandereWaifu.TartarusBossRoomGfx, {RoomType.ROOM_BOSS})
yandereWaifu.STAGE.Tartarus:SetRoomGfx(yandereWaifu.TartarusChallengeRoomGfx, {RoomType.ROOM_DEVIL, RoomType.ROOM_CURSE, RoomType.ROOM_CHALLENGE})
yandereWaifu.STAGE.Tartarus:SetRoomGfx(yandereWaifu.TartarusSacrificeRoomGfx, {RoomType.ROOM_SACRIFICE})

--yandereWaifu.STAGE.Tartarus:SetMusic(Isaac.GetMusicIdByName("Garden Floor"), RoomType.ROOM_DEFAULT)
--yandereWaifu.STAGE.Tartarus:SetBossMusic(Isaac.GetMusicIdByName("Garden Boss"), Music.MUSIC_BOSS_OVER)

--yandereWaifu.STAGE.Tartarus:SetSpots("gfx/ui/boss/bossspot_19_void.png", "gfx/ui/boss/playerspot_19_void.png")
yandereWaifu.STAGE.Tartarus:OverrideRockAltEffects()
--yandereWaifu.STAGE.Tartarus:SetTransitionIcon("gfx/ui/stage/TartarusIcon.png")

local TartarusXL = yandereWaifu.STAGE.Tartarus("Tartarus XL")
TartarusXL:SetDisplayName("")
--TartarusXL:SetNextStage("Tartarus2")
TartarusXL.IsSecondStage = true

yandereWaifu.STAGE.Tartarus:SetXLStage(TartarusXL)

local TartarusTwo = yandereWaifu.STAGE.Tartarus("Tartarus 2")

TartarusTwo:SetDisplayName("")
yandereWaifu.STAGE.Tartarus:SetNextStage(yandereWaifu.STAGE.Tartarus)
TartarusTwo:SetReplace(StageAPI.StageOverride.NecropolisTwo)
TartarusTwo.IsSecondStage = true

yandereWaifu.STAGE.Tartarus.OVERLAY = {
    Springs1 = StageAPI.Overlay(steam, Vector(1,-1)),
    Springs2 = StageAPI.Overlay(steam, Vector(0.30,-0.30), Vector(-1,-1)),
    Springs3 = StageAPI.Overlay(steam, Vector(-0.30,-0.30), Vector(-2,-2)),
}

local SteamOverlays = {
    yandereWaifu.STAGE.Tartarus.OVERLAY.Springs1,
    yandereWaifu.STAGE.Tartarus.OVERLAY.Springs2,
    yandereWaifu.STAGE.Tartarus.OVERLAY.Springs3
}

yandereWaifu:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
	if yandereWaifu.STAGE.Tartarus:IsStage() then
		if InutilLib.game:GetFrameCount() % 5 == 0 then
            local emberParticle = Isaac.Spawn(1000,87, 0, Vector(math.random(0, InutilLib.room:GetBottomRightPos().X), InutilLib.room:GetTopLeftPos().Y), Vector(0, 10):Resized(math.random(4,7)):Rotated(-35 + math.random(70)), nil):ToEffect()
			emberParticle.SpriteOffset = Vector(0, -20)
            emberParticle.Timeout = 300
			emberParticle:Update()
        end
	end
end)

StageAPI.AddCallback("RebekahCurse", "PRE_TRANSITION_RENDER", 1, function()
    local room = Game():GetRoom()
    local level = Game():GetLevel()
    if yandereWaifu.STAGE.Tartarus:IsStage()  then
        for _, overlay in ipairs(SteamOverlays) do
            --if not ((level:GetCurses() & LevelCurse.CURSE_OF_DARKNESS ~= 0) and overlay.Sprite:GetFilename() == steam) then
                overlay:Render(false, room:GetRenderScrollOffset())
            --end
        end
    end
end)
