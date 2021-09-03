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

function yandereWaifu:SaveAchievement()
	local saveData = RecapRebekahData()
	Isaac.SaveModData(yandereWaifu, JSON.encode( saveData ) );
end

function yandereWaifu:ExecuteCommand( command, params )
	if command == "rebeccamode" or command == "becmode" then
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
end
yandereWaifu:AddCallback( ModCallbacks.MC_EXECUTE_CMD, yandereWaifu.ExecuteCommand )
