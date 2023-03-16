
local ColorGreyscale = Color(1,1,1)
ColorGreyscale:SetColorize(1,1,1,1)

--ETERNAL HEART--
do

function yandereWaifu.RebekahEternalBarrage(player, direction)
	for j = 0, 180, 180/6 do --too lazy to calculate what 36--360-16 is lol
		local tickle = Isaac.Spawn(EntityType.ENTITY_TEAR, RebekahCurse.ENTITY_ETERNALFEATHER, 0, player.Position, Vector.FromAngle(j+(direction:GetAngleDegrees())-90)*(5), player):ToTear() --feather attack
		tickle.TearFlags = player.TearFlags | TearFlags.TEAR_SPECTRAL | TearFlags.TEAR_LIGHT_FROM_HEAVEN
		tickle.CollisionDamage = player.Damage * 3
		if player:HasCollectible(CollectibleType.COLLECTIBLE_CAR_BATTERY) then
			local tickle = Isaac.Spawn(EntityType.ENTITY_TEAR, RebekahCurse.ENTITY_ETERNALFEATHER, 0, player.Position, Vector.FromAngle(j+(direction:GetAngleDegrees())-90)*(7), player):ToTear() --feather attack
			tickle.TearFlags = player.TearFlags | TearFlags.TEAR_SPECTRAL | TearFlags.TEAR_LIGHT_FROM_HEAVEN
			tickle.CollisionDamage = player.Damage * 2
		end
	end
	local angle = direction:GetAngleDegrees()
	local beam = EntityLaser.ShootAngle(5, player.Position, angle, 10, Vector(0,10), player):ToLaser()
	if not yandereWaifu.GetEntityData(beam).IsLvlOneBeam then yandereWaifu.GetEntityData(beam).IsLvlOneBeam = true end
end

--eternal gun effect
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	if eff.SubType == 4 then
		local player = yandereWaifu.GetEntityData(eff).parent
		local sprite = eff:GetSprite();
		local playerdata = yandereWaifu.GetEntityData(player)
		local data = yandereWaifu.GetEntityData(eff)
		
		if player:HasCollectible(CollectibleType.COLLECTIBLE_MARKED) then
			direction = player:GetAimDirection()
		end
		
		if eff.FrameCount == 1 then
		--	sprite:Stop()
			eff.DepthOffset = 400
		end
		
		--if not data.StartCountFrame then data.StartCountFrame= 1 end
		
		if eff.FrameCount == (data.StartCountFrame) + 1 then
			sprite:Play("Startup", true)
			InutilLib.SetTimer( data.StartCountFrame*8,function()
				InutilLib.SFX:Play(RebekahCurseSounds.SOUND_ETERNALJINGLE, 1, 0, false, 1+(data.StartCountFrame/5))
			end)
		end
		
		eff.Velocity = player.Velocity;
		if data.Extra then --what am i doing
			eff.Position = player.Position + (Vector(0,20)):Rotated((data.direction):GetAngleDegrees()-90);
		else
			eff.Position = player.Position + (Vector(0,20)):Rotated((data.direction):GetAngleDegrees()-90);
		end
		
		--print(eff:GetSprite().Rotation)
		eff.RenderZOffset = 10
		sprite.Offset = Vector(0,-10)
		
		if sprite:IsFinished("Spawn") then
			sprite.Rotation = Round((data.direction):GetAngleDegrees(), 1)
				if (sprite.Rotation <= 180 and sprite.Rotation >= 135) or (sprite.Rotation <= 0 and sprite.Rotation >= -45) and not sprite:IsPlaying("ShootRight") then
					sprite:Play("ShootRight", true)
					--sprite.FlipY = true
				elseif(sprite.Rotation >= 0 and sprite.Rotation <= 45) or (sprite.Rotation >= -180 and sprite.Rotation <= -135) and not sprite:IsPlaying("ShootLeft") then
					sprite:Play("ShootLeft", true)
				elseif sprite.Rotation < 135 and sprite.Rotation > 45 and not sprite:IsPlaying("ShootDown") then
					sprite:Play("ShootDown", true)
				elseif sprite.Rotation > -180 and sprite.Rotation < 0 and not sprite:IsPlaying("ShootUp") then
					sprite:Play("ShootUp", true)
				end
				--playerdata.BarrageIntro = true 
		end

		if data.Shoot then
			if data.Heavy then
				sprite.Rotation = (data.direction):GetAngleDegrees()
				sprite.Scale = Vector(2,2)
				if (sprite.Rotation <= 180 and sprite.Rotation >= 135) or (sprite.Rotation <= 0 and sprite.Rotation >= -45) then
					sprite:Play("ShootRight", true)
					--sprite.FlipY = true
				elseif (sprite.Rotation >= 0 and sprite.Rotation <= 45) or (sprite.Rotation >= -180 and sprite.Rotation <= -135) then
					sprite:Play("ShootLeft", true)
				elseif sprite.Rotation < 135 and sprite.Rotation > 45 then
					sprite:Play("ShootDown", true)
				elseif sprite.Rotation > -180 and sprite.Rotation < 0 then
					sprite:Play("ShootUp", true)
				end
				InutilLib.SFX:Play(RebekahCurseSounds.SOUND_ETERNALJINGLE, 1, 0, false, 0.5)
			elseif data.DrFetus then
				sprite.Rotation = (data.direction):GetAngleDegrees()
				if (sprite.Rotation <= 180 and sprite.Rotation >= 135) or (sprite.Rotation <= 0 and sprite.Rotation >= -45) then
					sprite:Play("ShootRightDr", true)
					--sprite.FlipY = true
				elseif (sprite.Rotation >= 0 and sprite.Rotation <= 45) or (sprite.Rotation >= -180 and sprite.Rotation <= -135) then
					sprite:Play("ShootLeftDr", true)
				elseif sprite.Rotation < 135 and sprite.Rotation > 45 then
					sprite:Play("ShootDownDr", true)
				elseif sprite.Rotation > -180 and sprite.Rotation < 0 then
					sprite:Play("ShootUpDr", true)
				end
			elseif data.Tech then
				if sprite.Rotation <= 180 and sprite.Rotation >= 135 and not sprite:IsPlaying("ShootRightTechGo") then
					sprite:Play("ShootRightTechGo", true)
					--sprite.FlipY = true
				elseif (sprite.Rotation >= 0 and sprite.Rotation <= 45) or (sprite.Rotation >= -180 and sprite.Rotation <= -135) and not sprite:IsPlaying("ShootLeftTechGo") then
					sprite:Play("ShootLeftTechGo", true)
				elseif sprite.Rotation < 135 and sprite.Rotation > 45 and not sprite:IsPlaying("ShootDownTechGo") then
					sprite:Play("ShootDownTechGo", true)
				elseif sprite.Rotation > -180 and sprite.Rotation < 0 and not sprite:IsPlaying("ShootUpTechGo") then
					sprite:Play("ShootUpTechGo", true)
				end
			elseif data.Brimstone then
				if sprite.Rotation <= 180 and sprite.Rotation >= 135 and not sprite:IsPlaying("ShootRightBrimstoneGo") then
					sprite:Play("ShootRightBrimstoneGo", true)
					--sprite.FlipY = true
				elseif (sprite.Rotation >= 0 and sprite.Rotation <= 45) or (sprite.Rotation >= -180 and sprite.Rotation <= -135) and not sprite:IsPlaying("ShootLeftBrimstoneGo") then
					sprite:Play("ShootLeftBrimstoneGo", true)
				elseif sprite.Rotation < 135 and sprite.Rotation > 45 and not sprite:IsPlaying("ShootDownBrimstoneGo") then
					sprite:Play("ShootDownBrimstoneGo", true)
				elseif sprite.Rotation > -180 and sprite.Rotation < 0 and not sprite:IsPlaying("ShootUpBrimstoneGo") then
					sprite:Play("ShootUpBrimstoneGo", true)
				end
				InutilLib.SFX:Play(RebekahCurseSounds.SOUND_ETERNALJINGLE, 1, 0, false, 0.8)
			else
				sprite.Rotation = (data.direction):GetAngleDegrees()
				if (sprite.Rotation <= 180 and sprite.Rotation >= 135) or (sprite.Rotation <= 0 and sprite.Rotation >= -45) then
					sprite:Play("ShootRight", true)
					--sprite.FlipY = true
				elseif (sprite.Rotation >= 0 and sprite.Rotation <= 45) or (sprite.Rotation >= -180 and sprite.Rotation <= -135) then
					sprite:Play("ShootLeft", true)
				elseif sprite.Rotation < 135 and sprite.Rotation > 45 then
					sprite:Play("ShootDown", true)
				elseif sprite.Rotation > -180 and sprite.Rotation < 0 then
					sprite:Play("ShootUp", true)
				end
				if data.Light then
					InutilLib.SFX:Play(RebekahCurseSounds.SOUND_ETERNALJINGLE, 1, 0, false, 1)
				elseif data.Medium then
					InutilLib.SFX:Play(RebekahCurseSounds.SOUND_ETERNALJINGLE, 1, 0, false, 1)
				end
			end
			data.Shoot = false
		end
		
		--sounds
		--[[if InutilLib.IsPlayingMultiple(sprite, "ShootRight", "ShootLeft", "ShootDown", "ShootUp") then
			if sprite:GetFrame() == 0 then
				InutilLib.SFX:Play(RebekahCurseSounds.SOUND_REDSHOTMEDIUM, 1, 0, false, 1)
			end
		end]]
		if InutilLib.IsPlayingMultiple(sprite, "ShootRightDr", "ShootLeftDr", "ShootDownDr", "ShootUpDr") then
			if sprite:GetFrame() == 12 then
				InutilLib.SFX:Play(RebekahCurseSounds.SOUND_ETERNALJINGLE, 1, 0, false, 1)
			end
		end
		if InutilLib.IsPlayingMultiple(sprite, "ShootRightTechGo", "ShootLeftTechGo", "ShootDownTechGo", "ShootUpTechGo") then
			if sprite:GetFrame() == 0 then
				InutilLib.SFX:Play(RebekahCurseSounds.SOUND_ETERNALJINGLE, 1, 0, false, 1)
			end
		end
	end
end, RebekahCurse.ENTITY_REBEKAHENTITYWEAPON);

--light boom effect
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local player = Isaac.GetPlayer(0)
	local sprite = eff:GetSprite()
	local data = eff:GetData()
	
	if eff.FrameCount == 1 then
		sprite:Play("Spawn", true) --normal attack
	elseif sprite:GetFrame() == 2 and not data.NotEternal then
		for i, entenmies in pairs(Isaac.GetRoomEntities()) do --push enemies away
			if entenmies:IsEnemy() and entenmies:IsVulnerableEnemy() then
				if entenmies.Position:Distance(player.Position) < entenmies.Size + player.Size + 100 then
					entenmies.Velocity = (entenmies.Velocity + (entenmies.Position - player.Position)) * 0.5
					if not entenmies:GetData().IsBlessed then entenmies:GetData().IsBlessed = math.random(90,800) end
				end
			end
		end
	elseif sprite:IsFinished("Spawn") then
		eff:Remove()
	end
end, RebekahCurse.ENTITY_LIGHTBOOM)

yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_,  fam) --eternal star
	local spr = fam:GetSprite()
	local rng = math.random(1, 100)
	local player = fam.Player
	local data = yandereWaifu.GetEntityData(fam)
	
	local currentSide = nil
	local brideProtectorAngle = (fam.Player.Velocity):GetAngleDegrees()
	local willFlip = false
	local neededPosition = fam.Player.Position --+ Vector(-50,0):Rotated(brideProtectorAngle)
	
	if brideProtectorAngle >= 45 and brideProtectorAngle <= 135 and currentSide ~= "down" then
		currentSide = "down"
	elseif brideProtectorAngle <= -45 and brideProtectorAngle >= -135 and currentSide ~= "up" then
		currentSide = "up"
	elseif (brideProtectorAngle <= 0 and brideProtectorAngle >= -45) or (brideProtectorAngle >= 0 and brideProtectorAngle <= 45) and currentSide ~= "right" then
		currentSide = "right"
	elseif (brideProtectorAngle <= 180 and brideProtectorAngle >= 135) or (brideProtectorAngle >= -180 and brideProtectorAngle <= -135) and currentSide ~= "left" then
		currentSide = "left"
	end
	--delayed saved velocity
	data.delayedVel = data.delayedVel or nil
	InutilLib.SetTimer( 1, function()
		data.delayedVel = fam.Velocity * 0.8 --1.2
	end)
	if data.delayedVel then
		fam.Velocity = fam.Velocity*0.95 + ((neededPosition - fam.Position)*0.02) ; 
	end
	if not InutilLib.IsPlayingMultiple(spr, "Idle6", "Idle4", "Idle0", "Idle2", "Idle1", "Idle7", "Idle3", "Idle5") then --sets playing sprite
		InutilLib.AnimWalkFrame(fam, true, "Idle6", "Idle4", "Idle0", "Idle2", "Idle1", "Idle7", "Idle3", "Idle5")
	end
	-- print(brideProtectorAngle)
	fam:AddEntityFlags(EntityFlag.FLAG_SLIPPERY_PHYSICS)
	
	local grid = InutilLib.room:GetGridEntity(InutilLib.room:GetGridIndex(fam.Position)) --top grid destroy
	if grid ~= nil and grid.State ~= 2 then
		grid:Destroy()
		if grid:GetType() == GridEntityType.GRID_ROCK or grid:GetType() == GridEntityType.GRID_POOP then
			fam.Velocity = fam.Velocity * 0.8
		end
	end
	if fam.FrameCount % 3 == 0 and fam.Velocity:Length() > 2 then
		local dust = Isaac.Spawn( EntityType.ENTITY_EFFECT, EffectVariant.DUST_CLOUD, 0, fam.Position, Vector(0,0), fam ):ToEffect()
		dust:GetSprite().PlaybackSpeed = 0.3
		dust.Timeout = 3
		dust.LifeSpan = 3
	end
	
	fam.CollisionDamage = 3 + player.Damage/2
	if fam.SubType == 1 then
		fam.SpriteScale = Vector(0.8, 0.8)
		fam.Size = 14 
	end
	for i, collider in pairs(Isaac.GetRoomEntities()) do
		if collider.Type == 3 and collider.Variant == RebekahCurse.ENTITY_MORNINGSTAR and fam.Position:Distance(collider.Position) <= 25 and GetPtrHash(collider) ~= GetPtrHash(fam) then
			local vec = fam.Position-collider.Position
			fam.Velocity = fam.Velocity + vec:Resized(2)
		end
	end
end, RebekahCurse.ENTITY_MORNINGSTAR);

function yandereWaifu:EternalMorningstarCollision(fam, collider)
	if collider:IsEnemy() then
		local data = yandereWaifu.GetEntityData(fam)
		--collider:TakeDamage(fam.CollisionDamage, 0, EntityRef(tr), 4)
		fam.Velocity = fam.Velocity * 0.8
	end
	local vec = fam.Position-collider.Position
	fam.Velocity = fam.Velocity + vec:Resized(2)
end
yandereWaifu:AddCallback(ModCallbacks.MC_PRE_FAMILIAR_COLLISION, yandereWaifu.EternalMorningstarCollision, RebekahCurse.ENTITY_MORNINGSTAR)


yandereWaifu:AddCallback(ModCallbacks.MC_POST_FAMILIAR_RENDER, function(_,  fam) --eternal star
	--set chains
	
	--InutilLib.AttachChain(fam.Player, fam)
	--InutilLib.AttachChain3(fam.Player, fam, "gfx/effects/eternal/eternalmorningstar.anm2", "Chain", 48)
	
	local data = InutilLib.GetILIBData(fam)
	if not data.Init then                                             
		data.spr = Sprite()                                                 
		data.spr:Load("gfx/effects/eternal/eternalmorningstar.anm2", true) 
		data.spr:SetFrame("Chain", 1)
		data.Init = true                                              
	end          
	InutilLib.DeadDrawRotatedTilingSprite(data.spr, Isaac.WorldToScreen(fam.Player.Position), Isaac.WorldToScreen(fam.Position), 16, nil, 8, true)
	--i hate you api
	data.sprOverlay = fam:GetSprite()
	data.sprOverlay:Render(Isaac.WorldToScreen(fam.Position))
end, RebekahCurse.ENTITY_MORNINGSTAR);


function yandereWaifu:EternalPersonalityTearUpdate(tr)
	local data = yandereWaifu.GetEntityData(tr)
	if tr.Variant == 50 and data.IsAngelFetus then --just using 50 since the docs doesnt seem to have enums for fetus tears
		if tr.FrameCount == 1 and data.IsAngelFetus then
			tr:GetSprite():ReplaceSpritesheet(0, "gfx/effects/eternal/angel_fetus_tears.png")
			tr:GetSprite():LoadGraphics();
		end
		if tr.FrameCount <= 100 and data.IsAngelFetus then
			tr.Height = -12
			local e = InutilLib.GetClosestGenericEnemy(tr, 500)
			if e then
				--InutilLib.MoveDirectlyTowardsTarget(tr, e, 2+math.random(1,5)/10, 0.85)
				InutilLib.StrafeAroundTarget(tr, e, 2+math.random(1,5)/10, 0.85, 45)
				if tr.FrameCount % 45 == 0 then
					for i = 1, 5 do
						local tear = data.Player:FireTear(tr.Position, (e.Position - tr.Position):Resized(9), false, false, false):ToTear()
						tear.Position = tr.Position
						tear:ChangeVariant(TearVariant.FIRE) --ENTITY_ETERNALFEATHER)
						tear:AddTearFlags(TearFlags.TEAR_PIERCING)
						tear.CollisionDamage = tr.CollisionDamage
						yandereWaifu.GetEntityData(tear).EternalFlame = true
					end
				end
			end
			--tr.Velocity = tr.Velocity * (0.85+math.random(1,5)/10)
		end
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, yandereWaifu.EternalPersonalityTearUpdate)

function yandereWaifu:EternalPersonalityTearCollision(tr, cool)
	local data = yandereWaifu.GetEntityData(tr)
	if tr.Variant == 50 and data.IsAngelFetus then --just using 50 since the docs doesnt seem to have enums for fetus tears
		if tr.FrameCount <= 300 and tr.FrameCount % 7 == 0 and data.IsAngelFetus then
			cool:TakeDamage(tr.CollisionDamage, 0, EntityRef(tr), 4)
		end
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, yandereWaifu.EternalPersonalityTearCollision)

--eternal feather
function yandereWaifu:FeatherRender(tr, _)
	if tr.Variant == RebekahCurse.ENTITY_ETERNALFEATHER then
		local player, data, flags, scale = tr.Parent, yandereWaifu.GetEntityData(tr), tr.TearFlags, tr.Scale 
		local size = InutilLib.GetTearSizeTypeII(scale, flags)
		InutilLib.UpdateRegularTearAnimation(player, tr, data, flags, size);

		tr:GetSprite():Play("RegularTear4", false);
		tr:GetSprite():LoadGraphics();
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_POST_TEAR_RENDER, yandereWaifu.FeatherRender)

function yandereWaifu:FeatherUpdate(tr)
	local data = yandereWaifu.GetEntityData(tr)
	local player = tr.SpawnerEntity
	if tr.Variant == RebekahCurse.ENTITY_ETERNALFEATHER then
		data.EnemyHasDefined = nil --force it to nil
		data.closestEnt = 0
		--laggy
		if tr.FrameCount == 1 then
			data.trail = InutilLib.SpawnTrail(tr, Color(1,1,1,1))
		end
		--so this thing floats forever
		if tr.FrameCount >= 1 and tr.FrameCount <= 10 then
			data.firstHeight = tr.Height
			local angleNum = (tr.Velocity):GetAngleDegrees();
			tr.SpriteRotation = angleNum + 90;
			tr:GetData().Rotation = tr:GetSprite().Rotation;
		else
			if tr.FrameCount >= 10 and tr.FrameCount <= 30 then
				if not tr:GetData().NotSmart then
					if --[[tr.FrameCount % 10 == 0]] not data.HasFoundTarget then
						data.HasFoundTarget = true
						local e 
						if InutilLib.GetStrongestEnemy(tr,10000) then
							e = InutilLib.GetStrongestEnemy(tr,10000)
						end
						if e then
							tr.Velocity = tr.Velocity * 0.9 + ((e.Position-tr.Position):Resized(16))
						end
					end
				end
			else
				data.firstHeight = nil
			end
			local angleNum = (tr.Velocity):GetAngleDegrees();
			tr.SpriteRotation = angleNum + 90;
			tr:GetData().Rotation = tr:GetSprite().Rotation;
		end
		if data.firstHeight --[[and tr.FrameCount < 120]] then
			if tr.Height >= data.firstHeight --[[-6]] then
				tr.Height = data.firstHeight
			end
		end
		if player.Position:Distance(tr.Position) >= 500 then
			data.trail:Remove()
			tr:Remove()
		end
		if tr:IsDead() then
			local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.TEAR_POOF_A, 0, tr.Position, Vector(0,0), player) --poof e
			poof:GetSprite():ReplaceSpritesheet(0, "gfx/effects/featherpoof.png") 
		end
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, yandereWaifu.FeatherUpdate)

--featherbreak effect
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local sprite = eff:GetSprite()
	local data = eff:GetData()
	
	--sprite:LoadGraphics()
	if eff.FrameCount == 1 then
		sprite:Play("Break",true)
	elseif sprite:IsFinished("Break") then
		eff:Remove()
	end
end, RebekahCurse.ENTITY_FEATHERBREAK)

--tearbreak functionality effect
yandereWaifu:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, function(_, tr)
	if tr.Variant == RebekahCurse.ENTITY_ETERNALFEATHER then
		local part = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_FEATHERBREAK, 0, tr.Position, Vector(0,0), tr) --heart effect
		part:GetSprite().Rotation = tr:GetData().Rotation
	end
end, EntityType.ENTITY_TEAR)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, function(_,tear)
    local parent, spr, data = tear.Parent, tear:GetSprite(), yandereWaifu.GetEntityData(tear)
	--print(tear.Parent, "  ", parent.Variant, FamiliarVariant.INCUBUS)
    local player = parent:ToPlayer()
    if parent.Type == EntityType.ENTITY_FAMILIAR and parent.Variant == FamiliarVariant.INCUBUS then
      player = parent:ToFamiliar().Player
    end
	
	--tear:ChangeVariant(ENTITY_ETERNALFEATHER)
    --tear.TearFlags = tear.TearFlags | TearFlags.TEAR_SPECTRAL
	
    if yandereWaifu.IsNormalRebekah(player) and currentMode == REBECCA_MODE.EternalHearts and tear.TearFlags & TearFlags.TEAR_LUDOVICO ~= TearFlags.TEAR_LUDOVICO then
        tear:ChangeVariant(RebekahCurse.ENTITY_ETERNALFEATHER)
        tear.TearFlags = tear.TearFlags | TearFlags.TEAR_SPECTRAL
		tear:GetData().NotSmart = true
    end
end)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_BOMB_INIT, function(_, bb)
	local sprite = bb:GetSprite()
	if bb.SpawnerType == 1 then
		local player = bb.SpawnerEntity:ToPlayer()
		if yandereWaifu.GetEntityData(player).currentMode == REBECCA_MODE.EternalHearts then
			--local newbb = player:FireBomb( player.Position, bb.Velocity):ToBomb()
			--newbb.Flags = bb.Flags
			--newbb.ExplosionDamage = bb.ExplosionDamage
			--update sprite--
			if (bb.Variant > 4 or bb.Variant < 3) then
				if bb.Variant == 0 then
					bb.Variant = 3780
				elseif bb.Variant == 19 then
					yandereWaifu.GetEntityData(bb).HolyRocket = true
				end
			end
		end
	end

	if bb.Variant == 3780 then
		sprite:Load("gfx/items/pick ups/bombs/holy_grenade.anm2",true)
		sprite:Play("Pulse", true)
		--sprite:ReplaceSpritesheet(0, "gfx/items/pick ups/bombs/holy_grenade.png")
		--sprite:LoadGraphics()
	end

end)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE, function(_, bb)
	local sprite = bb:GetSprite()
	local data = yandereWaifu.GetEntityData(bb)
	if bb.Variant == 3780 or data.HolyRocket then
		local player = bb.SpawnerEntity:ToPlayer()
		if data.HolyRocket and bb.FrameCount == 1 then
			sprite:Load("gfx/items/pick ups/bombs/holy_rocket.anm2",true)
			sprite:Play("Pulse", true)
		end
		--[[if sprite:IsFinished("Pulse") or (data.HolyRocket and bb:CollidesWithGrid()) then
			local numLimit = data.StackedFeathers
			for i = 1, numLimit do
				for j = 0, 360-360/3, 360/3 do
					local randomRotate = math.random(-40,40)
					InutilLib.SetTimer( i*13, function()
						local tear = player:FireTear(bb.Position, Vector.FromAngle(j + randomRotate)*(13), false, false, false):ToTear()
						tear.Position = bb.Position
						tear:ChangeVariant(TearVariant.FIRE) --ENTITY_ETERNALFEATHER)
						tear:AddTearFlags(TearFlags.TEAR_PIERCING)
						tear.CollisionDamage = player.Damage * 0.3
						yandereWaifu.GetEntityData(tear).EternalFlame = true
						--tear:GetData().NotSmart = true
						--tear.BaseDamage = player.Damage * 2

						if i == data.StackedFeathers then
							InutilLib.SFX:Play(SoundEffect.SOUND_BIRD_FLAP, 1, 0, false, 1)
						end
					
					end);
				end
			end
		end]]
	end
end)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, function(_, bb)
	local data = yandereWaifu.GetEntityData(bb)
	if bb.Variant == 3780 or data.HolyRocket then
		local numLimit = data.StackedFeathers
		local player = bb.SpawnerEntity:ToPlayer()
		local extraBuffCount = 0
		if data.StackedFeatherBuff == 1 then --buff logic
			extraBuffCount = data.StackedFeathers
			numLimit = data.maxEternalFeather
		end
		if numLimit then
			for i = 1, numLimit do
				for j = 0, 360-360/3, 360/3 do
					local randomRotate = math.random(-40,40)
					InutilLib.SetTimer( i*7, function()
						local tear = player:FireTear(bb.Position, Vector.FromAngle(j + randomRotate)*(13), false, false, false):ToTear()
						tear.Position = bb.Position
						tear:ChangeVariant(TearVariant.FIRE) --ENTITY_ETERNALFEATHER)
						tear:AddTearFlags(TearFlags.TEAR_PIERCING)
						tear.CollisionDamage = player.Damage * 0.3
						yandereWaifu.GetEntityData(tear).EternalFlame = true
						--tear:GetData().NotSmart = true
						--tear.BaseDamage = player.Damage * 2

						if i == data.StackedFeathers then
							InutilLib.SFX:Play(SoundEffect.SOUND_BIRD_FLAP, 1, 0, false, 1)
						end
						if extraBuffCount > 0 then
							tear.CollisionDamage = tear.CollisionDamage * 1.5
							tear.Scale = 1.5
							tear.Color = ColorGreyscale
							extraBuffCount = extraBuffCount - 1
						end
					end);
				end
			end
		end
	end
end, EntityType.ENTITY_BOMB)



yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, function(_,  fam) 
    fam:AddToOrbit(7)
end, RebekahCurse.ENTITY_TINY_OPHANIM);

yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, function(_,  fam) 
    fam:AddToOrbit(5)
end, RebekahCurse.ENTITY_TINY_OPHANIM2);

yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_,  fam) 
    local spr = fam:GetSprite()
	local data = yandereWaifu.GetEntityData(fam)
	local player = fam.Player
	
	if not data.OrbitPlace then data.OrbitPlace = 7 end
	
	if not data.Init then
		data.Init = true
		spr:Play("Fade", true)
		fam:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	end
	
	--InutilLib.MoveOrbitAroundTargetType1(fam, player, 3, 0.9, data.OrbitPlace, 0)
	fam.SpriteScale = Vector(0.8, 0.8)
	fam.OrbitDistance = Vector(110,90)
	--if spr:IsPlaying("Idle") then
		fam.Velocity = (fam:GetOrbitPosition(player.Position+player.Velocity) - fam.Position)*0.2
	--else
	--	fam.Velocity = fam.Velocity * 0.3
	--end
	
	if spr:IsPlaying("Shoot") then
		if spr:GetFrame() == 1 then
			if player:HasWeaponType(WeaponType.WEAPON_BRIMSTONE) then
				local beam = player:FireBrimstone( Vector.FromAngle(data.FireDir), fam, 2):ToLaser();
				beam.Position = fam.Position
				beam.DisableFollowParent = true
				if data.IsBuffed then
					yandereWaifu.GetEntityData(beam).AngelBrimstone2 = true
					beam.CollisionDamage = player.Damage * 1.2;
					beam:AddTearFlags(TearFlags.TEAR_WIGGLE)
				else
					yandereWaifu.GetEntityData(beam).AngelBrimstone = true
					beam.CollisionDamage = player.Damage * 0.3
				end
			elseif player:HasWeaponType(WeaponType.WEAPON_LASER) then
				local numLimit = data.StackedFeathers
				for i = 1, numLimit do
					InutilLib.SetTimer( i, function()
						local techlaser = player:FireTechLaser(fam.Position, 0, Vector.FromAngle((player.Position - fam.Position):GetAngleDegrees()+ math.random(-2,2)), false, true)
						techlaser.OneHit = true;
						techlaser.Timeout = 1;
						techlaser.CollisionDamage = player.Damage * 0.8;
						techlaser:SetMaxDistance((fam.Position - player.Position):Length())
						techlaser:SetColor(Color(0,0,0,0.7,170,170,210),9999999,99,false,false);

					end)
				end
			elseif player:HasWeaponType(WeaponType.WEAPON_TECH_X) then
				local numLimit = data.StackedFeathers
				for i = 1, numLimit do
					InutilLib.SetTimer( i, function()
						local velSpeed = 20
						if data.IsBuffed then
							velSpeed = 10
						end
						local circle = player:FireTechXLaser(fam.Position, Vector.FromAngle(data.FireDir+math.random(-30,30))*(velSpeed), 40+math.random(-3,3)):ToLaser()
						circle.Position = fam.Position
						--local techlaser = player:FireTechLaser(fam.Position, 0, Vector.FromAngle((player.Position - fam.Position):GetAngleDegrees()+ math.random(-10,10)), false, true)
						--techlaser.OneHit = true;
						--techlaser.Timeout = 1;
						circle.CollisionDamage = player.Damage * 0.65;
						--techlaser:SetMaxDistance((fam.Position - player.Position):Length())
						if player:HasCollectible(CollectibleType.COLLECTIBLE_BRIMSTONE) then
							yandereWaifu.GetEntityData(circle).AngelBrimstone = true
						else
							circle:SetColor(Color(0,0,0,0.7,170,170,210),9999999,99,false,false);
						end
						if data.IsBuffed then
							circle:SetColor(Color(150,0,0,1,0,0,0),9999999,99,false,false);
							circle.Radius = circle.Radius * 0.8
						end
					end)
				end
			end
		end
	elseif spr:IsFinished("Shoot") then
		spr:Play("Fade", true)
	elseif spr:IsFinished("Fade") then
		spr:Play("Idle", true)
	end
end, RebekahCurse.ENTITY_TINY_OPHANIM);

yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_,  fam) 
    local spr = fam:GetSprite()
	local data = yandereWaifu.GetEntityData(fam)
	local player = fam.Player
	
	if not data.OrbitPlace then data.OrbitPlace = 5 end
	
	if not data.Init then
		data.Init = true
		spr:Play("Fade", true)
		fam:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	end
	
	--InutilLib.MoveOrbitAroundTargetType1(fam, player, 3, 0.9, data.OrbitPlace, 0)
	--fam.SpriteScale = Vector(0.8, 0.8)
	fam.OrbitDistance = Vector(90,70)
	--if spr:IsPlaying("Idle") then
		fam.Velocity = (fam:GetOrbitPosition(player.Position+player.Velocity) - fam.Position)*0.2
	--else
	--	fam.Velocity = fam.Velocity * 0.3
	--end
	
	if spr:IsPlaying("Shoot") then
		if spr:GetFrame() == 1 then
			if player:HasWeaponType(WeaponType.WEAPON_BRIMSTONE) then
				local beam = player:FireBrimstone( Vector.FromAngle(data.FireDir), fam, 2):ToLaser();
				beam.Position = fam.Position
				beam.DisableFollowParent = true
				yandereWaifu.GetEntityData(beam).AngelBrimstone = true
				beam.CollisionDamage = player.Damage * 0.3
			elseif player:HasWeaponType(WeaponType.WEAPON_LASER) then
				local numLimit = data.StackedFeathers
				for i = 1, numLimit do
					InutilLib.SetTimer( i, function()
						local techlaser = player:FireTechLaser(fam.Position, 0, Vector.FromAngle((player.Position - fam.Position):GetAngleDegrees()+ math.random(-2,2)), false, true)
						techlaser.OneHit = true;
						techlaser.Timeout = 1;
						techlaser.CollisionDamage = player.Damage * 0.4;
						techlaser:SetMaxDistance((fam.Position - player.Position):Length())
						techlaser:SetColor(Color(0,0,0,0.7,170,170,210),9999999,99,false,false);
					end)
				end
			elseif player:HasWeaponType(WeaponType.WEAPON_TECH_X) then
				local numLimit = data.StackedFeathers
				for i = 1, numLimit do
					InutilLib.SetTimer( i, function()
						local circle = player:FireTechXLaser(fam.Position, Vector.FromAngle(data.FireDir+math.random(-30,30))*(20), 40+math.random(-3,3))
						circle.Position = fam.Position
						--local techlaser = player:FireTechLaser(fam.Position, 0, Vector.FromAngle((player.Position - fam.Position):GetAngleDegrees()+ math.random(-10,10)), false, true)
						--techlaser.OneHit = true;
						--techlaser.Timeout = 1;
						circle.CollisionDamage = player.Damage * 0.65;
						--techlaser:SetMaxDistance((fam.Position - player.Position):Length())
						if player:HasCollectible(CollectibleType.COLLECTIBLE_BRIMSTONE) then
							yandereWaifu.GetEntityData(circle).AngelBrimstone = true
						else
							circle:SetColor(Color(0,0,0,0.7,170,170,210),9999999,99,false,false);
						end
					end)
				end
			end
		end
	elseif spr:IsFinished("Shoot") then
		spr:Play("Fade", true)
	elseif spr:IsFinished("Fade") then
		spr:Play("Spawn", true)
	elseif spr:IsFinished("Spawn") then
		spr:Play("Idle", true)
	end
end, RebekahCurse.ENTITY_TINY_OPHANIM2);

yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_,  fam) 
    local spr = fam:GetSprite()
	local data = yandereWaifu.GetEntityData(fam)
	local player = fam.Player
	
	if not data.OrbitPlace then data.OrbitPlace = 7 end
	
	--InutilLib.MoveOrbitAroundTargetType1(fam, player, 3, 0.9, data.OrbitPlace, 0)
	fam.Velocity = player:GetShootingInput() + fam.Velocity * 0.9 
	
	--if fam.FrameCount == 1 then
	fam.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
	--end
	
	if spr:IsPlaying("Shoot") then
		if spr:GetFrame() == 1 then
			--[[if player:HasWeaponType(WeaponType.WEAPON_BRIMSTONE) then
				local beam = player:FireBrimstone( Vector.FromAngle(data.FireDir), fam, 2):ToLaser();
				beam.Position = fam.Position
				beam.DisableFollowParent = true
				yandereWaifu.GetEntityData(beam).AngelBrimstone = true
				beam.CollisionDamage = player.Damage * 0.5
			elseif player:HasWeaponType(WeaponType.WEAPON_LASER) then
				local numLimit = data.StackedFeathers
				for i = 1, numLimit do
					InutilLib.SetTimer( i, function()
						local techlaser = player:FireTechLaser(fam.Position, 0, Vector.FromAngle((player.Position - fam.Position):GetAngleDegrees()+ math.random(-10,10)), false, true)
						techlaser.OneHit = true;
						techlaser.Timeout = 1;
						techlaser.CollisionDamage = player.Damage * 0.8;
						techlaser:SetMaxDistance((fam.Position - player.Position):Length())
						techlaser:SetColor(Color(0,0,0,0.7,170,170,210),9999999,99,false,false);
					end)
				end
			end]]
			local numLimit = data.StackedFeathers
			for i = 1, numLimit do
				for j = 0, 360-360/6, 360/6 do
					local randomRotate = math.random(-40,40)
					InutilLib.SetTimer( i*7, function()
						local tear = player:FireTear(fam.Position, Vector.FromAngle(j + randomRotate)*(4), false, false, false):ToTear()
						tear.Position = fam.Position
						tear:ChangeVariant(TearVariant.FIRE) --ENTITY_ETERNALFEATHER)
						tear:AddTearFlags(TearFlags.TEAR_PIERCING)
						tear.CollisionDamage = player.Damage * 0.2
						yandereWaifu.GetEntityData(tear).EternalFlame = true
						if player:HasCollectible(CollectibleType.COLLECTIBLE_GHOST_PEPPER) then
							tear.CollisionDamage = player.Damage * 0.8
							tear.Scale = 1.5
						end
						if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRDS_EYE) and math.random(1,14) + player.Luck >= 14 then
							local fire = Isaac.Spawn(EntityType.ENTITY_EFFECT, 51, 0, player.Position, Vector.FromAngle(data.AssignedHeadDir - math.random(-10,10))*(math.random(14,17)), player):ToEffect()
							fire.Scale = tear.Scale
							fire:GetSprite().Scale = Vector(tear.Scale,tear.Scale)
						end
						--tear:GetData().NotSmart = true
						--tear.BaseDamage = player.Damage * 2

						if i == data.StackedFeathers then
							InutilLib.SFX:Play(SoundEffect.SOUND_BIRD_FLAP, 1, 0, false, 1)
						end
					
					end);
				end
			end
		end
	elseif spr:IsFinished("Shoot") then
		spr:Play("Idle", true)
	end
	
	--pseudo damage
	if fam.FrameCount % 5 == 0 then
		for i, e in pairs(Isaac.GetRoomEntities()) do
			if e:IsActiveEnemy() and e:IsVulnerableEnemy() then
				if (fam.Position - e.Position):Length() < fam.Size + e.Size + 3 then
					e:TakeDamage(player.Damage/1.5, 0, EntityRef(fam), 4)
				end
			end
		end
	end
	
end, RebekahCurse.ENTITY_BIG_OPHANIM);


yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local player = yandereWaifu.GetEntityData(eff).Parent
	local controller = player.ControllerIndex;
	local sprite = eff:GetSprite();
	local room =  Game():GetRoom();
	local data = yandereWaifu.GetEntityData(eff)
    local roomClampSize = math.max( player.Size, 20 );
	--movement code
	eff.GridCollisionClass =  EntityGridCollisionClass.GRIDCOLL_NOPITS;
	
	eff.Velocity = player:GetShootingInput() * 20
	
	--function code
	--player.Velocity = (room:GetClampedPosition(eff.Position, roomClampSize) - player.Position)--*0.5;
	if eff.FrameCount == 1 then
		sprite:Play("Idle", true);
	elseif sprite:IsFinished("Idle") then
		sprite:Play("Blink",true);
	end
	
    if eff.FrameCount == 30 then
        local pillar = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_ETERNALEPICFIRE, 0, eff.Position, Vector(0,0), player)
		yandereWaifu.GetEntityData(pillar).Player = player
		yandereWaifu.GetEntityData(pillar).MultiTears = data.MultiTears
		yandereWaifu.GetEntityData(pillar).StackedFeathers = data.StackedFeathers * 3
    	eff:Remove();
    	
    	InutilLib.SFX:Play( SoundEffect.SOUND_WEIRD_WORM_SPIT, 1, 0, false, 1 );
    end
end, RebekahCurse.ENTITY_EPICFIRETARGET)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	--for i,player in ipairs(InutilLib.game:GetNumPlayers()-1) do
		local sprite = eff:GetSprite()
		local data = yandereWaifu.GetEntityData(eff)
		local player = data.Player
		local controller = player.ControllerIndex
		eff.GridCollisionClass =  EntityGridCollisionClass.GRIDCOLL_NOPITS 
		
		--eff.Velocity = player:GetShootingInput() + eff.Velocity * 0.7
		
		
		local room =  Game():GetRoom()
		--function code
		if eff.FrameCount == 1 then
			sprite:Play("StartFire", true)
		end
		
		if sprite:IsFinished("StartFire") then
			sprite:Play("FireLoop", true)
			if data.StackedFeathers >= 50 then
				local bomb = player:FireBomb( eff.Position , Vector.Zero):ToBomb()
				bomb.Position = eff.Position
				bomb:SetExplosionCountdown(0)
				bomb.IsFetus = true
			end
		end
		
		if data.StackedFeathers <= eff.FrameCount then
			sprite:Play("EndFire", false)
		end
		
		if sprite:IsFinished("EndFire") then
			eff:Remove()
		end 
		
		--close hitbox
		if eff.FrameCount % 5 == (0) then
			--if eff.FrameCount < yandereWaifu.GetEntityData(player).redcountdownFrames then
				for i, ent in pairs (Isaac.GetRoomEntities()) do
					if ent:IsEnemy() and ent:IsVulnerableEnemy() and not ent:IsDead() then
						if ent.Position:Distance((eff.Position)) <= 60 then
							ent:TakeDamage((player.Damage * data.MultiTears) * 4, 0, EntityRef(eff), 1)
						end
					end
					if ent.Type == 1 then
						if ent.Position:Distance((eff.Position)) <= 60 then
							ent:TakeDamage(1, 0, EntityRef(eff), 1)
						end
					end
				end
				--player.Velocity = Vector(0,0)
			--end
			if math.random(1,3) == 3 then
				local fire = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.RED_CANDLE_FLAME, 0, eff.Position, Vector.FromAngle(math.random(0,360)):Resized(9), player):ToEffect()
				fire.Timeout = 120
			end
			InutilLib.SFX:Play( SoundEffect.SOUND_SWORD_SPIN, 1, 0, false, 2);
		end
		--eff.Velocity = player.Velocity*2
	--end
end, RebekahCurse.ENTITY_ETERNALEPICFIRE)

function yandereWaifu:EternalFamiliarCheck(player, cacheF) --The thing the checks and updates the game, i guess?
	local data = yandereWaifu.GetEntityData(player)
	if cacheF == CacheFlag.CACHE_FAMILIARS then
		if not data.TinyOrphanims then data.TinyOrphanims = 0 end
		if not data.TinyOrphanims2 then data.TinyOrphanims2 = 0 end
		if not data.currentMode == REBECCA_MODE.EternalHearts then 
			data.TinyOrphanims = 0 
			data.TinyOrphanims2 = 0
		end
		player:CheckFamiliar(RebekahCurse.ENTITY_TINY_OPHANIM, data.TinyOrphanims, RNG())
		player:CheckFamiliar(RebekahCurse.ENTITY_TINY_OPHANIM2, data.TinyOrphanims2-1, RNG())
		if data.EternalLudo then
			player:CheckFamiliar(RebekahCurse.ENTITY_BIG_OPHANIM, 1, RNG())
		end
	end
	
end
yandereWaifu:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, yandereWaifu.EternalFamiliarCheck)
	
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	--for i,player in ipairs(InutilLib.game:GetNumPlayers()-1) do
		local sprite = eff:GetSprite()
		local data = yandereWaifu.GetEntityData(eff)
		local player = data.Player
		local controller = player.ControllerIndex
		eff.GridCollisionClass =  EntityGridCollisionClass.GRIDCOLL_NOPITS 
		
		local function HasGiantModifyingStuff() --checks if giant tear stuff exists
			if player:HasCollectible(CollectibleType.COLLECTIBLE_IPECAC) or player:HasCollectible(CollectibleType.COLLECTIBLE_POLYPHEMUS) then
				return true
			end
			return false
		end
		
		local room =  Game():GetRoom()
		--function code
		if eff.FrameCount == 1 then
			sprite:Play("StartSlash", true)
		end
		
		if sprite:IsFinished("StartSlash") then
			sprite:Play("SlashLoop", true)
		end
		
		if data.StackedFeathers <= eff.FrameCount then
			sprite:Play("EndSlash", false)
		end
		
		if sprite:IsFinished("EndSlash") then
			eff:Remove()
		end 
		
		eff.Position = player.Position
		eff.Velocity = player.Velocity
		
		--close hitbox
		if eff.FrameCount % 5 == (0) then
			--if eff.FrameCount < yandereWaifu.GetEntityData(player).redcountdownFrames then
				for i, ent in pairs (Isaac.GetRoomEntities()) do
					if (ent:IsEnemy() and ent:IsVulnerableEnemy()) or ent.Type == EntityType.ENTITY_FIREPLACE and not ent:IsDead() then
						if ent.Position:Distance((eff.Position)+ (Vector(50,0):Rotated(data.PermanentAngle))) <= 90 then
							ent:TakeDamage((player.Damage * data.MultiTears) * 2, 0, EntityRef(eff), 1)
						end
					end
				end
				--player.Velocity = Vector(0,0)
			--end
			InutilLib.SFX:Play( SoundEffect.SOUND_SWORD_SPIN, 1, 0, false, 2);
			local grid = room:GetGridEntity(room:GetGridIndex((eff.Position)+ (Vector(50,0):Rotated(data.PermanentAngle)))) --grids around that Rebecca stepped on
			if grid ~= nil then 
				--print( grid:GetType())
				if grid:GetType() == GridEntityType.GRID_TNT or grid:GetType() == GridEntityType.GRID_POOP then
					grid:Destroy()
				end
			end
		end
		--eff.Velocity = player.Velocity*2
		eff:GetSprite().Rotation = data.PermanentAngle
	--end
end, RebekahCurse.ENTITY_ETERNALSLASH)

end


function yandereWaifu.EternalHeartDash(player, vector)
	local playerdata = yandereWaifu.GetEntityData(player)
	local SubType = 0
	local trinketBonus = 0
	if player:HasTrinket(RebekahCurseTrinkets.TRINKET_ISAACSLOCKS) then
		trinketBonus = 5
	end
	
	player.Velocity = player.Velocity + vector:Resized( REBEKAH_BALANCE.ETERNAL_HEARTS_DASH_SPEED );
	
	local velAng = math.floor(player.Velocity:Rotated(-90):GetAngleDegrees())
	local subtype = RebekahCurseDustEffects.ENTITY_REBEKAH_GENERIC_DUST_BIG
	if (velAng >= 180 - 15 and velAng <= 180 + 15) or (velAng >= -180 - 15 and  velAng <= -180 + 15) or (velAng >= 0 - 15 and  velAng <= 0 + 15) then
		subtype = RebekahCurseDustEffects.ENTITY_REBEKAH_GENERIC_DUST_FRONT_BIG
	end
	if (velAng >= 45 - 15 and  velAng <= 45 + 15) or (velAng >= -45 - 15 and  velAng <= -45 + 15) then
		subtype = RebekahCurseDustEffects.ENTITY_REBEKAH_GENERIC_DUST_ANGLED_BIG
	end
	if (velAng >= 135 - 15 and  velAng <= 135 + 15) or (velAng >= -135 - 15 and  velAng <= -135 + 15) then
		subtype = RebekahCurseDustEffects.ENTITY_REBEKAH_GENERIC_DUST_ANGLED_BACK_BIG
	end
	
	local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_REBEKAH_DUST, subtype, player.Position, Vector.Zero, player)
	--print(velAng)
	if (velAng >= 90 - 15 and velAng <= 90 + 15 and velAng >= 0) or (((velAng >= -135 - 15 and  velAng <= -135 + 15)  or (velAng >= -45 - 15 and  velAng <= -45 + 15)) and velAng <= 0) then
		poof:GetSprite().FlipX = true
	end
	--yandereWaifu.SpawnDashPoofParticle( player.Position, Vector(0,0), player, RebekahPoofParticleType.Red );

	--yandereWaifu.SpawnDashPoofParticle( player.Position, Vector(0,0), player, RebekahPoofParticleType.Eternal );
	yandereWaifu.SpawnHeartParticles( 2, 5, player.Position, player.Velocity:Rotated(180):Resized( player.Velocity:Length() * (math.random() * 0.5 + 0.5) ), player, RebekahHeartParticleType.Eternal );
	--local lightboom = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_LIGHTBOOM, 0, player.Position, Vector(0,0), player);
	playerdata.specialCooldown = REBEKAH_BALANCE.ETERNAL_HEARTS_DASH_COOLDOWN - trinketBonus;
	playerdata.invincibleTime = REBEKAH_BALANCE.ETERNAL_HEARTS_DASH_INVINCIBILITY_FRAMES;
	playerdata.IsDashActive = true;
	for i = 0, math.random(2,3) do
		local tear = player:FireTear(player.Position, Vector.FromAngle(velAng - 90 - math.random(-45,45))*(math.random(4,6)), false, false, false):ToTear()
		tear.Position = player.Position
		tear:ChangeVariant(RebekahCurse.ENTITY_ETERNALFEATHER)
	end
	InutilLib.SFX:Play(SoundEffect.SOUND_BIRD_FLAP, 1, 0, false, 0.5);
end


function yandereWaifu.FlamethrowerLogic(player)
	local data = yandereWaifu.GetEntityData(player)
	
	if data.IsDashActive then --movement code
		if not data.countdownFrames then data.countdownFrames = 7 end
		data.countdownFrames = data.countdownFrames - 1
		local angle = player.Velocity:GetAngleDegrees()
		AddRebekahDashEffect(player)
		if data.countdownFrames < 0 then
			data.countdownFrames = 7
			data.IsDashActive = false
				
			--local lightboom = Isaac.Spawn(EntityType.ENTITY_EFFECT, ENTITY_LIGHTBOOM, 0, player.Position, Vector(0,0), player)
		end
	end
	
	local extraTears = 1 --this balances the fact you have mutant spider and inner eye but it slows down you feather stacks? wtf?
	
	if player:HasCollectible(CollectibleType.COLLECTIBLE_INNER_EYE) then
		extraTears = extraTears + 2
	end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_MUTANT_SPIDER) then
		extraTears = extraTears + 3
	end
	if player:HasCollectible(TaintedCollectibles.SPIDER_FREAK) then
		extraTears = extraTears + 5
	end

	
	if not data.extraTears or extraTears ~= data.extraTears then
		data.TinyOrphanims2 = extraTears
		player:AddCacheFlags(CacheFlag.CACHE_FAMILIARS);
		player:EvaluateItems()
		
		data.extraTears = extraTears
	end

	local extraPenalty = 0 --this increases if you have special items, for balance
	
	if player:HasCollectible(CollectibleType.COLLECTIBLE_DR_FETUS) then
		extraPenalty = extraPenalty + 1
	end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_KNIFE) then
		extraPenalty = extraPenalty + 3
	end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_IPECAC) then
		extraPenalty = extraPenalty + 2
	end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_HAEMOLACRIA)  then
		extraPenalty = extraPenalty + 2
	end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_TECH_X)  then
		extraPenalty = extraPenalty + 2
	end
	
	if player:HasCollectible(CollectibleType.COLLECTIBLE_C_SECTION) then
		extraPenalty = extraPenalty + 9
	end
	
	data.maxEternalFeather = math.floor(80/(player.MaxFireDelay/5)) --* extraTears
	
	if player:GetFireDirection() == -1 then --feather stack code
	
		if not data.StackedFeatherBuff then data.StackedFeatherBuff = 0 end --for birthright buff
		if not data.StackedFeathers then data.StackedFeathers = 0 end --stacked feathers is how much feathers you stacked while you aren't shooting.
		if not data.StackedFeathersTransition then data.StackedFeathersTransition = 0 end --this thing keeps track or counts on how long before a feather becomes added in the stack
		data.StackedFeathersTransition = data.StackedFeathersTransition + 1
		if data.StackedFeathersTransition >= (1+extraPenalty)*(player.MaxFireDelay) then
			if data.StackedFeathers < data.maxEternalFeather and data.StackedFeatherBuff == 0 then
				data.StackedFeathers = data.StackedFeathers + 2 * (1+(player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BIRTHRIGHT)*2)) --+ (2*extraTears)
				if player:HasWeaponType(WeaponType.WEAPON_BRIMSTONE) or player:HasWeaponType(WeaponType.WEAPON_LASER) or player:HasWeaponType(WeaponType.WEAPON_TECH_X) then
					data.TinyOrphanims = math.ceil((data.StackedFeathers/data.maxEternalFeather)*80/12) - 1
					player:AddCacheFlags(CacheFlag.CACHE_FAMILIARS);
					player:EvaluateItems()
				else
					if data.TinyOrphanims > 0 then
						data.TinyOrphanims = 0
						player:AddCacheFlags(CacheFlag.CACHE_FAMILIARS);
						player:EvaluateItems()
					end
				end
			elseif data.StackedFeathers >= data.maxEternalFeather and data.StackedFeatherBuff == 0 and player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) then
				data.StackedFeatherBuff = 1
				data.StackedFeathers = 0
			elseif data.StackedFeathers < data.maxEternalFeather and data.StackedFeatherBuff == 1 then
				data.StackedFeathers = data.StackedFeathers + 4 * (player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BIRTHRIGHT)*2) --+ (2*extraTears)
			end
			data.StackedFeathersTransition = 0 --reset
		end
	else
		--head dir configuration, since the double tap direction aim system is only applied when a double attack is enabled. Sorry!
		if player:GetFireDirection() == 3 then --down
			data.AssignedHeadDir = 90
		elseif player:GetFireDirection() == 1 then --up
			data.AssignedHeadDir = -90
		elseif player:GetFireDirection() == 0 then --left
			data.AssignedHeadDir = 180
		elseif player:GetFireDirection() == 2 then --right
			data.AssignedHeadDir = 0
		end
		local numLimit = data.StackedFeathers
		local extraBuffCount = 0
		if data.StackedFeatherBuff == 1 then --buff logic
			extraBuffCount = data.StackedFeathers
			numLimit = data.maxEternalFeather
		end
		if not player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) and data.StackedFeatherBuff == 1 then --incase reset
			numLimit = data.maxEternalFeather
			data.StackedFeatherBuff = 0
			extraBuffCount = 0
		end
		player.Velocity = player.Velocity * 0.8 --slow him down
		if data.StackedFeathers >= 1 then
			if player:HasCollectible(CollectibleType.COLLECTIBLE_TECHNOLOGY_2) then
				local dividingNum = data.TinyOrphanims
				for i = 1, numLimit do
					InutilLib.SetTimer( i*4, function()
						local techlaser = player:FireTechLaser(player.Position, 0, Vector.FromAngle(data.AssignedHeadDir - math.random(-10,10)), false, true)
						techlaser.OneHit = true;
						techlaser.Timeout = 1;
						techlaser.CollisionDamage = player.Damage * 0.4;
						--techlaser.Size = 7
						techlaser:SetColor(Color(0,0,0,0.7,170,170,210),9999999,99,false,false);
						InutilLib.UpdateLaserSize(techlaser, 7, false)
						if i == data.StackedFeathers then
							InutilLib.SFX:Play(SoundEffect.SOUND_BIRD_FLAP, 1, 0, false, 1)
							data.IsAttackActive = false
						end
						if extraBuffCount > 0 then
							techlaser.CollisionDamage = player.Damage * 1.5
							techlaser.SpriteScale = Vector(1.5,1.5)
							extraBuffCount = extraBuffCount - 1
						end
						--push back code
						player.Velocity = player.Velocity - Vector.FromAngle(data.AssignedHeadDir):Resized(0.3)
					end);
				end
			end
			if player:HasWeaponType(WeaponType.WEAPON_SPIRIT_SWORD) then
				local cut = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_ETERNALSLASH, 0, player.Position--[[+Vector.FromAngle(direction:GetAngleDegrees()):Resized(40)]], Vector(0,0), player);
				yandereWaifu.GetEntityData(cut).PermanentAngle = data.AssignedHeadDir
				yandereWaifu.GetEntityData(cut).MultiTears = extraTears
				yandereWaifu.GetEntityData(cut).Player = player
				yandereWaifu.GetEntityData(cut).StackedFeathers = data.StackedFeathers
				--yandereWaifu.GetEntityData(cut).TearDelay = modulusnum
				
			elseif player:HasWeaponType(WeaponType.WEAPON_LUDOVICO_TECHNIQUE) then
				for k, v in pairs(Isaac.GetRoomEntities()) do
					if v.Type == EntityType.ENTITY_FAMILIAR and v.Variant == RebekahCurse.ENTITY_BIG_OPHANIM then
						if GetPtrHash(v:ToFamiliar().Player:ToPlayer()) == GetPtrHash(player) then
							yandereWaifu.GetEntityData(v).FireDir = data.AssignedHeadDir
							yandereWaifu.GetEntityData(v).StackedFeathers = data.StackedFeathers*2
							v:GetSprite():Play("Shoot", true)
						end
					end
				end
			elseif player:HasWeaponType(WeaponType.WEAPON_ROCKETS) then --epic fetus
				local CanShootEpicFire = true
				for k, fire in pairs(Isaac.GetRoomEntities()) do
					if fire.Type == 1000 and fire.Variant == RebekahCurse.ENTITY_EPICFIRETARGET then
						if GetPtrHash(yandereWaifu.GetEntityData(fire).Parent) == GetPtrHash(player) then
							CanShootEpicFire = false
							break
						end
					end
				end
				if CanShootEpicFire then
					local target = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_EPICFIRETARGET, 0, player.Position, Vector(0,0), player)
					yandereWaifu.GetEntityData(target).Parent = player
					yandereWaifu.GetEntityData(target).MultiTears = extraTears
					yandereWaifu.GetEntityData(target).StackedFeathers = data.StackedFeathers
				end
			elseif player:HasWeaponType(WeaponType.WEAPON_BOMBS) then --dr. fetus
				local bomb = player:FireBomb( player.Position , Vector.FromAngle(data.AssignedHeadDir - math.random(-10,10))*(math.random(10,15))):ToBomb()
				bomb.Position = player.Position
				yandereWaifu.GetEntityData(bomb).StackedFeathers = data.StackedFeathers
				data.IsAttackActive = false 
				yandereWaifu.GetEntityData(bomb).StackedFeatherBuff = data.StackedFeatherBuff
				yandereWaifu.GetEntityData(bomb).maxEternalFeather = data.maxEternalFeather
				--[[if extraBuffCount > 0 then
					bomb.ExplosionDamage = bomb.ExplosionDamage * 1.5
					bomb.SpriteScale = Vector(1.5,1.5)
					extraBuffCount = extraBuffCount - 1
					bomb.RadiusMultiplier = 2
				end]]
			elseif player:HasWeaponType(WeaponType.WEAPON_BRIMSTONE) then --brimstone
				local dividingNum = data.TinyOrphanims
				local dividedNumForAngels = math.ceil((data.StackedFeathers/data.maxEternalFeather)*80/12) - 1
				for k, v in pairs(Isaac.GetRoomEntities()) do
					if v.Type == EntityType.ENTITY_FAMILIAR and v.Variant == RebekahCurse.ENTITY_TINY_OPHANIM then
						if GetPtrHash(v:ToFamiliar().Player:ToPlayer()) == GetPtrHash(player) then
							yandereWaifu.GetEntityData(v).FireDir = data.AssignedHeadDir
							v:GetSprite():Play("Shoot", true)
							if dividedNumForAngels > 0 and data.StackedFeatherBuff == 1 then
								yandereWaifu.GetEntityData(v).IsBuffed = true
								dividedNumForAngels = dividedNumForAngels - 1
							else
								yandereWaifu.GetEntityData(v).IsBuffed = false
							end
						end
					end
				end
				data.IsAttackActive = false
			elseif player:HasWeaponType(WeaponType.WEAPON_TECH_X) then --tech x
				local dividingNum = data.TinyOrphanims
				local dividedNumForAngels = math.ceil((data.StackedFeathers/data.maxEternalFeather)*80/12) - 1
				for k, v in pairs(Isaac.GetRoomEntities()) do
					if v.Type == EntityType.ENTITY_FAMILIAR and v.Variant == RebekahCurse.ENTITY_TINY_OPHANIM then
						if GetPtrHash(v:ToFamiliar().Player:ToPlayer()) == GetPtrHash(player) then
							yandereWaifu.GetEntityData(v).FireDir = data.AssignedHeadDir
							v:GetSprite():Play("Shoot", true)
							if data.StackedFeatherBuff == 1 then
								yandereWaifu.GetEntityData(v).StackedFeathers = data.maxEternalFeather/(2*dividingNum)
							else
								yandereWaifu.GetEntityData(v).StackedFeathers = data.StackedFeathers/(dividingNum*3) -- this is just too broken and much
							end
							if dividedNumForAngels > 0 and data.StackedFeatherBuff == 1 then
								yandereWaifu.GetEntityData(v).IsBuffed = true
								dividedNumForAngels = dividedNumForAngels - 1
							else
								yandereWaifu.GetEntityData(v).IsBuffed = false
							end
							--[[yandereWaifu.GetEntityData(v).maxEternalFeather = data.maxEternalFeather/(2*dividingNum)
							yandereWaifu.GetEntityData(v).StackedFeatherBuff = data.StackedFeatherBuff
							if data.StackedFeatherBuff == 1 then
								yandereWaifu.GetEntityData(v).extraBuffCount = extraBuffCount
							end]]
						end
					end
				end
			elseif player:HasWeaponType(WeaponType.WEAPON_LASER) then --technology
				local dividingNum = data.TinyOrphanims
				local dividedNumForAngels = math.ceil((data.StackedFeathers/data.maxEternalFeather)*80/12) - 1
				for k, v in pairs(Isaac.GetRoomEntities()) do
					if v.Type == EntityType.ENTITY_FAMILIAR and v.Variant == RebekahCurse.ENTITY_TINY_OPHANIM then
						if GetPtrHash(v:ToFamiliar().Player:ToPlayer()) == GetPtrHash(player) then
							yandereWaifu.GetEntityData(v).FireDir = data.AssignedHeadDir
							v:GetSprite():Play("Shoot", true)
							if data.StackedFeatherBuff == 1 then
								yandereWaifu.GetEntityData(v).StackedFeathers = data.maxEternalFeather/dividingNum
							else
								yandereWaifu.GetEntityData(v).StackedFeathers = data.StackedFeathers/dividingNum
							end
							if dividedNumForAngels > 0 and data.StackedFeatherBuff == 1 then
								yandereWaifu.GetEntityData(v).IsBuffed = true
								dividedNumForAngels = dividedNumForAngels - 1
							else
								yandereWaifu.GetEntityData(v).IsBuffed = false
							end
						end
					end
				end
				for i = 1, numLimit do
					InutilLib.SetTimer( i*4, function()
						local techlaser = player:FireTechLaser(player.Position, 0, Vector.FromAngle(data.AssignedHeadDir - math.random(-10,10)), false, true)
						techlaser.OneHit = true;
						techlaser.Timeout = 1;
						techlaser.CollisionDamage = player.Damage * 0.5;
						--techlaser.Size = 7
						techlaser:SetColor(Color(0,0,0,0.7,170,170,210),9999999,99,false,false);
						InutilLib.UpdateLaserSize(techlaser, 7, false)
						if extraBuffCount > 0 then
							techlaser.CollisionDamage = player.Damage * 1.5
							techlaser.SpriteScale = Vector(1.5,1.5)
							InutilLib.UpdateLaserSize(techlaser, 9, false)
							extraBuffCount = extraBuffCount - 1
							techlaser.OneHit = false;
							techlaser.Timeout = 30;
							techlaser:SetColor(Color(150,0,0,1,0,0,0),9999999,99,false,false);
						end
						if i == data.StackedFeathers then
							InutilLib.SFX:Play(SoundEffect.SOUND_BIRD_FLAP, 1, 0, false, 1)
							data.IsAttackActive = false
						end
						
						--push back code
						player.Velocity = player.Velocity - Vector.FromAngle(data.AssignedHeadDir):Resized(0.3)
					end);
				end
			else
				InutilLib.SFX:Play( SoundEffect.SOUND_FIRE_RUSH, 1, 0, false, 1 )
				
				for i = 1, numLimit do
					InutilLib.SetTimer( (i*extraPenalty), function()
						if player:HasWeaponType(WeaponType.WEAPON_KNIFE) then
							local knife = InutilLib.SpawnKnife(player, (data.AssignedHeadDir - math.random(-10,10)), false, 0, SchoolbagKnifeMode.FIRE_OUT_ONLY, 1, 120)
							if extraBuffCount > 0 then
								knife.CollisionDamage = knife.CollisionDamage * 3
								knife.Scale = 1.5
								knife.SpriteScale = Vector(1.5,1.5)
								knife.Color = ColorGreyscale
								extraBuffCount = extraBuffCount - 1
							end
						else
							local tear = player:FireTear(player.Position, Vector.FromAngle(data.AssignedHeadDir - math.random(-10,10))*(math.random(10,15)), false, false, false):ToTear()
							tear.Position = player.Position
							if player:HasCollectible(CollectibleType.COLLECTIBLE_IPECAC) or player:HasCollectible(CollectibleType.COLLECTIBLE_HAEMOLACRIA) then
								tear:ChangeVariant(RebekahCurse.ENTITY_HOLYBOMBTEAR)
								InutilLib.MakeTearLob(tear, 1.5, 7)
								yandereWaifu.GetEntityData(tear).StackedFeathers = data.StackedFeathers
							else
								tear:ChangeVariant(TearVariant.FIRE) --ENTITY_ETERNALFEATHER)
							end
							tear:AddTearFlags(TearFlags.TEAR_PIERCING)
							--tear.CollisionDamage = player.Damage * 0.8
							yandereWaifu.GetEntityData(tear).EternalFlame = true
							if player:HasCollectible(CollectibleType.COLLECTIBLE_GHOST_PEPPER) then
								tear.CollisionDamage = player.Damage * 0.8
								tear.Scale = 1.5
							end
							if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRDS_EYE) and math.random(1,14) + player.Luck >= 14 then
								local fire = Isaac.Spawn(EntityType.ENTITY_EFFECT, 51, 0, player.Position, Vector.FromAngle(data.AssignedHeadDir - math.random(-10,10))*(math.random(14,17)), player):ToEffect()
								fire.Scale = tear.Scale
								fire:GetSprite().Scale = Vector(tear.Scale,tear.Scale)
							end
							if player:HasCollectible(CollectibleType.COLLECTIBLE_C_SECTION) then
								tear:ChangeVariant(50)
								tear.TearFlags = tear.TearFlags | TearFlags.TEAR_PIERCING | TearFlags.TEAR_SPECTRAL
								yandereWaifu.GetEntityData(tear).IsAngelFetus = true
								yandereWaifu.GetEntityData(tear).Player = player
							end
							--tear:GetData().NotSmart = true
							--tear.BaseDamage = player.Damage * 2
							if extraBuffCount > 0 then
								tear.CollisionDamage = tear.CollisionDamage * 1.5
								tear.Scale = 1.5
								tear.Color = ColorGreyscale
								extraBuffCount = extraBuffCount - 1
							end
						end
						if i == data.StackedFeathers then
							InutilLib.SFX:Play(SoundEffect.SOUND_BIRD_FLAP, 1, 0, false, 1)
							data.IsAttackActive = false
						end
						
						--push back code
						player.Velocity = player.Velocity - Vector.FromAngle(data.AssignedHeadDir):Resized(0.3)
					end);
				end
			end
			for i = 1, numLimit/2 do
				InutilLib.SetTimer( (i+3*extraPenalty), function()
					for k, v in pairs(Isaac.GetRoomEntities()) do --extra eyes stuff
						if v.Type == EntityType.ENTITY_FAMILIAR and v.Variant == RebekahCurse.ENTITY_TINY_OPHANIM2 then
							if GetPtrHash(v:ToFamiliar().Player:ToPlayer()) == GetPtrHash(player) then
								yandereWaifu.GetEntityData(v).FireDir = data.AssignedHeadDir
								local tear = player:FireTear(v.Position, Vector.FromAngle(data.AssignedHeadDir - math.random(-10,10))*(math.random(10,15)), false, false, false):ToTear()
								tear.Position = v.Position
								if player:HasCollectible(CollectibleType.COLLECTIBLE_IPECAC) or player:HasCollectible(CollectibleType.COLLECTIBLE_HAEMOLACRIA) then
									tear:ChangeVariant(RebekahCurse.ENTITY_HOLYBOMBTEAR)
									InutilLib.MakeTearLob(tear, 1.5, 7)
									yandereWaifu.GetEntityData(tear).StackedFeathers = data.StackedFeathers
								else
									tear:ChangeVariant(TearVariant.FIRE) --ENTITY_ETERNALFEATHER)
								end
								tear:AddTearFlags(TearFlags.TEAR_PIERCING)
								--tear.CollisionDamage = player.Damage * 0.8
								yandereWaifu.GetEntityData(tear).EternalFlame = true
								if player:HasCollectible(CollectibleType.COLLECTIBLE_GHOST_PEPPER) then
									tear.CollisionDamage = player.Damage * 0.8
									tear.Scale = 1.5
								end
								if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRDS_EYE) and math.random(1,14) + player.Luck >= 14 then
									local fire = Isaac.Spawn(EntityType.ENTITY_EFFECT, 51, 0, player.Position, Vector.FromAngle(data.AssignedHeadDir - math.random(-10,10))*(math.random(14,17)), player):ToEffect()
									fire.Scale = tear.Scale
									fire:GetSprite().Scale = Vector(tear.Scale,tear.Scale)
								end
								if player:HasCollectible(CollectibleType.COLLECTIBLE_C_SECTION) then
									tear:ChangeVariant(50)
									tear.TearFlags = tear.TearFlags | TearFlags.TEAR_PIERCING | TearFlags.TEAR_SPECTRAL
									yandereWaifu.GetEntityData(tear).IsAngelFetus = true
									yandereWaifu.GetEntityData(tear).Player = player
								end
								--tear:GetData().NotSmart = true
								--tear.BaseDamage = player.Damage * 2
								if extraBuffCount > 0 then
									tear.CollisionDamage = tear.CollisionDamage * 1.5
									tear.Scale = 1.5
									tear.Color = ColorGreyscale
								end
							end
						end
					end
				end)
			end
		data.StackedFeathers = 0
		data.StackedFeatherBuff = 0
		end
	end
end

function yandereWaifu:FlamethrowerTearsUpdate(tr)
	local data = yandereWaifu.GetEntityData(tr)
	if tr.SpawnerEntity then
		local player = tr.SpawnerEntity:ToPlayer()
		if tr.Variant == TearVariant.FIRE and data.EternalFlame then
			if tr.Height >= -7 or tr:CollidesWithGrid() then
				tr.Height = 20
				tr.Velocity = Vector.Zero
			end
		end
		if tr.Variant == RebekahCurse.ENTITY_HOLYBOMBTEAR then
			if tr.FrameCount == 1 then
				tr:GetSprite():Play("RegularTear")
			end
			if tr.Height >= -7 or tr:CollidesWithGrid() then
			local numLimit = data.StackedFeathers
				for i = 1, numLimit do
					for j = 0, 360-360/6, 360/6 do
						local randomRotate = math.random(-40,40)
						InutilLib.SetTimer( i*7, function()
							local tear = player:FireTear(tr.Position, Vector.FromAngle(j + randomRotate)*(13), false, false, false):ToTear()
							tear.Position = tr.Position
							tear:ChangeVariant(TearVariant.FIRE) --ENTITY_ETERNALFEATHER)
							tear:AddTearFlags(TearFlags.TEAR_PIERCING)
							tear:ClearTearFlags(TearFlags.TEAR_BURSTSPLIT)
							tear.CollisionDamage = player.Damage * 0.3
							yandereWaifu.GetEntityData(tear).EternalFlame = true
							--tear:GetData().NotSmart = true
							--tear.BaseDamage = player.Damage * 2
							if player:HasCollectible(CollectibleType.COLLECTIBLE_C_SECTION) then
								tear:ChangeVariant(50)
								tear.TearFlags = tear.TearFlags | TearFlags.TEAR_PIERCING | TearFlags.TEAR_SPECTRAL
								yandereWaifu.GetEntityData(tear).IsAngelFetus = true
								yandereWaifu.GetEntityData(tear).Player = player
							end
							if i == data.StackedFeathers then
								InutilLib.SFX:Play(SoundEffect.SOUND_BIRD_FLAP, 1, 0, false, 1)
							end
						
						end);
					end
				end
			end
		end
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, yandereWaifu.FlamethrowerTearsUpdate)