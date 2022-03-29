local REBECCA_MODE_COMMAND_KEYS = {
	red = REBECCA_MODE.RedHearts,
	soul = REBECCA_MODE.SoulHearts,
	blue = REBECCA_MODE.SoulHearts,
	eternal = REBECCA_MODE.EternalHearts,
	white = REBECCA_MODE.EternalHearts,
	gold = REBECCA_MODE.GoldHearts,
	black = REBECCA_MODE.EvilHearts,
	evil = REBECCA_MODE.EvilHearts,
	bone = REBECCA_MODE.BoneHearts,
	rotten = REBECCA_MODE.RottenHearts,
	broken = REBECCA_MODE.BrokenHearts,
	
	bred = REBECCA_MODE.BrideRedHearts
}

REBEKAHMODE_EXPERIMENTAL = {
	lovelove = false
}

function yandereWaifu:SaveAchievement()
	local saveData = RecapRebekahData()
	Isaac.SaveModData(yandereWaifu, REB_JSON.encode( saveData ) );
end

function yandereWaifu:ExecuteCommand( command, params )
	if command == "rebeccamode" or command == "becmode" or command == "rebekahmode" then
		if REBECCA_MODE_COMMAND_KEYS[params] ~= nil then
			yandereWaifu.ChangeMode(Isaac.GetPlayer(0), REBECCA_MODE_COMMAND_KEYS[params], true, true);
		end
    end
	if command == "beccaresetachievement" then
		if params == "all" then
			CurrentRebeccaUnlocks = BaseRebeccaUnlocks
			yandereWaifu:SaveAchievement()
			print("Resetted "..tostring(params))
		end
	end
	
	if command == "rebekahbeta" or command == "rebekahbeta" then
		if REBEKAHMODE_EXPERIMENTAL[params] ~= nil then
			if not REBEKAHMODE_EXPERIMENTAL[params] then
				REBEKAHMODE_EXPERIMENTAL[params] = true
			else
				REBEKAHMODE_EXPERIMENTAL[params] = false
			end
			print("Option is now toggled as"..tostring(REBEKAHMODE_EXPERIMENTAL[params])..". Have fun!")
		end
	end
end
yandereWaifu:AddCallback( ModCallbacks.MC_EXECUTE_CMD, yandereWaifu.ExecuteCommand )
