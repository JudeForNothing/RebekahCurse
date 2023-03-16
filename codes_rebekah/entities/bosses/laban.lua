yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local sprite = eff:GetSprite()
	local data = yandereWaifu.GetEntityData(eff)

    if not sprite:IsPlaying("SmallIdle") then
        sprite:Play("SmallIdle", true)
    end
end, RebekahCurse.ENTITY_LABAN_DUDE);
