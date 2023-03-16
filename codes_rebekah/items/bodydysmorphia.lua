local usedBodyDysmorphia = false
yandereWaifu:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	usedBodyDysmorphia = false
end)

function yandereWaifu:useBodyDysmorphia(collItem, rng, player, flag, slot)
	local data = yandereWaifu.GetEntityData(player)
	
	if data.lastActiveUsedFrameCount then
		if InutilLib.game:GetFrameCount() == data.lastActiveUsedFrameCount then
			return
		end
						
		data.lastActiveUsedFrameCount = InutilLib.game:GetFrameCount()
	else
		data.lastActiveUsedFrameCount = InutilLib.game:GetFrameCount()
	end
	if not usedBodyDysmorphia then
		InutilLib.AnimateGiantbook("gfx/ui/giantbook/giantbook_bodydysmorphia.png", nil, "Shake", _, true)
		usedBodyDysmorphia = true
	end
	player:AnimateCollectible(collItem)
	if not data.PersistentPlayerData.DysmorphiaUses then 
		data.PersistentPlayerData.DysmorphiaUses = 1
	else
		data.PersistentPlayerData.DysmorphiaUses = data.PersistentPlayerData.DysmorphiaUses + 3
	end
	for i = 0, math.random(1,2) do
		local rng = math.random(1,5)
		if rng == 1 and data.PersistentPlayerData.BDBuffDamage < 10 then
			data.PersistentPlayerData.BDBuffDamage = data.PersistentPlayerData.BDBuffDamage + 0.5
		elseif rng == 2 and data.PersistentPlayerData.BDBuffLuck < 5 then
			data.PersistentPlayerData.BDBuffLuck = data.PersistentPlayerData.BDBuffLuck + 2
		elseif rng == 3 and data.PersistentPlayerData.BDBuffRange < 10 then
			data.PersistentPlayerData.BDBuffRange = data.PersistentPlayerData.BDBuffRange + 1
		elseif rng == 4 and data.PersistentPlayerData.BDBuffShotSpeed < 5 then
			data.PersistentPlayerData.BDBuffShotSpeed = data.PersistentPlayerData.BDBuffShotSpeed + 1
		elseif rng == 5 and data.PersistentPlayerData.BDBuffSpeed < 10 then
			data.PersistentPlayerData.BDBuffSpeed = data.PersistentPlayerData.BDBuffSpeed + 0.5
		end
	end
	
	player:AddCacheFlags(CacheFlag.CACHE_ALL);
	player:EvaluateItems();

	player:AddNullCostume(RebekahCurseCostumes.BodyDysmorphia)

	if not data.BodyDysmorphiaAura then
		data.BodyDysmorphiaAura = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_BODYDYSMORPHIAAURA, 0, player.Position, Vector(0,0), player)
		yandereWaifu.GetEntityData(data.BodyDysmorphiaAura).Player = player
		yandereWaifu.GetEntityData(data.BodyDysmorphiaAura).SpriteScale = data.PersistentPlayerData.DysmorphiaUses
	end
	
	--if data.BODYDYSMORPHIA_MENU.open then
	--end
end
yandereWaifu:AddCallback( ModCallbacks.MC_USE_ITEM, yandereWaifu.useBodyDysmorphia, RebekahCurseItems.COLLECTIBLE_BODYDYSMORHIA);

yandereWaifu:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function(_, player)
	local data = yandereWaifu.GetEntityData(player)
	if not data.PersistentPlayerData then return end
	if data.PersistentPlayerData.BDBuffDamage or data.PersistentPlayerData.BDBuffFireDelay or data.PersistentPlayerData.BDBuffLuck or
	data.PersistentPlayerData.BDBuffRange or data.PersistentPlayerData.BDBuffShotSpeed or data.PersistentPlayerData.BDBuffSpeed then
		if player.FrameCount % 30 == 0 then
			if data.PersistentPlayerData.BDBuffDamage > 0 then data.PersistentPlayerData.BDBuffDamage = data.PersistentPlayerData.BDBuffDamage - 0.1 end
			
			if data.PersistentPlayerData.BDBuffLuck > 0 then data.PersistentPlayerData.BDBuffLuck = data.PersistentPlayerData.BDBuffLuck - 0.1 end
			if data.PersistentPlayerData.BDBuffRange > 0 then data.PersistentPlayerData.BDBuffRange = data.PersistentPlayerData.BDBuffRange - 0.1 end
			if data.PersistentPlayerData.BDBuffShotSpeed > 0 then data.PersistentPlayerData.BDBuffShotSpeed = data.PersistentPlayerData.BDBuffShotSpeed - 0.1 end
			if data.PersistentPlayerData.BDBuffSpeed > 0 then data.PersistentPlayerData.BDBuffSpeed = data.PersistentPlayerData.BDBuffSpeed - 0.1 end
			player:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_SHOTSPEED | CacheFlag.CACHE_SPEED | CacheFlag.CACHE_RANGE | CacheFlag.CACHE_LUCK);
			player:EvaluateItems();
		end
		if math.floor(player.FrameCount % 200) == 0 then
			if data.PersistentPlayerData.DysmorphiaUses and data.PersistentPlayerData.DysmorphiaUses >= 0 then 
				if data.PersistentPlayerData.DysmorphiaUses > 0 then 
					data.PersistentPlayerData.DysmorphiaUses = data.PersistentPlayerData.DysmorphiaUses - 1 
					yandereWaifu.GetEntityData(data.BodyDysmorphiaAura).SpriteScale = data.PersistentPlayerData.DysmorphiaUses
				end
				player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY);
				player:EvaluateItems();
			end
		end
		if data.PersistentPlayerData.DysmorphiaUses and data.PersistentPlayerData.DysmorphiaUses > 0 then
			local closestEnemy = InutilLib.GetClosestGenericEnemy(player, 10 + data.PersistentPlayerData.DysmorphiaUses*30)
			if closestEnemy and player.FrameCount % 30 == 0 then
				data.BDAddFearFrames = 20
				InutilLib.game:ShakeScreen(5)
				SFXManager():Play( SoundEffect.SOUND_SCARED_WHIMPER, 5, 0, false, 0.8 );
			end
			data.BDDidRemoveCostume = false
			if not data.BodyDysmorphiaAura or not data.BodyDysmorphiaAura:Exists() then
				data.BodyDysmorphiaAura = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_BODYDYSMORPHIAAURA, 0, player.Position, Vector(0,0), player)
				yandereWaifu.GetEntityData(data.BodyDysmorphiaAura).Player = player
				yandereWaifu.GetEntityData(data.BodyDysmorphiaAura).SpriteScale = data.PersistentPlayerData.DysmorphiaUses
			end
		elseif data.PersistentPlayerData.DysmorphiaUses and data.PersistentPlayerData.DysmorphiaUses <= 0 and not data.BDDidRemoveCostume then
			player:TryRemoveNullCostume(RebekahCurseCostumes.BodyDysmorphia)
			data.BDDidRemoveCostume = true
			data.BodyDysmorphiaAura:Remove()
		end
		if data.BDAddFearFrames then
			if data.BDAddFearFrames > 0 then
				data.BDAddFearFrames = data.BDAddFearFrames - 1
				player:AddFear(EntityRef(player), 1)
			end
		end
	end
end)

yandereWaifu:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_,player, cacheF) --The thing the checks and updates the game, i guess?
	local data = yandereWaifu.GetEntityData(player)
	if data.PersistentPlayerData then
		if not data.PersistentPlayerData.BDBuffSpeed then data.PersistentPlayerData.BDBuffSpeed = 0 end
		if not data.PersistentPlayerData.BDBuffFireDelay then data.PersistentPlayerData.BDBuffFireDelay = 0 end
		if not data.PersistentPlayerData.BDBuffDamage then data.PersistentPlayerData.BDBuffDamage = 0 end
		if not data.PersistentPlayerData.BDBuffShotSpeed then data.PersistentPlayerData.BDBuffShotSpeed = 0 end
		if not data.PersistentPlayerData.BDBuffLuck then data.PersistentPlayerData.BDBuffLuck = 0 end
		if not data.PersistentPlayerData.BDBuffRange then data.PersistentPlayerData.BDBuffRange = 0 end
	
		if cacheF == CacheFlag.CACHE_SPEED then
			player.MoveSpeed = player.MoveSpeed + 0.05*data.PersistentPlayerData.BDBuffSpeed
		end
		if cacheF == CacheFlag.CACHE_DAMAGE then
			player.Damage = player.Damage + 0.5*data.PersistentPlayerData.BDBuffDamage
		end
		if cacheF == CacheFlag.CACHE_SHOTSPEED then
			player.ShotSpeed = player.ShotSpeed + 0.05*data.PersistentPlayerData.BDBuffShotSpeed
		end
		if cacheF == CacheFlag.CACHE_LUCK then
			player.Luck = player.Luck + 0.5*data.PersistentPlayerData.BDBuffRange
		end
		if cacheF == CacheFlag.CACHE_RANGE then
			player.TearRange = player.TearRange + 2*data.PersistentPlayerData.BDBuffRange
		end
		if cacheF == CacheFlag.CACHE_FIREDELAY and data.PersistentPlayerData.DysmorphiaUses then
			for i = 1, data.PersistentPlayerData.DysmorphiaUses do
				player.MaxFireDelay = player.MaxFireDelay*0.8
			end
			--player.MaxFireDelay = player.MaxFireDelay - 0.5*data.PersistentPlayerData.BDBuffFireDelay
		end
	end
end)



yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local sprite = eff:GetSprite()
	local data = yandereWaifu.GetEntityData(eff)
	local player = data.Player
	
	local room =  Game():GetRoom()
	
	--function code
	if not sprite:IsPlaying("Glow") then
		sprite:Play("Glow")
		eff.RenderZOffset = 1000000
	end 
	
	if player then
		eff.Position = player.Position

		if data.SpriteScale then
			eff.SpriteScale = Vector(data.SpriteScale*0.5, data.SpriteScale*0.5)
		end
	end
end, RebekahCurse.ENTITY_BODYDYSMORPHIAAURA)

