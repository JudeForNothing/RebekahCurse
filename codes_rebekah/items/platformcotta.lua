function isPlatformValid()
    local second = InutilLib.game.TimeCounter/30
    local minute = second/60
    local stage = InutilLib.level:GetStage()
    local stageType = InutilLib.level:GetStageType()
    if RebekahLocalSavedata.Data.HasPlatformItemsTaken then
        return false
    end
    --if minute > 0 and minute < 1 and stage == 1 then
        return true
    --end
    --return false
end


function spawnPlatform(pos, player)
    local platform = Isaac.Spawn( EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_PLATFORMCAKE, 0, InutilLib.room:GetCenterPos(),  Vector(0,0), ent );
    platform:GetSprite():Play("Missing", true)
    local data = yandereWaifu.GetEntityData(platform)
    if isPlatformValid() then
        platform:GetSprite():Play("Idle", true)
    end
    return platform
end

function generateItems(pos)
    local tbl = {}
    for i = 0, math.random(7,9) do
        local rng = math.random(1,9)
        if rng == 1 then
            local item = Isaac.Spawn( EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, 0, InutilLib.room:FindFreePickupSpawnPosition(pos, 1), Vector(0,0), player ):ToPickup();
            --item.OptionsPickupIndex = 117
            yandereWaifu.GetEntityData(item).PlatformItem = true
            table.insert(tbl, {type = item.Type, variant = item.Variant, subtype = item.SubType})
        elseif rng == 2 then
            local item = Isaac.Spawn( EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, 0,InutilLib.room:FindFreePickupSpawnPosition(pos, 1), Vector(0,0), player ):ToPickup();
            --item.OptionsPickupIndex = 117
            yandereWaifu.GetEntityData(item).PlatformItem = true
            table.insert(tbl, {type = item.Type, variant = item.Variant, subtype = item.SubType})
        elseif rng == 3 then
            local item = Isaac.Spawn( EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_KEY, 0, InutilLib.room:FindFreePickupSpawnPosition(pos, 1), Vector(0,0), player ):ToPickup();
            --item.OptionsPickupIndex = 117
            yandereWaifu.GetEntityData(item).PlatformItem = true
            table.insert(tbl, {type = item.Type, variant = item.Variant, subtype = item.SubType})
        elseif rng == 4 then
            local item = Isaac.Spawn( EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, 0, InutilLib.room:FindFreePickupSpawnPosition(pos, 1), Vector(0,0), player ):ToPickup();
            --item.OptionsPickupIndex = 117
            yandereWaifu.GetEntityData(item).PlatformItem = true
            table.insert(tbl, {type = item.Type, variant = item.Variant, subtype = item.SubType})
        elseif rng == 5 then
            local item = Isaac.Spawn( EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_PILL, 0, InutilLib.room:FindFreePickupSpawnPosition(pos, 1), Vector(0,0), player ):ToPickup();
            --item.OptionsPickupIndex = 117
            yandereWaifu.GetEntityData(item).PlatformItem = true
            table.insert(tbl, {type = item.Type, variant = item.Variant, subtype = item.SubType})
        elseif rng == 6 then
            local item = Isaac.Spawn( EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_KEY, 0, InutilLib.room:FindFreePickupSpawnPosition(pos, 1), Vector(0,0), player ):ToPickup();
            --item.OptionsPickupIndex = 117
            yandereWaifu.GetEntityData(item).PlatformItem = true
            table.insert(tbl, {type = item.Type, variant = item.Variant, subtype = item.SubType})
        elseif rng == 7 then
            local item = Isaac.Spawn( EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, 0, InutilLib.room:FindFreePickupSpawnPosition(pos, 1), Vector(0,0), player ):ToPickup();
            --item.OptionsPickupIndex = 117
            yandereWaifu.GetEntityData(item).PlatformItem = true
            table.insert(tbl, {type = item.Type, variant = item.Variant, subtype = item.SubType})
        elseif rng == 8 then
            local item = Isaac.Spawn( EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, 0, InutilLib.room:FindFreePickupSpawnPosition(pos, 1), Vector(0,0), player ):ToPickup();
			--item.OptionsPickupIndex = 117
            yandereWaifu.GetEntityData(item).PlatformItem = true
            table.insert(tbl, {type = item.Type, variant = item.Variant, subtype = item.SubType})
        elseif rng == 9 then
            local item = Isaac.Spawn( EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, 0, InutilLib.room:FindFreePickupSpawnPosition(pos, 1), Vector(0,0), player ):ToPickup();
            --item.OptionsPickupIndex = 117
            yandereWaifu.GetEntityData(item).PlatformItem = true
            table.insert(tbl, {type = item.Type, variant = item.Variant, subtype = item.SubType})
        end
    end
    return tbl
end


local isspawningPlatform = false

yandereWaifu:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(_, old)
	if not old then
        RebekahLocalSavedata.Data.HasPlatformItems = nil
        RebekahLocalSavedata.Data.HasPlatformItemsTaken = nil
        isspawningPlatform = false
    end
end)

function GeneratePlatformRoom(isRoom)
    for p = 0, InutilLib.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		local data = yandereWaifu.GetEntityData(player)
		local room = InutilLib.game:GetRoom()
		if player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_PLATFORMCOTTA) and InutilLib.level:GetCurrentRoomIndex() == InutilLib.level:GetStartingRoomIndex() then
            local plat = spawnPlatform(InutilLib.room:GetCenterPos(), player)
            if InutilLib.room:IsFirstVisit() then 
                RebekahLocalSavedata.Data.HasPlatformItemsTaken = false
                isspawningPlatform = true
            end
            if not RebekahLocalSavedata.Data.HasPlatformItemsTaken then

                if isRoom then
                    print("A")
                    if not RebekahLocalSavedata.Data.HasPlatformItems then
                        print("b")
                        RebekahLocalSavedata.Data.HasPlatformItems = InutilLib.Deepcopy(generateItems(plat.Position))
                    else
                        print("c")
                        for i, v in pairs (RebekahLocalSavedata.Data.HasPlatformItems) do
                            print("BELLS")
                            local item = Isaac.Spawn( v.type, v.variant, v.subtype, InutilLib.room:FindFreePickupSpawnPosition(plat.Position, 1), Vector(0,0), nil ):ToPickup();
                            --item.OptionsPickupIndex = 117
                            yandereWaifu.GetEntityData(item).PlatformItem = true
                        end
                    end
                end
            end
            break
        end
    end
end

function yandereWaifu:PlatformCottaNewRoom()
	GeneratePlatformRoom(true)
end
yandereWaifu:AddCallback( ModCallbacks.MC_POST_NEW_ROOM, yandereWaifu.PlatformCottaNewRoom)

function yandereWaifu:PlatformCottaNewLevel()
    if isspawningPlatform then
        for p = 0, InutilLib.game:GetNumPlayers() - 1 do
            local player = Isaac.GetPlayer(p)
            player.Position = InutilLib.room:FindFreeTilePosition(InutilLib.room:GetGridPosition(62), 3)
        end
        if isPlatformValid() then
            for i = 0, math.random(0,1) do
                local bum = Isaac.Spawn( RebekahCurse.Enemies.ENTITY_REBEKAH_ENEMY, RebekahCurse.Enemies.ENTITY_BUMBAB, 0, InutilLib.room:FindFreePickupSpawnPosition(InutilLib.room:GetGridPosition(72), 1),  Vector(0,0), nil );
            end
       end
    end
end
yandereWaifu:AddCallback( ModCallbacks.MC_POST_NEW_LEVEL, yandereWaifu.PlatformCottaNewLevel)


yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local sprite = eff:GetSprite();
	local room =  InutilLib.room
	local data = yandereWaifu.GetEntityData(eff)
    eff.RenderZOffset = -100000
    if isPlatformValid() then
        if sprite:IsPlaying("Missing") then
            sprite:Play("Arrive", true)
        end
       --[[ RebekahLocalSavedata.Data.HasPlatformItems = {}
        for i, v in pairs (Isaac.GetRoomEntities()) do
            if v:ToPickup() then
                if eff.Position:Distance(v.Position) < 95 then
                    local item = v:ToPickup()
                    if not item.Touched then
                        table.insert(RebekahLocalSavedata.Data.HasPlatformItems, {type = item.Type, variant = item.Variant, subtype = item.SubType})
                    end
                end
            end
        end
        print("CECDD")]]
    else
        if sprite:IsFinished("Leave") then
            sprite:Play("Missing", true)
        end
        if sprite:IsPlaying("Missing") and not data.Missing then
            data.Missing = true
        elseif not data.Missing and not sprite:IsPlaying("Leave") then
            sprite:Play("Leave", true)
            RebekahLocalSavedata.Data.HasPlatformItems = {}
            for i, v in pairs (Isaac.GetRoomEntities()) do
                if v:ToPickup() then
                    if eff.Position:Distance(v.Position) < 95 then
                        local item = v:ToPickup()
                        if (item.Variant ~= 100 and not item.Touched) or (item.Variant == 100 and item.SubType > 0) then
                            local poof = Isaac.Spawn( EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 2, item.Position, Vector(0,0), nil );
                            table.insert(RebekahLocalSavedata.Data.HasPlatformItems, {type = item.Type, variant = item.Variant, subtype = item.SubType})
                            item:Remove()
                        end
                    end
                end
            end
        end
    end
    if sprite:IsFinished("Leave") then
        data.Missing = true
        sprite:Play("Missing", true)
    end
    if sprite:IsFinished("Arrive") then
        data.Missing = false
        sprite:Play("Idle", true)
    end
    if data.Missing then
        for p = 0, InutilLib.game:GetNumPlayers() - 1 do
            local player = Isaac.GetPlayer(p)
            if player.Position:Distance(eff.Position) < 75 and not (player:GetSprite():IsPlaying("FallIn") or player:GetSprite():IsPlaying("JumpOut") or player:GetSprite():IsPlaying("HoleDeath")) and player:GetDamageCooldown() <= 0 then
                player:AnimatePitfallIn()
                InutilLib.SetTimer(15, function()
                    player.Velocity = (Vector(10,10)):Resized(13)
                end)
            end
        end
    end
    
end, RebekahCurse.ENTITY_PLATFORMCAKE)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, function(_, pickup)
	local data = yandereWaifu.GetEntityData(pickup)
    if pickup:ToPickup() then
        if data.PlatformItem and not RebekahLocalSavedata.Data.HasPlatformItemsTaken then
            --InutilLib.SetTimer(60, function()
                RebekahLocalSavedata.Data.HasPlatformItemsTaken = true
            --end)
        end
    end
end)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, pickup)
    local data = yandereWaifu.GetEntityData(pickup)
    if pickup:ToPickup() then
        if data.PlatformItem and not RebekahLocalSavedata.Data.HasPlatformItemsTaken then
            if pickup.SubType == 0 then
                RebekahLocalSavedata.Data.HasPlatformItemsTaken = true
            end
        end
    end
end, 100)
