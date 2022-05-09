yandereWaifu:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, damage, amount, damageFlag, damageSource, damageCountdownFrames) 
	if damage:ToPlayer() then
		local player = damage:ToPlayer()
		local data = yandereWaifu.GetEntityData(player)

		if (damageFlag & DamageFlag.DAMAGE_CURSED_DOOR) == 0 and not data.PersistentPlayerData.IsHurt and player:HasTrinket(RebekahCurse.TRINKET_ORIGINALSIN) and (player:GetSoulHearts() == 0 and player:GetBoneHearts() == 0) then
			data.PersistentPlayerData.IsHurt = true
			player:TakeDamage(1, DamageFlag.DAMAGE_RED_HEARTS, EntityRef(player), 1)
			player:TryRemoveNullCostume(RebekahCurseCostumes.OriginalSin)
			local eff = Isaac.Spawn(EntityType.ENTITY_EFFECT, 16, 11, player.Position, Vector.Zero, player):ToEffect()
			eff:GetSprite():ReplaceSpritesheet(0,'gfx/effects/items/originalsin_mantle_break.png')
			eff:GetSprite():LoadGraphics()
			InutilLib.SFX:Play( RebekahCurseSounds.SOUND_ORIGINALSIN_SHATTER, 1, 0, false, 1 );
			ILIB.game:ShakeScreen(5)
			return false
		end
	end
	
end, 1)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_,player)
	--local player = Isaac.GetPlayer(0);
    local room = Game():GetRoom();
	local data = yandereWaifu.GetEntityData(player)
	--items function!
	--if player:HasCollectible(RebekahCurse.COLLECTIBLE_POTATOSNACK) then
		if player:HasTrinket(RebekahCurse.TRINKET_ORIGINALSIN) and data.PersistentPlayerData.IsHurt == nil then
			player:AddNullCostume(RebekahCurseCostumes.OriginalSin)
			data.PersistentPlayerData.IsHurt = false
		end
	--end
end)

function yandereWaifu:OriginalSinNewFloor()
	for p = 0, ILIB.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		local data = yandereWaifu.GetEntityData(player)
		local room = ILIB.game:GetRoom()
		if data.PersistentPlayerData.IsHurt then
			data.PersistentPlayerData.IsHurt = false
			player:AddNullCostume(RebekahCurseCostumes.OriginalSin)
		end
	end
end
yandereWaifu:AddCallback( ModCallbacks.MC_POST_NEW_LEVEL, yandereWaifu.OriginalSinNewFloor)