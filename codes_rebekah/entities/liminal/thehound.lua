yandereWaifu:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, ent)
	local spr = ent:GetSprite()
	local data = yandereWaifu.GetEntityData(ent)
	local player = ent:GetPlayerTarget()
	if ent.Variant == RebekahCurse.Enemies.ENTITY_THE_HOUND then
		if not data.State then
			spr:Play("Spawn", true)
			SFXManager():Play( RebekahCurse.Sounds.SOUND_HOUND_SPAWN, 1, 0, false, 1 )
			data.State = 0
			ent:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
		else
			--press pressure plates under it
			local grid = InutilLib.room:GetGridEntityFromPos(ent.Position)
			if grid then
				if grid:ToPressurePlate() then
					if grid.State == 0 then
						InutilLib.PressPressurePlate(grid)
					end
				end
			end
			local path = InutilLib.GenerateAStarPath(ent.Position, player.Position, true)
			local function followTarget()
				InutilLib.FollowPath(ent, player, path, 1.5, 0.9)
			end
			local function checkOpportunityToDash()
				if math.random(1,2) == 2 and ent.FrameCount % 3 == 0 then
					if InutilLib.CuccoLaserCollision(ent, 0, 700, player, 30) and InutilLib.room:CheckLine(ent.Position, player.Position, 0, 900, false, false) then
						data.State = 3
						spr:Play("StartDashHori", true)
						spr.FlipX = false
					elseif InutilLib.CuccoLaserCollision(ent, 90, 700, player, 30) and InutilLib.room:CheckLine(ent.Position, player.Position, 0, 900, false, false) then
						data.State = 3
						spr:Play("StartDashFront", true)
					elseif InutilLib.CuccoLaserCollision(ent, 180, 700, player, 30) and InutilLib.room:CheckLine(ent.Position, player.Position, 0, 900, false, false) then
						data.State = 3
						spr:Play("StartDashHori", true)
						spr.FlipX = true
					elseif InutilLib.CuccoLaserCollision(ent, 270, 700, player, 30) and InutilLib.room:CheckLine(ent.Position, player.Position, 0, 900, false, false) then
						data.State = 3
						spr:Play("StartDashBack", true)
					end
				end
			end
			if data.State == 0 then
				if spr:IsFinished("Spawn") then
					data.State = 1
				end
				InutilLib.game:ShakeScreen(5)
			elseif data.State == 1 then --idle
				if ent.Velocity:Length() > 1 then
					data.State = 2
				end
				--animation
				--if not InutilLib.IsPlayingMultiple(spr, "IdleHori", "IdleFront", "IdleBack") then --reset after done shooting
				InutilLib.AnimShootFrame(ent, false, ent.Velocity, "IdleHori", "IdleFront", "IdleBack")
				--end
				ent.Velocity = ent.Velocity * 0.5
				checkOpportunityToDash()
			elseif data.State == 2 then --walk
				if ent.Velocity:Length() <= 1 then
					data.State = 1
				end
				--animation
				--if not InutilLib.IsPlayingMultiple(spr, "WalkHori", "WalkFront", "WalkBack") then --reset after done shooting
				InutilLib.AnimShootFrame(ent, false, ent.Velocity, "WalkHori", "WalkFront", "WalkBack")
				--end
				ent.Velocity = ent.Velocity * 0.8
				checkOpportunityToDash()
			elseif data.State == 3 then --prepare to dash
				if spr:IsFinished("StartDashHori") and not spr.FlipX then
					data.State = 4
					spr:Play("DashingHori", true)
					spr.FlipX = false
					data.DashDir = Vector(10,0)
					SFXManager():Play( RebekahCurse.Sounds.SOUND_HOUND_CHARGE, 1, 0, false, 1 )
				elseif spr:IsFinished("StartDashHori") and spr.FlipX then
					data.State = 4
					spr:Play("DashingHori", true)
					spr.FlipX = true
					data.DashDir = Vector(-10,0)
					SFXManager():Play( RebekahCurse.Sounds.SOUND_HOUND_CHARGE, 1, 0, false, 1 )
				elseif spr:IsFinished("StartDashBack") then
					data.State = 4
					spr:Play("DashingBack", true)
					data.DashDir = Vector(0,-10)
					SFXManager():Play( RebekahCurse.Sounds.SOUND_HOUND_CHARGE, 1, 0, false, 1 )
				elseif spr:IsFinished("StartDashFront") then
					data.State = 4
					spr:Play("DashingFront", true)
					data.DashDir = Vector(0,10)
					SFXManager():Play( RebekahCurse.Sounds.SOUND_HOUND_CHARGE, 1, 0, false, 1 )
				end
				ent.Velocity = ent.Velocity * 0.6
			elseif data.State == 4 then --the actual dash
				if ent:CollidesWithGrid() then
					InutilLib.game:ShakeScreen(5)
					data.State = 5
				end
				ent.Velocity = data.DashDir * 2.5
				local radius = 50 + ent.Size
				for i, e in pairs(Isaac.GetRoomEntities()) do
					if e:IsEnemy() and e.Position:Distance(ent.Position) < radius + e.Size then
						if GetPtrHash(e) ~= GetPtrHash(ent) then
							e:TakeDamage(7, 0, EntityRef(ent), 10)
						end
					end
				end
				for x = math.ceil(radius/40)*-1, math.ceil(radius/40) do
					for y = math.ceil(radius/40)*-1, math.ceil(radius/40) do
						local grid = InutilLib.room:GetGridEntityFromPos(Vector(ent.Position.X+40*x, ent.Position.Y+40*y))
						if grid and (grid:ToRock() or grid:ToPoop() or grid:ToTNT()) then
							if InutilLib.GetGridsInRadius(ent.Position, grid.Position, radius) then
								grid:Destroy()
							end
						end
					end
				end
				if not data.IsBackroomsHunting and ent.FrameCount % 3 == 0 then
					for i = -45, 45, 90 do
						local dir = ent.Velocity
						local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, (dir):Resized(6.5):Rotated(i))
						proj.Scale = 0.9
					end
					local eff = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_BLACK, 0, ent.Position,  Vector.Zero, nil):ToEffect();
					InutilLib.RevelSetCreepData(eff)
					InutilLib.RevelUpdateCreepSize(eff, 12, true)
					eff.Visible = false
					eff.RenderZOffset = 50
					InutilLib.SetTimer(5, function()
						eff.Visible = true
					end)
				end
			elseif data.State == 5 then --finish dashing
				if InutilLib.IsFinishedMultiple(spr, "DashEndHori", "DashEndBack", "DashEndFront") then --reset after done shooting
					data.State = 1
				elseif not InutilLib.IsPlayingMultiple(spr, "DashEndHori", "DashEndBack", "DashEndFront") then
					if spr:IsPlaying("DashingHori") and not spr.FlipX then
						spr:Play("DashEndHori", true)
						spr.FlipX = false
						SFXManager():Play(SoundEffect.SOUND_POT_BREAK, 1, 0, false, 0.7 )
					elseif spr:IsPlaying("DashingHori") and spr.FlipX then
						spr:Play("DashEndHori", true)
						spr.FlipX = true
						SFXManager():Play(SoundEffect.SOUND_POT_BREAK, 1, 0, false, 0.7 )
					elseif spr:IsPlaying("DashingBack") then
						spr:Play("DashEndBack", true)
						SFXManager():Play(SoundEffect.SOUND_POT_BREAK, 1, 0, false, 0.7 )
					elseif spr:IsPlaying("DashingFront")  then
						spr:Play("DashEndFront", true)
						SFXManager():Play(SoundEffect.SOUND_POT_BREAK, 1, 0, false, 0.7 )
					end
				end
				ent.Velocity = ent.Velocity * 0.6
			end
			if (data.State > 0 and data.State < 3) and path then --follow
				followTarget()
			end
		end
	end
end, RebekahCurse.Enemies.ENTITY_REBEKAH_ENEMY)

yandereWaifu:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, damage, amount, damageFlag, damageSource, damageCountdownFrames) 
	if damage.Variant == RebekahCurse.Enemies.ENTITY_THE_HOUND and yandereWaifu.GetEntityData(damage).IsInvincible then
		return false
	end
end, RebekahCurse.Enemies.ENTITY_REBEKAH_ENEMY)
