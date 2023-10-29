function yandereWaifu:CannedLaughterNewRoom()
	local laugh = false
	for p = 0, InutilLib.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		local data = yandereWaifu.GetEntityData(player)
		local room = InutilLib.game:GetRoom()
		if player:HasTrinket(RebekahCurse.Trinkets.TRINKET_CANNEDLAUGHTER) and not room:IsClear() and math.random(1,10) >= 9 then
			laugh = true
			SFXManager():Play( RebekahCurse.Sounds.SOUND_LAUGHTRACK , 1, 0, false, 1 );
		end
	end
	if laugh then
		for i, e in pairs(Isaac.GetRoomEntities()) do
			if e:IsEnemy() and e:IsVulnerableEnemy() then
				yandereWaifu.GetEntityData(e).IsLaughing = 300
			end
		end
	end
end
yandereWaifu:AddCallback( ModCallbacks.MC_POST_NEW_ROOM, yandereWaifu.CannedLaughterNewRoom)