yandereWaifu:AddCallback(ModCallbacks.MC_GET_SHADER_PARAMS, function(_, shaderName)
	if shaderName == "apologizeimscared" then
		local isActive = 1
		--local isLiminal = yandereWaifu.STAGE.Liminal:IsStage()
		--if not isLiminal then
			isActive = 0
		--end
		local param = { 
			colored = 12.0,
			pulse = ILIB.game:GetFrameCount()%15,
			shaderActive = isActive
		}
		return param
	end
	if shaderName == "yourreality" then
		local isActive = 1
		--local isLiminal = yandereWaifu.STAGE.Liminal:IsStage()
		--if not isLiminal then
			isActive = 0
		--end
		local frame = 1
		local param = { 
			time = frame,
			shaderActive = isActive
		}
		return param
	end
end)
