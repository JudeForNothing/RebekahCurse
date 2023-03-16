yandereWaifu:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, ent)
	local spr = ent:GetSprite()
	local data = yandereWaifu.GetEntityData(ent)
	local player = ent:GetPlayerTarget()
	if ent.Variant == RebekahCurseEnemies.ENTITY_REDTATO then
		if not data.Init then
			--if spr:IsFinished("Spawn") then
				data.Init = true
			--end
			--if not spr:IsPlaying("Spawn") then
			--	spr:Play("Spawn")
			--end
			data.FlipX = false
			spr:PlayOverlay("Head", true)
			data.State = 0
		else
			if data.State == 0 then
				if ent.SubType == 1 then --the soul heart version
					if math.random(1,5) == 5 and ent.FrameCount % 5 == 0 then
						data.State = 1
					end
				end
				if ent.SubType == 3 then --the eternal ver
					if math.random(1,5) == 5 and ent.FrameCount % 5 == 0 then
						data.State = 3
					end
				end
				if not data.path then
					data.path = InutilLib.GenerateAStarPath(ent.Position, player.Position)
				else
					if ent.FrameCount % 15 == 0 then
						data.path = InutilLib.GenerateAStarPath(ent.Position, player.Position)
					end
				end
				local angle = (ent.Position - player.Position):GetAngleDegrees()
				
				if ent.SubType == 4 then
					if not InutilLib.IsPlayingMultiple(spr, "WalkHori", "WalkDown", "WalkUp") then
						InutilLib.AnimShootFrame(ent, true, ent.Velocity, "WalkHori", "WalkDown", "WalkUp")
					end
					InutilLib.FlipXByVec(ent, false)
					if spr:IsOverlayPlaying("Head") and spr:GetOverlayFrame() == 1 and math.random(1,2) == 2 then
						for i = 0, 360-360/3, 360/3 do
							local proj = InutilLib.FireGenericProjAttack(ent, 1, 0, ent.Position, ((player.Position - ent.Position):Rotated(i)):Resized(6))
							proj.Scale = 0.5
							InutilLib.MakeProjectileLob(proj, 1.5, 9 )
						end
					end
				else
					ent:AnimWalkFrame("WalkHori", "WalkVert", 1)
				end
				if not spr:IsOverlayPlaying("Head") then
					spr:PlayOverlay("Head", true)
				end

				if data.path then
					if not InutilLib.room:CheckLine(ent.Position, player.Position, 0, 0) then
						InutilLib.FollowPath(ent, player, data.path, 0.8, 0.9)
					else
						InutilLib.MoveDirectlyTowardsTarget(ent, player, 0.8, 0.9)
					end
					if not spr:IsPlaying("Walk") then
						spr:Play("Walk", true)
					end
				else
					if not spr:IsPlaying("Idle") then
						spr:Play("Idle", true)
					end
					ent.Velocity = Vector.Zero
				end
			elseif data.State == 1 then
				if spr:IsFinished("Disappear") then
					data.State = 2
					ent.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
				elseif not spr:IsPlaying("Disappear") then
					spr:Play("Disappear", true)
				end
				ent.Velocity = Vector(0,0)
				spr:RemoveOverlay()
			elseif data.State == 2 then
				if spr:IsFinished("Reappear") then
					data.State = 0
					ent.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
				elseif not spr:IsPlaying("Reappear") and math.random(1,3) == 3 and ent.FrameCount % 15 == 0 then
					spr:Play("Reappear", true)
					ent.Position = Isaac.GetRandomPosition()
				end
			elseif data.State == 3 then
				if spr:IsOverlayFinished("Shoot") then
					data.State = 0
				elseif not spr:IsOverlayPlaying("Shoot") then
					spr:PlayOverlay("Shoot", true)
				else
					if spr:GetOverlayFrame() == 15 then 
						for i = 0, 360, 180 do
							local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, ((player.Position - ent.Position):Rotated(i+90)):Resized(4))
							proj.Scale = 1.5
							proj:AddProjectileFlags(ProjectileFlags.SMART)
						end
					end
				end
				ent.Velocity = Vector(0,0)
			end

			--[[data.Flip = false
			
			if spr:IsFinished("FlipX") then
				if not data.FlipX then
					data.FlipX = true
				else
					data.FlipX = false
				end
				spr.FlipX = data.FlipX
			end
			
			if ((angle >= 0 and angle <= 90) or (angle <= 0 and angle >= -90)) and not spr.FlipX and not data.Flip then
				--spr.FlipX = true
				if not data.Flip then
					data.Flip = true
				end
			elseif ((angle >= 90 and angle <= 180) or (angle <= -90 and angle >= -180)) and spr.FlipX and not data.Flip then
				--spr.FlipX = false
				if not data.Flip then
					data.Flip = true
				end
			end
			
			if data.Flip and not spr:IsPlaying("FlipX") then
				spr:Play("FlipX", true)
			end
		
			if (not spr:IsPlaying("FlipX") and not spr:IsPlaying("FlipX2")) then
				if path then
					if not InutilLib.room:CheckLine(ent.Position, player.Position, 0, 0) then
						InutilLib.FollowPath(ent, player, path, 1, 0.9)
					else
						InutilLib.MoveDirectlyTowardsTarget(ent, player, 1, 0.9)
					end
					if not spr:IsPlaying("Walk") then
						spr:Play("Walk", true)
					end
				else
					if not spr:IsPlaying("Idle") then
						spr:Play("Idle", true)
					end
					ent.Velocity = Vector.Zero
				end
			end]]
		end
	end
end, RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY)


yandereWaifu:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, function(_, ent)
	local spr = ent:GetSprite()
	local data = yandereWaifu.GetEntityData(ent)
	local player = ent:GetPlayerTarget()
	if ent.Variant == RebekahCurseEnemies.ENTITY_REDTATO then
		if not data.NoDrop then
			local subtype = 0
			if ent.SubType == 0 then
				subtype = RebekahMirrorHeartDrop[1]
			elseif ent.SubType == 1 then
				subtype = RebekahMirrorHeartDrop[2]
			elseif ent.SubType == 2 then
				subtype = RebekahMirrorHeartDrop[4]
				Isaac.Explode(ent.Position, ent, 30)
			elseif ent.SubType == 3 then
				subtype = RebekahMirrorHeartDrop[3]
			elseif ent.SubType == 4 then
				subtype = RebekahMirrorHeartDrop[6]
			elseif ent.SubType == 5 then
				subtype = RebekahMirrorHeartDrop[7]
				for i = 0, math.random(1,2) do
					local fly = Isaac.Spawn(EntityType.ENTITY_ATTACKFLY, 0, 0, ent.Position, Vector(0,0), ent):ToNPC()
					fly:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
				end
			end
			if math.random(1,3) == 3 then
				local newpickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, subtype, ent.Position, ent.Velocity, ent)
			end
		end
	end
end, RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY)