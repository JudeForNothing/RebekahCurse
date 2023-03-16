function yandereWaifu:IsaacsLocksNewRoom()
	for p = 0, InutilLib.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		local data = yandereWaifu.GetEntityData(player)
		local room = InutilLib.game:GetRoom()
		if player:HasTrinket(RebekahCurseTrinkets.TRINKET_ISAACSLOCKS) and room:IsFirstVisit() then
			local rng = math.random(1,2)
			local seed = room:GetSpawnSeed()
			--print(room:GetSpawnSeed())
			if (room:GetType() == RoomType.ROOM_SHOP or room:GetType() == RoomType.ROOM_BOSS or room:GetType() == RoomType.ROOM_TREASURE) or (seed/100000000 < 5 and (room:GetType() == RoomType.ROOM_DEVIL or room:GetType() == RoomType.ROOM_ANGEL)) then
				local slot = Isaac.Spawn(EntityType.ENTITY_SLOT, 10, 0, room:FindFreePickupSpawnPosition(room:GetCenterPos(), 1), Vector(0,0), player)
			end
		end
	end
end
yandereWaifu:AddCallback( ModCallbacks.MC_POST_NEW_ROOM, yandereWaifu.IsaacsLocksNewRoom)