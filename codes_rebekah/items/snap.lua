yandereWaifu:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function(_,player)
	local data = yandereWaifu.GetEntityData(player)
	if player:HasCollectible(RebekahCurseItems.COLLECTIBLE_SNAP) then
		if InutilLib.HasJustPickedCollectible( player, RebekahCurseItems.COLLECTIBLE_SNAP) then
			player:AddNullCostume(RebekahCurseCostumes.UnsnappedCos)
		end
		--[[local maxH, H = player:GetMaxHearts(), player:GetHearts()
		local ratioH
		if maxH - H == 0 then ratioH = 1 else ratioH = maxH - H end
		if H <= 2 then
			if not data.hasSnap then
				local fart = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_SNAP_EFFECT, 0, player.Position, Vector(0,0), player)
				player:AnimateSad()
				
				player:AddNullCostume(RebekahCurseCostumes.SnappedCos)
				player:TryRemoveNullCostume(RebekahCurseCostumes.UnsnappedCos)
			end
			data.hasSnap = true
		else
			if data.hasSnap == true then
				data.hasSnap = false
				
				player:AddNullCostume(RebekahCurseCostumes.UnsnappedCos)
				player:TryRemoveNullCostume(RebekahCurseCostumes.SnappedCos)
			end
		end
		local modulusF = (math.floor(240/ratioH))
		if data.hasSnap then modulusF = 10 end
		--print(player.FireDelay.."  "..data.SnapDelay)
		if Isaac.GetFrameCount() % modulusF == 0 then
			local fart = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_SNAP_HEARTBEAT, 0, player.Position, Vector(0,0), player)
			yandereWaifu.GetEntityData(fart).Snap = data.hasSnap
		end
		if (math.random(1,30)) >= 30 then
			if player.FireDelay > 0 and data.hasSnap then
				data.SnapDelay = math.random(math.floor(player.MaxFireDelay/3), player.MaxFireDelay/2)
				player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY);
				player:EvaluateItems()
			end
		end]]
	end
end)


InutilLib:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, damage, amount, damageFlag, damageSource, damageCountdownFrames) 
	if damage.Type == 1 and damage:ToPlayer():HasCollectible(RebekahCurseItems.COLLECTIBLE_SNAP) then
		local data = yandereWaifu.GetEntityData(damage)
		if not data.hasSnap and not data.isSnappedTired then
			damage = damage:ToPlayer()
			ILIB.game:ShowHallucination(15, 0)
			InutilLib.SetTimer( 60, function()
				local fart = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_SNAP_EFFECT, 0, damage.Position, Vector(0,0), damage)
				damage:AnimateSad()
				ILIB.game:ShakeScreen(5)
			end)
			damage:AddNullCostume(RebekahCurseCostumes.SnappedCos)
			damage:TryRemoveNullCostume(RebekahCurseCostumes.UnsnappedCos)
			data.hasSnap = true
			
			damage:AddCacheFlags(CacheFlag.CACHE_ALL);
			damage:EvaluateItems()
		end
	end
	
	--if enemy is hurt
	local player 
	if damageSource.Entity then
		player = damageSource.Entity:ToPlayer()
		if damageSource.Entity.SpawnerEntity then
			if damageSource.Entity.SpawnerEntity.Type == 1 then
				player = damageSource.Entity.SpawnerEntity:ToPlayer()
			end
		end
	end
	if player then
		local data = yandereWaifu.GetEntityData(player)
		if player:HasCollectible(RebekahCurseItems.COLLECTIBLE_SNAP )and data.hasSnap then
			--damage:TakeDamage( amount* 2, 0, damageSource, 0);
			--return false
		end
	end
end)

function yandereWaifu:SnappedTiredNewRoom()
	for p = 0, ILIB.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		local data = yandereWaifu.GetEntityData(player)
		if player:HasCollectible(RebekahCurseItems.COLLECTIBLE_SNAP) then
			if data.hasSnap then
				data.hasSnap = nil
				data.isSnappedTired = true
				player:AddCacheFlags(CacheFlag.CACHE_ALL);
				player:EvaluateItems()
				player:TryRemoveNullCostume(RebekahCurseCostumes.SnappedCos)
				--print("pog")
			elseif data.isSnappedTired then
				data.isSnappedTired = nil
				player:AddCacheFlags(CacheFlag.CACHE_ALL);
				player:EvaluateItems()
				
				player:AddNullCostume(RebekahCurseCostumes.UnsnappedCos)
				--print("pogchamp")
			end
		end
	end
end
yandereWaifu:AddCallback( ModCallbacks.MC_POST_NEW_ROOM, yandereWaifu.SnappedTiredNewRoom)

--stat cache for each mode
function yandereWaifu:snapcacheregister(player, cacheF) --The thing the checks and updates the game, i guess?
	local data = yandereWaifu.GetEntityData(player)
	if player:HasCollectible(RebekahCurseItems.COLLECTIBLE_SNAP) then
		--if data.SnapDelay then
		--	if cacheF == CacheFlag.CACHE_FIREDELAY then
		--		player.FireDelay = player.FireDelay - data.SnapDelay
		--	end
		--end
		if cacheF == CacheFlag.CACHE_FIREDELAY then
			if data.hasSnap then
				player.MaxFireDelay = player.MaxFireDelay - 2
			elseif data.isSnappedTired then
				player.MaxFireDelay = player.MaxFireDelay + 2
			end
		end
		if cacheF == CacheFlag.CACHE_DAMAGE then
			if data.hasSnap then
				player.Damage = player.Damage + ((player.Damage/3) * 2.5)
			elseif data.isSnappedTired then
				player.Damage = player.Damage - 1.5
			end
		end
		if cacheF == CacheFlag.CACHE_SPEED then
			if data.hasSnap then
				player.MoveSpeed = player.MoveSpeed + 0.25
			elseif data.isSnappedTired then
				player.MoveSpeed = player.MoveSpeed - 0.15
			end
		end
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, yandereWaifu.snapcacheregister)

--snap fart
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, function(_, eff)
	local sprite = eff:GetSprite()
	local data = yandereWaifu.GetEntityData(eff)
	eff.RenderZOffset = 10000;
	eff.SpriteOffset = Vector(0,-10)
end, RebekahCurse.ENTITY_SNAP_HEARTBEAT);

yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local sprite = eff:GetSprite();
	local data = yandereWaifu.GetEntityData(eff)
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
end, RebekahCurse.ENTITY_SNAP_HEARTBEAT);

yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, function(_, eff)
	local sprite = eff:GetSprite()
	local data = yandereWaifu.GetEntityData(eff)
	--eff.RenderZOffset = 10000;
	eff.SpriteOffset = Vector(0,-30)
	SFXManager():Play( RebekahCurseSounds.SOUND_ELECTRIC , 1, 0, false, 1.2 );
end, RebekahCurse.ENTITY_SNAP_EFFECT);

yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local sprite = eff:GetSprite();
	local data = yandereWaifu.GetEntityData(eff)
	local player = data.Player
		
	if sprite:IsFinished("snap") then
		eff:Remove()
	end
end, RebekahCurse.ENTITY_SNAP_EFFECT);
