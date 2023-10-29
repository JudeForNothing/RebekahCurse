
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, function(_, eff)
	local data = InutilLib.GetILIBData( eff )
	local sprite = eff:GetSprite();
	sprite:Play("HouseJustBeingAHouse", true)
end, RebekahCurse.ENTITY_HOUSE_BACKDROP)
