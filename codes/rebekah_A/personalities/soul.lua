
--SOUL HEART --
do
function yandereWaifu.SoulHeartTeleport(player, vector)
	local playerdata = yandereWaifu.GetEntityData(player)
	local SubType = 0
	local trinketBonus = 0
	if player:HasTrinket(RebekahCurse.TRINKET_ISAACSLOCKS) then
		trinketBonus = 5
	end
	--local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_PERSONALITYPOOF, 0, player.Position, Vector.Zero, player)
	
	local customBody = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_EXTRACHARANIMHELPER, 0, player.Position, Vector(0,0), player) --body effect
	yandereWaifu.GetEntityData(customBody).Player = player
	yandereWaifu.GetEntityData(customBody).WizoobIn = true
	player.Velocity = Vector( 0, 0 );
	player.ControlsEnabled = false;
	--yandereWaifu.SpawnPoofParticle( player.Position, Vector(0,0), player, RebekahPoofParticleType.Blue );
	yandereWaifu.SpawnHeartParticles( 3, 5, player.Position, yandereWaifu.RandomHeartParticleVelocity(), player, RebekahHeartParticleType.Blue );
	playerdata.specialCooldown = REBEKAH_BALANCE.SOUL_HEARTS_DASH_COOLDOWN - trinketBonus;
	playerdata.invincibleTime = REBEKAH_BALANCE.SOUL_HEARTS_DASH_INVINCIBILITY_FRAMES;
	InutilLib.SFX:Play( SoundEffect.SOUND_WEIRD_WORM_SPIT, 1, 0, false, 1 );
	playerdata.IsUninteractible = true
	playerdata.IsDashActive = true
	
	--set opened damage buff
	playerdata.SoulBuff = true
	player:AddCacheFlags(CacheFlag.CACHE_DAMAGE);
	player:EvaluateItems()
	--happy costume code
	yandereWaifu.ApplyCostumes( yandereWaifu.GetEntityData(player).currentMode, player , false, false)
	player:AddCostume(Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_NUMBER_ONE))
end

--soul heart movement
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local player = yandereWaifu.GetEntityData(eff).Parent
	local controller = player.ControllerIndex;
	local sprite = eff:GetSprite();
	local room =  Game():GetRoom();
	local data = yandereWaifu.GetEntityData(player)
    local roomClampSize = math.max( player.Size, 20 );
	--movement code
	eff.GridCollisionClass =  EntityGridCollisionClass.GRIDCOLL_NOPITS;

	--local movementDirection = player:GetMovementInput();
	--if movementDirection:Length() < 0.05 then
	
	player.Velocity = player.Velocity * 1.1
	eff.Velocity = player.Velocity;
	eff.Position = player.Position --room:GetClampedPosition(eff.Position, roomClampSize);
	
		--eff.Velocity = player.Velocity;
	--else
	--	eff.Velocity = (eff.Velocity * 0.9) + movementDirection:Resized( REBEKAH_BALANCE.SOUL_HEARTS_DASH_TARGET_SPEED );
	--end
	
	--trail
	local trail = InutilLib.SpawnTrail(eff, Color(0,0.5,1,0.5))
	--function code
	--player.Velocity = (room:GetClampedPosition(eff.Position, roomClampSize) - player.Position)--*0.5;
	if eff.FrameCount == 1 then
		player.Visible = true
	
	
		sprite:Play("Idle", true);
		data.LastEntityCollisionClass = player.EntityCollisionClass;
		data.LastGridCollisionClass = player.GridCollisionClass;
	elseif sprite:IsFinished("Idle") then
		sprite:Play("Blink",true);
	end
	
    if eff.FrameCount == 40 then
        if REBEKAH_BALANCE.SOUL_HEARTS_DASH_RETAINS_VELOCITY == false then
            player.Velocity = Vector( 0, 0 );
        else
            player.Velocity = eff.Velocity;
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
		local customBody = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_EXTRACHARANIMHELPER, 0, player.Position, Vector(0,0), player) --body effect
		yandereWaifu.GetEntityData(customBody).Player = player
		yandereWaifu.GetEntityData(customBody).WizoobOut = true
		player.ControlsEnabled = false
    	eff:Remove();
		
		yandereWaifu.GetEntityData(player).LeaksJuices = math.random(30,40)
    	
    	data.IsUninteractible = false;
    	InutilLib.SFX:Play( SoundEffect.SOUND_WEIRD_WORM_SPIT, 1, 0, false, 1 );
    else
		player:SetColor(Color(0,0,0,0.2,0,0,0),3,1,false,false)
    	player.GridCollisionClass =  EntityGridCollisionClass.GRIDCOLL_WALLS;
		player.EntityCollisionClass =  EntityCollisionClass.ENTCOLL_PLAYEROBJECTS;
    end
	--if eff.FrameCount < 35 then
	--	player.Velocity = Vector( 0, 0 );
	--end
end, RebekahCurse.ENTITY_SOULTARGET)

	--ectoplasm
	yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, function(_, eff)
		local sprite = eff:GetSprite()
		local data = yandereWaifu.GetEntityData(eff)
		
		if eff:GetData().IsEctoplasm and eff.FrameCount == 0 then 
			sprite:ReplaceSpritesheet(0, "gfx/effects/ectoplasm.png")
			sprite:LoadGraphics()
		end
	end, 46)

	--[[ecto tears
	yandereWaifu:AddCallback(ModCallbacks.MC_POST_TEAR_RENDER, function(_, tr)
		local data = yandereWaifu.GetEntityData(tr)
		local player = Isaac.GetPlayer(0)
		local sprite = tr:GetSprite()
		if tr:GetData().IsEctoplasm then
			sprite:ReplaceSpritesheet(0, "gfx/tears_ecto.png")
			sprite:LoadGraphics()
		end
	end)

	yandereWaifu:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, function(_, tr)
		local data = yandereWaifu.GetEntityData(tr)
		local player = Isaac.GetPlayer(0)
		local sprite = tr:GetSprite()
		if tr:GetData().IsEctoplasm then
			if tr.Height >= -7 or tr:CollidesWithGrid() then
				SpawnEctoplasm( tr.Position, Vector ( 0, 0 ) );
				tr:Remove();
			end
		end
	end)]]


	--haunted knife
	function yandereWaifu:HauntedKnifeRender(tr, _)
		if tr.Variant == RebekahCurse.ENTITY_HAUNTEDKNIFE then
			tr:GetSprite():Play("RegularTear", false);
			--tr:GetSprite():LoadGraphics();
		end
	end
	yandereWaifu:AddCallback(ModCallbacks.MC_POST_TEAR_RENDER, yandereWaifu.HauntedKnifeRender)

	function yandereWaifu:HauntedKnifeUpdate(tr)
		local data = yandereWaifu.GetEntityData(tr)
		if tr.Variant == RebekahCurse.ENTITY_HAUNTEDKNIFE then
			local angleNum = (tr.Velocity):GetAngleDegrees();
			tr:GetSprite().Rotation = angleNum + 90;
			tr:GetData().Rotation = tr:GetSprite().Rotation;
			--make it float for a while
			if tr.FrameCount == 1 then
				InutilLib.SpawnTrail(tr, Color(0,0,0,0.7,170,170,210), tr.Position - Vector(0,20))
				data.firstHeight = tr.Height
			elseif tr.FrameCount < 300 then
				tr.Height = data.firstHeight
			end
			--dash ability
			local target = InutilLib.GetClosestGenericEnemy(tr, 10000)
			if math.random(1,5) == 1 and tr.FrameCount % 3 == 0 then
				if target then
					InutilLib.MoveDirectlyTowardsTarget(tr, target, 20, 0.9)
				else
					InutilLib.MoveDirectlyTowardsTarget(tr, tr.SpawnerEntity:ToPlayer(), 20, 0.9)
					--InutilLib.MoveRandomlyTypeI(tr, tr.SpawnerEntity:ToPlayer().Position, 10, 0.9, 30, 30, 60)
				end
			else
				tr.Velocity = tr.Velocity * 0.95
			end
			--damage apparently
			if tr.FrameCount % 5 == 0 then
				for i, e in pairs(Isaac.GetRoomEntities()) do
					if e:IsActiveEnemy() and e:IsVulnerableEnemy() then
						if (tr.Position - e.Position):Length() < tr.Size + e.Size + 3 then
							e:TakeDamage(tr.CollisionDamage/1.5, 0, EntityRef(tr), 4)
						end
					end
				end
			end
			--on death
			if tr.Height >= -7 or tr:CollidesWithGrid() then
				yandereWaifu.SpawnPoofParticle( tr.Position, Vector(0,0), tr, RebekahPoofParticleType.Soul )
				tr:Remove()
			end
		end
	end
	yandereWaifu:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, yandereWaifu.HauntedKnifeUpdate)

	function yandereWaifu:EctoplasmaRender(tr, _)
		if tr.Variant == RebekahCurse.ENTITY_ECTOPLASMA then
			tr:GetSprite():Play("RegularTear", false);
		end
	end
	yandereWaifu:AddCallback(ModCallbacks.MC_POST_TEAR_RENDER, yandereWaifu.EctoplasmaRender)
	
	function yandereWaifu:EctoplasmaUpdate(tr)
		if tr.Variant == RebekahCurse.ENTITY_ECTOPLASMA then
			local data = yandereWaifu.GetEntityData(tr)
			local player = yandereWaifu.GetEntityData(tr).Parent
			tr.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE 
			if tr.FrameCount == 1 then
				data.firstHeight = tr.Height
			elseif tr.FrameCount < 60 then
				tr.Height = data.firstHeight
			end
			for i, enemy in pairs (Isaac.GetRoomEntities()) do
				if enemy:IsVulnerableEnemy() then
					if enemy.Position:Distance(tr.Position) < enemy.Size + (tr.Size * 5) then
						enemy:TakeDamage(Isaac.GetPlayer(0).Damage * 2, 0, EntityRef(tr), 1);
					end
				end
			end
			--if math.random(1,3) == 3 and tr.FrameCount % 2 == 0 then
			--	local laser = EntityLaser.ShootAngle(2, tr.Position, math.random(1,360), 2, Vector(0,-20), Isaac.GetPlayer(0))
			--	laser:SetColor(Color(0,0,0,0.7,170,170,210),9999999,99,false,false);
			--	laser:SetHomingType(1)
			--end
			local rand = math.random(1,2)
			if tr.FrameCount % 8 == 0 then
				for i = 1, rand do
					local circle = player:FireTechXLaser(tr.Position, Vector.FromAngle(math.random(1,360))*(20), math.random(10,20))
					circle:SetColor(Color(0,0,0,0.7,170,170,210),9999999,99,false,false);
				end
			end
		end
	end
	yandereWaifu:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, yandereWaifu.EctoplasmaUpdate)
	
function yandereWaifu:SoulPersonalityTearUpdate(tr)
	local data = yandereWaifu.GetEntityData(tr)
	if tr.Variant == 50 and data.IsSoulFetus then --just using 50 since the docs doesnt seem to have enums for fetus tears
		if tr.FrameCount == 1 and data.IsSoulFetus then
			tr:GetSprite():ReplaceSpritesheet(0, "gfx/fetus_tears_blue.png")
			tr:GetSprite():LoadGraphics();
		end
		if tr.FrameCount <= 300 and data.IsSoulFetus then
			tr.Height = -12
			local e = InutilLib.GetClosestGenericEnemy(tr, 500)
			if e then
				InutilLib.MoveDirectlyTowardsTarget(tr, e, 2+math.random(1,5)/10, 0.85)
			end
			tr.Velocity = tr.Velocity * 0.95
		end
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, yandereWaifu.SoulPersonalityTearUpdate)

function yandereWaifu:SoulPersonalityTearCollision(tr, cool)
	local data = yandereWaifu.GetEntityData(tr)
	if tr.Variant == 50 and data.IsSoulFetus then --just using 50 since the docs doesnt seem to have enums for fetus tears
		if tr.FrameCount <= 300 and tr.FrameCount % 30 == 0 and data.IsSoulFetus then
			cool:TakeDamage(tr.CollisionDamage, 0, EntityRef(tr), 4)
		end
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, yandereWaifu.SoulPersonalityTearCollision)

	
	yandereWaifu:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, function(_, tr)
		if tr.Variant == RebekahCurse.ENTITY_ECTOPLASMA then
			local player = yandereWaifu.GetEntityData(tr).Parent
			local part = Isaac.Spawn(EntityType.ENTITY_EFFECT, ENTITY_LIGHTBOOM, 0, tr.Position, Vector(0,0), tr);
			part:GetSprite():ReplaceSpritesheet(0, "gfx/effects/plasmaboom.png");
			part:GetData().NotEternal = true;
			local rand = math.random(3,6)
			for i = 1, rand do
				local circle = player:FireTechXLaser(tr.Position, Vector.FromAngle(math.random(1,360))*(20), math.random(10,20))
				circle:SetColor(Color(0,0,0,0.7,170,170,210),9999999,99,false,false);
			end
			--SpawnEctoplasm( tr.Position, Vector ( 0, 0 ) , math.random(12,35)/10, player);
		end
	end, EntityType.ENTITY_TEAR)

	--wizoob dropping missile guy
	yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
		local player = Isaac.GetPlayer(0)
		local controller = player.ControllerIndex
		local sprite = eff:GetSprite()
		local data = yandereWaifu.GetEntityData(eff)
		eff.GridCollisionClass =  EntityGridCollisionClass.GRIDCOLL_NOPITS 
		
		local room =  Game():GetRoom()
		
		for i, orb in pairs (Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.TARGET, -1, false, false)) do
			if not data.HasParent then
				data.HasParent = orb
			else
				if not data.HasParent:IsDead() then
					eff.Velocity = data.HasParent.Velocity
					eff.Position = data.HasParent.Position
				else
					eff.Velocity = eff.Velocity * 0.9
				end
			end
		end
		--function code
		if eff.FrameCount == 1 then
			sprite:Play("AppearDown", true)
			eff.SpriteOffset = Vector(0,-50)
		elseif sprite:IsFinished("AppearDown") then
			sprite:Play("ShootDown", true)
		elseif sprite:IsPlaying("ShootDown") then
			if sprite:IsEventTriggered("Shoot") then
				local ghostvomit = Isaac.Spawn(EntityType.ENTITY_BOMBDROP, 0, 0, eff.Position, Vector(0,0), eff):ToBomb() --this is a workaround to make explosions larger
				ghostvomit:SetExplosionCountdown(1)
				ghostvomit.Visible = false
				ghostvomit.RadiusMultiplier = 1.2 --my favorite part
				ghostvomit.ExplosionDamage = player.Damage*17.7013
				if player:HasWeaponType(WeaponType.WEAPON_LASER) then
					for i = 0, 360, 360/8 do
						local techlaser = player:FireTechLaser(eff.Position, 0, Vector.FromAngle(i), false, true)
						techlaser.CollisionDamage = player.Damage * 5
					end
				elseif player:HasWeaponType(WeaponType.WEAPON_BRIMSTONE) then
					for i = 0, 360, 360/8 do
						local brim = player:FireBrimstone(eff.Position, 0, Vector.FromAngle(i), false, true)
						brim.CollisionDamage = player.Damage * 2
						--brim:GetData().IsEctoplasm = true
					end
				else
					local chosenNumofBarrage =  math.random( 4, 8 );
					for i = 1, chosenNumofBarrage do
						local tear = player:FireTear( eff.Position,  Vector.FromAngle( math.random() * 360 ):Resized(7), false, false, false):ToTear()
						tear.Position = eff.Position
						tear.Scale = math.random() * 0.7 + 0.7;
						tear.FallingSpeed = -9 + math.random() * 2 ;
						tear.FallingAcceleration = 0.95;
						tear.CollisionDamage = player.Damage * 3.3;
						tear.TearFlags = tear.TearFlags | TearFlags.TEAR_EXPLOSIVE;
					end
				end
			end
		elseif sprite:IsFinished("ShootDown") then
			sprite:Play("VanishDown", true)
		elseif sprite:IsFinished("VanishDown") then
			eff:Remove()
		end
	end, RebekahCurse.ENTITY_WIZOOB_MISSILE)
	
	
--ghost missile
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
		local player = yandereWaifu.GetEntityData(eff).Parent
		local sprite = eff:GetSprite()
		local data = yandereWaifu.GetEntityData(eff)
		
		local movementDirection = player:GetShootingInput();
		local roomClampSize = math.max( player.Size, 20 )
		if movementDirection:Length() < 0.05 then
			eff.Velocity = Vector.Zero
		else
			eff.Position = ILIB.room:GetClampedPosition(eff.Position, roomClampSize);
			eff.Velocity = (eff.Velocity * 0.9) + movementDirection:Resized( REBEKAH_BALANCE.SOUL_HEARTS_DASH_TARGET_SPEED );
		end
		
		local room =  Game():GetRoom()
		--function code
		if eff.FrameCount == 1 then
			sprite:Play("Idle", true)
			yandereWaifu.RebekahCanShoot(player, false)
		elseif sprite:IsFinished("Idle") then
			sprite:Play("Blink",true)
		elseif eff.FrameCount == 55 then
			local missile = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_GHOSTMISSILE, 0, eff.Position, Vector.Zero, player) --heart effect
			yandereWaifu.GetEntityData(missile).ExtraTears = data.ExtraTears
			eff:Remove()
			yandereWaifu.RebekahCanShoot(player, true)
			player.FireDelay = 30
		end
		if eff.FrameCount < 35 then
			--player.Velocity = Vector(0,0)
		end
end, RebekahCurse.ENTITY_GHOSTTARGET)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, function(_,  eff) --eternal star
	local player = yandereWaifu.GetEntityData(eff).Parent
	local sprite = eff:GetSprite()
	local data = yandereWaifu.GetEntityData(eff)
	if not data.Init then      
		eff.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NOPITS 
		data.spr = Sprite()                                                 
		data.spr:Load("gfx/effects/soul/orbital_target.anm2", true) 
		data.spr:Play("Line", true)
		data.Init = true                                              
	end      
		
	InutilLib.DeadDrawRotatedTilingSprite(data.spr, Isaac.WorldToScreen(player.Position), Isaac.WorldToScreen(eff.Position), 16, nil, 8, true)
end, RebekahCurse.ENTITY_GHOSTTARGET);

yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	for p = 0, ILIB.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		local controller = player.ControllerIndex
		local sprite = eff:GetSprite()
		local data = yandereWaifu.GetEntityData(eff)
		eff.GridCollisionClass =  EntityGridCollisionClass.GRIDCOLL_NOPITS 
		
		local room =  Game():GetRoom()
		--function code
		if eff.FrameCount == 1 then
			sprite:Play("Falling", true)
		elseif sprite:IsEventTriggered("Blow") then
			local megumin = Isaac.Spawn(EntityType.ENTITY_BOMBDROP, 0, 0, eff.Position, Vector(0,0), eff):ToBomb() --this is a workaround to make explosions larger
			megumin:SetExplosionCountdown(1)
			megumin.Visible = false
			megumin.RadiusMultiplier = 1.6 --my favorite part
			megumin.ExplosionDamage = player.Damage*5
			ILIB.room:MamaMegaExplosion(megumin.Position)
			for i, ent in pairs(Isaac.GetRoomEntities()) do
				if ent:IsEnemy() and not ent:IsVulnerableEnemy() then
					ent:AddPoison(EntityRef(eff), 5, player.Damage*17)
				end
			end
			if player:HasWeaponType(WeaponType.WEAPON_LASER) then
				for i = 0, 360, 360/8 do
					local techlaser = player:FireTechLaser(eff.Position, 0, Vector.FromAngle(i), false, true)
					techlaser.CollisionDamage = player.Damage * 5
					--techlaser.Damage = player.Damage * 5 doesn't exist lol
				end
			elseif player:HasWeaponType(WeaponType.WEAPON_BRIMSTONE) then
				for i = 0, 360, 360/8 do
					local brim = player:FireBrimstone(eff.Position, 0, Vector.FromAngle(i), false, true)
					brim.CollisionDamage = player.Damage * 5
				end
			end
			for i = 1, 2 do
				local minions = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PURGATORY, 1, eff.Position, Vector(0,0), player)
				minions:GetSprite():ReplaceSpritesheet(0, "gfx/effects/soul/purgatory_soul.png")
				minions:GetSprite():ReplaceSpritesheet(1, "gfx/effects/soul/purgatory_soul.png")
				minions:GetSprite():LoadGraphics()
			end
			local crack = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_SOULNUKECRACK, 0, eff.Position, Vector(0,0), player)
			yandereWaifu.GetEntityData(crack).ExtraTears = data.ExtraTears
		elseif sprite:IsFinished("Falling") then
			eff:Remove()
		end
		if eff.FrameCount < 35 then
			player.Velocity = Vector(0,0)
		end
	end
end, RebekahCurse.ENTITY_GHOSTMISSILE)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	for p = 0, ILIB.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		local controller = player.ControllerIndex
		local sprite = eff:GetSprite()
		local data = yandereWaifu.GetEntityData(eff)
		eff.GridCollisionClass =  EntityGridCollisionClass.GRIDCOLL_NOPITS 
		
		local room =  Game():GetRoom()
		--function code
		if eff.FrameCount == 1 then
			sprite:Play("HoleOpen_old", true)
		elseif sprite:IsFinished("HoleOpen_old") then
			sprite:Play("HoleIdle", true)
		elseif sprite:IsPlaying("HoleIdle") then
			if sprite:GetFrame() == 5 and math.random(1,3) == 3 then
				for i = 1, math.random(1,2) + data.ExtraTears do
					local minions = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PURGATORY, 1, eff.Position, Vector(0,0), player)
					minions:GetSprite():ReplaceSpritesheet(0, "gfx/effects/soul/purgatory_soul.png")
					minions:GetSprite():ReplaceSpritesheet(1, "gfx/effects/soul/purgatory_soul.png")
					minions:GetSprite():LoadGraphics()
				end
			end
		elseif sprite:IsFinished("HoleClose") then
			eff:Remove()
		end
		if eff.FrameCount > 105 then
			sprite:Play("HoleClose", false)
		end
		eff.RenderZOffset = -100
	end
end, RebekahCurse.ENTITY_SOULNUKECRACK)

	
	function yandereWaifu:EctoplasmLaser(lz)
		 if lz:GetData().IsEctoplasm then
			if lz.FrameCount == 1 then
				lz:SetColor(Color(0,0,0,0.7,170,170,210),9999999,99,false,false);
				lz:GetSprite():Load("gfx/effect_ectoplasmlaser.anm2", true)
				lz:GetSprite():Play("LargeRedLaser", true)
				if lz.Child ~= nil then
					lz.Child:GetSprite():Load("gfx/effect_ectoplasmlaserend.anm2", true)
					lz.Child:GetSprite():LoadGraphics()
					lz.Child.Color = lz.Parent:GetSprite().Color
				end
			end
		 end
		 if yandereWaifu.GetEntityData(lz).IsEctoplasm then
			local player = lz.SpawnerEntity:ToPlayer()
			local rand = math.random(1,2)
			if lz.FrameCount % 5 == 0 then
				for i = 1, rand do
					local circle = player:FireTechXLaser(lz.Position, Vector.FromAngle(math.random(1,360))*(20), math.random(20,40))
					yandereWaifu.GetEntityData(circle).IsEctoplasmLaserX = true
					circle.Visible = false
					--circle:SetColor(Color(0,0,0,0.7,170,170,210),9999999,99,false,false);
				end
			end
		end
		if yandereWaifu.GetEntityData(lz).IsEctoplasmLaser then
			lz.Visible = true
			lz:GetSprite():ReplaceSpritesheet(0, "gfx/effects/soul/techlaser.png");
			lz:GetSprite():LoadGraphics();
			if lz.Child ~= nil then
				lz.Child.Visible = true
				lz.Child:GetSprite():ReplaceSpritesheet(0, "gfx/effects/soul/tech_dot.png");
				lz.Child:GetSprite():LoadGraphics();
			end
		 end
		  if yandereWaifu.GetEntityData(lz).IsEctoplasmLaserX then
			lz.Visible = true
			lz:GetSprite():ReplaceSpritesheet(0, "gfx/effects/soul/techlaser.png");
			lz:GetSprite():LoadGraphics();
			if lz.Child ~= nil then
				lz.Child.Visible = true
				lz.Child:GetSprite():ReplaceSpritesheet(0, "gfx/effects/soul/techimpact.png");
				lz.Child:GetSprite():LoadGraphics();
			end
		 end
		if yandereWaifu.GetEntityData(lz).IsMonstrosLung and yandereWaifu.GetEntityData(lz).LaserCount > 0 then
			local player = lz.SpawnerEntity:ToPlayer()
			local techlaser = player:FireTechLaser(lz:GetEndPoint(), 0, Vector.FromAngle(lz.Angle + math.random(-30,30)), false, true)
			yandereWaifu.GetEntityData(techlaser).LaserCount = yandereWaifu.GetEntityData(lz).LaserCount - 1
			yandereWaifu.GetEntityData(techlaser).IsMonstrosLung = true
			yandereWaifu.GetEntityData(techlaser).IsEctoplasmLaser = true
			techlaser.Visible = false
			techlaser.OneHit = true;
			techlaser.Timeout = 1;
			techlaser:SetMaxDistance(60)
			techlaser.CollisionDamage = player.Damage;
		end
	end
	yandereWaifu:AddCallback(ModCallbacks.MC_POST_LASER_UPDATE, yandereWaifu.EctoplasmLaser)


	--bomb bundle tear
	function yandereWaifu:SBombRender(tr, _)
		if tr.Variant == RebekahCurse.ENTITY_SBOMBBUNDLE then
			tr:GetSprite():Play("RegularTear", false);
			--tr:GetSprite():LoadGraphics();
		end
	end
	yandereWaifu:AddCallback(ModCallbacks.MC_POST_TEAR_RENDER, yandereWaifu.SBombRender)

	--after bomb bundle coll functionality 
	yandereWaifu:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, function(_, tr)
		if tr.Variant == RebekahCurse.ENTITY_SBOMBBUNDLE then
			local player = yandereWaifu.GetEntityData(tr).Parent
			--print(tr.CollisionDamage)
			Isaac.Explode(tr.Position, tr, tr.CollisionDamage * 17.7)
			InutilLib.SFX:Play(RebekahCurseSounds.SOUND_SOULFETUS1, 1, 0, false, 1.2)
			for i = 1, math.random(7,10) + 3 * yandereWaifu.GetEntityData(tr).ExtraTears do
                InutilLib.SetTimer( i*8, function()
					local bomb = player:FireBomb( tr.Position + Vector(math.random(1,10),math.random(1,10)),  Vector(0,5):Rotated(math.random(1,360)):Resized(4))
                    --local bomb = Isaac.Spawn(EntityType.ENTITY_BOMBDROP, 0, 0, tr.Position + Vector(math.random(1,10),math.random(1,10)),  Vector(0,5):Rotated(math.random(1,360)):Resized(15), tr):ToBomb();
					local rng = math.random(1,3)
					if rng == 1 then
						yandereWaifu.GetEntityData(bomb).IsSmall = true
					elseif rng == 2 then
						yandereWaifu.GetEntityData(bomb).IsLarge = true
					end
					yandereWaifu.GetEntityData(bomb).IsGhostBombs = true
					bomb.ExplosionDamage = player.Damage*2.7
					InutilLib.MakeBombLob(bomb, 1, 15 )
                end);
			end
			yandereWaifu.SpawnEctoplasm( tr.Position, Vector ( 0, 0 ) , math.random(35,40)/10, player);
		end
	end, EntityType.ENTITY_TEAR)

	--"ectoplasm leaking after just teleporting" mechanic
	function yandereWaifu:EctoplasmLeaking(player) 
		local data = yandereWaifu.GetEntityData(player)
		if yandereWaifu.GetEntityData(player).currentMode == REBECCA_MODE.SoulHearts then	
			if data.LeaksJuices and data.LeaksJuices > 0 then
				data.LeaksJuices = data.LeaksJuices - 1
				if math.random(1,5) == 3 then
					yandereWaifu.SpawnEctoplasm( player.Position, Vector ( 0, 0 ) , 1, player);
				end
			end
			if data.LeakingSoulBuff then
				if data.LeakingSoulBuff <= 0 then
					yandereWaifu.GetEntityData(player).SoulBuff = false
					player:AddCacheFlags(CacheFlag.CACHE_DAMAGE);
					player:EvaluateItems()
					--become depressed again
					yandereWaifu.ApplyCostumes( yandereWaifu.GetEntityData(player).currentMode, data.Player , false, false)
					player:RemoveCostume(Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_NUMBER_ONE))
					player:AddNullCostume(RebekahCurseCostumes.WizoobHairGoingDown)
					InutilLib.SetTimer( 10*3, function()
						player:TryRemoveNullCostume(RebekahCurseCostumes.WizoobHairGoingDown)
					end)
					data.LeakingSoulBuff = nil
				else
					if not yandereWaifu.GetEntityData(player).IsAttackActive then
						data.LeakingSoulBuff = data.LeakingSoulBuff - 1
					end
					if not yandereWaifu.GetEntityData(player).SoulBuff then data.LeakingSoulBuff = nil end
				end
			end
		end
	end
	yandereWaifu:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, yandereWaifu.EctoplasmLeaking)
	
	--soul buff 
	yandereWaifu:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, function(_,tear)
		local parent, spr, data = tear.Parent, tear:GetSprite(), yandereWaifu.GetEntityData(tear)
		local player = parent:ToPlayer()
		
		if yandereWaifu.IsNormalRebekah(player) and yandereWaifu.GetEntityData(player).currentMode == REBECCA_MODE.SoulHearts then
			if yandereWaifu.GetEntityData(player).SoulBuff then --give lenience to the barrage
				yandereWaifu.GetEntityData(player).SoulBuff = false
				player:AddCacheFlags(CacheFlag.CACHE_DAMAGE);
				player:EvaluateItems()
				--become depressed again
				yandereWaifu.ApplyCostumes( yandereWaifu.GetEntityData(player).currentMode, player , false)
				player:RemoveCostume(Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_NUMBER_ONE))
			end
		end
	end)
	
	InutilLib.AddCustomCallback(yandereWaifu, ILIBCallbacks.MC_POST_FIRE_LASER, function(_, lz)
		if lz.SpawnerEntity then
			local player = lz.SpawnerEntity:ToPlayer()
			if player then
				if yandereWaifu.IsNormalRebekah(player) and yandereWaifu.GetEntityData(player).currentMode == REBECCA_MODE.SoulHearts then
					if yandereWaifu.GetEntityData(player).SoulBuff then --give lenience to the barrage
						yandereWaifu.GetEntityData(player).SoulBuff = false
						player:AddCacheFlags(CacheFlag.CACHE_DAMAGE);
						player:EvaluateItems()
						--become depressed again
						yandereWaifu.ApplyCostumes( yandereWaifu.GetEntityData(player).currentMode, player , false)
						player:RemoveCostume(Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_NUMBER_ONE))
					end
				end
			end
		end
	end)

	InutilLib.AddCustomCallback(yandereWaifu, ILIBCallbacks.MC_POST_FIRE_BOMB, function(_, bb)
		local player = bb.SpawnerEntity:ToPlayer()
		local pldata = yandereWaifu.GetEntityData(player)
		if player then
			if yandereWaifu.IsNormalRebekah(player) and yandereWaifu.GetEntityData(player).currentMode == REBECCA_MODE.SoulHearts then
				if yandereWaifu.GetEntityData(player).SoulBuff then --give lenience to the barrage
					yandereWaifu.GetEntityData(player).SoulBuff = false
					player:AddCacheFlags(CacheFlag.CACHE_DAMAGE);
					player:EvaluateItems()
					--become depressed again
					yandereWaifu.ApplyCostumes( yandereWaifu.GetEntityData(player).currentMode, player , false)
					player:RemoveCostume(Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_NUMBER_ONE))
				end
			end
		end
	end)

	yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, function(_,  eff)
		--local parent = eff.Parent
		local player = eff.SpawnerEntity:ToPlayer()
		--print(player)
		if player and player.Type == EntityType.ENTITY_PLAYER then
			if player then
				if yandereWaifu.IsNormalRebekah(player) and yandereWaifu.GetEntityData(player).currentMode == REBECCA_MODE.SoulHearts then
					if yandereWaifu.GetEntityData(player).SoulBuff then --give lenience to the barrage
						yandereWaifu.GetEntityData(player).SoulBuff = false
						player:AddCacheFlags(CacheFlag.CACHE_DAMAGE);
						player:EvaluateItems()
						--become depressed again
						yandereWaifu.ApplyCostumes( yandereWaifu.GetEntityData(player).currentMode, player , false)
						player:RemoveCostume(Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_NUMBER_ONE))
					end
				end
			end
		end
	end, EffectVariant.TARGET);

	InutilLib:AddCallback(ModCallbacks.MC_POST_KNIFE_UPDATE, function(_, kn)

		local player = kn.SpawnerEntity:ToPlayer()
		local pldata = yandereWaifu.GetEntityData(player)
		if player then
			if yandereWaifu.IsNormalRebekah(player) and yandereWaifu.GetEntityData(player).currentMode == REBECCA_MODE.SoulHearts then
				if yandereWaifu.GetEntityData(player).SoulBuff then --give lenience to the barrage
					yandereWaifu.GetEntityData(player).SoulBuff = false
					player:AddCacheFlags(CacheFlag.CACHE_DAMAGE);
					player:EvaluateItems()
					--become depressed again
					yandereWaifu.ApplyCostumes( yandereWaifu.GetEntityData(player).currentMode, player , false)
					player:RemoveCostume(Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_NUMBER_ONE))
				end
			end
		end
	end)
	
--sword drop
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
		local player = yandereWaifu.GetEntityData(eff).Parent
		local sprite = eff:GetSprite()
		local data = yandereWaifu.GetEntityData(eff)
		
		local room =  Game():GetRoom()
		--function code
		if eff.FrameCount == 1 then
			sprite:Play("Drop", true)
		elseif sprite:IsFinished("Drop") then
			eff:Remove()
		end
		if player then
			local damage = player.Damage*3 or 3.5
			if sprite:IsEventTriggered("Hurt") then
				InutilLib.SFX:Play(SoundEffect.SOUND_SWORD_SPIN, 0.5, 0, false, 1)
				InutilLib.SFX:Play(SoundEffect.SOUND_GOLD_HEART_DROP, 0.5, 0, false, 1)
				ILIB.game:ShakeScreen(5)
				for i, e in pairs(Isaac.GetRoomEntities()) do
					if e:IsActiveEnemy() and e:IsVulnerableEnemy() then
						if (eff.Position - e.Position):Length() < 80 then
							e:TakeDamage(damage, 0, EntityRef(eff), 4)
						end
					end
				end
			end
		end
end, RebekahCurse.ENTITY_SWORDDROP)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE, function(_, bb)
	if yandereWaifu.GetEntityData(bb).IsGhostBombs then
		local sprite = bb:GetSprite();
		if bb.Variant == BombVariant.BOMB_ROCKET then
			if bb.FrameCount == 1 then
				if yandereWaifu.GetEntityData(bb).IsSmall then
					bb:GetSprite():Load("gfx/items/pick ups/bombs/rocket0_reb.anm2", true)
					--bb.SpriteScale =  Vector(0.5,0.5)
					bb.SizeMulti = Vector(0.5,0.5)
				elseif  yandereWaifu.GetEntityData(bb).IsLarge then
					bb:GetSprite():Load("gfx/items/pick ups/bombs/rocket3_reb.anm2", true)
					--bb.SpriteScale =  Vector(1.5,1.5)
					bb.SizeMulti = Vector(1.5,1.5)
				else
					bb:GetSprite():Load("gfx/items/pick ups/bombs/rocket2_reb.anm2", true)
				end
				bb:GetSprite():Play("Pulse")
				bb:GetSprite():ReplaceSpritesheet(0, "gfx/items/pick ups/bombs/soul_barrage_rocket.png");
				bb:GetSprite():LoadGraphics();
			end
		else
			if bb.FrameCount == 1 then
				if yandereWaifu.GetEntityData(bb).IsSmall then
					bb:GetSprite():Load("gfx/items/pick ups/bombs/bomb0_reb.anm2", true)
					--bb.SpriteScale =  Vector(0.5,0.5)
					bb.SizeMulti = Vector(0.5,0.5)
				elseif  yandereWaifu.GetEntityData(bb).IsLarge then
					bb:GetSprite():Load("gfx/items/pick ups/bombs/bomb3_reb.anm2", true)
					--bb.SpriteScale =  Vector(1.5,1.5)
					bb.SizeMulti = Vector(1.5,1.5)
				else
					bb:GetSprite():Load("gfx/items/pick ups/bombs/bomb2_reb.anm2", true)
				end
				bb:GetSprite():Play("Pulse")
				bb:GetSprite():ReplaceSpritesheet(0, "gfx/items/pick ups/bombs/soul_barrage_bomb.png");
				bb:GetSprite():LoadGraphics();
			end
		end
	end
end)
end

