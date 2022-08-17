yandereWaifu:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, ent)
	local spr = ent:GetSprite()
	local data = yandereWaifu.GetEntityData(ent)
	local player = ent:GetPlayerTarget()
	if ent.Variant == RebekahCurseEnemies.ENTITY_REDTATO then
		if not data.Init then
			if spr:IsFinished("Spawn") then
				data.Init = true
			end
			if not spr:IsPlaying("Spawn") then
				spr:Play("Spawn")
			end
			data.FlipX = false
		else
			local path = InutilLib.GenerateAStarPath(ent.Position, player.Position)
			local angle = (ent.Position - player.Position):GetAngleDegrees()
			
			data.Flip = false
			
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
					if not ILIB.room:CheckLine(ent.Position, player.Position, 0, 0) then
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
			end
		end
	end
end, RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY)


yandereWaifu:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, function(_, ent)
	local spr = ent:GetSprite()
	local data = yandereWaifu.GetEntityData(ent)
	local player = ent:GetPlayerTarget()
	if ent.Variant == RebekahCurseEnemies.ENTITY_REDTATO then
		if ent.SubType == 0 then
			local newpickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, RebekahMirrorHeartDrop[1], ent.Position, ent.Velocity, ent)
		end
	end
end, RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY)