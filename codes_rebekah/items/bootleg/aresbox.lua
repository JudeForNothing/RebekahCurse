function yandereWaifu:useAresBox(collItem, rng, player, flags, slot)
	local data = yandereWaifu.GetEntityData(player)
	if data.lastActiveUsedFrameCount then
		if InutilLib.game:GetFrameCount() == data.lastActiveUsedFrameCount then
			return
		end
						
		data.lastActiveUsedFrameCount = InutilLib.game:GetFrameCount()
	else
		data.lastActiveUsedFrameCount = InutilLib.game:GetFrameCount()
	end

	if flags & UseFlag.USE_NOANIM == 0 then
		player:AnimateCollectible(RebekahCurse.Items.COLLECTIBLE_ARESBOX, "UseItem", "PlayerPickupSparkle")
	end

	local ents = Isaac.FindInRadius(player.Position, 7500, EntityPartition.ENEMY)
    for _, ent in pairs(ents) do
        if ent:IsVulnerableEnemy() and not ent:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
			local rng = rng:RandomInt(10000)
			ent:ToNPC():MakeChampion(rng, -1, false)
			Isaac.Spawn(1000,144,1,ent.Position,Vector.Zero,ent)
        	SFXManager():Play(SoundEffect.SOUND_DEMON_HIT)
        end
    end
end

yandereWaifu:AddCallback( ModCallbacks.MC_USE_ITEM, yandereWaifu.useAresBox, RebekahCurse.Items.COLLECTIBLE_ARESBOX )
