local yandereWaifu = yandereWaifu
local game = Game()

local playertype_cache =  yandereWaifu.CACHED_PLAYERTYPE_CACHE or {}
yandereWaifu.CACHED_PLAYERTYPE_CACHE = playertype_cache

local unlocksHolder = {}
local unlocksHolder2 = {}

local DifficultyToCompletionMap = {
	[Difficulty.DIFFICULTY_NORMAL]	 = 1,
	[Difficulty.DIFFICULTY_HARD]	 = 2,
	[Difficulty.DIFFICULTY_GREED]	 = 1,
	[Difficulty.DIFFICULTY_GREEDIER] = 2,
}

local BossID = { -- Only the relevant ones
	HEART 		= 8,
	SATAN 		= 24,
	IT_LIVES	= 25,
	ISAAC		= 39,
	BLUE_BABY	= 40,
	LAMB		= 54,
	MEGA_SATAN	= 55,
	GREED		= 62,
	HUSH		= 63,
	DELIRIUM	= 70,
	GREEDIER	= 71,
	MOTHER		= 88,
	MAUS_HEART	= 90,
	BEAST		= 100,
}

local noteLayer = {
	DELI 	= 0,
	HEART	= 1,
	ISAAC	= 2,
	SATAN	= 3,
	RUSH 	= 4,
	BBABY 	= 5,
	LAMB 	= 6,
	MEGA 	= 7,
	GREED 	= 8,
	HUSH 	= 9,
	MOTHER 	= 10,
	BEAST 	= 11,
}

local associationToValueMap = {
	Heart 		= "heart",
	Isaac 		= "isaac",
	BlueBaby 	= "bbaby",
	Satan 		= "satan",
	Lamb		= "lamb",
	BossRush 	= "rush",
	Hush 		= "hush",
	Delirium 	= "deli",
	MegaSatan 	= "mega",
	Mother		= "mother",
	Beast		= "beast",
	Greed 		= "greed",
	Greedier 	= "greed",
}

local associationTestValue = {
	Heart 		= 2,
	Isaac 		= 1,
	BlueBaby 	= 1,
	Satan 		= 1,
	Lamb		= 1,
	BossRush 	= 1,
	Hush 		= 1,
	Delirium 	= 1,
	MegaSatan 	= 1,
	Mother 		= 1,
	Beast 		= 1,
	Greed 		= 1,
	Greedier 	= 2,
}

function yandereWaifu.UniversalRemoveItemFromPools(item)
	yandereWaifu.RemoveItemFromCustomItemPools(item)

	local itempool = game:GetItemPool()
	itempool:RemoveCollectible(item)
end

function yandereWaifu.UniversalRemoveTrinketFromPools(trinket)
	yandereWaifu.RemoveTrinketFromCustomItemPools(trinket)

	local itempool = game:GetItemPool()
	itempool:RemoveTrinket(trinket)
end

local unlockTypeToRemoveFunction = {
	collectible	= yandereWaifu.UniversalRemoveItemFromPools,
	trinket		= yandereWaifu.UniversalRemoveTrinketFromPools,
}

local function setDefaultValues(lookupStr, isTainted)
    RebekahLocalSavedata.CompletionMarks[lookupStr] = {
        lookupstr    = lookupStr,
        istainted    = isTainted,

        heart    = 0,
        isaac    = 0,
        bbaby    = 0,
        satan    = 0,
        lamb    = 0,
        rush    = 0,
        hush    = 0,
        deli    = 0,
        mega    = 0,
        greed    = 0,
        mother    = 0,
        beast    = 0,
    }
end

function yandereWaifu.InitCharacterCompletion(playername, tainted, forceTaintedCompletion)
    local lookup = string.lower(playername)
    if tainted then lookup = lookup .. "b" end

    forceTaintedCompletion = forceTaintedCompletion ~= nil and forceTaintedCompletion or tainted
    RebekahLocalSavedata.CompletionMarks = RebekahLocalSavedata.CompletionMarks or {}

    playertype_cache[lookup] = Isaac.GetPlayerTypeByName(playername, tainted)

    if not RebekahLocalSavedata.CompletionMarks[lookup] then
        setDefaultValues(lookup, forceTaintedCompletion)
    end
end

function yandereWaifu.ResetCharacterCompletion(playerType)
    for key, dataset in pairs(RebekahLocalSavedata.CompletionMarks) do
        if playertype_cache[key] == playerType then
            setDefaultValues(dataset.lookupstr, dataset.istainted)
        end
    end
end

function yandereWaifu.GetCompletionNoteLayerDataFromPlayerType(playerType)
	for key, dataset in pairs(RebekahLocalSavedata.CompletionMarks) do
		print(playertype_cache[key])
		print(playerType)
		print("HELP")
		if playertype_cache[key] == playerType then
			return {
				[noteLayer.DELI] 	= dataset.deli + (dataset.istainted and 3 or 0),
				[noteLayer.HEART] 	= dataset.heart,
				[noteLayer.ISAAC] 	= dataset.isaac,
				[noteLayer.SATAN] 	= dataset.satan,
				[noteLayer.RUSH] 	= dataset.rush,
				[noteLayer.BBABY] 	= dataset.bbaby,
				[noteLayer.LAMB] 	= dataset.lamb,
				[noteLayer.MEGA] 	= dataset.mega,
				[noteLayer.GREED] 	= dataset.greed,
				[noteLayer.HUSH] 	= dataset.hush,
				[noteLayer.MOTHER] 	= dataset.mother,
				[noteLayer.BEAST] 	= dataset.beast,
			}
		end
	end
end

function yandereWaifu.AssociateCompletionUnlocks(playerType, unlockset)
	for key, value in pairs(playertype_cache) do
		if value == playerType then
			unlocksHolder[key] = unlockset
		end
	end
end

function yandereWaifu.AssociateItemWithTest(unlockType, itemID, conditionFunction)
	table.insert(unlocksHolder2, {
		Type = unlockType,
		ID = itemID,
		Check = conditionFunction,
	})
end

function yandereWaifu.AssociateItemsWithTests(dataset)
	for _, data in pairs(dataset) do
		yandereWaifu.AssociateItemWithTest(table.unpack(data))
	end
end

local function HasPlayerAchievedQuartet(playerKey)
	return (
		RebekahLocalSavedata.CompletionMarks[playerKey].isaac >= 1 and
		RebekahLocalSavedata.CompletionMarks[playerKey].bbaby >= 1 and
		RebekahLocalSavedata.CompletionMarks[playerKey].satan >= 1 and
		RebekahLocalSavedata.CompletionMarks[playerKey].lamb >= 1
	)
end

local function HasPlayerAchievedDuet(playerKey)
	return (
		RebekahLocalSavedata.CompletionMarks[playerKey].rush >= 1 and
		RebekahLocalSavedata.CompletionMarks[playerKey].hush >= 1
	)
end

local function TestUnlock(playerKey, unlockType)
	if unlockType == "All" then
		local allHard = true

		for key, value in pairs(RebekahLocalSavedata.CompletionMarks[playerKey]) do
			if type(value) == "number" then
				if value < 2 then
					allHard = false
					break
				end
			end
		end

		return allHard
	elseif unlockType == "Quartet" then
		return HasPlayerAchievedQuartet(playerKey)
	elseif unlockType == "Duet" then
		return HasPlayerAchievedDuet(playerKey)
	else
		return RebekahLocalSavedata.CompletionMarks[playerKey][associationToValueMap[unlockType]] >= associationTestValue[unlockType]
	end
end

function yandereWaifu.IsCompletionMarkUnlocked(playerKey, unlockType)
	return TestUnlock(string.lower(playerKey), unlockType)
end

function yandereWaifu.IsCompletionItemUnlocked(itemID)
	for _, data in pairs(unlocksHolder2) do
		if data.Type == "collectible" and data.ID == itemID and data.Check() then
			return true
		end
	end

	for playerKey, dataset in pairs(unlocksHolder) do
		for unlockType, unlockData in pairs(dataset) do
			if unlockData[1] == "collectible" and unlockData[2] == itemID then
				return TestUnlock(playerKey, unlockType)
			end
		end
	end

	return true
end

function yandereWaifu.IsCompletionTrinketUnlocked(trinketID)
	for _, data in pairs(unlocksHolder2) do
		if data.Type == "trinket" and data.ID == trinketID and data.Check() then
			return true
		end
	end

	for playerKey, dataset in pairs(unlocksHolder) do
		for unlockType, unlockData in pairs(dataset) do
			if unlockData[1] == "trinket" and unlockData[2] == trinketID then
				return TestUnlock(playerKey, unlockType)
			end
		end
	end

	return true
end

function yandereWaifu.RemoveLockedItemsAndTrinkets()
	local itempool = game:GetItemPool()

	for playerKey, dataset in pairs(unlocksHolder) do
		for unlockType, unlockData in pairs(dataset) do
			if unlockData[1] == "collectible" then
				if not TestUnlock(playerKey, unlockType) then
					itempool:RemoveCollectible(unlockData[2])
				end
			elseif unlockData[1] == "trinket" then
				if not TestUnlock(playerKey, unlockType) then
					itempool:RemoveTrinket(unlockData[2])
				end
			end
		end
	end

	for _, data in pairs(unlocksHolder2) do
		if not data.Check() then
			if data.Type == "collectible" then
				itempool:RemoveCollectible(data.ID)
			elseif data.Type == "trinket" then
				itempool:RemoveTrinket(data.ID)
			end
		end
	end
end

function yandereWaifu.RemoveLockedTrinkets()
	local itempool = game:GetItemPool()

	for playerKey, dataset in pairs(unlocksHolder) do
		for unlockType, unlockData in pairs(dataset) do
			if unlockData[1] == "trinket" then
				if not TestUnlock(playerKey, unlockType) then
					itempool:RemoveTrinket(unlockData[2])
				end
			end
		end
	end

	for _, data in pairs(unlocksHolder2) do
		if not data.Check() then
			if data.Type == "trinket" then
				itempool:RemoveTrinket(data.ID)
			end
		end
	end
end

function CheckOnCompletionFunctions(playerKey, unlockKey, newValue, skipAll)
	print("outfitsness")
	if unlocksHolder[playerKey] and unlocksHolder[playerKey][unlockKey] then
		if unlockKey ~= "All" and RebekahLocalSavedata.CompletionMarks[playerKey][associationToValueMap[unlockKey]] < associationTestValue[unlockKey] and newValue >= associationTestValue[unlockKey] then
			if unlocksHolder[playerKey][unlockKey] then
				unlocksHolder[playerKey][unlockKey][3]()
			end
		end

		if unlockKey ~= "Greed" and not skipAll then
			local allHard = true
			local oldAllHard

			for key, value in pairs(RebekahLocalSavedata.CompletionMarks[playerKey]) do
				if type(value) == "number" then
					local num = value
					if num < 2 then
						oldAllHard = false
					end

					if key == associationToValueMap[unlockKey] then
						num = newValue
					end

					if num < 2 then
						allHard = false
						break
					end
				end
			end

			if allHard and not oldAllHard and unlocksHolder[playerKey].All then
				unlocksHolder[playerKey].All[3]()
			end
		end
	end
end

local antiRecursion = false
yandereWaifu:AddCallback(ModCallbacks.MC_GET_TRINKET, function(_, trinket, rng)
	if not antiRecursion and not yandereWaifu.IsCompletionTrinketUnlocked(trinket) then
		antiRecursion = true

		yandereWaifu.RemoveLockedTrinkets()

		local itempool = game:GetItemPool()
		local new = itempool:GetTrinket()

		antiRecursion = false

		return new
	end
end)



yandereWaifu:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, function()
	if yandereWaifu.CanRunUnlockAchievements() then
		local room = game:GetRoom()
		local roomtype = room:GetType()

		local value = DifficultyToCompletionMap[game.Difficulty]
		local check

		for _, data in pairs(RebekahLocalSavedata.CompletionMarks) do
			if playertype_cache[data.lookupstr] == Isaac.GetPlayer():GetPlayerType() then
				check = data
				break
			elseif (yandereWaifu.IsNormalRebekah(Isaac.GetPlayer(playertype_cache[data.lookupstr]))) then
				--for _, data2 in pairs(RebekahLocalSavedata.CompletionMarks) do
					if playertype_cache[data.lookupstr] == RebekahCurse.TECHNICAL_REB then
						check = data
						break
					end
				--end
			elseif (yandereWaifu.IsTaintedRebekah(Isaac.GetPlayer(playertype_cache[data.lookupstr]))) then
				--for _, data2 in pairs(RebekahLocalSavedata.CompletionMarks) do
					if playertype_cache[data.lookupstr] == RebekahCurse.SADREBEKAH then
						check = data
						break
					end
				--end
			end
		end

		if check then
			if roomtype == RoomType.ROOM_BOSS then
				local boss = room:GetBossID()

				local playerKey = check.lookupstr
				local taintedCompletion = check.istainted

				if game:GetLevel():GetStage() == LevelStage.STAGE7 then -- Void

					if boss == BossID.DELIRIUM then
						if value > check.deli then
							CheckOnCompletionFunctions(playerKey, "Delirium", value, taintedCompletion)
						end

						check.deli = math.max(check.deli, value)
					end
				else
					if boss == BossID.HEART or boss == BossID.IT_LIVES or boss == BossID.MAUS_HEART then
						if value > check.heart and not taintedCompletion then
							CheckOnCompletionFunctions(playerKey, "Heart", value)
						end

						check.heart = math.max(check.heart, value)
					elseif boss == BossID.ISAAC then
						local wasQuartetAchieved = taintedCompletion and HasPlayerAchievedQuartet(playerKey)

						if value > check.isaac and not taintedCompletion then
							CheckOnCompletionFunctions(playerKey, "Isaac", value)
						end

						check.isaac = math.max(check.isaac, value)
						local isQuartetAchieved = taintedCompletion and HasPlayerAchievedQuartet(playerKey)
						if isQuartetAchieved and not wasQuartetAchieved then
							unlocksHolder[playerKey].Quartet[3]()
						end
					elseif boss == BossID.BLUE_BABY then
						local wasQuartetAchieved = taintedCompletion and HasPlayerAchievedQuartet(playerKey)

						if value > check.bbaby and not taintedCompletion then
							CheckOnCompletionFunctions(playerKey, "BlueBaby", value)
						end

						check.bbaby = math.max(check.bbaby, value)
						local isQuartetAchieved = taintedCompletion and HasPlayerAchievedQuartet(playerKey)
						if isQuartetAchieved and not wasQuartetAchieved then
							unlocksHolder[playerKey].Quartet[3]()
						end
					elseif boss == BossID.SATAN then
						local wasQuartetAchieved = taintedCompletion and HasPlayerAchievedQuartet(playerKey)

						if value > check.satan and not taintedCompletion then
							CheckOnCompletionFunctions(playerKey, "Satan", value)
						end

						check.satan = math.max(check.satan, value)
						local isQuartetAchieved = taintedCompletion and HasPlayerAchievedQuartet(playerKey)
						if isQuartetAchieved and not wasQuartetAchieved then
							unlocksHolder[playerKey].Quartet[3]()
						end
					elseif boss == BossID.LAMB then
						local wasQuartetAchieved = taintedCompletion and HasPlayerAchievedQuartet(playerKey)

						if value > check.lamb and not taintedCompletion then
							CheckOnCompletionFunctions(playerKey, "Lamb", value)
						end

						check.lamb = math.max(check.lamb, value)
						local isQuartetAchieved = taintedCompletion and HasPlayerAchievedQuartet(playerKey)
						if isQuartetAchieved and not wasQuartetAchieved then
							unlocksHolder[playerKey].Quartet[3]()
						end
					elseif boss == BossID.HUSH then
						local wasDuetAchieved = taintedCompletion and HasPlayerAchievedDuet(playerKey)

						if value > check.hush and not taintedCompletion then
							CheckOnCompletionFunctions(playerKey, "Hush", value)
						end

						check.hush = math.max(check.hush, value)
						local isDuetAchieved = taintedCompletion and HasPlayerAchievedDuet(playerKey)
						if isDuetAchieved and not wasDuetAchieved then
							unlocksHolder[playerKey].Duet[3]()
						end
					elseif boss == BossID.MEGA_SATAN then
						if value > check.mega then
							CheckOnCompletionFunctions(playerKey, "MegaSatan", value, taintedCompletion)
						end

						check.mega = math.max(check.mega, value)
					elseif boss == BossID.GREED or boss == BossID.GREEDIER then
						if value > check.greed then
							if not check.istainted then
								CheckOnCompletionFunctions(playerKey, "Greed", value)
							end
							CheckOnCompletionFunctions(playerKey, "Greedier", value, taintedCompletion)
						end

						check.greed = math.max(check.greed, value)
					elseif boss == BossID.MOTHER then
						if value > check.mother then
							CheckOnCompletionFunctions(playerKey, "Mother", value, taintedCompletion)
						end

						check.mother = math.max(check.mother, value)
					end
				end
			elseif roomtype == RoomType.ROOM_BOSSRUSH then
				local wasDuetAchieved = check.istainted and HasPlayerAchievedDuet(check.lookupstr)

				if value > check.rush and not check.istainted then
					CheckOnCompletionFunctions(check.lookupstr, "BossRush", value)
				end

				check.rush = math.max(check.rush, value)
				local isDuetAchieved = check.istainted and HasPlayerAchievedDuet(check.lookupstr)
				if isDuetAchieved and not wasDuetAchieved then
					unlocksHolder[playerKey].Duet[3]()
				end
			end
		end
	end
end)

--[[
yandereWaifu:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, function()
	if yandereWaifu.CanRunUnlockAchievements() true then
		local room = game:GetRoom()
		local roomtype = room:GetType()

		local value = DifficultyToCompletionMap[game.Difficulty]
		local check

		for _, data in pairs(RebekahLocalSavedata.CompletionMarks) do
			print(playertype_cache[data.lookupstr])
			print("iraq")
			print(Isaac.GetPlayer():GetPlayerType())
			if playertype_cache[data.lookupstr] == Isaac.GetPlayer():GetPlayerType() then
				check = data
				print("vsauce")
				break
			elseif (yandereWaifu.IsNormalRebekah(Isaac.GetPlayer(playertype_cache[data.lookupstr]))) then
				for _, data2 in pairs(RebekahLocalSavedata.CompletionMarks) do
					if playertype_cache[data.lookupstr] == RebekahCurse.TECHNICAL_REB then
						check = data2
						print("vsauce2")
						print(check)
						break
					end
				end
			end
		end

		if check then
			if roomtype == RoomType.ROOM_BOSS then
				local boss = room:GetBossID()

				local playerKey = check.lookupstr
				local taintedCompletion = check.istainted

				if game:GetLevel():GetStage() == LevelStage.STAGE7 then -- Void

					if boss == BossID.DELIRIUM then
						if value > check.deli then
							CheckOnCompletionFunctions(playerKey, "Delirium", value, taintedCompletion)
						end

						check.deli = math.max(check.deli, value)
					end
				else
					if boss == BossID.HEART or boss == BossID.IT_LIVES or boss == BossID.MAUS_HEART then
						if value > check.heart and not taintedCompletion then
							CheckOnCompletionFunctions(playerKey, "Heart", value)
						end

						check.heart = math.max(check.heart, value)
					elseif boss == BossID.ISAAC then
						local wasQuartetAchieved = taintedCompletion and HasPlayerAchievedQuartet(playerKey)

						if value > check.isaac and not taintedCompletion then
							CheckOnCompletionFunctions(playerKey, "Isaac", value)
						end

						check.isaac = math.max(check.isaac, value)
						local isQuartetAchieved = taintedCompletion and HasPlayerAchievedQuartet(playerKey)
						if isQuartetAchieved and not wasQuartetAchieved then
							unlocksHolder[playerKey].Quartet[3]()
						end
					elseif boss == BossID.BLUE_BABY then
						local wasQuartetAchieved = taintedCompletion and HasPlayerAchievedQuartet(playerKey)

						if value > check.bbaby and not taintedCompletion then
							CheckOnCompletionFunctions(playerKey, "BlueBaby", value)
						end

						check.bbaby = math.max(check.bbaby, value)
						local isQuartetAchieved = taintedCompletion and HasPlayerAchievedQuartet(playerKey)
						if isQuartetAchieved and not wasQuartetAchieved then
							unlocksHolder[playerKey].Quartet[3]()
						end
					elseif boss == BossID.SATAN then
						local wasQuartetAchieved = taintedCompletion and HasPlayerAchievedQuartet(playerKey)

						if value > check.satan and not taintedCompletion then
							CheckOnCompletionFunctions(playerKey, "Satan", value)
						end

						check.satan = math.max(check.satan, value)
						local isQuartetAchieved = taintedCompletion and HasPlayerAchievedQuartet(playerKey)
						if isQuartetAchieved and not wasQuartetAchieved then
							unlocksHolder[playerKey].Quartet[3]()
						end
					elseif boss == BossID.LAMB then
						local wasQuartetAchieved = taintedCompletion and HasPlayerAchievedQuartet(playerKey)

						if value > check.lamb and not taintedCompletion then
							CheckOnCompletionFunctions(playerKey, "Lamb", value)
						end

						check.lamb = math.max(check.lamb, value)
						local isQuartetAchieved = taintedCompletion and HasPlayerAchievedQuartet(playerKey)
						if isQuartetAchieved and not wasQuartetAchieved then
							unlocksHolder[playerKey].Quartet[3]()
						end
					elseif boss == BossID.HUSH then
						local wasDuetAchieved = taintedCompletion and HasPlayerAchievedDuet(playerKey)

						if value > check.hush and not taintedCompletion then
							CheckOnCompletionFunctions(playerKey, "Hush", value)
						end

						check.hush = math.max(check.hush, value)
						local isDuetAchieved = taintedCompletion and HasPlayerAchievedDuet(playerKey)
						if isDuetAchieved and not wasDuetAchieved then
							unlocksHolder[playerKey].Duet[3]()
						end
					elseif boss == BossID.MEGA_SATAN then
						if value > check.mega then
							CheckOnCompletionFunctions(playerKey, "MegaSatan", value, taintedCompletion)
						end

						check.mega = math.max(check.mega, value)
					elseif boss == BossID.GREED or boss == BossID.GREEDIER then
						if value > check.greed then
							if not check.istainted then
								CheckOnCompletionFunctions(playerKey, "Greed", value)
							end
							CheckOnCompletionFunctions(playerKey, "Greedier", value, taintedCompletion)
						end

						check.greed = math.max(check.greed, value)
					elseif boss == BossID.MOTHER then
						if value > check.mother then
							CheckOnCompletionFunctions(playerKey, "Mother", value, taintedCompletion)
						end

						check.mother = math.max(check.mother, value)
					end
				end
			elseif roomtype == RoomType.ROOM_BOSSRUSH then
				local wasDuetAchieved = check.istainted and HasPlayerAchievedDuet(check.lookupstr)
				print("piss baby")
				if value > check.rush and not check.istainted then
					CheckOnCompletionFunctions(check.lookupstr, "BossRush", value)
				end

				check.rush = math.max(check.rush, value)
				local isDuetAchieved = check.istainted and HasPlayerAchievedDuet(check.lookupstr)
				if isDuetAchieved and not wasDuetAchieved then
					unlocksHolder[playerKey].Duet[3]()
				end
			end
		end
	end
end)]]

yandereWaifu:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, function(_, npc)
	if npc.Variant == 0 and yandereWaifu.CanRunUnlockAchievements() then -- The Beast
		local value = DifficultyToCompletionMap[game.Difficulty]
		local check

		for _, data in pairs(RebekahLocalSavedata.CompletionMarks) do
			if playertype_cache[data.lookupstr] == Isaac.GetPlayer():GetPlayerType() then
				check = data
				break
			end
		end

		if check then
			if value > check.beast then
				CheckOnCompletionFunctions(check.lookupstr, "Beast", value, check.istainted)
			end

			check.beast = math.max(check.beast, value)
		end
	end
end, 951)