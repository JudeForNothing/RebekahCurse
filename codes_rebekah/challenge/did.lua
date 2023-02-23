yandereWaifu:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(_, new)
	if not new then
        local challenge = ILIB.game.Challenge == RebekahCurseChallenges.DID
        if challenge then
            local player = Isaac.GetPlayer(0)
            local data = yandereWaifu.GetEntityData(player)
            player:ChangePlayerType(RebekahCurse.REB_RED)
            if player.FrameCount <= 2 then --trying to make it visually pleasing when she spawns in
				player.Visible = false
			end
			yandereWaifu.ChangeMode( player, REBECCA_MODE.RedHearts, true );
			
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

function yandereWaifu:DIDChallengeNewLevel()
	local challenge = ILIB.game.Challenge == RebekahCurseChallenges.DID
    if challenge and ILIB.level:GetStage() > 1 then
        for p = 0, ILIB.game:GetNumPlayers() - 1 do
            local player = Isaac.GetPlayer(p)
            yandereWaifu.ChangeMode( player, math.random(1,9), false, false);
        end
    end
end

yandereWaifu:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, yandereWaifu.DIDChallengeNewLevel)