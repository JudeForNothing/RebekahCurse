
yandereWaifu:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(_, new)
	if not new then
        local challenge = InutilLib.game.Challenge == RebekahCurse.Challenges.TheTrueFamilyGuy
        if challenge then
            InutilLib:SpawnCustomStrawman(RebekahCurse.REB_RED, Isaac.GetPlayer(0), true)
            InutilLib:SpawnCustomStrawman(19, Isaac.GetPlayer(0), true) --jacob
        end
    end
end)

--nerf cache
--[[function yandereWaifu:TFGPlayerCache(player, cacheF)
    local challenge = InutilLib.game.Challenge == RebekahCurse.Challenges.TheTrueFamilyGuy
    if challenge then
        if cacheF == CacheFlag.CACHE_DAMAGE then
            player.Damage = player.Damage / 2
        end
    end
end
yandereWaifu:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, yandereWaifu.TFGPlayerCache)]]


yandereWaifu:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, player, amount, damageFlag, damageSource, damageCountdownFrames)
    local challenge = InutilLib.game.Challenge == RebekahCurse.Challenges.TheTrueFamilyGuy
    if challenge then
        player = player:ToPlayer()
        local hearts = player:GetHearts() + player:GetSoulHearts() + player:GetGoldenHearts() + player:GetEternalHearts() + player:GetBoneHearts() + player:GetRottenHearts()
        if hearts - amount <= 0 then --kil all
            for i=0, InutilLib.game:GetNumPlayers()-1 do
                InutilLib.SetTimer( i * 30, function()
                    local others = Isaac.GetPlayer(i)
                    others:Die()
                end)
            end
        else
            for i=0, InutilLib.game:GetNumPlayers()-1 do
                local others = Isaac.GetPlayer(i)
                others:ResetDamageCooldown()
            end
        end
    end
end, EntityType.ENTITY_PLAYER)

function yandereWaifu.familycollision(_, player)
    local challenge = InutilLib.game.Challenge == RebekahCurse.Challenges.TheTrueFamilyGuy
    if challenge then
        for i=0, InutilLib.game:GetNumPlayers()-1 do
            local collider = Isaac.GetPlayer(i)
            if collider.Type == EntityType.ENTITY_PLAYER then
                if player.Position:Distance(collider.Position) < 15 then
                    local vec = player.Position-collider.Position
                    player.Velocity = player.Velocity + vec:Resized(0.3)
                end
            end
        end
    end
end

yandereWaifu:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, yandereWaifu.familycollision)
