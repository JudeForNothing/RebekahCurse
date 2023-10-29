
local diceRoll = Sprite();
diceRoll:Load("gfx/ui/roll_dice.anm2", true);

local goldDiceRoll = Sprite();
goldDiceRoll:Load("gfx/ui/gods_roll_dice.anm2", true);

function yandereWaifu:IsaacCregisterCache(player, cacheF) --The thing the checks and updates the game, i guess?
	local data = yandereWaifu.GetEntityData(player)
	if player:GetPlayerType() == RebekahCurse.WISHFUL_ISAAC then -- Especially here!
		--if data.UpdateHair then
		--	print("tuck")
		--[[if InutilLib.room:GetFrameCount() < 1 then
			yandereWaifu.ApplyCostumes( _, player , true, false)
		end]]
		--	data.UpdateHair = false
		--end
		
		--[[if cacheF == CacheFlag.CACHE_DAMAGE then
			player.Damage = player.Damage -- 0.73 --1.73
		end]]
		if cacheF == CacheFlag.CACHE_LUCK then
			player.Luck = player.Luck + 10
		end
		--[[if cacheF == CacheFlag.CACHE_FIREDELAY then	
			local FireDelayDiff = player.MaxFireDelay - 10
			if FireDelayDiff < 0 then
				player.MaxFireDelay = player.MaxFireDelay + FireDelayDiff
				player.Damage = player.Damage * FireDelayDiff/10
			elseif FireDelayDiff > 0 then
				player.MaxFireDelay = player.MaxFireDelay - FireDelayDiff
				player.Damage = player.Damage / FireDelayDiff
			end
		end]]
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, yandereWaifu.IsaacCregisterCache)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_RENDER, function(_, _)
	for p = 0, InutilLib.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		local data = yandereWaifu.GetEntityData(player)
		local room = InutilLib.room
		if player:GetPlayerType() == RebekahCurse.WISHFUL_ISAAC and not (room:GetType() == RoomType.ROOM_BOSS and not room:IsClear() and room:GetFrameCount() < 1) then
			if data.IsRollingHurt then 
				diceRoll:SetFrame("Dice", data.RollingHurtNum)
			end
			if data.IsRollingRendering then
				local playerLocation = Isaac.WorldToScreen(player.Position)
				diceRoll:Render(playerLocation + Vector(0, -70), Vector(0,0), Vector(0,0));
				diceRoll.Color = Color(1,1,1,data.IsRollingColorFade,0,0,0)
			end

			if data.IsGodRolling then 
				goldDiceRoll:SetFrame("Dice", data.RollingGodNum)
			end
			if data.IsGodRollingRendering then
				local playerLocation = Isaac.WorldToScreen(player.Position)
				goldDiceRoll:Render(playerLocation + Vector(0, -70), Vector(0,0), Vector(0,0));
				goldDiceRoll.Color = Color(1,1,1,data.IsRollingColorFade,0,0,0)
			end
		end
	end
end);


yandereWaifu:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)
	--for p = 0, InutilLib.game:GetNumPlayers() - 1 do
	--	local player = Isaac.GetPlayer(p)
		local data = yandereWaifu.GetEntityData(player)
		local room = InutilLib.room
		if player:GetPlayerType() == RebekahCurse.WISHFUL_ISAAC and not (room:GetType() == RoomType.ROOM_BOSS and not room:IsClear() and room:GetFrameCount() < 1) then
			if data.IsRollingHurt then 
				if not data.RollingHurtNum then data.RollingHurtNum = 0 end
				if player.FrameCount % 3 == 0 then
					data.RollingHurtNum = math.random(0,5)
					SFXManager():Play( RebekahCurse.Sounds.SOUND_IMDIECHIME , 0.2, 0, false, 0.9)
				end
					data.IsRollingHurt = data.IsRollingHurt - 1
					if data.IsRollingHurt <= 0 then
						data.IsRollingHurt = nil
						data.FinishedHurtRoll = true
						local tbl = data.RollingDmgInfo
						if data.RollingHurtNum == 0 then
							data.RollingDmgInfo.amount = data.RollingDmgInfo.amount * 2
							SFXManager():Play( RebekahCurse.Sounds.SOUND_IMDIECHIME , 1, 0, false, 0.7)
						elseif data.RollingHurtNum == 5 then
							data.RollingDmgInfo.amount = 0
							player:AddHearts(1)
							SFXManager():Play( RebekahCurse.Sounds.SOUND_IMDIECHIME , 1, 0, false, 1.2)
						end
						if data.RollingDmgInfo.damageSource then
							player:TakeDamage( tbl.amount, tbl.damageFlag, EntityRef(tbl.damageSource), tbl.damageCountdownFrames);
						end
						data.FinishedHurtRoll = false
					end
				--end
				--diceRoll:SetFrame("Dice", data.RollingHurtNum)
			end
			if data.IsRollingRendering then
				data.IsRollingRendering = data.IsRollingRendering - 1
				--[[if not data.IsRollingColorFade then
					data.IsRollingColorFade = 1 
				else
					if not data.IsRollingHurt then
						data.IsRollingColorFade = data.IsRollingColorFade - 0.1
					end
				end]]
				if data.IsRollingRendering <= 0 then
					data.IsRollingRendering = nil 
					data.IsRollingColorFade = 1
				end
			end
			if data.IsGodRolling then 
				data.IsGodRolling = data.IsGodRolling - 1
				if player.FrameCount % 3 == 0 then
					data.RollingGodNum = math.random(0,5)
					SFXManager():Play( RebekahCurse.Sounds.SOUND_IMDIECHIME , 0.2, 0, false, 0.9)
				end
					if data.IsGodRolling <= 0 then
						data.IsGodRolling = nil
						if data.RollingHurtNum == 0 then
							SFXManager():Play( RebekahCurse.Sounds.SOUND_IMDIECHIME , 1, 0, false, 0.7)
						elseif data.RollingHurtNum == 5 then
							SFXManager():Play( RebekahCurse.Sounds.SOUND_IMDIECHIME , 1, 0, false, 1.1)
						end

						for i, coll in pairs (Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, -1)) do
							local num = data.RollingGodNum
							coll = coll:ToPickup()
							if num == 0 then
								coll:Morph(5,100, coll.SubType - 1)
							elseif num == 1 then
								coll:Morph(5,100, coll.SubType + 1)
							elseif num == 2 then
								coll:Morph(5,100, coll.SubType + 1)
							elseif num == 3 then
								coll:Remove()
							end
						end

						--i feel lazy, this dice was supposed to reroll the last thing isaac did
					end
			end
			if data.IsGodRollingRendering then
				data.IsGodRollingRendering = data.IsGodRollingRendering - 1
				if data.IsGodRollingRendering <= 0 then
					data.IsGodRollingRendering = nil 
				end
			end
		end
	--end
end);

yandereWaifu:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, damage, amount, damageFlag, damageSource, damageCountdownFrames) --invincibilityframe when dashing or whatnot
	local player = damage:ToPlayer();
	local data = yandereWaifu.GetEntityData(player)

	if player:GetPlayerType() == RebekahCurse.WISHFUL_ISAAC then
		if data.FinishedHurtRoll then
			return true
		else
			data.IsRollingHurt = 60
			data.IsRollingRendering = 90
			local damageSource = InutilLib.GetEntFromDmgSrc(damageSource)
			data.RollingDmgInfo = {damage = damage, amount = amount, damageFlag = damageFlag, damageSource = damageSource, damageCountdownFrames = damageCountdownFrames}
			return false
		end
	end
	
end, EntityType.ENTITY_PLAYER)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, function(_,player)
	--if player:GetPlayerType() == RebekahCurse.WISHFUL_ISAAC and not player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_GODSDICE) then
	--	player:SetPocketActiveItem(RebekahCurse.Items.COLLECTIBLE_GODSDICE)
	--end
end)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_,player)
	--[[if player:GetPlayerType() == RebekahCurse.WISHFUL_ISAAC and not player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_GODSDICE) then
		player:SetPocketActiveItem(RebekahCurse.Items.COLLECTIBLE_GODSDICE)
	end]]
end)

function yandereWaifu:useGodsDice(collItem, rng, player, flags, slot)
	local data = yandereWaifu.GetEntityData(player)
	if data.lastActiveUsedFrameCount then
		if InutilLib.game:GetFrameCount() == data.lastActiveUsedFrameCount then
			return
		end
						
		data.lastActiveUsedFrameCount = InutilLib.game:GetFrameCount()
	else
		data.lastActiveUsedFrameCount = InutilLib.game:GetFrameCount()
	end
	InutilLib.SFX:Play(RebekahCurse.Sounds.SOUND_SCRIBBLING, 1, 0, false, 1.5)
	if flags & UseFlag.USE_NOANIM == 0 then
        player:AnimateCollectible(RebekahCurse.Items.COLLECTIBLE_GODSDICE, "UseItem", "PlayerPickupSparkle")
    end

	data.IsGodRolling = 60
	data.IsGodRollingRendering = 90
end

yandereWaifu:AddCallback( ModCallbacks.MC_USE_ITEM, yandereWaifu.useGodsDice, RebekahCurse.Items.COLLECTIBLE_GODSDICE)
