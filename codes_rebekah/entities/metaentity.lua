yandereWaifu:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, ent)
	local spr = ent:GetSprite()
	local data = yandereWaifu.GetEntityData(ent)
	local player = ent:GetPlayerTarget()
	local room = ILIB.room
	if ent.Variant == RebekahCurse.ENTITY_REBEKAHS_CARPET_REPLACE then
		print("[helpppp]")
		local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, 74, 177, ent.Position, Vector.Zero, ent):ToEffect()
		ent:Remove()
	end
end, RebekahCurse.ENTITY_REBEKAH_ENTITY_REPLACE)

yandereWaifu:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, ent)
	local spr = ent:GetSprite()
	local data = yandereWaifu.GetEntityData(ent)
	local player = ent:GetPlayerTarget()
	local room = ILIB.room
	print("helpppp")
	if ent.Variant == 85 then
		print("help")
		local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, 170040, 177, ent.Position, Vector.Zero, ent):ToEffect()
		ent:Remove()
	end
end, 998)