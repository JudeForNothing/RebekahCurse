local function HasAnyWikipedia(slot, player)
	if	player:GetActiveItem(slot) == RebekahCurseItems.COLLECTIBLE_WIKEPIDIA1 or player:GetActiveItem(slot) == RebekahCurseItems.COLLECTIBLE_WIKEPIDIA2 or player:GetActiveItem(slot) ==RebekahCurseItems.COLLECTIBLE_WIKEPIDIA3 or player:GetActiveItem(slot) ==RebekahCurseItems.COLLECTIBLE_WIKEPIDIA4 or player:GetActiveItem(slot) == RebekahCurseItems.COLLECTIBLE_WIKEPIDIA5 or player:GetActiveItem(slot) == RebekahCurseItems.COLLECTIBLE_WIKEPIDIA6 or player:GetActiveItem(slot) ==RebekahCurseItems.COLLECTIBLE_WIKEPIDIA7 or player:GetActiveItem(slot) ==RebekahCurseItems.COLLECTIBLE_WIKEPIDIA8 or player:GetActiveItem(slot) ==RebekahCurseItems.COLLECTIBLE_WIKEPIDIA9 or player:GetActiveItem(slot) ==RebekahCurseItems.COLLECTIBLE_WIKEPIDIA10 or player:GetActiveItem(slot) ==RebekahCurseItems.COLLECTIBLE_WIKEPIDIA11 or player:GetActiveItem(slot) ==RebekahCurseItems.COLLECTIBLE_WIKEPIDIA12 or player:GetActiveItem(slot) ==RebekahCurseItems.COLLECTIBLE_WIKEPIDIA13 or player:GetActiveItem(slot) ==RebekahCurseItems.COLLECTIBLE_WIKEPIDIA14 then
		return true
	else
		return false
	end
end

yandereWaifu:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_,player)
	--local player = Isaac.GetPlayer(0);
    local room = Game():GetRoom();
	local data = yandereWaifu.GetEntityData(player)
	local controller = player.ControllerIndex;
	
	--on first time pickup
	if player:GetActiveItem(slot) == RebekahCurseItems.COLLECTIBLE_WIKEPIDIA and not data.PersistentPlayerData.WikepidiaPage and  not data.PersistentPlayerData.WikepidiaCharge then
		
		InutilLib.SetTimer( 30, function()
			if player:GetActiveItem(slot) == RebekahCurseItems.COLLECTIBLE_WIKEPIDIA then
				player:RemoveCollectible(RebekahCurseItems.COLLECTIBLE_WIKEPIDIA, false, slot)
				player:AddCollectible(RebekahCurseItems.COLLECTIBLE_WIKEPIDIA1, 0, true, slot)
		
				player:SetActiveCharge(3, ActiveSlot.SLOT_PRIMARY)
				print(RebekahCurseItems.COLLECTIBLE_WIKEPIDIAPASSIVE)
				player:AddCollectible(RebekahCurseItems.COLLECTIBLE_WIKEPIDIAPASSIVE, 0, true)
			end
		end);
	end
end)
function yandereWaifu:WikepidiaInput(entity, inputHook, buttonAction)
	--for j = 1, Game():GetNumPlayers() do
	if entity then
		if entity:ToPlayer() then
			local player = entity:ToPlayer() --Isaac.GetPlayer(j-1)
			local data = yandereWaifu.GetEntityData(player)
			local controller = player.ControllerIndex;
			if HasAnyWikipedia(ActiveSlot.SLOT_PRIMARY, player) then
				if Input.IsActionTriggered(ButtonAction.ACTION_DROP, controller) then
				if inputHook == InputHook.IS_ACTION_TRIGGERED and buttonAction == ButtonAction.ACTION_DROP then
					local willStop = true
					if not data.PersistentPlayerData.WikepidiaPage then data.PersistentPlayerData.WikepidiaPage = 1 end
					if not data.PersistentPlayerData.WikepidiaCharge then data.PersistentPlayerData.WikepidiaCharge = player:GetActiveCharge(ActiveSlot.SLOT_PRIMARY) end
					
					--print(player:GetActiveCharge(ActiveSlot.SLOT_PRIMARY))
					
					--something that saves what charges you might have so you dont lose charges
					if data.PersistentPlayerData.WikepidiaCharge <= player:GetActiveCharge(ActiveSlot.SLOT_PRIMARY) then data.PersistentPlayerData.WikepidiaCharge = player:GetActiveCharge(ActiveSlot.SLOT_PRIMARY) end
					
						--print(data.PersistentPlayerData.WikepidiaCharge)
						if not data.LastDropTriggerFrame then data.LastDropTriggerFrame = player.FrameCount end
							print("linking")
							print(player.FrameCount)
							print(data.LastDropTriggerFrame+ 8)
							print(player:GetPlayerType())
							if ((player:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN or player:GetPlayerType() == PlayerType.PLAYER_THESOUL) and data.LastDropTriggerFrame + 8 > player.FrameCount) or (player:GetPlayerType() ~= PlayerType.PLAYER_THEFORGOTTEN and player:GetPlayerType() ~= PlayerType.PLAYER_THESOUL) then
								player:RemoveCollectible(RebekahCurseItems.COLLECTIBLE_WIKEPIDIA + data.PersistentPlayerData.WikepidiaPage, false, slot)
								print("park")
								if data.PersistentPlayerData.WikepidiaPage == 14 then
									data.PersistentPlayerData.WikepidiaPage = 1
									willStop = false
								else
									data.PersistentPlayerData.WikepidiaPage = data.PersistentPlayerData.WikepidiaPage + 1
								end
								
								player:AddCollectible(RebekahCurseItems.COLLECTIBLE_WIKEPIDIA, 0, true, slot)
								if not player:HasCollectible(CollectibleType.COLLECTIBLE_SCHOOLBAG) or (willStop and player:HasCollectible(CollectibleType.COLLECTIBLE_SCHOOLBAG)) then
									InutilLib.SetTimer( 30, function()
										if player:GetActiveItem(slot) == RebekahCurseItems.COLLECTIBLE_WIKEPIDIA then
											player:RemoveCollectible(RebekahCurseItems.COLLECTIBLE_WIKEPIDIA, false, slot)
											player:AddCollectible(RebekahCurseItems.COLLECTIBLE_WIKEPIDIA + data.PersistentPlayerData.WikepidiaPage, 0, true, slot)
									
											player:SetActiveCharge(data.PersistentPlayerData.WikepidiaCharge, ActiveSlot.SLOT_PRIMARY)
									
										end
									end);
								end
								if not willStop and player:HasCollectible(CollectibleType.COLLECTIBLE_SCHOOLBAG) then 
									player:RemoveCollectible(RebekahCurseItems.COLLECTIBLE_WIKEPIDIA, false, slot)
									player:AddCollectible(RebekahCurseItems.COLLECTIBLE_WIKEPIDIA + data.PersistentPlayerData.WikepidiaPage, 0, true, slot)
									
									player:SetActiveCharge(data.PersistentPlayerData.WikepidiaCharge, ActiveSlot.SLOT_PRIMARY)
									
									player:SwapActiveItems()
								end
								data.LastDropTriggerFrame = player.FrameCount
								return false
							end
							data.LastDropTriggerFrame = player.FrameCount
					end
				end
			end
			--[[if player:GetActiveItem(slot) == RebekahCurseItems.COLLECTIBLE_WIKEPIDIA then
				if Input.IsActionTriggered(ButtonAction.ACTION_DROP, controller) then
					if inputHook == InputHook.IS_ACTION_TRIGGERED and buttonAction == ButtonAction.ACTION_DROP then
						if player:HasCollectible(CollectibleType.COLLECTIBLE_SCHOOLBAG) then
							player:SwapActiveItems()
						end
					end
				end
			end]]
		end
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_INPUT_ACTION , yandereWaifu.WikepidiaInput)

function yandereWaifu:useWiki1(collItem, rng, player, _, slot)
	--local player = Isaac.GetPlayer(0);
    local room = Game():GetRoom();
	local data = yandereWaifu.GetEntityData(player)
	player:UseActiveItem(CollectibleType.COLLECTIBLE_ANARCHIST_COOKBOOK, false, false, false, false, -1)
	if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES) then
		player:AddWisp(CollectibleType.COLLECTIBLE_ANARCHIST_COOKBOOK, player.Position, false, false)
	end
	data.PersistentPlayerData.WikepidiaCharge = 0
end
yandereWaifu:AddCallback( ModCallbacks.MC_USE_ITEM, yandereWaifu.useWiki1, RebekahCurseItems.COLLECTIBLE_WIKEPIDIA1 )

function yandereWaifu:useWiki2(collItem, rng, player, _, slot)
	--local player = Isaac.GetPlayer(0);
    local room = Game():GetRoom();
	local data = yandereWaifu.GetEntityData(player)
	player:UseActiveItem(CollectibleType.COLLECTIBLE_BOOK_OF_REVELATIONS, false, false, false, false, -1)
	if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES) then
		player:AddWisp(CollectibleType.COLLECTIBLE_BOOK_OF_REVELATIONS, player.Position, false, false)
	end
	data.PersistentPlayerData.WikepidiaCharge = 0
end
yandereWaifu:AddCallback( ModCallbacks.MC_USE_ITEM, yandereWaifu.useWiki2, RebekahCurseItems.COLLECTIBLE_WIKEPIDIA2 )

function yandereWaifu:useWiki3(collItem, rng, player, _, slot)
	--local player = Isaac.GetPlayer(0);
    local room = Game():GetRoom();
	local data = yandereWaifu.GetEntityData(player)
	player:UseActiveItem(CollectibleType.COLLECTIBLE_BOOK_OF_SECRETS, false, false, false, false, -1)
	if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES) then
		player:AddWisp(CollectibleType.COLLECTIBLE_BOOK_OF_SECRETS, player.Position, false, false)
	end
	data.PersistentPlayerData.WikepidiaCharge = 0
end
yandereWaifu:AddCallback( ModCallbacks.MC_USE_ITEM, yandereWaifu.useWiki3, RebekahCurseItems.COLLECTIBLE_WIKEPIDIA3 )

function yandereWaifu:useWiki4(collItem, rng, player, _, slot)
	--local player = Isaac.GetPlayer(0);
    local room = Game():GetRoom();
	local data = yandereWaifu.GetEntityData(player)
	if data.lastActiveUsedFrameCount then
		if InutilLib.game:GetFrameCount() == data.lastActiveUsedFrameCount then
			return
		end
						
		data.lastActiveUsedFrameCount = InutilLib.game:GetFrameCount()
	else
		data.lastActiveUsedFrameCount = InutilLib.game:GetFrameCount()
	end
	player:UseActiveItem(CollectibleType.COLLECTIBLE_HOW_TO_JUMP, false, false, false, false, -1)
	if player:GetActiveCharge(slot) <= 1 then
		InutilLib.SetTimer( 15*30, function()
			if player:HasCollectible(RebekahCurseItems.COLLECTIBLE_WIKEPIDIA4) then
				player:SetActiveCharge(1, slot)
			end
		end)
	end
	data.PersistentPlayerData.WikepidiaCharge = 0
	if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES) then
		player:AddWisp(CollectibleType.COLLECTIBLE_HOW_TO_JUMP, player.Position, false, false)
	end
end
yandereWaifu:AddCallback( ModCallbacks.MC_USE_ITEM, yandereWaifu.useWiki4, RebekahCurseItems.COLLECTIBLE_WIKEPIDIA4 )

function yandereWaifu:useWiki5(collItem, rng, player, _, slot)
	--local player = Isaac.GetPlayer(0);
    local room = Game():GetRoom();
	local data = yandereWaifu.GetEntityData(player)
	player:UseActiveItem(CollectibleType.COLLECTIBLE_MONSTER_MANUAL, false, false, false, false, -1)
	if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES) then
		player:AddWisp(CollectibleType.COLLECTIBLE_MONSTER_MANUAL, player.Position, false, false)
	end
	data.PersistentPlayerData.WikepidiaCharge = 0
end
yandereWaifu:AddCallback( ModCallbacks.MC_USE_ITEM, yandereWaifu.useWiki5, RebekahCurseItems.COLLECTIBLE_WIKEPIDIA5 )

function yandereWaifu:useWiki6(collItem, rng, player, _, slot)
	--local player = Isaac.GetPlayer(0);
    local room = Game():GetRoom();
	local data = yandereWaifu.GetEntityData(player)
	player:UseActiveItem(CollectibleType.COLLECTIBLE_SATANIC_BIBLE, false, false, false, false, -1)
	if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES) then
		player:AddWisp(CollectibleType.COLLECTIBLE_SATANIC_BIBLE, player.Position, false, false)
	end
	data.PersistentPlayerData.WikepidiaCharge = 0
end
yandereWaifu:AddCallback( ModCallbacks.MC_USE_ITEM, yandereWaifu.useWiki6, RebekahCurseItems.COLLECTIBLE_WIKEPIDIA6 )

function yandereWaifu:useWiki7(collItem, rng, player, _, slot)
	--local player = Isaac.GetPlayer(0);
    local room = Game():GetRoom();
	local data = yandereWaifu.GetEntityData(player)
	player:UseActiveItem(CollectibleType.COLLECTIBLE_TELEPATHY_BOOK, false, false, false, false, -1)
	if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES) then
		player:AddWisp(CollectibleType.COLLECTIBLE_TELEPATHY_BOOK, player.Position, false, false)
	end
	data.PersistentPlayerData.WikepidiaCharge = 0
end
yandereWaifu:AddCallback( ModCallbacks.MC_USE_ITEM, yandereWaifu.useWiki7, RebekahCurseItems.COLLECTIBLE_WIKEPIDIA7 )

function yandereWaifu:useWiki8(collItem, rng, player, _, slot)
	--local player = Isaac.GetPlayer(0);
    local room = Game():GetRoom();
	local data = yandereWaifu.GetEntityData(player)
	player:UseActiveItem(CollectibleType.COLLECTIBLE_BIBLE, true, false, false, true, -1)
	--player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_BIBLE, true, 1)
	if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES) then
		player:AddWisp(CollectibleType.COLLECTIBLE_BIBLE, player.Position, false, false)
	end
	data.PersistentPlayerData.WikepidiaCharge = 0
end
yandereWaifu:AddCallback( ModCallbacks.MC_USE_ITEM, yandereWaifu.useWiki8, RebekahCurseItems.COLLECTIBLE_WIKEPIDIA8 )

function yandereWaifu:useWiki9(collItem, rng, player, _, slot)
	--local player = Isaac.GetPlayer(0);
    local room = Game():GetRoom();
	local data = yandereWaifu.GetEntityData(player)
	player:UseActiveItem(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL, false, false, false, false, -1)
	if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES) then
		player:AddWisp(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL, player.Position, false, false)
	end
	data.PersistentPlayerData.WikepidiaCharge = 0
end
yandereWaifu:AddCallback( ModCallbacks.MC_USE_ITEM, yandereWaifu.useWiki9, RebekahCurseItems.COLLECTIBLE_WIKEPIDIA9 )

function yandereWaifu:useWiki10(collItem, rng, player, _, slot)
	--local player = Isaac.GetPlayer(0);
    local room = Game():GetRoom();
	local data = yandereWaifu.GetEntityData(player)
	player:UseActiveItem(CollectibleType.COLLECTIBLE_BOOK_OF_SIN, false, false, false, false, -1)
	if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES) then
		player:AddWisp(CollectibleType.COLLECTIBLE_BOOK_OF_SIN, player.Position, false, false)
	end
	data.PersistentPlayerData.WikepidiaCharge = 0
end
yandereWaifu:AddCallback( ModCallbacks.MC_USE_ITEM, yandereWaifu.useWiki10, RebekahCurseItems.COLLECTIBLE_WIKEPIDIA10 )

function yandereWaifu:useWiki11(collItem, rng, player, _, slot)
	--local player = Isaac.GetPlayer(0);
    local room = Game():GetRoom();
	local data = yandereWaifu.GetEntityData(player)
	player:UseActiveItem(CollectibleType.COLLECTIBLE_NECRONOMICON, false, false, false, false, -1)
	if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES) then
		player:AddWisp(CollectibleType.COLLECTIBLE_NECRONOMICON, player.Position, false, false)
	end
	data.PersistentPlayerData.WikepidiaCharge = 0
end
yandereWaifu:AddCallback( ModCallbacks.MC_USE_ITEM, yandereWaifu.useWiki11, RebekahCurseItems.COLLECTIBLE_WIKEPIDIA11 )


function yandereWaifu:useWiki12(collItem, rng, player, _, slot)
	--local player = Isaac.GetPlayer(0);
    local room = Game():GetRoom();
	local data = yandereWaifu.GetEntityData(player)
	player:UseActiveItem(CollectibleType.COLLECTIBLE_BOOK_OF_THE_DEAD, false, false, false, false, -1)
	if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES) then
		player:AddWisp(CollectibleType.COLLECTIBLE_BOOK_OF_THE_DEAD, player.Position, false, false)
	end
	data.PersistentPlayerData.WikepidiaCharge = 0
end
yandereWaifu:AddCallback( ModCallbacks.MC_USE_ITEM, yandereWaifu.useWiki12, RebekahCurseItems.COLLECTIBLE_WIKEPIDIA12 )

function yandereWaifu:useWiki13(collItem, rng, player, _, slot)
	--local player = Isaac.GetPlayer(0);
    local room = Game():GetRoom();
	local data = yandereWaifu.GetEntityData(player)
	player:UseActiveItem(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES, false, false, false, false, -1)
	player:AddWisp(-1, player.Position, false, false)
	if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES) then
		player:AddWisp(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES, player.Position, false, false)
	end
	data.PersistentPlayerData.WikepidiaCharge = 0
end
yandereWaifu:AddCallback( ModCallbacks.MC_USE_ITEM, yandereWaifu.useWiki13, RebekahCurseItems.COLLECTIBLE_WIKEPIDIA13 )

function yandereWaifu:useWiki14(collItem, rng, player, _, slot)
	--local player = Isaac.GetPlayer(0);
    local room = Game():GetRoom();
	local data = yandereWaifu.GetEntityData(player)
	player:UseActiveItem(CollectibleType.COLLECTIBLE_LEMEGETON, false, false, false, false, -1)
	if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES) then
		player:AddWisp(CollectibleType.COLLECTIBLE_LEMEGETON, player.Position, false, false)
	end
	data.PersistentPlayerData.WikepidiaCharge = 0
end
yandereWaifu:AddCallback( ModCallbacks.MC_USE_ITEM, yandereWaifu.useWiki14, RebekahCurseItems.COLLECTIBLE_WIKEPIDIA14 )