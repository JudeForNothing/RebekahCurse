--romcom code
function yandereWaifu:useRomComBook(collItem, rng, player)
	InutilLib.ToggleShowActive(player, true)
end
yandereWaifu:AddCallback( ModCallbacks.MC_USE_ITEM, yandereWaifu.useRomComBook, RebekahCurse.COLLECTIBLE_ROMCOM );

yandereWaifu:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_,player)
	--local player = Isaac.GetPlayer(0);
    local room = Game():GetRoom();
	local data = yandereWaifu.GetEntityData(player)
	--typical rom-command
	if player:HasCollectible(RebekahCurse.COLLECTIBLE_ROMCOM) then
		if InutilLib.ConfirmUseActive( player, RebekahCurse.COLLECTIBLE_ROMCOM ) then
			local vector = InutilLib.DirToVec(player:GetFireDirection())
			data.specialAttackVector = Vector( vector.X, vector.Y )
			InutilLib.ConsumeActiveCharge(player)
			InutilLib.ToggleShowActive(player, false)
			
			local rng = math.random(1,5)
			yandereWaifu.DoExtraBarrages(player, 1)
		end
	end
end)