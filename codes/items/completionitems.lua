
local giant = Sprite()
giant:Load("gfx/characters/big_rebekah.anm2",true)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, function(_,player, offset)
	local data = GetEntityData(player)
	
	if data.IsThicc == true then
		--print("fire")
		--giant:SetOverlayRenderPriority(true)
		--giant:Play("HeadDown", true)
		--local playerLocation = Isaac.WorldToScreen(player.Position)
		--print(InutilLib.IsInMirroredFloor(player))
		if not InutilLib.IsInMirroredFloor(player) then
		--	giant:Render(playerLocation, Vector(0,0), Vector(0,0))
		end
	end
end)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function(_,player)
	--local player = Isaac.GetPlayer(0);
    local room = Game():GetRoom();
	local data = GetEntityData(player)
	--items function!
	if player:HasCollectible(RebekahCurse.COLLECTIBLE_LUNCHBOX) and InutilLib.HasJustPickedCollectible( player, RebekahCurse.COLLECTIBLE_LUNCHBOX ) then
		for i = 0, 2, 1 do
			local spawnPosition = room:FindFreePickupSpawnPosition(player.Position, 1);
			local newpickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, MirrorHeartDrop[math.random(1,6)], spawnPosition, Vector(0,0), player)
		end
		player:AddNullCostume(LunchboxCos)
	end
	if player:HasCollectible(RebekahCurse.COLLECTIBLE_POWERLOVE) and InutilLib.HasJustPickedCollectible( player, RebekahCurse.COLLECTIBLE_POWERLOVE) then
		player:AddNullCostume(LovePower)
	end
	--love = Power
	local H = player:GetHearts()
	if player:HasCollectible(RebekahCurse.COLLECTIBLE_POWERLOVE) then
		if data.H ~= H then
			player:AddCacheFlags(CacheFlag.CACHE_DAMAGE);
			player:AddCacheFlags(CacheFlag.CACHE_SPEED);
			player:EvaluateItems()
		end
		data.H = H
	elseif not player:HasCollectible(RebekahCurse.COLLECTIBLE_POWERLOVE) and data.H then
		data.H = nil
		player:AddCacheFlags(CacheFlag.CACHE_DAMAGE);
		player:AddCacheFlags(CacheFlag.CACHE_SPEED);
		player:EvaluateItems()
	end
	--cursed spoon
	if player:HasCollectible(RebekahCurse.COLLECTIBLE_CURSEDSPOON) and InutilLib.HasJustPickedCollectible( player, RebekahCurse.COLLECTIBLE_CURSEDSPOON) then
		player:AddNullCostume(CursedMawCos)
	end
	--typical rom-command
	if player:HasCollectible(RebekahCurse.COLLECTIBLE_ROMCOM) then
		if InutilLib.ConfirmUseActive( player, RebekahCurse.COLLECTIBLE_ROMCOM ) then
			local vector = InutilLib.DirToVec(player:GetFireDirection())
			data.specialAttackVector = Vector( vector.X, vector.Y )
			InutilLib.ConsumeActiveCharge(player)
			InutilLib.ToggleShowActive(player, false)
			
			local rng = math.random(1,5)
			yandereWaifu:DoExtraBarrages(player, rng)
		end
	end
	--lovesick
	if player:HasCollectible(RebekahCurse.COLLECTIBLE_LOVESICK) then
		if InutilLib.HasJustPickedCollectible( player, RebekahCurse.COLLECTIBLE_LOVESICK) then
			player:AddNullCostume(LoveSickCos)
		end
		if Isaac.GetFrameCount() % 120 == 0 then
			SpawnHeartParticles( 1, 3, player.Position, RandomHeartParticleVelocity(), player, HeartParticleType.Red );
			local fart = Isaac.Spawn(EntityType.ENTITY_EFFECT, ENTITY_PHEROMONES_RING, 0, player.Position, Vector(0,0), player)
			GetEntityData(fart).Player = player
		end
	end
	--snap
	if player:HasCollectible(RebekahCurse.COLLECTIBLE_SNAP) then
		if InutilLib.HasJustPickedCollectible( player, RebekahCurse.COLLECTIBLE_SNAP) then
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
	if player:HasCollectible(RebekahCurse.COLLECTIBLE_UNREQUITEDLOVE) then
		if InutilLib.ConfirmUseActive( player, RebekahCurse.COLLECTIBLE_UNREQUITEDLOVE ) then
			local vector = InutilLib.DirToVec(player:GetFireDirection())
			local hook = Isaac.Spawn(EntityType.ENTITY_EFFECT, ENTITY_LOVEHOOK, 0, player.Position, vector:Resized(45), player)
			hook.RenderZOffset = -10000;
			GetEntityData(hook).Player = player
			InutilLib.ConsumeActiveCharge(player)
			InutilLib.ToggleShowActive(player, false)
			
		end
	end
	--yandereWaifu:EctoplasmLeaking(player) 
end)



----------
--ITEMS!--
----------
 
function yandereWaifu:ItemsNewRoom()
	for p = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
	--for i,player in ipairs(ILIB.players) do
		local data = GetEntityData(player)
		local room = game:GetRoom()
		print(room:GetType())
		if player:HasCollectible(RebekahCurse.COLLECTIBLE_ETERNALBOND) then
			for i, iss in pairs (Isaac.FindByType(RebekahCurse.ENTITY_TINYISAAC, 663123, -1, false, false)) do
				iss.Position = player.Position
			end
			for i, iss in pairs (Isaac.FindByType(RebekahCurse.ENTITY_TINYBECCA, 663122, -1, false, false)) do
				iss.Position = player.Position
			end
		end
		if player:HasTrinket(RebekahCurse.TRINKET_ISAACSLOCKS) and room:IsFirstVisit() then
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




--stat cache for each mode
	function yandereWaifu:itemcacheregister(player, cacheF) --The thing the checks and updates the game, i guess?
		local data = GetEntityData(player)
		if cacheF == CacheFlag.CACHE_FAMILIARS then
			--Miraculous Womb
			player:CheckFamiliar(RebekahCurse.ENTITY_ORBITALESAU, player:GetCollectibleNum(CRebekahCurse.OLLECTIBLE_MIRACULOUSWOMB), player:GetCollectibleRNG(RebekahCurse.COLLECTIBLE_MIRACULOUSWOMB))
			player:CheckFamiliar(RebekahCurse.ENTITY_ORBITALJACOB, player:GetCollectibleNum(RebekahCurse.COLLECTIBLE_MIRACULOUSWOMB), player:GetCollectibleRNG(RebekahCurse.COLLECTIBLE_MIRACULOUSWOMB))
		end
		--love = power
		if player:HasCollectible(RebekahCurse.COLLECTIBLE_POWERLOVE) then
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
		if player:HasCollectible(RebekahCurse.COLLECTIBLE_SNAP) then
			if data.SnapDelay then
				if cacheF == CacheFlag.CACHE_FIREDELAY then
					player.FireDelay = player.FireDelay - data.SnapDelay
				end
			end
		end
	end
	yandereWaifu:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, yandereWaifu.itemcacheregister)