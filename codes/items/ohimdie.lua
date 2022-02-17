
--if has bomb item
yandereWaifu:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function(_,player)
	local data = yandereWaifu.GetEntityData(player)
	if player:HasCollectible(RebekahCurse.COLLECTIBLE_OHIMDIE) then
		if player:GetActiveCharge(ActiveSlot.SLOT_PRIMARY) or player:GetActiveCharge(ActiveSlot.SLOT_SECONDARY) or player:GetActiveCharge(ActiveSlot.SLOT_POCKET) then
		if (player:GetActiveItem(ActiveSlot.SLOT_PRIMARY) == RebekahCurse.COLLECTIBLE_OHIMDIE and InutilLib.config:GetCollectible(player:GetActiveItem(ActiveSlot.SLOT_PRIMARY)).MaxCharges == player:GetActiveCharge(ActiveSlot.SLOT_PRIMARY)) or (player:GetActiveItem(ActiveSlot.SLOT_SECONDARY) == RebekahCurse.COLLECTIBLE_OHIMDIE and InutilLib.config:GetCollectible(player:GetActiveItem(ActiveSlot.SLOT_SECONDARY)).MaxCharges == player:GetActiveCharge(ActiveSlot.SLOT_SECONDARY)) or (player:GetActiveItem(ActiveSlot.SLOT_POCKET) == RebekahCurse.COLLECTIBLE_OHIMDIE and InutilLib.config:GetCollectible(player:GetActiveItem(ActiveSlot.SLOT_POCKET)).MaxCharges == player:GetActiveCharge(ActiveSlot.SLOT_POCKET)) then
			player:AddCacheFlags(CacheFlag.CACHE_FAMILIARS);
			player:EvaluateItems()
		else
		--	data.ImDieCountdown = 0
		end
		end
	end
end)


function yandereWaifu:useimDie(collItem, rng, player, flag, slot)
	local data = yandereWaifu.GetEntityData(player)
	
	local wires = {
		"gfx/ui/wires/red.png",
		"gfx/ui/wires/blue.png",
		"gfx/ui/wires/green.png",
		"gfx/ui/wires/yellow.png"
	}
	
	data.IMDIE_MENU:UpdateOptions(wires)
	
	data.IMDIE_MENU:ToggleMenu()
	if slot == ActiveSlot.SLOT_POCKET then slot = true else slot = false end
	InutilLib.ToggleShowActive(player, false, slot)
	
	--if data.IMDIE_MENU.open then
	if data.currentIndex < 5 then
		InutilLib.RefundActiveCharge(player, 0)
	end
	--end
end
yandereWaifu:AddCallback( ModCallbacks.MC_USE_ITEM, yandereWaifu.useimDie, RebekahCurse.COLLECTIBLE_OHIMDIE);


yandereWaifu:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, function(_, player)
	local data = yandereWaifu.GetEntityData(player)
	local controller = player.ControllerIndex;
	local isDiffused = false --marks if successful diffusing
	if player:HasCollectible(RebekahCurse.COLLECTIBLE_OHIMDIE) then
		if not data.IMDIE_MENU then --set menu
			data.IMDIE_MENU = yandereWaifu.Minimenu:New("gfx/ui/none.png", Isaac.WorldToScreen(player.Position + Vector(0, -50)));
			
			data.IMDIE_MENU:AttachCallback( function(dir)
				if data.IMDIE_MENU.onRelease then
					
					--print(data.currentIndex)
					--if selected stuff code
					if dir and data.selectedImDieWire then
						if dir == data.WireCombinations[data.currentIndex] then
							if data.currentIndex < 4 then
								data.currentIndex = data.currentIndex + 1
							else
								data.WireCombinations = nil
								data.ImDieCountdown = 0
								data.currentIndex = nil
								isDiffused = true
								data.ImDiePolty:GetSprite():Play("Reward", true)
								player:SetActiveCharge(0, ActiveSlot.SLOT_PRIMARY)
								player:SetActiveCharge(0, ActiveSlot.SLOT_SECONDARY)
								player:SetActiveCharge(0, ActiveSlot.SLOT_POCKET)
							end
							player:AnimateHappy()
						else
							player:AnimateSad()
							yandereWaifu.GetEntityData(data.ImDiePolty).Mistakes = yandereWaifu.GetEntityData(data.ImDiePolty).Mistakes + 1
							data.ImDiePolty:GetSprite():Play("IdleWrong", true)
							
							SFXManager():Play(SoundEffect.SOUND_THUMBS_DOWN , 1, 0, false, 0.8 );
						end
						--if not isDiffused then
						data.IMDIE_MENU:ToggleMenu()
						--end
						data.selectedImDieWire = false
					end
				else
					--print("heelsdfd")
					if dir then --if selecting
						data.selectedImDieWire = true
					end
				end
			end)
		else
			data.IMDIE_MENU:Update( player:GetShootingInput(), Isaac.WorldToScreen(player.Position + Vector(0, -50)) )
		end
	else
		if data.IMDIE_MENU then	data.IMDIE_MENU:Remove() end
	end
end);

function yandereWaifu:ImDieInit(fam)
	if fam.Variant == RebekahCurse.ENTITY_OHIMPOLTY then --Rebecca--
		local sprite = fam:GetSprite()
		local data = yandereWaifu.GetEntityData(fam)
		sprite:Play("PickupFirst", true)
		
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, yandereWaifu.ImDieInit);

yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_,  fam) 
    local spr = fam:GetSprite()
	local data = yandereWaifu.GetEntityData(fam)
	local player = fam.Player
	player:ToPlayer()
	local playerdata = yandereWaifu.GetEntityData(player)
	
	fam:FollowParent()
	
	--fam.OrbitDistance = Vector(20, 20)
	--fam.OrbitAngleOffset = fam.OrbitAngleOffset+0.06
	--fam.Velocity = fam:GetOrbitPosition(player.Position+player.Velocity) - fam.Position
	if not playerdata.ImDiePolty then playerdata.ImDiePolty = fam end
	if not data.ImDieCountdown or data.ImDieCountdown == 0 then data.ImDieCountdown = 2000 end
	if not playerdata.WireCombinations then 
		playerdata.WireCombinations = {}
		for i = 1, 4 do
			playerdata.WireCombinations[i] = math.random(0,3)

		end
	end
	if not playerdata.currentIndex then playerdata.currentIndex = 1 end
	if not data.Mistakes then 
		data.Mistakes = 0 
		data.LastMistake = 0
	end
	
	if data.Mistakes > data.LastMistake and spr:IsFinished("IdleWrong") then
		if data.Mistakes == 1 then
			spr:Play("PickupIdle2", true)
		elseif data.Mistakes == 2 then
			spr:Play("PickupIdle3", true)
		elseif data.Mistakes == 3 then
			spr:Play("Throw", true)
		end
	end
	
	--print( TableLength(playerdata.WireCombinations) )
	
	if data.ImDieCountdown > 100 then
		if data.ImDieCountdown%100 == 0 then
			spr.Color = Color(1,0,0,1)
			SFXManager():Play( RebekahCurseSounds.SOUND_IMDIEBEEP , 1, 0, false, 1.2 )
			for i = 1, 4 do

				InutilLib.SetTimer( i*60, function()
					if player:HasCollectible(RebekahCurse.COLLECTIBLE_OHIMDIE) and fam and not fam:IsDead() then
						if (player:GetActiveItem(ActiveSlot.SLOT_PRIMARY) == RebekahCurse.COLLECTIBLE_OHIMDIE and InutilLib.config:GetCollectible(player:GetActiveItem(ActiveSlot.SLOT_PRIMARY)).MaxCharges == player:GetActiveCharge(ActiveSlot.SLOT_PRIMARY)) or (player:GetActiveItem(ActiveSlot.SLOT_SECONDARY) == RebekahCurse.COLLECTIBLE_OHIMDIE and InutilLib.config:GetCollectible(player:GetActiveItem(ActiveSlot.SLOT_SECONDARY)).MaxCharges == player:GetActiveCharge(ActiveSlot.SLOT_SECONDARY)) or (player:GetActiveItem(ActiveSlot.SLOT_POCKET) == RebekahCurse.COLLECTIBLE_OHIMDIE and InutilLib.config:GetCollectible(player:GetActiveItem(ActiveSlot.SLOT_POCKET)).MaxCharges == player:GetActiveCharge(ActiveSlot.SLOT_POCKET)) then
							local target = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_PINGEFFECT, playerdata.WireCombinations[i], fam.Position, Vector.Zero, player)
						end
					end
				end);
			end
		else
			spr.Color = Color(1,1,1,1)
		end
	else
		if data.ImDieCountdown%2 == 0 then
			spr.Color = Color(1,0,0,1)
			SFXManager():Play( RebekahCurseSounds.SOUND_IMDIEBEEP , 1, 0, false, 1.2 )
		else
			spr.Color = Color(1,1,1,1)
		end
	end
	
	data.ImDieCountdown = data.ImDieCountdown - 1
	
	if spr:IsFinished("PickupFirst") then
		spr:Play("PickupIdle", true)
	end
	
	if data.ImDieCountdown == 0 and not spr:IsPlaying("Throw") then
		spr:Play("Throw", true)
	end
	
	local function RemoveStuff()
		playerdata.WireCombinations = nil
		data.ImDieCountdown = 0
		playerdata.currentIndex = nil
		playerdata.ImDiePolty = nil
	end
	
	if spr:IsPlaying("Throw") then
		if spr:IsEventTriggered("PickupThrow") then
			local bomb = Isaac.Spawn(EntityType.ENTITY_BOMBDROP, BombVariant.BOMB_GIGA, 0, fam.Position,  Vector.Zero, nil):ToBomb();
			bomb.ExplosionDamage = 5
			bomb:SetExplosionCountdown(0)
			player:RemoveCollectible(RebekahCurse.COLLECTIBLE_OHIMDIE, false, ActiveSlot.SLOT_PRIMARY)
			player:RemoveCollectible(RebekahCurse.COLLECTIBLE_OHIMDIE, false, ActiveSlot.SLOT_SECONDARY)
			player:RemoveCollectible(RebekahCurse.COLLECTIBLE_OHIMDIE, false, ActiveSlot.SLOT_POCKET)
			fam:Kill()
			RemoveStuff()
		end
	end
	
	if spr:IsPlaying("Reward") then
		if spr:IsEventTriggered("PickupThrow") then
			if ILIB.room:IsClear() then
				local hasItems = false
				for i, ent in pairs (Isaac.GetRoomEntities()) do
					if ent.Type == 5 and ent.Variant == 100 then
						if math.random(1,4) == 4 then
							local bomb = Isaac.Spawn(EntityType.ENTITY_PICKUP, 100, ent.SubType, ILIB.room:FindFreePickupSpawnPosition(ent.Position, 1),  Vector.Zero, nil):ToBomb();
						else
							local rng = math.random(1,3)
							if rng == 1 then
								local pickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_SOUL, ILIB.room:FindFreePickupSpawnPosition(ent.Position, 1),  Vector.Zero, nil):ToPickup();
							elseif rng == 2 then
								local pickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_BLACK, ILIB.room:FindFreePickupSpawnPosition(ent.Position, 1),  Vector.Zero, nil):ToPickup();
							elseif rng == 3 then
								local pickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_GOLDEN, ILIB.room:FindFreePickupSpawnPosition(ent.Position, 1),  Vector.Zero, nil):ToPickup();
							end
						end
						hasItems = true
					elseif ent.Type == 5 and not ent.Variant == 100 then
						local rng = math.random(1,3)
						if rng == 1 then
							local pickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF_SOUL, ILIB.room:FindFreePickupSpawnPosition(ent.Position, 1),  Vector.Zero, nil):ToPickup();
						elseif rng == 2 then
							local pickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_BLENDED, ILIB.room:FindFreePickupSpawnPosition(ent.Position, 1),  Vector.Zero, nil):ToPickup();
						elseif rng == 3 then
							local pickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_ROTTEN, ILIB.room:FindFreePickupSpawnPosition(ent.Position, 1),  Vector.Zero, nil):ToPickup();
						end
						hasItems = true
					end
				end
				if not hasItems then
					for i = 1, 5 do
						local item = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, 0, ILIB.room:FindFreePickupSpawnPosition(fam.Position, 1), Vector(0,0), nil) --body effect
					end
				end
			else
				local rng = math.random(1,4)
				if rng == 1 then
					for j = 1, math.random(9,18) do
						local pickup = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLUE_FLY, 0, fam.Position,  Vector.Zero, player):ToPickup();
					end
				elseif rng == 2 then
					for j = 1, math.random(9,18) do
						local pickup = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLUE_SPIDER, 0, fam.Position,  Vector.Zero, player):ToPickup();
					end
				elseif rng == 3 then
					for j = 1, math.random(3,5) do
						local pickup = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.MINISAAC, 0, fam.Position,  Vector.Zero, player):ToPickup();
					end
				elseif rng == 4 then
					for j = 1, math.random(3,5) do
						local pickup = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PURGATORY, 0, fam.Position,  Vector.Zero, player):ToPickup();
					end
				end
			end
		end
	end
	
	if spr:IsFinished("Reward") then
		fam:Kill()
		RemoveStuff()
	end
	
end, RebekahCurse.ENTITY_OHIMPOLTY);

function yandereWaifu:ImDiePoltyCache(player, cacheF) --The thing the checks and updates the game, i guess?
	local data = yandereWaifu.GetEntityData(player)
	if cacheF == CacheFlag.CACHE_FAMILIARS then  -- Especially here!
		if player:HasCollectible(RebekahCurse.COLLECTIBLE_OHIMDIE) then
			if InutilLib.config:GetCollectible(player:GetActiveItem(ActiveSlot.SLOT_PRIMARY)).MaxCharges == player:GetActiveCharge(ActiveSlot.SLOT_PRIMARY) or  InutilLib.config:GetCollectible(player:GetActiveItem(ActiveSlot.SLOT_SECONDARY)).MaxCharges == player:GetActiveCharge(ActiveSlot.SLOT_SECONDARY) or InutilLib.config:GetCollectible(player:GetActiveItem(ActiveSlot.SLOT_POCKET)).MaxCharges == player:GetActiveCharge(ActiveSlot.SLOT_POCKET) then
				player:CheckFamiliar(RebekahCurse.ENTITY_OHIMPOLTY, player:GetCollectibleNum(RebekahCurse.COLLECTIBLE_OHIMDIE), RNG())
			end
		end
	end
		
end
yandereWaifu:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, yandereWaifu.ImDiePoltyCache)