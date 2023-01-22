
yandereWaifu:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_,player)
	--local player = Isaac.GetPlayer(0);
    local room = Game():GetRoom();
	local data = yandereWaifu.GetEntityData(player)
	--items function!
	--if player:HasCollectible(RebekahCurseItems.COLLECTIBLE_LUNCHBOX) then
		if player:HasCollectible(RebekahCurseItems.COLLECTIBLE_LUNCHBOX) and InutilLib.HasJustPickedCollectible( player, RebekahCurseItems.COLLECTIBLE_LUNCHBOX ) then
			for i = 0, 2, 1 do
				local spawnPosition = room:FindFreePickupSpawnPosition(player.Position, 1);
				local newpickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, RebekahMirrorHeartDrop[math.random(1,6)], spawnPosition, Vector(0,0), player)
			end
			player:AddNullCostume(RebekahCurseCostumes.LunchboxCos)
		end
	--end
end)