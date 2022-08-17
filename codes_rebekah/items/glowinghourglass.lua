function yandereWaifu:useGlowHourglass(collItem, rng, player) --glowsquids suck btw
	--for p = 0, ILIB.game:GetNumPlayers() - 1 do
	--	local player = Isaac.GetPlayer(p)
		local data = yandereWaifu.GetEntityData(player)
		if yandereWaifu.IsNormalRebekah(player) then
			data.currentMode = data.lastMode
			data.heartReserveFill = data.lastHeartReserve
			data.heartStocks = data.lastStockReserve
			data.UpdateHair = true
			--player:AddCacheFlags(CacheFlag.CACHE_DAMAGE);
			yandereWaifu.ApplyCostumes( yandereWaifu.GetEntityData(player).currentMode, player );
			player:EvaluateItems()
			--player.Visible = false
			--[[yandereWaifu.ApplyCostumes( yandereWaifu.GetEntityData(player).currentMode, player );
			 InutilLib.SetTimer( 1, function()
				print("fellow")
				player.Visible = false
			end);
			 InutilLib.SetTimer( 35, function()
				print("fellow")
				player.Visible = true
				yandereWaifu.ApplyCostumes( yandereWaifu.GetEntityData(player).currentMode, player );
			end);]]
		
			--player:AddNullCostume(NerdyGlasses)
			--print("haefheaufeaf")
		end
	--end
end

yandereWaifu:AddCallback(ModCallbacks.MC_USE_ITEM, yandereWaifu.useGlowHourglass, CollectibleType.COLLECTIBLE_GLOWING_HOUR_GLASS)