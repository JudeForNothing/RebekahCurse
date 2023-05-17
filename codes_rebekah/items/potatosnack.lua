yandereWaifu:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_,player)
	--local player = Isaac.GetPlayer(0);
    local room = Game():GetRoom();
	local data = yandereWaifu.GetEntityData(player)
	--items function!
	--if player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_POTATOSNACK) then
		--[[if player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_POTATOSNACK) and InutilLib.HasJustPickedCollectible( player, RebekahCurse.Items.COLLECTIBLE_POTATOSNACK ) then
			player:AddNullCostume(RebekahCurse.Costumes.PotatoSnack)
		end]]
	--end
end)