
function yandereWaifu:AngelsMorningstarCache(player, cacheF) 
	local data = yandereWaifu.GetEntityData(player)
	if cacheF == CacheFlag.CACHE_FAMILIARS then
		if player:HasCollectible(RebekahCurse.COLLECTIBLE_ANGELSMORNINGSTAR) then
			print(RebekahCurse.COLLECTIBLE_ANGELSMORNINGSTAR)
			player:CheckFamiliar(RebekahCurse.ENTITY_MORNINGSTAR, player:GetCollectibleNum(RebekahCurse.COLLECTIBLE_ANGELSMORNINGSTAR), RNG(), nil, 1)
		end
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, yandereWaifu.AngelsMorningstarCache)