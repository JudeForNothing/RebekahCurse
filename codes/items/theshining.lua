local currentLevelIDX
function yandereWaifu:usetheShining(collItem, rng, player)
	for i = 0, 7 do
		local door = ILIB.game:GetRoom():GetDoor(i)
		currentLevelIDX = ILIB.level:GetCurrentRoomDesc().GridIndex
		if door then
			local puddle = ILIB.game:Spawn( EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_RED, door.Position, Vector(0,0), player, 0, 0):ToEffect()
			InutilLib.RevelSetCreepData(puddle)
			InutilLib.RevelUpdateCreepSize(puddle, math.random(12,19), true)
			
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