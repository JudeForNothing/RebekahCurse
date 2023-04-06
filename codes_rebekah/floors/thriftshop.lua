if StageAPI and StageAPI.Loaded then

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
    if newRoom.LayoutName == "Thrift Shop" and InutilLib.room:IsFirstVisit() then --(newRoom:GetType() == "Love Room") 
        local defaultMap = StageAPI.GetDefaultLevelMap()
        
        --if newRoom.Layout.Name and string.sub(string.lower(newRoom.Layout.Name), 1, 4) == "trap" then
        newRoom.Data.RoomGfx = ThriftShopRoomGfx
        --MusicManager():Stop()
        MusicManager():Play(RebekahCurse.Music.MUSIC_HEARTROOM, 0.1)
        MusicManager():Queue(RebekahCurse.Music.MUSIC_HEARTROOM)
        MusicManager():UpdateVolume()
        replacesong = true
        if newRoom.PersistentData.LeadToSlot then
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


end