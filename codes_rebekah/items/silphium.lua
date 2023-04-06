--code taken from coming HOME WOW, THANKS KAKAODCAT YOU LOSER

do
function yandereWaifu:AddPostInit(player) --Starting Data for Silphium
    local data = yandereWaifu.GetEntityData(player)
	data.difference = 0
	data.totalarm = 0
end
yandereWaifu:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, yandereWaifu.AddPostInit)

function yandereWaifu:HeartUpdate(player) -- check for health change, act accordingly
    local data = yandereWaifu.GetEntityData(player)
	data.currentarm = player:GetHearts() -- currenthealth is how much Isaac has currently
--	lasthealth = currenthealth
--	print(tostring(currentarm .. "CA"))
	if player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_SILPHIUM) then --then if Isaac has Tungsten
		if 0 ~= data.currentarm then --and if Lasthealth is NOT like currenthealth
			player:AddCacheFlags(CacheFlag.CACHE_FAMILIARS) --then give dmg
			player:EvaluateItems()
		end
	end
	if player:GetName() == "Magdalene" then -- Especially here!
		data.totalarm = ((data.currentarm - 0)/2)
	else
		data.totalarm = ((data.currentarm - 0)/3)
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, yandereWaifu.HeartUpdate)

function yandereWaifu.GetSilphiumHeartCount(player)
    local data = yandereWaifu.GetEntityData(player)
    data.difference = 0
    for i=#Isaac.GetRoomEntities(), 1, -1 do
        local H = Isaac.GetRoomEntities()[i]
        if H.Type == 3 and H.Variant == RebekahCurse.ENTITY_CARDIAC and H.SubType == 0 and GetPtrHash(yandereWaifu.GetEntityData(H).Parent) == GetPtrHash(player) then
            data.difference = data.difference + 1
        end
    end
    return (data.totalarm - data.difference) + 1
end

function yandereWaifu.SpawnSilphiumHeart(player, subtype)
    local heart = Isaac.Spawn(EntityType.ENTITY_FAMILIAR,RebekahCurse.ENTITY_CARDIAC, subtype or 0, player.Position, Vector(0, 0), player)
    yandereWaifu.GetEntityData(heart).Parent = player
    print(yandereWaifu.GetSilphiumHeartCount(player))
    if subtype == 1 then
        yandereWaifu.GetEntityData(heart).IsInner = true
    elseif yandereWaifu.GetSilphiumHeartCount(player) > 6 then
        yandereWaifu.GetEntityData(heart).IsOuter = true
    end
    return heart
end

function yandereWaifu:SpawnSilphiumHearts() --Maggy WIP
	for i=0, InutilLib.game:GetNumPlayers()-1 do
        local player = Isaac.GetPlayer(i)
        local data = yandereWaifu.GetEntityData(player)
		--if flag == CacheFlag.CACHE_FAMILIARS then
		if player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_SILPHIUM) then --then if Isaac has Tungsten
			local count = yandereWaifu.GetSilphiumHeartCount(player)
			for i = 1, count do
				local heart = yandereWaifu.SpawnSilphiumHeart(player)
                --[[if i > 6 then
                    yandereWaifu.GetEntityData(heart).IsOuter = true
                end]]
            end
        end
	end
end

yandereWaifu:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, yandereWaifu.SpawnSilphiumHearts)


function yandereWaifu:HeartUpdate(heart)
    local data = yandereWaifu.GetEntityData(heart)
    local player = yandereWaifu.GetEntityData(heart).Parent
    if not data.Init then
        if data.IsOuter then
            heart:AddToOrbit(3001)
        elseif data.IsInner then
            heart:AddToOrbit(3002)
        else
            heart:AddToOrbit(3000)
        end
        data.Init= true
    end
    if data.IsOuter then
        heart.OrbitDistance = Vector(75, 45)
    elseif data.IsInner then
        heart.OrbitDistance = Vector(40, 15)
    else
	    heart.OrbitDistance = Vector(55, 30)
    end
	heart.OrbitSpeed = 0.0008
	heart.OrbitAngleOffset = heart.OrbitAngleOffset+0.02
	heart.Velocity = heart:GetOrbitPosition(player.Position+player.Velocity) - heart.Position
	
	--[[for i=#Isaac.GetRoomEntities(), 1, -1 do
		local bad = Isaac.GetRoomEntities()[i]
		if bad.Type == 9 then
			bad:ToProjectile()
			if bad.Position:Distance(heart.Position) < bad.Size+heart.Size+2 then
			bad:Remove()
			heart:Remove()
			heart:RemoveFromOrbit()
			heart.OrbitSpeed = 0.12
			SFXManager():Play(SoundEffect.SOUND_POT_BREAK, 1, 0, false, 0.9)
			end
		end
	end]]
end

yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, yandereWaifu.HeartUpdate, RebekahCurse.ENTITY_CARDIAC)

function yandereWaifu.silheartColl(_, fam, collider, low)
	local data = yandereWaifu.GetEntityData(fam.Player:ToPlayer())
	local function Die()
		fam:Remove()
		fam:RemoveFromOrbit()
		--fam.OrbitSpeed = 0.12
		SFXManager():Play(SoundEffect.SOUND_POT_BREAK, 1, 0, false, 0.9)
	end
	local data = yandereWaifu.GetEntityData(fam)
	if collider.Type == EntityType.ENTITY_PROJECTILE then -- stop enemy bullets
		collider:Die()
		Die()
	elseif collider:IsVulnerableEnemy() and not collider:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
		collider:TakeDamage(1, 0, EntityRef(fam), 1)
		Die()
	end
end

yandereWaifu:AddCallback(ModCallbacks.MC_PRE_FAMILIAR_COLLISION, yandereWaifu.silheartColl, RebekahCurse.ENTITY_CARDIAC)


end

