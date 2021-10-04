yandereWaifu:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, pl)
	local sprite = pl:GetSprite()
	local data = yandereWaifu.GetEntityData(pl)
	
	if pl:HasCollectible(RebekahCurse.COLLECTIBLE_MORIAHDIARY) then
		for i, v in ipairs (Isaac.GetRoomEntities()) do
			if v:IsEnemy() then
				if (pl.Position - v.Position):Length() <= 250 then
					yandereWaifu.GetEntityData(v).HasMoriahDiaryEffect = true
				end
			end
			if v.Type == EntityType.ENTITY_PROJECTILE or v.Type == EntityType.ENTITY_BOMBDROP then
				if (pl.Position - v.Position):Length() <= 160 then
					yandereWaifu.GetEntityData(v).HasMoriahDiaryEffect = true
				end
			end
		end
	end

end);

yandereWaifu:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, function(_,  npc)
	local sprite = npc:GetSprite()
	local data = yandereWaifu.GetEntityData(npc)
	
	if data.HasMoriahDiaryEffect then
		if not data.Init then       
			data.spr = Sprite()                                                 
			data.spr:Load("gfx/effects/items/futurediary/blue_target.anm2", true) 
			data.spr:Play("Line", true)
			data.Init = true                                              
		end 
		InutilLib.DeadDrawRotatedTilingSprite(data.spr, Isaac.WorldToScreen(npc.Position), Isaac.WorldToScreen(npc.Position + npc.Velocity:Resized(npc.Velocity:Length()*20)), 16, nil, 8, true)
	end
end);

yandereWaifu:AddCallback(ModCallbacks.MC_POST_PROJECTILE_RENDER, function(_,  proj)
	local sprite = proj:GetSprite()
	local data = yandereWaifu.GetEntityData(proj)
	
	if data.HasMoriahDiaryEffect then
		if not data.Init then       
			data.spr = Sprite()                                                 
			data.spr:Load("gfx/effects/items/futurediary/red_target.anm2", true) 
			data.spr:Play("Line", true)
			data.Init = true                                              
		end 
		InutilLib.DeadDrawRotatedTilingSprite(data.spr, Isaac.WorldToScreen(proj.Position), Isaac.WorldToScreen(proj.Position + proj.Velocity:Resized(proj.Velocity:Length()*10)), 16, nil, 8, true)
	end
end);