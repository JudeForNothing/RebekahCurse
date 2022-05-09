yandereWaifu:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, ent)
	local spr = ent:GetSprite()
	local data = yandereWaifu.GetEntityData(ent)
	local player = ent:GetPlayerTarget()
	local room = ILIB.room
	if data.path == nil then data.path = ent.Pathfinder end
	if ent.Variant == RebekahCurseEnemies.ENTITY_THE_STALWART then
		if not data.State then
			--spr:Play("Idle")
			ent:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
			ent:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
			data.State = 0
			data.path:SetCanCrushRocks(true)
		else
			if data.State == 0 then
				ent.Velocity = ent.Velocity * 0.7
				data.path:MoveRandomlyAxisAligned(0.8, false)
				--if not spr:IsPlaying("Idle") and not spr:IsPlaying("CrashHurt") then spr:Play("Idle", true) end
				if not data.lastDir or (InutilLib.VecToAppoxDir(ent.Velocity) ~= data.lastDir) then
					InutilLib.AnimShootFrame(ent, true, ent.Velocity, "IdleRight", "IdleFront", "IdleBack", "IdleLeft")
					data.lastDir = InutilLib.VecToAppoxDir(ent.Velocity)
				end
				if math.random(1,3) == 3 and ent.FrameCount % 5 == 0 then
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
				elseif math.random(1,3) == 3 and ent.FrameCount % 5 == 0 then
					if math.random(1,5) == 5 then
						data.State = 3
						ent.Velocity = ent.Velocity * 0
						data.lastDir = nil
					elseif #Isaac.FindByType(RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY, RebekahCurseEnemies.ENTITY_OVUM_EGG, -1, false, true) < 3 then
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
					InutilLib.SFX:Play( SoundEffect.SOUND_FORESTBOSS_STOMPS, 1, 0, false, 0.6 );
					ent.Velocity = Vector.Zero
					--crackwaves
					for i = 0, 360-360/4, 360/4 do
						local crack = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACKWAVE, 0, ent.Position, Vector.FromAngle(i), ent):ToEffect()
						crack.LifeSpan = 9;
						crack.Rotation = i
					end
					--rock splash
					local chosenNumofBarrage =  math.random( 8, 15 );
					for i = 1, chosenNumofBarrage do
						--local tear = player:FireTear(player.Position, Vector.FromAngle(data.specialAttackVector:GetAngleDegrees() - math.random(-10,10))*(math.random(10,15)), false, false, false):ToTear()
						local tear = ILIB.game:Spawn( EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_ROCK, ent.Position, Vector.FromAngle( math.random() * 360 ):Resized(REBEKAH_BALANCE.GOLD_HEARTS_DASH_ATTACK_SPEED), ent, 0, 0):ToProjectile()
						tear.Scale = math.random(2,12)/10;
						tear.FallingSpeed = -27 + math.random() * 2 ;
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
					if spr:WasEventTriggered("StartSpin") and not spr:IsEventTriggered("EndSpin") and math.floor(ent.FrameCount % 7) == 0 then
						InutilLib.SFX:Play( SoundEffect.SOUND_ULTRA_GREED_SPINNING, 1, 0, false, 0.6 );
						if not data.add then data.add = 0 end
						if not data.projectileOffset then data.projectileOffset = math.random(-60,60) end
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
						local egg = Isaac.Spawn(RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY, RebekahCurseEnemies.ENTITY_OVUM_EGG, 0, ent.Position, (player.Position - ent.Position):Resized(7),  ent):ToNPC()
						egg:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
						local dust = Isaac.Spawn( EntityType.ENTITY_EFFECT, EffectVariant.DUST_CLOUD, 0, ent.Position, Vector(0,0), ent ):ToEffect()
						dust:GetSprite().PlaybackSpeed = 0.3
						dust.Timeout = 6
						dust.LifeSpan = 6
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
	if damage.Type == RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY and damage.Variant == RebekahCurseEnemies.ENTITY_THE_STALWART then
		local data = yandereWaifu.GetEntityData(damage)
		return false
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
		local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurseEnemies.ENTITY_OVUM_EGG_EFFECT, 0, ent.Position, Vector.Zero, ent):ToEffect()
	end
end, RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY)



yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local sprite = eff:GetSprite();
	local room =  Game():GetRoom();
	local data = yandereWaifu.GetEntityData(player)

	if eff.FrameCount == 1 then
		sprite:Play("Death", true);
	elseif sprite:IsFinished("Death") then
		eff:Remove()
	elseif sprite:IsPlaying("Death") and sprite:GetFrame() == 15 then
		local rng = math.random(1,5)
		if rng == 1 then
			local bomb = Isaac.Spawn(EntityType.ENTITY_BOMBDROP, 4, 0, eff.Position, Vector.Zero, eff):ToEffect()
		else
			local bomb = Isaac.Spawn(EntityType.ENTITY_BOMBDROP, 3, 0, eff.Position, Vector.Zero, eff):ToEffect()
		end
	end
	
end, RebekahCurseEnemies.ENTITY_OVUM_EGG_EFFECT)


if StageAPI and StageAPI.Loaded then	
	yandereWaifu.StalwartStageAPIRooms = {
		StageAPI.AddBossData("The Stalwart", {
			Name = "The Stalwart",
			Portrait = "gfx/ui/boss/portrait_the_stalwart.png",
			Offset = Vector(0,-15),
			Bossname = "gfx/ui/boss/name_the_stalwart.png",
			Weight = 1,
			Rooms = StageAPI.RoomsList("The Stalwart Rooms", require("resources.luarooms.bosses.the_stalwart"))
		})
	}
	--[[StageAPI.AddBossToBaseFloorPool({BossID = "The Stalwart"},LevelStage.STAGE1_1,StageType.STAGETYPE_ORIGINAL)
	StageAPI.AddBossToBaseFloorPool({BossID = "The Stalwart"},LevelStage.STAGE1_1,StageType.STAGETYPE_WOTL)
	StageAPI.AddBossToBaseFloorPool({BossID = "The Stalwart"},LevelStage.STAGE1_1,StageType.STAGETYPE_AFTERBIRTH)
	StageAPI.AddBossToBaseFloorPool({BossID = "The Stalwart"},LevelStage.STAGE1_2,StageType.STAGETYPE_ORIGINAL)
	StageAPI.AddBossToBaseFloorPool({BossID = "The Stalwart"},LevelStage.STAGE1_2,StageType.STAGETYPE_WOTL)
	StageAPI.AddBossToBaseFloorPool({BossID = "The Stalwart"},LevelStage.STAGE1_2,StageType.STAGETYPE_AFTERBIRTH)
	
	StageAPI.AddBossToBaseFloorPool({BossID = "The Stalwart"},LevelStage.STAGE2_1,StageType.STAGETYPE_ORIGINAL)
	StageAPI.AddBossToBaseFloorPool({BossID = "The Stalwart"},LevelStage.STAGE2_1,StageType.STAGETYPE_WOTL)
	StageAPI.AddBossToBaseFloorPool({BossID = "The Stalwart"},LevelStage.STAGE2_1,StageType.STAGETYPE_AFTERBIRTH)
	StageAPI.AddBossToBaseFloorPool({BossID = "The Stalwart"},LevelStage.STAGE2_2,StageType.STAGETYPE_ORIGINAL)
	StageAPI.AddBossToBaseFloorPool({BossID = "The Stalwart"},LevelStage.STAGE2_2,StageType.STAGETYPE_WOTL)
	StageAPI.AddBossToBaseFloorPool({BossID = "The Stalwart"},LevelStage.STAGE2_2,StageType.STAGETYPE_AFTERBIRTH)
	
	StageAPI.AddBossToBaseFloorPool({BossID = "The Stalwart"},LevelStage.STAGE3_1,StageType.STAGETYPE_ORIGINAL)
	StageAPI.AddBossToBaseFloorPool({BossID = "The Stalwart"},LevelStage.STAGE3_1,StageType.STAGETYPE_WOTL)
	StageAPI.AddBossToBaseFloorPool({BossID = "The Stalwart"},LevelStage.STAGE3_1,StageType.STAGETYPE_AFTERBIRTH)]]
	
	StageAPI.AddBossToBaseFloorPool({BossID = "The Stalwart"},LevelStage.STAGE4_1,StageType.STAGETYPE_ORIGINAL)
	StageAPI.AddBossToBaseFloorPool({BossID = "The Stalwart"},LevelStage.STAGE4_1,StageType.STAGETYPE_WOTL)
	StageAPI.AddBossToBaseFloorPool({BossID = "The Stalwart"},LevelStage.STAGE4_1,StageType.STAGETYPE_AFTERBIRTH)
end

if HPBars then -- check if the mod is installed
	HPBars.BossDefinitions["600.222"] = { -- the table BossDefinitions is used to define boss specific content. Entries are defined with "Type.Variant" of the boss
		sprite = "gfx/ui/boss_icon/the_stalwart.png", -- path to the .png file that will be used as the icon for this boss
		offset = Vector(-4, 0) -- number of pixels the icon should be moved from its center versus the left-side of the bar
	}
end