local dash = {}

--double tap local dash function
function dash.CursedRebekahDoubleTapDash(vector, playerTapping)
	for p = 0, InutilLib.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		--print(GetPtrHash( playerTapping), "     vector!", GetPtrHash( player))
		if GetPtrHash( playerTapping ) == GetPtrHash( player) then
			local psprite = player:GetSprite()
			local playerdata = yandereWaifu.GetEntityData(player);
			local trinketBonus = 0
			if player:HasTrinket(RebekahCurseTrinkets.TRINKET_ISAACSLOCKS) then
				trinketBonus = 5
			end
			--print(playerdata.IsDashActive , playerdata.IsAttackActive , playerdata.NoBoneSlamActive)
			--checks if you can dash without interrupting something
			local isFree = not (psprite:IsPlaying("Trapdoor") or psprite:IsPlaying("Jump") or psprite:IsPlaying("HoleIn") or psprite:IsPlaying("HoleDeath") or psprite:IsPlaying("JumpOut") or
			psprite:IsPlaying("LightTravel") or psprite:IsPlaying("Appear") or psprite:IsPlaying("Death") 
			or psprite:IsPlaying("TeleportUp") or psprite:IsPlaying("TeleportDown")) and not (playerdata.IsUninteractible)
			and playerdata.specialCooldown <= 0 and not playerdata.IsParalysed and not DeadSeaScrollsMenu.IsOpen()
			
			if isFree then
				if yandereWaifu.IsTaintedRebekah(player) then --IF tainted
					yandereWaifu.CursedHeartStomp(player, vector)
				end
				playerdata.specialMaxCooldown = playerdata.specialCooldown --gain the max amount dash cooldown
				-- update the dash double tap cooldown based on Rebecca's mode specific cooldown
			end
			playerdata.DASH_TAINTED_DOUBLE_TAP.cooldown = playerdata.specialCooldown;
		end
	end
end

return dash