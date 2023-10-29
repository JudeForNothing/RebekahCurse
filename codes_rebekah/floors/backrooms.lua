local LiminalGrid = StageAPI.GridGfx()
LiminalGrid:AddDoors("gfx/grid/liminal/doors/door_liminal.png", StageAPI.DefaultDoorSpawn)
LiminalGrid:AddDoors("gfx/grid/liminal/doors/liminal_hole.png", StageAPI.SecretDoorSpawn)
LiminalGrid:AddDoors("gfx/grid/door_07_devilroomdoor.png", {RequireEither = {RoomType.ROOM_DEVIL}})
LiminalGrid:AddDoors("gfx/grid/door_07_holyroomdoor.png", {RequireEither = {RoomType.ROOM_ANGEL}})
LiminalGrid:AddDoors("gfx/grid/liminal/doors/door_liminal.png", {RequireEither = {RoomType.ROOM_TREASURE}})
LiminalGrid:AddDoors("gfx/grid/liminal/doors/liminal_boss.png", {RequireEither = {RoomType.ROOM_BOSS}})
LiminalGrid:AddDoors("gfx/grid/door_05_arcaderoomdoor.png", {RequireEither = {RoomType.ROOM_ARCADE}})
LiminalGrid:AddDoors("gfx/grid/door_04_selfsacrificeroomdoor.png", {RequireEither = {RoomType.ROOM_CURSE}})
LiminalGrid:AddDoors("gfx/grid/liminal/doors/door_liminal.png", {RequireEither = {RoomType.ROOM_CHALLENGE}, IsBossAmbush = false})
LiminalGrid:AddDoors("gfx/grid/liminal/doors/door_liminal.png", {RequireEither = {RoomType.ROOM_CHALLENGE}, IsBossAmbush = true})


LiminalGrid:SetRocks("gfx/grid/liminal/rocks_liminal.png")
LiminalGrid:SetPits("gfx/grid/liminal/grid_pit_liminal.png", _, true) --kinda convenient
LiminalGrid:SetDecorations("gfx/grid/liminal/props_liminal.png")
LiminalGrid:SetGrid("gfx/grid/grid_poop.png", GridEntityType.GRID_POOP, StageAPI.PoopVariant.Normal)
LiminalGrid:SetGrid("gfx/grid/liminal/rocks_liminal.png", GridEntityType.GRID_PILLAR)
LiminalGrid:SetBridges("gfx/grid/liminal/garden_bridge.png")

local LiminalBackdrop = StageAPI.BackdropHelper({
    Walls = {"room_1", "room_1", "room_1"},
    NFloors = {"nfloor"},
    LFloors = {"lfloor"},
    Corners = {"main_corner"}
}, "gfx/backdrop/liminal/", ".png")

local LiminalSafeBackdrop = StageAPI.BackdropHelper({
    Walls = {"room_1", "room_1", "room_1"},
    NFloors = {"nfloor"},
    LFloors = {"lfloor"},
    Corners = {"main_corner"}
}, "gfx/backdrop/liminal/", ".png")

local LiminalBackdropBoss = StageAPI.BackdropHelper({
    Walls = {"room_3"},
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


local LiminalRoomList = StageAPI.RoomsList("Backrooms", {
    Name = "Hound Backrooms",
    Rooms = require('resources.luarooms.liminal.stage')
})

local HoundLiminalStartingRoomList = StageAPI.RoomsList("Hound Starting Backrooms", {
    Name = "Hound Starting Backrooms",
    Rooms = require('resources.luarooms.liminal.hound.starting_room')
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
yandereWaifu.LiminalSafeRoomGfx = StageAPI.RoomGfx(LiminalSafeBackdrop, LiminalGrid, "_default", "stageapi/shading/shading")

yandereWaifu.LiminalBossRoomGfx = StageAPI.RoomGfx(LiminalBackdropBoss, LiminalGrid, "_default", "stageapi/shading/shading")
yandereWaifu.LiminalChallengeRoomGfx = StageAPI.RoomGfx(LiminalBackdrop, LiminalGrid, "_default", "stageapi/shading/shading")
yandereWaifu.LiminalSacrificeRoomGfx = StageAPI.RoomGfx(LiminalBackdrop, LiminalGrid, "_default", "stageapi/shading/shading")

yandereWaifu.STAGE.Liminal = StageAPI.CustomStage("Liminal") --Nametag of the floor itself

yandereWaifu.STAGE.Liminal:SetReplace(StageAPI.StageOverride.CatacombsOne)

yandereWaifu.STAGE.Liminal:SetDisplayName("Liminal")
yandereWaifu.STAGE.Liminal:SetRooms(LiminalRoomList)
yandereWaifu.STAGE.Liminal:SetStartingRooms(HoundLiminalStartingRoomList)

--yandereWaifu.STAGE.Liminal:SetPregenerationEnabled(true)
yandereWaifu.STAGE.Liminal:SetRoomGfx(yandereWaifu.LiminalRoomGfx, {RoomType.ROOM_DEFAULT, RoomType.ROOM_TREASURE, RoomType.ROOM_MINIBOSS, RoomType.ROOM_GREED_EXIT, "Starting Room"})
yandereWaifu.STAGE.Liminal:SetRoomGfx(yandereWaifu.LiminalSafeRoomGfx, {"Safe"})
yandereWaifu.STAGE.Liminal:SetRoomGfx(yandereWaifu.LiminalBossRoomGfx, {RoomType.ROOM_BOSS})
yandereWaifu.STAGE.Liminal:SetRoomGfx(yandereWaifu.LiminalChallengeRoomGfx, {RoomType.ROOM_DEVIL, RoomType.ROOM_CURSE, RoomType.ROOM_CHALLENGE})
yandereWaifu.STAGE.Liminal:SetRoomGfx(yandereWaifu.LiminalSacrificeRoomGfx, {RoomType.ROOM_SACRIFICE})

yandereWaifu.STAGE.Liminal:SetMusic(RebekahCurse.Music.MUSIC_BACKROOMS, RoomType.ROOM_DEFAULT)
yandereWaifu.STAGE.Liminal:SetBossMusic(RebekahCurse.Music.MUSIC_BACKROOMSBOSS, Music.MUSIC_BOSS_OVER)
--yandereWaifu.STAGE.Liminal:SetBossMusic(Isaac.GetMusicIdByName("Garden Boss"), Music.MUSIC_BOSS_OVER)

--yandereWaifu.STAGE.Liminal:SetSpots("gfx/ui/boss/bossspot_19_void.png", "gfx/ui/boss/playerspot_19_void.png")
yandereWaifu.STAGE.Liminal:OverrideRockAltEffects()
--yandereWaifu.STAGE.Liminal:SetTransitionIcon("gfx/ui/stage/LiminalIcon.png")

yandereWaifu.STAGE.Liminal:SetDisplayName("The Backrooms?!")

local LiminalXL = yandereWaifu.STAGE.Liminal("Liminal XL")
LiminalXL:SetDisplayName("The Backrooms?!")
--LiminalXL:SetNextStage("Liminal2")
LiminalXL.IsSecondStage = true

yandereWaifu.STAGE.Liminal:SetXLStage(LiminalXL)

local LiminalTwo = yandereWaifu.STAGE.Liminal("Liminal 2")

LiminalTwo:SetDisplayName("The Backrooms?!")
yandereWaifu.STAGE.Liminal:SetNextStage(yandereWaifu.STAGE.Liminal)
LiminalTwo:SetReplace(StageAPI.StageOverride.CatacombsTwo)
LiminalTwo.IsSecondStage = true

yandereWaifu:AddCallback(ModCallbacks.MC_POST_RENDER, function()
	if yandereWaifu.STAGE.Liminal:IsStage() then
		for i = 0, 7 do
			local door = InutilLib.game:GetRoom():GetDoor(i)
			if door then
				if door.TargetRoomType ~= RoomType.ROOM_DEFAULT and door.TargetRoomType ~= RoomType.ROOM_BOSS 
                and door.TargetRoomType ~= RoomType.ROOM_MINIBOSS then
					InutilLib.room:RemoveDoor(i)
					--InutilLib.room:TrySpawnSpecialQuestDoor(true)
					break
				end
			end
		end
	end
end)

function yandereWaifu.GenerateQualityFourItem(pool)
    local run = true
    local seed = RNG():SetSeed(Game():GetSeeds():GetStartSeed(), 25)
    local returnValue
    while run do
        local poolItem = InutilLib.game:GetItemPool():GetCollectible(pool, true, seed)
        if InutilLib.config:GetCollectible(poolItem).Quality >= 3 then
            run = false
            returnValue = poolItem
            break
        end
    end
    return returnValue 
end

local extraPools = {
    [0] = ItemPoolType.POOL_SECRET,
    [1] = ItemPoolType.POOL_ULTRA_SECRET,
    [2] = ItemPoolType.POOL_PLANETARIUM, 
    [3] = ItemPoolType.POOL_CURSE, 
    [4] = ItemPoolType.POOL_RED_CHEST,
    [5] = ItemPoolType.POOL_ANGEL,
    [6] = ItemPoolType.POOL_DEVIL
}

local hasTakenItems = false
local backRoomsItemsSpawned = {}
function yandereWaifu.GenerateStartingRoomItems()
    hasTakenItems = false
    backRoomsItemsSpawned = {}
    local seed = RNG():SetSeed(Game():GetSeeds():GetStartSeed(), 25)
    local secretPool = yandereWaifu.GenerateQualityFourItem(ItemPoolType.POOL_SECRET)
    backRoomsItemsSpawned[0] = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, secretPool, InutilLib.room:GetGridPosition(50), Vector.Zero, nil):ToPickup()
    local ultrasecretPool = yandereWaifu.GenerateQualityFourItem(ItemPoolType.POOL_ULTRA_SECRET)
    backRoomsItemsSpawned[1] = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, ultrasecretPool, InutilLib.room:GetGridPosition(54), Vector.Zero, nil):ToPickup()

    backRoomsItemsSpawned[2] = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, extraPools[math.random(0,6)], InutilLib.room:GetGridPosition(80), Vector.Zero, nil):ToPickup()
    backRoomsItemsSpawned[3] = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, extraPools[math.random(0,6)], InutilLib.room:GetGridPosition(84), Vector.Zero, nil):ToPickup()
    for i, v in pairs (backRoomsItemsSpawned) do
        v.OptionsPickupIndex = 29
    end
end

--setting the backroom floors
StageAPI.AddCallback("RebekahCurse", "POST_ROOM_LOAD", 0, function(newRoom) --POST_ROOM_INIT
    if yandereWaifu.STAGE.Liminal:IsStage() then
        if StageAPI.InStartingRoom() and InutilLib.room:IsFirstVisit() then
            newRoom:SetTypeOverride("Starting Room")
            yandereWaifu.GenerateStartingRoomItems()
            hasTakenItems = false
        end
        if newRoom.Layout.Name and string.sub(string.lower(newRoom.Layout.Name), 1, 6) == "(safe)" then
            newRoom:SetTypeOverride("Safe")
        end
    end
end)

function yandereWaifu.SpawnHoundFromDoor(noappear)
    local noappear = noappear or false
    local dist = 999999
    local chosenDoor
     local currentRoomIndex = InutilLib.level:GetCurrentRoomDesc().GridIndex
	for i = 0, 7 do
		local door = InutilLib.game:GetRoom():GetDoor(i)
		if door then
			if dist > door.Position:Distance(Isaac.GetPlayer(0).Position) then --this is assuming everyone is together anyway 
                dist = door.Position:Distance(Isaac.GetPlayer(0).Position)
                chosenDoor = door
            end
        end
	end
    if chosenDoor then
        InutilLib.SetTimer( 120,function()
           local savedRoomIndex = currentRoomIndex
           if savedRoomIndex == InutilLib.level:GetCurrentRoomDesc().GridIndex then
                local houndCount = #Isaac.FindByType(RebekahCurse.Enemies.ENTITY_REBEKAH_ENEMY, RebekahCurse.Enemies.ENTITY_THE_HOUND, -1, false, false)
		        if houndCount <= 0 then
                    local spawn = Isaac.Spawn(RebekahCurse.Enemies.ENTITY_REBEKAH_ENEMY, RebekahCurse.Enemies.ENTITY_THE_HOUND, 0, InutilLib.room:FindFreePickupSpawnPosition(chosenDoor.Position, 1), Vector(0,0), nil):ToNPC()
                   
                    if noappear then
                        spawn:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                    end
                    yandereWaifu.GetEntityData(spawn).IsInvincible = true
                    yandereWaifu.GetEntityData(spawn).IsBackroomsHunting = true
                    spawn.CanShutDoors = false
                    spawn:AddEntityFlags(EntityFlag.FLAG_DONT_COUNT_BOSS_HP)
                end
           end
        end)
    end
end

local function KeepDoorsLocked()
    for i = 0, 7 do
		local door = InutilLib.game:GetRoom():GetDoor(i)
		if door then
			if door:IsOpen() then
				door:Bar()
			end
			--InutilLib.room:SetClear(false)
        end
	end
end

--item checking if the items are still in the backrooms starting room
yandereWaifu:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    if yandereWaifu.STAGE.Liminal:IsStage() and StageAPI.InStartingRoom() then
        if not hasTakenItems then
            KeepDoorsLocked()
            for i, v in pairs (backRoomsItemsSpawned) do
                if not v or not v:Exists() then
                    hasTakenItems = true
                    yandereWaifu.SpawnHoundFromDoor()
                    break
                end
            end
        end
    end
    if InutilLib.room:GetType() ~= RoomType.ROOM_BOSS then
        if yandereWaifu.STAGE.Liminal:IsStage() then
            for p = 0, InutilLib.game:GetNumPlayers() - 1 do
                local player = Isaac.GetPlayer(p):ToPlayer()
                --player:AddCurseMistEffect(true)
                player:AddFear(EntityRef(player), 5)
            end
        end
    end
end)

--softlock from other things so you cant do stuff while in the backrooms
yandereWaifu:AddCallback(ModCallbacks.MC_INPUT_ACTION, function(_, entity, hook, action)
    if hook == InputHook.IS_ACTION_TRIGGERED and yandereWaifu.STAGE.Liminal:IsStage() and not hasTakenItems and (action == ButtonAction.ACTION_ITEM or action == ButtonAction.ACTION_BOMB or action == ButtonAction.ACTION_PILLCARD) then
       -- InutilLib.SFX:Play(SoundEffect.SOUND_METAL_DOOR_CLOSE, 1, 0, false, 1)
        --InutilLib.game:GetHUD():ShowItemText("Pick an item","It doesn't work for now...")
        return false
    end
end)

--spawning the monster
StageAPI.AddCallback("RebekahCurse", "POST_ROOM_LOAD", 1, function(newRoom) 
    if yandereWaifu.STAGE.Liminal:IsStage() and newRoom:GetType() ~= "Safe" and newRoom.RoomType ~= RoomType.ROOM_BOSS and hasTakenItems then
        yandereWaifu.SpawnHoundFromDoor(true)
    end
end)

yandereWaifu.TheHoundStageAPIRooms = {
	StageAPI.AddBossData("The Hound", {
		Name = "The Hound",
		Portrait = "gfx/ui/boss/portrait_hound.png",
		Offset = Vector(0,-15),
		Bossname = "gfx/ui/boss/name_hound.png",
		Weight = 3,
		Rooms = StageAPI.RoomsList("Hound Boss Backrooms", require("resources.luarooms.liminal.hound.hound_boss")),
		Entity =  {Type = RebekahCurse.Enemies.ENTITY_REBEKAH_ENEMY, Variant = RebekahCurse.Enemies.ENTITY_THE_HOUND},
	})
}

    yandereWaifu.STAGE.Liminal:SetBosses({"The Hound"})


--escaping the backrooms
StageAPI.AddCallback("RebekahCurse", "POST_ROOM_LOAD", 1, function(newRoom) 
    if yandereWaifu.STAGE.Liminal:IsStage() and newRoom.RoomType == RoomType.ROOM_BOSS then
        StageAPI.SpawnCustomTrapdoor(InutilLib.room:GetGridPosition(97), {NormalStage = true, Stage = 4, StageType = StageAPI.StageTypes[StageAPI.Random(1, 3, StageAPI.StageRNG)]}, "gfx/grid/liminal/exit_trapdoor.anm2", 32, false)
        --[[for p = 0, InutilLib.game:GetNumPlayers() - 1 do
            local player = Isaac.GetPlayer(p)
            player:RemoveCurseMistEffect()
        end]]
        StageAPI.SpawnCustomTrapdoor(InutilLib.room:GetGridPosition(37), {NormalStage = true, Stage = 4, StageType = StageAPI.StageTypes[StageAPI.Random(4, #StageAPI.StageTypes, StageAPI.StageRNG)]}, "gfx/grid/trapdoor_mines.anm2", 32, false)
    end
end)