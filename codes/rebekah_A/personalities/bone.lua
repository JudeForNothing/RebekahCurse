
--BONE HEART--
do

function yandereWaifu.BoneHeartPunch(player, vector)
	local playerdata, data = yandereWaifu.GetEntityData(player), yandereWaifu.GetEntityData(player) --idk do I have two things that does the exact same thing but ill investigate sooner
	
	--if not playerdata.IsDashActive and not playerdata.IsAttackActive and playerdata.NoBoneSlamActive then -- and playerdata.specialBoneHeartStompCooldown <= 0 then
	--local vault = Isaac.Spawn(EntityType.ENTITY_EFFECT, ENTITY_BONEVAULT, 0, player.Position, Vector(0,0), player) --vault effect
	--yandereWaifu.GetEntityData(vault).bonerOwner = player;
	--vault.DepthOffset = 5;
	--local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, ENTITY_PERSONALITYPOOF, 0, player.Position, Vector.Zero, player)
	
	--local customBody = Isaac.Spawn(EntityType.ENTITY_EFFECT, ENTITY_EXTRACHARANIMHELPER, 0, player.Position, Vector(0,0), player) --body effect
	--yandereWaifu.GetEntityData(customBody).Player = player
	--yandereWaifu.GetEntityData(customBody).IsHopping = true
	--yandereWaifu.GetEntityData(customBody).IsVaulting = true
	--playerdata.IsVaulting = true;
	--playerdata.vaultVelocity = vector:Resized( REBEKAH_BALANCE.BONE_HEARTS_VAULT_VELOCITY )
	local trinketBonus = 0
	if player:HasTrinket(RebekahCurse.TRINKET_ISAACSLOCKS) then
		trinketBonus = 5
	end
	
	player.Velocity = player.Velocity + vector:Resized( REBEKAH_BALANCE.BONE_HEARTS_DASH_VELOCITY );
	yandereWaifu.SpawnDashPoofParticle( player.Position, Vector(0,0), player, RebekahPoofParticleType.Bone );
	yandereWaifu.SpawnHeartParticles( 2, 5, player.Position, player.Velocity:Rotated(180):Resized( player.Velocity:Length() * (math.random() * 0.5 + 0.5) ), player, RebekahHeartParticleType.Bone );
	if not data.BoneStacks then data.BoneStacks = 0 end --just in case
	local cut, spear
	if player:HasWeaponType(WeaponType.WEAPON_KNIFE) then
		spear = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_BONESPEAR, 0, player.Position, Vector(0,0), player):ToEffect();
		yandereWaifu.GetEntityData(spear).PermanentAngle = vector:GetAngleDegrees() + 90
		yandereWaifu.GetEntityData(spear).Player = player
		spear:GetSprite():Play("Stab", true)
	else
		cut = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_BONEPUNCH, 0, player.Position, Vector(0,0), player):ToEffect();
		yandereWaifu.GetEntityData(cut).PermanentAngle = vector:GetAngleDegrees()
		yandereWaifu.GetEntityData(cut).Player = player
		yandereWaifu.GetEntityData(cut).Pos = bonePos
		if player:HasCollectible(CollectibleType.COLLECTIBLE_DEATHS_TOUCH) then
			cut:GetSprite():Load("gfx/effects/bone/melee/punch_scythe.anm2", true)
		end
	end
	if data.BoneStacks < 5 then
		playerdata.specialCooldown = (REBEKAH_BALANCE.BONE_HEARTS_DASH_COOLDOWN) - trinketBonus;
		--local bonePos = player.Position - Vector(0,15):Rotated(player:GetMovementInput():GetAngleDegrees()) 
		
		if cut then
			if data.BoneStacks == 0 or data.BoneStacks == 2 or data.BoneStacks == 4 then --altering fist code thingy
			--	bonePos = player.Position - Vector(-0,-15):Rotated(player:GetMovementInput():GetAngleDegrees())
				cut:GetSprite():Play("Punch2", true)
			end
			cut.RenderZOffset = 100
		end
	else
		if cut then cut:GetSprite():Play("PunchFull", true) end
		playerdata.specialCooldown = (REBEKAH_BALANCE.BONE_HEARTS_MODIFIED_DASH_COOLDOWN) - trinketBonus;
	end
	playerdata.invincibleTime = REBEKAH_BALANCE.BONE_HEARTS_DASH_INVINCIBILITY_FRAMES;
	playerdata.IsDashActive = true;
	--playerdata.NoBoneSlamActive = false;
--end
end


function yandereWaifu.RebekahBoneBarrage(player, direction)
	--local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_PERSONALITYPOOF, 0, player.Position, Vector.Zero, player)
	local data = yandereWaifu.GetEntityData(player)
	local extraWorms = 0
	if player:HasCollectible(CollectibleType.COLLECTIBLE_20_20) then
		extraWorms = extraWorms + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_20_20) 
	end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_MUTANT_SPIDER) then
		extraWorms = extraWorms + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_MUTANT_SPIDER) * 3
	end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_INNER_EYE) then
		extraWorms = extraWorms + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_INNER_EYE) * 2
	end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_MONSTROS_LUNG) then
		extraWorms = extraWorms + math.random(3,5);
	end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_SOY_MILK) then
		extraWorms = (extraWorms + 1) * 8
	end
	
	if not data.hasLeech then
		local leech = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, RebekahCurse.ENTITY_BONEJOCKEY, 0, player.Position, Vector(0,0), player)
		if extraWorms > 0 then
			for i = 1, extraWorms do --extra carrion worm thingies when extra tears!!
				local leech2 = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, RebekahCurse.ENTITY_BONEJOCKEY, 10, player.Position, Vector(0,0), player)
				yandereWaifu.GetEntityData(leech2).ParentLeech = leech
			--	--print("come on, this should work")
			end
		end
		--[[--ludostuff
		local ludoTear
		if player:HasCollectible(CollectibleType.COLLECTIBLE_LUDOVICO_TECHNIQUE) then
			ludoTear = InutilLib.GetPlayerLudo(player)
			if ludoTear then
				local ludoBone = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_LUDOBONE, 0, ludoTear.Position, Vector(0,0), player)
				ludoTear:Remove()
				data.LudoBone = ludoBone
			end
		end]]
		data.hasLeech = leech
		yandereWaifu.GetEntityData(leech).IsPossessed = true
		yandereWaifu.purchaseReserveStocks(player, 1)
		for i = 0, 12 do
			local var = TearVariant.BLOOD
			local rng = math.random(1,5)
			if rng == 3 then
				var = TearVariant.BONE
			--elseif rng == 4 then
			--	var = RebekahCurse.ENTITY_RIBTEAR
			--elseif rng == 5 then
			--	var = RebekahCurse.ENTITY_SKULLTEAR
			end
			local tears =  Isaac.Spawn(EntityType.ENTITY_TEAR, var, 0, player.Position, Vector(0,-8):Rotated(math.random(0,360)), player):ToTear()
			InutilLib.MakeTearLob(tears, 1.5, 9 )
		end
		data.IsLeftover = true
		
	else
		if not data.IsLeftover then
			local customBody = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_EXTRACHARANIMHELPER, 0, player.Position, Vector(0,0), nil) --body effect
			yandereWaifu.GetEntityData(customBody).Player = player
			yandereWaifu.GetEntityData(customBody).DontFollowPlayer = true
			yandereWaifu.GetEntityData(customBody).IsLeftover = true
			customBody.RenderZOffset = -10
			data.IsLeftover = true --sets the corpse to come and eat you
			data.IsLeftoverFrameLimit = player.FrameCount + 90
			--print("wahsy")
		end
	end
	--local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_SLAMDUST, 0, player.Position, Vector(0,0), player)
	--player.Invincible = true --player.Position = Vector(0,0) --player.GridCollisionClass =  EntityGridCollisionClass.GRIDCOLL_NOPITS 
	player.Velocity = Vector(0,0)
	player.Visible = false
	--player.ControlsEnabled = false
	yandereWaifu.RebekahCanShoot(player, false)
	data.LastGridCollisionClass = player.GridCollisionClass
	--data.LastEntityCollisionClass = player.EntityCollisionClass
	player.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
	--player.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
	--EndBarrage()
	data.NoBoneSlamActive = false
end
function yandereWaifu:onFamiliarBoneStandInit(fam)
    fam.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
	local data = yandereWaifu.GetEntityData(fam)
	local player = fam.Player
	player.Visible = false
    local sprite = fam:GetSprite()
    sprite:Play("Spawn", true)
end
yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, yandereWaifu.onFamiliarBoneStandInit, RebekahCurse.ENTITY_BONESTAND);

yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_,  fam) --bone stand
	local spr = fam:GetSprite()
	local rng = math.random(1, 100)
	local player = fam.Player:ToPlayer()
	local data = yandereWaifu.GetEntityData(fam)
	local body = data.Body
	local controller = player.ControllerIndex
	
	player.Velocity = fam.Velocity
	player.Position = fam.Position
	
	if not data.TriggerFrame then data.TriggerFrame = 35 end --sets up how long the frame left to trigger before reverting back
	
	data.TriggerFrame = data.TriggerFrame - 1
	
	if not data.FireDelay then data.FireDelay = math.floor(player.MaxFireDelay/3) end --sets how much one can shoot depending on player stats
	if data.FireDelay > 0 then data.FireDelay = data.FireDelay - 1 end
	
	if spr:IsFinished("Spawn") then
		data.Angle = InutilLib.AnimShootFrame(fam, true, data.Angle, "MoveSideward", "MoveForward", "MoveBackward")
	end
	
	--use heaart reserve
	yandereWaifu:addReserveFill(player, -1)
	
	if InutilLib.IsFinishedMultiple(spr, "AttackSideward", "AttackForward", "AttackBackward") then --reset after done shooting
		InutilLib.AnimShootFrame(fam, true, Vector.FromAngle(data.Angle), "MoveSideward", "MoveForward", "MoveBackward")
	end
	
	if player:GetShootingInput():GetAngleDegrees() == data.Angle and (player:GetShootingInput().X ~= 0 or player:GetShootingInput().Y ~= 0 ) then-- and player:GetShootingInput().Y == Vector.FromAngle(data.Angle).Y then
		data.TriggerFrame = 35
		
		fam.Velocity = Vector.Zero --stop
		
		if data.FireDelay <= 0 then
			if rng < 51 then
				local tears = player:FireTear(fam.Position + Vector(0,20):Rotated(player:GetShootingInput():GetAngleDegrees()), player:GetShootingInput():Resized(10), false, false, false):ToTear()
				tears.Position = fam.Position
				tears:ChangeVariant(RebekahCurse.ENTITY_RAPIDPUNCHTEAR)
				if (tears:GetSprite().Rotation >= -180 and tears:GetSprite().Rotation <= 0) then	
					tears:GetSprite().FlipX = false
				elseif (tears:GetSprite().Rotation >= 0 and tears:GetSprite().Rotation <= 180) then	
					tears:GetSprite().FlipX = true
				end
			else
				local tears = player:FireTear(fam.Position - Vector(0,20):Rotated(player:GetShootingInput():GetAngleDegrees()), player:GetShootingInput():Resized(10), false, false, false):ToTear()
				tears.Position = fam.Position
				tears:ChangeVariant(RebekahCurse.ENTITY_RAPIDPUNCHTEAR)
				if (tears:GetSprite().Rotation >= -180 and tears:GetSprite().Rotation <= 0) then	
					tears:GetSprite().FlipX = false
				elseif (tears:GetSprite().Rotation >= 0 and tears:GetSprite().Rotation <= 180) then	
					tears:GetSprite().FlipX = true
				end
			end
			data.FireDelay = math.floor(player.MaxFireDelay/3) --reset
		end
		
		InutilLib.AnimShootFrame(fam, true,  Vector.FromAngle(data.Angle), "AttackSideward", "AttackForward", "AttackBackward")
	end
	if player:GetMovementInput().X ~= 0 or player:GetMovementInput().Y ~= 0 then --move code
		if InutilLib.IsPlayingMultiple(spr, "MoveSideward") then
			fam.Velocity = Vector(player:GetMovementInput().X, 0)*10
		end
		if InutilLib.IsPlayingMultiple(spr, "MoveForward", "MoveBackward") then
			fam.Velocity = Vector(0, player:GetMovementInput().Y)*10
		end
	else
		fam.Velocity = Vector.Zero
	end
			
	--print(data.TriggerFrame, player:GetShootingInput(), Vector.FromAngle(data.Angle):Normalized(), data.Angle)
	
	if data.TriggerFrame <= 0 then
		yandereWaifu.GetEntityData(player).IsAttackActive = false
		fam:Remove()
		player.Visible = true;
		player.ControlsEnabled = true;
		player.GridCollisionClass = yandereWaifu.GetEntityData(player).LastGridCollisionClass;
		player.EntityCollisionClass = yandereWaifu.GetEntityData(player).LastEntityCollisionClass;
		yandereWaifu.GetEntityData(player).NoBoneSlamActive = true
		
		player.Position = body.Position
		body:Remove()
		--InutilLib.RefundActiveCharge(player, 1, true)
	end
	
end, RebekahCurse.ENTITY_BONESTAND);

yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	--for i,player in ipairs(ILIB.players) do
		local sprite = eff:GetSprite()
		local data = yandereWaifu.GetEntityData(eff)
		local player = data.Player
		
		local function HasGiantModifyingStuff() --checks if giant tear stuff exists
			if player:HasCollectible(CollectibleType.COLLECTIBLE_IPECAC) or player:HasCollectible(CollectibleType.COLLECTIBLE_POLYPHEMUS) then
				return true
			end
			return false
		end
		
		local room =  Game():GetRoom()
		--function code
		if eff.FrameCount == 1 and not sprite:IsPlaying("Punch") and not sprite:IsPlaying("Punch2")  and not sprite:IsPlaying("PunchFull") then
			sprite:Play("Punch")
			--eff.Velocity = Vector.FromAngle(data.PermanentAngle):Resized(35)
		end
		
		if sprite:IsFinished("Punch") or sprite:IsFinished("Punch2") or sprite:IsFinished("PunchFull") then
			eff:Remove()
		end 
		
		eff.Position = player.Position
		eff.Velocity = player.Velocity
		
		if sprite:GetFrame() == 5 then
			for i, ent in pairs (Isaac.GetRoomEntities()) do
				if (ent:IsEnemy() and ent:IsVulnerableEnemy()) or ent.Type == EntityType.ENTITY_FIREPLACE and not ent:IsDead() then
					local dmg = 2
					local additDistance = 0
					if player:HasCollectible(CollectibleType.COLLECTIBLE_DEATHS_TOUCH) then
						dmg = 3
						additDistance = 10
					end
					if ent.Position:Distance((eff.Position)+ (Vector(8,0):Rotated(data.PermanentAngle))) <= 50 + additDistance then
						ent:TakeDamage((player.Damage) * dmg, 0, EntityRef(eff), 1)
					end
				end
				local grid = room:GetGridEntity(room:GetGridIndex((eff.Position)+ (Vector(12,0):Rotated(data.PermanentAngle)))) --grids around that Rebecca stepped on
				if grid ~= nil then 
					--print( grid:GetType())
					if grid:GetType() == GridEntityType.GRID_TNT or grid:GetType() == GridEntityType.GRID_POOP then
						grid:Destroy()
					end
				end
			end
		elseif sprite:IsPlaying("PunchFull") then
			if sprite:GetFrame() >= 5 and sprite:GetFrame() <= 11 then
				local gridPos = 0
				for i, ent in pairs (Isaac.GetRoomEntities()) do
					if (ent:IsEnemy() and ent:IsVulnerableEnemy()) or ent.Type == EntityType.ENTITY_FIREPLACE and not ent:IsDead() then
						local dmg = 4
						local additDistance = 0
						if player:HasCollectible(CollectibleType.COLLECTIBLE_DEATHS_TOUCH) then
							dmg = 2
							additDistance = 10
						end
						if ent.Position:Distance((eff.Position)) <= 50 + additDistance then
							ent:TakeDamage((player.Damage)/dmg, 0, EntityRef(eff), 1)
						end
					end
					local grid = room:GetGridEntity(room:GetGridIndex((eff.Position)+ (Vector(12,0):Rotated(data.PermanentAngle + gridPos)))) --grids around that Rebecca stepped on
					if grid ~= nil then 
						--print( grid:GetType())
						if grid:GetType() == GridEntityType.GRID_TNT or grid:GetType() == GridEntityType.GRID_POOP then
							grid:Destroy()
						end
					end
				end
			end
		end
		--eff.Velocity = player.Velocity*2
		sprite.Rotation = data.PermanentAngle
	--end
end, RebekahCurse.ENTITY_BONEPUNCH)


yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	--for i,player in ipairs(ILIB.players) do
		local sprite = eff:GetSprite()
		local data = yandereWaifu.GetEntityData(eff)
		local player = data.Player
		
		local function HasGiantModifyingStuff() --checks if giant tear stuff exists
			if player:HasCollectible(CollectibleType.COLLECTIBLE_IPECAC) or player:HasCollectible(CollectibleType.COLLECTIBLE_POLYPHEMUS) then
				return true
			end
			return false
		end
		
		local room =  Game():GetRoom()
		--function code
		if eff.FrameCount == 1 and not sprite:IsPlaying("Idle") and not sprite:IsPlaying("Stab") then
			sprite:Play("Idle")
			--eff.Velocity = Vector.FromAngle(data.PermanentAngle):Resized(35)
		end
		
		if sprite:IsFinished("Stab") then
			if data.IsJockeySpear then
				sprite:Play("Idle")
			else
				eff:Remove()
			end
		end
		
		eff.Position = player.Position
		eff.Velocity = player.Velocity
		
		if sprite:IsPlaying("Stab") then
			if sprite:GetFrame() >= 5 and sprite:GetFrame() <= 11 then
				local gridPos = 0
				local step = 0 --way to push the hitbox further, idk how the better method is
				if sprite:GetFrame() == 5 then
					step = 12
				end
				if sprite:GetFrame() >= 6 then
					step = 6
				end
				--if sprite:GetFrame() >= 7 then
				--	step = -6
				--end
				for i, ent in pairs (Isaac.GetRoomEntities()) do
					if (ent:IsEnemy() and ent:IsVulnerableEnemy()) or ent.Type == EntityType.ENTITY_FIREPLACE and not ent:IsDead() then
						local dmg = 0.4
						local additDistance = 0
						if player:HasCollectible(CollectibleType.COLLECTIBLE_DEATHS_TOUCH) then
							dmg = 0.6
							additDistance = 10
						end
						if ent.Position:Distance((eff.Position)+ (Vector(72 + step,0):Rotated(data.PermanentAngle - 90))) <= 50 + additDistance then
							ent:TakeDamage((player.Damage)*dmg, 0, EntityRef(eff), 1)
							--bleed chance
							if math.random(1,3) == 3 and data.IsJockeySpear then --can only do the bleed if on the jockey
								ent:AddEntityFlags(EntityFlag.FLAG_BLEED_OUT)
							end
						end
					end
					local grid = room:GetGridEntity(room:GetGridIndex((eff.Position)+ (Vector(72 + step,0):Rotated(data.PermanentAngle  - 90 + gridPos)))) --grids around that Rebecca stepped on
					if grid ~= nil then 
						--print( grid:GetType())
						if grid:GetType() == GridEntityType.GRID_TNT or grid:GetType() == GridEntityType.GRID_POOP then
							grid:Destroy()
						end
					end
				end
			end
		elseif sprite:IsPlaying("Idle") then
			if eff.FrameCount % 5 == 0 then
				for i, ent in pairs (Isaac.GetRoomEntities()) do
					if (ent:IsEnemy() and ent:IsVulnerableEnemy()) or ent.Type == EntityType.ENTITY_FIREPLACE and not ent:IsDead() then
						if ent.Position:Distance((eff.Position)+ (Vector(72,0):Rotated(data.PermanentAngle - 90))) <= 50 then
							ent:TakeDamage((player.Damage), 0, EntityRef(eff), 1)
						end
					end
					local grid = room:GetGridEntity(room:GetGridIndex((eff.Position)+ (Vector(72,0):Rotated(data.PermanentAngle  - 90)))) --grids around that Rebecca stepped on
					if grid ~= nil then 
						--print( grid:GetType())
						if grid:GetType() == GridEntityType.GRID_TNT or grid:GetType() == GridEntityType.GRID_POOP then
							grid:Destroy()
						end
					end
				end
			end
		end
		
		
		if data.IsJockeySpear then
			if yandereWaifu.GetEntityData(player).IsAttackActive == false then
				eff:Remove()
			end
		end
		--eff.Velocity = player.Velocity*2
		sprite.Rotation = data.PermanentAngle
	--end
end, RebekahCurse.ENTITY_BONESPEAR)


yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	eff.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
	--for i,player in ipairs(ILIB.players) do
		local sprite = eff:GetSprite()
		local data = yandereWaifu.GetEntityData(eff)
		local player = data.Player
		
		local function HasGiantModifyingStuff() --checks if giant tear stuff exists
			if player:HasCollectible(CollectibleType.COLLECTIBLE_IPECAC) or player:HasCollectible(CollectibleType.COLLECTIBLE_POLYPHEMUS) then
				return true
			end
			return false
		end
		
		local room =  Game():GetRoom()
		--function code
		if eff.FrameCount == 1 then
			sprite:Play("Speen")
			--eff.Velocity = Vector.FromAngle(data.PermanentAngle):Resized(35)
		end
		
		InutilLib.MoveDiagonalTypeI(eff, 10, false, true)
		
		if player then
		
			if yandereWaifu.GetEntityData(player).IsAttackActive == false or yandereWaifu.GetEntityData(player).IsLeftover == false then
				eff:Remove()
			end 
			
			if fam.FrameCount % 5 == 0 then
				for i, e in pairs(Isaac.GetRoomEntities()) do
					if e:IsActiveEnemy() and e:IsVulnerableEnemy() then
						if (fam.Position - e.Position):Length() < fam.Size + e.Size + 3 then
							e:TakeDamage(player.Damage/1.5, 0, EntityRef(fam), 4)
						end
					end
				end
			end
		end
	--end
end, RebekahCurse.ENTITY_LUDOBONE)


yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	--for i,player in ipairs(ILIB.players) do
		local sprite = eff:GetSprite()
		local data = yandereWaifu.GetEntityData(eff)
		local player = data.Player
		
		local function HasGiantModifyingStuff() --checks if giant tear stuff exists
			if player:HasCollectible(CollectibleType.COLLECTIBLE_IPECAC) or player:HasCollectible(CollectibleType.COLLECTIBLE_POLYPHEMUS) then
				return true
			end
			return false
		end
		
		local room =  Game():GetRoom()
		--function code
		if eff.FrameCount == 1 then
			sprite:Play("Falling")
			--eff.Velocity = Vector.FromAngle(data.PermanentAngle):Resized(35)
		end
		
		if sprite:IsFinished("Falling") then
			sprite:Play("Fell")
			if eff.FrameCount % 5 == 0 then
				for i, e in pairs(Isaac.GetRoomEntities()) do
					if e:IsActiveEnemy() and e:IsVulnerableEnemy() then
						if (eff.Position - e.Position):Length() < eff.Size + e.Size + 50 then
							e:TakeDamage(player.Damage * 4, 0, EntityRef(eff), 4)
						end
					end
				end
			end
			Isaac.Explode(eff.Position, player, 10)
			ILIB.game:ShakeScreen(5)
			for i = 0, 360 - 360/8, 360/8 do
				local tears = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.BONE, 0, eff.Position, Vector(0,-8):Rotated(i), player):ToTear()
			end
		end 
		
		if sprite:IsFinished("Fell") then
			eff:Remove()
			for i = 0, 360 - 360/8, 360/8 do
				local tears = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.BONE, 0, eff.Position, Vector(0,-8):Rotated(i), player):ToTear()
			end
		end 
	--end
end, RebekahCurse.ENTITY_EPICBONE)

InutilLib:AddCallback(ModCallbacks.MC_POST_FAMILIAR_RENDER, function(_,  fam)
	local data = yandereWaifu.GetEntityData(fam)
	if fam.SubType == 0 then
		--if ILIB.game:GetFrameCount() % 10 == 0 then
			--InutilLib.CreateGenericPathfinder(fam)
			--if data.target then
			--	InutilLib.GenerateAStarPath(fam.Position, data.target.Position, true)
			--end
		--end
		--local path = InutilLib.GenerateAStarPath(fam.Position, fam.Player.Position, true)
	end
end, RebekahCurse.ENTITY_BONEJOCKEY)

function yandereWaifu:onFamiliarBoneJockeyInit(fam)
    fam.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
	local data = yandereWaifu.GetEntityData(fam)
	local player = fam.Player:ToPlayer()
	--local player = fam.Player
	--player.Visible = false
    local sprite = fam:GetSprite()
	if fam.SubType == 0 then
		if player:HasCollectible(CollectibleType.COLLECTIBLE_DR_FETUS) then
			sprite:ReplaceSpritesheet(2, "gfx/effects/bone/corpseeater/corpse_eater_rider_bomb.png")
			sprite:ReplaceSpritesheet(3, "gfx/effects/bone/corpseeater/corpse_eater_rider_bomb.png")
			sprite:ReplaceSpritesheet(4, "gfx/effects/bone/corpseeater/corpse_hair.png")
			sprite:LoadGraphics()
		end
		if not player:HasCollectible(CollectibleType.COLLECTIBLE_TECHNOLOGY) and not player:HasCollectible(CollectibleType.COLLECTIBLE_TECH_X) then --remove electric effect
			sprite:ReplaceSpritesheet(5, "gfx/effects/bone/corpseeater/none.png")
			sprite:LoadGraphics()
		end
		sprite:Play("Appear", true)
		data.Butt = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, RebekahCurse.ENTITY_BONEJOCKEY, 1, fam.Position, Vector(0,0), player) 
		yandereWaifu.GetEntityData(data.Butt).Head = fam
		
		data.ATTACK_DASH_DOUBLE_TAP = InutilLib.DoubleTap:New();
		
		
		yandereWaifu.GetEntityData(player).hasLeech = fam --set this so it wont duplicate
	elseif fam.SubType == 10 then
		sprite:Load("gfx/effects/bone/corpseeater/extra_bone_jockey.anm2", true)
		sprite:Play("Appear", true)
		data.VarySpeed = math.random(1,20)/10
	else
		fam.DepthOffset  = -10
		sprite:Play("BodyAppear", true)
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, yandereWaifu.onFamiliarBoneJockeyInit, RebekahCurse.ENTITY_BONEJOCKEY);

yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_,  fam) --bone jockey
	local spr = fam:GetSprite()
	local rng = math.random(1, 100)
	local player = fam.Player:ToPlayer()
	local data = yandereWaifu.GetEntityData(fam)
	local body = data.Body
	local butt = data.Butt
	local controller = player.ControllerIndex
	
	--print(fam.EntityCollisionClass)
	--print(fam.Player.Type)
	--print(fam:GetEntityFlags())
	
	local leechSize = 1
	if player:HasCollectible(CollectibleType.COLLECTIBLE_SOY_MILK) then
		leechSize = 0.8
	elseif player:HasCollectible(CollectibleType.COLLECTIBLE_POLYPHEMUS) then
		leechSize = 1.5
	end
	
	local extraDmg = 0
	if leechSize < 1 then
		extraDmg = extraDmg + 2
	end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_20_20) then
		extraDmg = extraDmg + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_20_20) 
	end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_MUTANT_SPIDER) then
		extraDmg = extraDmg + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_MUTANT_SPIDER) * 3
	end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_INNER_EYE) then
		extraDmg = extraDmg + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_INNER_EYE) * 2
	end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_MONSTROS_LUNG) then
		extraDmg = extraDmg + math.random(3,5);
	end
	
	
	if player:HasCollectible(CollectibleType.COLLECTIBLE_DOGMA) and fam.GridCollisionClass == EntityGridCollisionClass.GRIDCOLL_GROUND then --special case because it needs to float ffs
		fam.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
		if fam.SubType == 1 then
			fam:GetSprite():ReplaceSpritesheet(1, "gfx/effects/bone/corpseeater/corpse_eater_body_dogma.png")
			fam:GetSprite():LoadGraphics()
		end
	elseif not player:HasCollectible(CollectibleType.COLLECTIBLE_DOGMA) and fam.GridCollisionClass == EntityGridCollisionClass.GRIDCOLL_WALLS then --special case because it needs to float ffs
		fam.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
		if fam.SubType == 1 then
			fam:GetSprite():ReplaceSpritesheet(1, "gfx/effects/bone/corpseeater/corpse_eater_body.png")
			fam:GetSprite():LoadGraphics()
		end
	end
	
	--bloody body render
	if not player:HasCollectible(CollectibleType.COLLECTIBLE_DOGMA) and data.BloodyMouthCount then
		fam:GetSprite():ReplaceSpritesheet(0, "gfx/effects/bone/corpseeater/corpse_eater_hungry.png")
		fam:GetSprite():LoadGraphics()
		--data.Butt:GetSprite():ReplaceSpritesheet(0, "gfx/effects/bone/corpseeater/none.png")
		--data.Butt:GetSprite():LoadGraphics()
	end
	
	local function FollowParent()
		local path = InutilLib.GenerateAStarPath(fam.Position, player.Position)
		
		if (fam.Position - player.Position):Length() > 300 then
			InutilLib.FollowPath(fam, player, path, 2, 0.9)
		else
			fam:FollowParent()
		end
	end
	
	if fam.SubType == 0 then
		local function End()
			data.IsPossessed = false
			data.IsDashActive = false
					
			data.Dashing = false
			--player.ControlsEnabled = true
			--[[player.Visible = true
			yandereWaifu.GetEntityData(player).IsAttackActive = false
			yandereWaifu.RebekahCanShoot(player, true)
			player.GridCollisionClass = yandereWaifu.GetEntityData(player).LastGridCollisionClass
			--player.EntityCollisionClass = yandereWaifu.GetEntityData(player).LastEntityCollisionClass
			yandereWaifu.GetEntityData(player).LastGridCollisionClass = nil
			yandereWaifu.GetEntityData(player).LastEntityCollisionClass = nil
			
			yandereWaifu.GetEntityData(player).IsLeftover = false
			yandereWaifu.GetEntityData(player).NoBoneSlamActive = true]]
			
			local customBody = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_EXTRACHARANIMHELPER, 0, fam.Position, Vector(0,0), nil) --body effect
			yandereWaifu.GetEntityData(customBody).Player = player
			yandereWaifu.GetEntityData(customBody).DontFollowPlayer = true
			yandereWaifu.GetEntityData(customBody).BoneJumpOffFromJockey = true
			
			data.DeathFrame = 1800 
			
			fam:GetSprite():ReplaceSpritesheet(2, "gfx/effects/bone/corpseeater/none.png")
			fam:GetSprite():ReplaceSpritesheet(3, "gfx/effects/bone/corpseeater/none.png")
			fam:GetSprite():ReplaceSpritesheet(4, "gfx/effects/bone/corpseeater/none.png")
			fam:GetSprite():LoadGraphics()
			
			--yandereWaifu:addReserveStocks(player, -1)
			--yandereWaifu:addReserveFill(player, yandereWaifu.GetEntityData(player).heartReserveMaxFill-1)
			
			--yandereWaifu:addReserveFill(player, yandereWaifu.GetEntityData(player).heartReserveMaxFill-1)
		end
		
		if not data.Butt then
			data.Butt = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, RebekahCurse.ENTITY_BONEJOCKEY, 1, fam.Position, Vector(0,0), player) 
			yandereWaifu.GetEntityData(data.Butt).Head = fam
		end
		
		if spr:IsFinished("Appear") then
			data.Angle = InutilLib.AnimShootFrame(fam, true, fam.Velocity, "WalkRight", "WalkDown", "WalkUp", "WalkLeft")
		end
		if not InutilLib.IsPlayingMultiple(spr, "ChargeRight", "ChargeDown", "ChargeUp", "ChargeLeft") then 
			if data.IsPossessed then
				local lastDir 
				
				if (player:GetMovementInput().X ~= 0 or player:GetMovementInput().Y ~= 0) then
					lastDir = player:GetMovementInput()
				else
					if not data.lastDir then data.lastDir = Vector(1,0) end
					lastDir = data.lastDir
				end
				data.lastDir = lastDir
				data.Angle = InutilLib.AnimShootFrame(fam, false, lastDir or Vector(10,0), "WalkRight", "WalkDown", "WalkUp", "WalkLeft")
			else
				data.Angle = InutilLib.AnimShootFrame(fam, false, fam.Velocity, "WalkRight", "WalkDown", "WalkUp", "WalkLeft")
			end
		end
		
		local techXPos = Vector.FromAngle(data.Angle):Resized(15)
		
		--bloody mount code
		if data.BloodyMouthCount then
			if data.BloodyMouthCount > 0 then
				data.BloodyMouthCount = data.BloodyMouthCount - 1
				if fam.FrameCount % 5 == 0 then
					local puddle = ILIB.game:Spawn( EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_RED, fam.Position, Vector(0,0), player, 0, 0):ToEffect()
					InutilLib.RevelSetCreepData(puddle)
					InutilLib.RevelUpdateCreepSize(puddle, math.random(1,2), true)
				end
			else
				data.BloodyMouthCount = nil
				if not player:HasCollectible(CollectibleType.COLLECTIBLE_DOGMA) then
					fam:GetSprite():ReplaceSpritesheet(0, "gfx/effects/bone/corpseeater/corpse_eater.png")
					fam:GetSprite():LoadGraphics()
				end
			end
		end
		
		--chomp code
		if spr:IsEventTriggered("Chomp") then
			for i, entities in pairs(Isaac.GetRoomEntities()) do
				if entities:IsVulnerableEnemy() then
					if entities.Position:Distance(fam.Position) < entities.Size + fam.Size + 35*leechSize then
						entities:TakeDamage(player.Damage * 1.4 + extraDmg, 0, EntityRef(fam), 1)
					end
				end
			end
			if data.BloodyMouthCount then
				for i = 0, 4 do
					local var = TearVariant.BLOOD
					local rng = math.random(1,5)
					if rng == 3 then
						var = TearVariant.BONE
					--elseif rng == 4 then
					--	var = RebekahCurse.ENTITY_RIBTEAR
					--elseif rng == 5 then
					--	var = RebekahCurse.ENTITY_SKULLTEAR
					end
					local tears =  Isaac.Spawn(EntityType.ENTITY_TEAR, var, 0, fam.Position, Vector(0,-8):Rotated(math.random(0,360)), player):ToTear()
					InutilLib.MakeTearLob(tears, 1.5, 9 )
				end
			end
			if player:HasCollectible(CollectibleType.COLLECTIBLE_TECHNOLOGY) then
				for i = 0, math.random(0,2) do
					local techlaser = player:FireTechLaser(fam.Position, 0, Vector.FromAngle(math.random(0,360)), false, true)
					techlaser.OneHit = true;
					techlaser.Timeout = 1;
					techlaser.MaxDistance = math.random(15,45)
					techlaser.CollisionDamage = player.Damage;
				end
			end
			if player:HasCollectible(CollectibleType.COLLECTIBLE_TECH_X) then
				if not data.TechX or data.TechX:IsDead() then
					local circle = player:FireTechXLaser(fam.Position + techXPos, Vector.Zero, 35)
					circle.Timeout = 5;
					data.TechX = circle
				end
			end
		end
		
		--techx code
		if data.TechX then
			data.TechX.Position = fam.Position + techXPos
		end
		
		--butt code
		if spr:IsPlaying("WalkRight") or spr:IsPlaying("ChargeRight") then
			data.Butt.Position = fam.Position + Vector(-25,0)
		elseif spr:IsPlaying("WalkLeft") or spr:IsPlaying("ChargeLeft") then
			data.Butt.Position = fam.Position + Vector(25,0)
		elseif spr:IsPlaying("WalkUp") or spr:IsPlaying("ChargeUp") then
			data.Butt.Position = fam.Position + Vector(0,25)
		elseif spr:IsPlaying("WalkDown") or spr:IsPlaying("ChargeDown") then
			data.Butt.Position = fam.Position + Vector(0,-25)
		end
		data.Butt.Velocity = fam.Velocity
		
		if not data.IsPossessed then
			if data.IsPossessed == nil then
				fam:GetSprite():ReplaceSpritesheet(2, "gfx/effects/bone/corpseeater/none.png")
				fam:GetSprite():ReplaceSpritesheet(3, "gfx/effects/bone/corpseeater/none.png")
				fam:GetSprite():ReplaceSpritesheet(4, "gfx/effects/bone/corpseeater/none.png")
				fam:GetSprite():LoadGraphics()
				data.IsPossessed = false
			end
			--target code
			local target = InutilLib.GetClosestGenericEnemy(fam, 300, _, _, _, _, _, _, true)--, true, 3, 0, false, false)
			
			if not data.DeathFrame then data.DeathFrame = 1800 end
			
			local function Die()
				fam:Kill()
				data.Butt:Kill()
				yandereWaifu.GetEntityData(player).hasLeech = nil
			end
			
			if not yandereWaifu.GetEntityData(player).IsLeftover then
				data.DeathFrame = data.DeathFrame - 1 --i only want this to count down if you are not calling it
				
				if target then
					if target:IsVulnerableEnemy() then
						data.target = target
					end
						
					if data.target then
						local path = InutilLib.GenerateAStarPath(fam.Position, data.target.Position)
						
						if not path then
							FollowParent()
							data.target = nil
						else
							InutilLib.FollowPath(fam, data.target, path, 2, 0.9)
						end
					else
						FollowParent()
						data.target = nil
					end
				else
					FollowParent()
					data.target = nil
				end
			else
				if ILIB.game:GetFrameCount() % 3 == 0 then
					data.toPlayerpath = InutilLib.GenerateAStarPath(fam.Position, player.Position)
				end
				if data.toPlayerpath then
					InutilLib.FollowPath(fam, player, data.toPlayerpath, 4, 0.9)
				end
				
				--avoiding possible softlock, here!
				if yandereWaifu.GetEntityData(player).IsLeftoverFrameLimit == player.FrameCount then
					yandereWaifu.GetEntityData(player).IsLeftover = false
					End()
				end
				if spr:IsEventTriggered("Chomp") --[[and not fam:GetEntityFlags() & EntityFlag.FLAG_CHARM == EntityFlag.FLAG_CHARM]] then
					for i, entities in pairs(Isaac.GetRoomEntities()) do
						if entities.Variant == RebekahCurse.ENTITY_EXTRACHARANIMHELPER then
							if yandereWaifu.GetEntityData(entities).IsLeftover and GetPtrHash(yandereWaifu.GetEntityData(entities).Player) == GetPtrHash(player) then
								if entities.Position:Distance(fam.Position) < entities.Size + fam.Size + 45*leechSize then
									entities:Remove()
							
									for i = 0, 12 do
										local var = TearVariant.BLOOD
										local rng = math.random(1,5)
										if rng == 3 then
											var = TearVariant.BONE
										--elseif rng == 4 then
										--	var = RebekahCurse.ENTITY_RIBTEAR
										--elseif rng == 5 then
										--	var = RebekahCurse.ENTITY_SKULLTEAR
										end
										local tears =  Isaac.Spawn(EntityType.ENTITY_TEAR, var, 0, player.Position, Vector(0,-8):Rotated(math.random(0,360)), player):ToTear()
										InutilLib.MakeTearLob(tears, 1.5, 9 )
									end
									
									if player:HasCollectible(CollectibleType.COLLECTIBLE_DR_FETUS) then
										fam:GetSprite():ReplaceSpritesheet(2, "gfx/effects/bone/corpseeater/corpse_eater_rider_bomb.png")
										fam:GetSprite():ReplaceSpritesheet(3, "gfx/effects/bone/corpseeater/corpse_eater_rider_bomb.png")
									else
										fam:GetSprite():ReplaceSpritesheet(2, "gfx/effects/bone/corpseeater/corpse_eater_rider.png")
										fam:GetSprite():ReplaceSpritesheet(3, "gfx/effects/bone/corpseeater/corpse_eater_rider.png")
									end
									fam:GetSprite():ReplaceSpritesheet(4, "gfx/effects/bone/corpseeater/corpse_hair.png")
									fam:GetSprite():LoadGraphics()
									
									if not yandereWaifu.GetEntityData(player).BoneJockeyTimeLeft or yandereWaifu.GetEntityData(player).BoneJockeyTimeLeft <= 0 then
										yandereWaifu.purchaseReserveStocks(player, 1)									
										yandereWaifu.GetEntityData(player).BoneJockeyTimeLeft = 100
									end
									
									--print(data.IsPossessed)
									data.IsPossessed = true
								end
							end
						end
					end
				end
			end
			--death code
			if data.DeathFrame == 0 then
				Die()
			end
		else
			if fam:GetEntityFlags() & EntityFlag.FLAG_CHARM == EntityFlag.FLAG_CHARM then
				--print("FJDHF")
				player.Visible = false
				yandereWaifu.addReserveStocks(player, 1)
				End()
			end
			fam:GetEntityFlags()
			--color player code
			if yandereWaifu.GetEntityData(player).IsAttackActive then
				player:SetColor(Color(0,0,0,0,0,0,0),3,1,false,false)
				player.Visible = true
			end
			
			local movementDirection = player:GetMovementInput()
			local shootingInput = player:GetShootingInput()
			
			--movement
			local extraSpeed = 0
			if leechSize < 1 then
				extraSpeed = .2
			end
			if not data.Dashing then
				fam.Velocity = (fam.Velocity * 0.9) + movementDirection:Resized( player.MoveSpeed + .5 + extraSpeed)
			end
			player.Velocity = fam.Velocity
			player.Position = fam.Position
			
			if movementDirection then
				data.ATTACK_DASH_DOUBLE_TAP:Update( movementDirection , player );
			end
			
			--doubletap code
			if not data.ATTACK_DASH_DOUBLE_TAP_READY then
				data.ATTACK_DASH_DOUBLE_TAP:AttachCallback( function(vector, playerTapping)
					-- old random velocity code
					-- RandomHeartParticleVelocity()
				if not data.specialCooldown then 
					data.specialCooldown = 0 
					data.specialMaxCooldown = 20 
				end
				if not data.IsDashActive and data.specialCooldown <= 0 then
				--	if yandereWaifu.GetEntityData(player).currentMode == REBECCA_MODE.RedHearts then --IF RED HEART MODE
								
						fam.Velocity = fam.Velocity + vector:Resized( REBEKAH_BALANCE.BONE_HEARTS_BONE_JOCKEY_DASH_SPEED );
									
						yandereWaifu.SpawnDashPoofParticle( player.Position, Vector(0,0), player, RebekahPoofParticleType.Red );

				--		playerdata.specialCooldown = REBEKAH_BALANCE.RED_HEARTS_DASH_COOLDOWN - trinketBonus;
				--		playerdata.invincibleTime = REBEKAH_BALANCE.RED_HEARTS_DASH_INVINCIBILITY_FRAMES;
						InutilLib.SFX:Play( SoundEffect.SOUND_MONSTER_ROAR_0, 1, 0, false, 1 );
						data.IsDashActive = true
						
						data.Dashing = true --this sets you off to a direction, chomping fast while you cant control yourself
						data.DashVector = vector
						data.StopDashFrame = fam.FrameCount + 10
						
						data.specialCooldown = data.specialMaxCooldown
				--	end
					end
				end)
				data.ATTACK_DASH_DOUBLE_TAP_READY = true
			end
			--cooldown countdown thing
			if data.specialCooldown then
				if data.specialCooldown > 0 then data.specialCooldown = data.specialCooldown - 1 end
			end
			if data.Dashing then
				--dr fetus stuff
				if player:HasCollectible(CollectibleType.COLLECTIBLE_DR_FETUS) and fam.FrameCount % 2 == 0 then
					local bomb = player:FireBomb( player.Position , Vector.Zero):ToBomb()
					bomb.Position = player.Position
					bomb:SetExplosionCountdown(0)
					bomb.IsFetus = true
					bomb.RadiusMultiplier = 0.5
				end
				
				if player:HasCollectible(CollectibleType.COLLECTIBLE_BRIMSTONE) then
					if not data.BrimstoneHorns or data.BrimstoneHorns:IsDead() then
						local beam = player:FireBrimstone( Vector.FromAngle(movementDirection:GetAngleDegrees() - 45), fam, 2):ToLaser();
						beam.Timeout = 5
						beam.MaxDistance = 25
						data.BrimstoneHorns = beam
						local beam2 = player:FireBrimstone( Vector.FromAngle(movementDirection:GetAngleDegrees() + 45), fam, 2):ToLaser();
						beam2.MaxDistance = 25
						beam2.Timeout = 5
					end
				end
				fam.Velocity = data.DashVector:Resized( REBEKAH_BALANCE.BONE_HEARTS_BONE_JOCKEY_CONTINUOUS_DASH_SPEED);
				if not InutilLib.IsPlayingMultiple(spr, "ChargeRight", "ChargeDown", "ChargeUp", "ChargeLeft") then
					data.Angle = InutilLib.AnimShootFrame(fam, true, fam.Velocity, "ChargeRight", "ChargeDown", "ChargeUp", "ChargeLeft")
				end
				
				for i, entities in pairs(Isaac.GetRoomEntities()) do
					if entities:IsVulnerableEnemy() then
						if entities.Position:Distance(fam.Position) < entities.Size + fam.Size + 30 then
							entities:TakeDamage((player.Damage / 5)+extraDmg, 0, EntityRef(fam), 1)
							data.BloodyMouthCount = 30
							
						end
					end
				end
			end
			
			--dashactive code
			if data.IsDashActive then
				if fam:CollidesWithGrid() or (fam.FrameCount == data.StopDashFrame) then
				--if not data.DashActiveFrame then data.DashActiveFrame = REBEKAH_BALANCE.BONE_HEARTS_BONE_JOCKEY_DASH_COOLDOWN_FRAME end
				--print(data.DashActiveFrame)
				--if data.DashActiveFrame > 0 then
				--	data.DashActiveFrame = data.DashActiveFrame - 1
				--elseif data.DashActiveFrame == 0 then
					data.IsDashActive = false
					data.Dashing = false
					data.DashActiveFrame = nil --to reset
				end
			end
			
			--firing
			if (shootingInput.X ~= 0 or shootingInput.Y ~= 0) then
				if player:HasCollectible(CollectibleType.COLLECTIBLE_MARKED) then
					shootingInput = player:GetAimDirection()
				end
				if fam.FrameCount % (math.ceil(player.MaxFireDelay/2)) == 0 then
					local tears = player:FireTear(fam.Position, shootingInput:Resized(15), false, false, false):ToTear()
					tears.Position = fam.Position
					tears:ChangeVariant(TearVariant.BONE)
					if math.random(1,8) == 8 and player:HasCollectible(CollectibleType.COLLECTIBLE_EPIC_FETUS) then --epic fetus synergy
						local target = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_BONETARGET, 0, fam.Position, Vector(0,0), fam)
						yandereWaifu.GetEntityData(target).Player = player
						yandereWaifu.GetEntityData(target).SummonEpic = true
					end
				end
			end
			
			--reserve usage
			if fam.FrameCount % 5 == 0 then
				--[[if yandereWaifu:getReserveFill(player) <= 0 then
					--yandereWaifu:addReserveStocks(player, -1)
					if yandereWaifu:getReserveStocks(player) > 0 then
						yandereWaifu:addReserveFill(player, yandereWaifu.GetEntityData(player).heartReserveMaxFill)
						yandereWaifu:purchaseReserveStocks(player, 1)
					end]]
				if not yandereWaifu.GetEntityData(player).BoneJockeyTimeLeft then
					yandereWaifu.GetEntityData(player).BoneJockeyTimeLeft = 100
				else
					yandereWaifu.GetEntityData(player).BoneJockeyTimeLeft = yandereWaifu.GetEntityData(player).BoneJockeyTimeLeft- 1
				end
				
				--removed
				
				--[[if Input.IsActionPressed(ButtonAction.ACTION_PILLCARD, player.ControllerIndex) then
					End()
				end]]
				if--[[ yandereWaifu:getReserveStocks(player) <= 0 and]] yandereWaifu.GetEntityData(player).BoneJockeyTimeLeft <= 0 then --automatic end
					End()
				end
			end
			
			--spear code
			if player:HasWeaponType(WeaponType.WEAPON_KNIFE) then
				if not data.JockeySpear or data.JockeySpear:IsDead() then
					spear = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_BONESPEAR, 0, player.Position, Vector(0,0), player):ToEffect();
					yandereWaifu.GetEntityData(spear).PermanentAngle = movementDirection:GetAngleDegrees() + 90
					yandereWaifu.GetEntityData(spear).Player = player
					yandereWaifu.GetEntityData(spear).IsJockeySpear = true
					data.JockeySpear = spear
				end
			end
			
			
			if data.JockeySpear then
				
				if not data.SpearCharge then
					data.MaxSpearCharge = player.MaxFireDelay*2
					data.SpearCharge = 0
				end
				if (shootingInput.X ~= 0 or shootingInput.Y ~= 0) then
					yandereWaifu.GetEntityData(spear).PermanentAngle = shootingInput:GetAngleDegrees() + 90
					
					data.lastFireDir = shootingInput
					
					--charging code
					if data.SpearCharge < data.MaxSpearCharge then
						data.SpearCharge = data.SpearCharge + 1
					end
				else
					if not data.lastFireDir then data.lastFireDir = data.lastDir end
					yandereWaifu.GetEntityData(spear).PermanentAngle = data.lastFireDir:GetAngleDegrees() + 90
					if data.SpearCharge >= data.MaxSpearCharge then
						data.JockeySpear:GetSprite():Play("Stab", true)
						data.SpearCharge = 0
					else
						data.SpearCharge = 0
					end
				end
			end
			
			
			--entering room code
			local doorPosCheck
			if spr:IsPlaying("WalkRight") or spr:IsPlaying("ChargeRight") then
				doorPosCheck = fam.Position - Vector(-25,0)
			elseif spr:IsPlaying("WalkLeft") or spr:IsPlaying("ChargeLeft") then
				doorPosCheck = fam.Position - Vector(25,0)
			elseif spr:IsPlaying("WalkUp") or spr:IsPlaying("ChargeUp") then
				doorPosCheck = fam.Position - Vector(0,25)
			elseif spr:IsPlaying("WalkDown") or spr:IsPlaying("ChargeDown") then
				doorPosCheck = fam.Position - Vector(0,-25)
			end
			if fam:CollidesWithGrid() then
				--for i = 0, (ILIB.room:GetGridSize()) do
					local gent = ILIB.room:GetGridEntity(ILIB.room:GetGridIndex(doorPosCheck))
					if gent then
						if gent.Desc.Type == GridEntityType.GRID_DOOR then
							--Isaac.DebugString(gent.Desc.Type)
							local Door = gent:ToDoor()
							if (fam.Position - Door.Position):Length() <= 35 then
								--Isaac.DebugString(1)
								if ILIB.room:IsClear() then
									Door:TryUnlock(player)
								end
								--Isaac.DebugString(2)
								if Door and Door:IsOpen() then
									player.Position = Door.Position
								elseif Door and not Door:IsOpen() then

								end
							end
						end 
					end
				--end
			end
		end
	elseif fam.SubType == 1 then
		if yandereWaifu.GetEntityData(fam).Head == nil then fam:Remove() end
		if not yandereWaifu.GetEntityData(yandereWaifu.GetEntityData(fam).Head).IsPossessed then
			InutilLib.AnimShootFrame(fam, false, fam.Velocity, "BodyWalkRight", "BodyWalkDown", "BodyWalkUp", "BodyWalkLeft")
		else
			local lastDir 
				
			if (player:GetMovementInput().X ~= 0 or player:GetMovementInput().Y ~= 0) then
				lastDir = player:GetMovementInput()
			else
				if not data.lastDir then data.lastDir = Vector(1,0) end
				lastDir = data.lastDir
			end
			data.lastDir = lastDir
			InutilLib.AnimShootFrame(fam, false, lastDir or Vector(1,0), "BodyWalkRight", "BodyWalkDown", "BodyWalkUp", "BodyWalkLeft")
		end
	elseif fam.SubType == 10 then
		leechSize = 0.5
		if not data.ParentLeech then data.ParentLeech= yandereWaifu.GetEntityData(player).hasLeech end
		local function FollowParentAsBaby()
			local path = InutilLib.GenerateAStarPath(fam.Position, data.ParentLeech.Position)
			
			if (fam.Position - data.ParentLeech.Position):Length() > 25 then
				InutilLib.FollowPath(fam, data.ParentLeech, path, 2 + data.VarySpeed, 0.9)
			else
				if fam.FrameCount % 35 == 0 then
					data.MoveDir = Isaac.GetRandomPosition()
				end
				if data.MoveDir then
					InutilLib.MoveRandomlyTypeI(fam, data.MoveDir, 1.2 + data.VarySpeed, 0.9, 0, 0, 0)
				end
			end
		end
		--render code
		if fam.Velocity then
			if spr:IsFinished("Appear") then
				data.Angle = InutilLib.AnimShootFrame(fam, true, fam.Velocity, "WalkRight", "WalkDown", "WalkUp", "WalkLeft")
			end
			if not InutilLib.IsPlayingMultiple(spr, "ChargeRight", "ChargeDown", "ChargeUp", "ChargeLeft") then 
				data.Angle = InutilLib.AnimShootFrame(fam, false, fam.Velocity, "WalkRight", "WalkDown", "WalkUp", "WalkLeft")
			end
		end
		--target code
		local target = InutilLib.GetClosestGenericEnemy(fam, 300, _, _, _, _, _, _, true)--, true, 3, 0, false, false)
		
		if target then
			if target:IsVulnerableEnemy() then
				data.target = target
			end
						
			if data.target then
				local path = InutilLib.GenerateAStarPath(fam.Position, data.target.Position)
				
				if not path then
					FollowParentAsBaby()
					data.target = nil
				else
					InutilLib.FollowPath(fam, data.target, path, 2 + data.VarySpeed, 0.9)
				end
			else
				FollowParentAsBaby()
				data.target = nil
			end
		else
			FollowParentAsBaby()
			data.target = nil
		end

		--chomp code
		if spr:IsEventTriggered("Chomp") then
			for i, entities in pairs(Isaac.GetRoomEntities()) do
				if entities:IsVulnerableEnemy() then
					if entities.Position:Distance(fam.Position) < entities.Size + fam.Size + 35*leechSize then
						entities:TakeDamage(player.Damage * 0.6, 0, EntityRef(fam), 1)
					end
				end
			end
		end
		--death code
		if data.ParentLeech == nil or data.ParentLeech:IsDead() then
			fam:Kill()
		end
	end
	
	fam.SpriteScale = Vector(leechSize, leechSize)
	
end, RebekahCurse.ENTITY_BONEJOCKEY);


--firing random stuff
function yandereWaifu:BoneHeartTearsRender(tr, _)
	if tr.Variant == RebekahCurse.ENTITY_RIBTEAR or tr.Variant == RebekahCurse.ENTITY_SKULLTEAR or tr.Variant == RebekahCurse.ENTITY_HEARTTEAR then
		local player, data, flags, scale = tr.SpawnerEntity:ToPlayer(), yandereWaifu.GetEntityData(tr), tr.TearFlags, tr.Scale 
		local size = InutilLib.GetTearSizeTypeII(scale, flags)
		InutilLib.UpdateDynamicTearAnimation(player, tr, data, flags, "Stone", {"Move", "Idle"}, size)
	end
	--punch tear render
	if tr.Variant == RebekahCurse.ENTITY_RAPIDPUNCHTEAR and not yandereWaifu.GetEntityData(tr).Init then
		local rng = math.random(1,3)
		data.type = data.type or "a"
		tr:GetSprite():Play("Fist"..tostring(rng)..tostring(data.type))
		yandereWaifu.GetEntityData(tr).Init = true
		
		--initial angle as well
		local angleNum = (tr.Velocity):GetAngleDegrees();
		tr.SpriteRotation = angleNum;
		tr:GetData().Rotation = tr:GetSprite().Rotation
	end
	--print(tr.SpawnerEntity.Variant, "  ", tr.SpawnerVariant, FamiliarVariant.INCUBUS)
end
yandereWaifu:AddCallback(ModCallbacks.MC_POST_TEAR_RENDER, yandereWaifu.BoneHeartTearsRender)

function yandereWaifu:FistTearsUpdate(tr)
	tr = tr:ToTear()
	if tr.Variant == RebekahCurse.ENTITY_RAPIDPUNCHTEAR then
		local angleNum = (tr.Velocity):GetAngleDegrees();
		tr.SpriteRotation = angleNum;
		tr:GetData().Rotation = tr:GetSprite().Rotation;
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, yandereWaifu.FistTearsUpdate)

function yandereWaifu:BoneHeartTearsUpdate(tr)
	local data = yandereWaifu.GetEntityData(tr)
	local player = tr.Parent
	tr = tr:ToTear()
	if tr.Variant == RebekahCurse.ENTITY_RIBTEAR then
		local chosenNumofBarrage =  math.random( 2, 4 );
		for i = 1, chosenNumofBarrage do
			local tear = game:Spawn( EntityType.ENTITY_TEAR, TearVariant.BONE, tr.Position, Vector.FromAngle( math.random() * 360 ):Resized(REBEKAH_BALANCE.GOLD_HEARTS_DASH_ATTACK_SPEED), tr, 0, 0):ToTear()
			tear.TearFlags = tear.TearFlags | TearFlags.TEAR_BONE
			tear.Scale = (tr.Scale) - math.random(4,8)/10;
			InutilLib.MakeTearLob(tear, 1.5, 9 );
		end
	elseif tr.Variant == RebekahCurse.ENTITY_SKULLTEAR then
		local chosenNumofBarrage =  math.random( 1, 3 );
		for i = 1, chosenNumofBarrage do
			local tear = game:Spawn( EntityType.ENTITY_TEAR, TearVariant.TOOTH, tr.Position, Vector.FromAngle( math.random() * 360 ):Resized(REBEKAH_BALANCE.GOLD_HEARTS_DASH_ATTACK_SPEED), tr, 0, 0):ToTear()
			tear.TearFlags = tear.TearFlags | TearFlags.TEAR_BONE
			tear.Scale = (tr.Scale/2) - math.random(1,5)/10;
			InutilLib.MakeTearLob(tear, 1.5, 9 );
			--tear.CollisionDamage = player:ToPlayer().Damage * 1.5
		end
	elseif tr.Variant == RebekahCurse.ENTITY_HEARTTEAR then
		local chosenNumofBarrage =  math.random( 3, 6 );
		for i = 1, chosenNumofBarrage do
			local tear = game:Spawn( EntityType.ENTITY_TEAR, TearVariant.BLOOD, tr.Position, Vector.FromAngle( math.random() * 360 ):Resized(3), tr, 0, 0):ToTear()
			tear.TearFlags = tear.TearFlags | TearFlags.TEAR_BONE
			tear.Scale = (tr.Scale) - math.random(1,5)/10;
			InutilLib.MakeTearLob(tear, 1.5, 9 );
			local puddle = game:Spawn( EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_RED, tr.Position, Vector(0,0), tr, 0, 0):ToEffect()
			puddle.Scale = math.random(12,14)/10
			puddle:PostRender()
		end
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, yandereWaifu.BoneHeartTearsUpdate, EntityType.ENTITY_TEAR)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, function(_,tear)
    local parent, spr, data = tear.Parent, tear:GetSprite(), yandereWaifu.GetEntityData(tear)
    local player = parent:ToPlayer()
	local lobHeight = math.floor((player:ToPlayer().TearHeight/2)*-1)
    if parent.Type == EntityType.ENTITY_FAMILIAR and parent.Variant == FamiliarVariant.INCUBUS then
      player = parent:ToFamiliar().Player
    end
    if currentMode == REBECCA_MODE.BoneHearts then
		if math.random(1,2) == 2 then
			local rng = math.random(1,10)
			if rng > 0 and rng < 5 then
				tear:ChangeVariant(TearVariant.BONE)
			elseif rng > 4 and rng < 8 then
				tear:ChangeVariant(TearVariant.TOOTH)
				tear.CollisionDamage = player.Damage * 2;
			elseif rng == 8 then
				tear:ChangeVariant(ENTITY_SKULLTEAR)
				InutilLib.MakeTearLob(tear, 1.5, lobHeight );
				tear.CollisionDamage = player.Damage * 2.5
			elseif rng == 9 then
				tear:ChangeVariant(ENTITY_RIBTEAR)
				InutilLib.MakeTearLob(tear, 1.5, lobHeight );
			else
				tear:ChangeVariant(ENTITY_HEARTTEAR)
				InutilLib.MakeTearLob(tear, 1.5, lobHeight );
			end
		end
    end
end)

--bone heart attack effect
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local sprite = eff:GetSprite();
	local room =  Game():GetRoom();
	local data = yandereWaifu.GetEntityData(eff);
	local player = data.Player
    local roomClampSize = math.max( player.Size, 20 );
	--movement code
	eff.GridCollisionClass =  EntityGridCollisionClass.GRIDCOLL_NOPITS 
	
	--[[local movementDirection = player:GetMovementInput();
	if movementDirection:Length() < 0.05 then
		eff.Velocity = eff.Velocity * 0.3;
		player.Position = room:GetClampedPosition(eff.Position, roomClampSize);
		player.Velocity = eff.Velocity;
	else
		eff.Velocity = (eff.Velocity * 0.7) + movementDirection:Resized( REBEKAH_BALANCE.BONE_HEARTS_DASH_TARGET_SPEED );
	end]]
	
	--function code
	--player.Velocity = (room:GetClampedPosition(eff.Position, roomClampSize) - player.Position)*0.5;
	if data.SummonEpic then
		local target = InutilLib.GetClosestGenericEnemy(eff, 300)--, true, 3, 0, false, false)
		
		if target then
			if target:IsVulnerableEnemy() then
				InutilLib.MoveDirectlyTowardsTarget(eff, target, 0.8, 0.9)
			end
		end
	end
	if data.FinishedLeech then
		eff.Velocity = player:GetMovementInput():Resized(20)
		player.Position = eff.Position
		player.Visible = false
	end
	if eff.FrameCount == 1 then
		sprite:Play("Idle", true)
		--player.ControlsEnabled = false
	elseif sprite:IsFinished("Idle") then
		sprite:Play("Blink",true)
		--player.Visible = false
	elseif eff.FrameCount == 55 then
		if data.SummonEpic then
			local customBody = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_EPICBONE, 0, eff.Position, Vector(0,0), eff)
			yandereWaifu.GetEntityData(customBody).Player = data.Player
			eff:Remove()
		end
		if data.FinishedLeech then
			eff:Remove()
			local customBody = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_EXTRACHARANIMHELPER, 0, eff.Position, Vector(0,0), nil) --body effect
			yandereWaifu.GetEntityData(customBody).Player = player
			yandereWaifu.GetEntityData(customBody).DontFollowPlayer = true
			yandereWaifu.GetEntityData(customBody).BoneJumpDownFromJockey = true
		end
		--[[if REBEKAH_BALANCE.SOUL_HEARTS_DASH_RETAINS_VELOCITY == false then
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
		player.GridCollisionClass = data.LastGridCollisionClass;
		eff:Remove()
		local customBody = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_EXTRACHARANIMHELPER, 0, eff.Position, Vector(0,0), eff)
		yandereWaifu.GetEntityData(customBody).IsSlamming = true
		yandereWaifu.GetEntityData(customBody).Player = player
		customBody.Visible = false
		player.Visible = false
		yandereWaifu.SpawnHeartParticles( 1, 1, eff.Position, yandereWaifu.RandomHeartParticleVelocity(), player, RebekahHeartParticleType.Bone );]]
	end
	--[[if eff.FrameCount < 55 then
		player.Velocity = Vector(0,0)
	end]]
end, RebekahCurse.ENTITY_BONETARGET)



--slamdust effect
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local player = Isaac.GetPlayer(0)
	local sprite = eff:GetSprite()
	local data = yandereWaifu.GetEntityData(eff)
	
	if eff.FrameCount == 1 then
		sprite:Play("Slam", true) --normal attack
	elseif sprite:IsFinished("Slam") then
		eff:Remove()
	end
	
end, RebekahCurse.ENTITY_SLAMDUST)

end

--remove knife if in worm LMAO
yandereWaifu:AddCallback(ModCallbacks.MC_POST_KNIFE_UPDATE, function(_, kn)
	local data = yandereWaifu.GetEntityData(kn)
	local player = kn.SpawnerEntity
	if player.Type == 1 then
		local playerdata = yandereWaifu.GetEntityData(player)
		if playerdata.currentMode == REBECCA_MODE.BoneHearts and playerdata.IsLeftover then
			kn:Remove()
		end
	end
end)