if StageAPI and StageAPI.Loaded then


    local ThriftShopRoomBackdrop = StageAPI.BackdropHelper({
        Walls = {"room_1", "room_1", "room_1"},
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
    nil, 
    "Open", "Close", 
    "Opened", "Closed",
    false,
    nil--,
    --mirrorDoorExitFunction
)

RebekahThriftShopDoorInside = StageAPI.CustomDoor(
    "ThriftShopDoorInside", 
    nil, 
    "Open", "Close", 
    "Opened", "Closed",
    false,
    nil--,
    --mirrorDoorExitFunction
)


StageAPI.CustomStateDoor("ThriftShopDoor", nil, StageAPI.BaseDoorStates.Locked)
StageAPI.CustomStateDoor("ThriftShopDoorInside", nil, StageAPI.BaseDoorStates.Default)

yandereWaifu.ThriftShop = {}

local ThriftShopRoomlist = StageAPI.RoomsList("Thrift Shop", {
    Name = "Thrift Shop",
    Rooms = require('resources.luarooms.bosses.laban')
})

local LAYOUT_NAME = "Thrift Shop"

yandereWaifu.ThriftShop.RoomId = "ThriftShop"
--yandereWaifu.ThriftShop.Layout.Type = "Thrift Shop"
--[[
yandereWaifu.ThriftShop.Layout = StageAPI.CreateEmptyRoomLayout(RoomShape.ROOMSHAPE_1x1)
StageAPI.RegisterLayout(LAYOUT_NAME, yandereWaifu.ThriftShop.Layout)]]


--sets the door
function yandereWaifu.ThriftShop.CheckSpawnDoor()
    local room = InutilLib.room
    local level = InutilLib.level
    if --[[room:IsFirstVisit() and not RebekahLocalSavedata.Data.ThriftShopDoorSpawned 
    and]] level:GetCurrentRoomDesc().GridIndex == RebekahLocalSavedata.Data.thriftShopDoorRoomIndex
    and RebekahLocalSavedata.Data.hasThriftShopDoor
    then
        RebekahLocalSavedata.Data.ThriftShopDoorSpawned = true

        local defaultMap = StageAPI.GetDefaultLevelMap()
        local shopRoomData = defaultMap:GetRoomDataFromRoomID(yandereWaifu.ThriftShop.RoomId) --gets data from roomid and uses it to give destination?

        Isaac.DebugString("PISS")
       -- Isaac.DebugString(shopRoomData)
        local slot = RebekahLocalSavedata.Data.thriftShopDoorRoomSlot
        StageAPI.SpawnCustomDoor(slot, shopRoomData.MapID, StageAPI.DefaultLevelMapID, "ThriftShopDoor", nil, (slot + 2) % 4)
        print("did it work?")
    end
end

--NOTES: THEY SPAWN, KINDA BUT I THINK WE NEED TO SET UP MORE THINGS FOR THE DOOR TO APPEAR VISUALLY
--PH ALSO ADD A WEIRD WHILE LOOP TO KEEP LOOKING FOR A ROOM TO SPAWN IF THE FIRST PICK IS UNAVAILABLE

local currentLevelIDX
local DoorSlotFlag = {
    LEFT0 = 1 << DoorSlot.LEFT0,
    UP0 = 1 << DoorSlot.UP0,
    RIGHT0 = 1 << DoorSlot.RIGHT0,
    DOWN0 = 1 << DoorSlot.DOWN0,
    LEFT1 = 1 << DoorSlot.LEFT1,
    UP1 = 1 << DoorSlot.UP1,
    RIGHT1 = 1 << DoorSlot.RIGHT1,
    DOWN1 = 1 << DoorSlot.DOWN1,
  }

--gets custom door
function yandereWaifu.GetCustomDoorBySlot(slot) --taken from rev code
    ---@type CustomGridEntity[]
    local customDoors = StageAPI.GetCustomDoors()
    local slotIndex = InutilLib.room:GetGridIndex(InutilLib.room:GetDoorSlotPosition(slot))

    for _, door in ipairs(customDoors) do
        if door.GridIndex == slotIndex then
            return door
        end
    end
end

--takes all the slots in the given index
function yandereWaifu.GetRoomDoorSlotsToOverride(index)
	local level = InutilLib.game:GetLevel()
    local roomDescriptor = level:GetRoomByIdx(index)
	local roomConfigRoom = roomDescriptor.Data
	--local slot = roomConfigRoom.Doors
    local slots = {}
    --yuck i know but its late and im sleepy
    --[[if slot & DoorSlotFlag.LEFT0 == 1 then
        table.insert(slots, DoorSlot.LEFT0)
    end
    if slot & DoorSlotFlag.UP0 == 1 then
        table.insert(slots, DoorSlot.UP0)
    end
    if slot & DoorSlotFlag.RIGHT0 == 1 then
        table.insert(slots, DoorSlot.RIGHT0)
    end
    if slot & DoorSlotFlag.DOWN0 == 1 then
        table.insert(slots, DoorSlot.DOWN0)
    end
    if slot & DoorSlotFlag.LEFT1 == 1 then
        table.insert(slots, DoorSlot.LEFT1)
    end
    if slot & DoorSlotFlag.UP1 == 1 then
        table.insert(slots, DoorSlot.UP1)
    end
    if slot & DoorSlotFlag.RIGHT1 == 1 then
        table.insert(slots, DoorSlot.RIGHT1)
    end
    if slot & DoorSlotFlag.DOWN1 == 1 then
        table.insert(slots, DoorSlot.DOWN1)
    end]]

    local availableSlots = StageAPI.GetDoorsForRoomFromData(roomDescriptor.Data)

    Isaac.DebugString("START here")
    Isaac.DebugString(index)
    for slot = 0, DoorSlot.NUM_DOOR_SLOTS - 1 do
        if availableSlots[slot] --[[and not InutilLib.room:GetDoor(slot2) and not yandereWaifu.GetCustomDoorBySlot(slot2)]] then
            local leadingTo = yandereWaifu.GetRoomIdxRelativeToSlot(roomDescriptor, slot)
            --Isaac.DebugString(leadingTo)
            if leadingTo and not InutilLib.level:GetRoomByIdx(leadingTo).Data then
                Isaac.DebugString("bruh")
                Isaac.DebugString(slot)
                slots[#slots+1] = slot
            end
        end
    end
	return slots
end

--revelations, wtf is this
local RoomShapeDoorSlotOffsets = {
    --credits to MinimapAPI by Taz & Wofsauge
    -- L0 		UP0		R0		D0		L1		UP1		R1		D1
    {Vector(-1, 0), Vector(0, -1), Vector(1, 0), Vector(0, 1),nil,nil,nil,nil}, -- ROOMSHAPE_1x1
    {Vector(-1, 0),nil,Vector(1, 0),nil,nil,nil,nil,nil}, -- ROOMSHAPE_IH
    {nil,Vector(0, -1),nil,Vector(0, 1),nil,nil,nil,nil}, -- ROOMSHAPE_IV
    {Vector(-1, 0), Vector(0, -1), Vector(1, 0), Vector(0, 2), Vector(-1, 1),nil, Vector(1, 1),nil}, -- ROOMSHAPE_1x2
    {nil,Vector(0, -1),nil, Vector(0, 2),nil,nil,nil,nil}, -- ROOMSHAPE_IIV
    {Vector(-1, 0),Vector(0, -1),Vector(2, 0),Vector(0, 1),Vector(-1, 0),Vector(1, -1),Vector(2, 0),Vector(1, 1)}, -- ROOMSHAPE_2x1
    {Vector(-1, 0),nil,Vector(2,0),nil,nil,nil,nil,nil}, -- ROOMSHAPE_IIH
    {Vector(-1,0),Vector(0,-1),Vector(2,0),Vector(0,2),Vector(-1,1),Vector(1,-1),Vector(2,1),Vector(1,2)}, -- ROOMSHAPE_2x2
    {Vector(-1,0),Vector(-1,0),Vector(1,0),Vector(-1,2),Vector(-2,1),Vector(0,-1),Vector(1,1),Vector(0,2)}, -- ROOMSHAPE_LTL
    {Vector(-1,0),Vector(0,-1),Vector(1,0),Vector(0,2),Vector(-1,1),Vector(1,0),Vector(2,1),Vector(1,2)}, -- ROOMSHAPE_LTR
    {Vector(-1,0),Vector(0,-1),Vector(2,0),Vector(0,1),Vector(0,1),Vector(1,-1),Vector(2,1),Vector(1,2)}, -- ROOMSHAPE_LBL
    {Vector(-1,0),Vector(0,-1),Vector(2,0),Vector(0,2),Vector(-1,1),Vector(1,-1),Vector(1,1),Vector(1,1)} -- ROOMSHAPE_LBR
}

--gets room idx based on desc and slot
function yandereWaifu.GetRoomIdxRelativeToSlot(roomDesc, doorSlot)
    local shape = roomDesc.Data.Shape
    local pivotIndex = roomDesc.GridIndex
    local offset = RoomShapeDoorSlotOffsets[shape][doorSlot + 1]

    if not offset then
      error("Room slot offset not found; Shape: " .. tostring(shape) .. "; Slot: " .. tostring(doorSlot) .. REVEL.TryGetTraceback(), 2)
      return
    end

    local roomPos = Vector(pivotIndex % 13, math.floor(pivotIndex / 13))
    local newPos = roomPos + offset

    if newPos.X < 0 or newPos.X >= 13 or newPos.Y < 0 then
        return nil
    end

    return newPos.X + newPos.Y * 13
end

--grabs a random room in the floor's roomlist
function yandereWaifu.ThriftShop.GetRandomValidRoom(rng)
	local level = InutilLib.game:GetLevel()
	local roomsList = level:GetRooms()

	local index = {}
    Isaac.DebugString("GUS BALLS")
	for i = 0, #roomsList - 1 do
		local desc = roomsList:Get(i)
		if desc then
            Isaac.DebugString("NASKAPI BALLS")
            Isaac.DebugString(desc.GridIndex)
            Isaac.DebugString(desc.Data.Type)
            if desc.Data.Type == RoomType.ROOM_DEFAULT and desc.GridIndex ~= InutilLib.level:GetStartingRoomIndex() then
                Isaac.DebugString("LOKI BALLS")
                Isaac.DebugString(desc.GridIndex)
                Isaac.DebugString(desc.Data.Type)
                table.insert(index, desc)
            end
		end
	end

	return index[rng:RandomInt(#index) + 1]
end

--the function that does the beef 
function yandereWaifu.ThriftShop.PlaceInLevel()
    local lastBoss = InutilLib.level:GetLastBossRoomListIndex()

    local rng = RNG()
    rng:SetSeed(InutilLib.level:GetDungeonPlacementSeed(), 40)

    -- REVEL.PrintLevelMap()

    -- REVEL.DebugToString(validRooms, validRoomsFallback)

    --if thriftshopDoorDesc then
        local defaultMap = StageAPI.GetDefaultLevelMap()

        local avaiableDoorSlots = {} --table that keeps how muh slots are there in a room
        local thriftshopDoorDesc --room desc where the room door will spawn!
        local try = 20

        while #avaiableDoorSlots <= 0 and try > 0 do
            print("peen")
            print(#avaiableDoorSlots)
            local validRoom = yandereWaifu.ThriftShop.GetRandomValidRoom(rng)
            print("second rate")

            --if #validRooms > 0 then
            thriftshopDoorDesc = validRoom --validRooms[StageAPI.Random(1, #validRooms, rng)]
            --endFrameCount

             -- for now, only support vanilla map, no custom levels
            RebekahLocalSavedata.Data.thriftShopDoorRoomDimension = nil
            RebekahLocalSavedata.Data.thriftShopDoorRoomIndex = thriftshopDoorDesc.GridIndex
            RebekahLocalSavedata.Data.hasThriftShopDoor = true
            print(thriftshopDoorDesc.GridIndex)
            avaiableDoorSlots = yandereWaifu.GetRoomDoorSlotsToOverride(thriftshopDoorDesc.GridIndex)

            try = try - 1
        end
        if #avaiableDoorSlots > 0 then
            print("PASSED")
            local slot = avaiableDoorSlots[StageAPI.Random(1, #avaiableDoorSlots, rng)]

            Isaac.DebugString("zenith")
            Isaac.DebugString(tostring(slot))

            RebekahLocalSavedata.Data.thriftShopDoorRoomSlot = slot
            RebekahLocalSavedata.Data.thriftShopRoomIndex = yandereWaifu.GetRoomIdxRelativeToSlot(thriftshopDoorDesc, slot)
            
            Isaac.DebugString("Mirror room at:")
            Isaac.DebugString(RebekahLocalSavedata.Data.thriftShopDoorRoomIndex)
            Isaac.DebugString(RebekahLocalSavedata.Data.thriftShopRoomIndex)
            Isaac.DebugString(RebekahLocalSavedata.Data.thriftShopDoorRoomSlot)

            local x, y = StageAPI.GridToVector(RebekahLocalSavedata.Data.thriftShopRoomIndex, 13)
            x = x + 1
            y = y + 1

            local thriftShopRoom = StageAPI.LevelRoom {
                LayoutName = LAYOUT_NAME,
                SpawnSeed = InutilLib.room:GetSpawnSeed() + 5,
                Shape = RoomShape.ROOMSHAPE_1x1,
                RoomType = "Thrift Shop",
                RoomsList = ThriftShopRoomlist,
                IsExtraRoom = true,
            }
            thriftShopRoom:SetTypeOverride("Thrift Shop")
            local roomData = defaultMap:AddRoom(thriftShopRoom, {
                RoomID = yandereWaifu.ThriftShop.RoomId,
                X = x,
                Y = y,
            }, true)

            --thriftShopRoom.PersistentData.ExitRoom = InutilLib.level:GetCurrentRoomIndex()
        -- local pos = InutilLib.room:GetCenterPos()
            --thriftShopRoom.PersistentData.ExitRoomPosition = {X = pos.X, Y = pos.Y}

            local currentRoomData = defaultMap:GetRoomData(RebekahLocalSavedata.Data.thriftShopDoorRoomIndex)
            local mapId = (currentRoomData and currentRoomData.MapID) or RebekahLocalSavedata.Data.thriftShopDoorRoomIndex

            thriftShopRoom.PersistentData.ExitSlot = (slot + 2) % 4
            thriftShopRoom.PersistentData.LeadTo = mapId --RebekahLocalSavedata.Data.thriftShopDoorRoomIndex
            thriftShopRoom.PersistentData.LeadToMap = currentRoomData and defaultMap.Dimension
            thriftShopRoom.PersistentData.LeadToSlot = slot


            --[[if MinimapAPI then
                local pos = MinimapAPI:GridIndexToVector(revel.data.run.level.thriftShopRoomIndex)
                local exitSlot = (slot + 2) % 4
                local dir = StageAPI.DoorToDirection[exitSlot]

                --Reminder for displayflags: 3 bits "xyz", x:show icon, y:show room shadow, z:show room shape
                local thriftShopRoomArgs = {
                    ID = "Mirror",
                    Position = pos,--a vector representing the position of the room on the minimap.
                    Shape = "MirrorRoom" .. REVEL.dirToString[dir], --RoomShape.ROOMSHAPE_1x1,
                    TeleportHandler = {
                        Teleport = function(_, room)
                            if REVEL.STAGE.Glacier:IsStage() then
                                Isaac.ExecuteCommand("mirror")
                                return true
                            elseif REVEL.STAGE.Tomb:IsStage() then
                                Isaac.ExecuteCommand("mirror t")
                                return true
                            end
                            return false
                        end,
                        ---@param room MinimapAPI.Room
                        CanTeleport = function(_, room, allowUnclear)
                            if allowUnclear then
                                return room:GetDisplayFlags() > 0
                            else
                                return REVEL.MirrorRoom.DefeatedNarcissusThisChapter()
                            end
                        end,
                    },
                    -- Type = --A RoomType enum value. Optional, but recommended if you want the room to work as expected with minimap revealing items.
                    PermanentIcons = {"Mirror Room"},
                    LockedIcons = {"Mirror Room Locked"},--A list of strings like above, but this is only shown when the player does not know the room's type (eg locked shop, dice room)
                    DisplayFlags = RoomDescriptor.DISPLAY_NONE,
                    AdjacentDisplayFlags = RoomDescriptor.DISPLAY_NONE, --The display flags that this room will take on if seen from an adjacent room. This is usually 0 for secret rooms, 3 for locked rooms and 5 for all others.
                    Hidden = true, --This room is secret. It will not be revealed by the compass or the treasure map, and it WILL be revealed by the blue map.
                    Color = Color(0.9, 1.15, 1.25)
                }

                local mirrorMRoom = MinimapAPI:GetRoomAtPosition(pos)

                if mirrorMRoom then
                    for k, v in pairs(mirrorRoomArgs) do
                        mirrorMRoom[k] = v
                    end
                else
                    REVEL.DebugToString("WARNING | Mirror room minimap room not found when creating!")
                end

                if REVEL.OnePlayerHasCollectible(CollectibleType.COLLECTIBLE_COMPASS) then
                    local doorPos = MinimapAPI:GridIndexToVector(revel.data.run.level.mirrorDoorRoomIndex)
                    local entranceMRoom = MinimapAPI:GetRoomAtPosition(doorPos)
                    if entranceMRoom then
                        table.insert(entranceMRoom.PermanentIcons, "Mirror Entrance")
                    end    
                end
            end]]
        --end
        end
end

function yandereWaifu.ThriftShop.CanHaveThisChapter()
    return true
end


yandereWaifu:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
    if yandereWaifu.ThriftShop.CanHaveThisChapter() then
        yandereWaifu.ThriftShop.PlaceInLevel()
        Isaac.DebugString("TESTSS")
    end
    Isaac.DebugString("TESTSSSSSSSS")
end)


StageAPI.AddCallback("RebekahCurse", "POST_STAGEAPI_NEW_ROOM", 1, function()
    print("lemon tree")
--yandereWaifu:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    yandereWaifu.ThriftShop.CheckSpawnDoor()
end)

StageAPI.AddCallback("RebekahCurse", "POST_ROOM_LOAD", 0, function(newRoom) --POST_ROOM_INIT
    --yandereWaifu.ThriftShop.CheckSpawnDoor()
    if newRoom.LayoutName == "Thrift Shop" then --(newRoom:GetType() == "Love Room") 
        local defaultMap = StageAPI.GetDefaultLevelMap()
        
        --if newRoom.Layout.Name and string.sub(string.lower(newRoom.Layout.Name), 1, 4) == "trap" then
		newRoom.Data.RoomGfx = ThriftShopRoomGfx
	    --MusicManager():Stop()
	    MusicManager():Play(RebekahCurseMusic.MUSIC_HEARTROOM, 0.1)
        MusicManager():Queue(RebekahCurseMusic.MUSIC_HEARTROOM)
        MusicManager():UpdateVolume()
		replacesong = true
        print("HAHAHAHAA")
        print(newRoom.PersistentData.ExitSlot)
        print(newRoom.PersistentData.LeadTo)
        print(newRoom.PersistentData.LeadToSlot)
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

--[[StageAPI.AddCallback("RebekahCurse", "PRE_LEVELMAP_SPAWN_DOOR", 1, function(slot, doorData, levelRoom, targetLevelRoom, roomData, levelMap)
    if targetLevelRoom.RoomType == RoomType.ROOM_SECRET then
        Isaac.DebugString("DONG")
        StageAPI.SpawnCustomDoor(slot, doorData.ExitRoom, levelMap, "ThriftShopDoor", nil, doorData.ExitSlot, "Secret")
        return true
    end
end)]]

end