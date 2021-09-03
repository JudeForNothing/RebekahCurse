
		--pheromones fart ring
		yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, function(_, eff)
			local sprite = eff:GetSprite()
			sprite:Play("Appear", true)
			eff.RenderZOffset = 10000;
			eff.SpriteOffset = Vector(0,-10)
		end, ENTITY_PHEROMONES_RING);
		yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
			local sprite = eff:GetSprite();
			local data = GetEntityData(eff)
			local player = data.Player
			
			if sprite:IsFinished("Appear") then
				sprite:Play("Loop", true)
			end
			
			if eff.FrameCount == 20 then
				sprite:Play("Dissappear", true)
			end
			
			if sprite:IsFinished("Dissappear") then
				eff:Remove()
			end
			
			eff.Velocity = player.Velocity;
			eff.Position = player.Position;
			
			for k, ent in pairs(Isaac.GetRoomEntities()) do
				if ent:IsEnemy() and ent:IsVulnerableEnemy() then
				local num = 45
					if ent.Position:Distance( eff.Position ) < ent.Size + eff.Size + num then
						ent:AddCharmed(EntityRef(player), math.random(30,300))
					end
				end
			end
		end, ENTITY_PHEROMONES_RING);

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
					SchoolbagAPI.DoKnockbackTypeI(eff, enemy, 0.2)
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
	local data = SchoolbagAPI.GetSAPIData(eff)
	if not data.Init then                                             
		data.spr = Sprite()                                                 
		data.spr:Load("gfx/effects/eternal/eternalmorningstar.anm2", true) 
		data.spr:SetFrame("Chain", 1)
		data.Init = true                                              
	end          
	SchoolbagAPI.DeadDrawRotatedTilingSprite(data.spr, Isaac.WorldToScreen(data.Player.Position), Isaac.WorldToScreen(eff.Position), 16, nil, 8, true)
	data.sprOverlay = eff:GetSprite()
	data.sprOverlay:Render(Isaac.WorldToScreen(eff.Position))
end, ENTITY_LOVEHOOK);

yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local sprite = eff:GetSprite();
	local data = GetEntityData(eff)
	local player = data.Player
	--set chains
	--SchoolbagAPI.AttachChain(data.Player, eff)
	
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
			SchoolbagAPI.RefundActiveCharge(player, 120)
			eff:Remove()
		end
	elseif data.Attached and data.Attached:IsDead() then
		SchoolbagAPI.RefundActiveCharge(player, 120)
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
			SchoolbagAPI.RefundActiveCharge(player, 300)
			eff:Remove()
		end
	end
end, ENTITY_LOVEHOOK);

--cursed maw effect
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local player = Isaac.GetPlayer(0);
	local controller = player.ControllerIndex;
	local sprite = eff:GetSprite();
	local room =  Game():GetRoom();
	local data = GetEntityData(player)
    local roomClampSize = math.max( player.Size, 20 );
	--movement code
	eff.GridCollisionClass =  EntityGridCollisionClass.GRIDCOLL_GROUND;

	local movementDirection = player:GetMovementInput();

	--if movementDirection:Length() < 0.05 then
		--eff.Velocity = eff.Velocity * 0.3;
	player.Position = room:GetClampedPosition(eff.Position, roomClampSize);
		--player.Velocity = eff.Velocity;
	--else
		--eff.Velocity = (eff.Velocity * 0.9) + movementDirection:Resized( BALANCE.SOUL_HEARTS_DASH_TARGET_SPEED );
	--end

	--function code
	--player.Velocity = (room:GetClampedPosition(eff.Position, roomClampSize) - player.Position)*0.5;
	eff.Velocity = player.Velocity * 2
	eff.Position = player.Position
	local modulusnum = math.ceil((player.MaxFireDelay))
	if sprite:IsPlaying("Lick")then --shooting gimmick
		if Isaac.GetFrameCount() % ( modulusnum * 2)== 0 then
			local rng = math.random(-30,30)
			for i = 0, 360, 360/6 do
				if player:HasWeaponType(WeaponType.WEAPON_BRIMSTONE) then
					local brim = player:FireBrimstone( Vector.FromAngle(i + rng) ):ToLaser();
				elseif player:HasWeaponType(WeaponType.WEAPON_LASER) then --tech barrage
					local techlaser = player:FireTechLaser(player.Position, 0, Vector.FromAngle(i + rng), false, true)
					techlaser.OneHit = true;
					techlaser.Timeout = 1;
					techlaser.CollisionDamage = player.Damage * 2;
				else
					local tears = player:FireTear(player.Position, Vector.FromAngle(i + rng)*(8), false, false, false)
					tears.Position = player.Position
					--tears:ChangeVariant(TearVariant.BLOOD) --seems to bug
				end
			end
			
			--killaura thing
			for i, e in pairs(Isaac.GetRoomEntities()) do
				if e.Type ~= EntityType.ENTITY_PLAYER then
					if e:IsActiveEnemy() then
						if e:IsVulnerableEnemy() then
							if (eff.Position - e.Position):Length() < 75 then
								e:TakeDamage(player.Damage, 0, EntityRef(eff),4)
							end
						end
					end
				end
			end
		end
	end
	
	if eff.FrameCount == 1 then
		--player.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS;
		
		player.Visible = false
		player.ControlsEnabled = false;
	elseif sprite:IsFinished("Open") then
		sprite:Play("Lick",true);
		player.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE;
	elseif eff.FrameCount == 155 and sprite:IsPlaying("Lick") then
		sprite:Play("Spit",true);
	elseif sprite:IsEventTriggered("Spit") then
        if BALANCE.SOUL_HEARTS_DASH_RETAINS_VELOCITY == false then
            player.Velocity = Vector( 0, 0 );
        end
    	if player.CanFly == true and room:GetType() ~= RoomType.ROOM_DUNGEON then
    		player.Position = eff.Position;
            if room:IsPositionInRoom(player.Position, 0) == false then
                player.Velocity = Vector( 0, 0 );
                player.Position = room:GetClampedPosition( player.Position, roomClampSize );
            end
    	else
            player.Position = room:FindFreeTilePosition( eff.Position, 0 )
            if room:IsPositionInRoom(player.Position, 0) == false then
                player.Velocity = Vector( 0, 0 );
                player.Position = room:FindFreeTilePosition( room:GetClampedPosition( player.Position, roomClampSize ), 0 );
            end
        end
		player.Visible = true;
		player:AnimatePitfallOut()
		--player.GridCollisionClass = data.LastGridCollisionClass;
    	speaker:Play( SoundEffect.SOUND_WEIRD_WORM_SPIT, 1, 0, false, 1 );
	elseif sprite:IsEventTriggered("Spit2") then
		player.ControlsEnabled = true;
		player.EntityCollisionClass = data.LastEntityCollisionClass;
		
    	data.IsUninteractible = false;
    	speaker:Play( SoundEffect.SOUND_WEIRD_WORM_SPIT, 1, 0, false, 1 );
    end
	if sprite:IsFinished("Spit") then
		eff:Remove()
	end
	player:SetShootingCooldown(2)

end, ENTITY_CURSEDMAW);
