function yandereWaifu.ClearTransitionNightmare()
    StageAPI.TransitionNightmares = {}
end

function yandereWaifu.ResetNightmaresForUniquePlayers(_, hasstarted) --Init
	--if hasstarted then
		yandereWaifu.ClearTransitionNightmare()
        StageAPI.AddTransitionNightmare("gfx/ui/nightmares/basic/nightmare1.anm2")
        print("ITS THE NEGAACHIN")
	--end
end
yandereWaifu:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, yandereWaifu.ResetNightmaresForUniquePlayers)