
--if has bomb item
yandereWaifu:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function(_,player)
	local data = yandereWaifu.GetEntityData(player)
	if player:HasCollectible(RebekahCurseItems.COLLECTIBLE_BAGOFBRISTLEBRICKS) then
		if InutilLib.config:GetCollectible(player:GetActiveItem(ActiveSlot.SLOT_PRIMARY)).MaxCharges == player:GetActiveCharge(ActiveSlot.SLOT_PRIMARY) or  InutilLib.config:GetCollectible(player:GetActiveItem(ActiveSlot.SLOT_SECONDARY)).MaxCharges == player:GetActiveCharge(ActiveSlot.SLOT_SECONDARY) or InutilLib.config:GetCollectible(player:GetActiveItem(ActiveSlot.SLOT_POCKET)).MaxCharges == player:GetActiveCharge(ActiveSlot.SLOT_POCKET) then
			if not data.BristleCountdown or data.BristleCountdown == 0 then data.BristleCountdown = 2000 end
			if not data.WireCombinations then 
				data.WireCombinations = {}
				for i = 1, 4 do
					data.WireCombinations[i] = math.random(0,3)
	
				end
			end
			if not data.currentIndex then data.currentIndex = 1 end
			
			--print( TableLength(data.WireCombinations) )
			
			if data.BristleCountdown > 100 then
				if data.BristleCountdown%100 == 0 then
					player:SetColor(Color(1,0,0,1), 1, 1000, true, true)
					for i = 1, 4 do

						InutilLib.SetTimer( i*30, function()
							if InutilLib.config:GetCollectible(player:GetActiveItem(ActiveSlot.SLOT_PRIMARY)).MaxCharges == player:GetActiveCharge(ActiveSlot.SLOT_PRIMARY) or  InutilLib.config:GetCollectible(player:GetActiveItem(ActiveSlot.SLOT_SECONDARY)).MaxCharges == player:GetActiveCharge(ActiveSlot.SLOT_SECONDARY) or InutilLib.config:GetCollectible(player:GetActiveItem(ActiveSlot.SLOT_POCKET)).MaxCharges == player:GetActiveCharge(ActiveSlot.SLOT_POCKET) then
								local target = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_PINGEFFECT, data.WireCombinations[i], player.Position, Vector.Zero, player)
							end
						end);
					end
				end
			else
				if data.BristleCountdown%2 == 0 then
					player:SetColor(Color(1,0,0,1), 1, 1000, true, true)
				end
			end
			
			data.BristleCountdown = data.BristleCountdown - 1
			
			if data.BristleCountdown == 0 then
				local bomb = Isaac.Spawn(EntityType.ENTITY_BOMBDROP, BombVariant.BOMB_GIGA, 0, player.Position,  Vector.Zero, nil):ToBomb();
				bomb.ExplosionDamage = 5
				bomb:SetExplosionCountdown(0)
				player:RemoveCollectible(RebekahCurseItems.COLLECTIBLE_BAGOFBRISTLEBRICKS, false, ActiveSlot.SLOT_PRIMARY)
				player:RemoveCollectible(RebekahCurseItems.COLLECTIBLE_BAGOFBRISTLEBRICKS, false, ActiveSlot.SLOT_SECONDARY)
				player:RemoveCollectible(RebekahCurseItems.COLLECTIBLE_BAGOFBRISTLEBRICKS, false, ActiveSlot.SLOT_POCKET)
				
				data.WireCombinations = nil
				data.BristleCountdown = 0
				data.currentIndex = nil
			end
		else
		--	data.BristleCountdown = 0
		end
	end
end)


function yandereWaifu:usebristle(collItem, rng, player, flag, slot)
	local data = yandereWaifu.GetEntityData(player)
	
	local wires = {
		"gfx/items/collectibles/bricks/red.png",
		"gfx/items/collectibles/bricks/blue.png",
		"gfx/items/collectibles/bricks/green.png",
		"gfx/items/collectibles/bricks/wheel.png"
	}
	
	data.BRISTLEBAG_MENU:UpdateOptions(wires)
	
	data.BRISTLEBAG_MENU:ToggleMenu()
	if slot == ActiveSlot.SLOT_POCKET then slot = true else slot = false end
	InutilLib.ToggleShowActive(player, false, slot)
	
	--if data.BRISTLEBAG_MENU.open then
	if data.currentIndex < 5 then
		InutilLib.RefundActiveCharge(player, 0)
	end
	--end
end
yandereWaifu:AddCallback( ModCallbacks.MC_USE_ITEM, yandereWaifu.usebristle, RebekahCurseItems.COLLECTIBLE_BAGOFBRISTLEBRICKS);


yandereWaifu:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, function(_, player)
	local data = yandereWaifu.GetEntityData(player)
	local controller = player.ControllerIndex;
	local isDiffused = false --marks if successful diffusing
	if player:HasCollectible(RebekahCurseItems.COLLECTIBLE_BAGOFBRISTLEBRICKS) then
		if not data.BRISTLEBAG_MENU then --set menu
			data.BRISTLEBAG_MENU = yandereWaifu.Minimenu:New("gfx/ui/none.png", Isaac.WorldToScreen(player.Position + Vector(0, -50)));
			
			data.BRISTLEBAG_MENU:AttachCallback( function(dir)
				if data.BRISTLEBAG_MENU.onRelease then
					
					--print(data.currentIndex)
					--if selected stuff code
					if dir and data.selectedBristleWire then
						if dir == data.WireCombinations[data.currentIndex] then
							if data.currentIndex < 4 then
								data.currentIndex = data.currentIndex + 1
							else
								data.WireCombinations = nil
								data.BristleCountdown = 0
								data.currentIndex = nil
								isDiffused = true
								for i = 1, 13 do
									local item = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, 0, ILIB.room:FindFreePickupSpawnPosition(player.Position, 1), Vector(0,0), nil) --body effect
								end
								player:SetActiveCharge(0, ActiveSlot.SLOT_PRIMARY)
								player:SetActiveCharge(0, ActiveSlot.SLOT_SECONDARY)
								player:SetActiveCharge(0, ActiveSlot.SLOT_POCKET)
							end
							player:AnimateHappy()
						else
							player:AnimateSad()
						end
						--if not isDiffused then
						data.BRISTLEBAG_MENU:ToggleMenu()
						--end
						data.selectedBristleWire = false
					end
				else
					--print("heelsdfd")
					if dir then --if selecting
						data.selectedBristleWire = true
					end
				end
			end)
		else
			data.BRISTLEBAG_MENU:Update( player:GetShootingInput(), Isaac.WorldToScreen(player.Position + Vector(0, -50)) )
		end
	else
		if data.BRISTLEBAG_MENU then data.BRISTLEBAG_MENU:Remove() end
	end
end);