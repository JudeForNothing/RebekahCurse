
local giant = Sprite()
giant:Load("gfx/characters/big_rebekah.anm2",true)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, function(_,player, offset)
	local data = GetEntityData(player)
	
	if data.IsThicc == true then
		--print("fire")
		--giant:SetOverlayRenderPriority(true)
		--giant:Play("HeadDown", true)
		--local playerLocation = Isaac.WorldToScreen(player.Position)
		--print(SchoolbagAPI.IsInMirroredFloor(player))
		if not SchoolbagAPI.IsInMirroredFloor(player) then
		--	giant:Render(playerLocation, Vector(0,0), Vector(0,0))
		end
	end
end)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function(_,player)
	--local player = Isaac.GetPlayer(0);
    local room = Game():GetRoom();
	local data = GetEntityData(player)
	--items function!
	if player:HasCollectible(COLLECTIBLE_LUNCHBOX) and SchoolbagAPI.HasJustPickedCollectible( player, COLLECTIBLE_LUNCHBOX ) then
		for i = 0, 2, 1 do
			local spawnPosition = room:FindFreePickupSpawnPosition(player.Position, 1);
			local newpickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, MirrorHeartDrop[math.random(1,6)], spawnPosition, Vector(0,0), player)
		end
		player:AddNullCostume(LunchboxCos)
	end
	if player:HasCollectible(COLLECTIBLE_POWERLOVE) and SchoolbagAPI.HasJustPickedCollectible( player, COLLECTIBLE_POWERLOVE) then
		player:AddNullCostume(LovePower)
	end
	--love = Power
	local H = player:GetHearts()
	if player:HasCollectible(COLLECTIBLE_POWERLOVE) then
		if data.H ~= H then
			player:AddCacheFlags(CacheFlag.CACHE_DAMAGE);
			player:AddCacheFlags(CacheFlag.CACHE_SPEED);
			player:EvaluateItems()
		end
		data.H = H
	elseif not player:HasCollectible(COLLECTIBLE_POWERLOVE) and data.H then
		data.H = nil
		player:AddCacheFlags(CacheFlag.CACHE_DAMAGE);
		player:AddCacheFlags(CacheFlag.CACHE_SPEED);
		player:EvaluateItems()
	end
	--cursed spoon
	if player:HasCollectible(COLLECTIBLE_CURSEDSPOON) and SchoolbagAPI.HasJustPickedCollectible( player, COLLECTIBLE_CURSEDSPOON) then
		player:AddNullCostume(CursedMawCos)
	end
	--typical rom-command
	if player:HasCollectible(COLLECTIBLE_ROMCOM) then
		if SchoolbagAPI.ConfirmUseActive( player, COLLECTIBLE_ROMCOM ) then
			local vector = SchoolbagAPI.DirToVec(player:GetFireDirection())
			data.specialAttackVector = Vector( vector.X, vector.Y )
			SchoolbagAPI.ConsumeActiveCharge(player)
			SchoolbagAPI.ToggleShowActive(player, false)
			
			local rng = math.random(1,5)
			yandereWaifu:DoExtraBarrages(player, rng)
		end
	end
	--lovesick
	if player:HasCollectible(COLLECTIBLE_LOVESICK) then
		if SchoolbagAPI.HasJustPickedCollectible( player, COLLECTIBLE_LOVESICK) then
			player:AddNullCostume(LoveSickCos)
		end
		if Isaac.GetFrameCount() % 120 == 0 then
			SpawnHeartParticles( 1, 3, player.Position, RandomHeartParticleVelocity(), player, HeartParticleType.Red );
			local fart = Isaac.Spawn(EntityType.ENTITY_EFFECT, ENTITY_PHEROMONES_RING, 0, player.Position, Vector(0,0), player)
			GetEntityData(fart).Player = player
		end
	end
	--snap
	if player:HasCollectible(COLLECTIBLE_SNAP) then
		if SchoolbagAPI.HasJustPickedCollectible( player, COLLECTIBLE_SNAP) then
			player:AddNullCostume(UnsnappedCos)
		end
		local maxH, H = player:GetMaxHearts(), player:GetHearts()
		local ratioH
		if maxH - H == 0 then ratioH = 1 else ratioH = maxH - H end
		if H <= 2 then
			if not data.hasSnap then
				local fart = Isaac.Spawn(EntityType.ENTITY_EFFECT, ENTITY_SNAP_EFFECT, 0, player.Position, Vector(0,0), player)
				player:AnimateSad()
				
				player:AddNullCostume(SnappedCos)
				player:TryRemoveNullCostume(UnsnappedCos)
			end
			data.hasSnap = true
		else
			if data.hasSnap == true then
				data.hasSnap = false
				
				player:AddNullCostume(UnsnappedCos)
				player:TryRemoveNullCostume(SnappedCos)
			end
		end
		local modulusF = (math.floor(240/ratioH))
		if data.hasSnap then modulusF = 10 end
		--print(player.FireDelay.."  "..data.SnapDelay)
		if Isaac.GetFrameCount() % modulusF == 0 then
			local fart = Isaac.Spawn(EntityType.ENTITY_EFFECT, ENTITY_SNAP_HEARTBEAT, 0, player.Position, Vector(0,0), player)
			GetEntityData(fart).Snap = data.hasSnap
		end
		if (math.random(1,30)) >= 30 then
			if player.FireDelay > 0 and data.hasSnap then
				data.SnapDelay = math.random(math.floor(player.MaxFireDelay/3), player.MaxFireDelay/2)
				player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY);
				player:EvaluateItems()
			end
		end
	end
	--unrequited love
	if player:HasCollectible(COLLECTIBLE_UNREQUITEDLOVE) then
		if SchoolbagAPI.ConfirmUseActive( player, COLLECTIBLE_UNREQUITEDLOVE ) then
			local vector = SchoolbagAPI.DirToVec(player:GetFireDirection())
			local hook = Isaac.Spawn(EntityType.ENTITY_EFFECT, ENTITY_LOVEHOOK, 0, player.Position, vector:Resized(45), player)
			hook.RenderZOffset = -10000;
			GetEntityData(hook).Player = player
			SchoolbagAPI.ConsumeActiveCharge(player)
			SchoolbagAPI.ToggleShowActive(player, false)
			
		end
	end
	--yandereWaifu:EctoplasmLeaking(player) 
end)



----------
--ITEMS!--
----------
--Miraculous Womb Fams--

function yandereWaifu:EsauInit(fam)
    local sprite = fam:GetSprite()
    sprite:Play("FloatDown", true)
	fam.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
	fam:AddToOrbit(50)
	
	local data = GetEntityData(fam)
	data.Stat = {
		FireDelay = 25,
		MaxFireDelay = 25,
		Damage = 4.2, 
		PlayerMaxDelay = 0
	}
end
yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, yandereWaifu.EsauInit, ENTITY_ORBITALESAU);

yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_,  fam) 
    local spr = fam:GetSprite()
	local data = GetEntityData(fam)
	local player = fam.Player
	player:ToPlayer()
	
	fam.OrbitDistance = Vector(20, 20)
	fam.OrbitAngleOffset = fam.OrbitAngleOffset+0.06
	fam.Velocity = fam:GetOrbitPosition(player.Position+player.Velocity) - fam.Position
	
	if data.Stat.FireDelay > 0 then data.Stat.FireDelay = data.Stat.FireDelay - 1 end
	
	local playerDir = player:GetFireDirection()
	if playerDir > -1 then
		SchoolbagAPI.AnimShootFrame(fam, true, SchoolbagAPI.DirToVec(playerDir), "FloatShootSide", "FloatShootDown", "FloatShootUp")
		--if firedelay is ready then
		if data.Stat.FireDelay <= 0 then
			local tears = player:FireTear(fam.Position, SchoolbagAPI.DirToVec(playerDir), false, false, false):ToTear()
			tears.Position = fam.Position
			tears.CollisionDamage = data.Stat.Damage * player.Damage
			data.Stat.FireDelay = data.Stat.MaxFireDelay
		end
		
		if data.Stat.PlayerMaxDelay ~= player.MaxFireDelay then --balance purposes. They are so broken if I don't do this
			data.Stat.MaxFireDelay = 25 + player.MaxFireDelay/2
			data.Stat.PlayerMaxDelay = player.MaxFireDelay
		end
	else
		spr:Play("FloatDown", true)
	end
	
end, ENTITY_ORBITALESAU);

function yandereWaifu:JacobInit(fam)
    local sprite = fam:GetSprite()
    sprite:Play("FloatDown", true)
	fam.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
	fam:AddToOrbit(50)
	
	local data = GetEntityData(fam)
	data.Stat = {
		FireDelay = 6,
		MaxFireDelay = 6,
		Damage = 2, 
		PlayerMaxDelay = 0
	}
end
yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, yandereWaifu.JacobInit, ENTITY_ORBITALJACOB);

yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_,  fam) 
    local spr = fam:GetSprite()
	local data = GetEntityData(fam)
	local player = fam.Player
	player:ToPlayer()
	
	fam.OrbitDistance = Vector(20, 20)
	fam.OrbitAngleOffset = fam.OrbitAngleOffset+0.06
	fam.Velocity = fam:GetOrbitPosition(player.Position+player.Velocity) - fam.Position
	
	if data.Stat.FireDelay > 0 then data.Stat.FireDelay = data.Stat.FireDelay - 1 end
	
	local playerDir = player:GetFireDirection()
	if playerDir > -1 then
		SchoolbagAPI.AnimShootFrame(fam, true, SchoolbagAPI.DirToVec(playerDir), "FloatShootSide", "FloatShootDown", "FloatShootUp")
		--if firedelay is ready then
		if data.Stat.FireDelay <= 0 then
			local tears = player:FireTear(fam.Position, SchoolbagAPI.DirToVec(playerDir), false, false, false):ToTear()
			tears.Position = fam.Position
			tears.CollisionDamage = player.Damage - data.Stat.Damage
			data.Stat.FireDelay = data.Stat.MaxFireDelay
		end
		if data.Stat.PlayerMaxDelay ~= player.MaxFireDelay then --balance purposes. They are so broken if I don't do this
			data.Stat.MaxFireDelay = 6 + player.MaxFireDelay/4
			data.Stat.PlayerMaxDelay = player.MaxFireDelay
		end
	else
		spr:Play("FloatDown", true)
	end
	
end, ENTITY_ORBITALJACOB);
 
--ETERNAL BOND--
function yandereWaifu:TinyBeccaInit(fam)
	if fam.Variant == ENTITY_TINYBECCA then --Rebecca--
		local sprite = fam:GetSprite()
		local data = GetEntityData(fam)
		sprite:Play("StandingVert", true)
		fam.GridCollisionClass =  EntityGridCollisionClass.GRIDCOLL_GROUND;
		fam.EntityCollisionClass =  EntityCollisionClass.ENTCOLL_NONE;
		fam:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
		fam:AddEntityFlags(EntityFlag.FLAG_PERSISTENT)
		data.Stat = {
			FireDelay = 14,
			MaxFireDelay = 14,
			Damage = 1.77, 
			PlayerMaxDelay = 0,
			Wallet = 0,
			Mode = 0
		}
	end
	if fam.Variant == ENTITY_TINYISAAC then --Isaac--
		local sprite = fam:GetSprite()
		local data = GetEntityData(fam)
		sprite:Play("StandingVert", true)
		fam.GridCollisionClass =  EntityGridCollisionClass.GRIDCOLL_GROUND;
		fam.EntityCollisionClass =  EntityCollisionClass.ENTCOLL_NONE;
		fam:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
		fam:AddEntityFlags(EntityFlag.FLAG_PERSISTENT)
		data.Stat = {
			FireDelay = 14,
			MaxFireDelay = 14,
			Damage = 3, 
			PlayerMaxDelay = 0,
			Wallet = 0
		}
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_POST_NPC_INIT, yandereWaifu.TinyBeccaInit, ENTITY_TINYFELLOW);

yandereWaifu:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_,  iss) 
	local spr = iss:GetSprite()
	local data = GetEntityData(iss)
	local player = GetEntityData(iss).Parent
	local room = game:GetRoom()
	if iss.Variant == ENTITY_TINYBECCA then
		--bffs! synergy
		local extra = 0
		if player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
			extra = 2
			iss.Scale = 1.5
		else
			iss.Scale = 1
		end
		
		player:ToPlayer()
		if not player:HasCollectible(COLLECTIBLE_ETERNALBOND) then
			iss:Remove()
		end
		if not spr:IsPlaying("Drop") and not spr:IsPlaying("Rage") then
			SchoolbagAPI.AnimWalkFrame(iss, true, "WalkHori", "WalkVert")
		end
		if data.Stat.FireDelay > 0 then data.Stat.FireDelay = data.Stat.FireDelay - 1 end
		if spr:IsEventTriggered("Drop") then
			if player:GetPlayerType() == PlayerType.PLAYER_KEEPER then
				local newpickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, 0, iss.Position, iss.Velocity, iss)
			elseif player:GetPlayerType() == PlayerType.PLAYER_AZAZEL or player:GetPlayerType() == PlayerType.PLAYER_LILITH then
				local newpickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, 6, iss.Position, iss.Velocity, iss)
			elseif player:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN then
				local newpickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, 11, iss.Position, iss.Velocity, iss)
			else
				local tbl = {
					[1] = 3,
					[2] = 8
				}
				local newpickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, tbl[math.random(1,2)], iss.Position, iss.Velocity, iss)
			end
		end
		
		--iss.Velocity = player.Velocity * 0.8
		local enemy = SchoolbagAPI.GetClosestGenericEnemy(iss, 500, iss.Type)
		if data.Stat.Mode == 0 then
			if enemy and not enemy:IsDead() and enemy ~= nil and enemy.Type ~= EntityType.ENTITY_FIREPLACE and enemy:IsActiveEnemy() and  enemy:IsVulnerableEnemy() then
				if not data.specialAttackVector then  data.specialAttackVector = (enemy.Position - iss.Position) end
				if enemy.Position:Distance(iss.Position) > 100 then
					SchoolbagAPI.XalumMoveTowardsTarget(iss, enemy, 6, 0.9, false)
				else
					if Isaac.GetFrameCount() % 400 == 0 then
						yandereWaifu:DoTinyBarrages(iss, data.specialAttackVector)
					else
						SchoolbagAPI.MoveAwayFromTarget(iss, enemy, 4, 0.9)
						if data.Stat.FireDelay <= 0 then
							local tears =  Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0, iss.Position + Vector(0,-3):Rotated(data.specialAttackVector:GetAngleDegrees()), (enemy.Position - iss.Position):Resized(12), player):ToTear()
							tears.Scale = 0.3 + iss.Scale/2
							tears.CollisionDamage = data.Stat.Damage + extra/2
							local tears2 =  Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0, iss.Position + Vector(0,3):Rotated(data.specialAttackVector:GetAngleDegrees()), (enemy.Position - iss.Position):Resized(12), player):ToTear()
							tears2.Scale = 0.3 + iss.Scale/2
							tears2.CollisionDamage = data.Stat.Damage + extra/2
							data.Stat.FireDelay = data.Stat.MaxFireDelay
						end
					end
				end
				data.specialAttackVector = nil
			else
				local nearPickup, pos = SchoolbagAPI.GetClosestPickup(iss, 400, 10, -1)
				if nearPickup and (nearPickup.SubType == 1 or nearPickup.SubType == 2 or nearPickup.SubType == 9 ) then
					SchoolbagAPI.XalumMoveTowardsTarget(iss, nearPickup, 6, 0.9, false)
					if (nearPickup.Position-iss.Position):Length() < 5 and not nearPickup.Touched then
						local picked = SchoolbagAPI.PickupPickup(nearPickup)
						--print(data.Stat.Wallet.."   "..picked.Subtype)
						picked = picked:ToPickup()
						local earned = 0
						if picked.SubType == 1 or picked.SubType == 9 then
							earned = 2
						elseif picked.SubType == 2 then
							earned = 1
						end
						data.Stat.Wallet = data.Stat.Wallet + earned
					end
				else
					if data.Stat.Wallet > 4 and (not spr:IsPlaying("Drop") and not spr:IsPlaying("Rage")) then
						data.Stat.Wallet = data.Stat.Wallet - 5
						spr:Play("Drop", true)
					else
						if (not spr:IsPlaying("Drop") and not spr:IsPlaying("Rage")) then
							if Isaac.GetFrameCount() % 1200 == 0 then
								spr:Play("Drop", true)
							end
							if (iss.Position - player.Position):Length() > 100 then
								SchoolbagAPI.XalumMoveTowardsTarget(iss, player, 8, 0.9, false)
							end
						end
					end
				end
			end
		elseif data.Stat.Mode == 1 then
			if enemy and not enemy:IsDead() and enemy ~= nil and enemy.Type ~= EntityType.ENTITY_FIREPLACE and enemy:IsActiveEnemy() and  enemy:IsVulnerableEnemy() then
				data.specialAttackVector = (enemy.Position - iss.Position)
				if enemy.Position:Distance(iss.Position) > 100 then
					SchoolbagAPI.XalumMoveTowardsTarget(iss, enemy, 6, 0.9, false)
				else
					if Isaac.GetFrameCount() % 800 == 0 then
						yandereWaifu:DoTinyBarrages(iss, data.specialAttackVector)
					else
						SchoolbagAPI.MoveAwayFromTarget(iss, enemy, 4, 0.9)
						if data.Stat.FireDelay <= 0 then
							local tears = player:FireTear(iss.Position, data.specialAttackVector:Resized(8), false, false, false):ToTear()
							tears.Position = iss.Position
							tears.Scale = 0.3
							tears.CollisionDamage = data.Stat.Damage
							data.Stat.FireDelay = data.Stat.MaxFireDelay
						end
					end
				end
			end
		end
		iss.Velocity = iss.Velocity * 0.8
	end
	if iss.Variant == ENTITY_TINYISAAC then
		player:ToPlayer()
		
		--bffs! synergy
		local extra = 0
		if player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
			extra = 2
			iss.Scale = 1.5
		else
			iss.Scale = 1
		end
		
		if not player:HasCollectible(COLLECTIBLE_ETERNALBOND) then
			iss:Remove()
		end
		if not spr:IsPlaying("Drop") and not spr:IsPlaying("Drop2") then
			SchoolbagAPI.AnimWalkFrame(iss, true, "WalkHori", "WalkVert")
		end
		if data.Stat.FireDelay > 0 then data.Stat.FireDelay = data.Stat.FireDelay - 1 end
		
		--iss.Velocity = player.Velocity * 0.8
		if spr:IsEventTriggered("Drop") then
			local maths = math.random(1,3)
			if maths == 1 then
				local newpickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_KEY, 0, iss.Position, iss.Velocity, iss)
			elseif maths == 2 then
				local newpickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, 0, iss.Position, iss.Velocity, iss)
			else
				local newpickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, MirrorHeartDrop[math.random(1,6)], iss.Position, iss.Velocity, iss)
			end
		end
		if spr:IsEventTriggered("Drop2") then
			local newpickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, -1, iss.Position, iss.Velocity, iss)
		end
		local enemy = SchoolbagAPI.GetClosestGenericEnemy(iss, 1000, iss.Type)
		if enemy and not enemy:IsDead() and enemy ~= nil and enemy.Type ~= EntityType.ENTITY_FIREPLACE and enemy:IsActiveEnemy() and  enemy:IsVulnerableEnemy() then
			if enemy.Position:Distance(iss.Position) > 100 then
				SchoolbagAPI.XalumMoveTowardsTarget(iss, enemy, 6, 0.9, false)
			else
				if not data.bomb or data.bomb:IsDead() then
					if Isaac.GetFrameCount() % 1200 == 0 then
						data.bomb = Isaac.Spawn(EntityType.ENTITY_BOMBDROP, 0, 0, iss.Position,  Vector.FromAngle((enemy.Position-iss.Position):GetAngleDegrees()):Resized( 9 ), player);
					else
						SchoolbagAPI.MoveAwayFromTarget(iss, enemy, 4, 0.9)
						if data.Stat.FireDelay <= 0 then
							local tears = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0, iss.Position, (enemy.Position - iss.Position):Resized(10), player):ToTear()
							tears.Scale = 0.3 + extra/4
							tears.CollisionDamage = data.Stat.Damage + extra
							data.Stat.FireDelay = data.Stat.MaxFireDelay
						end
					end
				else
					if enemy.Position:Distance(data.bomb.Position) < 100 then
						SchoolbagAPI.MoveAwayFromTarget(iss, data.bomb, 4, 0.9)
					end
				end
			end
		else
			local nearPickup, pos = SchoolbagAPI.GetClosestPickup(iss, 400, 20, -1)
			if nearPickup then
				SchoolbagAPI.XalumMoveTowardsTarget(iss, nearPickup, 6, 0.9, false)
				if (nearPickup.Position-iss.Position):Length() < 5 and not nearPickup.Touched then
					local picked = SchoolbagAPI.PickupPickup(nearPickup)
					--print(data.Stat.Wallet.."   "..picked.Subtype)
					picked = picked:ToPickup()
					local earned = 0
					if picked.SubType == 1 or picked.SubType == 5 then
						earned = 1
					elseif picked.SubType == 2 then
						earned = 5
					elseif picked.SubType == 3 then
						earned = 10
					elseif picked.SubType == 4 then
						earned = 2
					end
					data.Stat.Wallet = data.Stat.Wallet + earned
				end
			else
				if data.Stat.Wallet > 4 and (not spr:IsPlaying("Drop") and not spr:IsPlaying("Drop2"))then
					data.Stat.Wallet = data.Stat.Wallet - 5
					local rng = math.random(1,15)
					if rng < 15 then
						spr:Play("Drop", true)
					else
						spr:Play("Drop2", true)
					end
				else
					if (not spr:IsPlaying("Drop") and not spr:IsPlaying("Drop2")) then
						if player.Position:Distance(iss.Position) > 100 then
							if math.floor(Isaac.GetFrameCount() % math.random(30,60)) == 0 then
								if not pos then pos = Isaac.GetRandomPosition() end
							elseif Isaac.GetFrameCount() % 1200 == 0 then
								spr:Play("Drop", true)
							end
							if pos then
								SchoolbagAPI.MoveRandomlyTypeI(iss, pos, 8, 0.9, 0, 0, 0)
							end
						else
							SchoolbagAPI.MoveAwayFromTarget(iss, player, 4, 0.9)
						end
					end
				end
			end
		end
		iss.Velocity = iss.Velocity * 0.8
	end
end, ENTITY_TINYFELLOW);

function yandereWaifu:AddTinyCharacters(player)
	if player:GetPlayerType() == Reb then
		local isThere = false
		for i, iss in pairs (Isaac.FindByType(ENTITY_TINYFELLOW, ENTITY_TINYISAAC, -1, false, false)) do
			isThere = true
		end
		if not isThere then
			local becca = Isaac.Spawn( ENTITY_TINYFELLOW, ENTITY_TINYISAAC, 0, player.Position, Vector(0,0), player );
			GetEntityData(becca).Parent = player
		end
	else
		local isThere = false
		for i, iss in pairs (Isaac.FindByType(ENTITY_TINYFELLOW, ENTITY_TINYBECCA, -1, false, false)) do
			isThere = true
		end
		if not isThere then
			local becca = Isaac.Spawn( ENTITY_TINYFELLOW, ENTITY_TINYBECCA, 0, player.Position, Vector(0,0), player );
			GetEntityData(becca).Parent = player
		end
	end
end

function yandereWaifu:RemoveTinyCharacters(player)
	if player:GetPlayerType() == Reb then
		local isThere = false
		for i, iss in pairs (Isaac.FindByType(ENTITY_TINYISAAC, 663123, -1, false, false)) do
			iss:Remove()
		end
	else
		local isThere = false
		for i, iss in pairs (Isaac.FindByType(ENTITY_TINYBECCA, 663122, -1, false, false)) do
			iss:Remove()
		end
	end
end

	--romcom code
	function yandereWaifu:useRomComBook(collItem, rng, player)
		SchoolbagAPI.ToggleShowActive(player, true)
	end
	yandereWaifu:AddCallback( ModCallbacks.MC_USE_ITEM, yandereWaifu.useRomComBook, COLLECTIBLE_ROMCOM );

	--dice of fate code
	function yandereWaifu:useDiceOfFate(collItem, rng, player)
			local hearts = player:GetMaxHearts() + player:GetSoulHearts() + player:GetGoldenHearts() + player:GetEternalHearts() + player:GetBoneHearts()
			--remove all hearts first
			if player:GetPlayerType() == PlayerType.PLAYER_KEEPER then
				rng = math.random(1,20)
				if rng < 6 then --red add
					player:AddBlueFlies(1, player.Position, player)
				elseif rng < 8 then
					player:AddBlueFlies(2, player.Position, player)
				elseif rng < 12 then
					player:AddBlueFlies(3, player.Position, player)
				elseif rng < 15 then
					player:AddBlueSpider(player.Position)
				elseif rng < 17 then
					player:AddBlueFlies(1, player.Position, player)
					player:AddBlueSpider(player.Position)
				else
					player:AddBlueFlies(3, player.Position, player)
					for i = 1, 3, 1 do
						player:AddBlueSpider(player.Position)
					end
				end
			elseif player:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN then
				player:AddGoldenHearts(-player:GetGoldenHearts())
				player:AddMaxHearts(-player:GetMaxHearts())
				player:AddHearts(-player:GetHearts())
				player:AddSoulHearts(-player:GetSoulHearts())
				player:AddEternalHearts(-player:GetEternalHearts())
				player:AddBoneHearts(-player:GetBoneHearts())
				player:AddBlackHearts(-GetPlayerBlackHearts(player))
				
				local hadEternal = false
				for i = 0, hearts/2 do
					rng = math.random(1,20)
					if rng < 6 then --red add
						player:AddMaxHearts(2)
						player:AddHearts(2)
					elseif rng < 8 then
						player:AddGoldenHearts(1)
					elseif rng < 12 then
						player:AddSoulHearts(2)
					elseif rng < 15 then
						if not hadEternal then
							player:AddEternalHearts(1)
							hadEternal = true
						else
							player:AddSoulHearts(1)
						end
					elseif rng < 17 then
						player:AddBlackHearts(2)
					else
						player:AddBoneHearts(1)
					end
				end
				if player:GetBoneHearts() <= 0 then
					player:AddBoneHearts(1)
				end
			else
				player:AddGoldenHearts(-player:GetGoldenHearts())
				player:AddMaxHearts(-player:GetMaxHearts())
				player:AddHearts(-player:GetHearts())
				player:AddSoulHearts(-player:GetSoulHearts())
				player:AddEternalHearts(-player:GetEternalHearts())
				player:AddBoneHearts(-player:GetBoneHearts())
				player:AddBlackHearts(-GetPlayerBlackHearts(player))
				
				local hadEternal = false
				for i = 0, hearts/2 do
					rng = math.random(1,20)
					if rng < 6 then --red add
						player:AddMaxHearts(2)
						player:AddHearts(2)
					elseif rng < 8 then
						player:AddGoldenHearts(1)
					elseif rng < 12 then
						player:AddSoulHearts(2)
					elseif rng < 15 then
						if not hadEternal then
							player:AddEternalHearts(1)
							hadEternal = true
						else
							player:AddSoulHearts(1)
						end
					elseif rng < 17 then
						player:AddBlackHearts(2)
					else
						player:AddBoneHearts(1)
					end
				end
		end
	return true
end
yandereWaifu:AddCallback( ModCallbacks.MC_USE_ITEM, yandereWaifu.useDiceOfFate, COLLECTIBLE_DICEOFFATE );

--unrequited love code
function yandereWaifu:useUnLove(collItem, rng, player)
	--for i,player in ipairs(SAPI.players) do
	SchoolbagAPI.ToggleShowActive(player, true)
	--end
end
yandereWaifu:AddCallback( ModCallbacks.MC_USE_ITEM, yandereWaifu.useUnLove, COLLECTIBLE_UNREQUITEDLOVE );


function yandereWaifu:ItemsNewRoom()
	for p = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
	--for i,player in ipairs(SAPI.players) do
		local data = GetEntityData(player)
		local room = game:GetRoom()
		print(room:GetType())
		if player:HasCollectible(COLLECTIBLE_ETERNALBOND) then
			for i, iss in pairs (Isaac.FindByType(ENTITY_TINYISAAC, 663123, -1, false, false)) do
				iss.Position = player.Position
			end
			for i, iss in pairs (Isaac.FindByType(ENTITY_TINYBECCA, 663122, -1, false, false)) do
				iss.Position = player.Position
			end
		end
		if player:HasTrinket(TRINKET_ISAACSLOCKS) and room:IsFirstVisit() then
			local rng = math.random(1,2)
			local seed = room:GetSpawnSeed()
			--print(room:GetSpawnSeed())
			if (room:GetType() == RoomType.ROOM_SHOP or room:GetType() == RoomType.ROOM_BOSS or room:GetType() == RoomType.ROOM_TREASURE) or (seed/100000000 < 5 and (room:GetType() == RoomType.ROOM_DEVIL or room:GetType() == RoomType.ROOM_ANGEL)) then
			local slot = Isaac.Spawn(EntityType.ENTITY_SLOT, 10, 0, room:FindFreePickupSpawnPosition(room:GetCenterPos(), 1), Vector(0,0), player)
			end
		end
	end
end
yandereWaifu:AddCallback( ModCallbacks.MC_POST_NEW_ROOM, yandereWaifu.ItemsNewRoom)


yandereWaifu:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, damage, amount, damageFlag, damageSource, damageCountdownFrames) --invincibilityframe when dashing or whatnot
	local player = damage:ToPlayer();
	local data = GetEntityData(player)

	if player:HasCollectible(COLLECTIBLE_CURSEDSPOON) and (damageFlag & DamageFlag.DAMAGE_CURSED_DOOR) == 0 then
		data.LastEntityCollisionClass = player.EntityCollisionClass;
		data.LastGridCollisionClass = player.GridCollisionClass;

		local maw = Isaac.Spawn(EntityType.ENTITY_EFFECT, ENTITY_CURSEDMAW, 0, player.Position, Vector(0,0), player)
		player:AnimatePitfallIn()
		data.IsUninteractible = true
	end
	
end, EntityType.ENTITY_PLAYER)

--stat cache for each mode
	function yandereWaifu:itemcacheregister(player, cacheF) --The thing the checks and updates the game, i guess?
		local data = GetEntityData(player)
		if cacheF == CacheFlag.CACHE_FAMILIARS then
			--Miraculous Womb
			player:CheckFamiliar(ENTITY_ORBITALESAU, player:GetCollectibleNum(COLLECTIBLE_MIRACULOUSWOMB), player:GetCollectibleRNG(COLLECTIBLE_MIRACULOUSWOMB))
			player:CheckFamiliar(ENTITY_ORBITALJACOB, player:GetCollectibleNum(COLLECTIBLE_MIRACULOUSWOMB), player:GetCollectibleRNG(COLLECTIBLE_MIRACULOUSWOMB))
		end
		--love = power
		if player:HasCollectible(COLLECTIBLE_POWERLOVE) then
			local maxH, H = player:GetMaxHearts(), player:GetHearts()
			if maxH >= 1 then
				local emptyH, fullH = (maxH - H), H 
				if cacheF == CacheFlag.CACHE_SPEED then
					player.MoveSpeed = player.MoveSpeed + (0.02 * emptyH)
				end
				if cacheF == CacheFlag.CACHE_DAMAGE then
					player.Damage = player.Damage + (0.50 * H)
				end
			end
		end
		if player:HasCollectible(COLLECTIBLE_SNAP) then
			if data.SnapDelay then
				if cacheF == CacheFlag.CACHE_FIREDELAY then
					player.FireDelay = player.FireDelay - data.SnapDelay
				end
			end
		end
	end
	yandereWaifu:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, yandereWaifu.itemcacheregister)