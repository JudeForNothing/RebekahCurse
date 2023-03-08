local function GetUSR()
	for i = ILIB.level:GetRooms().Size, 0, -1 do
		local roomdesc = ILIB.level:GetRooms():Get(i-1)
		if roomdesc and roomdesc.Data.Type == RoomType.ROOM_ULTRASECRET --[[and roomdesc.Data.Subtype ~= 34]] then
			return roomdesc
		end
	end
end

local function GetRoomsNeighborsIdx(index)
	local level = ILIB.game:GetLevel()
	local tbl = {}

	for _, shift in pairs({1, -1, 13, -13}) do
		--local desc = level:GetRoomByIdx(index + shift)
		local desc = index + shift
		table.insert(tbl, desc)
	end

	return tbl
end

yandereWaifu:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function(_) --The thing the checks and updates the game, i guess?
	for p = 0, ILIB.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		local data = yandereWaifu.GetEntityData(player)
		if player:HasCollectible(RebekahCurseItems.COLLECTIBLE_FENRIRSTOOTH) then
			local rooms = {}
			for i, v in pairs(GetRoomsNeighborsIdx(GetUSR().SafeGridIndex)) do
				table.insert(rooms, v)
				for j, w in pairs(GetRoomsNeighborsIdx(v)) do
					table.insert(rooms, w)
				end
			end

			--check room
			for i, v in pairs(rooms) do
				if ILIB.level:GetRoomByIdx(v, -1).SafeGridIndex == ILIB.level:GetCurrentRoomDesc().SafeGridIndex then
					InutilLib.SFX:Play(SoundEffect.SOUND_DOG_HOWELL, 1, 0, false, 0.8)
				end
			end
			--if ILIB.level:GetCurrentRoomDesc().Data.Type == RoomType.ROOM_ULTRASECRET then
		end
	end
end)