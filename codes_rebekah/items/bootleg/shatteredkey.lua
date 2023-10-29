
yandereWaifu:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
	for p = 0, InutilLib.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		local data = yandereWaifu.GetEntityData(player)
		if player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_SHATTEREDKEY) then
            for i = 1, math.random(4,6) do
                local newColl = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Card.CARD_CRACKED_KEY, InutilLib.room:FindFreePickupSpawnPosition(player.Position, 40, true), Vector.Zero, player)
            end
		end
	end
end)
