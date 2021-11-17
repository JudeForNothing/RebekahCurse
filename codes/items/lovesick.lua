yandereWaifu:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_,player)
	--local player = Isaac.GetPlayer(0);
    local room = Game():GetRoom();
	local data = yandereWaifu.GetEntityData(player)
	--lovesick
	if player:HasCollectible(RebekahCurse.COLLECTIBLE_LOVESICK) then
		if InutilLib.HasJustPickedCollectible( player, RebekahCurse.COLLECTIBLE_LOVESICK) then
			player:AddNullCostume(RebekahCurseCostumes.LoveSickCos)
		end
		if data.hasTurnedToLovesickBanshee then
			if not data.BansheeLovesickCountdown then data.BansheeLovesickCountdown = 3000 end
			data.BansheeLovesickCountdown = data.BansheeLovesickCountdown - 1
			
			if data.BansheeLovesickCountdown <= 0 then
				data.hasTurnedToLovesickBanshee = false
			else
			
				--because pre player coll is broken
				--[[for k, ent in pairs(Isaac.GetRoomEntities()) do
					if ent:IsEnemy() and ent:IsVulnerableEnemy() then
						local num = 45
						if ent.Position:Distance( player.Position ) < ent.Size + player.Size + num and player.FrameCount % 5 == 0 then
							print("Push")
							print(data.BansheeLovesickCountdown)
							local slash = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_LOVESICK_SLASH, 0, player.Position, Vector(0,0), player)
							slash:GetSprite().Rotation = (ent.Position - player.Position):GetAngleDegrees() - 90
							yandereWaifu.GetEntityData(slash).Player = player
						end
					end
				end]]
			end
		end
	end
end)

--[[InutilLib.AddCustomCallback(yandereWaifu, ILIBCallbacks.MC_POST_PLAYER_TEAR, function(_, tear)
	local data = yandereWaifu.GetEntityData(tear)
	local player = tear.SpawnerEntity:ToPlayer()
	if player:HasCollectible(RebekahCurse.COLLECTIBLE_LOVESICK) then
		if math.random(1,4) == 4 then
			data.IsLovesick = true
		end
	end
end)]]

--[[function yandereWaifu:LovesickTearUpdate(tr)
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
yandereWaifu:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, yandereWaifu.LovesickTearUpdate)]]

--pheromones fart ring
--[[
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
end, RebekahCurse.ENTITY_PHEROMONES_RING);]]

yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, function(_, eff)
	local sprite = eff:GetSprite()
	sprite:Play("Slash", true)
	eff.RenderZOffset = 10000;
	eff.SpriteOffset = Vector(0,-10)
end, RebekahCurse.ENTITY_LOVESICK_SLASH);

yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local sprite = eff:GetSprite();
	local data = yandereWaifu.GetEntityData(eff)
	local player = data.Player:ToPlayer()
	
	if sprite:IsFinished("Slash") then
		eff:Remove()
	end
	
	eff.Velocity = player.Velocity;
	eff.Position = player.Position;
	
	for k, ent in pairs(Isaac.GetRoomEntities()) do
		if ent:IsEnemy() and ent:IsVulnerableEnemy() then
		local num = 25
			if ent.Position:Distance( eff.Position ) < ent.Size + eff.Size + num then
				ent:AddCharmed(EntityRef(player), math.random(30,90))
				ent:TakeDamage(player.Damage*3, 0, EntityRef(player), 1)
			end
		end
	end
end, RebekahCurse.ENTITY_LOVESICK_SLASH);

--[[InutilLib:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, damage, amount, damageFlag, damageSource, damageCountdownFrames) 
	if damage.Type == 1 and damage:ToPlayer():HasCollectible(RebekahCurse.COLLECTIBLE_LOVESICK) then
		local data = yandereWaifu.GetEntityData(damage)
		damage = damage:ToPlayer()
		local hearts = damage:GetHearts() + damage:GetSoulHearts() + damage:GetGoldenHearts() + damage:GetEternalHearts() + damage:GetBoneHearts() + damage:GetRottenHearts()
		if not data.hasTurnedToLovesickBanshee and hearts <= 2 then
			damage = damage:ToPlayer()
			damage:AnimateSad()
				
			damage:AddNullCostume(RebekahCurseCostumes.SnappedCos)

			data.hasTurnedToLovesickBanshee = true
			
			damage:AddCacheFlags(CacheFlag.CACHE_ALL);
			damage:EvaluateItems()
		end
		if data.hasTurnedToLovesickBanshee then
			
			return false
		end
	end
	
end)]]



--stat cache for each mode
function yandereWaifu:lovesickbansheecacheregister(player, cacheF) --The thing the checks and updates the game, i guess?
	local data = yandereWaifu.GetEntityData(player)
	if player:HasCollectible(RebekahCurse.COLLECTIBLE_LOVESICK) and data.hasTurnedToLovesickBanshee then
		--if data.SnapDelay then
		--	if cacheF == CacheFlag.CACHE_FIREDELAY then
		--		player.FireDelay = player.FireDelay - data.SnapDelay
		--	end
		--end
		if cacheF == CacheFlag.CACHE_FIREDELAY then
			player.FireDelay = player.FireDelay - 2
		end
		if cacheF == CacheFlag.CACHE_SPEED then
			player.MoveSpeed = player.MoveSpeed + 0.25
		end
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, yandereWaifu.lovesickbansheecacheregister)