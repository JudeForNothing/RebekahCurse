function yandereWaifu:useSacrifialAltar(collItem, rng, player, flags, slot)
	print("sad")
    local hasFamiliar = false
    --check if theres any familiar from player
    for i, v in pairs (Isaac.GetRoomEntities()) do
        if v:ToFamiliar() then
            if GetPtrHash(v:ToFamiliar().Player) == GetPtrHash(player) then
                hasFamiliar = true
                break
            end
        end
    end
    --check if the following familiars exist
    for i, v in pairs (Isaac.GetRoomEntities()) do
        if v:ToFamiliar() then
            if GetPtrHash(v:ToFamiliar().Player) == GetPtrHash(player) then
                if v.Variant == RebekahCurse.ENTITY_NED_NORMAL then
                    v:Remove()
                    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, 1, v.Position, Vector(0,0), v)
                elseif v.Variant == RebekahCurse.ENTITY_SQUIRENED then
                    v:Remove()
                    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_DOUBLEPACK, v.Position, Vector(0,0), v)
                elseif v.Variant == RebekahCurse.ENTITY_CHRISTIANNED or v.Variant == RebekahCurse.ENTITY_SCREAMINGNED or v.Variant == RebekahCurse.ENTITY_BARBARICNED or v.Variant == RebekahCurse.ENTITY_DEFENDINGNED then
                    if math.random(1,3) == 3 then
                        if v.SubType == 1 then
                            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_MOMS_KNIFE, v.Position, Vector(0,0), v)
                        elseif v.SubType == 2 then
                            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_DR_FETUS, v.Position, Vector(0,0), v)
                        elseif v.SubType == 3 then
                            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_TECHNOLOGY, v.Position, Vector(0,0), v)
                        elseif v.SubType == 4 then
                            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_BRIMSTONE, v.Position, Vector(0,0), v)
                        elseif v.SubType == 5 then
                            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_SPIRIT_SWORD, v.Position, Vector(0,0), v)
                        elseif v.SubType == 6 then
                            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_C_SECTION, v.Position, Vector(0,0), v)
                        elseif v.SubType == 7 then
                            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_LUDOVICO_TECHNIQUE, v.Position, Vector(0,0), v)
                        else
                            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_SAD_ONION, v.Position, Vector(0,0), v)
                        end
                    else
                        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, math.random(2,3), v.Position, Vector(0,0), v)
                    end
                    v:Remove()
                end
            end
        end
    end
    if hasFamiliar then
        SFXManager():Play( 241, 1, 0, false, 1 )

        InutilLib.game:Darken(1, 300)
        player:RemoveCollectible(collItem, false, slot, true)
    end
end
yandereWaifu:AddCallback( ModCallbacks.MC_USE_ITEM, yandereWaifu.useSacrifialAltar, CollectibleType.COLLECTIBLE_SACRIFICIAL_ALTAR);
