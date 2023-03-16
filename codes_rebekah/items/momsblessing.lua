local chance = 1/4

yandereWaifu:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, pickup)
	local rng = pickup:GetDropRNG()
	for p = 0, InutilLib.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		local entityData = yandereWaifu.GetEntityData(player);
		local validPickup = (pickup.Variant == PickupVariant.PICKUP_CHEST)
		if (player:HasTrinket(RebekahCurseTrinkets.TRINKET_MOMSBLESSING)) then
			if rng:RandomFloat() <= (chance) and validPickup and InutilLib.room:GetType() ~= RoomType.ROOM_BOSS and RebekahCurseGlobalData.MOMS_BLESSING_NO_MORPH_FRAME == 0 and (pickup:GetSprite():IsPlaying("Appear") or pickup:GetSprite():IsPlaying("AppearFast")) and pickup:GetSprite():GetFrame() == 1 and not pickup.SpawnerEntity then
				if pickup.Variant == PickupVariant.PICKUP_CHEST then
					local newpickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_MOMSCHEST, 0, pickup.Position, Vector(0,0), player):ToPickup()
					if pickup:IsShopItem() then
						newpickup.Price = 5
					end
					newpickup.ShopItemId = -1
					newpickup.OptionsPickupIndex = pickup.OptionsPickupIndex
				end
				pickup:Remove()
			end
		end
	end
end)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
	if RebekahCurseGlobalData.MOMS_BLESSING_NO_MORPH_FRAME > 0 and InutilLib.game:GetFrameCount() > RebekahCurseGlobalData.MOMS_BLESSING_NO_MORPH_FRAME + 1 then --set frame back to zero
		RebekahCurseGlobalData.MOMS_BLESSING_NO_MORPH_FRAME = 0
	end
end)

function yandereWaifu:useDuplicateOnMomsBlessing(collItem, rng, player)
	RebekahCurseGlobalData.MOMS_BLESSING_NO_MORPH_FRAME = game:GetFrameCount()
end
yandereWaifu:AddCallback(ModCallbacks.MC_USE_ITEM, yandereWaifu.useDuplicateOnMomsBlessing, CollectibleType.COLLECTIBLE_CROOKED_PENNY)
yandereWaifu:AddCallback(ModCallbacks.MC_USE_ITEM, yandereWaifu.useDuplicateOnMomsBlessing, CollectibleType.COLLECTIBLE_DIPLOPIA)
