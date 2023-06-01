
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


function yandereWaifu:CheckIfAllRebekahUnlocksTrue()
	local unlockAll = true
	if yandereWaifu.ACHIEVEMENT.LOVE_POWER:IsUnlocked() and yandereWaifu.ACHIEVEMENT.REBEKAHS_CAMERA:IsUnlocked()
	and yandereWaifu.ACHIEVEMENT.LUNCHBOX:IsUnlocked() and yandereWaifu.ACHIEVEMENT.MIRACULOUS_WOMB:IsUnlocked() 
	and yandereWaifu.ACHIEVEMENT.DICE_OF_FATE:IsUnlocked() and yandereWaifu.ACHIEVEMENT.CURSED_SPOON:IsUnlocked() 
	and yandereWaifu.ACHIEVEMENT.REBEKAHS_ROOM:IsUnlocked() and yandereWaifu.ACHIEVEMENT.ISAACS_LOCKS:IsUnlocked()
	and yandereWaifu.ACHIEVEMENT.TYPICAL_ROMCOM:IsUnlocked() and yandereWaifu.ACHIEVEMENT.WIKEPIDIA:IsUnlocked() then
		return unlockAll
	end
end

local bossRushWasCompleted = false
local ultraGreedWasDefeated = false
local roomWasCleared = false
--boss rush
yandereWaifu:AddCallback(ModCallbacks.MC_POST_UPDATE, function()

	local room = InutilLib.game:GetRoom()
	local roomIsClear = InutilLib.room:IsClear()
	
	local currentStage = InutilLib.game:GetLevel():GetStage()
	local roomType = InutilLib.room:GetType()
	
	for i=0, InutilLib.game:GetNumPlayers()-1 do
		local player = Isaac.GetPlayer(i)
		if yandereWaifu.IsNormalRebekah(player) then
			if InutilLib.game:IsGreedMode() then
				if not ultraGreedWasDefeated then
					if currentStage == LevelStage.STAGE7_GREED then
						if not roomWasCleared and roomIsClear and roomType == RoomType.ROOM_BOSS and room:IsCurrentRoomLastBoss() then
							if not yandereWaifu.ACHIEVEMENT.LOVE_POWER:IsUnlocked() then --greed
								yandereWaifu.ACHIEVEMENT.LOVE_POWER:Unlock()
								--InutilLib.AnimateIsaacAchievement("gfx/ui/achievement/achievement_love_power.png", nil, true, 60)
							end
							if InutilLib.game.Difficulty == Difficulty.DIFFICULTY_GREEDIER then 
								if not yandereWaifu.ACHIEVEMENT.REBEKAHS_CAMERA:IsUnlocked() then --greedier
									yandereWaifu.ACHIEVEMENT.REBEKAHS_CAMERA:Unlock()

									--InutilLib.AnimateIsaacAchievement("gfx/ui/achievement/achievement_rebekahs_camera.png", nil, true, 60)
								end
							end
						end
					end
				end
			else
				--do boss rush unlock
				if not bossRushWasCompleted then
					if roomType == RoomType.ROOM_BOSSRUSH and room:IsAmbushDone() then
						if not yandereWaifu.ACHIEVEMENT.LUNCHBOX:IsUnlocked() then
							yandereWaifu.ACHIEVEMENT.LUNCHBOX:Unlock()
							--InutilLib.AnimateIsaacAchievement("gfx/ui/achievement/achievement_lunchbox.png", nil, true, 60)
						end
					end
				end--do other unlocks if the other methods didnt work
				if not roomWasCleared and roomIsClear and roomType == RoomType.ROOM_BOSS then
					local currentStageType = InutilLib.game:GetLevel():GetStageType()
					local curses =	InutilLib.game:GetLevel():GetCurses()
					
					if currentStage == 8 or (currentStage == 7 and curses & LevelCurse.CURSE_OF_LABYRINTH ~= 0 and room:IsCurrentRoomLastBoss()) then --womb 2
						if not yandereWaifu.ACHIEVEMENT.MIRACULOUS_WOMB:IsUnlocked() then
							yandereWaifu.ACHIEVEMENT.MIRACULOUS_WOMB:Unlock()

							--InutilLib.AnimateIsaacAchievement("gfx/ui/achievement/achievement_miraculous_womb.png", nil, true, 60)
						end
					elseif currentStage == 10 then
						if currentStageType == 1 then --cathedral
							if not yandereWaifu.ACHIEVEMENT.DICE_OF_FATE:IsUnlocked() then
								yandereWaifu.ACHIEVEMENT.DICE_OF_FATE:Unlock()
								--InutilLib.AnimateIsaacAchievement("gfx/ui/achievement/achievement_dice_of_fate.png", nil, true, 60)
							end
						elseif currentStageType == 0 then --sheol
							if not yandereWaifu.ACHIEVEMENT.CURSED_SPOON:IsUnlocked() then
								yandereWaifu.ACHIEVEMENT.CURSED_SPOON:Unlock()

								--InutilLib.AnimateIsaacAchievement("gfx/ui/achievement/achievement_cursed_spoon.png", nil, true, 60)
							end
						end
					elseif currentStage == 11 then
						local backdrop = room:GetBackdropType()
						if backdrop == 18 then --mega satan arena
							if not yandereWaifu.ACHIEVEMENT.REBEKAHS_ROOM:IsUnlocked() then
								yandereWaifu.ACHIEVEMENT.REBEKAHS_ROOM:Unlock()

								--InutilLib.AnimateIsaacAchievement("gfx/ui/achievement/achievement_rebekahs_room.png", nil, true, 60)
							end
						elseif currentStageType == 1 then --chest
							if not yandereWaifu.ACHIEVEMENT.ISAACS_LOCKS:IsUnlocked() then
								yandereWaifu.ACHIEVEMENT.ISAACS_LOCKS:Unlock()

								--InutilLib.AnimateIsaacAchievement("gfx/ui/achievement/achievement_isaacs_locks.png", nil, true, 60)
							end
						elseif currentStageType == 0 then --dark room
							if not yandereWaifu.ACHIEVEMENT.ETERNAL_BOND:IsUnlocked() then
								yandereWaifu.ACHIEVEMENT.ETERNAL_BOND:Unlock()

								--InutilLib.AnimateIsaacAchievement("gfx/ui/achievement/achievement_eternal_bond.png", nil, true, 60)
							end
						end
					elseif currentStage == 9 then --blue womb
						if not yandereWaifu.ACHIEVEMENT.REBEKAHS_CAMERA:IsUnlocked() then
							yandereWaifu.ACHIEVEMENT.REBEKAHS_CAMERA:Unlock()

							--InutilLib.AnimateIsaacAchievement("gfx/ui/achievement/achievement_rebekahs_camera.png", nil, true, 60)
						end
					elseif currentStage == 12 then --the void
						if deliriumWasInRoom then
							if not yandereWaifu.ACHIEVEMENT.WIKEPIDIA:IsUnlocked() then
								yandereWaifu.ACHIEVEMENT.WIKEPIDIA:Unlock()

								--InutilLib.AnimateIsaacAchievement("gfx/ui/achievement/achievement_wikepidia.png", nil, true, 60)
							end
		
						end
					end
				end
			end
			if not roomWasCleared and roomIsClear then
				local istrue = yandereWaifu:CheckIfAllRebekahUnlocksTrue()
				if not yandereWaifu.ACHIEVEMENT.UNREQUITED_LOVE:IsUnlocked() and istrue then
					yandereWaifu.ACHIEVEMENT.UNREQUITED_LOVE:Unlock()

					--InutilLib.AnimateIsaacAchievement("gfx/ui/achievement/achievement_unrequited_love.png", nil, true, 60)
				end
			end
		end
	end
	roomWasCleared = roomIsClear
end)

--[[
yandereWaifu:AddCallback(ModCallbacks.MC_POST_UPDATE, function()

	local room = game:GetRoom()
	local roomIsClear = room:IsClear()
	
	local currentStage = game:GetLevel():GetStage()
	local roomType = room:GetType()
	
	for i=0, InutilLib.game:GetNumPlayers()-1 do
		local player = Isaac.GetPlayer(i)
		if yandereWaifu:IsNormalRebekah() and CurrentRebeccaUnlocks and readyToUnlock then
			
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
				local istrue = yandereWaifu:CheckIfAllRebekahUnlocksTrue()
				if not CurrentRebeccaUnlocks.COLLECTIBLE_UNREQUITEDLOVE and istrue then --EVERYONE
					CurrentRebeccaUnlocks.COLLECTIBLE_UNREQUITEDLOVE = true

					--InutilLib.AnimateIsaacAchievement("gfx/ui/achievements/achievement_unrequited_love.png", nil, true)
				end
			end
		end
	end
	roomWasCleared = roomIsClear
end)]]

yandereWaifu:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(_, isSaveGame)
	bossRushWasCompleted = false
	ultraGreedWasDefeated = false
end)

--item pool unlockables!
yandereWaifu:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	local itemPool = InutilLib.game:GetItemPool()
	--if CurrentRebeccaUnlocks then
		if not yandereWaifu.ACHIEVEMENT.LUNCHBOX:IsUnlocked() then --boss rush
			itemPool:RemoveCollectible(RebekahCurse.Items.COLLECTIBLE_LUNCHBOX)
		end
		if not yandereWaifu.ACHIEVEMENT.COLLECTIBLE_MIRACULOUSWOMB then --it lives
			itemPool:RemoveCollectible(RebekahCurse.Items.COLLECTIBLE_MIRACULOUSWOMB)
		end
		if not yandereWaifu.ACHIEVEMENT.COLLECTIBLE_CURSEDSPOON then --satan
			itemPool:RemoveCollectible(RebekahCurse.Items.COLLECTIBLE_CURSEDSPOON)
		end
		if not yandereWaifu.ACHIEVEMENT.COLLECTIBLE_DICEOFFATE then --isaac
			itemPool:RemoveCollectible(RebekahCurse.Items.COLLECTIBLE_DICEOFFATE)
		end
		if not yandereWaifu.ACHIEVEMENT.TRINKET_ISAACSLOCKS then --lamb
			itemPool:RemoveTrinket(RebekahCurse.Trinkets.TRINKET_ISAACSLOCKS)
		end
		if not yandereWaifu.ACHIEVEMENT.COLLECTIBLE_ETERNALBOND then --???
			itemPool:RemoveCollectible(RebekahCurse.Items.COLLECTIBLE_ETERNALBOND)
		end
		if not yandereWaifu.ACHIEVEMENT.COLLECTIBLE_POWERLOVE then --greed
			itemPool:RemoveCollectible(RebekahCurse.Items.COLLECTIBLE_POWERLOVE)
		end
		if not yandereWaifu.ACHIEVEMENT.COLLECTIBLE_LOVESICK then --ier
			itemPool:RemoveCollectible(RebekahCurse.Items.COLLECTIBLE_LOVESICK)
		end
		if not yandereWaifu.ACHIEVEMENT.COLLECTIBLE_ROMCOM then --hush
			itemPool:RemoveCollectible(RebekahCurse.Items.COLLECTIBLE_REBEKAHSCAMERA)
		end
		if not yandereWaifu.ACHIEVEMENT.COLLECTIBLE_WIKEPIDIA then --delirium
			itemPool:RemoveCollectible(RebekahCurse.Items.COLLECTIBLE_WIKEPIDIA)
		end
		
		if not yandereWaifu.ACHIEVEMENT.COLLECTIBLE_UNREQUITEDLOVE then --IF ALL
			itemPool:RemoveCollectible(RebekahCurse.Items.COLLECTIBLE_UNREQUITEDLOVE)
		end
	--end
end)
