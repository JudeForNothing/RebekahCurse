--[[yandereWaifu:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_,player)
	local data = yandereWaifu.GetEntityData(player)
	if data.LMLMNBuff and (player:HasCollectible(RebekahCurse.COLLECTIBLE_LOVEMELOVEMENOT) or player:HasCollectible(RebekahCurse.COLLECTIBLE_LOVEMELOVEMENOT2) or player:HasCollectible(RebekahCurse.COLLECTIBLE_LOVEMELOVEMENOT3)) then
		player:AddCacheFlags(CacheFlag.CACHE_ALL);
		player:EvaluateItems()
	end
end)]]


function yandereWaifu:usedoLoveMe(collItem, rng, player, flags, slot)
	local data = yandereWaifu.GetEntityData(player)
	--data.LMLMNBuff = data.PersistentPlayerData.LMLMNBuff
	--data.LovesMe = data.PersistentPlayerData.LovesMe
	
	print(data.PersistentPlayerData.LMLMNBuff)
	print(data.PersistentPlayerData.LovesMe)
	
	if data.PersistentPlayerData.LMLMNBuff == nil then data.PersistentPlayerData.LMLMNBuff = 0 end
	if data.PersistentPlayerData.LovesMe == nil then data.PersistentPlayerData.LovesMe = true end
	
	local rng = math.random(1,3)
	if data.PersistentPlayerData.LovesMe == true then --if she loves you
		if rng == 1 then
			data.PersistentPlayerData.LMLMNBuff = 1
		--	player:AddCacheFlags(CacheFlag.CACHE_DAMAGE);
		elseif rng == 2 then
			data.PersistentPlayerData.LMLMNBuff = 2
		--	player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY);
		elseif rng == 3 then
			data.PersistentPlayerData.LMLMNBuff = 3
		--	player:AddCacheFlags(CacheFlag.CACHE_SPEED);
		--elseif rng == 4 then
		--	data.LMLMNBuff = 4
		--	player:AddCacheFlags(CacheFlag.CACHE_RANGE);
		end
		data.PersistentPlayerData.LovesMe = false
		local charge = Isaac.Spawn( EntityType.ENTITY_EFFECT, EffectVariant.HEART, 0, player.Position, Vector(0,0), player );
		charge.SpriteOffset = Vector(0,-40)
		InutilLib.SFX:Play( SoundEffect.SOUND_THUMBSUP , 1.2, 0, false, 1 );
	elseif data.PersistentPlayerData.LovesMe == false then --if she does not
		if rng == 1 then
			local h = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, BombSubType.BOMB_TROLL, ILIB.room:FindFreePickupSpawnPosition(player.Position, 1), Vector(0,0), nil)
		--[[elseif rng == 2 then
			local h = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, BombSubType.BOMB_SUPERTROLL, ILIB.room:FindFreePickupSpawnPosition(player.Position, 1), Vector(0,0), nil)
		elseif rng == 3 then
			local h = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, BombSubType.BOMB_GOLDENTROLL, ILIB.room:FindFreePickupSpawnPosition(player.Position, 1), Vector(0,0), nil)
		elseif rng == 4 then
			player:UseCard(Card.CARD_TOWER, 0)]]
		end
		data.PersistentPlayerData.LovesMe = true
		local charge = Isaac.Spawn( EntityType.ENTITY_EFFECT, EffectVariant.HEART, 0, player.Position, Vector(0,0), player );
		charge.SpriteOffset = Vector(0,-40)
		charge:GetSprite():ReplaceSpritesheet(0, "gfx/effects/items/heart_no_love.png");
		charge:GetSprite():LoadGraphics();
		InutilLib.SFX:Play( SoundEffect.SOUND_THUMBSUP , 1.2, 0, false, 0.4 );
		
		data.PersistentPlayerData.LMLMNBuff = 0
	end
	if math.random(1,100) >= 90 then --rng to stage 2
		player:RemoveCollectible(RebekahCurse.COLLECTIBLE_LOVEMELOVEMENOT, false, slot)
		player:AddCollectible(RebekahCurse.COLLECTIBLE_LOVEMELOVEMENOT2, 0, true, slot)
	end
	player:AddCacheFlags(CacheFlag.CACHE_ALL);
	player:EvaluateItems()
	
	--data.PersistentPlayerData.LMLMNBuff = data.LMLMNBuff
	--data.PersistentPlayerData.LovesMe = data.LovesMe
	
	player:AnimateCollectible(RebekahCurse.COLLECTIBLE_LOVEMELOVEMENOT, "UseItem")
end

function yandereWaifu:usedoLoveMe2(collItem, rng, player, flags, slot)
	local data = yandereWaifu.GetEntityData(player)
	--data.LMLMNBuff = data.PersistentPlayerData.LMLMNBuff
	--data.LovesMe = data.PersistentPlayerData.LovesMe
	
	if data.PersistentPlayerData.LMLMNBuff == nil then data.PersistentPlayerData.LMLMNBuff = 0 end
	if data.PersistentPlayerData.LovesMe == nil then data.PersistentPlayerData.LovesMe = true end
	
	local rng = math.random(1,3)
	if data.PersistentPlayerData.LovesMe == true then --if she loves you
		if rng == 1 then
			data.PersistentPlayerData.LMLMNBuff = 5
		elseif rng == 2 then
			data.PersistentPlayerData.LMLMNBuff = 6
		elseif rng == 3 then
			data.PersistentPlayerData.LMLMNBuff = 7
		end
		data.PersistentPlayerData.LovesMe = false
		local charge = Isaac.Spawn( EntityType.ENTITY_EFFECT, EffectVariant.HEART, 0, player.Position, Vector(0,0), player );
		charge.SpriteOffset = Vector(0,-40)
		InutilLib.SFX:Play( SoundEffect.SOUND_THUMBSUP , 1.2, 0, false, 1.2 );
	elseif data.PersistentPlayerData.LovesMe == false then --if she does not
		if rng == 1 then
			local h = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, BombSubType.BOMB_SUPERTROLL, ILIB.room:FindFreePickupSpawnPosition(player.Position, 1), Vector(0,0), nil)
		elseif rng == 2 then
			local h = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, BombSubType.BOMB_GOLDENTROLL, ILIB.room:FindFreePickupSpawnPosition(player.Position, 1), Vector(0,0), nil)
		end
		data.PersistentPlayerData.LovesMe = true
		local charge = Isaac.Spawn( EntityType.ENTITY_EFFECT, EffectVariant.HEART, 0, player.Position, Vector(0,0), player );
		charge.SpriteOffset = Vector(0,-40)
		charge:GetSprite():ReplaceSpritesheet(0, "gfx/effects/items/heart_no_love.png");
		charge:GetSprite():LoadGraphics();
		InutilLib.SFX:Play( SoundEffect.SOUND_THUMBSUP , 1.2, 0, false, 0.4 );
		
		data.PersistentPlayerData.LMLMNBuff = 0
	end
	if math.random(1,100) >= 90 then --rng to stage 3
		player:RemoveCollectible(RebekahCurse.COLLECTIBLE_LOVEMELOVEMENOT2, false, slot)
		player:AddCollectible(RebekahCurse.COLLECTIBLE_LOVEMELOVEMENOT3, 0, true, slot)
	end
	player:AddCacheFlags(CacheFlag.CACHE_ALL);
	player:EvaluateItems()
	
	--data.PersistentPlayerData.LMLMNBuff = data.LMLMNBuff
	--data.PersistentPlayerData.LovesMe = data.LovesMe
	
	player:AnimateCollectible(RebekahCurse.COLLECTIBLE_LOVEMELOVEMENOT2, "UseItem")
end

local function SpawnRandomReward(player)
	local rng = math.random(1,10)
	if rng == 1 then
		Isaac.Spawn( EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_CHEST, 0, ILIB.room:FindFreePickupSpawnPosition(player.Position, 1), Vector(0,0), player );
	elseif rng == 2 then
		for i = 1, math.random(3,8) do
			Isaac.Spawn( EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, 0,ILIB.room:FindFreePickupSpawnPosition(player.Position, 1), Vector(0,0), player );
		end
	elseif rng == 3 then
		for i = 1, math.random(3,5) do
			Isaac.Spawn( EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_KEY, 0, ILIB.room:FindFreePickupSpawnPosition(player.Position, 1), Vector(0,0), player );
		end
	elseif rng == 4 then
		for i = 1, math.random(3,5) do
			Isaac.Spawn( EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, 0, ILIB.room:FindFreePickupSpawnPosition(player.Position, 1), Vector(0,0), player );
		end
	elseif rng == 5 then
		for i = 1, 3 do
			Isaac.Spawn( EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_PILL, 0, ILIB.room:FindFreePickupSpawnPosition(player.Position, 1), Vector(0,0), player );
		end
	elseif rng == 6 then
		Isaac.Spawn( EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_ETERNALCHEST, 0, ILIB.room:FindFreePickupSpawnPosition(player.Position, 1), Vector(0,0), player );
	elseif rng == 7 then
		for i = 1, 3 do
			Isaac.Spawn( EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, 0, ILIB.room:FindFreePickupSpawnPosition(player.Position, 1), Vector(0,0), player );
		end
	elseif rng == 8 then
		local rng2 = math.random(1,3)
		for i = 1, 8 do
			if rng2 == 1 then
				local mob = Isaac.Spawn( EntityType.ENTITY_SLOTH, 0, 0, player.Position, Vector(0,0), player );
				mob:AddEntityFlags(EntityFlag.FLAG_CHARMED | EntityFlag.FLAG_FRIENDLY)
				break
			elseif rng2 == 2 then
				local mob = Isaac.Spawn( EntityType.ENTITY_MULLIGAN, 0, 0, player.Position, Vector(0,0), player );
				mob:AddEntityFlags(EntityFlag.FLAG_CHARMED | EntityFlag.FLAG_FRIENDLY)
			elseif rng2 == 3 then
				local mob = Isaac.Spawn( EntityType.ENTITY_LUST, 0, 0, player.Position, Vector(0,0), player );
				mob:AddEntityFlags(EntityFlag.FLAG_CHARMED | EntityFlag.FLAG_FRIENDLY)
				break
			end
		end
	elseif rng == 9 then
		for i = 1, 3 do
			Isaac.Spawn( EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_REDCHEST, 0, ILIB.room:FindFreePickupSpawnPosition(player.Position, 1), Vector(0,0), player );
		end
	elseif rng == 10 then
		Isaac.Spawn( EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_MEGACHEST, 0, ILIB.room:FindFreePickupSpawnPosition(player.Position, 1), Vector(0,0), player );
	end
end

function yandereWaifu:usedoLoveMe3(collItem, rng, player, flags, slot)
	local data = yandereWaifu.GetEntityData(player)
	--data.LMLMNBuff = data.PersistentPlayerData.LMLMNBuff
	--data.LovesMe = data.PersistentPlayerData.LovesMe
	
	if data.PersistentPlayerData.LMLMNBuff == nil then data.PersistentPlayerData.LMLMNBuff = 0 end
	if data.PersistentPlayerData.LovesMe == nil then data.PersistentPlayerData.LovesMe = true end
	
	local rng = math.random(1,4)
	if data.PersistentPlayerData.LovesMe == true then --if she loves you
		if rng == 1 then
			data.PersistentPlayerData.LMLMNBuff = 9
		elseif rng == 2 then
			data.PersistentPlayerData.LMLMNBuff = 10
		elseif rng == 3 then
			data.PersistentPlayerData.LMLMNBuff = 11
		elseif rng == 4 then
			data.PersistentPlayerData.LMLMNBuff = 12
		end
		data.PersistentPlayerData.LovesMe = false
		local charge = Isaac.Spawn( EntityType.ENTITY_EFFECT, EffectVariant.HEART, 0, player.Position, Vector(0,0), player );
		charge.SpriteOffset = Vector(0,-40)
		InutilLib.SFX:Play( SoundEffect.SOUND_THUMBSUP_AMPLIFIED , 1.2, 0, false, 1.3 );
		SpawnRandomReward(player)
	elseif data.PersistentPlayerData.LovesMe == false then --if she does not
		if rng == 1 then
			local h = Isaac.Spawn(EntityType.ENTITY_EFFECT, 29, 0, player.Position, Vector(0,0), nil)
		elseif rng == 2 then
			local h = Isaac.Spawn(EntityType.ENTITY_MOMS_HAND, 0, 0,player.Position, Vector(0,0), nil)
		end
		data.PersistentPlayerData.LovesMe = true
		local charge = Isaac.Spawn( EntityType.ENTITY_EFFECT, EffectVariant.HEART, 0, player.Position, Vector(0,0), player );
		charge.SpriteOffset = Vector(0,-40)
		charge:GetSprite():ReplaceSpritesheet(0, "gfx/effects/items/heart_no_love.png");
		charge:GetSprite():LoadGraphics();
		InutilLib.SFX:Play( SoundEffect.SOUND_THUMBSUP_AMPLIFIED , 1.2, 0, false, 0.4 );
		
		data.PersistentPlayerData.LMLMNBuff = 0
	end
	if math.random(1,100) >= 80 then --rng to stage 3
		player:RemoveCollectible(RebekahCurse.COLLECTIBLE_LOVEMELOVEMENOT3, false, slot)
		if data.PersistentPlayerData.LovesMe == true then
			for i = 1, 3 do
				SpawnRandomReward(player)
			end
		else
			local getHealth = player:GetHearts() + player:GetSoulHearts() + player:GetRottenHearts () + player:GetBoneHearts()
			local decrementDmg = 0
			if getHealth < 5 then
				decrementDmg = 5
			end
			player:TakeDamage(5 - decrementDmg, 0, EntityRef(player), 5)
		end
	end
	
	--data.PersistentPlayerData.LMLMNBuff = data.LMLMNBuff
	--data.PersistentPlayerData.LovesMe = data.LovesMe
	
	player:AnimateCollectible(RebekahCurse.COLLECTIBLE_LOVEMELOVEMENOT3, "UseItem")
end


yandereWaifu:AddCallback( ModCallbacks.MC_USE_ITEM, yandereWaifu.usedoLoveMe, RebekahCurse.COLLECTIBLE_LOVEMELOVEMENOT )
yandereWaifu:AddCallback( ModCallbacks.MC_USE_ITEM, yandereWaifu.usedoLoveMe2, RebekahCurse.COLLECTIBLE_LOVEMELOVEMENOT2 )
yandereWaifu:AddCallback( ModCallbacks.MC_USE_ITEM, yandereWaifu.usedoLoveMe3, RebekahCurse.COLLECTIBLE_LOVEMELOVEMENOT3 )

yandereWaifu:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_,player, cacheF) --The thing the checks and updates the game, i guess?
	local data = yandereWaifu.GetEntityData(player)
	if data.PersistentPlayerData.LMLMNBuff and (player:HasCollectible(RebekahCurse.COLLECTIBLE_LOVEMELOVEMENOT) or player:HasCollectible(RebekahCurse.COLLECTIBLE_LOVEMELOVEMENOT2) or player:HasCollectible(RebekahCurse.COLLECTIBLE_LOVEMELOVEMENOT3)) then
		if data.PersistentPlayerData.LMLMNBuff == 1 then
			if cacheF == CacheFlag.CACHE_DAMAGE then
				player.Damage = player.Damage + 4

			end
		elseif data.PersistentPlayerData.LMLMNBuff == 2 then
			if cacheF == CacheFlag.CACHE_FIREDELAY then
				player.MaxFireDelay = player.MaxFireDelay - 2

			end
		elseif data.PersistentPlayerData.LMLMNBuff == 3 then
			if cacheF == CacheFlag.CACHE_SPEED then
				player.MoveSpeed = player.MoveSpeed + 0.5

			end
		elseif data.PersistentPlayerData.LMLMNBuff == 4 then
			if cacheF == CacheFlag.CACHE_RANGE then
			--player.Range = player.Range + 3.0
				player.TearHeight = player.TearHeight + 3.0
			end
		elseif data.PersistentPlayerData.LMLMNBuff == 5 then
			if cacheF == CacheFlag.CACHE_DAMAGE then
			--player.Range = player.Range + 3.0
				player.Damage = player.Damage + 6
			end
			if cacheF == CacheFlag.CACHE_FIREDELAY then
			--player.Range = player.Range + 3.0
				player.MaxFireDelay = player.MaxFireDelay - 1
			end
		elseif data.PersistentPlayerData.LMLMNBuff == 6 then
			if cacheF == CacheFlag.CACHE_FIREDELAY then
			--player.Range = player.Range + 3.0
				player.MaxFireDelay = player.MaxFireDelay - 4
			end
			if cacheF == CacheFlag.CACHE_DAMAGE then
			--player.Range = player.Range + 3.0
				player.Damage = player.Damage * 0.5
			end
		elseif data.PersistentPlayerData.LMLMNBuff == 7 then
			if cacheF == CacheFlag.CACHE_SPEED then
			--player.Range = player.Range + 3.0
				player.MoveSpeed = player.MoveSpeed + 0.8
			end
		elseif data.PersistentPlayerData.LMLMNBuff == 8 then
			if cacheF == CacheFlag.CACHE_RANGE then
			--player.Range = player.Range + 3.0
				player.TearHeight = player.TearHeight + 3.0
			end
		elseif data.PersistentPlayerData.LMLMNBuff == 9 then
			if cacheF == CacheFlag.CACHE_DAMAGE then
			--player.Range = player.Range + 3.0
				player.Damage = player.Damage + 8
			end
			if cacheF == CacheFlag.CACHE_FIREDELAY then
			--player.Range = player.Range + 3.0
				player.MaxFireDelay = player.MaxFireDelay - 1
			end
		elseif data.PersistentPlayerData.LMLMNBuff == 10 then
			if cacheF == CacheFlag.CACHE_FIREDELAY then
			--player.Range = player.Range + 3.0
				player.MaxFireDelay = player.MaxFireDelay - 4
			end
			if cacheF == CacheFlag.CACHE_DAMAGE then
			--player.Range = player.Range + 3.0
				player.Damage = player.Damage * 0.8
			end
		elseif data.PersistentPlayerData.LMLMNBuff == 11 then
			if cacheF == CacheFlag.CACHE_SPEED then
			--player.Range = player.Range + 3.0
				player.MoveSpeed = player.MoveSpeed + 1
			end
		elseif data.PersistentPlayerData.LMLMNBuff == 12 then
			if cacheF == CacheFlag.CACHE_RANGE then
			--player.Range = player.Range + 3.0
				player.TearHeight = player.TearHeight + 3.0
			end
		end
	end
end)