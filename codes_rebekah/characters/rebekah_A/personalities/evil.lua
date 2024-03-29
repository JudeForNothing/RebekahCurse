local evilOrbTickMax = 90
--BLACK HEART --
--do

function yandereWaifu:EvilPersonalityTearUpdate(tr)
	local data = yandereWaifu.GetEntityData(tr)
	if tr.Variant == 50 and data.IsEvilFetus then --just using 50 since the docs doesnt seem to have enums for fetus tears
		if tr.FrameCount == 1 and data.IsEvilFetus then
			tr:GetSprite():ReplaceSpritesheet(0, "gfx/characters/costumes_shadow/fetus_tears.png")
			tr:GetSprite():LoadGraphics();
		end
		if tr.FrameCount <= 300 and data.IsEvilFetus then
			tr.Height = -12
			local e = InutilLib.GetClosestGenericEnemy(tr, 500)
			if e then
				InutilLib.MoveDirectlyTowardsTarget(tr, e, 2+math.random(1,5)/10, 0.85)
			end
			tr.Velocity = tr.Velocity * 0.95
		end
	end

    --[[for i = 1, 817 do
        if SFXManager():IsPlaying(i) then print(i) end
    end]]
end
yandereWaifu:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, yandereWaifu.EvilPersonalityTearUpdate)
function yandereWaifu:SoulPersonalityTearCollision(tr, cool)
	local data = yandereWaifu.GetEntityData(tr)
	if tr.Variant == 50 and data.IsEvilFetus then --just using 50 since the docs doesnt seem to have enums for fetus tears
		if tr.FrameCount <= 300 and tr.FrameCount % 7 == 0 and data.IsEvilFetus then
			cool:TakeDamage(tr.CollisionDamage, 0, EntityRef(tr), 4)
		end
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, yandereWaifu.SoulPersonalityTearCollision)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	if eff.SubType == 3 then
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
				InutilLib.SFX:Play(RebekahCurse.Sounds.SOUND_EVILSUMMONAPOSTATE, 1, 0, false, 1--[[+(data.StartCountFrame/5)]])
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
				InutilLib.SFX:Play(RebekahCurse.Sounds.SOUND_EVILSUMMONAPOSTATE, 1, 0, false, 0.5)
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
				InutilLib.SFX:Play(RebekahCurse.Sounds.SOUND_EVILSUMMONAPOSTATE, 1, 0, false, 0.8)
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
					InutilLib.SFX:Play(RebekahCurse.Sounds.SOUND_EVILSUMMONAPOSTATE, 1, 0, false, 1)
				elseif data.Medium then
					InutilLib.SFX:Play(RebekahCurse.Sounds.SOUND_EVILSUMMONAPOSTATE, 1, 0, false, 1)
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
				InutilLib.SFX:Play(RebekahCurse.Sounds.SOUND_EVILSUMMONAPOSTATE, 1, 0, false, 1)
			end
		end
		if InutilLib.IsPlayingMultiple(sprite, "ShootRightTechGo", "ShootLeftTechGo", "ShootDownTechGo", "ShootUpTechGo") then
			if sprite:GetFrame() == 0 then
				InutilLib.SFX:Play(RebekahCurse.Sounds.SOUND_EVILSUMMONAPOSTATE, 1, 0, false, 1)
			end
		end
	end
end, RebekahCurse.ENTITY_REBEKAHENTITYWEAPON);

function yandereWaifu.SpawnEvilOrb(player, position)
	InutilLib.SFX:Play( SoundEffect.SOUND_FIRE_RUSH, 1, 0, false, 1 );
	local SubType = 0
	--replacing tear code
	if player:HasCollectible(CollectibleType.COLLECTIBLE_CROWN_OF_LIGHT) and player:GetEffectiveMaxHearts() >= player:GetHearts() and math.random(0,10) + player.Luck >= 3 then
		SubType = 18
	elseif player:HasCollectible(CollectibleType.COLLECTIBLE_DEATHS_TOUCH) and math.random(0,10) + player.Luck >= 5 then
		SubType = 8
	elseif player:HasCollectible(CollectibleType.COLLECTIBLE_FIRE_MIND) and math.random(0,10) + player.Luck >= 4 then
		SubType = 5
	elseif player:HasCollectible(CollectibleType.COLLECTIBLE_URANUS) and math.random(0,10) + player.Luck >= 4 then
		SubType = 41
	elseif player:HasCollectible(CollectibleType.COLLECTIBLE_TERRA) and math.random(0,10) + player.Luck >= 2 then
		SubType = 42
	end
	--luck based tears
	if player:HasCollectible(CollectibleType.COLLECTIBLE_TOUGH_LOVE) and math.random(0,10) + player.Luck >= 10 then
		SubType = 2
	elseif player:HasCollectible(CollectibleType.COLLECTIBLE_EXPLOSIVO) and math.random(0,10) + player.Luck >= 10 then
		SubType = 19
	elseif player:HasCollectible(CollectibleType.COLLECTIBLE_SINUS_INFECTION) and math.random(0,10) + player.Luck >= 10 then
		SubType = 26
	elseif player:HasCollectible(CollectibleType.COLLECTIBLE_KNOCKOUT_DROPS) and math.random(0,10) + player.Luck >= 10 then
		SubType = 39
	elseif player:HasCollectible(CollectibleType.COLLECTIBLE_MUCORMYCOSIS) and math.random(0,10) + player.Luck >= 8 then
		SubType = 48
	end
	
	--if player:GetMaxHearts() > 0 then
	local orb = Isaac.Spawn( EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_EVILORB, SubType, position, Vector(0,0), player ); --heart effect
	yandereWaifu.GetEntityData(orb).Parent = player
	--tear flag code
	if player:HasCollectible(CollectibleType.COLLECTIBLE_HOLY_LIGHT) and math.random(0,10) + player.Luck >= 5 then
		yandereWaifu.GetEntityData(orb).HasHolyLight = true
	end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_LACHRYPHAGY) then
		yandereWaifu.GetEntityData(orb).HasHungryTears = true
	end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_HAEMOLACRIA) then
		yandereWaifu.GetEntityData(orb).HasBalloonTears = true
	end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_LOST_CONTACT) then
		yandereWaifu.GetEntityData(orb).HasLostContacts = true
	end
	if (player:HasCollectible(CollectibleType.COLLECTIBLE_COMMON_COLD) and math.random(0,10) + player.Luck >= 5) or player:HasCollectible(CollectibleType.COLLECTIBLE_IPECAC) then
		yandereWaifu.GetEntityData(orb).HasPoison = true
	end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_EYE_OF_BELIAL) then
		yandereWaifu.GetEntityData(orb).HasBelialTears = true
	end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_DARK_MATTER) then
		yandereWaifu.GetEntityData(orb).HasDarkMatter = true
	end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_LITTLE_HORN) and math.random(1,5) == 5 then
		yandereWaifu.GetEntityData(orb).HasLittleHorn = true
	end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_GODHEAD) then
		yandereWaifu.GetEntityData(orb).HasGodhead = true
	end
	if TaintedTreasure and player:HasCollectible(TaintedCollectibles.REAPER) or TaintedTreasure and player:HasCollectible(TaintedCollectibles.SORROWFUL_SHALLOT) then
		yandereWaifu.GetEntityData(orb).HasSprayFlames = true
		if TaintedTreasure and player:HasCollectible(TaintedCollectibles.REAPER) then
			yandereWaifu.GetEntityData(orb).HasReaperFlames = true
		end
	end
	if TaintedTreasure and player:HasCollectible(TaintedCollectibles.DRYADS_BLESSING) and (math.random(0,10) + player.Luck >= 8) then
		yandereWaifu.GetEntityData(orb).HasDryadsBlessing = true
	end
	if TaintedTreasure and player:HasCollectible(TaintedCollectibles.POISONED_DART) then
		yandereWaifu.GetEntityData(orb).HasPoisonedDartEffect = true
	end
	if TaintedTreasure and player:HasCollectible(TaintedCollectibles.EVANGELISM) then
		yandereWaifu.GetEntityData(orb).HasEvangelism = true
	end
	if TaintedTreasure and player:HasCollectible(TaintedCollectibles.LIL_SLUGGER) then
		yandereWaifu.GetEntityData(orb).HasLilSlugger = true
	end
end

yandereWaifu:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_,player)
	local data = yandereWaifu.GetEntityData(player)
	if yandereWaifu.GetEntityData(player).currentMode == RebekahCurse.REBECCA_MODE.EvilHearts then
		if player:GetFireDirection() > -1 then --if not firing
			if not data.evilOrbTick then data.evilOrbTick = 0 end
			
			data.evilOrbTick = data.evilOrbTick + 1
			
			local dir
			if player:GetFireDirection() == 3 then --down
				dir = 90
			elseif player:GetFireDirection() == 1 then --up
				dir = -90
			elseif player:GetFireDirection() == 0 then --left
				dir = 180
			elseif player:GetFireDirection() == 2 then --right
				dir = 0
			end
			data.evilOrbTickDir = dir
			if data.evilOrbTick and data.evilOrbTickDir then
				if data.evilOrbTick >= evilOrbTickMax then
					yandereWaifu.SpawnEvilOrb(player, player.Position)
					data.evilOrbTick = 0
				end
			end
		else
			data.evilOrbTick = 0
		end
	end
end)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_RENDER, function(_, _)
	local excludeBetaFiends = 0 --yeah thats right, esau and strawmen are beta fiends
	for p = 0, InutilLib.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		if yandereWaifu.GetEntityData(player).currentMode == RebekahCurse.REBECCA_MODE.EvilHearts and Options.ChargeBars then
			yandereWaifu.evilOrbUI(player)
		end
	end
end);

local uiReserve = Sprite();
uiReserve:Load("gfx/ui/ui_evilorb_reserve.anm2", true);

function yandereWaifu.evilOrbUI(player)
		local data = yandereWaifu.GetEntityData(player)
		local room = InutilLib.game:GetRoom()
		local gameFrame = InutilLib.game:GetFrameCount();
		local tick = data.evilOrbTick
		if player.Visible and not (room:GetType() == RoomType.ROOM_BOSS and not room:IsClear() and room:GetFrameCount() < 1) and tick then
			uiReserve:SetOverlayRenderPriority(true)
		
			if tick > 0 then
				if tick < evilOrbTickMax then
					local FramePercentResult = math.floor((tick/evilOrbTickMax)*100)
					uiReserve:SetFrame("Charging", FramePercentResult)
					data.evilorbBarFade = gameFrame
					data.FinishedevilOrbUICharge = false
				elseif tick >= evilOrbTickMax then
					if not data.FinishedevilOrbUICharge then
						uiReserve:SetFrame("StartCharged",gameFrame - data.evilorbBarFade)
						if uiReserve:GetFrame() == 11 then
							data.evilorbBarFade = gameFrame
							data.FinishedevilOrbUICharge = true
						end
					elseif data.FinishedevilOrbUICharge then
						if uiReserve:GetFrame() == 5 then
							data.evilorbBarFade = gameFrame
						end
						uiReserve:SetFrame("Charged",gameFrame - data.evilorbBarFade)
					end
				end
			else
				if not uiReserve:IsPlaying("Disappear") and data.evilorbBarFade then
					uiReserve:SetFrame("Disappear",gameFrame - data.evilorbBarFade);
				end
			end
	
				local playerLocation = Isaac.WorldToScreen(player.Position)
				--print(InutilLib.IsInMirroredFloor(player))
				if not InutilLib.IsInMirroredFloor(player) then
					uiReserve:Render(playerLocation + Vector(-15, 15), Vector(0,0), Vector(0,0));
				end
			end
	--end
end



function yandereWaifu.EvilHeartTeleport(player, vector)
	local playerdata = yandereWaifu.GetEntityData(player)
	local SubType = 0
	local trinketBonus = 0
	if player:HasTrinket(RebekahCurse.Trinkets.TRINKET_ISAACSLOCKS) then
		trinketBonus = 5
	end
	--local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_PERSONALITYPOOF, 0, player.Position, Vector.Zero, player)
	
	local customBody = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_EXTRACHARANIMHELPER, 0, player.Position, Vector(0,0), player) --body effect
	yandereWaifu.GetEntityData(customBody).Player = player
	yandereWaifu.GetEntityData(customBody).HereticIn = true
	player.Velocity = Vector( 0, 0 );
	player.ControlsEnabled = false;
	--yandereWaifu.SpawnPoofParticle( player.Position, Vector(0,0), player, RebekahCurse.RebekahPoofParticleType.Evil );
	yandereWaifu.SpawnHeartParticles( 3, 5, player.Position, yandereWaifu.RandomHeartParticleVelocity(), player, RebekahCurse.RebekahHeartParticleType.Evil );
	playerdata.specialCooldown = RebekahCurse.REBEKAH_BALANCE.EVIL_HEARTS_DASH_COOLDOWN - trinketBonus;
	playerdata.invincibleTime = RebekahCurse.REBEKAH_BALANCE.EVIL_HEARTS_DASH_INVINCIBILITY_FRAMES;
	playerdata.IsUninteractible = true
	playerdata.IsDashActive = true
	
	yandereWaifu.SpawnEvilOrb(player, player.Position)
end


yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local player = yandereWaifu.GetEntityData(eff).Parent
	local controller = player.ControllerIndex;
	local sprite = eff:GetSprite();
	local room =  Game():GetRoom();
	local data = yandereWaifu.GetEntityData(player)
    local roomClampSize = math.max( player.Size, 20 );
	local wall = InutilLib.ClosestHorizontalWall(eff)
	local wallPos = yandereWaifu:GetClosestHorizontalWallPos(wall, eff)
	
	yandereWaifu.GetEntityData(player).invincibleTime = 10
	--movement code
	eff.GridCollisionClass =  EntityGridCollisionClass.GRIDCOLL_NOPITS;

	local movementDirection = player:GetMovementInput();
	
	player.Velocity = player.Velocity * 1.1
	eff.Velocity = player.Velocity;
	eff.Position = player.Position --room:GetClampedPosition(eff.Position, roomClampSize);
	
		--eff.Velocity = player.Velocity;
	--else
	--	eff.Velocity = (eff.Velocity * 0.9) + movementDirection:Resized( RebekahCurse.REBEKAH_BALANCE.SOUL_HEARTS_DASH_TARGET_SPEED );
	--end
	
	--function code
	--player.Velocity = (room:GetClampedPosition(eff.Position, roomClampSize) - player.Position)--*0.5;
	if eff.FrameCount == 1 then
		player.Visible = true
		--InutilLib.SFX:Play( RebekahCurse.Sounds.SOUND_SOULJINGLE, 1, 0, false, 1 );
		sprite:Play("Idle", true);
		data.LastEntityCollisionClass = player.EntityCollisionClass;
		data.LastGridCollisionClass = player.GridCollisionClass;
		yandereWaifu.RebekahCanShoot(player, false)
		data.IsUninteractible = true
		if not data.EndFrames then data.EndFrames = 40 end
		--trail
		data.trail = InutilLib.SpawnTrail(eff, Color(1,0,1,0.5))
		data.movementCountFrame = 50
	elseif sprite:IsFinished("Idle") then
		sprite:Play("Blink",true);
	end
	
    if (player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) and data.movementCountFrame <= 0) or (not player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) and eff.FrameCount >= data.EndFrames) then
        if RebekahCurse.REBEKAH_BALANCE.SOUL_HEARTS_DASH_RETAINS_VELOCITY == false then
            player.Velocity = Vector( 0, 0 );
        else
            player.Velocity = eff.Velocity;
        end
    	if player.CanFly == true and room:GetType() ~= RoomType.ROOM_DUNGEON then
    		player.Position = eff.Position;
            if room:IsPositionInRoom(player.Position, 0) == false then
                player.Velocity = Vector( 0, 0 );
                player.Position = room:GetClampedPosition( player.Position, roomClampSize );
            end
    	else
            player.Position = room:FindFreeTilePosition( eff.Position, 0 )
            if room:IsPositionInRoom(player.Position, 0) == false then
                player.Velocity = Vector( 0, 0 );
                player.Position = room:FindFreeTilePosition( room:GetClampedPosition( player.Position, roomClampSize ), 0 );
            end
        end
		local customBody = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_EXTRACHARANIMHELPER, 0, wallPos, Vector(0,0), player) --body effect
		yandereWaifu.GetEntityData(customBody).Player = player
		yandereWaifu.GetEntityData(customBody).HereticOut = true
		yandereWaifu.GetEntityData(customBody).DontFollowPlayer = true
		player.ControlsEnabled = false
    	eff:Remove();
		data.trail:Remove()
    	
    	data.IsUninteractible = false;
		yandereWaifu.RebekahCanShoot(player, true)
    else
		player:SetColor(Color(0,0,0,0.2,0,0,0),3,1,false,false)
    	player.GridCollisionClass =  EntityGridCollisionClass.GRIDCOLL_NOPITS;
		player.EntityCollisionClass =  EntityCollisionClass.ENTCOLL_PLAYEROBJECTS;
    end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) then
		if movementDirection:Length() > 1 then
			data.movementCountFrame = 50
		else
			data.movementCountFrame = data.movementCountFrame - 1
		end
	end
	--if eff.FrameCount < 35 then
	--	player.Velocity = Vector( 0, 0 );
	--end
end, RebekahCurse.ENTITY_EVILTARGET)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, function(_,  eff) --orbital target
	local sprite = eff:GetSprite()
	local data = yandereWaifu.GetEntityData(eff)
	local player = data.Parent
	local wall = InutilLib.ClosestHorizontalWall(eff)
	local wallPos = yandereWaifu:GetClosestHorizontalWallPos(wall, eff)
	
	if not data.Init then      
		eff.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NOPITS 
		data.spr = Sprite()                                                 
		data.spr:Load("gfx/effects/evil/line.anm2", true) 
		data.spr:Play("Line", true)
		data.Init = true                                              
	end      
		
	InutilLib.DeadDrawRotatedTilingSprite(data.spr, Isaac.WorldToScreen(wallPos), Isaac.WorldToScreen(eff.Position), 16, nil, 8, true)
end, RebekahCurse.ENTITY_EVILTARGET);

function yandereWaifu.EvilHeartDash(player, vector)
	local playerdata = yandereWaifu.GetEntityData(player)
	local SubType = 0
	local trinketBonus = 0
	if player:HasTrinket(RebekahCurse.Trinkets.TRINKET_ISAACSLOCKS) then
		trinketBonus = 5
	end
	
	--transform code
	player.Velocity = player.Velocity + vector:Resized( RebekahCurse.REBEKAH_BALANCE.EVIL_HEARTS_DASH_SPEED );
	--local jet = Isaac.Spawn( EntityType.ENTITY_EFFECT, 147, 1, player.Position, Vector(0,0), player ):ToEffect(); 
	--jet.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
	--jet.GridCollisionClass = GridCollisionClass.COLLISION_NONE
	
	playerdata.specialCooldown = RebekahCurse.REBEKAH_BALANCE.EVIL_HEARTS_DASH_COOLDOWN - trinketBonus;
	--else
	--	local orb = Isaac.Spawn( EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_EVILORB, 1, player.Position, Vector(0,0), player ); --heart effect
	--	playerdata.specialCooldown = RebekahCurse.REBEKAH_BALANCE.EMPTY_EVIL_HEARTS_DASH_COOLDOWN - trinketBonus;
	--end
	--yandereWaifu.SpawnPoofParticle( player.Position, Vector(0,0), player, RebekahCurse.RebekahPoofParticleType.Black );
	--yandereWaifu.SpawnHeartParticles( 3, 5, player.Position, yandereWaifu.RandomHeartParticleVelocity(), player, RebekahCurse.RebekahHeartParticleType.Black );
	for i = 0, math.random(20,25) do
		InutilLib.SetTimer( i, function()
			local hole = Isaac.Spawn(EntityType.ENTITY_EFFECT, 111, 0, player.Position, Vector(0,0), player);
			hole:GetSprite():ReplaceSpritesheet(0, "gfx/effects/evil/eviltrail.png")
			hole:GetSprite():LoadGraphics()
			hole.SpriteOffset = Vector( 0, -20 );
			hole.RenderZOffset = -10;
		end)
	end
	playerdata.invincibleTime = RebekahCurse.REBEKAH_BALANCE.EVIL_HEARTS_DASH_INVINCIBILITY_FRAMES;
	InutilLib.SFX:Play( SoundEffect.SOUND_MAW_OF_VOID , 1, 0, false, 1 );
	
	playerdata.IsDashActive = true
end

yandereWaifu:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE, function(_, bb)
	if bb.FrameCount == 1 then
		if yandereWaifu.GetEntityData(bb).IsSmall and yandereWaifu.GetEntityData(bb).IsEvilBomb then
			bb:GetSprite():Load("gfx/items/pick ups/bombs/bomb0.anm2", true)
			--bb.SpriteScale =  Vector(0.5,0.5)
			bb.SizeMulti = Vector(0.5,0.5)
			bb:GetSprite():Play("Pulse")
			bb:GetSprite():LoadGraphics();
		end
	end
end)

--dark beam effect misc
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, function(_, eff)
	--sprite:LoadGraphics()
end, RebekahCurse.ENTITY_ARCANE_EXPLOSION);

yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local player = eff.SpawnerEntity;
	local sprite = eff:GetSprite();
	
	if not sprite:IsPlaying("Megumin") then
		--sprite.Scale = Vector(0.2,0.2);
		--sprite:LoadGraphics();
		if eff.FrameCount == 1 then
			sprite:Play("Pentagram", true) --normal attack
			eff.RenderZOffset = -10000;
		else
			local target
			local highestHP = 0 -- labels the highest enemy hp
			for i, ent in pairs (Isaac.GetRoomEntities()) do
				if ent.Position:Distance(eff.Position) < ent.Size + eff.Size + 10 then
					if ent.Type == EntityType.ENTITY_EFFECT and ent.Variant == RebekahCurse.ENTITY_EVILORB then
						target = ent
						break
					else
						if ent:IsVulnerableEnemy() then
							if highestHP <= ent.MaxHitPoints then
								highestHP = ent.MaxHitPoints
								target = ent
							end
						end
					end
				end
			end
			if target then
				if target.Type == EntityType.ENTITY_EFFECT and target.Variant == RebekahCurse.ENTITY_EVILORB then
					local hole = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_HOLEFABRIC, 0, target.Position, Vector(0,0), player);
					yandereWaifu.GetEntityData(hole).Parent = player
				else
					local stomp = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_LABAN_STOMP, 0, target.Position, Vector(0,0), player)
					yandereWaifu.GetEntityData(stomp).Parent = player
				end
				eff:Remove()
			end
		end
		--elseif eff.FrameCount == 20 then
		--	Isaac.Spawn(EntityType.ENTITY_EFFECT, ENTITY_DARKBEAMINTHESKY, 0, eff.Position, Vector(0,0), player)
		--	for i, entities in pairs(Isaac.GetRoomEntities()) do
				--[[if entities[i]:IsVulnerableEnemy() then
					if entities[i].Position:Distance(eff.Position) < entities[i].Size + eff.Size + 10 then
						entities[i]:TakeDamage(player.Damage * 2, 0, EntityRef(eff), 1)
					end
				end]]
		--		if entities.Type == EntityType.ENTITY_EFFECT and entities.Variant == ENTITY_EVILORB then
		--			if entities.Position:Distance(eff.Position) < entities.Size + eff.Size + 50 then
		--				Isaac.Spawn(EntityType.ENTITY_EFFECT, ENTITY_HOLEFABRIC, 0, entities.Position, Vector(0,0), player);
		--				entities:Remove();
		--			end
		--		end
		--	eff:Remove();
		
	end
	eff.Velocity = eff.Velocity * 0.88;
end,RebekahCurse. ENTITY_ARCANE_EXPLOSION);

yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local player = yandereWaifu.GetEntityData(eff).Parent:ToPlayer()
	local sprite = eff:GetSprite()
	
	if eff.SubType == 0 then
		if eff.FrameCount == 1 then
			sprite:Play("Stomp", true) --normal attack
			--speaker:Play(SoundEffect.SOUND_MAW_OF_VOID, 1, 0, false, 1)
		else
			if sprite:IsEventTriggered("Stomp") then
				game:ShakeScreen(10)
				speaker:Play(SoundEffect.SOUND_FORESTBOSS_STOMPS, 1, 0, false, 0.5);
				local entities = Isaac.GetRoomEntities()
				for i = 1, #entities do
					if entities[i]:IsVulnerableEnemy() then
						if entities[i].Position:Distance(eff.Position) < entities[i].Size + eff.Size + 20 then
							entities[i]:TakeDamage(player.Damage * 35, 0, EntityRef(eff), 1)
						end
					end
				end
				yandereWaifu.SpawnHeartParticles( 1, 1, eff.Position, RandomHeartParticleVelocity(), player, HeartParticleType.Black );
			else
				local entities = Isaac.GetRoomEntities()
				for i = 1, #entities do
					if entities[i]:IsVulnerableEnemy() then
						if entities[i].Position:Distance(eff.Position) < entities[i].Size + eff.Size + 20 then
							entities[i]:AddSlowing(EntityRef(player), 10, 0.2, entities[i].Color)
						end
					end
				end
			end
			if sprite:IsFinished("Stomp") then
				eff:Remove();
			end
		end
	elseif eff.SubType == 1 then
		if eff.FrameCount == 1 then
			sprite:Load("gfx/effects/evil/orb/knockout_effect.anm2", true)
			sprite:LoadGraphics()
			sprite:Play("Stomp", true) --normal attack
			--speaker:Play(SoundEffect.SOUND_MAW_OF_VOID, 1, 0, false, 1)
		else
			if sprite:IsEventTriggered("Stomp") then
				InutilLib.game:ShakeScreen(10)
				InutilLib.SFX:Play(SoundEffect.SOUND_FORESTBOSS_STOMPS, 1, 0, false, 0.5);
				local entities = Isaac.GetRoomEntities()
				for i = 1, #entities do
					if entities[i]:IsVulnerableEnemy() then
						if entities[i].Position:Distance(eff.Position) < entities[i].Size + eff.Size + 20 then
							entities[i]:TakeDamage(player.Damage * 10, 0, EntityRef(eff), 1)
						end
					end
				end
				yandereWaifu.SpawnHeartParticles( 1, 1, eff.Position, yandereWaifu.RandomHeartParticleVelocity(), player, RebekahCurse.RebekahHeartParticleType.Black );
			end
			if sprite:IsFinished("Stomp") then
				eff:Remove();
			end
		end
	end
end, RebekahCurse.ENTITY_LABAN_STOMP);

--[[yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local player = Isaac.GetPlayer(0)
	local controller = player.ControllerIndex
	local sprite = eff:GetSprite()
	
	if eff.FrameCount == 1 then
		sprite:Play("Start", true) --normal attack
		speaker:Play(SoundEffect.SOUND_MAW_OF_VOID, 1, 0, false, 1)
	elseif sprite:IsFinished("Start") then
		sprite:Play("Loop", true)
	elseif eff.FrameCount < 30 and not sprite:IsPlaying("Start")then
		local entities = Isaac.GetRoomEntities()
		for i = 1, #entities do
			if entities[i]:IsVulnerableEnemy() then
				if entities[i].Position:Distance(eff.Position) < entities[i].Size + eff.Size + 50 then
					entities[i]:TakeDamage(player.Damage * 2, 0, EntityRef(eff), 1)
				end
			end
		end
		SpawnHeartParticles( 1, 1, eff.Position, RandomHeartParticleVelocity(), player, HeartParticleType.Black );
	elseif eff.FrameCount == 30 then
		sprite:Play("End", true);
	elseif sprite:IsFinished("End") then
		eff:Remove();
	end
end, RebekahCurse.ENTITY_DARKBEAMINTHESKY);]]

--evilorb effect
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local sprite = eff:GetSprite()
	local data = yandereWaifu.GetEntityData(eff)
	local player = data.Parent
	local extraTearDmg = 1
	
	if not data.Tier then
		data.Tier = 1
	end
	eff.SpriteScale = Vector(0.5 + data.Tier, 0.5 + data.Tier)
	
	if player:HasCollectible(CollectibleType.COLLECTIBLE_20_20) then
		extraTearDmg = extraTearDmg + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_20_20) 
	end
	if player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_MUTANT_SPIDER) then
		extraTearDmg = extraTearDmg + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_MUTANT_SPIDER) * 3
	end
	if player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_INNER_EYE) then
		extraTearDmg = extraTearDmg + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_INNER_EYE) * 2
	end
	if player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_MONSTROS_LUNG) then
		extraTearDmg = extraTearDmg + math.random(3,5);
	end
	if TaintedTreasure and player:HasCollectible(TaintedCollectibles.SPIDER_FREAK) then
		extraTearDmg = extraTearDmg + player:GetCollectibleNum(TaintedCollectibles.SPIDER_FREAK) * 5
	end
	--overload code
	if data.Tier > 3 then
		data.HitPoints = 0
	end
	
	--if eff.SubType == 0 then
	if eff.FrameCount == 1 then
		if not sprite:IsPlaying("Spawn") then sprite:Play("Spawn", true) end
		if not data.setDespawn then data.setDespawn = math.random( 600, 900 ) end
		if not data.HitPoints then data.HitPoints = 10 end;
		
		if eff.SubType == 2 then --tough love synergy
			eff:GetSprite():ReplaceSpritesheet(2, "gfx/effects/evil/orb/teeth.png") 
		end
		if eff.SubType == 5 then --tough love synergy
			eff:GetSprite():ReplaceSpritesheet(0, "gfx/effects/evil/orb/orb_base.png") 
			eff:GetSprite():ReplaceSpritesheet(5, "gfx/effects/evil/fire_jet_base.png") 
			eff:SetColor(Color(0.8,0.5,0,1,0,0,0),9999999,99,false,false)
		end
		if eff.SubType == 8 then --scythe synergy
			eff:GetSprite():ReplaceSpritesheet(2, "gfx/effects/evil/orb/scythe.png") 
		end
		if eff.SubType == 18 then --diamond synergy
			eff:GetSprite():ReplaceSpritesheet(2, "gfx/effects/evil/orb/diamond.png") 
		end
		if eff.SubType == 19 then --explosivo synergy
			eff:GetSprite():ReplaceSpritesheet(2, "gfx/effects/evil/orb/explosivo.png") 
		end
		if eff.SubType == 26 then --booger synergy
			eff:GetSprite():ReplaceSpritesheet(2, "gfx/effects/evil/orb/booger.png") 
		end
		if eff.SubType == 39 then --knockout synergy
			eff:GetSprite():ReplaceSpritesheet(2, "gfx/effects/evil/orb/knockout.png") 
		end
		if eff.SubType == 41 then --ice synergy
			eff:GetSprite():ReplaceSpritesheet(2, "gfx/effects/evil/orb/ice.png") 
		end
		if eff.SubType == 42 then --rock synergy
			eff:GetSprite():ReplaceSpritesheet(2, "gfx/effects/evil/orb/rock.png") 
		end
		if eff.SubType == 48 then --spore synergy
			eff:GetSprite():ReplaceSpritesheet(2, "gfx/effects/evil/orb/spore.png") 
		end
		if data.HasHolyLight then
			eff:GetSprite():ReplaceSpritesheet(1, "gfx/effects/evil/orb/holylight_effect.png") 
		end
		if data.HasLittleHorn then
			eff:GetSprite():ReplaceSpritesheet(1, "gfx/effects/evil/orb/littlehorn_effect.png") 
		end
		if data.HasGodhead then
			eff:GetSprite():ReplaceSpritesheet(4, "gfx/effects/evil/orb/godhead_effect.png") 
			eff:GetSprite():ReplaceSpritesheet(0, "gfx/effects/evil/orb/orb_base.png") 
			eff:GetSprite():ReplaceSpritesheet(5, "gfx/effects/evil/fire_jet_base.png") 
		end
		if data.HasPoison then
			eff:GetSprite():ReplaceSpritesheet(0, "gfx/effects/evil/orb/orb_base.png") 
			eff:GetSprite():ReplaceSpritesheet(5, "gfx/effects/evil/fire_jet_base.png") 
			eff:SetColor(Color(0,1,0.3,1,0,0,0),9999999,99,false,false)
		end
		if data.HasDarkMatter then
			eff:GetSprite():ReplaceSpritesheet(0, "gfx/effects/evil/orb/orb_base.png") 
			eff:GetSprite():ReplaceSpritesheet(5, "gfx/effects/evil/fire_jet_base.png") 
			eff:SetColor(Color(0,0,0,1,0,0,0),9999999,99,false,false)
		end
		if data.HasLostContacts then
			eff:GetSprite():ReplaceSpritesheet(3, "gfx/effects/evil/orb/shield.png") 
		end
		if data.HasHungryTears then
			eff:GetSprite():ReplaceSpritesheet(2, "gfx/effects/evil/orb/hungry.png") 
		end
		if data.HasBalloonTears then
			eff:GetSprite():ReplaceSpritesheet(2, "gfx/effects/evil/orb/balloon.png") 
		end
		if data.HasBelialTears then
			eff:GetSprite():ReplaceSpritesheet(0, "gfx/effects/evil/orb/orb_base.png") 
			eff:GetSprite():ReplaceSpritesheet(5, "gfx/effects/evil/fire_jet_base.png") 
			eff:SetColor(Color(1,0,0,1,0,0,0),9999999,99,false,false)
		end
		if data.HasReaperFlames then
			eff:GetSprite():ReplaceSpritesheet(0, "gfx/effects/evil/orb/orb_base.png") 
			eff:GetSprite():ReplaceSpritesheet(5, "gfx/effects/evil/fire_jet_base.png") 
			local ColorGreyscale = Color(1,1,1)
			ColorGreyscale:SetColorize(1,1,1,1)
			eff.Color = ColorGreyscale
		end
		if data.HasEvangelism then
			eff:GetSprite():ReplaceSpritesheet(4, "gfx/effects/evil/orb/evangelism_effect.png") 
			eff:GetSprite():ReplaceSpritesheet(0, "gfx/effects/evil/orb/orb_base.png") 
			eff:GetSprite():ReplaceSpritesheet(5, "gfx/effects/evil/fire_jet_base.png") 
		end
		if data.HasDryadsBlessing then
			eff:GetSprite():ReplaceSpritesheet(0, "gfx/effects/evil/orb/orb_base.png") 
			eff:GetSprite():ReplaceSpritesheet(5, "gfx/effects/evil/fire_jet_base.png") 
			eff:SetColor(Color(0,1,0.3,1,0,0,0),9999999,99,false,false)
			eff:GetSprite():ReplaceSpritesheet(2, "gfx/effects/evil/orb/dryad.png") 
			eff:GetSprite():ReplaceSpritesheet(4, "gfx/effects/evil/orb/belial_germinate_effect.png") 
			local skin01 = true
			local refLeaf
			--taken directly from tainted treasures
			local size = 10*data.Tier
			local num = math.floor(size / 2)
			if num % 2 == 1 then
				num = num + 1
			end
			local skin01 = true
			local refLeaf
			for i = 360/num, 360, 360/num do
				local leaf = Isaac.Spawn(1000, TaintedEffects.CRYSTAL_LEAF, 0, eff.Position, Vector.Zero, eff)
				if skin01 then
					leaf:GetSprite():Play("Leaf01")
					skin01 = false
				else
					leaf:GetSprite():Play("Leaf02")
					skin01 = true
				end
				local data = leaf:GetData()
				data.Angle = i
				data.TargetRadius = size * 10
				data.CurrentRadius = 0
				data.RadiusRate = data.TargetRadius / 20
				data.OrbitPos = eff.Position
				leaf.Parent = eff
				if not refLeaf then
					refLeaf = leaf
				end
				--leaf:Update()
			end
			eff:GetData().TaintedStatus = "Germinated"
		end
		if data.HasLilSlugger then
			eff:GetSprite():ReplaceSpritesheet(0, "gfx/effects/evil/orb/orb_saw.png") 
		end
		eff:GetSprite():LoadGraphics()
	end
	
	if sprite:IsFinished("Spawn") then sprite:Play("Idle") end
	
	--belial code
	if data.IsActiveBelial then
		if eff.FrameCount % 5 == (0) and math.random(0,10) == 10 then
			local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.BELIAL, 1, eff.Position, Vector(math.random(7,15),0):Rotated(math.random(0,360)), player):ToTear()
			tear:AddTearFlags(TearFlags.TEAR_BELIAL)
		end
	end

	if data.HasSprayFlames then
		if eff.FrameCount % 5 == (0) and math.random(0,10) == 10 then
			local fire = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLUE_FLAME, 0, eff.Position, Vector(math.random(3,7),0):Rotated(math.random(0,360)), eff):ToEffect()
			fire.Parent = player
			fire.CollisionDamage = math.max(7, player.Damage*2) / 1.5
			fire.Timeout = math.random(40, 60)
			if data.HasReaperFlames then
				local ColorGreyscale = Color(1,1,1)
				ColorGreyscale:SetColorize(1,1,1,1)
				fire.Color = ColorGreyscale
				fire:GetData().TaintedReaperFire = true
				fire:Update()
			else
				fire:GetSprite():ReplaceSpritesheet(0, "gfx/effects/effect_005_fire_purple.png")
				fire:GetSprite():LoadGraphics()
			end
			fire.Size = 0.5
		end
	end
	--damage code
	local godheadBuff = 0
	if data.HasGodhead or data.HasEvangelism then godheadBuff = 70 end
	for i, entenmies in pairs(Isaac.GetRoomEntities()) do
		--local ents = Isaac.GetRoomEntities() --shorten this damn thing lol
		if entenmies:IsEnemy() and entenmies:IsVulnerableEnemy() --[[and not entenmies:IsEffect() and not entenmies:IsInvulnurable()]] then
			--print(eff.FrameCount % (5 + player.MaxFireDelay/5))
			if math.random(1,5) == 5 and entenmies.Position:Distance(eff.Position) < 200 and eff.FrameCount % math.ceil(5 + player.MaxFireDelay/5) == (0) and data.Tier > 1 then
				if InutilLib.room:CheckLine(entenmies.Position, eff.Position, 3, 0) then
					--turret code
					local tear = player:FireTear( eff.Position, (entenmies.Position - eff.Position):Resized(18), false, false, false):ToTear()
					tear.Position = eff.Position
					if tear.Variant ~= TearVariant.BLOOD then tear:ChangeVariant(TearVariant.BLOOD) end
					tear.CollisionDamage = (player.Damage * extraTearDmg)/3;
					break
				end
			end
			if entenmies.Position:Distance(eff.Position) <= 170 and data.HasPoisonedDartEffect and eff.FrameCount % 15 == 0 and not enemy:HasEntityFlags(EntityFlag.FLAG_WEAKNESS) and not enemy:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
				entenmies:AddEntityFlags(EntityFlag.FLAG_WEAKNESS)
				local weakColor = Color(1,1,1) --taken from TT
				weakColor:SetColorize(1.3,1,1.5,0.6)
				entenmies:SetColor(weakColor, -1, 1)
				SFXManager():Play(SoundEffect.SOUND_WHIP_HIT, 1, 2, false, 1)
			end
			if entenmies.Position:Distance(eff.Position) < entenmies.Size + eff.Size + 15 + godheadBuff then
				if eff.FrameCount % 5 == (0) then
					local sluggerDmgMulti = 1
					if data.HasLilSlugger then
						sluggerDmgMulti = 2
					end
					entenmies:TakeDamage((player.Damage/2)*sluggerDmgMulti, 0, EntityRef(eff), 4)
					
					--explode fire mind stuff
					if eff.SubType == 5 and math.random(0,10) == 10 then
						Isaac.Explode(eff.Position, player, player.Damage * 5)
						eff:Kill()
					end
					if eff.SubType == 19 and math.random(0,15) == 15 then
						local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.EXPLOSIVO, 1, entenmies.Position + Vector(3,0):Rotated(math.random(0,360)), Vector(0,0), player):ToTear()
						tear.Size = math.random(1,20)/10
						tear:AddTearFlags(player.TearFlags)
						tear:AddTearFlags(TearFlags.TEAR_STICKY)
					end
					if eff.SubType == 48 and math.random(0,8) == 8 then
						local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.SPORE, 1, entenmies.Position + Vector(3,0):Rotated(math.random(0,360)), Vector(0,0), player):ToTear()
						tear.Size = math.random(1,20)/10
						tear:AddTearFlags(player.TearFlags)
						tear:AddTearFlags(TearFlags.TEAR_SPORE)
					end
					if eff.SubType == 26 and math.random(0,8) == 8 then
						local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.BOOGER, 1, entenmies.Position + Vector(3,0):Rotated(math.random(0,360)), Vector(0,0), player):ToTear()
						tear.Size = math.random(1,20)/10
						tear:AddTearFlags(player.TearFlags)
						tear:AddTearFlags(TearFlags.TEAR_BOOGER)
					end
					if data.HasPoison and math.random(0,5) == 5 then
						entenmies:AddPoison(EntityRef(player), math.random(300,600), math.floor(player.Damage/5))
					end
					if data.HasDarkMatter and math.random(0,5) == 5 then
						entenmies:AddFear(EntityRef(player), math.random(600,900))
					end
					if data.HasBelialTears and not data.IsActiveBelial then
						if data.HasGodhead then
							eff:GetSprite():ReplaceSpritesheet(4, "gfx/effects/evil/orb/belial_godhead_effect.png") 
						else
							eff:GetSprite():ReplaceSpritesheet(4, "gfx/effects/evil/orb/belial_effect.png") 
						end
						eff:GetSprite():ReplaceSpritesheet(1, "gfx/effects/evil/orb/evileye.png") 
						eff:GetSprite():LoadGraphics()
						data.IsActiveBelial = true
					end
					if data.HasLittleHorn and math.random(0,8) == 8 then
						local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 1, entenmies.Position + Vector(3,0):Rotated(math.random(0,360)), Vector(0,0), player):ToTear()
						tear.Size = math.random(1,20)/10
						tear:AddTearFlags(player.TearFlags)
						tear:AddTearFlags(TearFlags.TEAR_HORN)
					end
					if data.HasEvangelism then
						--taken directly from TT, sorry lol
						local enemyData = entenmies:GetData()
						if enemyData.EvangelismStrength then
							enemyData.EvangelismStrength = enemyData.EvangelismStrength + 0.2
							enemyData.EvangelismTimer = 90
					
							if enemyData.EvangelismStrength >= 1 then
								local spawner = player
								if not (player and player:Exists()) then
									spawner = Isaac.GetPlayer()
								end
							
								local beam = Isaac.Spawn(1000, EffectVariant.CRACK_THE_SKY, 1, entenmies.Position, Vector.Zero, eff.Player)
								beam.Parent = spawner
								beam.CollisionDamage = spawner.Damage * 5
								beam:Update()
					
								sfx:Play(SoundEffect.SOUND_DOGMA_LIGHT_RAY_FIRE, 0.3)
								enemyData.EvangelismStrength = 0
							end
						end
					end

					data.HitPoints = data.HitPoints - 1
					--print(data.HitPoints)
					
					if data.HitPoints <= 2 and data.Tier > 1 then --shrink if its dying
						data.Tier = data.Tier - 1
					end
				end
				--gotta nerf this sucking thing
				--entenmies.Velocity = (eff.Position - entenmies.Position):Resized(2)
			end
		elseif data.HasLostContacts or data.HasHungryTears then
			if entenmies.Type == EntityType.ENTITY_PROJECTILE then
				if entenmies.Position:Distance(eff.Position) < entenmies.Size + eff.Size + 15 then
					entenmies:Kill()
					data.HitPoints = data.HitPoints - 1
					if data.HasHungryTears then
						if not data.TearsEaten then data.TearsEaten = 0 end
						data.TearsEaten = data.TearsEaten + 0.5
						--print(data.TearsEaten)
						eff.SpriteScale = Vector(1 + data.TearsEaten + data.Tier, 1 + data.TearsEaten + data.Tier)
						eff.Size = eff.Size * 1 + data.TearsEaten
						if data.TearsEaten > 2 then
							data.HitPoints = 0 --kill it
						end
					end
				end
			end
		--dryad's blessing synergy
		elseif entenmies.Type == 1 then
			if data.HasDryadsBlessing and entenmies.Position:Distance(eff.Position) < entenmies.Size + eff.Size + 50 then
				local pdata = entenmies:GetData()
				pdata.GerminatedStacks = pdata.GerminatedStacks + 1
				print(pdata.GerminatedStacks)
				TaintedTreasure:EvaluateGerminatedBoosts(entenmies:ToPlayer(), pdata)
			end
		end
	end
	
	if eff.FrameCount == data.setDespawn or (data.HitPoints <= 0 and sprite:IsFinished("Die")) then 
		--subtype and its effects?
		if eff.SubType == 2 then --tough love
			for i = 0, math.random(4,6) do
				InutilLib.SetTimer( i*30, function()
					local tear = player:FireTear( eff.Position, Vector.FromAngle(math.random(0,360)):Resized(20), false, false, false):ToTear()
					tear.Position = eff.Position
					tear.CollisionDamage = player.Damage * 5 * extraTearDmg;
					if tear.Variant ~= TearVariant.TOOTH then tear:ChangeVariant(TearVariant.TOOTH); end
				end)
			end
		elseif eff.SubType == 5 and math.random(0,10) == 10 then
			Isaac.Explode(eff.Position, player, player.Damage * 5 * extraTearDmg)
		elseif eff.SubType == 8 then --deaths touch
			for i = 0, math.random(4,6) do
				InutilLib.SetTimer( i*30, function()
					local tear = player:FireTear( eff.Position, Vector.FromAngle(math.random(0,360)):Resized(20), false, false, false):ToTear()
					tear.Position = eff.Position
					tear.CollisionDamage = player.Damage * 5 * extraTearDmg;
					if tear.Variant ~= RebekahCurse.ENTITY_WIND_SLASH then tear:ChangeVariant(RebekahCurse.ENTITY_WIND_SLASH); end
				end)
			end
		elseif eff.SubType == 18 then --crown of light
			for i = 0, 315, 360/8 do
				local tear = player:FireTear( eff.Position, Vector.FromAngle(i):Resized(15), false, false, false):ToTear()
				tear.Position = eff.Position
				tear.CollisionDamage = player.Damage * 5 * extraTearDmg;
				if tear.Variant ~= TearVariant.DIAMOND then tear:ChangeVariant(TearVariant.DIAMOND); end
			end
		elseif eff.SubType == 39 then --knockout drops
			local stomp = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_LABAN_STOMP, 1, eff.Position, Vector(0,0), player)
			yandereWaifu.GetEntityData(stomp).Parent = player
		elseif eff.SubType == 41 then --uranus
			for i = 0, 315, 360/8 do
				local tear = player:FireTear( eff.Position, Vector.FromAngle(i):Resized(15), false, false, false):ToTear()
				tear.Position = eff.Position
				tear.CollisionDamage = player.Damage * 5 * extraTearDmg;
				if tear.Variant ~= TearVariant.ICE then tear:ChangeVariant(TearVariant.ICE); end
			end
		elseif eff.SubType == 42 then --terra
			for i = 0, 1 do
				local crack = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SHOCKWAVE_RANDOM, 1, eff.Position, Vector(0,0), player)
			end
			for i = 0, 315, 360/8 do
				local tear =Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.ROCK, 0, eff.Position, Vector.FromAngle(i):Resized(15), ent):ToTear() 
				--local tear = player:FireTear( eff.Position, Vector.FromAngle(i):Resized(15), false, false, false):ToTear()
				tear.Position = eff.Position
				tear.CollisionDamage = player.Damage * 5 * extraTearDmg;
				if tear.Variant ~= TearVariant.ROCK then tear:ChangeVariant(TearVariant.ROCK); end
			end
		end
		
		if data.HasHolyLight then
			local crack = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACK_THE_SKY, 1, eff.Position, Vector(0,0), player) 
			crack.Size = crack.Size * 2
			crack.CollisionDamage = player.Damage * 5 * extraTearDmg
			crack.SpriteScale = Vector(2,2)
		end
		if data.HasHungryTears then
			for i = 0, 315, 360/8 do --fire 8 brimstone around
				--beam = player:FireBrimstone( Vector.FromAngle(i), eff, 2):ToLaser();
				local beam = EntityLaser.ShootAngle(1, eff.Position, i, 10, Vector(0,-5), player):ToLaser()
				beam.Position = eff.Position
				--beam:AddTearFlags(player.TearFlags)
				beam.MaxDistance = 100
				beam.Timeout = 10
				beam.DisableFollowParent = true
				beam:SetColor(Color(0,0,0,1,0.8,0,1),9999999,99,false,false)
				InutilLib.UpdateLaserSize(beam, data.TearsEaten or 0)
			end
		end
		if data.HasBalloonTears then
			if player:HasCollectible(CollectibleType.COLLECTIBLE_BRIMSTONE) then
				for i = 1, math.random(3,4) do
					local beam = player:FireBrimstone( Vector.FromAngle(math.random(0,360)), eff, 2):ToLaser()
					beam.Position = eff.Position
					beam.CollisionDamage = player.Damage*1.5 * extraTearDmg
					beam:AddTearFlags(player.TearFlags)
					beam.DisableFollowParent = true
				end
			elseif player:HasCollectible(CollectibleType.COLLECTIBLE_DR_FETUS) then
				for i = 1, math.random(3,4) + 3 do
					InutilLib.SetTimer( i*8, function()
						local bomb = player:FireBomb( eff.Position + Vector(math.random(1,10),math.random(1,10)), Vector(0,5):Rotated(math.random(1,360)):Resized(1))
						--local bomb = Isaac.Spawn(EntityType.ENTITY_BOMBDROP, 0, 0, tr.Position + Vector(math.random(1,10),math.random(1,10)),  Vector(0,5):Rotated(math.random(1,360)):Resized(15), tr):ToBomb();
						yandereWaifu.GetEntityData(bomb).IsSmall = true
						yandereWaifu.GetEntityData(bomb).IsEvilBomb = true
						bomb.ExplosionDamage = player.Damage*2.7* extraTearDmg
						InutilLib.MakeBombLob(bomb, 1, 8 )
					end);
				end
			else
				for i = 1, math.random(7,9) do
					local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.BLOOD, 0, eff.Position, Vector.FromAngle(math.random(0,360)):Resized(12), ent):ToTear() 
					tear.Position = eff.Position
					tear.CollisionDamage = player.Damage*1.5 * extraTearDmg
					InutilLib.MakeTearLob(tear, 1.5, 9 )
				end
			end
		end
		eff:Remove()
		local numofParticles = math.random(1,3)
		for i = 1, numofParticles do
			local part = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_HEARTPARTICLE, 0, eff.Position, Vector.FromAngle(1*math.random(1,360))*(math.random(2,4)), player) --heart effect
			if not yandereWaifu.GetEntityData(part).Small then yandereWaifu.GetEntityData(part).Small = true end
			part:GetSprite():ReplaceSpritesheet(0, "gfx/effects/heart_black.png") 
			part:GetSprite():LoadGraphics()
		end
		
		local function onDeath()
			if sprite:IsFinished("Die") then
			--if data.HitPoints <= 0 then --only do aoe if killed
				for i, entenmies in pairs(Isaac.GetRoomEntities()) do
					if entenmies:IsEnemy() then
						if entenmies.Position:Distance(eff.Position) < entenmies.Size + eff.Size + 140 then
							entenmies:TakeDamage(player.Damage*2.5, 0, EntityRef(eff), 4)
						end
					end
				end
				if player:HasCollectible(CollectibleType.COLLECTIBLE_IPECAC) then
					Isaac.Explode(eff.Position, player, player.Damage)
				end
				if player:HasCollectible(CollectibleType.COLLECTIBLE_SPIRIT_SWORD) then
					local sword = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_DARKSPIRITSWORD, 0, eff.Position, Vector(0,0), player)
					yandereWaifu.GetEntityData(sword).Parent = player
				end
				if player:HasCollectible(CollectibleType.COLLECTIBLE_DR_FETUS) then
					local bomb = player:FireBomb(eff.Position, Vector(0,0)):ToBomb() --this is a workaround to make explosions larger
					bomb:SetExplosionCountdown(1)
					bomb.Visible = false
					bomb.ExplosionDamage = player.Damage*1.77013
				end
			--end
			end
			if not sprite:IsPlaying("Die") then sprite:Play("Die", true) end
			--print(data.HitPoints)
			--print("yeeehoa")
		end
		
		if data.Tier > 1 then
			for i = 0, 360-360/6, 360/6 do
				local tear = player:FireTear(eff.Position, Vector.FromAngle(i):Resized(5), false, false, false):ToTear()
				tear.Position = eff.Position
				tear:ChangeVariant(TearVariant.FIRE)
				tear:GetSprite():ReplaceSpritesheet(0, "gfx/effects/effect_005_fire_purple.png")
				tear:GetSprite():LoadGraphics()
				tear:AddTearFlags(TearFlags.TEAR_PIERCING)
				tear.CollisionDamage = player.Damage
				tear.Size = data.Tier/2
			end
			onDeath()
		else
			if data.HitPoints <= 0 then --only do aoe if killed
				onDeath()
			else
				local tear = player:FireTear(eff.Position, Vector.Zero, false, false, false):ToTear()
				tear.Position = eff.Position
				tear:ChangeVariant(TearVariant.FIRE)
				tear:AddTearFlags(TearFlags.TEAR_PIERCING)
				tear.CollisionDamage = player.Damage * 0.8
				tear.SpriteScale = eff.SpriteScale
				tear:GetSprite():ReplaceSpritesheet(0, "gfx/effects/effect_005_fire_purple.png")
				tear:GetSprite():LoadGraphics()
			end
		end
		--dust effect
		local dust = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 1, eff.Position, Vector(0,0), eff)
		dust.SpriteScale = Vector(0.5, 0.5)
		dust:SetColor(Color(0,0,0,1,1,0,1),9999999,99,false,false)
		InutilLib.game:ShakeScreen(1)
	end
	
	if (data.HitPoints <= 0 and not sprite:IsPlaying("Die")) then
		sprite:Play("Die", true)
		
	end
	
	if data.ChainExplode then --deprecated?
		for i, orb in pairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_EVILORB, -1, false, false)) do
			if orb.Position:Distance(eff.Position) < orb.Size + eff.Size + 120 then
				yandereWaifu.GetEntityData(orb).ChainExplode = true
			end
		end
		for i, entenmies in pairs(Isaac.GetRoomEntities()) do
			if entenmies:IsEnemy() then
				if entenmies.Position:Distance(eff.Position) < entenmies.Size + eff.Size + 140 then
					entenmies:TakeDamage(player.Damage*6.5, 0, EntityRef(eff), 4)
				end
			end
		end
		local part = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_DARKBOOM2, 0, eff.Position, Vector(0,0), player);
		game:ShakeScreen(10)
		speaker:Play(SoundEffect.SOUND_FORESTBOSS_STOMPS, 1, 0, false, 0.5);
		eff:Remove();
	end
	if data.Heretic and not data.beam then
		local target
		local farthestOrb = 0 -- labels the farthest enemy
		for i, ent in pairs (Isaac.GetRoomEntities()) do
			if ent.Type == EntityType.ENTITY_EFFECT and ent.Variant == RebekahCurse.ENTITY_EVILORB and not yandereWaifu.GetEntityData(ent).Heretic and not ent:IsDead() then
				--print(ent.Variant, "  ", ENTITY_EVILORB)
				if farthestOrb <= ent.Position:Distance(eff.Position) then
					farthestOrb = ent.Position:Distance(eff.Position)
					target = ent
				end
			end
		end
		
		local beam
		local angle

		if target then --aims then to the furthest orb
			--if not data.delay then data.delay = 1 else data.delay = data.delay + 1 end
			--InutilLib.SetTimer( data.delay*30, function()
				angle = InutilLib.ObjToTargetAngle(eff, target, true)
				if player:HasCollectible(CollectibleType.COLLECTIBLE_THE_WIZ) then --derp
					for i = -15, 15, 30 do
						beam = player:FireBrimstone( Vector.FromAngle(angle + i), eff, 2):ToLaser();
						--beam = EntityLaser.ShootAngle(1, eff.Position, angle, 5, Vector(0,-5), player):ToLaser()
						beam.Position = eff.Position
						--beam:AddTearFlags(player.TearFlags)
						beam.MaxDistance = farthestOrb
						beam.Timeout = 20
						beam.DisableFollowParent = true
						yandereWaifu.GetEntityData(target).Heretic = true
						beam:SetColor(Color(0,0,0,1,0.8,0,1),9999999,99,false,false)
						yandereWaifu.GetEntityData(beam).IsEvil = true
						if player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_KNIFE) then
							for j = 1, 5 do
								InutilLib.SetTimer( j*15,function()
									yandereWaifu.ThrowDarkKnife(player, eff.Position, Vector.FromAngle(angle + i):Resized(15))
								end)
							end
						end
					end
				else
					beam = player:FireBrimstone( Vector.FromAngle(angle), eff, 2):ToLaser();
					--beam = EntityLaser.ShootAngle(1, eff.Position, angle, 5, Vector(0,-5), player):ToLaser()
					beam.Position = eff.Position
					--beam:AddTearFlags(player.TearFlags)
					beam.MaxDistance = farthestOrb
					beam.Timeout = 20
					beam.DisableFollowParent = true
					yandereWaifu.GetEntityData(target).Heretic = true
					beam:SetColor(Color(0,0,0,1,0.8,0,1),9999999,99,false,false)
					yandereWaifu.GetEntityData(beam).IsEvil = true
					if player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_KNIFE) then
						for j = 1, 5 do
							InutilLib.SetTimer( j*15,function()
								yandereWaifu.ThrowDarkKnife(player, eff.Position, Vector.FromAngle(angle):Resized(15))
							end)
						end
					end
				end
			--	yandereWaifu.GetEntityData(target).delay = data.delay
			--end)
			--devil's umbrella synergy
			if FiendFolio and player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.DEVILS_UMBRELLA) then
				local dir = Vector.FromAngle(angle):Resized(1+player.ShotSpeed*4)
		
				if dir ~= nil then FiendFolio:firePiss(player, dir) end
			end
		else
			local newTarget
			local strongestHP = 0 -- labels the highest enemy hp
			for i, entenmies in pairs(Isaac.GetRoomEntities()) do
				if entenmies:IsEnemy() and entenmies:IsVulnerableEnemy() then
					if strongestHP <= entenmies.MaxHitPoints then
						strongestHP = entenmies.MaxHitPoints
						newTarget = entenmies
					end
				end
			end

			if newTarget then
				--if not data.delay then data.delay = 1 else data.delay = data.delay + 1 end
				--InutilLib.SetTimer( data.delay*30, function()
					angle = InutilLib.ObjToTargetAngle(eff, newTarget, true)
					if player:HasCollectible(CollectibleType.COLLECTIBLE_THE_WIZ) then --derp
						for i = -15, 15, 30 do
							beam = player:FireBrimstone( Vector.FromAngle(angle + i), eff, 2):ToLaser();
							--beam = EntityLaser.ShootAngle(1, eff.Position, angle, 5, Vector(0,-5), player):ToLaser()
							beam.Position = eff.Position
							--beam:AddTearFlags(player.TearFlags)
							beam.MaxDistance = farthestOrb
							beam.Timeout = 20
							beam.DisableFollowParent = true
							--yandereWaifu.GetEntityData(newTarget).Heretic = true
							beam:SetColor(Color(0,0,0,1,0.8,0,1),9999999,99,false,false)
							yandereWaifu.GetEntityData(beam).IsEvil = true
							if player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_KNIFE) then
								for j = 1, 5 do
									InutilLib.SetTimer( j*15,function()
										yandereWaifu.ThrowDarkKnife(player, eff.Position, Vector.FromAngle(angle + i):Resized(15))
									end)
								end
							end
						end
					else
						beam = player:FireBrimstone( Vector.FromAngle(angle), eff, 2):ToLaser();
						--beam = EntityLaser.ShootAngle(1, eff.Position, angle, 5, Vector(0,-5), player):ToLaser()
						beam:AddTearFlags(player.TearFlags)
						beam.Position = eff.Position
						--beam.Damage = player.Damage * 2
						beam.CollisionDamage = player.Damage * 2 * extraTearDmg
						beam.Timeout = 20
						beam.DisableFollowParent = true
						beam:SetColor(Color(0,0,0,1,0.8,0,1),9999999,99,false,false)
						yandereWaifu.GetEntityData(beam).IsEvil = true
						if player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_KNIFE) then
							for j = 1, 5 do
								InutilLib.SetTimer( j*15,function()
									yandereWaifu.ThrowDarkKnife(player, eff.Position, Vector.FromAngle(angle):Resized(15))
								end)
							end
						end
					end
					for i = 1, math.random(2,3) do
						if player:HasCollectible(CollectibleType.COLLECTIBLE_C_SECTION) then
							local tear = player:FireTear( eff.Position, Vector.FromAngle(math.random(1,360)):Resized(8), false, false, false):ToTear()
							tear:ChangeVariant(50)
							tear.TearFlags = tear.TearFlags | TearFlags.TEAR_PIERCING | TearFlags.TEAR_SPECTRAL
							yandereWaifu.GetEntityData(tear).IsEvilFetus = true
						end
					end
				--	yandereWaifu.GetEntityData(target).delay = data.delay
				--end)
				--devil's umbrella synergy
				if FiendFolio and player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.DEVILS_UMBRELLA) then
					local dir = Vector.FromAngle(angle):Resized(1+player.ShotSpeed*4)
			
					if dir ~= nil then FiendFolio:firePiss(player, dir) end
				end
			else
				data.HitPoints = 0
			end
		end
		data.HitPoints = 0 --kill it
		data.beam = beam

		--[[if player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_KNIFE) and not data.ThrownKnife then
			yandereWaifu.ThrowDarkKnife(player, position)
			if not data.KnifeHelper then data.KnifeHelper = InutilLib:SpawnKnifeHelper(eff, player) else
				if not data.KnifeHelper.incubus:Exists() then
					data.KnifeHelper = InutilLib:SpawnKnifeHelper(eff, player)
				end
			end
			for i = 0, 315, 360/8 do
				--local knife = InutilLib.SpawnKnife(player, (i), false, 0, SchoolbagKnifeMode.FIRE_OUT_ONLY, 1, 60, data.KnifeHelper)
				--yandereWaifu.GetEntityData(knife).IsEvil = true
				local knife = player:FireTear( eff.Position, Vector.FromAngle(i):Resized(18), false, false, false):ToTear()
				knife.Position =  eff.Position
				----local tear = InutilLib.game:Spawn(EntityType.ENTITY_TEAR, 0, player.Position, Vector.FromAngle(direction:GetAngleDegrees() - math.random(-10,10))*(math.random(10,15)), player, 0, 0):ToTear()
				knife.TearFlags = knife.TearFlags | TearFlags.TEAR_PIERCING | TearFlags.TEAR_WIGGLE;
				--knife.CollisionDamage = player.Damage * 4;
				knife:ChangeVariant(RebekahCurse.ENTITY_DARKKNIFE);
				knife.CollisionDamage = player.Damage*5*extraTearDmg
				--player.Velocity = ( player.Velocity * 0.8 ) + Vector.FromAngle( (direction):GetAngleDegrees() +180 );
				--InutilLib.SFX:Play( SoundEffect.SOUND_BIRD_FLAP, 1, 0, false, 1.5 );
				--local knife = InutilLib.SpawnKnife(player, (direction:GetAngleDegrees() - math.random(-10,10)), false, 0, SchoolbagKnifeMode.FIRE_ONCE, 1, 90)
				data.ThrownKnife = true
			end
		end]]
		
	end
	--end
end, RebekahCurse.ENTITY_EVILORB);

yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, function(_, eff)
	local sprite = eff:GetSprite()
	local data = yandereWaifu.GetEntityData(eff)
	local player = data.Parent
	for i, ent in pairs (Isaac.GetRoomEntities()) do
		if ent.Type == EntityType.ENTITY_EFFECT and ent.Variant == RebekahCurse.ENTITY_EVILORB and not yandereWaifu.GetEntityData(ent).Heretic and not ent:IsDead() then
			--print(ent.Variant, "  ", ENTITY_EVILORB)
			if (eff.Position - ent.Position):Length() <= 30 then
				eff:Remove()
				if not yandereWaifu.GetEntityData(ent).Tier then
					yandereWaifu.GetEntityData(ent).Tier = 2
				else
					yandereWaifu.GetEntityData(ent).Tier = yandereWaifu.GetEntityData(ent).Tier + 1
				end
				yandereWaifu.GetEntityData(ent).setDespawn = yandereWaifu.GetEntityData(ent).setDespawn + 100
				yandereWaifu.GetEntityData(ent).HitPoints = 10
			end
		end
	end
end, RebekahCurse.ENTITY_EVILORB);

yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, function(_, eff)
	eff.SpriteScale = Vector(0, 0)
end, RebekahCurse.ENTITY_DARKMAW);

--darkmaw effect
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local player = Isaac.GetPlayer(0)
	local sprite = eff:GetSprite()
	local data = yandereWaifu.GetEntityData(eff)
	local playerdata = yandereWaifu.GetEntityData(player)
	
	local scaleNum 
	local range = -player.TearHeight/2
	if eff.FrameCount < range then scaleNum = eff.FrameCount else scaleNum = range end
		
	if eff:GetSprite():IsFinished("Die") then
		eff:Remove()
		for i, entenmies in pairs(Isaac.GetRoomEntities()) do
			if entenmies.Position:Distance(eff.Position) <= (scaleNum*8) + entenmies.Size then
				if entenmies:IsEnemy() and entenmies:IsVulnerableEnemy() then
					InutilLib.DoKnockbackTypeI(eff, entenmies, 0.1, false)
				end
			end
		end
	elseif not  eff:GetSprite():IsPlaying("Die") then
		for i, entenmies in pairs(Isaac.GetRoomEntities()) do
			if entenmies:IsEnemy() then
				if entenmies.Position:Distance(eff.Position) <= (scaleNum*8) + entenmies.Size then
					if eff.FrameCount % 10 == (0) then --damage
						entenmies:TakeDamage(player.Damage/5, 0, EntityRef(eff), 4)
					end
					if eff.FrameCount % 3 == (0) then --suck
						entenmies.Velocity = (eff.Position - entenmies.Position):Resized(4)
					end
				end
			end
		end
		
		local scaleNum2 = scaleNum/10
		eff.SpriteScale = Vector(scaleNum2, scaleNum2)

		eff.Velocity = player.Velocity
		eff.Position = player.Position
	end
	
end,RebekahCurse.ENTITY_DARKMAW);

yandereWaifu:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, ent, damage, dmgFlag, dmgSource, dmgCountdownFrames)
	--dmgSource = dmgSource:ToLaser()
	if ent:IsEnemy() and dmgFlag ~= DamageFlag.DAMAGE_POISON_BURN then
		if (dmgSource.Type == 1 --[[or dmgSource.Entity.SpawnerType == 1]]) then
			local player = dmgSource.Entity:ToPlayer()
			--local player = dmgSource.Entity.SpawnerEntity:ToPlayer()
			local playerType = player:GetPlayerType()
			local room = InutilLib.game:GetRoom()
			if yandereWaifu.GetEntityData(player).currentMode == RebekahCurse.REBECCA_MODE.EvilHearts then
				if (ent.HitPoints - damage) > 0 and ent.MaxHitPoints >=1800 then
					if dmgFlag == DamageFlag.DAMAGE_LASER and ent.FrameCount % 60 == 0 then
						--print(ent.HitPoints)
						ent.HitPoints = ent.HitPoints - damage
						--print("slim shady")
						--print(ent.HitPoints)
						--print(damage)
					end
				end
			end
		end
	end
end)

--dark boom effects
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local player = Isaac.GetPlayer(0)
	local sprite = eff:GetSprite()
	local data = eff:GetData()
	
	if eff.FrameCount == 1 then
		sprite:Play("Spawn", true) --normal attack
	elseif sprite:GetFrame() == 2 then
		--[[for i, entenmies in pairs(Isaac.GetRoomEntities()) do --suck enemies away
			if entenmies:IsEnemy() and entenmies:IsVulnerableEnemy() then
				if entenmies.Position:Distance(player.Position) < entenmies.Size + player.Size + 100 then
					entenmies.Velocity = (entenmies.Velocity - (entenmies.Position - player.Position)) * 0.8
				end
			end
		end]]
	elseif sprite:IsFinished("Spawn") then
		eff:Remove()
	end
end, RebekahCurse.ENTITY_DARKBOOM)
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local player = Isaac.GetPlayer(0)
	local sprite = eff:GetSprite()
	local data = eff:GetData()
	
	if eff.FrameCount == 1 then
		sprite:Play("Spawn", true) --normal attack
	elseif sprite:IsFinished("Spawn") then
		eff:Remove()
	end
end, RebekahCurse.ENTITY_DARKBOOM2)
--dark knife
function yandereWaifu:DarkKnifeUpdate(tr, _)
	if tr.Variant == RebekahCurse.ENTITY_DARKKNIFE then
		local angleNum = (tr.Velocity):GetAngleDegrees();
		tr:GetSprite().Rotation = angleNum;
		tr:GetData().Rotation = tr:GetSprite().Rotation;
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, yandereWaifu.DarkKnifeUpdate)

function yandereWaifu:DarkKnifeRender(tr, _)
	if tr.Variant == RebekahCurse.ENTITY_DARKKNIFE and tr.FrameCount == 1 then
		tr:GetSprite():Play("RegularTear", true);
		if TaintedTreasure and yandereWaifu.GetEntityData(tr).IsBottle then
			if tr.SpawnerEntity:GetData().BrokenBottle then
				tr:GetSprite():ReplaceSpritesheet(0, "gfx/effects/evil/tear_tt_bottle_broken.png")
			else
				tr:GetSprite():ReplaceSpritesheet(0, "gfx/effects/evil/tear_tt_bottle.png")
			end
		end
		tr:GetSprite():LoadGraphics()
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_POST_TEAR_RENDER, yandereWaifu.DarkKnifeRender)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
--function yandereWaifu:DarkKnifeFadeUpdate(tr, _)
	if eff.Variant == RebekahCurse.ENTITY_DARKKNIFEFADE then
		--eff:GetSprite().Rotation = eff:GetData().Rotation;
		if eff:GetSprite():IsFinished("RegularTear") then
			eff:Remove()
		end
	end
end)

--yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, yandereWaifu.DarkKnifeFadeUpdate, RebekahCurse.ENTITY_DARKKNIFEFADE)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, function(_, tr)
	if tr.Variant == RebekahCurse.ENTITY_DARKKNIFE then
		if yandereWaifu.GetEntityData(tr).IsBottle then
			InutilLib.SFX:Play(TaintedSounds.BOTTLE_BREAK2)
			InutilLib.SFX:Play(SoundEffect.SOUND_DEMON_HIT)
			local shardvec = RandomVector()
			for i = 1, 2 do
				local shard = Isaac.Spawn(1000, TaintedEffects.BOTTLE_SHARD, 0, tr.Position, (shardvec * math.random(2,4)):Rotated(i * (360/5)), tr)
				shard.CollisionDamage = math.max(3.5, tr.CollisionDamage/2)
			end
			yandereWaifu.SpawnEvilOrb(tr.SpawnerEntity:ToPlayer(), tr.Position)
		else
			local part = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_DARKKNIFEFADE, 0, tr.Position, Vector(0,0), tr) --heart effect
			part:GetSprite().Rotation = tr:GetSprite().Rotation
		end
	end
end, EntityType.ENTITY_TEAR)

--bomb dark effect
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local player = Isaac.GetPlayer(0)
	local sprite = eff:GetSprite()
	local data = eff:GetData()
	
	if eff.FrameCount == 1 then
		sprite:Play("Explosion", true) --normal attack
		speaker:Play(SOUND_LASEREXPLOSION, 10, 0, false, 1);
		speaker:Play(SoundEffect.SOUND_BOSS1_EXPLOSIONS , 1, 0, false, 0.4);
		local ashes = Isaac.Spawn( EntityType.ENTITY_EFFECT, 18, 0, eff.Position, Vector( 0 , 0 ), player );
		ashes.SpriteScale = Vector(2.5, 2.5);
		for i, grid in pairs(InutilLib.GetRoomGrids()) do
			if (grid.Position-eff.Position):LengthSquared() <= 100 ^ 2 and grid ~= nil then
				if game:GetRoom():CheckLine(grid.Position, eff.Position, 2, 0) then
					grid:Destroy()
				end
			end
		end
	elseif eff.FrameCount >= 4 then
		for i, entenmies in pairs(Isaac.GetRoomEntities()) do
			--if entenmies:IsEnemy() then
				if entenmies.Position:Distance(eff.Position) <= (150) + entenmies.Size then
					--damage
					if entenmies:IsEnemy() then
						entenmies:TakeDamage(player.Damage*5, DamageFlag.DAMAGE_EXPLOSION, EntityRef(eff), 4)
					else
						entenmies:TakeDamage(2, DamageFlag.DAMAGE_EXPLOSION, EntityRef(eff), 4)
					end
					--suck
					entenmies.Velocity = (eff.Position - entenmies.Position):Resized(4)
				end
			--end
		end
		game:ShakeScreen(3)
	end
	if sprite:IsFinished("Explosion") then
		eff:Remove()
	end
end, RebekahCurse.ENTITY_DARKSUPERNOVA)
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local player = Isaac.GetPlayer(0)
	local sprite = eff:GetSprite()
	local data = yandereWaifu.GetEntityData(eff)
	
	if eff.FrameCount == 1 then
		if data.Sub then
			sprite:Play("SpinSmall", true) --normal attack
		else
			sprite:Play("Spin", true) --normal attack
		end
	elseif InutilLib.IsFinishedMultiple(sprite, "SpinSmall", "Spin")  then
		eff:Remove()
		local orb = Isaac.Spawn( EntityType.ENTITY_EFFECT, ENTITY_DARKSUPERNOVA, 0, eff.Position, Vector( 0 , 0 ), player );
	end
	if eff.FrameCount % 3 == 0 then
		speaker:Play(SOUND_DEEPELECTRIC, 5, 0, false, 1);
	end
	eff.Velocity = eff.Velocity * 0.9
end, RebekahCurse.ENTITY_DARKPLASMA)

--hole fabric effect
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, function(_, eff)
	local player = Isaac.GetPlayer(0)
	local sprite = eff:GetSprite()
	
	if player:HasWeaponType(WeaponType.WEAPON_ROCKETS) then
		sprite:ReplaceSpritesheet(0, "gfx/effects/hole_fabric_epic.png") 
	end
	if player:HasWeaponType(WeaponType.WEAPON_KNIFE) then
		sprite:ReplaceSpritesheet(2, "gfx/effects/hole_fabric_spike.png") 
	end
end, ENTITY_HOLEFABRIC);

yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local player = yandereWaifu.GetEntityData(eff).Parent:ToPlayer();
	local sprite = eff:GetSprite();
	local data = yandereWaifu.GetEntityData(eff);
	
	if eff.FrameCount == 1 then
		if not data.setDespawn then data.setDespawn = math.random( 30, 200 ) end
		if not data.extraTears then data.extraTears = 0 end
		if player:HasCollectible(CollectibleType.COLLECTIBLE_INNER_EYE) and player:HasCollectible(CollectibleType.COLLECTIBLE_MUTANT_SPIDER) then
			data.extraTears = 7
		elseif player:HasCollectible(CollectibleType.COLLECTIBLE_INNER_EYE) then
			data.extraTears = 3
		elseif player:HasCollectible(CollectibleType.COLLECTIBLE_MUTANT_SPIDER) then
			data.extraTears = 4
		else
			data.extraTears = 1
		end
	end

	if eff.FrameCount == 1 then
		sprite:Play( "Appear", true ); --normal attack
		eff.SpriteOffset = Vector( 0, -20 );
		sprite:LoadGraphics();
		speaker:Play( SoundEffect.SOUND_MAW_OF_VOID, 1, 0, false, 1);
	elseif sprite:IsFinished("Appear") then
		if player:HasCollectible(CollectibleType.COLLECTIBLE_LITTLE_HORN) then
			sprite:Play( "IdleHorn", true );
		else
			sprite:Play( "Idle", true );
		end
	elseif sprite:IsPlaying("IdleHorn")then
		if sprite:IsEventTriggered("Grab") then
			speaker:Play(SoundEffect.SOUND_BOSS_LITE_ROAR, 1, 0, false, 1)
			speaker:Play(SoundEffect.SOUND_FORESTBOSS_STOMPS, 1, 0, false, 1)
			game:ShakeScreen(5)
			for i, entenmies in pairs(Isaac.GetRoomEntities()) do
				if entenmies:IsEnemy() then
					if entenmies.Position:Distance(eff.Position) <= (200) + entenmies.Size then
						--damage
						if entenmies.Position:Distance(eff.Position) <= (180) + entenmies.Size then
							if not entenmies:IsBoss() then
								--entenmies:Kill()
							else
								entenmies:TakeDamage(player.Damage*10, 0, EntityRef(eff), 4)
							end
						end
						--succ
						entenmies.Velocity = (eff.Position - entenmies.Position):Resized(10)
					end
				end
			end
		end
	elseif sprite:IsPlaying("Idle")then
		if player:HasWeaponType(WeaponType.WEAPON_LASER) then --tech barrage
			if eff.FrameCount % 3 == 0 then
				local rng = math.random(1,360)
				local techlaser = player:FireTechLaser(eff.Position, 0, Vector.FromAngle(rng), false, true)
				techlaser.Timeout = 3;
				techlaser:SetMaxDistance(math.random(100,120))
				techlaser:SetHomingType(1)
				techlaser.CollisionDamage = player.Damage / 2;
				
				local customColor = Color(0, 0, 0, 0, 0, 0, 0)
				techlaser:SetColor(customColor, 2, 5, true, true)
			end
		end
		if sprite:IsEventTriggered("Suck") then
			local suck = Isaac.Spawn( EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_DARKBOOM, 0, eff.Position, Vector( 0 , 0 ), player );
			speaker:Play(SoundEffect.SOUND_BIRD_FLAP, 1, 0, false, 0.3);
			if player:HasWeaponType(WeaponType.WEAPON_KNIFE) then --knife synergy
				local randomNum = math.random(-30,30)
				for i = 0, 360, 360/8 do
					local tear = player:FireTear( eff.Position, Vector.FromAngle(i+randomNum):Resized(50), false, false, false):ToTear()
					tear.Position = eff.Position
					tear.TearFlags = tear.TearFlags | TearFlags.TEAR_HOMING | TearFlags.TEAR_PIERCING;
					tear.CollisionDamage = player.Damage * 2;
					tear:ChangeVariant(RebekahCurse.ENTITY_DARKKNIFE);
				end
			end
			if player:HasWeaponType(WeaponType.WEAPON_TECH_X) then
				local random = math.random(3,6)
				for i = 1, random do
					local circle = player:FireTechXLaser(eff.Position, Vector.FromAngle(math.random(1,360))*(20), math.random(10,20))
					circle:SetColor(Color(0,0,0,0.7,170,170,210),9999999,99,false,false);
				end
			end
		elseif sprite:IsEventTriggered("Hyperbeam") then
			if player:HasWeaponType(WeaponType.WEAPON_BOMBS) then 
				sprite:Play("Death", true);
				local orb = Isaac.Spawn( EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_DARKPLASMA, 0, eff.Position, Vector( 0 , 0 ), player );
				
				if data.extraTears > 1 then
					local orb2 = Isaac.Spawn( EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_DARKPLASMA, 0, eff.Position, Vector.FromAngle(math.random(0,360)):Resized(5), player );
					yandereWaifu.GetEntityData(orb2).Sub = true
				end
			elseif not player:HasWeaponType(WeaponType.WEAPON_ROCKETS) then
				data.EnemyHasDefined = nil; --force it to nil
				data.highestHp = 0;
				for i, entities in pairs(Isaac.GetRoomEntities()) do
					if entities:IsEnemy() and entities.HitPoints > data.highestHp then
						data.highestHp = entities.HitPoints
						data.EnemyHasDefined = entities
					end
				end
				if data.EnemyHasDefined then
					local angle = (data.EnemyHasDefined.Position - eff.Position):GetAngleDegrees();
					data.targetAngle = angle;
					data.targetPos = data.EnemyHasDefined.Position;
					local laserType
					if player:HasCollectible(CollectibleType.COLLECTIBLE_POLYPHEMUS) then
						laserType = 6
					else
						laserType = 1
					end
					local hyperbeamlol = EntityLaser.ShootAngle(laserType, eff.Position, data.targetAngle, 10 * laserType, Vector(0,0), player):ToLaser();
					if not yandereWaifu.GetEntityData(hyperbeamlol).IsDark then 
						if laserType == 1 then
							yandereWaifu.GetEntityData(hyperbeamlol).IsDark = 1 
						else
							yandereWaifu.GetEntityData(hyperbeamlol).IsDark = 2 
						end
					end
					hyperbeamlol.DisableFollowParent = true;
					hyperbeamlol.CollisionDamage = (player.Damage * 1.77)/2
					hyperbeamlol.TearFlags = player.TearFlags | TearFlags.TEAR_HOMING
				end
			end
		elseif sprite:WasEventTriggered("Hyperbeam") then
			if player:HasWeaponType(WeaponType.WEAPON_ROCKETS) then 
				for i, entenmies in pairs(Isaac.GetRoomEntities()) do
					if entenmies:IsEnemy() then
						if entenmies.Position:Distance(eff.Position) <= (600) + entenmies.Size then
							--damage
							if entenmies.Position:Distance(eff.Position) <= (50) + entenmies.Size then
								entenmies:TakeDamage(player.Damage, 0, EntityRef(eff), 4)
							end
							--succ
							entenmies.Velocity = (eff.Position - entenmies.Position):Resized(10)
						end
					end
				end
			end
		end
		if math.random(1,5) == 5 then
			SpawnHeartParticles( 1, 1, eff.Position, RandomHeartParticleVelocity(), player, HeartParticleType.Evil );
		end
	elseif InutilLib.IsFinishedMultiple(sprite,"Idle","IdleHorn") then
		if data.extraTears > 1 then
			data.extraTears = data.extraTears - 1
			sprite:Play("Idle", true);
		else
			sprite:Play("Death", true);
			if player:HasWeaponType(WeaponType.WEAPON_ROCKETS) then 
				local orb = Isaac.Spawn( EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_DARKSUPERNOVA, 0, eff.Position, Vector( 0 , 0 ), player );
			end
		end
	elseif sprite:IsFinished("Death") then
		eff:Remove();
		for i, orb in pairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, ENTITY_EVILORB, -1, false, false)) do
			if orb.Position:Distance(eff.Position) < orb.Size + eff.Size + 100 then
				yandereWaifu.GetEntityData(orb).ChainExplode = true
			end
			local part = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_DARKBOOM2, 0, eff.Position, Vector(0,0), player);
		end
	end
end, RebekahCurse.ENTITY_HOLEFABRIC);

yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local player = yandereWaifu.GetEntityData(eff).Parent:ToPlayer();
	local sprite = eff:GetSprite();
	local data = yandereWaifu.GetEntityData(eff);
	
	if eff.FrameCount == 1 then
		sprite:Play("SpinLeft")
	end
	
	local numofShots = 1
	local tearSize = 0
		
	if player:HasCollectible(CollectibleType.COLLECTIBLE_MUTANT_SPIDER) then
		--curAng = -25
		numofShots = numofShots + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_MUTANT_SPIDER) * 3
	end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_20_20) then
		--curAng = -25
		numofShots = numofShots + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_20_20) 
	end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_INNER_EYE) then
		--curAng = -20
		numofShots = numofShots + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_INNER_EYE) * 2
	end
	
	if eff.FrameCount % numofShots == (0) then
		for i, ent in pairs (Isaac.GetRoomEntities()) do
			if ent:IsEnemy() and ent:IsVulnerableEnemy() and not ent:IsDead() then
				if ent.Position:Distance((eff.Position)) <= 150 then
					ent:TakeDamage((player.Damage * numofShots)/2, 0, EntityRef(eff), 1)
				end
			end
		end
	end
	
	if sprite:IsFinished("SpinLeft") then
		eff:Remove()
	end

end, RebekahCurse.ENTITY_DARKSPIRITSWORD);
--end
