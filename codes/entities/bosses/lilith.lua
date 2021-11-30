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
			
			InutilLib.AnimShootFrame(ent, false, ent.Velocity, "1WalkRight", "1WalkFront", "1WalkBack", "1WalkLeft")
		end
	end

end, RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY)
