
yandereWaifu:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_,player)
	--local player = Isaac.GetPlayer(0);
    local room = Game():GetRoom();
	local data = yandereWaifu.GetEntityData(player)
	--items function!
	if player:HasCollectible(RebekahCurse.COLLECTIBLE_BASKETOFEGGS) then
		if InutilLib.HasJustPickedCollectible( player, RebekahCurse.COLLECTIBLE_BASKETOFEGGS ) then
			for i = 0, 4, 1 do
				local spawnPosition = room:FindFreePickupSpawnPosition(player.Position, 1);
				yandereWaifu.SpawnEasterEgg(spawnPosition, player)
				--local newpickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, RebekahCurse.CARD_EASTEREGG, spawnPosition, Vector(0,0), player)
			end
			player:AddNullCostume(RebekahCurseCostumes.BasketOfEggs)
		end
	end
end)