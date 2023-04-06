local modes = {
	RebekahCurse.REBECCA_MODE.RedHearts,
	RebekahCurse.REBECCA_MODE.SoulHearts,
	RebekahCurse.REBECCA_MODE.EternalHearts,
	RebekahCurse.REBECCA_MODE.GoldHearts,
	RebekahCurse.REBECCA_MODE.EvilHearts,
	RebekahCurse.REBECCA_MODE.BoneHearts,
	RebekahCurse.REBECCA_MODE.RottenHearts,
	RebekahCurse.REBECCA_MODE.BrokenHearts,
	RebekahCurse.REBECCA_MODE.ImmortalHearts,
}
local detrimentalModes = {
	RebekahCurse.REBECCA_MODE.BlendedHearts,
	RebekahCurse.REBECCA_MODE.ScaredRedHearts,
	RebekahCurse.REBECCA_MODE.TwinRedHearts,
	RebekahCurse.REBECCA_MODE.HalfRedHearts,
}

yandereWaifu:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(_, continue)
	if not continue then
        local challenge = InutilLib.game.Challenge == RebekahCurse.Challenges.IdentityCrisis
        if challenge then
            local player = Isaac.GetPlayer(0)
            local data = yandereWaifu.GetEntityData(player)
			--print("WWWWW")
			--print(RebekahCurse.REB_RED)
			--Isaac.ExecuteCommand("restart "..RebekahCurse.REB_RED)
            player:ChangePlayerType(RebekahCurse.REB_RED)
            if player.FrameCount <= 2 then --trying to make it visually pleasing when she spawns in
				player.Visible = false
			end
			yandereWaifu.ChangeMode( player, RebekahCurse.REBECCA_MODE.RedHearts, true );
			
			--personalized doubletap classes
			data.DASH_DOUBLE_TAP = InutilLib.DoubleTap:New();
			data.ATTACK_DOUBLE_TAP = InutilLib.DoubleTap:New();
			-- start the meters invisible
			data.moveMeterFadeStartFrame = -20;
			data.attackMeterFadeStartFrame = -20;
			data.bonestackMeterFadeStartFrame = 0;
				
			RebeccaInit(player)
			--yandereWaifu.ApplyCostumes( data.currentMode, player );

			if not data.NoBoneSlamActive then data.NoBoneSlamActive = true end
        end
    end
end)

--function yandereWaifu:DIDChallengeNewRoom()
yandereWaifu:AddCallback("MC_POST_CLEAR_ROOM", function(_, room)
--StageAPI.AddCallback("RebekahCurse", "POST_ROOM_CLEAR", 2, function()
	local challenge = InutilLib.game.Challenge == RebekahCurse.Challenges.IdentityCrisis
    if challenge --[[and InutilLib.level:GetStage() > 1]] then
        for p = 0, InutilLib.game:GetNumPlayers() - 1 do
            local player = Isaac.GetPlayer(p)
			if InutilLib.level:GetStage() > 1 and math.random(1,2) == 2 then
				yandereWaifu.ChangeMode( player, detrimentalModes[math.random(1, #detrimentalModes)], false, false);
			else
				yandereWaifu.ChangeMode( player, modes[math.random(1, #modes)], false, false);
			end
        end
    end
end)

--yandereWaifu:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, yandereWaifu.DIDChallengeNewRoom)