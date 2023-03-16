local crystalGainFrame = 0

local function ThrowCursedSword(player, notSpecial)
    local data = yandereWaifu.GetEntityData(player)
    local sword
        sword = player:FireTear( player.Position, Vector(0,15):Rotated(data.taintedCursedDir-90):Resized(4+player.ShotSpeed*10), false, false, false):ToTear()
        -- local sword = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0, player.Position, Vector(0,20):Rotated(data.taintedCursedDir-90), player):ToTear()
        sword:AddTearFlags(TearFlags.TEAR_BOOMERANG --[[| TearFlags.TEAR_PIERCING]])
        sword.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ENEMIES
        yandereWaifu.GetEntityData(sword).IsCursedSword = true
        yandereWaifu.GetEntityData(sword).state = 1
        if player:HasWeaponType(WeaponType.WEAPON_BRIMSTONE) then
            sword.Velocity = sword.Velocity * 1.4
            sword:AddTearFlags(TearFlags.TEAR_PIERCING)
        end
        if player:HasWeaponType(WeaponType.WEAPON_FETUS) then
            local tear = player:FireTear( player.Position, Vector(0,15):Rotated(data.taintedCursedDir-90):Resized(4+player.ShotSpeed*10), false, false, false):ToTear()
            tear:ChangeVariant(50)
            tear.TearFlags = tear.TearFlags | TearFlags.TEAR_PIERCING | TearFlags.TEAR_SPECTRAL
            if math.random(1,4) == 4 then
                yandereWaifu.GetEntityData(tear).IsEsauFetus = true
            else
                yandereWaifu.GetEntityData(tear).IsJacobFetus = true
            end
        end
        if not notSpecial then
            data.CantGiveCrystal = true
            data.CantTaintedSkill = true
            data.CanShoot = false

            data.taintedWeapon.Visible = false
        end
    return sword
end

local function TeleportToClosestEnemy(player)
    local data = yandereWaifu.GetEntityData(player)
    local e = InutilLib.GetClosestGenericEnemy(player, 300)
    if e then
        data.LastChargePos = player.Position
        player.Position = e.Position
        data.invincibleTime = 99999999
        data.IsCursedCharging = true
    end

	--data.taintedWeapon = Isaac.Spawn( EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_REBEKAHCURSEDWEAPON, 0, player.Position,  Vector(0,0), player );
     -- yandereWaifu.GetEntityData(data.taintedWeapon).Player = player

     --yandereWaifu.GetEntityData(data.taintedWeapon).state = 2
     -- yandereWaifu.GetEntityData(data.taintedWeapon).Angle = data.taintedCursedDir
end

--deprecated
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local player = yandereWaifu.GetEntityData(eff).Player
	local controller = player.ControllerIndex;
	local sprite = eff:GetSprite();
	local room =  Game():GetRoom();
	local data = yandereWaifu.GetEntityData(player)
    local roomClampSize = math.max( player.Size, 20 );
	
	yandereWaifu.GetEntityData(player).invincibleTime = 60
	--movement code
	eff.GridCollisionClass =  EntityGridCollisionClass.GRIDCOLL_NOPITS;

	local movementDirection = player:GetMovementInput();
	
	player.Velocity = player.Velocity * 1.2
	eff.Velocity = player.Velocity;
	eff.Position = player.Position --room:GetClampedPosition(eff.Position, roomClampSize);
	
		--eff.Velocity = player.Velocity;
	--else
	--	eff.Velocity = (eff.Velocity * 0.9) + movementDirection:Resized( REBEKAH_BALANCE.SOUL_HEARTS_DASH_TARGET_SPEED );
	--end
	
	--function code
	--player.Velocity = (room:GetClampedPosition(eff.Position, roomClampSize) - player.Position)--*0.5;
	if eff.FrameCount == 1 then
		player.Visible = true
		--InutilLib.SFX:Play( RebekahCurseSounds.SOUND_SOULJINGLE, 1, 0, false, 1 );
		sprite:Play("Idle", true);
		data.LastEntityCollisionClass = player.EntityCollisionClass;
		data.LastGridCollisionClass = player.GridCollisionClass;
		--trail
		data.trail = InutilLib.SpawnTrail(eff, Color(1,0,0.5,0.5))
		data.movementCountFrame = 50
	elseif sprite:IsFinished("Idle") then
		sprite:Play("Blink",true);
	end
	
    if (eff.FrameCount >= 15) then
        player.Velocity = Vector( 0, 0 );
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
    	eff:Remove();
		data.trail:Remove()
    	
    	data.IsUninteractible = false;
    	InutilLib.SFX:Play( SoundEffect.SOUND_WEIRD_WORM_SPIT, 1, 0, false, 1 );

        player.GridCollisionClass = yandereWaifu.GetEntityData(player).LastGridCollisionClass;
		player.EntityCollisionClass = yandereWaifu.GetEntityData(player).LastEntityCollisionClass;
			
		--reset
		yandereWaifu.GetEntityData(player).LastEntityCollisionClass = nil
		yandereWaifu.GetEntityData(player).LastGridCollisionClass = nil

        yandereWaifu.GetEntityData(player).IsDashActive = false
        yandereWaifu.GetEntityData(player).CantTaintedSkill = false
        yandereWaifu.GetEntityData(player).CantGiveCrystal = false

        --stun thingy
         for i, ent in pairs (Isaac.GetRoomEntities()) do
            if (ent:IsEnemy() and ent:IsVulnerableEnemy()) or ent.Type == EntityType.ENTITY_FIREPLACE and not ent:IsDead() then
                local dmg = 2
                local additDistance = 0+player.Size
                if ent.Position:Distance((eff.Position)) <= 50 + additDistance then
                    ent:TakeDamage((player.Damage/3) * dmg, 0, EntityRef(player), 1)
                    ent:AddFreeze(EntityRef(player), 60)
                end
            end
        end
			
    else
		player:SetColor(Color(0,0,0,0.2,0,0,0),3,1,false,false)
    	player.GridCollisionClass =  EntityGridCollisionClass.GRIDCOLL_WALLS;
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
end, RebekahCurse.ENTITY_TAINTEDCURSEDASHTARGET)


yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local target = yandereWaifu.GetEntityData(eff).Target
	local sprite = eff:GetSprite();
	local room =  Game():GetRoom();
	eff.Velocity = target.Velocity;
	eff.Position = target.Position --room:GetClampedPosition(eff.Position, roomClampSize);
	
    if target and target:IsDead() then
        eff:Remove()
    elseif not target then
        eff:Remove()
    end
end, RebekahCurse.ENTITY_TAINTEDCURSEENEMYTARGET)

--deprecated
function yandereWaifu.CursedHeartTeleport(player, vector)
	local playerdata = yandereWaifu.GetEntityData(player)
	local SubType = 0
	local trinketBonus = 0
	if player:HasTrinket(RebekahCurseTrinkets.TRINKET_ISAACSLOCKS) then
		trinketBonus = 5
	end
	--local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_PERSONALITYPOOF, 0, player.Position, Vector.Zero, player)
	
	local customBody = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_TAINTEDCURSEDASHTARGET, 0, player.Position, Vector(0,0), player) --body effect
	yandereWaifu.GetEntityData(customBody).Player = player
	player.Velocity = Vector( 0, 0 );
	--yandereWaifu.SpawnPoofParticle( player.Position, Vector(0,0), player, RebekahPoofParticleType.Blue );
	yandereWaifu.SpawnHeartParticles( 3, 5, player.Position, yandereWaifu.RandomHeartParticleVelocity(), player, RebekahHeartParticleType.Blue );
	playerdata.specialCooldown = REBEKAH_BALANCE.SOUL_HEARTS_DASH_COOLDOWN/2 - trinketBonus;
	playerdata.invincibleTime = REBEKAH_BALANCE.SOUL_HEARTS_DASH_INVINCIBILITY_FRAMES;
	InutilLib.SFX:Play( SoundEffect.SOUND_WEIRD_WORM_SPIT, 1, 0, false, 1 );
	playerdata.IsUninteractible = true
	playerdata.IsDashActive = true
    playerdata.CantTaintedSkill = true
    playerdata.CantGiveCrystal = true
end

function yandereWaifu.CursedHeartStomp(player, vector)
    local playerdata = yandereWaifu.GetEntityData(player)
    local SubType = 0
	local trinketBonus = 0
	if player:HasTrinket(RebekahCurseTrinkets.TRINKET_ISAACSLOCKS) then
		trinketBonus = 5
	end
    InutilLib.game:MakeShockwave(player.Position, 0.065, 0.025, 10)

	Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 1, player.Position, Vector(0,0), player)

    playerdata.specialCooldown = REBEKAH_BALANCE.SOUL_HEARTS_DASH_COOLDOWN/2 - trinketBonus;
	playerdata.invincibleTime = REBEKAH_BALANCE.SOUL_HEARTS_DASH_INVINCIBILITY_FRAMES;
    playerdata.IsDashActive = true
    InutilLib.SFX:Play( SoundEffect.SOUND_FORESTBOSS_STOMPS, 1, 0, false, 1 );

    local radisu = 65
    for i, ent in pairs (Isaac.GetRoomEntities()) do
        if (ent:IsEnemy() and ent:IsVulnerableEnemy()) or ent.Type == EntityType.ENTITY_FIREPLACE and not ent:IsDead() then
            local additDistance = 0
            if ent.Position:Distance(player.Position) <= radisu + additDistance + ent.Size then
                ent:AddFreeze(EntityRef(player), 30)
            end
        end
    end
end

--spawning knife

function yandereWaifu.SpawnCursedKnife(player)
   -- local state = state or 1
   -- local angle = angle or player:GetShootingInput():GetAngleDegrees()
    local data = yandereWaifu.GetEntityData(player)
   -- local willFlip = flip or false
    data.taintedWeapon = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_REBEKAHCURSEDWEAPON, 0, player.Position,  Vector(0,0), player );
    yandereWaifu.GetEntityData(data.taintedWeapon).Player = player
    yandereWaifu.GetEntityData(data.taintedWeapon).state = 0
end

function yandereWaifu.SpawnAndSwingCursedKnife(player, state, angle, flip, pos)
    local state = state or 1
    local angle = angle or player:GetShootingInput():GetAngleDegrees()
    local data = yandereWaifu.GetEntityData(player)
    local willFlip = flip or false
    local taintedWeapon = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_REBEKAHCURSEDWEAPON, 0, pos or player.Position,  Vector(0,0), player );
    yandereWaifu.GetEntityData(taintedWeapon).Player = player
    yandereWaifu.GetEntityData(taintedWeapon).Temp = true

    if pos then
        yandereWaifu.GetEntityData(taintedWeapon).MovementIndependent = true
    end


    taintedWeapon:SetColor(Color(0.5,0.5,0.5,1,0,0,0),99999999,1,false,false)

    yandereWaifu.SwingCursedKnife(player, taintedWeapon, state, angle, flip)
    return taintedWeapon
end

function yandereWaifu.SwingCursedKnife(player, weapon, state, angle, flip)
    local state = state or 1
    local angle = angle or player:GetShootingInput():GetAngleDegrees()
    local data = yandereWaifu.GetEntityData(player)
    local willFlip = flip or false
    local weapon = weapon or data.taintedWeapon
   if not (weapon) then return end


   if data.IsGlorykillMode then
        weapon:GetSprite().PlaybackSpeed = 2
   else
        weapon:GetSprite().PlaybackSpeed = 1
   end
    yandereWaifu.GetEntityData(weapon).state = state
    yandereWaifu.GetEntityData(weapon).Angle = angle
    yandereWaifu.GetEntityData(weapon).willFlip = willFlip

    data.CantTaintedSkill = true
    if state ~= 1 then
        data.CantGiveCrystal = true
    end


    --lead pencil synergy
	if player:HasCollectible(CollectibleType.COLLECTIBLE_LEAD_PENCIL) then
        if not data.LeadPencilCount then data.LeadPencilCount = 1 end
        if data.LeadPencilCount >= 15 then
            local numLimit = 9
            for i = 1, numLimit do
                        
                --InutilLib.SetTimer( i * 3, function()
                    local chosenNumofBarrage = 4

                    for i = 1, chosenNumofBarrage do
                        local tear = player:FireTear(player.Position, Vector.FromAngle(angle - math.random(-10,10))*(math.random(7,12)):Resized(player.ShotSpeed*10), false, false, false):ToTear()
                        tear.Position = player.Position
                        if tear.Variant == 0 then tear:ChangeVariant(TearVariant.BLOOD) end
                        tear.Scale = math.random(07,14)/10
                        tear.Scale = tear.Scale
                        tear.FallingSpeed = -10 + math.random(1,3)
                        tear.FallingAcceleration = 0.5
                        tear.CollisionDamage = player.Damage * 3.5
                        --tear.BaseDamage = player.Damage * 2
                    end
               -- end)
            end
            data.LeadPencilCount = 1
        else
            data.LeadPencilCount = data.LeadPencilCount + 1
        end
	end
    --pencil sharpener synergy
	if player:HasCollectible(RebekahCurseItems.COLLECTIBLE_PENCILSHARPENER) then
		if data.lastPSRPFrameCount then
			if InutilLib.game:GetFrameCount() == data.lastPSRPFrameCount then
				return
			end
			
			data.lastPSRPFrameCount = InutilLib.game:GetFrameCount()
			
			if not data.PSRPFireCount then
				data.PSRPFireCount = 1
			else
				data.PSRPFireCount = data.PSRPFireCount + 1
			end
			
			if data.PSRPFireCount > 7 then
				data.PSRPFireCount = 0
				for i = -45, 45, 15 do
                    local tear = player:FireTear(player.Position, Vector.FromAngle(angle+i):Resized(player.ShotSpeed*10), true, false, false, (player), 1)
                    tear:AddTearFlags(TearFlags.TEAR_PIERCING)
                    tear:ChangeVariant(TearVariant.CUPID_BLUE)
                end
			end
		else
			data.lastPSRPFrameCount = InutilLib.game:GetFrameCount()
		end
	end

     --eye of greed synergy
	if player:HasCollectible(CollectibleType.COLLECTIBLE_EYE_OF_GREED) then
        if not data.EyeOfGreedCount then data.EyeOfGreedCount = 1 end
        if data.EyeOfGreedCount >= 20 then
            player:AddCoins(-1)
            data.EyeOfGreedCount = 1
            yandereWaifu.GetEntityData(data.taintedWeapon).canMidas = true
            data.taintedWeapon:GetSprite().Color = Color( 1, 1, 1, 1, 155, 155, 0 );
        else
            data.EyeOfGreedCount = data.EyeOfGreedCount + 1
        end
	end
end

yandereWaifu:AddCallback(ModCallbacks.MC_POST_NEW_ROOM,
function()
    local hasTaintedReb = false
    local num_players = Game():GetNumPlayers()
    for i=0,(num_players-1) do
        local player = Isaac.GetPlayer(i)
        local data = yandereWaifu.GetEntityData(player)
        if not yandereWaifu.IsTaintedRebekah(player) then return end
        data.CanShoot = true
        data.CantTaintedSkill = false
        data.CantGiveCrystal = false

        if not data.taintedWeapon or data.taintedWeapon:IsDead() then
            yandereWaifu.SpawnCursedKnife(player)
        end

        --data.taintedWeaponIdle = Isaac.Spawn( EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_SWORDOFHOPEEFFECT, 0, player.Position,  Vector(0,0), player );
        --yandereWaifu.GetEntityData(data.taintedWeaponIdle).Player = player

        if data.TAINTEDREBSKILL_MENU then
            data.TAINTEDREBSKILL_MENU:ToggleMenu(false)
        end

        crystalGainFrame = 0
    end
end
)


yandereWaifu:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_,player)
    local data = yandereWaifu.GetEntityData(player)

    if data.CanShoot == nil then data.CanShoot = true end
    if data.taintedWeapon and data.taintedWeapon:IsDead() then
        data.taintedWeapon = nil
        data.CanShoot = true
        data.CantTaintedSkill = false
    end
	if yandereWaifu.IsTaintedRebekah(player) then
        local numofShots = 1
        local tearIntervalPenalty = 0
        
        --neptunus synergy
        if not data.NeptunusTRebCount then data.NeptunusTRebCount = 0 end
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
        if player:HasCollectible(CollectibleType.COLLECTIBLE_SOY_MILK) or player:HasCollectible(CollectibleType.COLLECTIBLE_ALMOND_MILK) then
            --curAng = -20
            numofShots = numofShots*5
            tearIntervalPenalty = -15
        end
        if TaintedTreasure and player:HasCollectible(TaintedCollectibles.SPIDER_FREAK) then
            numofShots = numofShots + player:GetCollectibleNum(TaintedCollectibles.SPIDER_FREAK) * 5
        end

        numofShots = numofShots + math.min(data.NeptunusTRebCount)

        --if menu open, slow down
        if data.TAINTEDREBSKILL_MENU and data.TAINTEDREBSKILL_MENU.open then
            player.Velocity = player.Velocity * 0.7
            if data.taintedWeaponIdle then 
                data.taintedWeaponIdle:Remove()
                data.taintedWeaponIdle = nil
                data.taintedWeaponCount = 180
            end
        end

        --reimplement tear delay
        if data.TaintedTearDelay then
            if data.TaintedTearDelay > 0 then
                data.TaintedTearDelay = data.TaintedTearDelay - 1
            end
        end
         --pre charging code
         if player:GetFireDirection() == -1 then --if not firing
			if data.taintedCursedTick then
				if data.taintedCursedTick >= 30 then
                    --TeleportToClosestEnemy(player)
                    if player:HasWeaponType(WeaponType.WEAPON_BOMBS) then
                        local bomb = player:FireBomb(player.Position, Vector(0,15):Rotated(data.taintedCursedDir-90):Resized(2+player.ShotSpeed), player)
                        bomb:SetExplosionCountdown(75)
                    elseif player:HasWeaponType(WeaponType.WEAPON_SPIRIT_SWORD) then
                        local sword = player:FireTear( player.Position, Vector(0,15):Rotated(data.taintedCursedDir-90):Resized(20+player.ShotSpeed), false, false, false):ToTear()
                        sword:AddTearFlags(TearFlags.TEAR_PIERCING|TearFlags.TEAR_BURN)
                    else
                        local sword = ThrowCursedSword(player)
                        yandereWaifu.GetEntityData(sword).Sword = data.taintedWeapon
                    end
                    --[[for i = -30, 30, 15 do
                        local tear = player:FireTear(player.Position, Vector.FromAngle(data.taintedCursedDir+i):Resized(player.ShotSpeed*10), true, false, false, (player), 1)
                        tear.CollisionDamage = player.Damage * 1.5
                        tear.Scale = tear.Scale*1.5
                    end]]
                end
			end
			data.taintedCursedTick = 0
            if player:HasCollectible(CollectibleType.COLLECTIBLE_NEPTUNUS) and data.NeptunusTRebCount < 10 then
                data.NeptunusTRebCount = data.NeptunusTRebCount + 0.1
            end
		else
            --if data.IsCursedCharging then return end
			if not data.taintedCursedTick then data.taintedCursedTick = 0 end
			
			data.taintedCursedTick = data.taintedCursedTick + 1
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
			data.taintedCursedDir = dir

            data.NeptunusTRebCount = 0
		end

        --when swinging
        if --[[not data.taintedWeapon and]] (Input.IsActionPressed(ButtonAction.ACTION_SHOOTLEFT, player.ControllerIndex) or Input.IsActionPressed(ButtonAction.ACTION_SHOOTRIGHT, player.ControllerIndex) or Input.IsActionPressed(ButtonAction.ACTION_SHOOTUP, player.ControllerIndex) or Input.IsActionPressed(ButtonAction.ACTION_SHOOTDOWN, player.ControllerIndex)) then
            if not data.CanShoot then return end
            if data.TAINTEDREBSKILL_MENU.open then return end
            if data.TaintedTearDelay > 0 then return end

            if not data.taintedWeapon or data.taintedWeapon:IsDead() then
                yandereWaifu.SpawnCursedKnife(player)
            end

            local IsLokiHornsTriggered = false

            if player:HasCollectible(CollectibleType.COLLECTIBLE_LOKIS_HORNS) and math.random(0,10) + player.Luck >= 10 then
                IsLokiHornsTriggered = true
            else
                IsLokiHornsTriggered = false
            end

            local isOriginal = true

            --eyesore synergy
            if player:HasCollectible(CollectibleType.COLLECTIBLE_EYE_SORE) then
                if math.random(1,3) == 3 then
                    data.willEyeSoreBar = true
                    data.eyeSoreBarAngles = {
                        [1] = math.random(0,360),
                        [2] = math.random(0,360)
                    }
                else
                    data.willEyeSoreBar = false
                    data.eyeSoreBarAngles = nil
                end
            end
            if player:HasCollectible(CollectibleType.COLLECTIBLE_EYE_SORE) and data.willEyeSoreBar then
                for i, angle in pairs(data.eyeSoreBarAngles) do
                    yandereWaifu.SpawnAndSwingCursedKnife(player, 1, angle, false)
                end
            end
            local ffBeeSkinRng = math.random(-30,30)
            if FiendFolio and player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.BEE_SKIN) then
                for i = 0, 360 - 360/3, 360/3 do
                    yandereWaifu.SpawnAndSwingCursedKnife(player, 1, i+ffBeeSkinRng, false)
                end
            end
            for lhorns = 0, 270, 360/4 do
                local direction = player:GetShootingInput():GetAngleDegrees() + lhorns
                local oldDir = direction
                for wizAng = -45, 90, 135 do
                    if player:HasCollectible(CollectibleType.COLLECTIBLE_THE_WIZ) and lhorns == 0 then --sets the wiz angles
                        direction = (direction + wizAng)
                    end
                    if player:HasCollectible(CollectibleType.COLLECTIBLE_MONSTROS_LUNG) then
                        local rng = math.random(2,3)
                        for i = 1, rng do
                            InutilLib.SetTimer(0+(i*25), function()
                                local sword = yandereWaifu.SpawnAndSwingCursedKnife(player, 1, direction, false, player.Position + Vector(math.random(0, 5*i), 0):Rotated(direction))
                                yandereWaifu.GetEntityData(sword).SwordSize = 0.9
                            end)
                        end
                    end
                    for i = 0, numofShots-1, 1 do
                        local flip = false
                        if i%2 == 1 then
                            flip = true
                        end
                        InutilLib.SetTimer(0+i*(25+tearIntervalPenalty), function()
                            if player:HasCollectible(CollectibleType.COLLECTIBLE_SOY_MILK) then
                                direction = direction + math.random(-10,10)
                            end
                            if player:HasCollectible(CollectibleType.COLLECTIBLE_ALMOND_MILK) then
                                direction = direction + math.random(-20,20)
                            end
                            if isOriginal then
                                yandereWaifu.SwingCursedKnife(player, data.taintedWeapon, 1, direction, flip)
                            else
                                yandereWaifu.SpawnAndSwingCursedKnife(player, 1, direction, flip)
                            end
                        end)

                        if i == 0 then
                            isOriginal = false
                        end
                    end

                    if wizAng == -45 and not player:HasCollectible(CollectibleType.COLLECTIBLE_THE_WIZ) then
                        break -- just makes sure it doesnt duplicate
                    --[[else 
                        isOriginal = false]]
                    end
                end

                direction = oldDir
                if not IsLokiHornsTriggered then 
                    break
                --[[else
                    isOriginal = false]]
                end
            end

            --reset MaxFireDelay
            data.TaintedTearDelay = math.floor(player.MaxFireDelay*1.5)

            --reset sword
            if data.taintedWeaponIdle then 
                data.taintedWeaponIdle:Remove()
                data.taintedWeaponIdle = nil
                data.taintedWeaponCount = 180
            end

            --isaac's tears recharge because normally it doesnt charge
            if player:HasCollectible(CollectibleType.COLLECTIBLE_ISAACS_TEARS) then
                local coll = CollectibleType.COLLECTIBLE_ISAACS_TEARS
                local slot
                local maxcharge
                if player:GetActiveItem(ActiveSlot.SLOT_POCKET) == coll then
                    maxcharge = InutilLib.config:GetCollectible(player:GetActiveItem(ActiveSlot.SLOT_POCKET)).MaxCharges
                    slot = ActiveSlot.SLOT_POCKET

                elseif player:GetActiveItem(ActiveSlot.SLOT_PRIMARY) == coll then
                    maxcharge = InutilLib.config:GetCollectible(player:GetActiveItem(ActiveSlot.SLOT_PRIMARY)).MaxCharges
                    slot = ActiveSlot.SLOT_PRIMARY
                end
                if maxcharge > player:GetActiveCharge(slot) then
                    player:SetActiveCharge(player:GetActiveCharge(slot) + 1, slot)
                end
            end
        else
            --special quirky idle sword effect
            if data.taintedWeaponIdle then return end
            if not data.taintedWeaponCount then data.taintedWeaponCount = 180 end
            if data.taintedWeaponCount then
                data.taintedWeaponCount = data.taintedWeaponCount - 1
            end
            if data.taintedWeaponCount <= 0 then 
                --yandereWaifu.GetEntityData(data.taintedWeapon).state = -1
                --[[data.taintedWeaponIdle = Isaac.Spawn( EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_SWORDOFHOPEEFFECT, 0, player.Position,  Vector(0,0), player );
                yandereWaifu.GetEntityData(data.taintedWeaponIdle).Player = player]] 
            end
        end

        --charging code
       --[[ if data.IsCursedCharging then
            if not data.taintedCursedChargeTick then data.taintedCursedChargeTick = 0 end
			print("whses")
            player.Velocity = player.Velocity * 0.09
			data.taintedCursedChargeTick = data.taintedCursedChargeTick + 1
            if data.taintedCursedChargeTick <= 0 then
                data.IsCursedCharging = false
                data.taintedCursedChargeTick = nil

                player.Position = data.LastChargePos
                data.invincibleTime = 0
            end
        end]]

        --held up item
        --if not player:IsItemQueueEmpty() then
            --print(player.QueuedItem.Item.DevilPrice)
        --end
    end
end)

-- weapon state
-- 0 idle
local function canPoison(player)
    if player.TearFlags == player.TearFlags | TearFlags.TEAR_POISON then 
        return true
    elseif player:HasCollectible(CollectibleType.COLLECTIBLE_COMMON_COLD) and math.random(1,10) + player.Luck >= 10 then
        return true
    elseif player:HasCollectible(CollectibleType.COLLECTIBLE_SERPENTS_KISS) and math.random(1,10) + player.Luck >= 10 then
        return true
    elseif player:HasCollectible(CollectibleType.COLLECTIBLE_SCORPIO) then
        return true 
    end
end

local function canFear(player)
    if player.TearFlags == player.TearFlags | TearFlags.TEAR_FEAR then 
        return true
    elseif player:HasCollectible(CollectibleType.COLLECTIBLE_ABADDON) and math.random(1,12) + player.Luck >= 12 then
        return true
    elseif player:HasCollectible(CollectibleType.COLLECTIBLE_DARK_MATTER) and math.random(1,10) + player.Luck >= 10 then
        return true
    elseif player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_PERFUME) and math.random(1,14) + player.Luck >= 14 then
        return true
    end
end

local function canFreeze(player)
    if player.TearFlags == player.TearFlags | TearFlags.TEAR_FREEZE then 
        return true
    elseif player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_EYE) and math.random(1,10) + player.Luck >= 10 then
        return true
    end
end

local function canJacobsLadder(player)
    if player.TearFlags == player.TearFlags | TearFlags.TEAR_JACOBS then 
        return true
    elseif player:HasCollectible(CollectibleType.COLLECTIBLE_JACOBS_LADDER) then
        return true
    end
end

local function canHaemolacsomething(player)
    if player.TearFlags == player.TearFlags | TearFlags.TEAR_BURSTSPLIT then 
        return true
    elseif player:HasCollectible(CollectibleType.COLLECTIBLE_HAEMOLACRIA) then
        return true 
    end
end

local function canRock(player)
    if player.TearFlags == player.TearFlags | TearFlags.TEAR_ROCK then 
        return true
    elseif player:HasCollectible(CollectibleType.COLLECTIBLE_TERRA) then
        return true 
    end
end

local function canPop(player)
    if player.TearFlags == player.TearFlags | TearFlags.TEAR_POP then 
        return true
    elseif player:HasCollectible(CollectibleType.COLLECTIBLE_POP) then
        return true 
    end
end

local function canGodhead(player)
    if player.TearFlags == player.TearFlags | TearFlags.TEAR_GLOW then 
        return true
    elseif player:HasCollectible(CollectibleType.COLLECTIBLE_GODHEAD) then
        return true 
    end
end

local function changeCursedRebekahGfx(player, eff)
    local data = yandereWaifu.GetEntityData(eff)
    data.IsGfxLoaded = nil
    eff:GetSprite():Load("gfx/effects/tainted/cursed/weapon.anm2", true)
    eff:SetColor(Color(1,1,1,1,0,0,0), 7, 1)
    if ((player:HasWeaponType(WeaponType.WEAPON_LASER) or player:HasWeaponType(WeaponType.WEAPON_TECH_X)) and not data.IsGfxLoaded) then
        eff:GetSprite():Load("gfx/effects/tainted/cursed/weapon_tech.anm2", true)
        data.IsGfxLoaded = true
    elseif ((player:HasWeaponType(WeaponType.WEAPON_SPIRIT_SWORD)) and not data.IsGfxLoaded) then
        eff:GetSprite():Load("gfx/effects/tainted/cursed/weapon_spirit.anm2", true)
        data.IsGfxLoaded = true
    elseif ((player:HasWeaponType(WeaponType.WEAPON_FETUS)) and not data.IsGfxLoaded) then
        eff:GetSprite():Load("gfx/effects/tainted/cursed/weapon_csection.anm2", true)
        data.IsGfxLoaded = true
    elseif ((player:HasWeaponType(WeaponType.WEAPON_BRIMSTONE)) and not data.IsGfxLoaded) then
        eff:GetSprite():Load("gfx/effects/tainted/cursed/weapon_brimstone.anm2", true)
        data.IsGfxLoaded = true
    elseif ((player:HasWeaponType(WeaponType.WEAPON_BOMBS)) and not data.IsGfxLoaded) then
        eff:GetSprite():Load("gfx/effects/tainted/cursed/weapon_drfetus.anm2", true)
        data.IsGfxLoaded = true
    elseif ((player:HasWeaponType(WeaponType.WEAPON_ROCKETS)) and not data.IsGfxLoaded) then
        eff:GetSprite():Load("gfx/effects/tainted/cursed/weapon_epic.anm2", true)
        data.IsGfxLoaded = true
    else
        if (player:HasCollectible(CollectibleType.COLLECTIBLE_SOY_MILK) or player:HasCollectible(CollectibleType.COLLECTIBLE_ALMOND_MILK)) and not data.IsGfxLoaded then
            eff:GetSprite():Load("gfx/effects/tainted/cursed/weapon_soy.anm2", true)
            data.IsGfxLoaded = true
        end
        if player:HasCollectible(CollectibleType.COLLECTIBLE_POLYPHEMUS) and not data.IsGfxLoaded then
            eff:GetSprite():Load("gfx/effects/tainted/cursed/weapon_big.anm2", true)
            data.IsGfxLoaded = true
        end
        if FiendFolio and player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.EMOJI_GLASSES) and not data.IsGfxLoaded then
            eff:GetSprite():Load("gfx/effects/tainted/cursed/weapon_emoji.anm2", true)
            data.IsGfxLoaded = true
        end
        if player:HasCollectible(CollectibleType.COLLECTIBLE_TERRA) and not data.IsGfxLoaded then
            eff:GetSprite():Load("gfx/effects/tainted/cursed/weapon_terra.anm2", true)
            data.IsGfxLoaded = true
        end
        if player:HasCollectible(CollectibleType.COLLECTIBLE_IPECAC) and not data.IsGfxLoaded then
            eff:GetSprite():Load("gfx/effects/tainted/cursed/weapon_ipecac.anm2", true)
            data.IsGfxLoaded = true
        end
        if player:HasCollectible(CollectibleType.COLLECTIBLE_GODHEAD) and not data.IsGfxLoaded then
            eff:GetSprite():Load("gfx/effects/tainted/cursed/weapon_godhead.anm2", true)
            data.IsGfxLoaded = true
        end
    end
    if player:HasCollectible(CollectibleType.COLLECTIBLE_FIRE_MIND) then
        eff:SetColor(Color(1,1,1,1,1,0.3,0), 7, 1)
    end
end

yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local sprite = eff:GetSprite()
	local data = yandereWaifu.GetEntityData(eff)
	local player = data.Player
    local playerdata = yandereWaifu.GetEntityData(player)
    local scale = 1

    if not data.SwordSize then data.SwordSize = 1 end

    local range = player.TearRange
    local normalRange = 260

    --range size
    if range >= normalRange then
        if player:HasCollectible(CollectibleType.COLLECTIBLE_MY_REFLECTION) then
            range = math.max((range - 50) / 1.5, normalRange)
        end
        scale = ((range*0.8)/normalRange)
    else
        scale = 1
    end
    if scale < 1 then scale = 1 end
    if scale > 2 then scale = 2 end

    scale = scale * data.SwordSize

    if not data.LastCollCount or player:GetCollectibleCount() ~= data.LastCollCount then
        data.LastCollCount = player:GetCollectibleCount() 
        changeCursedRebekahGfx(player, eff)
        player:AddCacheFlags(CacheFlag.CACHE_ALL);
        player:EvaluateItems()

        eff.SpriteScale = Vector(scale, scale)
    end
    
    --[[if player:HasCollectible(CollectibleType.COLLECTIBLE_TECHNOLOGY_ZERO) then
        if not data.TechZeroSpots then
            data.TechZeroSpots = {}
        end
    end]]

    if player and data.state ~= 2 and not data.MovementIndependent then
        --eff.Position = player.Position
        local lerpVal = 0.6
        --[[if data.state == -1 then
		    eff.Velocity = InutilLib.Lerp(eff.Velocity,(player.Position + player.Velocity:Resized(15))-eff.Position, lerpVal)
        else]]if data.state == 0 then
            eff.Velocity = InutilLib.Lerp(eff.Velocity,(player.Position + player.Velocity:Resized(15))-eff.Position, lerpVal)
        elseif data.state == 1 and data.Angle then
            eff.Velocity = InutilLib.Lerp(eff.Velocity,(player.Position + (eff.Position):Rotated(data.Angle):Resized(2))-eff.Position, lerpVal)
        elseif data.Angle then
            eff.Velocity = InutilLib.Lerp(eff.Velocity,(player.Position + (eff.Position):Rotated(data.Angle):Resized(4))-eff.Position, lerpVal)
        end
    end

    local numofShots = 1

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
    if TaintedTreasure and player:HasCollectible(TaintedCollectibles.SPIDER_FREAK) then
        numofShots = numofShots + player:GetCollectibleNum(TaintedCollectibles.SPIDER_FREAK) * 5
    end
    local radiusMultiplier = 1 

    if player:HasCollectible(CollectibleType.COLLECTIBLE_PUPULA_DUPLEX) then
        radiusMultiplier = radiusMultiplier * 2
        scale = scale + 0.5
    end
    if player:HasCollectible(CollectibleType.COLLECTIBLE_POLYPHEMUS) then
        radiusMultiplier = radiusMultiplier * 2
        --InutilLib.game:ShakeScreen(10)
        scale = scale + 1
    end

    local function make_child(tear, damage)
        tear.CollisionDamage = damage * 0.5 or tear.CollisionDamage * 0.5
        tear:ClearTearFlags(TearFlags.TEAR_BURSTSPLIT)
        tear:ClearTearFlags(TearFlags.TEAR_QUADSPLIT)
        tear:ClearTearFlags(TearFlags.TEAR_SPLIT)
        tear:ClearTearFlags(TearFlags.TEAR_BONE)
    end

    local function cut(radius, pos, damage, sp)
        local radisu = radius or 50
        local pos = pos or (eff.Position)+ (Vector(28,0):Rotated(data.Angle))
        local damage = damage or (player.Damage)
        local did_hit = false
        local special = sp
        local radiusMultiplier = 1 
        if sp == nil then special = true end

        radisu = radisu * (scale * 1.2)

        local function isValidHit(ent, radius)
            if (InutilLib.CuccoLaserCollision(eff, data.Angle, player.TearRange * 15, ent, 40) and player:HasCollectible(CollectibleType.COLLECTIBLE_SOY_MILK)) or (ent.Position:Distance(pos) <= radius + ent.Size) then
                return true
            end
        end

        local isSoy = false
        if player:HasCollectible(CollectibleType.COLLECTIBLE_PROPTOSIS) then
            damage = damage * 3
        end
        if player:HasCollectible(CollectibleType.COLLECTIBLE_SOY_MILK) or player:HasCollectible(CollectibleType.COLLECTIBLE_ALMOND_MILK) then
            isSoy = true
        end
        local numofShots = 1

        --form radisu
        radisu = radisu * radiusMultiplier

        data.canPoison = canPoison(player)
        data.canFear = canFear(player)
        data.canFreeze = canFreeze(player)
        data.canJacobsLadder = canJacobsLadder(player)
        data.canHaemolacsomething = canHaemolacsomething(player)
        data.canRock = canRock(player)
        data.canPop = canPop(player)
        data.canGodhead = canGodhead(player)

        if (player:HasWeaponType(WeaponType.WEAPON_LASER) or player:HasWeaponType(WeaponType.WEAPON_TECH_X)) and (data.state == 1 or data.state == 3) then
            local randomTick = math.random(5,7)
            local penalty = 0
            if player:HasWeaponType(WeaponType.WEAPON_TECH_X) then
                randomTick = randomTick - 3 
                penalty = 5
            end --balance stuff
            for i = 1, randomTick do
                local currentRoom = InutilLib.level:GetCurrentRoomIndex()
                InutilLib.SetTimer(0+i*15+penalty, function()
                    if InutilLib.level:GetCurrentRoomIndex() == currentRoom then
                        if player:HasWeaponType(WeaponType.WEAPON_LASER) then
                            local position = pos
                            local rng = math.random(0,5)
                            local posTable = {
                                position = {
                                    [0] = position + Vector(55*scale,0):Rotated(data.Angle),
                                    [1] = position + Vector(0,55*scale):Rotated(data.Angle),
                                    [2] = position + Vector(0,-55*scale):Rotated(data.Angle),
                                    [3] = position + Vector(55*scale,0):Rotated(data.Angle),
                                    [4] = position + Vector(0,55*scale):Rotated(data.Angle),
                                    [5] = position + Vector(0,-55*scale):Rotated(data.Angle),
                                },
                                angle = {
                                    [0] = Vector.FromAngle(data.Angle-135),
                                    [1] = Vector.FromAngle(data.Angle-45),
                                    [2] = Vector.FromAngle(data.Angle+45),
                                    [3] = Vector.FromAngle(data.Angle+135),
                                    [4] = Vector.FromAngle(data.Angle-90),
                                    [5] = Vector.FromAngle(data.Angle+90),
                                }
                            }
                            local techlaser = player:FireTechLaser(posTable.position[rng], 0, posTable.angle[rng], false, true)
                            InutilLib.UpdateRepLaserSize(techlaser, 2*scale, false)
                            techlaser.DisableFollowParent = true
                            techlaser.MaxDistance = 50*scale
                            techlaser.CollisionDamage = player.Damage * 0.5
                        else
                            local techlaser = player:FireTechXLaser(player.Position, Vector.Zero, math.random(40,50))
							techlaser.Position = pos + Vector(math.random(-30, 30), math.random(-30, 30))
                            techlaser.Timeout = 1
                            InutilLib.UpdateRepLaserSize(techlaser, 2*scale, false)
							--techlaser.Size = techlaser.Size + math.random(1,3)
                            techlaser.DisableFollowParent = true
                            techlaser.CollisionDamage = player.Damage * 0.25
                        end
                    end
                end)
            end
        end
        if player:HasWeaponType(WeaponType.WEAPON_SPIRIT_SWORD) and (data.state == 1 or data.state == 3) and (playerdata.PersistentPlayerData.BasicTaintedHealth >=  playerdata.PersistentPlayerData.MaxTaintedHealth) then
            local tear = player:FireTear(pos, Vector.FromAngle(data.Angle):Resized(10*player.ShotSpeed), false, true, false)
            tear:ChangeVariant(TearVariant.SWORD_BEAM)
        end
        if player:HasCollectible(CollectibleType.COLLECTIBLE_MYSTERIOUS_LIQUID) then
            local puddle = InutilLib.game:Spawn( EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_GREEN, pos, Vector(0,0), player, 0, 0):ToEffect()
            InutilLib.RevelSetCreepData(puddle)
            InutilLib.RevelUpdateCreepSize(puddle, math.random(1,2), true)
        end
        if data.canJacobsLadder then
            local ents = Isaac.FindInRadius(pos, 75, EntityPartition.ENEMY)
            for _, ent in pairs(ents) do
                if ent:IsVulnerableEnemy() and not ent:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
                    local laser = EntityLaser.ShootAngle(10, pos, math.ceil((ent.Position - pos):GetAngleDegrees()), 5, Vector.Zero, player)
                    laser:AddTearFlags(TearFlags.TEAR_JACOBS)
                    laser:SetMaxDistance(ent.Position:Distance(pos))
                    laser.Parent = player
                    laser.Target = ent
                    laser.CollisionDamage = player.Damage * 0.5
                    if data.state == 5 then
                        InutilLib.UpdateRepLaserSize(laser, 20, false)
                    end
                    break
                end
            end
        end
        if data.canHaemolacsomething and special then
            if data.state ~= 5 then
                --i saw this in samael, dont kill me, its such a cool way to pop the thing
                local tear = player:FireTear(pos, Vector.Zero, false, true, false)
                tear.Height = 0
                tear:ClearTearFlags(TearFlags.TEAR_QUADSPLIT | TearFlags.TEAR_SPLIT | TearFlags.TEAR_BONE | TearFlags.TEAR_EXPLOSIVE)
                tear:Die()
            else
                for i = 0, 360 - 360/4, 360/4 do
                    --i saw this in samael, dont kill me, its such a cool way to pop the thing
                    local tear = player:FireTear(pos + Vector(45,0):Rotated(i+45), Vector.Zero, false, true, false)
                    tear.Height = 0
                    tear:ClearTearFlags(TearFlags.TEAR_QUADSPLIT | TearFlags.TEAR_SPLIT | TearFlags.TEAR_BONE | TearFlags.TEAR_EXPLOSIVE)
                    tear:Die()
                end
            end
        end
        if data.canRock and special and data.state ~= 1 then
            if data.state ~= 5 then
                for i = 0, math.random(1,2) do
                    local crack = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACKWAVE, 0, pos, Vector.Zero, player):ToEffect()
                    crack.LifeSpan = 5;
                    crack.Timeout = 5
                    crack.Rotation = math.random(1,360)
                end
            end
        end

        --FF synergies
        if FiendFolio then
            if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.EMOJI_GLASSES) and data.state <= 3 then
                if data.state == 3 then
                    local angle = Vector.FromAngle(data.Angle+math.random(-25,25))
                    local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0, pos, angle:Resized(math.random(5,8)), player):ToTear()
                    --player:FireTear(pos, angle:Resized(4), false, true, false):ToTear()
                    tear.Scale = math.random(7,12)/10
                else
                    for i = -15, 15, 15 do
                        local angle = Vector.FromAngle(data.Angle + i)
                        local tear = player:FireTear(pos, angle:Resized(4), false, true, false)
                    end
                end
            end
        end
        --to enemy code
        local ents = Isaac.FindInRadius(pos, 95, EntityPartition.ENEMY)
        for i, ent in pairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, -1, -1)) do
            if ent.Position:Distance(pos) <= 95 and  yandereWaifu.GetEntityData(ent).IsGlorykill then
                table.insert(ents, ent)
            end
        end
        for _, ent in pairs(ents) do
            local dmg = 1
            local additDistance = 0
            if isValidHit(ent, radisu) then
                --crystal gain
                if not playerdata.CantGiveCrystal then 
                    if not playerdata.HitForCrystal then
                        playerdata.HitForCrystal = true 
                    elseif playerdata.HitForCrystal and (crystalGainFrame + 15 < InutilLib.game:GetFrameCount()) then
                        playerdata.HitForCrystal = false
                        if not playerdata.RageCrystal then
                            playerdata.RageCrystal = 1 
                        elseif playerdata.RageCrystal < playerdata.PersistentPlayerData.MaxRageCrystal then
                            local multiplier = 1
                            if playerdata.TaintedRageTick and playerdata.TaintedRageTick > 0 then multiplier = 2 end
                            playerdata.RageCrystal =  playerdata.RageCrystal + 1*multiplier
                            if playerdata.RageCrystal >= playerdata.PersistentPlayerData.MaxRageCrystal then playerdata.RageCrystal = playerdata.PersistentPlayerData.MaxRageCrystal end
                        end
                        crystalGainFrame = InutilLib.game:GetFrameCount()
                    end
                end

                ent:TakeDamage((damage) * dmg, 0, EntityRef(player), 1)
                did_hit = true

                --poison synergies
                if data.canPoison then
                    ent:AddPoison(EntityRef(player), 30, 3)
                end
                if data.canFear then
                    ent:AddFear(EntityRef(player), 45)
                end
                if data.canFreeze then
                   ent:AddFreeze(EntityRef(player), 30)
                end
                if data.canMidas then
                    ent:AddMidasFreeze(EntityRef(player), 120)
                end
                if player:HasWeaponType(WeaponType.WEAPON_FETUS) then
                    if data.state == 4 then
                        if ent.HitPoints <= (damage) * dmg then
                            --if damage is more than ent hitpoints
                            data.EnemyDied = true
                        end
                        player.Velocity =  ((pos - player.Position):Resized(18+ent.Size))
                        --player.Position = ent.Position + (pos - player.Position):Resized(15+ent.Size)
                        yandereWaifu.GetEntityData(player).MakingTaintedIncision = 75
                        yandereWaifu.GetEntityData(player).invincibleTime = yandereWaifu.GetEntityData(player).MakingTaintedIncision + 35
                    elseif data.state == 5 then
                        for i = 0, 360 - 360/4, 360/4 do
                            local tear = player:FireTear( ent.Position, Vector.FromAngle(i):Resized(20), false, false, false):ToTear()
							tear:ChangeVariant(50)
							tear.TearFlags = tear.TearFlags | TearFlags.TEAR_PIERCING | TearFlags.TEAR_SPECTRAL
                            if math.random(1,4) == 4 then
                                yandereWaifu.GetEntityData(tear).IsEsauFetus = true
                            else
                                yandereWaifu.GetEntityData(tear).IsJacobFetus = true
                            end
                        end
                    end
                end
                if player:HasWeaponType(WeaponType.WEAPON_BRIMSTONE) and data.state == 3 then
                    ent:AddEntityFlags(EntityFlag.FLAG_BRIMSTONE_MARKED)
                end
                if player:HasWeaponType(WeaponType.WEAPON_FETUS) and data.state == 3 then
                    ent:AddEntityFlags(EntityFlag.FLAG_BLEED_OUT)
                end
                if player:HasCollectible(CollectibleType.COLLECTIBLE_HOLY_LIGHT) and math.random(1,5) + player.Luck >= 10 then
                    for i = 0, 360 - 360/4, 360/4 do
                        local crack = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACK_THE_SKY, 1, ent.Position+ Vector(35,0):Rotated(i), Vector(0,0), player) 
                        crack.CollisionDamage = player.Damage 
                    end
                    if data.state == 5 then
                       for i = 0, 360 - 360/4, 360/4 do
                            local crack = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACK_THE_SKY, 1, ent.Position+ Vector(70,0):Rotated(i+45), Vector(0,0), player) 
                            crack.CollisionDamage = player.Damage/2
                        end
                    end
                end
                if player:HasCollectible(CollectibleType.COLLECTIBLE_SINUS_INFECTION) and math.random(0,10) + player.Luck >= 10 then
                    local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.BOOGER, 1, ent.Position + Vector(3,0):Rotated(math.random(0,360)), Vector(0,0), player):ToTear()
					tear.Size = math.random(1,20)/10
					tear:AddTearFlags(player.TearFlags)
					tear:AddTearFlags(TearFlags.TEAR_BOOGER)
                end
                if player:HasCollectible(CollectibleType.COLLECTIBLE_EXPLOSIVO) and math.random(0,10) + player.Luck >= 10 then
                    local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.EXPLOSIVO, 1, ent.Position + Vector(3,0):Rotated(math.random(0,360)), Vector(0,0), player):ToTear()
					tear.Size = math.random(1,20)/10
					tear:AddTearFlags(player.TearFlags)
					tear:AddTearFlags(TearFlags.TEAR_STICKY)
                end
                if player:HasCollectible(CollectibleType.COLLECTIBLE_MUCORMYCOSIS) and math.random(0,10) + player.Luck >= 8 then
                    local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.SPORE, 1, ent.Position + Vector(3,0):Rotated(math.random(0,360)), Vector(0,0), player):ToTear()
					tear.Size = math.random(1,20)/10
					tear:AddTearFlags(player.TearFlags)
					tear:AddTearFlags(TearFlags.TEAR_SPORE)
                end
                if player:HasCollectible(CollectibleType.COLLECTIBLE_LITTLE_HORN) and math.random(1,5) == 5 then
                    local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 1, ent.Position + Vector(3,0):Rotated(math.random(0,360)), Vector(0,0), player):ToTear()
					tear.Size = math.random(1,20)/10
					tear:AddTearFlags(player.TearFlags)
					tear:AddTearFlags(TearFlags.TEAR_HORN)
                end
                if player:HasCollectible(CollectibleType.COLLECTIBLE_FIRE_MIND) then
                    ent:AddBurn(EntityRef(player), 60, Damage)
                end
                if player:HasCollectible(CollectibleType.COLLECTIBLE_CRICKETS_BODY) and not player:HasCollectible(CollectibleType.COLLECTIBLE_PARASITE) and special then
                    local rng = math.random(-30,30)
                    local dividend = 4
                    if data.state == 5 then dividend = 8 end
                    for i = 0, 360-360/dividend, 360/dividend do
                        local tear = player:FireTear( ent.Position + (eff.Position - ent.Position):Resized(ent.Size + 10), Vector(65,0):Rotated(rng + i):Resized(player.ShotSpeed*3), false, false, false):ToTear()
                        tear:ChangeVariant(RebekahCurse.ENTITY_METALTEAR)
                        tear.FallingAcceleration = 1.5
                        make_child(tear, damage)
                    end
                end
                if player:HasCollectible(CollectibleType.COLLECTIBLE_PARASITE) and special then
                    for i = 0, 360-360/2, 360/2 do
                        local tear = player:FireTear( ent.Position + (eff.Position - ent.Position):Resized(ent.Size + 10)--[[:Rotated(i+data.Angle+90)]], Vector(75,0):Rotated(i+data.Angle+90):Resized(player.ShotSpeed*10), false, false, false):ToTear()
                        tear:ChangeVariant(RebekahCurse.ENTITY_METALTEAR)
                        --make_child(tear, damage)
                        tear:ClearTearFlags(TearFlags.TEAR_SPLIT)
                    end
                end
                if data.canGodhead and data.state == 4 and special then
                    yandereWaifu.GetEntityData(ent).isCursedGodheadSlam = 45
                    if not yandereWaifu.GetEntityData(ent).CursedGodheadSlamTier then
                        yandereWaifu.GetEntityData(ent).CursedGodheadSlamTier = 1 
                    else
                        yandereWaifu.GetEntityData(ent).CursedGodheadSlamTier = yandereWaifu.GetEntityData(ent).CursedGodheadSlamTier + 1 
                    end
                    yandereWaifu.GetEntityData(ent).lastGodheadSlammedPlayer = player
                end
                if data.canPop and not yandereWaifu.GetEntityData(ent).IsGlorykill then
                    if data.state < 4 then
                        ent.Velocity = (ent.Position - pos):Resized(50)
                        ent:AddEntityFlags(EntityFlag.FLAG_APPLY_IMPACT_DAMAGE)
                        yandereWaifu.GetEntityData(ent).isSnooked = 15
                        InutilLib.SFX:Play( RebekahCurseSounds.SOUND_CURSED_POP, 1, 0, false, math.random(8,12)/10 );
                    elseif data.state == 4 then
                        ent:AddEntityFlags(EntityFlag.FLAG_APPLY_IMPACT_DAMAGE)
                        if not yandereWaifu.GetEntityData(ent).isSlamSnooked then
                            yandereWaifu.GetEntityData(ent).isSlamSnooked = 5
                            yandereWaifu.GetEntityData(ent).SlamSnookStrength = 15
                        else
                            yandereWaifu.GetEntityData(ent).SlamSnookStrength = yandereWaifu.GetEntityData(ent).SlamSnookStrength + 15
                            yandereWaifu.GetEntityData(ent).SnookVelocity = (ent.Position - pos):Resized(yandereWaifu.GetEntityData(ent).SlamSnookStrength)
                        end
                        InutilLib.SFX:Play( RebekahCurseSounds.SOUND_CURSED_POP, 1, 0, false, math.random(8,12)/10 );
                    elseif data.state == 5 then
                        ent.Velocity = (ent.Position - pos):Resized(65)
                        ent:AddEntityFlags(EntityFlag.FLAG_APPLY_IMPACT_DAMAGE)
                        yandereWaifu.GetEntityData(ent).isHeavySnooked = 45
                        InutilLib.SFX:Play( RebekahCurseSounds.SOUND_CURSED_POP, 1, 0, false, math.random(8,12)/10 );
                    end
                end
                if player:HasWeaponType(WeaponType.WEAPON_BOMBS) and not yandereWaifu.GetEntityData(ent).IsGlorykill and data.state <= 3 then
                    if data.state == 3 then
                        ent.Velocity = (ent.Position - player.Position):Resized(40)
                    else
                        ent.Velocity = (ent.Position - player.Position):Resized(30)
                    end
                    if ent:ToBomb() then
                        ent:ToBomb():SetExplosionCountdown(60)
                        yandereWaifu.GetEntityData(ent).SensitiveBombs = true
                        yandereWaifu.GetEntityData(ent).SensitiveBombsNoColor = true
                    end
                end
                if player:HasWeaponType(WeaponType.WEAPON_ROCKETS) and not yandereWaifu.GetEntityData(ent).IsGlorykill then
                    ent.Velocity = (ent.Position - player.Position):Resized(10)
                    if data.state == 4 then
                        ent.Velocity = (ent.Position - player.Position):Resized(25)
                    end
                end
            
            end
            if player:HasCollectible(CollectibleType.COLLECTIBLE_LOST_CONTACT) then
                if ent:ToProjectile() then
                    ent:Kill()
                end
            end
            if ent.Type == 1000 and yandereWaifu.GetEntityData(ent).IsGlorykill then
                if not playerdata.HitCount then playerdata.HitCount = 0 end
                playerdata.HitCount = playerdata.HitCount + 1
                ent:SetColor(Color(1,0,0,1,0,0,0), 7, 1)
                InutilLib.game:ShakeScreen(5)

                InutilLib.SFX:Play( RebekahCurseSounds.SOUND_CURSED_WILD_SWING, 1, 0, false, 0.7 );

                local heart = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_LOVELOVEPARTICLE, 1, ent.Position, Vector.FromAngle((player.Position - ent.Position):GetAngleDegrees() + math.random(-90,90) + 180):Resized(30), ent)
				yandereWaifu.GetEntityData(heart).Parent = player
				yandereWaifu.GetEntityData(heart).maxHealth = math.ceil(15)
            end
        end
        for x = math.ceil(radisu/40)*-1, math.ceil(radisu/40) do
            for y = math.ceil(radisu/40)*-1, math.ceil(radisu/40) do
                local grid = InutilLib.room:GetGridEntityFromPos(Vector(pos.X+40*x, pos.Y+40*y))
                if grid and (( grid:ToRock() and (data.canRock or (player:HasCollectible(CollectibleType.COLLECTIBLE_SULFURIC_ACID) and math.random(1,4) == 4)) ) or grid:ToPoop() or grid:ToTNT()) then
                    if (player:HasCollectible(CollectibleType.COLLECTIBLE_SOY_MILK) and InutilLib.CuccoLaserCollisionToGrid(eff, data.Angle, player.TearRange * 15, grid, 5)) or (not player:HasCollectible(CollectibleType.COLLECTIBLE_SOY_MILK) and InutilLib.GetGridsInRadius(pos, grid.Position, radisu)) then
                        grid:Destroy()
                    end
                end
            end
        end
        return did_hit
    end
    local function explosion(pos)
        return Isaac.Spawn(EntityType.ENTITY_BOMBDROP, 0, 0, pos, Vector(0,0), player):ToBomb()
    end

    local function slam(position, scale, child)

        local pos = position or (eff.Position)+ (Vector(32,0):Rotated(data.Angle))
        local size = scale or 1
        --stun and crystals
        local radisu = 60*size --95*size
        local isChild = child or false

        local function slam_effect(pos)
            if player:HasWeaponType(WeaponType.WEAPON_LASER) then
                for i = 0, 360 - 360/4, 360/4 do
                    local techlaser = player:FireTechLaser(pos, 0,  Vector.FromAngle(i+45), false, true)
                    InutilLib.UpdateRepLaserSize(techlaser, 10*size, false)
                    techlaser.DisableFollowParent = true
                    techlaser.MaxDistance = 90*size
                    techlaser.CollisionDamage = player.Damage * 0.8
                end
            elseif player:HasWeaponType(WeaponType.WEAPON_TECH_X) then
                for i = 0, 360 - 360/2, 360/2 do
                    local techlaser = player:FireTechXLaser(player.Position, Vector(25,0):Rotated(i), math.random(40,50))
                    techlaser.Position = pos + Vector(math.random(-30, 30), math.random(-30, 30))
                    techlaser.Timeout = 1
                    InutilLib.UpdateRepLaserSize(techlaser, 8, false)
                    --techlaser.Size = techlaser.Size + math.random(1,3)
                    techlaser.DisableFollowParent = true
                    techlaser.CollisionDamage = player.Damage * 0.25
                end
            elseif player:HasWeaponType(WeaponType.WEAPON_BRIMSTONE) then
                local variation = math.random(-180,180)
                for i = 0, 360 - 360/2, 360/2 do
                    local brim = player:FireBrimstone( Vector.FromAngle(i+variation)):ToLaser();
                    brim.DisableFollowParent = true
                    brim.MaxDistance = 35*size
                    brim.Timeout = 7
                    --InutilLib.UpdateBrimstoneDamage(brim, 2)
                    brim.Position = pos
                end
            elseif player:HasWeaponType(WeaponType.WEAPON_BOMBS) then
                local bomb = explosion(pos)
                bomb:SetExplosionCountdown(0)
                yandereWaifu.GetEntityData(bomb).NoHarm = true
                bomb.ExplosionDamage = player.Damage
            elseif player:HasWeaponType(WeaponType.WEAPON_ROCKETS) then
                local bomb = explosion(pos)
                yandereWaifu.GetEntityData(bomb).NoHarm = true
                bomb.ExplosionDamage = player.Damage*1.5 + data.storedKineticEnergy
                bomb:SetExplosionCountdown(0)

                data.storedKineticEnergy = 0 --reset
            else
                local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_REBEKAH_DUST, RebekahCurseDustEffects.ENTITY_REBEKAH_CURSED_SLAM_DEFAULT, pos, Vector.Zero, ent)
                yandereWaifu.GetEntityData(poof).Parent = ent
                poof:GetSprite().Scale = Vector(1*size, 1*size)
                local color
                if data.canPoison then
                    color = Color( 1, 1, 1, 1, 0, 215, 0 );
                elseif data.canFear then
                    color = Color( 0.4, 0, 1, 1, 0, 0, 0 );
                else
                    color = Color( 1, 1, 1, 1, 0, 155, 155 );
                end

                if color then
                    poof:GetSprite().Color = color
                end
            end
        end

        local damage = (player.Damage)*2
        if FiendFolio and player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.EMOJI_GLASSES) then
            damage = damage * 2
        end
        if player:HasWeaponType(WeaponType.WEAPON_SPIRIT_SWORD) then
            radisu = 90*size
            pos = player.Position
            --player.Velocity = player.Velocity + Vector.FromAngle(data.Angle):Resized(4)
            damage = damage * 0.2
            InutilLib.SFX:Play( SoundEffect.SOUND_SHELLGAME, 1, 0, false, 1 );
        end
        cut(radisu, pos, damage)
        if player:HasCollectible(CollectibleType.COLLECTIBLE_TECHNOLOGY_ZERO) then
            local dot = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_CURSEDTECHZERODOT, 0, pos, Vector.Zero, player):ToEffect()
            yandereWaifu.GetEntityData(dot).Player = player
        end
        if player:HasCollectible(CollectibleType.COLLECTIBLE_FIRE_MIND) and math.random(1,4) == 4 then
            Isaac.Explode(pos, player, player.Damage * 0.7)
        end
        if player:HasCollectible(CollectibleType.COLLECTIBLE_IPECAC) then
            local puddle = InutilLib.game:Spawn( EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_GREEN, pos, Vector(0,0), player, 0, 0):ToEffect()
            InutilLib.RevelSetCreepData(puddle)
            InutilLib.RevelUpdateCreepSize(puddle, math.random(14,15), true)
            local bomb = explosion(pos)
            bomb:SetExplosionCountdown(0)
            yandereWaifu.GetEntityData(bomb).NoHarm = true
            bomb.RadiusMultiplier = 1.5
        end
         --counts how many enemies were interacted
        local addendEnemy = 0
        for i, ent in pairs (Isaac.GetRoomEntities()) do
            if (ent:IsEnemy() and ent:IsVulnerableEnemy()) or ent.Type == EntityType.ENTITY_FIREPLACE and not ent:IsDead() then
                local dmg = 2
                local additDistance = 0
                if ent.Position:Distance(pos) <= radisu + ent.Size + additDistance then
                    ent:AddFreeze(EntityRef(player), 30)
                    if math.random(1,3) == 3 and data.repeatSlam == 0 and not isChild then
                        if not playerdata.RageCrystal then
                            playerdata.RageCrystal = 1 
                        elseif playerdata.RageCrystal < playerdata.PersistentPlayerData.MaxRageCrystal then
                            local multiplier = 1
                            if playerdata.TaintedRageTick and playerdata.TaintedRageTick > 0 then multiplier = 2 end
                            playerdata.RageCrystal =  playerdata.RageCrystal + 1*multiplier
                        if playerdata.RageCrystal >= playerdata.PersistentPlayerData.MaxRageCrystal then playerdata.RageCrystal = playerdata.PersistentPlayerData.MaxRageCrystal end
                        end
                    end
                    data.did_hit = true
                    ent.Velocity = (ent.Velocity + (Vector(10,0))):Rotated(data.Angle):Resized(3)
                    if not isChild then
                        InutilLib.SetTimer(0+addendEnemy*5, function()
                            slam_effect(ent.Position)
                        end)
                        addendEnemy = addendEnemy + 1
                    end
                end
            end
        end
        if isChild then
            slam_effect(pos)
        end
        local pitch = 0
        if player:HasCollectible(CollectibleType.COLLECTIBLE_POLYPHEMUS) then
            pitch = 0.4
        end
        if data.did_hit then
            cut(90*size --[[125*size]], pos, (player.Damage), false)
            InutilLib.SFX:Play( RebekahCurseSounds.SOUND_CURSED_SLAM, 1, 0, false, (math.random(9,11)/10) - pitch);
        else
            InutilLib.SFX:Play( SoundEffect.SOUND_SHELLGAME, 1, 0, false, 1.2 - pitch );
        end
        InutilLib.game:ShakeScreen(6)
    end

    local function magnetize(pos, radisu, multiplier)
        local addendEnemy = 0
        local mult = multiplier or 10
        for i, ent in pairs (Isaac.GetRoomEntities()) do
             if (ent:IsEnemy() and ent:IsVulnerableEnemy()) or ent.Type == EntityType.ENTITY_FIREPLACE and not ent:IsDead() then
                local additDistance = 0
                if ent.Position:Distance(pos) <= (radisu*3) + ent.Size + additDistance then
                    ent.Velocity = ent.Velocity + (pos - ent.Position):Resized(mult)
                end
            end
        end
    end


    if data.state == 0 then
        eff.RenderZOffset = -1
    else
        eff.RenderZOffset = 1
    end
    if data.state == 0 or data.state == -1 then
        sprite.PlaybackSpeed = 1 --set to default
        --if player:GetFireDirection() == -1 then
        if data.Temp then
            eff:Remove()
        else
            yandereWaifu.GetEntityData(player).CantTaintedSkill = false
            yandereWaifu.GetEntityData(player).CantGiveCrystal = false
        end
        if not InutilLib.IsPlayingMultiple(sprite, "Idle", "Idle2") then
            if data.willFlip then
                sprite:Play("Idle2")
            else
                sprite:Play("Idle")
            end

            if data.state == 0 then
                eff.SpriteRotation = (player.Position-eff.Position):GetAngleDegrees()
  
                --eff.SpriteRotation = (player.Position-eff.Position):Rotated(90):GetAngleDegrees()
            end
        end
            --[[eff:Remove()
            yandereWaifu.GetEntityData(player).taintedWeapon = nil]]
        --end
    elseif data.state == 1 then --swinging
        local radius = 65 --90
        local pos = (eff.Position)+ (Vector(30,0):Rotated(data.Angle))
        if InutilLib.IsFinishedMultiple(sprite, "Swing", "Swing2") then
            data.state = 0
        end
        if not InutilLib.IsPlayingMultiple(sprite, "Swing", "Swing2") then
            if data.willFlip then
                sprite:Play("Swing2")
            else
                sprite:Play("Swing")
            end
            sprite.Rotation = data.Angle
        end
        if sprite:GetFrame() == 3 and player:HasCollectible(CollectibleType.COLLECTIBLE_STRANGE_ATTRACTOR) then
            magnetize(pos, radius)
        elseif sprite:GetFrame() == 2 then
            local pitch = 1
            if player:HasCollectible(CollectibleType.COLLECTIBLE_POLYPHEMUS) then
                pitch = 0.7
            end
            if player:HasWeaponType(WeaponType.WEAPON_BRIMSTONE) then
                local brim = player:FireBrimstone( Vector.FromAngle(data.Angle)):ToLaser();
                brim.DisableFollowParent = true
                brim.MaxDistance = 90
                brim.CollisionDamage = player.Damage * 0.8
                brim.Position = pos
            end
            if isSoy then
               -- stab(90, (eff.Position)+ (Vector(40,0):Rotated(data.Angle)), player.Damage)
                sprite.PlaybackSpeed = 10
           -- else
            end
            local did_hit = cut(radius, pos, player.Damage*0.7)
            InutilLib.SFX:Play( SoundEffect.SOUND_SHELLGAME, 1, 0, false, pitch )
            if player:HasCollectible(CollectibleType.COLLECTIBLE_TECHNOLOGY_ZERO) then
                local dot = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_CURSEDTECHZERODOT, 0, pos, Vector.Zero, player):ToEffect()
                yandereWaifu.GetEntityData(dot).Player = player
            end
            --if dr fetus
            --[[if player:HasWeaponType(WeaponType.WEAPON_BOMBS) then
                player:FireBomb(eff.Position, (Vector(40,0):Rotated(data.Angle):Resized(player.ShotSpeed*4)), player)
            end]]
            if data.canGodhead then
                local aura = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_CURSEDGODHEADAURA, 0, pos, Vector.Zero, player):ToEffect()
                yandereWaifu.GetEntityData(aura).Player = player
                yandereWaifu.GetEntityData(aura).GivenPos = pos
            end
            if did_hit then
                if player:HasWeaponType(WeaponType.WEAPON_ROCKETS) then
                    local bomb = explosion(pos)
                    yandereWaifu.GetEntityData(bomb).NoHarm = true
                    bomb.ExplosionDamage = player.Damage
                    bomb:SetExplosionCountdown(0)
                end
            end
        end
    elseif data.state == 2 then --flying
        if not sprite:IsPlaying("Fly") then
            sprite:Play("Fly")
        end
        for i, ent in pairs (Isaac.GetRoomEntities()) do
            if (ent:IsEnemy() and ent:IsVulnerableEnemy()) or ent.Type == EntityType.ENTITY_FIREPLACE and not ent:IsDead() then
                local dmg = 2
                local additDistance = 0
                if ent.Position:Distance((eff.Position)+ (Vector(8,0):Rotated(data.Angle))) <= 45 + additDistance then
                    ent:TakeDamage((player.Damage/3) * dmg, 0, EntityRef(eff), 1)
                end
            end
        end
        eff.Velocity = Vector(20,0):Rotated(data.Angle)
        sprite.Rotation = data.Angle
        if eff.FrameCount > 30 then
            eff:Remove()
        end
    elseif data.state == 3 then --wild swing
        local pos = (eff.Position)+ (Vector(32,0):Rotated(data.Angle))
        local radisu = 75 --110
        if sprite:IsFinished("Cut") then
            data.state = 0
            return
        end
        if not sprite:IsPlaying("Cut") then
            sprite:Play("Cut")
            sprite.Rotation = data.Angle
        end
        if sprite:GetFrame() <= 3 then
            if player:HasCollectible(CollectibleType.COLLECTIBLE_STRANGE_ATTRACTOR) then
                magnetize(pos, radisu, 4)
            end
            if player:HasWeaponType(WeaponType.WEAPON_ROCKETS) then
                if playerdata.TaintedEnemyTarget then
                    InutilLib.MoveDirectlyTowardsTarget(player, playerdata.TaintedEnemyTarget, 8, 0.8)
                    if sprite:GetFrame() == 0 then
                        InutilLib.SFX:Play( RebekahCurseSounds.SOUND_CURSED_ROCKET_LAUNCH, 1, 0, false, 1 );
                    end
                    if not data.storedKineticEnergy then data.storedKineticEnergy = 0 end
                   -- player.Velocity = playerdata.TaintedEnemyTarget

                   if playerdata.TaintedEnemyTarget.Position:Distance(player.Position) > playerdata.TaintedEnemyTarget.Size + 45 then
                        sprite:SetFrame(1)
                        data.storedKineticEnergy = data.storedKineticEnergy + 4

                        --[[if eff.FrameCount % 3 == 0 then
                            InutilLib.spawnEpicRocket(player, player.Position, true, 10)
                        end]]
                    else
                        player.Velocity = Vector.Zero
                    end
                end
            end
        elseif sprite:GetFrame() >= 4 and sprite:GetFrame() <= 6 then
            local special = false
            if sprite:GetFrame() == 5 then special = true end --special interactions must happen once
            data.did_hit = cut(radisu, pos, (player.Damage)*0.7+math.floor((player.Damage*(numofShots-1))/4), special)
            if player:HasCollectible(CollectibleType.COLLECTIBLE_IPECAC) then
                local gas = Isaac.Spawn( EntityType.ENTITY_EFFECT, EffectVariant.SMOKE_CLOUD, 0, pos, Vector(0,0), player):ToEffect()
                gas.Timeout = 150
            end
            if player:HasWeaponType(WeaponType.WEAPON_ROCKETS) then
                local bomb = explosion(pos)
                yandereWaifu.GetEntityData(bomb).NoHarm = true
                bomb.ExplosionDamage = player.Damage + data.storedKineticEnergy
                bomb:SetExplosionCountdown(0)

                data.storedKineticEnergy = 0 --reset

                InutilLib.SFX:Stop(RebekahCurseSounds.SOUND_CURSED_ROCKET_LAUNCH);
            end

            --yandereWaifu.GetEntityData(player).invincibleTime = 15
            if sprite:GetFrame() == 4 then
                if not playerdata.RageCrystal then
                    playerdata.RageCrystal = 1 
                elseif playerdata.RageCrystal < playerdata.PersistentPlayerData.MaxRageCrystal then
                    local multiplier = 1
                    if playerdata.TaintedRageTick and playerdata.TaintedRageTick > 0 then multiplier = 2 end
                    playerdata.RageCrystal =  playerdata.RageCrystal + 1*multiplier
                    if playerdata.RageCrystal >= playerdata.PersistentPlayerData.MaxRageCrystal then playerdata.RageCrystal = playerdata.PersistentPlayerData.MaxRageCrystal end
                end
            end
        end
        local pitch = 1
        if player:HasCollectible(CollectibleType.COLLECTIBLE_POLYPHEMUS) then
            pitch = 0.7
        end
        if sprite:GetFrame() == 5 then
            if data.did_hit then
                local addendEnemy = 0
                for i, ent in pairs (Isaac.GetRoomEntities()) do
                    if (ent:IsEnemy() and ent:IsVulnerableEnemy()) or ent.Type == EntityType.ENTITY_FIREPLACE and not ent:IsDead() then
                        local additDistance = 0
                        if ent.Position:Distance(pos) <= radisu + ent.Size + additDistance then
                            data.did_hit = true
                            ent.Velocity = (ent.Velocity + (Vector(10,0))):Rotated(data.Angle):Resized(3)
                            InutilLib.SetTimer(0+addendEnemy*5, function()
                                local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_REBEKAH_DUST, RebekahCurseDustEffects.ENTITY_REBEKAH_CURSED_WILD_SWING, ent.Position, Vector.Zero, ent)
                                yandereWaifu.GetEntityData(poof).Parent = ent
                            end)
                            addendEnemy = addendEnemy + 1
                        end
                    end
                end
                InutilLib.SFX:Play( RebekahCurseSounds.SOUND_CURSED_WILD_SWING, 1, 0, false, pitch );
            else
                InutilLib.SFX:Play( SoundEffect.SOUND_SHELLGAME, 1, 0, false, pitch );
            end
            --if dr fetus
            --[[if player:HasWeaponType(WeaponType.WEAPON_BOMBS) then
                player:FireBomb(eff.Position, (Vector(40,0):Rotated(data.Angle):Resized(player.ShotSpeed*10)), player)
            end]]
            if player:HasCollectible(CollectibleType.COLLECTIBLE_TECHNOLOGY_ZERO) then
                local dot = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_CURSEDTECHZERODOT, 0, pos, Vector.Zero, player):ToEffect()
                yandereWaifu.GetEntityData(dot).Player = player
            end
            if data.canGodhead then
                local aura = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_CURSEDGODHEADAURA, 0, pos, Vector.Zero, player):ToEffect()
                yandereWaifu.GetEntityData(aura).Player = player
                yandereWaifu.GetEntityData(aura).GivenPos = pos
            end
        end
    elseif data.state == 4 then --slam
        local pos = (eff.Position)+ (Vector(32,0):Rotated(data.Angle))
        local function playSlam()
            if not player:HasCollectible(CollectibleType.COLLECTIBLE_POLYPHEMUS) then
                sprite.Rotation = data.Angle
                sprite:Play("Slam", true)
            else
                if (data.Angle > 0 and (data.Angle <= 90 - 25 and data.Angle >= 90 + 25)) then
                    --down
                    sprite:Play("SlamOld", true)
                elseif (data.Angle < 0 and (data.Angle >= -90 + 25 and data.Angle <= -90 - 25)) then
                    --up
                    sprite:Play("SlamOld", true)
                else
                    sprite.Rotation = 0
                    sprite:Play("Slam", true)
                    if (data.Angle < 0 and data.Angle >= -90) or (data.Angle > 0 and data.Angle <= 90)  then
                        sprite.FlipX = false
                    elseif (data.Angle < -90 and data.Angle >= -180) or (data.Angle > 90 and data.Angle <= 180) then
                        sprite.FlipX = true
                    end
                    --side
                end
            end
        end
        if sprite:IsFinished("Slam") or sprite:IsFinished("SlamOld") then
            if data.repeatSlam <= 0 then
                sprite.FlipX = false -- reset
                data.state = 0
                return
            else
                data.repeatSlam = data.repeatSlam - 1
                playSlam()
                sprite.PlaybackSpeed = 1.5
                return
            end
        end
        if not sprite:IsPlaying("Slam") and not sprite:IsPlaying("SlamOld") then
            playSlam()
            data.repeatSlam = numofShots-1
        end
        if sprite:GetFrame() <= 3 then
            if player:HasCollectible(CollectibleType.COLLECTIBLE_STRANGE_ATTRACTOR) then
                magnetize(pos, 110, 4)
            end
            if player:HasWeaponType(WeaponType.WEAPON_ROCKETS) then
                if playerdata.TaintedEnemyTarget then
                    if not data.storedKineticEnergy then data.storedKineticEnergy = 0 end
                    InutilLib.MoveDirectlyTowardsTarget(player, playerdata.TaintedEnemyTarget, 6, 0.8)
                    if sprite:GetFrame() == 0 then
                        InutilLib.SFX:Play( RebekahCurseSounds.SOUND_CURSED_ROCKET_LAUNCH, 1, 0, false, 1 );
                    end
                   -- player.Velocity = playerdata.TaintedEnemyTarget

                   if playerdata.TaintedEnemyTarget.Position:Distance(player.Position) > playerdata.TaintedEnemyTarget.Size + 45 then
                        data.storedKineticEnergy = data.storedKineticEnergy + 2
                    else
                        player.Velocity = Vector.Zero
                    end
                end
            end
        elseif (sprite:GetFrame() == 4) then
            slam(pos)
            if player:HasCollectible(CollectibleType.COLLECTIBLE_MONSTROS_LUNG) then
                local rng = math.random(2,3)
                for i = 1, rng do
                    InutilLib.SetTimer( 30*i, function()
                        local new_pos = pos + (Vector(15*i,0):Rotated(math.random(-15,15)+data.Angle))
                        slam(new_pos, 0.7, true)
                    end)
                end
            end
            if player:HasWeaponType(WeaponType.WEAPON_FETUS) then
                local customBody = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_EXTRACHARANIMHELPER, 0, player.Position, Vector(0,0), nil) --body effect
                yandereWaifu.GetEntityData(customBody).Player = player
                yandereWaifu.GetEntityData(customBody).IsLifelineHelper = true
                yandereWaifu.GetEntityData(customBody).DontFollowPlayer = true
                InutilLib.SFX:Stop( RebekahCurseSounds.SOUND_CURSED_BEEP);
                InutilLib.SFX:Stop( RebekahCurseSounds.SOUND_CURSED_BEEP_DEAD);
                if data.EnemyDied then
                    --if damage is more than ent hitpoints
                    yandereWaifu.GetEntityData(customBody).EnemyDied = true
                    data.EnemyDied = false
                    InutilLib.SFX:Play( RebekahCurseSounds.SOUND_CURSED_BEEP, 1, 0, false, 1);
                else
                    InutilLib.SFX:Play( RebekahCurseSounds.SOUND_CURSED_BEEP_DEAD, 1, 0, false, 1);
                end
            end
            if player:HasCollectible(CollectibleType.COLLECTIBLE_CRICKETS_BODY) then
                InutilLib.SetTimer( 30, function()
                    --local rng = math.random(-30,30)
                    --for i = 0, 360-360/4, 360/4 do
                        --local new_pos = pos + (Vector(75,0):Rotated(rng + i))
                        --local tear = player:FireTear( pos,  Vector(75,0):Rotated(rng + i):Resized(player.ShotSpeed*10), false, false, false):ToTear()
                        --tear:ChangeVariant(RebekahCurse.ENTITY_METALTEAR)
                        --slam(new_pos, 0.7, true)
                    --    print(i)
                    --end
                end)
            end
            if FiendFolio and player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.EMOJI_GLASSES) then
                local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_REBEKAH_DUST, RebekahCurseDustEffects.ENTITY_REBEKAH_CURSED_EMOJI_SLAM, pos, Vector.Zero, ent)
                yandereWaifu.GetEntityData(poof).Parent = eff
            end
            InutilLib.SFX:Stop(RebekahCurseSounds.SOUND_CURSED_ROCKET_LAUNCH);
            local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 1, pos, Vector(0,0), player)
            poof:GetSprite().Scale = Vector(1*scale, 1*scale)
        elseif player:HasWeaponType(WeaponType.WEAPON_SPIRIT_SWORD) then
            slam(pos)
        end
    elseif data.state == 5 then --heavy strike
        local pos =(eff.Position)+ (Vector(48,0):Rotated(data.Angle))
        if sprite:IsFinished("Slice") then
            data.state = 0
        end
        if not sprite:IsPlaying("Slice") then
            sprite:Play("Slice")
            sprite.Rotation = data.Angle
        end
        if sprite:GetFrame() >= 4 and sprite:GetFrame() <= 6 then
            local special = false
            if sprite:GetFrame() == 5 then special = true end --special interactions must happen once
            data.did_hit = cut(180, pos, (player.Damage)*3.5+math.floor((player.Damage*(numofShots-1))/4), special)
            --stun
            local radisu = 60
            for i, ent in pairs (Isaac.GetRoomEntities()) do
                if (ent:IsEnemy() and ent:IsVulnerableEnemy()) or ent.Type == EntityType.ENTITY_FIREPLACE and not ent:IsDead() then
                    local dmg = 2
                    local additDistance = 0
                    if ent.Position:Distance(pos) <= radisu + ent.Size + additDistance then
                        ent:AddConfusion(EntityRef(player), 30)
                    end
                end
            end
        end
        if sprite:GetFrame() <= 3 and player:HasCollectible(CollectibleType.COLLECTIBLE_STRANGE_ATTRACTOR) then
            magnetize(pos, 330)
        elseif sprite:GetFrame() == 4 then
            if player:HasCollectible(CollectibleType.COLLECTIBLE_MONSTROS_LUNG) then
                for j = 0, 360 - 360/4, 360/4 do
                    local rng = math.random(9,12)
                    for i = 0, rng do
                        InutilLib.SetTimer( 15*i, function()
                            local new_pos = pos + (Vector(45*i,0):Rotated(math.random(-15,15)+data.Angle + j))
                            slam(new_pos, 0.7, true)
                            --[[cut(180, new_pos, (player.Damage)*3.5+math.floor((player.Damage*(numofShots-1))/8), false)
                            print("WOW")
                            local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_REBEKAH_DUST, RebekahCurseDustEffects.ENTITY_REBEKAH_CURSED_HEAVY_STRIKE, pos, Vector.Zero, eff)
                            yandereWaifu.GetEntityData(poof).Parent = eff
                            poof:GetSprite().Scale = Vector(1+0.1*(numofShots-1), 1+0.1*(numofShots-1))
                            Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 1, new_pos, Vector(0,0), player)
                            InutilLib.SFX:Play( RebekahCurseSounds.SOUND_CURSED_HEAVY_STRIKE, 1, 0, false, math.random(9,11)/10 );]]
                        end)
                    end
                end
            end
            if player:HasCollectible(CollectibleType.COLLECTIBLE_FIRE_MIND) then
                Isaac.Explode(pos, player, player.Damage * 1)
            end
            local pitch = 0
            if player:HasCollectible(CollectibleType.COLLECTIBLE_POLYPHEMUS) then
                pitch = 0.4
            end
            if player:HasCollectible(CollectibleType.COLLECTIBLE_IPECAC) then
                for i = 0, 360 - 360/8, 360/8 do
                    local gas = Isaac.Spawn( EntityType.ENTITY_EFFECT, EffectVariant.SMOKE_CLOUD, 0, pos + Vector(75,0):Rotated(i), Vector(0,0), player):ToEffect()
                    gas.Timeout = 300
                end
                for i = 0, math.random(4,5) do
                    local puddle = InutilLib.game:Spawn( EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_GREEN, pos + Vector(math.random(-50,50),math.random(-50,50)), Vector(0,0), player, 0, 0):ToEffect()
                    InutilLib.RevelSetCreepData(puddle)
                    InutilLib.RevelUpdateCreepSize(puddle, math.random(14,15), true)
                end
                local bomb = explosion(pos)
                yandereWaifu.GetEntityData(bomb).NoHarm = true
                bomb:SetExplosionCountdown(0)
                bomb.RadiusMultiplier = 2
               
                bomb.ExplosionDamage = player.Damage
            end
            if player:HasWeaponType(WeaponType.WEAPON_SPIRIT_SWORD) then
                local tear = player:FireTear( player.Position,  Vector.FromAngle(data.Angle+180):Resized(9+player.ShotSpeed):Rotated(180), false, false, false):ToTear()
				tear.CollisionDamage = player.Damage * 1.5
                tear:ChangeVariant(RebekahCurse.ENTITY_WIND_SLASH)
				tear.Scale = 2.5
				tear:AddTearFlags(TearFlags.TEAR_PIERCING)
				tear:AddTearFlags(TearFlags.TEAR_SPECTRAL)
            end
            if player:HasWeaponType(WeaponType.WEAPON_ROCKETS) then
                for i = 0, 360 - 360/4, 360/4 do
                    for j = 0, 4, 1 do
                        InutilLib.SetTimer( j * 5, function()
                            InutilLib.spawnEpicRocket(player, pos + Vector((40*j),0):Rotated(i), true, 10)
                        end)
                    end
                end
            end
            if player:HasWeaponType(WeaponType.WEAPON_BRIMSTONE) then
                local beam = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_DARKBEAMINTHESKY, 0, pos, Vector(0,0), player):ToEffect()
                yandereWaifu.GetEntityData(beam).IsCursedBeastBeam = true
                yandereWaifu.GetEntityData(beam).Player = player
            end
            if data.canRock then
                local eff = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SHOCKWAVE, 0, pos, Vector.Zero, player):ToEffect()
				eff.Parent = player
				eff:SetRadii(0, 80)
				eff:SetTimeout(35)
            end
            if player:HasCollectible(CollectibleType.COLLECTIBLE_TECHNOLOGY_ZERO) then
                for i = 0, 360 - 360/4, 360/4 do
                    local dot = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_CURSEDTECHZERODOT, 0, pos + Vector(46,0):Rotated(i), Vector.Zero, player):ToEffect()
                    yandereWaifu.GetEntityData(dot).Player = player
                end
            end
            if data.canGodhead then
                for i = 0, math.random(16,20) do
                    InutilLib.SetTimer( i * 15, function()
                        local crack = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACK_THE_SKY, 1, InutilLib.room:FindFreeTilePosition(pos+ Vector(math.random(-150,150),math.random(-150,150)), 2), Vector(0,0), player) 
                        crack.CollisionDamage = player.Damage 
                    end)
                end
                for i, ent in pairs (Isaac.GetRoomEntities()) do
                    if (ent:IsEnemy() and ent:IsVulnerableEnemy()) or ent.Type == EntityType.ENTITY_FIREPLACE and not ent:IsDead() then
                        local dmg = 2
                        local additDistance = 0
                        if ent.Position:Distance(pos) <= 300 + ent.Size + additDistance then
                            ent:AddBurn(EntityRef(player), 150, 2)
                            ent:TakeDamage((player.Damage/2), 0, EntityRef(player), 1)
                            InutilLib.game:ShakeScreen(10)
                            InutilLib.SetTimer( i * 3, function()
                                local crack = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACK_THE_SKY, 1, ent.Position, Vector(0,0), player) 
                                crack.CollisionDamage = player.Damage
                            end)
                        end
                    end
                end
                local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_REBEKAH_DUST, RebekahCurseDustEffects.ENTITY_REBEKAH_CURSED_GODHEAD_STRIKE, pos, Vector.Zero, ent)
                yandereWaifu.GetEntityData(poof).Parent = eff
                InutilLib.SFX:Play(SoundEffect.SOUND_HOLY, 1.2, 0, false, 1.2);
            end
            if FiendFolio and player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.EMOJI_GLASSES) then
                local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_REBEKAH_DUST, RebekahCurseDustEffects.ENTITY_REBEKAH_CURSED_EMOJI_HEAVY_STRIKE, pos, Vector.Zero, player)
                yandereWaifu.GetEntityData(poof).Parent = player
            end
            --yandereWaifu.GetEntityData(player).invincibleTime = 20
            player.Velocity = (player.Velocity + (Vector(10,0))):Rotated(data.Angle-180):Resized(5)
            if player:HasWeaponType(WeaponType.WEAPON_LASER) then
                for i = 0, 360 - 360/4, 360/4 do
                    local techlaser = player:FireTechLaser(pos, 0,  Vector.FromAngle(i), false, true)
                    InutilLib.UpdateRepLaserSize(techlaser, 20, false)
                    techlaser.DisableFollowParent = true
                    techlaser.MaxDistance = 350
                    techlaser.CollisionDamage = player.Damage * 2
                    techlaser.Timeout = 15*numofShots
                end
            elseif player:HasWeaponType(WeaponType.WEAPON_TECH_X) then
                for  i = 0, math.random(5,7) do
                    InutilLib.SetTimer( i * 45, function()
                        local techlaser = player:FireTechXLaser(player.Position, Vector.Zero, math.random(20,70))
                        techlaser.Position = pos
                        techlaser.Timeout = 1
                        InutilLib.UpdateRepLaserSize(techlaser, 15, false)
                        --techlaser.Size = techlaser.Size + math.random(1,3)
                        techlaser.DisableFollowParent = true
                        techlaser.CollisionDamage = player.Damage * 0.25
                    end)
                end
            elseif player:HasWeaponType(WeaponType.WEAPON_BOMBS) then
                local bomb = explosion(pos)
                bomb:SetExplosionCountdown(0)
                yandereWaifu.GetEntityData(bomb).NoHarm = true
                bomb.ExplosionDamage = player.Damage
                for i = 0, 360 - 360/4, 360/4 do
                    for j = 0, 40, 10 do
                        local bomb = explosion(pos + Vector((40+j)*bomb.RadiusMultiplier,0):Rotated(i))
                        bomb:SetExplosionCountdown(0)
                        bomb.GridCollisionClass = GridCollisionClass.COLLISION_NONE
                        yandereWaifu.GetEntityData(bomb).NoHarm = true
                    end
                end
            else
                local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_REBEKAH_DUST, RebekahCurseDustEffects.ENTITY_REBEKAH_CURSED_HEAVY_STRIKE, pos, Vector.Zero, eff)
                yandereWaifu.GetEntityData(poof).Parent = ent
                poof:GetSprite().Scale = Vector(1+0.1*(numofShots-1), 1+0.1*(numofShots-1))
                Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 1, pos, Vector(0,0), player)
            end
            InutilLib.game:ShakeScreen(8)
            InutilLib.game:MakeShockwave(eff.Position, 0.075+0.01*(numofShots-1), 0.025, 10)
            if data.did_hit then
                InutilLib.SFX:Play( RebekahCurseSounds.SOUND_CURSED_HEAVY_STRIKE, 1, 0, false, math.random(9,11)/10 - pitch );
             else
                InutilLib.SFX:Play( SoundEffect.SOUND_SHELLGAME, 1, 0, false, 1 - pitch);
             end
        end
    end
end, RebekahCurse.ENTITY_REBEKAHCURSEDWEAPON)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, function(_, tr)
    local data = yandereWaifu.GetEntityData(tr)
    if data.IsCursedSword then
        local player = tr.SpawnerEntity:ToPlayer()
        local sprite = tr:GetSprite()
        if tr.FrameCount == 1 then
            --sprite:Load("gfx/effects/tainted/cursed/weapon.anm2", true)
            changeCursedRebekahGfx(player, tr)
            sprite:LoadGraphics()
            sprite:Play("Fly", true)
            tr.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE;
        else
            for i, ent in pairs (Isaac.GetRoomEntities()) do
                if (ent:IsEnemy() and ent:IsVulnerableEnemy()) or ent.Type == EntityType.ENTITY_FIREPLACE and not ent:IsDead() then
                    local dmg = 2
                    local additDistance = 0
                    if ent.Position:Distance((tr.Position)) <= 50 + additDistance then
                        if player:HasWeaponType(WeaponType.WEAPON_BOMBS) then
                            local bomb = Isaac.Spawn(EntityType.ENTITY_BOMBDROP, 0, 0, tr.Position, Vector(0,0), player):ToBomb()
                            bomb:SetExplosionCountdown(0)
                            yandereWaifu.GetEntityData(bomb).NoHarm = true
                            bomb.ExplosionDamage = player.Damage
                        else
                            ent:TakeDamage((player.Damage/5) * dmg, 0, EntityRef(player), 1)
                        end
                        if data.state == 1 and not tr:HasTearFlags(TearFlags.TEAR_PIERCING) then 
                            data.state = 2 
                            if player:HasWeaponType(WeaponType.WEAPON_ROCKETS) then
                                yandereWaifu.GetEntityData(ent).CursedEpicFetusTargeted = 20
                                --InutilLib.spawnEpicRocket(player, tr.Position, false, 10)
                            end
                        end
                    end
                --[[elseif ent.Type == 4 then
                    if ent.Position:Distance((tr.Position)) <= 75 then
                        ent.Position = tr.Position
                    end]]
                end
            end
            tr.Height = -8
            if data.state == 1 then
                if tr.FrameCount > 15 then
                  tr.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS;
                  data.state = 2
                end
               if tr:CollidesWithGrid() then
                    local sword = player:FireTear( player.Position,  (tr.Position - player.Position):Resized(9+player.ShotSpeed):Rotated(180), false, false, false):ToTear()
                -- local sword = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0, player.Position, Vector(0,20):Rotated(data.taintedCursedDir-90), player):ToTear()
                    sword:AddTearFlags(TearFlags.TEAR_BOOMERANG)
                    yandereWaifu.GetEntityData(sword).IsCursedSword = true
                    yandereWaifu.GetEntityData(sword).state = 2
                    sword.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ENEMIES
                     sword.Position = tr.Position
                    tr:Remove()
                    InutilLib.game:ShakeScreen(5)
                end
                if player:HasWeaponType(WeaponType.WEAPON_BRIMSTONE) then
                    if tr.FrameCount == 2 then
                        local brim = player:FireBrimstone( Vector.FromAngle((tr.Velocity):GetAngleDegrees() + 180):Resized(2)):ToLaser();
                        brim.Parent = tr
                        brim.MaxDistance = 150
                        brim.Timeout = 7
                        --InutilLib.UpdateBrimstoneDamage(brim, 2)
                    end
                end
            else
                tr.Velocity =  (tr.Position - player.Position):Resized(9+player.ShotSpeed):Rotated(180)
            end
        end
        if player.Position:Distance(tr.Position) < 30 and tr.FrameCount > 9 and data.state == 2 then
            data.IsRemovedSafely = true
            tr:Remove()
            yandereWaifu.GetEntityData(player).CanShoot = true
            yandereWaifu.GetEntityData(player).CantTaintedSkill = false
            yandereWaifu.GetEntityData(player).CantGiveCrystal = false
            yandereWaifu.GetEntityData(player).taintedWeapon.Visible = true
        end
    end
end)


yandereWaifu:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, function(_, tr)
	local data = yandereWaifu.GetEntityData(tr)
    if tr.SpawnerEntity then
        local player = tr.SpawnerEntity:ToPlayer()
        local sprite = tr:GetSprite()
        --if tr.TearFlags == tr.TearFlags | TearFlags.TEAR_POP then return end
        if data.IsCursedSword and not data.IsRemovedSafely then
            local sword = player:FireTear( tr.Position,  (tr.Position - player.Position):Resized(9+player.ShotSpeed), false, false, false):ToTear()
            sword:AddTearFlags(TearFlags.TEAR_BOOMERANG)
            yandereWaifu.GetEntityData(sword).IsCursedSword = true
            yandereWaifu.GetEntityData(sword).state = 2
            yandereWaifu.GetEntityData(sword).taintedWeapon = data.taintedWeapon
            sword.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE;
            sword.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ENEMIES
        end
    end
end, EntityType.ENTITY_TEAR)


--sword idle effect

yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local player = yandereWaifu.GetEntityData(eff).Player
	local controller = player.ControllerIndex;
	local sprite = eff:GetSprite();
	local room =  Game():GetRoom();
	local data = yandereWaifu.GetEntityData(player)
	
	--movement code
	eff.GridCollisionClass =  EntityGridCollisionClass.GRIDCOLL_NOPITS;

	local movementDirection = player:GetMovementInput();
	
    local princessProtectorAngle = (player.Velocity):GetAngleDegrees()+180
    local neededPosition = player.Position + Vector(20,0):Rotated(princessProtectorAngle)
	eff.Velocity = (neededPosition - eff.Position)*0.9;

	if eff.FrameCount == 1 then
		sprite:Play("Appear", true);
	elseif sprite:IsFinished("Appear") then
		sprite:Play("Idle",true);
	end
	
end, RebekahCurse.ENTITY_SWORDOFHOPEEFFECT)

function yandereWaifu:CursedRebekahTearRender(tr, _)
	if tr.Variant == RebekahCurse.ENTITY_METALTEAR then
		local player, data, flags, scale = tr.SpawnerEntity:ToPlayer(), yandereWaifu.GetEntityData(tr), tr.TearFlags, tr.Scale 
		local size = InutilLib.GetTearSizeTypeII(scale, flags)
		InutilLib.UpdateRegularTearAnimation(player, tr, data, flags, size, "Speen");
		--InutilLib.UpdateDynamicTearAnimation(player, tr, data, flags, "Rotate", "", size)
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_POST_TEAR_RENDER, yandereWaifu.CursedRebekahTearRender)

function yandereWaifu:CursedRebekahTearUpdate(tr)
	local data = yandereWaifu.GetEntityData(tr)
	local player = tr.Parent
	tr = tr:ToTear()
	if tr.Variant == RebekahCurse.ENTITY_METALTEAR then
		local chosenNumofBarrage =  math.random( 2, 4 );
		for i = 1, chosenNumofBarrage do
			local eff = InutilLib.game:Spawn( EntityType.ENTITY_EFFECT, 35, tr.Position, Vector.FromAngle( math.random() * 360 ):Resized(2), tr, 0, 0):ToTear()
		end
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, yandereWaifu.CursedRebekahTearUpdate, EntityType.ENTITY_TEAR)


-- Following the player
--[[
mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, fam)
    local player = fam.Player
    local roomCenter = GetExpectedCenterPos(game:GetRoom())
    
    fam:FollowPosition((roomCenter - player.Position) + roomCenter)
end, familiar)]]


--stat cache for each mode
function yandereWaifu:TRebekahcacheregister(player, cacheF) --The thing the checks and updates the game, i guess?
    local data = yandereWaifu.GetEntityData(player)
    if yandereWaifu.IsTaintedRebekah(player) then -- Especially here!
        --special interactions
        --isaac's tears, the d6, fate, maggy's bow, transcedence, divorce papers, polaroid and negative, isaac's head
        if player:HasCollectible(CollectibleType.COLLECTIBLE_POP) then
            if cacheF == CacheFlag.CACHE_FIREDELAY then
                player.MaxFireDelay = player.MaxFireDelay + 8
            end
        end
        if player:HasWeaponType(WeaponType.WEAPON_BOMBS) then
            if cacheF == CacheFlag.CACHE_FIREDELAY then
                player.MaxFireDelay = player.MaxFireDelay - 12
            end
        end
        if player:HasCollectible(CollectibleType.COLLECTIBLE_ISAACS_TEARS) then
            if cacheF == CacheFlag.CACHE_FIREDELAY then
                player.MaxFireDelay = player.MaxFireDelay - 2
            end
        end
        if player:HasCollectible(CollectibleType.COLLECTIBLE_D6) then
            if cacheF == CacheFlag.CACHE_SPEED then
                player.MoveSpeed = player.MoveSpeed + 0.20
            end
        end
        if player:HasCollectible(CollectibleType.COLLECTIBLE_FATE) then
            if cacheF == CacheFlag.CACHE_FIREDELAY then
                player.MaxFireDelay = player.MaxFireDelay - 2
            end
        end	
        if player:HasCollectible(CollectibleType.COLLECTIBLE_MAGGYS_BOW) then
            if cacheF == CacheFlag.CACHE_DAMAGE then
                player.Damage = player.Damage + 1.77
            end
        end
        if player:HasCollectible(CollectibleType.COLLECTIBLE_WHORE_OF_BABYLON) then
            if cacheF == CacheFlag.CACHE_DAMAGE then
                player.Damage = player.Damage + 1.77
            end
        end
        if player:HasCollectible(CollectibleType.COLLECTIBLE_BOX_OF_FRIENDS) then
            if cacheF == CacheFlag.CACHE_DAMAGE then
                player.Damage = player.Damage + 1.77
            end
        end
        if player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_KNIFE) then
            if cacheF == CacheFlag.CACHE_SPEED then
                player.MoveSpeed = player.MoveSpeed + 0.20
            end
        end
        if player:HasCollectible(CollectibleType.COLLECTIBLE_TRANSCENDENCE) then
            if cacheF == CacheFlag.CACHE_FIREDELAY then
                player.MaxFireDelay = player.MaxFireDelay - 2
            end
        end
        if player:HasCollectible(CollectibleType.COLLECTIBLE_DIVORCE_PAPERS) then
            if cacheF == CacheFlag.CACHE_FIREDELAY then
                player.MaxFireDelay = player.MaxFireDelay - 1
            end
        end
        if player:HasCollectible(CollectibleType.COLLECTIBLE_POLAROID) then 
            if cacheF == CacheFlag.CACHE_FIREDELAY then
                player.MaxFireDelay = player.MaxFireDelay - 1
                --player.Damage = player.Damage + 1.77
            end
        end
        if player:HasCollectible(CollectibleType.COLLECTIBLE_NEGATIVE) then
            if cacheF == CacheFlag.CACHE_FIREDELAY then
                player.MaxFireDelay = player.MaxFireDelay - 1
                --player.Damage = player.Damage + 1.77
            end
        end
    end
    
end
yandereWaifu:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, yandereWaifu.TRebekahcacheregister)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local player = yandereWaifu.GetEntityData(eff).Player
	local sprite = eff:GetSprite();
	local data = yandereWaifu.GetEntityData(eff)
	if eff.FrameCount == 1 then
        sprite:Play("Idle", true)
        sprite.Offset = Vector(0,-5)
    end
    if eff.FrameCount == 120 then
        sprite:Play("Disappear", true)
    end
	if sprite:IsFinished("Disappear") then
        eff:Remove()
    end
    if not data.SameTZNum then data.SameTZNum = 0 end --sets this to 0 in default
	if data.Laser ~= nil then --if the laser data has been already set
        local TechLaser = data.Laser
        if yandereWaifu.GetEntityData(TechLaser).HasConnect then
            TechLaser:SetTimeout(2)
            local dist, angle = ((eff.Position - data.DistHasDefined.Position):Length()), (eff.Position - data.DistHasDefined.Position):GetAngleDegrees()
            TechLaser.Position = eff.Position
            TechLaser.Angle = angle
            TechLaser:SetMaxDistance(dist)
        else
            TechLaser:Remove()
            data.Laser = nil
        end
	else --elseif not
		data.DistHasDefined = nil --force it to nil
		data.closestProj = 99506742
		for j, projOther in pairs (Isaac.FindByType(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_CURSEDTECHZERODOT, -1, false, false)) do --loop in checking if there is others
			if projOther.Index ~= eff.Index and yandereWaifu.GetEntityData(projOther).SameTZNum == data.SameTZNum then --the second condition is important!
				if (projOther.FrameCount <= eff.FrameCount) and (projOther.Parent == eff.Parent) then
					--if (projOther.SpawnerType == eff.SpawnerType and projOther.SpawnerVariant == eff.SpawnerVariant) then
					local savedDist = (projOther.Position - eff.Position):Length()
					if savedDist < data.closestProj and savedDist < 300 then
						data.closestProj = savedDist
						data.DistHasDefined = projOther
					end
				end
			end
		end
		if data.DistHasDefined ~= nil and data.Laser == nil then --if the laser isn't nil then
			local LaserAngleNeeded = InutilLib.ObjToTargetAngle(data.DistHasDefined, eff, true)
			local laser = EntityLaser.ShootAngle(2, data.DistHasDefined.Position, LaserAngleNeeded, 3, Vector(0,-20), data.DistHasDefined)
			laser:SetColor(Color(0,1,1,1,0,0,0),9999999,99,false,false)
            --laser:AddTearFlags(TearFlags.TEAR_JACOBS)
			laser:SetMaxDistance(data.closestProj)
			yandereWaifu.GetEntityData(laser).IsTechZero = true
			yandereWaifu.GetEntityData(laser).HasConnect = data.DistHasDefined
            laser.CollisionDamage = player.Damage * 0.5
			data.Laser = laser
		end
    end
end, RebekahCurse.ENTITY_CURSEDTECHZERODOT)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local player = yandereWaifu.GetEntityData(eff).Player
	local sprite = eff:GetSprite();
	local data = yandereWaifu.GetEntityData(eff)
    local tier = data.Tier or 0
    eff.Position = data.GivenPos
    eff.RenderZOffset = 100
	if eff.FrameCount == 1 then
        sprite:Play("Appear", true)
    end
    if sprite:IsFinished("Appear") then
        sprite:Play("Glow", true)
    end
    if sprite:IsFinished("Disappear") then
        eff:Remove()
    end
    if eff.FrameCount == 15 then
        sprite:Play("Disappear", true)
    end
    local ents = Isaac.FindInRadius(eff.Position, 95, EntityPartition.ENEMY)
    for _, ent in pairs(ents) do
        if eff.FrameCount % 5 == 0 then
            ent:TakeDamage(2+(tier*2), 0, EntityRef(player), 1)
        end
    end
end, RebekahCurse.ENTITY_CURSEDGODHEADAURA)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local player = yandereWaifu.GetEntityData(eff).Player
	local sprite = eff:GetSprite();
	local data = yandereWaifu.GetEntityData(eff)
	
    if data.IsCursedBeastBeam then
        if eff.FrameCount == 1 then
            sprite:Load("gfx/effects/tainted/cursed/darkbeaminthesky_beast.anm2", true)
            sprite:Play("Start", true) --normal attack
            InutilLib.SFX:Play(SoundEffect.SOUND_BEAST_LASER, 1, 0, false, 1)
        elseif sprite:IsFinished("Start") then
            sprite:Play("Loop", true)
        elseif eff.FrameCount < 120 and not sprite:IsPlaying("Start") then
            InutilLib.game:ShakeScreen(5)
            for i, v in pairs (Isaac.FindInRadius(eff.Position, 750, EntityPartition.ENEMY)) do
                if v:IsVulnerableEnemy() then
                    if v.Position:Distance(eff.Position) < v.Size + eff.Size + 160 then
                        v:TakeDamage(player.Damage, 0, EntityRef(eff), 1)
                    end
                end
            end
        elseif eff.FrameCount == 120 then
            sprite:Play("End", true);
        elseif sprite:IsFinished("End") then
            eff:Remove();
        end
    end
end, RebekahCurse.ENTITY_DARKBEAMINTHESKY);

yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, function(_,  eff)
	local sprite = eff:GetSprite()
	local data = yandereWaifu.GetEntityData(eff)
	local player = data.Player
    if data.IsLifelineHelper then
        if eff.FrameCount < 7 then
            data.PlayerPos = player.Position
        end
        if not data.Init then      
            eff.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NOPITS 
            data.spr = Sprite()           
            if data.EnemyDied then
                data.spr:Load("gfx/effects/tainted/cursed/c_section_beep_died.anm2", true) 
            else                                      
                data.spr:Load("gfx/effects/tainted/cursed/c_section_beep.anm2", true) 
            end
            data.Init = true           
            eff.RenderZOffset = 100000
            --eff.Visible = false                         
        end
        if player then
            data.spr:SetFrame("Line", math.floor(eff.FrameCount/3))
            InutilLib.DeadDrawRotatedTilingSprite(data.spr, Isaac.WorldToScreen(data.PlayerPos), Isaac.WorldToScreen(eff.Position), 30, nil, 8, true)
        end
        if data.spr:GetFrame() >= 6 then
            eff:Remove()
        end
    end
end, RebekahCurse.ENTITY_EXTRACHARANIMHELPER);
