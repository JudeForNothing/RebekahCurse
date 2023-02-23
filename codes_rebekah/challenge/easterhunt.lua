yandereWaifu:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, pickup)
	local chance = 1/2
	local rng = pickup:GetDropRNG()
	local challenge = ILIB.game.Challenge == RebekahCurseChallenges.EasterHunt
    if challenge then
		local validPickup = (pickup.Variant == PickupVariant.PICKUP_CHEST or pickup.Variant == PickupVariant.PICKUP_TAROTCARD)
			--pickup.Wait = 10;
		if rng:RandomFloat() <= (chance) and validPickup and ILIB.room:GetType() ~= RoomType.ROOM_BOSS and RebekahCurseGlobalData.EASTER_EGG_NO_MORPH_FRAME == 0 
		and (pickup:GetSprite():IsPlaying("Appear") or pickup:GetSprite():IsPlaying("AppearFast")) and pickup:GetSprite():GetFrame() == 1 and not pickup.SpawnerEntity then
			local newpickup = yandereWaifu.SpawnEasterEgg(pickup.Position, player, 1, pickup:IsShopItem())
			--local newpickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, RebekahCurseCards.CARD_EASTEREGG, pickup.Position, Vector(0,0), player):ToPickup()
			newpickup.OptionsPickupIndex = pickup.OptionsPickupIndex
			if pickup.Variant == PickupVariant.PICKUP_CHEST then
				for i = 0, math.random(0,1) do
					local newpickup = yandereWaifu.SpawnEasterEgg(pickup.Position, player, 1, pickup:IsShopItem())
					newpickup.OptionsPickupIndex = pickup.OptionsPickupIndex
				end
			end
			pickup:Remove()
		end
		if pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE then
			for i = 0, math.random(3,5) do
				local newpickup = yandereWaifu.SpawnEasterEgg(pickup.Position, player, 1, pickup:IsShopItem())
				newpickup.OptionsPickupIndex = pickup.OptionsPickupIndex
			end
			pickup:Remove()
		end
	end
end)
