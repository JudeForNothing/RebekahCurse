
function yandereWaifu:MoonBossUpdate(npc)
	if npc.Variant == RebekahCurse.Enemies.ENTITY_THEMOON then
		local data = npc:GetData()
		local spr = npc:GetSprite()
		local target = npc:GetPlayerTarget()
		--init
		if not data.State then
			data.State = 0
			data.StartingPos = (npc.Position - target.Position):GetAngleDegrees()
		end
		if data.State == 0 then
			spr:Play("Idle", true)
			data.State = 1
		end
		
		if data.State == 1 then
			InutilLib.StrafeAroundTarget(npc, target, 1, 0.9, 35)
			--MoveOrbitAroundTargetType1(npc, target, 2, 0.9, 12, data.StartingPos)
			if math.random(1,2) == 2 and npc.FrameCount % 30 == 0 then
				data.State = math.random(2,4)
			end
			if npc.HitPoints < npc.MaxHitPoints/2 then
				data.State = 5
			end
			if math.random(1,3) == 3 and spr:GetFrame() == 2 then
				InutilLib.SFX:Play(SoundEffect.SOUND_MONSTER_GRUNT_0, 0.7, 0, false, 0.7)
			end
		elseif data.State == 2 then
			InutilLib.StrafeAroundTarget(npc, target, 1, 0.9, 35)
			--MoveOrbitAroundTargetType1(npc, target, 2, 0.9, 15, data.StartingPos)
			InutilLib.FlipXByTarget(npc, target, false)
			if spr:IsPlaying("Dance") then
				if not data.VariantState then
					data.VariantState = math.random(1,2) 
					data.Added = 0
				end
				if data.VariantState == 1 then
					if spr:GetFrame() == 2 or spr:GetFrame() == 13 or spr:GetFrame() == 25 or spr:GetFrame() == 35 then
						for i = 0, 360-360/6, 360/6 do
							local proj = InutilLib.FireGenericProjAttack(npc, ProjectileVariant.PROJECTILE_FIRE, 0, npc.Position, (target.Position - npc.Position):Rotated(i):Resized(8))
							--proj.Color = Color(1,0,2)
						end
						npc:PlaySound(SoundEffect.SOUND_FIRE_RUSH, 1, 0, false, 1)
					end
				else
					if npc.FrameCount % 5 == 0 then
						local proj = InutilLib.FireGenericProjAttack(npc, ProjectileVariant.PROJECTILE_FIRE, 0, npc.Position, (target.Position - npc.Position):Rotated(math.random(-5,5)):Resized(9))
						--proj.Color = Color(1,0,2)
						data.Added = data.Added + 20
						InutilLib.SFX:Play(SoundEffect.SOUND_FIRE_RUSH, 0.8, 0, false, 0.8)
						npc:PlaySound(SoundEffect.SOUND_FART, 1, 0, false, 0.5)
					end
				end
			elseif spr:IsFinished("Dance") then
				spr:Play("Idle", true)
				data.State = 1
				data.VariantState = nil
			else
				spr:Play("Dance", true)
			end
		elseif data.State == 3 then
			InutilLib.StrafeAroundTarget(npc, target, 1, 0.9, 35)
			--MoveOrbitAroundTargetType1(npc, target, 2, 0.9, 15, data.StartingPos)
			InutilLib.FlipXByTarget(npc, target, false)
			if spr:IsPlaying("Pound") then
				if spr:GetFrame() == 14 then
					Game():Fart(npc.Position, 110, npc, 1, 0)
					for i = 0, 360-360/6, 360/6 do
						local proj = InutilLib.FireGenericProjAttack(npc, ProjectileVariant.PROJECTILE_ROCK, 0, npc.Position, (target.Position - npc.Position):Rotated(i):Resized(12))
						--proj.Color = Color(1,0,2)
					end
					local hasCandlers = 0
					for _,e in ipairs(Isaac.GetRoomEntities()) do
						if e.Type == EntityType.ENTITY_CANDLER then
							hasCandlers = hasCandlers + 1
						end
					end
					if hasCandlers < 2 then
						Isaac.Spawn(EntityType.ENTITY_CANDLER, 0, 0, npc.Position, Vector.Zero, npc)
					end
					npc:PlaySound(SoundEffect.SOUND_FART, 1, 0, false, 1)
				end
			elseif spr:IsFinished("Pound") then
				spr:Play("Idle", true)
				data.State = 1
			else
				spr:Play("Pound", true)
			end
		elseif data.State == 4 then
			InutilLib.StrafeAroundTarget(npc, target, 1, 0.9, 35)
			--MoveOrbitAroundTargetType1(npc, target, 2, 0.9, 15, data.StartingPos)
			InutilLib.FlipXByTarget(npc, target, true)
			if spr:IsPlaying("Moon") then
				if spr:GetFrame() == 12 then
					data.buttShine = (npc.Position - target.Position):GetAngleDegrees()-180
				end
				if spr:GetFrame() == 18 then
					--local brimstone = EntityLaser.ShootAngle(5, npc.Position, data.buttShine, 15, Vector(0,0), npc)
					local jet = Isaac.Spawn(1000, 148, 0, npc.Position, Vector(0,0), npc):ToEffect()
					jet.Parent = npc
					jet.Rotation = data.buttShine
					for i = 0, 360, 360/6 do
						local proj = InutilLib.FireGenericProjAttack(npc, ProjectileVariant.PROJECTILE_FIRE, 0, npc.Position, (target.Position - npc.Position):Rotated(i):Resized(10))
						--proj.Color = Color(1,0,2)
					end
					npc:PlaySound(SoundEffect.SOUND_FART, 0.8, 0, false, 1)
				end
			elseif spr:IsFinished("Moon") then
				if math.random(1,3) == 3 then
					spr:Play("Moon", true)
				else
					spr:Play("Idle", true)
					data.State = 1
				end
			else
				spr:Play("Moon", true)
			end
		elseif data.State == 5 then
			--MoveOrbitAroundTargetType1(npc, target, 2, 0.9, 18, 0)
			InutilLib.FlipXByTarget(npc, target, true)
			if spr:IsPlaying("Transition") then

			elseif spr:IsFinished("Transition") then
				spr:Play("Idle2", true)
				data.State = 6
				--npc.GridCollisionClass = GridCollisionClass.COLLISION_WALL
			else
				InutilLib.SFX:Play(SoundEffect.SOUND_FIRE_RUSH, 0.8, 0, false, 0.2)
				npc:PlaySound(SoundEffect.SOUND_HUSH_GROWL, 1, 0, false, 0.8)
				spr:Play("Transition", true)
				for _,e in ipairs(Isaac.GetRoomEntities()) do
					if e.Type == 33 and e.Variant == 10 then
						e:Kill()
					end
				end
			end
		elseif data.State == 6 then --idle
			--MoveDiagonalTypeI(npc, 3, false, true)
			InutilLib.StrafeAroundTarget(npc, target, 1.5, 0.9, 35)
			--MoveOrbitAroundTargetType1(npc, target, 2, 0.9, 12, data.StartingPos)
			if math.random(1,2) == 2 and npc.FrameCount % 30 == 0 then
				if math.random(1,2) == 2 then
					local hasFire = 0
					for _,e in ipairs(Isaac.GetRoomEntities()) do
						if e.Type == 33 then
							hasFire = hasFire + 1
						end
					end
					if hasFire > 10 then
						data.State = 10
					else
						data.State = 7
					end
				else
					data.State = 9
				end
			end
			if spr:GetFrame() == 2 then
				if math.random(1,3) == 3 then
					InutilLib.SFX:Play(SoundEffect.SOUND_LOW_INHALE, 0.2, 0, false, 0.9)
				end
				npc:PlaySound(SoundEffect.SOUND_BEAST_FIRE_RING, 1, 0, false, 0.7)
				npc:PlaySound(SoundEffect.SOUND_FORESTBOSS_STOMPS, 0.4, 0, false, 1.4)
			end
		elseif data.State == 7 then
			--MoveOrbitAroundTargetType1(npc, target, 2, 0.9, 18, 0)
			InutilLib.FlipXByTarget(npc, target, true)
			if spr:IsPlaying("DashAway") then
				InutilLib.MoveAwayFromTarget(npc, target, 6, 0.9)
			elseif spr:IsFinished("DashAway") then
				npc.Position = (npc.Position + Vector(60,0):Rotated(math.random(1,360)))
				data.State = 8
				spr:Play("DashAppear", true)
				InutilLib.SFX:Play(SoundEffect.SOUND_FIRE_RUSH, 0.8, 0, false, 0.2)
				npc:PlaySound(SoundEffect.SOUND_BOSS_LITE_ROAR, 1, 0, false, 0.6)
			else
				spr:Play("DashAway", true)
				InutilLib.SFX:Play(SoundEffect.SOUND_FIRE_RUSH, 0.8, 0, false, 0.2)
				npc:PlaySound(SoundEffect.SOUND_BOSS_LITE_HISS, 1, 0, false, 0.6)
			end
		elseif data.State == 8 then
			--MoveOrbitAroundTargetType1(npc, target, 2, 0.9, 18, 0)
			InutilLib.FlipXByTarget(npc, target, true)
			if spr:IsPlaying("DashAppear") then
				InutilLib.MoveDirectlyTowardsTarget(npc, target, 6, 0.9)
				if math.floor(npc.FrameCount % 3) == 0 then
					if math.random(1,2) == 2 then
						local fire = Isaac.Spawn(33, 10, 0, npc.Position, Vector(0,0), npc)
						fire.HitPoints = 3
					end
					local fire = Isaac.Spawn(1000, 147, 0, npc.Position, Vector(0,0), npc)
				end
			elseif spr:IsFinished("DashAppear") then
				spr:Play("Dashing", true)
				InutilLib.MoveDirectlyTowardsTarget(npc, target, 20, 0.9)
			elseif spr:IsPlaying("Dashing") then
				--InutilLib.MoveDirectlyTowardsTarget(npc, target, 4, 0.9)
				if math.floor(npc.FrameCount % 3) == 0 then
					if math.random(1,2) == 2 then
						local fire = Isaac.Spawn(33, 10, 0, npc.Position, Vector(0,0), npc)
						fire.HitPoints = 3
					end
					local fire = Isaac.Spawn(1000, 147, 0, npc.Position, Vector(0,0), npc)
				end
				if spr:GetFrame() == 16 then
					for i = 1,4 do
						local jet = Isaac.Spawn(1000, 148, 0, npc.Position, Vector(0,0), npc):ToEffect()
						jet.Parent = npc
						jet.Rotation = 90 * i
					end
				end
				InutilLib.SFX:Play(SoundEffect.SOUND_FIRE_RUSH, 0.8, 0, false, 0.2)
				npc:PlaySound(SoundEffect.SOUND_BOSS_LITE_ROAR, 1, 0, false, 0.6)
			elseif spr:IsFinished("Dashing") then
				InutilLib.MoveAwayFromTarget(npc, target, 6, 0.9)
				if math.random(1,2) == 2 then
					if math.random(1,2) == 2 then
						data.State = 10
					else
						data.State = 7
					end
				else
					data.State = 6
					spr:Play("Idle2", true)
				end
				Game():ShakeScreen(10)
			end
		elseif data.State == 9 then
			--MoveOrbitAroundTargetType1(npc, target, 2, 0.9, 18, 0)
			InutilLib.StrafeAroundTarget(npc, target, 1, 0.9, 35)
			InutilLib.FlipXByTarget(npc, target, true)
			if spr:IsPlaying("MoonHarder") then
			elseif spr:IsFinished("MoonHarder") then
				data.State = 6
				spr:Play("Idle2", true)
				for i = -45, 45, 70 do
					local jet = Isaac.Spawn(1000, 148, 0, npc.Position, Vector(0,0), npc):ToEffect()
					jet.Parent = npc
					jet.Rotation = data.buttShine + i
				end
				for i = 0, 360-360/8, 360/8 do
					local proj = InutilLib.FireGenericProjAttack(npc, ProjectileVariant.PROJECTILE_FIRE, 0, npc.Position, (target.Position - npc.Position):Rotated(i):Resized(10))
					proj.Scale = 0.3
					--proj.Color = Color(1,0,2)
				end
				InutilLib.SFX:Play(SoundEffect.SOUND_FIRE_RUSH, 0.8, 0, false, 0.8)
				npc:PlaySound(SoundEffect.SOUND_FART, 1, 0, false, 0.5)
				Game():ShakeScreen(10)
			else
				spr:Play("MoonHarder", true)
				data.buttShine = (npc.Position - target.Position):GetAngleDegrees()-180
			end
		elseif data.State == 10 then
			--MoveOrbitAroundTargetType1(npc, target, 2, 0.9, 18, 0)
			InutilLib.FlipXByTarget(npc, target, true)
			if spr:IsPlaying("Assert") then
				if spr:GetFrame() == 18 then
					local fireCount = 0
					for _,e in ipairs(Isaac.GetRoomEntities()) do
						if e.Type == 833 then
							fireCount = fireCount+ 1
						end
						--[[if e.Type == 33 and e.Variant == 10 then
							InutilLib.SetTimer( 30*fireCount, function()
								if e and not e:IsDead() then
									--for i = 1,4 do
									
										--local jet = Isaac.Spawn(1000, 148, 0, e.Position, Vector(0,0), npc):ToEffect()
										--jet.Parent = npc
										--jet.Rotation = (e.Position - target.Position):GetAngleDegrees()-180
										--jet.LifeSpan = 1
										--jet:SetTimeout(1)
										local angle = (e.Position - target.Position):GetAngleDegrees()-180
										local proj = InutilLib.FireGenericProjAttack(npc, ProjectileVariant.PROJECTILE_FIRE, 0, e.Position, (Vector(100,0):Rotated(angle):Resized(8)))
										proj.Scale = 0.3
									--end
									--Isaac.Explode(e.Position, e, 1)
									Game():ShakeScreen(10)
									e:Kill()
								end
							end);
							fireCount = fireCount+ 1
						end]]
					end
					if fireCount < 1 then
						local imp = Isaac.Spawn(833, 0, 0, npc.Position + Vector(30,0), Vector(0,0), npc)
						local imp2 = Isaac.Spawn(833, 0, 0, npc.Position - Vector(30,0), Vector(0,0), npc)
					else
						if math.random(1,2) == 2 then
							for i = 1,4 do	
								local jet = Isaac.Spawn(1000, 148, 0, npc.Position, Vector(0,0), npc):ToEffect()
								jet.Parent = npc
								jet.Rotation = 90 * 1
							end
						else
							for i = 1,4 do	
								local jet = Isaac.Spawn(1000, 148, 0, npc.Position, Vector(0,0), npc):ToEffect()
								jet.Parent = npc
								jet.Rotation = 90 + 45 * 1
							end
						end
						for i = 0, 360-360/8, 360/8 do
							local proj = InutilLib.FireGenericProjAttack(npc, ProjectileVariant.PROJECTILE_FIRE, 0, npc.Position, (target.Position - npc.Position):Rotated(i):Resized(10))
							proj.Scale = 0.3
							--proj.Color = Color(1,0,2)
						end
					end
					InutilLib.SFX:Play(SoundEffect.SOUND_FIRE_RUSH, 0.8, 0, false, 0.2)
					npc:PlaySound(SoundEffect.SOUND_BOSS_SPIT_BLOB_BARF, 1, 0, false, 0.6)
					npc:PlaySound(SoundEffect.SOUND_FORESTBOSS_STOMPS, 1, 0, false, 0.7)
					Game():ShakeScreen(10)
				end
			elseif spr:IsFinished("Assert") then
				data.State = 6
				spr:Play("Idle2", true)
			else
				spr:Play("Assert", true)
			end
		end
		npc.Velocity = npc.Velocity *0.9
		if spr:IsPlaying("Death") and spr:GetFrame() == 1 then
			InutilLib.SFX:Play(SoundEffect.SOUND_FIRE_RUSH, 0.8, 0, false, 0.2)
			npc:PlaySound(SoundEffect.SOUND_BOSS_SPIT_BLOB_BARF, 1, 0, false, 0.6)
			npc:PlaySound(SoundEffect.SOUND_FORESTBOSS_STOMPS, 1, 0, false, 0.7)
			Game():ShakeScreen(10)
		end
	end
end


yandereWaifu:AddCallback(ModCallbacks.MC_NPC_UPDATE, yandereWaifu.MoonBossUpdate, RebekahCurse.Enemies.ENTITY_REBEKAH_ENEMY)

yandereWaifu:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(ent, damage, amount, damageFlag, damageSource, damageCountdownFrames) 
	if damage.Variant == RebekahCurse.Enemies.ENTITY_THEMOON  then

		if damageSource.Type == 1000 and (damageSource.Variant == 148 or damageSource.Variant == 147)then
			return false
		end
	end
end, RebekahCurse.Enemies.ENTITY_REBEKAH_ENEMY)

if StageAPI then	
	yandereWaifu.StageAPIBosses = {
		StageAPI.AddBossData("The Moon", {
			Name = "The Moon",
			Portrait = "gfx/ui/boss/portrait_themoon.png",
			Offset = Vector(0,-15),
			Bossname = "gfx/ui/boss/name_themoon.png",
			Weight = 2,
			Rooms = StageAPI.RoomsList("The Moon Rooms", require("resources.luarooms.bosses.the_moon")),
			Entity = {Type = RebekahCurse.Enemies.ENTITY_REBEKAH_ENEMY, Variant = RebekahCurse.Enemies.ENTITY_THEMOON},
		})
	}
	StageAPI.AddBossToBaseFloorPool({BossID = "The Moon"}, LevelStage.STAGE3_1,StageType.STAGETYPE_REPENTANCE)
end

if HPBars then -- check if the mod is installed
	HPBars.BossDefinitions["620.2200"] = { -- the table BossDefinitions is used to define boss specific content. Entries are defined with "Type.Variant" of the boss
		sprite = "gfx/ui/bossicons/themoon.png", -- path to the .png file that will be used as the icon for this boss
		offset = Vector(-4, 0) -- number of pixels the icon should be moved from its center versus the left-side of the bar
	}
end