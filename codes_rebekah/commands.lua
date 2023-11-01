local REBECCA_MODE_COMMAND_KEYS = {
	none = RebekahCurse.REBECCA_MODE.EmptyHearts,
	red = RebekahCurse.REBECCA_MODE.RedHearts,
	soul = RebekahCurse.REBECCA_MODE.SoulHearts,
	blue = RebekahCurse.REBECCA_MODE.SoulHearts,
	eternal = RebekahCurse.REBECCA_MODE.EternalHearts,
	white = RebekahCurse.REBECCA_MODE.EternalHearts,
	gold = RebekahCurse.REBECCA_MODE.GoldHearts,
	black = RebekahCurse.REBECCA_MODE.EvilHearts,
	evil = RebekahCurse.REBECCA_MODE.EvilHearts,
	bone = RebekahCurse.REBECCA_MODE.BoneHearts,
	rotten = RebekahCurse.REBECCA_MODE.RottenHearts,
	broken = RebekahCurse.REBECCA_MODE.BrokenHearts,
	immortal = RebekahCurse.REBECCA_MODE.ImmortalHearts,

	scared = RebekahCurse.REBECCA_MODE.ScaredRedHearts,
	twinred = RebekahCurse.REBECCA_MODE.TwinRedHearts,
	blended = RebekahCurse.REBECCA_MODE.BlendedHearts,
	halfred = RebekahCurse.REBECCA_MODE.HalfRedHearts,
	halfsoul = RebekahCurse.REBECCA_MODE.HalfSoulHearts,
	
	bred = RebekahCurse.REBECCA_MODE.BrideRedHearts,

	cursed = RebekahCurse.REBECCA_MODE.CursedCurse,
}

REBEKAHMODE_EXPERIMENTAL = {
	lovelove = false,
	easter = false
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
