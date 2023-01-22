local cache = {}
function cache.SetTaintedRebekahBaseStats(cacheF, player)
local data = yandereWaifu.GetEntityData(player)
	if yandereWaifu.IsTaintedRebekah(player) then
		--[[if cacheF == CacheFlag.CACHE_DAMAGE then
			player.Damage = player.Damage * 0.5
		end]]
		if cacheF == CacheFlag.CACHE_SPEED then
			player.MoveSpeed = player.MoveSpeed + 0.15
		end
		if cacheF == CacheFlag.CACHE_FIREDELAY then
			player.MaxFireDelay = player.MaxFireDelay + 5
		end
		if cacheF == CacheFlag.CACHE_LUCK then
			player.Luck = player.Luck + 1
		end
	end
end

return cache