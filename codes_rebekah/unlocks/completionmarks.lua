
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

CurrentRebeccaUnlocks = nil



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
	if CurrentRebeccaUnlocks then
		for i, v in pairs(CurrentRebeccaUnlocks) do
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

	local room = game:GetRoom()
	local roomIsClear = room:IsClear()
	
	local currentStage = game:GetLevel():GetStage()
	local roomType = room:GetType()
	
	for i=0, InutilLib.game:GetNumPlayers()-1 do
		local player = Isaac.GetPlayer(i)
		if player:GetPlayerType() == Reb and CurrentRebeccaUnlocks and readyToUnlock then
			
			if game:IsGreedMode() then
				if not ultraGreedWasDefeated then
					if currentStage == LevelStage.STAGE7_GREED then
						if not roomWasCleared and roomIsClear and roomType == RoomType.ROOM_BOSS and room:IsCurrentRoomLastBoss() then
							if not CurrentRebeccaUnlocks.COLLECTIBLE_POWERLOVE then --greed
								CurrentRebeccaUnlocks.COLLECTIBLE_POWERLOVE = true

								--InutilLib.AnimateIsaacAchievement("gfx/ui/achievements/achievement_love_power.png", nil, true)
							end
							if game.Difficulty == Difficulty.DIFFICULTY_GREEDIER then --ier
								if not CurrentRebeccaUnlocks.COLLECTIBLE_LOVESICK then
									CurrentRebeccaUnlocks.COLLECTIBLE_LOVESICK = true

									--InutilLib.AnimateIsaacAchievement("gfx/ui/achievements/achievement_lovesick.png", nil, true)
								end
							end
						end
					end
				end
			else
				--do boss rush unlock
				if not bossRushWasCompleted then
					if roomType == RoomType.ROOM_BOSSRUSH and room:IsAmbushDone() then
						if not CurrentRebeccaUnlocks.COLLECTIBLE_LUNCHBOX then
							CurrentRebeccaUnlocks.COLLECTIBLE_LUNCHBOX = true

							--InutilLib.AnimateIsaacAchievement("gfx/ui/achievements/achievement_lunchbox.png", nil, true)
						end
					end
				end
				
				--do other unlocks if the other methods didnt work
				if not roomWasCleared and roomIsClear and roomType == RoomType.ROOM_BOSS then
					local currentStageType = game:GetLevel():GetStageType()
					local curses =	game:GetLevel():GetCurses()
					
					if currentStage == 8 or (currentStage == 7 and curses & LevelCurse.CURSE_OF_LABYRINTH ~= 0 and room:IsCurrentRoomLastBoss()) then --womb 2
						if not CurrentRebeccaUnlocks.COLLECTIBLE_MIRACULOUSWOMB then
							CurrentRebeccaUnlocks.COLLECTIBLE_MIRACULOUSWOMB = true

							--InutilLib.AnimateIsaacAchievement("gfx/ui/achievements/achievement_miraculous_womb.png", nil, true)
						end
					elseif currentStage == 10 then
						if currentStageType == 1 then --cathedral
							if not CurrentRebeccaUnlocks.COLLECTIBLE_DICEOFFATE then
								CurrentRebeccaUnlocks.COLLECTIBLE_DICEOFFATE = true

								--InutilLib.AnimateIsaacAchievement("gfx/ui/achievements/achievement_dice_of_fate.png", nil, true)
							end
						elseif currentStageType == 0 then --sheol
							if not CurrentRebeccaUnlocks.COLLECTIBLE_CURSEDSPOON then
								CurrentRebeccaUnlocks.COLLECTIBLE_CURSEDSPOON = true

								--InutilLib.AnimateIsaacAchievement("gfx/ui/achievements/achievement_cursed_spoon.png", nil, true)
							end
						end
					elseif currentStage == 11 then
						local backdrop = room:GetBackdropType()
						if backdrop == 18 then --mega satan arena
							if not CurrentRebeccaUnlocks.HAS_LOVERS_CARD then
								CurrentRebeccaUnlocks.HAS_LOVERS_CARD = true

								--InutilLib.AnimateIsaacAchievement("gfx/ui/achievements/achievement_rebekahsfatesealed.png", nil, true)
							end
						elseif currentStageType == 1 then --chest
							if not CurrentRebeccaUnlocks.COLLECTIBLE_ETERNALBOND then
								CurrentRebeccaUnlocks.COLLECTIBLE_ETERNALBOND = true

								--InutilLib.AnimateIsaacAchievement("gfx/ui/achievements/achievement_eternal_bond.png", nil, true)
							end
						elseif currentStageType == 0 then --dark room
							if not CurrentRebeccaUnlocks.TRINKET_ISAACSLOCKS then
								CurrentRebeccaUnlocks.TRINKET_ISAACSLOCKS = true

								--InutilLib.AnimateIsaacAchievement("gfx/ui/achievements/achievement_isaacs_locks.png", nil, true)
							end
						end
					elseif currentStage == 9 then --blue womb
						if not CurrentRebeccaUnlocks.COLLECTIBLE_ROMCOM then
							CurrentRebeccaUnlocks.COLLECTIBLE_ROMCOM = true

							--InutilLib.AnimateIsaacAchievement("gfx/ui/achievements/achievement_typical_romcom.png", nil, true)
						end
					elseif currentStage == 12 then --the void
						if deliriumWasInRoom then
							if not CurrentRebeccaUnlocks.COLLECTIBLE_SNAP then
								CurrentRebeccaUnlocks.COLLECTIBLE_SNAP = true

								--InutilLib.AnimateIsaacAchievement("gfx/ui/achievements/achievement_snap.png", nil, true)
							end
		
						end
					end
				end
			end
			if not roomWasCleared and roomIsClear then
				local istrue = yandereWaifu:CheckIfAllUnlocksTrue()
				if not CurrentRebeccaUnlocks.COLLECTIBLE_UNREQUITEDLOVE and istrue then --EVERYONE
					CurrentRebeccaUnlocks.COLLECTIBLE_UNREQUITEDLOVE = true

					--InutilLib.AnimateIsaacAchievement("gfx/ui/achievements/achievement_unrequited_love.png", nil, true)
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
--[[yandereWaifu:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	local itemPool = game:GetItemPool()
	if CurrentRebeccaUnlocks then
		if not CurrentRebeccaUnlocks.COLLECTIBLE_LUNCHBOX then --boss rush
			itemPool:RemoveCollectible(COLLECTIBLE_LUNCHBOX)
		end
		if not CurrentRebeccaUnlocks.COLLECTIBLE_MIRACULOUSWOMB then --it lives
			itemPool:RemoveCollectible(COLLECTIBLE_MIRACULOUSWOMB)
		end
		if not CurrentRebeccaUnlocks.COLLECTIBLE_CURSEDSPOON then --satan
			itemPool:RemoveCollectible(COLLECTIBLE_CURSEDSPOON)
		end
		if not CurrentRebeccaUnlocks.COLLECTIBLE_DICEOFFATE then --isaac
			itemPool:RemoveCollectible(COLLECTIBLE_DICEOFFATE)
		end
		if not CurrentRebeccaUnlocks.TRINKET_ISAACSLOCKS then --lamb
			itemPool:RemoveTrinket(TRINKET_ISAACSLOCKS)
		end
		if not CurrentRebeccaUnlocks.COLLECTIBLE_ETERNALBOND then --???
			itemPool:RemoveCollectible(COLLECTIBLE_ETERNALBOND)
		end
		if not CurrentRebeccaUnlocks.COLLECTIBLE_POWERLOVE then --greed
			itemPool:RemoveCollectible(COLLECTIBLE_POWERLOVE)
		end
		if not CurrentRebeccaUnlocks.COLLECTIBLE_LOVESICK then --ier
			itemPool:RemoveCollectible(COLLECTIBLE_LOVESICK)
		end
		if not CurrentRebeccaUnlocks.COLLECTIBLE_ROMCOM then --hush
			itemPool:RemoveCollectible(COLLECTIBLE_ROMCOM)
		end
		if not CurrentRebeccaUnlocks.COLLECTIBLE_SNAP then --delirium
			itemPool:RemoveCollectible(COLLECTIBLE_SNAP)
		end
		
		if not CurrentRebeccaUnlocks.COLLECTIBLE_UNREQUITEDLOVE then --IF ALL
			itemPool:RemoveCollectible(COLLECTIBLE_UNREQUITEDLOVE)
		end
	end
end)
]]