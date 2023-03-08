yandereWaifu:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function(_,player)
	--local player = Isaac.GetPlayer(0);
    local room = Game():GetRoom();
	local data = yandereWaifu.GetEntityData(player)

	if player:HasTrinket(RebekahCurseTrinkets.TRINKET_NOSCOPE) then
		local direction = InutilLib.DirToVec(player:GetFireDirection())
		if data.NoScopeBuff == nil then 
			data.NoScopeBuff = false 
			data.NoScopeDir = direction
		end
		if player:HasCollectible(CollectibleType.COLLECTIBLE_MARKED) then
			direction = player:GetAimDirection()
		end
		if data.NoScopeDir and data.NoScopeDir.X ~= direction.X and data.NoScopeDir.Y ~= direction.Y then
			data.NoScopeBuff = true
			data.NoScopeBuffFrameLeniency = player.FrameCount
			player:AddCacheFlags(CacheFlag.CACHE_DAMAGE);
			player:EvaluateItems()
			if not data.SpinCount then data.SpinCount = 0 end
			data.SpinCount = data.SpinCount + 1
		else
			if data.NoScopeBuff and data.NoScopeBuffFrameLeniency + 15 < player.FrameCount then
				data.NoScopeBuff = false
				player:AddCacheFlags(CacheFlag.CACHE_DAMAGE);
				player:EvaluateItems()
				data.SpinCount = 0
			end
		end
		data.NoScopeDir = direction
	end
end)


function yandereWaifu:NoScopeDamageCache(player, cacheF)
	local data = yandereWaifu.GetEntityData(player)
    if data.NoScopeBuff then
        if cacheF == CacheFlag.CACHE_DAMAGE then
			if data.SpinCount >= 3 then
				player.Damage = player.Damage + 4
			else
            	player.Damage = player.Damage + 2
			end
        end
    end
end
yandereWaifu:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, yandereWaifu.NoScopeDamageCache)