yandereWaifu:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, ent)
	local spr = ent:GetSprite()
	local data = yandereWaifu.GetEntityData(ent)
	local player = ent:GetPlayerTarget()
	if ent.Variant == RebekahCurseEnemies.ENTITY_THE_HOUND then
		if not data.State then
			spr:Play("Spawn", true)
			data.State = 0
			ent:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
		else
			--press pressure plates under it
			local grid = ILIB.room:GetGridEntityFromPos(ent.Position)
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
					if InutilLib.CuccoLaserCollision(ent, 0, 700, player) and ILIB.room:CheckLine(ent.Position, player.Position, 0, 900, false, false) then
						data.State = 3
						spr:Play("StartDashHori", true)
						spr.FlipX = false
					elseif InutilLib.CuccoLaserCollision(ent, 90, 700, player) and ILIB.room:CheckLine(ent.Position, player.Position, 0, 900, false, false) then
						data.State = 3
						spr:Play("StartDashFront", true)
					elseif InutilLib.CuccoLaserCollision(ent, 180, 700, player) and ILIB.room:CheckLine(ent.Position, player.Position, 0, 900, false, false) then
						data.State = 3
						spr:Play("StartDashHori", true)
						spr.FlipX = true
					elseif InutilLib.CuccoLaserCollision(ent, 270, 700, player) and ILIB.room:CheckLine(ent.Position, player.Position, 0, 900, false, false) then
						data.State = 3
						spr:Play("StartDashBack", true)
					end
				end
			end
			if data.State == 0 then
				if spr:IsFinished("Spawn") then
					data.State = 1
				end
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
				elseif spr:IsFinished("StartDashHori") and spr.FlipX then
					data.State = 4
					spr:Play("DashingHori", true)
					spr.FlipX = true
					data.DashDir = Vector(-10,0)
				elseif spr:IsFinished("StartDashBack") then
					data.State = 4
					spr:Play("DashingBack", true)
					data.DashDir = Vector(0,-10)
				elseif spr:IsFinished("StartDashFront") then
					data.State = 4
					spr:Play("DashingFront", true)
					data.DashDir = Vector(0,10)
				end
				ent.Velocity = ent.Velocity * 0.6
			elseif data.State == 4 then --the actual dash
				if ent:CollidesWithGrid() then
					data.State = 1
				end
				ent.Velocity = data.DashDir * 2
			end
			if (data.State > 0 and data.State < 3) and path then --follow
				followTarget()
			end
		end
	end
end, RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY)

InutilLib:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, damage, amount, damageFlag, damageSource, damageCountdownFrames) 
	if damage.Variant == RebekahCurseEnemies.ENTITY_THE_HOUND then
		return false
	end
end, RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY)
