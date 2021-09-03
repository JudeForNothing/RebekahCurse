yandereWaifu:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, function(_,tear)
		local parent, spr, data = tear.Parent, tear:GetSprite(), yandereWaifu.GetEntityData(tear)
		local player = parent:ToPlayer()
		
		if player:GetPlayerType() == RebekahCurse.REB and yandereWaifu.GetEntityData(player).currentMode == REBECCA_MODE.BrokenHearts then
			if yandereWaifu.GetEntityData(player).BrokenBuff then
				yandereWaifu.GetEntityData(player).BrokenBuff = false
				player:AddCacheFlags(CacheFlag.CACHE_DAMAGE);
				player:EvaluateItems()
			end
		end
end)