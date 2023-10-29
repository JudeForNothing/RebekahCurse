local chance = 0.3

yandereWaifu:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, ent, damage, flags, source, countdown)
	local data = yandereWaifu.GetEntityData(ent)
	local cloned = flags & DamageFlag.DAMAGE_CLONES ~= 0

	if data.TakeDmgCancel ~= true and not cloned and ent:ToNPC() then
		local originalDamage = damage
		local newDamage = damage
		local newFlags = flags
		local sendNewDamage = false

		if source == nil then
			-- do nothing
		elseif source.Type == EntityType.ENTITY_TEAR or
			   (source.Type == EntityType.ENTITY_BOMBDROP and flags == flags | DamageFlag.DAMAGE_EXPLOSION) or
			   (source.Type == EntityType.ENTITY_EFFECT and source.Variant == EffectVariant.PLAYER_CREEP_HOLYWATER_TRAIL) or
			   (source.Type == EntityType.ENTITY_EFFECT and source.Variant == EffectVariant.ROCKET)
		then
            local player = InutilLib.GetPlayerFromDmgSrc(source)
            if player ~= nil then
                if not player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_SILENCER) then return end
                local rng = Isaac.GetPlayer():GetCollectibleRNG(RebekahCurse.Items.COLLECTIBLE_SILENCER)
			    if rng:RandomFloat() < chance and not yandereWaifu.GetEntityData(ent).IsSilenced then
                    local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
                    yandereWaifu.AddSilence(ent, 60*secondHandMultiplier)
                end
            end
		elseif source.Type == EntityType.ENTITY_KNIFE and (source.Variant == 0 or source.Variant == 5) then
			local player = InutilLib:GetPlayerFromKnife(source.Entity)
            if not player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_SILENCER) then return end
			if player ~= nil then
				local rng = Isaac.GetPlayer():GetCollectibleRNG(RebekahCurse.Items.COLLECTIBLE_SILENCER)
			    if rng:RandomFloat() < chance and not yandereWaifu.GetEntityData(ent).IsSilenced then
                    local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
                    yandereWaifu.AddSilence(ent, 60*secondHandMultiplier)
                end
			end
		elseif source.Type == EntityType.ENTITY_PLAYER and flags == flags | DamageFlag.DAMAGE_LASER then
			local player = source.Entity:ToPlayer()
            if not player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_SILENCER) then return end
			local rng = Isaac.GetPlayer():GetCollectibleRNG(RebekahCurse.Items.COLLECTIBLE_SILENCER)
			if rng:RandomFloat() < chance and not yandereWaifu.GetEntityData(ent).IsSilenced then
                local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
                yandereWaifu.AddSilence(ent, 60*secondHandMultiplier)
            end
		--[[elseif source.Type == EntityType.ENTITY_EFFECT and source.Variant == EffectVariant.DARK_SNARE then
			if source.Entity and source.Entity.SpawnerEntity and source.Entity.SpawnerEntity.Type == EntityType.ENTITY_PLAYER then
				local player = source.Entity.SpawnerEntity:ToPlayer()
                if not player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_SILENCER) then return end
				local rng = Isaac.GetPlayer():GetCollectibleRNG(RebekahCurse.Items.COLLECTIBLE_SILENCER)
			    if rng:RandomFloat() < chance and not yandereWaifu.GetEntityData(ent).IsSilenced then
                    local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
                    yandereWaifu.AddSilence(ent, 60*secondHandMultiplier)
                end
			end]]
		elseif source.Type == EntityType.ENTITY_FAMILIAR and source.Variant == FamiliarVariant.ABYSS_LOCUST then
			if source.Entity and source.Entity.SpawnerEntity and source.Entity.SpawnerEntity.Type == EntityType.ENTITY_PLAYER then
				local player = source.Entity.SpawnerEntity:ToPlayer()
                if not player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_SILENCER) then return end
				local rng = Isaac.GetPlayer():GetCollectibleRNG(RebekahCurse.Items.COLLECTIBLE_SILENCER)
			    if rng:RandomFloat() < chance and not yandereWaifu.GetEntityData(ent).IsSilenced then
                    local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
                    yandereWaifu.AddSilence(ent, 60*secondHandMultiplier)
                end
			end
		end
	end
end)