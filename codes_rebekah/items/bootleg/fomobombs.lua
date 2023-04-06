
yandereWaifu:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, pickup)
	local rng = pickup:GetDropRNG()
	for p = 0, InutilLib.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		local data = yandereWaifu.GetEntityData(pickup);
		local validPickup = (pickup.Variant == PickupVariant.PICKUP_BOMB) and (pickup.SubType == 1 or pickup.SubType == 2)
		if player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_FOMOBOMBS) then
			--pickup.Wait = 10;
			if pickup.Timeout <= 0 and ((pickup:GetSprite():IsPlaying("Appear") or pickup:GetSprite():IsPlaying("AppearFast")) and --[[pickup:GetSprite():GetFrame()]] pickup.FrameCount == 1 and validPickup) --[[and not pickup.SpawnerEntity ]]then
				if pickup.SubType == 2 then
					pickup:Morph(5, RebekahCurse.ENTITY_TRIPLEBOMBS, 177, true, true, true)
				else
					pickup:Morph(5, PickupVariant.PICKUP_BOMB, BombSubType.BOMB_DOUBLEPACK, true, true, true)
				end
				pickup.Timeout = 45
			end
		end
	end
end)


yandereWaifu:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)
	local pickups = Isaac.FindByType(5, RebekahCurse.ENTITY_TRIPLEBOMBS, 177, false, false)
    --Isaac.FindInRadius(player.Position, player.Size + 15, EntityPartition.PICKUP)
	for _, pickup in pairs(pickups) do
       if player.Position:Distance(pickup.Position) < player.Size + pickup.Size then
           pickup = pickup:ToPickup()
            if pickup and pickup.Wait <= 0 then
         	   	local picked = InutilLib.PickupPickup(pickup)
                player:AddBombs(3)
            end
         end
	end
end)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, function(_, pickup)
    local spr = pickup:GetSprite()
    if pickup.Variant == RebekahCurse.ENTITY_TRIPLEBOMBS then
        spr:Play("Appear", true)
    end
end)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, pickup)
    local spr = pickup:GetSprite()
    if pickup.Variant == RebekahCurse.ENTITY_TRIPLEBOMBS then
        if spr:IsEventTriggered("DropSound") then
            InutilLib.SFX:Play(SoundEffect.SOUND_CHEST_DROP, 1, 0, false, 1.2);
        elseif spr:IsPlaying("Collect") and spr:GetFrame() == 2 then
            --InutilLib.SFX:Play(SoundEffect.SOUND_PENNYPICKUP, 1, 0, false, 1.2);
            pickup.Velocity = Vector.Zero
            pickup.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        end
    end
end)