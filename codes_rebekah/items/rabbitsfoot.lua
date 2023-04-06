local chance = 1/4
local isEaster = false --just setting this up because easter is still out

yandereWaifu:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, pickup)
	local chance = 1/8
	local rng = pickup:GetDropRNG()
	for p = 0, InutilLib.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		local entityData = yandereWaifu.GetEntityData(player);
		local validPickup = (pickup.Variant == PickupVariant.PICKUP_CHEST or pickup.Variant == PickupVariant.PICKUP_TAROTCARD)
		if (player:HasTrinket(RebekahCurse.Trinkets.TRINKET_RABBITSFOOT) or isEaster) then
			if isEaster and player:HasTrinket(RebekahCurse.Trinkets.TRINKET_RABBITSFOOT) then chance = 1/2 end
			--pickup.Wait = 10;
			if rng:RandomFloat() <= (chance) and validPickup and InutilLib.room:GetType() ~= RoomType.ROOM_BOSS and RebekahCurseGlobalData.EASTER_EGG_NO_MORPH_FRAME == 0 
		and (pickup:GetSprite():IsPlaying("Appear") or pickup:GetSprite():IsPlaying("AppearFast")) and pickup:GetSprite():GetFrame() == 1 and not pickup.SpawnerEntity then
				local newpickup = yandereWaifu.SpawnEasterEgg(pickup.Position, player, 1, pickup:IsShopItem())
				--local newpickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, RebekahCurse.Cards.CARD_EASTEREGG, pickup.Position, Vector(0,0), player):ToPickup()
				newpickup.OptionsPickupIndex = pickup.OptionsPickupIndex
				if pickup.Variant == PickupVariant.PICKUP_CHEST then
					for i = 0, math.random(0,1) do
						local newpickup = yandereWaifu.SpawnEasterEgg(pickup.Position, player, 1, pickup:IsShopItem())
						newpickup.OptionsPickupIndex = pickup.OptionsPickupIndex
					end
				end
				pickup:Remove()
			end
		end
	end
end)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
	if RebekahCurseGlobalData.EASTER_EGG_NO_MORPH_FRAME > 0 and game:GetFrameCount() > RebekahCurseGlobalData.EASTER_EGG_NO_MORPH_FRAME + 1 then --set frame back to zero
		RebekahCurseGlobalData.EASTER_EGG_NO_MORPH_FRAME = 0
	end
end)