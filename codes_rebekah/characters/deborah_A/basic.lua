
function yandereWaifu.DeborahInit(player)
	local mode 
	local data = yandereWaifu.GetEntityData(player)
	player:AddNullCostume(RebekahCurse.Costumes.DeborahBody);
end

yandereWaifu:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, function(_,player)
	if player:GetPlayerType() ==  RebekahCurse.DEBORAH then
        yandereWaifu.DeborahInit(player)
    end
end)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_NEW_ROOM,
function()
    local num_players = InutilLib.game:GetNumPlayers()
    for i=0,(num_players-1) do
        local player = Isaac.GetPlayer(i)
        local data = yandereWaifu.GetEntityData(player)
        if player:GetPlayerType() == RebekahCurse.DEBORAH then 

			if not data.DeborahGun or data.DeborahGun:IsDead() then
				yandereWaifu.SpawnDeborahGun(player)
			end
		end
    end
end
)

function yandereWaifu:DeborahBulletTearUpdate(tr, _)
	local data = yandereWaifu.GetEntityData(tr)
	if data.DeborahBullet then
		tr:GetSprite().Rotation = tr.Velocity:GetAngleDegrees()
        tr.SpriteScale = Vector(2, 1)
		if tr.FrameCount == 1 then
            data.trail = InutilLib.SpawnTrail(tr, Color(1,1,1,1), _, Vector(1,22))
			local player, data, flags, scale = tr.SpawnerEntity:ToPlayer(), yandereWaifu.GetEntityData(tr), tr.TearFlags, tr.Scale 
			local size = InutilLib.GetTearSizeTypeI(scale, flags)
			InutilLib.UpdateRegularTearAnimation(player, tr, data, flags, size, "RegularTear");
			--InutilLib.UpdateDynamicTearAnimation(player, tr, data, flags, "Rotate", "", size)
		end
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, yandereWaifu.DeborahBulletTearUpdate)


local gunChamber = Sprite();
gunChamber:Load("gfx/ui/ui_gun_reserve.anm2", true);

yandereWaifu:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, function(_, player)
    if player:GetPlayerType() == RebekahCurse.DEBORAH then
        local data = yandereWaifu.GetEntityData(player)
        gunChamber:SetFrame("Idle", 0)
        local playerLocation = Isaac.WorldToScreen(player.Position)
        gunChamber:Render((playerLocation + Vector(0,-65)), Vector(0,0), Vector(0,0))

        for i = 1, 6 do
            gunChamber:ReplaceSpritesheet(i, "gfx/ui/bullet/none.png")
        end
        for i, v in pairs (data.DeborahGunClip) do
            gunChamber:ReplaceSpritesheet(i, v.gfx or "gfx/ui/bullet/none.png")
        end
        gunChamber:LoadGraphics()
        gunChamber.Color = Color(1,1,1,data.gunChamberTransFrame or 0.5)
    end
end);



function yandereWaifu.FillBullet(player)
    local data = yandereWaifu.GetEntityData(player)
    if not data.DeborahGunClip then
        data.DeborahGunClip = {}
    end
    table.insert(data.DeborahGunClip, {name = "normal", gfx = "gfx/ui/bullet/base.png", damage = player.Damage})
end


yandereWaifu:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_,player)
    local data = yandereWaifu.GetEntityData(player)

    if data.CanShoot == nil then data.CanShoot = true end
    if data.DeborahGun and data.DeborahGun:IsDead() then
        data.DeborahGun = nil
    end
	if player:GetPlayerType() == RebekahCurse.DEBORAH then
        
        local numofShots = 1
        local tearIntervalPenalty = 0

        --gun storage thing
        if not data.DeborahGunClip then
            data.DeborahGunClip = {}
        end
        --neptunus synergy
        if not data.NeptunusDeborahCount then data.NeptunusDeborahCount = 0 end
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

        numofShots = numofShots + math.min(data.NeptunusDeborahCount)

        --[[reimplement tear delay
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
                    local sword = ThrowCursedSword(player)
                    yandereWaifu.GetEntityData(sword).Sword = data.taintedWeapon
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
		end]]

        --when shoot
		if data.HasPressed and player:GetShootingInput().X == 0 and player:GetShootingInput().Y == 0 then
			data.HasPressed = false
            if player.FrameCount % 3 == 0 then
                if data.gunChamberTransFrame and data.gunChamberTransFrame > 0 then
                    data.gunChamberTransFrame =  data.gunChamberTransFrame - 0.2
                elseif not data.gunChamberTransFrame then
                    data.gunChamberTransFrame = 0.5
                end
            end
		end
        if player:GetShootingInput().X == 0 and player:GetShootingInput().Y == 0 then
            if player.FrameCount % 3 == 0 then
                if data.gunChamberTransFrame and data.gunChamberTransFrame > 0 then
                    data.gunChamberTransFrame = data.gunChamberTransFrame - 0.2
                elseif not data.gunChamberTransFrame then
                    data.gunChamberTransFrame = 0.5
                end
            end
		end
        --shot speed interval
        if not data.shotSpeedInterval then data.shotSpeedInterval = player.ShotSpeed end --tells how long it takes before to reload the next bullet
			
        if data.shotSpeedInterval > 0 then
		    data.shotSpeedInterval = data.shotSpeedInterval - 1
        end

        local canShoot = data.shotSpeedInterval and TableLength(data.DeborahGunClip) > 0 and data.CanShoot and (Input.IsActionPressed(ButtonAction.ACTION_SHOOTLEFT, player.ControllerIndex) or Input.IsActionPressed(ButtonAction.ACTION_SHOOTRIGHT, player.ControllerIndex) or Input.IsActionPressed(ButtonAction.ACTION_SHOOTUP, player.ControllerIndex) or Input.IsActionPressed(ButtonAction.ACTION_SHOOTDOWN, player.ControllerIndex))
        if not data.HasPressed and canShoot then
			data.HasPressed = true
            data.shotSpeedInterval = player.ShotSpeed
            if not data.DeborahGun or data.DeborahGun:IsDead() then
                yandereWaifu.SpawnDeborahGun(player)
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
                --for i, angle in pairs(data.eyeSoreBarAngles) do
                --    yandereWaifu.SpawnAndSwingCursedKnife(player, 1, angle, false)
                --end
            end
            for lhorns = 0, 270, 360/4 do
                local direction = InutilLib.DirToVec(player:GetFireDirection()):GetAngleDegrees() +  lhorns --player:GetShootingInput():GetAngleDegrees() + lhorns
                local oldDir = direction
                for wizAng = -45, 90, 135 do
                    if player:HasCollectible(CollectibleType.COLLECTIBLE_THE_WIZ) and lhorns == 0 then --sets the wiz angles
                        direction = (direction + wizAng)
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
                                yandereWaifu.ShootDeborahGun(player, data.DeborahGun, 1, direction, flip, data.DeborahGunClip[1].damage)
                            else
                                --yandereWaifu.SpawnAndSwingCursedKnife(player, 1, direction, flip)
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
            --data.TaintedTearDelay = math.floor(player.MaxFireDelay*1.5)
            table.remove(data.DeborahGunClip, 1)
            gunChamber:LoadGraphics()
            data.gunChamberTransFrame = 1
        elseif TableLength(data.DeborahGunClip) <= 0 and data.CanShoot then
            data.CanShoot = false
        end
        if TableLength(data.DeborahGunClip) < 6 and not data.CanShoot then
            if not data.reloadInterval then 
                if InutilLib.room:IsClear() then
                    data.reloadInterval = player.MaxFireDelay /2
                else
                    data.reloadInterval = player.MaxFireDelay 
                end --tells how long it takes before to reload the next bullet
            end
			
            if data.reloadInterval > 0 then
			    data.reloadInterval = data.reloadInterval - 1
            else
               -- InutilLib.SetTimer( i*60, function()
                yandereWaifu.FillBullet(player)
               data.reloadInterval = player.MaxFireDelay
            end
            data.gunChamberTransFrame = 1
        elseif TableLength(data.DeborahGunClip) >= 6 and not data.CanShoot then
            data.CanShoot = true
        end
    end
end)

function yandereWaifu:DeborahregisterCache(player, cacheF) --The thing the checks and updates the game, i guess?
	local data = yandereWaifu.GetEntityData(player)
	if player:GetPlayerType() == RebekahCurse.DEBORAH then -- Especially here!
		if cacheF == CacheFlag.CACHE_DAMAGE then
			player.Damage = player.Damage * 2.2
		end
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, yandereWaifu.DeborahregisterCache)


yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local player = yandereWaifu.GetEntityData(eff).parent
	local sprite = eff:GetSprite();
	local playerdata = yandereWaifu.GetEntityData(player)
	local data = yandereWaifu.GetEntityData(eff)
		
	if player:HasCollectible(CollectibleType.COLLECTIBLE_MARKED) then
		data.direction = player:GetAimDirection():GetAngleDegrees()
	end

	--eff.Position = player.Position + (Vector(0,20)):Rotated((data.direction):GetAngleDegrees()-90);
	local lerpVal = 0.6
	eff.Velocity = InutilLib.Lerp(eff.Velocity,(player.Position + player.Velocity:Resized(20))-eff.Position, lerpVal)
	--eff.Velocity = InutilLib.Lerp(eff.Velocity,(player.Position + player:GetShootingInput():Resized(15))-eff.Position, lerpVal)
		
	--print(eff:GetSprite().Rotation)
	eff.RenderZOffset = 10
	sprite.Offset = Vector(0,-10)
		
	if data.Shoot then
		sprite.Rotation = Round((data.direction), 1)
		print(sprite.Rotation)
		if ((sprite.Rotation <= 45 and sprite.Rotation >= 0) or (sprite.Rotation <= 0 and sprite.Rotation >= -45)) and not sprite:IsPlaying("ShootRight") then
			sprite:Play("ShootRight", true)
			--sprite.FlipY = true
		elseif ((sprite.Rotation > 135 and sprite.Rotation <= 180) or (sprite.Rotation >= -180 and sprite.Rotation <= -135)) and not sprite:IsPlaying("ShootLeft") then
			sprite:Play("ShootLeft", true)
		elseif sprite.Rotation < 135 and sprite.Rotation > 45 and not sprite:IsPlaying("ShootDown") then
			sprite:Play("ShootDown", true)
		elseif sprite.Rotation > -180 and sprite.Rotation < 0 and not sprite:IsPlaying("ShootUp") then
			sprite:Play("ShootUp", true)
		end
		data.Shoot = false
	end
end, RebekahCurse.ENTITY_DEBORAHENTITYWEAPON);
