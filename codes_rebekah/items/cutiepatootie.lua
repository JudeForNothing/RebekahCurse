
yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_,  fam) 
    local spr = fam:GetSprite()
	local data = yandereWaifu.GetEntityData(fam)
	local player = fam.Player
	player:ToPlayer()
	local playerdata = yandereWaifu.GetEntityData(player)
	
	--bffs! synergy
	local extraDmg = 1
	local extraFireDelay = false
	if player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
		extraDmg = 2
	end
	if player:HasTrinket(TrinketType.TRINKET_FORGOTTEN_LULLABY) then
		extraFireDelay = true
	end
	
	fam.OrbitDistance = Vector(55, 30)

	fam.OrbitSpeed = 0.03
	fam.OrbitAngleOffset = fam.OrbitAngleOffset+0.02
	fam.Velocity = fam:GetOrbitPosition(player.Position+player.Velocity) - fam.Position

end, RebekahCurse.ENTITY_CUTIEPATOOTIE);


function yandereWaifu:BestGirlSabbbbInit(fam)
    local sprite = fam:GetSprite()
    sprite:Play("Init", true)
	--fam.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
	fam:AddToOrbit(7000)
	
	local data = yandereWaifu.GetEntityData(fam)
end
yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, yandereWaifu.BestGirlSabbbbInit, RebekahCurse.ENTITY_CUTIEPATOOTIE);

function yandereWaifu:BestGirlSabbbbCache(player, cacheF) --The thing the checks and updates the game, i guess?
	local data = yandereWaifu.GetEntityData(player)
	if cacheF == CacheFlag.CACHE_FAMILIARS then  -- Especially here!
		if player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_CUTIEPATOOTIE) then
			player:CheckFamiliar(RebekahCurse.ENTITY_CUTIEPATOOTIE, player:GetCollectibleNum(RebekahCurse.Items.COLLECTIBLE_CUTIEPATOOTIE) + player:GetEffects():GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_BOX_OF_FRIENDS), RNG(), InutilLib.config:GetCollectible(RebekahCurse.Items.COLLECTIBLE_CUTIEPATOOTIE))
		end
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, yandereWaifu.BestGirlSabbbbCache)

function yandereWaifu.BestGirlSabbbbColl(_, fam, collider, low)
	local data = yandereWaifu.GetEntityData(fam.Player:ToPlayer())
	if collider:IsVulnerableEnemy() and not collider:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
		yandereWaifu.GetEntityData(collider).IsPatootied = true
		yandereWaifu.GetEntityData(collider).Patootie = fam
	end
end

yandereWaifu:AddCallback(ModCallbacks.MC_PRE_FAMILIAR_COLLISION, yandereWaifu.BestGirlSabbbbColl, RebekahCurse.ENTITY_CUTIEPATOOTIE)

yandereWaifu:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, ent, amount, damageFlag, damageSource, damageCountdownFrames)
    ent = ent:ToNPC()
	local data = yandereWaifu.GetEntityData(ent)
	if ent and ent:IsVulnerableEnemy() then
		if data.IsPatootied and ent:IsEnemy() then
			local src = InutilLib.GetPlayerFromDmgSrc(damageSource)
			if src then
				data.LastHurtPlayer = src
			end
		end
	end
end)

local customColor = Color(1, 0, 1, 1, 0, 0, 0)
yandereWaifu:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, ent)
	local data = yandereWaifu.GetEntityData(ent)
	
	--blessed effect
	if data.IsPatootied then
		ent:SetColor(customColor, 2, 5, true, true)
	end
	if data.IsPatootied then
		if ent:IsDead() then -- on death
			for i, entenmies in pairs(Isaac.GetRoomEntities()) do --affect others
				if entenmies:IsEnemy() and entenmies:IsVulnerableEnemy() then
					if yandereWaifu.GetEntityData(entenmies).IsPatootied then
						entenmies:TakeDamage(data.LastHurtPlayer.Damage, 0, EntityRef(ent), 1)
					end
				end
			end
		end
	end
end)
yandereWaifu:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, function(_, ent)
    local data = yandereWaifu.GetEntityData(ent)
    if data.IsPatootied then

		if not data.Init then                                             
			data.spr = Sprite()                      
			data.spr:Load("gfx/effects/items/br_string.anm2", true)
			data.Init = true                     
		end
		if data.Patootie then
			data.spr:SetFrame("Chain", 0)--math.floor(tr.FrameCount % 4))
			InutilLib.DeadDrawRotatedTilingSprite(data.spr, Isaac.WorldToScreen(data.Patootie.Position+Vector(0,-15)), Isaac.WorldToScreen(ent.Position+Vector(0,-15)), 30, nil, 8, true)
		end
    end
end)

