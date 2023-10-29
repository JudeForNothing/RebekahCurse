yandereWaifu:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_,player, cacheF) --The thing the checks and updates the game, i guess?
	local data = yandereWaifu.GetEntityData(player)
	--love = power
	if player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_APPRECIATIONCAKE) then
		if cacheF == CacheFlag.CACHE_SPEED then
			player.MoveSpeed = player.MoveSpeed + 0.2
		end
		if cacheF == CacheFlag.CACHE_DAMAGE then
			player.Damage = player.Damage + 1
		end
		if cacheF == CacheFlag.CACHE_FIREDELAY then	
			player.MaxFireDelay = player.MaxFireDelay - 1
		end
		if cacheF == CacheFlag.CACHE_RANGE then
			player.TearHeight = player.TearHeight - 5.25
		end
		if cacheF == CacheFlag.CACHE_LUCK then
			player.Luck = player.Luck + 1
		end
	end
end)

--[[yandereWaifu:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_,player)
	local data = yandereWaifu.GetEntityData(player)
	if player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_APPRECIATIONCAKE) and InutilLib.HasJustPickedCollectible( player, RebekahCurse.Items.COLLECTIBLE_APPRECIATIONCAKE) then
		player:AddNullCostume(RebekahCurse.Costumes.CandyWeddingRing)
	end
end)]]

local num = 3

function yandereWaifu.CakeFireTearBurst(player, dir, pos)
	local direction = dir or InutilLib.DirToVec(player:GetFireDirection())
	local position = pos or player.Position
	if player:HasCollectible(CollectibleType.COLLECTIBLE_MARKED) then
		direction = player:GetAimDirection()
	end
	local tear = Isaac.Spawn(1000, EffectVariant.RED_CANDLE_FLAME, 0, position, direction:Resized(player.ShotSpeed*10), player)
end



yandereWaifu:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, function(_,  tr)
	local player = tr.SpawnerEntity:ToPlayer()
	local pldata = yandereWaifu.GetEntityData(player)
	if player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_APPRECIATIONCAKE) then
		local spr = tr:GetSprite()
		if pldata.lastARPCFrameCount then
			if InutilLib.game:GetFrameCount() == pldata.lastARPCFrameCount then
				return
			end
			
			pldata.lastARPCFrameCount = InutilLib.game:GetFrameCount()
			
			if not pldata.ARPCFireCount then
				pldata.ARPCFireCount = 1
			else
				pldata.ARPCFireCount = pldata.ARPCFireCount + 1
			end
			
			if pldata.ARPCFireCount > num then
				pldata.ARPCFireCount = 0
				local amount = 4
				if player:HasCollectible(CollectibleType.COLLECTIBLE_SOY_MILK) then
					amount = 2
				end
				yandereWaifu.CakeFireTearBurst(player)
			end
		else
			pldata.lastARPCFrameCount = InutilLib.game:GetFrameCount()
		end
	end
end);

yandereWaifu:AddCallback("MC_POST_FIRE_LASER", function(_,lz)
	if lz.SpawnerEntity then
		local player = lz.SpawnerEntity:ToPlayer()
		if player then
			local pldata = yandereWaifu.GetEntityData(player)
			if player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_APPRECIATIONCAKE) then
				if player:HasWeaponType(WeaponType.WEAPON_LASER) or player:HasWeaponType(WeaponType.WEAPON_TECH_X) then
					local spr = lz:GetSprite()
					if pldata.lastARPCFrameCount then
						if InutilLib.game:GetFrameCount() == pldata.lastARPCFrameCount then
							return
						end
						
						pldata.lastARPCFrameCount = InutilLib.game:GetFrameCount()
						
						if not pldata.ARPCFireCount then
							pldata.ARPCFireCount = 1
						else
							pldata.ARPCFireCount = pldata.ARPCFireCount + 1
						end
						
						if pldata.ARPCFireCount > num then
							pldata.ARPCFireCount = 0
							
							if pldata.ARPCFireCount > num then
								pldata.ARPCFireCount = 0
								local amount = 4
								if player:HasCollectible(CollectibleType.COLLECTIBLE_SOY_MILK) then
									amount = 2
								end
								yandereWaifu.CakeFireTearBurst(player)
							end
						end
					else
						pldata.lastARPCFrameCount = InutilLib.game:GetFrameCount()
					end
				end
			end
		end
	end
end)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_LASER_UPDATE, function(_,  lz)
	if lz.SpawnerEntity then
		local player = lz.SpawnerEntity:ToPlayer()
		if player then
			local pldata = yandereWaifu.GetEntityData(player)
			if player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_APPRECIATIONCAKE) and player:HasWeaponType(WeaponType.WEAPON_BRIMSTONE) then
				local parent = lz.Parent
				if parent and parent.Type == EntityType.ENTITY_PLAYER then
					local spr = lz:GetSprite()
					if pldata.lastARPCFrameCount then
						if InutilLib.game:GetFrameCount() == pldata.lastARPCFrameCount then
							return
						end
						
						pldata.lastARPCFrameCount = InutilLib.game:GetFrameCount()
						
						if not pldata.ARPCFireCount then
							pldata.ARPCFireCount = 1
						else
							pldata.ARPCFireCount = pldata.ARPCFireCount + 1
						end
						--print(pldata.ARPCFireCount)
						--if pldata.ARPCFireCount > 90 then
						--	pldata.ARPCFireCount = 0
							
							if pldata.ARPCFireCount > num then
								pldata.ARPCFireCount = 0
								local amount = 4
								if player:HasCollectible(CollectibleType.COLLECTIBLE_SOY_MILK) then
									amount = 2
								end
								yandereWaifu.CakeFireTearBurst(player)
							end
						--end
					else
						pldata.lastARPCFrameCount = InutilLib.game:GetFrameCount()
					end
				end
			end
		end
	end
end);

yandereWaifu:AddCallback("MC_POST_FIRE_BOMB", function(_, bb)
	local player = bb.SpawnerEntity:ToPlayer()
	local pldata = yandereWaifu.GetEntityData(player)
	if player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_APPRECIATIONCAKE) then
		if player:HasWeaponType(WeaponType.WEAPON_BOMBS) then
			local spr = bb:GetSprite()
			if pldata.lastARPCFrameCount then
				if InutilLib.game:GetFrameCount() == pldata.lastARPCFrameCount then
					return
				end
				
				pldata.lastARPCFrameCount = InutilLib.game:GetFrameCount()
				
				if not pldata.ARPCFireCount then
					pldata.ARPCFireCount = 1
				else
					pldata.ARPCFireCount = pldata.ARPCFireCount + 1
				end
				
				if pldata.ARPCFireCount > num then
					pldata.ARPCFireCount = 0
					
					--yandereWaifu.CakeFireTearBurst(player)
					bb:AddTearFlags(TearFlags.TEAR_BURN)
				end
			else
				pldata.lastARPCFrameCount = InutilLib.game:GetFrameCount()
			end
		end
	end
end)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, function(_,  eff)
	--local parent = eff.Parent
	local player = eff.SpawnerEntity:ToPlayer()
	--print(player)
	if player and player.Type == EntityType.ENTITY_PLAYER then
		local pldata = yandereWaifu.GetEntityData(player)
		if player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_APPRECIATIONCAKE) and player:HasWeaponType(WeaponType.WEAPON_ROCKETS) then
			local spr = eff:GetSprite()
			if pldata.lastARPCFrameCount then
				if InutilLib.game:GetFrameCount() == pldata.lastARPCFrameCount then
					return
				end
				
				pldata.lastARPCFrameCount = InutilLib.game:GetFrameCount()
				
				if not pldata.ARPCFireCount then
					pldata.ARPCFireCount = 1
				else
					pldata.ARPCFireCount = pldata.ARPCFireCount + 1
				end
				
				if pldata.ARPCFireCount > num then
					pldata.ARPCFireCount = 0
					
					yandereWaifu.CakeFireTearBurst(player)
				end
			else
				pldata.lastARPCFrameCount = InutilLib.game:GetFrameCount()
			end
		end
	end
end, EffectVariant.TARGET);

yandereWaifu:AddCallback(ModCallbacks.MC_POST_KNIFE_UPDATE, function(_, kn)

	local player = kn.SpawnerEntity:ToPlayer()
	local pldata = yandereWaifu.GetEntityData(player)
	if player and player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_APPRECIATIONCAKE) then
		local spr = kn:GetSprite()
		if player:HasWeaponType(WeaponType.WEAPON_KNIFE) then
			if not pldata.NoActiveKnife then pldata.NoActiveKnife = true end
			if pldata.lastARPCFrameCount then
				if InutilLib.game:GetFrameCount() == pldata.lastARPCFrameCount and pldata.NoActiveKnife then
					return
				end
				
				pldata.lastARPCFrameCount = InutilLib.game:GetFrameCount()
				
				if not pldata.ARPCFireCount then
					pldata.ARPCFireCount = 1
				else
					pldata.ARPCFireCount = pldata.ARPCFireCount + 1
				end
				
				if pldata.ARPCFireCount > 240 then
					pldata.ARPCFireCount = 0
					
					yandereWaifu.CakeFireTearBurst(player)
				end
			else
				pldata.lastARPCFrameCount = InutilLib.game:GetFrameCount()
			end
			local data = InutilLib.GetILIBData(kn)
			if kn.FrameCount == 1 then
				data.state = -1
				data.refreshStateFrame = 0
				data.lastVel = kn:GetKnifeVelocity()
				data.lastState = nil
				pldata.NoActiveKnife = true
			end
			--print(data.state, "state")
			if kn:GetKnifeVelocity() > 0 then
				data.lastState = data.state
				data.state = 1
				pldata.NoActiveKnife = false
			elseif kn:GetKnifeVelocity() < 0 and data.state == 1 then
				data.lastState = data.state
				data.state = 2
				data.refreshStateFrame = kn.FrameCount
			elseif kn:GetKnifeDistance() == 0 and data.state == 2 then
				data.lastState = data.state
				data.state = 0
				pldata.NoActiveKnife = true
			end
		elseif player:HasWeaponType(WeaponType.WEAPON_BONE) then
			if not pldata.DontGreatPheonixTick and InutilLib.IsFinishedMultiple(spr, "Swing", "Swing2", "SwingDown", "SwingDown2") then
				if pldata.lastARPCFrameCount then
					if InutilLib.game:GetFrameCount() == pldata.lastARPCFrameCount then
						return
					end
					
					pldata.lastARPCFrameCount = InutilLib.game:GetFrameCount()
					
					if not pldata.ARPCFireCount then
						pldata.ARPCFireCount = 1
					else
						pldata.ARPCFireCount = pldata.ARPCFireCount + 1
					end
					
					if pldata.ARPCFireCount > num then
						pldata.ARPCFireCount = 0
						local amount = 4
						if player:HasCollectible(CollectibleType.COLLECTIBLE_SOY_MILK) then
							amount = 2
						end
						yandereWaifu.CakeFireTearBurst(player)
					end
				else
					pldata.lastARPCFrameCount = InutilLib.game:GetFrameCount()
				end
				pldata.DontGreatPheonixTick = true
			elseif InutilLib.IsPlayingMultiple(spr, "Swing", "Swing2", "SwingDown", "SwingDown2", "AttackRight", "AttackLeft", "AttackDown", "AttackUp") then
				pldata.DontGreatPheonixTick = false
			end
		elseif player:HasWeaponType(WeaponType.WEAPON_SPIRIT_SWORD) then
			if --[[not pldata.DontGreatPheonixTick]] spr:GetFrame() == 1 and InutilLib.IsPlayingMultiple(spr, "Swing", "Swing2", "SwingDown", "SwingDown2", "AttackRight", "AttackLeft", "AttackDown", "AttackUp") then
				if pldata.lastARPCFrameCount then
					if InutilLib.game:GetFrameCount() == pldata.lastARPCFrameCount then
						return
					end
					
					pldata.lastARPCFrameCount = InutilLib.game:GetFrameCount()
					
					if not pldata.ARPCFireCount then
						pldata.ARPCFireCount = 1
					else
						pldata.ARPCFireCount = pldata.ARPCFireCount + 1
					end
					
					if pldata.ARPCFireCount > num then
						pldata.ARPCFireCount = 0
						local amount = 1
						if player:HasCollectible(CollectibleType.COLLECTIBLE_SOY_MILK) then
							amount = 1
						end
						yandereWaifu.CakeFireTearBurst(player)
					end
				else
					pldata.lastARPCFrameCount = InutilLib.game:GetFrameCount()
				end
			--	pldata.DontGreatPheonixTick = true
			--elseif InutilLib.IsPlayingMultiple(spr, "Swing", "Swing2", "SwingDown", "SwingDown2", "AttackRight", "AttackLeft", "AttackDown", "AttackUp") then
			--	pldata.DontGreatPheonixTick = false
			end
		end
	end
end)