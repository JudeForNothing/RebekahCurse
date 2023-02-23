yandereWaifu:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_,player, cacheF) --The thing the checks and updates the game, i guess?
	local data = yandereWaifu.GetEntityData(player)
	if player:HasCollectible(RebekahCurseItems.COLLECTIBLE_BURGER) then
		if cacheF == CacheFlag.CACHE_SPEED then
			player.MoveSpeed = player.MoveSpeed + 0.2
		end
	end
end)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_,player)
	local data = yandereWaifu.GetEntityData(player)
	if player:HasCollectible(RebekahCurseItems.COLLECTIBLE_BURGER) and InutilLib.HasJustPickedCollectible( player, RebekahCurseItems.COLLECTIBLE_BURGER) then
		--player:AddNullCostume(RebekahCurseCostumes.CandyWeddingRing)
		local seed = ILIB.room:GetSpawnSeed()
		if math.ceil(seed % 3) == 0 then
			Isaac.Spawn( EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, TrinketType.TRINKET_EVES_BIRD_FOOT, player.Position,  Vector(0,0), player ):ToPickup();
		elseif math.ceil(seed % 3) == 1 then
			Isaac.Spawn( EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, TrinketType.TRINKET_CALLUS, player.Position,  Vector(0,0), player ):ToPickup();
		elseif math.ceil(seed % 3) == 2 then
			Isaac.Spawn( EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, TrinketType.TRINKET_GOAT_HOOF, player.Position,  Vector(0,0), player ):ToPickup();
		elseif math.ceil(seed % 3) == 3 then
			Isaac.Spawn( EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, TrinketType.TRINKET_LUCKY_TOE, player.Position,  Vector(0,0), player ):ToPickup();
		end
	end
end)