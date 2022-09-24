local currentLevelIDX
function yandereWaifu:usetheShining(collItem, rng, player)
	local data = yandereWaifu.GetEntityData(player)
	data.GonnaChopOffTheDoor = true
	player:AddCacheFlags(CacheFlag.CACHE_ALL);
	player:EvaluateItems()
	for i = 0, 7 do
		local door = ILIB.game:GetRoom():GetDoor(i)
		currentLevelIDX = ILIB.level:GetCurrentRoomDesc().GridIndex
		if door then
			local puddle = ILIB.game:Spawn( EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_RED, door.Position, Vector(0,0), player, 0, 0):ToEffect()
			InutilLib.RevelSetCreepData(puddle)
			InutilLib.RevelUpdateCreepSize(puddle, math.random(12,19), true)
			if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES) then
				local wisp = player:AddWisp(CollectibleType.COLLECTIBLE_SULFUR, door.Position, false, false):ToFamiliar()
				if wisp then
					wisp.HitPoints = 2
				end
			end
			local limit = math.random(7,15)
			for j = 0, limit do
				InutilLib.SetTimer( j*30, function()
					if door and currentLevelIDX == ILIB.level:GetCurrentRoomDesc().GridIndex then
						local vector = InutilLib.DirToVec(door.Direction)
						local tear = player:FireTear(door.Position, Vector.FromAngle(math.random(-10,10)+vector:GetAngleDegrees()+180)*(math.random(13,25)), false, false, false):ToTear()
						InutilLib.MakeTearLob(tear, 8, 15)
						tear:ChangeVariant(TearVariant.BLOOD)
						if j == limit then
							beam = player:FireBrimstone( Vector.FromAngle(vector:GetAngleDegrees()+180), player, 2):ToLaser();
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
end
yandereWaifu:AddCallback( ModCallbacks.MC_USE_ITEM, yandereWaifu.usetheShining, RebekahCurse.COLLECTIBLE_THESHINING);


function yandereWaifu:ItsJohnnyenteringtheroom()
	for p = 0, ILIB.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		local data = yandereWaifu.GetEntityData(player)
		if player:HasCollectible(RebekahCurse.COLLECTIBLE_THESHINING) and data.GonnaChopOffTheDoor then
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