

yandereWaifu:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function(_,player)

	--unrequited love
	if player:HasCollectible(RebekahCurse.COLLECTIBLE_UNREQUITEDLOVE) then
		if InutilLib.ConfirmUseActive( player, RebekahCurse.COLLECTIBLE_UNREQUITEDLOVE ) then
			local vector = InutilLib.DirToVec(player:GetFireDirection())
			local hook = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_LOVEHOOK, 0, player.Position, vector:Resized(45), player)
			hook.RenderZOffset = -10000;
			yandereWaifu.GetEntityData(hook).Player = player
			InutilLib.ConsumeActiveCharge(player)
			InutilLib.ToggleShowActive(player, false)
			
		end
	end
	--yandereWaifu:EctoplasmLeaking(player) 
end)

--unrequited love code
function yandereWaifu:useUnLove(collItem, rng, player)
	--for i,player in ipairs(ILIB.players) do
	InutilLib.ToggleShowActive(player, true)
	--end
end
yandereWaifu:AddCallback( ModCallbacks.MC_USE_ITEM, yandereWaifu.useUnLove, RebekahCurse.COLLECTIBLE_UNREQUITEDLOVE );

--love hook effect

yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, function(_,  eff) --eternal star
	--set chains
	local data = yandereWaifu.GetEntityData(eff)
	if not data.Init then                                             
		data.spr = Sprite()                                                 
		data.spr:Load("gfx/effects/eternal/eternalmorningstar.anm2", true) 
		data.spr:SetFrame("Chain", 1)
		data.Init = true                                              
	end          
	InutilLib.DeadDrawRotatedTilingSprite(data.spr, Isaac.WorldToScreen(data.Player.Position), Isaac.WorldToScreen(eff.Position), 16, nil, 8, true)
	data.sprOverlay = eff:GetSprite()
	data.sprOverlay:Render(Isaac.WorldToScreen(eff.Position))
end, RebekahCurse.ENTITY_LOVEHOOK);

yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local sprite = eff:GetSprite();
	local data = yandereWaifu.GetEntityData(eff)
	local player = data.Player
	--set chains
	--InutilLib.AttachChain(data.Player, eff)
	
	if data.Attached and not data.Attached:IsDead() then
		--eff.Visible = false
		eff:SetColor(Color(0,0,0,0,0,0,0),9999999,99,false,false);
		eff.Velocity = data.Attached.Velocity
		eff.Position = data.Attached.Position
		local dist = data.Attached.Position:Distance((player.Position ))
		if dist > 250 and Isaac.GetFrameCount() % math.floor(10) == 0 then
			data.Attached:TakeDamage(1.5, 0, EntityRef(eff), 1)
			data.Attached.Velocity = data.Attached.Velocity * 1.5
		end
		if data.Attached.EntityCollisionClass == EntityCollisionClass.ENTCOLL_NONE then --remove cases
			InutilLib.RefundActiveCharge(player, 120)
			eff:Remove()
		end
		
		--delayed saved velocity
		local neededPosition = player.Position
		data.delayedVel = data.delayedVel or nil
		InutilLib.SetTimer( 1, function()
			data.delayedVel = (data.Attached.Velocity) * 1.2
		end)
		if data.delayedVel then
			data.Attached.Velocity = (data.Attached.Velocity*0.95 + player:GetShootingInput()*3) + ((neededPosition - data.Attached.Position)*0.02); 
		end
		if player:GetShootingInput() then
			if not data.SwingingInertia then data.SwingingInertia = 0 end
			data.SwingingInertia = data.SwingingInertia + 1
		else
			data.SwingingInertia = 0
		end
		-- print(brideProtectorAngle)
		data.Attached:AddEntityFlags(EntityFlag.FLAG_SLIPPERY_PHYSICS)
		--data.Attached:AddEntityFlags(EntityFlag.FLAG_HELD)
		--data.Attached.Velocity = (data.Attached.Velocity+player:GetShootingInput()*5)*0.9
		
		if data.CountdownTilRelease <= 0 or data.Attached:CollidesWithGrid() then
			eff:Remove()
			InutilLib.RefundActiveCharge(player, 300)
			data.Attached:AddEntityFlags(EntityFlag.FLAG_BLEED_OUT)
			if data.Attached:CollidesWithGrid() then
				ILIB.game:ShakeScreen(10)
				data.Attached:TakeDamage(player.Damage * data.Attached.Velocity:Length()/2, 0, EntityRef(eff), 1)
				InutilLib.SFX:Play( SoundEffect.SOUND_FORESTBOSS_STOMPS, 1, 0, false, 1.4 );
			end
		end
		data.CountdownTilRelease = data.CountdownTilRelease - 1
		--ram stuff
		local entities = Isaac.GetRoomEntities()
		for i = 1, #entities do
			if entities[i]:IsVulnerableEnemy() and GetPtrHash(entities[i]) ~= GetPtrHash(data.Attached) then
				if entities[i].Position:Distance(data.Attached.Position) < entities[i].Size + data.Attached.Size + 8 then
					if data.Attached.Velocity:Length() > 9 then
						entities[i]:TakeDamage(player.Damage * 0.8, 0, EntityRef(eff), 1)
						data.Attached:TakeDamage(player.Damage * 0.8, 0, EntityRef(eff), 1)
					end
				end
			end
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
					data.CountdownTilRelease = math.random(300,400)
				end
			end
		end
		if eff.FrameCount > 10 then --expiration
			InutilLib.RefundActiveCharge(player, 300)
			eff:Remove()
		end
	end
end, RebekahCurse.ENTITY_LOVEHOOK);