

yandereWaifu:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_,player)
	--local player = Isaac.GetPlayer(0);
    local room = Game():GetRoom();
	local data = yandereWaifu.GetEntityData(player)
	local pldata = yandereWaifu.GetEntityData(player)
	--items function!
	if player:HasCollectible(RebekahCurseItems.COLLECTIBLE_GREATPHEONIX) and InutilLib.HasJustPickedCollectible( player, RebekahCurseItems.COLLECTIBLE_GREATPHEONIX ) then
		player:AddNullCostume(RebekahCurseCostumes.GreatPheonix)
		if not pldata.GPFireCount then
			pldata.GPFireCount = 1
		end
	end
end)

local function SpawnFlies(player, amount)
	local amountFlies = amount or 4
	
	for i = 1, amountFlies do 
		local maggot = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLUE_FLY, math.random(1,5), player.Position, Vector(0,0), player)
	end
end

yandereWaifu:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, function(_,  tr)
	local player = tr.SpawnerEntity:ToPlayer()
	local pldata = yandereWaifu.GetEntityData(player)
	if player:HasCollectible(RebekahCurseItems.COLLECTIBLE_GREATPHEONIX) then
		local spr = tr:GetSprite()
		if pldata.lastGPFrameCount then
			if ILIB.game:GetFrameCount() == pldata.lastGPFrameCount then
				return
			end
			
			pldata.lastGPFrameCount = ILIB.game:GetFrameCount()
			
			if not pldata.GPFireCount then
				pldata.GPFireCount = 1
			else
				pldata.GPFireCount = pldata.GPFireCount + 1
			end
			
			if pldata.GPFireCount > 30 then
				pldata.GPFireCount = 0
				local amount = 4
				if player:HasCollectible(CollectibleType.COLLECTIBLE_SOY_MILK) then
					amount = 2
				end
				SpawnFlies(player, amount)
			end
		else
			pldata.lastGPFrameCount = ILIB.game:GetFrameCount()
		end
	end
end);

InutilLib.AddCustomCallback(yandereWaifu, ILIBCallbacks.MC_POST_FIRE_LASER, function(_, lz)
	if lz.SpawnerEntity then
		local player = lz.SpawnerEntity:ToPlayer()
		if player then
			local pldata = yandereWaifu.GetEntityData(player)
			if player:HasCollectible(RebekahCurseItems.COLLECTIBLE_GREATPHEONIX) then
				if player:HasWeaponType(WeaponType.WEAPON_LASER) or player:HasWeaponType(WeaponType.WEAPON_TECH_X) then
					local spr = lz:GetSprite()
					if pldata.lastGPFrameCount then
						if ILIB.game:GetFrameCount() == pldata.lastGPFrameCount then
							return
						end
						
						pldata.lastGPFrameCount = ILIB.game:GetFrameCount()
						
						if not pldata.GPFireCount then
							pldata.GPFireCount = 1
						else
							pldata.GPFireCount = pldata.GPFireCount + 1
						end
						
						if pldata.GPFireCount > 30 then
							pldata.GPFireCount = 0
							
							if pldata.GPFireCount > 30 then
								pldata.GPFireCount = 0
								local amount = 4
								if player:HasCollectible(CollectibleType.COLLECTIBLE_SOY_MILK) then
									amount = 2
								end
								SpawnFlies(player, amount)
							end
						end
					else
						pldata.lastGPFrameCount = ILIB.game:GetFrameCount()
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
			if player:HasCollectible(RebekahCurseItems.COLLECTIBLE_GREATPHEONIX) and player:HasWeaponType(WeaponType.WEAPON_BRIMSTONE) then
				local parent = lz.Parent
				if parent and parent.Type == EntityType.ENTITY_PLAYER then
					local spr = lz:GetSprite()
					if pldata.lastGPFrameCount then
						if ILIB.game:GetFrameCount() == pldata.lastGPFrameCount then
							return
						end
						
						pldata.lastGPFrameCount = ILIB.game:GetFrameCount()
						
						if not pldata.GPFireCount then
							pldata.GPFireCount = 1
						else
							pldata.GPFireCount = pldata.GPFireCount + 1
						end
						--print(pldata.GPFireCount)
						--if pldata.GPFireCount > 90 then
						--	pldata.GPFireCount = 0
							
							if pldata.GPFireCount > 30 then
								pldata.GPFireCount = 0
								local amount = 4
								if player:HasCollectible(CollectibleType.COLLECTIBLE_SOY_MILK) then
									amount = 2
								end
								SpawnFlies(player, amount)
							end
						--end
					else
						pldata.lastGPFrameCount = ILIB.game:GetFrameCount()
					end
				end
			end
		end
	end
end);

InutilLib.AddCustomCallback(yandereWaifu, ILIBCallbacks.MC_POST_FIRE_BOMB, function(_, bb)
	local player = bb.SpawnerEntity:ToPlayer()
	local pldata = yandereWaifu.GetEntityData(player)
	if player:HasCollectible(RebekahCurseItems.COLLECTIBLE_GREATPHEONIX) then
		if player:HasWeaponType(WeaponType.WEAPON_BOMBS) then
			local spr = bb:GetSprite()
			if pldata.lastGPFrameCount then
				if ILIB.game:GetFrameCount() == pldata.lastGPFrameCount then
					return
				end
				
				pldata.lastGPFrameCount = ILIB.game:GetFrameCount()
				
				if not pldata.GPFireCount then
					pldata.GPFireCount = 1
				else
					pldata.GPFireCount = pldata.GPFireCount + 1
				end
				
				if pldata.GPFireCount > 30 then
					pldata.GPFireCount = 0
					
					SpawnFlies(player, 4)
				end
			else
				pldata.lastGPFrameCount = ILIB.game:GetFrameCount()
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
		if player:HasCollectible(RebekahCurseItems.COLLECTIBLE_GREATPHEONIX) and player:HasWeaponType(WeaponType.WEAPON_ROCKETS) then
			local spr = eff:GetSprite()
			if pldata.lastGPFrameCount then
				if ILIB.game:GetFrameCount() == pldata.lastGPFrameCount then
					return
				end
				
				pldata.lastGPFrameCount = ILIB.game:GetFrameCount()
				
				if not pldata.GPFireCount then
					pldata.GPFireCount = 1
				else
					pldata.GPFireCount = pldata.GPFireCount + 1
				end
				
				if pldata.GPFireCount > 3 then
					pldata.GPFireCount = 0
					
					SpawnFlies(player)
				end
			else
				pldata.lastGPFrameCount = ILIB.game:GetFrameCount()
			end
		end
	end
end, EffectVariant.TARGET);

InutilLib:AddCallback(ModCallbacks.MC_POST_KNIFE_UPDATE, function(_, kn)

	local player = kn.SpawnerEntity:ToPlayer()
	local pldata = yandereWaifu.GetEntityData(player)
	if player and player:HasCollectible(RebekahCurseItems.COLLECTIBLE_GREATPHEONIX) then
		if player:HasWeaponType(WeaponType.WEAPON_KNIFE) then
			if not pldata.NoActiveKnife then pldata.NoActiveKnife = true end
			local spr = kn:GetSprite()
			if pldata.lastGPFrameCount then
				if ILIB.game:GetFrameCount() == pldata.lastGPFrameCount and pldata.NoActiveKnife then
					return
				end
				
				pldata.lastGPFrameCount = ILIB.game:GetFrameCount()
				
				if not pldata.GPFireCount then
					pldata.GPFireCount = 1
				else
					pldata.GPFireCount = pldata.GPFireCount + 1
				end
				
				if pldata.GPFireCount > 240 then
					pldata.GPFireCount = 0
					
					SpawnFlies(player)
				end
			else
				pldata.lastGPFrameCount = ILIB.game:GetFrameCount()
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
		end
	end
end)