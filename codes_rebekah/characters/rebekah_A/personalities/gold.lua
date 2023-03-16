
function yandereWaifu.GoldHeartSlam(player, vector)
	local playerdata = yandereWaifu.GetEntityData(player)
	local trinketBonus = 0
	if player:HasTrinket(RebekahCurseTrinkets.TRINKET_ISAACSLOCKS) then
		trinketBonus = 5
	end
	local room = InutilLib.room
	for k, enemy in pairs( Isaac.GetRoomEntities() ) do
		if enemy:IsEnemy() --[[and not enemy:IsEffect() and not enemy:IsInvulnurable()]] then
			if enemy.Position:Distance( player.Position ) < enemy.Size + player.Size + REBEKAH_BALANCE.GOLD_HEARTS_DASH_KNOCKBACK_RANGE then
				InutilLib.DoKnockbackTypeI(player, enemy, 0.35)
			end
		end
	end
	--rock splash
	local chosenNumofBarrage =  math.random( 8, 15 );
	for i = 1, chosenNumofBarrage do
		player.Velocity = player.Velocity * 0.8; --slow him down
		--local tear = player:FireTear(player.Position, Vector.FromAngle(data.specialAttackVector:GetAngleDegrees() - math.random(-10,10))*(math.random(10,15)), false, false, false):ToTear()
		local tear = InutilLib.game:Spawn( EntityType.ENTITY_TEAR, TearVariant.ROCK, player.Position, Vector.FromAngle( math.random() * 360 ):Resized(REBEKAH_BALANCE.GOLD_HEARTS_DASH_ATTACK_SPEED), player, 0, 0):ToTear()
		tear.Scale = math.random(2,12)/10;
		tear.FallingSpeed = -9 + math.random() * 2 ;
		tear.FallingAcceleration = 0.5;
		tear.CollisionDamage = player.Damage * 1.3;
		--tear.BaseDamage = player.Damage * 2
	end
	
	--destroy grids
	for i = 1, 8 do --code that checks each eight directions
		--local checkingVector = (room:GetGridEntity(room:GetGridIndex(fam.Position + data.savedVelocity*4)))
		local gridStomped = room:GetGridEntity(room:GetGridIndex(player.Position + Vector(45,0):Rotated(45*(i-1)))) --grids around that Rebecca stepped on
		--if gridStomped:GetType() == GridEntityType.GRID_TNT or gridStomped:GetType() == GridEntityType.GRID_ROCK then
		--print( gridStomped:GetType())
		if gridStomped ~= nil then
			gridStomped:Destroy()
		end
		if i == 8 then 
			local gridStomped = room:GetGridEntity(room:GetGridIndex(player.Position)) --top grid
			if gridStomped ~= nil then
				gridStomped:Destroy()
			end
		end
	end
	
	InutilLib.game:MakeShockwave(player.Position, 0.065, 0.025, 10)

	Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 1, player.Position, Vector(0,0), player)
	local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_REBEKAH_DUST, 14, player.Position, Vector.Zero, player):ToEffect()
	yandereWaifu.GetEntityData(poof).Parent = player
	--yandereWaifu.SpawnPoofParticle( player.Position, Vector(0,0), player, RebekahPoofParticleType.Gold );
	yandereWaifu.SpawnHeartParticles( 3, 5, player.Position, yandereWaifu.RandomHeartParticleVelocity(), player, RebekahHeartParticleType.Gold );
	playerdata.specialCooldown = REBEKAH_BALANCE.GOLD_HEARTS_DASH_COOLDOWN - trinketBonus;
	playerdata.invincibleTime = REBEKAH_BALANCE.GOLD_HEARTS_DASH_INVINCIBILITY_FRAMES;
	InutilLib.SFX:Play( SoundEffect.SOUND_FORESTBOSS_STOMPS, 1, 0, false, 1 );
end

--gold gun effect
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	if eff.SubType == 5 then
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

function yandereWaifu.RebekahGoldBarrage(player, direction)
	local coins = player:GetNumCoins(); --check amount of coins for Ned
	local nedClones = 1;--was 2
	--[[if coins >= 25 and coins < 50 then nedClones = 3
	elseif coins >= 50 and coins < 75 then nedClones = 4
	elseif coins >= 75 then nedClones = 5
	else nedClones = 2
	end]]
	--[[local ned = Isaac.Spawn( EntityType.ENTITY_FAMILIAR, RebekahCurse.ENTITY_NED_NORMAL, 0, player.Position, Vector( 0, 0 ), player):ToFamiliar();
	ned.Player = player
	if player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_KNIFE) 
		local ned = Isaac.Spawn( EntityType.ENTITY_FAMILIAR, RebekahCurse.ENTITY_NED_NORMAL, 1, player.Position, Vector( 0, 0 ), player):ToFamiliar();
		ned.Player = player
	end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_BRIMSTONE) then
		local ned = Isaac.Spawn( EntityType.ENTITY_FAMILIAR, RebekahCurse.ENTITY_NED_NORMAL, 4, player.Position, Vector( 0, 0 ), player):ToFamiliar();
		ned.Player = player
	end]]
	local current1Neds = 0
	for n, ned in pairs( Isaac.FindByType(EntityType.ENTITY_FAMILIAR, RebekahCurse.ENTITY_NED_NORMAL, -1, false, false) ) do
		if GetPtrHash(ned:ToFamiliar().Player:ToPlayer()) == GetPtrHash(player) then
			if ned.SubType < 10 then
				current1Neds = current1Neds + 1
			end
		end
	end
	if current1Neds >= 8 then
		nedClones = 0
	end
	if current1Neds < 8 then
		for i = 1, nedClones do
			--ned weapon type randomizer
			local subtype = 0
			if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) then
				subtype = math.random(0,6)
			else
				--local rng = math.random(0,120)
				if player:HasWeaponType(WeaponType.WEAPON_FETUS) then --rng >= 20 and rng <= 110 and player:HasCollectible(CollectibleType.COLLECTIBLE_C_SECTION) then
					subtype = 6
				elseif player:HasWeaponType(WeaponType.WEAPON_SPIRIT_SWORD) then --rng >= 30 and rng <= 110 and player:HasCollectible(CollectibleType.COLLECTIBLE_SPIRIT_SWORD) then
					subtype = 5
				elseif player:HasWeaponType(WeaponType.WEAPON_BOMBS) or player:HasWeaponType(WeaponType.WEAPON_ROCKETS) then -- rng >= 40 and rng <= 120 and player:HasCollectible(CollectibleType.COLLECTIBLE_DR_FETUS) or  player:HasCollectible(CollectibleType.COLLECTIBLE_EPIC_FETUS) then
					subtype = 2
				elseif player:HasWeaponType(WeaponType.WEAPON_KNIFE) then --rng >= 45 and rng <= 120 and player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_KNIFE) then
					if TaintedTreasure and player:HasCollectible(TaintedCollectibles.THE_BOTTLE) then
						subtype = 20
					else
						subtype = 1
					end
				elseif player:HasWeaponType(WeaponType.WEAPON_LASER) or player:HasWeaponType(WeaponType.WEAPON_TECH_X) then--rng >= 40 and rng <= 120 and (player:HasCollectible(CollectibleType.COLLECTIBLE_TECHNOLOGY) or player:HasCollectible(CollectibleType.COLLECTIBLE_TECH_X)) then
					subtype = 3
				elseif player:HasWeaponType(WeaponType.WEAPON_BRIMSTONE) then --rng >= 10 and rng <= 120 and player:HasCollectible(CollectibleType.COLLECTIBLE_BRIMSTONE) then
					subtype = 4
				end
			end
			local ned = Isaac.Spawn( EntityType.ENTITY_FAMILIAR, RebekahCurse.ENTITY_NED_NORMAL, subtype, player.Position, direction*1.5, player):ToFamiliar();
			--if i == 5 then yandereWaifu.purchaseReserveStocks(player, 1) --[[player:AddHearts( -1 )]] end
		end
		if player:HasCollectible(CollectibleType.COLLECTIBLE_LUDOVICO_TECHNIQUE) then
			local ned = Isaac.Spawn( EntityType.ENTITY_FAMILIAR, RebekahCurse.ENTITY_NED_NORMAL, 7, player.Position, direction*1.5, player):ToFamiliar();
		end
	end
	--else
	for n, ned in pairs( Isaac.FindByType(EntityType.ENTITY_FAMILIAR, -1, -1, false, false) ) do
		if GetPtrHash(ned:ToFamiliar().Player:ToPlayer()) == GetPtrHash(player) then
			if ned.Variant == RebekahCurse.ENTITY_NED_NORMAL then
				yandereWaifu.GetEntityData(ned).Health = 3
				local crack = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACK_THE_SKY, 1, ned.Position, Vector.Zero, player) 
				crack.CollisionDamage = 0
			end
			if ned.Variant == RebekahCurse.ENTITY_SQUIRENED then
				yandereWaifu.GetEntityData(ned).Health = 5
					local crack = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACK_THE_SKY, 1, ned.Position, Vector.Zero, player) 
				crack.CollisionDamage = 0
			end
		end
	end
	--end
	--extra special neds
	if player.Luck + math.random(1,10) >= 8 and player:HasCollectible(CollectibleType.COLLECTIBLE_LOKIS_HORNS) then
		for i = 1, 4 do
			local ned = Isaac.Spawn( EntityType.ENTITY_FAMILIAR, RebekahCurse.ENTITY_NED_NORMAL, 100, player.Position, direction*1.5, player):ToFamiliar();
		end
	end
	if player.Luck + math.random(1,10) >= 5 and player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_EYE) then
		local ned = Isaac.Spawn( EntityType.ENTITY_FAMILIAR, RebekahCurse.ENTITY_NED_NORMAL, 110, player.Position, direction*1.5, player):ToFamiliar();
	end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_MONSTROS_LUNG) then
		for i = 1, math.random(3,5) do
			local ned = Isaac.Spawn( EntityType.ENTITY_FAMILIAR, RebekahCurse.ENTITY_NED_NORMAL, 120, player.Position, direction*1.5, player):ToFamiliar();
		end
	end
	yandereWaifu.purchaseReserveStocks(player, 1)
	for i, enemies in pairs( Isaac.GetRoomEntities() ) do
		if enemies:IsEnemy() then
			if math.random(1,10) == 10 then --gold freeze
				if enemies.Position:Distance(player.Position) < enemies.Size + player.Size + 50 then
					enemies:AddMidasFreeze( EntityRef(player), math.random( 13, 177 ) );
				end
			end
		end
	end
	yandereWaifu.SpawnPoofParticle( player.Position, Vector( 0, 0 ), player, RebekahPoofParticleType.Gold );
	yandereWaifu.SpawnHeartParticles( 3, 5, player.Position, yandereWaifu.RandomHeartParticleVelocity(), player, RebekahHeartParticleType.Gold );
end

--lvl one ned
function yandereWaifu:onFamiliarNedInit(fam)
	fam.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
	--fam.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ENEMIES
    local sprite = fam:GetSprite()
    sprite:Play("Init", true)
	
	if fam.SubType == 1 then --moms knife
		sprite:ReplaceSpritesheet(0, "gfx/effects/gold/knife/familiar_ned.png") 
		sprite:ReplaceSpritesheet(1, "gfx/effects/gold/knife/familiar_ned.png") 
	elseif fam.SubType == 2 then --dr fetus
		sprite:Load("gfx/effects/gold/bombs/ned_normal.anm2", true)
	elseif fam.SubType == 3 then --tech
		sprite:ReplaceSpritesheet(0, "gfx/effects/gold/laser/familiar_ned.png") 
		sprite:ReplaceSpritesheet(1, "gfx/effects/gold/laser/familiar_ned.png") 
	elseif fam.SubType == 4 then --brimstone
		sprite:Load("gfx/effects/gold/brimstone/ned_normal.anm2", true)
	elseif fam.SubType == 5 then --sword
		sprite:ReplaceSpritesheet(0, "gfx/effects/gold/sword/familiar_ned.png") 
		sprite:ReplaceSpritesheet(1, "gfx/effects/gold/sword/familiar_ned.png") 
	elseif fam.SubType == 6 then --c section
		sprite:ReplaceSpritesheet(0, "gfx/effects/gold/fetus/familiar_ned.png") 
		sprite:ReplaceSpritesheet(1, "gfx/effects/gold/fetus/familiar_ned.png")
	elseif fam.SubType == 7 then --ludovico
		sprite:Load("gfx/effects/gold/ludo/ned_normal.anm2", true)
		
	elseif fam.SubType == 100 then --loki horn
		sprite:ReplaceSpritesheet(0, "gfx/effects/gold/extra/familiar_ned_loki.png") 
		sprite:ReplaceSpritesheet(1, "gfx/effects/gold/extra/familiar_ned_loki.png") 
	elseif fam.SubType == 110 then --moms eye
		sprite:ReplaceSpritesheet(0, "gfx/effects/gold/extra/familiar_ned_moms_eye.png") 
		sprite:ReplaceSpritesheet(1, "gfx/effects/gold/extra/familiar_ned_moms_eye.png") 
	elseif fam.SubType == 120 then --monstros lung
		sprite:ReplaceSpritesheet(0, "gfx/effects/gold/extra/familiar_ned_monstros_lung.png") 
		sprite:ReplaceSpritesheet(1, "gfx/effects/gold/extra/familiar_ned_monstros_lung.png") 

	--tainted treasures
	elseif fam.SubType == 20 then --c section
		sprite:ReplaceSpritesheet(0, "gfx/effects/gold/bottle/familiar_ned.png") 
		sprite:ReplaceSpritesheet(1, "gfx/effects/gold/bottle/familiar_ned.png")
	end
	sprite:LoadGraphics()
end
yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, yandereWaifu.onFamiliarNedInit, RebekahCurse.ENTITY_NED_NORMAL);

yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local data = yandereWaifu.GetEntityData(eff)
	local room = InutilLib.game:GetRoom()
	if eff.FrameCount == 1 then
		local wall = InutilLib.ClosestHorizontalWall(eff)
		if wall == Direction.RIGHT then
			data.savedVelocity = Vector(-5,0) --needed for the velocity it goes + detection what grid is in front
		elseif wall == Direction.LEFT then
			data.savedVelocity = Vector(5,0)
		end
		eff:GetSprite():Play("ChargingFadeIn", true)
	end
	if data.savedVelocity then
		eff.Velocity = eff.Velocity * 0.75 + data.savedVelocity
		local checkingVector = (room:GetGridEntity(room:GetGridIndex(eff.Position + data.savedVelocity)))
		if checkingVector and (checkingVector:GetType() == GridEntityType.GRID_WALL or checkingVector:GetType() == GridEntityType.GRID_DOOR) and eff.FrameCount > 5 then
			eff:GetSprite():Play("ChargingFadeOut", true)
		end
	end
	if eff.FrameCount > 5 then
		if eff:GetSprite():IsFinished("ChargingFadeIn") then
			eff:GetSprite():Play("Charging", true)
		elseif eff:GetSprite():IsPlaying("Charging") then
			for k, enemy in pairs( Isaac.GetRoomEntities() ) do
				if enemy:IsVulnerableEnemy() then
					if enemy.Position:Distance( eff.Position ) < enemy.Size + eff.Size + 30 then
						enemy:TakeDamage(data.Damage, 0, EntityRef(eff), 4) --2.5 + data.IncreasedBuff - damageNerf + fam.Player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BFFS)
					end
				end
			end
			--local setAngle = (eff.Velocity):GetAngleDegrees()
		elseif eff:GetSprite():IsFinished("ChargingFadeOut") then
			eff:Remove()
			InutilLib.SFX:Play( RebekahCurseSounds.SOUND_STRIKE, 1, 0, false, 1 );
		end
	end
end, RebekahCurse.ENTITY_CHRISTIANNEDEXTRA );


yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local data = yandereWaifu.GetEntityData(eff)
	local room = InutilLib.game:GetRoom()
	local spr = eff:GetSprite()
	if eff.FrameCount == 1 then
		if eff.SubType == 0 then
			eff:GetSprite():Play("Float1", true)
		elseif eff.SubType == 1 then
			eff:GetSprite():Play("Float2", true)
		end
	end
	local e = InutilLib.GetClosestGenericEnemy(eff, 500)
	if e and not (spr:IsPlaying("Shoot1") or spr:IsPlaying("Shoot2")) then
		if eff.SubType == 0 then
			eff:GetSprite():Play("Shoot1", true)
		elseif eff.SubType == 1 then
			eff:GetSprite():Play("Shoot2", true)
		end
		local tear = yandereWaifu.FireBarrageTear(eff.Position, ((e.Position - eff.Position):Resized(16)), TearVariant.BLOOD, eff):ToTear()
		tear.CollisionDamage = 1.5
	end
	if eff.SubType == 0 then
		InutilLib.MoveOrbitAroundTargetType1(eff, data.Parent, 7, 0.9, 2, 0)	
	elseif eff.SubType == 1 then
		InutilLib.MoveOrbitAroundTargetType1(eff, data.Parent, 7, 0.9, 2, 180)	
	end
end, RebekahCurse.ENTITY_SOLOMONNEDBABY );

function yandereWaifu.nedCollision(_, fam, collider, low)
	local data = yandereWaifu.GetEntityData(fam)
	if collider.Type == EntityType.ENTITY_PROJECTILE and fam.FrameCount > 15 then -- stop enemy bullets
		collider:Die()
		if data.Health > 1 then
			data.Health = data.Health - 1
		else
			fam:Die()
			if math.random(1,3) == 3 then
				InutilLib.game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, fam.Position, fam.Velocity/5, Parent, HeartSubType.HEART_HALF_SOUL, 0)
			end
		end
	elseif collider:IsEnemy() and fam.FrameCount % 3 == 0 and fam.FrameCount <= 15 then
		collider:TakeDamage(fam.Player.Damage, 0, EntityRef(fam), 4)
	end
end

yandereWaifu:AddCallback(ModCallbacks.MC_PRE_FAMILIAR_COLLISION, yandereWaifu.nedCollision, RebekahCurse.ENTITY_NED_NORMAL)

yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_,  fam) --nerdy keeper function
    local spr = fam:GetSprite()
	local rng = math.random(1, 100)
	local data = yandereWaifu.GetEntityData(fam)
	local player = fam.Player
	
	if not data.Health then
		data.Health = 3
	end
	
	for i, e in pairs(InutilLib.roomProjectiles) do
		if (e.Position - fam.Position):LengthSquared() <= 25 ^ 2 then
			if not spr:IsPlaying("Move") then
				spr:Play("Move", true)
				fam.Velocity = fam.Velocity + (fam.Position - e.Position)/3
			end
		end
	end
	
	local target = InutilLib.GetClosestGenericEnemy(fam, 250, RebekahCurse.ENTITY_TINYFELLOW)
	
	--if ned is too far from player
	if not spr:IsPlaying("Shoot") or not spr:IsPlaying("Move") or not spr:IsPlaying("Idle") then
		if (player.Position - fam.Position):Length() > 50 and math.random(1,5) > 2 then
			if InutilLib.game:GetFrameCount() % 7 == 0 then
				spr:Play("Move", true)
				fam.Velocity = fam.Velocity + Vector.FromAngle(((player.Position - fam.Position)):GetAngleDegrees()+math.random(-10,10)):Resized(15)
			end
		elseif target and not (spr:IsPlaying("Shoot") or spr:IsPlaying("Move") or spr:IsPlaying("Idle")) then
			spr:Play("Shoot", true)
			data.target = target
		end
	end
	fam.Velocity = fam.Velocity - fam.Velocity*0.25

	if (spr:IsFinished("Shoot")) then
		spr:Play("Idle", true)
	end
	if spr:IsFinished("Shoot") or spr:IsFinished("Move") or spr:IsFinished("Idle") then
		if rng > 50 then
			spr:Play("Move", true)
			fam.Velocity = fam.Velocity + Vector( math.random(-15, 15), math.random(-15, 15) )
		end
		if rng < 51 then
			--[[for i, e in pairs(Isaac.GetRoomEntities()) do
				if e.Type ~= EntityType.ENTITY_PLAYER and e.Type ~= RebekahCurse.ENTITY_TINYFELLOW then
					if e:IsActiveEnemy() == true then
						if e:IsVulnerableEnemy() == true then
							if (fam.Position - e.Position):Length() < 250 then
								target = e
							end
						end
					end
				end
			end]]
			--shoot code
			if target then
				spr:Play("Shoot", true)
				data.target = target
			end
		end
	elseif spr:IsPlaying("Shoot") then
		if spr:GetFrame() == 2 then
			if fam.SubType == 1 then
				local kn = yandereWaifu.ThrowPseudoKnife(fam,  Vector.FromAngle((data.target.Position - fam.Position):GetAngleDegrees()):Resized(16), 4)
				--local kn =InutilLib.SpawnKnife(player, ((data.target.Position - fam.Position):GetAngleDegrees()), false, 0, SchoolbagKnifeMode.FIRE_ONCE, 1, 150, InutilLib:SpawnKnifeHelper(fam, player, true), true)
				kn.Size = 0.8
				kn.SpriteScale = Vector(0.8, 0.8)
				kn.CollisionDamage = 0.9
				InutilLib.AddHomingIfBabyBender(player, kn)
				--kn:SetColor(Color(0,0,0,1,0.8,0,1),9999999,99,false,false)
			elseif fam.SubType == 2 then
				local bomb = Isaac.Spawn(EntityType.ENTITY_BOMBDROP, BombVariant.BOMB_SMALL, 0, fam.Position, (data.target.Position - fam.Position):Resized( 9 ), fam.Player):ToBomb()
				bomb.ExplosionDamage = 5
				InutilLib.AddHomingIfBabyBender(player, bomb)
			elseif fam.SubType == 3 then
				--local techlaser = player:FireTechLaser(fam.Position, 0,(data.target.Position - fam.Position), false, true)
				local techlaser = EntityLaser.ShootAngle(2, fam.Position, (data.target.Position - fam.Position):GetAngleDegrees(), 5, Vector(0,-5), fam):ToLaser()
				techlaser.Position = fam.Position
				techlaser.OneHit = true;
				techlaser.Timeout = 1;
				techlaser.CollisionDamage = 2.5;
				techlaser:SetHomingType(1)
				techlaser:SetMaxDistance(130)
				InutilLib.AddHomingIfBabyBender(player, techlaser)
			elseif fam.SubType == 4 then
				--local beam = player:FireBrimstone((data.target.Position - fam.Position):Resized(1), fam, 1):ToLaser()
				local beam = EntityLaser.ShootAngle(1, fam.Position, (data.target.Position - fam.Position):GetAngleDegrees(), 15, Vector(0,-5), fam):ToLaser()
				--beam.Timeout = 120
				beam.CollisionDamage = player.Damage / 1.4
				--beam.DisableFollowParent = true
				beam:SetMaxDistance(200)
				--InutilLib.UpdateLaserSize(beam, 0.5)
				InutilLib.AddHomingIfBabyBender(player, beam)
			elseif fam.SubType == 5 then
				local tear = InutilLib.game:Spawn( EntityType.ENTITY_TEAR, RebekahCurse.ENTITY_WIND_SLASH, fam.Position, (data.target.Position - fam.Position):Resized(12), fam.Player, 0, 0):ToTear()
				tear.CollisionDamage = 1.5
				tear.Scale = 0.5
				tear:AddTearFlags(TearFlags.FLAG_PIERCING)
				InutilLib.AddHomingIfBabyBender(player, tear)
			elseif fam.SubType == 6 then
				data.targetsafe = data.target
				for i = 0, 4 do
					InutilLib.SetTimer( i*5, function()
						if data.targetsafe or not data.targetsafe:IsDead() then
							local tear = yandereWaifu.FireBarrageTear(fam.Position, (Vector(0, 0) + fam.Velocity/5 + Vector.FromAngle((data.targetsafe.Position - fam.Position):GetAngleDegrees()+math.random(-15,15)):Resized(16)), TearVariant.BLOOD, fam):ToTear()
							tear.CollisionDamage = 1.5
							InutilLib.AddHomingIfBabyBender(player, tear)
						end
					end)
				end
			elseif fam.SubType == 7 then
				local tear = yandereWaifu.FireBarrageTear(fam.Position, (Vector(0, 0) + fam.Velocity/5 + (data.target.Position - fam.Position):Resized(1)), TearVariant.BLOOD, fam):ToTear()
				tear.CollisionDamage = 1
				tear:ChangeVariant(0)
				yandereWaifu.GetEntityData(tear).IsPseudoLudo = true
				--tear:AddTearFlags(TearFlags.FLAG_PIERCING)
				InutilLib.AddHomingIfBabyBender(player, tear)
			elseif fam.SubType == 20 then
				local kn = yandereWaifu.ThrowPseudoKnife(fam,  Vector.FromAngle((data.target.Position - fam.Position):GetAngleDegrees()):Resized(16), 4)
				--local kn =InutilLib.SpawnKnife(player, ((data.target.Position - fam.Position):GetAngleDegrees()), false, 0, SchoolbagKnifeMode.FIRE_ONCE, 1, 150, InutilLib:SpawnKnifeHelper(fam, player, true), true)
				kn.Size = 0.8
				kn.SpriteScale = Vector(0.8, 0.8)
				kn.CollisionDamage = 0.9
				yandereWaifu.GetEntityData(kn).IsBottle = true
				InutilLib.AddHomingIfBabyBender(player, kn)
				kn:GetSprite():ReplaceSpritesheet(0,"gfx/effects/gold/tear_pseudobottle.png")
				kn:GetSprite():LoadGraphics()
				--kn:SetColor(Color(0,0,0,1,0.8,0,1),9999999,99,false,false)
			elseif fam.SubType == 100 then
				for i = 0, 270, 360/4 do
					local tear = yandereWaifu.FireBarrageTear(fam.Position, (Vector(0, 0) + fam.Velocity/5 + (data.target.Position - fam.Position):Resized(16)):Rotated(i), TearVariant.BLOOD, fam):ToTear()
					tear.CollisionDamage = 1.5
					InutilLib.AddHomingIfBabyBender(player, tear)
				end
			elseif fam.SubType == 110 then
				local tear = yandereWaifu.FireBarrageTear(fam.Position, (Vector(0, 0) + fam.Velocity/5 + (data.target.Position - fam.Position):Resized(16)), TearVariant.BLOOD, fam):ToTear()
				tear.CollisionDamage = 2.5
				InutilLib.AddHomingIfBabyBender(player, tear)
				local tear2 = yandereWaifu.FireBarrageTear(fam.Position, (Vector(0, 0) + fam.Velocity/5 - (data.target.Position - fam.Position):Resized(16)), TearVariant.BLOOD, fam):ToTear()
				tear2.CollisionDamage = 5.5
				tear2.Size = 1.7
				InutilLib.AddHomingIfBabyBender(player, tear2)
			elseif fam.SubType == 120 then
				for i = 1, math.random(5,7) do
					local tear = yandereWaifu.FireBarrageTear(fam.Position, (Vector(0, 0) + fam.Velocity/5 + Vector.FromAngle((data.target.Position - fam.Position):GetAngleDegrees()+math.random(-30,30)):Resized(16)), TearVariant.BLOOD, fam):ToTear()
					tear.CollisionDamage = 1
					tear.Size = 0.2
					InutilLib.AddHomingIfBabyBender(player, tear)
				end
			else
				local tear = yandereWaifu.FireBarrageTear(fam.Position, (Vector(0, 0) + fam.Velocity/5 + (data.target.Position - fam.Position):Resized(16)), TearVariant.BLOOD, fam):ToTear()
				tear.CollisionDamage = 3.5
				InutilLib.AddHomingIfBabyBender(player, tear)
			end
			InutilLib.SFX:Play(SoundEffect.SOUND_WORM_SPIT, 1, 0, false, 1)
			data.target = nil
		end
	end
end, RebekahCurse.ENTITY_NED_NORMAL);


yandereWaifu:AddCallback(ModCallbacks.MC_POST_FAMILIAR_RENDER, function(_,  fam) --render stuff
	local data = yandereWaifu.GetEntityData(fam)
	if data.Health then
		local Sprite = Sprite()
		Sprite:Load("gfx/effects/gold/ui/ui_hearts.anm2", true)
		
		for i = 1, 3 do
			local state = "Full"
			pos = Isaac.WorldToScreen(fam.Position) + Vector(-12+ i*6, 5) --heart position
			
			if data.Health < i then
				state = "Empty"
			end
			
			Sprite:Play(state, true)
			Sprite:Render(pos, Vector.Zero, Vector.Zero)
		end
	end
end, RebekahCurse.ENTITY_NED_NORMAL);


--lvl two ned
function yandereWaifu.ned2Collision(_, fam, collider, low)
	local data = yandereWaifu.GetEntityData(fam)
	if collider.Type == EntityType.ENTITY_PROJECTILE then -- stop enemy bullets
		collider:Die()
		if data.Health > 1 then
			data.Health = data.Health - 1
		else
			fam:Die()
			if math.random(1,3) == 3 then
				InutilLib.game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, fam.Position, fam.Velocity/5, Parent, HeartSubType.HEART_HALF_SOUL, 0)
			end
		end
	end
end

yandereWaifu:AddCallback(ModCallbacks.MC_PRE_FAMILIAR_COLLISION, yandereWaifu.ned2Collision, RebekahCurse.ENTITY_SQUIRENED)

function yandereWaifu:onFamiliarNed2Init(fam)
    fam.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
    local sprite = fam:GetSprite()
    sprite:Play("Init", true)
	
	if fam.SubType == 1 then --moms knife
		--sprite:ReplaceSpritesheet(0, "gfx/effects/gold/knife/familiar_ned_the_squire.png") 
		--sprite:ReplaceSpritesheet(1, "gfx/effects/gold/knife/familiar_ned_the_squire.png") 
		sprite:Load("gfx/effects/gold/knife/squire_ned.anm2", true)
	elseif fam.SubType == 2 then --dr fetus
		sprite:ReplaceSpritesheet(0, "gfx/effects/gold/bombs/familiar_ned_the_squire.png") 
		sprite:ReplaceSpritesheet(1, "gfx/effects/gold/bombs/familiar_ned_the_squire.png") 
	elseif fam.SubType == 3 then --tech
		sprite:ReplaceSpritesheet(0, "gfx/effects/gold/laser/familiar_ned_the_squire.png") 
		sprite:ReplaceSpritesheet(1, "gfx/effects/gold/laser/familiar_ned_the_squire.png") 
	elseif fam.SubType == 4 then --brimstone
		--sprite:ReplaceSpritesheet(0, "gfx/effects/gold/brimstone/familiar_ned_the_squire.png") 
		--sprite:ReplaceSpritesheet(1, "gfx/effects/gold/brimstone/familiar_ned_the_squire.png") 
		sprite:Load("gfx/effects/gold/brimstone/squire_ned.anm2", true)
	elseif fam.SubType == 5 then --sword
		sprite:Load("gfx/effects/gold/sword/squire_ned.anm2", true)
	elseif fam.SubType == 6 then --c section
		sprite:Load("gfx/effects/gold/fetus/squire_ned.anm2", true)
	elseif fam.SubType == 7 then --ludovico
		sprite:ReplaceSpritesheet(0, "gfx/effects/gold/ludo/familiar_ned_the_squire.png") 
		sprite:ReplaceSpritesheet(1, "gfx/effects/gold/ludo/familiar_ned_the_squire.png") 
	elseif fam.SubType == 20 then --the bottle
		sprite:Load("gfx/effects/gold/bottle/squire_ned.anm2", true)
	end
	sprite:LoadGraphics()
	sprite:Play("Idle", true)
end
yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, yandereWaifu.onFamiliarNed2Init, RebekahCurse.ENTITY_SQUIRENED);

--psuedo knife
function yandereWaifu:PsuedoKnifeRender(tr, _)
	if tr.Variant == RebekahCurse.ENTITY_PSEUDO_KNIFE then
		tr:GetSprite():Play("RegularTear", false);
		--tr:GetSprite():LoadGraphics();
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_POST_TEAR_RENDER, yandereWaifu.PsuedoKnifeRender)

function yandereWaifu.ThrowPseudoKnife(player, velocity, timeset)
	local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, RebekahCurse.ENTITY_PSEUDO_KNIFE, 0, player.Position, Vector.Zero, player):ToTear() --feather attack
	local data = yandereWaifu.GetEntityData(tear)
	tear.TearFlags = TearFlags.TEAR_PIERCING | TearFlags.TEAR_SPECTRAL
	tear.GridCollisionClass = GridCollisionClass.COLLISION_NONE
	data.FlightDuration = timeset
	data.AssignedVelocity = velocity
	return tear
end

function yandereWaifu:PsuedoKnifeUpdate(tr)
	local data = yandereWaifu.GetEntityData(tr)
	if tr.Variant == RebekahCurse.ENTITY_PSEUDO_KNIFE then
		--knife states
		--0 is not yet moving
		--1 is moving forward
		--2 is moving back
		
		--render code
		local angleNum = (tr.Velocity):GetAngleDegrees();
		if data.State ~= 2 then
			tr:GetSprite().Rotation = angleNum + 90;
		else
			tr:GetSprite().Rotation = angleNum - 90;
		end
		
		--tr:GetData().Rotation = tr:GetSprite().Rotation;
		--print(data.State)
		--make it float forever
		if tr.FrameCount == 1 then
			data.State = 0 
			data.firstHeight = tr.Height
			data.OriginPoint = tr.Position -- the original point the knife will go back into
		end
		tr.Height = data.firstHeight

		if data.State == 0 and data.AssignedVelocity then --start throw
			data.State = 1
			tr.Velocity = data.AssignedVelocity
		elseif data.State == 1 and (data.FlightDuration + 3)*30 >= tr.FrameCount then --go back
			data.State = 2
		elseif data.State == 2 then
			tr.Velocity = tr.Velocity - (tr.Position - data.OriginPoint):Resized(5)
			if (tr.Position - data.OriginPoint):Length() <= 10 then
				tr:Remove()
			end
		end
		--pseudo damage apparently, because piercing only damages enemy once
		if tr.FrameCount % 5 == 0 then
			for i, e in pairs(Isaac.GetRoomEntities()) do
				if e:IsActiveEnemy() and e:IsVulnerableEnemy() then
					if (tr.Position - e.Position):Length() < tr.Size + e.Size + 3 then
						e:TakeDamage(tr.CollisionDamage/1.5, 0, EntityRef(tr), 4)
						if data.IsBottle then
							e:AddEntityFlags(EntityFlag.FLAG_BLEED_OUT)
						end
					end
				end
			end
		end
		--on death
		if tr.Height >= -7 or tr:CollidesWithGrid() then
			yandereWaifu.SpawnPoofParticle( tr.Position, Vector(0,0), tr, RebekahPoofParticleType.Gold )
			tr:Remove()
		end
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, yandereWaifu.PsuedoKnifeUpdate)

--pseudo rocket
function yandereWaifu:PseudoRocketUpdate(tr, _)
	if tr.Variant == RebekahCurse.ENTITY_PSEUDO_ROCKET then
		if tr.FrameCount == 1 then
			tr:GetSprite():Play("RegularTear", false);
		end
		local angleNum = (tr.Velocity):GetAngleDegrees();
		tr:GetSprite().Rotation = angleNum + 90;
		tr:GetData().Rotation = tr:GetSprite().Rotation;
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, yandereWaifu.PseudoRocketUpdate)

--wind slash
function yandereWaifu:WindSlashRender(tr, _)
	if tr.Variant == RebekahCurse.ENTITY_WIND_SLASH and tr.FrameCount == 1 then
		tr:GetSprite():Play("RegularTear", false);
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_POST_TEAR_RENDER, yandereWaifu.WindSlashRender)
function yandereWaifu:WindSlashUpdate(tr, _)
	if tr.Variant == RebekahCurse.ENTITY_WIND_SLASH then
		local angleNum = (tr.Velocity):GetAngleDegrees();
		for k, enemy in pairs( Isaac.GetRoomEntities() ) do
			if enemy:IsVulnerableEnemy() and tr.FrameCount % 5 == 0 then
				if enemy.Position:Distance( tr.Position ) < enemy.Size + tr.Size * 10 then
					local targetAngle = (enemy.Position - tr.Position):GetAngleDegrees()
					if targetAngle >= (angleNum - 90) and targetAngle <= (angleNum + 90) then
						enemy:TakeDamage(tr.CollisionDamage, 0, EntityRef(tr), 4)
					end
				end
			end
		end
		tr:GetSprite().Rotation = angleNum + 90;
		tr:GetData().Rotation = tr:GetSprite().Rotation;
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, yandereWaifu.WindSlashUpdate)

function yandereWaifu:GoldPersonalityTearInit(tr)
	local data = yandereWaifu.GetEntityData(tr)
	if tr.Variant == RebekahCurse.ENTITY_REDKNIFE then
		local angleNum = (tr.Velocity):GetAngleDegrees();
		tr:GetSprite().Rotation = angleNum + 90;
		tr:GetData().Rotation = tr:GetSprite().Rotation;
		tr.Velocity = tr.Velocity * 0.9
	elseif tr.Variant == 50 and data.IsJacobFetus2 then --just using 50 since the docs doesnt seem to have enums for fetus tears
		if tr.FrameCount == 1 and data.IsJacobFetus2 then
			tr:GetSprite():ReplaceSpritesheet(0, "gfx/fetus_tears_jacob.png")
			tr:GetSprite():LoadGraphics();
		end
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_POST_TEAR_INIT, yandereWaifu.GoldPersonalityTearInit)

function yandereWaifu:GoldPersonalityTearUpdate(tr, cool)
	local data = yandereWaifu.GetEntityData(tr)
	if tr.Variant == 50 and (data.IsJacobFetus2 or data.IsGiantFetus or data.IsGiantFetus2) then --just using 50 since the docs doesnt seem to have enums for fetus tears
		local endFrame = 240
		if data.IsJacobFetus2 then endFrame = 120 end
		local player, data, flags, scale = tr.Parent, yandereWaifu.GetEntityData(tr), tr.TearFlags, tr.Scale 
		if tr.FrameCount <= endFrame and tr.FrameCount % 5 == 0 then
			cool:TakeDamage(tr.CollisionDamage, 0, EntityRef(tr), 4)
		end
		if tr.FrameCount <= endFrame then
			tr.Height = -12
			local e = InutilLib.GetClosestGenericEnemy(tr, 500)
			if e then
				InutilLib.MoveDirectlyTowardsTarget(tr, e, 2+math.random(1,5)/10, 0.85)
			end
			tr.Velocity = tr.Velocity * (0.85+math.random(1,5)/10)
		end
		InutilLib.UpdateRegularTearAnimation(player, tr, data, flags, size);
	elseif data.IsPseudoLudo then
		local e = InutilLib.GetClosestGenericEnemy(tr, 700)

		if e then
			InutilLib.MoveDirectlyTowardsTarget(tr, e, 2+math.random(1,5)/10, 0.85)
			tr.Height = -12
		end
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, yandereWaifu.GoldPersonalityTearUpdate)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local data = yandereWaifu.GetEntityData(eff)
	--print(data.BySquire)
	if eff.Variant == EffectVariant.BRIMSTONE_BALL and data.BySquire then
		for k, enemy in pairs( Isaac.GetRoomEntities() ) do
			if enemy:IsVulnerableEnemy() and tr.FrameCount % 5 == 0 then
				if enemy.Position:Distance( eff.Position ) < enemy.Size + eff.Size + 5 then
					--local targetAngle = (enemy.Position - eff.Position):GetAngleDegrees()
					--if targetAngle >= (angleNum - 90) and targetAngle <= (angleNum + 90) then
						enemy:TakeDamage(data.Damage or 3, 0, EntityRef(eff), 4)
					--end
				end
			end
		end
		if eff.FrameCount > 12 then
			eff:Die()
		end
	end

end, EffectVariant.BRIMSTONE_BALL);


yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_,  fam) --squire keeper function
    local spr = fam:GetSprite()
	local rng = math.random(1, 100)
	local player = fam.Player
	local data = yandereWaifu.GetEntityData(fam)
	
	if not data.Health then
		data.Health = 5
	end
	
	--hurt stuff	
	--for i, e in pairs(Isaac.GetRoomEntities()) do
	--	if e.Type ~= EntityType.ENTITY_PLAYER then
	--		if e.Type == EntityType.ENTITY_PROJECTILE then
				--if (e.Position - fam.Position):Length() < 10 then
				--	e:Die()
				--	fam:Die()
				--	if math.random(1,3) == 3 then
				--		if rng < 11 then
				--			InutilLib.game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, fam.Position, fam.Velocity/5, Parent, HeartSubType.HEART_HALF_SOUL, 0)
				--		end
				--	end
				--end
				--if (e.Position - fam.Position):Length() < 75 then
					if InutilLib.game:GetFrameCount() % 30 == 0 then
						local Mrng = math.random(1,3)
						spr:Play("Move", true)
						if Mrng == 1 then
						--	fam.Velocity = fam.Velocity + (fam.Position - e.Position)/3
						elseif Mrng == 2 then
							fam.Velocity = fam.Velocity + Vector( math.random(-15, 15), math.random(-15, 15) )
						end
					end
				--end
	---		end
	--	end
	--end
	
	if (player.Position - fam.Position):Length() > 120 then
		if InutilLib.game:GetFrameCount() % 7 == 0 then
			fam.Velocity = fam.Velocity + (player.Position - fam.Position)*0.125*0.6
		end
	end
	
	fam.Velocity = fam.Velocity - fam.Velocity*0.25
    if spr:IsFinished("Init") == true then
		spr:Play("Idle", true)
	end
	--[[if spr:IsPlaying("Repel") then
		if spr:IsEventTriggered("Repel") then
			for k, enemy in pairs( Isaac.GetRoomEntities() ) do
				if enemy.Variant == EntityType.ENTITY_PROJECTILE then
					if enemy.Position:Distance( fam.Position ) < enemy.Size + fam.Size + 200 then
						enemy:ToProjectile();
						enemy.Velocity = enemy.Velocity * 0.6 + (enemy.Position - fam.Position):Resized((enemy.Position - fam.Position):Length())
					end
				end
			end
			local chosenNumofBarrage =  math.random( 3, 6 );
			for i = 1, chosenNumofBarrage do
				local tear = InutilLib.game:Spawn( EntityType.ENTITY_TEAR, 20, fam.Position, Vector.FromAngle( math.random() * 360 ):Resized(BALANCE.GOLD_HEARTS_DASH_ATTACK_SPEED), fam.Player, 0, 0):ToTear()
				tear.Scale = math.random() * 0.7 + 0.7;
				tear.FallingSpeed = -9 + math.random() * 2 ;
				tear.FallingAcceleration = 0.5;
				tear.CollisionDamage = fam.Player.Damage;
			end
			yandereWaifu.SpawnPoofParticle( fam.Position, Vector(0,0), fam, RebekahPoofParticleType.Gold );
			SpawnHeartParticles( 3, 5, fam.Position, RandomHeartParticleVelocity(), fam, RebekahHeartParticleType.Gold );
		end]]
	if spr:IsFinished("Repel") or spr:IsFinished("Attack_Front") or spr:IsFinished("Attack_Back") or spr:IsFinished("Attack_Side") then
		spr:Play("Idle", false)
	end
	if spr:IsPlaying("Idle") == true then
		for k, enemy in pairs( Isaac.GetRoomEntities() ) do
			if enemy:IsVulnerableEnemy() --[[and not enemy:IsEffect() and not enemy:IsInvulnurable()]] then
				if enemy.Position:Distance( fam.Position ) < enemy.Size + fam.Size + 300 then
					data.target = enemy
				end
			end
		end
		if InutilLib.game:GetFrameCount() % 30 == 0 then
			if data.target then -- every one second
				--doesnt make you stay too close
				if (fam.Position - data.target.Position):Length() > 50 then
					fam.Velocity = fam.Velocity * 0.9 + ((data.target.Position - fam.Position):Resized(8)) + Vector( math.random(-15, 15), math.random(-15, 15) );
				end
				if (fam.Position - data.target.Position):Length() < 230 then
					local angle = (data.target.Position - fam.Position):GetAngleDegrees();
					local slashAngle
					if angle >= 45 and angle <= 135 then --front
						spr:Play("Attack_Front")
						slashAngle = 90
					elseif angle <= -45 and angle >= -135 then --back
						spr:Play("Attack_Back")
						slashAngle = 270
					elseif (angle >= 135 and angle <= 180) or (angle <= -135 and angle >= -180) then
						spr:Play("Attack_Side")
						spr.FlipX = true
						slashAngle = 180
					elseif (angle >= 0 and angle <= 45) or (angle <= 0 and angle >= -45) then
						spr:Play("Attack_Side")
						spr.FlipX = false
						slashAngle = 0
					end
					if fam.SubType == 0 then
						local tear = InutilLib.game:Spawn( EntityType.ENTITY_TEAR, RebekahCurse.ENTITY_WIND_SLASH, fam.Position, Vector.FromAngle( slashAngle ):Resized(12), fam.Player, 0, 0):ToTear()
						tear.CollisionDamage = 1.5
						InutilLib.AddHomingIfBabyBender(player, tear)
						tear:AddTearFlags(TearFlags.FLAG_PIERCING)
					elseif fam.SubType == 1 then
						
						--if not data.KnifeHelper then data.KnifeHelper = InutilLib:SpawnKnifeHelper(fam, player, true) else
						--	if not data.KnifeHelper.incubus:Exists() then
						--		data.KnifeHelper.incubus:Remove()
						--		data.KnifeHelper = nil
						--		data.KnifeHelper = InutilLib:SpawnKnifeHelper(fam, player, true)
						--	else
						--		data.KnifeHelper.incubus.Position = fam.Position
						--	end
						--end
						--local helper = InutilLib:SpawnKnifeHelper(fam, player, true)
						local kn = yandereWaifu.ThrowPseudoKnife(fam,  Vector.FromAngle(slashAngle+ 15):Resized(20), 3)
						--local kn =InutilLib.SpawnKnife(player, slashAngle+ 15, false, 0, SchoolbagKnifeMode.FIRE_ONCE, 1, 250, data.KnifeHelper, true)
						kn.Size = 1
						kn.SpriteScale = Vector(1, 1)
						kn.CollisionDamage = 3.2
						InutilLib.AddHomingIfBabyBender(player, kn)
						local kn2 = yandereWaifu.ThrowPseudoKnife(fam,  Vector.FromAngle(slashAngle- 15):Resized(20), 3)
						--local kn2 =InutilLib.SpawnKnife(player, slashAngle- 15, false, 0, SchoolbagKnifeMode.FIRE_ONCE, 1, 250, data.KnifeHelper, true)
						kn2.Size = 1
						kn2.SpriteScale = Vector(1, 1)
						kn2.CollisionDamage = 3.2
						InutilLib.AddHomingIfBabyBender(player, kn2)
					elseif fam.SubType == 2 then
						local bomb = Isaac.Spawn(EntityType.ENTITY_BOMBDROP, 0, 0, fam.Position, (data.target.Position - fam.Position):Resized( 9 ), fam.Player):ToBomb()
						bomb.ExplosionDamage = 7
						InutilLib.AddHomingIfBabyBender(player, bomb)
					elseif fam.SubType == 3 then
						local techx = EntityLaser.ShootAngle(2, fam.Position, slashAngle, 5, Vector(0,-5), fam):ToLaser()
						--local techx = player:FireTechXLaser(fam.Position,  Vector.FromAngle( slashAngle ):Resized(12), 20, fam.Player, 1)
						--techx.TearFlags = TearFlags.TEAR_NORMAL
						techx.Position = fam.Position
						--techx.OneHit = true;
						--techx.Timeout = 1;
						techx.CollisionDamage = 4.5;
						techx:SetHomingType(1)
						techx:SetMaxDistance(240)
						InutilLib.AddHomingIfBabyBender(player, techx)
					elseif fam.SubType == 4 then
						local beam = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BRIMSTONE_BALL, 0, fam.Position, Vector.FromAngle( slashAngle ):Resized(12), fam.Player)
						yandereWaifu.GetEntityData(beam).BySquire = true
						--local beam = player:FireBrimstone( Vector.FromAngle(slashAngle), fam, 2):ToLaser();
						--beam:IsCircleLaser(true)
						--beam.Radius = 15
						--beam:Update()
					elseif fam.SubType == 5 then
						local tear = InutilLib.game:Spawn( EntityType.ENTITY_TEAR, RebekahCurse.ENTITY_WIND_SLASH, fam.Position, Vector.FromAngle( slashAngle ):Resized(12), fam.Player, 0, 0):ToTear()
						tear.CollisionDamage = 2
						tear.Scale = 2.5
						tear:AddTearFlags(TearFlags.FLAG_PIERCING)
						InutilLib.AddHomingIfBabyBender(player, tear)
						local tear2 = InutilLib.game:Spawn( EntityType.ENTITY_TEAR, TearVariant.SWORD_BEAM, fam.Position, (data.target.Position - fam.Position):Resized(12), fam.Player, 0, 0):ToTear()
						tear2.CollisionDamage = 5
						InutilLib.AddHomingIfBabyBender(player, tear)
					elseif fam.SubType == 6 then
						local tear = player:FireTear( fam.Position,  (data.target.Position - fam.Position):Resized(7), false, false, false):ToTear()
						tear:ChangeVariant(50)
						tear.TearFlags = tear.TearFlags | TearFlags.TEAR_PIERCING | TearFlags.TEAR_SPECTRAL
						yandereWaifu.GetEntityData(tear).IsJacobFetus2 = true
						tear.CollisionDamage = 2
					elseif fam.SubType == 20 then
						for i = 0, math.random(1,2), 1 do
							local tear = Isaac.Spawn( EntityType.ENTITY_TEAR, RebekahCurse.ENTITY_WIND_SLASH, 0, fam.Position, Vector.FromAngle( slashAngle + math.random(-95,95)):Resized(4), fam.Player):ToTear()
							tear.CollisionDamage = 1.5
							InutilLib.AddHomingIfBabyBender(player, tear)
							tear.TearFlags = tear.TearFlags | TearFlags.TEAR_PIERCING
							--tear:AddTearFlags(TearFlags.FLAG_PIERCING)
						end
					end
				end
			else
				if rng > 75 then
					spr:Play("Move", true)
					fam.Velocity = fam.Velocity + Vector( math.random(-15, 15), math.random(-15, 15) )
				end
				if rng < 76 then
					spr:Play("Move", false)
					fam.Velocity = fam.Velocity + Vector( math.random(-15, 15), math.random(-15, 15) )
				end
			end
		end	
	end
	--target detection, if the target is dead lol
	if data.target then
		if data.target:IsDead() then
			data.target = nil
		end
	end
end, RebekahCurse.ENTITY_SQUIRENED);

yandereWaifu:AddCallback(ModCallbacks.MC_POST_FAMILIAR_RENDER, function(_,  fam) --render stuff
	if yandereWaifu.GetEntityData(fam).Health then
		local Sprite = Sprite()
		Sprite:Load("gfx/effects/gold/ui/ui_hearts.anm2", true)
		
		for i = 1, 5 do
			local state = "Full"
			pos = Isaac.WorldToScreen(fam.Position) + Vector(-18+ i*6, 5) --heart position
			
			if yandereWaifu.GetEntityData(fam).Health < i then
				state = "Empty"
			end
			
			Sprite:Play(state, true)
			Sprite:Render(pos, Vector.Zero, Vector.Zero)
		end
	end
end, RebekahCurse.ENTITY_SQUIRENED);


--christian ned
function yandereWaifu:onFamiliarChristianInit(fam)
    fam.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
	local data = yandereWaifu.GetEntityData(fam)
    local sprite = fam:GetSprite()
    sprite:Play("Spawn", true)
	data.IncreasedBuff = 0
	
	if fam.SubType == 1 then --moms knife
		--sprite:ReplaceSpritesheet(0, "gfx/effects/gold/knife/christian_ned.png") 
		--sprite:ReplaceSpritesheet(1, "gfx/effects/gold/knife/christian_ned.png") 
		sprite:Load("gfx/effects/gold/knife/christian_ned.anm2", true)
	elseif fam.SubType == 2 then --dr fetus
		sprite:Load("gfx/effects/gold/bombs/christian_ned.anm2", true)
	elseif fam.SubType == 3 then --laser
		sprite:Load("gfx/effects/gold/laser/christian_ned.anm2", true)
	elseif fam.SubType == 4 then --brimstone
		sprite:ReplaceSpritesheet(0, "gfx/effects/gold/brimstone/christian_ned.png") 
		sprite:ReplaceSpritesheet(1, "gfx/effects/gold/brimstone/christian_ned.png") 
		sprite:ReplaceSpritesheet(2, "gfx/effects/gold/brimstone/christian_ned.png") 
		sprite:ReplaceSpritesheet(3, "gfx/effects/gold/brimstone/christian_ned.png") 
		sprite:ReplaceSpritesheet(4, "gfx/effects/gold/brimstone/christian_ned.png") 
	elseif fam.SubType == 5 then --sword
		sprite:Load("gfx/effects/gold/sword/christian_ned.anm2", true)
	elseif fam.SubType == 6 then --c section
		sprite:Load("gfx/effects/gold/fetus/christian_ned.anm2", true)
	elseif fam.SubType == 20 then --bottle
		sprite:Load("gfx/effects/gold/bottle/christian_ned.anm2", true)
	end
	sprite:LoadGraphics()
	sprite:Play("Spawn", true)
end
yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, yandereWaifu.onFamiliarChristianInit, RebekahCurse.ENTITY_CHRISTIANNED);

yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_,  fam) --christian nerd
	local spr = fam:GetSprite()
	local rng = math.random(1, 100)
	local player = fam.Player
	local data = yandereWaifu.GetEntityData(fam)
	
	if fam.SubType == 25 then return end

	if spr:IsFinished("Spawn") then
		spr:Play("Idle", true)
	end
	local damageNerf = 0
	if yandereWaifu.GetEntityData(player).currentMode ~= REBECCA_MODE.GoldHearts then
		damageNerf = 1
		fam:SetColor(Color(0.2,0.2,0.2,1,0,0,0),2,2,false,false)
	end
	
	if fam.SubType == 4 then
		if InutilLib.game:GetRoom():GetFrameCount() == 1 and InutilLib.game:GetRoom():GetType() == RoomType.ROOM_BOSS then
			spr:Play("DeusVult",true)
			InutilLib.SFX:Play( RebekahCurseSounds.SOUND_CHRISTIAN_READ, 1, 0, false, 1 );
		end
	elseif fam.SubType == 0 or fam.SubType == 1 then
		--reading Bible mechanic
		if InutilLib.game:GetRoom():GetFrameCount() == 1 and InutilLib.game:GetRoom():GetType() == RoomType.ROOM_BOSS then
			for i, e in pairs(Isaac.GetRoomEntities()) do
				if e.Type == EntityType.ENTITY_MOM or e.Type == EntityType.ENTITY_MOMS_HEART or e.Type == EntityType.ENTITY_IT_LIVES then
					spr:Play("DeusVult",true)
					InutilLib.SFX:Play( RebekahCurseSounds.SOUND_CHRISTIAN_READ, 1, 0, false, 1 );
				elseif e.Type == EntityType.ENTITY_SATAN then
					spr:Play("ForJerusalem",true)
					InutilLib.SFX:Play( RebekahCurseSounds.SOUND_CHRISTIAN_READ, 1, 0, false, 1 );
				end
			end
		end
	end
	--flip sprite mechanic
	if spr:IsPlaying("Idle") then
		InutilLib.FlipXByVec(fam, false)
	end
	if spr:IsEventTriggered("Hit") then
		InutilLib.SFX:Play( RebekahCurseSounds.SOUND_STRIKE, 2, 0, false, 1 );
	end
	fam.Velocity = fam.Velocity - fam.Velocity*0.25
	if spr:IsPlaying("Idle") then

		--movement code
		if data.HasCommander then
			fam:FollowPosition ( data.HasCommander.Position );
			if fam.FrameCount % 35 == 0 then
				data.MoveDir = Isaac.GetRandomPosition()
			end
			if data.MoveDir then
				InutilLib.MoveRandomlyTypeI(fam, data.MoveDir, 2, 0.9, 0, 0, 0)
			end
		else
			fam:FollowParent();
			--fam:MoveDelayed( 70 );
			if fam.FrameCount % 35 == 0 then
				data.MoveDir = Isaac.GetRandomPosition()
			end
			if data.MoveDir then
				InutilLib.MoveRandomlyTypeI(fam, data.MoveDir, 2, 0.9, 0, 0, 0)
			end
		end
		
		if fam.SubType == 2 then --if tf2 solder
			local target = InutilLib.GetClosestGenericEnemy(fam, 350)
			
			if math.random(1,20) == 20 and fam.FrameCount % 600 == 0 then --rare heal
				spr:Play("DeusVult", true)
			else
				if target and fam.FrameCount % 3 == 0 and math.random(1,4) == 4 then
					local angle = (target.Position - fam.Position):GetAngleDegrees();
					if ((angle >= 175 and angle <= 180) or (angle <= -175 and angle >= -180)) then
						spr.FlipX = true
						data.ChargeTo = 0
						spr:Play("Fire", true)
						data.target = target
						InutilLib.SFX:Play( RebekahCurseSounds.SOUND_CHRISTIAN_OVERTAKE, 3, 0, false, 1 );
						InutilLib.SFX:Play( SoundEffect.SOUND_FORESTBOSS_STOMPS, 1, 0, false, 1 );
					elseif ((angle >= 0 and angle <= 10) or (angle <= 0 and angle >= -10)) then 
						spr.FlipX = false 
						data.ChargeTo = 1
						spr:Play("Fire", true)
						data.target = target
						InutilLib.SFX:Play( RebekahCurseSounds.SOUND_CHRISTIAN_OVERTAKE, 3, 0, false, 1 );
						InutilLib.SFX:Play( SoundEffect.SOUND_FORESTBOSS_STOMPS, 1, 0, false, 1 );
					else
						if math.random(1,5) == 5 and fam.FrameCount % 9 == 0 then
							spr:Play("RocketJump", true)
						end
					end
				end
			end
		elseif fam.SubType == 3 then --if robocop
			local target = InutilLib.GetClosestGenericEnemy(fam, 350, nil, true, 0, 0, false, false)
			
			if target then
				local angle = (target.Position - fam.Position):GetAngleDegrees();
				spr:Play("Charge", true)
				data.target = target
				if ((angle >= 0 and angle <= 90) or (angle <= 0 and angle >= -90)) then
					spr.FlipX = false
				else
					spr.FlipX = true
				end
			end
		elseif fam.SubType == 5 then --if big crusader
			local target = InutilLib.GetClosestGenericEnemy(fam, 350)
			if target and math.random(1,3) == 3 and fam.FrameCount % 60 == 0 then
				local angle = (target.Position - fam.Position):GetAngleDegrees();
				if math.random(1,3) == 3 then --send barrage
					spr:Play("DeusVult", true)
				else
					if math.random(1,5) == 5 then
						spr:Play("Charge", true)
						data.target = target
						if ((angle >= 0 and angle <= 90) or (angle <= 0 and angle >= -90)) then
							spr.FlipX = false
						else
							spr.FlipX = true
						end
					elseif (target.Position - fam.Position):Length() <= 100 then
						spr:Play("Attack", true)
						if ((angle >= 0 and angle <= 90) or (angle <= 0 and angle >= -90)) then
							spr.FlipX = false
						else
							spr.FlipX = true
						end
					end
				end
			end
		elseif fam.SubType == 6 then --if fetus yeeter
			local target = InutilLib.GetClosestGenericEnemy(fam, 450)
			if target and math.random(1,3) == 3 and fam.FrameCount % 60 == 0 then
				local angle = (target.Position - fam.Position):GetAngleDegrees();
				spr:Play("Charge", true)
				data.target = target
				if ((angle >= 0 and angle <= 90) or (angle <= 0 and angle >= -90)) then
					spr.FlipX = false
				else
					spr.FlipX = true
				end
			end
		elseif fam.SubType == 20 then --if dad ripoff
			local target = InutilLib.GetClosestGenericEnemy(fam, 450)
			if target and math.random(1,3) == 3 and fam.FrameCount % 60 == 0 then
				local angle = (target.Position - fam.Position):GetAngleDegrees();
				spr:Play("Charge", true)
				data.target = target
				if ((angle >= 0 and angle <= 90) or (angle <= 0 and angle >= -90)) then
					spr.FlipX = false
				else
					spr.FlipX = true
				end
			end
			if math.random(1,10) == 10 and fam.FrameCount % 15 == 0 then
				spr:Play("Vomit", true)
			end
		else
		--if InutilLib.game:GetFrameCount() % 120 == 0 then -- every one second
			for i, e in pairs(Isaac.GetRoomEntities()) do
				if e.Type ~= EntityType.ENTITY_PLAYER then
					if e:IsActiveEnemy() then
						if e:IsVulnerableEnemy() then
							if (fam.Position - e.Position):Length() < 250 then
								if fam.SubType == 1 then
									if rng > 90 then
										spr:Play("Charge", true)
									end
								else
									local angle = (e.Position - fam.Position):GetAngleDegrees();
									if ((angle >= 175 and angle <= 180) or (angle <= -175 and angle >= -180)) then
										spr.FlipX = true
										data.ChargeTo = 0
										spr:Play("Charge", true)
										data.target = e
										InutilLib.SFX:Play( RebekahCurseSounds.SOUND_CHRISTIAN_OVERTAKE, 3, 0, false, 1 );
										InutilLib.SFX:Play( SoundEffect.SOUND_FORESTBOSS_STOMPS, 1, 0, false, 1 );
									elseif ((angle >= 0 and angle <= 10) or (angle <= 0 and angle >= -10)) then 
										spr.FlipX = false 
										data.ChargeTo = 1
										spr:Play("Charge", true)
										data.target = e
										InutilLib.SFX:Play( RebekahCurseSounds.SOUND_CHRISTIAN_OVERTAKE, 3, 0, false, 1 );
										InutilLib.SFX:Play( SoundEffect.SOUND_FORESTBOSS_STOMPS, 1, 0, false, 1 );
									end
								end
							end
						end
					end
					if e.Type == EntityType.ENTITY_FAMILIAR and e.Variant == RebekahCurse.ENTITY_SCREAMINGNED and e.SubType == fam.SubType then
						data.HasCommander = e
					end
					if data.HasCommander and GetPtrHash(e) == GetPtrHash(data.HasCommander) and (fam.Position - e.Position):Length() < 250 then
						data.IncreasedBuff = 0.8
					else
						data.IncreasedBuff = 0
					end
				end
			end
		end	
	elseif spr:IsFinished("Idle") then
		spr:Play("Idle", true)
		InutilLib.SFX:Play( RebekahCurseSounds.SOUND_CHRISTIAN_CHANT, 2, 0, false, 1 );
	--charge ai
	elseif spr:IsFinished("Charge") then
		if fam.SubType == 1 then
			data.chargingFrameLimit = fam.FrameCount + 90
		elseif fam.SubType == 3 then
			spr:Play("Idle", true)
			local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.TECH_SWORD_BEAM, 0, fam.Position, (data.target.Position - fam.Position):Resized(60), fam.Player)
			InutilLib.AddHomingIfBabyBender(player, tear)
			--tear:ChangeVariant(TearVariant.TECH_SWORD_BEAM)
		elseif fam.SubType == 5 then
			for i, e in pairs(Isaac.GetRoomEntities()) do
				if e:IsActiveEnemy() and e:IsVulnerableEnemy() then
					if (fam.Position - e.Position):Length() < 250 then
						local crack = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACK_THE_SKY, 1, e.Position, Vector(0,0), player)
						--crack.CollisionDamage = 70
					end
				end
			end
			spr:Play("Idle", true)
		elseif fam.SubType == 6 or fam.SubType == 20 then
			spr:Play("Idle", true)
		else
			if data.ChargeTo == 0 then
				data.savedVelocity = Vector(-10,0) --needed for the velocity it goes + detection what grid is in front
			elseif data.ChargeTo == 1 then
				data.savedVelocity = Vector(10,0)
			end
			if fam.SubType == 4 then
				local beam = EntityLaser.ShootAngle(1, fam.Position, (Vector(data.savedVelocity.X*-1, 0)):GetAngleDegrees(), 5, Vector(0,-5), fam):ToLaser()
				--local beam = player:FireBrimstone( Vector(data.savedVelocity.X*-1, 0) , fam, 2):ToLaser();
				beam.Position = fam.Position
				beam.Timeout = 15
				beam.CollisionDamage = 4 + data.IncreasedBuff - damageNerf --[[+ fam.Player:GetNumCoins()/8]] + fam.Player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BFFS)
			--	beam.DisableFollowParent = true
			end
			data.chargingFrameLimit = fam.FrameCount + 30
		end
		if fam.SubType ~= 5 and fam.SubType ~= 3 and fam.SubType ~= 6 and fam.SubType ~= 20 then
			spr:Play("Charging", true)
		end
	elseif spr:IsPlaying("Charge") and fam.SubType == 6 then
		if spr:GetFrame() == 36 then
			local tear = player:FireTear( fam.Position, (data.target.Position - fam.Position):Resized(7), false, false, false):ToTear()
			tear:ChangeVariant(50)
			tear.TearFlags = tear.TearFlags | TearFlags.TEAR_PIERCING | TearFlags.TEAR_SPECTRAL
			yandereWaifu.GetEntityData(tear).IsGiantFetus = true
			tear.CollisionDamage = 5
			tear.Scale = 2
		end
	elseif spr:IsPlaying("Charge") and fam.SubType == 20 then
		if spr:GetFrame() == 15 then
			--crackwaves
			local crack = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACKWAVE, 0, fam.Position, (data.target.Position - fam.Position):Resized(7), player):ToEffect()
			crack.LifeSpan = 12;
			crack.Timeout = 12
			crack.Rotation = (fam.Position - data.target.Position):GetAngleDegrees()
			for i = 0, math.random(2,3) do
				local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0, fam.Position, Vector.FromAngle((data.target.Position - fam.Position):GetAngleDegrees() + math.random(-30,30)):Resized(7), fam):ToTear()
				tear.TearFlags = tear.TearFlags | TearFlags.TEAR_CONFUSION
				tear.CollisionDamage = 3
				tear.Scale = math.random(12, 16)/10
			end
		end
	elseif spr:IsPlaying("Charging") then
		
		if fam.SubType == 1 then
			local target = InutilLib.GetClosestGenericEnemy(fam, 250)
			if target then
				InutilLib.MoveDirectlyTowardsTarget(fam, target, 1, 0.7)
			
				--if not data.KnifeHelper then data.KnifeHelper = InutilLib:SpawnKnifeHelper(fam, player, true) else
				--	if not data.KnifeHelper.incubus:Exists() then
						--data.KnifeHelper.incubus:Remove()
						--data.KnifeHelper = nil
				--		data.KnifeHelper = InutilLib:SpawnKnifeHelper(fam, player, true)
				--	else
				--		data.KnifeHelper.incubus.Position = fam.Position
				--	end
				--end
				--local helper = InutilLib:SpawnKnifeHelper(fam, player, true)
				if fam.FrameCount % 15 == 0 then
					--local kn = InutilLib.SpawnKnife(player, fam.Velocity:GetAngleDegrees(), false, 0, SchoolbagKnifeMode.FIRE_ONCE, 1, 25, data.KnifeHelper, true)
					--kn.Size = 1
					--kn.SpriteScale = Vector(1, 1)
					--kn.CollisionDamage = 0.9
					--local kn = InutilLib.game:Spawn(EntityType.ENTITY_TEAR, 0, fam.Position, Vector.FromAngle(fam.Velocity:GetAngleDegrees()):Resized(20), player, 0, 0):ToTear()
					local kn = yandereWaifu.ThrowPseudoKnife(fam,  Vector.FromAngle(fam.Velocity:GetAngleDegrees()):Resized(20), 1)
					kn.TearFlags = kn.TearFlags | TearFlags.TEAR_PIERCING;
					kn.CollisionDamage = 1.5 + data.IncreasedBuff - damageNerf --[[+ fam.Player:GetNumCoins()/8]] + fam.Player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BFFS)
					InutilLib.AddHomingIfBabyBender(player, kn)
					--kn:ChangeVariant(RebekahCurse.ENTITY_PSEUDO_KNIFE);
					--print("does this work, pls")
				end
			else
				spr:Play("Idle", true)
			end
			--print(fam.Velocity:GetAngleDegrees())
			if fam.Velocity:GetAngleDegrees() > 90 or fam.Velocity:GetAngleDegrees() < -90 then
				spr.FlipX = true
			else
				spr.FlipX = false
			end
		else
			
			for k, enemy in pairs( Isaac.GetRoomEntities() ) do
				if enemy:IsVulnerableEnemy() then
					if enemy.Position:Distance( fam.Position ) < enemy.Size + fam.Size + 30 then
						enemy:TakeDamage(2.5 + data.IncreasedBuff - damageNerf --[[+ fam.Player:GetNumCoins()/8]] + fam.Player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BFFS), 0, EntityRef(fam), 4)
					end
				end
			end
			local room = InutilLib.game:GetRoom()
			--local setAngle = (fam.Velocity):GetAngleDegrees()
			if data.savedVelocity then
				fam.Velocity = fam.Velocity * 0.75 + data.savedVelocity
				local checkingVector = (room:GetGridEntity(room:GetGridIndex(fam.Position + data.savedVelocity)))
				if checkingVector and (checkingVector:GetType() == GridEntityType.GRID_WALL or checkingVector:GetType() == GridEntityType.GRID_DOOR) then 
					spr:Play("Charged", true)
					InutilLib.SFX:Play( RebekahCurseSounds.SOUND_STRIKE, 1, 0, false, 1 );
				end
			end
		end
		if data.chargingFrameLimit == fam.FrameCount then
			spr:Play("Idle", true)
		end
	elseif spr:IsPlaying("Charged") then
		if spr:GetFrame() <= 64 then
			fam.Velocity = Vector( 0 , 0 );
		else
			if spr:GetFrame() == 65 then
				fam.Velocity = data.savedVelocity:Resized(50)
			end
		end
	elseif spr:IsFinished("Charged") then
		spr:Play("Idle")
	elseif spr:IsPlaying("DeusVult") then
		fam.Velocity = fam.Velocity * 0.8
		if spr:GetFrame() == 40 then
			
			if fam.SubType == 4 then
				fam.Player:UseActiveItem(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL, true, false, false, false, -1)
			elseif fam.SubType == 2 then 
				for i, e in pairs(Isaac.GetRoomEntities()) do
					if e.Type == EntityType.ENTITY_PLAYER then
						e:ToPlayer():AddHearts(2)
						local charge = Isaac.Spawn( EntityType.ENTITY_EFFECT, EffectVariant.HEART, 0, e.Position, Vector(0,0), player );
						charge.SpriteOffset = Vector(0,-40)
					end
				end
				InutilLib.SFX:Play( SoundEffect.SOUND_VAMP_GULP, 1, 0, false, 1 );
			else
				for i, e in pairs(Isaac.GetRoomEntities()) do
					if e.Type == EntityType.ENTITY_MOM or e.Type == EntityType.ENTITY_MOMS_HEART or e.Type == EntityType.ENTITY_IT_LIVES then
						e.HitPoints = e.MaxHitPoints/2
						InutilLib.SFX:Play( SoundEffect.SOUND_MONSTER_GRUNT_0, 1, 0, false, 1.2 );
						--e:Kill()
					end
				end
			end
		elseif fam.SubType == 5 then -- stuff
			if spr:GetFrame() >= 20 and fam.FrameCount % 3 == 0 then
				local room = InutilLib.game:GetRoom()
				local x, y
				local lowestY, highestY = Round(math.abs(InutilLib.room:GetTopLeftPos().Y),0), Round(math.abs(InutilLib.room:GetBottomRightPos().Y),0)
				if InutilLib.ClosestHorizontalWall(fam) == Direction.LEFT then
					x = Round(math.abs(InutilLib.room:GetTopLeftPos().X), 0) - 50
				else
					x = Round(math.abs(InutilLib.room:GetBottomRightPos().X), 0) + 50
				end
				--print(Round(math.abs(InutilLib.room:GetBottomRightPos().Y),0))
				--print(Round(math.abs(InutilLib.room:GetTopLeftPos().Y),0))
				local y1, y2 = Round(math.abs(fam.Position.Y - 50),0), Round(math.abs(fam.Position.Y + 50),0)--the ys that the randomizer will pick from
				if y1 <= lowestY then y1 = lowestY end
				if y2 <= highestY then y2 = highestY end
				y = math.random( y1, y2 )
				local position = Vector(x,y)
				local neds = Isaac.Spawn( EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_CHRISTIANNEDEXTRA, 0, position, Vector.Zero, player)
				yandereWaifu.GetEntityData(neds).Damage = 2.5 + data.IncreasedBuff - damageNerf + fam.Player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BFFS)
				if InutilLib.ClosestHorizontalWall(fam) == Direction.RIGHT then
					neds.FlipX = true
				end
			end
		end
	elseif spr:IsFinished("DeusVult") or spr:IsFinished("Fire") or spr:IsFinished("LandDown") then
		spr:Play("Idle")
	elseif spr:IsFinished("ForJerusalem") then
		fam:Remove()
	elseif spr:IsPlaying("Fire") then
		if spr:GetFrame() == 19 then
			local vel --set where exactly the rocket will go
			 if data.ChargeTo == 0 then
				vel = Vector(-10,0)
			elseif data.ChargeTo == 1 then
				vel = Vector(10,0)
			end
			local bomb =  Isaac.Spawn(EntityType.ENTITY_TEAR, RebekahCurse.ENTITY_PSEUDO_ROCKET, 0, fam.Position, Vector.FromAngle(vel:GetAngleDegrees()):Resized( 20 ), fam):ToTear()
			bomb:AddTearFlags(TearFlags.TEAR_EXPLOSIVE)
			--local bomb = Isaac.Spawn(EntityType.ENTITY_BOMBDROP, BombVariant.BOMB_ROCKET, 0, fam.Position, Vector.FromAngle(vel:GetAngleDegrees()):Resized( 9 ), fam.Player):ToBomb()
			--bomb:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
			--bomb:ClearTearFlags(fam.Player.TearFlags)
			--bomb.ExplosionDamage = 3
			--bomb.TargetPosition = vel
		end
	elseif spr:IsPlaying("RocketJump") then
		if spr:GetFrame() == 9 then
			Isaac.Explode(fam.Position, fam.Player, 20 + data.IncreasedBuff - damageNerf + fam.Player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BFFS))
		end
		if spr:GetFrame() == 15 then
			fam.Visible = false
		end
		if spr:GetFrame() == 16 then
			local entCount = 0
			for i, e in pairs(Isaac.GetRoomEntities()) do
				--if e.Type ~= EntityType.ENTITY_PLAYER then
				if e:IsActiveEnemy() and e:IsVulnerableEnemy() then
					if entCount < 3 then
						InutilLib.SetTimer( i*10, function()
							local nuke = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_ORBITALNUKE, 1, e.Position + (Vector(5,0)):Rotated(math.random(0,360)), Vector.Zero, player) --maggots
							yandereWaifu.GetEntityData(nuke).CustomDamage = 10
							yandereWaifu.GetEntityData(nuke).CustomRadius = 1
							nuke:GetSprite():Load("gfx/effects/gold/bombs/orbital_nuclear_missile.anm2", true)
							nuke:GetSprite():LoadGraphics()
						end)
					end
					entCount = entCount + 1
				end
			end
		end
	elseif spr:IsFinished("RocketJump") then
		fam.Visible = true
		fam.Position = Isaac.GetRandomPosition()
		if math.random(1,4) == 4 then
			spr:Play("LandFail", true)
		else
			spr:Play("LandDown", true)
		end
	elseif spr:IsPlaying("Attack") then
		if spr:GetFrame() >= 17 and spr:GetFrame() <= 21 then
			for k, enemy in pairs( Isaac.GetRoomEntities() ) do
				if enemy:IsVulnerableEnemy() then
					if enemy.Position:Distance( fam.Position ) < enemy.Size + fam.Size + 110 then
						enemy:TakeDamage(15 + data.IncreasedBuff - damageNerf --[[+ fam.Player:GetNumCoins()/8]] + fam.Player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BFFS), 0, EntityRef(fam), 4)
					end
				end
			end
		end
	elseif spr:IsFinished("Attack") then
		fam.Visible = true
		spr:Play("Idle", true)
	elseif spr:IsPlaying("Vomit") then
		if spr:GetFrame() == 35 then
			for i = 0, math.random(1,2) do 
				local fly = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLUE_FLY, 0, fam.Position, Vector.Zero, fam.Player)
			end
		end
	elseif spr:IsFinished("Vomit") then
		spr:Play("Idle", true)
	end
	
end, RebekahCurse.ENTITY_CHRISTIANNED);

function yandereWaifu.stormtroopernedCollision(_, fam, collider, low)
	local data = yandereWaifu.GetEntityData(fam)
	if collider.Type == EntityType.ENTITY_PROJECTILE then -- stop enemy bullets
		collider:Die()
		if data.Health > 1 then
			data.Health = data.Health - 1
		else
			fam:Die()
		end
	end
end

yandereWaifu:AddCallback(ModCallbacks.MC_PRE_FAMILIAR_COLLISION, yandereWaifu.stormtroopernedCollision, RebekahCurse.ENTITY_STORMTROOPER_NED)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_FAMILIAR_RENDER, function(_,  fam) --render stuff
	local data = yandereWaifu.GetEntityData(fam)
	if data.Health then
		local Sprite = Sprite()
		Sprite:Load("gfx/effects/gold/ui/ui_hearts.anm2", true)
		
		for i = 1, 3 do
			local state = "Full"
			pos = Isaac.WorldToScreen(fam.Position) + Vector(-12+ i*6, 5) --heart position
			
			if data.Health < i then
				state = "Empty"
			end
			
			Sprite:Play(state, true)
			Sprite:Render(pos, Vector.Zero, Vector.Zero)
		end
	end
end, RebekahCurse.ENTITY_STORMTROOPER_NED);

function yandereWaifu:onFamiliarStormTrooperInit(fam)
    fam.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
    local sprite = fam:GetSprite()
	if fam.SubType == 1 then --boba
		sprite:Load("gfx/effects/gold/laser/boba_ned.anm2", true)
	end
	sprite:LoadGraphics()
    sprite:Play("Spawn", true)
end
yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, yandereWaifu.onFamiliarStormTrooperInit, RebekahCurse.ENTITY_STORMTROOPER_NED);

yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_,  fam) --stormtrooper nerd
	local spr = fam:GetSprite()
	local rng = math.random(1, 100)
	local player = fam.Player
	local data = yandereWaifu.GetEntityData(fam)
	
	if not data.Health then data.Health = 3 end
	
	if spr:IsFinished("Spawn") then
		spr:Play("Idle", true)
	end
	local damageNerf = 0
	if yandereWaifu.GetEntityData(player).currentMode ~= REBECCA_MODE.GoldHearts then
		damageNerf = 1
		fam:SetColor(Color(0.2,0.2,0.2,1,0,0,0),2,2,false,false)
	end
	
	if fam.FrameCount % 900 == 0 and fam.SubType ~= 1 then --slowly kill him
		if data.Health > 1 then
			data.Health = data.Health - 1
		else
			fam:Die()
		end
	end
	
	--flip sprite mechanic
	if spr:IsPlaying("Idle") then
		InutilLib.FlipXByVec(fam, false)
	end
	if spr:IsEventTriggered("Hit") then
		InutilLib.SFX:Play( RebekahCurseSounds.SOUND_STRIKE, 2, 0, false, 1 );
	end
	fam.Velocity = fam.Velocity - fam.Velocity*0.25
	if spr:IsPlaying("Idle") then
		local target = InutilLib.GetClosestGenericEnemy(fam, 350)
		if target then
			local angle = (target.Position - fam.Position):GetAngleDegrees();
			spr:Play("Charge", true)
			data.target = target
			if ((angle >= 0 and angle <= 90) or (angle <= 0 and angle >= -90)) then
				spr.FlipX = false
			else
				spr.FlipX = true
			end
		end
			
		--movement code
		if data.HasCommander then
			fam:FollowPosition ( data.HasCommander.Position );
			if fam.FrameCount % 35 == 0 then
				data.MoveDir = Isaac.GetRandomPosition()
			end
			if data.MoveDir then
				InutilLib.MoveRandomlyTypeI(fam, data.MoveDir, 2, 0.9, 0, 0, 0)
			end
		else
			fam:FollowParent();
			--fam:MoveDelayed( 70 );
			if fam.FrameCount % 35 == 0 then
				data.MoveDir = Isaac.GetRandomPosition()
			end
			if data.MoveDir then
				InutilLib.MoveRandomlyTypeI(fam, data.MoveDir, 2, 0.9, 0, 0, 0)
			end
		end
	
	elseif spr:IsFinished("Idle") then
		spr:Play("Idle", true)
		InutilLib.SFX:Play( RebekahCurseSounds.SOUND_CHRISTIAN_CHANT, 2, 0, false, 1 );
	--charge ai
	elseif spr:IsFinished("Charge") then
		spr:Play("Idle", true)
		if fam.SubType == 1 then
			local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.TECH_SWORD_BEAM, 0, fam.Position, Vector.FromAngle((data.target.Position - fam.Position):GetAngleDegrees()):Resized(40), fam.Player)
		else
			local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.TECH_SWORD_BEAM, 0, fam.Position, Vector.FromAngle((data.target.Position - fam.Position):GetAngleDegrees() + math.random(-70,70)):Resized(60), fam.Player)
		end
	elseif spr:IsPlaying("DeusVult") then
		fam.Velocity = fam.Velocity * 0.8
		if spr:GetFrame() == 40 then
			if fam.SubType == 4 then
				fam.Player:UseActiveItem(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL, true, false, false, false, -1)
			else
				for i, e in pairs(Isaac.GetRoomEntities()) do
					if e.Type == EntityType.ENTITY_MOM or e.Type == EntityType.ENTITY_MOMS_HEART or e.Type == EntityType.ENTITY_IT_LIVES then
						e.HitPoints = e.MaxHitPoints/2
						InutilLib.SFX:Play( SoundEffect.SOUND_MONSTER_GRUNT_0, 1, 0, false, 1.2 );
						--e:Kill()
					end
				end
			end
		end
	elseif spr:IsFinished("DeusVult") then
		spr:Play("Idle")
	elseif spr:IsFinished("ForJerusalem") then
		fam:Remove()
	end
end, RebekahCurse.ENTITY_STORMTROOPER_NED);



--screamin ned
function yandereWaifu:onFamiliarScreamingInit(fam)
    fam.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
    local sprite = fam:GetSprite()
	if fam.SubType == 1 then --moms knife
		sprite:Load("gfx/effects/gold/knife/screaming_ned.anm2", true)
	elseif fam.SubType == 2 then --dr fetus
		sprite:Load("gfx/effects/gold/bombs/screaming_ned.anm2", true)
	elseif fam.SubType == 3 then --laser
		sprite:Load("gfx/effects/gold/laser/screaming_ned.anm2", true)
	elseif fam.SubType == 4 then --brimstone
		sprite:Load("gfx/effects/gold/brimstone/screaming_ned.anm2", true)
	elseif fam.SubType == 5 then --sword
		sprite:Load("gfx/effects/gold/sword/screaming_ned.anm2", true)
	elseif fam.SubType == 6 then --c section
		sprite:Load("gfx/effects/gold/fetus/screaming_ned.anm2", true)
	elseif fam.SubType == 20 then --bottle
		sprite:Load("gfx/effects/gold/bottle/screaming_ned.anm2", true)
	end
	sprite:LoadGraphics()
    sprite:Play("Spawn", true)
end
yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, yandereWaifu.onFamiliarScreamingInit, RebekahCurse.ENTITY_SCREAMINGNED);

function yandereWaifu:ThrownSpearUpdate(fam, _)
	local spr = fam:GetSprite()
	local data = yandereWaifu.GetEntityData(fam)
	if fam.FrameCount == 1 then--init
		if not data.Height then
			data.Height = -25
		end
		if fam.SubType == 6 then
			spr:ReplaceSpritesheet(0, "gfx/effects/gold/fetus/screaming_ned.png") 
			spr:LoadGraphics()
			spr:Play("Flying", true)
		end
	end
	local damageNerf = 0
	if yandereWaifu.GetEntityData(fam.Player).currentMode ~= REBECCA_MODE.GoldHearts then
		damageNerf = 1
		fam:SetColor(Color(0.2,0.2,0.2,1,0,0,0),2,2,false,false)
	end
	if not data.Stuck then
		if fam.FrameCount % 2 == 0 and data.Height then
			data.Height = data.Height + 1
		end
		local angleNum = (fam.Velocity):GetAngleDegrees();
		for k, enemy in pairs( Isaac.GetRoomEntities() ) do
			if enemy:IsVulnerableEnemy() then
				if enemy.Position:Distance( fam.Position ) < enemy.Size + fam.Size + 30 then
					enemy:TakeDamage(5.5 -damageNerf + fam.Player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BFFS), 0, EntityRef(fam), 4)
				end
			end
		end
		--flip sprite
		InutilLib.FlipXByVec(fam, false)
		--stuck code
		local room = InutilLib.game:GetRoom()
		local checkingVector = (room:GetGridEntity(room:GetGridIndex(fam.Position + data.savedVelocity)))
		if checkingVector and (checkingVector:GetType() == GridEntityType.GRID_WALL or checkingVector:GetType() == GridEntityType.GRID_DOOR) then 
			spr:Play("Flyingn't", true)
			data.Stuck = true
			fam.Velocity = Vector( 0,0 );
			spr.FlipX = data.willFlipX
			
			InutilLib.SFX:Play( RebekahCurseSounds.SOUND_STRIKE, 1, 0, false, 1 );
		end
		if not spr:IsPlaying("Flyingn't") then
			if fam.FrameCount > 30 then
				if fam.SubType == 6 then
					local fly = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.MINISAAC, 0, fam.Position, Vector.Zero, fam.Player):ToFamiliar()
					fly.HitPoints = 5
				end
				fam:Remove()
			end
		end
		--height sprite
		if data.Height then
			fam.SpriteOffset = Vector ( 0, data.Height )
		end
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, yandereWaifu.ThrownSpearUpdate, RebekahCurse.ENTITY_SPEAR_NED)


function yandereWaifu:PseudoQuintsUpdate(fam, _)
	local spr = fam:GetSprite()
	local data = yandereWaifu.GetEntityData(fam)
	if data.PseudoQuints then
		if fam.FrameCount == 1 then
			data.QuintsOrigin = fam.Position
		else
			fam.Position = data.QuintsOrigin
			fam.Velocity = Vector.Zero
		end
		
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, yandereWaifu.PseudoQuintsUpdate)

yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_,  fam)
	local spr = fam:GetSprite()
	local rng = math.random(1, 100)
	local player = fam.Player
	local data = yandereWaifu.GetEntityData(fam)
	
	if spr:IsFinished("Spawn") then
		spr:Play("Idle", true)
	end
	
	--refresh spear
	if InutilLib.game:GetRoom():GetFrameCount() == 1 then
		spr:Play("Idle", true) --force have spear
	end
	
	--flip sprite mechanic
	if spr:IsPlaying("Idle") or spr:IsPlaying("March") then
		InutilLib.FlipXByVec(fam, false)
	end
	
	if fam.SubType == 6 and (not data.SolomonChild1 or data.SolomonChild1:IsDead()) then
		data.SolomonChild1 = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_SOLOMONNEDBABY, 0, fam.Position, Vector.Zero, fam.Player)
		yandereWaifu.GetEntityData(data.SolomonChild1).Parent = fam
		data.SolomonChild2 = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_SOLOMONNEDBABY, 1, fam.Position, Vector.Zero, fam.Player)
		yandereWaifu.GetEntityData(data.SolomonChild2).Parent = fam
	end
	
	fam.Velocity = fam.Velocity - fam.Velocity*0.25
	if spr:IsPlaying("Idle") then
		--code for natural following THOTGIRL and throwing spear
		for i, e in pairs(Isaac.GetRoomEntities()) do
			if e.Type == EntityType.ENTITY_PLAYER then
				if (fam.Position - e.Position):Length() <= 150 then
					fam:FollowParent()
					--fam:MoveDelayed( 10 )
					if fam.FrameCount % 35 == 0 then
						data.MoveDir = Isaac.GetRandomPosition()
					end
					if data.MoveDir then
						InutilLib.MoveRandomlyTypeI(fam, data.MoveDir, 6, 0.9, 0, 0, 0)
					end
				else
					fam.Velocity = fam.Velocity * 0.8 + ( e.Position - fam.Position):Resized(2);
				end
			end
			if e.Type ~= EntityType.ENTITY_PLAYER then
				if e:IsActiveEnemy() then
					if e:IsVulnerableEnemy() then
						if fam.FrameCount % 120 == 0 and fam.SubType ~= 2 and fam.SubType ~= 6 then
							local rng2 = 1
							if fam.SubType == 4 then
								rng2 = math.random(1,20)
							end
							if rng2 == 1 then
								spr:Play("Scream")
							end
						end
						if fam.SubType == 1 then --knife beast variant
							if fam.FrameCount % 130 == 0 and math.random(1,3) == 3 then
								spr:Play("Throw", true)
							end
						elseif fam.SubType == 2 and fam.FrameCount % 120 == 0 then --dr. fetus variant
							if (fam.Position - e.Position):Length() < 235 then
								local angle = (e.Position - fam.Position):GetAngleDegrees();
								if ((angle >= 178 and angle <= 180) or (angle <= -178 and angle >= -180)) then
									spr.FlipX = true
									data.ChargeTo = 0
									spr:Play("Throw", true)
									--data.target = e
								elseif ((angle >= 0 and angle <= 2) or (angle <= 0 and angle >= -2)) then 
									spr.FlipX = false
									data.ChargeTo = 1
									spr:Play("Throw", true)
									--data.target = e
								end
							end
						elseif fam.SubType == 3 then --darth vader variant
							if (fam.Position - e.Position):Length() <= 120 then
								spr:Play("Swing", true)
							else
								if fam.FrameCount % 90 == 0 and math.random(1,3) == 3 then
									spr:Play("Throw", true)
								end
							end
						elseif fam.SubType == 5 then --white knight
							if (fam.Position - e.Position):Length() < 235 then
								local angle = (e.Position - fam.Position):GetAngleDegrees();
								if ((angle >= 178 and angle <= 180) or (angle <= -178 and angle >= -180)) then
									spr.FlipX = true
									data.ChargeTo = 0
									spr:Play("StartCharge", true)
									--data.target = e
								elseif ((angle >= 0 and angle <= 2) or (angle <= 0 and angle >= -2)) then 
									spr.FlipX = false
									data.ChargeTo = 1
									spr:Play("StartCharge", true)
									--data.target = e
								end
							end
						elseif fam.SubType == 6 then --soolomon knight
							if (fam.Position - e.Position):Length() < 235 then
								local angle = (e.Position - fam.Position):GetAngleDegrees();
								if ((angle >= 178 and angle <= 180) or (angle <= -178 and angle >= -180)) then
									spr.FlipX = true
									data.ChargeTo = 0
									spr:Play("Throw", true)
									--data.target = e
								elseif ((angle >= 0 and angle <= 2) or (angle <= 0 and angle >= -2)) then 
									spr.FlipX = false
									data.ChargeTo = 1
									spr:Play("Throw", true)
									--data.target = e
								end
							end
						elseif fam.SubType == 20 then --demoman
							if (fam.Position - e.Position):Length() < 235 then
								local angle = (e.Position - fam.Position):GetAngleDegrees();
								if ((angle >= 155 and angle <= 180) or (angle <= -155 and angle >= -180)) then
									spr.FlipX = true
									data.ChargeTo = 0
									spr:Play("Throw", true)
									--data.target = e
								elseif ((angle >= 0 and angle <= 25) or (angle <= 0 and angle >= -25)) then 
									spr.FlipX = false
									data.ChargeTo = 1
									spr:Play("Throw", true)
									--data.target = e
								end
							end
						else
							if (fam.Position - e.Position):Length() < 235 and fam.FrameCount % 15 == 0 then
								local angle = (e.Position - fam.Position):GetAngleDegrees();
								if ((angle >= 178 and angle <= 180) or (angle <= -178 and angle >= -180)) then
									spr.FlipX = true
									data.ChargeTo = 0
									spr:Play("Throw", true)
									--data.target = e
								elseif ((angle >= 0 and angle <= 2) or (angle <= 0 and angle >= -2)) then 
									spr.FlipX = false
									data.ChargeTo = 1
									spr:Play("Throw", true)
									--data.target = e
								end
							end
						end
					end
				end
			end
		end
	elseif spr:IsFinished("Idle") then
		spr:Play("Idle", true)
	--throw ai
	elseif spr:IsPlaying("Throw") then
		if spr:GetFrame() == 20 then
			local savedVelocity
			if data.ChargeTo == 0 then
				savedVelocity = Vector(-10,0) --needed for the velocity it goes + detection what grid is in front
			elseif data.ChargeTo == 1 then
				savedVelocity = Vector(10,0)
			end
			if fam.SubType == 1 then 
				local fly = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLUE_FLY, math.random(1,5), fam.Position, Vector.Zero, fam.Player)
			elseif fam.SubType == 2 then 
				local bomb = Isaac.Spawn(EntityType.ENTITY_BOMBDROP, BombVariant.BOMB_BOBBY, 0, fam.Position, savedVelocity, fam.Player):ToBomb()
				--bomb:AddTearFlags(TearFlags.TEAR_HOMING)
				bomb:AddTearFlags(TearFlags.TEAR_SPECTRAL)
				InutilLib.AddHomingIfBabyBender(player, bomb)
			elseif fam.SubType == 3 then
				local subtype = 0
				if math.random(1,100) == 100 then subtype = 1 end
				local derp = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, RebekahCurse.ENTITY_STORMTROOPER_NED, subtype, fam.Position, Vector.Zero, fam.Player)
				yandereWaifu.GetEntityData(derp).HasCommander = fam
			elseif fam.SubType == 4 then
				local beam = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BRIMSTONE_BALL, 0, fam.Position, savedVelocity*3.5, fam.Player)
				yandereWaifu.GetEntityData(beam).BySquire = true
				yandereWaifu.GetEntityData(beam).Damage = 4.5
			elseif fam.SubType == 6 then
				local spear = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, RebekahCurse.ENTITY_SPEAR_NED, 6, fam.Position, savedVelocity*3.5, fam.Player)
				if savedVelocity == Vector(-10,0) then spr.FlipX = true end
				--set spear flip as well
				yandereWaifu.GetEntityData(spear).willFlipX = spr.FlipX
				local speardata = yandereWaifu.GetEntityData(spear)
				if not speardata.savedVelocity then speardata.savedVelocity = savedVelocity end
				spear:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			else --normal spear
				local spear = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, RebekahCurse.ENTITY_SPEAR_NED, 0, fam.Position, savedVelocity*3.5, fam.Player)
				if savedVelocity == Vector(-10,0) then spr.FlipX = true end
				--set spear flip as well
				yandereWaifu.GetEntityData(spear).willFlipX = spr.FlipX
				local speardata = yandereWaifu.GetEntityData(spear)
				if not speardata.savedVelocity then speardata.savedVelocity = savedVelocity end
				spear:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			end
		elseif spr:GetFrame() == 5 then
			local savedVelocity
			if data.ChargeTo == 0 then
				savedVelocity = Vector(-10,0) --needed for the velocity it goes + detection what grid is in front
			elseif data.ChargeTo == 1 then
				savedVelocity = Vector(10,0)
			end
			if fam.SubType == 20 then
				local bomb = Isaac.Spawn(EntityType.ENTITY_BOMBDROP, BombVariant.BOMB_SMALL, 0, fam.Position, (savedVelocity):Resized( 8 ), fam.Player):ToBomb()
				bomb.ExplosionDamage = 5
				bomb:SetExplosionCountdown(45)
				InutilLib.AddHomingIfBabyBender(player, bomb)
			end
		end
	elseif spr:IsFinished("Throw") then
		print("go here?")
		if fam.SubType == 3 then
			spr:Play("Idle", true)
		elseif fam.SubType == 20 then
			spr:Play("Idle", true)
			print("in here?")
		else
			spr:Play("March", true)
		end
	elseif spr:IsPlaying("March") then
		if fam.FrameCount % 3 == 0 then
			InutilLib.SFX:Play( RebekahCurseSounds.SOUND_RATTLEARMOR, 1, 0, false, 1 );
		end
		local spear
		for i, e in pairs(Isaac.GetRoomEntities()) do
			if e.Type == EntityType.ENTITY_FAMILIAR and e.Variant == RebekahCurse.ENTITY_SPEAR_NED then
				spear = e
				if (fam.Position - e.Position):Length() < 45 and yandereWaifu.GetEntityData(e).Stuck then
					if fam.SubType == 6 then
						local fly = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.MINISAAC, 0, e.Position, Vector.Zero, fam.Player):ToFamiliar()
						fly.HitPoints = 5
					end
					e:Remove()
					spr:Play("Idle")
				end
			end
		end
		if spear then
			if yandereWaifu.GetEntityData(spear).Stuck then --if stuck
				fam.Velocity = fam.Velocity * 0.8 + ( spear.Position - fam.Position):Resized(1.5);
			end
		else
			spr:Play("Idle")
		end
	elseif spr:IsPlaying("Scream") then
		if spr:GetFrame() == 11 then
			InutilLib.SFX:Play( RebekahCurseSounds.SOUND_SCREAMING_SCREAM, 1, 0, false, 1 );
			for i, e in pairs(Isaac.GetRoomEntities()) do
				if e:IsEnemy() then
					e.Target = fam
				end
			end
		end
		if fam.SubType == 1 then
			if spr:GetFrame() == 35 then
				for i = 0, 360, 360/16 do
					local fire = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.FIRE, 0, fam.Position, Vector.Zero, player)
					fire.Position = fam.Position + Vector(-70,0):Rotated(i)
					fire.Velocity = (fam.Position - fire.Position):Resized(7)
					fire:SetColor(Color(1,0,0,1,1,0,0),9999999,99,false,false)
				end
			end
		elseif fam.SubType == 3 then
			for k, enemy in pairs( Isaac.GetRoomEntities() ) do
				if enemy:IsEnemy() --[[and not enemy:IsEffect() and not enemy:IsInvulnurable()]] then
					if enemy.Position:Distance( player.Position ) < enemy.Size + player.Size + REBEKAH_BALANCE.GOLD_HEARTS_DASH_KNOCKBACK_RANGE then
						InutilLib.DoKnockbackTypeI(player, enemy, 0.65)
					end
				end
			end
		elseif fam.SubType == 4 then
			if spr:GetFrame() >= 25 then
				if fam.FrameCount % 5 == 0 then
					--print("fire")
					local minions = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PURGATORY, 1, fam.Position, Vector(0,0), player)
				end
			end
		end
	elseif spr:IsFinished("Scream") then
		spr:Play("Idle", true)
	elseif spr:IsPlaying("Swing") then
		if spr:GetFrame() == 12 then
			for i, e in pairs(Isaac.GetRoomEntities()) do
				if e.Type ~= EntityType.ENTITY_PLAYER then
					if e:IsActiveEnemy() then
						if e:IsVulnerableEnemy() then
							if (fam.Position - e.Position):LengthSquared() <= 90^2 then
								e:TakeDamage((3 * fam.Player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BFFS)) + 4, 0, EntityRef(fam),4)
							end
						end
					end
				end
			end
		end
	elseif spr:IsFinished("Swing") then
		spr:Play("Idle", true)
	elseif spr:IsFinished("StartCharge") then
		spr:Play("Charging", true)
	elseif spr:IsPlaying("Charging") then
		local savedVelocity
		if data.ChargeTo == 0 then
			savedVelocity = Vector(-10,0) --needed for the velocity it goes + detection what grid is in front
		elseif data.ChargeTo == 1 then
			savedVelocity = Vector(10,0)
		end
		fam.Velocity = (savedVelocity):Resized(30) * 0.9
		if fam.FrameCount % 2 == 0 then
			for i, e in pairs(Isaac.GetRoomEntities()) do
				if e.Type ~= EntityType.ENTITY_PLAYER then
					if e:IsActiveEnemy() then
						if e:IsVulnerableEnemy() then
							if (fam.Position - e.Position):Length() <= 30 then
								e:TakeDamage((1.5 * fam.Player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BFFS)) + 4, 0, EntityRef(fam),4)
							end
						end
					end
				end
			end
		end
		--InutilLib.SetTimer( spr:GetFrame()*2, function()
		if InutilLib.game:GetFrameCount() % 3 == 0 then
			local pos = fam.Position
			local crack = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACK_THE_SKY, 1, pos, Vector(0,0), player) 
			crack.CollisionDamage = 40
		end
		--end)
		if fam:CollidesWithGrid() then spr:Play("Idle", true) end
	elseif spr:IsFinished("Charging") then
		spr:Play("Idle", true)
	end
	if fam.FrameCount % 90 == 0 then
		for i, e in pairs(Isaac.GetRoomEntities()) do --reset target
			if e.Type ~= EntityType.ENTITY_PLAYER then
				if e:IsActiveEnemy() then
					if e:IsVulnerableEnemy() then
						e.Target = nil
					end
				end
			end
		end
	end
end, RebekahCurse.ENTITY_SCREAMINGNED);



function yandereWaifu:onFamiliarBarbaricInit(fam)
    fam.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
    local sprite = fam:GetSprite()
	if fam.SubType == 1 then --moms knife
		sprite:Load("gfx/effects/gold/knife/barbaric_ned.anm2", true)
	elseif fam.SubType == 2 then --dr fetus
		sprite:Load("gfx/effects/gold/bombs/barbaric_ned.anm2", true)
	elseif fam.SubType == 3 then --tech
		sprite:Load("gfx/effects/gold/laser/barbaric_ned.anm2", true)
	elseif fam.SubType == 4 then --brimstone
		sprite:Load("gfx/effects/gold/brimstone/barbaric_ned.anm2", true)
	elseif fam.SubType == 5 then --sword
		sprite:Load("gfx/effects/gold/sword/barbaric_ned.anm2", true)
	elseif fam.SubType == 6 then --c section
		sprite:Load("gfx/effects/gold/fetus/barbaric_ned.anm2", true)
	elseif fam.SubType == 20 then --bottle
		sprite:Load("gfx/effects/gold/bottle/barbaric_ned.anm2", true)
	end
	sprite:LoadGraphics()
    sprite:Play("Spawn", true)
end
yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, yandereWaifu.onFamiliarBarbaricInit, RebekahCurse.ENTITY_BARBARICNED);

--barbaric ned
yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_,  fam)
	local spr = fam:GetSprite()
	local rng = math.random(1, 100)
	local player = fam.Player
	local data = yandereWaifu.GetEntityData(fam)
	
	if spr:IsFinished("Spawn") then
		spr:Play("Idle", true)
		InutilLib.SFX:Play( RebekahCurseSounds.SOUND_BARBARIAN_LAUGH, 1, 0, false, 1 );
	end
	
	local damageNerf = 0
	if yandereWaifu.GetEntityData(player).currentMode ~= REBECCA_MODE.GoldHearts then
		damageNerf = 1
		fam:SetColor(Color(0.2,0.2,0.2,1,0,0,0),2,2,false,false)
	end
	
	--flip sprite mechanic
	if spr:IsPlaying("Idle")  then
		InutilLib.FlipXByVec(fam, false)
	end
	--get commander
	for i, e in pairs(Isaac.GetRoomEntities()) do
		if e.Type == EntityType.ENTITY_FAMILIAR and e.Variant == RebekahCurse.ENTITY_SCREAMINGNED and e.SubType == fam.SubType then
			data.HasCommander = e
		end
		if data.HasCommander and GetPtrHash(e) == GetPtrHash(data.HasCommander) and (fam.Position - e.Position):Length() < 250 then
			data.IncreasedBuff = 0.8
		else
			data.IncreasedBuff = 0
		end
	end
	fam.Velocity = fam.Velocity - fam.Velocity*0.25
	if spr:IsPlaying("Idle") then
		if fam.SubType ~= 6 then
			--movement code
			if data.HasCommander then
				fam:FollowPosition ( data.HasCommander.Position );
				--fam:MoveDelayed( 50 );
				if fam.FrameCount % 35 == 0 then
					data.MoveDir = Isaac.GetRandomPosition()
				end
				if data.MoveDir then
					InutilLib.MoveRandomlyTypeI(fam, data.MoveDir, 2, 0.9, 0, 0, 0)
				end
			else
				if (fam.Player.Position - fam.Position):Length() <= 150 then
					fam:FollowParent()
					--fam:MoveDelayed( 40 )
					if fam.FrameCount % 35 == 0 then
						data.MoveDir = Isaac.GetRandomPosition()
					end
					if data.MoveDir then
						InutilLib.MoveRandomlyTypeI(fam, data.MoveDir, 6, 0.9, 0, 0, 0)
					end
				else
					fam.Velocity = fam.Velocity * 0.8 + ( fam.Player.Position - fam.Position):Resized(3.4);
					if fam.FrameCount % 35 == 0 then
						data.MoveDir = Isaac.GetRandomPosition()
					end
					if data.MoveDir then
						InutilLib.MoveRandomlyTypeI(fam, data.MoveDir, 6, 0.9, 0, 0, 0)
					end
				end
			end
			if fam.SubType == 2 then
				local target = InutilLib.GetClosestGenericEnemy(fam, 250, RebekahCurse.ENTITY_TINYFELLOW)
				if target and math.random(1,5) == 5 and fam.FrameCount % 60 == 0 then
					local angle = (target.Position - fam.Position):GetAngleDegrees();
					spr:Play("StartSpin", true)
					spr.FlipX = false
					data.target = target
				end
			elseif fam.SubType == 3 then
				local target = InutilLib.GetClosestGenericEnemy(fam, 250, RebekahCurse.ENTITY_TINYFELLOW)
				if target and math.random(1,3) == 3 and fam.FrameCount % 60 == 0 then
					local angle = (target.Position - fam.Position):GetAngleDegrees();
					if (angle >= 30 and angle <= 90) then
						spr:Play("Charge0", true)
					elseif (angle >= -30 and angle <= 30) then
						spr:Play("Charge1", true)
					elseif (angle >= -90 and angle <= -30) then
						spr:Play("Charge2", true)
					elseif (angle >= -150 and angle <= -90) then
						spr:Play("Charge3", true)
					elseif (angle >= -180 and angle <= -150) or (angle >= 150 and angle <= 180) then
						spr:Play("Charge4", true)
					elseif (angle >= 90 and angle <= 150) then
						spr:Play("Charge5", true)
					end
					spr.FlipX = false
					data.target = target
				end
			elseif fam.SubType == 5 then
				local target = InutilLib.GetClosestGenericEnemy(fam, 250)
				if target and fam.FrameCount % 60 == 0 --[[and fam.FrameCount % 300 == 0 and math.random(1,3) == 3 ]]then
					spr:Play("StartSlice", true)
					data.SliceCount = 3
				end
				data.lastTarget = target
			else --if not trollge or daft punk or laban
				for i, e in pairs(Isaac.GetRoomEntities()) do
					if e.Type ~= EntityType.ENTITY_PLAYER then
						if e:IsActiveEnemy() then
							if e:IsVulnerableEnemy() then
								if (fam.Position - e.Position):Length() < 250 then
									if math.random(1,5) == 5 then
										spr:Play("Boo")
										InutilLib.SFX:Play( RebekahCurseSounds.SOUND_BARBARIAN_LAUGH, 1, 0, false, 1 );
									else
										spr:Play("StartSpin", true)
										InutilLib.SFX:Play( RebekahCurseSounds.SOUND_BARBARIAN_GRUNT, 1, 0, false, 1 );
									end
								end
							end
						end
						
					end
				end
			end
		elseif fam.SubType == 6 then
			local target = InutilLib.GetClosestGenericEnemy(fam, 250)
			if target then
				InutilLib.MoveDirectlyTowardsTarget(fam, target, 1.8, 0.9)
				local famSubs = {
					[0] = 1,
					[1] = 2,
					[2] = 5,
					[3] = 6,
					[4] = 7,
					[5] = 8,
					[6] = 9,
					[7] = 10,
					[8] = 32,
					[9] = 54,
					[10] = 92,
					[11] = 208,
					[12] = 209
				}
				if fam.FrameCount % 30 == 0 and math.random(1,8) == 8 then
					local tear = player:FireTear( fam.Position, (target.Position - fam.Position):Resized(7), false, false, false):ToTear()
					tear:ChangeVariant(50)
					tear.TearFlags = tear.TearFlags | TearFlags.TEAR_PIERCING | TearFlags.TEAR_SPECTRAL
					yandereWaifu.GetEntityData(tear).IsGiantFetus2 = true
					tear.CollisionDamage = 5
				end
				for i, e in pairs(Isaac.GetRoomEntities()) do
					if e.Type ~= EntityType.ENTITY_PLAYER then
						if e:IsActiveEnemy() then
							if e:IsVulnerableEnemy() then
								if (fam.Position - e.Position):Length() < 45 and fam.FrameCount % 15 == 0 then
									local dmg = 4.5 + data.IncreasedBuff - damageNerf + fam.Player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BFFS)
									e:TakeDamage(dmg, 0, EntityRef(fam),10)
									if e.HitPoints - dmg <= 0 then
										if not data.QuintsCount then
											data.QuintsCount = 0
										end
										if data.QuintsCount and data.QuintsCount < 5 then
											local fam = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, famSubs[math.random(0,12)], 0, e.Position, Vector.Zero, ent):ToFamiliar()
											fam:RemoveFromFollowers()
											yandereWaifu.GetEntityData(fam).PseudoQuints = true
											yandereWaifu.GetEntityData(fam).QuintsOrigin = e.Position
											local color = Color(1,1,1)
											color:SetColorize(1, 1, 1, 1)
											fam:GetSprite().Color = color
											data.QuintsCount = data.QuintsCount + 1
										end
									end
								end
							end
						end
					end
				end
			else
				if fam.FrameCount % 35 == 0 then
					data.MoveDir = Isaac.GetRandomPosition()
				end
				if data.MoveDir then
					InutilLib.MoveRandomlyTypeI(fam, data.MoveDir, 1.2, 0.9, 0, 0, 0)
				end
			end
		end
	elseif spr:IsFinished("Idle") then
		spr:Play("Idle", true)
	--throw ai
	elseif spr:IsPlaying("StartSpin") then
		if fam.SubType == 1 then
			if spr:GetFrame() >= 27 and spr:GetFrame() <= 29 then
				local rng2 = 0
				for i = 0, 360, 360/4 do 
					local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0, fam.Position, Vector.Zero, ent):ToTear()
					tear.Velocity = tear.Velocity + Vector(-5,0):Rotated(i+rng2)
					tear:AddTearFlags(TearFlags.TEAR_WIGGLE)
					tear.CollisionDamage = 1 + data.IncreasedBuff - damageNerf + fam.Player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BFFS)
					tear.Scale = 0.45
					InutilLib.AddHomingIfBabyBender(player, tear)
				end
			end
		elseif not fam.SubType == 2 then -- make sure is not trolleg
			if spr:GetFrame() >= 20 then
				for i, e in pairs(Isaac.GetRoomEntities()) do
					if e.Type ~= EntityType.ENTITY_PLAYER then
						if e:IsActiveEnemy() then
							if e:IsVulnerableEnemy() then
								if (fam.Position - e.Position):LengthSquared() <= 45^2 then
									e:TakeDamage(1 * fam.Player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BFFS), 0, EntityRef(fam),4)
								end
							end
						end
					end
				end
			end
		end
	elseif spr:IsFinished("StartSpin") then
		if fam.SubType == 4 then
			spr:Play("Bite", true)
		elseif fam.SubType == 2 then
			spr:Play("Appear1", true)
			fam.Position = Isaac.GetRandomPosition()
			InutilLib.game:ShakeScreen(10)
		else
			spr:Play("Spin", true)
		end
	elseif spr:IsPlaying("Spin") then
		if fam.SubType == 1 then
			if (spr:GetFrame() >= 7 and spr:GetFrame() <= 9) or (spr:GetFrame() >= 17 and spr:GetFrame() <= 19) or (spr:GetFrame() >= 27 and spr:GetFrame() <= 29) or (spr:GetFrame() >= 37 and spr:GetFrame() <= 39) or (spr:GetFrame() >= 47 and spr:GetFrame() <= 49) 
				or (spr:GetFrame() >= 57 and spr:GetFrame() <= 59) or (spr:GetFrame() >= 67 and spr:GetFrame() <= 69) and spr:GetFrame() % 2 == 0 then
				if not data.rot then data.rot = math.random(30,60) end
				for i = 0, 360, 360/4 do 
					local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0, fam.Position, Vector.Zero, ent):ToTear()
					tear.Velocity = tear.Velocity + Vector(-5,0):Rotated(i+data.rot)
					tear:AddTearFlags(TearFlags.TEAR_WIGGLE)
					tear.CollisionDamage = 1 + data.IncreasedBuff - damageNerf + fam.Player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BFFS)
					tear.Scale = 0.45
					InutilLib.AddHomingIfBabyBender(player, tear)
				end			
			end
			if spr:GetFrame() == 9 or spr:GetFrame() == 19 or spr:GetFrame() == 29 or spr:GetFrame() == 39 or spr:GetFrame() == 49 or spr:GetFrame() == 59 or spr:GetFrame() == 69 then
				data.rot = data.rot + 15
			end	
		elseif fam.SubType == 20 then
			if spr:GetFrame() == 1 then
				for i = 0, 360, 360/3 do
					local beam = EntityLaser.ShootAngle(1, fam.Position, i, 32, Vector(0,-5), fam):ToLaser()
					--local beam = player:FireBrimstone( Vector(data.savedVelocity.X*-1, 0) , fam, 2):ToLaser();
					beam.Position = fam.Position
					beam.Timeout = 32
					beam.CollisionDamage = 1	
					beam.MaxDistance = 90
					beam.Color = Color(0, 1, 0, 1, 0, 1, 0)
					beam:SetActiveRotation(3, 1440, 15, true)
				end
			end
		end
		if fam.FrameCount % 5 == 0 then
			InutilLib.SFX:Play( SoundEffect.SOUND_SHELLGAME, 1, 0, false, 0.6 );
		end
		data.closestDist = 177013 --saved Dist to check who is the closest enemy
		data.target = nil
		for i, e in pairs(Isaac.GetRoomEntities()) do
			if e.Type ~= EntityType.ENTITY_PLAYER then
				if e:IsActiveEnemy() then
					if e:IsVulnerableEnemy() then
						if (fam.Position - e.Position):Length() < 45 then
							e:TakeDamage(2.5 + data.IncreasedBuff - damageNerf + fam.Player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BFFS), 0, EntityRef(fam),10)
						end
						if (fam.Position - e.Position):Length() < 500 then
							if (fam.Position - e.Position):Length() <= data.closestDist then
								data.target = e
								data.closestDist = (fam.Position - e.Position):Length()
							end							
						end
					end
				end
			end
		end
		if data.target and not data.target:IsDead() then
			if fam.SubType == 1 then
				fam.Velocity = fam.Velocity * 0.6 + ( data.target.Position - fam.Position):Resized(2);
			else
				fam.Velocity = fam.Velocity * 0.8 + ( data.target.Position - fam.Position):Resized(2);
			end
		else
			data.target = nil
			if data.HasCommander then
				fam:FollowPosition ( data.HasCommander.Position );
				--fam:MoveDelayed( 40 );
			else
				fam:FollowParent();
				--fam:MoveDelayed( 40 );
			end
		end
	elseif spr:IsPlaying("Bite") then
		if spr:GetFrame() == 1 then
			data.closestDist = 177013 --saved Dist to check who is the closest enemy
			data.target = nil
			for i, e in pairs(Isaac.GetRoomEntities()) do
				if e.Type ~= EntityType.ENTITY_PLAYER then
					if e:IsActiveEnemy() then
						if e:IsVulnerableEnemy() then
							if (fam.Position - e.Position):Length() < 45 then
								e:TakeDamage(2.5 + data.IncreasedBuff - damageNerf + fam.Player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BFFS), 0, EntityRef(fam),10)
							end
							if (fam.Position - e.Position):Length() < 500 then
								if (fam.Position - e.Position):Length() <= data.closestDist then
									data.target = e
									data.closestDist = (fam.Position - e.Position):Length()
								end							
							end
						end
					end
				end
			
			end
			if data.target and not data.target:IsDead() then
				if math.random(1,2) == 2 then
					fam.Position = data.target.Position - Vector(-60,0)
					spr.FlipX = true
				else
					fam.Position = data.target.Position + Vector(-60,0)
					spr.FlipX = false
				end
			end
		elseif spr:GetFrame() == 9 then
			if spr.FlipX then
				fam.Velocity = fam.Velocity * 0.75 - Vector(15,0)
			else
				fam.Velocity = fam.Velocity * 0.75 + Vector(15,0)
			end
		elseif spr:GetFrame() >= 9 and spr:GetFrame() <= 13 then
			for i, e in pairs(Isaac.GetRoomEntities()) do
				if e:IsActiveEnemy() then
					if e:IsVulnerableEnemy() then
						local axeOffset
						if spr.FlipX then
							axeOffset = Vector(15,0)
						else
							axeOffset = Vector(-15,0)
						end
						if ((fam.Position + axeOffset) - e.Position):Length() < 75 then
							e:TakeDamage(2.5 + data.IncreasedBuff -damageNerf + fam.Player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BFFS), 0, EntityRef(fam),10)
						end
					end
				end
			end
		end
	elseif spr:IsFinished("Bite") then
		spr:Play("EndSpin", true)
		fam.Position = Isaac.GetRandomPosition()
	elseif spr:IsFinished("Spin") then
		data.rot = nil
		spr:Play("EndSpin", true)
		InutilLib.SFX:Play( RebekahCurseSounds.SOUND_BARBARIAN_LAUGH, 1, 0, false, 0.5 );
	--[[elseif spr:IsPlaying("EndSpin") then
		if spr:GetFrame() >= 6 and spr:GetFrame() <= 215 then
			fam:AddConfusion(EntityRef(fam), 2, false)
		end]]
	elseif spr:IsFinished("EndSpin") then
		spr:Play("Idle", true)
	elseif spr:IsPlaying("Boo") then
		if spr:GetFrame() == 11 then
			for i, e in pairs(Isaac.GetRoomEntities()) do
				if e:IsEnemy() then
					if (fam.Position - e.Position):Length() < 500 then
						e:AddFear(EntityRef(fam), 60)
					end
				end
			end
		end
	elseif spr:IsFinished("Boo") then
		spr:Play("Idle", true)
	elseif spr:IsPlaying("Appear1") or spr:IsPlaying("Appear2") then
		for i, e in pairs(Isaac.GetRoomEntities()) do
			if e:IsEnemy() then
				if (fam.Position - e.Position):Length() < 200 then
					e:AddFreeze(EntityRef(fam), 10)
					e:AddFear(EntityRef(fam), 10)
				end
			end
		end
	elseif spr:IsFinished("Appear1") or spr:IsFinished("Appear2") then
		if math.random(1,3) == 3 then
			if math.random(1,4) == 4 then
				spr:Play("Detonate", true)
			else
				spr:Play("EndSpin", true)
			end
		else
			if math.random(1,4) == 4 then
				spr:Play("Appear2", true)
			else
				spr:Play("Appear1", true)
			end
			fam.Position = Isaac.GetRandomPosition()
			InutilLib.game:ShakeScreen(10)
			InutilLib.SFX:Play( SoundEffect.SOUND_FORESTBOSS_STOMPS, 1, 0, false, 1 );
		end
	elseif spr:IsPlaying("Detonate") then
		local target = InutilLib.GetClosestGenericEnemy(fam, 250)
		if target then
			InutilLib.MoveDirectlyTowardsTarget(fam, target, 1, 0.9)
		end
	elseif spr:IsFinished("Detonate") then
		if not data.HeWatchesYouIdle then
			 data.HeWatchesYouIdle = math.random(90,180)
			 for i, e in pairs(Isaac.GetRoomEntities()) do
				if e:IsEnemy() then
					if (fam.Position - e.Position):Length() < 170 then
						InutilLib.SetTimer( i*15, function()
							Isaac.Explode(e.Position, fam, 150 + data.IncreasedBuff - damageNerf + fam.Player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BFFS))
						end)
					end
				end
			end
		else
			data.HeWatchesYouIdle =  data.HeWatchesYouIdle - 1
			if data.HeWatchesYouIdle <= 0 then
				 data.HeWatchesYouIdle = nil
				spr:Play("EndSpin", true)
			end
		end
	elseif spr:IsFinished("StartSlice") then
		for i, e in pairs(Isaac.GetRoomEntities()) do
			if e:IsEnemy() then
				if (fam.Position - e.Position):Length() < 2000 then
					if not yandereWaifu.GetEntityData(e).IsTargetedByLaban then
						yandereWaifu.GetEntityData(e).IsTargetedByLaban = true
						if not data.LabanTargets then data.LabanTargets = {} end
						table.insert(data.LabanTargets, e)
						fam.Position = e.Position
						spr:Play("Slice1", true)
						e:AddFreeze(EntityRef(fam), 10)
						e:AddFear(EntityRef(fam), 10)
						break
					end
				end
			end
			--incase theres nothing
			spr:Play("FinishSlice", true)
		end
	elseif InutilLib.IsFinishedMultiple(spr, "Slice1", "Slice2", "Slice3") then
		if math.random(1,3) == 3 and data.SliceCount > 0 then
			data.SliceCount = data.SliceCount - 1
			local function playRandomSlice()
				local rng = math.random(1,3)
				
				if rng == 1 then
					spr:Play("Slice1", true)
				elseif rng == 2 then
					spr:Play("Slice2", true)
				else
					spr:Play("Slice3", true)
				end
			end
			local didSucceed = false
			for i, e in pairs(Isaac.GetRoomEntities()) do
				if e:IsEnemy() then
					if (fam.Position - e.Position):Length() < 500 then
						if not yandereWaifu.GetEntityData(e).IsTargetedByLaban then
							yandereWaifu.GetEntityData(e).IsTargetedByLaban = true
							if not data.LabanTargets then data.LabanTargets = {} end
							table.insert(data.LabanTargets, e)
							--if not data.LabanTargetCount then data.LabanTargetCount = 0 end
							--data.LabanTargetCount = data.LabanTargetCount + 1
							--data.LabanTargets[data.LabanTargetCount] = e
							fam.Position = e.Position + Vector(math.random(-10,10), math.random(-10,10))
							playRandomSlice()
							didSucceed = true
							e:AddFreeze(EntityRef(fam), 10)
							e:AddFear(EntityRef(fam), 10)
							break
						end
					end
				end
			end
			if not didSucceed then
				spr:Play("FinishSlice", true)
				fam.Position = Isaac.GetRandomPosition()
				data.LabanTargetCount = 0
			end
		else
			spr:Play("FinishSlice", true)
			fam.Position = Isaac.GetRandomPosition()
			data.LabanTargetCount = 0
		end
	elseif spr:IsPlaying("FinishSlice") then
		if spr:GetFrame() == 20 then
			for i, e in pairs(Isaac.GetRoomEntities()) do
				if yandereWaifu.GetEntityData(e).IsTargetedByLaban then
					InutilLib.SFX:Play( SoundEffect.SOUND_KNIFE_PULL, 0.7, 0, false, 1 );
					yandereWaifu.GetEntityData(e).IsTargetedByLaban = false
					yandereWaifu.SpawnPoofParticle( e.Position, Vector( 0, 0 ), player, RebekahPoofParticleType.Evil );
					e:TakeDamage(7.5 + data.IncreasedBuff -damageNerf + fam.Player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BFFS), 0, EntityRef(fam),10)
				end
			end
			--local customBody = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_EXTRACHARANIMHELPER, 0, fam.Position, Vector(0,0), nil) --body effect
			--yandereWaifu.GetEntityData(customBody).Player = player
			--yandereWaifu.GetEntityData(customBody).DontFollowPlayer = true
			--yandereWaifu.GetEntityData(customBody).LabanHelper = true
			--yandereWaifu.GetEntityData(customBody).LabanTargets = data.LabanTargets
			--print(#yandereWaifu.GetEntityData(customBody).LabanTargets)
			--yandereWaifu.GetEntityData(customBody).Damage = 7.5 + data.IncreasedBuff -damageNerf + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BFFS)
			--data.LabanTargets = {}
		end
	elseif spr:IsFinished("FinishSlice") then
		spr:Play("Idle", true)
	elseif InutilLib.IsPlayingMultiple(spr, "Charge0", "Charge1", "Charge2", "Charge3", "Charge4", "Charge5") then
		if spr:IsEventTriggered("Burst") then
			local savedAngle = (data.target.Position - fam.Position):GetAngleDegrees() --I need it to be static
			for i = 1, 12 do
                player.Velocity = player.Velocity * 0.8 --slow him down
				local color = Color(1,1,1,1.0,255,0,0)
				if i == 1 or i == 7 then
					--Red
					color = Color(1,1,1,1.0,255,0,0)
				elseif i == 2 or i == 8 then
					--Orang
					color = Color(1,1,1,1.0,255,100,0)
				elseif i == 3 or i == 9 then
					--Yellow
					color = Color(1,1,1,1.0,255,255,0)
				elseif i == 4 or i == 10 then
					--Green
					color = Color(1,1,1,1.0,0,255,0)
				elseif i == 5 or i == 11 then
					--Blue
					color = Color(1,1,1,1.0,0,0,255)
				elseif i == 6 or i == 12 then
					--Purple
					color = Color(1,1,1,1.0,155,0,155)
				end
                InutilLib.SetTimer( i*7, function()
					tech = EntityLaser.ShootAngle(2, fam.Position, savedAngle + math.random(-10,10), 5, Vector(0,-5), fam):ToLaser()
					tech.CollisionDamage = 2.5 + data.IncreasedBuff - damageNerf + fam.Player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BFFS)
					tech.DisableFollowParent = true
					tech:SetColor(color,9999999,9999999,false,false)
					tech.Timeout = 1
					InutilLib.AddHomingIfBabyBender(player, tech)
					--tech:SetMaxDistance(100)
					--InutilLib.UpdateLaserSize(tech, 0.5)
				end)
			end
		end
	elseif InutilLib.IsFinishedMultiple(spr, "Charge0", "Charge1", "Charge2", "Charge3", "Charge4", "Charge5") then
		spr:Play("Idle", true)
	end
	if fam.FrameCount % 90 == 0 then
		for i, e in pairs(Isaac.GetRoomEntities()) do --reset target
			if e.Type ~= EntityType.ENTITY_PLAYER then
				if e:IsActiveEnemy() then
					if e:IsVulnerableEnemy() then
						e.Target = nil
					end
				end
			end
		end
	end
end, RebekahCurse.ENTITY_BARBARICNED);


function yandereWaifu:RebekahNewRoomForLilithKnightThing()	
	for n, ned in pairs( Isaac.FindByType(EntityType.ENTITY_FAMILIAR, RebekahCurse.ENTITY_BARBARICNED, -1, false, false) ) do
		local data = yandereWaifu.GetEntityData(ned)
		data.QuintsCount = 0
	end
end
yandereWaifu:AddCallback( ModCallbacks.MC_POST_NEW_ROOM, yandereWaifu.RebekahNewRoomForLilithKnightThing)

function yandereWaifu.nedDefedCollision(_, fam, collider, low)
	local data = yandereWaifu.GetEntityData(fam)
	if collider.Type == EntityType.ENTITY_PROJECTILE then -- stop enemy bullets
		collider:Die()
		--if math.random(1,10) == 10 then
			local princessProtectorAngle = (fam.Player.Velocity):GetAngleDegrees()
			if fam.SubType == 4 then
				local beam = EntityLaser.ShootAngle(1, fam.Position, princessProtectorAngle-180, 5, Vector(0,-5), fam):ToLaser()
				--local beam = player:FireBrimstone( Vector(data.savedVelocity.X*-1, 0) , fam, 2):ToLaser();
				beam.Position = fam.Position
				beam.Timeout = 5
				beam.CollisionDamage = 1	
				InutilLib.AddHomingIfBabyBender(player, beam)
			end
		--end
		if fam.SubType == 20 and not data.IsBroken then
			data.IsBroken = true
			for i = 1, 3 do
				local shard = Isaac.Spawn(1000, TaintedEffects.BOTTLE_SHARD, 0, fam.Position, (RandomVector() * math.random(2,4)):Rotated(i * (360/5)), fam)
				shard.CollisionDamage = 1.5
			end
		end
	end
end

yandereWaifu:AddCallback(ModCallbacks.MC_PRE_FAMILIAR_COLLISION, yandereWaifu.nedDefedCollision, RebekahCurse.ENTITY_DEFENDINGNED)
function yandereWaifu:onFamiliarDefendingInit(fam)
    fam.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
    local sprite = fam:GetSprite()
	if fam.SubType == 1 then --moms knife
		sprite:Load("gfx/effects/gold/knife/defending_ned.anm2", true)
	elseif fam.SubType == 2 then --dr fetus
		sprite:Load("gfx/effects/gold/bombs/defending_ned.anm2", true)
	elseif fam.SubType == 3 then --tech
		sprite:Load("gfx/effects/gold/laser/defending_ned.anm2", true)
	elseif fam.SubType == 4 then --brimstone
		sprite:ReplaceSpritesheet(0, "gfx/effects/gold/brimstone/defending_ned.png") 
		sprite:ReplaceSpritesheet(1, "gfx/effects/gold/brimstone/defending_ned.png") 
		sprite:ReplaceSpritesheet(2, "gfx/effects/gold/brimstone/defending_ned.png") 
		sprite:ReplaceSpritesheet(3, "gfx/effects/gold/brimstone/defending_ned.png") 
		sprite:ReplaceSpritesheet(4, "gfx/effects/gold/brimstone/defending_ned.png") 
	elseif fam.SubType == 5 then --sword
		sprite:Load("gfx/effects/gold/sword/defending_ned.anm2", true)
	elseif fam.SubType == 6 then --c section
		sprite:Load("gfx/effects/gold/fetus/defending_ned.anm2", true)
	elseif fam.SubType == 20 then --bottle
		sprite:Load("gfx/effects/gold/bottle/defending_ned.anm2", true)
	end
	sprite:LoadGraphics()
    sprite:Play("Spawn", true)
end
yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, yandereWaifu.onFamiliarDefendingInit, RebekahCurse.ENTITY_DEFENDINGNED);


--defending ned
yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_,  fam)
	local spr = fam:GetSprite()
	local rng = math.random(1, 100)
	local player = fam.Player
	local data = yandereWaifu.GetEntityData(fam)
	
	if spr:IsFinished("Spawn") then
		spr:Play("Side", true)
	end
	
	local damageNerf = 0
	if yandereWaifu.GetEntityData(player).currentMode ~= REBECCA_MODE.GoldHearts then
		damageNerf = 1
		fam:SetColor(Color(0.2,0.2,0.2,1,0,0,0),2,2,false,false)
	end

	if data.IsBroken then
		fam:SetColor(Color(0,0,0,1,0,0,0),2,2,false,false)
		if math.random(1,10) == 10 and fam.FrameCount % 15 == 0 then
			data.IsBroken = false
		end
	end
	
	local currentSide = nil
	local princessProtectorAngle = (fam.Player.Velocity):GetAngleDegrees()
	local willFlip = false
	local neededPosition = fam.Player.Position + Vector(40,0):Rotated(princessProtectorAngle)
	
	if fam.SubType == 4 then --brimstone variant
		neededPosition = fam.Player.Position - Vector(40,0):Rotated(princessProtectorAngle)
		if spr:IsFinished("Spawn") then
			spr:Play("Front", true)
		end
	end
	if fam.SubType == 2 then
		InutilLib.MoveOrbitAroundTargetType1(fam, player, 7, 0.9, 3, 0)	
	end
	if fam.SubType == 5 then
		InutilLib.MoveDiagonalTypeI(fam, 8, false, true)
	end
	if fam.SubType == 1 then
		InutilLib.MoveOrbitAroundTargetType1(fam, player, 3, 0.9, 5, 0)	
	end
	if fam.SubType == 3 then
		InutilLib.MoveOrbitAroundTargetType1(fam, player, 2, 0.9, 5, 0)	
	end
	if fam.SubType == 20 then
		InutilLib.MoveOrbitAroundTargetType1(fam, player, 5, 0.9, 3, 0)	
	end
	if not spr:IsPlaying("ThrowBomb") then
		--fam.Velocity = fam.Velocity * 2
		if fam.SubType == 1 or fam.SubType == 5 then
			local e = InutilLib.GetClosestGenericEnemy(fam, 70)
			if e then
				if not InutilLib.IsPlayingMultiple(spr, "SideAttack", "FrontAttack", "BackAttack") then
					local angle = (e.Position - fam.Position):GetAngleDegrees();
					if princessProtectorAngle >= 45 and princessProtectorAngle <= 135 and currentSide ~= "down" then
						currentSide = "down"
						if not spr:IsPlaying("BackAttack") then spr:Play("BackAttack", true) end
					elseif princessProtectorAngle <= -45 and princessProtectorAngle >= -135 and currentSide ~= "up" then
						currentSide = "up"
						if not spr:IsPlaying("FrontAttack") then spr:Play("FrontAttack", true) end
					elseif (princessProtectorAngle <= 0 and princessProtectorAngle >= -45) or (princessProtectorAngle >= 0 and princessProtectorAngle <= 45) and currentSide ~= "right" then
						currentSide = "right"
						if not spr:IsPlaying("SideAttack") then spr:Play("SideAttack", true) end
						spr.FlipX = true;
						willFlip = true;
					elseif (princessProtectorAngle <= 180 and princessProtectorAngle >= 135) or (princessProtectorAngle >= -180 and princessProtectorAngle <= -135) and currentSide ~= "left" then
						currentSide = "left"
						if not spr:IsPlaying("SideAttack") then spr:Play("SideAttack", true) end
						spr.FlipX = false;
						willFlip = false;
					end	
				end
			end
		elseif fam.SubType == 2 then
			local e = InutilLib.GetClosestGenericEnemy(fam, 300)
			if e then
				if math.random(1,10) == 10 and fam.FrameCount % 30 == 0 then
					spr:Play("ThrowBomb", true)
					data.target = e
				else
					InutilLib.AnimWalkFrame(fam, true, "Side", "Front", "Back")
				end
			else
				InutilLib.AnimWalkFrame(fam, true, "Side", "Front", "Back")
			end
		elseif fam.SubType == 3 then
			local closestproj
			for i, e in pairs(Isaac.GetRoomEntities()) do
				if e.Type == EntityType.ENTITY_PROJECTILE then
					if (fam.Position - e.Position):Length() < 500 then
						closestproj = e
					end
				end
			end
			if closestproj then
				if princessProtectorAngle >= 45 and princessProtectorAngle <= 135 and currentSide ~= "down" then
					currentSide = "down"
					if not spr:IsPlaying("BackShoot") then spr:Play("BackShoot", true) end
				elseif princessProtectorAngle <= -45 and princessProtectorAngle >= -135 and currentSide ~= "up" then
					currentSide = "up"
					if not spr:IsPlaying("FrontShoot") then spr:Play("FrontShoot", true) end
				elseif (princessProtectorAngle <= 0 and princessProtectorAngle >= -45) or (princessProtectorAngle >= 0 and princessProtectorAngle <= 45) and currentSide ~= "right" then
					currentSide = "right"
					if not spr:IsPlaying("SideShoot") then spr:Play("SideShoot", true) end
					spr.FlipX = true;
					willFlip = true;
				elseif (princessProtectorAngle <= 180 and princessProtectorAngle >= 135) or (princessProtectorAngle >= -180 and princessProtectorAngle <= -135) and currentSide ~= "left" then
					currentSide = "left"
					if not spr:IsPlaying("SideShoot") then spr:Play("SideShoot", true) end
					spr.FlipX = false;
					willFlip = false;
				end
				data.closestproj = closestproj
			end
		elseif fam.SubType == 4 then
			if princessProtectorAngle >= 45 and princessProtectorAngle <= 135 and currentSide ~= "down" then
				currentSide = "down"
				if not spr:IsPlaying("Back") then spr:Play("Back", true) end
			elseif princessProtectorAngle <= -45 and princessProtectorAngle >= -135 and currentSide ~= "up" then
				currentSide = "up"
				if not spr:IsPlaying("Front") then spr:Play("Front", true) end
			elseif (princessProtectorAngle <= 0 and princessProtectorAngle >= -45) or (princessProtectorAngle >= 0 and princessProtectorAngle <= 45) and currentSide ~= "right" then
				currentSide = "right"
				if not spr:IsPlaying("Side") then spr:Play("Side", true) end
				spr.FlipX = true;
				willFlip = true;
			elseif (princessProtectorAngle <= 180 and princessProtectorAngle >= 135) or (princessProtectorAngle >= -180 and princessProtectorAngle <= -135) and currentSide ~= "left" then
				currentSide = "left"
				if not spr:IsPlaying("Side") then spr:Play("Side", true) end
				spr.FlipX = false;
				willFlip = false;
			end
		elseif fam.SubType == 6 then
			local princessProtectorAngle = fam.Velocity:GetAngleDegrees() 
			if princessProtectorAngle >= 45 and princessProtectorAngle <= 135 and currentSide ~= "down" then
				currentSide = "down"
				if not spr:IsPlaying("Front") then spr:Play("Front", true) end
			elseif princessProtectorAngle <= -45 and princessProtectorAngle >= -135 and currentSide ~= "up" then
				currentSide = "up"
				if not spr:IsPlaying("Back") then spr:Play("Back", true) end
			elseif (princessProtectorAngle <= 0 and princessProtectorAngle >= -45) or (princessProtectorAngle >= 0 and princessProtectorAngle <= 45) and currentSide ~= "right" then
				currentSide = "right"
				if not spr:IsPlaying("Side") then spr:Play("Side", true) end
				spr.FlipX = false;
				willFlip = false;
			elseif (princessProtectorAngle <= 180 and princessProtectorAngle >= 135) or (princessProtectorAngle >= -180 and princessProtectorAngle <= -135) and currentSide ~= "left" then
				currentSide = "left"
				if not spr:IsPlaying("Side") then spr:Play("Side", true) end
				spr.FlipX = true;
				willFlip = true;
			end
		else
			if princessProtectorAngle >= 45 and princessProtectorAngle <= 135 and currentSide ~= "down" then
				currentSide = "down"
				if not spr:IsPlaying("Front") then spr:Play("Front", true) end
			elseif princessProtectorAngle <= -45 and princessProtectorAngle >= -135 and currentSide ~= "up" then
				currentSide = "up"
				if not spr:IsPlaying("Back") then spr:Play("Back", true) end
			elseif (princessProtectorAngle <= 0 and princessProtectorAngle >= -45) or (princessProtectorAngle >= 0 and princessProtectorAngle <= 45) and currentSide ~= "right" then
				currentSide = "right"
				if not spr:IsPlaying("Side") then spr:Play("Side", true) end
				spr.FlipX = false;
				willFlip = false;
			elseif (princessProtectorAngle <= 180 and princessProtectorAngle >= 135) or (princessProtectorAngle >= -180 and princessProtectorAngle <= -135) and currentSide ~= "left" then
				currentSide = "left"
				if not spr:IsPlaying("Side") then spr:Play("Side", true) end
				spr.FlipX = true;
				willFlip = true;
			end

		end
		--stay where?
		--fam:FollowPosition ( neededPosition );
		if fam.SubType == 1 or fam.SubType == 5 then
			--fam:AddToOrbit(15)
			--fam.OrbitDistance = Vector(70,70)
			--fam.OrbitAngleOffset = fam.OrbitAngleOffset+0.02
			--fam.Velocity = fam:GetOrbitPosition(player.Position+player.Velocity) - fam.Position	
			if InutilLib.IsPlayingMultiple(spr, "SideAttack", "FrontAttack", "BackAttack") then
				if spr:GetFrame() >= 6 and spr:GetFrame() <= 12 then
					local offsetPos = fam.Position - Vector(15,0):Rotated(princessProtectorAngle)
					local e = InutilLib.GetClosestGenericEnemy(fam, 70)
					if e then
						e:TakeDamage(5.5/((fam.Position - e.Position):Length() + fam.Player:GetNumCoins()/10), 0, EntityRef(fam),10)
					end
				end
				if spr:GetFrame() == 10 then
					for i, e in pairs(Isaac.GetRoomEntities()) do
						if e.Type == EntityType.ENTITY_PROJECTILE then
							if (fam.Position - e.Position):Length() < 70 then
								e:Die()
							end
						end
					end
					InutilLib.SFX:Play( SoundEffect.SOUND_MEAT_IMPACTS, 0.7, 0, false, 1 );
				end
			end
			if InutilLib.IsFinishedMultiple(spr, "SideAttack", "FrontAttack", "BackAttack") then
				if fam.SubType == 5 and math.random(1,5) == 5 then
					spr:Play("SpinAttack", true)
				else
					spr:Play("Front", true)
				end
			end	
			if spr:IsPlaying("SpinAttack") then
				if spr:GetFrame() >= 6 and spr:GetFrame() <= 12 then
					local offsetPos = fam.Position - Vector(15,0):Rotated(princessProtectorAngle)
					for i, e in pairs (Isaac.GetRoomEntities()) do
						if e:IsEnemy() and (e.Position - fam.Position):Length() <= 90 then
							e:TakeDamage(5.5/((fam.Position - e.Position):Length() + fam.Player:GetNumCoins()/10), 0, EntityRef(fam),10)
						end
					end
				end
			elseif spr:IsFinished("SpinAttack") then
				for i = 0, 360, 360/8 do
					local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.SWORD_BEAM, 0, fam.Position, Vector.FromAngle(i):Resized(10), player):ToTear() --feather attack
					InutilLib.AddHomingIfBabyBender(player, tear)
				end
				spr:Play("Front", true)
			end
		elseif fam.SubType == 3 then
			--fam:AddToOrbit(15)
			--fam.OrbitDistance = Vector(70,70)
			--fam.OrbitAngleOffset = fam.OrbitAngleOffset+0.02
			--fam.Velocity = fam:GetOrbitPosition(player.Position+player.Velocity) - fam.Position	
			InutilLib.MoveOrbitAroundTargetType1(fam, player, 15, 0.9, 7, 0)	
			if InutilLib.IsPlayingMultiple(spr, "SideShoot", "FrontShoot", "BackShoot") then
				if spr:GetFrame() == 3 then
					local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.PUPULA, 0, fam.Position, (data.closestproj.Position - fam.Position):Resized(8), player):ToTear() --feather attack
					tear.TearFlags = TearFlags.TEAR_PERSISTENT | TearFlags.TEAR_SHIELDED
					tear.CollisionDamage = 15
					tear.Scale = 2
					InutilLib.AddHomingIfBabyBender(player, tear)
				end

			end
			if InutilLib.IsFinishedMultiple(spr, "SideShoot", "FrontShoot", "BackShoot") then
				spr:Play("Front", true)
			end
		elseif fam.SubType == 6 then
			local target = InutilLib.GetClosestGenericEnemy(fam, 250, RebekahCurse.ENTITY_TINYFELLOW)
			InutilLib.MoveDiagonalTypeI(fam, 4, false, true)
			if target and not target:IsDead() and fam.FrameCount % 30 == 0 then
				local tear = yandereWaifu.FireBarrageTear(fam.Position, (Vector(0, 0) + fam.Velocity/5 + Vector.FromAngle((target.Position - fam.Position):GetAngleDegrees()+math.random(-15,15)):Resized(16)), TearVariant.BLOOD, fam):ToTear()
				tear.CollisionDamage = 3.5 - damageNerf + fam.Player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BFFS)
				InutilLib.AddHomingIfBabyBender(player, tear)
			end
			if fam.FrameCount % 15 == 0 then
				local stray = yandereWaifu.FireBarrageTear(fam.Position, Vector.Zero, TearVariant.BLOOD, fam):ToTear()
				stray.CollisionDamage = 5 - damageNerf + fam.Player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BFFS)
				InutilLib.AddHomingIfBabyBender(player, stray)
			end
		elseif fam.SubType ~= 2 then
			fam.Velocity = (neededPosition - fam.Position)*0.4;
		end
		--blocking code
		--print(tostring(data.TimesBlocked))
		--if data.TimesBlocked and data.TimesBlocked >= 10 then --slam code
		--if not InutilLib.game:GetRoom():IsClear() then
		--	if fam.FrameCount % 270 == 0 then
		--		spr:Play("CMASlamAWTTJam")
		--		data.TimesBlocked = 0
		--	end
		--end
	end
	
	if spr:IsPlaying("ThrowBomb") then
		if spr:GetFrame() == 10 then
			local rng = math.random(1,5)
			local vel = (data.target.Position - fam.Position)
			if rng == 1 then
				local bomb = Isaac.Spawn(EntityType.ENTITY_BOMBDROP, BombVariant.BOMB_SAD, 0, fam.Position, Vector.FromAngle(vel:GetAngleDegrees()):Resized( 9 ), fam.Player):ToBomb()
				bomb:AddTearFlags(TearFlags.TEAR_SAD_BOMB)
				InutilLib.AddHomingIfBabyBender(player, bomb)
			elseif rng == 2 then
				local bomb = Isaac.Spawn(EntityType.ENTITY_BOMBDROP, BombVariant.BOMB_HOT, 0, fam.Position, Vector.FromAngle(vel:GetAngleDegrees()):Resized( 9 ), fam.Player):ToBomb()
				bomb:AddTearFlags(TearFlags.TEAR_BURN)
				InutilLib.AddHomingIfBabyBender(player, bomb)
			else
				local bomb = Isaac.Spawn(EntityType.ENTITY_BOMBDROP, BombVariant.BOMB_TROLL, 0, fam.Position, Vector.FromAngle(vel:GetAngleDegrees()):Resized( 9 ), fam.Player):ToBomb()
				InutilLib.AddHomingIfBabyBender(player, bomb)
			end
		end
	elseif spr:IsFinished("ThrowBomb") then
		spr:Play("Front", true)
	end
	--end
	if spr:IsPlaying("CMASlamAWTTJam") then --slam stun code
		data.closestDist = 177013 --saved Dist to check who is the closest enemy
		data.target = nil
		if spr:GetFrame() < 22 then
			for i, e in pairs(Isaac.GetRoomEntities()) do
				if e.Type ~= EntityType.ENTITY_PLAYER then
					if e:IsActiveEnemy() then
						if e:IsVulnerableEnemy() then
							if (fam.Position - e.Position):Length() < 500 then
								if (fam.Position - e.Position):Length() <= data.closestDist then
									data.target = e
									data.closestDist = (fam.Position - e.Position):Length()
								end							
							end
						end
					end
				end
			end
			if data.target and not data.target:IsDead() then
				fam.Velocity =(data.target.Position - fam.Position)*0.4;
			end
		end
		if spr:GetFrame() == 22 then
			for i, e in pairs(Isaac.GetRoomEntities()) do
				if e:IsVulnerableEnemy() then
					if (fam.Position - e.Position):Length() <= 100 then
						e:AddConfusion(EntityRef(fam), math.random(10,30), false)
						e:TakeDamage(2.5 - damageNerf/((fam.Position - e.Position):Length() + fam.Player:GetNumCoins()/10), 0, EntityRef(fam),10)
					end
				end
			end
			InutilLib.game:ShakeScreen(5);
			InutilLib.SFX:Play( SoundEffect.SOUND_FORESTBOSS_STOMPS, 1, 0, false, 1 );
			yandereWaifu.SpawnPoofParticle( player.Position, Vector( 0, 0 ), player, RebekahPoofParticleType.Gold );
		end
		fam.Velocity = fam.Velocity * 0.9
	end
	--no need to set anim after this animation because it is automatic apparently

	
end, RebekahCurse.ENTITY_DEFENDINGNED);

function yandereWaifu:LevelUpNeds()
	for p = 0, InutilLib.game:GetNumPlayers() - 1 do
		local canUpgrade = false
		local player = Isaac.GetPlayer(p)
		if yandereWaifu.IsNormalRebekah(player) and yandereWaifu.GetEntityData(player).currentMode == REBECCA_MODE.GoldHearts then
			canUpgrade = true
	--		break
		end
		
	--for p = 0, InutilLib.game:GetNumPlayers() - 1 do
	--	local player = Isaac.GetPlayer(p)
		if canUpgrade then
			local potentialKnights = {
				[1] = false, --RebekahCurse.ENTITY_CHRISTIANNED
				[2] = false, --RebekahCurse.ENTITY_SCREAMINGNED
				[3] = false, --RebekahCurse.ENTITY_BARBARICNED
				[4] = false, --RebekahCurse.ENTITY_DEFENDINGNED
				[5] = false --squire
			}
			local AvailableKnights = {
				[0] = {},
				[1] = {},
				[2] = {},
				[3] = {},
				[4] = {},
				[5] = {},
				[6] = {},
				[20] = {}
			}
			--print("fff"..tostring(AvailableKnights[0][1]))
			--print(AvailableKnights[1][1])
			for c, ned in pairs( Isaac.GetRoomEntities() ) do
				if ned.Type == 3 then
					--check for knights system
					if GetPtrHash(ned:ToFamiliar().Player:ToPlayer()) == GetPtrHash(player) then
						--print(ned.SubType)
						for i = 0, 50 do
							if ned.SubType == i then
								--print(ned.SubType.."  "..i)
								if ned.Variant == RebekahCurse.ENTITY_CHRISTIANNED then AvailableKnights[i][1] = true end
								if ned.Variant == RebekahCurse.ENTITY_SCREAMINGNED then AvailableKnights[i][2] = true end
								if ned.Variant == RebekahCurse.ENTITY_BARBARICNED then AvailableKnights[i][3] = true end
								if ned.Variant == RebekahCurse.ENTITY_DEFENDINGNED then AvailableKnights[i][4]  = true end
							end
						end
						--print("hel"..tostring(AvailableKnights[0][1]))
						--print(AvailableKnights[1][1])
						--print(AvailableKnights[4][1])
					end
				end
				--rank up system
			end
			for n, ned in pairs( Isaac.FindByType(EntityType.ENTITY_FAMILIAR, -1, -1, false, false) ) do
				if GetPtrHash(ned:ToFamiliar().Player:ToPlayer()) == GetPtrHash(player) then
					if ned.Variant == RebekahCurse.ENTITY_NED_NORMAL then
						local squire = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, RebekahCurse.ENTITY_SQUIRENED, ned.SubType, ned.Position, Vector(0,0), ned);
						--local squire = InutilLib.game:Spawn( EntityType.ENTITY_FAMILIAR, RebekahCurse.ENTITY_SQUIRENED, ned.Position, Vector( 0, 0 ), ned, 0, 0);
						ned:Remove()
					elseif ned.Variant == RebekahCurse.ENTITY_SQUIRENED then
						for s = 0, 50 do
							if ned.SubType == s and AvailableKnights[ned.SubType] then
								print(ned.SubType)
								--print("amogus"..ned.SubType)
								--print(AvailableKnights[1][4])
								--print(AvailableKnights[4][4])
								local rng = math.random(1, 10)
								if --[[rng >= 0 and rng <= 2]] not AvailableKnights[ned.SubType][4] then
									local defender =  Isaac.Spawn(EntityType.ENTITY_FAMILIAR, RebekahCurse.ENTITY_DEFENDINGNED, ned.SubType, ned.Position, Vector(0,0), ned.Player):ToFamiliar();
									AvailableKnights[ned.SubType][4] = true
									defender:AddToFollowers()
									ned:Remove()
									break
									--print("1")
								elseif --[[rng >= 3 and rng <= 4]] not AvailableKnights[ned.SubType][3] then
									local jugger =  Isaac.Spawn(EntityType.ENTITY_FAMILIAR, RebekahCurse.ENTITY_BARBARICNED, ned.SubType, ned.Position, Vector(0,0), ned.Player):ToFamiliar();
									AvailableKnights[ned.SubType][3] = true
									jugger:AddToFollowers()
									ned:Remove()
									break
								elseif --[[rng >= 5 and rng <= 6]] not AvailableKnights[ned.SubType][2] then
									local command =  Isaac.Spawn(EntityType.ENTITY_FAMILIAR, RebekahCurse.ENTITY_SCREAMINGNED, ned.SubType, ned.Position, Vector(0,0), ned.Player):ToFamiliar();
									AvailableKnights[ned.SubType][2] = true
									command:AddToFollowers()
									ned:Remove()
									--print("3")
									break
								elseif --[[rng >= 7 and rng <= 10]] not AvailableKnights[ned.SubType][1] then
									local christian =  Isaac.Spawn(EntityType.ENTITY_FAMILIAR, RebekahCurse.ENTITY_CHRISTIANNED, ned.SubType, ned.Position, Vector(0,0), ned.Player):ToFamiliar();
									--local christian = InutilLib.game:Spawn( EntityType.ENTITY_FAMILIAR, RebekahCurse.ENTITY_CHRISTIANNED, ned.Position, Vector( 0, 0 ), ned, 0, 0);
									AvailableKnights[ned.SubType][1] = true
									christian:AddToFollowers()
									ned:Remove()
									--print("4")
									break
								end
							end
						end
					end
				end
			end
		end
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, yandereWaifu.LevelUpNeds)