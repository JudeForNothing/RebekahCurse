local sizeScale = 0.4

yandereWaifu:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, function(_,tear)
    local parent, spr, data = tear.Parent, tear:GetSprite(), yandereWaifu.GetEntityData(tear)
    local player = parent:ToPlayer()
    local playerdata = yandereWaifu.GetEntityData(player)
    if player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_SILENTTREATMENT) then
        tear.Scale = tear.Scale * sizeScale
    end
end)


yandereWaifu:AddCallback("MC_POST_FIRE_BOMB", function(_, bb)
	local player = bb.SpawnerEntity:ToPlayer()
	local pldata = yandereWaifu.GetEntityData(player)
	if player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_SILENTTREATMENT) then
		if player:HasWeaponType(WeaponType.WEAPON_BOMBS) and bb.IsFetus then
            bb.SpriteScale = bb.SpriteScale * sizeScale
            bb.RadiusMultiplier = sizeScale
            bb:SetExplosionCountdown(15)
		end
	end
end)

yandereWaifu:AddCallback("MC_POST_FIRE_LASER", function(_,lz)
	if lz.SpawnerEntity then
		local player = lz.SpawnerEntity:ToPlayer()
		if player then
			local pldata = yandereWaifu.GetEntityData(player)
			if player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_SILENTTREATMENT) then
				if lz.Variant == 2 then
					InutilLib.UpdateRepLaserSize(lz, lz.Size * sizeScale, false)
				else
					lz.SpriteScale = Vector(sizeScale, sizeScale)
				end
			end
		end
	end
end)

function yandereWaifu:silenttreatmentcache(player, cacheF) --The thing the checks and updates the game, i guess?
	local data = yandereWaifu.GetEntityData(player)
	if player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_SILENTTREATMENT) then
		--if data.SnapDelay then
		--	if cacheF == CacheFlag.CACHE_FIREDELAY then
		--		player.FireDelay = player.FireDelay - data.SnapDelay
		--	end
		--end
		if cacheF == CacheFlag.CACHE_FIREDELAY then
			player.MaxFireDelay = player.MaxFireDelay * 3
		end
		if cacheF == CacheFlag.CACHE_DAMAGE then
			player.Damage = player.Damage * 3
		end
		if cacheF == CacheFlag.CACHE_SHOTSPEED then
			player.ShotSpeed = player.ShotSpeed * 2.2
		end
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, yandereWaifu.silenttreatmentcache)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function(_)
    local num_players = Game():GetNumPlayers()
    for i=0,(num_players-1) do
        local player = Isaac.GetPlayer(i)
        if player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_SILENTTREATMENT) then
            for _, ent in pairs( Isaac.GetRoomEntities()) do
                if (ent.Position - player.Position):Length() <= 350 and ent:IsVulnerableEnemy() then
					yandereWaifu.AddSilence(ent, 60)
                    --yandereWaifu.GetEntityData(ent).IsSilenced = 60
                end
            end
        end
    end
end)