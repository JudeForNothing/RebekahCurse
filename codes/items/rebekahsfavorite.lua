yandereWaifu:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_,player)
	local data = yandereWaifu.GetEntityData(player)
	--cursed spoon
	if InutilLib.HasJustPickedCollectible( player, RebekahCurse.COLLECTIBLE_REBEKAHSFAVORITE) then
		InutilLib:SpawnCustomStrawman(PlayerType.PLAYER_ESAU, player, true)
	end
end)