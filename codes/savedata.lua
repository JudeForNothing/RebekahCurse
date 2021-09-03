
--data that will be passed all around the mod
RebekahLocalSavedata = {
	bossRoomsCleared = {},
	CurrentRebeccaUnlocks = nil
}

---------------
-- UNLOCKS!! --
---------------

--boolean item stuff
BaseRebeccaUnlocks = {
	COLLECTIBLE_LUNCHBOX = false,
	COLLECTIBLE_ROMCOM = false,
	COLLECTIBLE_MIRACULOUSWOMB = false,
	COLLECTIBLE_ETERNALBOND = false,
	COLLECTIBLE_POWERLOVE = false,
	COLLECTIBLE_CURSEDSPOON = false,
	COLLECTIBLE_DICEOFFATE = false,
	TRINKET_ISAACSLOCKS = false,
	COLLECTIBLE_LOVESICK = false,
	COLLECTIBLE_SNAP = false,
	HAS_LOVERS_CARD = false,

	COLLECTIBLE_UNREQUITEDLOVE = false
}

--local RebekahLocalSavedata.CurrentRebeccaUnlocks = nil


--got an idea from community remix. thx

--delirium check
local deliriumWasInRoom = false
yandereWaifu:AddCallback(ModCallbacks.MC_POST_NPC_INIT, function(_, npc)
	deliriumWasInRoom = true
end, EntityType.ENTITY_DELIRIUM)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	deliriumWasInRoom = false
	--local deliriumCount = Isaac.CountEntities(nil, EntityType.ENTITY_DELIRIUM, -1, -1)
	--if deliriumCount then
	--	if deliriumCount > 0 then
	--		deliriumWasInRoom = true
	--	end
	--end
end)


function yandereWaifu:CheckIfAllUnlocksTrue()
	local unlockAll = true
	if RebekahLocalSavedata.CurrentRebeccaUnlocks then
		for i, v in pairs(RebekahLocalSavedata.CurrentRebeccaUnlocks) do
			if v == false and tostring(i) ~= "COLLECTIBLE_UNREQUITEDLOVE" then
				unlockAll = false
				break
				
			end
		end
	end
	return unlockAll
end

local bossRushWasCompleted = false
local ultraGreedWasDefeated = false
local roomWasCleared = false

yandereWaifu:AddCallback(ModCallbacks.MC_POST_UPDATE, function()

	local room = SAPI.game:GetRoom()
	local roomIsClear = room:IsClear()
	
	local currentStage = SAPI.game:GetLevel():GetStage()
	local roomType = room:GetType()
	
	for i,player in ipairs(SAPI.players) do
		if player:GetPlayerType() == Reb and RebekahLocalSavedata.CurrentRebeccaUnlocks and readyToUnlock then
			
			if SAPI.game:IsGreedMode() then
				if not ultraGreedWasDefeated then
					if currentStage == LevelStage.STAGE7_GREED then
						if not roomWasCleared and roomIsClear and roomType == RoomType.ROOM_BOSS and room:IsCurrentRoomLastBoss() then
							if not RebekahLocalSavedata.CurrentRebeccaUnlocks.COLLECTIBLE_POWERLOVE then --greed
								RebekahLocalSavedata.CurrentRebeccaUnlocks.COLLECTIBLE_POWERLOVE = true

								SchoolbagAPI.AnimateIsaacAchievement("gfx/ui/achievements/achievement_love_power.png", nil, true)
							end
							if SAPI.game.Difficulty == Difficulty.DIFFICULTY_GREEDIER then --ier
								if not RebekahLocalSavedata.CurrentRebeccaUnlocks.COLLECTIBLE_LOVESICK then
									RebekahLocalSavedata.CurrentRebeccaUnlocks.COLLECTIBLE_LOVESICK = true

									SchoolbagAPI.AnimateIsaacAchievement("gfx/ui/achievements/achievement_lovesick.png", nil, true)
								end
							end
						end
					end
				end
			else
				--do boss rush unlock
				if not bossRushWasCompleted then
					if roomType == RoomType.ROOM_BOSSRUSH and room:IsAmbushDone() then
						if not RebekahLocalSavedata.CurrentRebeccaUnlocks.COLLECTIBLE_LUNCHBOX then
							RebekahLocalSavedata.CurrentRebeccaUnlocks.COLLECTIBLE_LUNCHBOX = true

							SchoolbagAPI.AnimateIsaacAchievement("gfx/ui/achievements/achievement_lunchbox.png", nil, true)
						end
					end
				end
				
				--do other unlocks if the other methods didnt work
				if not roomWasCleared and roomIsClear and roomType == RoomType.ROOM_BOSS then
					local currentStageType = SAPI.game:GetLevel():GetStageType()
					local curses =	SAPI.game:GetLevel():GetCurses()
					
					if currentStage == 8 or (currentStage == 7 and curses & LevelCurse.CURSE_OF_LABYRINTH ~= 0 and room:IsCurrentRoomLastBoss()) then --womb 2
						if not RebekahLocalSavedata.CurrentRebeccaUnlocks.COLLECTIBLE_MIRACULOUSWOMB then
							RebekahLocalSavedata.CurrentRebeccaUnlocks.COLLECTIBLE_MIRACULOUSWOMB = true

							SchoolbagAPI.AnimateIsaacAchievement("gfx/ui/achievements/achievement_miraculous_womb.png", nil, true)
						end
					elseif currentStage == 10 then
						if currentStageType == 1 then --cathedral
							if not RebekahLocalSavedata.CurrentRebeccaUnlocks.COLLECTIBLE_DICEOFFATE then
								RebekahLocalSavedata.CurrentRebeccaUnlocks.COLLECTIBLE_DICEOFFATE = true

								SchoolbagAPI.AnimateIsaacAchievement("gfx/ui/achievements/achievement_dice_of_fate.png", nil, true)
							end
						elseif currentStageType == 0 then --sheol
							if not RebekahLocalSavedata.CurrentRebeccaUnlocks.COLLECTIBLE_CURSEDSPOON then
								RebekahLocalSavedata.CurrentRebeccaUnlocks.COLLECTIBLE_CURSEDSPOON = true

								SchoolbagAPI.AnimateIsaacAchievement("gfx/ui/achievements/achievement_cursed_spoon.png", nil, true)
							end
						end
					elseif currentStage == 11 then
						local backdrop = room:GetBackdropType()
						if backdrop == 18 then --mega satan arena
							if not RebekahLocalSavedata.CurrentRebeccaUnlocks.HAS_LOVERS_CARD then
								RebekahLocalSavedata.CurrentRebeccaUnlocks.HAS_LOVERS_CARD = true

								SchoolbagAPI.AnimateIsaacAchievement("gfx/ui/achievements/achievement_rebekahsfatesealed.png", nil, true)
							end
						elseif currentStageType == 1 then --chest
							if not RebekahLocalSavedata.CurrentRebeccaUnlocks.COLLECTIBLE_ETERNALBOND then
								RebekahLocalSavedata.CurrentRebeccaUnlocks.COLLECTIBLE_ETERNALBOND = true

								SchoolbagAPI.AnimateIsaacAchievement("gfx/ui/achievements/achievement_eternal_bond.png", nil, true)
							end
						elseif currentStageType == 0 then --dark room
							if not RebekahLocalSavedata.CurrentRebeccaUnlocks.TRINKET_ISAACSLOCKS then
								RebekahLocalSavedata.CurrentRebeccaUnlocks.TRINKET_ISAACSLOCKS = true

								SchoolbagAPI.AnimateIsaacAchievement("gfx/ui/achievements/achievement_isaacs_locks.png", nil, true)
							end
						end
					elseif currentStage == 9 then --blue womb
						if not RebekahLocalSavedata.CurrentRebeccaUnlocks.COLLECTIBLE_ROMCOM then
							RebekahLocalSavedata.CurrentRebeccaUnlocks.COLLECTIBLE_ROMCOM = true

							SchoolbagAPI.AnimateIsaacAchievement("gfx/ui/achievements/achievement_typical_romcom.png", nil, true)
						end
					elseif currentStage == 12 then --the void
						if deliriumWasInRoom then
							if not RebekahLocalSavedata.CurrentRebeccaUnlocks.COLLECTIBLE_SNAP then
								RebekahLocalSavedata.CurrentRebeccaUnlocks.COLLECTIBLE_SNAP = true

								SchoolbagAPI.AnimateIsaacAchievement("gfx/ui/achievements/achievement_snap.png", nil, true)
							end
		
						end
					end
				end
			end
			if not roomWasCleared and roomIsClear then
				local istrue = yandereWaifu:CheckIfAllUnlocksTrue()
				if not RebekahLocalSavedata.CurrentRebeccaUnlocks.COLLECTIBLE_UNREQUITEDLOVE and istrue then --EVERYONE
					RebekahLocalSavedata.CurrentRebeccaUnlocks.COLLECTIBLE_UNREQUITEDLOVE = true

					SchoolbagAPI.AnimateIsaacAchievement("gfx/ui/achievements/achievement_unrequited_love.png", nil, true)
				end
			end
		end
	end
	roomWasCleared = roomIsClear
end)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(_, isSaveGame)
	bossRushWasCompleted = false
	ultraGreedWasDefeated = false
end)

--item pool unlockables!
yandereWaifu:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	local itemPool = SAPI.game:GetItemPool()
	if RebekahLocalSavedata.CurrentRebeccaUnlocks then
		if not RebekahLocalSavedata.CurrentRebeccaUnlocks.COLLECTIBLE_LUNCHBOX then --boss rush
			itemPool:RemoveCollectible(RebekahCurse.COLLECTIBLE_LUNCHBOX)
		end
		if not RebekahLocalSavedata.CurrentRebeccaUnlocks.COLLECTIBLE_MIRACULOUSWOMB then --it lives
			itemPool:RemoveCollectible(RebekahCurse.COLLECTIBLE_MIRACULOUSWOMB)
		end
		if not RebekahLocalSavedata.CurrentRebeccaUnlocks.COLLECTIBLE_CURSEDSPOON then --satan
			itemPool:RemoveCollectible(RebekahCurse.COLLECTIBLE_CURSEDSPOON)
		end
		if not RebekahLocalSavedata.CurrentRebeccaUnlocks.COLLECTIBLE_DICEOFFATE then --isaac
			itemPool:RemoveCollectible(RebekahCurse.COLLECTIBLE_DICEOFFATE)
		end
		if not RebekahLocalSavedata.CurrentRebeccaUnlocks.TRINKET_ISAACSLOCKS then --lamb
			itemPool:RemoveTrinket(RebekahCurse.TRINKET_ISAACSLOCKS)
		end
		if not RebekahLocalSavedata.CurrentRebeccaUnlocks.COLLECTIBLE_ETERNALBOND then --???
			itemPool:RemoveCollectible(RebekahCurse.COLLECTIBLE_ETERNALBOND)
		end
		if not RebekahLocalSavedata.CurrentRebeccaUnlocks.COLLECTIBLE_POWERLOVE then --greed
			itemPool:RemoveCollectible(RebekahCurse.COLLECTIBLE_POWERLOVE)
		end
		if not RebekahLocalSavedata.CurrentRebeccaUnlocks.COLLECTIBLE_LOVESICK then --ier
			itemPool:RemoveCollectible(RebekahCurse.COLLECTIBLE_LOVESICK)
		end
		if not RebekahLocalSavedata.CurrentRebeccaUnlocks.COLLECTIBLE_ROMCOM then --hush
			itemPool:RemoveCollectible(RebekahCurse.COLLECTIBLE_ROMCOM)
		end
		if not RebekahLocalSavedata.CurrentRebeccaUnlocks.COLLECTIBLE_SNAP then --delirium
			itemPool:RemoveCollectible(RebekahCurse.COLLECTIBLE_SNAP)
		end
		
		if not RebekahLocalSavedata.CurrentRebeccaUnlocks.COLLECTIBLE_UNREQUITEDLOVE then --IF ALL
			itemPool:RemoveCollectible(RebekahCurse.COLLECTIBLE_UNREQUITEDLOVE)
		end
	end
end)


------
	-- ensures that rebecca maintains the collectible effects she should have
	--[[function yandereWaifu:ApplyCollectibleEffects(pl)
	if pl then
		local player = pl
		if player:GetPlayerType() == Reb then
			if yandereWaifu.GetEntityData(player).currentMode then
				local effect = RebeccaModeEffects[yandereWaifu.GetEntityData(player).currentMode];
				if effect ~= nil and player:GetEffects():HasCollectibleEffect( effect ) == false then
					Isaac.DebugString(tostring(effect))
					--KIL FIX YOUR GAME
					--player:GetEffects():AddCollectibleEffect(effect, false, 1);
				end
			end
		end
	else
			for p = 0, SAPI.game:GetNumPlayers() - 1 do
				local player = Isaac.GetPlayer(p)
				if player:GetPlayerType() == Reb then
					if yandereWaifu.GetEntityData(player).currentMode then
						local effect = RebeccaModeEffects[yandereWaifu.GetEntityData(player).currentMode];
						if effect ~= nil and player:GetEffects():HasCollectibleEffect( effect ) == false then
							Isaac.DebugString(tostring(effect))
							--KIL FIX YOUR GAME
							--player:GetEffects():AddCollectibleEffect(effect, false, 1);
						end
					end
				end
			end
		end
	end]]
	--yandereWaifu:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, yandereWaifu.ApplyCollectibleEffects)
	--yandereWaifu:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, yandereWaifu.ApplyCollectibleEffects)
	--yandereWaifu:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, yandereWaifu.ApplyCollectibleEffects)
	
	

local function RecapRebekahData()
	local saveData = {}
	saveData.currentMode = {};
	saveData.heartFillReserve = {};
	saveData.heartStockReserve = {};
	saveData.NedHealth = {} -- first ned
	for i,player in ipairs(SAPI.players) do
		if player:GetPlayerType() == RebekahCurse.REB then
			saveData.currentMode[i] = yandereWaifu.GetEntityData(player).currentMode
			saveData.heartFillReserve[i] = yandereWaifu.getReserveFill(player)
			saveData.heartStockReserve[i] = yandereWaifu.getReserveStocks(player)
			print("its just a burning memory")
		else
			saveData.currentMode[i] = nil
		end
		for c, ned in pairs( Isaac.FindByType(EntityType.ENTITY_FAMILIAR, -1, -1, false, false) ) do
		--check for knights health
			if ned.Variant == ENTITY_NED_NORMAL or ned.Variant == ENTITY_SQUIRENED then 
				if not saveData.NedHealth[i] then saveData.NedHealth[i] = {} end
				
				local name = tonumber(ned.Variant..ned.SubType)
				print(name)
				--if not tbl[name] then tbl[name] = {} end
				
				if GetPtrHash(player) == GetPtrHash(ned:ToFamiliar().Player) then
					table.insert(saveData.NedHealth[i], {name, yandereWaifu.GetEntityData(ned).Health})
				end
			end
		end
		print(saveData.heartFillReserve[i])
	end
	saveData.bossRoomsCleared = RebekahLocalSavedata.bossRoomsCleared;
	saveData.unlocks = RebekahLocalSavedata.CurrentRebeccaUnlocks;
	
	print("eclectric chair")
	
	
	return saveData
end

local function IsRebekahPlayer(player)
	if player:GetPlayerType() == RebekahCurse.REB or player.GetPlayerTypeByName == Isaac.GetPlayerTypeByName("Isaac") then
		return true
	else
		return false
	end
end

JSON = require("json");

-- Load Moddata
yandereWaifu:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function()
	local data = JSON.decode(Isaac.LoadModData(yandereWaifu));
	if data ~= nil then
		if data.currentMode ~= nil then 
			for i,player in ipairs(SAPI.players) do
				if player:GetPlayerType() == RebekahCurse.REB then
					yandereWaifu.GetEntityData(player).currentMode = data.currentMode[i]
					yandereWaifu.addReserveFill(player, data.heartFillReserve[i])
					yandereWaifu.addReserveStocks(player, data.heartStockReserve[i])
				end
			end
		end
		--this is being called a lot if theres a lot of players, I feel like i should change this
		if data.bossRoomsCleared ~= nil then RebekahLocalSavedata.bossRoomsCleared = data.bossRoomsCleared end
		if data.unlocks ~= nil then RebekahLocalSavedata.CurrentRebeccaUnlocks = data.unlocks end
		
		if data.NedHealth then
			for i,player in ipairs(SAPI.players) do
				for n, ned in pairs( Isaac.FindByType(EntityType.ENTITY_FAMILIAR, -1, -1, false, false) ) do
					if ned.Variant == ENTITY_NED_NORMAL or ned.Variant == ENTITY_SQUIRENED then 
						local name = tonumber(ned.Variant..ned.SubType)
						for k, health in ipairs(data.NedHealth[i]) do
							print(data.NedHealth[i][k][1], "steve")
							print(data.NedHealth[i][k][2], "steve")
							if data.NedHealth[i][k][1] == name then
								yandereWaifu.GetEntityData(ned).Health = data.NedHealth[i][k][2]
								table.remove(data.NedHealth[i], k)
							end
				--	print(name)
					--check for knights health
				--		if ned.Variant == ENTITY_NED_NORMAL or ned.Variant == ENTITY_SQUIRENED then 
				--			if GetPtrHash(player) == GetPtrHash(ned:ToFamiliar().Player) then
				--				yandereWaifu.GetEntityData(ned).Health = data.NedHealth[i][name][c]
						end
					end
				end
			end
		end
	end
end)

-- Save Moddata
-- this doesn't need to be called every frame and especially not for characters that aren't rebecca
function yandereWaifu.Save()
	local saveData = RecapRebekahData()
	Isaac.SaveModData(yandereWaifu, JSON.encode( saveData ) );
end

yandereWaifu:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
	yandereWaifu.Save()
end)
yandereWaifu:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, function(_, boo)
	if boo then
		yandereWaifu.Save()
	end
end)
yandereWaifu:AddCallback(ModCallbacks.MC_POST_GAME_END, function(_, boo)
	currentMode = nil;
	yandereWaifu.Save()
end)