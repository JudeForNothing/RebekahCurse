local cyclePerFrame = 120

local red = {gfx = "gfx/ui/dysmorphia_hearts/red.png", id = 1}
local blue = { gfx = "gfx/ui/dysmorphia_hearts/blue.png", id = 2}
local gold = { gfx = "gfx/ui/dysmorphia_hearts/gold.png",id = 3}
local evil = { gfx = "gfx/ui/dysmorphia_hearts/evil.png",id = 4}
local eternal = { gfx = "gfx/ui/dysmorphia_hearts/eternal.png",id = 5}
local bone = { gfx = "gfx/ui/dysmorphia_hearts/bone.png",id = 6}
local rotten = { gfx = "gfx/ui/dysmorphia_hearts/rotten.png",id = 7}
local function GetAllHeartsInTable(player)
	local heartTable = {}
	if player:GetHearts() >= 2 then table.insert(heartTable, red) end
	if player:GetSoulHearts() >= 2 and (player:GetSoulHearts()-yandereWaifu.GetPlayerBlackHearts(player))>= 2 then table.insert(heartTable, blue) end	
	if player:GetGoldenHearts() > 0 then table.insert(heartTable, gold) end
	if yandereWaifu.GetPlayerBlackHearts(player) >= 2 then table.insert(heartTable, evil) end
	if player:GetEternalHearts() > 0 then table.insert(heartTable, eternal) end
	if player:GetBoneHearts() > 0 then table.insert(heartTable, bone) end
	if player:GetRottenHearts() > 0 then table.insert(heartTable, rotten) end
	return heartTable
end


function yandereWaifu:useHeartsAndCrafts(collItem, rng, player)
	local data = yandereWaifu.GetEntityData(player)
	if data.HEARTSANDCRAFTS_MENU then --reset in case
		data.HEARTSANDCRAFTS_MENU.lastVector = Vector.Zero
		data.HEARTSANDCRAFTS_MENU.onRelease = false
		data.selectedBodyDysWire = false
	end
	
	data.StoredBodyHeartsAndCrafts = GetAllHeartsInTable(player)
	
	local wires = {}
	local wiresValue = {}
	data.currentBodyDysmorphiaNextPage = 0 --reset cycle of hearts
	for i = 1, 4 do
		if data.StoredBodyHeartsAndCrafts[i] then
			table.insert(wires, data.StoredBodyHeartsAndCrafts[i].gfx)
			table.insert(wiresValue, data.StoredBodyHeartsAndCrafts[i].id)
			if data.StoredBodyHeartsAndCrafts[i].gfx then
				data.currentBodyDysmorphiaNextPage = data.currentBodyDysmorphiaNextPage + 1
			end
		end
	end
	data.TotalStoredBodyHeartsAndCrafts = #data.StoredBodyHeartsAndCrafts
	
	data.HEARTSANDCRAFTS_MENU:UpdateOptions(wires, wiresValue)
	
	data.HEARTSANDCRAFTS_MENU:ToggleMenu()
	if slot == ActiveSlot.SLOT_POCKET then slot = true else slot = false end
	InutilLib.ToggleShowActive(player, false, slot)
	
	data.refreshDysmorphiaChoiceFrame = cyclePerFrame
end
yandereWaifu:AddCallback( ModCallbacks.MC_USE_ITEM, yandereWaifu.useHeartsAndCrafts, RebekahCurseItems.COLLECTIBLE_HEARTSANDCRAFTS );


yandereWaifu:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, function(_, player)
	local data = yandereWaifu.GetEntityData(player)
	local controller = player.ControllerIndex;
	if player:HasCollectible(RebekahCurseItems.COLLECTIBLE_HEARTSANDCRAFTS) then
		if not data.HEARTSANDCRAFTS_MENU then --set menu
			data.HEARTSANDCRAFTS_MENU = yandereWaifu.Minimenu:New("gfx/ui/none.png", Isaac.WorldToScreen(player.Position + Vector(0, -50)));
			
			data.HEARTSANDCRAFTS_MENU:AttachCallback( function(dir, value, isAvailable)
				if data.HEARTSANDCRAFTS_MENU.onRelease then
					
					--print(data.currentIndex)
					--if selected stuff code
					if dir and isAvailable and data.selectedBodyDysWire then

						player:AnimateSad()
							
						SFXManager():Play(SoundEffect.SOUND_THUMBS_DOWN , 1, 0, false, 0.8 );
							
						--if not isDiffused then
						data.HEARTSANDCRAFTS_MENU:ToggleMenu()
						--end
						data.selectedBodyDysWire = false
						local sub = 0
						if value == 1 then
							sub = 0
							player:AddHearts(-2)
						elseif value == 2 then
							sub = 1
							player:AddSoulHearts(-2)
						elseif value == 3 then
							sub = 6
							player:AddGoldenHearts(-1)
						elseif value == 4 then
							sub = 2
							player:AddBlackHearts(-2)
						elseif value == 5 then
							sub = 3
							player:AddEternalHearts(-1)
						elseif value == 6 then
							sub = 4
							player:AddBoneHearts(-1)
						elseif value == 7 then
							sub = 5
							player:AddRottenHearts(-1)
						--[[elseif value == 8 then
							sub = 0
							player:AddBrokenHearts(-1)]]
						end
						local mob = Isaac.Spawn(RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY, RebekahCurseEnemies.ENTITY_REDTATO, sub, player.Position,  player.Velocity, player):ToNPC();
						mob:AddEntityFlags(EntityFlag.FLAG_CHARM | EntityFlag.FLAG_FRIENDLY | EntityFlag.FLAG_PERSISTENT)
						mob.HitPoints = mob.HitPoints/2
						mob.CollisionDamage = 1.5
						yandereWaifu.GetEntityData(mob).CharmedToParent = player
					end
				else
					--print("heelsdfd")
					if dir then --if selecting
						data.selectedBodyDysWire = true
					end
				end
			end)
		else
			data.HEARTSANDCRAFTS_MENU:Update( player:GetShootingInput(), Isaac.WorldToScreen(player.Position + Vector(0, -50)) )
			if data.TotalStoredBodyHeartsAndCrafts and data.TotalStoredBodyHeartsAndCrafts > 4 then --if more than four hearts
				if not data.refreshDysmorphiaChoiceFrame then data.refreshDysmorphiaChoiceFrame = cyclePerFrame end
				--print(data.refreshDysmorphiaChoiceFrame)
				if data.refreshDysmorphiaChoiceFrame <= 0 then --refresh!
					local currentBodyDysmorphiaNextPage = data.currentBodyDysmorphiaNextPage
					local wires = {}
					local wiresValue = {}
					--if already at the end
					if data.TotalStoredBodyHeartsAndCrafts <= data.currentBodyDysmorphiaNextPage then
						data.currentBodyDysmorphiaNextPage = 0
						for i = 1, 4 do
							if data.StoredBodyHeartsAndCrafts[i] then
								table.insert(wires, data.StoredBodyHeartsAndCrafts[i].gfx)
								table.insert(wiresValue, data.StoredBodyHeartsAndCrafts[i].id)
								if data.StoredBodyHeartsAndCrafts[i].gfx then
									data.currentBodyDysmorphiaNextPage = data.currentBodyDysmorphiaNextPage + 1
								end
							end
						end
					else --else
						for i = 1+currentBodyDysmorphiaNextPage, 4+currentBodyDysmorphiaNextPage do
							if not data.currentBodyDysmorphiaNextPage then data.currentBodyDysmorphiaNextPage = 0 end
							if data.StoredBodyHeartsAndCrafts[i] then
								table.insert(wires, data.StoredBodyHeartsAndCrafts[i].gfx)
								table.insert(wiresValue, data.StoredBodyHeartsAndCrafts[i].id)
								data.currentBodyDysmorphiaNextPage = data.currentBodyDysmorphiaNextPage + 1
							else
								--table.insert(wires, nil)
							end
						end
					end
					data.HEARTSANDCRAFTS_MENU:UpdateOptions(wires, wiresValue)
					data.refreshDysmorphiaChoiceFrame = cyclePerFrame
				else
					if player:GetShootingInput().X == 0 or player:GetShootingInput().Y == 0 then
						data.refreshDysmorphiaChoiceFrame = data.refreshDysmorphiaChoiceFrame - 1
					end
				end
			end
		end
	else
		if data.HEARTSANDCRAFTS_MENU then data.HEARTSANDCRAFTS_MENU:Remove() end
	end
end);

