yandereWaifu:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function(_,player) --peffect cant detect player dying for some reason
	local data = yandereWaifu.GetEntityData(player)
	--COLLECTIBLE_REBEKAHSFAVORITE
	if player:HasCollectible(RebekahCurse.COLLECTIBLE_REBEKAHSFAVORITE) and InutilLib.HasJustPickedCollectible( player, RebekahCurse.COLLECTIBLE_REBEKAHSFAVORITE) then
		InutilLib:SpawnCustomStrawman(RebekahCurse.HAPPYJACOB, player, true)
	end
	if player:GetPlayerType() == RebekahCurse.HAPPYJACOB then
		if data.CollectibleCount then
			if player:GetCollectibleCount() ~= data.CollectibleCount then
				data.CollectibleCount = player:GetCollectibleCount()
				player:AddCacheFlags(CacheFlag.CACHE_RANGE);
				player:AddCacheFlags(CacheFlag.CACHE_SPEED);
				player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY);
				player:AddCacheFlags(CacheFlag.CACHE_LUCK);
				player:AddCacheFlags(CacheFlag.CACHE_DAMAGE);
				player:EvaluateItems()
			end
		else
			data.CollectibleCount = player:GetCollectibleCount()
		end

		if player:IsDead() and (player:GetSprite():IsFinished("LostDeath") or player:GetSprite():IsFinished("Death")) then
			player.Parent:ToPlayer():RemoveCollectible(RebekahCurse.COLLECTIBLE_REBEKAHSFAVORITE)
		end
	end
end)

local function updateJacobHair(player)
	local hairpath='gfx/characters/costumes/happyjacobhair.png'
	local config=Isaac.GetItemConfig():GetNullItem(52)
	player:ReplaceCostumeSprite(config,hairpath,0)
end

function yandereWaifu:happyjacobcache(player, cacheF) --The thing the checks and updates the game, i guess?
	local data = yandereWaifu.GetEntityData(player)
	
	if player:GetPlayerType() == RebekahCurse.HAPPYJACOB then
	--print(cacheF)
	--print(CacheFlag.CACHE_ALL)
		if cacheF == CacheFlag.CACHE_FIREDELAY then--stupid workaround cuz right now CACHE_ALL isnt working
			player.MaxFireDelay = player.MaxFireDelay - (player:GetCollectibleCount())/2
		end
		if cacheF == CacheFlag.CACHE_SPEED then
			player.MoveSpeed = player.MoveSpeed + (player:GetCollectibleCount())/5
		end
		if cacheF == CacheFlag.CACHE_RANGE then
			player.TearRange = player.TearRange + (player:GetCollectibleCount())/2
		end
		if cacheF == CacheFlag.CACHE_LUCK then
			player.Luck = player.Luck + (player:GetCollectibleCount())/2
		end
		if cacheF == CacheFlag.CACHE_DAMAGE then
			player.Damage = player.Damage + (player:GetCollectibleCount())/2
		end
		--[[print(player.MaxFireDelay)
		print(player.MoveSpeed)
		print(player.TearRange)
		print(player.Luck)
		print("pai peko")]]
		updateJacobHair(player)
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, yandereWaifu.happyjacobcache)


yandereWaifu:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, function(_,player)
	if player:GetPlayerType() == RebekahCurse.HAPPYJACOB then 
		updateJacobHair(player)
	end
end)