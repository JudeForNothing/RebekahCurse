yandereWaifu:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
	for p = 0, InutilLib.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		local data = yandereWaifu.GetEntityData(player)
		if player:HasTrinket(RebekahCurseTrinkets.TRINKET_JOHNANDROMANS) then
			if not data.PersistentPlayerData.LostJohnRomansBuff then
				InutilLib.RemoveInnateItem(player, CollectibleType.COLLECTIBLE_SALVATION)
			end
			InutilLib.AddInnateItem(player, CollectibleType.COLLECTIBLE_SALVATION)
			data.PersistentPlayerData.LostJohnRomansBuff = false
		end
	end
end)


yandereWaifu:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, damage, amount, damageFlag, damageSource, damageCountdownFrames) --invincibilityframe when dashing or whatnot
	local player = damage:ToPlayer();
	local data = yandereWaifu.GetEntityData(player)

	if player:HasTrinket(RebekahCurseTrinkets.TRINKET_JOHNANDROMANS) and (damageFlag & DamageFlag.DAMAGE_CURSED_DOOR) == 0 and (not data.PsoriasisHealth or data.PsoriasisHealth <= 0) then
		if not data.PersistentPlayerData.LostJohnRomansBuff then
			InutilLib.RemoveInnateItem(player, CollectibleType.COLLECTIBLE_SALVATION)
			data.PersistentPlayerData.LostJohnRomansBuff = true
			local babies = 0
			for _, ent in ipairs(Isaac.FindByType(38, 1, 1)) do
				if ent:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) and GetPtrHash(ent.SpawnerEntity) == GetPtrHash(player) then
					babies = babies + 1
				end
			end

			if babies <= 4 then
				for i = 0, math.random(1,2) do
					local minion = Isaac.Spawn(38, 1, 1, player.Position, Vector.Zero, player):ToNPC()
					minion:AddCharmed(EntityRef(player), -1)
				end
			end
		end
	end
end, EntityType.ENTITY_PLAYER)