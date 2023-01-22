--romcom code
function yandereWaifu:useRomComBook(collItem, rng, player)
	--InutilLib.ToggleShowActive(player, true)
	for i, v in pairs (Isaac.GetRoomEntities()) do
		if v:IsEnemy() and v:IsVulnerableEnemy() and not v:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
			yandereWaifu.GetEntityData(v).IsLaughing = 300
			if player:HasCollectible(CollectibleType.COLLECTIBLE_CAR_BATTERY) then
				yandereWaifu.GetEntityData(v).IsLaughing = 600
				v:AddCharmed(EntityRef(player), 600)
			else
				if math.random(1,2) == 2 then
					v:AddCharmed(EntityRef(player), 300)
				end
			end
		end
	end
	if math.random(1,10) == 10 then
		SFXManager():Play( RebekahCurseSounds.SOUND_LAUGHUNSETTLING , 1, 0, false, 1 );
	else
		SFXManager():Play( RebekahCurseSounds.SOUND_LAUGHTRACK , 1, 0, false, 1 );
	end
	InutilLib.AnimateGiantbook("gfx/ui/giantbook/giantbook_romcom.png", nil, "Shake", _, true)
end
yandereWaifu:AddCallback( ModCallbacks.MC_USE_ITEM, yandereWaifu.useRomComBook, RebekahCurseItems.COLLECTIBLE_ROMCOM );

--[[yandereWaifu:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_,player)
	--local player = Isaac.GetPlayer(0);
    local room = Game():GetRoom();
	local data = yandereWaifu.GetEntityData(player)
	--typical rom-command
	if player:HasCollectible(RebekahCurseItems.COLLECTIBLE_ROMCOM) then
		if InutilLib.ConfirmUseActive( player, RebekahCurseItems.COLLECTIBLE_ROMCOM ) then
			local vector = InutilLib.DirToVec(player:GetFireDirection())
			data.specialAttackVector = Vector( vector.X, vector.Y )
			InutilLib.ConsumeActiveCharge(player)
			InutilLib.ToggleShowActive(player, false)
			
			local rng = math.random(1,5)
			yandereWaifu.DoExtraBarrages(player, 1)
		end
	end
end)]]
