--dice of fate code
function yandereWaifu:useDiceOfFate(collItem, rng, player)
	local hearts = player:GetMaxHearts() + player:GetSoulHearts() + player:GetGoldenHearts() + player:GetEternalHearts() + player:GetBoneHearts() + player:GetRottenHearts()
	local addEternal, addGolden = false, 0
	if player:GetPlayerType() ~= PlayerType.PLAYER_KEEPER then
		player:AddGoldenHearts(-player:GetGoldenHearts())
		player:AddMaxHearts(-player:GetMaxHearts())
		player:AddHearts(-player:GetHearts())
		player:AddSoulHearts(-player:GetSoulHearts())
		player:AddEternalHearts(-player:GetEternalHearts())
		player:AddBoneHearts(-player:GetBoneHearts())
		player:AddBlackHearts(-yandereWaifu.GetPlayerBlackHearts(player))
		player:AddRottenHearts(-player:GetRottenHearts())
	end
	--remove all hearts first
	if player:GetPlayerType() == PlayerType.PLAYER_KEEPER then
		rng = math.random(1,20)
		if rng < 6 then --red add
			player:AddBlueFlies(1, player.Position, player)
		elseif rng < 8 then
			player:AddBlueFlies(2, player.Position, player)
		elseif rng < 12 then
			player:AddBlueFlies(3, player.Position, player)
		elseif rng < 15 then
			player:AddBlueSpider(player.Position)
		elseif rng < 17 then
			player:AddBlueFlies(1, player.Position, player)
			player:AddBlueSpider(player.Position)
		else
			player:AddBlueFlies(3, player.Position, player)
			for i = 1, 3, 1 do
				player:AddBlueSpider(player.Position)
			end
		end
	elseif player:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN then
		local hadEternal = false
		for i = 0, hearts do
			rng = math.random(1,20)
			if rng < 2 then --red add
				player:AddHearts(2)
			elseif rng < 6 then
				player:AddMaxHearts(1)
			elseif rng < 8 then
				player:AddGoldenHearts(1)
			elseif rng < 12 then
				player:AddSoulHearts(1)
			elseif rng < 15 then
				player:AddBlackHearts(1)
			elseif rng < 17 then
				player:AddRottenHearts(1)
			elseif rng < 18 then
				if not hadEternal then
					--player:AddEternalHearts(1)
					hadEternal = true
				else
					player:AddSoulHearts(1)
				end
			else
				player:AddBoneHearts(1)
			end
		end
		if player:GetBoneHearts() <= 0 then
			player:AddBoneHearts(1)
		end
	else
		local hadEternal = false
		for i = 0, hearts do
			rng = math.random(1,20)
			if rng < 2 then --red add
				player:AddHearts(2)
			elseif rng < 6 then
				player:AddMaxHearts(1)
			elseif rng < 8 then
				addGolden = addGolden + 1
			elseif rng < 12 then
				player:AddSoulHearts(1)
			elseif rng < 15 then
				player:AddBlackHearts(1)
			elseif rng < 17 then
				player:AddRottenHearts(1)
			elseif rng < 18 then
				if not hadEternal then
					--player:AddEternalHearts(1)
					hadEternal = true
					addEternal = true
				else
					player:AddSoulHearts(1)
				end
			else
				player:AddBoneHearts(1)
			end
		end
		--[[if addEternal then
			player:AddEternalHearts(1)
		end
		if addGolden > 0 then
			player:AddGoldenHearts(addGolden)
		end]]
	end
	return true
end
yandereWaifu:AddCallback( ModCallbacks.MC_USE_ITEM, yandereWaifu.useDiceOfFate, RebekahCurse.COLLECTIBLE_DICEOFFATE );