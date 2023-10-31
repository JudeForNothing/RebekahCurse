function yandereWaifu:useItemWithSeaBattery(collItem, rng, player, flags, slot)
	local data = yandereWaifu.GetEntityData(player)
	if player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_SEABATTERY) and not data.PersistentPlayerData.SeaBatteryBuff then
		player:TakeDamage(1, DamageFlag.DAMAGE_FAKE, EntityRef(player), 15)
		InutilLib.AddInnateItem(player, CollectibleType.COLLECTIBLE_120_VOLT)
		data.PersistentPlayerData.SeaBatteryBuff = true
	end
end

yandereWaifu:AddCallback( ModCallbacks.MC_USE_ITEM, yandereWaifu.useItemWithSeaBattery)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	for p = 0, InutilLib.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		local data = yandereWaifu.GetEntityData(player)
		if player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_SEABATTERY) then
			if not data.PersistentPlayerData.SeaBatteryBuff then
				InutilLib.RemoveInnateItem(player, CollectibleType.COLLECTIBLE_120_VOLT)
			end
			data.PersistentPlayerData.SeaBatteryBuff = false
		end
	end
end)
