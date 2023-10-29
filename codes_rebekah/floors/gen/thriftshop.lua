if StageAPI and StageAPI.Loaded then
    
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
        if room:IsFirstVisit() and --[[not RebekahLocalSavedata.Data.ThriftShopDoorSpawned 
        and]] level:GetCurrentRoomDesc().GridIndex == RebekahLocalSavedata.Data.thriftShopDoorRoomIndex
        and RebekahLocalSavedata.Data.hasThriftShopDoor
        then
            RebekahLocalSavedata.Data.ThriftShopDoorSpawned = true

            local defaultMap = StageAPI.GetDefaultLevelMap()
            local shopRoomData = defaultMap:GetRoomDataFromRoomID(yandereWaifu.ThriftShop.RoomId) --gets data from roomid and uses it to give destination?

            if shopRoomData then
                local slot = RebekahLocalSavedata.Data.thriftShopDoorRoomSlot
                StageAPI.SpawnCustomDoor(slot, shopRoomData.MapID, StageAPI.DefaultLevelMapID, "ThriftShopDoor", nil, (slot + 2) % 4)
            else    
                print("The wierdest instance where it doesn't spawn... even I don't know why it happens, it's so rare!")
            end
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
        for slot = 0, DoorSlot.NUM_DOOR_SLOTS - 1 do
            if availableSlots[slot] --[[and not InutilLib.room:GetDoor(slot2) and not yandereWaifu.GetCustomDoorBySlot(slot2)]] then
                local leadingTo = yandereWaifu.GetRoomIdxRelativeToSlot(roomDescriptor, slot)
                --Isaac.DebugString(leadingTo)
                if leadingTo and not InutilLib.level:GetRoomByIdx(leadingTo).Data then
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
        for i = 0, #roomsList - 1 do
            local desc = roomsList:Get(i)
            if desc then
                if desc.Data.Type == RoomType.ROOM_SUPERSECRET --[[and desc.GridIndex ~= InutilLib.level:GetStartingRoomIndex()]] then
                --if desc.Data.Type == RoomType.ROOM_DEFAULT and desc.GridIndex ~= InutilLib.level:GetStartingRoomIndex() then
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

        -- i got this from revelations because i am a stupid coder

        --if thriftshopDoorDesc then
            local defaultMap = StageAPI.GetDefaultLevelMap()

            local avaiableDoorSlots = {} --table that keeps how muh slots are there in a room
            local thriftshopDoorDesc --room desc where the room door will spawn!
            local try = 20

            while #avaiableDoorSlots <= 0 and try > 0 do
                local validRoom = yandereWaifu.ThriftShop.GetRandomValidRoom(rng)

                --if #validRooms > 0 then
                thriftshopDoorDesc = validRoom --validRooms[StageAPI.Random(1, #validRooms, rng)]
                --endFrameCount

                -- for now, only support vanilla map, no custom levels
                if thriftshopDoorDesc then
                    RebekahLocalSavedata.Data.thriftShopDoorRoomDimension = nil
                    RebekahLocalSavedata.Data.thriftShopDoorRoomIndex = thriftshopDoorDesc.GridIndex
                    RebekahLocalSavedata.Data.hasThriftShopDoor = true
                    avaiableDoorSlots = yandereWaifu.GetRoomDoorSlotsToOverride(thriftshopDoorDesc.GridIndex)
                end
                try = try - 1
            end
            if #avaiableDoorSlots > 0 then
                local slot = avaiableDoorSlots[StageAPI.Random(1, #avaiableDoorSlots, rng)]

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


                if MinimapAPI then
                    local pos = MinimapAPI:GridIndexToVector(RebekahLocalSavedata.Data.thriftShopRoomIndex)
                    local exitSlot = (slot + 2) % 4
                    local dir = StageAPI.DoorToDirection[exitSlot]

                    --Reminder for displayflags: 3 bits "xyz", x:show icon, y:show room shadow, z:show room shape
                    local thriftShopRoomArgs = {
                        ID = "LabansShop",
                        Position = pos,--a vector representing the position of the room on the minimap.
                        Shape = RoomShape.ROOMSHAPE_1x1,
                        -- Type = --A RoomType enum value. Optional, but recommended if you want the room to work as expected with minimap revealing items.
                        PermanentIcons = {"LabanShop"},
                        LockedIcons = {"LabanShop"},
                        DisplayFlags = RoomDescriptor.DISPLAY_NONE,
                        AdjacentDisplayFlags = RoomDescriptor.DISPLAY_NONE, --The display flags that this room will take on if seen from an adjacent room. This is usually 0 for secret rooms, 3 for locked rooms and 5 for all others.
                        --Hidden = true, --This room is secret. It will not be revealed by the compass or the treasure map, and it WILL be revealed by the blue map.
                        --Color = Color(0.9, 1.15, 1.25)
                    }

                    local labansShopMRoom = MinimapAPI:GetRoomAtPosition(pos)

                    if labansShopMRoom then
                        for k, v in pairs(thriftShopRoomArgs) do
                            labansShopMRoom[k] = v
                        end
                    end

                    --[[if REVEL.OnePlayerHasCollectible(CollectibleType.COLLECTIBLE_COMPASS) then
                        local doorPos = MinimapAPI:GridIndexToVector(revel.data.run.level.mirrorDoorRoomIndex)
                        local entranceMRoom = MinimapAPI:GetRoomAtPosition(doorPos)
                        if entranceMRoom then
                            table.insert(entranceMRoom.PermanentIcons, "Mirror Entrance")
                        end    
                    end]]
                end
            --end
            end
    end

    --reset global locl stuff
    yandereWaifu:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(_, continue)
        if not continue then
            RebekahLocalSavedata.Data.thriftShopChance = 0
        end
    end)

    function yandereWaifu.ThriftShop.CanHaveThisChapter()
        --[[local seed = Game():GetSeeds():GetStartSeed()
        local rng = RNG()
        rng:SetSeed(seed, 45)
        local randomChance = rng:RandomInt(100)
        if  math.abs(randomChance) < RebekahLocalSavedata.Data.thriftShopChance then
            return true
        else
            return false
        end]]
        if InutilLib.level:GetStage() % 2 == 0 and InutilLib.level:GetStage() < 7 then
            return true
        end
        return false
    end

    --[[yandereWaifu:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
        if InutilLib.room:GetType() == RoomType.ROOM_SHOP then
            RebekahLocalSavedata.Data.thriftShopWillIncreaseChance = false
        end
    end)]]

    --StageAPI.AddCallback("RebekahCurse", "POST_STAGEAPI_LOAD_SAVE", 1, function()
    yandereWaifu:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
        --[[if RebekahLocalSavedata.Data.thriftShopWillIncreaseChance and InutilLib.level:GetStage() > 1 then
            RebekahLocalSavedata.Data.thriftShopChance = RebekahLocalSavedata.Data.thriftShopChance + 30
        end
        RebekahLocalSavedata.Data.thriftShopWillIncreaseChance = true]]
        if yandereWaifu.ThriftShop.CanHaveThisChapter() then
            InutilLib.SetTimer( 60, function() --praying this gets around TT's wacky stuff
                yandereWaifu.ThriftShop.PlaceInLevel()
            end)
        end
    end)


    StageAPI.AddCallback("RebekahCurse", "POST_STAGEAPI_NEW_ROOM", 1, function()
    --yandereWaifu:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
        yandereWaifu.ThriftShop.CheckSpawnDoor()
    end)

    --[[StageAPI.AddCallback("RebekahCurse", "PRE_LEVELMAP_SPAWN_DOOR", 1, function(slot, doorData, levelRoom, targetLevelRoom, roomData, levelMap)
        if targetLevelRoom.RoomType == RoomType.ROOM_SECRET then
            StageAPI.SpawnCustomDoor(slot, doorData.ExitRoom, levelMap, "ThriftShopDoor", nil, doorData.ExitSlot, "Secret")
            return true
        end
    end)]]

end