
yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_,  fam) 
    local spr = fam:GetSprite()
	local data = yandereWaifu.GetEntityData(fam)
	local player = fam.Player
	player:ToPlayer()
	local playerdata = yandereWaifu.GetEntityData(player)
	
	--bffs! synergy
	local extraDmg = 1
	local extraFireDelay = false
	if player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
		extraDmg = 2
	end
	if player:HasTrinket(TrinketType.TRINKET_FORGOTTEN_LULLABY) then
		extraFireDelay = true
	end
	
	if not data.Init then
		fam:AddToFollowers()
		data.Init = true
		data.State = 0
	end
	if fam.SubType == 1 then
		if fam.Coins >= 3 then
			Isaac.Spawn( EntityType.ENTITY_EFFECT, EffectVariant.DIRT_PILE, 0, player.Position,  Vector(0,0), player );
			fam.Coins = 0
			local newColl = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Card.CARD_CRACKED_KEY, InutilLib.room:FindFreePickupSpawnPosition(fam.Position, 40, true), Vector.Zero, fam)
		end
	end
	fam.Velocity = fam.Velocity * 0.9
	local enemy = InutilLib.GetClosestGenericEnemy(fam, 500, fam.Type)
	if enemy then
		if data.State == 0 then --idle
			if math.random(1,5) == 5 and fam.FrameCount % 15 == 0 then
				data.State = 1
			elseif not spr:IsPlaying("Triggered") then
				spr:Play("Triggered", true)
				if math.random(1,3) == 3 then
					InutilLib.SFX:Play(SoundEffect.SOUND_DOG_BARK, 1, 0, false, 0.8)
				end
			end
			if enemy.Position:Distance(fam.Position) > 90 then
				InutilLib.MoveDirectlyTowardsTarget(fam, enemy, 2, 0.9)
			else
				fam.Velocity = fam.Velocity * 0.3
			--	InutilLib.MoveOrbitAroundTargetType1(fam, player, 4, 0.9, 2, 0)
			end
			if not data.ColorTint then
				data.ColorTint = 0.1
			end
			if data.ColorTint < 0.5 then
				data.ColorTint = data.ColorTint + .1
			end
			fam:SetColor(Color(1-data.ColorTint,1-data.ColorTint,1-data.ColorTint,1-data.ColorTint,0,0,0),3,1,false,false)
		elseif data.State == 1 then --attack
			if spr:IsFinished("Bite") then
				data.State = 0
			elseif not spr:IsPlaying("Bite") then
				spr:Play("Bite", true)
				data.ColorTint = nil
				if math.random(1,3) == 3 then
					InutilLib.SFX:Play(SoundEffect.SOUND_DOG_HOWELL, 1, 0, false, 0.8)
				end
			elseif spr:IsPlaying("Bite") then
				if spr:IsEventTriggered("Dash") and not spr:IsEventTriggered("Bite") then
					InutilLib.MoveDirectlyTowardsTarget(fam, enemy, 12, 0.9)
				elseif spr:IsEventTriggered("Bite") then
					fam.Velocity = fam.Velocity * 0.9
					local ents = Isaac.FindInRadius(fam.Position, 75, EntityPartition.ENEMY)
					for _, ent in pairs(ents) do
						if ent:IsVulnerableEnemy() and not ent:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
							ent:TakeDamage(7, 0, EntityRef(player), 5)
							ent:AddEntityFlags(EntityFlag.FLAG_WEAKNESS)
							yandereWaifu.GetEntityData(ent).IsWeakenedByEnchiridion = 60
						end
					end
					InutilLib.game:MakeShockwave(fam.Position, 0.035, 0.025, 10)
				end
			end
		end
	else
		local pos = player.Position
		if pos and pos:Distance(fam.Position) > 100 then
			InutilLib.MoveRandomlyTypeI(fam, pos, 2.5, 0.9, 0, 0, 0)
		end
		if not spr:IsPlaying("Idle") then
			spr:Play("Idle", true)
		end
		data.State = 0
	end
	if not spr:IsOverlayPlaying("Hands") then
		spr:PlayOverlay("Hands", true)
	end
	InutilLib.FlipXByVec(fam, false)
end, RebekahCurse.ENTITY_FENRIR);

function yandereWaifu:FenrirPuppyInit(fam)
    local sprite = fam:GetSprite()
	
	local data = yandereWaifu.GetEntityData(fam)
	--[[data.Stat = {
		FireDelay = 25,
		MaxFireDelay = 25,
		Damage = 2.2, 
		PlayerMaxDelay = 0
		
	}]]
	if fam.SubType == 1 then
		fam:GetSprite():ReplaceSpritesheet(0, "gfx/familiar/fenrir_dead.png")
		fam:GetSprite():ReplaceSpritesheet(1, "gfx/familiar/fenrir_dead.png")
		fam:GetSprite():LoadGraphics()
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, yandereWaifu.FenrirPuppyInit, RebekahCurse.ENTITY_FENRIR);


yandereWaifu:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function(_,player)
	local data = yandereWaifu.GetEntityData(player)
	--[[if player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_FENRIRSLEASH) and InutilLib.HasJustPickedCollectible(RebekahCurse.Items.COLLECTIBLE_FENRIRSLEASH) then
		player:AddCacheFlags(CacheFlag.CACHE_FAMILIARS);
		player:EvaluateItems()
	end]]
end)

function yandereWaifu:FenrirPuppyCache(player, cacheF) --The thing the checks and updates the game, i guess?
	local data = yandereWaifu.GetEntityData(player)
	if cacheF == CacheFlag.CACHE_FAMILIARS then  -- Especially here!
		if player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_FENRIRSLEASH) then
			player:CheckFamiliar(RebekahCurse.ENTITY_FENRIR, player:GetCollectibleNum(RebekahCurse.Items.COLLECTIBLE_FENRIRSLEASH) + player:GetEffects():GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_BOX_OF_FRIENDS), RNG(), InutilLib.config:GetCollectible(RebekahCurse.Items.COLLECTIBLE_FENRIRSLEASH))
		end
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, yandereWaifu.FenrirPuppyCache)