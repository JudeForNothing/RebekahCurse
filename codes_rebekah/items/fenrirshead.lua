
yandereWaifu:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, ent, damage, dmgFlag, dmgSource, dmgCountdownFrames)
	--dmgSource = dmgSource:ToLaser()
    local data = yandereWaifu.GetEntityData(ent)
	if not data.TakeDmgCancel and ent:IsEnemy() and dmgFlag & DamageFlag.DAMAGE_POISON_BURN == 0 then
        local confirm = false
        local newDamage = 0
        local player
        if dmgSource.Type == 1 then
            player = dmgSource.Entity:ToPlayer()
        elseif dmgSource.Entity and dmgSource.Entity.SpawnerEntity and dmgSource.Entity.SpawnerEntity.Type == 1 then
            player = dmgSource.Entity.SpawnerEntity:ToPlayer()
        end
        if (player) then
            if player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_FENRIRSHEAD) and math.random(1,10) == 10  then
                newDamage = damage * 2
                confirm = true
                local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_REBEKAH_DUST, RebekahCurse.DustEffects.ENTITY_REBEKAH_CURSED_WILD_SWING, ent.Position, Vector.Zero, ent)
                yandereWaifu.GetEntityData(poof).Parent = ent
                InutilLib.SFX:Play( RebekahCurse.Sounds.SOUND_CURSED_WILD_SWING, 1, 0, false, 0.6 );
                InutilLib.game:ShakeScreen(10)
            end
        end
		if confirm and dmgFlag & DamageFlag.DAMAGE_FIRE == 0 then
			data.TakeDmgCancel = true
			ent:TakeDamage(newDamage, dmgFlag, dmgSource, 1)
			data.TakeDmgCancel = nil
			return false
		end
	end
end)