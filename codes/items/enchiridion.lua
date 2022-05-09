function yandereWaifu:useEnchiridion(collItem, rng, player, flags, slot)
	local data = yandereWaifu.GetEntityData(player)
	if data.lastActiveUsedFrameCount then
		if ILIB.game:GetFrameCount() == data.lastActiveUsedFrameCount then
			return
		end
						
		data.lastActiveUsedFrameCount = ILIB.game:GetFrameCount()
	else
		data.lastActiveUsedFrameCount = ILIB.game:GetFrameCount()
	end
	for i, ent in pairs (Isaac.GetRoomEntities()) do
		if ent:IsEnemy() and ent:IsVulnerableEnemy() and not ent:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
			ent:AddEntityFlags(EntityFlag.FLAG_WEAKNESS)
			yandereWaifu.GetEntityData(ent).IsWeakenedByEnchiridion = 150
		end
	end
	player:UseCard(Card.CARD_STRENGTH, UseFlag.USE_NOANIM)
end
yandereWaifu:AddCallback( ModCallbacks.MC_USE_ITEM, yandereWaifu.useEnchiridion, RebekahCurse.COLLECTIBLE_THEENCHIRIDION )

yandereWaifu:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
	local data = yandereWaifu.GetEntityData(npc)
    if data.IsWeakenedByEnchiridion then
        data.IsWeakenedByEnchiridion = data.IsWeakenedByEnchiridion - 1
		if data.IsWeakenedByEnchiridion <= 0 then
			npc:ClearEntityFlags(EntityFlag.FLAG_WEAKNESS)
			data.IsWeakenedByEnchiridion = nil
		end
    end
end)