yandereWaifu:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_,player)
    local room = Game():GetRoom();
	local data = yandereWaifu.GetEntityData(player)
	if InutilLib.HasJustPickedCollectible( player, RebekahCurse.COLLECTIBLE_NUTWATER ) then
			for i = 0, 2, 1 do
				local spawnPosition = room:FindFreePickupSpawnPosition(player.Position, 1);
				local newpickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, RebekahMirrorHeartDrop[math.random(1,6)], spawnPosition, Vector(0,0), player)
			end
	end
end)