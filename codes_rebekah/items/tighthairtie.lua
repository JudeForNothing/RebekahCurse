yandereWaifu:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_,player, cacheF) --The thing the checks and updates the game, i guess?
	local data = yandereWaifu.GetEntityData(player)
	--love = power
	if player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_TIGHTHAIRTIE) then
		if cacheF == CacheFlag.CACHE_SPEED then
			player.MoveSpeed = player.MoveSpeed + 0.2 * player:GetCollectibleCount(RebekahCurse.Items.COLLECTIBLE_TIGHTHAIRTIE)
		end
		if cacheF == CacheFlag.CACHE_RANGE then
			player.TearRange = player.TearRange + 2 * player:GetCollectibleCount(RebekahCurse.Items.COLLECTIBLE_TIGHTHAIRTIE)
		end
	end
end)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_,player)
	local data = yandereWaifu.GetEntityData(player)
	if player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_TIGHTHAIRTIE) and InutilLib.HasJustPickedCollectible( player, RebekahCurse.Items.COLLECTIBLE_TIGHTHAIRTIE) then
		player:AddNullCostume(RebekahCurse.Costumes.TightHairtie)
	end
end)