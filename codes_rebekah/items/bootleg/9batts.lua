
yandereWaifu:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
	for p = 0, InutilLib.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		local data = yandereWaifu.GetEntityData(player)
		if player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_9BATTS) then
			local rng = player:GetCollectibleRNG(RebekahCurse.Items.COLLECTIBLE_9BATTS)
            for i = 1, 9 do
				local pickupRng = rng:RandomInt(2) + 1
                local newColl = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_LIL_BATTERY, pickupRng, InutilLib.room:FindFreePickupSpawnPosition(player.Position, 40, true), Vector.Zero, player)
            end
		end
	end
end)
