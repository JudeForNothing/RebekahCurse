local dash = require("codes_rebekah.characters.rebekah_B.dash")
local cache = require("codes_rebekah.characters.rebekah_B.cache")

local healthbar = Sprite();
healthbar:Load("gfx/ui/tainted_rebekah_healthbar.anm2", true);


function TaintedRebeccaInit(player)

	local data = yandereWaifu.GetEntityData(player)
	data.PersistentPlayerData.TaintedHealth = 50
    data.PersistentPlayerData.MaxTaintedHealth = 50
	data.PersistentPlayerData.MaxRageCrystal = 3
	data.RageCrystal = 0

	data.DASH_TAINTED_DOUBLE_TAP = InutilLib.DoubleTap:New();

	data.specialCooldown = 0 --cooldown special

	yandereWaifu.ApplyCostumes(REBECCA_MODE.CursedCurse, player , false, false)

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

		--[[if ILIB.room:GetFrameCount() < 1 then
			yandereWaifu.ApplyCostumes( yandereWaifu.GetEntityData(player).currentMode, player , false, false)
		end]]

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
		local hasTaintedReb = false
		local num_players = Game():GetNumPlayers()
		for i=0,(num_players-1) do
			local player = Isaac.GetPlayer(i)
			if not yandereWaifu.IsTaintedRebekah(player) then return end
			local data = yandereWaifu.GetEntityData(player)
			data.DASH_TAINTED_DOUBLE_TAP:Reset();
			player:AddSoulHearts(2)

			if data.IsDashActive then data.IsDashActive = false end --stop any active dashes
			data.IsUninteractible = false 
			hasTaintedReb = true
		end
		if hasTaintedReb then
			for j, pickup in pairs (Isaac.FindByType(EntityType.ENTITY_PICKUP, 100, -1, false, false)) do
				pickup = pickup:ToPickup()
				--is devil deals
				print(pickup.Price)
			end
		end
	end
)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_,player)
	--local player = Isaac.GetPlayer(0);
    local room = Game():GetRoom();
	local data = yandereWaifu.GetEntityData(player)
	--print(player:GetPlayerType())
	
	if yandereWaifu.IsTaintedRebekah(player) then

		--test fly
		if data.TaintedRageTick then
			if data.TaintedRageTick > 0 then data.TaintedRageTick = data.TaintedRageTick - 1 end
		end
		if data.TaintedRageTick and data.TaintedRageTick == 1 then
			print("stopped")
			Isaac.Spawn( EntityType.ENTITY_FLY, 0, 0, player.Position,  Vector(0,0), player );
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
		local keyboardKey=nil
		local controllerKey=0
		local disenableDashByKey = false
		local controller = player.ControllerIndex;
		--[[if ModConfigMenu then
			keyboardKey = ModConfigMenu.Config["Cursed Rebekah"]["Rebekah Dash Keyboard Binding"]
			controllerKey = ModConfigMenu.Config["Cursed Rebekah"]["Rebekah Dash Controller Binding"]
			disenableDashByKey = ModConfigMenu.Config["Cursed Rebekah"]["Rebekah Dash Alternative Key Enable"]
		end]]
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
		end
		
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
		local target = InutilLib.GetClosestGenericEnemy(player, 140)
		if target then
			if data.TaintedEnemyTarget then
				if data.TaintedEnemyTarget and data.TaintedEnemyTarget:IsDead() then
					data.TaintedEnemyTarget = nil
					return
				end
				if target.Position:Distance(player.Position) <= data.TaintedEnemyTarget.Position:Distance(player.Position) then
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
			
			if player:GetMovementInput() and yandereWaifu.GetEntityData(player).DASH_TAINTED_DOUBLE_TAP_READY then
				yandereWaifu.GetEntityData(player).DASH_TAINTED_DOUBLE_TAP:Update( player:GetMovementInput() , player );
			end

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
	if player:GetHearts() > 0 then
		data.PersistentPlayerData.TaintedHealth = data.PersistentPlayerData.TaintedHealth + (player:GetHearts()*25)
		player:GetHearts(-player:GetHearts())
	end
	if player:GetMaxHearts() > 0 then
		data.PersistentPlayerData.MaxTaintedHealth = data.PersistentPlayerData.MaxTaintedHealth + (player:GetMaxHearts()*25)
		player:AddMaxHearts(-player:GetMaxHearts()--[[+2]])
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
end


--Take damage logic 
yandereWaifu:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, damage, amount, damageFlag, damageSource, damageCountdownFrames) --invincibilityframe when dashing or whatnot
	local player = damage:ToPlayer();
	local data = yandereWaifu.GetEntityData(player)
	if player and yandereWaifu.IsTaintedRebekah(player) then

		if data.invincibleTime and data.invincibleTime > 0 then return false end

        if damageFlag & DamageFlag.DAMAGE_SPIKES > 0 and math.random(1,2) == 2 then
			data.PersistentPlayerData.TaintedHealth = data.PersistentPlayerData.TaintedHealth - 5
		elseif (damageFlag & DamageFlag.DAMAGE_TNT > 0 or damageFlag & DamageFlag.DAMAGE_EXPLOSION > 0) and not damage:ToPlayer():HasCollectible(CollectibleType.COLLECTIBLE_PYROMANIAC) then
			data.PersistentPlayerData.TaintedHealth = data.PersistentPlayerData.TaintedHealth - 50
		elseif damageFlag & DamageFlag.DAMAGE_CRUSH > 0 then
			data.PersistentPlayerData.TaintedHealth = data.PersistentPlayerData.TaintedHealth - 25
		elseif damageFlag & DamageFlag.DAMAGE_FIRE > 0 then
			data.PersistentPlayerData.TaintedHealth = data.PersistentPlayerData.TaintedHealth - 10
		elseif damageFlag & DamageFlag.DAMAGE_LASER > 0 then
			data.PersistentPlayerData.TaintedHealth = data.PersistentPlayerData.TaintedHealth - 10
		elseif damageFlag & DamageFlag.DAMAGE_PITFALL > 0 then
			data.PersistentPlayerData.TaintedHealth = data.PersistentPlayerData.TaintedHealth - 25
		elseif damageFlag & DamageFlag.DAMAGE_POOP > 0 then
			data.PersistentPlayerData.TaintedHealth = data.PersistentPlayerData.TaintedHealth - 5
		elseif damageFlag & DamageFlag.DAMAGE_RED_HEARTS > 0 then
			data.PersistentPlayerData.TaintedHealth = data.PersistentPlayerData.TaintedHealth - 10
		else
			damageSource = damageSource.Entity
			if damageSource then
				if damageSource:IsEnemy() then
					if damageSource:IsBoss() then
						data.PersistentPlayerData.TaintedHealth = data.PersistentPlayerData.TaintedHealth - 2
					else
						data.PersistentPlayerData.TaintedHealth = data.PersistentPlayerData.TaintedHealth - 5
					end
				elseif damageSource.Entity and damageSource.Entity.Type == 10 then
					data.PersistentPlayerData.TaintedHealth = data.PersistentPlayerData.TaintedHealth - 5
				end
			else
				data.PersistentPlayerData.TaintedHealth = data.PersistentPlayerData.TaintedHealth - 5
			end
		end

		local hp = data.PersistentPlayerData.TaintedHealth

        healthbar.Color = Color(1,0,0,1,0,0,0)
        InutilLib.SetTimer(15, function()
			healthbar.Color = Color(0,0,0,1,0,0,0)
		end)
        if hp < 1 then
            player:Kill()
        end
		if (hp % 10) == 0 then
            player:AddSoulHearts(amount)
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
				local percent = (data.PersistentPlayerData.TaintedHealth/data.PersistentPlayerData.MaxTaintedHealth)*100
                healthbar:SetFrame("Bar", math.ceil(percent) or 0)
				healthbar:Render((position + (Options.HUDOffset * Vector(20, 12))), Vector(0,0), Vector(0,0))
				healthbar.Color = Color(1,1,1,1,0,0,0)
				--heartReserve:RenderLayer(1, (position), Vector(0,0), Vector(0,0))
			end
		--end
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
yandereWaifu:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, damage, amount, damageFlag, damageSource, damageCountdownFrames) --invincibilityframe when dashing or whatnot
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
end)


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
						if data.TAINTEDREBSKILL_MENU.chargecooldown[value] <= 0 then
							if data.TAINTEDREBSKILL_MENU.options[value].price <= data.RageCrystal then
								local success = false
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
											yandereWaifu.SpawnCursedKnife(player, 3, direction)

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
									yandereWaifu.SpawnCursedKnife(player, 4, ((data.TaintedEnemyTarget.Position - player.Position):GetAngleDegrees()))
								elseif value == 2 and data.TaintedEnemyTarget and not data.TaintedEnemyTarget:IsDead() then
									success = true
									yandereWaifu.SpawnCursedKnife(player, 5, ((data.TaintedEnemyTarget.Position - player.Position):GetAngleDegrees()))
								elseif value == 3 then
									success = true
									InutilLib.SFX:Play( RebekahCurseSounds.SOUND_CURSED_RAGE, 0.8, 0, false, 1 );
									data.TaintedRageTick = 210
								end
								if success then
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
