local PencilSharpenerCount = 7

yandereWaifu:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_,player)
	--local player = Isaac.GetPlayer(0);
    local room = Game():GetRoom();
	local data = yandereWaifu.GetEntityData(player)
	local pldata = yandereWaifu.GetEntityData(player)
	--items function!
	if player:HasCollectible(RebekahCurseItems.COLLECTIBLE_PENCILSHARPENER) and InutilLib.HasJustPickedCollectible( player, RebekahCurseItems.COLLECTIBLE_PENCILSHARPENER ) then
		--player:AddNullCostume(RebekahCurseCostumes.GreatPheonix)
		if not pldata.PSRPFireCount then
			pldata.PSRPFireCount = 1
		end
	end
end)

function yandereWaifu.SharpenerFireTearBurst(player, dir, pos)
	local direction = dir or InutilLib.DirToVec(player:GetFireDirection())
	local position = pos or player.Position
	if player:HasCollectible(CollectibleType.COLLECTIBLE_MARKED) then
		direction = player:GetAimDirection()
	end
	for i = -45, 45, 15 do
		local tear = player:FireTear(pos, Vector.FromAngle(direction:GetAngleDegrees()+i):Resized(player.ShotSpeed*10), true, false, false, (player), 1)
		tear:AddTearFlags(TearFlags.TEAR_PIERCING)
		tear:ChangeVariant(TearVariant.CUPID_BLUE)
	end
end

InutilLib.AddCustomCallback(yandereWaifu, ILIBCallbacks.MC_POST_PLAYER_TEAR, function(_, tr)
	local data = yandereWaifu.GetEntityData(tr)
	local player = tr.SpawnerEntity:ToPlayer()
	if not player then return end
	local pldata = yandereWaifu.GetEntityData(player)
	if player:HasCollectible(RebekahCurseItems.COLLECTIBLE_PENCILSHARPENER) then
		local spr = tr:GetSprite()
		if pldata.lastPSRPFrameCount then
			if ILIB.game:GetFrameCount() == pldata.lastPSRPFrameCount then
				return
			end
			
			pldata.lastPSRPFrameCount = ILIB.game:GetFrameCount()
			
			if not pldata.PSRPFireCount then
				pldata.PSRPFireCount = 1
			else
				pldata.PSRPFireCount = pldata.PSRPFireCount + 1
			end
			
			if pldata.PSRPFireCount > PencilSharpenerCount then
				pldata.PSRPFireCount = 0
				yandereWaifu.SharpenerFireTearBurst(player, player:GetLastDirection())
			end
		else
			pldata.lastPSRPFrameCount = ILIB.game:GetFrameCount()
		end
	end
end)

InutilLib.AddCustomCallback(yandereWaifu, ILIBCallbacks.MC_POST_INCUBUS_TEAR, function(_, tr)
	local data = yandereWaifu.GetEntityData(tr)
	local fam = tr.SpawnerEntity:ToFamiliar()
	local player = fam.Player:ToPlayer()
	local pldata = yandereWaifu.GetEntityData(fam)
	if player:HasCollectible(RebekahCurseItems.COLLECTIBLE_PENCILSHARPENER) then
		local spr = tr:GetSprite()
		if pldata.lastPSRPFrameCount then
			if ILIB.game:GetFrameCount() == pldata.lastPSRPFrameCount then
				return
			end
			
			pldata.lastPSRPFrameCount = ILIB.game:GetFrameCount()
			
			if not pldata.PSRPFireCount then
				pldata.PSRPFireCount = 1
			else
				pldata.PSRPFireCount = pldata.PSRPFireCount + 1
			end
			
			if pldata.PSRPFireCount > PencilSharpenerCount then
				pldata.PSRPFireCount = 0
				print("boo")
				yandereWaifu.SharpenerFireTearBurst(player, player:GetLastDirection(), fam.Position)
			end
		else
			pldata.lastPSRPFrameCount = ILIB.game:GetFrameCount()
		end
	end
end)

--[[
yandereWaifu:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, function(_,  tr)
	local player = tr.SpawnerEntity:ToPlayer()
	local pldata = yandereWaifu.GetEntityData(player)
	if player:HasCollectible(RebekahCurseItems.COLLECTIBLE_PENCILSHARPENER) then
		local spr = tr:GetSprite()
		if pldata.lastPSRPFrameCount then
			if ILIB.game:GetFrameCount() == pldata.lastPSRPFrameCount then
				return
			end
			
			pldata.lastPSRPFrameCount = ILIB.game:GetFrameCount()
			
			if not pldata.PSRPFireCount then
				pldata.PSRPFireCount = 1
			else
				pldata.PSRPFireCount = pldata.PSRPFireCount + 1
			end
			
			if pldata.PSRPFireCount > PencilSharpenerCount then
				pldata.PSRPFireCount = 0
				yandereWaifu.SharpenerFireTearBurst(player)
			end
		else
			pldata.lastPSRPFrameCount = ILIB.game:GetFrameCount()
		end
	end
end);]]

InutilLib.AddCustomCallback(yandereWaifu, ILIBCallbacks.MC_POST_FIRE_LASER, function(_, lz)
	if lz.SpawnerEntity then
		local player = lz.SpawnerEntity:ToPlayer()
		if player then
			local pldata = yandereWaifu.GetEntityData(player)
			if player:HasCollectible(RebekahCurseItems.COLLECTIBLE_PENCILSHARPENER) then
				if player:HasWeaponType(WeaponType.WEAPON_LASER) or player:HasWeaponType(WeaponType.WEAPON_TECH_X) then
					local spr = lz:GetSprite()
					if pldata.lastPSRPFrameCount then
						if ILIB.game:GetFrameCount() == pldata.lastPSRPFrameCount then
							return
						end
						
						pldata.lastPSRPFrameCount = ILIB.game:GetFrameCount()
						
						if not pldata.PSRPFireCount then
							pldata.PSRPFireCount = 1
						else
							pldata.PSRPFireCount = pldata.PSRPFireCount + 1
						end
						
						if pldata.PSRPFireCount > PencilSharpenerCount then
							pldata.PSRPFireCount = 0
							
							if pldata.PSRPFireCount > PencilSharpenerCount then
								pldata.PSRPFireCount = 0
								yandereWaifu.SharpenerFireTearBurst(player)
							end
						end
					else
						pldata.lastPSRPFrameCount = ILIB.game:GetFrameCount()
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
			if player:HasCollectible(RebekahCurseItems.COLLECTIBLE_PENCILSHARPENER) and player:HasWeaponType(WeaponType.WEAPON_BRIMSTONE) then
				local parent = lz.Parent
				if parent and parent.Type == EntityType.ENTITY_PLAYER then
					local spr = lz:GetSprite()
					if pldata.lastPSRPFrameCount then
						if ILIB.game:GetFrameCount() == pldata.lastPSRPFrameCount then
							return
						end
						
						pldata.lastPSRPFrameCount = ILIB.game:GetFrameCount()
						
						if not pldata.PSRPFireCount then
							pldata.PSRPFireCount = 1
						else
							pldata.PSRPFireCount = pldata.PSRPFireCount + 1
						end
						--print(pldata.PSRPFireCount)
						--if pldata.PSRPFireCount > 90 then
						--	pldata.PSRPFireCount = 0
							
							if pldata.PSRPFireCount > PencilSharpenerCount then
								pldata.PSRPFireCount = 0
								yandereWaifu.SharpenerFireTearBurst(player)
							end
						--end
					else
						pldata.lastPSRPFrameCount = ILIB.game:GetFrameCount()
					end
				end
			end
		end
	end
end);

InutilLib.AddCustomCallback(yandereWaifu, ILIBCallbacks.MC_POST_FIRE_BOMB, function(_, bb)
	local player = bb.SpawnerEntity:ToPlayer()
	local pldata = yandereWaifu.GetEntityData(player)
	if player:HasCollectible(RebekahCurseItems.COLLECTIBLE_PENCILSHARPENER) then
		if player:HasWeaponType(WeaponType.WEAPON_BOMBS) then
			local spr = bb:GetSprite()
			if pldata.lastPSRPFrameCount then
				if ILIB.game:GetFrameCount() == pldata.lastPSRPFrameCount then
					return
				end
				
				pldata.lastPSRPFrameCount = ILIB.game:GetFrameCount()
				
				if not pldata.PSRPFireCount then
					pldata.PSRPFireCount = 1
				else
					pldata.PSRPFireCount = pldata.PSRPFireCount + 1
				end
				
				if pldata.PSRPFireCount > PencilSharpenerCount then
					pldata.PSRPFireCount = 0
					
					yandereWaifu.SharpenerFireTearBurst(player)
				end
			else
				pldata.lastPSRPFrameCount = ILIB.game:GetFrameCount()
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
		if player:HasCollectible(RebekahCurseItems.COLLECTIBLE_PENCILSHARPENER) and player:HasWeaponType(WeaponType.WEAPON_ROCKETS) then
			local spr = eff:GetSprite()
			if pldata.lastPSRPFrameCount then
				if ILIB.game:GetFrameCount() == pldata.lastPSRPFrameCount then
					return
				end
				
				pldata.lastPSRPFrameCount = ILIB.game:GetFrameCount()
				
				if not pldata.PSRPFireCount then
					pldata.PSRPFireCount = 1
				else
					pldata.PSRPFireCount = pldata.PSRPFireCount + 1
				end
				
				if pldata.PSRPFireCount > 3 then
					pldata.PSRPFireCount = 0
					
					yandereWaifu.SharpenerFireTearBurst(player)
				end
			else
				pldata.lastPSRPFrameCount = ILIB.game:GetFrameCount()
			end
		end
	end
end, EffectVariant.TARGET);

InutilLib:AddCallback(ModCallbacks.MC_POST_KNIFE_UPDATE, function(_, kn)

	local player = kn.SpawnerEntity:ToPlayer()
	local pldata = yandereWaifu.GetEntityData(player)
	if player and player:HasCollectible(RebekahCurseItems.COLLECTIBLE_PENCILSHARPENER) then
		local spr = kn:GetSprite()
		if player:HasWeaponType(WeaponType.WEAPON_KNIFE) then
			if not pldata.NoActiveKnife then pldata.NoActiveKnife = true end
			if pldata.lastPSRPFrameCount then
				if ILIB.game:GetFrameCount() == pldata.lastPSRPFrameCount and pldata.NoActiveKnife then
					return
				end
				
				pldata.lastPSRPFrameCount = ILIB.game:GetFrameCount()
				
				if not pldata.PSRPFireCount then
					pldata.PSRPFireCount = 1
				else
					pldata.PSRPFireCount = pldata.PSRPFireCount + 1
				end
				
				if pldata.PSRPFireCount > 240 then
					pldata.PSRPFireCount = 0
					
					yandereWaifu.SharpenerFireTearBurst(player)
				end
			else
				pldata.lastPSRPFrameCount = ILIB.game:GetFrameCount()
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
				if pldata.lastPSRPFrameCount then
					if ILIB.game:GetFrameCount() == pldata.lastPSRPFrameCount then
						return
					end
					
					pldata.lastPSRPFrameCount = ILIB.game:GetFrameCount()
					
					if not pldata.PSRPFireCount then
						pldata.PSRPFireCount = 1
					else
						pldata.PSRPFireCount = pldata.PSRPFireCount + 1
					end
					
					if pldata.PSRPFireCount > PencilSharpenerCount then
						pldata.PSRPFireCount = 0
						yandereWaifu.SharpenerFireTearBurst(player)
					end
				else
					pldata.lastPSRPFrameCount = ILIB.game:GetFrameCount()
				end
				pldata.DontGreatPheonixTick = true
			elseif InutilLib.IsPlayingMultiple(spr, "Swing", "Swing2", "SwingDown", "SwingDown2", "AttackRight", "AttackLeft", "AttackDown", "AttackUp") then
				pldata.DontGreatPheonixTick = false
			end
		elseif player:HasWeaponType(WeaponType.WEAPON_SPIRIT_SWORD) then
			if --[[not pldata.DontGreatPheonixTick]] spr:GetFrame() == 1 and InutilLib.IsPlayingMultiple(spr, "Swing", "Swing2", "SwingDown", "SwingDown2", "AttackRight", "AttackLeft", "AttackDown", "AttackUp") then
				if pldata.lastPSRPFrameCount then
					if ILIB.game:GetFrameCount() == pldata.lastPSRPFrameCount then
						return
					end
					
					pldata.lastPSRPFrameCount = ILIB.game:GetFrameCount()
					
					if not pldata.PSRPFireCount then
						pldata.PSRPFireCount = 1
					else
						pldata.PSRPFireCount = pldata.PSRPFireCount + 1
					end
					
					if pldata.PSRPFireCount > PencilSharpenerCount then
						pldata.PSRPFireCount = 0
						yandereWaifu.SharpenerFireTearBurst(player)
					end
				else
					pldata.lastPSRPFrameCount = ILIB.game:GetFrameCount()
				end
			--	pldata.DontGreatPheonixTick = true
			--elseif InutilLib.IsPlayingMultiple(spr, "Swing", "Swing2", "SwingDown", "SwingDown2", "AttackRight", "AttackLeft", "AttackDown", "AttackUp") then
			--	pldata.DontGreatPheonixTick = false
			end
		end
	end
end)