yandereWaifu:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, function(_, npc)
	local sprite = npc:GetSprite();
	local data = yandereWaifu.GetEntityData(npc);
	
	if data.EyesOfDeadAge then
		local text = math.floor(data.EyesOfDeadAge)
		--Isaac.RenderText(tostring(text),Isaac.WorldToScreen(npc.Position).X-7,  Isaac.WorldToScreen(npc.Position).Y-15, 1 ,1 ,1 ,1 )
		local f = Font() -- init font object
		f:Load("font/pftempestasevencondensed.fnt") -- load a font into the font object
		f:DrawString(text,Isaac.WorldToScreen(npc.Position).X-16,Isaac.WorldToScreen(npc.Position).Y+5,KColor(1,0,0,1,0,0,0),0,true)
	end
end)


yandereWaifu:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_,player)
	--local player = Isaac.GetPlayer(0);
    local room = Game():GetRoom();
	local data = yandereWaifu.GetEntityData(player)
	if player:HasCollectible(RebekahCurse.COLLECTIBLE_EYESOFTHEDEAD) then
		for i, v in pairs(Isaac.GetRoomEntities()) do
			if v:IsEnemy() then
				local vdata = yandereWaifu.GetEntityData(v)
				if not vdata.EyesOfDeadAge then 
					vdata.EyesOfDeadAge = math.random(1,300000) - ILIB.room:GetFrameCount()*10
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
				data.EyesOfDeadDamage = nil
			end
		end
	end
end)

yandereWaifu:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, damage, amount, damageFlag, damageSource, damageCountdownFrames)
	if damage:IsEnemy() then
		--print(damageSource.Entity.Type)
		--print(damageSource.Entity.SpawnerEntity.Type)
		local data = yandereWaifu.GetEntityData(damage)
		local function GrantDmg(player)
			local room = ILIB.game:GetRoom()

			if amount > damage.HitPoints and player.Damage < yandereWaifu.GetEntityData(player).PersistentPlayerData.EyeDeadDamage * 3 then
				if not yandereWaifu.GetEntityData(player).EyesOfDeadDamage then
					yandereWaifu.GetEntityData(player).EyesOfDeadDamage = (yandereWaifu.GetEntityData(damage).EyesOfDeadAge/350000)*(1+player.Damage/10)
				else
					yandereWaifu.GetEntityData(player).EyesOfDeadDamage = yandereWaifu.GetEntityData(player).EyesOfDeadDamage + (yandereWaifu.GetEntityData(damage).EyesOfDeadAge/350000)*(1+player.Damage/10)
				end
			end
		end
		if dmgFlag ~= DamageFlag.DAMAGE_POISON_BURN --[[and damageSource.Entity.SpawnerEntity]] then
			local player 
			if damageSource.Entity then
				player = damageSource.Entity:ToPlayer()
				if damageSource.Entity.SpawnerEntity then
					if damageSource.Entity.SpawnerEntity.Type == 1 then
						player = damageSource.Entity.SpawnerEntity:ToPlayer()
					end
				end
			end
			if player then
				if player:HasCollectible(RebekahCurse.COLLECTIBLE_EYESOFTHEDEAD) then
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
		if player:HasCollectible(RebekahCurse.COLLECTIBLE_EYESOFTHEDEAD) and InutilLib.HasJustPickedCollectible( player, RebekahCurse.COLLECTIBLE_EYESOFTHEDEAD ) then
			player:AddNullCostume(RebekahCurseCostumes.EyesOfTheDead)
			data.PersistentPlayerData.EyeDeadDamage = player.Damage*2
		end
	--end
end)