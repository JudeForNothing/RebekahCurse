yandereWaifu:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_,player, cacheF) --The thing the checks and updates the game, i guess?
	local data = yandereWaifu.GetEntityData(player)
	if player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_MILKWINE) and data.MilkWineMultiplier then
		if cacheF == CacheFlag.CACHE_DAMAGE then
			player.Damage = player.Damage * data.MilkWineMultiplier
		end
	end
end)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_,player)
	local data = yandereWaifu.GetEntityData(player)
	if player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_MILKWINE) and InutilLib.HasJustPickedCollectible( player, RebekahCurse.Items.COLLECTIBLE_MILKWINE) then
		--player:AddNullCostume(RebekahCurse.Costumes.CandyWeddingRing)
	end
    if player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_MILKWINE) and player.FrameCount % 15 == 0 then
        local rng = math.random(1,100)
        if not data.MilkWineMultiplier then data.MilkWineMultiplier = 1 end
        if rng <= 50 then
            data.MilkWineMultiplier = 1
        elseif rng <= 60 then
            data.MilkWineMultiplier = 0.3
        elseif rng <= 70 then
            data.MilkWineMultiplier = 0.2
        elseif rng <= 80 then
            data.MilkWineMultiplier = 0.1
        elseif rng <= 90 then
            data.MilkWineMultiplier = 1.5
        elseif rng == 100 then
            data.MilkWineMultiplier = 3
        end
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE);
		player:EvaluateItems()
    end
end)