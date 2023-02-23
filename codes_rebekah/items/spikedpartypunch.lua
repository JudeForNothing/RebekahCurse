yandereWaifu:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_,player)
    local room = Game():GetRoom();
	local data = yandereWaifu.GetEntityData(player)
	--[[if player:HasCollectible(RebekahCurseItems.COLLECTIBLE_SPIKEDPARTYPUNCH) and InutilLib.HasJustPickedCollectible( player, RebekahCurseItems.COLLECTIBLE_SPIKEDPARTYPUNCH) then
		player:AddNullCostume(RebekahCurseCostumes.LovePower)
	end]]
end)

yandereWaifu:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_,player, cacheF) --The thing the checks and updates the game, i guess?
	local data = yandereWaifu.GetEntityData(player)
	if player:HasCollectible(RebekahCurseItems.COLLECTIBLE_SPIKEDPARTYPUNCH) then
		if cacheF == CacheFlag.CACHE_DAMAGE then
			player.Damage = player.Damage + 1.40
		end
	end
end)