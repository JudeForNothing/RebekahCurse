yandereWaifu:AddCallback(ModCallbacks.MC_POST_NPC_INIT, function(_, npc) --totally didnt steal this idea from FF
	if npc.Variant == 1770 then
		npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
		npc:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK)
		npc.Velocity = Vector.Zero
	end
end, 292)

yandereWaifu:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, entity, amount, flags)
	--interesting way to not make them explode Fiend Folio :0
	local data = yandereWaifu.GetEntityData(entity)
	if data.dontDoAnything then
		return
	end
	if entity.Variant == 1770 then -- Compost Bins, CompostAI, PooBarrels, BeanTNT,
		local amt = math.min(math.max(math.floor(amount / 15), 1), 3)
		if entity.HitPoints - amt <= 1 or flags & (DamageFlag.DAMAGE_TNT | DamageFlag.DAMAGE_EXPLOSION) ~= 0 or entity:IsDead() then
			sfx:Play(SoundEffect.SOUND_MUSHROOM_POOF, 2, 0, false, 1.5);
			if entity:GetDropRNG():RandomInt(50) == 0 then
				local sd = FiendFolio.savedata.run
				sd.ComposBarrelBeanFloor = sd.ComposBarrelBeanFloor or entity:GetDropRNG():RandomInt(5)
				if sd.ComposBarrelBeanFloor == 1 and not sd.SpawnedRainbowBean then
					Isaac.Spawn(5, 350, mod.ITEM.TRINKET.RAINBOW_BEAN, entity.Position + Vector(0,10), nilvector, nil)
					sd.SpawnedRainbowBean = true
				end
			end
			if entity.SubType == 2 then
				Game():CharmFart(entity.Position, 120, entity)
			elseif entity.SubType == 1 then
				Game():Fart(entity.Position, 80, entity, 1, 0)
				mod:FakeFart(entity, entity.Position)
			else
				game:ButterBeanFart(entity.Position, 280, entity, true, false)
				for _, enemy in pairs(Isaac.FindInRadius(entity.Position, 120, 0xffffffff)) do
					if enemy:IsEnemy() or enemy.Type == 1 then
						local enemyvec = (enemy.Position - entity.Position)
						local dist = 80 - enemyvec:Length()
						if enemy:IsEnemy() and not enemy:HasEntityFlags(EntityFlag.FLAG_CONFUSION) then
							enemy:AddConfusion(EntityRef(entity), math.ceil(30 + dist), false)
						end
						if not enemy:HasEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK) then
							if enemy.Type == 1 then
								--enemy.Velocity = enemy.Velocity + enemyvec:Resized(2)
							else
								enemy.Velocity = enemy.Velocity + enemyvec:Resized(15)
							end
						end
					end
				end
			end

			for i = 1, 6 do
				local particle = Isaac.Spawn(1000, 27, 0, entity.Position, RandomVector()*math.random(5,30)/10, entity)
				local ps = particle:GetSprite()

				ps:Load("gfx/grid/grid_winebarrel.anm2", true)
				ps:Play("Gib" .. math.random(4), true)
				--[[particle:GetData().turnedIntoCoolBetterParticles = true
				particle:Update()]]
			end

			local t = Isaac.Spawn(entity.Type, entity.Variant, entity.SubType, entity.Position, Vector.Zero, nil)
			t.HitPoints = 0
			t:GetData().dontDoAnything = true
			entity:Remove()
			t:Update()
		else
			entity.HitPoints = entity.HitPoints - amt
		end
		return false
	end
end, 292)