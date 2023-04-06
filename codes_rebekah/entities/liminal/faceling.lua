yandereWaifu:AddCallback(ModCallbacks.MC_POST_NPC_INIT, function(_, ent)
	local spr = ent:GetSprite()
	local data = yandereWaifu.GetEntityData(ent)
	local player = ent:GetPlayerTarget()
	if ent.Variant == RebekahCurse.Enemies.ENTITY_FACELING then
		spr:ReplaceSpritesheet(1, "gfx/monsters/liminal/faceling.png")
		spr:LoadGraphics()
		ent.Velocity = ent.Velocity:Resized(5)
	end
end, EntityType.ENTITY_GAPER)