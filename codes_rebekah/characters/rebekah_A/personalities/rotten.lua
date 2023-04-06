
--ROTTEN HEART--
do

function yandereWaifu.RottenTossHead(player, vector)
	local playerdata = yandereWaifu.GetEntityData(player)
	local trinketBonus = 0
	if player:HasTrinket(RebekahCurse.Trinkets.TRINKET_ISAACSLOCKS) then
		trinketBonus = 5
	end
	playerdata.IsDashActive = true
	if not playerdata.noHead then
		local head = Isaac.Spawn( EntityType.ENTITY_FAMILIAR, RebekahCurse.ENTITY_ROTTENHEAD, 0, player.Position, vector:Resized(15), player):ToFamiliar();
		playerdata.noHead = true
		playerdata.RebHead = head
		
		for i, v in pairs (playerdata.RottenFlyTable) do
			--if not v:IsDead() and v:Exists() then
				yandereWaifu.GetEntityData(v).Parent = head
			--end
		end
		
		playerdata.extraHeadsPresent = false
		--code that checks if extra heads exist
		for i, v in pairs (Isaac.GetRoomEntities()) do
			if v.Type == EntityType.ENTITY_FAMILIAR then
				if v.Variant == FamiliarVariant.SCISSORS or v.Variant == FamiliarVariant.DECAP_ATTACK then
					playerdata.extraHeadsPresent = true
					--print("Something wrong")
				end
			end
		end
		if playerdata.extraHeadsPresent == false then
			--player:AddNullCostume(RebekahCurse.Costumes.HeadlessHead)
			player:AddNullCostume(RebekahCurse.Costumes.BloodGush)
		else
			player:AddNullCostume(RebekahCurse.Costumes.SkinlessHead)
			yandereWaifu.ApplyCostumes( yandereWaifu.GetEntityData(player).currentMode, player , false, false)
		end

		playerdata.specialCooldown = RebekahCurse.REBEKAH_BALANCE.ROTTEN_HEARTS_DASH_COOLDOWN - trinketBonus;
		playerdata.IsDashActive = false
	else
		if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) then
			local target = Isaac.Spawn( EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_ROTTENBIRTHRIGHTTARGET, 0, playerdata.RebHead.Position, Vector(0,0), player):ToEffect(); --heart effect
			yandereWaifu.GetEntityData(target).Parent = player
		else
			playerdata.RebHead.Velocity = vector:Resized(15)
			playerdata.IsDashActive = false
		end
		playerdata.specialCooldown = RebekahCurse.REBEKAH_BALANCE.ROTTEN_HEARTS_DASH_COOLDOWN - trinketBonus;
		yandereWaifu.GetEntityData(playerdata.RebHead).PickupFrames = 30
	end
	for i, v in pairs(playerdata.RottenFlyTable) do
		--if not v:IsDead() or v:Exists() then
			v.Velocity = v.Velocity + vector:Resized( RebekahCurse.REBEKAH_BALANCE.ROTTEN_HEARTS_DASH_SPEED );
			yandereWaifu.GetEntityData(v).SpecialDash = true
		--end
	end
	for i, entity in pairs(Isaac.GetRoomEntities()) do
		if entity.Type == EntityType.ENTITY_FAMILIAR and entity.Variant == ENTITY_ROTTENFLYBALL then
			if GetPtrHash(entity:ToFamiliar().Player) == GetPtrHash(player) then
				entity.Velocity = entity.Velocity + vector:Resized( RebekahCurse.REBEKAH_BALANCE.ROTTEN_HEARTS_DASH_SPEED );
				yandereWaifu.GetEntityData(entity).SpecialDash = true
			end
		end
	end
	
end

function yandereWaifu.RebekahRottenBarrage(player, direction)
	local data = yandereWaifu.GetEntityData(player)
	--[[if not data.noHead then
		local head = Isaac.Spawn( EntityType.ENTITY_FAMILIAR, RebekahCurse.ENTITY_ROTTENHEAD, 0, player.Position, direction:Resized(10), player):ToFamiliar();
		data.noHead = true
		data.RebHead = head
		
		for i, v in pairs (data.RottenFlyTable) do
			--if not v:IsDead() and v:Exists() then
				yandereWaifu.GetEntityData(v).Parent = head
			--end
		end
		
		data.extraHeadsPresent = false
		--code that checks if extra heads exist
		for i, v in pairs (Isaac.GetRoomEntities()) do
			if v.Type == EntityType.ENTITY_FAMILIAR then
				if v.Variant == FamiliarVariant.SCISSORS or v.Variant == FamiliarVariant.DECAP_ATTACK then
					data.extraHeadsPresent = true
					print("Something wrong")
				end
			end
		end
		if data.extraHeadsPresent == false then
			player:AddNullCostume(RebekahCurse.Costumes.HeadlessHead)
		else
			player:AddNullCostume(RebekahCurse.Costumes.SkinlessHead)
			yandereWaifu.ApplyCostumes( yandereWaifu.GetEntityData(player).currentMode, player , false)
		end
	else]]
	local pos
	if data.RebHead and not data.RebHead:IsDead() then pos = data.RebHead.Position else pos = player.Position end
	local subtype = 0
	if player:HasWeaponType(WeaponType.WEAPON_BOMBS) then subtype = 1 end
	if player:HasWeaponType(WeaponType.WEAPON_BRIMSTONE) then subtype = 2 end
	if player:HasWeaponType(WeaponType.WEAPON_LASER) or player:HasWeaponType(WeaponType.WEAPON_TECH_X) then subtype = 3 end
	if player:HasWeaponType(WeaponType.WEAPON_ROCKETS) then subtype = 4 end
	if player:HasWeaponType(WeaponType.WEAPON_KNIFE) then 
		if TaintedTreasure and player:HasCollectible(TaintedCollectibles.THE_BOTTLE) then
			subtype = 21
		else
			subtype = 5 
		end
	end
	if player:HasWeaponType(WeaponType.WEAPON_SPIRIT_SWORD) then subtype = 6 end
	if player:HasWeaponType(WeaponType.WEAPON_FETUS) then subtype = 7 end
	if #Isaac.FindByType( EntityType.ENTITY_FAMILIAR, RebekahCurse.ENTITY_ROTTENFLYBALL, -1 ) < 8 then
		local ball = Isaac.Spawn( EntityType.ENTITY_FAMILIAR, RebekahCurse.ENTITY_ROTTENFLYBALL, subtype, pos, direction, player):ToFamiliar()
	else
		SFXManager():Play(SoundEffect.SOUND_BOSS2INTRO_ERRORBUZZ, 0.7333333)
		 addReserveStocks(player, 1)
		return
	end
	--end
end


--bazook rotten gun effect
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	if eff.SubType == 7 then
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
				InutilLib.SFX:Play(RebekahCurse.Sounds.SOUND_ETERNALJINGLE, 1, 0, false, 1+(data.StartCountFrame/5))
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
				InutilLib.SFX:Play(RebekahCurse.Sounds.SOUND_ETERNALJINGLE, 1, 0, false, 0.5)
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
				InutilLib.SFX:Play(RebekahCurse.Sounds.SOUND_ETERNALJINGLE, 1, 0, false, 0.8)
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
					InutilLib.SFX:Play(RebekahCurse.Sounds.SOUND_ETERNALJINGLE, 1, 0, false, 1)
				elseif data.Medium then
					InutilLib.SFX:Play(RebekahCurse.Sounds.SOUND_ETERNALJINGLE, 1, 0, false, 1)
				end
			end
			data.Shoot = false
		end
		
		--sounds
		--[[if InutilLib.IsPlayingMultiple(sprite, "ShootRight", "ShootLeft", "ShootDown", "ShootUp") then
			if sprite:GetFrame() == 0 then
				InutilLib.SFX:Play(RebekahCurse.Sounds.SOUND_REDSHOTMEDIUM, 1, 0, false, 1)
			end
		end]]
		if InutilLib.IsPlayingMultiple(sprite, "ShootRightDr", "ShootLeftDr", "ShootDownDr", "ShootUpDr") then
			if sprite:GetFrame() == 12 then
				InutilLib.SFX:Play(RebekahCurse.Sounds.SOUND_ETERNALJINGLE, 1, 0, false, 1)
			end
		end
		if InutilLib.IsPlayingMultiple(sprite, "ShootRightTechGo", "ShootLeftTechGo", "ShootDownTechGo", "ShootUpTechGo") then
			if sprite:GetFrame() == 0 then
				InutilLib.SFX:Play(RebekahCurse.Sounds.SOUND_ETERNALJINGLE, 1, 0, false, 1)
			end
		end
	end
end, RebekahCurse.ENTITY_REBEKAHENTITYWEAPON);

function yandereWaifu.resetRottenHead(player)
	yandereWaifu.GetEntityData(player).noHead = false
	yandereWaifu.GetEntityData(player).extraHeadsPresent = false
	player:TryRemoveNullCostume(RebekahCurse.Costumes.HeadlessHead)
	player:TryRemoveNullCostume(RebekahCurse.Costumes.BloodGush)
	player:TryRemoveNullCostume(RebekahCurse.Costumes.SkinlessHead)
	--print(yandereWaifu.GetEntityData(player).extraHeadsPresent)
	yandereWaifu.ApplyCostumes( yandereWaifu.GetEntityData(player).currentMode, player , false)
end

function yandereWaifu:onFamiliarOllieHeadInit(fam)
    fam.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
	fam.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
	local data = yandereWaifu.GetEntityData(fam)
    local sprite = fam:GetSprite()
	yandereWaifu.GetEntityData(fam.Player).noHead = true
	yandereWaifu.GetEntityData(fam.Player).RebHead = fam
	yandereWaifu.GetEntityData(fam).PickupFrames = 0
end
yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, yandereWaifu.onFamiliarOllieHeadInit, RebekahCurse.ENTITY_ROTTENHEAD);

function yandereWaifu.rottenheadColl(_, fam, collider, low)
	local data = yandereWaifu.GetEntityData(fam)
	if fam.FrameCount > 5 then
		if collider.Type == EntityType.ENTITY_PLAYER or collider.Type == EntityType.ENTITY_TEAR then -- someEngineer's code, thanks!
			if data.PickupFrames > 0 and GetPtrHash(collider) == GetPtrHash(fam.Player) then
				fam:Kill()
				yandereWaifu.resetRottenHead(fam.Player)
				for i, v in pairs (yandereWaifu.GetEntityData(fam.Player).RottenFlyTable) do
					--if v:IsDead() or not v:Exists() then
						yandereWaifu.GetEntityData(v).Parent = fam.Player
					--end
				end
				
				yandereWaifu.GetEntityData(fam.Player).RebHead = nil
			else
				local vec = fam.Position-collider.Position
				fam.Velocity = vec:Resized(10)
			end
		end
	end
end

yandereWaifu:AddCallback(ModCallbacks.MC_PRE_FAMILIAR_COLLISION, yandereWaifu.rottenheadColl, RebekahCurse.ENTITY_ROTTENHEAD)

yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_,  fam) --bone stand
	local spr = fam:GetSprite()
	local rng = math.random(1, 100)
	local player = fam.Player:ToPlayer()
	local data = yandereWaifu.GetEntityData(fam)
	local body = data.Body
	local butt = data.Butt
	local controller = player.ControllerIndex
	
	if fam.Velocity:Length() > 2 then
		if not data.headFrame then data.headFrame = 0 end
		if data.headFrame < 11 then
			--print(math.ceil(player.MaxFireDelay/4))
			if fam.FrameCount % (math.ceil(player.MaxFireDelay/10)) == 0 then --was 4?
				local tears = player:FireTear(fam.Position, Vector.FromAngle(30*(data.headFrame+3)):Resized(10), false, false, false):ToTear()
				tears.Position = fam.Position
				
				data.headFrame = data.headFrame + 1
			end
			spr:Play("Shake"..tostring(data.headFrame))
		else
			data.headFrame = 0
		end
	else
		if player:HasCollectible(CollectibleType.COLLECTIBLE_MARKED) then
			local direction = player:GetAimDirection()
			if (direction.X ~= 0 or direction.Y ~= 0) then
				--[[if fam.FrameCount % (math.ceil(player.MaxFireDelay/10)) == 0 then --was 4?
					local tears = player:FireTear(fam.Position, (Vector(direction.X - fam.Position.X, direction.Y - fam.Position.Y)):Resized(10), false, false, false):ToTear()
					tears.Position = fam.Position
					
				end
				spr:Play("Shake0")]]
				if not data.headFrame then data.headFrame = 0 end
					if data.headFrame < 11 then
						--print(math.ceil(player.MaxFireDelay/4))
						if fam.FrameCount % (math.ceil(player.MaxFireDelay/2)) == 0 then --was 4?
							local tears = player:FireTear(fam.Position, Vector.FromAngle(30*(data.headFrame+3)):Resized(10), false, false, false):ToTear()
							tears.Position = fam.Position
							
							data.headFrame = data.headFrame + 1
						end
						spr:Play("Shake"..tostring(data.headFrame))
					else
						data.headFrame = 0
				end
			end
		elseif (player:GetShootingInput().X ~= 0 or player:GetShootingInput().Y ~= 0) and not spr:IsPlaying("Shoot") then
			if player:GetFireDirection() == 3 then --down
				spr:Play("Shake0")
				data.headFrame = 0
			elseif player:GetFireDirection() == 1 then --up
				spr:Play("Shake6")
				data.headFrame = 6
			elseif player:GetFireDirection() == 0 then --left
				spr:Play("Shake3")
				data.headFrame = 3
			elseif player:GetFireDirection() == 2 then --right
				spr:Play("Shake9")
				data.headFrame = 9
			end
			
			if fam.FrameCount % (math.ceil(player.MaxFireDelay) or 1) == 0 then
				local tears = player:FireTear(fam.Position, Vector.FromAngle(30*(data.headFrame+3)):Resized(8), false, false, false):ToTear()
				tears.Position = fam.Position
				--tears:ChangeVariant(RebekahCurse.ENTITY_MAGGOTTEAR)
			end
			if fam.FrameCount % 5 == 0 and math.random(1,10) == 10 and player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) then
				spr:Play("Shoot", true)
			end
		end
	end
	fam.Velocity = fam.Velocity * 0.95 --friction
	
	if data.PickupFrames then
		data.PickupFrames = data.PickupFrames - 1
	end
	
	if spr:IsPlaying("Shoot") and spr:GetFrame() == 14 then
		--local fly = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, RebekahCurse.ENTITY_FLYTEAR, 0, fam.Position, Vector(0,0), player)
		--player:AddSwarmFlyOrbital(fam.Position)
		local fly = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLUE_FLY, 0, fam.Position, Vector(0,0), fam)
	end
	if spr:IsFinished("Shoot") then
		spr:Play("Shake0")
	end
	--blood effect
	if math.random(1,10) == 10 and player.FrameCount % 5 == 0 then
		local puddle = Isaac.Spawn(EntityType.ENTITY_EFFECT, 7, math.random(0,1), fam.Position, Vector(0,0), fam)
	end

	--death code
	if fam.FrameCount == 2300 then --2300
		fam:Kill()
		yandereWaifu.resetRottenHead(player)
		
		for i, v in pairs (yandereWaifu.GetEntityData(player).RottenFlyTable) do
			--if v:IsDead() or not v:Exists() then
				yandereWaifu.GetEntityData(v).Parent = player
			--end
		end
		
		yandereWaifu.GetEntityData(fam.Player).RebHead = nil
	end
end, RebekahCurse.ENTITY_ROTTENHEAD);

function yandereWaifu:RottenHeartTearsRender(tr, _)
	if tr.Variant == RebekahCurse.ENTITY_MAGGOTTEAR then
		local player, data, flags, scale = tr.Parent, yandereWaifu.GetEntityData(tr), tr.TearFlags, tr.Scale 
		if not data.Init then
			data.Init = true
			tr:GetSprite():Play("Bullet", true)
		end
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_POST_TEAR_RENDER, yandereWaifu.RottenHeartTearsRender)

function yandereWaifu:MaggotTearUpdate(tr)
	local data = yandereWaifu.GetEntityData(tr)
	local player = tr.SpawnerEntity
	if tr.Variant == RebekahCurse.ENTITY_MAGGOTTEAR then
		if tr:IsDead() then
			--local maggot = Isaac.Spawn(EntityType.ENTITY_SMALL_MAGGOT, ENTITY_ROTTENSMALLMAGGOT, 0, tr.Position, Vector(0,0), player)
			--maggot:AddEntityFlags(EntityFlag.FLAG_FRIENDLY)
		end
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, yandereWaifu.MaggotTearUpdate)

--fire to spawn familiar fly
yandereWaifu:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function(_,player)
	local data = yandereWaifu.GetEntityData(player)
	
	if yandereWaifu.IsNormalRebekah(player) and yandereWaifu.GetEntityData(player).currentMode == RebekahCurse.REBECCA_MODE.RottenHearts then
		if not data.RottenFlyTable then 
			data.RottenFlyTable = {} 
			
			--reassign when quitting out of game
			for i, v in ipairs(InutilLib.roomEntities) do
				if v.Type == 3 and v.Variant == RebekahCurse.ENTITY_ROTTENFLY then
					if GetPtrHash(v:ToFamiliar().Player:ToPlayer()) == GetPtrHash(player) then
						table.insert(data.RottenFlyTable, v)
					end
				end
			end
			--[[if TableLength(data.RottenFlyTable) > 0 then
					print(TableLength(data.RottenFlyTable))
					local divNum, loopNum = 360/#data.RottenFlyTable, 0
					for j, v in ipairs(data.RottenFlyTable) do
						if not yandereWaifu.GetEntityData(v).StartingPos then
							yandereWaifu.GetEntityData(v).StartingPos = loopNum
							loopNum = loopNum + divNum
						end
					end
			end]]
		end
		if data.noHead then
			if math.random(1,10) == 10 and player.FrameCount % 3 == 0 then
				local puddle = Isaac.Spawn(EntityType.ENTITY_EFFECT, 7, math.random(0,1), player.Position, Vector(0,0), player)
			end
		end
		
		if not data.RottenFireDelay then data.RottenFireDelay = player.MaxFireDelay end
		if data.RottenFireDelay > 0 then
			data.RottenFireDelay = data.RottenFireDelay - 1
		end
		local yourFlies = 0
		for k, v in pairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, RebekahCurse.ENTITY_ROTTENFLY, -1)) do
			if GetPtrHash(v:ToFamiliar().Player) == GetPtrHash(player) then
				yourFlies = yourFlies + 1
			end
		end
		--print(data.RottenFireDelay)
		local canShoot = yourFlies < 8 and ((player:HasCollectible(CollectibleType.COLLECTIBLE_MARKED) and player:GetAimDirection().X ~= 0 or player:GetAimDirection().Y ~= 0 ) or(player:GetShootingInput().X ~= 0 or player:GetShootingInput().Y ~= 0)) and data.RottenFireDelay <= 0
		if canShoot then
			data.RottenFireDelay = player.MaxFireDelay --resets the firedelay
		--if player.FireDelay <= 1 and not data.HasJustShot then
		
			if math.random(1,40) - player.Luck*2 <= 1 then -- a chance to spawn flies
				local fly = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, RebekahCurse.ENTITY_ROTTENFLY, 0, player.Position, Vector(0,0), player)
				table.insert(data.RottenFlyTable, fly)
				--[[if TableLength(data.RottenFlyTable) > 0 then
					local divNum, loopNum = 360/#data.RottenFlyTable, 0
					for j, v in ipairs(data.RottenFlyTable) do
						if not yandereWaifu.GetEntityData(v).StartingPos then
							yandereWaifu.GetEntityData(v).StartingPos = loopNum
							--print(yandereWaifu.GetEntityData(v).StartingPos, "    ",j)
							loopNum = loopNum + divNum
						end
					end
				end]]
			end
			--if you have marked
			if	player:HasCollectible(CollectibleType.COLLECTIBLE_MARKED) then
				if math.random(1,30) - player.Luck*2 <= 1 then -- a chance to spawn flies
					local fly = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, RebekahCurse.ENTITY_FLYTEAR, 20, player.Position, Vector(0,0), player)
				end
			end
			--if player:GetShootingInput().X ~= 0 or player:GetShootingInput().Y ~= 0 then
				--if player.FireDelay == player.MaxFireDelay then
					if yandereWaifu.GetEntityData(player).RottenHiveTable then
						--print(TableLength( yandereWaifu.GetEntityData(player).RottenHiveTable))
						if TableLength( yandereWaifu.GetEntityData(player).RottenHiveTable) > 0 then
							local fireDir = player:GetShootingInput()
							local ball
							for k, v in pairs ( yandereWaifu.GetEntityData(player).RottenHiveTable) do
								if k == 1 then
									ball = v
									yandereWaifu.GetEntityData(ball).Hidden = false
									table.remove( yandereWaifu.GetEntityData(player).RottenHiveTable, k)
									break
								end
							end
							ball.Position = player.Position
							ball.Velocity = ball.Velocity + fireDir:Resized(20)
							--print(ball.Velocity)
						end
					end
				--end
			--end
			--data.HasJustShot  = true
		end
		--if player.FireDelay > 1 then
		--	data.HasJustShot  = false
		--end
	end
	--print(TableLength(data.RottenFlyTable))
	--print(#data.RottenFlyTable)
end)
function yandereWaifu:onFamiliarRottenFlyInit(fam)
	if #Isaac.FindByType(fam.Type, 62690, -1) + #Isaac.FindByType(3, 43, -1) > 64 --[[blue fly]] and fam.Variant == 62690 then fam:Remove() end
	local player = fam.Player:ToPlayer()
    fam.CollisionDamage = 1
	if fam.SubType == 1 then
		fam:GetSprite():Load("gfx/effects/rotten/fly_orbital_pooter.anm2", true)
		fam:GetSprite():LoadGraphics()
		fam:GetSprite():Play("Idle", true)
	end
	if fam.SubType == 2 then
		fam:GetSprite():Load("gfx/effects/rotten/fly_orbital_pooter2.anm2", true)
		fam:GetSprite():LoadGraphics()
		fam:GetSprite():Play("Idle", true)
	end
	if fam.SubType == 3 then
		fam:GetSprite():Load("gfx/effects/rotten/fly_orbital_pooter3.anm2", true)
		fam:GetSprite():LoadGraphics()
		fam:GetSprite():Play("Idle", true)
	end
	if fam.SubType == 4 then
		fam:GetSprite():Load("gfx/effects/rotten/fly_orbital_pooter4.anm2", true)
		fam:GetSprite():LoadGraphics()
		fam:GetSprite():Play("Idle", true)
	end
	if fam.SubType == 5 then
		fam:GetSprite():Load("gfx/effects/rotten/fly_orbital_pooter5.anm2", true)
		fam:GetSprite():LoadGraphics()
		fam:GetSprite():Play("Idle", true)
	end
	if fam.SubType == 10 then
		fam:GetSprite():Load("gfx/effects/rotten/fly_orbital_big.anm2", true)
		fam:GetSprite():LoadGraphics()
		fam:GetSprite():Play("Idle", true)
		fam.CollisionDamage = 2
	end
	 fam:AddToOrbit(2)
end
yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, yandereWaifu.onFamiliarRottenFlyInit, RebekahCurse.ENTITY_ROTTENFLY);
function yandereWaifu.rottenFlyColl(_, fam, collider, low)
	local data = yandereWaifu.GetEntityData(fam.Player:ToPlayer())
	local function Die()
		for i, v in pairs (data.RottenFlyTable) do
			if not v:Exists() then
				table.remove(data.RottenFlyTable, i)
			end
		end
		fam:Die()
	end
	local data = yandereWaifu.GetEntityData(fam)
	if collider.Type == EntityType.ENTITY_PROJECTILE then -- stop enemy bullets
		collider:Die()
		Die()
	elseif collider:IsVulnerableEnemy() and not collider:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
		--if fam.FrameCount % 3 == 0 then
			Die()
		--end
	end
end

yandereWaifu:AddCallback(ModCallbacks.MC_PRE_FAMILIAR_COLLISION, yandereWaifu.rottenFlyColl, RebekahCurse.ENTITY_ROTTENFLY)

yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_,  fam) --rotten fly orbital
	local spr = fam:GetSprite()
	local rng = math.random(1, 100)
	local player = fam.Player:ToPlayer()
	local data = yandereWaifu.GetEntityData(fam)
	local controller = player.ControllerIndex
	
	
	if not data.Parent then data.Parent = player end
	if not data.Health then
		if fam.SubType == 10 then
			data.Health = 30
		else
			data.Health = 3
		end
	end	
	--if not data.StartingPos then data.StartingPos = 0 end
	if data.SpecialDash then
		if not data.StopFrames then
			data.StopFrames = fam.FrameCount + 14
		else
			if data.StopFrames == fam.FrameCount then
				data.SpecialDash = nil
				data.StopFrames = nil
			end
		end
		fam.Velocity = fam.Velocity * 0.9
	else
		--InutilLib.MoveOrbitAroundTargetType1(fam, data.Parent, 3, 0.9, 5, data.StartingPos)
		fam.Velocity = (fam:GetOrbitPosition(player.Position+player.Velocity) - fam.Position)*0.2
	end
	
	local target
	local nearestOrb = 177013 -- labels the highest enemy hp
	for i, ent in pairs (Isaac.GetRoomEntities()) do
		if ent:IsVulnerableEnemy() and not ent:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
			if ent.Position:Distance(player.Position) < 200 then
				if nearestOrb >= ent.Position:Distance(player.Position) then
					nearestOrb = ent.Position:Distance(player.Position)
					target = ent
				end
			end
		end
	end
	if target and math.random(1,30) == 30 then
		if fam.SubType == 0 then
			if fam.FrameCount >= 300 and math.random(1,3) == 3 and fam.FrameCount % 3 == 0 then
				local subtype = 1
				if player:HasCollectible(CollectibleType.COLLECTIBLE_POLYPHEMUS) or player.Damage >= 20 and math.random(1,3) == 3 then
					subtype = 10
				end
				
				if (player:HasCollectible(CollectibleType.COLLECTIBLE_THE_WIZ) or player:HasCollectible(CollectibleType.COLLECTIBLE_20_20)) and math.random(1,2) == 2 then
					subtype = 2
				end
				if player:HasCollectible(CollectibleType.COLLECTIBLE_INNER_EYE) and math.random(1,3) == 3 then
					subtype = 3
				end
				if player:HasCollectible(CollectibleType.COLLECTIBLE_MUTANT_SPIDER) and math.random(1,3) == 3 then
					subtype = 4
				end
				if player:HasCollectible(CollectibleType.COLLECTIBLE_MONSTROS_LUNG) and math.random(1,3) == 3 then
					subtype = 5
				end
				local new = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, RebekahCurse.ENTITY_ROTTENFLY, subtype, fam.Position, Vector.Zero, player):ToFamiliar()
				fam:Remove()
				--yandereWaifu.GetEntityData(v).StartingPos = data.StartingPos
				table.insert(yandereWaifu.GetEntityData(player).RottenFlyTable, new)
				--[[
				if TableLength(data.RottenFlyTable) > 0 then
					local divNum, loopNum = 360/#data.RottenFlyTable, 0
					for j, v in ipairs(data.RottenFlyTable) do
						if not yandereWaifu.GetEntityData(v).StartingPos then
							yandereWaifu.GetEntityData(v).StartingPos = loopNum
							--print(yandereWaifu.GetEntityData(v).StartingPos, "    ",j)
							loopNum = loopNum + divNum
						end
					end
				end]]
			end
		else
			spr:Play("Attack", true)
		end
	end
	if spr:IsPlaying("Attack") and spr:IsEventTriggered("Shoot") and target then
		if fam.SubType == 1 then
			local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.BLOOD, 0, fam.Position, (target.Position - fam.Position):Resized(15), player):ToTear()
			tear.CollisionDamage = 1.5
		end
		if fam.SubType == 2 then
			for i = -15, 15, 30 do
				local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.BLOOD, 0, fam.Position, (target.Position - fam.Position):Rotated(i):Resized(15), player):ToTear()
				tear.CollisionDamage = 1.5
			end
		end
		if fam.SubType == 3 then
			for i = -15, 15, 15 do
				local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.BLOOD, 0, fam.Position, (target.Position - fam.Position):Rotated(i):Resized(15), player):ToTear()
				tear.CollisionDamage = 1.5
			end
		end
		if fam.SubType == 4 then
			for i = -20, 20, 10 do
				local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.BLOOD, 0, fam.Position, (target.Position - fam.Position):Rotated(i):Resized(15), player):ToTear()
				tear.CollisionDamage = 1.5
			end
		end
		if fam.SubType == 5 then
			local direction = (target.Position - fam.Position)
			local chosenNumofBarrage =  math.random(7,9)
			for i = 1, chosenNumofBarrage do
				local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.BLOOD, 0, fam.Position, Vector.FromAngle(direction:GetAngleDegrees() - math.random(-10,10))*(math.random(5,15)), player):ToTear()
				--local tear = player:FireTear(player.Position, Vector.FromAngle(direction:GetAngleDegrees() - math.random(-10,10))*(math.random(5,15)), false, false, false):ToTear()
				tear.Scale = math.random(07,14)/10
				tear.FallingSpeed = -10 + math.random(1,3)
				tear.FallingAcceleration = 0.5
				tear.CollisionDamage = 1.0
				--tear.BaseDamage = player.Damage * 2
			end
		end
	end
	if spr:IsFinished("Attack") then
		fam:GetSprite():Play("Idle", true)
	end
end, RebekahCurse.ENTITY_ROTTENFLY);


yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local data = yandereWaifu.GetEntityData(eff)
	if data.ByRottenSoulSucker then
		local player = data.Player
		if eff:GetSprite():GetFrame() == 17 then
			for i = 0, 360-360/4, 360/4 do
				--local brim = player:FireBrimstone( Vector.FromAngle( i )):ToLaser();
				local brim = EntityLaser.ShootAngle(1, eff.Position, i, 5, Vector(0,-5), eff):ToLaser()
				brim.Timeout = 5
				brim.CollisionDamage = 0.2	
				brim.Position = eff.Position
				brim.DisableFollowParent = true
				brim.ParentOffset = Vector(0,5)
			end
		end
	end

end, EffectVariant.BRIMSTONE_SWIRL);

function yandereWaifu:onFamiliarRottenFlyHeadInit(fam)
	local player = fam.Player:ToPlayer()
    fam.CollisionDamage = 3.5
	fam.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
	
	if fam.SubType == 1 then
		fam:GetSprite():Load("gfx/effects/rotten/fly_ball_bomb.anm2", true)
		--fam:GetSprite():LoadGraphics()
		fam:GetSprite():Play("Idle", true)
	end
	if fam.SubType == 2 then
		fam:GetSprite():ReplaceSpritesheet(0, "gfx/effects/rotten/cluster/rotten_ball_of_flies_brimstone.png")
		fam:GetSprite():LoadGraphics()
	end
	if fam.SubType == 3 then
		fam:GetSprite():Load("gfx/effects/rotten/fly_ball_tech.anm2", true)
		--fam:GetSprite():LoadGraphics()
		fam:GetSprite():Play("Idle", true)
	end
	if fam.SubType == 4 then
		fam:GetSprite():Load("gfx/effects/rotten/fly_ball_epic.anm2", true)
		--fam:GetSprite():LoadGraphics()
		fam:GetSprite():Play("Idle", true)
	end
	if fam.SubType == 5 then
		fam:GetSprite():ReplaceSpritesheet(0, "gfx/effects/rotten/cluster/rotten_ball_of_flies_knife.png")
		fam:GetSprite():LoadGraphics()
	end
	if fam.SubType == 6 then
		fam:GetSprite():ReplaceSpritesheet(0, "gfx/effects/rotten/cluster/rotten_ball_of_flies_sword.png")
		fam:GetSprite():LoadGraphics()
	end
	if fam.SubType == 7 then
		fam:GetSprite():ReplaceSpritesheet(0, "gfx/effects/rotten/cluster/rotten_ball_of_flies_c_section.png")
		fam:GetSprite():LoadGraphics()
	end
	if fam.SubType == 21 then
		fam:GetSprite():ReplaceSpritesheet(0, "gfx/effects/rotten/cluster/rotten_ball_of_flies_bottle.png")
		fam:GetSprite():LoadGraphics()
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, yandereWaifu.onFamiliarRottenFlyHeadInit, RebekahCurse.ENTITY_ROTTENFLYBALL);

function yandereWaifu.rottenFlyHeadColl(_, fam, collider, low)
	local data = yandereWaifu.GetEntityData(fam)
	local function Die()
		if data.Health < 1 then
			fam:Die()
			for i = 0, math.random(4,9) do
				local fly = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, RebekahCurse.ENTITY_FLYTEAR, 0, fam.Position, Vector(0,0), player)
				yandereWaifu.GetEntityData(fly).RandomOrbit = math.random(0,360)
			end
		else
			data.Health = data.Health - 1
		end
	end
	
	if collider.Type == EntityType.ENTITY_PROJECTILE then -- stop enemy bullets
		collider:Die()
		Die()
	elseif collider:IsVulnerableEnemy() and not collider:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
		if fam.FrameCount % 3 == 0 then
			Die()
		end
	end
end

yandereWaifu:AddCallback(ModCallbacks.MC_PRE_FAMILIAR_COLLISION, yandereWaifu.rottenFlyHeadColl, RebekahCurse.ENTITY_ROTTENFLYBALL)

yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_,  fam) --rotten fly orbital
	local spr = fam:GetSprite()
	local rng = math.random(1, 100)
	local player = fam.Player:ToPlayer()
	local data = yandereWaifu.GetEntityData(fam)
	local controller = player.ControllerIndex
	
	if not data.Hidden then
		fam.Visible = true
		if not data.Health then
			data.Health = 40
		end
		if data.SpecialDash then
			if not data.StopFrames then
				data.StopFrames = fam.FrameCount + 14
			else
				if data.StopFrames == fam.FrameCount then
					data.SpecialDash = nil
					data.StopFrames = nil
				end
			end
		else
			--local  = player:GetMovementInput();
			--if movementDirection:Length() < 0.05 then
				if fam.Velocity:Length() < 1 then
					local pos
					if rng > 35 then
						if not pos then pos = Isaac.GetRandomPosition() end
					end
					if pos then
						InutilLib.MoveRandomlyTypeI(fam, pos, 8, 0.9, 0, 0, 0)
					end
				else
					fam.Velocity = fam.Velocity * 0.9;
				end
				if fam.FrameCount % 30 == 0 and math.random(1,10) == 10 then
					if math.random(1,3) == 3 then
						local customSubType
						if math.random(1,10) + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_LOKIS_HORNS)*3 == 10 then
							customSubType = 10
						end
						if math.random(1,10) + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_IPECAC)*(2 + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_LOKIS_HORNS)) == 10 then
							customSubType = 11
						end
						if math.random(1,10) + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BALL_OF_TAR)*(3 + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_LOKIS_HORNS)) == 10 then
							customSubType = 12
						end
						local fly = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, RebekahCurse.ENTITY_FLYTEAR, customSubType or fam.SubType, fam.Position, Vector(0,0), player)
						yandereWaifu.GetEntityData(fly).RandomOrbit = math.random(0,360)
					else
						local fly = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, RebekahCurse.ENTITY_FLYTEAR, fam.SubType, fam.Position, Vector(0,0), player)
						yandereWaifu.GetEntityData(fly).RandomOrbit = math.random(0,360)
					end
				end
			--else
			--	fam.Velocity = (fam.Velocity * 0.7) + movementDirection:Resized( BALANCE.ROTTEN_HEARTS_FLYBALL_SPEED + player.MoveSpeed );
			--end
		end
		
		if yandereWaifu.GetEntityData(player).currentMode ~= RebekahCurse.REBECCA_MODE.RottenHearts then
			fam:Die()
			for i = 0, math.random(9,15) do
				local fly = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, RebekahCurse.ENTITY_FLYTEAR, 0, fam.Position, Vector(0,0), player)
				yandereWaifu.GetEntityData(fly).RandomOrbit = math.random(0,360)
			end
		end
	else
		fam.Position = Vector(0,0)
		fam.Visible = false
	end
end, RebekahCurse.ENTITY_ROTTENFLYBALL);



function yandereWaifu:onFamiliarRottenFlyTearInit(fam)
	local player = fam.Player:ToPlayer()
	local data = yandereWaifu.GetEntityData(fam)
    fam.CollisionDamage = 2
	if fam.SubType == 1 then
		fam:GetSprite():Load("gfx/effects/rotten/fly_seeker_bomb.anm2", true)
		fam:GetSprite():LoadGraphics()
		fam:GetSprite():Play("Idle", true)
	end
	if fam.SubType == 2 then
		fam:GetSprite():Load("gfx/effects/rotten/fly_seeker_brimstone.anm2", true)
		fam:GetSprite():LoadGraphics()
		fam:GetSprite():Play("Idle", true)
	end
	if fam.SubType == 3 then
		fam:GetSprite():Load("gfx/effects/rotten/fly_seeker_tech.anm2", true)
		fam:GetSprite():LoadGraphics()
		fam:GetSprite():Play("FlyLit", true)
	end
	if fam.SubType == 4 then
		fam:GetSprite():Load("gfx/effects/rotten/fly_seeker_epic.anm2", true)
		fam:GetSprite():LoadGraphics()
		fam:GetSprite():Play("Fly", true)
	end
	if fam.SubType == 5 then
		fam:GetSprite():Load("gfx/effects/rotten/fly_seeker_knife.anm2", true)
		fam:GetSprite():LoadGraphics()
		fam:GetSprite():Play("Fly", true)
		data.Health = 20
		fam.CollisionDamage = 3
	end
	if fam.SubType == 6 then
		fam:GetSprite():Load("gfx/effects/rotten/fly_seeker_sword.anm2", true)
		fam:GetSprite():LoadGraphics()
		fam:GetSprite():Play("Fly", true)
		data.Health = 20
		fam.CollisionDamage = 3
	end
	if fam.SubType == 7 then
		fam:GetSprite():Load("gfx/effects/rotten/fly_seeker_c_section.anm2", true)
		fam:GetSprite():LoadGraphics()
		fam:GetSprite():Play("Idle", true)
		data.Health = 10
	end
	
	if fam.SubType == 10 then
		fam:GetSprite():Load("gfx/effects/rotten/fly_seeker_sucker.anm2", true)
		fam:GetSprite():Play("Idle", true)
	end
	if fam.SubType == 11 then
		fam:GetSprite():Load("gfx/effects/rotten/fly_seeker_spit.anm2", true)
		fam:GetSprite():Play("Idle", true)
	end
	if fam.SubType == 12 then
		fam:GetSprite():Load("gfx/effects/rotten/fly_seeker_ink.anm2", true)
		fam:GetSprite():Play("Idle", true)
	end
	
	if fam.SubType == 21 then
		fam:GetSprite():Load("gfx/effects/rotten/fly_seeker_bottle.anm2", true)
		fam:GetSprite():Play("Fly", true)
	end
	
	fam:AddToOrbit(4)
	
	if not data.Health then
		if fam.SubType == 21 then
			data.Health = 1
		else
			data.Health = 5
		end
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, yandereWaifu.onFamiliarRottenFlyTearInit, RebekahCurse.ENTITY_FLYTEAR);

function yandereWaifu.rottenFlyTearColl(_, fam, collider, low)
	local data = yandereWaifu.GetEntityData(fam.Player:ToPlayer())
	local function Die()
		if yandereWaifu.GetEntityData(fam).Health < 1 then
			fam:Die()
			if fam.SubType == 1 then
				local bomb = Isaac.Spawn(EntityType.ENTITY_BOMBDROP, BombVariant.BOMB_SMALL, 0, fam.Position, Vector(0,0), player)
			end
			if fam.SubType == 2 then
				local brim = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BRIMSTONE_SWIRL, 0, fam.Position, Vector(0,0), player)
				yandereWaifu.GetEntityData(brim).ByRottenSoulSucker = true
				yandereWaifu.GetEntityData(brim).Player = fam.Player
			end
			if fam.SubType == 3 then --tech
				for i = 0, 1 do
					local techlaser = fam.Player:FireTechLaser(fam.Position, 0, Vector.FromAngle(math.random(1,360)), false, true)
					techlaser.OneHit = true;
					techlaser.DisableFollowParent = true
					techlaser.CollisionDamage = 1.5
					techlaser:SetHomingType(1)
				end
			end
			if fam.SubType == 7 then --c section
				for i = 0, 4 do
					local fly = Isaac.Spawn( EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLUE_FLY, 0, fam.Position, Vector.Zero, player):ToFamiliar()
				end
			end
			if fam.SubType == 10 then --sucker
				for i = 0, 360-360/4, 360/4 do
					local tears = fam.Player:FireTear(collider.Position, Vector.FromAngle(i):Resized(10), false, false, false):ToTear()
					tears.Position = fam.Position
					tears:ChangeVariant(TearVariant.BLOOD)
					tears:AddTearFlags(TearFlags.TEAR_PIERCING)
				end
			end
			if fam.SubType == 11 then --spit
				local tears = fam.Player:FireTear(fam.Position, Vector.FromAngle(0):Resized(4), false, false, false):ToTear()
				tears.Position = fam.Position
				tears:ChangeVariant(TearVariant.BLOOD)
				tears:AddTearFlags(TearFlags.TEAR_EXPLOSIVE)
				tears:SetColor(Color(0,1,0,1,0,0,0),9999999,99,false,false)
				InutilLib.MakeTearLob(tears, 1.5, 9 )
			end
			if fam.SubType == 12 then --ink
				for i = 0, 360-360/4, 360/4 do
					local tears = fam.Player:FireTear(collider.Position, Vector.FromAngle(i+45):Resized(10), false, false, false):ToTear()
					tears.Position = fam.Position
					tears:AddTearFlags(TearFlags.TEAR_PIERCING)
					tears:SetColor(Color(0,0,0,1,0,0,0),9999999,99,false,false)
				end
			end
			if fam.SubType == 21 then --bottle
				for i = 0, math.random(1,2) do
					local shard = Isaac.Spawn(1000, TaintedEffects.BOTTLE_SHARD, 0, fam.Position, (RandomVector() * math.random(2,4)):Rotated(i * (360/5)), fam)
					shard.CollisionDamage = 1.5
				end
				InutilLib.SFX:Play(TaintedSounds.BOTTLE_BREAK2)
			end
		else
			yandereWaifu.GetEntityData(fam).Health = yandereWaifu.GetEntityData(fam).Health - 1
		end
	end
	local data = yandereWaifu.GetEntityData(fam)
	if collider:IsVulnerableEnemy() and not collider:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
		if fam.FrameCount % 3 == 0 and not data.Vulnerable then
			Die()
		end
	end
end

yandereWaifu:AddCallback(ModCallbacks.MC_PRE_FAMILIAR_COLLISION, yandereWaifu.rottenFlyTearColl, RebekahCurse.ENTITY_FLYTEAR)

yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_,  fam) --rotten fly orbital
	local spr = fam:GetSprite()
	local rng = math.random(1, 100)
	local player = fam.Player:ToPlayer()
	local data = yandereWaifu.GetEntityData(fam)
	local controller = player.ControllerIndex
	
	if not data.Health then
		if fam.SubType == 21 then
			data.Health = 1
		else
			data.Health = 5
		end
	end
	
	if not data.Parent then data.Parent = player end
	local target
	local nearestOrb = 177013 -- labels the highest enemy hp
	for i, ent in pairs (Isaac.GetRoomEntities()) do
		if ent:IsVulnerableEnemy() and not ent:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
			if ent.Position:Distance(player.Position) < 200 then
				if nearestOrb >= ent.Position:Distance(player.Position) then
					nearestOrb = ent.Position:Distance(player.Position)
					target = ent
				end
			end
		end
	end
	if fam.SubType ~= 20 then --not dart fly
		if target then
			if fam.SubType == 5 or fam.SubType == 6 or fam.SubType == 21 then
				if math.random(1,5) == 5 then
					InutilLib.MoveDirectlyTowardsTarget(fam, target, 10, 0.9)
				elseif fam.FrameCount % 15 == 0 then
					fam.Velocity = Vector.Zero
				end
				if target.Position:Distance(fam.Position) < 75 and fam.FrameCount % 5 == 0 and fam.SubType == 6 then
					target:TakeDamage(fam.Player.Damage*3, 0, EntityRef(fam.Player), 1)
					fam:GetSprite():Play("Slash", true)
					fam.Velocity = Vector.Zero
				end
				if fam:GetSprite():IsFinished("Slash") then
					fam:GetSprite():Play("Fly", true)
				end
			elseif fam.SubType == 4 then
				--do nothing
			elseif fam.SubType == 7 then
				InutilLib.MoveDirectlyTowardsTarget(fam, target, 0.5, 0.9)
			else
				InutilLib.MoveDirectlyTowardsTarget(fam, target, 2, 0.9)
			end
		else
			if fam.SubType ~= 4 then
				if not data.RandomOrbit then data.RandomOrbit = math.random(0,360) end
				--InutilLib.MoveOrbitAroundTargetType1(fam, data.Parent, 2, 0.9, 8, 0 + data.RandomOrbit)
				fam.Velocity = (fam:GetOrbitPosition(player.Position+player.Velocity) - fam.Position)*0.2
			end
		end
		if fam.SubType == 4 then
			if fam:GetSprite():IsPlaying("Fly") then
				if math.random(1,15) == 15  and fam.FrameCount % 5 == 0 and target then
					fam:GetSprite():Play("FlyUp", true)
					data.target = target
					fam.Velocity = Vector.Zero
					data.Vulnerable = true
				else
					fam.Velocity = (fam:GetOrbitPosition(player.Position+player.Velocity) - fam.Position)*0.2
				end
			elseif fam:GetSprite():IsFinished("FlyUp") then
				fam:GetSprite():Play("FlyDown", true)
				fam.Position = data.target.Position
			elseif fam:GetSprite():IsFinished("FlyDown") then
				Isaac.Explode(fam.Position, fam, player.Damage*4)
				fam:Remove()
			end
		end
		if fam.SubType == 7 then
			if math.random(1,8) == 8 and fam.FrameCount % 5 == 0 and target then
				fam:GetSprite():Play("Attack", true)
			elseif fam:GetSprite():IsPlaying("Attack") then
				if fam:GetSprite():IsEventTriggered("Shoot") then
					local fly = Isaac.Spawn( EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLUE_FLY, 0, fam.Position, Vector.Zero, player):ToFamiliar()
				elseif fam:GetSprite():GetFrame() == 35 then
					fam:GetSprite():Play("Idle", true)
				end
				fam.Velocity = Vector.Zero
			end
		end
	else
		fam.Velocity = (fam.Velocity + player:GetAimDirection()):Resized(8)
		if fam.FrameCount > 30 then
			fam:Remove()
		end
	end
	InutilLib.FlipXByVec(fam, true)
end, RebekahCurse.ENTITY_FLYTEAR);

	function yandereWaifu:useHeadItems(collItem, rng, player)
		if yandereWaifu.IsNormalRebekah(player) then
			local data = yandereWaifu.GetEntityData(player)
			--print("fire")
			if yandereWaifu.GetEntityData(player).currentMode == RebekahCurse.REBECCA_MODE.RottenHearts and data.noHead then
				data.extraHeadsPresent = true
				if data.extraHeadsPresent then
					player:AddNullCostume(RebekahCurse.Costumes.SkinlessHead)
					yandereWaifu.ApplyCostumes( yandereWaifu.GetEntityData(player).currentMode, player, false)
				end
			end
		end
	end
	yandereWaifu:AddCallback(ModCallbacks.MC_USE_ITEM, yandereWaifu.useHeadItems, CollectibleType.COLLECTIBLE_SCISSORS)
	yandereWaifu:AddCallback(ModCallbacks.MC_USE_ITEM, yandereWaifu.useHeadItems, CollectibleType.COLLECTIBLE_PINKING_SHEARS)
	yandereWaifu:AddCallback(ModCallbacks.MC_USE_ITEM, yandereWaifu.useHeadItems, CollectibleType.COLLECTIBLE_DECAP_ATTACK)
end


--rotten birthright heart movement
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local player = yandereWaifu.GetEntityData(eff).Parent
	local controller = player.ControllerIndex;
	local sprite = eff:GetSprite();
	local room =  Game():GetRoom();
	local data = yandereWaifu.GetEntityData(player)
	local effData = yandereWaifu.GetEntityData(eff)
    local roomClampSize = math.max( player.Size, 20 );
	
	local trinketBonus = 0
	if player:HasTrinket(RebekahCurse.Trinkets.TRINKET_ISAACSLOCKS) then
		trinketBonus = 5
	end

	yandereWaifu.GetEntityData(player).invincibleTime = 10
	--movement code
	eff.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NOPITS;

	local movementDirection = player:GetShootingInput();
	eff.Velocity = (movementDirection*10)
	if eff.FrameCount == 1 then
		player.Visible = true
		--InutilLib.SFX:Play( RebekahCurse.Sounds.SOUND_SOULJINGLE, 1, 0, false, 1 );
		sprite:Play("Idle", true);
		effData.movementCountFrame = 20
	elseif sprite:IsFinished("Idle") then
		sprite:Play("Blink",true);
	end
	if data.RebHead then
		if movementDirection:Length() > 0.5 then
			effData.movementCountFrame = 20
		else
			effData.movementCountFrame = effData.movementCountFrame - 1
		end
		if effData.movementCountFrame <= 0 then
			local vector = (eff.Position - data.RebHead.Position):Resized(2)
			print( RebekahCurse.REBEKAH_BALANCE.ROTTEN_HEARTS_DASH_COOLDOWN)
			print(data.specialCooldown)
			data.IsDashActive = false
			yandereWaifu.GetEntityData(data.RebHead).PickupFrames = 30
			data.RebHead.Velocity = vector:Resized(15)
			eff:Remove()
		end
	elseif not data.RebHead or data.RebHead:IsDead() then
		data.IsDashActive = false
		eff:Remove()
	end

end, RebekahCurse.ENTITY_ROTTENBIRTHRIGHTTARGET)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, function(_,  eff)
local player = yandereWaifu.GetEntityData(eff).Parent
local sprite = eff:GetSprite()
local data = yandereWaifu.GetEntityData(eff)
if not data.Init then      
	eff.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NOPITS 
	data.spr = Sprite()                                                 
	data.spr:Load("gfx/effects/soul/orbital_target.anm2", true) 
	data.spr:Play("Line", true)
	data.Init = true                                              
end      
	
InutilLib.DeadDrawRotatedTilingSprite(data.spr, Isaac.WorldToScreen(yandereWaifu.GetEntityData(player).RebHead.Position), Isaac.WorldToScreen(eff.Position), 16, nil, 8, true)
end, RebekahCurse.ENTITY_ROTTENBIRTHRIGHTTARGET);