
--if has bomb item
yandereWaifu:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function(_,player)
	local data = yandereWaifu.GetEntityData(player)
	if player:HasCollectible(RebekahCurse.COLLECTIBLE_OHIMDIE) then
		if InutilLib.config:GetCollectible(player:GetActiveItem(ActiveSlot.SLOT_PRIMARY)).MaxCharges == player:GetActiveCharge(ActiveSlot.SLOT_PRIMARY) or  InutilLib.config:GetCollectible(player:GetActiveItem(ActiveSlot.SLOT_SECONDARY)).MaxCharges == player:GetActiveCharge(ActiveSlot.SLOT_SECONDARY) or InutilLib.config:GetCollectible(player:GetActiveItem(ActiveSlot.SLOT_POCKET)).MaxCharges == player:GetActiveCharge(ActiveSlot.SLOT_POCKET) then
			if not data.ImDieCountdown or data.ImDieCountdown == 0 then data.ImDieCountdown = 2000 end
			if not data.WireCombinations then 
				data.WireCombinations = {}
				for i = 1, 4 do
					data.WireCombinations[i] = math.random(0,3)
	
				end
			end
			if not data.currentIndex then data.currentIndex = 1 end
			
			print( TableLength(data.WireCombinations) )
			
			if data.ImDieCountdown > 100 then
				if data.ImDieCountdown%100 == 0 then
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
				if data.ImDieCountdown%2 == 0 then
					player:SetColor(Color(1,0,0,1), 1, 1000, true, true)
				end
			end
			
			data.ImDieCountdown = data.ImDieCountdown - 1
			
			if data.ImDieCountdown == 0 then
				local bomb = Isaac.Spawn(EntityType.ENTITY_BOMBDROP, BombVariant.BOMB_GIGA, 0, player.Position,  Vector.Zero, nil):ToBomb();
				bomb.ExplosionDamage = 5
				bomb:SetExplosionCountdown(0)
				player:RemoveCollectible(RebekahCurse.COLLECTIBLE_OHIMDIE, false, ActiveSlot.SLOT_PRIMARY)
				player:RemoveCollectible(RebekahCurse.COLLECTIBLE_OHIMDIE, false, ActiveSlot.SLOT_SECONDARY)
				player:RemoveCollectible(RebekahCurse.COLLECTIBLE_OHIMDIE, false, ActiveSlot.SLOT_POCKET)
				
				data.WireCombinations = nil
				data.ImDieCountdown = 0
				data.currentIndex = nil
			end
		else
		--	data.ImDieCountdown = 0
		end
	end
end)


function yandereWaifu:useimDie(collItem, rng, player, flag, slot)
	local data = yandereWaifu.GetEntityData(player)
	
	local wires = {
		"gfx/ui/wires/red.png",
		"gfx/ui/wires/blue.png",
		"gfx/ui/wires/green.png",
		"gfx/ui/wires/yellow.png"
	}
	
	data.IMDIE_MENU:UpdateOptions(wires)
	
	data.IMDIE_MENU:ToggleMenu()
	if slot == ActiveSlot.SLOT_POCKET then slot = true else slot = false end
	InutilLib.ToggleShowActive(player, false, slot)
	
	--if data.IMDIE_MENU.open then
	if data.currentIndex < 5 then
		InutilLib.RefundActiveCharge(player, 0)
	end
	--end
end
yandereWaifu:AddCallback( ModCallbacks.MC_USE_ITEM, yandereWaifu.useimDie, RebekahCurse.COLLECTIBLE_OHIMDIE);


yandereWaifu:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, function(_, player)
	local data = yandereWaifu.GetEntityData(player)
	local controller = player.ControllerIndex;
	local isDiffused = false --marks if successful diffusing
	if player:HasCollectible(RebekahCurse.COLLECTIBLE_OHIMDIE) then
		if not data.IMDIE_MENU then --set menu
			data.IMDIE_MENU = yandereWaifu.Minimenu:New("gfx/ui/none.png", Isaac.WorldToScreen(player.Position + Vector(0, -50)));
			
			data.IMDIE_MENU:AttachCallback( function(dir)
				if data.IMDIE_MENU.onRelease then
					
					--print(data.currentIndex)
					--if selected stuff code
					if dir and data.selectedImDieWire then
						if dir == data.WireCombinations[data.currentIndex] then
							if data.currentIndex < 4 then
								data.currentIndex = data.currentIndex + 1
							else
								data.WireCombinations = nil
								data.ImDieCountdown = 0
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
						data.IMDIE_MENU:ToggleMenu()
						--end
						data.selectedImDieWire = false
					end
				else
					print("heelsdfd")
					if dir then --if selecting
						data.selectedImDieWire = true
					end
				end
			end)
		else
			data.IMDIE_MENU:Update( player:GetShootingInput(), Isaac.WorldToScreen(player.Position + Vector(0, -50)) )
		end
	else
		if data.IMDIE_MENU then	data.IMDIE_MENU:Remove() end
	end
end);