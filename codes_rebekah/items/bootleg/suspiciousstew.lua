yandereWaifu:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_,player)
	if InutilLib.HasJustPickedCollectible(player, RebekahCurse.Items.COLLECTIBLE_SUSPICIOUSSTEW) then
		local data = yandereWaifu.GetEntityData(player)
		if data.lastActiveUsedFrameCount then
			if InutilLib.game:GetFrameCount() == data.lastActiveUsedFrameCount then
				return
			end
							
			data.lastActiveUsedFrameCount = InutilLib.game:GetFrameCount()
		else
			data.lastActiveUsedFrameCount = InutilLib.game:GetFrameCount()
		end

		--[[if flags & UseFlag.USE_NOANIM == 0 then
			player:AnimateCollectible(RebekahCurse.Items.COLLECTIBLE_SUSPICIOUSSTEW, "UseItem", "PlayerPickupSparkle")
		end]]
		for i = 1, 8 do
			InutilLib.SetTimer(60*i, function()
				local seed = RNG():SetSeed(Game():GetSeeds():GetStartSeed(), 25)
				local pill = InutilLib.itemPool:GetPillEffect(math.random(0,13))
				player:UsePill(pill, 1, UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER)
			end)
		end
		for i = 1, 9 do
			player:UseActiveItem(CollectibleType.COLLECTIBLE_WAVY_CAP, 0, -1)
		end

		player:AddHearts(36)
		
		--player:RemoveCollectible(RebekahCurse.Items.COLLECTIBLE_SUSPICIOUSSTEW)
	end
end)

--yandereWaifu:AddCallback( ModCallbacks.MC_USE_ITEM, yandereWaifu.useSuspiciousStew, RebekahCurse.Items.COLLECTIBLE_SUSPICIOUSSTEW )
