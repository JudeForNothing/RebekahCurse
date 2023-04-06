
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
		data.FillState = 0
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
		--fill render
		if data.FillState then
			local anim = "Idle" .. tostring(data.FillState)
			if not spr:IsPlaying(anim) then
				spr:Play(anim, true)
			end
		end
		local playerDir = player:GetFireDirection()
		if playerDir > -1 then
			if not data.lastDir or (playerDir ~= data.lastDir) then
				--InutilLib.AnimShootFrame(fam, true, InutilLib.DirToVec(playerDir), "FloatShootSide", "FloatShootDown", "FloatShootUp", "FloatShootSide2")
				data.lastDir = playerDir
			end
			if not data.lastDir then data.lastDir = playerDir end
			--if firedelay is ready then
			if data.Stat.FireDelay <= 0 then
				if data.FillState >= 8 then
					data.State = 1
					data.FillState = 0
				else
				
					if fam:GetEntityFlags() & EntityFlag.FLAG_CHARM == EntityFlag.FLAG_CHARM then
					else
						local tears = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0, fam.Position, InutilLib.DirToVec(playerDir), fam):ToTear()
						--local tears = player:FireTear(fam.Position, InutilLib.DirToVec(playerDir), false, false, false):ToTear()
						tears.Position = fam.Position
						tears.CollisionDamage = data.Stat.Damage * extraDmg
						if player:HasTrinket(TrinketType.TRINKET_BABY_BENDER) then
							tears:AddTearFlags(TearFlags.TEAR_HOMING)
							tears.Color = Color(1,0,1,1)
						end
					end
					data.Stat.FireDelay = data.Stat.MaxFireDelay

					data.FillState = data.FillState + 1
				end
			end
			
			if player:HasTrinket(TrinketType.TRINKET_FORGOTTEN_LULLABY) then --balance purposes. They are so broken if I don't do this
				data.Stat.MaxFireDelay = 15
			else
				data.Stat.MaxFireDelay = 25
			end
		else
			data.lastDir = nil
		end
	elseif data.State == 1 then --splash
		if spr:IsFinished("Burst") then
			data.State = 0
		elseif not spr:IsPlaying("Burst") then
			spr:Play("Burst", true)
		elseif spr:IsEventTriggered("Splash") then
			for i = 0, 360 - 360/8, 360/8 do
				local tears = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0, fam.Position, Vector.FromAngle(i):Resized(6), fam):ToTear()
				--local tears = player:FireTear(fam.Position, InutilLib.DirToVec(playerDir), false, false, false):ToTear()
				tears.Position = fam.Position
				tears.CollisionDamage = data.Stat.Damage * extraDmg
				if player:HasTrinket(TrinketType.TRINKET_BABY_BENDER) then
					tears:AddTearFlags(TearFlags.TEAR_HOMING)
					tears.Color = Color(1,0,1,1)
				end
			end
		end
	end
end, RebekahCurse.ENTITY_JACOBSTEARS);

function yandereWaifu:JacobGlassInit(fam)
    local sprite = fam:GetSprite()
	
	local data = yandereWaifu.GetEntityData(fam)
	data.Stat = {
		FireDelay = 25,
		MaxFireDelay = 25,
		Damage = 3, 
		PlayerMaxDelay = 0
	}
end
yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, yandereWaifu.JacobGlassInit, RebekahCurse.ENTITY_JACOBSTEARS);


function yandereWaifu:JacobGlassCache(player, cacheF) --The thing the checks and updates the game, i guess?
	local data = yandereWaifu.GetEntityData(player)
	if cacheF == CacheFlag.CACHE_FAMILIARS then  -- Especially here!
		if player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_JACOBSTEARS) then
			player:CheckFamiliar(RebekahCurse.ENTITY_JACOBSTEARS, player:GetCollectibleNum(RebekahCurse.Items.COLLECTIBLE_JACOBSTEARS) + player:GetEffects():GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_BOX_OF_FRIENDS), RNG(), InutilLib.config:GetCollectible(RebekahCurse.Items.COLLECTIBLE_JACOBSTEARS))
		end
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, yandereWaifu.JacobGlassCache)