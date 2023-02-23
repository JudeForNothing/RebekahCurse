local teleport = true
local willdupe = true
yandereWaifu:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function(_) --The thing the checks and updates the game, i guess?
	local room = Game():GetRoom();
	for p = 0, ILIB.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		local data = yandereWaifu.GetEntityData(player)
		if player:HasCollectible(RebekahCurseItems.COLLECTIBLE_HEARTACHES) then
			local items = InutilLib.CollectPlayerItems(player)
			--[[for i, v in pairs (items) do
				Isaac.GetItemConfig():GetCollectible(v)
			end]]
			for i = 0, math.random(2,4) do
				local success = false
				for j = 0, 8 do
					if ILIB.room:IsDoorSlotAllowed(j) then
						local roomIdx = ILIB.level:GetRandomRoomIndex(false, math.random(1,100))
						if ILIB.room.RoomType ~= RoomType.ROOM_BOSS and (ILIB.level:GetRoomByIdx(roomIdx).Flags | RoomDescriptor.FLAG_RED_ROOM ~= 0) then
							success = ILIB.level:MakeRedRoomDoor((roomIdx), j)
							if success then break end
						else
							i = i - 1
							break
						end
					end
				end
				if not success then
					i = i - 1
				end
			end
		end
	end
	willdupe = true
end)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function(_) --The thing the checks and updates the game, i guess?
	local room = Game():GetRoom();
	for p = 0, ILIB.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		local data = yandereWaifu.GetEntityData(player)
		if player:HasCollectible(RebekahCurseItems.COLLECTIBLE_HEARTACHES) then
			if not willdupe and math.random(1,10) == 1 then
				willdupe = true
			end
			--if teleport then
			--	teleport = false
			--	ILIB.game:ChangeRoom(ILIB.level:GetRandomRoomIndex(false, math.random(1,100)))
				--:MoveToRandomRoom(IAmErrorRoom, Seed, Player)
			--end
			if math.random(1,6) == 6 then
				local desc = ILIB.level:GetRoomByIdx(ILIB.level:GetRandomRoomIndex(false, math.random(1,100)))
				if desc.DisplayFlags > 0 then --Reveal Room if unrevealed	
					--[[desc.DisplayFlags = desc.DisplayFlags | 5
				else]]
					desc.DisplayFlags = 0
				end
			end
			if ILIB.room:IsClear() and math.random(1,10) == 1 and ILIB.room.RoomType ~= RoomType.ROOM_BOSS then
				player:UseActiveItem(CollectibleType.COLLECTIBLE_D7, false, false, false, false, -1, 0)
			end
			if not data.PersistentPlayerData.GoodiesContents then data.PersistentPlayerData.GoodiesContents = {} end

			local hinto = false
			if data.PersistentPlayerData.GoodiesContents and willdupe then
				local roomInfo = data.PersistentPlayerData.GoodiesContents[ILIB.level:GetCurrentRoomDesc().SafeGridIndex]
				if roomInfo then
					for _, e in ipairs(data.PersistentPlayerData.GoodiesContents[ILIB.level:GetCurrentRoomDesc().SafeGridIndex]) do
						Isaac.Spawn(e.type, e.var, e.sub, ILIB.room:FindFreePickupSpawnPosition(e.pos, 10 ), Vector.Zero, nil)
					end
					data.PersistentPlayerData.GoodiesContents[ILIB.level:GetCurrentRoomDesc().SafeGridIndex] = nil
					hinto = true
				end
				willdupe = false
			end
			if data.PersistentPlayerData.GoodiesContents and not hinto then
				data.PersistentPlayerData.GoodiesContents[ILIB.level:GetCurrentRoomDesc().SafeGridIndex] = {}
				for _,e in ipairs(Isaac.GetRoomEntities()) do
					if e.Type == EntityType.ENTITY_PICKUP then 
						table.insert(data.PersistentPlayerData.GoodiesContents[ILIB.level:GetCurrentRoomDesc().SafeGridIndex], {pos = e.Position, type = e.Type, var = e.Variant, sub = e.SubType})
					end
				end
			end
		end
	end
end)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_,player)
	local data = yandereWaifu.GetEntityData(player)
	if player:HasCollectible(RebekahCurseItems.COLLECTIBLE_HEARTACHES) and InutilLib.HasJustPickedCollectible( player, RebekahCurseItems.COLLECTIBLE_HEARTACHES) then
		--player:AddNullCostume(RebekahCurseCostumes.CandyWeddingRing)
	end
	--if player.FrameCount % 15 == 0 and math.random(1,100) == 100 then
	--	teleport = true
	--end
end)