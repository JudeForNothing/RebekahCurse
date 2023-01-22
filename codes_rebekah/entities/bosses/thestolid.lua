yandereWaifu:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, ent)
	local spr = ent:GetSprite()
	local data = yandereWaifu.GetEntityData(ent)
	local player = ent:GetPlayerTarget()
	local room = ILIB.room
	if data.path == nil then data.path = ent.Pathfinder end
	if ent.Variant == RebekahCurseEnemies.ENTITY_THE_STOLID and ent.SubType == 1 then
		if not data.State then
			spr:Play("Travel", true)
			ent:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
			ent:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
			ent.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
			data.State = 0
			data.path:SetCanCrushRocks(true)
			--InutilLib.SFX:Play( RebekahCurseSounds.SOUND_STOLID_APPEAR, 1, 0, false, 0.9 );
		else
			if data.State == 0 then
				InutilLib.MoveDirectlyTowardsTarget(ent, player, 0.8, 0.9)
				if ent.Position:Distance(player.Position) < 35 then
					data.State = 1
				end
			else
				if spr:IsFinished("Punch") then
					ent:Remove()
				end
				if not spr:IsPlaying("Punch") then
					spr:Play("Punch", true)
					ent.Velocity = ent.Velocity * 0
					InutilLib.SFX:Play( SoundEffect.SOUND_BOSS_LITE_ROAR, 1, 0, false, 0.6 );
				elseif spr:IsPlaying("Punch") and spr:GetFrame() == 17 then
					InutilLib.SFX:Play( RebekahCurseSounds.SOUND_STOLID_APPEAR, 1, 0, false, 0.9 );
					ILIB.game:ShakeScreen(5)
					for i, v in pairs (Isaac.GetRoomEntities()) do
						if (v.Position - ent.Position):Length() < v.Size + ent.Size + 30 then
							if v:ToPlayer() then
								v:TakeDamage(1, 0, EntityRef(ent), 1) 
							elseif v:IsEnemy() then
								v:TakeDamage(60, 0, EntityRef(ent), 1) 
							end
						end
					end
				end
			end
		end
	elseif ent.Variant == RebekahCurseEnemies.ENTITY_THE_STOLID and ent.SubType == 0 then
		if not data.State then
			--spr:Play("Idle")
			ent:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
			ent:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
			data.State = 5
			data.path:SetCanCrushRocks(true)
		else
			if data.State >= 5 and data.State < 10 and ent.HitPoints <= math.floor(ent.MaxHitPoints/1.8) then
				data.State = 10 
			end
			if data.State == 0 then
				local entnumber = 0
				for i, v in pairs(Isaac.GetRoomEntities()) do
					if v:IsEnemy() then
						entnumber = entnumber + 1
					end
				end
				ent.Velocity = ent.Velocity * 0.7
				data.path:MoveRandomlyAxisAligned(0.8, false)
				--if not spr:IsPlaying("Idle") and not spr:IsPlaying("CrashHurt") then spr:Play("Idle", true) end
				if not data.lastDir or (InutilLib.VecToAppoxDir(ent.Velocity) ~= data.lastDir) then
					InutilLib.AnimShootFrame(ent, true, ent.Velocity, "IdleRight", "IdleFront", "IdleBack", "IdleLeft")
					data.lastDir = InutilLib.VecToAppoxDir(ent.Velocity)
				end
				if --[[math.random(1,3) == 3 and]] ent.FrameCount % 5 == 0 then
					local dir
					if InutilLib.CuccoLaserCollision(ent, 0, 700, player) then
						dir  = "DashRight"
						data.State = 1
						spr:Play("ChargeStart", true)
						data.DashDir = dir
						data.lastDir = nil
						InutilLib.SFX:Play( SoundEffect.SOUND_BOSS_LITE_ROAR, 1, 0, false, 0.6 );
					elseif InutilLib.CuccoLaserCollision(ent, 90, 700, player) then
						dir  = "DashFront"
						data.State = 1
						spr:Play("ChargeStart", true)
						data.DashDir = dir
						data.lastDir = nil
						InutilLib.SFX:Play( SoundEffect.SOUND_BOSS_LITE_ROAR, 1, 0, false, 0.6 );
					elseif InutilLib.CuccoLaserCollision(ent, 180, 700, player) then
						dir  = "DashLeft"
						data.State = 1
						spr:Play("ChargeStart", true)
						data.DashDir = dir
						data.lastDir = nil
						InutilLib.SFX:Play( SoundEffect.SOUND_BOSS_LITE_ROAR, 1, 0, false, 0.6 );
					elseif InutilLib.CuccoLaserCollision(ent, 270, 700, player) then
						dir  = "DashBack"
						data.State = 1
						spr:Play("ChargeStart", true)
						data.DashDir = dir
						data.lastDir = nil
						InutilLib.SFX:Play( SoundEffect.SOUND_BOSS_LITE_ROAR, 1, 0, false, 0.6 );
					end
				elseif math.random(1,2) == 2 and ent.FrameCount % 5 == 0 then
					if math.random(1,5) == 5 then
						data.State = 3
						ent.Velocity = ent.Velocity * 0
						data.lastDir = nil
					elseif #Isaac.FindByType(RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY, RebekahCurseEnemies.ENTITY_OVUM_EGG, -1, false, true) > 2 and math.random (1,2) then
						data.State = 11
						ent.Velocity = ent.Velocity * 0
						data.lastDir = nil
					elseif #Isaac.FindByType(RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY, RebekahCurseEnemies.ENTITY_OVUM_EGG, -1, false, true) < 5 and entnumber < 4 then
						data.State = 4
						ent.Velocity = ent.Velocity * 0
						data.lastDir = nil
					end
				end
			elseif data.State == 1 then
				if spr:IsFinished("ChargeStart") then
					spr:Play(data.DashDir , true)
					data.State = 2
				end
				ent.Velocity = ent.Velocity * 0
			elseif data.State == 2 then
				if ent:CollidesWithGrid() then
					data.State = 0
					ent.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
					if ent.HitPoints - 100 <= 0 then
						ent:Die()
						InutilLib.SFX:Play( SoundEffect.SOUND_BOSS_LITE_ROAR, 1, 0, false, 0.6 );
					else
						ent.HitPoints = ent.HitPoints - 100
						spr:Play("CrashHurt", true)
					end
					ILIB.game:ShakeScreen(10)
					ILIB.game:MakeShockwave(ent.Position, 0.075, 0.025, 10)
					InutilLib.SFX:Play( SoundEffect.SOUND_FORESTBOSS_STOMPS, 1, 0, false, 0.6 );
					ent.Velocity = Vector.Zero
					--crackwaves
					for i = 0, 360-360/4, 360/4 do
						local crack = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACKWAVE, 0, ent.Position, Vector.FromAngle(i), ent):ToEffect()
						crack.LifeSpan = 12;
						crack.Timeout = 12
						crack.Rotation = i
					end
					--rock splash
					local chosenNumofBarrage =  math.random( 8, 15 );
					for i = 1, chosenNumofBarrage do
						--local tear = player:FireTear(player.Position, Vector.FromAngle(data.specialAttackVector:GetAngleDegrees() - math.random(-10,10))*(math.random(10,15)), false, false, false):ToTear()
						local tear = ILIB.game:Spawn( EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_ROCK, ent.Position, Vector.FromAngle( math.random() * 360 ):Resized(REBEKAH_BALANCE.GOLD_HEARTS_DASH_ATTACK_SPEED), ent, 0, 0):ToProjectile()
						tear.Scale = math.random(2,12)/10;
						tear.FallingSpeed = -27 + math.random(1,5) * 2 ;
						tear.FallingAccel = 0.5;
						--tear.BaseDamage = player.Damage * 2
					end
					--rocks falling down randomly
					for i = 0, math.random(5,7) do
						InutilLib.SetTimer( 7 * i, function()
							local tear = ILIB.game:Spawn( EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_ROCK, Isaac.GetRandomPosition(), Vector.Zero, ent, 0, 0):ToProjectile()
							tear.Scale = math.random(12,16)/10;
							tear.Height = -520;
							tear.FallingAccel = 1.3;
						end);
						
					end
				else
					--destroy grids
						for i = 1, 8 do --code that checks each eight directions
							--local checkingVector = (room:GetGridEntity(room:GetGridIndex(fam.Position + data.savedVelocity*4)))
							local gridStomped = room:GetGridEntity(room:GetGridIndex(ent.Position + Vector(45,0):Rotated(45*(i-1)))) --grids around that Rebecca stepped on
							--if gridStomped:GetType() == GridEntityType.GRID_TNT or gridStomped:GetType() == GridEntityType.GRID_ROCK then
							--print( gridStomped:GetType())
							if gridStomped ~= nil then
								gridStomped:Destroy()
							end
							if i == 8 then 
								local gridStomped = room:GetGridEntity(room:GetGridIndex(ent.Position)) --top grid
								if gridStomped ~= nil then
									gridStomped:Destroy()
								end
							end
						end
					if spr:IsPlaying("DashRight") then
						ent.Velocity = ent.Velocity + Vector(1,0)
					elseif spr:IsPlaying("DashFront") then
						ent.Velocity = ent.Velocity + Vector(0,1)
					elseif spr:IsPlaying("DashLeft") then
						ent.Velocity = ent.Velocity + Vector(-1,0)
					elseif spr:IsPlaying("DashBack") then
						ent.Velocity = ent.Velocity + Vector(0,-1)
					end
					ent.Velocity = ent.Velocity  * 0.95
					if ent.FrameCount % 5 == 0 then
						local dust = Isaac.Spawn( EntityType.ENTITY_EFFECT, EffectVariant.DUST_CLOUD, 0, ent.Position, Vector(0,0), ent ):ToEffect()
						dust:GetSprite().PlaybackSpeed = 0.3
						dust.Timeout = 6
						dust.LifeSpan = 6
					end
					ent.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
				end
			elseif data.State == 3 then
				if spr:IsFinished("Spin") then
					data.State = 0
					data.add = 0
					data.projectileOffset = math.random(-30,30)
					spr:Play("Idle")
					InutilLib.SFX:Stop( SoundEffect.SOUND_ULTRA_GREED_SPINNING);
				end
				if not spr:IsPlaying("Spin") then
					spr:Play("Spin", true)
					ent.Velocity = ent.Velocity * 0
					InutilLib.SFX:Play( SoundEffect.SOUND_BOSS_LITE_ROAR, 1, 0, false, 0.6 );
				elseif spr:IsPlaying("Spin") then
					if spr:WasEventTriggered("StartSpin") and not spr:IsEventTriggered("EndSpin") and math.floor(ent.FrameCount % 9) == 0 then
						InutilLib.SFX:Play( SoundEffect.SOUND_ULTRA_GREED_SPINNING, 1, 0, false, 0.6 );
						if not data.add then data.add = 0 end
						if not data.projectileOffset then data.projectileOffset = math.random(-90,90) end
						for i = 0, 360 - 360/4, 360/4  do
							local tear = ILIB.game:Spawn( EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_ROCK, ent.Position, Vector(9,0):Rotated(i + data.add + data.projectileOffset), ent, 0, 0):ToProjectile()	
							tear.Height = -30
						end
						data.add = data.add + 7
					--[[elseif spr:WasEventTriggered("EndSpin") and spr:GetFrame() < 55 then
						ent.Velocity = (ent.Velocity + ((player.Position - ent.Position)*0.03))*0.85
						ent.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE]]
					elseif spr:GetFrame() == 55 then
						ent.Velocity = Vector.Zero
						ent.Position = ent.Position
						ILIB.game:ShakeScreen(10)
					end
				end
			elseif data.State == 4 then
				if spr:IsFinished("Spit") then
					data.State = 0
				end
				if not spr:IsPlaying("Spit") then
					spr:Play("Spit", true)
				elseif spr:IsPlaying("Spit") then
					if spr:IsEventTriggered("Spit") then
						InutilLib.SFX:Play( SoundEffect.SOUND_BOSS_SPIT_BLOB_BARF, 1, 0, false, 0.6 );
						local egg = Isaac.Spawn(RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY, RebekahCurseEnemies.ENTITY_OVUM_EGG, 2, ent.Position, (player.Position - ent.Position):Resized(7),  ent):ToNPC()
						--local egg = Isaac.Spawn(EntityType.ENTITY_BOOMFLY, 4, 0, ent.Position, (player.Position - ent.Position):Resized(7),  ent):ToNPC()
						egg:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
						local dust = Isaac.Spawn( EntityType.ENTITY_EFFECT, EffectVariant.DUST_CLOUD, 0, ent.Position, Vector(0,0), ent ):ToEffect()
						dust:GetSprite().PlaybackSpeed = 0.3
						dust.Timeout = 6
						dust.LifeSpan = 6
					end
				end
			elseif data.State == 5 then
				if not spr:IsPlaying("IdleStationary") then
					spr:Play("IdleStationary", true)
					ent.Velocity = ent.Velocity * 0
				end
				local entnumber = 0
				for i, v in pairs(Isaac.GetRoomEntities()) do
					if v:IsEnemy() then
						entnumber = entnumber + 1
					end
				end
				if math.random(1,3) == 3 and ent.FrameCount % 15 == 0 and #Isaac.FindByType(RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY, RebekahCurseEnemies.ENTITY_OVUM_EGG, -1, false, true) < 3 and entnumber < 5 then
					data.State = 6
				elseif ent.FrameCount % 30 == 0 and math.random(1,5) == 5 then
					if math.random(1,4) == 4 and entnumber <= 5 then
						if #Isaac.FindByType(RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY, RebekahCurseEnemies.ENTITY_OVUM_EGG, -1, false, true) >= 2 then
							data.State = 9	
						end
					else
						if math.random(1,4) == 4 and #Isaac.FindByType(RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY, RebekahCurseEnemies.ENTITY_THE_STOLID, 1, false, true) < 1 then
							data.State = 8
						else
							data.State = 7
						end
					end
				end
			elseif data.State == 6 then
				if spr:IsFinished("SpitStationary") then
					data.State = 5
				end
				if not spr:IsPlaying("SpitStationary") then
					spr:Play("SpitStationary", true)
				elseif spr:IsPlaying("SpitStationary") then
					if spr:IsEventTriggered("Spit") then
						InutilLib.SFX:Play( SoundEffect.SOUND_BOSS_SPIT_BLOB_BARF, 1, 0, false, 0.6 );
						local egg = Isaac.Spawn(RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY, RebekahCurseEnemies.ENTITY_OVUM_EGG, 1, ent.Position, (player.Position - ent.Position):Resized(7),  ent):ToNPC()
						--local egg = Isaac.Spawn(EntityType.ENTITY_FLY_BOMB, 0, 0, ent.Position, (player.Position - ent.Position):Resized(7),  ent):ToNPC()
						egg:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
						local dust = Isaac.Spawn( EntityType.ENTITY_EFFECT, EffectVariant.DUST_CLOUD, 0, ent.Position, Vector(0,0), ent ):ToEffect()
						dust:GetSprite().PlaybackSpeed = 0.3
						dust.Timeout = 6
						dust.LifeSpan = 6
					end
				end
			elseif data.State == 7 then
				if spr:IsFinished("SpitStationary2") then
					data.State = 5
				end
				if not spr:IsPlaying("SpitStationary2") then
					spr:Play("SpitStationary2", true)
					data.SavedPosition = player.Position
				elseif spr:IsPlaying("SpitStationary2") then
					local frames = spr:GetFrame()
					if not data.addedbarrageangle then data.addedbarrageangle = 0 end
					--if frames % 2 then
						if frames == 0 then
							data.addedbarrageangle = 0
						elseif frames > 1 and frames < 10 then
							data.addedbarrageangle = data.addedbarrageangle - 2
						elseif frames > 10 and frames < 20 then
							data.addedbarrageangle = data.addedbarrageangle + 2
						elseif frames > 20 and frames < 30 then
							data.addedbarrageangle = data.addedbarrageangle - 4
						elseif frames > 30 and frames < 40 then
							data.addedbarrageangle = data.addedbarrageangle + 4
						elseif frames >= 40 then
							if ((frames/5) % 1) == (0) then --reset for a bit
								data.addedbarrageangle = 0
							end
							if (math.floor(frames/5) % 2) == 1 then
								data.addedbarrageangle = data.addedbarrageangle + 2
							elseif (math.floor(frames/5) % 2) == 0 then
								data.addedbarrageangle = data.addedbarrageangle - 2
							end
						else
							data.addedbarrageangle = 0
						end
					--end
					if spr:WasEventTriggered("Spit") and ent.FrameCount % 3 == 0 then
						--for i = 0, 2 do
							--InutilLib.SetTimer( i*15, function()
								--for i = -15, 15, 30 do
									local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, ((data.SavedPosition - ent.Position):Rotated(data.addedbarrageangle)):Resized(8))
									proj.Scale = 1.4
							--		proj:AddProjectileFlags(ProjectileFlags.BURST)
									InutilLib.SFX:Play( SoundEffect.SOUND_GHOST_SHOOT, 1, 0, false, 0.9 );
								--end
							--end)
						--end
					end
				end
			elseif data.State == 8 then
				if spr:IsFinished("PunchStationary") then
					data.State = 5
				end
				if not spr:IsPlaying("PunchStationary") then
					spr:Play("PunchStationary", true)
				elseif spr:IsPlaying("PunchStationary") then
					if spr:IsEventTriggered("Spit") then
						local dust = Isaac.Spawn( RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY, RebekahCurseEnemies.ENTITY_THE_STOLID, 1, ent.Position, Vector(0,0), ent ):ToNPC()
						dust:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
					end
				end
			elseif data.State == 9 then
				if spr:IsFinished("SingStationary") then
					data.State = 5
					for i, v in pairs(Isaac.FindByType(RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY, RebekahCurseEnemies.ENTITY_OVUM_EGG, -1, false, true) ) do
						v:Die()
					end
				elseif not spr:IsPlaying("SingStationary") then
					spr:Play("SingStationary", true)
					InutilLib.SFX:Play( RebekahCurseSounds.SOUND_STOLID_SING, 1, 0, false, 0.9 );
				elseif spr:IsPlaying("SingStationary") then
					if spr:WasEventTriggered("Spit") then
						ILIB.game:ShakeScreen(10)
					end
				end
				if ent.FrameCount % 15 == 0 then
					ILIB.game:MakeShockwave(ent.Position, 0.075, 0.025, 10)
				end
			elseif data.State == 10 then
				if spr:IsFinished("Transition") then
					data.State = 0
					for i, v in pairs(Isaac.FindByType(RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY, RebekahCurseEnemies.ENTITY_OVUM_EGG, -1, false, true) ) do
						v:Die()
					end
					for i, v in pairs(Isaac.FindByType(RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY, RebekahCurseEnemies.ENTITY_THE_STOLID, 1, false, true) ) do
						v:Remove()
					end
					--crackwaves
					for i = 0, 360-360/4, 360/4 do
						local crack = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACKWAVE, 0, ent.Position, Vector.FromAngle(i), ent):ToEffect()
						crack.LifeSpan = 24;
						crack.Timeout = 24
						crack.Rotation = i
					end
					--rock splash
					local chosenNumofBarrage =  math.random( 10, 18 );
					for i = 1, chosenNumofBarrage do
						--local tear = player:FireTear(player.Position, Vector.FromAngle(data.specialAttackVector:GetAngleDegrees() - math.random(-10,10))*(math.random(10,15)), false, false, false):ToTear()
						local tear = ILIB.game:Spawn( EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_ROCK, ent.Position, Vector.FromAngle( math.random() * 360 ):Resized(10), ent, 0, 0):ToProjectile()
						tear.Scale = math.random(2,12)/10;
						tear.FallingSpeed = -27 + math.random(1,5) * 2 ;
						tear.FallingAccel = 0.5;
						--tear.BaseDamage = player.Damage * 2
					end
				end
				if not spr:IsPlaying("Transition") then
					spr:Play("Transition", true)
				elseif spr:IsPlaying("Transition") then
					if spr:WasEventTriggered("Spit") then
						ILIB.game:ShakeScreen(5)
					end
				end
			elseif data.State == 11 then
				if spr:IsFinished("Sing") then
					data.State = 0
					for i, v in pairs(Isaac.FindByType(RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY, RebekahCurseEnemies.ENTITY_OVUM_EGG, -1, false, true) ) do
						InutilLib.SetTimer( 7 * i, function()
							v:Die()
						end)
					end
				elseif not spr:IsPlaying("Sing") then
					spr:Play("Sing", true)
					InutilLib.SFX:Play( RebekahCurseSounds.SOUND_STOLID_SING, 1, 0, false, 0.9 );
				elseif spr:IsPlaying("Sing") then
					if spr:WasEventTriggered("Spit") then
						ILIB.game:ShakeScreen(10)
					end
				end
				if ent.FrameCount % 15 == 0 then
					ILIB.game:MakeShockwave(ent.Position, 0.075, 0.025, 10)
				end
			elseif spr:IsPlaying("Death") then
				if spr:GetFrame() == 36 then
					ILIB.game:ShakeScreen(10)
					ILIB.game:MakeShockwave(ent.Position, 0.075, 0.025, 10)
					ent.Velocity = Vector.Zero
					--crackwaves
					for i = 0, 360-360/4, 360/4 do
						local crack = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACKWAVE, 0, ent.Position, Vector.FromAngle(i), ent):ToEffect()
						--crack.LifeSpan = 12;
						--crack.Timeout = 12
						crack.Rotation = i
					end
					--rock splash
					local chosenNumofBarrage =  math.random( 8, 15 );
					for i = 1, chosenNumofBarrage do
						--local tear = player:FireTear(player.Position, Vector.FromAngle(data.specialAttackVector:GetAngleDegrees() - math.random(-10,10))*(math.random(10,15)), false, false, false):ToTear()
						local tear = ILIB.game:Spawn( EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_ROCK, ent.Position, Vector.FromAngle( math.random() * 360 ):Resized(REBEKAH_BALANCE.GOLD_HEARTS_DASH_ATTACK_SPEED), ent, 0, 0):ToProjectile()
						tear.Scale = math.random(2,12)/10;
						tear.FallingSpeed = -27 + math.random(1,5) * 2 ;
						tear.FallingAccel = 0.5;
						--tear.BaseDamage = player.Damage * 2
					end
					--rocks falling down randomly
					for i = 0, math.random(5,7) do
						InutilLib.SetTimer( 7 * i, function()
							local tear = ILIB.game:Spawn( EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_ROCK, Isaac.GetRandomPosition(), Vector.Zero, ent, 0, 0):ToProjectile()
							tear.Scale = math.random(12,16)/10;
							tear.Height = -520;
							tear.FallingAccel = 1.3;
						end);
						
					end
				end
			end
			--[[local path = InutilLib.GenerateAStarPath(ent.Position, player.Position)
			if path then
				if not ILIB.room:CheckLine(ent.Position, player.Position, 0, 0) then
					InutilLib.FollowPath(ent, player, path, 1.2, 0.9)
				else
					InutilLib.MoveDirectlyTowardsTarget(ent, player, 1.2, 0.9)
				end
			end]]
		end
	end
end, RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY)

yandereWaifu:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, damage, amount, damageFlag, damageSource, damageCountdownFrames) 
	if damage.Type == RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY and damage.Variant == RebekahCurseEnemies.ENTITY_THE_STOLID then
		local data = yandereWaifu.GetEntityData(damage)
		if (damageSource.Type == EntityType.ENTITY_TEAR and damageSource.Variant ~= 42) and (damageFlag & DamageFlag.DAMAGE_EXPLOSION == 0) then
			return false
		end
	end
end)

yandereWaifu:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, ent)
	local spr = ent:GetSprite()
	local data = yandereWaifu.GetEntityData(ent)
	local player = ent:GetPlayerTarget()
	local room = ILIB.room
	if data.path == nil then data.path = ent.Pathfinder end
	if ent.Variant == RebekahCurseEnemies.ENTITY_OVUM_EGG then
		if ent.FrameCount == 1 then
			if ent.SubType >= 1 then
				spr:ReplaceSpritesheet(0, "gfx/bosses/normal/ovumegg_stone.png");
				spr:LoadGraphics();
			end
			spr:Play("Idle")
			data.State = 0
		else
			if data.State == 0 then
				ent.Velocity = ent.Velocity * 0.9
				data.path:MoveRandomlyAxisAligned(0.5, false)
			end
		end
	end
end, RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY)


yandereWaifu:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, function(_, ent)
	local spr = ent:GetSprite()
	local data = yandereWaifu.GetEntityData(ent)
	local player = ent:GetPlayerTarget()
	if ent.Variant == RebekahCurseEnemies.ENTITY_OVUM_EGG then
		local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurseEnemies.ENTITY_OVUM_EGG_EFFECT, ent.SubType, ent.Position, Vector.Zero, ent):ToEffect()
	end
end, RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY)



yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local sprite = eff:GetSprite();
	local room =  Game():GetRoom();
	local data = yandereWaifu.GetEntityData(player)

	if eff.FrameCount == 1 then
		if eff.SubType >= 1 then
			sprite:ReplaceSpritesheet(0, "gfx/bosses/normal/ovumegg_stone.png");
			sprite:LoadGraphics();
		end
		sprite:Play("Death", true);
	elseif sprite:IsFinished("Death") then
		eff:Remove()
	elseif sprite:IsPlaying("Death") and sprite:GetFrame() == 15 then
		if eff.SubType == 1 then
			local rng = math.random(3,14)
			if rng <= 7 then
				local bomb = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_THROWABLEBOMB, 0, eff.Position, Vector.Zero, eff):ToEffect()
			elseif rng <= 9 then
				local bomb = Isaac.Spawn(EntityType.ENTITY_MIGRAINE, 0, 0, eff.Position, Vector.Zero, eff):ToEffect()
			elseif rng == 10 then
				local bomb = Isaac.Spawn(EntityType.ENTITY_BONY, 0, 0, eff.Position, Vector.Zero, eff):ToEffect()
			elseif rng == 11 then
				for i = 0, 2 do
					local bomb = Isaac.Spawn(EntityType.ENTITY_ATTACKFLY, 0, 0, eff.Position, Vector.Zero, eff):ToEffect()
				end
			elseif rng == 12 then
				local bomb = Isaac.Spawn(EntityType.ENTITY_CLICKETY_CLACK, 0, 0, eff.Position, Vector.Zero, eff):ToEffect()
			elseif rng == 13 then
				local bomb = Isaac.Spawn(EntityType.ENTITY_FLY_BOMB, 0, 0, eff.Position, Vector.Zero, eff):ToEffect()
			else
				local bomb = Isaac.Spawn(EntityType.ENTITY_DUST, 0, 0, eff.Position, Vector.Zero, eff):ToEffect()
			end
		elseif eff.SubType == 2 then
			for i = 0, 360, 360/8 do
				local tear = ILIB.game:Spawn( EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_ROCK, eff.Position, Vector.FromAngle(Vector(0,10):GetAngleDegrees() + i):Resized(8), eff, 0, 0):ToProjectile()
			end
			if math.random(1,3) == 3 then
				--local bomb = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_THROWABLEBOMB, 0, eff.Position, Vector.Zero, eff):ToEffect()
				local bomb = Isaac.Spawn(EntityType.ENTITY_ROCK_SPIDER, 2, 0, eff.Position, Vector.Zero, eff)
			end
		else
			local rng = math.random(1,5)
			if rng == 1 then
				local bomb = Isaac.Spawn(EntityType.ENTITY_BOMBDROP, 4, 0, eff.Position, Vector.Zero, eff):ToEffect()
			else
				local bomb = Isaac.Spawn(EntityType.ENTITY_BOMBDROP, 3, 0, eff.Position, Vector.Zero, eff):ToEffect()
			end
		end
	end
	
end, RebekahCurseEnemies.ENTITY_OVUM_EGG_EFFECT)


if StageAPI and StageAPI.Loaded then	
	yandereWaifu.StolidStageAPIRooms = {
		StageAPI.AddBossData("The Stolid", {
			Name = "The Stolid",
			Portrait = "gfx/ui/boss/portrait_the_stolid.png",
			Offset = Vector(0,-15),
			Bossname = "gfx/ui/boss/name_the_stolid.png",
			Weight = 1,
			Rooms = StageAPI.RoomsList("The Stolid Rooms", require("resources.luarooms.bosses.the_stolid_big")),
			Entity =  {Type = RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY, Variant = RebekahCurseEnemies.ENTITY_THE_STOLID},
		})
	}
	StageAPI.AddBossToBaseFloorPool({BossID = "The Stolid"},LevelStage.STAGE2_1,StageType.STAGETYPE_REPENTANCE_B)
	StageAPI.AddBossToBaseFloorPool({BossID = "The Stolid"},LevelStage.STAGE2_2,StageType.STAGETYPE_REPENTANCE_B)
	--[[StageAPI.AddBossToBaseFloorPool({BossID = "The Stolid"},LevelStage.STAGE1_1,StageType.STAGETYPE_ORIGINAL)
	StageAPI.AddBossToBaseFloorPool({BossID = "The Stolid"},LevelStage.STAGE1_1,StageType.STAGETYPE_WOTL)
	StageAPI.AddBossToBaseFloorPool({BossID = "The Stolid"},LevelStage.STAGE1_1,StageType.STAGETYPE_AFTERBIRTH)
	StageAPI.AddBossToBaseFloorPool({BossID = "The Stolid"},LevelStage.STAGE1_2,StageType.STAGETYPE_ORIGINAL)
	StageAPI.AddBossToBaseFloorPool({BossID = "The Stolid"},LevelStage.STAGE1_2,StageType.STAGETYPE_WOTL)
	StageAPI.AddBossToBaseFloorPool({BossID = "The Stolid"},LevelStage.STAGE1_2,StageType.STAGETYPE_AFTERBIRTH)
	
	StageAPI.AddBossToBaseFloorPool({BossID = "The Stolid"},LevelStage.STAGE2_1,StageType.STAGETYPE_ORIGINAL)
	StageAPI.AddBossToBaseFloorPool({BossID = "The Stolid"},LevelStage.STAGE2_1,StageType.STAGETYPE_WOTL)
	StageAPI.AddBossToBaseFloorPool({BossID = "The Stolid"},LevelStage.STAGE2_1,StageType.STAGETYPE_AFTERBIRTH)
	StageAPI.AddBossToBaseFloorPool({BossID = "The Stolid"},LevelStage.STAGE2_2,StageType.STAGETYPE_ORIGINAL)
	StageAPI.AddBossToBaseFloorPool({BossID = "The Stolid"},LevelStage.STAGE2_2,StageType.STAGETYPE_WOTL)
	StageAPI.AddBossToBaseFloorPool({BossID = "The Stolid"},LevelStage.STAGE2_2,StageType.STAGETYPE_AFTERBIRTH)
	
	StageAPI.AddBossToBaseFloorPool({BossID = "The Stolid"},LevelStage.STAGE3_1,StageType.STAGETYPE_ORIGINAL)
	StageAPI.AddBossToBaseFloorPool({BossID = "The Stolid"},LevelStage.STAGE3_1,StageType.STAGETYPE_WOTL)
	StageAPI.AddBossToBaseFloorPool({BossID = "The Stolid"},LevelStage.STAGE3_1,StageType.STAGETYPE_AFTERBIRTH)
	
	StageAPI.AddBossToBaseFloorPool({BossID = "The Stolid"},LevelStage.STAGE4_1,StageType.STAGETYPE_ORIGINAL)
	StageAPI.AddBossToBaseFloorPool({BossID = "The Stolid"},LevelStage.STAGE4_1,StageType.STAGETYPE_WOTL)
	StageAPI.AddBossToBaseFloorPool({BossID = "The Stolid"},LevelStage.STAGE4_1,StageType.STAGETYPE_AFTERBIRTH)]]
end

if HPBars then -- check if the mod is installed
	HPBars.BossDefinitions["600.222"] = { -- the table BossDefinitions is used to define boss specific content. Entries are defined with "Type.Variant" of the boss
		sprite = "gfx/ui/boss_icon/the_stolid.png", -- path to the .png file that will be used as the icon for this boss
		offset = Vector(-4, 0) -- number of pixels the icon should be moved from its center versus the left-side of the bar
	}
end