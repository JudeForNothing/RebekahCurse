function yandereWaifu:rebekahItemWispUpdate(wisp)
	local data = yandereWaifu.GetEntityData(wisp)
	if wisp.Player and wisp.SubType == RebekahCurseItems.COLLECTIBLE_DOORSTOPPER then
        if wisp.FrameCount >= 60 then
            wisp:Remove()
        end
    end
    if wisp.Player and wisp.SubType == RebekahCurseItems.COLLECTIBLE_OHIMDIE then
        --this is a test, dont bother
        --local fart = Isaac.Spawn(EntityType.ENTITY_EFFECT, 4, 0, wisp.Position, Vector(0,0), wisp)
    end
end
yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, yandereWaifu.rebekahItemWispUpdate, FamiliarVariant.WISP)

function yandereWaifu:rebekahItemWispCollision(wisp, coll, low)
	--[[if wisp.Player and wisp.SubType == RebekahCurseItems.COLLECTIBLE_OHIMDIE and wisp.HitPoints <= 1 then
        if not coll:IsEnemy() then return end
		local item = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_LOCKEDCHEST, 0, ILIB.room:FindFreePickupSpawnPosition(wisp.Position, 1), Vector(0,0), nil):ToPickup()
		item:TryOpenChest(player)
        item:Remove()
        Isaac.Explode(wisp.Position, wisp, 40)
	end]]
end
yandereWaifu:AddCallback(ModCallbacks.MC_PRE_FAMILIAR_COLLISION, yandereWaifu.rebekahItemWispCollision, FamiliarVariant.WISP)

-- Prevents disc wisps from taking damage.
function yandereWaifu:rebekahItemWispDamage(wisp, damage, damageFlags, coll, damageCountdown)
    if wisp.Type == 3 and wisp.Variant == FamiliarVariant.WISP then
        wisp = wisp:ToFamiliar()
        if wisp and wisp.Player and wisp.SubType == RebekahCurseItems.COLLECTIBLE_OHIMDIE and wisp.HitPoints <= 1 then

            local item = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_LOCKEDCHEST, 0, ILIB.room:FindFreePickupSpawnPosition(wisp.Position, 1), Vector(0,0), nil):ToPickup()
            item:TryOpenChest(wisp.Player)
            item:Remove()
            Isaac.Explode(wisp.Position, wisp, 40)
        end
    end
end
yandereWaifu:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, yandereWaifu.rebekahItemWispDamage)

--on death
yandereWaifu:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, function(_, wisp)
    if wisp.Variant == FamiliarVariant.WISP then
        wisp = wisp:ToFamiliar()
        if wisp.SubType == RebekahCurseItems.COLLECTIBLE_REBEKAHSCAMERA then
            for i, e in pairs(Isaac.GetRoomEntities()) do
                if e:IsEnemy() and e:IsVulnerableEnemy() and not e:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
                    e:AddFreeze(EntityRef(wisp.Player), math.random(60,120))
                end
            end
            InutilLib.SFX:Play( RebekahCurseSounds.SOUND_CAMERAUSE, 1.4, 0, false, 1 );
        end
    end
end, 3)