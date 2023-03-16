local function CloseDoors()
	for i = 0, 7 do
		local door = InutilLib.game:GetRoom():GetDoor(i)
		currentLevelIDX = InutilLib.level:GetCurrentRoomDesc().GridIndex
		local rng = math.random(0,10)
		if door then
			if door:IsOpen() then
				door:Bar()
			end
			InutilLib.room:SetClear(false)
		end
	end
end

function yandereWaifu:useFenrirsPaw(collItem, rng, player, flag, slot)
	local data = yandereWaifu.GetEntityData(player)
	
	if data.lastActiveUsedFrameCount then
		if InutilLib.game:GetFrameCount() == data.lastActiveUsedFrameCount then
			return
		end
						
		data.lastActiveUsedFrameCount = InutilLib.game:GetFrameCount()
	else
		data.lastActiveUsedFrameCount = InutilLib.game:GetFrameCount()
	end

	player:AnimateCollectible(collItem)
	local rng = math.random(1,100)

	local isChamp = false
	local isBelial = false
	if player:HasCollectible(CollectibleType.COLLECTIBLE_CAR_BATTERY) then
		isChamp = true
	end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) and player:GetName() == "Judas" then
		isBelial = true
	end
	
	Isaac.Spawn( EntityType.ENTITY_EFFECT, EffectVariant.DIRT_PILE, 0, player.Position,  Vector(0,0), player );
	local spawnPosition = InutilLib.room:FindFreePickupSpawnPosition(player.Position, 1);
	if rng >= 1 and rng <= 40 then
		if not isBelial then
			local tears =  Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.BONE, 0, player.Position, Vector(0,-8):Rotated(math.random(0,360)), player):ToTear()
			InutilLib.MakeTearLob(tears, 1.5, 9 )
		else
			local bomb = Isaac.Spawn(EntityType.ENTITY_BOMBDROP, BombVariant.BOMB_TROLL, 0, player.Position, Vector.Zero, player):ToBomb()
		end
	elseif rng > 40 and rng <= 50 then
		Isaac.Spawn( EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, 0, spawnPosition, Vector(0,0), player );
	elseif rng > 50 and rng <= 55 then
		Isaac.Spawn( EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_CHEST, 0, spawnPosition, Vector(0,0), player );
	elseif rng > 55 and rng <= 58 then
		Isaac.Spawn( EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, 0, spawnPosition, Vector(0,0), player );
	elseif rng > 58 and rng <= 60 then
		Isaac.Spawn( EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_KEY, 0, spawnPosition, Vector(0,0), player );
	else
		if InutilLib.level:GetAbsoluteStage() == 10 and InutilLib.level:GetStageType() == 1 and math.random(1,2) == 2 then
			if math.random(1,2) == 1 then
				for i = 0, 3 do
					local ent = Isaac.Spawn(38, 1, 0, InutilLib.room:FindFreePickupSpawnPosition(player.Position, 3), Vector.Zero, player):ToNPC()
					ent:AddEntityFlags(EntityFlag.FLAG_AMBUSH)
					if isChamp then
						ent:MakeChampion(math.random(1,10), -1, false)
					end
				end
			else
				local ent = Isaac.Spawn(227, 1, 0, InutilLib.room:FindFreePickupSpawnPosition(player.Position, 3), Vector.Zero, player):ToNPC()
				ent:AddEntityFlags(EntityFlag.FLAG_AMBUSH)
				if isChamp then
					ent:MakeChampion(math.random(1,10), -1, false)
				end
			end
		elseif InutilLib.level:GetAbsoluteStage() == 10 and InutilLib.level:GetStageType() == 0 and math.random(1,2) == 2 then
			if math.random(1,2) == 1 then
				for i = 0, 3 do
					local ent = Isaac.Spawn(252, 0, 0, InutilLib.room:FindFreePickupSpawnPosition(player.Position, 3), Vector.Zero, player):ToNPC()
					ent:AddEntityFlags(EntityFlag.FLAG_AMBUSH)
					if isChamp then
						ent:MakeChampion(math.random(1,10), -1, false)
					end
				end
			else
				local ent = Isaac.Spawn(841, 0, 0, InutilLib.room:FindFreePickupSpawnPosition(player.Position, 3), Vector.Zero, player):ToNPC()
				ent:AddEntityFlags(EntityFlag.FLAG_AMBUSH)
				if isChamp then
					ent:MakeChampion(math.random(1,10), -1, false)
				end
			end
		elseif InutilLib.level:GetAbsoluteStage() == 9 and math.random(1,2) == 2 then
			local ent = Isaac.Spawn(297, 1, 0, spawnPosition, Vector.Zero, player):ToNPC()
			ent:AddEntityFlags(EntityFlag.FLAG_AMBUSH)
			if isChamp then
				ent:MakeChampion(math.random(1,10), -1, false)
			end
		elseif InutilLib.level:GetAbsoluteStage() > 6 and math.random(1,3) == 3 then
			if math.random(1,2) == 1 then
				for i = 0, 3 do
					local ent = Isaac.Spawn(EntityType.ENTITY_BONY, 0, 0, InutilLib.room:FindFreePickupSpawnPosition(player.Position, 3), Vector.Zero, player):ToNPC()
					ent:AddEntityFlags(EntityFlag.FLAG_AMBUSH)
					if isChamp then
						ent:MakeChampion(math.random(1,10), -1, false)
					end
				end
			else
				for i = 0, 2 do
					local ent = Isaac.Spawn(231, 0, 0, InutilLib.room:FindFreePickupSpawnPosition(player.Position, 3), Vector.Zero, player):ToNPC()
					ent:AddEntityFlags(EntityFlag.FLAG_AMBUSH)
					if isChamp then
						ent:MakeChampion(math.random(1,10), -1, false)
					end
				end
			end
		elseif InutilLib.level:GetAbsoluteStage() > 6 and math.random(1,2) == 2 then
			if math.random(1,2) == 1 then
				local ent = Isaac.Spawn(290, 0, 0, spawnPosition, Vector.Zero, player):ToNPC()
				ent:AddEntityFlags(EntityFlag.FLAG_AMBUSH)
				if isChamp then
					ent:MakeChampion(math.random(1,10), -1, false)
				end
			else
				local ent = Isaac.Spawn(231, 1, 0, spawnPosition, Vector.Zero, player):ToNPC()
				ent:AddEntityFlags(EntityFlag.FLAG_AMBUSH)
				if isChamp then
					ent:MakeChampion(math.random(1,10), -1, false)
				end
			end
		elseif InutilLib.level:GetAbsoluteStage() > 4 and math.random(1,3) == 3 then
			if math.random(1,2) == 1 then
				for i = 0, 2 do
					local ent = Isaac.Spawn(EntityType.ENTITY_BONY, 0, 0, InutilLib.room:FindFreePickupSpawnPosition(player.Position, 3), Vector.Zero, player):ToNPC()
					ent:AddEntityFlags(EntityFlag.FLAG_AMBUSH)
					if isChamp then
						ent:MakeChampion(math.random(1,10), -1, false)
					end
				end
			else
				for i = 0, 2 do
					local ent = Isaac.Spawn(237, 0, 0, InutilLib.room:FindFreePickupSpawnPosition(player.Position, 3), Vector.Zero, player):ToNPC()
					ent:AddEntityFlags(EntityFlag.FLAG_AMBUSH)
					if isChamp then
						ent:MakeChampion(math.random(1,10), -1, false)
					end
				end
			end
		elseif InutilLib.level:GetAbsoluteStage() > 4 and math.random(1,2) == 2 then
			if math.random(1,2) == 1 then
				local ent = Isaac.Spawn(830, 0, 0, spawnPosition, Vector.Zero, player):ToNPC()
				ent:AddEntityFlags(EntityFlag.FLAG_AMBUSH)
				if isChamp then
					ent:MakeChampion(math.random(1,10), -1, false)
				end
			else
				local ent = Isaac.Spawn(219, 1, 0, spawnPosition, Vector.Zero, player):ToNPC()
				ent:AddEntityFlags(EntityFlag.FLAG_AMBUSH)
				if isChamp then
					ent:MakeChampion(math.random(1,10), -1, false)
				end
			end
		elseif InutilLib.level:GetAbsoluteStage() > 2 and math.random(1,3) == 3 then
			if math.random(1,2) == 1 then
				local ent = Isaac.Spawn(27, 0, 0, spawnPosition, Vector.Zero, player):ToNPC()
				ent:AddEntityFlags(EntityFlag.FLAG_AMBUSH)
				if isChamp then
					ent:MakeChampion(math.random(1,10), -1, false)
				end
			else
				local ent = Isaac.Spawn(27, 1, 0, spawnPosition, Vector.Zero, player):ToNPC()
				ent:AddEntityFlags(EntityFlag.FLAG_AMBUSH)
				if isChamp then
					ent:MakeChampion(math.random(1,10), -1, false)
				end
			end
		elseif InutilLib.level:GetAbsoluteStage() > 2 and math.random(1,2) == 2 then
			if math.random(1,2) == 1 then
				local ent = Isaac.Spawn(889, 0, 0, spawnPosition, Vector.Zero, player):ToNPC()
				ent:AddEntityFlags(EntityFlag.FLAG_AMBUSH)
				if isChamp then
					ent:MakeChampion(math.random(1,10), -1, false)
				end
			else
				local ent = Isaac.Spawn(25, 4, 0, spawnPosition, Vector.Zero, player):ToNPC()
				ent:AddEntityFlags(EntityFlag.FLAG_AMBUSH)
				if isChamp then
					ent:MakeChampion(math.random(1,10), -1, false)
				end
			end
		else
			local ent = Isaac.Spawn(EntityType.ENTITY_BONY, 0, 0, spawnPosition, Vector.Zero, player):ToNPC()
			ent:AddEntityFlags(EntityFlag.FLAG_AMBUSH)
			if isChamp then
				ent:MakeChampion(math.random(1,10), -1, false)
			end
		end
		CloseDoors()
	end
end
yandereWaifu:AddCallback( ModCallbacks.MC_USE_ITEM, yandereWaifu.useFenrirsPaw, RebekahCurseItems.COLLECTIBLE_FENRIRSPAW);
