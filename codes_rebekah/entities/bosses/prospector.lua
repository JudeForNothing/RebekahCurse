yandereWaifu:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, ent)
	local spr = ent:GetSprite()
	local data = yandereWaifu.GetEntityData(ent)
	local player = ent:GetPlayerTarget()
	local room = ILIB.room
	if ent.Variant == RebekahCurseEnemies.ENTITY_THEPROSPECTOR then
		if ent.SubType == 1 then
			local engi 
			for i, v in ipairs(Isaac.FindByType(RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY, RebekahCurseEnemies.ENTITY_THEPROSPECTOR, 0, false, false)) do
				if v then engi = v break end
			end
			if not engi then
				Isaac.Explode(ent.Position, ent, 15)
				ent:Die()
			end
			if not data.State then
				--spr:Play("Idle")
				ent:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
				ent:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
				data.State = 0
				data.Upgrade = 0
			end
			if spr:IsFinished("SpawnBack") then
				data.State = 3
			end
			if spr:IsFinished("Keep") then
				ent.Visible = false
			end
			if data.State == 0 then
				if data.Upgrade > 0 then
					data.State = 1
					data.Upgrade = data.Upgrade - 1
				end
			elseif data.State == 1 then
				if math.random(1,3) == 3 and ent.FrameCount % 15 == 0 then
					data.State = 2
				end
				if not spr:IsPlaying("Level1Idle") then
					spr:Play("Level1Idle", true)
				end
				ent.Velocity = ent.Velocity * 0
				if data.Upgrade > 0 then
					data.State = 3
					data.Upgrade = data.Upgrade - 1
				end
			elseif data.State == 2 then --shoot normal
				if spr:IsFinished("Level1Shoot") then
					data.State = 1
				elseif not spr:IsPlaying("Level1Shoot") then
					spr:Play("Level1Shoot", true)
				else
					if spr:WasEventTriggered("Shoot") and ent.FrameCount % 5 == 0 then
						data.targetVector = (player.Position - ent.Position)
						local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, (data.targetVector):Resized(12))
						proj.Scale = 0.9
						InutilLib.SFX:Play(SoundEffect.SOUND_WORM_SPIT, 1, 0, false, 1)
					end
				end
			elseif data.State == 3 then
				if math.random(1,5) == 5 and ent.FrameCount % 7 == 0 then
					data.State = 4
				end
				if not spr:IsPlaying("Level2Idle") then
					spr:Play("Level2Idle", true)
				end
				ent.Velocity = ent.Velocity * 0
				if data.Upgrade > 0 then
					data.HasRockets = true
					data.Upgrade = data.Upgrade - 1
				end
			elseif data.State == 4 then --shoot normal
				if spr:IsFinished("Level2Shoot") then
					data.State = 5
				elseif not spr:IsPlaying("Level2Shoot") then
					spr:Play("Level2Shoot", true)
				else
					if spr:WasEventTriggered("Shoot") and ent.FrameCount % 3 == 0 then
						data.targetVector = (player.Position - ent.Position)
						local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, (data.targetVector):Resized(12))
						proj.Scale = 0.7
						InutilLib.SFX:Play(SoundEffect.SOUND_WORM_SPIT, 1, 0, false, 1)
					end
				end
			elseif data.State == 5 then --shoot normal
				if spr:IsFinished("Level2Shoot2") then
					data.State = 3
				elseif not spr:IsPlaying("Level2Shoot2") then
					spr:Play("Level2Shoot2", true)
				else
					if spr:WasEventTriggered("Shoot") and ent.FrameCount % 5 == 0 then
						data.targetVector = (player.Position - ent.Position)
						local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, (data.targetVector):Resized(10))
						InutilLib.MakeProjectileLob(proj, 1.5, 9)
						proj:AddProjectileFlags(ProjectileFlags.BOUNCE_FLOOR)
						proj.Scale = 1.4
						InutilLib.SFX:Play(SoundEffect.SOUND_WORM_SPIT, 1, 0, false, 0.8)
					end
				end
			end
			if data.State >= 3 then
				if data.HasRockets then
					if not spr:IsOverlayPlaying("Level3Idle") and not spr:IsOverlayPlaying("Level3Shoot") then
						spr:PlayOverlay("Level3Idle", true)
					elseif spr:IsOverlayPlaying("Level3Idle") then
						if ent.FrameCount % 120 == 0 then
							spr:PlayOverlay("Level3Shoot", true)
						end
					elseif spr:IsOverlayPlaying("Level3Shoot") then
						if spr:GetOverlayFrame() == 36 then
							Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurseEnemies.ENTITY_SENTRYROCKETTARGET, 0, player.Position, Vector.Zero, eff)
						end
					end
				end
			end
		else
			if not data.QueueUpgrade then data.QueueUpgrade = 0 end
			local sentry 
			for i, v in ipairs(Isaac.FindByType(RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY, RebekahCurseEnemies.ENTITY_THEPROSPECTOR, 1, false, false)) do
				if v then sentry = v break end
			end
			if sentry then
				if ent.HitPoints < ent.MaxHitPoints*0.8 and not data.HasNotYetUpgradeOnce then
					data.QueueUpgrade = data.QueueUpgrade + 1
					data.HasNotYetUpgradeOnce = true
				elseif ent.HitPoints < ent.MaxHitPoints*0.5 and not data.HasNotYetUpgradeTwice then
					data.QueueUpgrade = data.QueueUpgrade + 1
					data.HasNotYetUpgradeTwice = true
				elseif ent.HitPoints < ent.MaxHitPoints*0.3 and not data.HasNotYetUpgradeThrice then
					data.QueueUpgrade = data.QueueUpgrade + 1
					data.HasNotYetUpgradeThrice = true
				end
			end
			if not data.State then
				--spr:Play("Idle")
				ent:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
				ent:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
				data.State = 0
			else
				if data.State == 0 then
					if spr:IsFinished("Appear") then
						data.State = 1
					elseif not spr:IsPlaying("Appear") then
						spr:Play("Appear", true)
					end
					ent.Velocity = ent.Velocity * 0
				elseif data.State == 1 then
					if math.random(1,3) == 3 and ent.FrameCount % 7 == 0 then
						if math.random(1,2) == 2 then
							data.State = 2
						end
					end
					if not spr:IsPlaying("Idle") then
						spr:Play("Idle", true)
					end
					ent.Velocity = ent.Velocity * 0
				elseif data.State == 2 then --shoot normal
					if spr:IsFinished("Shoot") then
						data.State = 3
					elseif not spr:IsPlaying("Shoot") then
						spr:Play("Shoot", true)
						InutilLib.SFX:Play( RebekahCurseSounds.SOUND_PROSPECTOR_SHOOT, 1, 0, false, 1);
					else
						if spr:IsEventTriggered("Shoot") then
							data.targetVector = (player.Position - ent.Position)
							local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, (data.targetVector):Resized(12))
							proj.Scale = 1.2
						elseif spr:IsEventTriggered("Shoot2") then
							for i = -7.5, 7.5, 15 do
								--if i ~= 0 then
									local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, (data.targetVector):Rotated(i):Resized(12))
									proj.Scale = 1.2
								--end
							end
						elseif spr:IsEventTriggered("Shoot3") then
							for i = -15, 15, 15 do
								local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, (data.targetVector):Rotated(i):Resized(12))
								proj.Scale = 1.2
							end
						end
						--[[
							if spr:IsEventTriggered("Shoot") then
							data.targetVector = (player.Position - ent.Position)
							local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, (data.targetVector):Resized(10))
							proj.Scale = 1.1
						elseif spr:IsEventTriggered("Shoot2") then
							for i = -45, 45, 30 do
								--if i ~= 0 then
									local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, (data.targetVector):Rotated(i):Resized(10))
									proj.Scale = 1.1
								--end
							end
						elseif spr:IsEventTriggered("Shoot3") then
							for i = -30, 30, 30 do
								local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, (data.targetVector):Rotated(i):Resized(10))
								proj.Scale = 1.1
							end
						end
						]]
					end
				elseif data.State == 3 then --flip
					if spr:IsFinished("Jump") or spr:IsFinished("JumpBack") then
						data.State = 4
					elseif not spr:IsPlaying("Jump") and not spr:IsPlaying("JumpBack") then
						spr:Play("Jump", true)
						InutilLib.SFX:Play( RebekahCurseSounds.SOUND_PROSPECTOR_GRUNT, 1, 0, false, 1);
						data.targetLanding = room:FindFreePickupSpawnPosition((ent.Position - Vector(math.random(150,250),0)):Rotated(1,360),1) --(Vector.FromAngle((ent.Position - Vector(10,0)):GetAngleDegrees() + math.random(1,360)):Resized(math.random(1,2)))
					else
						if spr:IsEventTriggered("Jump") then
							ent.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
							ent.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
						end
						if spr:WasEventTriggered("Jump") then
							ent.Velocity = ((ent.Velocity * 0.01) + ((data.targetLanding- ent.Position)*0.2))
						else
							ent.Velocity = ent.Velocity * 0.8
							--ent.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
						end
					end
				elseif data.State == 4 then --burrow
					ent.Visible = false
					ent.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
					ent.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
					local sentry 
					for i, v in ipairs(Isaac.FindByType(RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY, RebekahCurseEnemies.ENTITY_THEPROSPECTOR, 1, false, false)) do
						if v then sentry = v break end
					end
						if data.BurrowEndPos == nil then
							if data.QueueUpgrade and data.QueueUpgrade > 0 then
								if sentry then
									data.BurrowEndPos = room:FindFreePickupSpawnPosition(sentry.Position+(Vector(220,0)), 1)
									if math.random(1,2) == 2 then
										data.BurrowEndPos = room:FindFreePickupSpawnPosition(sentry.Position+(Vector(-220,0)), 1)
									end
									--data.BurrowEndPos = room:FindFreePickupSpawnPosition(sentry.Position, 1)
								end
							elseif ent.HitPoints < ent.MaxHitPoints*0.3 and data.HasNotYetUpgradeThrice and math.random(1,3) == 3 then
								if sentry then
									data.BurrowEndPos = room:FindFreePickupSpawnPosition(sentry.Position+(Vector(60,0)), 1)
									if math.random(1,2) == 2 then
										data.BurrowEndPos = room:FindFreePickupSpawnPosition(sentry.Position+(Vector(-60,0)), 1)
									end
									data.WillTakeSentry = sentry
									--data.BurrowEndPos = room:FindFreePickupSpawnPosition(sentry.Position, 1)
								end
							else
								data.WillGoShotgun = false
								if math.random(1,3) == 3 then
									data.WillGoShotgun = true
									local pos
									if math.random(1,2) == 1 then
										pos = Vector(room:GetTopLeftPos().X, player.Position.Y)
									else
										pos = Vector(room:GetBottomRightPos().X, player.Position.Y)
									end
									data.BurrowEndPos = room:FindFreePickupSpawnPosition(pos, 1)
								else
									data.BurrowEndPos = room:GetRandomPosition(3)--room:FindFreePickupSpawnPosition((ent.Position - Vector(3,0)):Rotated(1,360):Resized(math.random(2,4)),1) --(Vector.FromAngle((ent.Position - Vector(10,0)):GetAngleDegrees() + math.random(1,360)):Resized(math.random(1,2)))
								end
							end
						elseif data.BurrowEndPos and data.BurrowEndPos:Distance(ent.Position) <= 50 then
							if data.QueueUpgrade and data.QueueUpgrade > 0 then
								data.State = 6
								data.QueueUpgrade = data.QueueUpgrade - 1
								InutilLib.SFX:Play( RebekahCurseSounds.SOUND_PROSPECTOR_GRUNT, 1, 0, false, 1);
							elseif data.WillTakeSentry then
								data.WillTakeSentry:GetSprite():Play("Keep", true)
								yandereWaifu.GetEntityData(data.WillTakeSentry).State = -1
								data.DropBackSentry = data.WillTakeSentry
								data.WillTakeSentry = nil

								if math.random(1,2) == 1 then
									pos = Vector(room:GetTopLeftPos().X, player.Position.Y)
								else
									pos = Vector(room:GetBottomRightPos().X, player.Position.Y)
								end
								data.BurrowEndPos = room:FindFreePickupSpawnPosition(pos, 1)
								data.DropBackSentry:GetSprite():RemoveOverlay()
								data.DropBackSentry.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
							elseif data.DropBackSentry then
								data.DropBackSentry:ToNPC():GetSprite():Play("SpawnBack", true)
								data.DropBackSentry.Position = data.BurrowEndPos
								data.State = 0
								data.DropBackSentry.Visible = true
								data.DropBackSentry.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
								data.DropBackSentry = false
							elseif data.WillGoShotgun then
								data.State = 5
								InutilLib.SFX:Play( RebekahCurseSounds.SOUND_PROSPECTOR_GRUNT, 1, 0, false, 1);
							else
								data.State = 0
								InutilLib.SFX:Play( RebekahCurseSounds.SOUND_PROSPECTOR_GRUNT, 1, 0, false, 1);
							end
							if not data.DropBackSentry then
								data.BurrowEndPos = nil
								ent.Velocity = Vector.Zero
								ent.Visible = true
								ent.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
								ent.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
							end
						else
							ent.Velocity = ((ent.Velocity * 0.9) + (data.BurrowEndPos- ent.Position) ):Resized(8) + Vector(math.random(-5,5),math.random(-5,5))
							if ent.FrameCount % 2 == 0 then
								local crack = Isaac.Spawn( EntityType.ENTITY_EFFECT, 72, 0, ent.Position, Vector(0,0), ent ):ToEffect();
								crack.Timeout = 1
							end
						end

				elseif data.State == 5 then --shotgun
					if spr:IsFinished("ShootShotgun") or spr:IsFinished("ShootShotgun3x")  then
						data.State = 3
						spr.FlipX = false
					elseif not spr:IsPlaying("ShootShotgun") and not spr:IsPlaying("ShootShotgun3x") then
						if math.random(1,3) == 3 then
							spr:Play("ShootShotgun3x", true)
						else
							spr:Play("ShootShotgun", true)
						end
						local wall = InutilLib.ClosestHorizontalWall(ent)
						if wall == Direction.RIGHT then
							data.targetVector = Vector(-10,0)
						else
							data.targetVector = Vector(10,0)
							spr.FlipX = true
						end
						InutilLib.SFX:Play( RebekahCurseSounds.SOUND_PROSPECTOR_YEEE_HOO, 1, 0, false, 1);
					else
						if spr:IsEventTriggered("ShootShotgun") then
							for i = 0, math.random(8,10) do
								local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, (data.targetVector):Rotated(math.random(-30,30)):Resized(math.random(8,18)))
								proj.Scale = math.random(3,13)/10
							end
							InutilLib.SFX:Play( RebekahCurseSounds.SOUND_PROSPECTOR_SHOTGUN, 1, 0, false, 1);
						end
						--[[
							if spr:IsEventTriggered("Shoot") then
							data.targetVector = (player.Position - ent.Position)
							local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, (data.targetVector):Resized(10))
							proj.Scale = 1.1
						elseif spr:IsEventTriggered("Shoot2") then
							for i = -45, 45, 30 do
								--if i ~= 0 then
									local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, (data.targetVector):Rotated(i):Resized(10))
									proj.Scale = 1.1
								--end
							end
						elseif spr:IsEventTriggered("Shoot3") then
							for i = -30, 30, 30 do
								local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, (data.targetVector):Rotated(i):Resized(10))
								proj.Scale = 1.1
							end
						end
						]]
					end
				elseif data.State == 6 then --upgrades people!
					local sentry 
					for i, v in ipairs(Isaac.FindByType(RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY, RebekahCurseEnemies.ENTITY_THEPROSPECTOR, 1, false, false)) do
						if v then sentry = v break end
					end
					if sentry then
						if spr:IsFinished("Upgrade") then
							data.State = 3
							spr.FlipX = false
						elseif not spr:IsPlaying("Upgrade") then
							spr:Play("Upgrade", true)
							InutilLib.SFX:Play( RebekahCurseSounds.SOUND_PROSPECTOR_GOING_UP, 1, 0, false, 1);
						elseif spr:IsEventTriggered("Hit") then
							InutilLib.SFX:Play( RebekahCurseSounds.SOUND_PROSPECTOR_WRENCH, 1, 0, false, 1);
						else
							if spr:GetFrame() == 70 then
								yandereWaifu.GetEntityData(sentry).Upgrade = yandereWaifu.GetEntityData(sentry).Upgrade + 1
							end
							InutilLib.FlipXByTarget(ent, sentry, false)
						end
					else
						data.State = 1
					end
				end
			end
		end
	end
end, RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY)


yandereWaifu:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, function(_, ent)
	local spr = ent:GetSprite()
	local data = yandereWaifu.GetEntityData(ent)
	if ent.Variant == RebekahCurseEnemies.ENTITY_THEPROSPECTOR and ent.SubType == 1 then
		Isaac.Explode(ent.Position, ent, 15)
		for i = 0, math.random(5,7) do
			InutilLib.SetTimer( 7 * i, function()
				local tear = ILIB.game:Spawn( EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_ROCK, Isaac.GetRandomPosition(), Vector.Zero, ent, 0, 0):ToProjectile()
				tear.Scale = math.random(12,16)/10;
				tear.Height = -520;
				tear.FallingAccel = 1.3;
			end);
			
		end
		--im lazy lool
		local engi 
		for i, v in ipairs(Isaac.FindByType(RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY, RebekahCurseEnemies.ENTITY_THEPROSPECTOR, 0, false, false)) do
			if v then engi = v break end
		end
		if engi then
			InutilLib.SFX:Play( RebekahCurseSounds.SOUND_PROSPECTOR_SENTRY_DOWN, 1, 0, false, 1);
		end
	end
end,RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, function(_, ent)
	local spr = ent:GetSprite()
	local data = yandereWaifu.GetEntityData(ent)
	local player = ent:GetPlayerTarget()
	if ent.Variant == RebekahCurseEnemies.ENTITY_THEPROSPECTOR and ent.SubType == 0 then
		if spr:IsPlaying("Death") and spr:GetFrame() == 1 then
			InutilLib.SFX:Play( RebekahCurseSounds.SOUND_PROSPECTOR_DEATH, 1, 0, false, 1);
		end
		if spr:IsEventTriggered("Explosion") and data.DidNotExplode then
			ent:BloodExplode()
			data.DidNotExplode = true
		end
	end
end,RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY)



yandereWaifu:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, damage, amount, damageFlag, damageSource, damageCountdownFrames) --invincibilityframe when dashing or whatnot

	if damage.Variant == RebekahCurseEnemies.ENTITY_THEPROSPECTOR then
		if damage.SubType == 1 then
			return false
		end
		if damageSource.Entity.Type == 4 and damageSource.Entity.Variant == 177013 and damageSource.Entity.SubType == 177 then
			return false
		end
	end
end, RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local sprite = eff:GetSprite()
	local data = yandereWaifu.GetEntityData(eff)
	
	local room =  Game():GetRoom()
	--function code
	if eff.FrameCount == 1 then
		sprite:Play("Idle", true)
		data.SoundFrame = 1
	elseif sprite:IsFinished("Idle") then
		sprite:Play("Blink",true)
	elseif eff.FrameCount >= 30 then
		Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurseEnemies.ENTITY_SENTRYROCKETNUKE, 0, eff.Position, Vector.Zero, eff) --heart effect
		eff:Remove()
	end

end, RebekahCurseEnemies.ENTITY_SENTRYROCKETTARGET)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local sprite = eff:GetSprite()
	local data = yandereWaifu.GetEntityData(eff)
	eff.GridCollisionClass =  EntityGridCollisionClass.GRIDCOLL_NOPITS 
	
	local room =  Game():GetRoom()
	--function code
	if sprite:GetFrame() == 25 then
		eff.Velocity = Vector.Zero
	else
		eff.Velocity = eff.Velocity * 0.8
	end
	if eff.FrameCount == 1 then
		if eff.SubType == 0 then
			sprite:Play("Falling", true)
		elseif eff.SubType == 1 then
			sprite:Play("FallingSingular", true)
		end
	elseif sprite:IsEventTriggered("Blow") then
		local megumin = Isaac.Spawn(EntityType.ENTITY_BOMBDROP, 177013, 177, eff.Position, Vector(0,0), eff):ToBomb() --this is a workaround to make explosions larger
		megumin:SetExplosionCountdown(1)
		megumin.Visible = false
		megumin.RadiusMultiplier = data.CustomRadius or 1.6
	elseif sprite:IsFinished("Falling") or sprite:IsFinished("FallingSingular") then
		eff:Remove()
	end
end, RebekahCurseEnemies.ENTITY_SENTRYROCKETNUKE)