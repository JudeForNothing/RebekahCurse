--local dash = require("codes_rebekah.characters.rebekah_B.dash")
local cache = require("codes_rebekah.characters.rebekah_B.cache")

local healthbar = Sprite();
healthbar:Load("gfx/ui/tainted_rebekah_healthbar.anm2", true);

local isTRebPresent = false
local isDevilDealAvailable = false

yandereWaifu:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(_, new)
	if not new then
		isTRebPresent = false
    end
end)

function yandereWaifu.AddTaintedBossHealth(player, num)
	local data = yandereWaifu.GetEntityData(player)
	data.PersistentPlayerData.TaintedHealth = data.PersistentPlayerData.TaintedHealth + num
end

function TaintedRebeccaInit(player)
	Isaac.DebugString("start")
	local mode 
	local data = yandereWaifu.GetEntityData(player)
	data.PersistentPlayerData.TaintedHealth = 50
    data.PersistentPlayerData.MaxTaintedHealth = 50
	data.PersistentPlayerData.MaxRageCrystal = 2
	data.lastNum = 50
	data.RageCrystal = 0

	--data.DASH_TAINTED_DOUBLE_TAP = InutilLib.DoubleTap:New();

	data.specialCooldown = 0 --cooldown special

	if player:GetPlayerType() == RebekahCurse.REB_CURSED then
		mode = REBECCA_MODE.CursedCurse
	end
	yandereWaifu.ApplyCostumes(mode, player, false, true)

	isTRebPresent = true

	data.currentMode = mode
	-- start the meters invisible
	data.moveMeterFadeStartFrame = -20;
	data.TaintedTearDelay = 0 --special thing i cant be bothered but to remake

	local hasPocket = yandereWaifu.HasCollectibleGuns(player)
	--for other characters who comes in but not on game_start
	local hasPocket = yandereWaifu.HasCollectibleMultiple(player, RebekahCurseItems.COLLECTIBLE_TAINTEDQ, RebekahCurseItems.COLLECTIBLE_WIZOOBTONGUE, RebekahCurseItems.COLLECTIBLE_APOSTATE, RebekahCurseItems.COLLECTIBLE_MAINLUA, RebekahCurseItems.COLLECTIBLE_PSALM45, RebekahCurseItems.COLLECTIBLE_BARACHIELSPETAL, RebekahCurseItems.COLLECTIBLE_FANG, RebekahCurseItems.COLLECTIBLE_BEELZEBUBSBREATH, RebekahCurseItems.COLLECTIBLE_COMFORTERSWING)
	if --[[Game():GetRoom():GetFrameCount() > 1 and]] not hasPocket then
		--yandereWaifu:SetRebekahPocketActiveItem( player, yandereWaifu.GetEntityData(player).currentMode )
		player:SetPocketActiveItem(RebekahCurseItems.COLLECTIBLE_TAINTEDQ)
	end
end

yandereWaifu:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, function(_,player)
	if yandereWaifu.IsTaintedRebekah(player) then
        TaintedRebeccaInit(player)
		Isaac.DebugString("START MOFO")
    end
end)

function yandereWaifu:TaintedRebekahcacheregister(player, cacheF) --The thing the checks and updates the game, i guess?
	local data = yandereWaifu.GetEntityData(player)
	local num, num2, num3
	if data.currentMode == REBECCA_MODE.BrideRedHearts and yandereWaifu.IsNormalRebekah(player) then num1 = 1 else num1 = 0 end
	--if data.currentMode == REBECCA_MODE.EternalHearts and yandereWaifu.IsNormalRebekah(player) then num2 = 1 else num2 = 0 end
	--if data.currentMode == REBECCA_MODE.BoneHearts and yandereWaifu.IsNormalRebekah(player) then num3 = 1 else num3 = 0 end
	if cacheF == CacheFlag.CACHE_FAMILIARS then
		player:CheckFamiliar(RebekahCurse.ENTITY_LABAN, num1, RNG())
		--player:CheckFamiliar(RebekahCurse.ENTITY_MORNINGSTAR, num2, RNG())
	--	player:CheckFamiliar(RebekahCurse.ENTITY_BONEJOCKEY, num3, RNG())
	end
	if yandereWaifu.IsTaintedRebekah(player) then -- Especially here!

		if ILIB.room:GetFrameCount() < 1 then
			yandereWaifu.ApplyCostumes( yandereWaifu.GetEntityData(player).currentMode, player , false, false)
		end

		cache.SetTaintedRebekahBaseStats(cacheF, player)

		--special interactions
		--isaac's tears, the d6, fate, maggy's bow, transcedence, divorce papers, polaroid and negative, isaac's head
		if player:HasCollectible(CollectibleType.COLLECTIBLE_ISAACS_TEARS) then
			if cacheF == CacheFlag.CACHE_FIREDELAY then
				player.MaxFireDelay = player.MaxFireDelay - 2
			end
		end
		if player:HasCollectible(CollectibleType.COLLECTIBLE_D6) then
			if cacheF == CacheFlag.CACHE_SPEED then
				player.MoveSpeed = player.MoveSpeed + 0.20
			end
		end
		if player:HasCollectible(CollectibleType.COLLECTIBLE_FATE) then
			if cacheF == CacheFlag.CACHE_FIREDELAY then
				player.MaxFireDelay = player.MaxFireDelay - 2
			end
		end	
		if player:HasCollectible(CollectibleType.COLLECTIBLE_MAGGYS_BOW) then
			if cacheF == CacheFlag.CACHE_DAMAGE then
				player.Damage = player.Damage + 1.77
			end
		end
		if player:HasCollectible(CollectibleType.COLLECTIBLE_WHORE_OF_BABYLON) then
			if cacheF == CacheFlag.CACHE_DAMAGE then
				player.Damage = player.Damage + 1.77
			end
		end
		if player:HasCollectible(CollectibleType.COLLECTIBLE_BOX_OF_FRIENDS) then
			if cacheF == CacheFlag.CACHE_DAMAGE then
				player.Damage = player.Damage + 1.77
			end
		end
		if player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_KNIFE) then
			if cacheF == CacheFlag.CACHE_SPEED then
				player.MoveSpeed = player.MoveSpeed + 0.20
			end
		end
		if player:HasCollectible(CollectibleType.COLLECTIBLE_TRANSCENDENCE) then
			if cacheF == CacheFlag.CACHE_FIREDELAY then
				player.MaxFireDelay = player.MaxFireDelay - 2
			end
		end
		if player:HasCollectible(CollectibleType.COLLECTIBLE_DIVORCE_PAPERS) then
			if cacheF == CacheFlag.CACHE_FIREDELAY then
				player.MaxFireDelay = player.MaxFireDelay - 1
			end
		end
		if player:HasCollectible(CollectibleType.COLLECTIBLE_POLAROID) then 
			if cacheF == CacheFlag.CACHE_FIREDELAY then
				player.MaxFireDelay = player.MaxFireDelay - 1
				--player.Damage = player.Damage + 1.77
			end
		end
		if player:HasCollectible(CollectibleType.COLLECTIBLE_NEGATIVE) then
			if cacheF == CacheFlag.CACHE_FIREDELAY then
				player.MaxFireDelay = player.MaxFireDelay - 1
				--player.Damage = player.Damage + 1.77
			end
		end
	end
	
end
yandereWaifu:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, yandereWaifu.TaintedRebekahcacheregister)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_NEW_ROOM,
	function()
		local num_players = Game():GetNumPlayers()
		for i=0,(num_players-1) do
			local player = Isaac.GetPlayer(i)
			if not yandereWaifu.IsTaintedRebekah(player) then return end
			local data = yandereWaifu.GetEntityData(player)
			--data.DASH_TAINTED_DOUBLE_TAP:Reset();
			player:AddSoulHearts(2)

			data.lastMode = data.currentMode

			--if data.IsDashActive then data.IsDashActive = false end --stop any active dashes
			data.IsUninteractible = false 
			isTRebPresent = true

			if player:GetExtraLives() > 0 and data.PersistentPlayerData.MaxTaintedHealth <= 0 and data.PersistentPlayerData.TaintedHealth <= 0 then
				data.PersistentPlayerData.MaxTaintedHealth = data.PersistentPlayerData.MaxTaintedHealth+ 50
				yandereWaifu.AddTaintedBossHealth(player, 50)
			end
		end
		isDevilDealAvailable = false
	end
)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_,player)
	--local player = Isaac.GetPlayer(0);
    local room = Game():GetRoom();
	local data = yandereWaifu.GetEntityData(player)
	--print(player:GetPlayerType())
	
	if yandereWaifu.IsTaintedRebekah(player) then
		--print("LAB")
		--print(data.PersistentPlayerData.TaintedHealth)
		--print(data.PersistentPlayerData.MaxTaintedHealth)
		local iframes = 15
		if player:GetDamageCooldown() > iframes then
			player:ResetDamageCooldown()
			player:SetMinDamageCooldown(iframes)
		  end
		if data.TaintedRageTick then
			if data.TaintedRageTick > 0 then data.TaintedRageTick = data.TaintedRageTick - 1 end
		end

		yandereWaifu.HandleTaintedRebHeart(player)
		if InutilLib.HasCollectiblesUpdated(player) == true then
			player:AddCacheFlags(CacheFlag.CACHE_ALL);
			player:EvaluateItems()
		end
		--cooldown stuff
		if data.specialCooldown > 0 then data.specialCooldown = data.specialCooldown - 1 end

		--revive code stuff
		if (player:IsCoopGhost()) and not data.CoopDead then
			data.CoopDead = true
			player:GetSprite():ReplaceSpritesheet(0, "gfx/characters/ghost_rebekah.png")
			player:GetSprite():ReplaceSpritesheet(1, "gfx/characters/ghost_rebekah.png")
			player:GetSprite():LoadGraphics()
		end
		if not player:IsCoopGhost() and data.CoopDead then
			data.CoopDead = false
			--yandereWaifu.ApplyCostumes( yandereWaifu.GetEntityData(player).currentMode, player , true)
		end
		
		--dash skill
		--[[local keyboardKey=nil
		local controllerKey=0
		local disenableDashByKey = false
		local controller = player.ControllerIndex;
		keyboardKey = RebekahLocalSavedata.Config.rebekahdashkey
		controllerKey = RebekahLocalSavedata.Config.rebekahdashkey
		disenableDashByKey = RebekahLocalSavedata.Config.disablerebekahdash
		if not disenableDashByKey then
			if not data.DASH_TAINTED_DOUBLE_TAP_READY then
				if not data.DASH_TAINTED_DOUBLE_TAP then
					data.DASH_TAINTED_DOUBLE_TAP = InutilLib.DoubleTap:New();
				end
				yandereWaifu.GetEntityData(player).DASH_TAINTED_DOUBLE_TAP:AttachCallback( function(vector, playerTapping)
					dash.CursedRebekahDoubleTapDash(vector, player)
				end)
				data.DASH_TAINTED_DOUBLE_TAP_READY = true
			end
		else
			if data.DASH_TAINTED_DOUBLE_TAP_READY then
				data.DASH_TAINTED_DOUBLE_TAP_READY = nil
				data.DASH_TAINTED_DOUBLE_TAP = nil
			end
		end
		if (player:GetMovementInput().X ~= 0 or player:GetMovementInput().Y ~= 0) then
			if keyboardKey or controllerKey then
				if (Input.IsButtonTriggered(keyboardKey,controller) or Input.IsButtonTriggered(controllerKey,controller)) then
					dash.CursedRebekahDoubleTapDash(vector, player)
				end
				--if data.DASH_TAINTED_DOUBLE_TAP_READY then
				--	data.DASH_TAINTED_DOUBLE_TAP_READY = nil
				--	data.DASH_TAINTED_DOUBLE_TAP = nil
				--end
			end
		end]]
		
		if data.IsParalysed then 
			if not data.ParalysedCooldown then data.ParalysedCooldown = 200 end
			if data.ParalysedCooldown <= 0 then
				data.IsParalysed = nil 
				data.ParalysedCooldown = nil
			else
				data.ParalysedCooldown = data.ParalysedCooldown - 1
			end
		end

		--targetting system
		local target = InutilLib.GetClosestGenericEnemy(player, 160)
		--incase glory kill is nearby
		local dist = 100
		local closestDist = 999999
		for i, e in pairs(Isaac.GetRoomEntities()) do
			if e.Type == 1000 and yandereWaifu.GetEntityData(e).IsGlorykill then
				local minDist = dist or 100
				if (player.Position - e.Position):Length() < 160 + e.Size then
					if (player.Position - e.Position):Length() < closestDist + e.Size then
						closestDist = (player.Position - e.Position):Length()
						target = e
					end
				end
			end
		end
		if target then
			if data.TaintedEnemyTarget then
				if data.TaintedEnemyTarget and data.TaintedEnemyTarget:IsDead() then
					data.TaintedEnemyTarget = nil
					return
				end
				if target.Position:Distance(player.Position) - target.Size <= data.TaintedEnemyTarget.Position:Distance(player.Position) - data.TaintedEnemyTarget.Size then
					--remove old target
					yandereWaifu.GetEntityData(data.TaintedEnemyTarget).Target:Remove()
					--add new target
					local target_eff = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_TAINTEDCURSEENEMYTARGET, 0, target.Position, Vector.Zero, player)
					yandereWaifu.GetEntityData(target_eff).Target = target
					yandereWaifu.GetEntityData(target).Target = target_eff
					data.TaintedEnemyTarget = target
				end
			else
				local target_eff = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_TAINTEDCURSEENEMYTARGET, 0, target.Position, Vector.Zero, player)
				yandereWaifu.GetEntityData(target_eff).Target = target
				yandereWaifu.GetEntityData(target).Target = target_eff
				data.TaintedEnemyTarget = target
			end
		else
			if data.TaintedEnemyTarget and not data.TaintedEnemyTarget:IsDead() then
				--remove old target
				yandereWaifu.GetEntityData(data.TaintedEnemyTarget).Target:Remove()
			end
			data.TaintedEnemyTarget = nil
		end

		--glorykill 
		if data.IsGlorykillMode then
			if not data.TAINTEDREBSKILL_MENU.open then
				data.TAINTEDREBSKILL_MENU:ToggleMenu(true)
			end
			data.RageCrystal = data.PersistentPlayerData.MaxRageCrystal
		end

		local willDie = false
		--devil deal stuff
		if data.PersistentPlayerData.currentQueuedDevilItem then
            local pickup = data.PersistentPlayerData.currentQueuedDevilItem
            local heartCost = 25
			local heartSoulCost = 15
            if pickup.Price == -1 then
                --1 Red
                if heartCost >= data.PersistentPlayerData.MaxTaintedHealth then
					willDie = true
				end
				data.PersistentPlayerData.MaxTaintedHealth = data.PersistentPlayerData.MaxTaintedHealth - heartCost
            elseif pickup.Price == -2 then
                --2 Red
				if heartCost*2 >= data.PersistentPlayerData.MaxTaintedHealth then
					willDie = true
				end
				data.PersistentPlayerData.MaxTaintedHealth = data.PersistentPlayerData.MaxTaintedHealth - heartCost*2
            elseif pickup.Price == -3 then
                --3 soul
                if heartSoulCost*3 >= data.PersistentPlayerData.MaxTaintedHealth then
					willDie = true
				end
				data.PersistentPlayerData.MaxTaintedHealth = data.PersistentPlayerData.MaxTaintedHealth - heartSoulCost*3
            elseif pickup.Price == -4 then
                --1 Red, 2 Soul
				if heartCost + (heartSoulCost*2) >= data.PersistentPlayerData.MaxTaintedHealth then
					willDie = true
				end
				data.PersistentPlayerData.MaxTaintedHealth = data.PersistentPlayerData.MaxTaintedHealth - (heartCost  + (heartSoulCost*2))
            elseif pickup.Price == -7 then
                --1 Soul
                if heartSoulCost >= data.PersistentPlayerData.MaxTaintedHealth then
					willDie = true
				end
				data.PersistentPlayerData.MaxTaintedHealth = data.PersistentPlayerData.MaxTaintedHealth - heartSoulCost
            elseif pickup.Price == -8 then
                --2 Souls
                if heartSoulCost*2 >= data.PersistentPlayerData.MaxTaintedHealth then
					willDie = true
				end
				data.PersistentPlayerData.MaxTaintedHealth = data.PersistentPlayerData.MaxTaintedHealth - heartSoulCost*2
            elseif pickup.Price == -9 then
                --1 Red, 1 Soul
                if heartCost + (heartSoulCost) >= data.PersistentPlayerData.MaxTaintedHealth then
					willDie = true
				end
				data.PersistentPlayerData.MaxTaintedHealth = data.PersistentPlayerData.MaxTaintedHealth - (heartCost  + (heartSoulCost))
            else
                return true
            end
            data.PersistentPlayerData.currentQueuedDevilItem = nil
        end

		--extra health stuff
		local hp, maxhp = data.PersistentPlayerData.TaintedHealth, data.PersistentPlayerData.MaxTaintedHealth
        if hp < 1 then
            player:Kill()
			Isaac.DebugString("END MOFO")
			print("WHAT")
        end
		if willDie then
            player:Kill()
			Isaac.DebugString("END 2 MOFO")
        end

		if data.PersistentPlayerData.MaxTaintedHealth < data.PersistentPlayerData.TaintedHealth then
			data.PersistentPlayerData.TaintedHealth = data.PersistentPlayerData.MaxTaintedHealth
		end

		--if crystal fragments has reached more than 3
		if data.PersistentPlayerData.WrathFragmentCount and data.PersistentPlayerData.WrathFragmentCount >= 3 then
			data.PersistentPlayerData.MaxRageCrystal = data.PersistentPlayerData.MaxRageCrystal + math.floor(data.PersistentPlayerData.WrathFragmentCount/3)
			data.PersistentPlayerData.WrathFragmentCount = data.PersistentPlayerData.WrathFragmentCount % 3
		end
	end
end)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
	
	for p = 0, ILIB.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		local data = yandereWaifu.GetEntityData(player)
		if player:GetPlayerType() == 0 then
			IsaacPresent = true
		elseif player:GetPlayerType() == 19 then
			JacobPresent = true
		end
		if yandereWaifu.IsTaintedRebekah(player) then
			
			--[[if player:GetMovementInput() and yandereWaifu.GetEntityData(player).DASH_TAINTED_DOUBLE_TAP_READY then
				yandereWaifu.GetEntityData(player).DASH_TAINTED_DOUBLE_TAP:Update( player:GetMovementInput() , player );
			end]]

			if not data.invincibleTime then data.invincibleTime = 0 end --invincible time
			if data.invincibleTime > 0 then data.invincibleTime = data.invincibleTime - 1 end --frames on counting down how much time you can be invincible
			InutilLib.UpdateTimers();
			
		end
	end
end);

--Handle base health
function yandereWaifu.HandleTaintedRebHeart(player)

	local data = yandereWaifu.GetEntityData(player)
	if not yandereWaifu.IsTaintedRebekah(player) then return end
	if player:GetHearts() > 1 then
		local neededHearts = 0-player:GetHearts()+1
		data.PersistentPlayerData.TaintedHealth = yandereWaifu.AddTaintedBossHealth(player, data.PersistentPlayerData.TaintedHealth + math.abs(neededHearts*25))
		player:AddHearts(neededHearts)
	end
	if player:GetMaxHearts() > 6 then
		local neededHearts = player:GetMaxHearts()-6
		data.PersistentPlayerData.MaxTaintedHealth = data.PersistentPlayerData.MaxTaintedHealth + (neededHearts*25)
		player:AddMaxHearts(-neededHearts--[[+2]])
	end
	if player:GetBoneHearts() > 0 then
		player:AddBoneHearts(-player:GetBoneHearts())
	end
	if player:GetEternalHearts() > 0 then
		player:AddEternalHearts(-1)
	end
	if player:GetGoldenHearts() > 0 then
		player:AddGoldenHearts(-24)
	end
	if player:GetSoulHearts() > 2 then
		player:AddSoulHearts(-player:GetSoulHearts()+2)
	--[[else
		player:AddSoulHearts(2)]]
	end
	--add increment incase
	if player:GetMaxHearts() < 6 then
		local neededHearts = 6-player:GetMaxHearts()
		player:AddMaxHearts(neededHearts)
	end

	--correct health
	if data.PersistentPlayerData.TaintedHealth >= data.PersistentPlayerData.MaxTaintedHealth then
		data.PersistentPlayerData.TaintedHealth = data.PersistentPlayerData.MaxTaintedHealth
	end
end

yandereWaifu:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, function(_, pickup, coll, bool)
	if coll:ToPlayer() then
		local player = coll:ToPlayer()
		local entityData = yandereWaifu.GetEntityData(player);
		if yandereWaifu.IsTaintedRebekah(player) then
			if pickup.Variant == PickupVariant.PICKUP_HEART then
				return false
			elseif pickup.Variant == RebekahCurse.ENTITY_WRATHCRYSTALFRAGMENT and not pickup.Touched and yandereWaifu.IsTaintedRebekah(player) then
				if not entityData.PersistentPlayerData.WrathFragmentCount then entityData.PersistentPlayerData.WrathFragmentCount = 0 end
				entityData.PersistentPlayerData.WrathFragmentCount = entityData.PersistentPlayerData.WrathFragmentCount + 1
				InutilLib.PickupPickup(pickup)
				pickup.Touched = true
				return true
			end
		end
	end
end)


--Take damage logic 
yandereWaifu:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, damage, amount, damageFlag, damageSource, damageCountdownFrames) --invincibilityframe when dashing or whatnot
	local player = damage:ToPlayer();
	local data = yandereWaifu.GetEntityData(player)
	if player and yandereWaifu.IsTaintedRebekah(player) then

		if data.invincibleTime and data.invincibleTime > 0 then return false end
		local takenDmg = 0
        if damageFlag & DamageFlag.DAMAGE_SPIKES > 0 and math.random(1,2) == 2 then
			takenDmg = 5
		elseif (damageFlag & DamageFlag.DAMAGE_TNT > 0 or damageFlag & DamageFlag.DAMAGE_EXPLOSION > 0) and not damage:ToPlayer():HasCollectible(CollectibleType.COLLECTIBLE_PYROMANIAC) then
			takenDmg = 50
		elseif damageFlag & DamageFlag.DAMAGE_CRUSH > 0 then
			takenDmg = 25
		elseif damageFlag & DamageFlag.DAMAGE_FIRE > 0 then
			takenDmg = 10
		elseif damageFlag & DamageFlag.DAMAGE_LASER > 0 then
			takenDmg = 10
		elseif damageFlag & DamageFlag.DAMAGE_PITFALL > 0 then
			takenDmg = 25
		elseif damageFlag & DamageFlag.DAMAGE_POOP > 0 then
			takenDmg = 5
		elseif damageFlag & DamageFlag.DAMAGE_RED_HEARTS > 0 then
			takenDmg = 10
		else
			damageSource = damageSource.Entity
			if damageSource then

				if damageSource.Type == 9 then
					takenDmg = 10
				elseif damageSource:IsEnemy() then
					if damageSource:IsBoss() then
						takenDmg = 2
					else
						takenDmg = 5
					end

					if damageSource:ToNPC():IsChampion() then
						takenDmg = takenDmg*2
					end
				end
			else
				takenDmg = 5
			end
		end

		if not player:HasCollectible(CollectibleType.COLLECTIBLE_WAFER) then
			if ILIB.game:IsGreedMode() then
				if ILIB.level:GetAbsoluteStage() >= LevelStage.STAGE5_GREED then
					takenDmg = takenDmg * 2
				end
			else
				if ILIB.level:GetAbsoluteStage() >= LevelStage.STAGE4_1 then
					takenDmg = takenDmg * 2
				end
			end
		end
		yandereWaifu.AddTaintedBossHealth(player, -takenDmg)
		local hp, maxhp = data.PersistentPlayerData.TaintedHealth, data.PersistentPlayerData.MaxTaintedHealth

        healthbar.Color = Color(1,0,0,1,0,0,0)
        InutilLib.SetTimer(15, function()
			healthbar.Color = Color(0,0,0,1,0,0,0)
		end)
        if hp < 1 then
            player:Kill()
        end
		if maxhp < 1 then
            player:Kill()
        end
		if (hp % 10) == 0 then
            player:AddSoulHearts(amount*2) --i had to multiply this because custom heart api is making this hard
			player:ResetDamageCooldown()
			player:SetMinDamageCooldown(5)
			--player:TakeDamage( 1, DamageFlag.DAMAGE_NOKILL, EntityRef(damageSource), 2);
            return true
        else
            return false
        end
    end
end, EntityType.ENTITY_PLAYER)

--on bumping collision
--[[yandereWaifu:AddCallback(ModCallbacks.MC_PRE_NPC_COLLISION, function(_, eff, coll, low)
	if coll.Type == 1 and yandereWaifu.IsTaintedRebekah(coll:ToPlayer()) then
		eff:TakeDamage(1, 0, EntityRef(coll), 1)
	end
end)]]

local font = Font()
font:Load("font/pftempestasevencondensed.fnt")

function yandereWaifu.taintedheartReserveRenderLogic(player, id)
	local data = yandereWaifu.GetEntityData(player)
	if ILIB.game:GetHUD():IsVisible() and not player.Parent then
		local position = Vector(50,12)
		if id == 1 then
			position = Vector(338,74)
		elseif id == 2 then
			position = Vector(58,210)
		elseif id == 3 then
			position = Vector(338,210)
		end
		--print(player.Position.X)
		--if InutilLib.IsInMirroredFloor(player) then
			--position.X = position.X * -1
		--	 position = Isaac.WorldToScreen(Vector((player.Position.X * -1)-(player.Position.X * -1),player.Position.Y))
		--end
		--print(position.X)
		
		local room = ILIB.game:GetRoom()
		local gameFrame = ILIB.game:GetFrameCount();
		--if yandereWaifu.IsNormalRebekah(player) then
			if not (room:GetType() == RoomType.ROOM_BOSS and not room:IsClear() and room:GetFrameCount() < 1) then
				if data.PersistentPlayerData.MaxTaintedHealth > 0 then
					local percent = (data.PersistentPlayerData.TaintedHealth/data.PersistentPlayerData.MaxTaintedHealth)*100
					healthbar:SetFrame("Bar", math.ceil(percent) or 0)
					--heartReserve:RenderLayer(1, (position), Vector(0,0), Vector(0,0))
				else
					healthbar:SetFrame("Bar", 0)
				end
				healthbar:Render((position + (Options.HUDOffset * Vector(20, 12))), Vector(0,0), Vector(0,0))
				healthbar.Color = Color(1,1,1,1,0,0,0)
				if player:GetExtraLives() > 0 then
					local text = "x" .. tostring(player:GetExtraLives())
					--Isaac.RenderText(tostring(text),position.X, position.Y+15, 1 ,1 ,1 ,1 )
					font:DrawString(text,position.X, position.Y+10,KColor(1,1,1,1,0,0,0),0,true)
				end
			end
		--end

		if isDevilDealAvailable then
			print("hefef")
			local text = math.floor(data.PersistentPlayerData.MaxTaintedHealth)
			local rng = math.random(1,10)
			if rng == 10 then
				data.eyecolor = KColor(0,0,0,1,0,0,0)
			else
				if math.random(1,30) == 30 then
					data.eyecolor = KColor(1,1,1,1,0,0,0)
				else
					data.eyecolor = KColor(1,0,0,1,0,0,0)
				end
			end
			if player.FrameCount % 15 == 0 then
				data.eyerenderx = math.random(10,12)/10
				data.eyerendery = math.random(10,12)/10
				data.eyeoffset = math.random(1,3)
			end
			if not data.eyerenderx then
				data.eyerenderx = math.random(10,12)/10
				data.eyerendery = math.random(10,12)/10
				data.eyeoffset = math.random(1,3)
			end
			--Isaac.RenderText(tostring(text),Isaac.WorldToScreen(npc.Position).X-7,  Isaac.WorldToScreen(npc.Position).Y-15, 1 ,1 ,1 ,1 )
			local f = Font() -- init font object
			f:Load("font/pftempestasevencondensed.fnt") -- load a font into the font object
			f:DrawStringScaled (text,position.X+35-data.eyeoffset,position.Y+5-data.eyeoffset, data.eyerenderx, data.eyerendery, data.eyecolor,0,true)
		end
	end
end

local rageCrystalIndicator = Sprite();
rageCrystalIndicator:Load("gfx/ui/rage_crystal_counter.anm2", true);

function yandereWaifu.RageCrystalRenderLogic(player)

	local data = yandereWaifu.GetEntityData(player)
		local room = ILIB.game:GetRoom()
		local gameFrame = ILIB.game:GetFrameCount();
		if yandereWaifu.IsTaintedRebekah(player) then
			if player.Visible and not (room:GetType() == RoomType.ROOM_BOSS and not room:IsClear() and room:GetFrameCount() < 1) then
				rageCrystalIndicator:SetOverlayRenderPriority(true)

				--move
				if data.RageCrystal then --for special cooldown for bone heart
					rageCrystalIndicator:SetFrame("Count", data.RageCrystal)
				end
				
				local playerLocation = Isaac.WorldToScreen(player.Position)
				--print(InutilLib.IsInMirroredFloor(player))
				--if not InutilLib.IsInMirroredFloor(player) then
				rageCrystalIndicator:Render(playerLocation + Vector(0, 5), Vector(0,0), Vector(0,0));
				--end
			end
		end
end



yandereWaifu:AddCallback(ModCallbacks.MC_GET_SHADER_PARAMS, function(_, name)
	local excludeBetaFiends = 0 --yeah thats right, esau and strawmen are beta fiends
	for p = 0, ILIB.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		if yandereWaifu.IsTaintedRebekah(player) then
            if name ~= "UI_DrawRebekahHUD_DummyShader" then return end
            yandereWaifu.taintedheartReserveRenderLogic(player, p - excludeBetaFiends)
        end
    end
end)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, function(_, _)
	if Options.ChargeBars then
		for p = 0, ILIB.game:GetNumPlayers() - 1 do
			local player = Isaac.GetPlayer(p)
			if yandereWaifu.IsTaintedRebekah(player) then
				yandereWaifu.RageCrystalRenderLogic(player)
				yandereWaifu.meterLogic(player)
			end
		end
	end
end);

--crystal gaining menu
--[[yandereWaifu:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, damage, amount, damageFlag, damageSource, damageCountdownFrames) --invincibilityframe when dashing or whatnot
	if not damageSource.Entity then return true end
	local player 

	if not damageSource.Entity.SpawnerEntity then 
		player = damageSource.Entity:ToPlayer(); 
	else
		player = damageSource.Entity.SpawnerEntity:ToPlayer();
	end
	if not player then player = damageSource.Entity:ToPlayer(); end
	local data = yandereWaifu.GetEntityData(player)
	if player and yandereWaifu.IsTaintedRebekah(player) then
		if data.CantGiveCrystal then return end
		if not data.HitForCrystal then
			data.HitForCrystal = true 
		elseif data.HitForCrystal then
			data.HitForCrystal = false
			if not data.RageCrystal then
				data.RageCrystal = 1 
			elseif data.RageCrystal < data.PersistentPlayerData.MaxRageCrystal then
				local multiplier = 1
				if data.TaintedRageTick and data.TaintedRageTick > 0 then multiplier = 2 end
				data.RageCrystal =  data.RageCrystal + 1*multiplier
				if data.RageCrystal >= data.PersistentPlayerData.MaxRageCrystal then data.RageCrystal = data.PersistentPlayerData.MaxRageCrystal end
			end
		end
    end
end)]]


--tainted rebekah skill menu basics
local skills = {
	[0] = {sprite="gfx/ui/spells/cursed/cut.png", price = 0, maxcharge = 100},
	[1] = {sprite="gfx/ui/spells/cursed/slam.png", price = 1, maxcharge = 10},
	[2] = {sprite="gfx/ui/spells/cursed/strike.png", price = 2, maxcharge = 900},
	[3] = {sprite="gfx/ui/spells/cursed/rage.png", price = 3, maxcharge = 1800}
}
yandereWaifu:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, function(_, player)
	local data = yandereWaifu.GetEntityData(player)
	local controller = player.ControllerIndex;
	if yandereWaifu.IsTaintedRebekah(player) then
		if not data.TAINTEDREBSKILL_MENU then --set menu
			
			data.TAINTEDREBSKILL_MENU = yandereWaifu.TaintedSkillMenu:New(Isaac.WorldToScreen(player.Position + Vector(0, -90)), skills);
			
			data.TAINTEDREBSKILL_MENU:AttachCallback( function(dir, value, isAvailable)
				if data.TAINTEDREBSKILL_MENU.onRelease then
					
					--print(data.currentIndex)
					--if selected stuff code
					if dir and isAvailable and data.selectedTaintedRebSkill then

							
						--if not isDiffused then
						--data.TAINTEDREBSKILL_MENU:ToggleMenu()
						--end
						data.selectedTaintedRebSkill = false
						if data.CantTaintedSkill then return end
						if data.TAINTEDREBSKILL_MENU.chargecooldown[value] <= 0 or data.IsGlorykillMode then
							if data.TAINTEDREBSKILL_MENU.options[value].price <= data.RageCrystal or  data.IsGlorykillMode then
								local success = false
								if not data.taintedWeapon then
									yandereWaifu.SpawnCursedKnife(player)
								end
								if value == 0 and data.TaintedEnemyTarget and not data.TaintedEnemyTarget:IsDead() then
									success = true
									local IsLokiHornsTriggered = false

									if player:HasCollectible(CollectibleType.COLLECTIBLE_LOKIS_HORNS) and math.random(0,10) + player.Luck >= 10 then
										IsLokiHornsTriggered = true
									else
										IsLokiHornsTriggered = false
									end

									for lhorns = 0, 270, 360/4 do
										local direction = (data.TaintedEnemyTarget.Position - player.Position):GetAngleDegrees() + lhorns
										local oldDir = direction
										for wizAng = -45, 90, 135 do
											if player:HasCollectible(CollectibleType.COLLECTIBLE_THE_WIZ) and lhorns == 0 then --sets the wiz angles
												direction = (direction + wizAng)
											end
											yandereWaifu.SwingCursedKnife(player, data.taintedWeapon, 3, direction)

											if wizAng == -45 and not player:HasCollectible(CollectibleType.COLLECTIBLE_THE_WIZ) then
												break -- just makes sure it doesnt duplicate
											end
										end

										direction = oldDir
										if not IsLokiHornsTriggered then 
											break
										end
									end
								elseif value == 1 and data.TaintedEnemyTarget and not data.TaintedEnemyTarget:IsDead() then
									success = true
									yandereWaifu.SwingCursedKnife(player, data.taintedWeapon, 4, ((data.TaintedEnemyTarget.Position - player.Position):GetAngleDegrees()))
								elseif value == 2 and data.TaintedEnemyTarget and not data.TaintedEnemyTarget:IsDead() then
									success = true
									yandereWaifu.SwingCursedKnife(player, data.taintedWeapon, 5, ((data.TaintedEnemyTarget.Position - player.Position):GetAngleDegrees()))
								elseif value == 3 then
									success = true
									InutilLib.SFX:Play( RebekahCurseSounds.SOUND_CURSED_RAGE, 0.8, 0, false, 1 );
									data.TaintedRageTick = 210
									local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_REBEKAH_DUST, RebekahCurseDustEffects.ENTITY_REBEKAH_RAGE_CIRCLE, player.Position, Vector.Zero, player)
									yandereWaifu.GetEntityData(poof).Parent = player
									player:SetColor(Color(1,0,0,1,0,0,0), data.TaintedRageTick, 2, false, true)
								end
								if success and not data.IsGlorykillMode then
									data.TAINTEDREBSKILL_MENU:ChargeSkill(value)
									data.RageCrystal = data.RageCrystal - data.TAINTEDREBSKILL_MENU.options[value].price
								end
								data.TAINTEDREBSKILL_MENU.lastVector = Vector(0,0)

							end
						end
						data.TAINTEDREBSKILL_MENU.lastVector = Vector.Zero
					end
				else
					if dir then --if selecting
						data.selectedTaintedRebSkill = true
					end
				end
			end)
		else
			data.TAINTEDREBSKILL_MENU:Update( player:GetShootingInput(), Isaac.WorldToScreen(player.Position + Vector(0, -90)), player )
			
			--if not data.InitTAINTEDREBSKILL_MENU then
				local wiresValue = {
					[0] = 0,
					[1] = 1,
					[2] = 2,
					[3] = 3
				}
				--if already at the end
				data.TAINTEDREBSKILL_MENU:UpdateOptions(skills, wiresValue)
				data.InitTAINTEDREBSKILL_MENU = true
			--end
		end
	else
		if data.TAINTEDREBSKILL_MENU then data.TAINTEDREBSKILL_MENU:Remove() end
	end
end);

function yandereWaifu:useRebekahTaintedQ(collItem, rng, player)
	local data = yandereWaifu.GetEntityData(player)
	if data.TAINTEDREBSKILL_MENU then --reset in case
		data.TAINTEDREBSKILL_MENU.lastVector = Vector.Zero
		data.TAINTEDREBSKILL_MENU.onRelease = false
		data.selectedTaintedRebSkill = false
	end
	
	--data.StoredBodyHeartsAndCrafts = GetAllHeartsInTable(player)
	
	data.TAINTEDREBSKILL_MENU:ToggleMenu()
	--if slot == ActiveSlot.SLOT_POCKET then slot = true else slot = false end
	--InutilLib.ToggleShowActive(player, false, slot)
	
	--data.refreshDysmorphiaChoiceFrame = cyclePerFrame
end
yandereWaifu:AddCallback( ModCallbacks.MC_USE_ITEM, yandereWaifu.useRebekahTaintedQ, RebekahCurseItems.COLLECTIBLE_TAINTEDQ );

function yandereWaifu:useReroll2(collItem, rng, player)
	--for p = 0, ILIB.game:GetNumPlayers() - 1 do
	--	local player = Isaac.GetPlayer(p)
		if yandereWaifu.IsTaintedRebekah(player) then
			yandereWaifu.ApplyCostumes( yandereWaifu.GetEntityData(player).currentMode, player );
			--player:AddNullCostume(NerdyGlasses)
		end
	--end
end
yandereWaifu:AddCallback(ModCallbacks.MC_USE_ITEM, yandereWaifu.useReroll2, CollectibleType.COLLECTIBLE_D4)
yandereWaifu:AddCallback(ModCallbacks.MC_USE_ITEM, yandereWaifu.useReroll2, CollectibleType.COLLECTIBLE_D100)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_PICKUP_RENDER, function(_, pickup)
	local sprite = pickup:GetSprite();
	local data = yandereWaifu.GetEntityData(pickup);

	local function price()
		local heartCost = 25
		local heartSoulCost = 15
		local word = 0
		if pickup.Price == -1 then
			--1 Red
			word = heartCost
		elseif pickup.Price == -2 then
			--2 Red
			word = heartCost*2
		elseif pickup.Price == -3 then
			--3 soul
			word = heartSoulCost*3
		elseif pickup.Price == -4 then
			--1 Red, 2 Soul
			word = (heartCost  + (heartSoulCost*2))
		elseif pickup.Price == -7 then
			--1 Soul
			word = heartSoulCost
		elseif pickup.Price == -8 then
			--2 Souls
			word = heartSoulCost*2
		elseif pickup.Price == -9 then
			--1 Red, 1 Soul
			word = (heartCost  + (heartSoulCost))
		end
		return word
	end
	
	if pickup.Price < 0 and isTRebPresent then
		isDevilDealAvailable = true
		local text = math.floor(price())
		local rng = math.random(1,10)
		if rng == 10 then
			data.eyecolor = KColor(0,0,0,1,0,0,0)
		else
			if math.random(1,30) == 30 then
				data.eyecolor = KColor(1,1,1,1,0,0,0)
			else
				data.eyecolor = KColor(1,0,0,1,0,0,0)
			end
		end
		if pickup.FrameCount % 15 == 0 then
			data.eyerenderx = math.random(6,12)/10
			data.eyerendery = math.random(8,12)/10
			data.eyeoffset = math.random(-5,5)
		end
		if not data.eyerenderx then
			data.eyerenderx = math.random(6,12)/10
			data.eyerendery = math.random(8,12)/10
			data.eyeoffset = math.random(-5,5)
		end
		--Isaac.RenderText(tostring(text),Isaac.WorldToScreen(npc.Position).X-7,  Isaac.WorldToScreen(npc.Position).Y-15, 1 ,1 ,1 ,1 )
		local f = Font() -- init font object
		f:Load("font/pftempestasevencondensed.fnt") -- load a font into the font object
		f:DrawStringScaled (text,Isaac.WorldToScreen(pickup.Position).X-16-data.eyeoffset,Isaac.WorldToScreen(pickup.Position).Y+5-data.eyeoffset, data.eyerenderx, data.eyerendery, data.eyecolor,0,true)
	end
end)