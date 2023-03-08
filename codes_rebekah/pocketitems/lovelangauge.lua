--affirmation
function yandereWaifu:UseWordsofAffirmation(card, player, flags) 
	player:ToPlayer()
	local playerdata = yandereWaifu.GetEntityData(player)
	local rng = math.random(1,10)
	
	local heart = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_AFFIRMATIONHEART, 0, player.Position, InutilLib.DirToVec(player:GetMovementDirection()):Resized(8), player):ToFamiliar();
	InutilLib.SFX:Play( RebekahCurseSounds.SOUND_SPRING_SOUND, 1, 0, false, 1 );
end

yandereWaifu:AddCallback(ModCallbacks.MC_USE_CARD, yandereWaifu.UseWordsofAffirmation, RebekahCurseCards.CARD_WORDSOFAFFIRMATION);

yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local player = yandereWaifu.GetEntityData(eff).parent
	local sprite = eff:GetSprite();
	local playerdata = yandereWaifu.GetEntityData(player)
	local data = yandereWaifu.GetEntityData(eff)
	local ents = Isaac.FindInRadius(eff.Position, 450, EntityPartition.ENEMY)

	if sprite:IsFinished("Spawn") then
		sprite:Play("Idle", true)
	end

    for _, ent in pairs(ents) do
		if eff.Position:Distance(ent.Position) < 70 + ent.Size then
			if eff.FrameCount % 5 == 0 then
				ent:TakeDamage(9999999999999, 0, EntityRef(player), 1)
			end
		end
    end

	if eff.FrameCount > 120 then eff:Remove() end
end, RebekahCurse.ENTITY_AFFIRMATIONHEART);

--gift giving
function yandereWaifu:UseGiftGiving(card, player, flags) 
	player:ToPlayer()
	local playerdata = yandereWaifu.GetEntityData(player)
	local rng = math.random(1,10)
	
	for i = 0, 1 do
        player:UseActiveItem(CollectibleType.COLLECTIBLE_MYSTERY_GIFT, 0, -1)
    end
end

yandereWaifu:AddCallback(ModCallbacks.MC_USE_CARD, yandereWaifu.UseGiftGiving, RebekahCurseCards.CARD_GIFTGIVING);

--service
function yandereWaifu:UseActOfGiving(card, player, flags) 
	player:ToPlayer()
	local playerdata = yandereWaifu.GetEntityData(player)
	local christian = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, RebekahCurse.ENTITY_CHRISTIANNED, 25, player.Position, Vector(0,0), player):ToFamiliar();
	christian:AddToFollowers()
end

yandereWaifu:AddCallback(ModCallbacks.MC_USE_CARD, yandereWaifu.UseActOfGiving, RebekahCurseCards.CARD_ACTOFSERVICE);

function yandereWaifu:RemoveServantNed()
	for c, ned in pairs( Isaac.GetRoomEntities() ) do
		if ned.Type == 3 and ned.Variant ==  RebekahCurse.ENTITY_CHRISTIANNED and ned.SubType == 25 then
			ned:Remove()
		end
	end
	for i=0, ILIB.game:GetNumPlayers()-1 do
		local player = Isaac.GetPlayer(i)
		if yandereWaifu.GetEntityData(player).PersistentPlayerData.ServantNedInventory then
			InutilLib.SetTimer( i * 5, function()
				for i, v in pairs(yandereWaifu.GetEntityData(player).PersistentPlayerData.ServantNedInventory) do
					Isaac.Spawn(v.Type, v.Variant, v.SubType, ILIB.game:GetRoom():FindFreePickupSpawnPosition(player.Position, 5), Vector.Zero, player);
					v = nil
				end
			end)
			yandereWaifu.GetEntityData(player).PersistentPlayerData.ServantNedInventory = nil
		end
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, yandereWaifu.RemoveServantNed)

function yandereWaifu:onFamiliarServantInit(fam)
    fam.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
	local data = yandereWaifu.GetEntityData(fam)
    local sprite = fam:GetSprite()
    sprite:Play("Spawn", true)
	data.IncreasedBuff = 0
	
	if fam.SubType == 25 then 
		--sprite:ReplaceSpritesheet(0, "gfx/effects/gold/knife/christian_ned.png") 
		--sprite:ReplaceSpritesheet(1, "gfx/effects/gold/knife/christian_ned.png") 
		sprite:Load("gfx/familiar/servant_ned.anm2", true)
	end
	sprite:LoadGraphics()
	sprite:Play("Spawn", true)
end
yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, yandereWaifu.onFamiliarServantInit, RebekahCurse.ENTITY_CHRISTIANNED);

yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_,  fam)
	local spr = fam:GetSprite()
	local rng = math.random(1, 100)
	local player = fam.Player
	local data = yandereWaifu.GetEntityData(fam)
	
	if fam.SubType ~= 25 then return end

	if spr:IsFinished("Spawn") then
		spr:Play("Idle", true)
	end
	local damageNerf = 0

	--reading Bible mechanic
	if ILIB.game:GetRoom():GetFrameCount() == 1 and ILIB.game:GetRoom():GetType() == RoomType.ROOM_BOSS then
		for i, e in pairs(Isaac.GetRoomEntities()) do
			if e.Type == EntityType.ENTITY_MOM or e.Type == EntityType.ENTITY_MOMS_HEART or e.Type == EntityType.ENTITY_IT_LIVES then
				spr:Play("DeusVult",true)
				InutilLib.SFX:Play( RebekahCurseSounds.SOUND_CHRISTIAN_READ, 1, 0, false, 1 );
			elseif e.Type == EntityType.ENTITY_SATAN then
				spr:Play("ForJerusalem",true)
				InutilLib.SFX:Play( RebekahCurseSounds.SOUND_CHRISTIAN_READ, 1, 0, false, 1 );
			end
		end
	end
	--flip sprite mechanic
	if spr:IsPlaying("Idle") then
		InutilLib.FlipXByVec(fam, false)
	end
	if spr:IsEventTriggered("Hit") then
		InutilLib.SFX:Play( RebekahCurseSounds.SOUND_STRIKE, 2, 0, false, 1 );
	end
	fam.Velocity = fam.Velocity - fam.Velocity*0.25
	if spr:IsPlaying("Idle") then
		local function GetClosestUnreachablePickup(obj, dist, variant, subtype)
			local path 
			local closestDist = 177013 --saved Dist to check who is the closest enemy
			local returnV
			for j, pickup in pairs (Isaac.FindByType(EntityType.ENTITY_PICKUP, -1, -1, false, false)) do
				local data = InutilLib.GetILIBData(pickup);
				local minDist = dist or 100
				if (obj.Position - pickup.Position):Length() < minDist then
					if (obj.Position - pickup.Position):Length() < closestDist and not (pickup:GetSprite():IsPlaying("Open") or pickup:GetSprite():IsPlaying("Opened") or pickup:GetSprite():IsPlaying("Collect")) then
						path = InutilLib.GenerateAStarPath(obj.Position, pickup.Position)
						if not path then
							closestDist = (obj.Position - pickup.Position):Length()
							returnV = pickup
						end
					end
				end
			end
			return returnV
		end

		--bomb tinted rocks
		local grids = InutilLib.GetRoomGrids()
		local tinted = InutilLib.GetClosestGrid(fam, 500, GridEntityType.GRID_ROCKT)
		local sstinted = InutilLib.GetClosestGrid(fam, 500, GridEntityType.GRID_ROCK_SS)
		--local alt = InutilLib.GetClosestGrid(fam, 500, GridEntityType.GRID_ROCK_ALT)
		--local alt2 = InutilLib.GetClosestGrid(fam, 500, GridEntityType.GRID_ROCK_ALT2)
		local gold = InutilLib.GetClosestGrid(fam, 500, GridEntityType.GRID_ROCK_GOLD)
		local secret = InutilLib.GetClosestGrid(fam, 500, GridEntityType.GRID_DOOR)
		local poop = InutilLib.GetClosestGrid(fam, 500, GridEntityType.GRID_POOP)
		--local cobweb = InutilLib.GetClosestGrid(fam, 500, GridEntityType.GRID_SPIDERWEB)

		local pickup = GetClosestUnreachablePickup(player, 500)

		if data.hasDroppedBomb then
			data.hasDroppedBomb = data.hasDroppedBomb -1
			if data.hasDroppedBomb <= 0 then
				data.hasDroppedBomb = nil
			end
		end
		if alt then
			tinted = alt --replace it LOL
		end
		if alt2 then
			tinted = alt2 --replace it LOL
		end
		if gold then
			tinted = gold --replace it LOL
		end
		if sstinted then
			tinted = sstinted --replace it LOL
		end
		if secret and secret:ToDoor() and not secret:ToDoor():IsOpen() and (secret:ToDoor():IsRoomType(RoomType.ROOM_SECRET) or secret:ToDoor():IsRoomType(RoomType.ROOM_SUPERSECRET)) then
			tinted = secret
		end
		if yandereWaifu.GetEntityData(player).PersistentPlayerData.ServantNedInventory and ILIB.room:IsClear() then
			if player.Position:Distance(fam.Position) < 30 then
				for i, v in pairs(yandereWaifu.GetEntityData(player).PersistentPlayerData.ServantNedInventory) do
					InutilLib.SetTimer( i * 5, function()
						Isaac.Spawn(v.Type, v.Variant, v.SubType, ILIB.game:GetRoom():FindFreePickupSpawnPosition(player.Position, 5), Vector.Zero, player);
						v = nil
					end)
				end
				yandereWaifu.GetEntityData(player).PersistentPlayerData.ServantNedInventory = nil
			else
				fam.Velocity = fam.Velocity * 0.8 + ((player.Position - fam.Position):Resized(3))
			end
		elseif pickup and ILIB.room:IsClear() then
			if pickup.Position:Distance(fam.Position) < 30 then
				if not yandereWaifu.GetEntityData(player).PersistentPlayerData.ServantNedInventory then yandereWaifu.GetEntityData(player).PersistentPlayerData.ServantNedInventory = {} end
				table.insert(yandereWaifu.GetEntityData(player).PersistentPlayerData.ServantNedInventory, {Type = pickup.Type, Variant = pickup.Variant, SubType = pickup.SubType})
				fam.Velocity = fam.Velocity * 0.8
				pickup:Remove()
			else
				fam.Velocity = fam.Velocity * 0.8 + ((pickup.Position - fam.Position):Resized(3))
			end
		elseif poop and ILIB.room:IsClear() then
			if poop.Position:Distance(fam.Position) < 30 then
				if not data.hasDroppedBomb then
					--local bomb = Isaac.Spawn(EntityType.ENTITY_BOMBDROP, 0, 0, fam.Position, Vector.Zero, player);
					poop:Hurt(1)
					data.hasDroppedBomb = 15
				end
				fam.Velocity = fam.Velocity * 0.8
			else
				fam.Velocity = fam.Velocity * 0.8 + ((poop.Position - fam.Position):Resized(3))
			end
		elseif cobweb and ILIB.room:IsClear() then
			if cobweb.Position:Distance(fam.Position) < 30 then
				if not data.hasDroppedBomb then
					--local bomb = Isaac.Spawn(EntityType.ENTITY_BOMBDROP, 0, 0, fam.Position, Vector.Zero, player);
					cobweb:Destroy()
					data.hasDroppedBomb = 3
				end
				fam.Velocity = fam.Velocity * 0.8
			else
				fam.Velocity = fam.Velocity * 0.8 + ((cobweb.Position - fam.Position):Resized(3))
			end
		elseif tinted and ILIB.room:IsClear() then
			if tinted.Position:Distance(fam.Position) < 30 then
				if not data.hasDroppedBomb then
					--local bomb = Isaac.Spawn(EntityType.ENTITY_BOMBDROP, 0, 0, fam.Position, Vector.Zero, player);
					tinted:Destroy()
					data.hasDroppedBomb = 60
				end
				fam.Velocity = fam.Velocity * 0.8
			else
				fam.Velocity = fam.Velocity * 0.8 + ((tinted.Position - fam.Position):Resized(3))
			end
		else
			--movement code
			if data.HasCommander then
				fam:FollowPosition ( data.HasCommander.Position );
				if fam.FrameCount % 35 == 0 then
					data.MoveDir = Isaac.GetRandomPosition()
				end
				if data.MoveDir then
					InutilLib.MoveRandomlyTypeI(fam, data.MoveDir, 2, 0.9, 0, 0, 0)
				end
			else
				fam:FollowParent();
				--fam:MoveDelayed( 70 );
				if fam.FrameCount % 35 == 0 then
					data.MoveDir = Isaac.GetRandomPosition()
				end
				if data.MoveDir then
					InutilLib.MoveRandomlyTypeI(fam, data.MoveDir, 2, 0.9, 0, 0, 0)
				end
			end
		end
		
		
		for i, e in pairs(Isaac.GetRoomEntities()) do
				if e.Type ~= EntityType.ENTITY_PLAYER then
					if e:IsActiveEnemy() then
						if e:IsVulnerableEnemy() then
							if (fam.Position - e.Position):Length() < 250 then
									local angle = (e.Position - fam.Position):GetAngleDegrees();
									if ((angle >= 175 and angle <= 180) or (angle <= -175 and angle >= -180)) then
										spr.FlipX = true
										data.ChargeTo = 0
										spr:Play("Charge", true)
										data.target = e
										InutilLib.SFX:Play( RebekahCurseSounds.SOUND_CHRISTIAN_OVERTAKE, 3, 0, false, 1 );
										InutilLib.SFX:Play( SoundEffect.SOUND_FORESTBOSS_STOMPS, 1, 0, false, 1 );
									elseif ((angle >= 0 and angle <= 10) or (angle <= 0 and angle >= -10)) then 
										spr.FlipX = false 
										data.ChargeTo = 1
										spr:Play("Charge", true)
										data.target = e
										InutilLib.SFX:Play( RebekahCurseSounds.SOUND_CHRISTIAN_OVERTAKE, 3, 0, false, 1 );
										InutilLib.SFX:Play( SoundEffect.SOUND_FORESTBOSS_STOMPS, 1, 0, false, 1 );
									end
							end
						end
					end
					if e.Type == EntityType.ENTITY_FAMILIAR and e.Variant == RebekahCurse.ENTITY_SCREAMINGNED and e.SubType == fam.SubType then
						data.HasCommander = e
					end
					if data.HasCommander and GetPtrHash(e) == GetPtrHash(data.HasCommander) and (fam.Position - e.Position):Length() < 250 then
						data.IncreasedBuff = 0.8
					else
						data.IncreasedBuff = 0
					end
				end
		end
	elseif spr:IsFinished("Idle") then
		spr:Play("Idle", true)
		InutilLib.SFX:Play( RebekahCurseSounds.SOUND_CHRISTIAN_CHANT, 2, 0, false, 1 );
	--charge ai
	elseif spr:IsFinished("Charge") then
			if data.ChargeTo == 0 then
				data.savedVelocity = Vector(-10,0) --needed for the velocity it goes + detection what grid is in front
			elseif data.ChargeTo == 1 then
				data.savedVelocity = Vector(10,0)
			end
			data.chargingFrameLimit = fam.FrameCount + 30
			spr:Play("Charging", true)
	elseif spr:IsPlaying("Charging") then
			
			for k, enemy in pairs( Isaac.GetRoomEntities() ) do
				if enemy:IsVulnerableEnemy() then
					if enemy.Position:Distance( fam.Position ) < enemy.Size + fam.Size + 30 then
						enemy:TakeDamage(5 + data.IncreasedBuff - damageNerf --[[+ fam.Player:GetNumCoins()/8]] + fam.Player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BFFS), 0, EntityRef(fam), 4)
					end
				end
			end
			local room = ILIB.game:GetRoom()
			--local setAngle = (fam.Velocity):GetAngleDegrees()
			if data.savedVelocity then
				fam.Velocity = fam.Velocity * 0.75 + data.savedVelocity
				local checkingVector = (room:GetGridEntity(room:GetGridIndex(fam.Position + data.savedVelocity)))
				if checkingVector and (checkingVector:GetType() == GridEntityType.GRID_WALL or checkingVector:GetType() == GridEntityType.GRID_DOOR) then 
					spr:Play("Charged", true)
					InutilLib.SFX:Play( RebekahCurseSounds.SOUND_STRIKE, 1, 0, false, 1 );
				end
			end
		if data.chargingFrameLimit == fam.FrameCount then
			spr:Play("Idle", true)
		end
	elseif spr:IsPlaying("Charged") then
		if spr:GetFrame() <= 64 then
			fam.Velocity = Vector( 0 , 0 );
		else
			if spr:GetFrame() == 65 then
				fam.Velocity = data.savedVelocity:Resized(50)
			end
		end
	elseif spr:IsFinished("Charged") then
		spr:Play("Idle")
	elseif spr:IsPlaying("DeusVult") then
		fam.Velocity = fam.Velocity * 0.8
		if spr:GetFrame() == 40 then
				for i, e in pairs(Isaac.GetRoomEntities()) do
					if e.Type == EntityType.ENTITY_MOM or e.Type == EntityType.ENTITY_MOMS_HEART or e.Type == EntityType.ENTITY_IT_LIVES then
						e.HitPoints = e.MaxHitPoints/2
						InutilLib.SFX:Play( SoundEffect.SOUND_MONSTER_GRUNT_0, 1, 0, false, 1.2 );
						--e:Kill()
					end
				end
		end
	elseif spr:IsFinished("DeusVult") or spr:IsFinished("Fire") or spr:IsFinished("LandDown") then
		spr:Play("Idle")
	elseif spr:IsFinished("ForJerusalem") then
		fam:Remove()
	end
	
end, RebekahCurse.ENTITY_CHRISTIANNED);

local freezeFrame = 0
local freezeFrame2 = 0
local maxTime = 30*5
--quality time

local function freezezawarudo()
	for _, v in pairs(Isaac.GetRoomEntities()) do
		local vdata = yandereWaifu.GetEntityData(v)
		local valid = not vdata.DontFreeze and (v.Type ~= EntityType.ENTITY_PLAYER and v.Type ~= EntityType.ENTITY_PROJECTILE and v.Type ~= EntityType.ENTITY_KNIFE and (v.Type ~= EntityType.ENTITY_BOMBDROP and not v.SpawnerEntity)) or (v.SpawnerEntity and v.SpawnerEntity.Type ~= EntityType.ENTITY_PLAYER)
		if valid then 
			if not v:HasEntityFlags(EntityFlag.FLAG_FREEZE) or not vdata.IsTheWorlded then
				v:AddEntityFlags(EntityFlag.FLAG_FREEZE)
				v:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
				if v:IsBoss() then
					v:AddEntityFlags(EntityFlag.FLAG_NO_SPRITE_UPDATE)
				elseif v.Type == EntityType.ENTITY_PICKUP then
					local pickup = v:ToPickup()
					pickup.Timeout = (pickup.Timeout ~= -1) and freezeFrame + 60 or -1
				end
				vdata.IsTheWorlded = true
			end
		end
	end
end

function yandereWaifu:UseQualityTime(card, player, flags) 
	freezeFrame = maxTime
	--[[print("ADJSDD")
	print(maxTime)
	print(freezeFrame)]]
	--freeze code
	freezezawarudo()
	InutilLib.SFX:Play( RebekahCurseSounds.SOUND_QUALITY_TIME_IN, 1, 0, false, 1 );

	ILIB.game:MakeShockwave(player.Position, 0.85, 0.025, 10)
end

yandereWaifu:AddCallback(ModCallbacks.MC_USE_CARD, yandereWaifu.UseQualityTime, RebekahCurseCards.CARD_QUALITYTIME);


--Shader copied from Nine/Sora with permission, thank you!
function yandereWaifu:ZaWarudoShader(name)
	if name == "ZaWarudo" then
		--local player = Isaac.GetPlayer(0)
		local dist = 1/(((maxTime-2-freezeFrame))) + 1/(((freezeFrame-2)))
		local on = 0
		if dist < 0 then
			dist = math.abs(dist)^2
		elseif freezeFrame-2 == 0 or maxTime-2-freezeFrame == 0 then
			dist = 1
		else
			on = 0.5
		end
		if freezeFrame == 277 then
		--	sound:Play(CustomSound.TICK_9,5,0,false,1)
		elseif freezeFrame == 157 then
		--	sound:Play(CustomSound.TICK_5,5,0,false,1)
		elseif freezeFrame == 1 then
		--	sound:Play(CustomSound.RESUME_TIME,2,0,false,1)
		--	music:Resume()
		elseif freezeFrame == 0 then
			dist = 0
		end
       -- if shaderAPI then
        --    shaderAPI.Shader("ZaWarudo",{ DistortionScale = dist, DistortionOn = on})
        --else
            return { DistortionScale = dist, DistortionOn = on}
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_GET_SHADER_PARAMS, yandereWaifu.ZaWarudoShader)
--[[yandereWaifu:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, function(_, proj)
    local vdata = yandereWaifu.GetEntityData(proj)
	print("ADSDDD")
	print(freezeFrame)
	if not vdata.IsTheWorlded and freezeFrame > 1 then
		vdata.StoredVelocity = proj.Velocity
        vdata.StoredFallingSpeed = proj.FallingSpeed
       	vdata.StoredAccel = proj.FallingAccel
		vdata.IsTheWorlded = true
	end
    if freezeFrame == 1 then
        vdata.IsTheWorlded = false
        proj.Velocity = vdata.StoredVelocity
        proj.FallingSpeed = vdata.StoredFallingSpeed
        proj.FallingAccel = vdata.StoredAccel
    end
	if freezeFrame > 1 then
		--print("Ahbfafiasffsff")
		proj.Velocity = Vector(0, 0)
		proj.FallingAccel = -0.1
		proj.FallingSpeed = 0
    end
end)]]

yandereWaifu:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
	if freezeFrame > 0 then
		if freezeFrame > 1 then
			freezezawarudo()
			for _, v in pairs(Isaac.GetRoomEntities()) do
				local vdata = yandereWaifu.GetEntityData(v)
				local valid = not vdata.DontFreeze and (v.Type ~= EntityType.ENTITY_PLAYER and v.Type ~= EntityType.ENTITY_PROJECTILE and v.Type ~= EntityType.ENTITY_KNIFE and (v.Type ~= EntityType.ENTITY_BOMBDROP and not v.SpawnerEntity)) or (v.SpawnerEntity and v.SpawnerEntity.Type ~= EntityType.ENTITY_PLAYER)
				if vdata.IsTheWorlded and valid then
					if not v:HasEntityFlags(EntityFlag.FLAG_FREEZE) then
						v:AddEntityFlags(EntityFlag.FLAG_FREEZE)
					end
				end
				if v.Type == EntityType.ENTITY_PROJECTILE then
					local proj = v:ToProjectile()
					if not vdata.IsTheWorlded and freezeFrame > 1 then
						vdata.StoredVelocity = proj.Velocity
						vdata.StoredFallingSpeed = proj.FallingSpeed
						vdata.StoredAccel = proj.FallingAccel
						vdata.IsTheWorlded = true
					end
					if freezeFrame == 1 then
						vdata.IsTheWorlded = false
						proj.Velocity = vdata.StoredVelocity
						proj.FallingSpeed = vdata.StoredFallingSpeed
						proj.FallingAccel = vdata.StoredAccel
					end
					if freezeFrame > 1 then
						print("Ahbfafiasffsff")
						proj.Velocity = Vector(0, 0)
						proj.FallingAccel = -0.1
						proj.FallingSpeed = 0
					end
				end
			end
		end
		freezeFrame = freezeFrame - 1
		--print(freezeFrame)
	end
	if freezeFrame == 1 then
		for i,v in pairs(Isaac.GetRoomEntities()) do
			local vdata = yandereWaifu.GetEntityData(v)
			if vdata.IsTheWorlded then
       			v:ClearEntityFlags(EntityFlag.FLAG_FREEZE)
       			v:ClearEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
       			v:ClearEntityFlags(EntityFlag.FLAG_NO_SPRITE_UPDATE)
				if v.Type == EntityType.ENTITY_PROJECTILE then
					local proj = v:ToProjectile()
					vdata.IsTheWorlded = false
					proj.Velocity = vdata.StoredVelocity
					proj.FallingSpeed = vdata.StoredFallingSpeed
					proj.FallingAccel = vdata.StoredAccel
				end
				vdata.IsTheWorlded = false
				if vdata.StoredZaWarudoDmg and vdata.StoredZaWarudoDmg > 0 then
					v:TakeDamage(vdata.StoredZaWarudoDmg, vdata.StoredLastDmgFlag or 0, EntityRef(player), 0)
					vdata.StoredZaWarudoDmg = nil
					vdata.StoredLastDmgFlag = nil
				end
			end
		end
		InutilLib.SFX:Play( RebekahCurseSounds.SOUND_QUALITY_TIME_OUT, 1, 0, false, 1 );
	end
	--[[
	local player = Isaac.GetPlayer(0)-- get player data
	local entities = Isaac.GetRoomEntities()
	if room2 ~= Game():GetLevel():GetCurrentRoomIndex() then
		freezeFrame = 0
	end
	if freezeFrame == 1 then
		for i,v in pairs(entities) do
			if v:HasEntityFlags(EntityFlag.FLAG_FREEZE) then
        v:ClearEntityFlags(EntityFlag.FLAG_FREEZE)
        if v.Type == EntityType.ENTITY_TEAR then
          local data = v:GetData()
          if data.Frozen then
            data.Frozen = nil
            tear = v:ToTear()
            entities[i].Velocity = data.StoredVel
            tear = entities[i]:ToTear()
            tear.FallingSpeed = data.StoredFall
            tear.FallingAcceleration = data.StoredAcc
          end
        elseif v.Type == EntityType.ENTITY_LASER then
          local data = v:GetData()
          data.Frozen = nil
        elseif v.Type == EntityType.ENTITY_KNIFE then
          local data = v:GetData()
          data.Frozen = nil
        end
      end
    end
    freezeFrame = freezeFrame - 1
	elseif freezeFrame > 1 then
		game.TimeCounter = savedTime
		for i,v in pairs(entities) do
			if entities[i].Type ~= EntityType.ENTITY_PLAYER and entities[i].Type ~= EntityType.ENTITY_FAMILIAR then
				if entities[i].Type ~= EntityType.ENTITY_PROJECTILE then
          if not v:HasEntityFlags(EntityFlag.FLAG_FREEZE) then
            entities[i]:AddEntityFlags(EntityFlag.FLAG_FREEZE)
          end
        end
				if entities[i].Type == EntityType.ENTITY_TEAR then
          local data = v:GetData()
					if not data.Frozen then
            if v.Velocity.X ~= 0 or v.Velocity.Y ~= 0 or not player:HasCollectible(CollectibleType.COLLECTIBLE_ANTI_GRAVITY) then
              data.Frozen = true
              data.StoredVel = entities[i].Velocity
              local tear = entities[i]:ToTear()
              data.StoredFall = tear.FallingSpeed
              data.StoredAcc = tear.FallingAcceleration
            else
              local tear = entities[i]:ToTear()
              tear.FallingSpeed = 0
            end
					else
            local tear = entities[i]:ToTear()
						entities[i].Velocity = zeroV
						tear.FallingAcceleration = -0.1
						tear.FallingSpeed = 0
					end
				elseif entities[i].Type == EntityType.ENTITY_BOMBDROP then
					bomb = v:ToBomb()
					bomb:SetExplosionCountdown(2)
                    if v.Variant  == 4 then
                        bomb.Velocity = zeroV
                    end
				elseif entities[i].Type == EntityType.ENTITY_LASER then
					if v.Variant ~= 2 then
            local laser = v:ToLaser()
            local data = v:GetData()
            if not data.Frozen and not laser:IsCircleLaser() then
              local newLaser = player:FireBrimstone(Vector.FromAngle(laser.StartAngleDegrees))
              newLaser.Position = laser.Position
              newLaser.DisableFollowParent = true
              local newData = newLaser:GetData()
              newData.Frozen = true
              laser.CollisionDamage = -100
              data.Frozen = true
              laser.DisableFollowParent = true
              laser.Visible = false
            end
            laser:SetTimeout(19)
          end
        elseif v.Type == EntityType.ENTITY_KNIFE then
          ---[[
         
        end
			end
		end
		freezeFrame = math.max(0,freezeFrame - 1)
	else
    for i,v in pairs(entities) do
      if v:GetData().Knife then
        for o,entity in pairs(entities) do
          if entity:IsVulnerableEnemy() and (not entity:GetData().Knife) and entity.Position:Distance(v.Position) < entity.Size + 7 then
            entity:TakeDamage(v.CollisionDamage,0,EntityRef(v),0)
          end
        end
        if player.Position:Distance(v.Position) > 1000 then
          v:Remove()
        end
      end
    end
  end]]
end);


yandereWaifu:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, ent, damage, dmgFlag, dmgSource, dmgCountdownFrames)
	print(freezeFrame)
	if freezeFrame > 1 then
		local player
        if dmgSource.Type == 1 then
            player = dmgSource.Entity:ToPlayer()
        elseif dmgSource.Entity and dmgSource.Entity.SpawnerEntity and dmgSource.Entity.SpawnerEntity.Type == 1 then
            player = dmgSource.Entity.SpawnerEntity:ToPlayer()
        end
		if player then
			local data = yandereWaifu.GetEntityData(ent)
			if not data.StoredZaWarudoDmg then data.StoredZaWarudoDmg = 0 end
			data.StoredZaWarudoDmg = data.StoredZaWarudoDmg + damage
			data.StoredLastDmgFlag = dmgFlag
			if dmgFlag & DamageFlag.DAMAGE_EXPLOSION ~= 0 then
				local blood = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BOMB_EXPLOSION, 0, ent.Position, Vector.Zero, nil):ToEffect();
				blood.RenderZOffset = 100
			else
				local blood = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, 0, ent.Position, Vector.Zero, nil):ToEffect();
				blood.RenderZOffset = 100
			end
			return false
		end
	end
end)


yandereWaifu:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_,player)
    local data = yandereWaifu.GetEntityData(player)
	if freezeFrame > 0 and not data.TIMETOMUDAMUDAMUDA then
		data.TIMETOMUDAMUDAMUDA = true
		player:AddCacheFlags(CacheFlag.CACHE_ALL);
		player:EvaluateItems()
	end
	if freezeFrame == 1 and data.TIMETOMUDAMUDAMUDA then
		data.TIMETOMUDAMUDAMUDA = false
		player:AddCacheFlags(CacheFlag.CACHE_ALL);
		player:EvaluateItems()
	end
end)

function yandereWaifu:QualityTimeCache(player, cacheF)
    local data = yandereWaifu.GetEntityData(player)
	if freezeFrame > 0 and data.TIMETOMUDAMUDAMUDA then
        if cacheF == CacheFlag.CACHE_FIREDELAY then
            player.MaxFireDelay = player.MaxFireDelay / 2
        end
    end
end
yandereWaifu:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, yandereWaifu.QualityTimeCache)

--physical touch
function yandereWaifu:UsePhysicalTouch(card, player, flags) 
	for i = 0, 7 do
		yandereWaifu.SpawnSilphiumHeart(player, 1)
	end
end

yandereWaifu:AddCallback(ModCallbacks.MC_USE_CARD, yandereWaifu.UsePhysicalTouch, RebekahCurseCards.CARD_PHYSICALTOUCH);