yandereWaifu:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, ent)
	local spr = ent:GetSprite()
	local data = yandereWaifu.GetEntityData(ent)
	local player = ent:GetPlayerTarget()
	local room = InutilLib.room
	print("BALLES")
	print(ent.SubType)
	if ent.SubType == 177 then --ent.Variant == RebekahCurse.ENTITY_REBEKAHS_CARPET_REPLACE then
		print("[helpppp]")
		local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, 74, 177, ent.Position, Vector.Zero, ent):ToEffect()
		ent:Remove()
	elseif ent.SubType == 178 then --ent.Variant == RebekahCurse.ENTITY_LABAN_DUDE_REPLACE then
		local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_LABAN_DUDE, 178, ent.Position, Vector.Zero, ent):ToEffect()
		ent:Remove()
	end
end, RebekahCurse.ENTITY_REBEKAH_ENTITY_REPLACE)

yandereWaifu:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, ent)
	local spr = ent:GetSprite()
	local data = yandereWaifu.GetEntityData(ent)
	local player = ent:GetPlayerTarget()
	local room = InutilLib.room
	print("helpppp")
	if ent.Variant == 85 then
		print("help")
		local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, 170040, 177, ent.Position, Vector.Zero, ent):ToEffect()
		ent:Remove()
	end
	if ent.Variant == 86 then
		print("help")
		local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_LABAN_DUDE, 178, ent.Position, Vector.Zero, ent):ToEffect()
		ent:Remove()
	end
end, 998)