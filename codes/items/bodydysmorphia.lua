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
	if player:GetHearts() > 2 then table.insert(heartTable, red) 
	print(heartTable) end
	if player:GetSoulHearts() > 2 and (player:GetSoulHearts()-yandereWaifu.GetPlayerBlackHearts(player))> 2 then table.insert(heartTable, blue) end	
	if player:GetGoldenHearts() > 0 then table.insert(heartTable, gold) end
	if yandereWaifu.GetPlayerBlackHearts(player) > 2 then table.insert(heartTable, evil) end
	if player:GetEternalHearts() > 0 then table.insert(heartTable, eternal) end
	if player:GetBoneHearts() > 0 then table.insert(heartTable, bone) end
	if player:GetRottenHearts() > 0 then table.insert(heartTable, rotten) end
	--if player:GetBrokenHearts() > 0 then heartTable.ShowBroken = true end
	return heartTable
end

function yandereWaifu:useBodyDysmorphia(collItem, rng, player, flag, slot)
	local data = yandereWaifu.GetEntityData(player)
	
	if data.BODYDYSMORPHIA_MENU then --reset in case
		data.BODYDYSMORPHIA_MENU.lastVector = Vector.Zero
		data.BODYDYSMORPHIA_MENU.onRelease = false
		data.selectedBodyDysWire = false
	end
	
	if data.lastActiveUsedFrameCount then
		if ILIB.game:GetFrameCount() == data.lastActiveUsedFrameCount then
			return
		end
						
		data.lastActiveUsedFrameCount = ILIB.game:GetFrameCount()
	else
		data.lastActiveUsedFrameCount = ILIB.game:GetFrameCount()
	end
	
	data.StoredBodyDysmorphiaHearts = GetAllHeartsInTable(player)
	
	local wires = {}
	local wiresValue = {}
	data.currentBodyDysmorphiaNextPage = 0 --reset cycle of hearts
	for i = 1, 4 do
		print(data.StoredBodyDysmorphiaHearts[i])
		if data.StoredBodyDysmorphiaHearts[i] then
			table.insert(wires, data.StoredBodyDysmorphiaHearts[i].gfx)
			table.insert(wiresValue, data.StoredBodyDysmorphiaHearts[i].id)
			if data.StoredBodyDysmorphiaHearts[i].gfx then
				data.currentBodyDysmorphiaNextPage = data.currentBodyDysmorphiaNextPage + 1
			end
		end
	end
	data.TotalStoredBodyDysmorphiaHearts = #data.StoredBodyDysmorphiaHearts
	
	data.BODYDYSMORPHIA_MENU:UpdateOptions(wires, wiresValue)
	
	data.BODYDYSMORPHIA_MENU:ToggleMenu()
	if slot == ActiveSlot.SLOT_POCKET then slot = true else slot = false end
	InutilLib.ToggleShowActive(player, false, slot)
	
	data.refreshDysmorphiaChoiceFrame = cyclePerFrame
	--if data.BODYDYSMORPHIA_MENU.open then
	--end
end
yandereWaifu:AddCallback( ModCallbacks.MC_USE_ITEM, yandereWaifu.useBodyDysmorphia, RebekahCurse.COLLECTIBLE_BODYDYSMORHIA);


yandereWaifu:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, function(_, player)
	local data = yandereWaifu.GetEntityData(player)
	local controller = player.ControllerIndex;
	if player:HasCollectible(RebekahCurse.COLLECTIBLE_BODYDYSMORHIA) then
		if not data.BODYDYSMORPHIA_MENU then --set menu
			data.BODYDYSMORPHIA_MENU = yandereWaifu.Minimenu:New("gfx/ui/none.png", Isaac.WorldToScreen(player.Position + Vector(0, -50)));
			
			data.BODYDYSMORPHIA_MENU:AttachCallback( function(dir, value, isAvailable)
				if data.BODYDYSMORPHIA_MENU.onRelease then
					
					--print(data.currentIndex)
					--if selected stuff code
					if dir and isAvailable and data.selectedBodyDysWire then

						player:AnimateSad()
							
						SFXManager():Play(SoundEffect.SOUND_THUMBS_DOWN , 1, 0, false, 0.8 );
							
						--if not isDiffused then
						data.BODYDYSMORPHIA_MENU:ToggleMenu()
						--end
						data.selectedBodyDysWire = false
						
						if value == 1 then
							local rng = math.random(1,6)
							if rng == 1 then
								data.PersistentPlayerData.RedStatBuffDamage = data.PersistentPlayerData.RedStatBuffDamage + 1
							elseif rng == 2 then
								data.PersistentPlayerData.RedStatBuffFireDelay = data.PersistentPlayerData.RedStatBuffFireDelay + 1
							elseif rng == 3 then
								data.PersistentPlayerData.RedStatBuffLuck = data.PersistentPlayerData.RedStatBuffLuck + 1
							elseif rng == 4 then
								data.PersistentPlayerData.RedStatBuffRange = data.PersistentPlayerData.RedStatBuffRange + 1
							elseif rng == 5 then
								data.PersistentPlayerData.RedStatBuffShotSpeed = data.PersistentPlayerData.RedStatBuffShotSpeed + 1
							elseif rng == 6 then
								data.PersistentPlayerData.RedStatBuffSpeed = data.PersistentPlayerData.RedStatBuffSpeed + 1
							end
							player:AddHearts(-2)
						elseif value == 2 then
							data.PersistentPlayerData.SoulStatBuff = data.PersistentPlayerData.SoulStatBuff + 1
							player:AddSoulHearts(-2)
						elseif value == 3 then
							data.PersistentPlayerData.GoldStatBuff = data.PersistentPlayerData.GoldStatBuff + 1
							player:AddGoldenHearts(-1)
						elseif value == 4 then
							data.PersistentPlayerData.EvilStatBuff = data.PersistentPlayerData.EvilStatBuff + 1
							player:AddBlackHearts(-2)
						elseif value == 5 then
							data.PersistentPlayerData.EternalStatBuff = data.PersistentPlayerData.EternalStatBuff + 1
							player:AddEternalHearts(-1)
						elseif value == 6 then
							data.PersistentPlayerData.BoneStatBuff = data.PersistentPlayerData.BoneStatBuff + 1
							player:AddBoneHearts(-1)
						elseif value == 7 then
							data.PersistentPlayerData.RottenStatBuff = data.PersistentPlayerData.RottenStatBuff + 1
							player:AddRottenHearts(-1)
						elseif value == 8 then
							data.PersistentPlayerData.BrokenStatBuff = data.PersistentPlayerData.BrokenStatBuff + 1
							player:AddBrokenHearts(-1)
						end
						
						player:AddCacheFlags(CacheFlag.CACHE_ALL);
						player:EvaluateItems();
					end
				else
					--print("heelsdfd")
					if dir then --if selecting
						data.selectedBodyDysWire = true
					end
				end
			end)
		else
			data.BODYDYSMORPHIA_MENU:Update( player:GetShootingInput(), Isaac.WorldToScreen(player.Position + Vector(0, -50)) )
			if data.TotalStoredBodyDysmorphiaHearts and data.TotalStoredBodyDysmorphiaHearts > 4 then --if more than four hearts
				if not data.refreshDysmorphiaChoiceFrame then data.refreshDysmorphiaChoiceFrame = cyclePerFrame end
				--print(data.refreshDysmorphiaChoiceFrame)
				if data.refreshDysmorphiaChoiceFrame <= 0 then --refresh!
					local currentBodyDysmorphiaNextPage = data.currentBodyDysmorphiaNextPage
					local wires = {}
					local wiresValue = {}
					--if already at the end
					if data.TotalStoredBodyDysmorphiaHearts <= data.currentBodyDysmorphiaNextPage then
						data.currentBodyDysmorphiaNextPage = 0
						for i = 1, 4 do
							if data.StoredBodyDysmorphiaHearts[i] then
								table.insert(wires, data.StoredBodyDysmorphiaHearts[i].gfx)
								table.insert(wiresValue, data.StoredBodyDysmorphiaHearts[i].id)
								if data.StoredBodyDysmorphiaHearts[i].gfx then
									data.currentBodyDysmorphiaNextPage = data.currentBodyDysmorphiaNextPage + 1
								end
							end
						end
					else --else
						for i = 1+currentBodyDysmorphiaNextPage, 4+currentBodyDysmorphiaNextPage do
							if not data.currentBodyDysmorphiaNextPage then data.currentBodyDysmorphiaNextPage = 0 end
							if data.StoredBodyDysmorphiaHearts[i] then
								table.insert(wires, data.StoredBodyDysmorphiaHearts[i].gfx)
								table.insert(wiresValue, data.StoredBodyDysmorphiaHearts[i].id)
								data.currentBodyDysmorphiaNextPage = data.currentBodyDysmorphiaNextPage + 1
							else
								--table.insert(wires, nil)
							end
						end
					end
					data.BODYDYSMORPHIA_MENU:UpdateOptions(wires, wiresValue)
					data.refreshDysmorphiaChoiceFrame = cyclePerFrame
				else
					if player:GetShootingInput().X == 0 or player:GetShootingInput().Y == 0 then
						data.refreshDysmorphiaChoiceFrame = data.refreshDysmorphiaChoiceFrame - 1
					end
				end
			end
		end
	else
		if data.BODYDYSMORPHIA_MENU then data.BODYDYSMORPHIA_MENU:Remove() end
	end
end);
