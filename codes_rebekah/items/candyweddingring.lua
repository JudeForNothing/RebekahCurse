yandereWaifu:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_,player, cacheF) --The thing the checks and updates the game, i guess?
	local data = yandereWaifu.GetEntityData(player)
	--love = power
	if player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_CANDYWEDDINGRING) then
		if cacheF == CacheFlag.CACHE_SPEED then
			player.MoveSpeed = player.MoveSpeed + 0.2
		end
	end
end)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_,player)
	local data = yandereWaifu.GetEntityData(player)
	--[[if player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_CANDYWEDDINGRING) and InutilLib.HasJustPickedCollectible( player, RebekahCurse.Items.COLLECTIBLE_CANDYWEDDINGRING) then
		player:AddNullCostume(RebekahCurse.Costumes.CandyWeddingRing)
	end]]
end)