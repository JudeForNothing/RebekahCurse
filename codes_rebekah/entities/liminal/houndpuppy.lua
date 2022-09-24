yandereWaifu:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, ent)
	local spr = ent:GetSprite()
	local data = yandereWaifu.GetEntityData(ent)
	local player = ent:GetPlayerTarget()
	if ent.Variant == RebekahCurseEnemies.ENTITY_HOUNDPUPPY then
		if not data.State then
			spr:Play("Appear", true)
			data.State = 0
		else
			--press pressure plates under it
			--[[local grid = ILIB.room:GetGridEntityFromPos(ent.Position)
			if grid then
				if grid:ToPressurePlate() then
					if grid.State == 0 then
						InutilLib.PressPressurePlate(grid)
					end
				end
			end]]
			if not data.path then 
				data.path = InutilLib.GenerateAStarPath(ent.Position, player.Position, false)
			else
				if ent.FrameCount % 5 == 0 then
					data.path = InutilLib.GenerateAStarPath(ent.Position, player.Position, false)
				end
			end
			local function followTarget()
				InutilLib.FollowPath(ent, player, data.path, 1.5, 0.9)
			end
			local function checkOpportunityToDash()
				if math.random(1,2) == 2 and ent.FrameCount % 3 == 0 then
					if InutilLib.CuccoLaserCollision(ent, 0, 700, player) and ILIB.room:CheckLine(ent.Position, player.Position, 0, 900, false, false) then
						data.State = 3
						spr:Play("Move Hori", true)
						spr.FlipX = false
						data.DashDir = Vector(8,0)
					elseif InutilLib.CuccoLaserCollision(ent, 90, 700, player) and ILIB.room:CheckLine(ent.Position, player.Position, 0, 900, false, false) then
						data.State = 3
						spr:Play("Move Down", true)
						data.DashDir = Vector(0,8)
					elseif InutilLib.CuccoLaserCollision(ent, 180, 700, player) and ILIB.room:CheckLine(ent.Position, player.Position, 0, 900, false, false) then
						data.State = 3
						spr:Play("Move Hori", true)
						spr.FlipX = true
						data.DashDir = Vector(-8,0)
					elseif InutilLib.CuccoLaserCollision(ent, 270, 700, player) and ILIB.room:CheckLine(ent.Position, player.Position, 0, 900, false, false) then
						data.State = 3
						spr:Play("Move Up", true)
						data.DashDir = Vector(0,-8)
					end
				end
			end
			if data.State == 0 then
				if spr:IsFinished("Appear") then
					data.State = 1
				end
			elseif data.State == 1 then --idle
				if ent.Velocity:Length() > 1 then
					data.State = 2
				end
				--animation
				InutilLib.AnimShootFrame(ent, false, ent.Velocity, "Idle Hori", "Idle Down", "Idle Up")
				ent.Velocity = ent.Velocity * 0.5
				checkOpportunityToDash()
			elseif data.State == 2 then --walk
				if ent.Velocity:Length() <= 1 then
					data.State = 1
				end
				--animation
				InutilLib.AnimShootFrame(ent, false, ent.Velocity, "Move Hori", "Move Down", "Move Up")
				ent.Velocity = ent.Velocity * 0.8
				checkOpportunityToDash()
			--[[elseif data.State == 3 then --prepare to dash
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
				ent.Velocity = ent.Velocity * 0.6]]
			elseif data.State == 3 then --the actual dash
				if ent:CollidesWithGrid() then
					data.State = 1
					spr:Stop()
				end
				ent.Velocity = data.DashDir 
			end
			if (data.State > 0 and data.State < 3) and data.path then --follow
				followTarget()
			end
		end
	end
end, RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY)
