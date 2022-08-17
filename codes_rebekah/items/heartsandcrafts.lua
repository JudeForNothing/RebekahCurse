function yandereWaifu:useHeartsAndCrafts(collItem, rng, player)
	--[[	local hadEternal = false
	
			rng = math.random(1,20)
			if rng < 2 then --red add
				local mob = Isaac.Spawn(RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY, RebekahCurseEnemies.ENTITY_REDTATO, 0, player.Position,  player.Velocity, player):ToNPC();
				mob:AddEntityFlags(EntityFlag.FLAG_CHARM | EntityFlag.FLAG_FRIENDLY | EntityFlag.FLAG_PERSISTENT)
				mob.HitPoints = mob.HitPoints/2
				mob.CollisionDamage = 3
				--player:AddHearts(2)

				--player:AddMaxHearts(2)
			elseif rng < 8 then
				local mob = Isaac.Spawn(RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY, RebekahCurseEnemies.ENTITY_REDTATO, 0, player.Position,  player.Velocity, player):ToNPC();
				mob:AddEntityFlags(EntityFlag.FLAG_CHARM | EntityFlag.FLAG_FRIENDLY | EntityFlag.FLAG_PERSISTENT)
				mob.HitPoints = mob.HitPoints/2
				mob.CollisionDamage = 3
				--addGolden = addGolden + 1
			elseif rng < 12 then
				local mob = Isaac.Spawn(RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY, RebekahCurseEnemies.ENTITY_REDTATO, 0, player.Position,  player.Velocity, player):ToNPC();
				mob:AddEntityFlags(EntityFlag.FLAG_CHARM | EntityFlag.FLAG_FRIENDLY | EntityFlag.FLAG_PERSISTENT)
				mob.CollisionDamage = 3
				mob.HitPoints = mob.HitPoints/2
				--player:AddSoulHearts(1)
			elseif rng < 15 then
				local mob = Isaac.Spawn(RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY, RebekahCurseEnemies.ENTITY_REDTATO, 0, player.Position,  player.Velocity, player):ToNPC();
				mob:AddEntityFlags(EntityFlag.FLAG_CHARM | EntityFlag.FLAG_FRIENDLY | EntityFlag.FLAG_PERSISTENT)
				mob.HitPoints = mob.HitPoints/2
				mob.CollisionDamage = 3
				--player:AddBlackHearts(1)
			elseif rng < 17 then
				local mob = Isaac.Spawn(RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY, RebekahCurseEnemies.ENTITY_REDTATO, 0, player.Position,  player.Velocity, player):ToNPC();
				mob:AddEntityFlags(EntityFlag.FLAG_CHARM | EntityFlag.FLAG_FRIENDLY | EntityFlag.FLAG_PERSISTENT)
				mob.HitPoints = mob.HitPoints/2
				mob.CollisionDamage = 3
				--player:AddRottenHearts(1)
			elseif rng < 18 then
				local mob = Isaac.Spawn(RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY, RebekahCurseEnemies.ENTITY_REDTATO, 0, player.Position,  player.Velocity, player):ToNPC();
				mob:AddEntityFlags(EntityFlag.FLAG_CHARM | EntityFlag.FLAG_FRIENDLY | EntityFlag.FLAG_PERSISTENT)
				mob.HitPoints = mob.HitPoints/2
				mob.CollisionDamage = 3
				--if not hadEternal then
					--player:AddEternalHearts(1)
				--	hadEternal = true
				--	addEternal = true
				--else
				--	player:AddSoulHearts(1)
				--end
			else
				local mob = Isaac.Spawn(RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY, RebekahCurseEnemies.ENTITY_REDTATO, 0, player.Position,  player.Velocity, player):ToNPC();
				mob:AddEntityFlags(EntityFlag.FLAG_CHARM | EntityFlag.FLAG_FRIENDLY | EntityFlag.FLAG_PERSISTENT)
				mob.HitPoints = mob.HitPoints/2
				mob.CollisionDamage = 3
				--player:AddBoneHearts(1)
			end]]
	local mob = Isaac.Spawn(RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY, RebekahCurseEnemies.ENTITY_REDTATO, 0, player.Position,  player.Velocity, player):ToNPC();
	mob:AddEntityFlags(EntityFlag.FLAG_CHARM | EntityFlag.FLAG_FRIENDLY | EntityFlag.FLAG_PERSISTENT)
	mob.HitPoints = mob.HitPoints/2
	mob.CollisionDamage = 1.5
	yandereWaifu.GetEntityData(mob).CharmedToParent = player
end
yandereWaifu:AddCallback( ModCallbacks.MC_USE_ITEM, yandereWaifu.useHeartsAndCrafts, RebekahCurse.COLLECTIBLE_HEARTSANDCRAFTS );