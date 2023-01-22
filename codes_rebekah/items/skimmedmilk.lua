
yandereWaifu:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, function(_,  tr)
    if not tr.SpawnerEntity then return end
	local player = tr.SpawnerEntity:ToPlayer()
	local pldata = yandereWaifu.GetEntityData(player)
    local data = yandereWaifu.GetEntityData(tr)
	if player:HasCollectible(RebekahCurseItems.COLLECTIBLE_SKIMMEDMILK) then
		if tr.FrameCount == 1 then
            data.OriginalDamage = tr.CollisionDamage
        else
            if data.OriginalDamage then
                tr.CollisionDamage = data.OriginalDamage + (tr.Velocity:Length())/4
            end
        end
	end
end);

yandereWaifu:AddCallback(ModCallbacks.MC_POST_LASER_UPDATE, function(_,  lz)
	local player = lz.SpawnerEntity:ToPlayer()
	local pldata = yandereWaifu.GetEntityData(player)
    local data = yandereWaifu.GetEntityData(lz)
	if player:HasCollectible(RebekahCurseItems.COLLECTIBLE_SKIMMEDMILK) then
		if lz.FrameCount == 1 then
            data.OriginalDamage = lz.CollisionDamage
        end
	end
end);


yandereWaifu:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE, function(_,  bb)
    if bb.SpawnerEntity and bb.SpawnerEntity:ToPlayer() then
        local player = bb.SpawnerEntity:ToPlayer()
        local pldata = yandereWaifu.GetEntityData(player)
        local data = yandereWaifu.GetEntityData(bb)
        if player:HasCollectible(RebekahCurseItems.COLLECTIBLE_SKIMMEDMILK) then
            if bb.FrameCount == 1 then
                data.OriginalDamage = bb.ExplosionDamage
            else
                if data.OriginalDamage then
                    bb.ExplosionDamage = data.OriginalDamage + (bb.Velocity:Length())/2
                end
            end
        end
    end
end);

yandereWaifu:AddCallback(ModCallbacks.MC_POST_KNIFE_UPDATE, function(_,  kn)
	local player = kn.SpawnerEntity:ToPlayer()
	local pldata = yandereWaifu.GetEntityData(player)
    local data = yandereWaifu.GetEntityData(kn)
	if player:HasCollectible(RebekahCurseItems.COLLECTIBLE_SKIMMEDMILK) then
		if not data.OriginalDamage or data.OriginalDamage ~= player.Damage then
            data.OriginalDamage = kn.CollisionDamage
        else
            if data.OriginalDamage then
                kn.CollisionDamage = data.OriginalDamage + (kn.Velocity:Length())/4
            end
        end
	end
end);