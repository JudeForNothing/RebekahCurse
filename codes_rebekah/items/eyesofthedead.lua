yandereWaifu:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, function(_, npc)
	local sprite = npc:GetSprite();
	local data = yandereWaifu.GetEntityData(npc);
	
	if data.EyesOfDeadAge then
		local text = math.floor(data.EyesOfDeadAge)
		local rng = math.random(1,10)
		if rng == 10 then
			data.eyecolor = KColor(0,0,0,1,0,0,0)
		else
			if math.random(1,30) == 30 then
				data.eyecolor = KColor(1,1,1,1,0,0,0)
			else
				data.eyecolor = KColor(1,0,0,1,0,0,0)
			end
		end
		if npc.FrameCount % 15 == 0 then
			data.eyerenderx = math.random(6,12)/10
			data.eyerendery = math.random(8,12)/10
			data.eyeoffset = math.random(-5,5)
		end
		if not data.eyerenderx then
			data.eyerenderx = math.random(6,12)/10
			data.eyerendery = math.random(8,12)/10
			data.eyeoffset = math.random(-5,5)
		end
		--Isaac.RenderText(tostring(text),Isaac.WorldToScreen(npc.Position).X-7,  Isaac.WorldToScreen(npc.Position).Y-15, 1 ,1 ,1 ,1 )
		local f = Font() -- init font object
		f:Load("font/pftempestasevencondensed.fnt") -- load a font into the font object
		f:DrawStringScaled (text,Isaac.WorldToScreen(npc.Position).X-16-data.eyeoffset,Isaac.WorldToScreen(npc.Position).Y+5-data.eyeoffset, data.eyerenderx, data.eyerendery, data.eyecolor,0,true)
	end
end)


yandereWaifu:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_,player)
	--local player = Isaac.GetPlayer(0);
    local room = Game():GetRoom();
	local data = yandereWaifu.GetEntityData(player)
	if player:HasCollectible(RebekahCurseItems.COLLECTIBLE_EYESOFTHEDEAD) then
		for i, v in pairs(Isaac.GetRoomEntities()) do
			if v:IsEnemy() and v:IsActiveEnemy() then
				local vdata = yandereWaifu.GetEntityData(v)
				if not vdata.EyesOfDeadAge then 
					vdata.EyesOfDeadAge = math.random(1,200000+20*v.MaxHitPoints/10) - ILIB.room:GetFrameCount()*10
					vdata.EyesOfDeadPlayer = player
				end
			end
		end
		if data.EyesOfDeadDamage then
			player:AddCacheFlags(CacheFlag.CACHE_DAMAGE);
			player:EvaluateItems()
			if data.EyesOfDeadDamage > 0 then
				if player.FrameCount % 3 == 0 then
					data.EyesOfDeadDamage = data.EyesOfDeadDamage - 0.01 * (1+player.Damage/10)
				end
			else
				data.EyesOfDeadDamage = 0
			end
		end
		if data.EyesOfDeadDamage and data.PersistentPlayerData.EyeDeadDamage/2 < player.Damage - data.EyesOfDeadDamage then
			data.PersistentPlayerData.EyeDeadDamage =  player.Damage*2
		end
	end
end)

function yandereWaifu:EyeoftheDeadNewLevel()
	local room = Game():GetRoom();
	for p = 0, ILIB.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		local data = yandereWaifu.GetEntityData(player)
		if data.EyesOfDeadDamage then
			data.EyesOfDeadDamage = 0
		end
	end
end

yandereWaifu:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, yandereWaifu.EyeoftheDeadNewLevel)

yandereWaifu:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, damage, amount, damageFlag, damageSource, damageCountdownFrames)
	if damage:IsEnemy() and damage:IsActiveEnemy() then
		--print(damageSource.Entity.Type)
		--print(damageSource.Entity.SpawnerEntity.Type)
		local data = yandereWaifu.GetEntityData(damage)
		local function GrantDmg(player)
			player = player:ToPlayer()
			local room = ILIB.game:GetRoom()
			if amount > damage.HitPoints and player.Damage < yandereWaifu.GetEntityData(player).PersistentPlayerData.EyeDeadDamage * 1.5 then
				if not yandereWaifu.GetEntityData(player).EyesOfDeadDamage then
					yandereWaifu.GetEntityData(player).EyesOfDeadDamage = (yandereWaifu.GetEntityData(damage).EyesOfDeadAge/350000)*(1+player.Damage/10)
				else
					yandereWaifu.GetEntityData(player).EyesOfDeadDamage = yandereWaifu.GetEntityData(player).EyesOfDeadDamage + (yandereWaifu.GetEntityData(damage).EyesOfDeadAge/350000)*(1+player.Damage/10)
				end
			end
		end
		if dmgFlag ~= DamageFlag.DAMAGE_POISON_BURN --[[and damageSource.Entity.SpawnerEntity]] then
			local player = InutilLib.GetPlayerFromDmgSrc(damageSource)
			if player then
				if player:HasCollectible(RebekahCurseItems.COLLECTIBLE_EYESOFTHEDEAD) then
					GrantDmg(player)
				end
			end
		end
	end
end)

function yandereWaifu:EyeOfDeadCache(player, cacheF) --The thing the checks and updates the game, i guess?
	local data = yandereWaifu.GetEntityData(player)
	if data.EyesOfDeadDamage then
		if cacheF == CacheFlag.CACHE_DAMAGE then
			if data.EyesOfDeadDamage > 0 then
				player.Damage = player.Damage + data.EyesOfDeadDamage
			else
				player.Damage = player.Damage
			end
		end
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, yandereWaifu.EyeOfDeadCache)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_,player)
	--local player = Isaac.GetPlayer(0);
    local room = Game():GetRoom();
	local data = yandereWaifu.GetEntityData(player)
	--items function!
		if player:HasCollectible(RebekahCurseItems.COLLECTIBLE_EYESOFTHEDEAD) and InutilLib.HasJustPickedCollectible( player, RebekahCurseItems.COLLECTIBLE_EYESOFTHEDEAD ) then
			player:AddNullCostume(RebekahCurseCostumes.EyesOfTheDead)
			data.PersistentPlayerData.EyeDeadDamage = player.Damage*2
		end
	--end
end)