local cache = {}
function cache.SetRebekahBaseStats(cacheF, player)
local data = yandereWaifu.GetEntityData(player)
	if data.currentMode == RebekahCurse.REBECCA_MODE.RedHearts then
		if cacheF == CacheFlag.CACHE_DAMAGE then
			player.Damage = player.Damage -- 0.73 --1.73
		end
		if cacheF == CacheFlag.CACHE_LUCK then
			player.Luck = player.Luck - 0.13
		end
	elseif data.currentMode == RebekahCurse.REBECCA_MODE.SoulHearts or data.currentMode == RebekahCurse.REBECCA_MODE.BlendedHearts 
	or data.currentMode == RebekahCurse.REBECCA_MODE.HalfSoulHearts then
		if cacheF == CacheFlag.CACHE_DAMAGE then
			if yandereWaifu.GetEntityData(player).SoulBuff then
				player.Damage = player.Damage * 2.5
			else
				player.Damage = player.Damage + 0.2
			end
		end
		if cacheF == CacheFlag.CACHE_FIREDELAY then	
			if player.MaxFireDelay >= 4 then
				player.MaxFireDelay = player.MaxFireDelay - 1
			end
		end
		if cacheF == CacheFlag.CACHE_RANGE then
			player.TearHeight = player.TearHeight - 5.25
		end
		if cacheF == CacheFlag.CACHE_SPEED then
			player.MoveSpeed = player.MoveSpeed + 0.25
		end
		if cacheF == CacheFlag.CACHE_LUCK then
			player.Luck = player.Luck - 1
		end
		if cacheF == CacheFlag.CACHE_TEARFLAG then
			player.TearFlags = player.TearFlags | TearFlags.TEAR_SPECTRAL
		end
		if cacheF == CacheFlag.CACHE_TEARCOLOR then
			player.TearColor = Color(1.0, 1.0, 1.0, 1.0, 0, 0, 0)
		end
		if cacheF == CacheFlag.CACHE_FAMILIARS then
			if player:HasCollectible(CollectibleType.COLLECTIBLE_LIL_HAUNT) then hauntMinions = 3 else hauntMinions = 0 end
			player:CheckFamiliar(FamiliarVariant.LIL_HAUNT, hauntMinions, RNG())
			--end
		end
	elseif data.currentMode == RebekahCurse.REBECCA_MODE.GoldHearts then
		if cacheF == CacheFlag.CACHE_DAMAGE then
			player.Damage = player.Damage + 1.00
		end
		if cacheF == CacheFlag.CACHE_SPEED then
			player.MoveSpeed = player.MoveSpeed - 0.15
		end
		if cacheF == CacheFlag.CACHE_FIREDELAY then
			player.MaxFireDelay = player.MaxFireDelay + 4
		end
		if cacheF == CacheFlag.CACHE_LUCK then
			player.Luck = player.Luck + 3
		end
	elseif data.currentMode == RebekahCurse.REBECCA_MODE.EvilHearts then
		--[[if player:GetHearts() < 1 then
			if cacheF == CacheFlag.CACHE_DAMAGE then
				player.Damage = player.Damage / 2
			end
			if cacheF == CacheFlag.CACHE_FIREDELAY then
				player.MaxFireDelay = player.MaxFireDelay - 2
			end
			if cacheF == CacheFlag.CACHE_SPEED then
				player.MoveSpeed = player.MoveSpeed + 0.20
			end
			if cacheF == CacheFlag.CACHE_LUCK then
				player.Luck = player.Luck
			end
		else]]
			if cacheF == CacheFlag.CACHE_DAMAGE then
				player.Damage = player.Damage * 1.20
			end
			if cacheF == CacheFlag.CACHE_FIREDELAY then
				player.MaxFireDelay = player.MaxFireDelay + 2
			end
			if cacheF == CacheFlag.CACHE_SPEED then
				player.MoveSpeed = player.MoveSpeed - 0.10
			end
			if cacheF == CacheFlag.CACHE_LUCK then
				player.Luck = player.Luck - 1
			end
		--end
	elseif data.currentMode == RebekahCurse.REBECCA_MODE.EternalHearts then
		if cacheF == CacheFlag.CACHE_FIREDELAY then
			player.MaxFireDelay = player.MaxFireDelay + 2
		end
		if cacheF == CacheFlag.CACHE_DAMAGE then
			player.Damage = player.Damage * 0.35
		end
		if cacheF == CacheFlag.CACHE_SPEED then
			player.MoveSpeed = player.MoveSpeed + 0.20
		end
		if cacheF == CacheFlag.CACHE_LUCK then
			player.Luck = player.Luck - 2
		end
		if cacheF == CacheFlag.CACHE_FLYING then
			player.CanFly = true
		end
		if cacheF == CacheFlag.CACHE_TEARFLAG then
			player.TearFlags = player.TearFlags | TearFlags.TEAR_PIERCING
		end
	elseif data.currentMode == RebekahCurse.REBECCA_MODE.BoneHearts then
		if cacheF == CacheFlag.CACHE_DAMAGE then
			player.Damage = player.Damage * 1.1
		end
		if cacheF == CacheFlag.CACHE_FIREDELAY then
			player.MaxFireDelay = player.MaxFireDelay
		end
		if cacheF == CacheFlag.CACHE_SPEED then
			player.MoveSpeed = player.MoveSpeed + 0.30
		end
	elseif data.currentMode == RebekahCurse.REBECCA_MODE.BrideRedHearts then
		if cacheF == CacheFlag.CACHE_DAMAGE then
			player.Damage = player.Damage - 1.73
		end
		if cacheF == CacheFlag.CACHE_LUCK then
			player.Luck = player.Luck - 0.13
		end
		if cacheF == CacheFlag.CACHE_FLYING then
			player.CanFly = true
		end
	elseif data.currentMode == RebekahCurse.REBECCA_MODE.RottenHearts then
		if cacheF == CacheFlag.CACHE_FIREDELAY then
			if player.MaxFireDelay >= 4 then
				player.MaxFireDelay = player.MaxFireDelay - 1
			end
		end
		if cacheF == CacheFlag.CACHE_SPEED then
			player.MoveSpeed = player.MoveSpeed - 0.10
		end
		if cacheF == CacheFlag.CACHE_DAMAGE then
			player.Damage = player.Damage / 2
		end
	elseif data.currentMode == RebekahCurse.REBECCA_MODE.BrokenHearts then
		if cacheF == CacheFlag.CACHE_SPEED then
			player.MoveSpeed = player.MoveSpeed - 0.25
		end
		if cacheF == CacheFlag.CACHE_DAMAGE then
			if yandereWaifu.GetEntityData(player).BrokenBuff then
				player.Damage = player.Damage + 40.00
			else
				player.Damage = player.Damage
			end
			if yandereWaifu.GetEntityData(player).tankAmount then
				if cacheF == CacheFlag.CACHE_DAMAGE then
					player.Damage = player.Damage + yandereWaifu.GetEntityData(player).tankAmount/4
				end
			end
		end
		if cacheF == CacheFlag.CACHE_LUCK then
			if yandereWaifu.GetEntityData(player).BrokenLuck then
				player.Luck = player.Luck + 50.00
			else
				player.Luck = player.Luck
			end
		end
	elseif data.currentMode == RebekahCurse.REBECCA_MODE.ImmortalHearts then
		if cacheF == CacheFlag.CACHE_DAMAGE then
			player.Damage = player.Damage - 1.50
		end
		if cacheF == CacheFlag.CACHE_SPEED then
			player.MoveSpeed = player.MoveSpeed - 0.10
		end
	

	elseif data.currentMode == RebekahCurse.REBECCA_MODE.HalfRedHearts then
		if cacheF == CacheFlag.CACHE_DAMAGE then
			player.Damage = player.Damage - 0.73 --1.73
		end
		if cacheF == CacheFlag.CACHE_LUCK then
			player.Luck = player.Luck - 0.13
		end
		if cacheF == CacheFlag.CACHE_SPEED then
			player.MoveSpeed = player.MoveSpeed + 0.15
		end
	end
end

return cache