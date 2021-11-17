

--special beam circle effect
do
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local player = yandereWaifu.GetEntityData(eff).parent
		local sprite = eff:GetSprite();
		local playerdata = yandereWaifu.GetEntityData(player)
		
		if eff.FrameCount == 1 then
			sprite:Play("Start", true) --normal attack
			--eff.RenderZOffset = 10000;
		elseif sprite:IsFinished("Start") then
			sprite:Play("Loop")
		end
		--eff.Velocity = eff.Velocity * 0.88;
		if not playerdata.isReadyForSpecialAttack then 
			sprite:Play("End")
		end
		if sprite:IsFinished("End") then
			eff:Remove()
		end
		eff.Velocity = player.Velocity;
		eff.Position = player.Position;
end, RebekahCurse.ENTITY_SPECIALBEAM);
end

--broken glasses effect
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	--for i,player in ipairs(ILIB.players) do
		local sprite = eff:GetSprite();
		--local playerdata = yandereWaifu.GetEntityData(player)
		
		if not sprite:IsPlaying("Flying") then
			if eff.FrameCount == 1 then
				sprite:Play("Flying", true) --normal attack
			elseif sprite:IsFinished("Flying") then
				sprite:Play("Land")
			end
		end
		eff.Velocity = eff.Velocity * 0.9
		InutilLib.FlipXByVec(eff, true)
	--end
end, RebekahCurse.ENTITY_BROKEN_GLASSES);

yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
		local sprite = eff:GetSprite();
		
		if eff.FrameCount == 1 then
			sprite:Play("Poof", true) --normal attack
			eff.RenderZOffset = 100;
			eff.Position = eff.Position + Vector(0,5)
		end
		if sprite:IsFinished("Poof") then
			eff:Remove()
		end
end, RebekahCurse.ENTITY_PERSONALITYPOOF);

function AddRebekahDashEffect(player)
	local customBody = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_EXTRACHARANIMHELPER, 0, player.Position, Vector(0,0), player) --body effect
	yandereWaifu.GetEntityData(customBody).Player = player
	yandereWaifu.GetEntityData(customBody).DashEffect = true
	yandereWaifu.GetEntityData(customBody).DontFollowPlayer = true
end

function yandereWaifu:getPillEffect(pillEffect, player, useFlag)
    if pillEffect == PillEffect.PILLEFFECT_PARALYSIS then
		yandereWaifu.GetEntityData(player).IsParalysed = true
    end
end
yandereWaifu:AddCallback(ModCallbacks.MC_USE_PILL, yandereWaifu.getPillEffect) 

--poof effect
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local sprite = eff:GetSprite();
	
	--sprite:LoadGraphics();
	if eff.FrameCount == 1 then
		sprite:Play("Poof", true);
	elseif sprite:IsFinished("Poof") then
		eff:Remove();
	end
end, RebekahCurse.ENTITY_HEARTPOOF)

--heart effect
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local sprite = eff:GetSprite()
	local data = yandereWaifu.GetEntityData(eff)
	
	--sprite:LoadGraphics()
	if eff.FrameCount == 1 then
		if data.Small then 
			--sprite:Play("Fly_small",true)
			sprite:SetFrame("Fly_small",1);
		elseif data.Large then
			--sprite:Play("Fly_large",true)
			sprite:SetFrame("Fly_large",1);
		else
			--sprite:Play("Fly",false)
			sprite:SetFrame("Fly",1);
		end
		if math.random(1,2) == 1 then
			sprite.FlipX = true
		end
	--elseif sprite:IsFinished("Fly") or sprite:IsFinished("Fly_small") or sprite:IsFinished("Fly_large") or eff.FrameCount > 32 then
	elseif eff.FrameCount > 16 then
		eff:Remove()
	end
	eff.Velocity = eff.Velocity - Vector( 0, math.random() + 0.5 );
	local alpha = ( 1 - (eff.FrameCount / 16) ) ^ 0.3;
	sprite.Color = Color( sprite.Color.R, sprite.Color.G, sprite.Color.G, alpha, 0, 0, 0 );
	sprite.Rotation = sprite.Rotation + eff.Velocity.X;
end, RebekahCurse.ENTITY_HEARTPARTICLE)

--lasers
function yandereWaifu:changetoDifferentLaser(lz)
	local entityData = yandereWaifu.GetEntityData(lz);
	if entityData.IsPlainTech then
		if lz.FrameCount == 1 then
			lz:GetSprite():Load("gfx/empty_techlaser.anm2", true)
			lz:GetSprite():Play("LargeRedLaser", true)
			if lz.Child ~= nil then
				lz.Child:GetSprite():Load("gfx/dark_impact.anm2", true)
				lz.Child:GetSprite():LoadGraphics()
				lz.Child.Color = lz.Parent:GetSprite().Color
			end
		end
	end
	 if entityData.IsDark == 1 then
		if lz.FrameCount == 1 then
			lz:GetSprite():Load("gfx/darkbrimstone.anm2", true)
			lz:GetSprite():Play("LargeRedLaser", true)
			if lz.Child ~= nil then
				lz.Child:GetSprite():Load("gfx/dark_impact.anm2", true)
				lz.Child:GetSprite():LoadGraphics()
				lz.Child.Color = lz.Parent:GetSprite().Color
			end
		end
	elseif entityData.IsDark == 2 then
		if lz.FrameCount == 1 then
			lz:GetSprite():Load("gfx/darkbrimstone_giant.anm2", true)
			lz:GetSprite():Play("LargeRedLaser", true)
			if lz.Child ~= nil then
				lz.Child:GetSprite():Load("gfx/dark_impact.anm2", true)
				lz.Child:GetSprite():LoadGraphics()
				lz.Child.Color = lz.Parent:GetSprite().Color
			end
		end
	end
	if entityData.IsLvlOneBeam then
		if lz.FrameCount == 1 then
			lz:GetSprite():Load("gfx/lightbeam.anm2", true)
			lz:GetSprite():Play("LargeRedLaser", true)
		end
	 end
	if entityData.IsLvlTwoBeam then
		if lz.FrameCount == 1 then
			lz:GetSprite():Load("gfx/lightbeam2.anm2", true)
			lz:GetSprite():Play("LargeRedLaser", true)
			if lz.Child ~= nil then
				lz.Child:GetSprite():Load("gfx/lvltwobrimimpact.anm2", true)
				lz.Child:GetSprite():LoadGraphics()
				lz.Child.Color = lz.Parent:GetSprite().Color
			end
		end
	 end
	if entityData.IsLvlThreeBeam then
		if lz.FrameCount == 1 then
			lz:GetSprite():Load("gfx/lightbeam3.anm2", true)
			lz:GetSprite():Play("LargeRedLaser", true)
			lz:GetSprite():LoadGraphics()
		end
	 end
	 if entityData.IsThickTechnology == 1 then
		if lz.FrameCount == 1 then
			lz:GetSprite():ReplaceSpritesheet(0, "gfx/effects/red_laser.png")
		end
	end
	 if entityData.AngelBrimstone == true then
		if lz.FrameCount == 1 then
			lz:GetSprite():Load("gfx/effects/eternal/angelbrimstone.anm2", true)
			lz:GetSprite():Play("LargeRedLaser", true)
			if lz.Child ~= nil then
				lz.Child:GetSprite():Load("gfx/effects/eternal/angelbrimstone_impact.anm2", true)
				lz.Child:GetSprite():LoadGraphics()
				lz.Child.Color = lz.Parent:GetSprite().Color
			end
		end
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_POST_LASER_RENDER, yandereWaifu.changetoDifferentLaser)

function yandereWaifu:changetoDifferentLaser2(lz)
	local entityData = yandereWaifu.GetEntityData(lz);
	 if entityData.AngelBrimstone == true then
			lz:GetSprite():Load("gfx/effects/eternal/angelbrimstone.anm2", true)
			lz:GetSprite():Play("LargeRedLaser", true)
			if lz.Child ~= nil then
				lz.Child:GetSprite():Load("gfx/effects/eternal/angelbrimstone_impact.anm2", true)
				lz.Child:GetSprite():LoadGraphics()
				lz.Child.Color = lz.Parent:GetSprite().Color
			end
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_POST_LASER_INIT, yandereWaifu.changetoDifferentLaser2)

--knife change sprite
yandereWaifu:AddCallback(ModCallbacks.MC_POST_KNIFE_UPDATE, function(_,  knf)
	local player = knf.Parent
	local knfdata = yandereWaifu.GetEntityData(knf);
	if knf.FrameCount == 0 then
		if knfdata.IsRed then
			knf:GetSprite():ReplaceSpritesheet(0, "gfx/effects/red/red_dagger.png")
			knf:GetSprite():LoadGraphics()
		elseif knfdata.IsSoul then
			knf:GetSprite():ReplaceSpritesheet(0, "gfx/effects/soul/soul_dagger.png")
			knf:GetSprite():LoadGraphics()
		elseif knfdata.IsEvil then
			knf:GetSprite():ReplaceSpritesheet(0, "gfx/effects/evil/evil_knife.png")
			knf:GetSprite():LoadGraphics()
		end
	end
end)

--mechanic, like wtf. Sac Dac can kill enemies while you just stay in mid-air, so broken lol
--so this mechanic that makes vanilla orbitals hurt nothing in a certain case, like jumping in bone mode or teleporting in soul mode
yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_,  fam)
	local player = fam.Player
	player:ToPlayer()
	local data = yandereWaifu.GetEntityData(player);
	local famdata =  yandereWaifu.GetEntityData(fam);
	--print(tostring(fam.CollisionDamage))
	if player:GetPlayerType() == Reb then
		if fam.Variant == FamiliarVariant.FLY_ORBITAL or fam.Variant == FamiliarVariant.SACRIFICIAL_DAGGER or fam.Variant == FamiliarVariant.CUBE_OF_MEAT_1  or fam.Variant == FamiliarVariant.CUBE_OF_MEAT_2 or fam.Variant == FamiliarVariant.BALL_OF_BANDAGES_1 or fam.Variant == FamiliarVariant.BALL_OF_BANDAGES_2 or fam.Variant == FamiliarVariant.OBSESSED_FAN or fam.Variant == FamiliarVariant.MOMS_RAZOR or fam.Variant == FamiliarVariant.FOREVER_ALONE or fam.Variant == FamiliarVariant.DISTANT_ADMIRATION then --list of stuff, shut up it looks messy, I know
			if data.IsUninteractible then
				if not famdata.HasBeenModified then famdata.HasBeenModified = fam.CollisionDamage end --ill just dump in the info of their last entcoll so I use too less instructions here...
				fam.CollisionDamage = 0
			elseif not data.IsUninteractible and famdata.HasBeenModified then
				fam.CollisionDamage = famdata.HasBeenModified
				famdata.HasBeenModified = nil
			end
		end
	end
end)
yandereWaifu:AddCallback(ModCallbacks.MC_POST_KNIFE_UPDATE, function(_,  knf)
	local player = knf.Parent
	if player then
		player:ToPlayer()
		local data = yandereWaifu.GetEntityData(player);
		local knfdata =  yandereWaifu.GetEntityData(knf);
		if data.IsUninteractible and knf.FrameCount > 5 then
			if not knfdata.HasBeenModified then knfdata.HasBeenModified = knf.EntityCollisionClass end --ill just dump in the info of their last entcoll so I use too less instructions here...
			knf.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		elseif not data.IsUninteractible and knfdata.HasBeenModified then
			knf.EntityCollisionClass = knfdata.HasBeenModified
			knfdata.HasBeenModified = nil
		end
	end
end)

--arcane stuff
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local sprite = eff:GetSprite()
	local data = yandereWaifu.GetEntityData(eff)
	
	--sprite:LoadGraphics()
	if eff.FrameCount == 1 then
		sprite:Play("FadeIn", true)
	end
	if sprite:IsFinished("FadeIn") then
		sprite:Play("Pentagram", true)
	end
	if sprite:IsFinished("FadeOut") then
		eff:Remove()
	end
	eff.RenderZOffset = -10000;
end, RebekahCurse.ENTITY_ARCANE_CIRCLE)

--Ungeneric Tracer

yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local sprite = eff:GetSprite();
	local data = yandereWaifu.GetEntityData(eff)
	if not data.TimeoutFrame then 
		data.TimeoutFrame = 0 
	end
	
	if sprite:IsFinished("Appear") then
		sprite:Play("Spot", false)
	end
	
	if data.TimeoutFrame == data.Timeout then
		sprite:Play("Disappear", false)
	else
		data.TimeoutFrame = data.TimeoutFrame + 1
	end
	if sprite:IsFinished("Disappear") then
		eff:Remove()
	end
end, RebekahCurse.ENTITY_UNGENERICTRACER)

--Ping

yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, function(_, eff)
	local sprite = eff:GetSprite();
	local data = yandereWaifu.GetEntityData(eff)
	
	--if eff.FrameCount == 1 then
		if eff.SubType == 1 then
			sprite:ReplaceSpritesheet(0, "gfx/effects/items/imdie/blue.png")
		elseif eff.SubType == 2 then
			sprite:ReplaceSpritesheet(0, "gfx/effects/items/imdie/green.png")
		elseif eff.SubType == 3 then
			sprite:ReplaceSpritesheet(0, "gfx/effects/items/imdie/yellow.png")
		end
		sprite:LoadGraphics()
	--end
	
end, RebekahCurse.ENTITY_PINGEFFECT)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local sprite = eff:GetSprite();
	local data = yandereWaifu.GetEntityData(eff)
	
	if sprite:IsFinished("Ping") then
		eff:Remove()
	end
end, RebekahCurse.ENTITY_PINGEFFECT)