yandereWaifu:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
	for p = 0, InutilLib.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		local data = yandereWaifu.GetEntityData(player)
		if player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_IOU) and InutilLib.level:GetStage() <= 6 then
			local seed = RNG():SetSeed(Game():GetSeeds():GetStartSeed(), 25)
			local itemPool = yandereWaifu.GenerateQualityFourItem(ItemPoolType.POOL_SHOP)
			local item = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, itemPool, InutilLib.room:GetCenterPos() + Vector(0,80), Vector.Zero, nil):ToPickup()
		end
	end
end)
