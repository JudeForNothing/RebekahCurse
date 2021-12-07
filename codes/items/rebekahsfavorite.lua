yandereWaifu:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_,player)
	local data = yandereWaifu.GetEntityData(player)
	--COLLECTIBLE_REBEKAHSFAVORITE
	if InutilLib.HasJustPickedCollectible( player, RebekahCurse.COLLECTIBLE_REBEKAHSFAVORITE) then
		InutilLib:SpawnCustomStrawman(RebekahCurse.HAPPYJACOB, player, true)
	end
	if player:GetPlayerType() == RebekahCurse.HAPPYJACOB then
		if data.CollectibleCount then
			if player:GetCollectibleCount() ~= data.CollectibleCount then
				data.CollectibleCount = player:GetCollectibleCount()
				player:AddCacheFlags(CacheFlag.CACHE_RANGE);
				player:EvaluateItems()
				player:AddCacheFlags(CacheFlag.CACHE_SPEED);
				player:EvaluateItems()
				player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY);
				player:EvaluateItems()
				player:AddCacheFlags(CacheFlag.CACHE_LUCK);
				player:EvaluateItems()
			end
		else
			data.CollectibleCount = player:GetCollectibleCount()
		end
	end
end)


function yandereWaifu:happyjacobcache(player, cacheF) --The thing the checks and updates the game, i guess?
	local data = yandereWaifu.GetEntityData(player)
	
	if player:GetPlayerType() == RebekahCurse.HAPPYJACOB then
	--print(cacheF)
	--print(CacheFlag.CACHE_ALL)
		if cacheF == CacheFlag.CACHE_FIREDELAY then--stupid workaround cuz right now CACHE_ALL isnt working
			player.MaxFireDelay = player.MaxFireDelay + (player:GetCollectibleCount())/10
		end
		if cacheF == CacheFlag.CACHE_SPEED then
			player.MoveSpeed = player.MoveSpeed + (player:GetCollectibleCount())/20
		end
		if cacheF == CacheFlag.CACHE_RANGE then
			player.TearRange = player.TearRange + (player:GetCollectibleCount())/10
		end
		if cacheF == CacheFlag.CACHE_LUCK then
			player.Luck = player.Luck + (player:GetCollectibleCount())/10
		end
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, yandereWaifu.happyjacobcache)