if StageAPI and StageAPI.Loaded then
    local replacesong = false

    local steam = "gfx/backdrop/shop/steam.anm2"

    yandereWaifu.ThriftShop.OVERLAY = {
        Springs1 = StageAPI.Overlay(steam, Vector(1,-1)),
        Springs2 = StageAPI.Overlay(steam, Vector(0.66,-0.66), Vector(-10,-10)),
        Springs3 = StageAPI.Overlay(steam, Vector(-0.66,-0.66), Vector(-2,-2)),
    }

    local SteamOverlays = {
        yandereWaifu.ThriftShop.OVERLAY.Springs1,
        yandereWaifu.ThriftShop.OVERLAY.Springs2,
        yandereWaifu.ThriftShop.OVERLAY.Springs3
    }


    local ThriftShopRoomBackdrop = StageAPI.BackdropHelper({
        Walls = {"room_1", "room_2", "room_1"},
        NFloors = {"nfloor"}
    }, "gfx/backdrop/shop/", ".png")
    
    
    local ThriftShopRoomGrid = StageAPI.GridGfx()
    ThriftShopRoomGrid:AddDoors("gfx/backdrop/rebekahsroom/door_curse_door.png", {RequireEither = {RoomType.ROOM_CURSE}, NotEither = {RoomType.ROOM_SECRET, RoomType.ROOM_SUPERSECRET}})
    
    local ThriftShopRoomFlatGrid = StageAPI.GridGfx()
    ThriftShopRoomFlatGrid:AddDoors("gfx/backdrop/rebekahsroom/door_curse_door_flat.png", {RequireEither = {RoomType.ROOM_CURSE}, NotEither = {RoomType.ROOM_SECRET, RoomType.ROOM_SUPERSECRET}})
    
    ThriftShopRoomGrid:SetRocks("gfx/grid/rebekahsroom/rocks.png")
    ThriftShopRoomGrid:SetPits("gfx/grid/liminal/grid_pit_liminal.png", _, true)
    ThriftShopRoomGrid:SetDecorations("gfx/grid/liminal/props_liminal.png")
    --ThriftShopRoomGrid:SetGrid("gfx/grid/rebekahsroom/rocks.png", GridEntityType.GRID_PILLAR)
    ThriftShopRoomGrid:SetBridges("gfx/grid/rebekahsroom/rocks.png")
    
    ThriftShopRoomFlatGrid:SetRocks("gfx/grid/rebekahsroom/rocks.png")
    ThriftShopRoomFlatGrid:SetPits("gfx/grid/liminal/grid_pit_liminal.png", _, true)
    ThriftShopRoomFlatGrid:SetDecorations("gfx/grid/liminal/props_liminal.png")
    --ThriftShopRoomFlatGrid:SetGrid("gfx/grid/rebekahsroom/rocks.png", GridEntityType.GRID_PILLAR)
    ThriftShopRoomFlatGrid:SetBridges("gfx/grid/rebekahsroom/rocks.png")
    
    local ThriftShopRoomGfx = StageAPI.RoomGfx(ThriftShopRoomBackdrop, ThriftShopRoomGrid, "_default", "stageapi/shading/shading")
    local ThriftShopRoomFlatGfx = StageAPI.RoomGfx(ThriftShopRoomBackdrop, ThriftShopRoomFlatGrid, "_default", "stageapi/shading/shading")
    

RebekahThriftShopDoor = StageAPI.CustomDoor(
    "ThriftShopDoor", 
    "gfx/grid/thriftshop/door.anm2", 
    "Open", "Close", 
    "Opened", "Closed",
    false,
    nil--,
    --mirrorDoorExitFunction
)

RebekahThriftShopDoorInside = StageAPI.CustomDoor(
    "ThriftShopDoorInside", 
    "gfx/grid/thriftshop/door.anm2", 
    "Open", "Close", 
    "Opened", "Closed",
    false,
    nil--,
    --mirrorDoorExitFunction
)


StageAPI.CustomStateDoor("ThriftShopDoor", "gfx/grid/thriftshop/door.anm2", StageAPI.BaseDoorStates.Locked)
StageAPI.CustomStateDoor("ThriftShopDoorInside", "gfx/grid/thriftshop/door.anm2", StageAPI.BaseDoorStates.Default)

StageAPI.AddCallback("RebekahCurse", "PRE_TRANSITION_RENDER", 1, function()
    local room = Game():GetRoom()
    local level = Game():GetLevel()
    if  StageAPI.GetCurrentRoomType() == "Thrift Shop" then
        for _, overlay in ipairs(SteamOverlays) do
            if not ((level:GetCurses() & LevelCurse.CURSE_OF_DARKNESS ~= 0) and overlay.Sprite:GetFilename() == steam) then
                overlay:Render(false, room:GetRenderScrollOffset())
            end
        end
    end
end)

StageAPI.AddCallback("RebekahCurse", "POST_ROOM_LOAD", 0, function(newRoom) --POST_ROOM_INIT
    --yandereWaifu.ThriftShop.CheckSpawnDoor()
    if newRoom.LayoutName == "Thrift Shop" then --(newRoom:GetType() == "Love Room") 
        local defaultMap = StageAPI.GetDefaultLevelMap()
        
        --if newRoom.Layout.Name and string.sub(string.lower(newRoom.Layout.Name), 1, 4) == "trap" then
        newRoom.Data.RoomGfx = ThriftShopRoomGfx
        --MusicManager():Stop()
        MusicManager():Play(RebekahCurse.Music.MUSIC_LABANSSHOP, 0.1)
        MusicManager():Queue(RebekahCurse.Music.MUSIC_LABANSSHOP)
        MusicManager():UpdateVolume()
        replacesong = true
        if newRoom.PersistentData.LeadToSlot and InutilLib.room:IsFirstVisit() then
            StageAPI.SpawnCustomDoor(
                newRoom.PersistentData.ExitSlot, 
                newRoom.PersistentData.LeadTo, 
                nil, --StageAPI.DefaultLevelMapID, 
                "ThriftShopDoorInside", 
                nil, 
                newRoom.PersistentData.LeadToSlot
            )
        end
    end
end)

--[[
yandereWaifu:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, pickup)
    if pickup and pickup:IsShopItem() then
        if pickup.Price > 0 then
            pickup.Price = pickup.Price / 2
        end
    end
end)]]

yandereWaifu:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, function(_, pickup, coll, low)
	local rng = pickup:GetDropRNG()
	local player = coll:ToPlayer()
	pickup = pickup:ToPickup()
	if StageAPI.GetCurrentRoomType() == "Thrift Shop" then
        if pickup:IsShopItem() then
            if rng:RandomFloat() <= 0.50 then
                if yandereWaifu.OriginalToBootleg[pickup.SubType] then
                    local oldPickupPrice = pickup.Price
                    pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, yandereWaifu.OriginalToBootleg[pickup.SubType], true, true, false)
                    pickup.Price = oldPickupPrice
                    pickup.AutoUpdatePrice = false
                    pickup:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                    pickup.Touched = false
                    pickup.Wait = 2
                end
            end
        end
    end
end, PickupVariant.PICKUP_COLLECTIBLE)

yandereWaifu:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, function(_, pickup, coll, low)
	local rng = pickup:GetDropRNG()
	local player = coll:ToPlayer()
	pickup = pickup:ToPickup()
	if StageAPI.GetCurrentRoomType() == "Thrift Shop" then
        if pickup:IsShopItem() then
            if rng:RandomFloat() <= 0.50 then
                if pickup.SubType == HeartSubType.HEART_FULL then
                    local mob = Isaac.Spawn(RebekahCurse.Enemies.ENTITY_REBEKAH_ENEMY, RebekahCurse.Enemies.ENTITY_REDTATO, 0, pickup.Position,  player.Velocity, player):ToNPC();
                    mob:AddEntityFlags(EntityFlag.FLAG_AMBUSH)
                    pickup.Touched = false
                    pickup:Remove()
                elseif pickup.SubType == HeartSubType.HEART_SOUL then
                    local oldPickupPrice = pickup.Price
                    local rng = math.random(1,3)
                    if rng == 1 then
                        pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, 1, true, true, false)
                    elseif rng == 2 then
                        pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, 1, true, true, false)
                    elseif rng == 3 then
                        pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_KEY, 1, true, true, false)
                    end
                    pickup.Price = oldPickupPrice
                    pickup.AutoUpdatePrice = false
                    pickup:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                    pickup.Touched = false
                    pickup.Wait = 2
                end
                for i, v in pairs (Isaac.FindByType(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_LABAN_DUDE, -1)) do
                    local data = yandereWaifu.GetEntityData(v)
                    data.state = 3
                end
            end
        end
    end
end, PickupVariant.PICKUP_HEART)


yandereWaifu:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	replacesong = false
end)


if MMC then
    MMC.AddMusicCallback(yandereWaifu, function(self, music)
        if replacesong then
            return RebekahCurse.Music.MUSIC_LABANSSHOP
        end
    end)
end

end

