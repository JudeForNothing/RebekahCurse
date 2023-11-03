yandereWaifu:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, function()
	local isRebekahThere = false
	if not yandereWaifu.AreAchievementsEnabled() and not yandereWaifu.CanRunUnlockAchievements() and not yandereWaifu.CanChallengeRunUnlockAchievements() then return end
	for i=0, InutilLib.game:GetNumPlayers()-1 do
		local player = Isaac.GetPlayer(i)
		if yandereWaifu.IsNormalRebekah(player) then
			isRebekahThere = true
		end
	end
	local room = InutilLib.game:GetRoom()
	if room:GetType() == RoomType.ROOM_BOSS and InutilLib.game:GetLevel():GetStage() ~= LevelStage.STAGE7 then --the aloof
		local boss = room:GetBossID()
		if boss == 6 or boss == 89 then -- Mom / Maus Mom
            if not yandereWaifu.ACHIEVEMENT.REBEKAH_SOUL:IsUnlocked() and isRebekahThere then
                yandereWaifu.ACHIEVEMENT.REBEKAH_SOUL:Unlock()
				--InutilLib.AnimateIsaacAchievement("gfx/ui/achievement/achievement_soul_personality.png", nil, true, 60)
			end
		end
	end
end)


yandereWaifu:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function(_, player)
	local data = yandereWaifu.GetEntityData(player)

	if not yandereWaifu.AreAchievementsEnabled() then return end
	if yandereWaifu.GetPlayerBlackHearts(player) >= 12 and not yandereWaifu.ACHIEVEMENT.REBEKAH_EVIL:IsUnlocked() then -- the mischevious
		yandereWaifu.ACHIEVEMENT.REBEKAH_EVIL:Unlock()
		--InutilLib.AnimateIsaacAchievement("gfx/ui/achievement/achievement_evil_personality.png", nil, true, 60)
	end
	if player:HasPlayerForm(PlayerForm.PLAYERFORM_ANGEL) and not yandereWaifu.ACHIEVEMENT.REBEKAH_ETERNAL:IsUnlocked() then -- the kind
		yandereWaifu.ACHIEVEMENT.REBEKAH_ETERNAL:Unlock()
		--InutilLib.AnimateIsaacAchievement("gfx/ui/achievement/achievement_eternal_personality.png", nil, true, 60)
	end
	if ( (player:HasCollectible(CollectibleType.COLLECTIBLE_HOLY_MANTLE) and player:HasTrinket(TrinketType.TRINKET_WOODEN_CROSS)) or (ComplianceImmortal)) and not yandereWaifu.ACHIEVEMENT.REBEKAH_IMMORTAL:IsUnlocked() then -- the guardian
		yandereWaifu.ACHIEVEMENT.REBEKAH_IMMORTAL:Unlock()
		--InutilLib.AnimateIsaacAchievement("gfx/ui/achievement/achievement_immortal_personality.png", nil, true, 60)
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
		--InutilLib.AnimateIsaacAchievement("gfx/ui/achievement/achievement_bone_personality.png", nil, true, 60)
	end
	if player:GetRottenHearts() >= 3 and not yandereWaifu.ACHIEVEMENT.REBEKAH_ROTTEN:IsUnlocked() then -- the crazy
		yandereWaifu.ACHIEVEMENT.REBEKAH_ROTTEN:Unlock()
		--InutilLib.AnimateIsaacAchievement("gfx/ui/achievement/achievement_rotten_personality.png", nil, true, 60)
	end
	if player:GetBrokenHearts() >= 12 and not yandereWaifu.ACHIEVEMENT.REBEKAH_BROKEN:IsUnlocked() then -- the crazy
		yandereWaifu.ACHIEVEMENT.REBEKAH_BROKEN:Unlock()
		--InutilLib.AnimateIsaacAchievement("gfx/ui/achievement/achievement_broken_personality.png", nil, true, 60)
	end
end)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
	for i=0, InutilLib.game:GetNumPlayers()-1 do
		local player = Isaac.GetPlayer(i)
		local data = yandereWaifu.GetEntityData(player)

		if not yandereWaifu.ACHIEVEMENT.REBEKAH_GOLD:IsUnlocked() and yandereWaifu.AreAchievementsEnabled() then
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
				--InutilLib.AnimateIsaacAchievement("gfx/ui/achievement/achievement_gold_personality.png", nil, true, 60)
			end
		end
	end
end)


--TAINTED UNLOCK
--got this code from Arachna
local function rebekahInCloset()
	local room = InutilLib.game:GetRoom()
	--if you're arachna, you're in home and tainted version was not unlocked
	if (not yandereWaifu.ACHIEVEMENT.TAINTED_REBEKAH:IsUnlocked()) and (InutilLib.game:GetLevel():GetStage() == 13) and yandereWaifu.IsNormalRebekah(Isaac.GetPlayer(0)) then
		--if you're entering the dark closet for the first time
		if (room:GetRoomShape() == 2) and (room:GetBackdropType() == 53) then
			return true
		end
	end
	return false
end
--on closet enter
local function spawnLayingIsaac(ent)
	local isaacLay = Isaac.Spawn(6, 14, 0, ent.Position, Vector(0,0), nil)
	--isaacLay:GetSprite():ReplaceSpritesheet(0, "gfx/characters/costumes/character_arachna_b.png")
	isaacLay:GetSprite():LoadGraphics()
	ent:Remove()
	local sprite = isaacLay:GetSprite()
	sprite:ReplaceSpritesheet(0, "gfx/characters/costumes/character_017_theforgotten.png")
	sprite:LoadGraphics()

	if yandereWaifu.IsTaintedRebekah(Isaac.GetPlayer()) then
		local door = room:GetDoor(2)
		room:RemoveGridEntity(door:GetGridIndex(), 0, false)

		for i = 1, 3 do
			Isaac.Spawn(1000, 21, 0, centre, Vector.Zero, nil)
		end

		Isaac.Spawn(1000, 64, 0, centre, Vector.Zero, nil)
	end
end
function yandereWaifu:closetTaintedRebekah()
	if rebekahInCloset() and (InutilLib.game:GetRoom():IsFirstVisit()) then
		--replace shopkeeper or a pedestal with a laying isaac
		local wasReplaced = false
		for _, ent in pairs(Isaac.FindByType(17, -1, -1, false, false)) do	
			if not wasReplaced then
				spawnLayingIsaac(ent)
			end
		end
		for _, ent in pairs(Isaac.FindByType(5, 100, -1, false, false)) do	
			if not wasReplaced then
				spawnLayingIsaac(ent)
			end
		end
	end 
end
yandereWaifu:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, yandereWaifu.closetTaintedRebekah)
--laying isaac update (replace sprite, do unlock)
function yandereWaifu:layingIsaacUpdate()
	if rebekahInCloset() then
		local tainteds = Isaac.FindByType(6, 14)
		for _, ent in pairs(tainteds) do
			local sprite = ent:GetSprite()
			local data = ent:GetData()
			--init
			--[[if not data.init then
				sprite:ReplaceSpritesheet(0, "gfx/characters/costumes/character_arachna_b.png")
				sprite:LoadGraphics()
				data.init = true
			end]]
			--UNLOCK ON ANIMATION END
			if sprite:IsFinished ("PayPrize") then
				yandereWaifu.ACHIEVEMENT.TAINTED_REBEKAH:Unlock()
				--InutilLib.AnimateIsaacAchievement("gfx/ui/achievement/achievement_rebekahb.png", nil, true, 60)
			end
		end
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_POST_UPDATE, yandereWaifu.layingIsaacUpdate)
