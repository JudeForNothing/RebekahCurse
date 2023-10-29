
yandereWaifu:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(_, new)
	if not new then
        local challenge = InutilLib.game.Challenge == RebekahCurse.Challenges.OldMaid
        if challenge then
            local player = Isaac.GetPlayer(0)
            player:ChangePlayerType(RebekahCurse.DEBORAH)
            yandereWaifu.DeborahInit(player)
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
