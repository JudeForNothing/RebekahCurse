function yandereWaifu.UpdateCurseRoomDepleteButWithRebekahsKey()
	local hasTrinket = false
	for p = 0, ILIB.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		local data = yandereWaifu.GetEntityData(player)
		local room = ILIB.game:GetRoom()
		if player:HasTrinket(RebekahCurseTrinkets.TRINKET_REBEKAHSKEY) then
			hasTrinket = true
			break
		end
	end
	if not hasTrinket then return end
	local trinketAdd = 20
	if RebekahLocalSavedata.loveRoomReplacePercent then
		if --[[RebekahLocalSavedata.savedloveRoomDepletePercent]] 0 >= RebekahLocalSavedata.loveRoomReplacePercent + trinketAdd then
			--RebekahLocalSavedata.loveRoomReplacePercent = 0
			RebekahLocalSavedata.loveRoomReplacePercent = RebekahLocalSavedata.loveRoomReplacePercent - trinketAdd
		else
			--addend thing for the trinket
			if 0 < RebekahLocalSavedata.loveRoomReplacePercent then
				RebekahLocalSavedata.loveRoomReplacePercent = RebekahLocalSavedata.loveRoomReplacePercent - trinketAdd
			end
			--if the sum of saved and added percent is higher than 100...
			if RebekahLocalSavedata.loveRoomReplacePercent + trinketAdd >= 100 then
				--make it flat 100%
				RebekahLocalSavedata.loveRoomReplacePercent = 100
			else
				RebekahLocalSavedata.loveRoomReplacePercent = RebekahLocalSavedata.loveRoomReplacePercent + trinketAdd
			end
		end
		--showDifference = true
		--Alpha = 2.9
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_POST_CURSE_EVAL, yandereWaifu.UpdateCurseRoomDepleteButWithRebekahsKey)