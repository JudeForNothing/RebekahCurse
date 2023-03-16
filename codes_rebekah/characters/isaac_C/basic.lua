function yandereWaifu:IsaacCregisterCache(player, cacheF) --The thing the checks and updates the game, i guess?
	local data = yandereWaifu.GetEntityData(player)
	if player:GetPlayerType() == RebekahCurse.WISHFUL_ISAAC then -- Especially here!
		--if data.UpdateHair then
		--	print("tuck")
		if InutilLib.room:GetFrameCount() < 1 then
			yandereWaifu.ApplyCostumes( _, player , true, false)
		end
		--	data.UpdateHair = false
		--end
		
		--[[if cacheF == CacheFlag.CACHE_DAMAGE then
			player.Damage = player.Damage -- 0.73 --1.73
		end]]
		if cacheF == CacheFlag.CACHE_LUCK then
			player.Luck = player.Luck + 10
		end
		--[[if cacheF == CacheFlag.CACHE_FIREDELAY then	
			local FireDelayDiff = player.MaxFireDelay - 10
			if FireDelayDiff < 0 then
				player.MaxFireDelay = player.MaxFireDelay + FireDelayDiff
				player.Damage = player.Damage * FireDelayDiff/10
			elseif FireDelayDiff > 0 then
				player.MaxFireDelay = player.MaxFireDelay - FireDelayDiff
				player.Damage = player.Damage / FireDelayDiff
			end
		end]]
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, yandereWaifu.IsaacCregisterCache)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, function(_,player)
	if player:GetPlayerType() == RebekahCurse.WISHFUL_ISAAC then
		--if player.FrameCount <= 1 then --trying to make it visually pleasing when she spawns in
		--	player.Visible = false
		--end
		yandereWaifu.ApplyCostumes( _, player, true, false);
	end
end)