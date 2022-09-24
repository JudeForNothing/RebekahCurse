local generateSomeHoles = false
yandereWaifu:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_,player)
    local room = Game():GetRoom();
	local data = yandereWaifu.GetEntityData(player)
	if player:HasCollectible(RebekahCurse.COLLECTIBLE_NUTWATER) and InutilLib.HasJustPickedCollectible( player, RebekahCurse.COLLECTIBLE_NUTWATER ) then
		player:AddCacheFlags(CacheFlag.CACHE_DAMAGE);
		player:AddCacheFlags(CacheFlag.CACHE_SPEED);
		player:EvaluateItems()
		--print("pain")
		player:AddNullCostume(RebekahCurseCostumes.NutWater)
		--for i = 0, 1, 1 do
			if player:GetPlayerType() == PlayerType.PLAYER_KEEPER or player:GetPlayerType() == PlayerType.PLAYER_KEEPER_B then
				local newpickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, 0, ILIB.room:FindFreePickupSpawnPosition(player.Position,3) , player.Velocity, player)
			elseif player:GetPlayerType() == PlayerType.PLAYER_AZAZEL or player:GetPlayerType() == PlayerType.PLAYER_LILITH or player:GetPlayerType() == PlayerType.PLAYER_AZAZEL_B or player:GetPlayerType() == PlayerType.PLAYER_LILITH_B then
				local newpickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, 6, ILIB.room:FindFreePickupSpawnPosition(player.Position,3), player.Velocity, player)
			elseif player:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN then
				local newpickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, 11, ILIB.room:FindFreePickupSpawnPosition(player.Position,3), player.Velocity, player)
			else
				local tbl = {
					[1] = 3,
					[2] = 8
				}
				local newpickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, tbl[math.random(1,2)], ILIB.room:FindFreePickupSpawnPosition(player.Position,3), player.Velocity, player)
			end
		--end
	end
	if player:HasCollectible(RebekahCurse.COLLECTIBLE_NUTWATER) then
		generateSomeHoles = true
	else
		generateSomeHoles = false
	end
	if ILIB.room:GetGridEntityFromPos(player.Position) then
		if not data.GonnaNoClip then data.GonnaNoClip = 0 end
		if ILIB.room:GetGridEntityFromPos(player.Position):GetType() == GridEntityType.GRID_WALL and StageAPI and StageAPI.Loaded then
			if data.GonnaNoClip > 10 then
				StageAPI.GotoCustomStage(yandereWaifu.STAGE.Liminal, true)
			else 
				data.GonnaNoClip = data.GonnaNoClip + 1
				player.Velocity = player.Velocity + ((ILIB.room:GetGridEntityFromPos(player.Position).Position - player.Position):Resized(math.random(1,2))) * 0.7
				ILIB.game:ShakeScreen(3)
			end
		else
			data.GonnaNoClip = data.GonnaNoClip - 2
		end
	end
end)

yandereWaifu:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_,player, cacheF) 
	local data = yandereWaifu.GetEntityData(player)
	if player:HasCollectible(RebekahCurse.COLLECTIBLE_NUTWATER) then
		if cacheF == CacheFlag.CACHE_SPEED then
			player.MoveSpeed = player.MoveSpeed + 0.10
		end
		if cacheF == CacheFlag.CACHE_DAMAGE then
			player.Damage = player.Damage * 1.5
		end
	end
end)

InutilLib:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	local normalGen
	local thematicGen
	local withItemGen
	if (ILIB.room:GetType() == RoomType.ROOM_SUPERSECRET or ILIB.room:GetType() == RoomType.ROOM_SECRET) and generateSomeHoles and not yandereWaifu.STAGE.Liminal:IsStage() then
		for k, v in pairs(InutilLib.GetRoomGrids()) do
			if v:GetType() == GridEntityType.GRID_WALL then
				v:GetRNG():SetSeed(Random(), 1)
				if v:GetRNG():GetSeed() < 100000000 then
					v.CollisionClass = GridCollisionClass.COLLISION_NONE
					ILIB.room:SpawnGridEntity(v:GetGridIndex(), GridEntityType.GRID_PIT, 0, 0, 0)
					local eff = Isaac.Spawn( EntityType.ENTITY_EFFECT, EffectVariant.WISP, 0, v.Position, Vector.Zero, nil):ToEffect();
				end
			end
		end
	end
end)