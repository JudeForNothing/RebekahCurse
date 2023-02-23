yandereWaifu:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, function()
	local isRebekahThere = false
	for i=0, ILIB.game:GetNumPlayers()-1 do
		local player = Isaac.GetPlayer(i)
		if yandereWaifu.IsNormalRebekah(player) then
			isRebekahThere = true
		end
	end
	local room = ILIB.game:GetRoom()
	if room:GetType() == RoomType.ROOM_BOSS and ILIB.game:GetLevel():GetStage() ~= LevelStage.STAGE7 then --the aloof
		local boss = room:GetBossID()
		if boss == 6 or boss == 89 then -- Mom / Maus Mom
            if not yandereWaifu.ACHIEVEMENT.REBEKAH_SOUL:IsUnlocked() and isRebekahThere then
                yandereWaifu.ACHIEVEMENT.REBEKAH_SOUL:Unlock()
				InutilLib.AnimateIsaacAchievement("gfx/ui/achievement/achievement_soul_personality.png", nil, true, 60)
			end
		end
	end
end)


yandereWaifu:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function(_, player)
	local data = yandereWaifu.GetEntityData(player)
	if yandereWaifu.GetPlayerBlackHearts(player) >= 12 and not yandereWaifu.ACHIEVEMENT.REBEKAH_EVIL:IsUnlocked() then -- the mischevious
		yandereWaifu.ACHIEVEMENT.REBEKAH_EVIL:Unlock()
		InutilLib.AnimateIsaacAchievement("gfx/ui/achievement/achievement_evil_personality.png", nil, true, 60)
	end
	if player:HasPlayerForm(PlayerForm.PLAYERFORM_ANGEL) and not yandereWaifu.ACHIEVEMENT.REBEKAH_ETERNAL:IsUnlocked() then -- the kind
		yandereWaifu.ACHIEVEMENT.REBEKAH_ETERNAL:Unlock()
		InutilLib.AnimateIsaacAchievement("gfx/ui/achievement/achievement_eternal_personality.png", nil, true, 60)
	end
	if ( (player:HasCollectible(CollectibleType.COLLECTIBLE_HOLY_MANTLE) and player:HasTrinket(TrinketType.TRINKET_WOODEN_CROSS)) or (ComplianceImmortal)) and not yandereWaifu.ACHIEVEMENT.REBEKAH_IMMORTAL:IsUnlocked() then -- the guardian
		yandereWaifu.ACHIEVEMENT.REBEKAH_IMMORTAL:Unlock()
		InutilLib.AnimateIsaacAchievement("gfx/ui/achievement/achievement_immortal_personality.png", nil, true, 60)
	end

	-- the royal code
	if not yandereWaifu.ACHIEVEMENT.REBEKAH_GOLD:IsUnlocked() then
		if player:GetGoldenHearts() > 0 then
			data.PersistentPlayerData.GoldenHeartCount = player:GetGoldenHearts()
		end
		if data.PersistentPlayerData.GoldenHeartCount and data.PersistentPlayerData.GoldenHeartCount > player:GetGoldenHearts() then
			data.PersistentPlayerData.GoldenHeartCount = 0
			data.PersistentPlayerData.GoldenHeartRebekahUnlockTimes = 0
		end
	end

	if player:GetBoneHearts() >= 3 and not yandereWaifu.ACHIEVEMENT.REBEKAH_BONE:IsUnlocked() then -- the weird
		yandereWaifu.ACHIEVEMENT.REBEKAH_BONE:Unlock()
		InutilLib.AnimateIsaacAchievement("gfx/ui/achievement/achievement_bone_personality.png", nil, true, 60)
	end
	if player:GetRottenHearts() >= 6 and not yandereWaifu.ACHIEVEMENT.REBEKAH_ROTTEN:IsUnlocked() then -- the crazy
		yandereWaifu.ACHIEVEMENT.REBEKAH_ROTTEN:Unlock()
		InutilLib.AnimateIsaacAchievement("gfx/ui/achievement/achievement_rotten_personality.png", nil, true, 60)
	end
end)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
	for i=0, ILIB.game:GetNumPlayers()-1 do
		local player = Isaac.GetPlayer(i)
		local data = yandereWaifu.GetEntityData(player)

		if not yandereWaifu.ACHIEVEMENT.REBEKAH_GOLD:IsUnlocked()  then
			--if has golden heart
			if not data.PersistentPlayerData.GoldenHeartCount then data.PersistentPlayerData.GoldenHeartCount = 0 end
			if data.PersistentPlayerData.GoldenHeartCount > 0 then
				if not data.PersistentPlayerData.GoldenHeartRebekahUnlockTimes then
					data.PersistentPlayerData.GoldenHeartRebekahUnlockTimes = 1
				else
					data.PersistentPlayerData.GoldenHeartRebekahUnlockTimes = data.PersistentPlayerData.GoldenHeartRebekahUnlockTimes + 1
				end
			end

			if data.PersistentPlayerData.GoldenHeartRebekahUnlockTimes and data.PersistentPlayerData.GoldenHeartRebekahUnlockTimes >= 2 then
				yandereWaifu.ACHIEVEMENT.REBEKAH_GOLD:Unlock()
				InutilLib.AnimateIsaacAchievement("gfx/ui/achievement/achievement_gold_personality.png", nil, true, 60)
			end
		end
	end
end)


