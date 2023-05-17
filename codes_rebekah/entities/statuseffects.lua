local statusEffects = Sprite();
statusEffects:Load("gfx/ui/rebekahstatuseffects.anm2", true);

local greenLaughterColor = Color(0, 1, 0, 1, 0, 0, 0)
local purpleDrunkColor = Color(0.5, 0, 0.7, 1, 0, 0, 0)
local brownNoBabiesColor = Color(1, 0.5, 0, 1, 0, 0, 0)

yandereWaifu:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, ent)
	local data = yandereWaifu.GetEntityData(ent)
	local player = data.PlayerStruck
	
	--laughing
	if data.IsLaughing then
		if not InutilLib.game:IsPaused() then
            data.IsLaughing = data.IsLaughing - 1
            if data.IsLaughing <= 0 then
                data.IsLaughing = nil
            end
        end
	end

    --drunk
	if data.IsDrunk then
		if not InutilLib.game:IsPaused() then
            data.IsDrunk = data.IsDrunk - 1
            ent.Target = InutilLib.GetClosestGenericEnemy(ent, 700)
            --print(ent.Target.Type)
           -- ent:AddEntityFlags(EntityFlag.FLAG_CHARM)
            if ent.Velocity:Length() < 7 then
                ent.Velocity = (ent.Velocity * (1.2))
            end
            if data.IsDrunk <= 0 then
                data.IsDrunk = nil
                ent.Target = InutilLib.GetClosestPlayer(ent, 700)
                --ent:ClearEntityFlags(EntityFlag.FLAG_CHARM)
            end
        end
	end

	--no babies
	if data.IsMenopaused then
		if not InutilLib.game:IsPaused() then
            data.IsMenopaused = data.IsMenopaused - 1
            if data.IsMenopaused <= 0 then
                data.IsMenopaused = nil
            end
        end
	end

	--intimidated
	if data.isIntimidated then
		if not InutilLib.game:IsPaused() then
            data.isIntimidated = data.isIntimidated - 1
            if data.isIntimidated <= 0 then
                data.isIntimidated = nil
				ent:ClearEntityFlags(EntityFlag.FLAG_WEAKNESS)
				print("bye bye")
			else
				if not ent:HasEntityFlags(EntityFlag.FLAG_WEAKNESS) then
					ent:AddEntityFlags(EntityFlag.FLAG_WEAKNESS)
				end
            end
        end
		ent.Velocity = ent.Velocity * 0.5
	end

	--cheese
	if data.IsCheesed then
        if not InutilLib.game:IsPaused() then
            data.IsCheesed = data.IsCheesed - 1
            if data.IsCheesed <= 0 then
                data.IsCheesed = nil
            end
        end
		if ent:IsDead() then -- on death
			for i, entenmies in pairs(Isaac.GetRoomEntities()) do --affect others
				if entenmies:IsEnemy() and entenmies:IsVulnerableEnemy() then
					if yandereWaifu.GetEntityData(entenmies).IsCheesed then
						entenmies:TakeDamage(player.Damage, 0, EntityRef(ent), 1)
					end
				end
			end
		end
    end

	--tainted rebekah stuff
	if data.isGlorykill then
		if not InutilLib.game:IsPaused() then
            data.isGlorykill = data.isGlorykill - 1
            if data.isGlorykill <= 0 then
                data.isGlorykill = nil
			end
		end
	end
	if data.isSnooked then
		if not InutilLib.game:IsPaused() then
            data.isSnooked = data.isSnooked - 1
            if data.isSnooked <= 0 then
                data.isSnooked = nil
			end
		end
	end
	if data.isSlamSnooked then
		if not InutilLib.game:IsPaused() then
            data.isSlamSnooked = data.isSlamSnooked - 1
            if data.isSlamSnooked <= 0 then
                data.isSlamSnooked = nil
				ent.Velocity = yandereWaifu.GetEntityData(ent).SnookVelocity
				InutilLib.SFX:Play( RebekahCurse.Sounds.SOUND_CURSED_POP, 1, 0, false, math.random(8,12)/10 );
			end
		end
	end
	if data.isHeavySnooked then
		if not InutilLib.game:IsPaused() then
            data.isHeavySnooked = data.isHeavySnooked - 1
            if data.isHeavySnooked <= 0 then
                data.isHeavySnooked = nil
			end
		end
	end

	if data.isCursedGodheadSlam then
		if not InutilLib.game:IsPaused() then
            data.isCursedGodheadSlam = data.isCursedGodheadSlam - 1
			if data.CursedGodheadSlamTier and data.CursedGodheadSlamTier >= 3 then
				local aura = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_CURSEDGODHEADAURA, 0, ent.Position, Vector.Zero, player):ToEffect()
				yandereWaifu.GetEntityData(aura).Player = data.lastGodheadSlammedPlayer
				yandereWaifu.GetEntityData(aura).GivenPos = ent.Position
				yandereWaifu.GetEntityData(aura).Tier = data.CursedGodheadSlamTier
				data.CursedGodheadSlamTier = nil
				data.isCursedGodheadSlam = nil
				local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, 15, 0, ent.Position, Vector.Zero, player):ToEffect()
				poof:GetSprite():ReplaceSpritesheet(0, "gfx/effects/poof_old.png")
				poof:GetSprite():LoadGraphics()
				yandereWaifu.SpawnPoofParticle( ent.Position, Vector(0,0), ent, RebekahCurse.RebekahPoofParticleType.Gold );
				InutilLib.SFX:Play(SoundEffect.SOUND_GLASS_BREAK, 1, 0, false, 1);
			elseif data.isCursedGodheadSlam <= 0 then
				local aura = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_CURSEDGODHEADAURA, 0, ent.Position, Vector.Zero, player):ToEffect()
                yandereWaifu.GetEntityData(aura).Player = data.lastGodheadSlammedPlayer
                yandereWaifu.GetEntityData(aura).GivenPos = ent.Position
				yandereWaifu.GetEntityData(aura).Tier = data.CursedGodheadSlamTier
				data.CursedGodheadSlamTier = nil
				data.isCursedGodheadSlam = nil
				local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, 15, 0, ent.Position, Vector.Zero, player):ToEffect()
				poof:GetSprite():ReplaceSpritesheet(0, "gfx/effects/poof_old.png")
				poof:GetSprite():LoadGraphics()
				yandereWaifu.SpawnPoofParticle( ent.Position, Vector(0,0), ent, RebekahCurse.RebekahPoofParticleType.Gold );
				InutilLib.SFX:Play(SoundEffect.SOUND_GLASS_BREAK, 1, 0, false, 1);
			end
		end
	end
	if data.CursedEpicFetusTargeted then
		if not InutilLib.game:IsPaused() then
			data.CursedEpicFetusTargeted = data.CursedEpicFetusTargeted - 1
			if data.CursedEpicFetusTargeted == 0 then
				InutilLib.spawnEpicRocket(player, ent.Position, true, 10)
				data.CursedEpicFetusTargeted = nil
			end
		end
	end
	if data.IsSilenced then
		if not InutilLib.game:IsPaused() then
			data.IsSilenced = data.IsSilenced - 1
			if data.IsSilenced == 0 then
				data.IsSilenced = nil
			end
		end
	end
	if data.IsGonnaCombo then
		if not InutilLib.game:IsPaused() then
			data.IsGonnaCombo = data.IsGonnaCombo - 1
			if data.IsGonnaCombo == 0 then
				data.IsGonnaCombo = nil
			end
		end
	end
end)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, function(_, ent)
	local data = yandereWaifu.GetEntityData(ent)
	local player = data.PlayerStruck
	
	--laughing
	if data.IsLaughing then
		ent:SetColor(greenLaughterColor, 2, 5, true, true)
		if not data.laughingRenderFrame then data.laughingRenderFrame = 0 end
		local loc = Isaac.WorldToScreen(ent.Position)
		statusEffects:SetOverlayRenderPriority(true)
		statusEffects:SetFrame("Laughing", data.laughingRenderFrame)
		statusEffects:Render(loc + Vector(0, -30), Vector(0,0), Vector(0,0));
		data.laughingRenderFrame = data.laughingRenderFrame + 1
		if data.laughingRenderFrame >= 7 then data.laughingRenderFrame = 0 end
	end

    --drunk
	if data.IsDrunk then
		ent:SetColor(purpleDrunkColor, 2, 5, true, true)
		if not data.drunkRenderFrame then data.drunkRenderFrame = 0 end
		local loc = Isaac.WorldToScreen(ent.Position)
		statusEffects:SetOverlayRenderPriority(true)
		statusEffects:SetFrame("Drunk", data.drunkRenderFrame)
		statusEffects:Render(loc + Vector(0, -30), Vector(0,0), Vector(0,0));
		data.drunkRenderFrame = data.drunkRenderFrame + 1
		if data.drunkRenderFrame >= 11 then data.drunkRenderFrame = 0 end
	end

	--menopaused
	if data.IsMenopaused then
		ent:SetColor(brownNoBabiesColor, 2, 5, true, true)
		if not data.menopausedRenderFrame then data.menopausedRenderFrame = 0 end
		local loc = Isaac.WorldToScreen(ent.Position)
		statusEffects:SetOverlayRenderPriority(true)
		statusEffects:SetFrame("Menopaused", data.menopausedRenderFrame)
		statusEffects:Render(loc + Vector(0, -30), Vector(0,0), Vector(0,0));
		data.menopausedRenderFrame = data.menopausedRenderFrame + 1
		if data.menopausedRenderFrame >= 7 then data.menopausedRenderFrame = 0 end
	end

	--silenced
	if data.IsSilenced then
		ent:SetColor(Color(0.5, 0.5, 0.5, 1), 2, 5, true, true)
		if not data.IsSilenceRenderFramed then data.IsSilenceRenderFramed = 0 end
		local loc = Isaac.WorldToScreen(ent.Position)
		statusEffects:SetOverlayRenderPriority(true)
		statusEffects:SetFrame("Silenced", data.IsSilenceRenderFramed)
		statusEffects:Render(loc + Vector(0, -30), Vector(0,0), Vector(0,0));
		data.IsSilenceRenderFramed = data.IsSilenceRenderFramed + 1
		if data.IsSilenceRenderFramed >= 23 then data.IsSilenceRenderFramed = 0 end
	end

	--regicide
	if data.IsGonnaCombo then
		ent:SetColor(Color(0.5, 0.5, 0.5, 1), 2, 5, true, true)
		if not data.RegicideTick then data.RegicideTick = 0 end
		local loc = Isaac.WorldToScreen(ent.Position)
		statusEffects:SetOverlayRenderPriority(true)
		statusEffects:SetFrame("Regicide", data.RegicideTick)
		statusEffects:Render(loc + Vector(0, -30), Vector(0,0), Vector(0,0));
	end

	if data.isGlorykillProc then
		ent:SetColor(Color(0.5, 0.5, 0.5, 1), 2, 5, true, true)
		if not data.isGlorykillProcFrame then data.isGlorykillProcFrame = 0 end
		local loc = Isaac.WorldToScreen(ent.Position)
		statusEffects:SetOverlayRenderPriority(true)
		statusEffects:SetFrame("Glorykill", data.isGlorykillProcFrame)
		statusEffects:Render(loc + Vector(0, -30), Vector(0,0), Vector(0,0));
		data.isGlorykillProcFrame = data.isGlorykillProcFrame + 1
		if data.isGlorykillProcFrame >= 1 then data.isGlorykillProcFrame = 0 end
	end
	if data.isGlorykill then
		ent:SetColor(Color(0.5, 0.5, 0.5, 1), 2, 5, true, true)
		if not data.isGlorykillFrame then data.isGlorykillFrame = 0 end
		local loc = Isaac.WorldToScreen(ent.Position)
		statusEffects:SetOverlayRenderPriority(true)
		statusEffects:SetFrame("Glorykill", data.isGlorykillFrame)
		statusEffects:Render(loc + Vector(0, -30), Vector(0,0), Vector(0,0));
		data.isGlorykillFrame = data.isGlorykillFrame + 1
		if data.isGlorykillFrame >= 7 then data.isGlorykillFrame = 0 end
	end

	--epic fetus thing
	if data.CursedEpicFetusTargeted then
		ent:SetColor(brownNoBabiesColor, 2, 5, true, true)
		if not data.EpicFetusRenderFrame then data.EpicFetusRenderFrame = 0 end
		local loc = Isaac.WorldToScreen(ent.Position)
		statusEffects:SetOverlayRenderPriority(true)
		statusEffects:SetFrame("NukeTarget", data.EpicFetusRenderFrame)
		statusEffects:Render(loc + Vector(0, -30), Vector(0,0), Vector(0,0));
		data.EpicFetusRenderFrame = data.EpicFetusRenderFrame + 1
		if data.EpicFetusRenderFrame >= 7 then data.EpicFetusRenderFrame = 0 end
	end

	if data.IsCheesed then
		local data = InutilLib.GetILIBData(ent)
		if not data.Init then                                             
			data.spr = Sprite()                                                 
			data.spr:Load("gfx/effects/items/cheese_string.anm2", true) 
			data.spr:SetFrame("Chain", 1)
			data.Init = true                                    
		end          
		InutilLib.DeadDrawRotatedTilingSprite(data.spr, Isaac.WorldToScreen(data.Player.Position), Isaac.WorldToScreen(fentam.Position), 16, nil, 8, true)
	end

	if data.isSlamSnooked then
		local endpoint = Isaac.WorldToScreen(ent.Position + data.SnookVelocity*1.2)
		if not data.Init then       
			data.spr = Sprite()                                                 
			data.spr:Load("gfx/effects/items/futurediary/blue_target.anm2", true) 
			data.spr:Play("Line", true)
				
			data.sprChild = Sprite()                                                 
			data.sprChild:Load("gfx/effects/items/futurediary/blue_target.anm2", true) 
			--if ent.Size <= 18 then
				data.sprChild:Play("Point", true)
			--[[else
				data.sprChild:Play("Target", true)
			end]]
			data.Init = true          
		end 
		InutilLib.DeadDrawRotatedTilingSprite(data.spr, Isaac.WorldToScreen(ent.Position), endpoint, 16, nil, 8, true)
		if data.SnookVelocity:Length() >= 1 then
			data.sprChild:Render(endpoint, Vector.Zero, Vector.Zero)
			--if ent.Size <= 18 then
				data.sprChild.Rotation = (data.SnookVelocity):GetAngleDegrees()
			--end
		end
	end
	if data.CursedGodheadSlamTier then
		local color = 0.2 * data.CursedGodheadSlamTier
		ent:SetColor(Color(1, 1, 1-color, 1, 0, 0, 0), 2, 5, true, true)
	end
	
end)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, function(_, proj)
	local data = yandereWaifu.GetEntityData(proj)
	if proj.SpawnerEntity then
		local spawnerData = yandereWaifu.GetEntityData(proj.SpawnerEntity)
		if proj.SpawnerEntity and proj.FrameCount == 1 then
			if spawnerData.IsLaughing or spawnerData.IsSilenced then
				proj:Remove()
			end
		end
	end
end)

yandereWaifu:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, ent)
	local data = yandereWaifu.GetEntityData(ent)
	if ent.SpawnerEntity then
		local spawnerData = yandereWaifu.GetEntityData(ent.SpawnerEntity)
		if ent.SpawnerEntity and ent.FrameCount == 1 then
			if spawnerData.IsMenopaused then
				ent:Remove()
				local puddle = InutilLib.game:Spawn( EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_RED, ent.Position, Vector(0,0), player, 0, 0):ToEffect()
				InutilLib.RevelSetCreepData(puddle)
				InutilLib.RevelUpdateCreepSize(puddle, math.random(5,7), true)
			end
			if spawnerData.IsSilenced then
				ent:Remove()
			end
		end
	end
	if data.IsSilenced then
		if not data.SavedSilencedTarget then data.SavedSilencedTarget = ent.Target end
		ent.Target = ent
	else
		ent.Target = data.SavedSilencedTarget
		data.SavedSilencedTarget = nil
	end
	if data.isSnooked and ent:CollidesWithGrid() then
		ent:TakeDamage(ent.Velocity:Length()/2, 0, EntityRef(ent), 1)
		InutilLib.SFX:Play( RebekahCurse.Sounds.SOUND_CURSED_POP, 1, 0, false, math.random(8,12)/10 );
		data.isSnooked = nil
	end
	if data.isSlamSnooked and ent:CollidesWithGrid() then
		ent:TakeDamage(ent.Velocity:Length()/2, 0, EntityRef(ent), 1)
		InutilLib.SFX:Play( RebekahCurse.Sounds.SOUND_CURSED_POP, 1, 0, false, math.random(8,12)/10 );
		data.isSnooked = nil
	end
	if data.isHeavySnooked then
		ent.Velocity = ent.Velocity * 1
		if ent:CollidesWithGrid() then
			ent:TakeDamage(ent.Velocity:Length()/2, 0, EntityRef(ent), 1)
			InutilLib.SFX:Play( RebekahCurse.Sounds.SOUND_CURSED_POP, 1, 0, false, math.random(8,12)/10 );
			ent.Velocity = ent.Velocity * 1.1
		end
	end
end)

yandereWaifu:AddCallback(ModCallbacks.MC_PRE_NPC_COLLISION, function(_, ent, coll, low)
	local data = yandereWaifu.GetEntityData(ent)
	if coll:IsEnemy() then
		if data.isSnooked or data.isSlamSnooked then
			ent:TakeDamage(ent.Velocity:Length()/2, 0, EntityRef(ent), 1)
			coll:TakeDamage(ent.Velocity:Length()/2, 0, EntityRef(ent), 1)
			coll.Velocity = (coll.Position - ent.Position):Resized(25)
			yandereWaifu.GetEntityData(coll).isSnooked = 15
			InutilLib.SFX:Play( RebekahCurse.Sounds.SOUND_CURSED_POP, 1, 0, false, math.random(8,12)/10 );
		end

		if data.isHeavySnooked then
			ent:TakeDamage(ent.Velocity:Length()/2, 0, EntityRef(ent), 1)
			coll:TakeDamage(ent.Velocity:Length()/2, 0, EntityRef(ent), 1)
			coll.Velocity = (coll.Position - ent.Position):Resized(35)
			yandereWaifu.GetEntityData(coll).isSnooked = 15
			InutilLib.SFX:Play( RebekahCurse.Sounds.SOUND_CURSED_POP, 1, 0, false, math.random(8,12)/10 );
		end
	end
end)


yandereWaifu:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, ent)
	local data = yandereWaifu.GetEntityData(ent)
	
	if data.MakingTaintedIncision then
		if not InutilLib.game:IsPaused() then
            data.MakingTaintedIncision = data.MakingTaintedIncision - 1
            if data.MakingTaintedIncision <= 0 then
				data.MakingTaintedIncision = nil
            end
        end
	end
end)

yandereWaifu:AddCallback(ModCallbacks.MC_PRE_PLAYER_COLLISION, function(_, player, coll, low)
	local data = yandereWaifu.GetEntityData(player)
	
	if data.MakingTaintedIncision then
		return false
	end
end)