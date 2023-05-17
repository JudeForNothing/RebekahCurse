yandereWaifu:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function(_, pl)
	local sprite = pl:GetSprite()
	
	if pl:HasCollectible(RebekahCurse.Items.COLLECTIBLE_WISHFULTHINKING) then
		if sprite:IsPlaying("Death") and sprite:GetFrame() == 30 then
			pl:Revive()
			pl:RemoveCollectible(RebekahCurse.Items.COLLECTIBLE_WISHFULTHINKING)
			pl:ResetDamageCooldown()
			pl:SetMinDamageCooldown(120)
			
			pl:ChangePlayerType(RebekahCurse.WISHFUL_ISAAC)
			--yandereWaifu.ApplyCostumes( _, pl, true, false)
		end
	end
end);