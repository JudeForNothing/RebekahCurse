yandereWaifu:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_,player)
	--local player = Isaac.GetPlayer(0);
    local room = Game():GetRoom();
	local data = yandereWaifu.GetEntityData(player)
	--lovesick
	if player:HasCollectible(RebekahCurse.COLLECTIBLE_LOVESICK) then
		if InutilLib.HasJustPickedCollectible( player, RebekahCurse.COLLECTIBLE_LOVESICK) then
			player:AddNullCostume(RebekahCurseCostumes.LoveSickCos)
		end
		if Isaac.GetFrameCount() % 120 == 0 then
			yandereWaifu.SpawnHeartParticles( 1, 3, player.Position, yandereWaifu.RandomHeartParticleVelocity(), player, RebekahHeartParticleType.Red );
			local fart = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_PHEROMONES_RING, 0, player.Position, Vector(0,0), player)
			yandereWaifu.GetEntityData(fart).Player = player
		end
	end
end)

InutilLib.AddCustomCallback(yandereWaifu, ILIBCallbacks.MC_POST_PLAYER_TEAR, function(_, tear)
	local data = yandereWaifu.GetEntityData(tear)
	local player = tear.SpawnerEntity:ToPlayer()
	if player:HasCollectible(RebekahCurse.COLLECTIBLE_LOVESICK) then
		if math.random(1,4) == 4 then
			data.IsLovesick = true
		end
	end
end)

function yandereWaifu:LovesickTearUpdate(tr)
	local data = yandereWaifu.GetEntityData(tr)
	local player = tr.SpawnerEntity
	if data.IsLovesick then
		if Isaac.GetFrameCount() % 30 == 0 then
			yandereWaifu.SpawnHeartParticles( 1, 3, tr.Position, yandereWaifu.RandomHeartParticleVelocity(), tr, RebekahHeartParticleType.Red );
			local fart = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_PHEROMONES_RING, 0, tr.Position, Vector(0,0), player)
			yandereWaifu.GetEntityData(fart).Player = tr
		end
	end
	
	if player then
		player = player:ToPlayer()
		if player:HasCollectible(RebekahCurse.COLLECTIBLE_LOVESICK) and player:HasWeaponType(WeaponType.WEAPON_LUDOVICO_TECHNIQUE) then
			if Isaac.GetFrameCount() % 30 == 0 and math.random(1,3) == 3 then
				yandereWaifu.SpawnHeartParticles( 1, 3, tr.Position, yandereWaifu.RandomHeartParticleVelocity(), tr, RebekahHeartParticleType.Red );
				local fart = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_PHEROMONES_RING, 0, tr.Position, Vector(0,0), player)
				yandereWaifu.GetEntityData(fart).Player = tr
			end
		end
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, yandereWaifu.LovesickTearUpdate)

--pheromones fart ring
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, function(_, eff)
	local sprite = eff:GetSprite()
	sprite:Play("Appear", true)
	eff.RenderZOffset = 10000;
	eff.SpriteOffset = Vector(0,-10)
end, RebekahCurse.ENTITY_PHEROMONES_RING);

yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local sprite = eff:GetSprite();
	local data = yandereWaifu.GetEntityData(eff)
	local player = data.Player
	
	if sprite:IsFinished("Appear") then
		sprite:Play("Loop", true)
	end
	
	if eff.FrameCount == 20 then
		sprite:Play("Dissappear", true)
	end
	
	if sprite:IsFinished("Dissappear") then
		eff:Remove()
	end
	
	eff.Velocity = player.Velocity;
	eff.Position = player.Position;
	
	for k, ent in pairs(Isaac.GetRoomEntities()) do
		if ent:IsEnemy() and ent:IsVulnerableEnemy() then
		local num = 45
			if ent.Position:Distance( eff.Position ) < ent.Size + eff.Size + num then
				ent:AddCharmed(EntityRef(player), math.random(30,90))
			end
		end
	end
end, RebekahCurse.ENTITY_PHEROMONES_RING);