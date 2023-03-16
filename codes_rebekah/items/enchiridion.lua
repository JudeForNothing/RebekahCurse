function yandereWaifu:useEnchiridion(collItem, rng, player, flags, slot)
	local data = yandereWaifu.GetEntityData(player)
	if data.lastActiveUsedFrameCount then
		if InutilLib.game:GetFrameCount() == data.lastActiveUsedFrameCount then
			return
		end
						
		data.lastActiveUsedFrameCount = InutilLib.game:GetFrameCount()
	else
		data.lastActiveUsedFrameCount = InutilLib.game:GetFrameCount()
	end
	for i, ent in pairs (Isaac.GetRoomEntities()) do
		if ent:IsEnemy() and ent:IsVulnerableEnemy() and not ent:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
			ent:AddEntityFlags(EntityFlag.FLAG_WEAKNESS)
			yandereWaifu.GetEntityData(ent).IsWeakenedByEnchiridion = 150
		end
	end
	player:UseCard(Card.CARD_STRENGTH, UseFlag.USE_NOANIM)
	player:AnimateCollectible(RebekahCurseItems.COLLECTIBLE_THEENCHIRIDION)
	
	player:AddNullCostume(RebekahCurseCostumes.AdventureTime)
	if not player:HasCollectible(CollectibleType.COLLECTIBLE_SPIRIT_SWORD) then
	player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_SPIRIT_SWORD, false, 1) end
	
	InutilLib.AnimateGiantbook("gfx/ui/giantbook/giantbook_the_enchiridion.png", nil, "Shake", _, true)
	--[[InutilLib.SetTimer( 30*120, function()
		player:TryRemoveNullCostume (RebekahCurseCostumes.AdventureTime)
		if not player:HasCollectible(CollectibleType.COLLECTIBLE_SPIRIT_SWORD) then
		player:GetEffects():RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_SPIRIT_SWORD, false, 1) end
	end)]]
end
yandereWaifu:AddCallback( ModCallbacks.MC_USE_ITEM, yandereWaifu.useEnchiridion, RebekahCurseItems.COLLECTIBLE_THEENCHIRIDION )

function yandereWaifu:useEnchiridionNewRoom()	
	for p = 0, InutilLib.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		local data = yandereWaifu.GetEntityData(player)
		local room = InutilLib.game:GetRoom()
		if player:HasCollectible(RebekahCurseItems.COLLECTIBLE_THEENCHIRIDION) then
			player:TryRemoveNullCostume (RebekahCurseCostumes.AdventureTime)
			if not player:HasCollectible(CollectibleType.COLLECTIBLE_SPIRIT_SWORD) then
			player:GetEffects():RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_SPIRIT_SWORD, false, 1) end
		end
	end
end
yandereWaifu:AddCallback( ModCallbacks.MC_POST_NEW_ROOM, yandereWaifu.useEnchiridionNewRoom)

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