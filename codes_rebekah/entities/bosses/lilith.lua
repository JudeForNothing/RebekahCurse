--LILITH BOSS!--

yandereWaifu:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, ent)
	local spr = ent:GetSprite()
	local data = yandereWaifu.GetEntityData(ent)
	local player = ent:GetPlayerTarget()
	if ent.Variant == RebekahCurseEnemies.ENTITY_LILITH_BOSS then
		if ent.FrameCount == 1 then
			data.State = 0
			spr:Play("1Start", true)
			ent:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
			ent:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
		end
		if spr:IsFinished("1Start") then
			data.State = 1
		end
		
		--[[if ent:CollidesWithGrid() then
			ent.Velocity = (ent.Velocity:Rotated(180)):Resized(6)
		end]]
		if data.State == 1 then --phase one idle
			InutilLib.MoveRandomlyTypeI(ent, ILIB.room:GetCenterPos(), 0.5, 0.8, 30, 5, 15)
			local hasDemonBabs = 0
			local hasBombs = 0
			local hasElectroBabs = 0
			for i, v in pairs (Isaac.GetRoomEntities()) do
				if v.Type == RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY and v.Variant == RebekahCurseEnemies.ENTITY_DEMONBABY_ENEMY then
					hasDemonBabs = hasDemonBabs + 1
				end
				if v.Type == EntityType.ENTITY_BOOMFLY then
					hasBombs = hasBombs + 1
				end
				if v.Type == RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY and v.Variant == RebekahCurseEnemies.ENTITY_ROBOBABY_ENEMY then
					hasElectroBabs = hasElectroBabs + 1
				end
			end
			
			InutilLib.AnimShootFrame(ent, false, ent.Velocity, "1WalkRight", "1WalkFront", "1WalkBack", "1WalkLeft")
			if hasBombs <= 1 and math.random(1,10) == 10 and ent.FrameCount % 60 == 0 then
				data.State = 2
				spr:Play("1Spawn", true)
			end
			if hasBombs <= 1 and math.random(1,5) == 5 and ent.FrameCount % 60 == 0 then
				data.State = 3
				spr:Play("1Spawn", true)
			end
			--spawn demon babies
			if hasDemonBabs <= 1 and (math.random(1,2) == 2 and ent.FrameCount % 30 == 0) then
				data.State = 5
				spr:Play("1Spawn", true)
			end
			if hasDemonBabs <= 1 and (math.random(1,4) == 4 and ent.FrameCount % 300 == 0) then
				data.State = 6
				spr:Play("1Spawn", true)
			end
			if hasBombs <= 1 and hasElectroBabs < 1 and (math.random(1,15) == 15 and ent.FrameCount % 15 == 0) and ent.HitPoints <= 600 then
				data.State = 7
				spr:Play("1Spawn", true)
			end
		end
		if data.State == 2 then --spawn boom flies
			if spr:IsFinished("1Spawn") then
				data.State = 1
			end
			if spr:IsEventTriggered("Attack") then
				for i = 0, 2 do
					InutilLib.SetTimer( i * 30, function()
						Isaac.Spawn(EntityType.ENTITY_BOOMFLY, 0, 0, ent.Position, Vector.Zero, ent)
					end)
				end
			end
		end
		if data.State == 3 then --spawn bobs brain
			if spr:IsFinished("1Spawn") then
				--data.State = 1
				data.State = 4
				spr:Play("1Subject", true)
			end
			if spr:IsEventTriggered("Attack") then
				for i = 0, 360 - 360/2, 360/2 do
					local brain = Isaac.Spawn(RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY, RebekahCurseEnemies.ENTITY_BOBSBRAIN_ENEMY, 0, ent.Position, Vector.Zero, ent)
					yandereWaifu.GetEntityData(brain).Lilith = ent
					yandereWaifu.GetEntityData(brain).startingNum = i
				end
			end
		end
		if data.State == 4 then --send familiars
			if spr:IsFinished("1Subject") then
				data.State = 1
			end
			if spr:IsEventTriggered("Attack") then
				for i, v in pairs (Isaac.GetRoomEntities()) do
					if v.Type == RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY then
						if v.Variant == RebekahCurseEnemies.ENTITY_BOBSBRAIN_ENEMY then
							yandereWaifu.GetEntityData(v).State = 2
							yandereWaifu.GetEntityData(v).VelocityDir = (player.Position - ent.Position):Resized(2)
							v:GetSprite():Play("StartFire", true)
						end
					end
				end
			end
		end
		if data.State == 5 then --spawn demon baby
			if spr:IsFinished("1Spawn") then
				--data.State = 1
				data.State = 1
				spr:Play("1Subject", true)
			end
			if spr:IsEventTriggered("Attack") then
				for i = 0, 360 - 360/2, 360/2 do
					local brain = Isaac.Spawn(RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY, RebekahCurseEnemies.ENTITY_DEMONBABY_ENEMY, 0, ent.Position, Vector.Zero, ent)
					yandereWaifu.GetEntityData(brain).Lilith = ent
					yandereWaifu.GetEntityData(brain).startingNum = i --+ ent.FrameCount
				end
			end
		end
		if data.State == 6 then --spawn multidimensional baby
			if spr:IsFinished("1Spawn") then
				--data.State = 1
				data.State = 1
				spr:Play("1Subject", true)
			end
			if spr:IsEventTriggered("Attack") then
				
				for i = 0, 2 do
					InutilLib.SetTimer( i * 30, function()
						local brain = Isaac.Spawn(RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY, RebekahCurseEnemies.ENTITY_MULTIDIMENSIONALBABY_ENEMY, 0, ent.Position, (player.Position - ent.Position):Resized(8):Rotated((player.Position - ent.Position):GetAngleDegrees() + math.random(-30,30)), ent)
					end)
				end
			end
		end
		if data.State == 7 then --spawn robo baby
			if spr:IsFinished("1Spawn") then
				data.State = 1
				spr:Play("1Subject", true)
			end
			if spr:IsEventTriggered("Attack") then
				local rnd = math.random(1,2)
				local rng = math.random(1,2)
				for i = 0, 1 do
					local robo = Isaac.Spawn(RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY, RebekahCurseEnemies.ENTITY_ROBOBABY_ENEMY, 0, ent.Position, Vector.Zero, ent)
					if rnd == 1 then
						if i == 0 then
							yandereWaifu.GetEntityData(robo).State = Direction.RIGHT
						elseif i == 1 then
							yandereWaifu.GetEntityData(robo).State = Direction.LEFT
						end
						if rng == 2 then
							robo:GetSprite():Play("FloatUp", true)
							rng = 1
						else
							robo:GetSprite():Play("FloatDown", true)
							rng = 2
						end
					elseif rnd == 2 then
						if i == 0 then
							yandereWaifu.GetEntityData(robo).State = Direction.UP
						elseif i == 1 then
							yandereWaifu.GetEntityData(robo).State = Direction.DOWN
						end
						if rng == 2 then
							robo:GetSprite():Play("FloatSide", true)
							rng = 1
						else
							robo:GetSprite():Play("FloatSide2", true)
							rng = 2
						end
					end
				end
			end
		end
		ent.Velocity = ent.Velocity *0.8
	end

end, RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY)
