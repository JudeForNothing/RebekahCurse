--EVE BOSS!--

yandereWaifu:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, ent)
	local spr = ent:GetSprite()
	local data = yandereWaifu.GetEntityData(ent)
	local player = ent:GetPlayerTarget()
	if ent.Variant == RebekahCurseEnemies.ENTITY_EVE_BOSS then
		if ent.FrameCount == 1 then
			data.State = 0
			spr:Play("1Start", true)
			ent:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
		end
		if spr:IsFinished("1Start") then
			data.State = 1
		end
		
		if ent:CollidesWithGrid() then
			ent.Velocity = (ent.Velocity:Rotated(180)):Resized(2)
		end
		
		if data.State == 1 then --phase one idle
			--InutilLib.MoveRandomlyTypeI(ent, ILIB.room:GetCenterPos(), 4, 0.3, 25, 20, 30)
			--local path = InutilLib.GenerateAStarPath(ent.Position, player.Position)
		
			
			--if path then
			--	InutilLib.FollowPath(ent, player, path, 0.7, 0.9)
			--else
			--	InutilLib.MoveDirectlyTowardsTarget(ent, player, 1.2, 0.9)
			--end
			if (ent.Position - player.Position):Length() > 150 then
				InutilLib.MoveRandomlyTypeI(ent, player.Position, 2.2, 0.9, 75, 15, 30)
			else
			--	InutilLib.MoveAwayFromTarget(ent, player, 5.2, 0.9)
				InutilLib.StrafeAroundTarget(ent, player, 0.9, 0.9, 30)
			end
			--end
			data.State = 1
			if math.random(1,4) == 4 and ent.FrameCount % 30 == 0 then
				--ent.State = 2
			--	data.State = math.random(2,4)
			end
			
			InutilLib.AnimShootFrame(ent, false, ent.Velocity, "1WalkRight", "1WalkFront", "1WalkBack", "1WalkLeft")
			
			if ent.FrameCount % 30 == 0 then
				if InutilLib.CuccoLaserCollision(ent, 0, 700, player) then
					data.State = 2
					spr:Play("1AttackRight", true)
				elseif InutilLib.CuccoLaserCollision(ent, 90, 700, player) then
					data.State = 2
					spr:Play("1AttackFront", true)
				elseif InutilLib.CuccoLaserCollision(ent, 180, 700, player) then
					data.State = 2
					spr:Play("1AttackLeft", true)
				elseif InutilLib.CuccoLaserCollision(ent, 270, 700, player) then
					data.State = 2
					spr:Play("1AttackBack", true)
				end
			end
		end
		
		if data.State == 2 then --phase one tear burst
			if InutilLib.IsFinishedMultiple(spr, "1AttackFront", "1AttackLeft", "1AttackBack", "1AttackRight") then
				data.State = 1
			end
			if spr:GetFrame() == 8 then
				local angle = 0
				if spr:IsPlaying("1AttackFront") then
					angle = 90
				elseif spr:IsPlaying("1AttackLeft") then
					angle = 180
				elseif spr:IsPlaying("1AttackBack") then
					angle = 270
				elseif spr:IsPlaying("1AttackRight") then
					angle = 0
				end
				
				for i = -30, 30, 15 do
					local adjustingAng = 0
					if i == 1 then
						adjustingAng = -30
					elseif i == 3 then
						adjustingAng = 30
					end
					local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, (Vector(0,40):Rotated(i + angle - 90)):Resized(10))
					proj.Scale = 1.5
				end
			end
		end
		if data.State == 3 then --phase one tear burst
			if spr:IsFinished("1Attack") then
				data.State = 1
			end
			if not spr:IsPlaying("1Attack") then
				spr:Play("1Attack", true)
			elseif spr:IsPlaying("1Attack") then
				if spr:GetFrame() == 8 then
					local num = 0
					local randomRot = math.random(-20,10)
					for i = 0, 360-360/8, 360/8 do
						local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, (Vector(0,40):Rotated(i+randomRot)):Resized(heartShapeVel[num]))
						num = num + 1
						proj.Scale = 1.2
					end
					local splat = Isaac.Spawn(EntityType.ENTITY_EFFECT, 2, 6, ent.Position, Vector(0,0), nil)
				end	
			end
		end
	end

end, RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY)
