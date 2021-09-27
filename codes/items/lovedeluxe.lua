yandereWaifu:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_,player)
	local data = yandereWaifu.GetEntityData(player)
	if player:HasCollectible(RebekahCurse.COLLECTIBLE_LOVEDELUXE) then
		if player:GetFireDirection() == -1 then --if not firing
			if data.loveDeluxeTick and data.loveDeluxeDir then
				if data.loveDeluxeTick > 30 then
					local cut = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_HAIRWHIP, 0, player.Position, Vector(0,0), player);
					yandereWaifu.GetEntityData(cut).PermanentAngle = data.loveDeluxeDir
					yandereWaifu.GetEntityData(cut).Player = player
				end
			end
			data.loveDeluxeTick = 0
		else
			if not data.loveDeluxeTick then data.loveDeluxeTick = 0 end
			
			data.loveDeluxeTick = data.loveDeluxeTick + 1
			
			local dir
			if player:GetFireDirection() == 3 then --down
				dir = 90
			elseif player:GetFireDirection() == 1 then --up
				dir = -90
			elseif player:GetFireDirection() == 0 then --left
				dir = 180
			elseif player:GetFireDirection() == 2 then --right
				dir = 0
			end
			data.loveDeluxeDir = dir
		end
	end
end)


yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local sprite = eff:GetSprite()
	local data = yandereWaifu.GetEntityData(eff)
	local player = data.Player
	eff.GridCollisionClass =  EntityGridCollisionClass.GRIDCOLL_NOPITS 
	
	local room =  Game():GetRoom()
	
	--function code
	if eff.FrameCount == 1 then
		sprite:Play("AttackHori", true)
	end
	if sprite:IsFinished("AttackHori") then
		eff:Remove()
	end 
	
	eff.Position = player.Position
	eff.Velocity = player.Velocity
	
	--close hitbox
	if sprite:GetFrame() >= 4 and sprite:GetFrame() <= 6 then
		for i, ent in pairs (Isaac.GetRoomEntities()) do
			if (ent:IsEnemy() and ent:IsVulnerableEnemy()) or ent.Type == EntityType.ENTITY_FIREPLACE and not ent:IsDead() then
				if InutilLib.CuccoLaserCollision(eff, data.PermanentAngle, 240, ent) then
				--if ent.Position:Distance((eff.Position)+ (Vector(50,0):Rotated(data.PermanentAngle))) <= 90 then
					ent:TakeDamage(2.5, 0, EntityRef(eff), 1)
				end
			end
		end
	end
			--player.Velocity = Vector(0,0)
		--end
		InutilLib.SFX:Play( SoundEffect.SOUND_SWORD_SPIN, 1, 0, false, 2);
	--[[	local grid = room:GetGridEntity(room:GetGridIndex((eff.Position)+ (Vector(50,0):Rotated(data.PermanentAngle)))) --grids around that Rebecca stepped on
		if grid ~= nil then 
			--print( grid:GetType())
			if grid:GetType() == GridEntityType.GRID_TNT or grid:GetType() == GridEntityType.GRID_POOP then
				grid:Destroy()
			end
		end
	end]]
	eff:GetSprite().Rotation = data.PermanentAngle
end, RebekahCurse.ENTITY_HAIRWHIP)