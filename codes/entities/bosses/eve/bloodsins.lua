

yandereWaifu:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, ent)
	local spr = ent:GetSprite()
	local data = yandereWaifu.GetEntityData(ent)
	if data.path == nil then data.path = ent.Pathfinder end
	local player = ent:GetPlayerTarget()
	--BLOOD SLOTH
	if ent.Variant == RebekahCurseEnemies.ENTITY_BLOOD_SLOTH then
		if ent.FrameCount == 1 then
			data.State = 1
			spr:Play("Appear", true)
			ent:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
			data.pos = Isaac.GetRandomPosition()
		end
		if data.State == 1 then --phase one idle
			InutilLib.AnimWalkFrame(ent, true, "WalkHori", "WalkVert")
			--data.path:MoveRandomlyAxisAligned(0.1, false)

			local path = InutilLib.GenerateAStarPath(ent.Position, data.pos)
			if path then
				InutilLib.FollowPath(ent, data.pos, path, 2, 0.8)
			end
			if ent.FrameCount % 30 == 0 then
				data.pos = Isaac.GetRandomPosition()
				if math.random(1,3) == 3 then
					data.State = 2
					spr:Play("Attack", true)
				end
			end
		elseif data.State >= 2 then --lerp tear attack
			ent.Velocity = Vector.Zero
			if spr:GetFrame() == 10 then
				if data.State == 2 then
					local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, (player.Position-ent.Position):Resized(10)):ToProjectile()
					proj.Scale = 1.7
					proj.FallingSpeed = (7)*-1;
					proj.FallingAccel = 1;
				end
			end
			if spr:IsFinished("Attack") then
				data.State = 1
			end
		end
	end
	
	--BLOOD WRATH
	if ent.Variant == RebekahCurseEnemies.ENTITY_BLOOD_WRATH then
		if ent.FrameCount == 1 then
			data.State = 1
			spr:Play("Appear", true)
			ent:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
			data.pos = Isaac.GetRandomPosition()
		end
		if data.State == 1 then --phase one idle
			InutilLib.AnimWalkFrame(ent, true, "WalkHori", "WalkVert")
			--data.path:MoveRandomlyAxisAligned(0.1, false)

			local path = InutilLib.GenerateAStarPath(ent.Position, data.pos)
			if path then
				InutilLib.FollowPath(ent, data.pos, path, 2, 0.8)
			end
			if ent.FrameCount % 30 == 0 then
				data.pos = Isaac.GetRandomPosition()
				if math.random(1,3) == 3 then
					data.State = 2
					spr:Play("Attack", true)
				end
			end
		elseif data.State >= 2 then --yeet bomb
			ent.Velocity = Vector.Zero
			if spr:GetFrame() == 5 then
				if data.State == 2 then
					local bomb = Isaac.Spawn(EntityType.ENTITY_BOMBDROP, 15, 0, ent.Position,  (player.Position-ent.Position):Resized(10):Resized( 6 ), ent);
				end
			end
			if spr:IsFinished("Attack") then
				data.State = 1
			end
		end
	end
end, RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY)