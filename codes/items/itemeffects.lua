

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

--love hook effect

yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, function(_,  eff) --eternal star
	--set chains
	local data = InutilLib.GetILIBData(eff)
	if not data.Init then                                             
		data.spr = Sprite()                                                 
		data.spr:Load("gfx/effects/eternal/eternalmorningstar.anm2", true) 
		data.spr:SetFrame("Chain", 1)
		data.Init = true                                              
	end          
	InutilLib.DeadDrawRotatedTilingSprite(data.spr, Isaac.WorldToScreen(data.Player.Position), Isaac.WorldToScreen(eff.Position), 16, nil, 8, true)
	data.sprOverlay = eff:GetSprite()
	data.sprOverlay:Render(Isaac.WorldToScreen(eff.Position))
end, ENTITY_LOVEHOOK);

yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local sprite = eff:GetSprite();
	local data = GetEntityData(eff)
	local player = data.Player
	--set chains
	--InutilLib.AttachChain(data.Player, eff)
	
	if data.Attached and not data.Attached:IsDead() then
		--eff.Visible = false
		eff:SetColor(Color(0,0,0,0,0,0,0),9999999,99,false,false);
		eff.Velocity = data.Attached.Velocity
		eff.Position = data.Attached.Position
		local dist = data.Attached.Position:Distance((player.Position ))
		data.Attached:AddEntityFlags(EntityFlag.FLAG_BLEED_OUT)
		if dist > 250 and Isaac.GetFrameCount() % math.floor(10) == 0 then
			data.Attached:TakeDamage(1.5, 0, EntityRef(eff), 1)
		end
		if data.Attached.EntityCollisionClass == EntityCollisionClass.ENTCOLL_NONE then --remove cases
			InutilLib.RefundActiveCharge(player, 120)
			eff:Remove()
		end
	elseif data.Attached and data.Attached:IsDead() then
		InutilLib.RefundActiveCharge(player, 120)
		eff:Remove()
	else
		--rotation gimmick
		local angleNum = (eff.Velocity):GetAngleDegrees();
		eff:GetSprite().Rotation = angleNum;
		eff:GetData().Rotation = eff:GetSprite().Rotation;
		local entities = Isaac.GetRoomEntities()
		for i = 1, #entities do
			if entities[i]:IsVulnerableEnemy() then
				if entities[i].Position:Distance(eff.Position) < entities[i].Size + eff.Size + 8 then
					if entities[i].Size > 12 then
						data.Attached = entities[i]
						entities[i]:TakeDamage(player.Damage * 1.6, 0, EntityRef(eff), 1)
					else
						entities[i]:TakeDamage(player.Damage * 1.3, 0, EntityRef(eff), 1)
					end
				end
			end
		end
		if eff.FrameCount > 10 then --expiration
			InutilLib.RefundActiveCharge(player, 300)
			eff:Remove()
		end
	end
end, ENTITY_LOVEHOOK);
