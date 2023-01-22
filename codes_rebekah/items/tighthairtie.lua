yandereWaifu:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_,player, cacheF) --The thing the checks and updates the game, i guess?
	local data = yandereWaifu.GetEntityData(player)
	--love = power
	if player:HasCollectible(RebekahCurseItems.COLLECTIBLE_TIGHTHAIRTIE) then
		if cacheF == CacheFlag.CACHE_SPEED then
			player.MoveSpeed = player.MoveSpeed + 0.2 * player:GetCollectibleCount(RebekahCurseItems.COLLECTIBLE_TIGHTHAIRTIE)
		end
		if cacheF == CacheFlag.CACHE_RANGE then
			player.TearRange = player.TearRange + 2 * player:GetCollectibleCount(RebekahCurseItems.COLLECTIBLE_TIGHTHAIRTIE)
		end
	end
end)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_,player)
	local data = yandereWaifu.GetEntityData(player)
	if player:HasCollectible(RebekahCurseItems.COLLECTIBLE_TIGHTHAIRTIE) and InutilLib.HasJustPickedCollectible( player, RebekahCurseItems.COLLECTIBLE_TIGHTHAIRTIE) then
		player:AddNullCostume(RebekahCurseCostumes.TightHairtie)
	end
end)