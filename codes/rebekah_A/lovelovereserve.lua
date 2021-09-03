
----------------
--<3 RESERVE CODE--

function yandereWaifu.getReserveStocks(player)
	return yandereWaifu.GetEntityData(player).heartStocks
end

function yandereWaifu.addReserveStocks(player, number)
	yandereWaifu.GetEntityData(player).heartStocks = yandereWaifu.GetEntityData(player).heartStocks + number
	print("add")
	print(yandereWaifu.getReserveStocks(player))
	
end

function yandereWaifu.purchaseReserveStocks(player, number, restore)
	number = number or 1
	print("get")
	print(yandereWaifu.getReserveStocks(player))
	if yandereWaifu.getReserveStocks(player) >= 1 then
		yandereWaifu.addReserveStocks(player, -number)
		--just in case, i dont wannt negatives
		if yandereWaifu.getReserveStocks(player) <= 0 then
			yandereWaifu.GetEntityData(player).heartStocks = 0
		end
	else
		--player:AddHearts( -1 )
		if restore then
			if player:GetBrokenHearts() > 11 then
				player:Die()
			else
				if player:GetHearts() --[[+ player:GetSoulHearts() + player:GetGoldenHearts() + player:GetBoneHearts() + player:GetEternalHearts() + player:GetRottenHearts()]] <= 1 then
					player:AddBrokenHearts(1)
				end
				yandereWaifu.addReserveStocks(player, 1)
				player:TakeDamage( 1, DamageFlag.DAMAGE_NOKILL | DamageFlag.DAMAGE_RED_HEARTS, EntityRef(player), 0);
				player:ResetDamageCooldown()
			end
		end
	end
end

function yandereWaifu.getReserveFill(player)
	return yandereWaifu.GetEntityData(player).heartReserveFill
end

function yandereWaifu.addReserveFill(player, number)
	--if yandereWaifu.GetEntityData(player).heartReserveFill > 0 then
		yandereWaifu.GetEntityData(player).heartReserveFill = yandereWaifu.GetEntityData(player).heartReserveFill + number
	--else
		--calculate broken down stocks into pure reserve
	--	local newReserve = yandereWaifu.getReserveStocks(player) * yandereWaifu.GetEntityData(player).heartReserveMaxFill
	--	yandereWaifu.GetEntityData(player).heartReserveFill = yandereWaifu.GetEntityData(player).heartReserveFill + newReserve
	--	yandereWaifu.GetEntityData(player).heartReserveFill = yandereWaifu.GetEntityData(player).heartReserveFill + number
	--end
end

function yandereWaifu.resetReserve(player) --used to reset the stocks back into reserve so that the game can recalculate it for other modes
	if not yandereWaifu.getReserveStocks(player)  then
		yandereWaifu.GetEntityData(player).heartStocks = 0
	end
	if yandereWaifu.getReserveStocks(player) > 0 then
		local savedLastStocks = (yandereWaifu.getReserveStocks(player))
		yandereWaifu.addReserveStocks(player, -(yandereWaifu.getReserveStocks(player)))
		yandereWaifu.addReserveFill(player, -yandereWaifu.getReserveFill(player))
		local newReserve = savedLastStocks * yandereWaifu.GetEntityData(player).heartReserveMaxFill
		yandereWaifu.addReserveFill(player, newReserve/2)
	end
end

function yandereWaifu.heartReserveLogic(player)
	--for p = 0, game:GetNumPlayers() - 1 do
	--local player = Isaac.GetPlayer(p)
	local playerdata = yandereWaifu.GetEntityData(player);
	--print(playerdata.heartStocksMax)
	--print(yandereWaifu.getReserveStocks(player))
	if playerdata.heartReserveFill >= playerdata.heartReserveMaxFill and yandereWaifu.getReserveStocks(player) < playerdata.heartStocksMax then
		local number = 0
		local remainder = math.floor(playerdata.heartReserveFill/playerdata.heartReserveMaxFill)
		for j = 0, remainder, 1 do
			number = j
		end
		print(remainder)
		print("summer")
		if number > 0 then
			yandereWaifu.addReserveStocks(player, number)
			yandereWaifu.addReserveFill(player, -playerdata.heartReserveMaxFill) --decrease reserve to fit in more reserve
		end
	elseif playerdata.heartStocksMax and yandereWaifu.getReserveStocks(player) then
		if yandereWaifu.getReserveStocks(player) >= playerdata.heartStocksMax then -- force max stocks
			yandereWaifu.GetEntityData(player).heartStocks = playerdata.heartStocksMax
			yandereWaifu.GetEntityData(player).heartReserveFill = 0
			--yandereWaifu.GetEntityData(player).heartReserveFill = playerdata.heartReserveMaxFill - 1
		end
	--end
	--[[elseif playerdata.heartReserveFill == 0 then
		local number = yandereWaifu.getReserveStocks(player) - 1
		print(number)
		if number == 0 then
			print("works")
			yandereWaifu.addReserveFill(player, playerdata.heartReserveMaxFill)
			yandereWaifu.addReserveStocks(player, -number)
		end]]
	end
end
