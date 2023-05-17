local item = nil

RebekahCurse.LaughList = {
    RebekahCurse.Items.COLLECTIBLE_SHATTEREDKEY,
	RebekahCurse.Items.COLLECTIBLE_UNSTABLECANDLE,
	RebekahCurse.Items.COLLECTIBLE_OINKYBANK,
	RebekahCurse.Items.COLLECTIBLE_9BATTS,
	RebekahCurse.Items.COLLECTIBLE_ARESBOX,
	RebekahCurse.Items.COLLECTIBLE_SEABATTERY,
	RebekahCurse.Items.COLLECTIBLE_VITAMINC,
	RebekahCurse.Items.COLLECTIBLE_IOU,
	RebekahCurse.Items.COLLECTIBLE_SUSPICIOUSSTEW,
	RebekahCurse.Items.COLLECTIBLE_FOMOBOMBS,
}

yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local sprite = eff:GetSprite()
	local data = yandereWaifu.GetEntityData(eff)

    if eff.FrameCount == 1 then
        sprite:Play("SmallIdle", true)
        data.state = 0
    end
    if data.state == 0 then
        if eff.FrameCount % 30 == 0 and math.random(1,3) == 3 then
            data.state = 1
        end
        if not sprite:IsPlaying("SmallIdle") then
            sprite:Play("SmallIdle", true)
        end
    elseif data.state == 1 then
        if sprite:IsFinished("SmallSmoke") then
            data.state = 0
        elseif not sprite:IsPlaying("SmallSmoke") then
            sprite:Play("SmallSmoke", true)
        end
    elseif data.state == 2 then
        if sprite:IsFinished("SmallApplause") then
            data.state = 0
        elseif not sprite:IsPlaying("SmallApplause") then
            sprite:Play("SmallApplause", true)
        end
        if sprite:IsEventTriggered("Clap") then
            InutilLib.SFX:Play( RebekahCurse.Sounds.SOUND_LABAN_CLAP, 1, 0, false, 1 );
        end
    elseif data.state == 3 then
        if sprite:IsFinished("SmallLaugh") then
            data.state = 0
            if math.random(1,3) == 3 then
                InutilLib.SFX:Play( RebekahCurse.Sounds.SOUND_LABAN_COUGH, 1, 0, false, 1 );
            end
        elseif not sprite:IsPlaying("SmallLaugh") then
            sprite:Play("SmallLaugh", true)
        end
        if sprite:IsEventTriggered("Laugh") then
            --InutilLib.SFX:Play( RebekahCurse.Sounds.SOUND_LABAN_WHEEZE_1, 1, 0, false, 1 );
            InutilLib.SFX:Play( RebekahCurse.Sounds.SOUND_LABAN_LAUGH, 1, 0, false, 1 );
        end
        --[[if sprite:IsEventTriggered("Laugh2") then
            InutilLib.SFX:Play( RebekahCurse.Sounds.SOUND_LABAN_WHEEZE_2, 1, 0, false, 1 );
        end]]
    end
    if item then
        print("data.CacheReaction")
        data.CacheReaction = 30
        data.item = item
        item = nil
    end
    if data.CacheReaction  then 
        data.CacheReaction = data.CacheReaction  - 1
    end
    if data.CacheReaction and data.CacheReaction <= 0 then
        local laugh = false
        for i, v in pairs (RebekahCurse.LaughList) do
            if v == data.item then
                laugh = true
            end
        end
        if laugh then
            data.state = 3
        else
            data.state = 2
        end
        data.item = nil
        data.CacheReaction = nil
    end
end, RebekahCurse.ENTITY_LABAN_DUDE);

yandereWaifu:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_,player)
	local data = yandereWaifu.GetEntityData(player)
    if data.PersistentPlayerData.currentQueuedShopItem then
        item = data.PersistentPlayerData.currentQueuedShopItem
        data.PersistentPlayerData.currentQueuedShopItem = nil
    end
end)

StageAPI.AddCallback("RebekahCurse", "POST_SPAWN_CUSTOM_GRID", 1, function(customGrid)
    local grindex = customGrid.GridIndex
    local mantle = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_LABAN_DUDE, 0, InutilLib.room:GetGridPosition(grindex), Vector.Zero, nil):ToEffect() --body effect
end, RebekahCurse.Grids.LABAN_DUDE.Name)