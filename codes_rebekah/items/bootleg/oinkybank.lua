function yandereWaifu:useOinkyBank(collItem, rng, player, flags, slot)
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
		player:AnimateCollectible(RebekahCurse.Items.COLLECTIBLE_OINKYBANK, "UseItem", "PlayerPickupSparkle")
		rng = rng:RandomInt(3)
		for i = 1, rng do
			Isaac.Spawn( EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, 0, player.Position, Vector.FromAngle(math.random(1,360)):Resized(math.random(4,6)), player );
		end
	end
end

yandereWaifu:AddCallback( ModCallbacks.MC_USE_ITEM, yandereWaifu.useOinkyBank, RebekahCurse.Items.COLLECTIBLE_OINKYBANK )

yandereWaifu:AddCallback("MC_POST_CLEAR_ROOM", function(_, room)
	for p = 0, InutilLib.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		if player:HasCollectible( RebekahCurse.Items.COLLECTIBLE_OINKYBANK) then
			local data = yandereWaifu.GetEntityData(player)
			local rng = player:GetCollectibleRNG( RebekahCurse.Items.COLLECTIBLE_OINKYBANK )
			rng = rng:RandomInt(2)
			if rng == 1 then
				if not data.PersistentPlayerData.OinkyBank then data.PersistentPlayerData.OinkyBank = 0 end
				data.PersistentPlayerData.OinkyBank = data.PersistentPlayerData.OinkyBank + math.random(1,2)
				SFXManager():Play(SoundEffect.SOUND_COIN_SLOT, 1, 0, false, 1.1)
			end
		end
	end
end)

yandereWaifu:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, ent, damage, dmgFlag, dmgSource, dmgCountdownFrames)
	--dmgSource = dmgSource:ToLaser()
	if ent:ToPlayer() then
		local player = ent:ToPlayer()
		if player:HasCollectible( RebekahCurse.Items.COLLECTIBLE_OINKYBANK) then
			player:RemoveCollectible( RebekahCurse.Items.COLLECTIBLE_OINKYBANK)
			local data = yandereWaifu.GetEntityData(player)
			if not data.PersistentPlayerData.OinkyBank then data.PersistentPlayerData.OinkyBank = 0 end
			for i = 1, data.PersistentPlayerData.OinkyBank do
				Isaac.Spawn( EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, 0, player.Position, Vector.FromAngle(math.random(1,360)):Resized(math.random(4,6)), player );
			end
			data.PersistentPlayerData.OinkyBank = nil
			SFXManager():Play(SoundEffect.SOUND_POT_BREAK, 1, 0, false, 0.9)
		end
	end
end)