function yandereWaifu.GetUSR()
	for i = InutilLib.level:GetRooms().Size, 0, -1 do
		local roomdesc = InutilLib.level:GetRooms():Get(i-1)
		if roomdesc and roomdesc.Data.Type == RoomType.ROOM_ULTRASECRET --[[and roomdesc.Data.Subtype ~= 34]] then
			return roomdesc
		end
	end
end

function yandereWaifu.GetRoomsNeighborsIdx(index)
	local level = InutilLib.game:GetLevel()
	local tbl = {}

	for _, shift in pairs({1, -1, 13, -13}) do
		--local desc = level:GetRoomByIdx(index + shift)
		local desc = index + shift
		table.insert(tbl, desc)
	end

	return tbl
end

yandereWaifu:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function(_) --The thing the checks and updates the game, i guess?
	for p = 0, InutilLib.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		local data = yandereWaifu.GetEntityData(player)
		if player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_FENRIRSTOOTH) then
			local rooms = {}
			for i, v in pairs(yandereWaifu.GetRoomsNeighborsIdx(yandereWaifu.GetUSR().SafeGridIndex)) do
				table.insert(rooms, v)
				for j, w in pairs(yandereWaifu.GetRoomsNeighborsIdx(v)) do
					table.insert(rooms, w)
				end
			end

			--check room
			for i, v in pairs(rooms) do
				if InutilLib.level:GetRoomByIdx(v, -1).SafeGridIndex == InutilLib.level:GetCurrentRoomDesc().SafeGridIndex then
					InutilLib.SFX:Play(SoundEffect.SOUND_DOG_HOWELL, 1, 0, false, 0.8)
				end
			end
			--if InutilLib.level:GetCurrentRoomDesc().Data.Type == RoomType.ROOM_ULTRASECRET then
		end
	end
end)