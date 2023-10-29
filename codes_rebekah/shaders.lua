yandereWaifu:AddCallback(ModCallbacks.MC_GET_SHADER_PARAMS, function(_, shaderName)
	if shaderName == "apologizeimscared" then
		local isActive = 1.0
		--local isLiminal = yandereWaifu.STAGE.Liminal:IsStage()
		--if not isLiminal then
			isActive = 0.0
		--end
		local param = { 
			colored = 12.0,
			pulse = math.floor(InutilLib.game:GetFrameCount()%15)*1.0,
			shaderActive = isActive
		}
		return param
	end
	if shaderName == "yourreality" then
		local isActive = 0.0
		--local isLiminal = yandereWaifu.STAGE.Liminal:IsStage()
		local isErroring = false
		for i, player in pairs (Isaac.FindByType(EntityType.ENTITY_PLAYER, -1, -1, false, false)) do
			local data = yandereWaifu.GetEntityData(player)
			if data.MirrorBrokenCooldown and data.MirrorBrokenCooldown >= 28 then
				isErroring = true
				break
			end
		end 
		if isErroring then
			isActive = 1.0
		end
		local frame = 1.0
		local param = { 
			time = frame,
			shaderActive = isActive
		}
		return param
	end
end)
