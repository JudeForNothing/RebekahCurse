
function yandereWaifu:AngelsMorningstarCache(player, cacheF) 
	local data = yandereWaifu.GetEntityData(player)
	if cacheF == CacheFlag.CACHE_FAMILIARS then
		if player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_ANGELSMORNINGSTAR) then
			print(RebekahCurse.Items.COLLECTIBLE_ANGELSMORNINGSTAR)
			player:CheckFamiliar(RebekahCurse.ENTITY_MORNINGSTAR, player:GetCollectibleNum(RebekahCurse.Items.COLLECTIBLE_ANGELSMORNINGSTAR), RNG(), nil, 1)
		end
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, yandereWaifu.AngelsMorningstarCache)