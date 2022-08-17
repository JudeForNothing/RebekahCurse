yandereWaifu:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, ent)
	local spr = ent:GetSprite()
	local data = yandereWaifu.GetEntityData(ent)
	local player = ent:GetPlayerTarget()
	if ent.Variant == RebekahCurseEnemies.ENTITY_THE_SCUM then
		if ent.FrameCount == 1 then
			spr:Play("Idle")
			ent:AddEntityFlags(EntityFlag.FLAG_PERSISTENT)
			--no one asked you to be here
			--get off
		else
			local path = InutilLib.GenerateAStarPath(ent.Position, player.Position)
			if path then
				if not ILIB.room:CheckLine(ent.Position, player.Position, 0, 0) then
					InutilLib.FollowPath(ent, player, path, 1.2, 0.9)
				else
					InutilLib.MoveDirectlyTowardsTarget(ent, player, 1.2, 0.9)
				end
			end
		end
	end
end, RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY)