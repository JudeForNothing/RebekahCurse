
--Miraculous Womb Fams--

function yandereWaifu:EsauInit(fam)
    local sprite = fam:GetSprite()
    sprite:Play("FloatDown", true)
	fam.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
	fam:AddToOrbit(4)
	
	local data = yandereWaifu.GetEntityData(fam)
	data.Stat = {
		FireDelay = 25,
		MaxFireDelay = 25,
		Damage = 4.2, 
		PlayerMaxDelay = 0
	}
end
yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, yandereWaifu.EsauInit, RebekahCurse.ENTITY_ORBITALESAU);

yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_,  fam) 
    local spr = fam:GetSprite()
	local data = yandereWaifu.GetEntityData(fam)
	local player = fam.Player
	player:ToPlayer()
	
	fam.OrbitDistance = Vector(20, 20)
	fam.OrbitAngleOffset = fam.OrbitAngleOffset+0.06
	fam.Velocity = ((fam:GetOrbitPosition(player.Position+player.Velocity) - fam.Position)) * 0.9 --(fam.Velocity + (fam:GetOrbitPosition(player.Position+player.Velocity) - fam.Position)) * 0.9
	
	if data.Stat.FireDelay > 0 then data.Stat.FireDelay = data.Stat.FireDelay - 1 end
	
	local playerDir = player:GetFireDirection()
	if playerDir > -1 then
		InutilLib.AnimShootFrame(fam, true, InutilLib.DirToVec(playerDir), "FloatShootSide", "FloatShootDown", "FloatShootUp")
		--if firedelay is ready then
		if data.Stat.FireDelay <= 0 then
			local tears = player:FireTear(fam.Position, InutilLib.DirToVec(playerDir), false, false, false):ToTear()
			tears.Position = fam.Position
			tears.CollisionDamage = data.Stat.Damage * player.Damage
			data.Stat.FireDelay = data.Stat.MaxFireDelay
		end
		
		if data.Stat.PlayerMaxDelay ~= player.MaxFireDelay then --balance purposes. They are so broken if I don't do this
			data.Stat.MaxFireDelay = 25 + player.MaxFireDelay/2
			data.Stat.PlayerMaxDelay = player.MaxFireDelay
		end
	else
		spr:Play("FloatDown", true)
	end
	
end, RebekahCurse.ENTITY_ORBITALESAU);

function yandereWaifu:JacobInit(fam)
    local sprite = fam:GetSprite()
    sprite:Play("FloatDown", true)
	fam.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
	fam:AddToOrbit(4)
	
	local data = yandereWaifu.GetEntityData(fam)
	data.Stat = {
		FireDelay = 6,
		MaxFireDelay = 6,
		Damage = 2, 
		PlayerMaxDelay = 0
	}
end
yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, yandereWaifu.JacobInit, RebekahCurse.ENTITY_ORBITALJACOB);

yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_,  fam) 
    local spr = fam:GetSprite()
	local data = yandereWaifu.GetEntityData(fam)
	local player = fam.Player
	player:ToPlayer()
	
	fam.OrbitDistance = Vector(20, 20)
	fam.OrbitAngleOffset = fam.OrbitAngleOffset+0.06
	fam.Velocity = ((fam:GetOrbitPosition(player.Position+player.Velocity) - fam.Position)) * 0.9
	
	if data.Stat.FireDelay > 0 then data.Stat.FireDelay = data.Stat.FireDelay - 1 end
	
	local playerDir = player:GetFireDirection()
	if playerDir > -1 then
		InutilLib.AnimShootFrame(fam, true, InutilLib.DirToVec(playerDir), "FloatShootSide", "FloatShootDown", "FloatShootUp")
		--if firedelay is ready then
		if data.Stat.FireDelay <= 0 then
			local tears = player:FireTear(fam.Position, InutilLib.DirToVec(playerDir), false, false, false):ToTear()
			tears.Position = fam.Position
			tears.CollisionDamage = player.Damage - data.Stat.Damage
			data.Stat.FireDelay = data.Stat.MaxFireDelay
		end
		if data.Stat.PlayerMaxDelay ~= player.MaxFireDelay then --balance purposes. They are so broken if I don't do this
			data.Stat.MaxFireDelay = 6 + player.MaxFireDelay/4
			data.Stat.PlayerMaxDelay = player.MaxFireDelay
		end
	else
		spr:Play("FloatDown", true)
	end
	
end, RebekahCurse.ENTITY_ORBITALJACOB);

function yandereWaifu:miraculousWombCacheregister(player, cacheF) --The thing the checks and updates the game, i guess?
	local data = yandereWaifu.GetEntityData(player)
	if cacheF == CacheFlag.CACHE_FAMILIARS then
		--Miraculous Womb
		player:CheckFamiliar(RebekahCurse.ENTITY_ORBITALESAU, player:GetCollectibleNum(RebekahCurse.COLLECTIBLE_MIRACULOUSWOMB), player:GetCollectibleRNG(RebekahCurse.COLLECTIBLE_MIRACULOUSWOMB))
		player:CheckFamiliar(RebekahCurse.ENTITY_ORBITALJACOB, player:GetCollectibleNum(RebekahCurse.COLLECTIBLE_MIRACULOUSWOMB), player:GetCollectibleRNG(RebekahCurse.COLLECTIBLE_MIRACULOUSWOMB))
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, yandereWaifu.miraculousWombCacheregister)