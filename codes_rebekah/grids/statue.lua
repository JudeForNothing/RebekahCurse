StageAPI.AddCallback("RebekahCurse", "POST_SPAWN_CUSTOM_GRID", 1, function(customGrid)
    local grindex = customGrid.GridIndex
    local mantle = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.Statues.MOMS_STATUE, 0, InutilLib.room:GetGridPosition(grindex), Vector.Zero, nil):ToEffect() --body effect
end, RebekahCurse.Grids.MOMS_STATUE.Name)

StageAPI.AddCallback("RebekahCurse", "POST_SPAWN_CUSTOM_GRID", 1, function(customGrid)
    local grindex = customGrid.GridIndex
    local mantle = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.Statues.MOMS_STATUE, 1, InutilLib.room:GetGridPosition(grindex), Vector.Zero, nil):ToEffect() --body effect
end, RebekahCurse.Grids.DADS_STATUE.Name)

StageAPI.AddCallback("RebekahCurse", "POST_CUSTOM_GRID_UPDATE", 1, function(customGrid)
    for i=0, InutilLib.game:GetNumPlayers()-1 do
        local player = Isaac.GetPlayer(i)
        local data = yandereWaifu.GetEntityData(player)
        if player.Position:Distance(customGrid.Position) < 35 and not data.PersistentPlayerData.HasMomsApproval then
            InutilLib.game:GetHUD():ShowItemText("Approval of Mom","May her devotion protect your path to heaven")
            data.PersistentPlayerData.HasMomsApproval = true
            player:AddBrokenHearts(3)
        end
    end
end, RebekahCurse.Grids.MOMS_STATUE.Name)

StageAPI.AddCallback("RebekahCurse", "POST_CUSTOM_GRID_UPDATE", 1, function(customGrid)
    for i=0, InutilLib.game:GetNumPlayers()-1 do
        local player = Isaac.GetPlayer(i)
        local data = yandereWaifu.GetEntityData(player)
        if player.Position:Distance(customGrid.Position) < 35 and not data.PersistentPlayerData.HasDadsApproval and player:GetNumCoins() >= 15  then
            InutilLib.game:GetHUD():ShowItemText("Approval of Dad","May his imagination path you with protection")
            data.PersistentPlayerData.HasDadsApproval = true
            player:AddCoins(-15)
        end
    end
end, RebekahCurse.Grids.DADS_STATUE.Name)


yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local sprite = eff:GetSprite()
	local data = yandereWaifu.GetEntityData(eff)

    if eff.FrameCount == 1 then
        sprite:Play("Idle", true)
        data.state = 0
    end
end, RebekahCurse.Statues.MOMS_STATUE)

--[[if StageAPI and StageAPI.Loaded then
    yandereWaifu:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function() --spawn statues
        if InutilLib.room:GetType() == RoomType.ROOM_SACRIFICE and InutilLib.room:IsFirstVisit() then
            local grindex = 52
            local rock = Isaac.Spawn(656, 178, 1, InutilLib.room:GetGridPosition(grindex), Vector.Zero, nil):ToNPC()
        end
    end)
end]]

yandereWaifu:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
    for i=0, InutilLib.game:GetNumPlayers()-1 do
        local player = Isaac.GetPlayer(i)
        local data = yandereWaifu.GetEntityData(player)
        if data.PersistentPlayerData.HasMomsApproval then
            local count = 8
            for i = 1, count*2 do
				local heart = yandereWaifu.SpawnSilphiumHeart(player)
            end
        end
    end
end)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)
	local pldata = yandereWaifu.GetEntityData(player)
    local direction = player:GetShootingInput():GetAngleDegrees()
   --[[ if player:HasCollectible(CollectibleType.COLLECTIBLE_MARKED) then 
        direction = InutlibLib.DirToVec(player:GetAimDirection()):GetAngleDegrees()
    end]]
    --[[if player:GetFireDirection() > -1 and player.FrameCount % 15 == 0 and math.random(20) == 20 and not InutilLib.room:IsClear() then --if not firing
        player:UseCard(Card.CARD_HIGH_PRIESTESS, UseFlag.USE_NOANIM|UseFlag.USE_NOANNOUNCER)
    end]]
end)

function yandereWaifu:useItemWithMomsApproval(collItem, rng, player, flag, slot)
	local data = yandereWaifu.GetEntityData(player)
	if data.PersistentPlayerData.HasMomsApproval then
        local num = InutilLib.config:GetCollectible(collItem).MaxCharges
        for i = 1, num do
            player:AddBlueSpider(player.Position)
        end
    end
end
yandereWaifu:AddCallback( ModCallbacks.MC_USE_ITEM, yandereWaifu.useItemWithMomsApproval);
