
yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_,  fam) 
    local spr = fam:GetSprite()
	local data = yandereWaifu.GetEntityData(fam)
	local player = fam.Player
	player:ToPlayer()
	local playerdata = yandereWaifu.GetEntityData(player)
	
	
	if not data.Init then
		fam:AddToFollowers()
		data.Init = true
		data.State = 0
	end
	fam.Velocity = fam.Velocity * 0.9
	if data.State == 0 then --idle
		--if not spr:IsPlaying("FloatDown") then spr:Play("FloatDown") end
		fam:FollowParent()
		if fam.FrameCount % 15 == 0 and math.random(1,5) == 5 then
			for k, v in pairs (Isaac.GetRoomEntities()) do
				if v:HasEntityFlags(EntityFlag.FLAG_FEAR) then
					data.target = v
					data.State = 1
					break
				end
			end
		end
		if data.Stat.FireDelay > 0 then data.Stat.FireDelay = data.Stat.FireDelay - 1 end
	
		local playerDir = player:GetFireDirection()
		if playerDir > -1 then
			if not data.lastDir or (playerDir ~= data.lastDir) then
				InutilLib.AnimShootFrame(fam, true, InutilLib.DirToVec(playerDir), "FloatShootSide", "FloatShootDown", "FloatShootUp", "FloatShootSide2")
				data.lastDir = playerDir
			end
			if not data.lastDir then data.lastDir = playerDir end
			--if firedelay is ready then
			if data.Stat.FireDelay <= 0 then
				if fam:GetEntityFlags() & EntityFlag.FLAG_CHARM == EntityFlag.FLAG_CHARM then
				else
					local tears = player:FireTear(fam.Position, InutilLib.DirToVec(playerDir), false, false, false):ToTear()
					tears.Position = fam.Position
					tears.CollisionDamage = data.Stat.Damage
					tears:ChangeVariant(TearVariant.DARK_MATTER)
					tears:AddTearFlags(TearFlags.TEAR_FEAR)
				end
				data.Stat.FireDelay = data.Stat.MaxFireDelay
			end
			
			if player:HasTrinket(TrinketType.TRINKET_FORGOTTEN_LULLABY) then --balance purposes. They are so broken if I don't do this
				data.Stat.MaxFireDelay = 15
			else
				data.Stat.MaxFireDelay = 25
			end
		else
			if not spr:IsPlaying("FloatDown") then spr:Play("FloatDown") end
			data.lastDir = nil
		end
	elseif data.State == 1 then
		if spr:IsFinished("Warp") then
			data.State = 2
		elseif not spr:IsPlaying("Warp") then
			spr:Play("Warp", true)
			fam.Velocity = Vector.Zero
			InutilLib.SFX:Play(RebekahCurseSounds.SOUND_PSALM23UTTER, 1.2, 0, false, 0.8)
			data.lastDir = nil
			ILIB.game:Darken(2, 35)
		end
	elseif data.State == 2 then
		if spr:IsFinished("Grab") then
			data.State = 3
			if not data.target:IsDead() then
				if data.target:IsBoss() then
					data.target:TakeDamage(45, 0, EntityRef(fam), 1)
				else
					data.target:Kill()
				end
			end
		elseif not spr:IsPlaying("Grab") then
			spr:Play("Grab", true)
			fam.Position = data.target.Position
			data.PreviousColor = data.target.Color
		end
		if spr:WasEventTriggered("Grabbed") then
			data.target.Position = fam.Position
		end
		if spr:WasEventTriggered("Finish") then
			if not data.decreaseTint then data.decreaseTint = 0 end
			data.target:SetColor(Color(1-data.decreaseTint,1-data.decreaseTint,1-data.decreaseTint,1-data.decreaseTint,0,0,0),2,99,false,false);
			data.decreaseTint= data.decreaseTint + 1
		end
		if spr:IsEventTriggered("Finish") then
			local mob = Isaac.Spawn( EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_BEAUTIFULGRAVEDROP, 0, fam.Position, Vector.Zero, fam );
			InutilLib.SFX:Play(SoundEffect.SOUND_FORESTBOSS_STOMPS, 1, 0, false, 0.8)
			local dust = Isaac.Spawn( EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 2, fam.Position, Vector(0,0), player );
		end
	elseif data.State == 3 then
		if spr:IsFinished("WarpBack") then
			data.State = 0
		elseif not spr:IsPlaying("WarpBack") then
			spr:Play("WarpBack", true)
			InutilLib.SFX:Play(RebekahCurseSounds.SOUND_PSALM23UTTER, 1.2, 0, false, 0.8)
		end
	end
end, RebekahCurse.ENTITY_GRAVEBABY);

function yandereWaifu:GraveBabyInit(fam)
    local sprite = fam:GetSprite()
	
	local data = yandereWaifu.GetEntityData(fam)
	data.Stat = {
		FireDelay = 25,
		MaxFireDelay = 25,
		Damage = 2.2, 
		PlayerMaxDelay = 0
	}
end
yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, yandereWaifu.GraveBabyInit, RebekahCurse.ENTITY_GRAVEBABY);


yandereWaifu:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function(_,player)
	local data = yandereWaifu.GetEntityData(player)
	--[[if player:HasCollectible(RebekahCurse.COLLECTIBLE_ABEAUTIFULGRAVE) and InutilLib.HasJustPickedCollectible(RebekahCurse.COLLECTIBLE_ABEAUTIFULGRAVE) then
		player:AddCacheFlags(CacheFlag.CACHE_FAMILIARS);
		player:EvaluateItems()
	end]]
end)

function yandereWaifu:GraveBabyCache(player, cacheF) --The thing the checks and updates the game, i guess?
	local data = yandereWaifu.GetEntityData(player)
	if cacheF == CacheFlag.CACHE_FAMILIARS then  -- Especially here!
		if player:HasCollectible(RebekahCurse.COLLECTIBLE_ABEAUTIFULGRAVE) then
			player:CheckFamiliar(RebekahCurse.ENTITY_GRAVEBABY, player:GetCollectibleNum(RebekahCurse.COLLECTIBLE_ABEAUTIFULGRAVE) + player:GetEffects():GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_BOX_OF_FRIENDS), RNG())
		end
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, yandereWaifu.GraveBabyCache)