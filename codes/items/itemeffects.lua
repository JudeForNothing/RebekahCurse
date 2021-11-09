

		--snap fart
		yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, function(_, eff)
			local sprite = eff:GetSprite()
			local data = GetEntityData(eff)
			eff.RenderZOffset = 10000;
			eff.SpriteOffset = Vector(0,-10)
		end, ENTITY_SNAP_HEARTBEAT);
		yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
			local sprite = eff:GetSprite();
			local data = GetEntityData(eff)
			local player = data.Player
			
			if not data.Init then
				if data.Snap then
					sprite:Play("Heartbeat_snap", true)
				else
					sprite:Play("Heartbeat", true)
				end
		data.Init = true
	end
	if sprite:GetFrame() == 7 then
		for k, enemy in pairs( Isaac.GetRoomEntities() ) do
			if enemy:IsEnemy() --[[and not enemy:IsEffect() and not enemy:IsInvulnurable()]] then
				if enemy.Position:Distance( eff.Position ) < enemy.Size + eff.Size + 35 then
					InutilLib.DoKnockbackTypeI(eff, enemy, 0.2)
				end
			end
		end
	end
		
	if sprite:IsFinished("Heartbeat") or sprite:IsFinished("Heartbeat_snap") then
		eff:Remove()
	end
end, ENTITY_SNAP_HEARTBEAT);

yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, function(_, eff)
	local sprite = eff:GetSprite()
	local data = GetEntityData(eff)
	--eff.RenderZOffset = 10000;
	eff.SpriteOffset = Vector(0,-30)
	speaker:Play( SOUND_ELECTRIC , 1, 0, false, 1.2 );
end, ENTITY_SNAP_EFFECT);
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local sprite = eff:GetSprite();
	local data = GetEntityData(eff)
	local player = data.Player
		
	if sprite:IsFinished("snap") then
		eff:Remove()
	end
end, ENTITY_SNAP_EFFECT);
