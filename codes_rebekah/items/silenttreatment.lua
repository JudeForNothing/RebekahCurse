yandereWaifu:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, function(_,tear)
    local parent, spr, data = tear.Parent, tear:GetSprite(), yandereWaifu.GetEntityData(tear)
    local player = parent:ToPlayer()
    local playerdata = yandereWaifu.GetEntityData(player)
    if player:HasCollectible(RebekahCurseItems.COLLECTIBLE_SILENTTREATMENT) then
        tear.Scale = tear.Scale * 0.6
    end
end)


yandereWaifu:AddCallback("MC_POST_FIRE_BOMB", function(_, bb)
	local player = bb.SpawnerEntity:ToPlayer()
	local pldata = yandereWaifu.GetEntityData(player)
	if player:HasCollectible(RebekahCurseItems.COLLECTIBLE_SILENTTREATMENT) then
		if player:HasWeaponType(WeaponType.WEAPON_BOMBS) and bb.IsFetus then
            bb.SpriteScale = bb.SpriteScale * 0.6
            bb.RadiusMultiplier = 0.6
            bb:SetExplosionCountdown(15)
		end
	end
end)

yandereWaifu:AddCallback("MC_POST_FIRE_LASER", function(_,lz)
	if lz.SpawnerEntity then
		local player = lz.SpawnerEntity:ToPlayer()
		if player then
			local pldata = yandereWaifu.GetEntityData(player)
			if player:HasCollectible(RebekahCurseItems.COLLECTIBLE_SILENTTREATMENT) then
				if lz.Variant == 2 then
					print("goo")
					InutilLib.UpdateRepLaserSize(lz, lz.Size * 0.5, false)
				else
					lz.SpriteScale = Vector(0.5, 0.5)
				end
			end
		end
	end
end)

function yandereWaifu:silenttreatmentcache(player, cacheF) --The thing the checks and updates the game, i guess?
	local data = yandereWaifu.GetEntityData(player)
	if player:HasCollectible(RebekahCurseItems.COLLECTIBLE_SILENTTREATMENT) then
		--if data.SnapDelay then
		--	if cacheF == CacheFlag.CACHE_FIREDELAY then
		--		player.FireDelay = player.FireDelay - data.SnapDelay
		--	end
		--end
		if cacheF == CacheFlag.CACHE_FIREDELAY then
			player.MaxFireDelay = player.MaxFireDelay * 2
		end
		if cacheF == CacheFlag.CACHE_DAMAGE then
			player.Damage = player.Damage * 3
		end
		if cacheF == CacheFlag.CACHE_SHOTSPEED then
			player.ShotSpeed = player.ShotSpeed * 1.5
		end
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, yandereWaifu.silenttreatmentcache)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function(_)
    local num_players = Game():GetNumPlayers()
    for i=0,(num_players-1) do
        local player = Isaac.GetPlayer(i)
        if player:HasCollectible(RebekahCurseItems.COLLECTIBLE_SILENTTREATMENT) then
            for _, ent in pairs( Isaac.GetRoomEntities()) do
                if (ent.Position - player.Position):Length() <= 350 and ent:IsVulnerableEnemy() then
                    yandereWaifu.GetEntityData(ent).IsSilenced = 60
                end
            end
        end
    end
end)