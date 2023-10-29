yandereWaifu:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_,player, cacheF) --The thing the checks and updates the game, i guess?
	local data = yandereWaifu.GetEntityData(player)
	--love = power
	if player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_MORIAHDIARY) then
		if cacheF == CacheFlag.CACHE_SPEED then
			player.MoveSpeed = player.MoveSpeed + 0.2
		end
	end
end)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, pl)
	local sprite = pl:GetSprite()
	local data = yandereWaifu.GetEntityData(pl)
	
	if pl:HasCollectible(RebekahCurse.Items.COLLECTIBLE_MORIAHDIARY) then
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
			if v.Type == EntityType.ENTITY_PROJECTILE or v.Type == EntityType.ENTITY_BOMBDROP or v.Type == EntityType.ENTITY_EFFECT then
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
		
			data.spr.Color = Color(1, 1, 1, 0.5, 0, 0, 0)
			data.sprChild.Color = Color(1, 1, 1, 0.5, 0, 0, 0)
		--end
	end
end);
yandereWaifu:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, function(_,  proj) -- ping where the projectile spawns or drops
	if (proj.Height <= -34 and proj.FrameCount == 1 or proj.FrameCount % 30 == 0) and yandereWaifu.GetEntityData(proj).HasMoriahDiaryEffect then
		local target = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_PINGEFFECT, 4, proj.Position, Vector.Zero, player)
		target:GetSprite().Color = Color(1, 0.2, 0, 1, 0, 0, 0)
	end
end)

--bomb ping
yandereWaifu:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE, function(_,  bb)
	if yandereWaifu.GetEntityData(bb).HasMoriahDiaryEffect and not yandereWaifu.GetEntityData(bb).HasMoriahDiaryEffectInit then
		local target = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_PINGEFFECT, 10, bb.Position, bb.Velocity, bb):ToEffect()
		yandereWaifu.GetEntityData(target).Parent = bb
		if not bb.IsFetus then
			SFXManager():Play( RebekahCurse.Sounds.SOUND_IMDIECHIME , 1.4, 0, false, 0.5)
		end
		if bb.Variant == 17 then
			bb:GetSprite().Scale = Vector(1.5,1.5)
		end

		yandereWaifu.GetEntityData(bb).HasMoriahDiaryEffectInit = true
	end
end)

--enemy ping thing
yandereWaifu:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_,  npc)
	local spr = npc:GetSprite()
	local data = yandereWaifu.GetEntityData(npc)
	if yandereWaifu.GetEntityData(npc).HasMoriahDiaryEffect  then
		local function ping(pos1)
			local pos = pos1 or npc.Position
			local target = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_PINGEFFECT, 10, pos, npc.Velocity, npc):ToEffect()
			if not pos1 then
				yandereWaifu.GetEntityData(target).Parent = npc
			end
			SFXManager():Play( RebekahCurse.Sounds.SOUND_IMDIECHIME , 1.4, 0, false, 0.5)
		end
		if (npc.Type == EntityType.ENTITY_MOM or npc.Type == EntityType.ENTITY_SATAN or npc.Type == EntityType.ENTITY_MOMS_HAND) and spr:IsPlaying("Stomp") and spr:GetFrame() == 1 then
			ping()
		end
		if (npc.Type == EntityType.ENTITY_MOM and npc.SubType == 3) and (spr:IsPlaying("QuickStomp") or spr:IsPlaying("QuickStompEnd") or spr:IsPlaying("QuickStompBegin")) and spr:GetFrame() == 1 then
			ping()
		end
		if (npc.Type == EntityType.ENTITY_DADDYLONGLEGS) and (spr:IsPlaying("StompArm") or spr:IsPlaying("StompLeg") or spr:IsPlaying("Down")) and spr:GetFrame() == 1 then
			ping()
		end
		if (npc.Type == EntityType.ENTITY_MONSTRO or npc.Type == EntityType.ENTITY_MONSTRO2 or npc.Type == EntityType.ENTITY_PEEP) and (spr:IsPlaying("JumpDown")) and spr:GetFrame() == 15 then
			ping()
		end
		if (npc.Type == EntityType.ENTITY_MEGA_FATTY) and (spr:IsPlaying("Jumping")) and spr:GetFrame() == 14 then
			ping()
		end
		if (npc.Type == EntityType.ENTITY_ADVERSARY) and (spr:IsPlaying("FlyDown")) and spr:GetFrame() == 0 then
			ping()
		end
		if (npc.Type == EntityType.ENTITY_BLASTOCYST_BIG or npc.Type == EntityType.ENTITY_BLASTOCYST_MEDIUM or npc.Type == EntityType.ENTITY_BLASTOCYST_SMALL) and (spr:IsPlaying("JumpDown")) and spr:GetFrame() == 15 then
			ping()
		end
		if (npc.Type == EntityType.ENTITY_SISTERS_VIS) and (spr:IsPlaying("Jumping")) and spr:GetFrame() == 18 then
			ping()
		end
		if (npc.Type == EntityType.ENTITY_LIL_BLUB) and (spr:IsPlaying("Attack04")) and spr:GetFrame() == 28 then
			ping()
		end
		if (npc.Type == EntityType.ENTITY_PIN) and ((spr:IsPlaying("Attack1") and spr:GetFrame() == 28) or (spr:IsPlaying("Attack2") and spr:GetFrame() == 0)) then
			ping()
		end
		if (npc.Type == EntityType.ENTITY_SINGE) and (spr:IsPlaying("SuperBlastLand")) and spr:GetFrame() == 0 then
			ping()
		end
		if (npc.Type == EntityType.ENTITY_STAIN) and ((spr:IsPlaying("ComeUp") or spr:IsPlaying("ComeUp2")) and spr:GetFrame() == 0) or (spr:GetFrame() % 60 == 0 and spr:IsPlaying("DirtDisappear") or spr:IsPlaying("Dirt")) then
			ping()
		end
		if (npc.Type == EntityType.ENTITY_ULTRA_COIN) and npc.FrameCount == 1 then
			ping()
		end
		if (npc.Type == EntityType.ENTITY_ULTRA_GREED) then
			if spr:IsPlaying("Smash") and spr:GetFrame() == 10 then
				ping(npc.Position + Vector(0,50))
			elseif (spr:IsPlaying("Tantrum") and spr:GetFrame() == 5) or ((spr:IsPlaying("JumpDown")) and spr:GetFrame() == 0) then
				ping()
			end
		end
		
		local beamColor = Color(1,0,0,1)
		if (npc.Type == EntityType.ENTITY_PEEP and npc.Variant == 1) then
			if (spr:IsPlaying("AttackAlt01")) and spr:GetFrame() == 0 then
				yandereWaifu.AddGenericTracer(npc.Position + Vector(8,0), beamColor, 90, 7)
				yandereWaifu.AddGenericTracer(npc.Position + Vector(-8,0), beamColor, 90, 7)
				SFXManager():Play( RebekahCurse.Sounds.SOUND_IMDIECHIME , 1.4, 0, false, 1.7)
			elseif (spr:IsPlaying("AttackAlt02")) and spr:GetFrame() == 0 then
				yandereWaifu.AddGenericTracer(npc.Position, beamColor, 0, 7)
				yandereWaifu.AddGenericTracer(npc.Position, beamColor, 180, 7)
				SFXManager():Play( RebekahCurse.Sounds.SOUND_IMDIECHIME , 1.4, 0, false, 1.7)
			end
		end
		if (npc.Type == EntityType.ENTITY_MOM and npc.SubType == 3) then
			if (spr:IsPlaying("EyeLaser") or spr:IsPlaying("Eye")) and spr:GetFrame() == 0 then
				yandereWaifu.AddGenericTracer(npc.Position, beamColor, npc.SpriteRotation + 90, 7)
			elseif (spr:IsPlaying("QuickStompEnd")) and spr:GetFrame() == 2 then
				for i = 0, 360 - 360/4, 360/4 do
					yandereWaifu.AddGenericTracer(npc.Position, beamColor, i, 7)
				end
				SFXManager():Play( RebekahCurse.Sounds.SOUND_IMDIECHIME , 1.4, 0, false, 1.7)
			end
		end
		if (npc.Type == EntityType.ENTITY_ADVERSARY) and ( spr:GetFrame() == 0 or spr:GetFrame() == 2 or spr:GetFrame() == 4 or spr:GetFrame() == 5) then
			if (spr:IsPlaying("Attack2Right")) then
				yandereWaifu.AddGenericTracer(npc.Position, beamColor, 0 + math.random(-15,15), 7)
				SFXManager():Play( RebekahCurse.Sounds.SOUND_IMDIECHIME , 1.4, 0, false, 1.7)
			elseif (spr:IsPlaying("Attack2Left")) then
				yandereWaifu.AddGenericTracer(npc.Position, beamColor, 180 + math.random(-15,15), 7)
				SFXManager():Play( RebekahCurse.Sounds.SOUND_IMDIECHIME , 1.4, 0, false, 1.7)
			elseif (spr:IsPlaying("Attack2Up")) then
				yandereWaifu.AddGenericTracer(npc.Position, beamColor, 270 + math.random(-15,15), 7)
				SFXManager():Play( RebekahCurse.Sounds.SOUND_IMDIECHIME , 1.4, 0, false, 1.7)
			elseif (spr:IsPlaying("Attack2Down")) then
				yandereWaifu.AddGenericTracer(npc.Position, beamColor, 90 + math.random(-15,15), 7)
				SFXManager():Play( RebekahCurse.Sounds.SOUND_IMDIECHIME , 1.4, 0, false, 1.7)
			end
		end
		if (npc.Type == EntityType.ENTITY_MONSTRO2) and (spr:IsPlaying("Taunt")) and spr:GetFrame() == 0 then
			if npc.FlipX then
				yandereWaifu.AddGenericTracer(npc.Position, beamColor, 0, 7)
				SFXManager():Play( RebekahCurse.Sounds.SOUND_IMDIECHIME , 1.4, 0, false, 1.7)
			else
				yandereWaifu.AddGenericTracer(npc.Position, beamColor, 180, 7)
				SFXManager():Play( RebekahCurse.Sounds.SOUND_IMDIECHIME , 1.4, 0, false, 1.7)
			end
		end
		if (npc.Type == EntityType.ENTITY_SISTERS_VIS) and spr:GetFrame() == 0 then
			if (spr:IsPlaying("LaserStartSide")) then
				if npc.FlipX then
					yandereWaifu.AddGenericTracer(npc.Position, beamColor, 180, 7)
					SFXManager():Play( RebekahCurse.Sounds.SOUND_IMDIECHIME , 1.4, 0, false, 1.7)
				else
					yandereWaifu.AddGenericTracer(npc.Position, beamColor, 0, 7)
					SFXManager():Play( RebekahCurse.Sounds.SOUND_IMDIECHIME , 1.4, 0, false, 1.7)
				end
			elseif (spr:IsPlaying("LaserStartUp")) then
				yandereWaifu.AddGenericTracer(npc.Position, beamColor, 270, 7)
				SFXManager():Play( RebekahCurse.Sounds.SOUND_IMDIECHIME , 1.4, 0, false, 1.7)
			elseif (spr:IsPlaying("LaserStartDown")) then
				yandereWaifu.AddGenericTracer(npc.Position, beamColor, 90, 7)
				SFXManager():Play( RebekahCurse.Sounds.SOUND_IMDIECHIME , 1.4, 0, false, 1.7)
			end
		end
		if (npc.Type == EntityType.ENTITY_FALLEN) then
			if spr:IsPlaying("Attack2")  and spr:GetFrame() == 0 then
				for i = 0, 360 - 360/4, 360/4 do
					yandereWaifu.AddGenericTracer(npc.Position, beamColor, i, 7)
				end
				SFXManager():Play( RebekahCurse.Sounds.SOUND_IMDIECHIME , 1.4, 0, false, 1.7)
				if npc.Variant == 1 then
					for i = 0, 360 - 360/4, 360/4 do
						yandereWaifu.AddGenericTracer(npc.Position, Color(1,0,0.5,1), i+45, 7)
					end
					SFXManager():Play( RebekahCurse.Sounds.SOUND_IMDIECHIME , 1.4, 0, false, 1.7)
				end
				local target = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_PINGEFFECT, 10, npc.Position, npc.Velocity, npc):ToEffect()
				yandereWaifu.GetEntityData(target).Parent = npc
				SFXManager():Play( RebekahCurse.Sounds.SOUND_IMDIECHIME , 1.4, 0, false, 0.5)
				target:GetSprite().Scale = Vector(1.5,1.5)
			elseif (spr:IsPlaying("Attack2Alt")) and spr:GetFrame() == 25 then
				for i = 0, 360 - 360/4, 360/4 do
					yandereWaifu.AddGenericTracer(npc.Position, beamColor, i, 7)
				end
				SFXManager():Play( RebekahCurse.Sounds.SOUND_IMDIECHIME , 1.4, 0, false, 1.7)
			end
		end
		if (npc.Type == EntityType.ENTITY_GATE) and (spr:IsPlaying("Charging")) and spr:GetFrame() == 30  then
			local target = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_PINGEFFECT, 10, npc.Position, npc.Velocity, npc):ToEffect()
			yandereWaifu.GetEntityData(target).Parent = npc
			SFXManager():Play( RebekahCurse.Sounds.SOUND_IMDIECHIME , 1.4, 0, false, 0.5)
			target:GetSprite().Scale = Vector(1.5,1.5)
			for i = 0, 360 - 360/4, 360/4 do
				yandereWaifu.AddGenericTracer(npc.Position, beamColor, i, 7)
			end
		end
		if (npc.Type == EntityType.ENTITY_STAIN) and (spr:IsPlaying("Attack1")) and spr:GetFrame() == 0 then
			yandereWaifu.AddGenericTracer(npc.Position, beamColor, 0, 7)
			yandereWaifu.AddGenericTracer(npc.Position, beamColor, 180, 7)
		end
		if (npc.Type == EntityType.ENTITY_ULTRA_DOOR) and (spr:IsPlaying("Open")) and spr:GetFrame() == 0 then
			yandereWaifu.AddGenericTracer(npc.Position, beamColor, npc.SpriteRotation + 90, 7)
		end
		if (npc.Type == EntityType.ENTITY_REAP_CREEP) then
			if (spr:IsPlaying("Attack3BeamStart")) and spr:GetFrame() == 15 and not data.NotForward then --start charge beam
				yandereWaifu.AddGenericTracer(npc.Position, beamColor, 90, 7)
			elseif (spr:IsPlaying("Attack3Charge")) and spr:GetFrame() == 15 then --start beam start
				yandereWaifu.AddGenericTracer(npc.Position, beamColor, 45 + 15, 7)
				yandereWaifu.AddGenericTracer(npc.Position, beamColor, 135+ 15, 7)
				yandereWaifu.AddGenericTracer(npc.Position, beamColor, 45- 15, 7)
				yandereWaifu.AddGenericTracer(npc.Position, beamColor, 135- 15, 7)
				data.NotForward = true
			elseif data.NotForward and spr:IsPlaying("Idle3") then
				data.NotForward = false
			end
		end
		if (npc.Type == EntityType.ENTITY_VIS) then
			local angle = 0
			if (spr:IsPlaying("Attack01Horiz") or spr:IsPlaying("Attack02Horiz") or spr:IsPlaying("Attack03Horiz")) and spr:GetFrame() == 15 then --start charge beam
				angle = 0
				if npc.FlipX then
					angle = 180
				end
			elseif (spr:IsPlaying("Attack01Down") or spr:IsPlaying("Attack02Down") or spr:IsPlaying("Attack03Down")) and spr:GetFrame() == 15 then --start charge beam
				angle = 90
			elseif (spr:IsPlaying("Attack01Up") or spr:IsPlaying("Attack02Up") or spr:IsPlaying("Attack03Up")) and spr:GetFrame() == 15 then --start charge beam
				angle = 270
			end
			if not (spr:IsPlaying("WalkHori")) and spr:GetFrame() == 15 then
				yandereWaifu.AddGenericTracer(npc.Position, beamColor, angle, 7)
				if npc.Variant == 1 then
					yandereWaifu.AddGenericTracer(npc.Position, beamColor, angle+180, 7)
				elseif npc.Variant == 3 then
					for i = 90, 270, 90 do
						yandereWaifu.AddGenericTracer(npc.Position, beamColor, angle+i, 7)
					end
				end
			end
		end
	end
end)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_,  npc)
	local spr = npc:GetSprite()
	if yandereWaifu.GetEntityData(npc).HasMoriahDiaryEffect  then
		local function ping()
			local target = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_PINGEFFECT, 10, npc.Position, npc.Velocity, npc):ToEffect()
			yandereWaifu.GetEntityData(target).Parent = npc
			SFXManager():Play( RebekahCurse.Sounds.SOUND_IMDIECHIME , 1.4, 0, false, 0.5)
		end
		if (npc.Variant == EffectVariant.MOM_FOOT_STOMP) and spr:IsPlaying("Stomp") and spr:GetFrame() == 1 then
			ping()
		end
		if (npc.Variant == 55) and spr:GetFrame() == 0 then
			local target = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_PINGEFFECT, 4, npc.Position, Vector.Zero, npc)
			target:GetSprite().Color = Color(1, 0.5, 0, 1, 0, 0, 0)
			SFXManager():Play( RebekahCurse.Sounds.SOUND_IMDIECHIME , 1.4, 0, false, 1.3)
		end
	end
end)
