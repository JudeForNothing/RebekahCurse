function yandereWaifu:useVitaminC(collItem, rng, player, flags, slot)
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
		player:AnimateCollectible(RebekahCurse.Items.COLLECTIBLE_VITAMINC, "UseItem", "PlayerPickupSparkle")
	end
	data.PersistentPlayerData.IsVitaminC = 1600
	player:AddCacheFlags(CacheFlag.CACHE_ALL);
	player:EvaluateItems()
	player:RemoveCollectible(RebekahCurse.Items.COLLECTIBLE_VITAMINC)
	InutilLib.SFX:Play( SoundEffect.SOUND_THUMBSUP_AMPLIFIED, 0.7, 0, false, 0.5 );
end

yandereWaifu:AddCallback( ModCallbacks.MC_USE_ITEM, yandereWaifu.useVitaminC, RebekahCurse.Items.COLLECTIBLE_VITAMINC )

yandereWaifu:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function(_,player)
	local data = yandereWaifu.GetEntityData(player)
	local function heal()
		if player:GetMaxHearts() > 0 then
			player:AddHearts(1)
		else
			if player:GetSoulHearts() < 6 then
				player:AddSoulHearts(1)
			end
		end
		local charge = Isaac.Spawn( EntityType.ENTITY_EFFECT, EffectVariant.HEART, 0, player.Position, Vector(0,0), player );
		charge.SpriteOffset = Vector(0,-40)
		InutilLib.SFX:Play( SoundEffect.SOUND_VAMP_GULP , 1.3, 0, false, 1.2 );
	end
	if data.PersistentPlayerData.IsVitaminC then
		data.PersistentPlayerData.IsVitaminC = data.PersistentPlayerData.IsVitaminC - 1
		if data.PersistentPlayerData.IsVitaminC % 15 == 0 then
			data.VitaminCColor = Color(math.random(1,3)/10,math.random(1,3)/10,math.random(1,3)/10,1)
		end
		if not data.VitaminCColor then
			data.VitaminCColor = Color(math.random(0,1)/10,1,1,1,0,0,0)
		end
		player:SetColor(data.VitaminCColor, 2, 1, false, true)
		if data.PersistentPlayerData.IsVitaminC % 200 == 0 then
			heal()
		end
		if data.PersistentPlayerData.IsVitaminC <= 0 then
			data.PersistentPlayerData.IsVitaminC = nil
			player:AddCacheFlags(CacheFlag.CACHE_ALL);
			player:EvaluateItems()
		end
    end
end)

function yandereWaifu:TFGPlayerCache(player, cacheF)
	local data = yandereWaifu.GetEntityData(player)
    if data.PersistentPlayerData.IsVitaminC then
        if cacheF == CacheFlag.CACHE_DAMAGE then
            player.Damage = player.Damage * 2
        end
		if cacheF == CacheFlag.CACHE_FIREDELAY then
			player.MaxFireDelay = player.MaxFireDelay - 3
		end
    end
end
yandereWaifu:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, yandereWaifu.TFGPlayerCache)