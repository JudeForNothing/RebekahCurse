
yandereWaifu:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_,player)
	--local player = Isaac.GetPlayer(0);
    local room = Game():GetRoom();
	local data = yandereWaifu.GetEntityData(player)
	--items function!
		--[[if player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_TECHHZ) and InutilLib.HasJustPickedCollectible( player, RebekahCurse.Items.COLLECTIBLE_TECHHZ ) then
			player:AddNullCostume(RebekahCurse.Costumes.TechHz)
		end]]
		if player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_TECHHZ) then
			local movement = player:GetMovementVector()
			if movement:Length() > 0 and player:GetFireDirection() > -1 then
				if math.floor(player.FrameCount % 5) == 0 then
					data.TechHz = player:FireTechXLaser(player.Position, Vector.Zero, 42, player, 0.7):ToLaser()
					data.TechHz.Timeout = 5
					data.TechHz.CollisionDamage = player.Damage/2
					yandereWaifu.GetEntityData(data.TechHz).TechHz = true
				end
			end
		end
end)

function yandereWaifu:TechHzUpdate(lz)
	local entityData = yandereWaifu.GetEntityData(lz);
	 if entityData.TechHz == true then
		if lz.FrameCount == 2 then
			SFXManager():Stop(271);
			SFXManager():Stop(272);
			SFXManager():Stop(273);
		end
		lz.Position = lz.Parent.Position
		if lz.Child ~= nil then
			lz.Child.Color = Color(0,0,0,0)
		end
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_POST_LASER_UPDATE, yandereWaifu.TechHzUpdate)
