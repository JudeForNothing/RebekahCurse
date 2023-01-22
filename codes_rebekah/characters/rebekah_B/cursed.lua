local function ThrowCursedSword(player)
    local data = yandereWaifu.GetEntityData(player)
    data.CanShoot = false
    local sword = player:FireTear( player.Position,  Vector(0,15):Rotated(data.taintedCursedDir-90), false, false, false):ToTear()
     -- local sword = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0, player.Position, Vector(0,20):Rotated(data.taintedCursedDir-90), player):ToTear()
    sword:AddTearFlags(TearFlags.TEAR_BOOMERANG | TearFlags.TEAR_PIERCING)
    yandereWaifu.GetEntityData(sword).IsCursedSword = true
    
    data.CantTaintedSkill = true
    data.CantGiveCrystal = true
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
	
    print(target:IsDead())
    if target and target:IsDead() then
        eff:Remove()
    elseif not target then
        eff:Remove()
    end
end, RebekahCurse.ENTITY_TAINTEDCURSEENEMYTARGET)


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
    end
end
)

--spawning knife
function yandereWaifu.SpawnCursedKnife(player, state, angle)
    local state = state or 1
    local angle = angle or player:GetShootingInput():GetAngleDegrees()
    local data = yandereWaifu.GetEntityData(player)
    data.taintedWeapon = Isaac.Spawn( EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_REBEKAHCURSEDWEAPON, 0, player.Position,  Vector(0,0), player );
    yandereWaifu.GetEntityData(data.taintedWeapon).Player = player

    yandereWaifu.GetEntityData(data.taintedWeapon).state = state
    yandereWaifu.GetEntityData(data.taintedWeapon).Angle = angle

    data.CantTaintedSkill = true
    if state ~= 1 then
        data.CantGiveCrystal = true
    end
end

yandereWaifu:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_,player)
    local data = yandereWaifu.GetEntityData(player)

    if data.CanShoot == nil then data.CanShoot = true end
    if data.taintedWeapon and data.taintedWeapon:IsDead() then
        data.taintedWeapon = nil
        data.CanShoot = true
        data.CantTaintedSkill = false
    end
	if yandereWaifu.IsTaintedRebekah(player) then
        --if menu open, slow down
        if data.TAINTEDREBSKILL_MENU and data.TAINTEDREBSKILL_MENU.open then
            player.Velocity = player.Velocity * 0.7
        end

        --reimplement tear delay
        if data.TaintedTearDelay then
            if data.TaintedTearDelay > 0 then
                data.TaintedTearDelay = data.TaintedTearDelay - 1
            end
        end
        --when swinging
        if not data.taintedWeapon and (Input.IsActionPressed(ButtonAction.ACTION_SHOOTLEFT, player.ControllerIndex) or Input.IsActionPressed(ButtonAction.ACTION_SHOOTRIGHT, player.ControllerIndex) or Input.IsActionPressed(ButtonAction.ACTION_SHOOTUP, player.ControllerIndex) or Input.IsActionPressed(ButtonAction.ACTION_SHOOTDOWN, player.ControllerIndex)) then
            if not data.CanShoot then return end
            if data.TAINTEDREBSKILL_MENU.open then return end
            if data.TaintedTearDelay > 0 then return end
            yandereWaifu.SpawnCursedKnife(player, 1)

            --reset MaxFireDelay
            data.TaintedTearDelay = math.floor(player.MaxFireDelay*1.5)
        end

        --pre charging code
        if player:GetFireDirection() == -1 then --if not firing
			if data.taintedCursedTick then
				if data.taintedCursedTick >= 30 then
                    --TeleportToClosestEnemy(player)
                    ThrowCursedSword(player)
				end
			end
			data.taintedCursedTick = 0
		else
            if data.IsCursedCharging then return end
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
		end

        --charging code
        if data.IsCursedCharging then
            if not data.taintedCursedChargeTick then data.taintedCursedChargeTick = 30 end
			
            player.Velocity = player.Velocity * 0.09
			data.taintedCursedChargeTick = data.taintedCursedChargeTick - 1
            if data.taintedCursedChargeTick <= 0 then
                data.IsCursedCharging = false
                data.taintedCursedChargeTick = nil

                player.Position = data.LastChargePos
                data.invincibleTime = 0
            end
        end
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

yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local sprite = eff:GetSprite()
	local data = yandereWaifu.GetEntityData(eff)
	local player = data.Player
    local playerdata = yandereWaifu.GetEntityData(player)

    if player and data.state ~= 2 then
        eff.Position = player.Position
    end

    local function cut(radius, pos, damage)
        local radisu = radius or 90
        local pos = pos or (eff.Position)+ (Vector(22,0):Rotated(data.Angle))
        local damage = damage or (player.Damage)
        local did_hit = false

        data.canPoison = canPoison(player)
        data.canFear = canFear(player)
        data.canFreeze = canFreeze(player)
        for i, ent in pairs (Isaac.GetRoomEntities()) do
            if (ent:IsEnemy() and ent:IsVulnerableEnemy()) or ent.Type == EntityType.ENTITY_FIREPLACE and not ent:IsDead() then
                local dmg = 1
                local additDistance = 0
                if ent.Position:Distance(pos) <= radisu + additDistance then
                    ent:TakeDamage((player.Damage) * dmg, 0, EntityRef(eff), 1)
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
                end
            end
        end
        for x = math.ceil(radisu/40)*-1, math.ceil(radisu/40) do
            for y = math.ceil(radisu/40)*-1, math.ceil(radisu/40) do
                local grid = ILIB.room:GetGridEntityFromPos(Vector(pos.X+40*x, pos.Y+40*y))
                if grid and (--[[grid:ToRock() or ]]grid:ToPoop() or grid:ToTNT()) then
                    if InutilLib.GetGridsInRadius(pos, grid.Position, radisu) then
                        grid:Destroy()
                    end
                end
            end
        end
        return did_hit
    end

    if data.state == 0 then
        if player:GetFireDirection() == -1 then
            eff:Remove()
            yandereWaifu.GetEntityData(player).taintedWeapon = nil
            yandereWaifu.GetEntityData(player).CantTaintedSkill = false
            yandereWaifu.GetEntityData(player).CantGiveCrystal = false
        end
    elseif data.state == 1 then --swinging
        if sprite:IsFinished("Swing") then
            data.state = 0
        end
        if not sprite:IsPlaying("Swing") then
            sprite:Play("Swing")
            sprite.Rotation = data.Angle
        end
        if sprite:GetFrame() == 2 then
            cut()
            InutilLib.SFX:Play( SoundEffect.SOUND_SHELLGAME, 1, 0, false, 1 )
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
        local pos = (eff.Position)+ (Vector(26,0):Rotated(data.Angle))
        local radisu = 110
        if sprite:IsFinished("Cut") then
            data.state = 0
        end
        if not sprite:IsPlaying("Cut") then
            sprite:Play("Cut")
            sprite.Rotation = data.Angle
        end
        if sprite:GetFrame() >= 4 and sprite:GetFrame() <= 6 then
            data.did_hit = cut(radisu, pos, (player.Damage)*1.5)
            --yandereWaifu.GetEntityData(player).invincibleTime = 15
            if sprite:GetFrame() == 4 then
                if not playerdata.RageCrystal then
                    playerdata.RageCrystal = 1 
                elseif  playerdata.RageCrystal < 5 then
                    playerdata.RageCrystal =  playerdata.RageCrystal + 1 
                end
            end
        end
        if sprite:GetFrame() == 5 then
            local addendEnemy = 0
            if data.did_hit then
                for i, ent in pairs (Isaac.GetRoomEntities()) do
                    if (ent:IsEnemy() and ent:IsVulnerableEnemy()) or ent.Type == EntityType.ENTITY_FIREPLACE and not ent:IsDead() then
                        local additDistance = 0
                        if ent.Position:Distance(pos) <= radisu + additDistance then
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
                InutilLib.SFX:Play( RebekahCurseSounds.SOUND_CURSED_WILD_SWING, 1, 0, false, 1 );
            else
                InutilLib.SFX:Play( SoundEffect.SOUND_SHELLGAME, 1, 0, false, 1 );
            end
        end
    elseif data.state == 4 then --slam
        if sprite:IsFinished("Slam") then
            data.state = 0
        end
        if not sprite:IsPlaying("Slam") then
            sprite:Play("Slam")
            sprite.Rotation = data.Angle
        end
        if sprite:GetFrame() == 4 then
            local pos =(eff.Position)+ (Vector(26,0):Rotated(data.Angle))
            cut(75, pos, (player.Damage)*2)
            --stun and crystals
            local radisu = 75
            --counts how many enemies were interacted
            local addendEnemy = 0
            for i, ent in pairs (Isaac.GetRoomEntities()) do
                if (ent:IsEnemy() and ent:IsVulnerableEnemy()) or ent.Type == EntityType.ENTITY_FIREPLACE and not ent:IsDead() then
                    local dmg = 2
                    local additDistance = 0
                    if ent.Position:Distance(pos) <= radisu + additDistance then
                        ent:AddFreeze(EntityRef(player), 30)
                        if math.random(1,5) == 5 then
                            if not playerdata.RageCrystal then
                                playerdata.RageCrystal = 1 
                            elseif  playerdata.RageCrystal < 5 then
                                playerdata.RageCrystal =  playerdata.RageCrystal + 1 
                            end
                        end
                        data.did_hit = true
                        ent.Velocity = (ent.Velocity + (Vector(10,0))):Rotated(data.Angle):Resized(3)
                        InutilLib.SetTimer(0+addendEnemy*5, function()
                            local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_REBEKAH_DUST, RebekahCurseDustEffects.ENTITY_REBEKAH_CURSED_SLAM_DEFAULT, ent.Position, Vector.Zero, ent)
                            yandereWaifu.GetEntityData(poof).Parent = ent
                            if data.canPoison then
                                poof:GetSprite().Color = Color( 1, 1, 1, 1, 0, 215, 0 );
                            elseif data.canFear then
                                poof:GetSprite().Color = Color( 0.4, 0, 1, 1, 0, 0, 0 );
                            else
                                poof:GetSprite().Color = Color( 1, 1, 1, 1, 0, 155, 155 );
                            end
                        end)
                        addendEnemy = addendEnemy + 1
                    end
                end
            end
            if data.did_hit then
                cut(125, pos, (player.Damage))
            else
                return
            end
            --yandereWaifu.GetEntityData(player).invincibleTime = 15
            --player.Velocity = (player.Velocity + (Vector(10,0))):Rotated(data.Angle-180):Resized(2)
            Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 1, pos, Vector(0,0), player)
            ILIB.game:ShakeScreen(6)
            if data.did_hit then
                InutilLib.SFX:Play( RebekahCurseSounds.SOUND_CURSED_SLAM, 1, 0, false, math.random(9,11)/10 );
            else
                InutilLib.SFX:Play( SoundEffect.SOUND_SHELLGAME, 1, 0, false, 1.2 );
            end
        end
    elseif data.state == 5 then --heavy strike
        local pos =(eff.Position)+ (Vector(26,0):Rotated(data.Angle))
        if sprite:IsFinished("Slice") then
            data.state = 0
        end
        if not sprite:IsPlaying("Slice") then
            sprite:Play("Slice")
            sprite.Rotation = data.Angle
        end
        if sprite:GetFrame() >= 4 and sprite:GetFrame() <= 6 then
            data.did_hit = cut(180, pos, (player.Damage)*3)
            --stun
            local radisu = 60
            for i, ent in pairs (Isaac.GetRoomEntities()) do
                if (ent:IsEnemy() and ent:IsVulnerableEnemy()) or ent.Type == EntityType.ENTITY_FIREPLACE and not ent:IsDead() then
                    local dmg = 2
                    local additDistance = 0
                    if ent.Position:Distance(pos) <= radisu + additDistance then
                        ent:AddConfusion(EntityRef(player), 30)
                        if sprite:GetFrame() == 5 then
                            local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_REBEKAH_DUST, RebekahCurseDustEffects.ENTITY_REBEKAH_CURSED_HEAVY_STRIKE, ent.Position, Vector.Zero, ent)
                            yandereWaifu.GetEntityData(poof).Parent = ent
                        end
                    end
                end
            end
        end
        if sprite:GetFrame() == 5 then
            --yandereWaifu.GetEntityData(player).invincibleTime = 20
            player.Velocity = (player.Velocity + (Vector(10,0))):Rotated(data.Angle-180):Resized(5)
            Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 1, pos, Vector(0,0), player)
            ILIB.game:ShakeScreen(8)
            ILIB.game:MakeShockwave(eff.Position, 0.075, 0.025, 10)
            if data.did_hit then
                InutilLib.SFX:Play( RebekahCurseSounds.SOUND_CURSED_HEAVY_STRIKE, 1, 0, false, math.random(9,11)/10  );
             else
                InutilLib.SFX:Play( SoundEffect.SOUND_SHELLGAME, 1, 0, false, 1 );
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
            sprite:Load("gfx/effects/tainted/cursed/weapon.anm2", true)
            sprite:LoadGraphics()
            sprite:Play("Fly", true)
            tr.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE;
        else
            for i, ent in pairs (Isaac.GetRoomEntities()) do
                if (ent:IsEnemy() and ent:IsVulnerableEnemy()) or ent.Type == EntityType.ENTITY_FIREPLACE and not ent:IsDead() then
                    local dmg = 2
                    local additDistance = 0
                    if ent.Position:Distance((tr.Position)) <= 75 + additDistance then
                        ent:TakeDamage((player.Damage/5) * dmg, 0, EntityRef(player), 1)
                    end
                end
            end
            if tr.FrameCount > 15 then
                 tr.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS;
            end
            tr.Height = -8
            if tr:CollidesWithGrid() then
                local sword = player:FireTear( player.Position,  (tr.Position - player.Position):Resized(9+player.ShotSpeed):Rotated(180), false, false, false):ToTear()
                -- local sword = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0, player.Position, Vector(0,20):Rotated(data.taintedCursedDir-90), player):ToTear()
                sword:AddTearFlags(TearFlags.TEAR_BOOMERANG | TearFlags.TEAR_PIERCING)
                yandereWaifu.GetEntityData(sword).IsCursedSword = true
                sword.Position = tr.Position
                tr:Remove()
                ILIB.game:ShakeScreen(5)
            end
        end
        if player.Position:Distance(tr.Position) < 45 and tr.FrameCount > 3 then
            tr:Remove()
        end
    end
end)


yandereWaifu:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, function(_, tr)
	local data = yandereWaifu.GetEntityData(tr)
    if tr.SpawnerEntity then
        local player = tr.SpawnerEntity:ToPlayer()
        local sprite = tr:GetSprite()
        if data.IsCursedSword then
            yandereWaifu.GetEntityData(player).CanShoot = true
            yandereWaifu.GetEntityData(player).CantTaintedSkill = false
            yandereWaifu.GetEntityData(player).CantGiveCrystal = false
        end
    end
end, EntityType.ENTITY_TEAR)

