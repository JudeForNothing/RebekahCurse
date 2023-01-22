yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local sprite = eff:GetSprite()
	local data = yandereWaifu.GetEntityData(eff)
	
	if eff.FrameCount == 1 then
		data.Mode = 0
		data.OrbitStart = 0
	elseif eff.FrameCount >= 420 then
		eff:Remove()
	end
	
	if data.Mode == 1 then
		InutilLib.MoveOrbitAroundTargetType1(eff, data.Player, 3, 0.9, 5, data.OrbitStart)
	end
		
	if data.Mode == 2 then
		eff.Position = data.Player.Position
		eff.Velocity = data.Player.Velocity
		if not sprite:IsPlaying("Poke") then
			sprite:Play("Poke", true)
		end
		sprite.Rotation = eff.FrameCount
		if sprite:GetFrame() == 8 then
			local extraDmg = 1
			if data.TruePlayer:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
				extraDmg = 2
			end
			data.Player:TakeDamage( 1.5*extraDmg, 0, EntityRef(data.TruePlayer), 0);
		end
	else
		if sprite:IsPlaying("Poke") then
			sprite:Play("Idle", true)
		end
		sprite.Rotation = 0
	end
	
	if (not data.Player or data.Player:IsDead()) and data.TruePlayer then
		data.Mode = 1
		data.Player = data.TruePlayer
		table.insert(yandereWaifu.GetEntityData(data.Player).FingerTable, eff)
	end
end, RebekahCurse.ENTITY_FINGER_CLICKER);

yandereWaifu:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, pl)
	local sprite = pl:GetSprite()
	local data = yandereWaifu.GetEntityData(pl)
	
	if pl:HasCollectible(RebekahCurseItems.COLLECTIBLE_FINGERFINGER) then
		if not data.FingerTable then data.FingerTable = {} end
		for i, v in ipairs (Isaac.GetRoomEntities()) do
			if v.Type == 1000 and v.Variant == RebekahCurse.ENTITY_FINGER_CLICKER then
				if (pl.Position - v.Position):Length() <= 150 and yandereWaifu.GetEntityData(v).Mode == 0 then
					yandereWaifu.GetEntityData(v).Mode = 1
					yandereWaifu.GetEntityData(v).Player = pl
					yandereWaifu.GetEntityData(v).TruePlayer = pl
					table.insert(data.FingerTable, v)
				end
			end
		end
	end

end);


yandereWaifu:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, damage, amount, damageFlag, damageSource, damageCountdownFrames)
	if damage:IsEnemy() then
		--print(damageSource.Entity.Type)
		--print(damageSource.Entity.SpawnerEntity.Type)
		local data = yandereWaifu.GetEntityData(damage)
		local function SpawnFinger(player)
			local room = ILIB.game:GetRoom()

			if amount > damage.HitPoints then
				local finger = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_FINGER_CLICKER, 0, damage.Position, Vector(0,0), damage)
			end
			
		end
		
		if dmgFlag ~= DamageFlag.DAMAGE_POISON_BURN --[[and damageSource.Entity.SpawnerEntity]] then
			local player = InutilLib.GetPlayerFromDmgSrc(damageSource)
			if player then
				if player:HasCollectible(RebekahCurseItems.COLLECTIBLE_FINGERFINGER) then
					if not data.FingerTable then data.FingerTable = {} end
					if #yandereWaifu.GetEntityData(player).FingerTable > 0 and damage:IsEnemy() and damage:IsVulnerableEnemy() then
						for i, v in pairs(yandereWaifu.GetEntityData(player).FingerTable) do
							yandereWaifu.GetEntityData(v).Mode = 2
							yandereWaifu.GetEntityData(v).Player = damage
							table.insert(data.FingerTable, v)
							table.remove(yandereWaifu.GetEntityData(player).FingerTable, i)
						end
					end
					if #yandereWaifu.GetEntityData(player).FingerTable < 15 then
						SpawnFinger(player)
					end
				end
			end
			--[[if damageSource.Entity then
				if (damageSource.Entity.Type == 1) then
					print("hello")
					local player = damageSource.Entity:ToPlayer()
					if player:HasCollectible(RebekahCurseItems.COLLECTIBLE_FINGERFINGER) then
						SpawnFinger(player)
					end
				end
			elseif damageSource.Entity.SpawnerEntity then
				if (damageSource.Entity.SpawnerEntity.Type == 1) then
					print("helloaa")
					local player = damageSource.Entity.SpawnerEntity:ToPlayer()
					if player:HasCollectible(RebekahCurseItems.COLLECTIBLE_FINGERFINGER) then
						SpawnFinger(player)
					end
				end
			end]]
		end
	end
end)