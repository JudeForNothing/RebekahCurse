
function yandereWaifu.RebekahImmortalBarrage(player, direction)
	InutilLib.SFX:Play(RebekahCurse.Sounds.SOUND_IMMORTALJINGLE, 1, 0, false, 1)
	--local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_PERSONALITYPOOF, 0, player.Position, Vector.Zero, player)
	local prism = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_IMMORTAL_PRISM, 0, player.Position, Vector(0,0), player)
end

yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local player = eff.SpawnerEntity;
	local sprite = eff:GetSprite();
	local data = yandereWaifu.GetEntityData(eff)
	
	eff.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL

	for i, v in pairs (Isaac.GetRoomEntities()) do
		if v:ToPlayer() then
			local playerdata = yandereWaifu.GetEntityData(v)
			if (v.Position - eff.Position):Length() <= 270 then
				if not playerdata.ImmortalPrismProp or playerdata.ImmortalPrismProp:IsDead() then
					playerdata.ImmortalPrismProp = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.ANGELIC_PRISM, 177, eff.Position, Vector.Zero, nil)
					yandereWaifu.GetEntityData(playerdata.ImmortalPrismProp).YoureATool = true
					yandereWaifu.GetEntityData(playerdata.ImmortalPrismProp).YoureAToolParent = v
					yandereWaifu.GetEntityData(playerdata.ImmortalPrismProp).YoureAToolParentCrystal = eff
					yandereWaifu.GetEntityData(playerdata.ImmortalPrismProp).Safe = true
				end
			else
				if playerdata.ImmortalPrismProp then
					--if owned by self
					if GetPtrHash(yandereWaifu.GetEntityData(playerdata.ImmortalPrismProp).YoureAToolParentCrystal) == GetPtrHash(eff) then
						playerdata.ImmortalPrismProp:Remove()
						playerdata.ImmortalPrismProp = nil
						v:ToPlayer():AddCacheFlags(CacheFlag.CACHE_FAMILIARS);
						v:ToPlayer():EvaluateItems()
					end
				end
			end
		end
	end
	if eff.FrameCount >= 1400 then
		if eff.FrameCount%15 == 0 then
			sprite.Color = Color(1,0,0,1)
			SFXManager():Play( RebekahCurse.Sounds.SOUND_IMDIEBEEP , 1, 0, false, 0.4 )
		else
			sprite.Color = Color(1,1,1,1)
		end
	end
	if sprite:IsFinished("Death") then
		eff:Remove()
	elseif eff.FrameCount >= 1800 and not sprite:IsPlaying("Death") then
		sprite:Play("Death", true)
	end
	
end,RebekahCurse.ENTITY_IMMORTAL_PRISM);

yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, fam)
	local player = fam.SpawnerEntity;
	local sprite = fam:GetSprite();
	local data = yandereWaifu.GetEntityData(fam)
	
	if fam.SubType == 177 and not data.Safe and fam.FrameCount <= 10 then
		fam:Remove()
	end
	local offset = 0
	if data.YoureAToolParent and data.YoureAToolParent:ToPlayer():HasCollectible(CollectibleType.COLLECTIBLE_MOMS_KNIFE) then
		offset = 25 
	end
	if data.YoureATool then
		fam.Size = 110
		if (data.YoureAToolParent:ToPlayer():GetShootingJoystick().X ~= 0 or data.YoureAToolParent:ToPlayer():GetShootingJoystick().Y ~= 0) or not data.lastToolPosition then
			data.lastToolPosition = data.YoureAToolParent:ToPlayer():GetShootingJoystick() * (5 + offset)
		end
		fam:RemoveFromOrbit()
		fam.Position = data.YoureAToolParent.Position + data.lastToolPosition
		fam.Velocity = data.YoureAToolParent.Velocity
		fam.SpriteOffset = Vector(0,-50)
		fam.Parent = nil
	end
	
end,FamiliarVariant.ANGELIC_PRISM);

--[[yandereWaifu:AddCallback(ModCallbacks.MC_PRE_NPC_COLLISION, function(_, eff, coll, low)
	print(coll.Type)
	if coll.Type == 100 then
		print((v.Position - eff.Position):Length())
		return false
	end
end, ENTITY_ANGLEDHOLYMANTLE)]]
