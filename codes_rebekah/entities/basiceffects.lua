

--special beam circle effect
do
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local player = yandereWaifu.GetEntityData(eff).parent
		local sprite = eff:GetSprite();
		local playerdata = yandereWaifu.GetEntityData(player)
		
		if eff.FrameCount % 15 == 0 then
			ILIB.game:MakeShockwave(eff.Position, 0.035, 0.025, 10)
		end
		if eff.FrameCount == 1 then
			sprite:Play("Start", true) --normal attack
			--eff.RenderZOffset = 10000;
			ILIB.game:MakeShockwave(eff.Position, 0.035, 0.025, 10)
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

yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, function(_, eff)
	local sprite = eff:GetSprite();
	local data = yandereWaifu.GetEntityData(eff)
	sprite.Color = Color( 1, 1, 1, 0, 0, 0, 0 );
end, RebekahCurse.ENTITY_REBEKAH_DUST);

yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local sprite = eff:GetSprite();
	local data = yandereWaifu.GetEntityData(eff)
	
	if eff.FrameCount == 1 then
		--sprite.Color = Color( 1, 1, 1, 0.5, 0, 0, 0 );
		eff.RenderZOffset = 100;
		if eff.SubType == RebekahCurseDustEffects.ENTITY_REBEKAH_GENERIC_DUST then
			sprite:Play("Side", true) 
		elseif eff.SubType == RebekahCurseDustEffects.ENTITY_REBEKAH_GENERIC_DUST_FRONT then
			sprite:Play("Front", true) 
		elseif eff.SubType == RebekahCurseDustEffects.ENTITY_REBEKAH_GENERIC_DUST_ANGLED then
			sprite:Play("Angled", true) 
		elseif eff.SubType == RebekahCurseDustEffects.ENTITY_REBEKAH_GENERIC_DUST_ANGLED_BACK then
			sprite:Play("AngledBack", true) 
		elseif eff.SubType == RebekahCurseDustEffects.ENTITY_REBEKAH_CHARGE_DUST then
			sprite:Load("gfx/effects/red/charge_dust.anm2", true)
			sprite:Play("Charge", true) 
		elseif eff.SubType == RebekahCurseDustEffects.ENTITY_REBEKAH_LUDO_LIGHTNING then
			sprite:Load("gfx/effects/red/red_ludocrashlightning.anm2", true)
			sprite:Play("Crash", true) 
			if data.Soul then
				InutilLib.SFX:Play(RebekahCurseSounds.SOUND_SOULJINGLE, 1, 0, false, 1)
				sprite:ReplaceSpritesheet(0, "gfx/effects/soul/hugsandroses_flare.png")
				sprite:ReplaceSpritesheet(2, "gfx/effects/soul/hugsandroses_flare.png")
				sprite:LoadGraphics()
			else
				InutilLib.SFX:Play(RebekahCurseSounds.SOUND_REDJINGLE, 1, 0, false, 1)
			end
			sprite.Color = Color( 1, 1, 1, 1, 0, 0, 0 );
		elseif eff.SubType == RebekahCurseDustEffects.ENTITY_REBEKAH_SOUL_ARCANE_CIRCLE then
			sprite:Load("gfx/effects/soul/effectchargeoutro.anm2", true)
			sprite:Play("Poof", true) 
			sprite.Color = Color( 1, 1, 1, 1, 0, 0, 0 );
		elseif eff.SubType == RebekahCurseDustEffects.ENTITY_REBEKAH_SOUL_PUKE_EFFECT then
			sprite:Load("gfx/effects/soul/ectoplasm_spit.anm2", true)
			sprite:Play("Poof", true) 
			sprite.Color = Color( 1, 1, 1, 1, 0, 0, 0 );
		elseif eff.SubType == RebekahCurseDustEffects.ENTITY_REBEKAH_SPECIAL_ARCANE_CIRCLE then
			sprite:Load("gfx/effects/soul/special_arcane_circle.anm2", true)
			sprite:Play("Poof", true) 
		elseif eff.SubType == RebekahCurseDustEffects.ENTITY_REBEKAH_LUDO_MOUTH then
			sprite:Load("gfx/effects/soul/ludo_mouth.anm2", true)
			sprite:Play("Poof", true) 
			sprite.Color = Color( 1, 1, 1, 1, 0, 0, 0 );
		elseif eff.SubType == RebekahCurseDustEffects.ENTITY_REBEKAH_GENERIC_DUST_BIG then
			sprite:Load("gfx/effects/red/dash_dust_big.anm2", true)
			sprite:Play("Side", true) 
		elseif eff.SubType == RebekahCurseDustEffects.ENTITY_REBEKAH_GENERIC_DUST_FRONT_BIG then
			sprite:Load("gfx/effects/red/dash_dust_big.anm2", true)
			sprite:Play("Front", true) 
		elseif eff.SubType == RebekahCurseDustEffects.ENTITY_REBEKAH_GENERIC_DUST_ANGLED_BIG then
			sprite:Load("gfx/effects/red/dash_dust_big.anm2", true)
			sprite:Play("Angled", true) 
		elseif eff.SubType == RebekahCurseDustEffects.ENTITY_REBEKAH_GENERIC_DUST_ANGLED_BACK_BIG then
			sprite:Load("gfx/effects/red/dash_dust_big.anm2", true)
			sprite:Play("AngledBack", true) 
		elseif eff.SubType == RebekahCurseDustEffects.ENTITY_REBEKAH_GOLD_FORCE_FIELD then
			sprite:Load("gfx/effects/gold/stomp_shield.anm2", true)
			sprite:Play("Shield", true) 
		

		elseif eff.SubType == RebekahCurseDustEffects.ENTITY_REBEKAH_CURSED_SLAM then
			sprite:Load("gfx/effects/tainted/cursed/slam.anm2", true)
			sprite:Play("Slam", true) 
			sprite.Color = Color( 1, 1, 1, 1, 0, 0, 0 );
			eff.RenderZOffset = 100;
		elseif eff.SubType == RebekahCurseDustEffects.ENTITY_REBEKAH_CURSED_SLAM_DEFAULT then
			sprite:Load("gfx/effects/tainted/cursed/slam_default.anm2", true)
			sprite:Play("Slam", true) 
			eff.RenderZOffset = 100;
		elseif eff.SubType == RebekahCurseDustEffects.ENTITY_REBEKAH_CURSED_HEAVY_STRIKE then
			sprite:Load("gfx/effects/tainted/cursed/heavy_strike.anm2", true)
			sprite:Play("Slam", true) 
			sprite.Color = Color( 1, 1, 1, 1, 0, 0, 0 );
			eff.RenderZOffset = 100;
		elseif eff.SubType == RebekahCurseDustEffects.ENTITY_REBEKAH_CURSED_WILD_SWING then
			sprite:Load("gfx/effects/tainted/cursed/wild_swing.anm2", true)
			sprite:Play("Slam", true) 
			sprite.Color = Color( 1, 1, 1, 1, 155, 0, 155 );
			eff.RenderZOffset = 100;
		end
	end
	if sprite:IsFinished("Side") or sprite:IsFinished("Front") or sprite:IsFinished("Angled") or sprite:IsFinished("AngledBack") or sprite:IsFinished("Poof") or sprite:IsFinished("Crash") or sprite:IsFinished("Shield") or sprite:IsFinished("Slam") then
		eff:Remove()
	end
	if eff.SubType == RebekahCurseDustEffects.ENTITY_REBEKAH_CHARGE_DUST then
		eff.Position = data.Parent.Position
		eff.Velocity = data.Parent.Velocity
	end
	if eff.SubType == RebekahCurseDustEffects.ENTITY_REBEKAH_LUDO_LIGHTNING then
		if sprite:GetFrame() == 9 then
			if data.Soul then
				yandereWaifu.GetEntityData(data.Parent).FinishedPlayingCustomAnim = true
				local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_REBEKAH_DUST, 9, InutilLib.GetPlayerLudo(data.Parent).Position, Vector.Zero, data.Parent)
			else
				yandereWaifu.GetEntityData(data.Parent).isPlayingCustomAnim = false
				yandereWaifu.GetEntityData(data.Parent).FinishedPlayingCustomAnim = true
				yandereWaifu.GetEntityData(data.Parent).BarrageIntro = true 
			end
			ILIB.game:ShakeScreen(10)
		end
	end
	if eff.SubType == RebekahCurseDustEffects.ENTITY_REBEKAH_GOLD_FORCE_FIELD and sprite:GetFrame() < 12 then
		--tear projectiles defence
		for i, e in pairs(Isaac.GetRoomEntities()) do
			if e.Type == EntityType.ENTITY_PROJECTILE then
				if (e.Position - data.Parent.Position):Length() < 80 then
				local oldProj = e
				local projdata = yandereWaifu.GetEntityData(oldProj)
				projdata.Variant = oldProj.Variant
				projdata.Subtype = oldProj.Subtype
				projdata.Scale = oldProj.Scale
				projdata.CollisionDamage = oldProj.CollsionDamage
				--local newProj = ILIB.game:Spawn( EntityType.ENTITY_PROJECTILE, projdata.Variant, oldProj.Position, Vector(0,0), data.Parent, 0, 0):ToProjectile();
				local crack = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACK_THE_SKY, 1, oldProj.Position, Vector(0,0), data.Parent) 
				--newProj:AddFallingSpeed(-9 + math.random() * 2) ;
				--newProj:AddFallingAccel(0.5);
				--newProj:AddProjectileFlags(ProjectileFlags.HIT_ENEMIES)
				oldProj:Remove()
				end
			elseif e:IsEnemy() and eff.FrameCount % 5 == 0 then
				if (e.Position - data.Parent.Position):Length() < 80 then
					e:TakeDamage(data.Parent.Damage/3, 0, EntityRef(eff), 4)
				end
			end
		end
	end
end, RebekahCurse.ENTITY_REBEKAH_DUST);


yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local sprite = eff:GetSprite()
	local data = yandereWaifu.GetEntityData(eff)
	
	--sprite:LoadGraphics()
	if eff.FrameCount == 1 then
		sprite:Play("Fly",1);
		if math.random(1,2) == 1 then
			sprite.FlipX = true
		end
		data.trail = InutilLib.SpawnTrail(eff, Color(1,0,0,0.5))
	end
	if data.Parent then
		if (data.Parent.Position - eff.Position):Length() <= 30 then
			sprite:Play("Splash")
			eff.Velocity = Vector.Zero
		else
			eff.Velocity = (eff.Velocity + (data.Parent.Position - eff.Position):Resized(3))*0.9
		end
	end
	if sprite:IsFinished("Splash") then
		yandereWaifu.addReserveFill(data.Parent, data.maxHealth)
		data.trail:Remove()
		eff:Remove()
	end
	if sprite:IsPlaying("Splash") and sprite:GetFrame() == 1 then
		InutilLib.SFX:Play( SoundEffect.SOUND_GOLD_HEART_DROP, 1, 0, false, 1.1 )
	end
end, RebekahCurse.ENTITY_LOVELOVEPARTICLE)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local sprite = eff:GetSprite()
	local data = yandereWaifu.GetEntityData(eff)
	
	--sprite:LoadGraphics()
	if eff.FrameCount == 1 then
		sprite:Play("Gulp",1);
	end
	if data.Parent then
		eff.Position = data.Parent.Position
	end
	if sprite:IsFinished("Gulp") then
		eff:Remove()
	end
end, RebekahCurse.ENTITY_HEARTGULP)

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
			lz:GetSprite():Load("gfx/effects/eternal/lightbeam.anm2", true)
			lz:GetSprite():Play("LargeRedLaser", true)
		end
	 end
	if entityData.IsLvlTwoBeam then
		if lz.FrameCount == 1 then
			lz:GetSprite():Load("gfx/effects/eternal/lightbeam2.anm2", true)
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
			lz:GetSprite():Load("gfx/effects/eternal/lightbeam3.anm2", true)
			lz:GetSprite():Play("LargeRedLaser", true)
			lz:GetSprite():LoadGraphics()
		end
	 end
	 if entityData.IsThickTechnology == 1 then
		if lz.FrameCount == 1 then
			lz:GetSprite():ReplaceSpritesheet(0, "gfx/effects/red_laser.png")
		end
	end
	if entityData.IsEcto then
		if lz.FrameCount == 1 then
			if lz.Variant == 11 then
				lz:GetSprite():Load("gfx/effects/soul/effect_ectoplasmlaserthicker.anm2", true)
				lz:GetSprite():Play("LargeRedLaser", true)
				if lz.Child ~= nil then
					lz.Child:GetSprite():Load("gfx/effects/soul/effect_ectoplasmlaserthickerend.anm2", true)
					lz.Child.Color =  Color( 1, 1, 1, 1, 0, 0, 0 )
					lz.Child:GetSprite():LoadGraphics()
					lz.Child:GetSprite():Play("Loop", true)
				end
			else
				lz:GetSprite():Load("gfx/effects/soul/effect_ectoplasmlaser.anm2", true)
				lz:GetSprite():Play("LargeRedLaser", true)
				if lz.Child ~= nil then
					lz.Child.Color =  Color( 1, 1, 1, 0, 0, 0, 0 )
					--[[lz.Child:GetSprite():Load("gfx/effects/soul/effect_ectoplasmlaserend.anm2", true)
					lz.Child:GetSprite():LoadGraphics()
					lz.Child.Color = lz.Parent:GetSprite().Color
					lz.Child:GetSprite():Play("Loop", true)]]
				end
			end
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
	if entityData.AngelBrimstone2 == true then
		if lz.FrameCount == 1 then
			lz:GetSprite():Load("gfx/effects/eternal/angelbrimstone_buffed.anm2", true)
			lz:GetSprite():Play("LargeRedLaser", true)
			if lz.Child ~= nil then
				lz.Child:GetSprite():Load("gfx/effects/eternal/angelbrimstone_impact_buffed.anm2", true)
				lz.Child:GetSprite():LoadGraphics()
				lz.Child.Color = lz.Parent:GetSprite().Color
			end
		end
	end
	if entityData.BrimBone then
		if lz.FrameCount == 1 then
			lz:GetSprite():Load("gfx/effects/bone/brimbone.anm2", true)
			lz:GetSprite():Play("LargeRedLaser", true)
			if lz.Child ~= nil then
				print("test")
				lz.Child:GetSprite():Load("gfx/effects/bone/brimbone_impact.anm2", true)
				lz.Child:GetSprite():LoadGraphics()
				lz.Child:GetSprite():Play("Loop", true)
				--lz.Child.Color = lz.Parent:GetSprite().Color
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
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	if eff.Type == 1000 and eff.Variant == 71 and eff.FrameCount == 1 then
		if yandereWaifu.GetEntityData(eff.Child).IsEvil then
			eff:SetColor(Color(0,0,0,1,0.8,0,1),9999999,99,false,false)
		end
	end
end)

--arcane stuff
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local sprite = eff:GetSprite()
	local data = yandereWaifu.GetEntityData(eff)
	
	if data.parent then
		eff.Position = data.parent.Position
		eff.Velocity = data.parent.Velocity
	end
	
	--sprite:LoadGraphics()
	if eff.FrameCount == 1 and eff.SubType == 0 then
		sprite:Play("FadeIn", true)
		InutilLib.SFX:Play( RebekahCurseSounds.SOUND_GROUNDCRACK, 1, 0, false, 0.9 )
	end
	if sprite:IsPlaying("FadeIn") then
		ILIB.game:ShakeScreen(4)
	end
	if sprite:IsFinished("FadeIn") then
		sprite:Play("Pentagram", true)
	end
	if sprite:IsFinished("FadeOut") then
		eff:AddEntityFlags(EntityFlag.FLAG_RENDER_FLOOR)
		--eff:Remove()
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
	
	if data.TimeoutFrame == data.Timeout then
		sprite:Play("Disappear", false)
	else
		data.TimeoutFrame = data.TimeoutFrame + 1
	end
	
	if sprite:IsFinished("Appear") then
		sprite:Play("Spot", false)
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
		elseif eff.SubType == 4 then
			sprite:ReplaceSpritesheet(0, "gfx/effects/items/imdie/gray.png")
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
	if eff.SubType == 10 and data.Parent then
		eff.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
		eff.Position = data.Parent.Position
		--eff.Variant = data.Parent.Variant
	end
end, RebekahCurse.ENTITY_PINGEFFECT)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local sprite = eff:GetSprite();
	local data = yandereWaifu.GetEntityData(eff)
	
	if sprite:IsPlaying("Drop") and sprite:GetFrame() == 4 then
		local mob = Isaac.Spawn( EntityType.ENTITY_EFFECT, 16, 2, eff.Position, Vector.Zero, eff );
		InutilLib.SFX:Play( SoundEffect.SOUND_CHEST_DROP, 1, 0, false, 0.5 )
		ILIB.game:ShakeScreen(10)
	end
	if sprite:IsFinished("Drop") then
		eff:Remove()
	end
end, RebekahCurse.ENTITY_BEAUTIFULGRAVEDROP)

--rebekah miniisaac thing
function yandereWaifu:MiniIsaacReplaceSpritesheet(fam)
	local player = fam.Player
	local sprite = fam:GetSprite()
	if yandereWaifu.IsNormalRebekah(player) then
		sprite:ReplaceSpritesheet(0, "gfx/familiar/familiar_minisaac_rebekah.png")
		sprite:ReplaceSpritesheet(1, "gfx/familiar/familiar_minisaac_rebekah.png")
	end
	sprite:LoadGraphics()
end
yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, yandereWaifu.MiniIsaacReplaceSpritesheet, FamiliarVariant.MINISAAC)


--drunk puddle
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local sprite = eff:GetSprite();
	local data = yandereWaifu.GetEntityData(eff)
	
	if eff.SubType == 177 then
		if eff.FrameCount == 1 then
			sprite:ReplaceSpritesheet(0, "gfx/effects/wine_splat.png")
			sprite:LoadGraphics()
			data.IsWine = true
		end
	end
end, EffectVariant.PLAYER_CREEP_LEMON_MISHAP)

yandereWaifu:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, damage, amount, damageFlag, damageSource, damageCountdownFrames) 
	if damage:IsEnemy() then
		if not damageSource.Entity then return end
		local data = yandereWaifu.GetEntityData(damageSource.Entity)
		if damageSource.Entity.Type == 1000 and damageSource.Entity.Variant == EffectVariant.PLAYER_CREEP_LEMON_MISHAP and data.IsWine then
			yandereWaifu.GetEntityData(damage).IsDrunk = math.random(60,85)
			return false
		end
	end
end)