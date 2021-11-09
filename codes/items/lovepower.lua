yandereWaifu:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_,player)
	--local player = Isaac.GetPlayer(0);
    local room = Game():GetRoom();
	local data = yandereWaifu.GetEntityData(player)
	if player:HasCollectible(RebekahCurse.COLLECTIBLE_POWERLOVE) and InutilLib.HasJustPickedCollectible( player, RebekahCurse.COLLECTIBLE_POWERLOVE) then
		player:AddNullCostume(RebekahCurseCostumes.LovePower)
	end
	--love = Power
	local H = player:GetHearts()
	if player:HasCollectible(RebekahCurse.COLLECTIBLE_POWERLOVE) then
		if data.H ~= H then
			player:AddCacheFlags(CacheFlag.CACHE_DAMAGE);
			player:AddCacheFlags(CacheFlag.CACHE_SPEED);
			player:EvaluateItems()
		end
		data.H = H
	elseif not player:HasCollectible(RebekahCurse.COLLECTIBLE_POWERLOVE) and data.H then
		data.H = nil
		player:AddCacheFlags(CacheFlag.CACHE_DAMAGE);
		player:AddCacheFlags(CacheFlag.CACHE_SPEED);
		player:EvaluateItems()
	end
end)

yandereWaifu:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_,player, cacheF) --The thing the checks and updates the game, i guess?
	local data = yandereWaifu.GetEntityData(player)
	--love = power
	if player:HasCollectible(RebekahCurse.COLLECTIBLE_POWERLOVE) then
		local maxH, H = player:GetMaxHearts(), player:GetHearts()
		if maxH >= 1 then
			local emptyH, fullH = (maxH - H), H 
			if cacheF == CacheFlag.CACHE_SPEED then
				player.MoveSpeed = player.MoveSpeed + (0.02 * emptyH)
			end
			if cacheF == CacheFlag.CACHE_DAMAGE then
				player.Damage = player.Damage + (0.20 * H)
			end
		end
	end
end)
--yandereWaifu:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, yandereWaifu.itemcacheregister)