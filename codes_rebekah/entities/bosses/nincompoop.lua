yandereWaifu:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, ent)
	local spr = ent:GetSprite()
	local data = yandereWaifu.GetEntityData(ent)
	local player = ent:GetPlayerTarget()
	local room = ILIB.room
	local invert = true
	if data.path == nil then data.path = ent.Pathfinder end
	if ent.Variant == RebekahCurseEnemies.ENTITY_NINCOMPOOP then
		if not data.State then
			--spr:Play("Idle")
			data.State = 0
			ent:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
			ent:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
			ent:AddEntityFlags(EntityFlag.FLAG_SLIPPERY_PHYSICS)
		else
			if data.State == 0 then
				if not spr:IsPlaying("Idle") then
					spr:Play("Idle", true)
				end
				if math.random(1,3) == 3 and ent.FrameCount % 5 == 0 then
					if math.random(1,2) == 2 then
						data.State = 1
					else
						data.State = 3
					end
				end
				ent:GetSprite().FlipX = false
			elseif data.State == 1 then
				if spr:IsFinished("Whistle") then
					if math.random(1,3) == 3 then
						data.State = 7
					else
						data.State = 2
					end
					InutilLib.SFX:Stop( RebekahCurseSounds.SOUND_NINCOMPOOP_WHISTLE);
				elseif not spr:IsPlaying("Whistle") then
					spr:Play("Whistle", true)
					InutilLib.SFX:Play( RebekahCurseSounds.SOUND_NINCOMPOOP_WHISTLE, 1, 0, false, 1.4);
				end
			elseif data.State == 2 then
				if spr:IsFinished("Shoot") or spr:IsFinished("SmileShoot") then
					data.State = 0
				elseif not spr:IsPlaying("Shoot") and not spr:IsPlaying("SmileShoot") then
					local rng = math.random(1,2)
					if rng == 1 then
						spr:Play("Shoot", true)
					else
						spr:Play("SmileShoot", true)
					end
				elseif spr:IsPlaying("Shoot") then
					if spr:GetFrame() == 1 then
						for i = 0, 4 do
							InutilLib.SetTimer( i*15, function()
								for i = -15, 15, 30 do
									local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, ((player.Position - ent.Position):Rotated(i)):Resized(10))
									proj.Scale = 1.5
								end
							end)
						end
						InutilLib.SFX:Play( RebekahCurseSounds.SOUND_NINCOMPOOP_SPIT, 1, 0, false, 1.3);
					end
				elseif spr:IsPlaying("SmileShoot") then
					if spr:GetFrame() == 22 then
						for i = -45, 45, 30 do
							--if i ~= 0 then
								local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, ((player.Position - ent.Position):Rotated(i)):Resized(10))
								proj.Scale = 1.5
							--end
						end
						InutilLib.SFX:Play( RebekahCurseSounds.SOUND_NINCOMPOOP_SPIT, 1, 0, false, 1.3);
					elseif spr:GetFrame() == 27 then
						for i = -30, 30, 30 do
							local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, ((player.Position - ent.Position):Rotated(i)):Resized(10))
							proj.Scale = 1.5
						end
						InutilLib.SFX:Play( RebekahCurseSounds.SOUND_NINCOMPOOP_SPIT, 1, 0, false, 1.3);
					end
				end
				local angle = (player.Position - ent.Position):GetAngleDegrees()
				if angle >= -90 and angle <= 90 then -- Left
					if invert == true then result = true else result = false end
				elseif angle >= 90 or angle <= -90 then -- Right
					if invert == true then result = false else result = true end
				end
				ent:GetSprite().FlipX = result
			elseif data.State == 3 then
				if spr:IsFinished("BeginCharge") then
					local rng = math.random(1,20)
					--[[if rng <= 10 and rng >= 0 then
						data.State = 4
					elseif rng <= 15 and rng >= 10 then
						data.State = 6
					elseif rng <= 18 and rng >= 15 then
						data.State = 7
					else
						data.State = 8
					end]]
					if rng <= 10 and rng >= 0 then
						data.State = 4
					elseif rng <= 15 and rng >= 10 then
						data.State = 6
					else
						data.State = 8
					end
				elseif not spr:IsPlaying("BeginCharge") then
					spr:Play("BeginCharge", true)
				end
			elseif data.State == 4 then
				if spr:IsFinished("DashBeautiful") then
					if data.DashTimes >= 3 then
						data.State = 5
					else
						spr:Play("DashBeautiful", true)
						data.DashTimes = data.DashTimes + 1
						data.OriginalDash = (player.Position - ent.Position)
					end
				elseif not spr:IsPlaying("DashBeautiful") then
					spr:Play("DashBeautiful", true)
					data.DashTimes = 0
					data.OriginalDash = (player.Position - ent.Position)
					InutilLib.SFX:Play( RebekahCurseSounds.SOUND_NINCOMPOOP_SPIT, 1, 0, false, 1);
				elseif spr:IsPlaying("DashBeautiful") then
					if spr:GetFrame() < 10 then
						if ent.FrameCount % 5 == 0 then
							ent.Velocity = ent.Velocity + data.OriginalDash:Resized(4.5)
							--[[local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_SLIPPERY_BROWN, 0, ent.Position, Vector(0,0), ent):ToEffect();
							creep:Update()
							creep.Timeout = 550]]
						end
					--[[elseif spr:GetFrame() < 20 and ent.FrameCount % 3 == 0 then
						ent.Velocity = ent.Velocity * 0.99]]
					elseif ent.FrameCount % 3 == 0 and spr:GetFrame() < 25 then
						InutilLib.MoveDirectlyTowardsTarget(ent, player, 4.5, 1)
						--[[if ent.FrameCount % 5 == 0 then
							local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_SLIPPERY_BROWN, 0, ent.Position, Vector(0,0), ent):ToEffect();
							creep:Update()
							creep.Timeout = 550
						end]]
					elseif spr:GetFrame() > 25 then 
						--ent.Velocity = ent.Velocity * 0.99
					else
						ent.Velocity = ent.Velocity * 0.999
					end
				end
				InutilLib.FlipXByVec(ent, invert)
			elseif data.State == 5 then --tired
				if spr:IsFinished("Tired") then
					data.State = 0
					--InutilLib.SFX:Stop( RebekahCurseSounds.SOUND_NINCOMPOOP_PANT);
				elseif spr:IsEventTriggered("Pant") then
					--InutilLib.SFX:Play( RebekahCurseSounds.SOUND_NINCOMPOOP_PANT, 1, 0, false, 1);
				elseif not spr:IsPlaying("Tired") then
					spr:Play("Tired", true)
				end
			elseif data.State == 6 then
				if spr:IsFinished("LongDash") then
					data.State = 5
				elseif not spr:IsPlaying("LongDash") then
					spr:Play("LongDash", true)
				elseif spr:IsPlaying("LongDash") then
					if spr:GetFrame() == 1 then
						InutilLib.MoveDirectlyTowardsTarget(ent, player, 11, 0.9)
					end
					if ent.FrameCount % 3 == 0 and spr:GetFrame() < 120 then
						--[[if ent.FrameCount % 5 == 0 then
							local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_SLIPPERY_BROWN, 0, ent.Position, Vector(0,0), ent):ToEffect();
							creep:Update()
							creep.Timeout = 550
						end]]
						if ent.FrameCount % 30 == 0 then
							InutilLib.MoveDirectlyTowardsTarget(ent, player, 11, 0.9)
							local fly = Isaac.Spawn(EntityType.ENTITY_DIP, 0, 0, ent.Position, Vector(0,0), ent):ToNPC()
							fly:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
							ILIB.game:Fart(ent.Position, 100, ent, 1, 0)
							--[[local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_SLIPPERY_BROWN, 0, ent.Position, Vector(0,0), ent):ToEffect();
							creep.Scale = 1.5
							creep.SpriteScale = Vector(1.5, 1.5)
							creep:Update()
							creep.Timeout = 550]]
						end
					elseif spr:GetFrame() > 120 then
						ent.Velocity = ent.Velocity * 0.95
					end
				end
				InutilLib.FlipXByVec(ent, invert)
			elseif data.State == 7 then
				if spr:IsFinished("ShortDash") then
					data.State = 0
				elseif not spr:IsPlaying("ShortDash") then
					spr:Play("ShortDash", true)
				elseif spr:IsPlaying("ShortDash") then
					if spr:GetFrame() == 1 then
						InutilLib.MoveDirectlyTowardsTarget(ent, player, 8, 0.9)
					end
				end
				InutilLib.FlipXByVec(ent, invert)
			elseif data.State == 8 then --just happy
				if spr:IsFinished("Shoot") then
					data.State = 0
				elseif not spr:IsPlaying("Shoot") then
					spr:Play("Shoot", true)
				elseif spr:IsPlaying("Shoot") then
					if spr:GetFrame() == 1 then
						for i = 0, 4 do
							InutilLib.SetTimer( i*15, function()
								local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, ((player.Position - ent.Position)):Resized(10))
								proj.Scale = 1.5
								proj:AddProjectileFlags(ProjectileFlags.SMART)
							end)
						end
						InutilLib.SFX:Play( RebekahCurseSounds.SOUND_NINCOMPOOP_SPIT, 1, 0, false, 1.3);
					end
				end
				ent:GetSprite().FlipX = false
			end
		end
		ent.Velocity = ent.Velocity * 0.95
	end
end, RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY)


yandereWaifu:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, damage, amount, damageFlag, damageSource, damageCountdownFrames) --invincibilityframe when dashing or whatnot
	if damage:IsEnemy() and damage:ToNPC().Type == RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY and damage:ToNPC().Variant == RebekahCurseEnemies.ENTITY_NINCOMPOOP then
		if damage:ToNPC():GetSprite():IsPlaying("DashBeautiful") or (damage:ToNPC():GetSprite():IsPlaying("BeginCharge") and damage:ToNPC():GetSprite():GetFrame() >= 15) then
			return false
		end
	end
end)


if StageAPI and StageAPI.Loaded then	
	yandereWaifu.NincompoopStageAPIRooms = {
		StageAPI.AddBossData("Nincompoop", {
			Name = "Nincompoop",
			Portrait = "gfx/ui/boss/portrait_nincompoop.png",
			Offset = Vector(0,-15),
			Bossname = "gfx/ui/boss/name_nincompoop.png",
			Weight = 2,
			Rooms = StageAPI.RoomsList("Nincompoop Rooms", require("resources.luarooms.bosses.nincompoop")),
			Entity =  {Type = RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY, Variant = RebekahCurseEnemies.ENTITY_NINCOMPOOP},
		})
	}

	StageAPI.AddBossToBaseFloorPool({BossID = "Nincompoop"},LevelStage.STAGE1_1,StageType.STAGETYPE_REPENTANCE_B)
	StageAPI.AddBossToBaseFloorPool({BossID = "Nincompoop"},LevelStage.STAGE1_2,StageType.STAGETYPE_REPENTANCE_B)
end