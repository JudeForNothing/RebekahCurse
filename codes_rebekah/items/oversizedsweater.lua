yandereWaifu:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, function(_, pickup, coll, low)
	local rng = pickup:GetDropRNG()
	local player = coll:ToPlayer()
	pickup = pickup:ToPickup()
	if player and player:HasCollectible(RebekahCurseItems.COLLECTIBLE_OVERSIZEDSWEATER) then
		if (pickup.SubType == 1 or pickup.SubType == 2 or pickup.SubType == 5 or pickup.SubType == 9 or pickup.SubType == 10 ) and player:CanPickRedHearts() then
			local clot = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLOOD_BABY, 0, player.Position, Vector(0, 0), player):ToFamiliar()
			if pickup.SubType == 2 then
				clot.HitPoints = clot.HitPoints/2
			end
			if pickup.SubType == 5 then
				local clot = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLOOD_BABY, 0, player.Position, Vector(0, 0), player):ToFamiliar()
			end
		elseif (pickup.SubType == 3 or pickup.SubType == 8 or pickup.SubType == 10) and player:CanPickSoulHearts() then
			local clot = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLOOD_BABY, 1, player.Position, Vector(0, 0), player):ToFamiliar()
			if pickup.SubType == 8 then
				clot.HitPoints = clot.HitPoints/2
			end
		elseif pickup.SubType == 6 and player:CanPickBlackHearts() then
			local clot = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLOOD_BABY, 2, player.Position, Vector(0, 0), player):ToFamiliar()
		elseif pickup.SubType == 4 then
			local clot = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLOOD_BABY, 3, player.Position, Vector(0, 0), player):ToFamiliar()
		elseif pickup.SubType == 7 and player:CanPickGoldenHearts() then
			local clot = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLOOD_BABY, 4, player.Position, Vector(0, 0), player):ToFamiliar()
		elseif pickup.SubType == 11 and player:CanPickBoneHearts() then
			local clot = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLOOD_BABY, 5, player.Position, Vector(0, 0), player):ToFamiliar()
		elseif pickup.SubType == 12 and player:CanPickRottenHearts() then
			local clot = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLOOD_BABY, 6, player.Position, Vector(0, 0), player):ToFamiliar()
		end
	end
end, PickupVariant.PICKUP_HEART)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_,player)
	local data = yandereWaifu.GetEntityData(player)
	--items function!
	if player:HasCollectible(RebekahCurseItems.COLLECTIBLE_OVERSIZEDSWEATER) and InutilLib.HasJustPickedCollectible( player, RebekahCurseItems.COLLECTIBLE_OVERSIZEDSWEATER ) then
		player:AddNullCostume(RebekahCurseCostumes.OversizedSweater)
	end
end)