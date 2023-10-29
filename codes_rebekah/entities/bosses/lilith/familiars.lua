yandereWaifu:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, ent)
	local spr = ent:GetSprite()
	local data = yandereWaifu.GetEntityData(ent)
	local player = ent:GetPlayerTarget()
	
	if ent.Variant == RebekahCurse.Enemies.ENTITY_DEMONBABY_ENEMY then
		if ent.FrameCount == 1 then
			data.State = 0
			spr:Play("IdleDown", true)
			ent:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
			ent:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
		end
		if spr:IsFinished("IdleDown") then
			data.State = 1
		end
		
		if data.State == 1 then --phase one idle
			if not spr:IsPlaying("FloatDown") then
				spr:Play("FloatDown", true)
			end
			
			if ent.FrameCount % 240 and not InutilLib.IsPlayingMultiple(spr, "FloatShootDown") and (player.Position - ent.Position):Length() <= 120 then
				data.State = 2
				spr:Play("FloatShootDown", true)
			end
		end
		
		if data.State == 2 then
			if spr:GetFrame() == 5 then
				local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, (player.Position - ent.Position):Resized(6))
				proj.Scale = 0.5
			end
			if spr:GetFrame() == 15 then
				data.State = 1
			end
		end
		
		if data.Lilith then
			InutilLib.MoveOrbitAroundTargetType1(ent, data.Lilith, 1, 0.9, 8, data.startingNum or 0)
		end
	end
	
	--laser guy
	if ent.Variant == RebekahCurse.Enemies.ENTITY_ROBOBABY_ENEMY then
		if ent.FrameCount == 1 then
			ent:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
			ent:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
		end
		if ent:CollidesWithGrid() then
			ent:Die()
		end

		if ent.Velocity:Length() > 0 then
			ent.Velocity = (ent.Velocity):Resized(0.8)
		else
			ent.Velocity = InutilLib.DirToVec(data.State) --Vector(10,0)
		end
		
			
		if ent.FrameCount % 240 and not InutilLib.IsPlayingMultiple(spr, "FloatShootDown", "FloatShootUp", "FloatShootSide", "FloatShootSide2") then
			if spr:IsPlaying("FloatDown") then
				spr:Play("FloatShootDown", true)
			elseif spr:IsPlaying("FloatUp") then
				spr:Play("FloatShootUp", true)
			elseif spr:IsPlaying("FloatSide") then
				spr:Play("FloatShootSide", true)
			elseif spr:IsPlaying("FloatSide2") then
				spr:Play("FloatShootSide2", true)
			end
		end
		
		if InutilLib.IsPlayingMultiple(spr, "FloatShootDown", "FloatShootUp", "FloatShootSide", "FloatShootSide2") then
			if spr:GetFrame() == 5 then
				if spr:IsPlaying("FloatShootDown") then
					EntityLaser.ShootAngle(2, ent.Position, 90, 10, Vector(0,-10), ent):ToLaser()
				elseif spr:IsPlaying("FloatShootUp") then
					EntityLaser.ShootAngle(2, ent.Position, 270, 10, Vector(0,-10), ent):ToLaser()
				elseif spr:IsPlaying("FloatShootSide") then
					EntityLaser.ShootAngle(2, ent.Position, 0, 10, Vector(0,-10), ent):ToLaser()
				elseif spr:IsPlaying("FloatShootSide2") then
					EntityLaser.ShootAngle(2, ent.Position, 180, 10, Vector(0,-10), ent):ToLaser()
				end
			end
			if spr:GetFrame() == 15 then
				if spr:IsPlaying("FloatShootDown") then
					spr:Play("FloatDown", true)
				elseif spr:IsPlaying("FloatShootUp") then
					spr:Play("FloatUp", true)
				elseif spr:IsPlaying("FloatShootSide") then
					spr:Play("FloatSide", true)
				elseif spr:IsPlaying("FloatShootSide2") then
					spr:Play("FloatSide2", true)
				end
			end
		end
	end
	
	if ent.Variant == RebekahCurse.Enemies.ENTITY_MULTIDIMENSIONALBABY_ENEMY then
		if ent.FrameCount == 1 then
			data.State = 0
			spr:Play("IdleDown", true)
			ent:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
			ent:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
		end
		if spr:IsFinished("IdleDown") then
			data.State = 1
		end
		
		--[[if ent:CollidesWithGrid() then
			ent.Velocity = (ent.Velocity:Rotated(180)):Resized(6)
		end]]
		if data.State == 1 then --phase one idle
			if not spr:IsPlaying("FloatDown") then
				spr:Play("FloatDown", true)
			end
			
			if math.random(1,5) == 5 and ent.FrameCount % 5 == 0 then
				ent.Velocity = (player.Position - ent.Position):Resized(8)
				data.MoveFrame = 30
			end
			
			if data.MoveFrame then
				if data.MoveFrame <= 0 then
					ent.Velocity = Vector.Zero
				else
					data.MoveFrame = data.MoveFrame - 1
				end
			else
				ent.Velocity = Vector.Zero
			end
			
			if ent.Velocity:Length() > 2 then
				InutilLib.AnimShootFrame(ent, false, ent.Velocity, "FloatSide", "FloatDown", "FloatUp")
			end
		end
	end
	
	if ent.Variant == RebekahCurse.Enemies.ENTITY_BOBSBRAIN_ENEMY then
		if ent.FrameCount == 1 then
			data.State = 0
			spr:Play("Appear", true)
			ent:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
			ent:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
		end
		if spr:IsFinished("Appear") then
			data.State = 1
		end
		
		local function DieMiserably()
			Isaac.Explode(ent.Position, ent, 15)
			ent:Remove()
			Game():ShakeScreen(10)
		end
		
		--[[if ent:CollidesWithGrid() then
			ent.Velocity = (ent.Velocity:Rotated(180)):Resized(6)
		end]]
		if data.State == 1 then --phase one idle
			if not spr:IsPlaying("Float") then
				spr:Play("Float", true)
			end
			if data.Lilith then
				InutilLib.MoveOrbitAroundTargetType1(ent, data.Lilith, 3, 0.9, 4, data.startingNum or 0)
			end
		end
		if data.State == 2 then
			if ent:CollidesWithGrid() then
				DieMiserably()
				data.State = 1
				data.VelocityDir = nil
			end
			if spr:IsFinished("StartFire") then
				spr:Play("Fire", true)
			end
			if data.VelocityDir and spr:IsPlaying("Fire") then
				ent.Velocity = ent.Velocity + data.VelocityDir * 0.8
			end
		end
	end

end, RebekahCurse.Enemies.ENTITY_REBEKAH_ENEMY)

yandereWaifu:AddCallback(ModCallbacks.MC_PRE_NPC_COLLISION, function(_, ent, coll, low)
	local spr = ent:GetSprite()
	local data = yandereWaifu.GetEntityData(ent)
	local player = ent:GetPlayerTarget()
	if ent.Variant == RebekahCurse.Enemies.ENTITY_BOBSBRAIN_ENEMY and coll.Type == EntityType.ENTITY_PLAYER then
		Isaac.Explode(ent.Position, ent, 15)
		ent:Remove()
		Game():ShakeScreen(10)
	end

end, RebekahCurse.Enemies.ENTITY_REBEKAH_ENEMY)