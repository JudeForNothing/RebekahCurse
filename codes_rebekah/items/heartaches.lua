local teleport = true
local willdupe = true
yandereWaifu:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function(_) --The thing the checks and updates the game, i guess?
	local room = Game():GetRoom();
	for p = 0, InutilLib.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		local data = yandereWaifu.GetEntityData(player)
		if player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_HEARTACHES) then
			local items = InutilLib.CollectPlayerItems(player)
			--[[for i, v in pairs (items) do
				Isaac.GetItemConfig():GetCollectible(v)
			end]]
			for i = 0, math.random(2,4) do
				local success = false
				for j = 0, 8 do
					if InutilLib.room:IsDoorSlotAllowed(j) then
						local roomIdx = InutilLib.level:GetRandomRoomIndex(false, math.random(1,100))
						if InutilLib.room.RoomType ~= RoomType.ROOM_BOSS and (InutilLib.level:GetRoomByIdx(roomIdx).Flags | RoomDescriptor.FLAG_RED_ROOM ~= 0) then
							success = InutilLib.level:MakeRedRoomDoor((roomIdx), j)
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

			if data.PersistentPlayerData.GoodiesContents then
				for i = 0, 100 do
					local roomInfo = data.PersistentPlayerData.GoodiesContents[i]
					if roomInfo --[[and math.random(1,3) == 3]] then
						for _, e in ipairs(data.PersistentPlayerData.GoodiesContents[i]) do
							Isaac.Spawn(e.type, e.var, e.sub, InutilLib.room:FindFreePickupSpawnPosition(player.Position, 10 ), Vector.Zero, nil)
						end
						data.PersistentPlayerData.GoodiesContents[i] = nil
					end
				end
			end
		end
	end
	willdupe = true
end)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function(_) --The thing the checks and updates the game, i guess?
	local room = Game():GetRoom();
	for p = 0, InutilLib.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		local data = yandereWaifu.GetEntityData(player)
		if player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_HEARTACHES) then
			if not willdupe and math.random(1,10) == 1 then
				willdupe = true
			end
			--if teleport then
			--	teleport = false
			--	InutilLib.game:ChangeRoom(InutilLib.level:GetRandomRoomIndex(false, math.random(1,100)))
				--:MoveToRandomRoom(IAmErrorRoom, Seed, Player)
			--end
			if math.random(1,6) == 6 then
				local desc = InutilLib.level:GetRoomByIdx(InutilLib.level:GetRandomRoomIndex(false, math.random(1,100)))
				if desc.DisplayFlags > 0 then --Reveal Room if unrevealed	
					--[[desc.DisplayFlags = desc.DisplayFlags | 5
				else]]
					desc.DisplayFlags = 0
				end
			end
			if InutilLib.room:IsClear() and math.random(1,10) == 1 and InutilLib.room.RoomType ~= RoomType.ROOM_BOSS then
				player:UseActiveItem(CollectibleType.COLLECTIBLE_D7, false, false, false, false, -1, 0)
			end
			if not data.PersistentPlayerData.GoodiesContents then data.PersistentPlayerData.GoodiesContents = {} end

			local hinto = false
			local roomInfo = data.PersistentPlayerData.GoodiesContents[InutilLib.level:GetCurrentRoomDesc().SafeGridIndex]
			--[[if data.PersistentPlayerData.GoodiesContents and willdupe then
				if roomInfo then
					for _, e in ipairs(data.PersistentPlayerData.GoodiesContents[InutilLib.level:GetCurrentRoomDesc().SafeGridIndex]) do
						Isaac.Spawn(e.type, e.var, e.sub, InutilLib.room:FindFreePickupSpawnPosition(e.pos, 10 ), Vector.Zero, nil)
					end
					data.PersistentPlayerData.GoodiesContents[InutilLib.level:GetCurrentRoomDesc().SafeGridIndex] = nil
					hinto = true
				end
				willdupe = false
			end]]
			if data.PersistentPlayerData.GoodiesContents and not hinto then
				data.PersistentPlayerData.GoodiesContents[InutilLib.level:GetCurrentRoomDesc().SafeGridIndex] = {}
				for _,e in ipairs(Isaac.GetRoomEntities()) do
					if e.Type == EntityType.ENTITY_PICKUP then 
						table.insert(data.PersistentPlayerData.GoodiesContents[InutilLib.level:GetCurrentRoomDesc().SafeGridIndex], {pos = e.Position, type = e.Type, var = e.Variant, sub = e.SubType})
					end
				end
			end
		end
	end
end)

yandereWaifu:AddCallback("MC_POST_CLEAR_ROOM", function(_, room)
	local hinto = false	
	for p = 0, InutilLib.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		local data = yandereWaifu.GetEntityData(player)
		if player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_HEARTACHES) then
			local roomInfo = data.PersistentPlayerData.GoodiesContents[InutilLib.level:GetCurrentRoomDesc().SafeGridIndex]
			--[[if data.PersistentPlayerData.GoodiesContents and willdupe then
				if roomInfo then
					for _, e in ipairs(data.PersistentPlayerData.GoodiesContents[InutilLib.level:GetCurrentRoomDesc().SafeGridIndex]) do
						Isaac.Spawn(e.type, e.var, e.sub, InutilLib.room:FindFreePickupSpawnPosition(e.pos, 10 ), Vector.Zero, nil)
					end
					data.PersistentPlayerData.GoodiesContents[InutilLib.level:GetCurrentRoomDesc().SafeGridIndex] = nil
					hinto = true
				end
				willdupe = false
			end]]
			if data.PersistentPlayerData.GoodiesContents and not hinto then
				data.PersistentPlayerData.GoodiesContents[InutilLib.level:GetCurrentRoomDesc().SafeGridIndex] = {}
				for _,e in ipairs(Isaac.GetRoomEntities()) do
					if e.Type == EntityType.ENTITY_PICKUP then 
						table.insert(data.PersistentPlayerData.GoodiesContents[InutilLib.level:GetCurrentRoomDesc().SafeGridIndex], {pos = e.Position, type = e.Type, var = e.Variant, sub = e.SubType})
					end
				end
			end
		end
	end
end)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_,player)
	local data = yandereWaifu.GetEntityData(player)
	if player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_HEARTACHES) and InutilLib.HasJustPickedCollectible( player, RebekahCurse.Items.COLLECTIBLE_HEARTACHES) then
		--player:AddNullCostume(RebekahCurse.Costumes.CandyWeddingRing)
	end
	--if player.FrameCount % 15 == 0 and math.random(1,100) == 100 then
	--	teleport = true
	--end
end)

--unlock
yandereWaifu:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function(_, pl)
	local sprite = pl:GetSprite()
	
	if yandereWaifu.IsNormalRebekah(pl) and yandereWaifu.GetEntityData(pl).currentMode == RebekahCurse.REBECCA_MODE.BrokenHearts then
		if sprite:IsPlaying("Death") and sprite:GetFrame() == 30 then
			if not yandereWaifu.ACHIEVEMENT.HEARTACHES:IsUnlocked() then
				yandereWaifu.ACHIEVEMENT.HEARTACHES:Unlock()
			end
		end
	end
end);