--ETERNAL BOND--
function yandereWaifu:TinyBeccaInit(fam)
	if fam.Variant == RebekahCurse.ENTITY_TINYBECCA then --Rebecca--
		local sprite = fam:GetSprite()
		local data = yandereWaifu.GetEntityData(fam)
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
	if fam.Variant == RebekahCurse.ENTITY_TINYISAAC then --Isaac--
		local sprite = fam:GetSprite()
		local data = yandereWaifu.GetEntityData(fam)
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
yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, yandereWaifu.TinyBeccaInit);

yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_,  iss) 
	local spr = iss:GetSprite()
	local data = yandereWaifu.GetEntityData(iss)
	local player = iss.Player
	local room = InutilLib.game:GetRoom()
	if iss.Variant == RebekahCurse.ENTITY_TINYBECCA then
		--bffs! synergy
		local extraDmg = 0
		local extraFireDelay = false
		if player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
			extraDmg = 2
		end
		if player:HasTrinket(TrinketType.TRINKET_FORGOTTEN_LULLABY) then
			extraFireDelay = true
		end
		
		player:ToPlayer()
		if not player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_ETERNALBOND) then
			iss:Remove()
		end
		if not spr:IsPlaying("Drop") and not spr:IsPlaying("Rage") then
			InutilLib.AnimWalkFrame(iss, true, "WalkHori", "WalkVert")
		end
		if data.Stat.FireDelay > 0 then data.Stat.FireDelay = data.Stat.FireDelay - 1 end
		if spr:IsEventTriggered("Drop") then
			if player:GetPlayerType() == PlayerType.PLAYER_KEEPER or player:GetPlayerType() == PlayerType.PLAYER_KEEPER_B then
				local newpickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, 0, iss.Position, iss.Velocity, iss)
			elseif player:GetPlayerType() == PlayerType.PLAYER_AZAZEL or player:GetPlayerType() == PlayerType.PLAYER_LILITH or player:GetPlayerType() == PlayerType.PLAYER_AZAZEL_B or player:GetPlayerType() == PlayerType.PLAYER_LILITH_B then
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
		local enemy = InutilLib.GetClosestGenericEnemy(iss, 500, iss.Type)
		if enemy then
			local path = InutilLib.GenerateAStarPath(iss.Position, enemy.Position)
			if data.Stat.Mode == 0 then
				if enemy and not enemy:IsDead() and enemy ~= nil and enemy.Type ~= EntityType.ENTITY_FIREPLACE and enemy:IsActiveEnemy() and  enemy:IsVulnerableEnemy() then
					if not data.specialAttackVector then  data.specialAttackVector = (enemy.Position - iss.Position) end
					if enemy.Position:Distance(iss.Position) > 100 and path then
						InutilLib.FollowPath(iss, enemy, path, 2, 0.9)
						--InutilLib.XalumMoveTowardsTarget(iss, enemy, 6, 0.9, false)
					else
						if iss.FrameCount % 60 == 0 and math.random(1,3)== 3 then
							yandereWaifu.DoTinyBarrages(iss, (enemy.Position - iss.Position))
						else
							InutilLib.MoveAwayFromTarget(iss, enemy, 4, 0.9)
							if data.Stat.FireDelay <= 0 then
								local tears =  Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0, iss.Position + Vector(0,-3):Rotated(data.specialAttackVector:GetAngleDegrees()), (enemy.Position - iss.Position):Resized(12), player):ToTear()
								tears.Scale = 0.3
								tears.CollisionDamage = data.Stat.Damage + extraDmg/2
								local totalMaxFireDelay = data.Stat.MaxFireDelay
								if extraFireDelay then totalMaxFireDelay = data.Stat.MaxFireDelay/2 end
								data.Stat.FireDelay = totalMaxFireDelay
								local tears2 =  Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0, iss.Position + Vector(0,3):Rotated(data.specialAttackVector:GetAngleDegrees()), (enemy.Position - iss.Position):Resized(12), player):ToTear()
								tears2.Scale = 0.3
								tears2.CollisionDamage = data.Stat.Damage + extraDmg/2
								local totalMaxFireDelay = data.Stat.MaxFireDelay
								if extraFireDelay then totalMaxFireDelay = data.Stat.MaxFireDelay/2 end
								data.Stat.FireDelay = totalMaxFireDelay
								if player:HasTrinket(TrinketType.TRINKET_BABY_BENDER) then
									tears:AddTearFlags(TearFlags.TEAR_HOMING)
									tears.Color = Color(1,0,1,1)
									tears2:AddTearFlags(TearFlags.TEAR_HOMING)
									tears2.Color = Color(1,0,1,1)
								end
							end
						end
					end
					data.specialAttackVector = nil
				else
					local nearPickup, pos = InutilLib.GetClosestPickup(iss, 400, 10, -1)
					local PickUppath = InutilLib.GenerateAStarPath(iss.Position, nearPickup.Position)
					if nearPickup and (nearPickup.SubType == 1 or nearPickup.SubType == 2 or nearPickup.SubType == 5 or nearPickup.SubType == 9 or nearPickup.SubType == 10) then
						if PickUppath then
							if (nearPickup.Position - iss.Position):Length() > 15 then
								InutilLib.FollowPath(iss, nearPickup, PickUppath, 5, 0.9)
								--InutilLib.XalumMoveTowardsTarget(iss, nearPickup, 6, 0.9, false)
							else
								InutilLib.MoveDirectlyTowardsTarget(iss, nearPickup, 5, 0.9)
							end
						end
						if (nearPickup.Position-iss.Position):Length() < 40 and not nearPickup.Touched then
							local picked = InutilLib.PickupPickup(nearPickup)
							--print(data.Stat.Wallet.."   "..picked.Subtype)
							picked = picked:ToPickup()
							local earned = 0
							if picked.SubType == 1 or picked.SubType == 9 then
								earned = 2
							elseif picked.SubType == 9 then
								earned = 4
							elseif picked.SubType == 2 or picked.SubType == 10 then
								earned = 1
							end
							data.Stat.Wallet = data.Stat.Wallet + earned
						end
					else
						if data.Stat.Wallet > 9 and (not spr:IsPlaying("Drop") and not spr:IsPlaying("Rage")) then
							data.Stat.Wallet = data.Stat.Wallet - math.random(8,10)
							spr:Play("Drop", true)
						else
							if (not spr:IsPlaying("Drop") and not spr:IsPlaying("Rage")) then
								if (Isaac.GetFrameCount() % 1200 == 0 and player:GetEffectiveMaxHearts() > 2 and player:GetHearts() < 4) or (Isaac.GetFrameCount() % 2400 == 0 and math.random(1,2) and player:GetSoulHearts() < 4) then
									spr:Play("Drop", true)
								end
								if (iss.Position - player.Position):Length() > 100 then
									local path = InutilLib.GenerateAStarPath(iss.Position, player.Position)
									InutilLib.FollowPath(iss, player, path, 2, 0.9)
									--InutilLib.XalumMoveTowardsTarget(iss, player, 8, 0.9, false)
								end
							end
						end
					end
				end
			elseif data.Stat.Mode == 1 then
				if enemy and not enemy:IsDead() and enemy ~= nil and enemy.Type ~= EntityType.ENTITY_FIREPLACE and enemy:IsActiveEnemy() and  enemy:IsVulnerableEnemy() then
					data.specialAttackVector = (enemy.Position - iss.Position)
					if enemy.Position:Distance(iss.Position) > 100 and path then
						--InutilLib.XalumMoveTowardsTarget(iss, enemy, 6, 0.9, false)
						InutilLib.FollowPath(iss, enemy, path, 2, 0.9)
					else
						if Isaac.GetFrameCount() % 800 == 0 then
							yandereWaifu:DoTinyBarrages(iss, data.specialAttackVector)
						else
							InutilLib.MoveAwayFromTarget(iss, enemy, 4, 0.9)
							if data.Stat.FireDelay <= 0 then
								local tears = player:FireTear(iss.Position, data.specialAttackVector:Resized(8), false, false, false):ToTear()
								tears.Position = iss.Position
								tears.Scale = 0.3
								tears.CollisionDamage = data.Stat.Damage
								local totalMaxFireDelay = data.Stat.MaxFireDelay
								if extraFireDelay then totalMaxFireDelay = data.Stat.MaxFireDelay/2 end
								data.Stat.FireDelay = totalMaxFireDelay
								if player:HasTrinket(TrinketType.TRINKET_BABY_BENDER) then
									tears:AddTearFlags(TearFlags.TEAR_HOMING)
									tears.Color = Color(1,0,1,1)
								end
							end
						end
					end
				end
			end
		else
			local pos = player.Position
			if pos and pos:Distance(iss.Position) > 100 then
				InutilLib.MoveRandomlyTypeI(iss, pos, 2.5, 0.9, 0, 0, 0)
			end
		end
		iss.Velocity = iss.Velocity * 0.8
	end
	if iss.Variant == RebekahCurse.ENTITY_TINYISAAC then
		player:ToPlayer()
		
		--bffs! synergy
		local extraDmg = 0
		local extraFireDelay = false
		if player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
			extraDmg = 2
		end
		if player:HasTrinket(TrinketType.TRINKET_FORGOTTEN_LULLABY) then
			extraFireDelay = true
		end
		
		if not player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_ETERNALBOND) then
			iss:Remove()
		end
		if not spr:IsPlaying("Drop") and not spr:IsPlaying("Drop2") then
			InutilLib.AnimWalkFrame(iss, true, "WalkHori", "WalkVert")
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
				local newpickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, RebekahCurse.RebekahMirrorHeartDrop[math.random(1,6)], iss.Position, iss.Velocity, iss)
			end
		end
		if spr:IsEventTriggered("Drop2") then
			local newpickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, -1, iss.Position, iss.Velocity, iss)
		end
		local enemy = InutilLib.GetClosestGenericEnemy(iss, 1000, iss.Type)
		if enemy and not enemy:IsDead() and enemy ~= nil and enemy.Type ~= EntityType.ENTITY_FIREPLACE and enemy:IsActiveEnemy() and  enemy:IsVulnerableEnemy() then
			local path = InutilLib.GenerateAStarPath(iss.Position, enemy.Position)
			if enemy.Position:Distance(iss.Position) > 100 and path then
				--InutilLib.XalumMoveTowardsTarget(iss, enemy, 6, 0.9, false)
				InutilLib.FollowPath(iss, enemy, path, 2.5, 0.9)
			else
				if not data.bomb or data.bomb:IsDead() then
					if Isaac.GetFrameCount() % 1200 == 0 then
						data.bomb = Isaac.Spawn(EntityType.ENTITY_BOMBDROP, 0, 0, iss.Position,  Vector.FromAngle((enemy.Position-iss.Position):GetAngleDegrees()):Resized( 9 ), player);
					else
						InutilLib.MoveAwayFromTarget(iss, enemy, 4, 0.9)
						if data.Stat.FireDelay <= 0 then
							local tears = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0, iss.Position, (enemy.Position - iss.Position):Resized(10), player):ToTear()
							tears.Scale = 0.3 + extraDmg/4
							tears.CollisionDamage = data.Stat.Damage + extraDmg
							local totalMaxFireDelay = data.Stat.MaxFireDelay
							if extraFireDelay then totalMaxFireDelay = data.Stat.MaxFireDelay/2 end
							data.Stat.FireDelay = totalMaxFireDelay
							if player:HasTrinket(TrinketType.TRINKET_BABY_BENDER) then
								tears:AddTearFlags(TearFlags.TEAR_HOMING)
								tears.Color = Color(1,0,1,1)
							end
						end
					end
				else
					if enemy.Position:Distance(data.bomb.Position) < 100 then
						InutilLib.MoveAwayFromTarget(iss, data.bomb, 4, 0.9)
					end
				end
			end
		else
			local nearPickup, pos = InutilLib.GetClosestPickup(iss, 400, 20, -1)
			if nearPickup then
				local PickUppath = InutilLib.GenerateAStarPath(iss.Position, nearPickup.Position)
				if PickUppath and (nearPickup.Position - iss.Position):Length() > 15 then
					InutilLib.FollowPath(iss, nearPickup, PickUppath, 1, 0.9)
					--InutilLib.XalumMoveTowardsTarget(iss, nearPickup, 6, 0.9, false)
				else
					InutilLib.MoveDirectlyTowardsTarget(iss, nearPickup, 1, 0.9)
				end
				if (nearPickup.Position-iss.Position):Length() < 40 and not nearPickup.Touched then
					local picked = InutilLib.PickupPickup(nearPickup)
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
								InutilLib.MoveRandomlyTypeI(iss, pos, 8, 0.9, 0, 0, 0)
							end
						else
							InutilLib.MoveAwayFromTarget(iss, player, 4, 0.9)
						end
					end
				end
			end
		end
		iss.Velocity = iss.Velocity * 0.8
	end
end);--[[

function yandereWaifu:AddTinyCharacters(player)
	if player:GetPlayerType() == Reb then
		local isThere = false
		for i, iss in pairs (Isaac.FindByType(RebekahCurse.ENTITY_TINYFELLOW, RebekahCurse.ENTITY_TINYISAAC, -1, false, false)) do
			isThere = true
		end
		if not isThere then
			local becca = Isaac.Spawn( RebekahCurse.ENTITY_TINYFELLOW, RebekahCurse.ENTITY_TINYISAAC, 0, player.Position, Vector(0,0), player );
			yandereWaifu.GetEntityData(becca).Parent = player
		end
	else
		local isThere = false
		for i, iss in pairs (Isaac.FindByType(RebekahCurse.ENTITY_TINYFELLOW, RebekahCurse.ENTITY_TINYBECCA, -1, false, false)) do
			isThere = true
		end
		if not isThere then
			local becca = Isaac.Spawn( RebekahCurse.ENTITY_TINYFELLOW, RebekahCurse.ENTITY_TINYBECCA, 0, player.Position, Vector(0,0), player );
			yandereWaifu.GetEntityData(becca).Parent = player
		end
	end
end

function yandereWaifu:RemoveTinyCharacters(player)
	if player:GetPlayerType() == Reb then
		local isThere = false
		for i, iss in pairs (Isaac.FindByType(RebekahCurse.ENTITY_TINYISAAC, 663123, -1, false, false)) do
			iss:Remove()
		end
	else
		local isThere = false
		for i, iss in pairs (Isaac.FindByType(RebekahCurse.ENTITY_TINYBECCA, 663122, -1, false, false)) do
			iss:Remove()
		end
	end
end]]


function yandereWaifu:TinyEternalBondCache(player, cacheF) --The thing the checks and updates the game, i guess?
	local data = yandereWaifu.GetEntityData(player)
	if cacheF == CacheFlag.CACHE_FAMILIARS then  -- Especially here!
		--if yandereWaifu.IsNormalRebekah(player) then
			player:CheckFamiliar(RebekahCurse.ENTITY_TINYISAAC, player:GetCollectibleNum(RebekahCurse.Items.COLLECTIBLE_ETERNALBOND), RNG(), InutilLib.config:GetCollectible(RebekahCurse.Items.COLLECTIBLE_ETERNALBOND))
		--else
			player:CheckFamiliar(RebekahCurse.ENTITY_TINYBECCA, player:GetCollectibleNum(RebekahCurse.Items.COLLECTIBLE_ETERNALBOND), RNG(), InutilLib.config:GetCollectible(RebekahCurse.Items.COLLECTIBLE_ETERNALBOND))
		--end
	end
		
end
yandereWaifu:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, yandereWaifu.TinyEternalBondCache)