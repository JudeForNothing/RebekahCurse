--wip knives synergies
--wip tainted rebekah synergy
function yandereWaifu:FullMilkCache(player, cacheF) --The thing the checks and updates the game, i guess?
	local data = yandereWaifu.GetEntityData(player)
	if player:HasCollectible(RebekahCurseItems.COLLECTIBLE_FULLFATMILK) then
		--if data.SnapDelay then
		--	if cacheF == CacheFlag.CACHE_FIREDELAY then
		--		player.FireDelay = player.FireDelay - data.SnapDelay
		--	end
		--end
		if cacheF == CacheFlag.CACHE_DAMAGE and data.PersistentPlayerData.FullMilkTearMulti then
			player.Damage = player.Damage * data.PersistentPlayerData.FullMilkTearMulti
		end
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, yandereWaifu.FullMilkCache)


yandereWaifu:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_,player)
    local data = yandereWaifu.GetEntityData(player)
    if not data.PersistentPlayerData.FullMilkTearMulti then data.PersistentPlayerData.FullMilkTearMulti = 1 end
    if not data.PersistentPlayerData.FullMilkMutantSpiderCount then data.PersistentPlayerData.FullMilkMutantSpiderCount = 0 end
    if not data.PersistentPlayerData.FullMilk2020Count then data.PersistentPlayerData.FullMilk2020Count = 0 end
    if not data.PersistentPlayerData.FullMilkWizCount then data.PersistentPlayerData.FullMilkWizCount = 0 end
    if not data.PersistentPlayerData.FullMilkLokisHornsCount then data.PersistentPlayerData.FullMilkLokisHornsCount = 0 end
    if not data.PersistentPlayerData.FullMilkLokisHornsCount then data.PersistentPlayerData.FullMilkLokisHornsCount = 0 end
    if not data.PersistentPlayerData.FullMilkLokisHornsCount then data.PersistentPlayerData.FullMilkLokisHornsCount = 0 end
    if not data.PersistentPlayerData.FullMilkLokisHornsCount then data.PersistentPlayerData.FullMilkLokisHornsCount = 0 end

    if player:HasCollectible(RebekahCurseItems.COLLECTIBLE_FULLFATMILK) then        
        if player:HasCollectible(CollectibleType.COLLECTIBLE_MUTANT_SPIDER) then
            data.PersistentPlayerData.FullMilkTearMulti = data.PersistentPlayerData.FullMilkTearMulti + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_MUTANT_SPIDER) * 1.5
            data.PersistentPlayerData.FullMilkMutantSpiderCount = data.PersistentPlayerData.FullMilkMutantSpiderCount + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_MUTANT_SPIDER)
            for i = 1, player:GetCollectibleNum(CollectibleType.COLLECTIBLE_MUTANT_SPIDER) do
                player:RemoveCollectible(CollectibleType.COLLECTIBLE_MUTANT_SPIDER)
                print("balls")
            end
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE);
			player:EvaluateItems()
        end
        if player:HasCollectible(CollectibleType.COLLECTIBLE_20_20) then
            data.PersistentPlayerData.FullMilkTearMulti = data.PersistentPlayerData.FullMilkTearMulti + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_20_20) 
            data.PersistentPlayerData.FullMilk2020Count =  data.PersistentPlayerData.FullMilk2020Count + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_20_20)
            for i = 1, player:GetCollectibleNum(CollectibleType.COLLECTIBLE_20_20) do
                player:RemoveCollectible(CollectibleType.COLLECTIBLE_20_20)
            end
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE);
			player:EvaluateItems()
        end
        if player:HasCollectible(CollectibleType.COLLECTIBLE_THE_WIZ) then
            data.PersistentPlayerData.FullMilkTearMulti = data.PersistentPlayerData.FullMilkTearMulti + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_THE_WIZ) 
            data.PersistentPlayerData.FullMilk2020Count =  data.PersistentPlayerData.FullMilkWizCount + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_THE_WIZ)
            for i = 1, player:GetCollectibleNum(CollectibleType.COLLECTIBLE_THE_WIZ) do
                player:RemoveCollectible(CollectibleType.COLLECTIBLE_THE_WIZ)
            end
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE);
			player:EvaluateItems()
        end
        if player:HasCollectible(CollectibleType.COLLECTIBLE_LOKIS_HORNS) then
            data.PersistentPlayerData.FullMilkTearMulti = data.PersistentPlayerData.FullMilkTearMulti + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_LOKIS_HORNS) * 2
            data.PersistentPlayerData.FullMilkLokisHornsCount =  data.PersistentPlayerData.FullMilkLokisHornsCount + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_LOKIS_HORNS)
            for i = 1, player:GetCollectibleNum(CollectibleType.COLLECTIBLE_LOKIS_HORNS) do
                player:RemoveCollectible(CollectibleType.COLLECTIBLE_LOKIS_HORNS)
            end
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE);
			player:EvaluateItems()
        end
        
        if player:HasCollectible(CollectibleType.COLLECTIBLE_INNER_EYE) then
            data.PersistentPlayerData.FullMilkTearMulti = data.PersistentPlayerData.FullMilkTearMulti + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_INNER_EYE) 
            data.PersistentPlayerData.FullMilkLokisHornsCount = data.PersistentPlayerData.FullMilkLokisHornsCount + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_INNER_EYE)
            for i = 1, player:GetCollectibleNum(CollectibleType.COLLECTIBLE_INNER_EYE) do
                player:RemoveCollectible(CollectibleType.COLLECTIBLE_INNER_EYE)
            end
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE);
			player:EvaluateItems()
        end
        if TaintedTreasure and player:HasCollectible(TaintedCollectibles.SPIDER_FREAK) then
            data.PersistentPlayerData.FullMilkTearMulti = data.PersistentPlayerData.FullMilkTearMulti + player:GetCollectibleNum(TaintedCollectibles.SPIDER_FREAK) * 2.5
            data.PersistentPlayerData.FullMilkLokisHornsCount = data.PersistentPlayerData.FullMilkLokisHornsCount + player:GetCollectibleNum(TaintedCollectibles.SPIDER_FREAK)
            for i = 1, player:GetCollectibleNum(TaintedCollectibles.SPIDER_FREAK) do
                player:RemoveCollectible(TaintedCollectibles.SPIDER_FREAK)
            end
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE);
			player:EvaluateItems()
        end
        if FiendFolio and player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.BEE_SKIN) then
            data.PersistentPlayerData.FullMilkTearMulti = data.PersistentPlayerData.FullMilkTearMulti + player:GetCollectibleNum(FiendFolio.ITEM.COLLECTIBLE.BEE_SKIN) * 1.5
            data.PersistentPlayerData.FullMilkLokisHornsCount = data.PersistentPlayerData.FullMilkLokisHornsCount + player:GetCollectibleNum(FiendFolio.ITEM.COLLECTIBLE.BEE_SKIN)
            for i = 1, player:GetCollectibleNum(FiendFolio.ITEM.COLLECTIBLE.BEE_SKIN) do
                player:RemoveCollectible(FiendFolio.ITEM.COLLECTIBLE.BEE_SKIN)
            end
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE);
			player:EvaluateItems()
        end
    elseif not player:HasCollectible(RebekahCurseItems.COLLECTIBLE_FULLFATMILK) then
        if data.PersistentPlayerData.FullMilkMutantSpiderCount > 0 then 
            for i = 1, data.PersistentPlayerData.FullMilkMutantSpiderCount do
                player:AddCollectible(CollectibleType.COLLECTIBLE_MUTANT_SPIDER, 0, true)
            end
            data.PersistentPlayerData.FullMilkMutantSpiderCount = 0
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE);
			player:EvaluateItems()
        end
        if data.PersistentPlayerData.FullMilk2020Count > 0  then 
            for i = 1, data.PersistentPlayerData.FullMilk2020Count do
                player:AddCollectible(CollectibleType.COLLECTIBLE_20_20, 0, true)
            end
            data.PersistentPlayerData.FullMilk2020Count = 0
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE);
			player:EvaluateItems()
        end
        if data.PersistentPlayerData.FullMilkWizCount > 0  then 
            for i = 1, data.PersistentPlayerData.FullMilkWizCount do
                player:AddCollectible(CollectibleType.COLLECTIBLE_THE_WIZ, 0, true)
            end
            data.PersistentPlayerData.FullMilkWizCount = 0
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE);
			player:EvaluateItems()
        end 
        if data.PersistentPlayerData.FullMilkLokisHornsCount > 0  then 
            for i = 1, data.PersistentPlayerData.FullMilkLokisHornsCount do
                player:AddCollectible(CollectibleType.COLLECTIBLE_LOKIS_HORNS, 0, true)
            end
            data.PersistentPlayerData.FullMilkLokisHornsCount = 0
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE);
			player:EvaluateItems()
        end
        if data.PersistentPlayerData.FullMilkLokisHornsCount > 0  then
            for i = 1, data.PersistentPlayerData.FullMilkLokisHornsCount do
                player:AddCollectible(CollectibleType.COLLECTIBLE_INNER_EYE, 0, true)
            end
            data.PersistentPlayerData.FullMilkLokisHornsCount = 0 
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE);
			player:EvaluateItems()
        end
        if TaintedTreasure and data.PersistentPlayerData.FullMilkLokisHornsCount > 0  then
            for i = 1, data.PersistentPlayerData.FullMilkLokisHornsCount do
                player:AddCollectible(TaintedCollectibles.SPIDER_FREAK, 0, true)
            end
            data.PersistentPlayerData.FullMilkLokisHornsCount = 0
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE);
			player:EvaluateItems()
        end
        if FiendFolio and data.PersistentPlayerData.FullMilkLokisHornsCount > 0  then
            for i = 1, data.PersistentPlayerData.FullMilkLokisHornsCount do
                player:AddCollectible(FiendFolio.ITEM.COLLECTIBLE.BEE_SKIN, 0, true)
            end
            data.PersistentPlayerData.FullMilkLokisHornsCount = 0
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE);
			player:EvaluateItems()
        end
    end
end)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, function(_,tear)
    local parent, spr, data = tear.Parent, tear:GetSprite(), yandereWaifu.GetEntityData(tear)
    local player = parent:ToPlayer()
    local playerdata = yandereWaifu.GetEntityData(player)
    local direction = player:GetShootingInput()
    if player:HasCollectible(CollectibleType.COLLECTIBLE_MARKED) then 
        direction = player:GetAimDirection()
    end
    if player:HasCollectible(RebekahCurseItems.COLLECTIBLE_FULLFATMILK) then
        if playerdata.AntiRecursiveFullMilk then return end
        if playerdata.FullFatTear and playerdata.FullFatTear:IsDead() then
            playerdata.FullFatTear = nil
        end
        if not playerdata.FullFatTear then
            playerdata.AntiRecursiveFullMilk = true
            if not player:HasWeaponType(WeaponType.WEAPON_FETUS) then
                playerdata.FullFatTear = player:FireTear(player.Position, direction:Resized(10*player.ShotSpeed), false, false, false):ToTear()
                --playerdata.FullFatTear:ChangeVariant(tear.Variant)
                tear:Remove()
            else
                playerdata.FullFatTear = tear
            end
            playerdata.FullFatTearDmg = 1
            
            playerdata.AntiRecursiveFullMilk = false
        else
            playerdata.FullFatTearDmg = playerdata.FullFatTearDmg + 1
            playerdata.FullFatTear.CollisionDamage = playerdata.FullFatTear.CollisionDamage + player.Damage/2
            playerdata.FullFatTear.Scale = playerdata.FullFatTear.Scale + 0.2
            tear:Remove()
        end
    end
end)


yandereWaifu:AddCallback(ModCallbacks.MC_POST_LASER_INIT, function(_,lz)
	if lz.SpawnerEntity then
		local player = lz.SpawnerEntity:ToPlayer()
		if player then
            local direction = player:GetLastDirection()
            if player:HasCollectible(CollectibleType.COLLECTIBLE_MARKED) then 
                direction = player:GetAimDirection()
            end
			local pldata = yandereWaifu.GetEntityData(player)
			if player:HasCollectible(RebekahCurseItems.COLLECTIBLE_FULLFATMILK) then
                if pldata.AntiRecursiveFullMilk then return end
				--if player:HasWeaponType(WeaponType.WEAPON_LASER) or player:HasWeaponType(WeaponType.WEAPON_TECH_X) then
					local spr = lz:GetSprite()
					if pldata.FullFatTear and pldata.FullFatTear:IsDead() then
                        pldata.FullFatTear = nil
                    end
                    if not pldata.FullFatTear then
                        pldata.AntiRecursiveFullMilk = true
                        if player:HasWeaponType(WeaponType.WEAPON_LASER) then
                            pldata.FullFatTear = player:FireTechLaser(lz.Position, 0, direction, false, true):ToLaser()
                        elseif player:HasWeaponType(WeaponType.WEAPON_TECH_X) then
                            print(direction)
                            pldata.FullFatTear = player:FireTechXLaser(player.Position, Vector.FromAngle(direction:GetAngleDegrees()):Resized(4), lz.Radius, player, 1):ToLaser()
                        elseif player:HasWeaponType(WeaponType.WEAPON_BRIMSTONE) then
                            pldata.FullFatTear = player:FireBrimstone( Vector.FromAngle(direction:GetAngleDegrees()), player, 2):ToLaser();
                        end
                        pldata.FullFatTearDmg = 1
                        if not player:HasWeaponType(WeaponType.WEAPON_BRIMSTONE) and player:HasCollectible(CollectibleType.COLLECTIBLE_SOY_MILK) then
                            lz:Remove()
                        end
                        pldata.AntiRecursiveFullMilk = false
                    else
                        pldata.FullFatTearDmg = pldata.FullFatTearDmg + 1
                        pldata.FullFatTear.CollisionDamage = pldata.FullFatTear.CollisionDamage + 2
                        if player:HasWeaponType(WeaponType.WEAPON_LASER) then
                            --InutilLib.UpdateBrimstoneDamage( pldata.FullFatTear, pldata.FullFatTear.CollisionDamage + 1)
                            InutilLib.UpdateRepLaserSize(pldata.FullFatTear, pldata.FullFatTearDmg, false)
                        elseif player:HasWeaponType(WeaponType.WEAPON_TECH_X) then
                            pldata.AntiRecursiveFullMilk = true
                            local oldTear = pldata.FullFatTear
                            pldata.FullFatTear = player:FireTechXLaser(oldTear.Position, Vector.FromAngle(oldTear.Velocity:GetAngleDegrees()):Resized(4), oldTear.Radius, player, pldata.FullFatTearDmg/2):ToLaser()
                            pldata.FullFatTear.CollisionDamage = oldTear.CollisionDamage + pldata.FullFatTearDmg/2
                            oldTear:Remove()
                            InutilLib.UpdateRepLaserSize(pldata.FullFatTear, pldata.FullFatTearDmg/3, false)
                            pldata.AntiRecursiveFullMilk = false
                        end
                        lz:Remove()
                    end
                --end
			end
		end
	end
end)

yandereWaifu:AddCallback("MC_POST_FIRE_BOMB", function(_, bb)
	local player = bb.SpawnerEntity:ToPlayer()
	local playerdata = yandereWaifu.GetEntityData(player)
	local parent, spr, data = bb.Parent, bb:GetSprite(), yandereWaifu.GetEntityData(bb)
    local direction = player:GetShootingInput()
    if player:HasCollectible(CollectibleType.COLLECTIBLE_MARKED) then 
        direction = player:GetAimDirection()
    end
    if player:HasCollectible(RebekahCurseItems.COLLECTIBLE_FULLFATMILK) then
        if playerdata.AntiRecursiveFullMilk then return end
        if playerdata.FullFatTear and playerdata.FullFatTear:IsDead() then
            playerdata.FullFatTear = nil
        end
        if not playerdata.FullFatTear then
            playerdata.AntiRecursiveFullMilk = true
            playerdata.FullFatTear = bb--player:FireBomb(player.Position, direction:Resized(10*player.ShotSpeed), player):ToBomb()
            playerdata.FullFatTear.Velocity = playerdata.FullFatTear.Velocity + direction:Resized(10*player.ShotSpeed)
            playerdata.FullFatTearDmg = 1
            --bb:Remove()
            playerdata.AntiRecursiveFullMilk = false
        else
            playerdata.FullFatTearDmg = playerdata.FullFatTearDmg + 2*player.Damage
            playerdata.FullFatTear.ExplosionDamage = playerdata.FullFatTear.ExplosionDamage + playerdata.FullFatTearDmg
           -- playerdata.FullFatTear.Scale = playerdata.FullFatTear.Scale + 0.25
            bb:Remove()
            playerdata.FullFatTear.SpriteScale = playerdata.FullFatTear.SpriteScale + Vector(playerdata.FullFatTearDmg/5, playerdata.FullFatTearDmg/5)
        end
    end
end)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, function(_,  eff)
	--local parent = eff.Parent
	local player = eff.SpawnerEntity:ToPlayer()
	--print(player)
	if player and player.Type == EntityType.ENTITY_PLAYER then
		local pldata = yandereWaifu.GetEntityData(player)
        local direction = player:GetShootingInput()
        if player:HasCollectible(CollectibleType.COLLECTIBLE_MARKED) then 
            direction = player:GetAimDirection()
        end
		if player:HasCollectible(RebekahCurseItems.COLLECTIBLE_FULLFATMILK) and player:HasWeaponType(WeaponType.WEAPON_ROCKETS) then
			local spr = eff:GetSprite()
			if pldata.AntiRecursiveFullMilk then return end
            if pldata.FullFatTear and pldata.FullFatTear:IsDead() then
                pldata.FullFatTear = nil
            end
            if not pldata.FullFatTear then
                pldata.AntiRecursiveFullMilk = true
                pldata.FullFatTear = eff
                --pldata.FullFatTear:ChangeVariant(tear.Variant)
                pldata.FullFatTearDmg = 1
                
                pldata.AntiRecursiveFullMilk = false
            else
                pldata.FullFatTearDmg = pldata.FullFatTearDmg + (player.Damage * 20)
                print(pldata.FullFatTearDmg)
                --pldata.FullFatTear.DamageSource = pldata.FullFatTear.DamageSource + player.Damage/2
                eff:Remove()
            end
		end
	end
end, EffectVariant.TARGET);


--[[yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, function(_, rocket) --Main Code
    if not rocket.SpawnerEntity then return end
    local player = rocket.SpawnerEntity:ToPlayer()
    if not player then return end
    local pldata = yandereWaifu.GetEntityData(player)
    if player:HasCollectible(RebekahCurseItems.COLLECTIBLE_FULLFATMILK) and player:HasWeaponType(WeaponType.WEAPON_ROCKETS) then
        if pldata.FullFatTearDmg then 
            print("orion stil sucks")
                print(pldata.FullFatTearDmg)
            rocket.DamageSource = math.floor(rocket.DamageSource + (player.Damage * 20))
            print(rocket.DamageSource)
        end
        rocket:Update()
    end
end, 31)]]

yandereWaifu:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, ent, damage, flags, source, countdown)
	local data = ent:GetData()
    if source.Type == EntityType.ENTITY_PLAYER and flags == flags | DamageFlag.DAMAGE_LASER then
		local player = source.Entity:ToPlayer()
        local pldata = yandereWaifu.GetEntityData(player)
        if not pldata.IgnoreFullMilkBrimDmg then
            if player:HasCollectible(RebekahCurseItems.COLLECTIBLE_FULLFATMILK) then
                pldata.FullFatTearDmg = pldata.FullFatTearDmg + 1
                pldata.IgnoreFullMilkBrimDmg = true
                ent:TakeDamage( damage + pldata.FullFatTearDmg/2, flags, EntityRef(player), 0);
                InutilLib.UpdateRepLaserSize(pldata.FullFatTear, pldata.FullFatTearDmg, false)
                pldata.IgnoreFullMilkBrimDmg = nil
                return false
            end
        end
    elseif source.Type == 1000 then
        local rocket = source.Entity:ToEffect()
        if rocket and source.Variant == 31 then
            local player = rocket.SpawnerEntity:ToPlayer() --get player from the rocket, damn
            local pldata = yandereWaifu.GetEntityData(player)
            if player and not pldata.IgnoreFullMilkBrimDmg and pldata.FullFatTearDmg then
                pldata.IgnoreFullMilkBrimDmg = true
                ent:TakeDamage(pldata.FullFatTearDmg, flags, source, countdown)
                pldata.IgnoreFullMilkBrimDmg = nil
                return false
            end
        end
    elseif source.Type == 8 then
        local knife = source.Entity:ToKnife()
        --if rocket and source.Variant == 31 then
        local player = knife.SpawnerEntity:ToPlayer()
        if player:HasCollectible(RebekahCurseItems.COLLECTIBLE_FULLFATMILK) then
            local pldata = yandereWaifu.GetEntityData(player)
            if yandereWaifu.GetEntityData(knife).IsHidden then return false end
            if player and not pldata.IgnoreFullMilkBrimDmg and pldata.FullFatTearDmg then
                pldata.IgnoreFullMilkBrimDmg = true
                ent:TakeDamage(pldata.FullFatTearDmg, flags, source, countdown)
                pldata.IgnoreFullMilkBrimDmg = nil
                return false
            end
        end
    end
end)

--screw knives i cant get it to work
--[[
yandereWaifu:AddCallback(ModCallbacks.MC_POST_KNIFE_UPDATE, function(_, kn)

	local player = kn.SpawnerEntity:ToPlayer()
	local pldata = yandereWaifu.GetEntityData(player)
    --mom's knife stuff
    if pldata.FullFatTear then
        if GetPtrHash(pldata.FullFatTear) == GetPtrHash(kn) then 
        end
        if yandereWaifu.GetEntityData(kn).IsHidden then
            --kn.Visible = false
            kn.GridCollisionClass = GridCollisionClass.COLLISION_NONE;
		    kn.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE;
            if player then
                kn.Position = player.Position
            end
        end
    end
    --when charging
	if player and player:HasCollectible(RebekahCurseItems.COLLECTIBLE_FULLFATMILK) then
		local spr = kn:GetSprite()
		if player:HasWeaponType(WeaponType.WEAPON_KNIFE) then
			if not pldata.NoActiveKnife then pldata.NoActiveKnife = true end
			local direction = player:GetShootingInput()
            if player:HasCollectible(CollectibleType.COLLECTIBLE_MARKED) then 
                direction = player:GetAimDirection()
            end
            local data = InutilLib.GetILIBData(kn)
            if player:HasCollectible(RebekahCurseItems.COLLECTIBLE_FULLFATMILK) then
                if pldata.AntiRecursiveFullMilk then return end
                if pldata.FullFatTear and pldata.FullFatTear:IsDead() then
                    pldata.FullFatTear = nil
                end
                if data.state ~= 0 then 
                    if not pldata.FullFatTear then
                        pldata.AntiRecursiveFullMilk = true
                        pldata.FullFatTear = player:FireKnife(player, direction:Resized(10*player.ShotSpeed), false):ToKnife()
                        pldata.FullFatTear.Velocity = pldata.FullFatTear.Velocity + direction:Resized(10*player.ShotSpeed)
                        pldata.FullFatTearDmg = 1
                        --bb:Remove()
                        pldata.AntiRecursiveFullMilk = false
                    else
                        if data.state ~= 1 then 
                            pldata.FullFatTearDmg = 1
                            pldata.FullFatTear.SpriteScale = Vector(2,2)
                            pldata.FullFatTear = nil
                        else
                            pldata.FullFatTearDmg = pldata.FullFatTearDmg + player.Damage/4
                            pldata.FullFatTear.CollisionDamage = pldata.FullFatTear.CollisionDamage + pldata.FullFatTearDmg
                            -- playerdata.FullFatTear.Scale = playerdata.FullFatTear.Scale + 0.25
                                --kn:Remove()
                            if not yandereWaifu.GetEntityData(kn).IsHidden and GetPtrHash(pldata.FullFatTear) ~= GetPtrHash(kn) then
                                yandereWaifu.GetEntityData(kn).IsHidden = true
                            end
                            local size = pldata.FullFatTearDmg/5
                            if size > 1.5 then
                                size = 1.5
                            end
                            pldata.FullFatTear.SpriteScale = Vector(size, size)
                        end
                    end
                end
            end
			if kn.FrameCount == 1 then
				data.state = -1
				data.refreshStateFrame = 0
				data.lastVel = kn:GetKnifeVelocity()
				data.lastState = nil
				pldata.NoActiveKnife = true
			end
			--print(data.state, "state")
			if kn:GetKnifeVelocity() > 0 then
				data.lastState = data.state
				data.state = 1
				pldata.NoActiveKnife = false
			elseif kn:GetKnifeVelocity() < 0 and data.state == 1 then
				data.lastState = data.state
				data.state = 2
				data.refreshStateFrame = kn.FrameCount
			elseif kn:GetKnifeDistance() == 0 and data.state == 2 then
				data.lastState = data.state
				data.state = 0
				pldata.NoActiveKnife = true
                pldata.FullFatTear.SpriteScale = Vector(1, 1)
			end
		elseif player:HasWeaponType(WeaponType.WEAPON_BONE) then
			if not pldata.DontGreatPheonixTick and InutilLib.IsFinishedMultiple(spr, "Swing", "Swing2", "SwingDown", "SwingDown2") then
				if pldata.lastPSRPFrameCount then
					if InutilLib.game:GetFrameCount() == pldata.lastPSRPFrameCount then
						return
					end
					
					pldata.lastPSRPFrameCount = InutilLib.game:GetFrameCount()
					
					if not pldata.PSRPFireCount then
						pldata.PSRPFireCount = 1
					else
						pldata.PSRPFireCount = pldata.PSRPFireCount + 1
					end
					
					if pldata.PSRPFireCount > PencilSharpenerCount then
						pldata.PSRPFireCount = 0
						yandereWaifu.SharpenerFireTearBurst(player)
					end
				else
					pldata.lastPSRPFrameCount = InutilLib.game:GetFrameCount()
				end
				pldata.DontGreatPheonixTick = true
			elseif InutilLib.IsPlayingMultiple(spr, "Swing", "Swing2", "SwingDown", "SwingDown2", "AttackRight", "AttackLeft", "AttackDown", "AttackUp") then
				pldata.DontGreatPheonixTick = false
			end
		elseif player:HasWeaponType(WeaponType.WEAPON_SPIRIT_SWORD) then
			if spr:GetFrame() == 1 and InutilLib.IsPlayingMultiple(spr, "Swing", "Swing2", "SwingDown", "SwingDown2", "AttackRight", "AttackLeft", "AttackDown", "AttackUp") then
				if pldata.lastPSRPFrameCount then
					if InutilLib.game:GetFrameCount() == pldata.lastPSRPFrameCount then
						return
					end
					
					pldata.lastPSRPFrameCount = InutilLib.game:GetFrameCount()
					
					if not pldata.PSRPFireCount then
						pldata.PSRPFireCount = 1
					else
						pldata.PSRPFireCount = pldata.PSRPFireCount + 1
					end
					
					if pldata.PSRPFireCount > PencilSharpenerCount then
						pldata.PSRPFireCount = 0
						yandereWaifu.SharpenerFireTearBurst(player)
					end
				else
					pldata.lastPSRPFrameCount = InutilLib.game:GetFrameCount()
				end
			--	pldata.DontGreatPheonixTick = true
			--elseif InutilLib.IsPlayingMultiple(spr, "Swing", "Swing2", "SwingDown", "SwingDown2", "AttackRight", "AttackLeft", "AttackDown", "AttackUp") then
			--	pldata.DontGreatPheonixTick = false
			end
		end
	end
end)]]