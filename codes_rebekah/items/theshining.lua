local currentLevelIDX
function yandereWaifu:usetheShining(collItem, rng, player, flags)
	local data = yandereWaifu.GetEntityData(player)
	data.GonnaChopOffTheDoor = true
	player:AddCacheFlags(CacheFlag.CACHE_ALL);
	player:EvaluateItems()
	for i = 0, 7 do
		local door = InutilLib.game:GetRoom():GetDoor(i)
		currentLevelIDX = InutilLib.level:GetCurrentRoomDesc().GridIndex
		if door and (door:GetVariant() == DoorVariant.DOOR_LOCKED or door:GetVariant() == DoorVariant.DOOR_LOCKED_BARRED or door:GetVariant() == DoorVariant.DOOR_UNLOCKED or door:GetVariant() == DoorVariant.DOOR_LOCKED_CRACKED or door:GetVariant() == DoorVariant.DOOR_LOCKED_DOUBLE ) then
			local puddle = InutilLib.game:Spawn( EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_RED, door.Position, Vector(0,0), player, 0, 0):ToEffect()
			InutilLib.RevelSetCreepData(puddle)
			InutilLib.RevelUpdateCreepSize(puddle, math.random(12,19), true)
			if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES) then
				local wisp = player:AddWisp(CollectibleType.COLLECTIBLE_SULFUR, door.Position, false, false):ToFamiliar()
				if wisp then
					wisp.HitPoints = 2
				end
			end
			data.ShiningLimit = math.random(7,15)
			for j = 0, data.ShiningLimit do
				InutilLib.SetTimer( j*30, function()
					if door and currentLevelIDX == InutilLib.level:GetCurrentRoomDesc().GridIndex then
						local vector = InutilLib.DirToVec(door.Direction)
						local tear = player:FireTear(door.Position, Vector.FromAngle(math.random(-10,10)+vector:GetAngleDegrees()+180)*(math.random(13,25)), false, false, false):ToTear()
						InutilLib.MakeTearLob(tear, 8, 15)
						tear:ChangeVariant(TearVariant.BLOOD)
						if j == data.ShiningLimit then
							local beam = player:FireBrimstone( Vector.FromAngle(vector:GetAngleDegrees()+180), player, 2):ToLaser();
							beam.Position = door.Position
							beam.DisableFollowParent = true
							door:Open()
							InutilLib.SFX:Play( SoundEffect.SOUND_DOOR_HEAVY_OPEN, 1, 0, false, 1.4 );
							local dust = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DARK_BALL_SMOKE_PARTICLE, 0, door.Position, Vector(0,0), nil)
						end
					end
				end)
			end
		end
	end
	if flags & UseFlag.USE_NOANIM == 0 then
        player:AnimateCollectible(RebekahCurse.Items.COLLECTIBLE_THESHINING, "UseItem", "PlayerPickupSparkle")
    end
end
yandereWaifu:AddCallback( ModCallbacks.MC_USE_ITEM, yandereWaifu.usetheShining, RebekahCurse.Items.COLLECTIBLE_THESHINING);


function yandereWaifu:ItsJohnnyenteringtheroom()
	for p = 0, InutilLib.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		local data = yandereWaifu.GetEntityData(player)
		if player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_THESHINING) and data.GonnaChopOffTheDoor then
			data.GonnaChopOffTheDoor = false
			player:AddCacheFlags(CacheFlag.CACHE_ALL);
			player:EvaluateItems()
		end
	end
end
yandereWaifu:AddCallback( ModCallbacks.MC_POST_NEW_ROOM, yandereWaifu.ItsJohnnyenteringtheroom)

function yandereWaifu:ItsJonnyVibes(player, cacheF) --The thing the checks and updates the game, i guess?
	local data = yandereWaifu.GetEntityData(player)
	if data.GonnaChopOffTheDoor then
		if cacheF == CacheFlag.CACHE_DAMAGE then
			player.Damage = player.Damage * 1.5
		end
		if cacheF == CacheFlag.CACHE_SPEED then
			player.MoveSpeed = player.MoveSpeed + 0.15
		end
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, yandereWaifu.ItsJonnyVibes)