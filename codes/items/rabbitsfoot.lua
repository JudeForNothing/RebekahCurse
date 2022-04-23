local chance = 1/4
local isEaster = false --just setting this up because easter is still out
yandereWaifu:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, function(_, pickup)
	local rng = pickup:GetDropRNG()
	for p = 0, ILIB.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		local entityData = yandereWaifu.GetEntityData(player);
		local validPickup = (pickup.Variant == PickupVariant.PICKUP_CHEST or pickup.Variant == PickupVariant.PICKUP_PILL)
		if (player:HasTrinket(RebekahCurse.TRINKET_RABBITSFOOT) or isEaster) or pickup.Variant == PickupVariant.PICKUP_PILL then
			if isEaster and player:HasTrinket(RebekahCurse.TRINKET_RABBITSFOOT) then chance = 1/2 end
			--pickup.Wait = 10;
			if rng:RandomFloat() <= (chance) and validPickup and ILIB.room:IsFirstVisit() and not pickup.Parent then
				local newpickup = yandereWaifu.SpawnEasterEgg(pickup.Position, player, 1, pickup:IsShopItem())
				--local newpickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, RebekahCurse.CARD_EASTEREGG, pickup.Position, Vector(0,0), player):ToPickup()
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