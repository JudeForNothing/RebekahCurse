yandereWaifu:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, pl)
	local sprite = pl:GetSprite()
	local data = yandereWaifu.GetEntityData(pl)
	
	if pl:HasCollectible(RebekahCurse.COLLECTIBLE_MORIAHDIARY) then
		for i, v in ipairs (Isaac.GetRoomEntities()) do
			if v:IsEnemy() then
				if (pl.Position - v.Position):Length() <= 250 then
					yandereWaifu.GetEntityData(v).HasMoriahDiaryEffect = true
					if v.FrameCount == 0 then
						local target = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_PINGEFFECT, 4, v.Position, Vector.Zero, player)
						target:GetSprite().Color = Color(1, 0.5, 0, 1, 0, 0, 0)
						if v.Size > 18 then
							target:GetSprite().Scale = Vector(1.5,1.5)
						end
					end
				end
			end
			if v.Type == EntityType.ENTITY_PROJECTILE or v.Type == EntityType.ENTITY_BOMBDROP then
				if (pl.Position - v.Position):Length() <= 160 then
					yandereWaifu.GetEntityData(v).HasMoriahDiaryEffect = true
				else
					yandereWaifu.GetEntityData(v).HasMoriahDiaryEffect = false
				end
			end
		end
	end

end);

yandereWaifu:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, function(_,  npc)
	local sprite = npc:GetSprite()
	local data = yandereWaifu.GetEntityData(npc)
	
	if data.HasMoriahDiaryEffect and npc.EntityCollisionClass ~= EntityCollisionClass.ENTCOLL_NONE then
		local endpoint = Isaac.WorldToScreen(npc.Position + npc.Velocity:Resized(npc.Velocity:Length()*18))
		if not data.Init then       
			data.spr = Sprite()                                                 
			data.spr:Load("gfx/effects/items/futurediary/blue_target.anm2", true) 
			data.spr:Play("Line", true)
			
			data.sprChild = Sprite()                                                 
			data.sprChild:Load("gfx/effects/items/futurediary/blue_target.anm2", true) 
			--if npc.Size <= 18 then
				data.sprChild:Play("Point", true)
			--[[else
				data.sprChild:Play("Target", true)
			end]]
			data.Init = true          
		end 
		InutilLib.DeadDrawRotatedTilingSprite(data.spr, Isaac.WorldToScreen(npc.Position), endpoint, 16, nil, 8, true)
		if npc.Velocity:Length() >= 1 then
			data.sprChild:Render(endpoint, Vector.Zero, Vector.Zero)
			--if npc.Size <= 18 then
				data.sprChild.Rotation = (npc.Velocity):GetAngleDegrees()
			--end
		end
	end
end);

yandereWaifu:AddCallback(ModCallbacks.MC_POST_PROJECTILE_RENDER, function(_,  proj)
	local sprite = proj:GetSprite()
	local data = yandereWaifu.GetEntityData(proj)
	
	if data.HasMoriahDiaryEffect then
		local endpoint = Isaac.WorldToScreen(proj.Position + proj.Velocity:Resized(proj.Velocity:Length()*10))
		if not data.Init then       
			data.spr = Sprite()                                                 
			data.spr:Load("gfx/effects/items/futurediary/red_target.anm2", true) 
			data.spr:Play("Line", true)
			
			data.sprChild = Sprite()                                                 
			data.sprChild:Load("gfx/effects/items/futurediary/red_target.anm2", true) 
			--if proj.Size <= 18 then
				data.sprChild:Play("Point", true)
			--[[else
				data.sprChild:Play("Target", true)
			end]]
			data.Init = true          
		end 
		InutilLib.DeadDrawRotatedTilingSprite(data.spr, Isaac.WorldToScreen(proj.Position), endpoint, 16, nil, 8, true)
		if proj.Velocity:Length() > 2 then
			data.sprChild:Render(endpoint, Vector.Zero, Vector.Zero)
			--if proj.Size <= 18 then
				data.sprChild.Rotation = (proj.Velocity):GetAngleDegrees()
			--end
		end
		--if proj.Height <= -34 then
			data.spr.Color = Color(1, 1, 1, 0.5, 0, 0, 0)
			data.sprChild.Color = Color(1, 1, 1, 0.5, 0, 0, 0)
		--end
	end
end);

yandereWaifu:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE, function(_,  bb)
	if yandereWaifu.GetEntityData(bb).HasMoriahDiaryEffect and not yandereWaifu.GetEntityData(bb).HasMoriahDiaryEffectInit then
		local target = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_PINGEFFECT, 10, bb.Position, bb.Velocity, bb):ToEffect()
		yandereWaifu.GetEntityData(target).Parent = bb
		if not bb.IsFetus then
			SFXManager():Play( RebekahCurseSounds.SOUND_IMDIECHIME , 1.4, 0, false, 0.5)
		end
		if bb.Variant == 17 then
			bb:GetSprite().Scale = Vector(1.5,1.5)
		end
		print(bb.RadiusMultiplier)
		yandereWaifu.GetEntityData(bb).HasMoriahDiaryEffectInit = true
	end
end)
