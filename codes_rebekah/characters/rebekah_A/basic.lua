local wasFromTaintedLocked = false

local IsaacPresent = false
local JacobPresent = false


local hasInit = false;
--local currentMode = RebekahCurse.REBECCA_MODE.RedHearts;

local didKillSatan = false

local giant = Sprite()
giant:Load("gfx/characters/big_rebekah.anm2",true)

local dash = require("codes_rebekah.characters.rebekah_A.dash")
local cache = require("codes_rebekah.characters.rebekah_A.cache")
local barrage = require("codes_rebekah.characters.rebekah_A.barrages")


local function SetupRebekahData(player, mode) --sets up basic attributes for Rebekah
	local data = yandereWaifu.GetEntityData(player)
	if mode then data.currentMode = mode else data.currentMode = nil end
	--player:AddNullCostume(NerdyGlasses)
	
	--data.currentMode = RebekahCurse.REBECCA_MODE.RedHearts
	--player:AddCacheFlags (CacheFlag.CACHE_ALL);
	--player:EvaluateItems();
	
	--heart reserve
	data.heartReserveFill = 0
	data.heartReserveMaxFill = 0 
	data.heartStocks = 0
	data.heartStocksMax = 0	
	data.DASH_DOUBLE_TAP:Reset();
end

function RebeccaInit(player)
	IsaacPresent = false
	JacobPresent = false
	
	local data = yandereWaifu.GetEntityData(player)
	player:AddHearts(-RebekahCurse.REBEKAH_BALANCE.INIT_REMOVE_HEARTS);
	--heart reserve
	SetupRebekahData(player)
	
	local mode = RebekahCurse.REBECCA_MODE.RedHearts
	if player:GetPlayerType() ==  RebekahCurse.REB_RED then
		mode = RebekahCurse.REBECCA_MODE.RedHearts
	elseif player:GetPlayerType() == RebekahCurse.REB_SOUL then
		mode = RebekahCurse.REBECCA_MODE.SoulHearts 
	elseif player:GetPlayerType() == RebekahCurse.REB_GOLD then
		mode = RebekahCurse.REBECCA_MODE.GoldHearts
	elseif player:GetPlayerType() == RebekahCurse.REB_EVIL then
		mode = RebekahCurse.REBECCA_MODE.EvilHearts
	elseif player:GetPlayerType() == RebekahCurse.REB_ETERNAL then
		mode = RebekahCurse.REBECCA_MODE.EternalHearts
	elseif player:GetPlayerType() == RebekahCurse.REB_BONE then
		mode = RebekahCurse.REBECCA_MODE.BoneHearts
	elseif player:GetPlayerType() == RebekahCurse.REB_ROTTEN then
		mode = RebekahCurse.REBECCA_MODE.RottenHearts 
	elseif player:GetPlayerType() == RebekahCurse.REB_BROKEN then
		mode = RebekahCurse.REBECCA_MODE.BrokenHearts
	elseif player:GetPlayerType() == RebekahCurse.REB_IMMORTAL then
		mode = RebekahCurse.REBECCA_MODE.ImmortalHearts
	end
	yandereWaifu.ChangeMode( player, mode, true, false, true);
	yandereWaifu.AddRandomHeart(player)
	

	data.ATTACK_DOUBLE_TAP:Reset();
	
	if RebekahLocalSavedata.CurrentRebeccaUnlocks == nil then RebekahLocalSavedata.CurrentRebeccaUnlocks = BaseRebeccaUnlocks end
	if RebekahLocalSavedata.CurrentRebeccaUnlocks.HAS_LOVERS_CARD then --MEGA STAN UNLOCK
		player:AddCard(Card.CARD_LOVERS)
	end
	
	local hasPocket = yandereWaifu.HasCollectibleGuns(player)
	--for other characters who comes in but not on game_start
	if Game():GetRoom():GetFrameCount() > 1 and not hasPocket then
		yandereWaifu:SetRebekahPocketActiveItem( player, yandereWaifu.GetEntityData(player).currentMode )
		--player:SetPocketActiveItem(RebekahCurse.Items.COLLECTIBLE_LOVECANNON)
	end

	--setting max heartStocks
	if not data.heartStocksMax then data.heartStocksMax = 1 end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) then
		data.heartStocksMax = 3
	else
		data.heartStocksMax = 1
	end
	
	player.Visible = true
	--local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_PERSONALITYPOOF, 0, player.Position, Vector.Zero, player)
end

yandereWaifu:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function(_,player)
	--local player = Isaac.GetPlayer(0);
    local room = Game():GetRoom();
	local data = yandereWaifu.GetEntityData(player)
	--print(player:GetPlayerType())
	--print(RebekahCurse.SADREBEKAH)
	--[[if player:GetPlayerType() == RebekahCurse.SADREBEKAH and not yandereWaifu.ACHIEVEMENT.TAINTED_REBEKAH:IsUnlocked() then 
		if InutilLib.game:GetFrameCount() > 1 then
			
			player:ChangePlayerType(RebekahCurse.REB_RED)
			--local data = yandereWaifu.GetEntityData(player)
				
			if player.FrameCount <= 2 then --trying to make it visually pleasing when she spawns in
				player.Visible = false
			end
			yandereWaifu.ChangeMode( player, RebekahCurse.REBECCA_MODE.RedHearts, true );
			
			--personalized doubletap classes
			data.DASH_DOUBLE_TAP = InutilLib.DoubleTap:New();
			data.ATTACK_DOUBLE_TAP = InutilLib.DoubleTap:New();
			-- start the meters invisible
			data.moveMeterFadeStartFrame = -20;
			data.attackMeterFadeStartFrame = -20;
			data.bonestackMeterFadeStartFrame = 0;
				
			RebeccaInit(player)
			--yandereWaifu.ApplyCostumes( data.currentMode, player );

			if not data.NoBoneSlamActive then data.NoBoneSlamActive = true end
		else
			wasFromTaintedLocked = true
			
			Isaac.ExecuteCommand("restart "..RebekahCurse.REB_RED)
		end
	end]]
	
	if yandereWaifu.IsNormalRebekah(player) then
		--local RebekahDoubleTapDash = dash.RebekahDoubleTapDash()
		
		yandereWaifu.barrageAndSP( player );
		--yandereWaifu.RenderUnderlay( player ) 
		--yandereWaifu.RenderMegaMushOverlay( player )
		--yandereWaifu.RenderExtraHair(player, data.hairpath) 
		--update the costumes when a new tem gets picked up
		
		if InutilLib.HasCollectiblesUpdated(player) == true then
			player:AddCacheFlags(CacheFlag.CACHE_ALL);
			player:EvaluateItems()
		end
		--revive code stuff
		if (player:IsCoopGhost()) and not data.CoopDead then
			data.CoopDead = true
			player:GetSprite():ReplaceSpritesheet(0, "gfx/characters/ghost_rebekah.png")
			player:GetSprite():ReplaceSpritesheet(1, "gfx/characters/ghost_rebekah.png")
			player:GetSprite():LoadGraphics()
		end
		if not player:IsCoopGhost() and data.CoopDead then
			data.CoopDead = false
			yandereWaifu.ApplyCostumes( yandereWaifu.GetEntityData(player).currentMode, player , true)
		end
		--[[mega mush custom sprite
		if player:GetEffects():GetCollectibleEffect(CollectibleType.COLLECTIBLE_MEGA_MUSH) and not data.IsThicc then
			--data.IsThicc = true
			--player:GetSprite():Load("gfx/characters/big_rebekah.anm2",true)
			--player:GetSprite():LoadGraphics()
		end
		if not  player:GetEffects():GetCollectibleEffect(CollectibleType.COLLECTIBLE_MEGA_MUSH) and data.IsThicc then
			--data.IsThicc = false
		end]]
		
		if player:GetSprite():GetFrame() == 12 and player:GetSprite():IsPlaying("Death") == true then
			local glasses = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_BROKEN_GLASSES, 0, player.Position, Vector(-2,0) * 2, player)
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
		controllerKey = ButtonAction.ACTION_DROP
		disenableDashByKey = RebekahLocalSavedata.Config.disablerebekahdash
		if not disenableDashByKey then
			if not data.DASH_DOUBLE_TAP_READY then
				if not data.DASH_DOUBLE_TAP then
					data.DASH_DOUBLE_TAP = InutilLib.DoubleTap:New();
				end
				yandereWaifu.GetEntityData(player).DASH_DOUBLE_TAP:AttachCallback( function(vector, playerTapping)
					dash.RebekahDoubleTapDash(vector, playerTapping)
				end)
				data.DASH_DOUBLE_TAP_READY = true
			end
		else
			if data.DASH_DOUBLE_TAP_READY then
				data.DASH_DOUBLE_TAP_READY = nil
				data.DASH_DOUBLE_TAP = nil
			end
		end
		if (player:GetMovementInput().X ~= 0 or player:GetMovementInput().Y ~= 0) then
			if keyboardKey or controllerKey then
				if (keyboardKey ~= Keyboard.KEY_LEFT_CONTROL and (Input.IsButtonTriggered(keyboardKey,controller)) or (keyboardKey == Keyboard.KEY_LEFT_CONTROL  and (Input.IsActionTriggered(controllerKey,controller)))) then
					dash.RebekahDoubleTapDash(player:GetMovementInput(), player)
				end
				--if data.DASH_DOUBLE_TAP_READY then
				--	data.DASH_DOUBLE_TAP_READY = nil
				--	data.DASH_DOUBLE_TAP = nil
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
		--attack skill
		local hasCollectible = yandereWaifu.HasCollectibleGuns(player)
		if hasCollectible then
			local didUseGun = yandereWaifu.HasCollectibleConfirmedUseMultiple(player, RebekahCurse.Items.COLLECTIBLE_LOVECANNON, RebekahCurse.Items.COLLECTIBLE_WIZOOBTONGUE, RebekahCurse.Items.COLLECTIBLE_APOSTATE, RebekahCurse.Items.COLLECTIBLE_MAINLUA, RebekahCurse.Items.COLLECTIBLE_PSALM45, RebekahCurse.Items.COLLECTIBLE_BARACHIELSPETAL, RebekahCurse.Items.COLLECTIBLE_FANG, RebekahCurse.Items.COLLECTIBLE_BEELZEBUBSBREATH, RebekahCurse.Items.COLLECTIBLE_COMFORTERSWING)
			if didUseGun then
				local vector = InutilLib.DirToVec(player:GetFireDirection())
				local playerdata = yandereWaifu.GetEntityData(player);
				local psprite = player:GetSprite()
				local controller = player.ControllerIndex;
				--cooldown
				if not player:IsExtraAnimationFinished() and not (playerdata.IsUninteractible) then
					--if --[[OPTIONS.HOLD_DROP_FOR_SPECIAL_ATTACK == false or Input.IsActionPressed(ButtonAction.ACTION_DROP, controller)]] playerdata.isReadyForSpecialAttack then
					if (yandereWaifu.getReserveStocks(player) >= 1 and playerdata.NoBoneSlamActive) then --[[ and (yandereWaifu.GetEntityData(player).currentMode ~= RebekahCurse.REBECCA_MODE.BrokenHearts and yandereWaifu.GetEntityData(player).currentMode ~= RebekahCurse.REBECCA_MODE.RottenHearts))]] --[[or (yandereWaifu.GetEntityData(player).currentMode == RebekahCurse.REBECCA_MODE.BrokenHearts or (yandereWaifu.GetEntityData(player).currentMode == RebekahCurse.REBECCA_MODE.RottenHearts and ((not data.noHead) or (data.noHead and yandereWaifu.getReserveStocks(player) >= 1)))]] --((player:GetSoulHearts() >= 2 and player:GetHearts() > 0) or player:GetHearts() > 2) and playerdata.NoBoneSlamActive then
						if yandereWaifu.GetEntityData(player).currentMode == RebekahCurse.REBECCA_MODE.RedHearts then --if red 
							playerdata.specialActiveAtkCooldown = 500;
							playerdata.invincibleTime = 10;
							playerdata.redcountdownFrames = 0;  --just in case, it kinda breaks occasionally, so that's weird
						elseif yandereWaifu.GetEntityData(player).currentMode == RebekahCurse.REBECCA_MODE.SoulHearts then --if blue 
							playerdata.specialActiveAtkCooldown = 120;
							playerdata.soulcountdownFrames = 0;
						elseif yandereWaifu.GetEntityData(player).currentMode == RebekahCurse.REBECCA_MODE.GoldHearts then --if yellow 
							playerdata.specialActiveAtkCooldown = 5;
						elseif yandereWaifu.GetEntityData(player).currentMode == RebekahCurse.REBECCA_MODE.EvilHearts then --if black 
							playerdata.specialActiveAtkCooldown = 90;
						elseif yandereWaifu.GetEntityData(player).currentMode == RebekahCurse.REBECCA_MODE.EternalHearts then --if eternal 
							playerdata.specialActiveAtkCooldown = 1200;
						elseif yandereWaifu.GetEntityData(player).currentMode == RebekahCurse.REBECCA_MODE.BoneHearts then --if bone 
							playerdata.specialActiveAtkCooldown = 900;
						elseif yandereWaifu.GetEntityData(player).currentMode == RebekahCurse.REBECCA_MODE.RottenHearts then --if rotten 
							playerdata.specialActiveAtkCooldown = 60;
						elseif yandereWaifu.GetEntityData(player).currentMode == RebekahCurse.REBECCA_MODE.BrokenHearts then --if broken 
							playerdata.specialActiveAtkCooldown = 160;
						elseif yandereWaifu.GetEntityData(player).currentMode == RebekahCurse.REBECCA_MODE.BrideRedHearts then --if bred 
							playerdata.specialActiveAtkCooldown = 80;
							playerdata.invincibleTime = 10;
							playerdata.redcountdownFrames = 0;  --just in case, it kinda breaks occasionally, so that's weird
						elseif yandereWaifu.GetEntityData(player).currentMode == RebekahCurse.REBECCA_MODE.ImmortalHearts then --if immortal 
							playerdata.specialActiveAtkCooldown = 160;
						end
						playerdata.specialAttackVector = Vector( vector.X, vector.Y );
						playerdata.IsAttackActive = true;
									-- should probably play some sort of sound indicating damage
									--player:AddHearts(-1);
									
									--yandereWaifu.purchaseReserveStocks(player, 1)
									--[[
									consider as an alternative to simply removing a half heart
									player:TakeDamage( 1, DamageFlag.DAMAGE_NOKILL | DamageFlag.DAMAGE_RED_HEARTS, EntityRef(player), 0);
									player:ResetDamageCooldown()
									]]
						--playerdata.ATTACK_DOUBLE_TAP.cooldown = playerdata.specialActiveAtkCooldown;
						playerdata.isReadyForSpecialAttack = false;
						playerdata.AttackVector = vector;
									
						playerdata.specialMaxActiveAtkCooldown = playerdata.specialActiveAtkCooldown;
						InutilLib.ToggleShowActive(player, false, InutilLib.GetShowingActiveSlot(player))
						InutilLib.ConsumeActiveCharge(player, InutilLib.GetShowingActiveSlot(player))
					--[[else
						yandereWaifu.purchaseReserveFills(player, 50)
						--InutilLib.ToggleShowActive(player, false, InutilLib.GetShowingActiveSlot(player))

						--InutilLib.ToggleShowActive(player, false, true)
						InutilLib.SFX:Play( SoundEffect.SOUND_THUMBS_DOWN, 1, 0, false, 1 );
						--playerdata.ATTACK_DOUBLE_TAP.cooldown = OPTIONS.FAILED_SPECIAL_ATTACK_COOLDOWN;
						
						--local charge = Isaac.Spawn( EntityType.ENTITY_EFFECT, EffectVariant.HEART, 0, player.Position, Vector(0,0), player );
						--charge.SpriteOffset = Vector(0,-40)
						local gulp = Isaac.Spawn( EntityType.ENTITY_EFFECT,  RebekahCurse.ENTITY_HEARTGULP, 0, player.Position, Vector(0,0), player );
						yandereWaifu.GetEntityData(gulp).Parent = parent
						gulp.SpriteOffset = Vector(0,-20)
						gulp.RenderZOffset = 10000]]
					end
					--InutilLib.ConsumeActiveCharge(player, true)
					--yandereWaifu.purchaseReserveStocks(player, 1, true)
				end 
			--end
			end
		end
	end
end)

--using rebekah's actives as anyone else but rebekah, i saw eden have this and it makes me angry so here
--i think this is impossible anyway so it doesnt work anymore
yandereWaifu:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function(_,player)
	--local player = Isaac.GetPlayer(0);
    local room = Game():GetRoom();
	local data = yandereWaifu.GetEntityData(player)
	
	if not yandereWaifu.IsNormalRebekah(player) then
		local hasCollectibles = yandereWaifu.HasCollectibleGuns(player)
		
		if hasCollectibles then
			local hasUsedGuns = yandereWaifu.HasCollectibleConfirmedUseMultiple(player, RebekahCurse.Items.COLLECTIBLE_LOVECANNON, RebekahCurse.Items.COLLECTIBLE_WIZOOBTONGUE, RebekahCurse.Items.COLLECTIBLE_APOSTATE, RebekahCurse.Items.COLLECTIBLE_MAINLUA, RebekahCurse.Items.COLLECTIBLE_PSALM45, RebekahCurse.Items.COLLECTIBLE_BARACHIELSPETAL, RebekahCurse.Items.COLLECTIBLE_FANG, RebekahCurse.Items.COLLECTIBLE_BEELZEBUBSBREATH, RebekahCurse.Items.COLLECTIBLE_COMFORTERSWING)
			
			
			if hasUsedGuns then
				local vector = InutilLib.DirToVec(player:GetFireDirection())
				local playerdata = yandereWaifu.GetEntityData(player);
				local psprite = player:GetSprite()
				local controller = player.ControllerIndex;
				playerdata.specialAttackVector = Vector( vector.X, vector.Y );
				if InutilLib.ConfirmUseActive( player, RebekahCurse.Items.COLLECTIBLE_WIZOOBTONGUE ) then
					yandereWaifu.DoExtraBarrages(player, 5)
				elseif InutilLib.ConfirmUseActive( player, RebekahCurse.Items.COLLECTIBLE_APOSTATE ) then
					local didtrigger = false
					if player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BRIMSTONE) < 2 then
						player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_BRIMSTONE, false, player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BRIMSTONE)+2)
						didtrigger = true
					end
					local beam = player:FireBrimstone( vector, player, 2):ToLaser();
					beam.Position = player.Position
					beam.MaxDistance = 100
					beam.Timeout = 20
					beam.DisableFollowParent = true
					yandereWaifu.GetEntityData(beam).IsEvil = true
					if didtrigger then
						player:GetEffects():RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_BRIMSTONE, player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BRIMSTONE)+2)
					end
				elseif InutilLib.ConfirmUseActive( player, RebekahCurse.Items.COLLECTIBLE_PSALM45 ) then
					local ned = Isaac.Spawn( EntityType.ENTITY_FAMILIAR, RebekahCurse.ENTITY_NED_NORMAL, 0, player.Position, Vector( 0, 0 ), player):ToFamiliar();
				elseif InutilLib.ConfirmUseActive( player, RebekahCurse.Items.COLLECTIBLE_BARACHIELSPETAL ) then
					local angle = vector:GetAngleDegrees()
					local beam = EntityLaser.ShootAngle(5, player.Position, angle, 10, Vector(0,10), player):ToLaser()
					if not yandereWaifu.GetEntityData(beam).IsLvlOneBeam then yandereWaifu.GetEntityData(beam).IsLvlOneBeam = true end
				elseif InutilLib.ConfirmUseActive( player, RebekahCurse.Items.COLLECTIBLE_FANG ) then
					for i = 1, 4 do --extra carrion worm thingies when extra tears!!
						local leech = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, RebekahCurse.ENTITY_BONEJOCKEY, 10, player.Position, Vector(0,0), player)
						yandereWaifu.GetEntityData(leech).ParentLeech = player
					end
				elseif InutilLib.ConfirmUseActive( player, RebekahCurse.Items.COLLECTIBLE_BEELZEBUBSBREATH ) then
					local ball = Isaac.Spawn( EntityType.ENTITY_FAMILIAR, RebekahCurse.ENTITY_ROTTENFLYBALL, 0, player.Position, vector, player):ToFamiliar();
				elseif InutilLib.ConfirmUseActive( player, RebekahCurse.Items.COLLECTIBLE_MAINLUA ) then
					Isaac.Explode(player.Position, player, 500)
					player:TakeDamage(2, 0, EntityRef(player), 1)
				elseif InutilLib.ConfirmUseActive( player, RebekahCurse.Items.COLLECTIBLE_COMFORTERSWING ) then
					
				else
					yandereWaifu.DoExtraBarrages(player, 1)
				end
					
				InutilLib.ToggleShowActive(player, false, InutilLib.GetShowingActiveSlot(player))
				InutilLib.ConsumeActiveCharge(player, InutilLib.GetShowingActiveSlot(player))
				
			end
		end
	end
end)

------
--Rebecca's Barrage and Specials
function yandereWaifu.barrageAndSP(player) 
	local data = yandereWaifu.GetEntityData(player)
	local controller = player.ControllerIndex
	
	--poop beam
	
	if data.shiftyBeam then
		if not data.shiftyBeam:IsDead() then
			data.shiftyBeam.Angle = (player.Velocity:GetAngleDegrees()) - 180
			if player.FrameCount % 5 == 0 then
				for i = -15, 15, 30 do
					local beam = EntityLaser.ShootAngle(12, player.Position, data.shiftyBeam.Angle + math.random(-10,10) + i, 10, Vector(0,10), player):ToLaser();
					beam.MaxDistance = math.random(50,200)
					beam.Timeout = 2
					--InutilLib.UpdateLaserSize(beam, math.random(1,2))
				end
			end
			if player.FrameCount % 3 == 0 then
				for i = 1, math.random(2,4) do
					if math.random(1,3) == 3 then
						local tear = InutilLib.game:Spawn( EntityType.ENTITY_TEAR, 1, player.Position, Vector.FromAngle(data.shiftyBeam.Angle + math.random(-5,5)):Resized(math.random(10,25)), player, 0, 0):ToTear()
					else
						local tear = InutilLib.game:Spawn( EntityType.ENTITY_TEAR, 0, player.Position, Vector.FromAngle(data.shiftyBeam.Angle + math.random(-5,5)):Resized(math.random(10,25)), player, 0, 0):ToTear()
						tear:GetSprite():Load("gfx/009.005_corn projectile.anm2", true)
						tear:GetSprite():Play("Small01", true)
					end
				end
			end
		else
			data.shiftyBeam = nil
		end
	end
	if data.currentMode == RebekahCurse.REBECCA_MODE.SoulHearts then
		if data.isPlayingCustomAnim2 then
			--if not data.soulspitframecount then data.soulspitframecount = 0 end
			if data.soulspitframecount == 5 then
				data.BarrageIntro = true
			elseif data.soulspitframecount == 45 then
				player:TryRemoveNullCostume(RebekahCurse.Costumes.RebekahSpitsOut)
				data.isPlayingCustomAnim2 = false
				data.isPlayingCustomAnim = false
			end
			data.soulspitframecount = data.soulspitframecount + 1
		end
	end
	if data.currentMode == RebekahCurse.REBECCA_MODE.RedHearts or data.currentMode == RebekahCurse.REBECCA_MODE.BoneHearts or
	data.currentMode == RebekahCurse.REBECCA_MODE.ScaredRedHearts or data.currentMode == RebekahCurse.REBECCA_MODE.TwinRedHearts 
	or data.currentMode == RebekahCurse.REBECCA_MODE.BlendedHearts  or data.currentMode == RebekahCurse.REBECCA_MODE.HalfRedHearts then
		if data.IsDashActive then --movement code
			local heartType = RebekahCurse.RebekahHeartParticleType.Red
			if data.currentMode == RebekahCurse.REBECCA_MODE.RedHearts then
				heartType = RebekahCurse.RebekahHeartParticleType.Red
			else
				heartType = RebekahCurse.RebekahHeartParticleType.Black
			end
			
			
			if not data.countdownFrames then data.countdownFrames = 7 end
			data.countdownFrames = data.countdownFrames - 1
			
			if data.countdownFrames < 0 then
				--if data.boneSuccessDash then
				if data.currentMode == RebekahCurse.REBECCA_MODE.BoneHearts then 
					if data.BoneStacks < 5 then data.BoneStacks = data.BoneStacks + 1 end
				end
				--	print(data.BoneStacks)
				--	data.boneSuccessDash = false
				--end
				data.countdownFrames = 7
				data.IsDashActive = false
			end
			if Isaac.GetFrameCount() % 3 == 0 then
			AddRebekahDashEffect(player)
			--if not data.currentMode == RebekahCurse.REBECCA_MODE.EvilHearts then
				yandereWaifu.SpawnHeartParticles( 1, 3, player.Position, player.Velocity:Rotated(180+math.random(-5,5)):Resized( player.Velocity:Length() * (math.random() * 0.5 + 0.5) ), player, heartType );
			end
			
		end
		if data.currentMode == RebekahCurse.REBECCA_MODE.BoneHearts then
			if (data.LudoBone == nil or data.LudoBone:IsDead()) and data.IsAttackActive then
				--ludostuff
				local ludoTear
				if player:HasCollectible(CollectibleType.COLLECTIBLE_LUDOVICO_TECHNIQUE) then
					ludoTear = InutilLib.GetPlayerLudo(player)
					if ludoTear then
						local ludoBone = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_LUDOBONE, 0, ludoTear.Position, Vector(0,0), player)
						ludoTear:Remove()
						data.LudoBone = ludoBone
						data.Player = player
					else
						local ludoBone = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_LUDOBONE, 0, player.Position, Vector(0,0), player)
						data.LudoBone = ludoBone
						data.Player = player
					end
				end
			end
			--[[for i, entities in pairs(Isaac.GetRoomEntities()) do
				if entities:IsVulnerableEnemy() then
					if entities.Position:Distance(player.Position) < entities.Size + player.Size + 30 then
						entities:TakeDamage(player.Damage * 0.4, 0, EntityRef(player), 1)
						--data.boneSuccessDash = true
					end
				end
			end]]
		end
	end
	
	if not data.LastBonestackFrame then data.LastBonestackFrame = player.FrameCount + 45 end
	if data.LastBonestackFrame == player.FrameCount then
		if not data.BoneStacks then data.BoneStacks = 0 end
		if data.BoneStacks > 0 then
			data.BoneStacks = data.BoneStacks - 1
		end
		data.LastBonestackFrame = player.FrameCount + 45
	end
	
	if data.currentMode == RebekahCurse.REBECCA_MODE.EternalHearts then	
		yandereWaifu.FlamethrowerLogic(player)
		--ludo stuff
		if player:HasWeaponType(WeaponType.WEAPON_LUDOVICO_TECHNIQUE) and not data.EternalLudo then
			data.EternalLudo = true
			player:AddCacheFlags(CacheFlag.CACHE_FAMILIARS);
			player:EvaluateItems()
		end
	elseif data.currentMode ~= RebekahCurse.REBECCA_MODE.EternalHearts and data.EternalLudo then	
		data.EternalLudo = false
		player:AddCacheFlags(CacheFlag.CACHE_FAMILIARS);
		player:EvaluateItems()
	end

	if data.currentMode == RebekahCurse.REBECCA_MODE.BrokenHearts then --decrement of tankAmount
		if data.tankAmount then
			if data.tankAmount >= 1 then 
				if player.FrameCount % 100 == 0 then
					data.tankAmount = data.tankAmount - 1
				end
			end
		end
		if player.FrameCount % 300 == 0 and yandereWaifu.GetEntityData(player).BrokenLuck then

			yandereWaifu.GetEntityData(player).BrokenLuck = false
			player:AddCacheFlags(CacheFlag.CACHE_LUCK);
			player:EvaluateItems()
		end
		
		if yandereWaifu.IsNormalRebekah(player) and yandereWaifu.GetEntityData(player).currentMode == RebekahCurse.REBECCA_MODE.BrokenHearts then
			if yandereWaifu.GetEntityData(player).BrokenBuff then
				yandereWaifu.GetEntityData(player).BrokenBuff = false
				player:AddCacheFlags(CacheFlag.CACHE_DAMAGE);
				player:EvaluateItems()
			end
		end
	end
	
	if data.IsLeftover then --dont move
		player.Velocity = Vector.Zero
		--player.Position = Vector.Zero
	end
	
	if data.IsAttackActive and data.NoBoneSlamActive then	--attack code
		if not data.LuckBuff then 
			data.LuckBuff = true
			player:AddCacheFlags(CacheFlag.CACHE_LUCK);
			player:EvaluateItems()
		end
		local mode
		if not data.currentActiveBarrageMode then
			if player:IsHoldingItem() and InutilLib.GetLastShownItem(player) == RebekahCurse.Items.COLLECTIBLE_LOVECANNON  then
				data.currentActiveBarrageMode = RebekahCurse.REBECCA_MODE.RedHearts
			elseif player:IsHoldingItem() and InutilLib.GetLastShownItem(player) == RebekahCurse.Items.COLLECTIBLE_WIZOOBTONGUE then
				data.currentActiveBarrageMode = RebekahCurse.REBECCA_MODE.SoulHearts
			elseif player:IsHoldingItem() and InutilLib.GetLastShownItem(player) == RebekahCurse.Items.COLLECTIBLE_APOSTATE then
				data.currentActiveBarrageMode = RebekahCurse.REBECCA_MODE.EvilHearts
			elseif player:IsHoldingItem() and InutilLib.GetLastShownItem(player) == RebekahCurse.Items.COLLECTIBLE_PSALM45 then
				data.currentActiveBarrageMode = RebekahCurse.REBECCA_MODE.GoldHearts
			elseif player:IsHoldingItem() and InutilLib.GetLastShownItem(player) == RebekahCurse.Items.COLLECTIBLE_BARACHIELSPETAL then
				data.currentActiveBarrageMode = RebekahCurse.REBECCA_MODE.EternalHearts
			elseif player:IsHoldingItem() and InutilLib.GetLastShownItem(player) == RebekahCurse.Items.COLLECTIBLE_FANG then
				data.currentActiveBarrageMode = RebekahCurse.REBECCA_MODE.BoneHearts
			elseif player:IsHoldingItem() and InutilLib.GetLastShownItem(player) == RebekahCurse.Items.COLLECTIBLE_BEELZEBUBSBREATH then
				data.currentActiveBarrageMode = RebekahCurse.REBECCA_MODE.RottenHearts
			elseif player:IsHoldingItem() and InutilLib.GetLastShownItem(player) == RebekahCurse.Items.COLLECTIBLE_MAINLUA then
				data.currentActiveBarrageMode = RebekahCurse.REBECCA_MODE.BrokenHearts
			elseif player:IsHoldingItem() and InutilLib.GetLastShownItem(player) == RebekahCurse.Items.COLLECTIBLE_COMFORTERSWING then
				data.currentActiveBarrageMode = RebekahCurse.REBECCA_MODE.ImmortalHearts
			end
		end
		yandereWaifu.DoRebeccaBarrage(player, data.currentActiveBarrageMode, data.specialAttackVector)
	else
		if data.LuckBuff then 
			InutilLib.SetTimer( 30, function()
				data.LuckBuff = false
				player:AddCacheFlags(CacheFlag.CACHE_LUCK);
				player:EvaluateItems()
            end);
		end
	end
end


--[[function yandereWaifu.RenderUnderlay(player) 
	--local player = Isaac.GetPlayer(0)
	local psprite = player:GetSprite()
	if yandereWaifu.GetEntityData(player).currentMode == RebekahCurse.REBECCA_MODE.BrideRedHearts then	
		--local s = Sprite()
		--s:Load("gfx/weddingveil.anm2", true)
		--s:Update()
		--s:Play("Front", true)
		--s:Render(Isaac.WorldToScreen(player.Position), Vector(0,0), Vector(0,0))
		--s.RenderZOffset = 10000
		
		if psprite:IsPlaying("Trapdoor") or psprite:IsPlaying("Jump") or psprite:IsPlaying("HoleIn") or psprite:IsPlaying("HoleDeath") or psprite:IsPlaying("JumpOut") or psprite:IsPlaying("LightTravel") or psprite:IsPlaying("Appear") or psprite:IsPlaying("Death") or psprite:IsPlaying("TeleportUp") or psprite:IsPlaying("TeleportDown") then
			InutilLib.UnderlayVisible(player, false)
		else
			InutilLib.UnderlayMatchOwner(player)
			
			local plusOffset = 0

			if psprite:GetOverlayFrame() > 1 then
				plusOffset = 2
			end
			
			InutilLib.AddUnderlay(player, "gfx/weddingveil.anm2")
			if player.Velocity:Length() <= 1 then
				if player:GetHeadDirection() == 3 or player:GetHeadDirection() == -1 then --down
					InutilLib.PlayUnderlay(player, "Front", true)
					InutilLib.UnderlaySetUnder(player)
				elseif player:GetHeadDirection() == 1 then --up
					InutilLib.PlayUnderlay(player, "Back", true)
					InutilLib.UnderlaySetOver(player)
				elseif player:GetHeadDirection() == 0 then --left
					InutilLib.PlayUnderlay(player, "Side", true)
					InutilLib.UnderlaySetOver(player)
					InutilLib.FlipXUnderlay(player, true)
				elseif player:GetHeadDirection() == 2 then --right
					InutilLib.PlayUnderlay(player, "Side", true)
					InutilLib.UnderlaySetOver(player)
					InutilLib.FlipXUnderlay(player, false)
				end
			else
				if player:GetHeadDirection() == 3 or player:GetHeadDirection() == -1 then --down
					InutilLib.PlayUnderlay(player, "FrontMove", false)
					InutilLib.UnderlaySetUnder(player)
				elseif player:GetHeadDirection() == 1 then --up
					InutilLib.PlayUnderlay(player, "BackMove", false)
					InutilLib.UnderlaySetOver(player)
				elseif player:GetHeadDirection() == 0 then --left
					InutilLib.PlayUnderlay(player, "SideMove", false)
					InutilLib.UnderlaySetOver(player)
					InutilLib.FlipXUnderlay(player, true)
				elseif player:GetHeadDirection() == 2 then --right
					InutilLib.PlayUnderlay(player, "SideMove", false)
					InutilLib.UnderlaySetOver(player)
					InutilLib.FlipXUnderlay(player, false)
				end
			end
			InutilLib.UnderlayOffset(player, Vector(0,-1+plusOffset))
		end
	else
		InutilLib.RemoveUnderlay(player)
	end
end]]
--yandereWaifu:AddCallback(ModCallbacks.MC_POST_RENDER, yandereWaifu.RenderUnderlay) 


--[[function yandereWaifu:RenderMegaMushOverlay() 
	--local player = Isaac.GetPlayer(0)
	for p = 0, InutilLib.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		if yandereWaifu.IsNormalRebekah(player) then
			local psprite = player:GetSprite()
			
			--print("test")
			--print(psprite:GetAnimation())
			--print( psprite:IsPlaying("Transform") )
			if yandereWaifu.GetEntityData(player).IsThicc then	
				--local s = Sprite()
				--s:Load("gfx/weddingveil.anm2", true)
				--s:Update()
				--s:Play("Front", true)
				--s:Render(Isaac.WorldToScreen(player.Position), Vector(0,0), Vector(0,0))
				--s.RenderZOffset = 10000
				
				if psprite:IsPlaying("Trapdoor") or psprite:IsPlaying("Jump") or psprite:IsPlaying("HoleIn") or psprite:IsPlaying("HoleDeath") or psprite:IsPlaying("JumpOut") or psprite:IsPlaying("LightTravel") or psprite:IsPlaying("Appear") or psprite:IsPlaying("Death") or psprite:IsPlaying("TeleportUp") or psprite:IsPlaying("TeleportDown") then
					InutilLib.OverlayVisible(player, false)
				else
					--print("test")
					--print(psprite:GetOverlayAnimation())
					if psprite:IsPlaying("Transform") or psprite:IsPlaying("TransformBack") then
						InutilLib.OverlaySetOver(player)
						InutilLib.AddOverlay(player, "gfx/characters/big_rebekah.anm2")
						InutilLib.SetOverlayFrame(player, psprite:GetAnimation(), psprite:GetFrame())
						InutilLib.OverlayOffset(player, Vector(0,-2))
					else
						InutilLib.OverlayMatchOwner(player)
						--print(psprite:GetFrame())
						local plusOffset = 0

						if psprite:GetFrame() >= 6 and psprite:GetFrame() <= 14 then
							plusOffset = 2
							if psprite:GetFrame() >= 9 and psprite:GetFrame() <= 12 then
								plusOffset = plusOffset + 2
							end
						end
						if psprite:GetFrame() >= 13 and psprite:GetFrame() <= 19 then
							plusOffset = 2
							if psprite:GetFrame() >= 15 and psprite:GetFrame() <= 18 then
								plusOffset = plusOffset + 2
							end
						end
						InutilLib.OverlaySetOver(player)
						InutilLib.AddOverlay(player, "gfx/characters/big_rebekah.anm2")
						InutilLib.SetOverlayFrame(player, psprite:GetOverlayAnimation(), psprite:GetOverlayFrame())
						--if player.Velocity:Length() <= 1 then
						--	if player:GetHeadDirection() == 3 or player:GetHeadDirection() == -1 then --down
						--		InutilLib.PlayOverlay(player, "HeadDown", true)
						--	elseif player:GetHeadDirection() == 1 then --up
						--		InutilLib.PlayOverlay(player, "HeadUp", true)
						--	elseif player:GetHeadDirection() == 0 then --left
						--		InutilLib.PlayOverlay(player, "HeadLeft", true)
						--	elseif player:GetHeadDirection() == 2 then --right
						--		InutilLib.PlayOverlay(player, "HeadRight", true)
						--	end
						--end
						InutilLib.OverlayOffset(player, Vector(0,-37+plusOffset))
					end
				end
			else
				InutilLib.RemoveOverlay(player)
			end
		end
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_POST_RENDER, yandereWaifu.RenderMegaMushOverlay) ]]

--pickup shizz, because i dont want you to ghost around and pick up random things
yandereWaifu:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, pickup)
	for p = 0, InutilLib.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		local entityData = yandereWaifu.GetEntityData(player);
		if yandereWaifu.IsNormalRebekah(player) and not entityData.currentMode == RebekahCurse.REBECCA_MODE.SoulHearts then
			if ( entityData.invincibleTime or 0 ) > 0 then
				pickup.Wait = 10;
			end
		end
	end
end)


yandereWaifu:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, function(_, ent)
	for p = 0, InutilLib.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		local playerType = player:GetPlayerType()
		local room = InutilLib.game:GetRoom()
		local data = yandereWaifu.GetEntityData(player)
		
		if yandereWaifu.IsNormalRebekah(player)  then
			if ent.Type == EntityType.ENTITY_ISAAC or (ent.Type == EntityType.ENTITY_SATAN and not didKillSatan ) then -- isaac heart spawn
				if InutilLib.game:GetLevel():GetStage() == 10 then
					didKillSatan = true
					--local spawnPosition = room:FindFreePickupSpawnPosition(room:GetGridPosition(97), 1);
					--local newpickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, 100, CollectibleType.COLLECTIBLE_ISAACS_HEART, spawnPosition, Vector(0,0), player)
				end
			end
			local maxHealth = ent.MaxHitPoints
			if yandereWaifu.getReserveStocks(player) < yandereWaifu.GetEntityData(player).heartStocksMax and not ent:IsInvincible() and modes ~= RebekahCurse.REBECCA_MODE.BoneHearts and not (data.IsLeftover)--[[(ent.Variant == EntityType.ENTITY_STONEY)]] then
				for i = 1, math.ceil(maxHealth/50) do
					local heart = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_LOVELOVEPARTICLE, 0, ent.Position, Vector.FromAngle((player.Position - ent.Position):GetAngleDegrees() + math.random(-90,90) + 180):Resized(30), ent)
					yandereWaifu.GetEntityData(heart).Parent = player
					yandereWaifu.GetEntityData(heart).maxHealth = math.ceil(maxHealth/10)
					--print(math.ceil(maxHealth/3))
				end
			end
			if yandereWaifu.GetEntityData(player).IsLeftover then
				yandereWaifu.GetEntityData(player).BoneJockeyTimeLeft = yandereWaifu.GetEntityData(player).BoneJockeyTimeLeft + maxHealth/7
			end
		end
	end
end)

function yandereWaifu:RebekahNewRoom()	
	yandereWaifu.InsertMirrorData()
	for p = 0, InutilLib.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		local data = yandereWaifu.GetEntityData(player)
		local room = InutilLib.game:GetRoom()
		if yandereWaifu.IsNormalRebekah(player) then
			
			--in case it is taken away, because of some softlocks
			if not yandereWaifu.HasCollectibleGuns(player) then
				yandereWaifu:SetRebekahPocketActiveItem( player, yandereWaifu.GetEntityData(player).currentMode )
			end
			if data.DASH_DOUBLE_TAP then data.DASH_DOUBLE_TAP:Reset(); end
			data.ATTACK_DOUBLE_TAP:Reset();
			--neded for soul heart and bone heart movement lol
			--if this was tampered to being with
			if data.IsUninteractible then 
				if data.currentMode == RebekahCurse.REBECCA_MODE.SoulHearts or data.currentMode == RebekahCurse.REBECCA_MODE.EvilHearts 
				or data.currentMode == RebekahCurse.REBECCA_MODE.BlendedHearts or data.currentMode == RebekahCurse.REBECCA_MODE.HalfSoulHearts then
					yandereWaifu.RebekahCanShoot(player, true)
				end
				data.IsUninteractible = false 
			end --reset orbitals
			
			if data.specialActiveAtkCooldown and data.specialActiveAtkCooldown > 0 and not data.IsLeftover then --reset special attack
				yandereWaifu.RebekahCanShoot(player, true)
				player.FireDelay = 15
				data.FinishedPlayingCustomAnim = nil
				data.IsAttackActive = false
				data.chargeDelay = 0
				data.barrageInit = false
				
				if data.isPlayingCustomAnim then
					data.specialActiveAtkCooldown = 0
				end
				data.BarrageIntro = false
				data.isPlayingCustomAnim = nil
				--data.soulspitframecount = 0
				data.FinishedPlayingCustomAnim = nil
				data.isPlayingCustomAnim2  = nil
				
				yandereWaifu.RemoveRedGun(player)
				yandereWaifu.RemoveEvilGun(player)
				yandereWaifu.RemoveGoldGun(player)
				yandereWaifu.RemoveEternalGun(player)
				yandereWaifu.RemoveBoneGun(player)
				if data.MainArcaneCircle then
					data.MainArcaneCircle:GetSprite():Play("FadeOut", true)
					data.MainArcaneCircle = nil
					data.ArcaneCircleDust:Remove()
					data.tintEffect = nil
				end
			end
			if data.IsDashActive then data.IsDashActive = false end --stop any active dashes
			if data.NoBoneSlamActive ~= true then data.NoBoneSlamActive = true end

			if data.LastGridCollisionClass then player.GridCollisionClass = data.LastGridCollisionClass end
			if data.LastEntityCollisionClass then player.EntityCollisionClass = data.LastEntityCollisionClass end

			data.LastGridCollisionClass = nil
			data.LastEntityCollisionClass = nil

			data.isReadyForSpecialAttack = false
			data.IsParryInvul = false
			
			data.lastMode = data.currentMode
			data.lastHeartReserve = yandereWaifu.getReserveFill(player)
			data.lastStockReserve = yandereWaifu.getReserveStocks(player)
			
			data.currentActiveBarrageMode = nil --???

			--heal back tf2 soldiers
			for i, fam in pairs (Isaac.GetRoomEntities()) do
				if fam.Variant == RebekahCurse.ENTITY_CHRISTIANNED and fam.SubType == 2 then
					if fam:GetSprite():IsFinished("LandFail") then
						fam:GetSprite():Play("Spawn", true)
					end
				end
				--remove rotten heads
				if fam.Variant == RebekahCurse.ENTITY_ROTTENHEAD and GetPtrHash(fam:ToFamiliar().Player) == GetPtrHash(player) then
					fam:Kill()
					yandereWaifu.resetRottenHead(player)
				end
			end
			
			if data.mainGlitch then
				if not data.mainGlitch:Exists() then
					data.mainGlitch = nil 
					
					if data.tankAmount and data.tankAmount > 0 then
						if player:GetBrokenHearts() > 11 then
							player:Die()
						else
							if player:GetHearts() <= 1 then
								player:AddBrokenHearts(1)
							end
							
							data.tankAmount = nil
							data.mainGlitch = nil
							player:TakeDamage( 2, DamageFlag.DAMAGE_NOKILL | DamageFlag.DAMAGE_RED_HEARTS, EntityRef(player), 0);
							player:ResetDamageCooldown()
						end
					end
				end
			end
			if data.debug7 then
				data.debug7 = false
			end
			if data.currentMode == RebekahCurse.REBECCA_MODE.RottenHearts then
				data.RottenHiveTable = {}
				for i, entity in pairs(Isaac.GetRoomEntities()) do
					if entity.Type == EntityType.ENTITY_FAMILIAR and entity.Variant == RebekahCurse.ENTITY_ROTTENFLYBALL then
						if GetPtrHash(entity:ToFamiliar().Player) == GetPtrHash(player) then
							table.insert(data.RottenHiveTable, entity)
							yandereWaifu.GetEntityData(entity).Hidden = true
						end
					end
				end
			end
			if data.SoulBuff then
				data.SoulBuff = false
				player:AddCacheFlags(CacheFlag.CACHE_DAMAGE);
				player:EvaluateItems()
				--become depressed again
				yandereWaifu.ApplyCostumes( data.currentMode, player , false, false)
				player:RemoveCostume(Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_NUMBER_ONE))
				player:AddNullCostume(RebekahCurse.Costumes.WizoobHairGoingDown)
				InutilLib.SetTimer( 10*3, function()
					player:TryRemoveNullCostume(RebekahCurse.Costumes.WizoobHairGoingDown)
				end)
			end
			if data.ImmortalPrismProp then
				data.ImmortalPrismProp:Remove()
			end
			if data.currentMode == RebekahCurse.REBECCA_MODE.BoneHearts and data.IsLeftover then
				player.Visible = false
			end
			if not player:IsCoopGhost() then
				yandereWaifu.ApplyCostumes( yandereWaifu.GetEntityData(player).currentMode, player, false, false )
			else
				player:GetSprite():ReplaceSpritesheet(0, "gfx/characters/ghost_rebekah.png")
				player:GetSprite():ReplaceSpritesheet(1, "gfx/characters/ghost_rebekah.png")
				player:GetSprite():LoadGraphics()
			end
		end
	end
end
yandereWaifu:AddCallback( ModCallbacks.MC_POST_NEW_ROOM, yandereWaifu.RebekahNewRoom)

--stat cache for each mode
function yandereWaifu:Rebekahcacheregister(player, cacheF) --The thing the checks and updates the game, i guess?
		local data = yandereWaifu.GetEntityData(player)
		local num, num2, num3
		if data.currentMode == RebekahCurse.REBECCA_MODE.BrideRedHearts and yandereWaifu.IsNormalRebekah(player) then num1 = 1 else num1 = 0 end
		--if data.currentMode == RebekahCurse.REBECCA_MODE.EternalHearts and yandereWaifu.IsNormalRebekah(player) then num2 = 1 else num2 = 0 end
		--if data.currentMode == RebekahCurse.REBECCA_MODE.BoneHearts and yandereWaifu.IsNormalRebekah(player) then num3 = 1 else num3 = 0 end
		if cacheF == CacheFlag.CACHE_FAMILIARS then
			player:CheckFamiliar(RebekahCurse.ENTITY_LABAN, num1, RNG())
			--player:CheckFamiliar(RebekahCurse.ENTITY_MORNINGSTAR, num2, RNG())
		--	player:CheckFamiliar(RebekahCurse.ENTITY_BONEJOCKEY, num3, RNG())
		end
		if yandereWaifu.IsNormalRebekah(player) then -- Especially here!
			--if data.UpdateHair then
			--	print("tuck")
			if InutilLib.room:GetFrameCount() == 1 then
				--yandereWaifu.ApplyCostumes( yandereWaifu.GetEntityData(player).currentMode, player , false, false)
			end
			--	data.UpdateHair = false
			--end
			if (data.currentMode == RebekahCurse.REBECCA_MODE.RedHearts or data.currentMode == RebekahCurse.REBECCA_MODE.SoulHearts) then
				--bonus luck when shooting a barrage
				if cacheF == CacheFlag.CACHE_LUCK then
					if yandereWaifu.GetEntityData(player).LuckBuff then
						player.Luck = player.Luck + 7
					else
						player.Luck = player.Luck
					end
				end
				--epiphora synergy buff
				if cacheF == CacheFlag.CACHE_FIREDELAY and data.EpiphoraBuff then
					--print( player.MaxFireDelay - data.EpiphoraBuff )
					if player.MaxFireDelay > 1 then --incase it breaks
						player.MaxFireDelay = player.MaxFireDelay - data.EpiphoraBuff
					end
				end
			end
			cache.SetRebekahBaseStats(cacheF, player)
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
yandereWaifu:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, yandereWaifu.Rebekahcacheregister)
	

yandereWaifu:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, function(_,player)
	--[[if player:GetPlayerType() == RebekahCurse.SADREBEKAH and not yandereWaifu.ACHIEVEMENT.TAINTED_REBEKAH:IsUnlocked() then 
		if InutilLib.game:GetFrameCount() > 1 then
			--print("fellow")
			InutilLib.AnimateIsaacAchievement("gfx/ui/achievement/locked_tainted_rebekah.png", nil, true, 300)
			--print("fellow")
			player:ChangePlayerType(RebekahCurse.REB_RED)
			local data = yandereWaifu.GetEntityData(player)
				
			if player:GetFrameCount() <= 2 then --trying to make it visually pleasing when she spawns in
				player.Visible = false
			end
			RebekahCurse.ChangeMode( player, RebekahCurse.REBECCA_MODE.RedHearts, true );
			RebeccaInit(player)
			
			--personalized doubletap classes
			data.DASH_DOUBLE_TAP = InutilLib.DoubleTap:New();
			data.ATTACK_DOUBLE_TAP = InutilLib.DoubleTap:New();
			-- start the meters invisible
			data.moveMeterFadeStartFrame = -20;
			data.attackMeterFadeStartFrame = -20;
			data.bonestackMeterFadeStartFrame = 0;
				
			--yandereWaifu.ApplyCostumes( data.currentMode, player );

			if not data.NoBoneSlamActive then data.NoBoneSlamActive = true end
		else
			--print("sol")
			--print(tostring(RebekahCurse.REB))
			Isaac.ExecuteCommand("restart "..RebekahCurse.REB_RED)
			--print("did it work?")
		end
	end]]
	if yandereWaifu.IsNormalRebekah(player) then
		if player.FrameCount <= 1 then --trying to make it visually pleasing when she spawns in
			player.Visible = false
		end
		local data = yandereWaifu.GetEntityData(player)
		
		--personalized doubletap classes
		data.DASH_DOUBLE_TAP = InutilLib.DoubleTap:New();
		data.ATTACK_DOUBLE_TAP = InutilLib.DoubleTap:New();
		-- start the meters invisible
		data.moveMeterFadeStartFrame = -20;
		data.attackMeterFadeStartFrame = -20;
		data.bonestackMeterFadeStartFrame = 0;
		
		RebeccaInit(player)

		if not data.NoBoneSlamActive then data.NoBoneSlamActive = true end
	end
end)

local function Init(force)
	if force == true then
		for i=0, InutilLib.game:GetNumPlayers()-1 do
			local player = Isaac.GetPlayer(i)
			--Isaac.DebugString("1")
			hasInit = true;
			
			--lastSaveTime = 0;
			--RebeccaInit(player)

			--Isaac.DebugString("4")
			
			--Isaac.DebugString("5")
			didKillSatan = false
			
			
			--set for player 1
			if not yandereWaifu.HasCollectibleGuns(player) then
				yandereWaifu:SetRebekahPocketActiveItem( player, mode )
				--player:SetPocketActiveItem(RebekahCurse.Items.COLLECTIBLE_LOVECANNON)
				local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_PERSONALITYPOOF, 0, player.Position, Vector.Zero, player)
			end
		end
	end
end
	
function yandereWaifu:RebeccaGameInit(hasstarted) --Init
	IsaacPresent = false
	JacobPresent = false
	
	for i=0, InutilLib.game:GetNumPlayers()-1 do
		local player = Isaac.GetPlayer(i)
		if yandereWaifu.IsNormalRebekah(player) then
			if wasFromTaintedLocked then 
				wasFromTaintedLocked = false
				--print("fel")
				InutilLib.AnimateIsaacAchievement("gfx/ui/achievement/locked_tainted_rebekah.png", nil, true, 300)
			end
		-- this was commented out as it seems to be a bug that allows players to gain 20/20 when in different modes when continuing a run
		--player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_20_20, false)
			-- if it's a new run
			if not hasstarted then
				Init(true);
			end

		--print("ffff", yandereWaifu.GetEntityData(player).currentMode)
		if not player:IsCoopGhost() then
			yandereWaifu.ApplyCostumes( yandereWaifu.GetEntityData(player).currentMode, player, false )
		else
			player:GetSprite():ReplaceSpritesheet(0, "gfx/characters/ghost_rebekah.png")
			player:GetSprite():ReplaceSpritesheet(1, "gfx/characters/ghost_rebekah.png")
			player:GetSprite():LoadGraphics()
		end
		player:AddCacheFlags(CacheFlag.CACHE_ALL);
		player:EvaluateItems()
		--fix again later
		if not yandereWaifu.GetEntityData(player).NoBoneSlamActive then yandereWaifu.GetEntityData(player).NoBoneSlamActive = true end
		end
    end
end
yandereWaifu:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, yandereWaifu.RebeccaGameInit)


-- composite of all callbacks to ensure proper callback order
yandereWaifu:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
	
	for p = 0, InutilLib.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		if player:GetPlayerType() == 0 then
			IsaacPresent = true
		elseif player:GetPlayerType() == 19 then
			JacobPresent = true
		end
		if yandereWaifu.IsNormalRebekah(player) then
			-- for debugging, remove when release
			Init();
			--if Game():GetFrameCount() - lastSaveTime >= OPTIONS.SAVE_INTERVAL then
			--	yandereWaifu.Save()
			--	lastSaveTime = Game():GetFrameCount();
			--end
			if yandereWaifu.GetEntityData(player).currentMode ~= RebekahCurse.REBECCA_MODE.BrideRedHearts then
				yandereWaifu.TrySpawnMirror();
			end
			--yandereWaifu.RenderMegaMushOverlay(player)
			
			if IsaacPresent and not yandereWaifu.GetEntityData(player).IsaacPresent then
				player:AddNullCostume(RebekahCurse.Costumes.IsaacOverdose)
				yandereWaifu.GetEntityData(player).IsaacPresent = true
			end
			
			if JacobPresent and not yandereWaifu.GetEntityData(player).JacobPresent then
				player:AddNullCostume(RebekahCurse.Costumes.JacobEsauGlad)
				yandereWaifu.GetEntityData(player).JacobPresent = true
			end
			
			yandereWaifu.heartReserveLogic(player);
			yandereWaifu.customMovesInput();
			yandereWaifu.ExtraStompCooldown();
			yandereWaifu.MirrorMechanic();
			
			yandereWaifu.HandleMirrorData()
			
			--custom hurt sounds
			--I removed them right now because I have no good voice for her >:/
			--[[
			if OPTIONS.CUSTOM_DAMAGE_SOUND == true then
				if queueDamageSound == true then
					queueDamageSound = false;
					InutilLib.SFX:Stop(SoundEffect.SOUND_ISAAC_HURT_GRUNT);
					InutilLib.SFX:Play(OPTIONS.CUSTOM_DAMAGE_SOUND_ID, 1, 0, false, OPTIONS.CUSTOM_DAMAGE_SOUND_PITCH);
				end
			end
			if OPTIONS.CUSTOM_DEATH_SOUND == true then
				local isPlayerDead = player:IsDead() and player:GetSprite():IsPlaying("Death") and player:GetSprite():GetFrame() > 7;
				if isPlayerDead and not wasPlayerDead then
					InutilLib.SFX:Stop(SoundEffect.SOUND_ISAACDIES);
					InutilLib.SFX:Play(OPTIONS.CUSTOM_DEATH_SOUND_ID, 1, 0, false, OPTIONS.CUSTOM_DEATH_SOUND_PITCH);
				end
				wasPlayerDead = isPlayerDead;
			end]]
			if player:GetMovementInput() and yandereWaifu.GetEntityData(player).DASH_DOUBLE_TAP_READY then
				yandereWaifu.GetEntityData(player).DASH_DOUBLE_TAP:Update( player:GetMovementInput() , player );
			end
			if player:GetShootingInput() then
				yandereWaifu.GetEntityData(player).ATTACK_DOUBLE_TAP:Update( player:GetShootingInput() , player );
			end
			InutilLib.UpdateTimers();
			
		end
		--[[if player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_ETERNALBOND) then
			yandereWaifu.AddTinyCharacters(player)
		else
		--	yandereWaifu.RemoveTinyCharacters(player)
		end]]
	end
end);

	-- re-add the appropriate costume when the player rerolls (with d4 or d100)
	function yandereWaifu:useReroll(collItem, rng, player)
		--for p = 0, InutilLib.game:GetNumPlayers() - 1 do
		--	local player = Isaac.GetPlayer(p)
			if yandereWaifu.IsNormalRebekah(player) then
				yandereWaifu.ApplyCostumes( yandereWaifu.GetEntityData(player).currentMode, player );
				--player:AddNullCostume(NerdyGlasses)
			end
		--end
	end
	yandereWaifu:AddCallback(ModCallbacks.MC_USE_ITEM, yandereWaifu.useReroll, CollectibleType.COLLECTIBLE_D4)
	yandereWaifu:AddCallback(ModCallbacks.MC_USE_ITEM, yandereWaifu.useReroll, CollectibleType.COLLECTIBLE_D100)


function yandereWaifu:usePocketCannon(collItem, rng, player, flags, slot)
	local ispocket = false
	local data = yandereWaifu.GetEntityData(player)
	if yandereWaifu.IsNormalRebekah(player) then
		if data.IsAttackActive then
			return
		end
		if data.specialActiveAtkCooldown and data.specialActiveAtkCooldown > 0 then
			return
		end
	end
	if slot == ActiveSlot.SLOT_POCKET then
		ispocket = true
	end

	if data.lastActiveUsedFrameCount then
		if InutilLib.game:GetFrameCount() == data.lastActiveUsedFrameCount then
			return
		end
						
		data.lastActiveUsedFrameCount = InutilLib.game:GetFrameCount()
	else
		data.lastActiveUsedFrameCount = InutilLib.game:GetFrameCount()
	end

	if (not data.IsAttackActive and yandereWaifu.IsNormalRebekah(player)) and ispocket then
		InutilLib.ToggleShowActive(player, false, ispocket)
	else
		InutilLib.RefundActiveCharge(player, 0, ispocket) --just in case
		InutilLib.ToggleShowActive(player, false, ispocket)
	end
	
	--[[if collItem == RebekahCurse.Items.COLLECTIBLE_MAINLUA then
		--special parry thing
		local tilde = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_EXTRACHARANIMHELPER, 0, player.Position, Vector(0,0), nil) --body effect
		yandereWaifu.GetEntityData(tilde).Player = player
		yandereWaifu.GetEntityData(tilde).DontFollowPlayer = true
		yandereWaifu.GetEntityData(tilde).TildeConsole = true
		yandereWaifu.GetEntityData(player).Parry = tilde
		tilde.RenderZOffset = 100;
	end]]
end
yandereWaifu:AddCallback( ModCallbacks.MC_USE_ITEM, yandereWaifu.usePocketCannon, RebekahCurse.Items.COLLECTIBLE_LOVECANNON );
yandereWaifu:AddCallback( ModCallbacks.MC_USE_ITEM, yandereWaifu.usePocketCannon, RebekahCurse.Items.COLLECTIBLE_WIZOOBTONGUE );
yandereWaifu:AddCallback( ModCallbacks.MC_USE_ITEM, yandereWaifu.usePocketCannon, RebekahCurse.Items.COLLECTIBLE_APOSTATE );
yandereWaifu:AddCallback( ModCallbacks.MC_USE_ITEM, yandereWaifu.usePocketCannon, RebekahCurse.Items.COLLECTIBLE_PSALM45 );
yandereWaifu:AddCallback( ModCallbacks.MC_USE_ITEM, yandereWaifu.usePocketCannon, RebekahCurse.Items.COLLECTIBLE_FANG );
yandereWaifu:AddCallback( ModCallbacks.MC_USE_ITEM, yandereWaifu.usePocketCannon, RebekahCurse.Items.COLLECTIBLE_BARACHIELSPETAL );
yandereWaifu:AddCallback( ModCallbacks.MC_USE_ITEM, yandereWaifu.usePocketCannon, RebekahCurse.Items.COLLECTIBLE_BEELZEBUBSBREATH );
yandereWaifu:AddCallback( ModCallbacks.MC_USE_ITEM, yandereWaifu.usePocketCannon, RebekahCurse.Items.COLLECTIBLE_MAINLUA );
yandereWaifu:AddCallback( ModCallbacks.MC_USE_ITEM, yandereWaifu.usePocketCannon, RebekahCurse.Items.COLLECTIBLE_COMFORTERSWING);

--custom actions code
function yandereWaifu:customMovesInput()
	for p = 0, InutilLib.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		if yandereWaifu.IsNormalRebekah(player) then
			local playerdata = yandereWaifu.GetEntityData(player);
			local controller = player.ControllerIndex;
			if not playerdata.specialSwitchCooldown then playerdata.specialSwitchCooldown = 0 end --cooldown for click switch detection
			if not playerdata.specialCooldown then playerdata.specialCooldown = 0 end --cooldown special
			if not playerdata.specialActiveAtkCooldown then playerdata.specialActiveAtkCooldown = 0 end  --atk cooldown special
			if not playerdata.invincibleTime then playerdata.invincibleTime = 0 end --invincible time
			
			if playerdata.specialSwitchCooldown > 0 then playerdata.specialSwitchCooldown = playerdata.specialSwitchCooldown - 1 end
			if playerdata.specialCooldown > 0 and not playerdata.IsDashActive then playerdata.specialCooldown = playerdata.specialCooldown - 1 end --countdown for using dash skill
			if playerdata.specialActiveAtkCooldown > 0 and not playerdata.IsAttackActive then playerdata.specialActiveAtkCooldown = playerdata.specialActiveAtkCooldown - 1 end --countdown for using atk skill
			if playerdata.invincibleTime > 0 then playerdata.invincibleTime = playerdata.invincibleTime - 1 end --frames on counting down how much time you can be invincible
			
			if not playerdata.isReadyForSpecialAttack then playerdata.isReadyForSpecialAttack = false end
			--print(playerdata.invincibleTime)
			
			--charge pocket item after ready

			--[[if playerdata.specialActiveAtkCooldown and playerdata.specialActiveAtkCooldown == 0 and player:GetActiveCharge(ActiveSlot.SLOT_POCKET) < InutilLib.config:GetCollectible(player:GetActiveItem(ActiveSlot.SLOT_POCKET)).MaxCharges and yandereWaifu.HasCollectibleGuns(player) then --could need attendance later, this can be optimized
				InutilLib.RefundActiveCharge(player, 0, true, true)
			end]]
			if playerdata.specialCooldown == 1 then --1 is already close to 0 without being 0 so eh
				local charge = Isaac.Spawn( EntityType.ENTITY_EFFECT, EffectVariant.HEART, 0, player.Position, Vector(0,0), player );
				charge.SpriteOffset = Vector(0,-40)
				charge:GetSprite():ReplaceSpritesheet(0, "gfx/effects/move_effect_filled.png");
				charge:GetSprite():LoadGraphics();
				if playerdata.currentMode ~= RebekahCurse.REBECCA_MODE.BoneHearts or playerdata.BoneStacks == 5 then
					InutilLib.SFX:Play( SoundEffect.SOUND_MIRROR_EXIT , 1.3, 0, false, 1.2 );
				end
			end
			if playerdata.specialActiveAtkCooldown == 1 then
				local charge = Isaac.Spawn( EntityType.ENTITY_EFFECT, EffectVariant.HEART, 0, player.Position, Vector(0,0), player );
				charge.SpriteOffset = Vector(0,-40)
				charge:GetSprite():ReplaceSpritesheet(0, "gfx/effects/attack_effect_filled.png");
				charge:GetSprite():LoadGraphics();
				InutilLib.SFX:Play( SoundEffect.SOUND_MIRROR_EXIT , 1.2, 0, false, 0.4 );
			end
			
			local isLoveCannon = InutilLib.GetShowingActive(player) == RebekahCurse.Items.COLLECTIBLE_LOVECANNON
			local isWizoobsTongue = InutilLib.GetShowingActive(player) == RebekahCurse.Items.COLLECTIBLE_WIZOOBTONGUE
			local isApostate = InutilLib.GetShowingActive(player) == RebekahCurse.Items.COLLECTIBLE_APOSTATE
			local isPsalm45 = InutilLib.GetShowingActive(player) == RebekahCurse.Items.COLLECTIBLE_PSALM45
			local isBarachielsPetal = InutilLib.GetShowingActive(player) == RebekahCurse.Items.COLLECTIBLE_BARACHIELSPETAL
			local isFang = InutilLib.GetShowingActive(player) == RebekahCurse.Items.COLLECTIBLE_FANG
			local isBeelzebubsBreath = InutilLib.GetShowingActive(player) == RebekahCurse.Items.COLLECTIBLE_BEELZEBUBSBREATH
			local isMainLua = InutilLib.GetShowingActive(player) == RebekahCurse.Items.COLLECTIBLE_MAINLUA
			local isComfortersWing = InutilLib.GetShowingActive(player) == RebekahCurse.Items.COLLECTIBLE_COMFORTERSWING
			--special beam thing
			--print(InutilLib.GetShowingActive(player))
			if playerdata.isReadyForSpecialAttack == false and (isLoveCannon or isWizoobsTongue or isApostate or isPsalm45 or isBarachielsPetal or isFang or isBeelzebubsBreath or isMainLua or isComfortersWing) and yandereWaifu.getReserveStocks(player) >= 1 then
				playerdata.isReadyForSpecialAttack = true;
				local arcane = Isaac.Spawn( EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_SPECIALBEAM, 0, player.Position, Vector(0,0), player );
				yandereWaifu.GetEntityData(arcane).parent = player
				InutilLib.SFX:Play( SoundEffect.SOUND_BLOOD_LASER , 1, 0, false, 1.2 );
				if yandereWaifu.GetEntityData(player).currentMode == RebekahCurse.REBECCA_MODE.SoulHearts then
					for i = 0, 6 do
						arcane:GetSprite():ReplaceSpritesheet(i, "gfx/effects/soul/special_beam.png")
					end
				elseif yandereWaifu.GetEntityData(player).currentMode == RebekahCurse.REBECCA_MODE.EvilHearts then
					for i = 0, 6 do
						arcane:GetSprite():ReplaceSpritesheet(i, "gfx/effects/evil/special_beam.png")
					end
				elseif yandereWaifu.GetEntityData(player).currentMode == RebekahCurse.REBECCA_MODE.EternalHearts then
					for i = 0, 6 do
						arcane:GetSprite():ReplaceSpritesheet(i, "gfx/effects/eternal/special_beam.png")
					end
				elseif yandereWaifu.GetEntityData(player).currentMode == RebekahCurse.REBECCA_MODE.GoldHearts then
					for i = 0, 6 do
						arcane:GetSprite():ReplaceSpritesheet(i, "gfx/effects/gold/special_beam.png")
					end
				elseif yandereWaifu.GetEntityData(player).currentMode == RebekahCurse.REBECCA_MODE.RottenHearts then
					for i = 0, 6 do
						arcane:GetSprite():ReplaceSpritesheet(i, "gfx/effects/rotten/special_beam.png")
					end
				elseif yandereWaifu.GetEntityData(player).currentMode == RebekahCurse.REBECCA_MODE.BrokenHearts then
					for i = 0, 6 do
						arcane:GetSprite():ReplaceSpritesheet(i, "gfx/effects/broken/special_beam.png")
					end
				end
				arcane:GetSprite():LoadGraphics()
			else
				local isLoveCannon = InutilLib.GetShowingActive(player) == RebekahCurse.Items.COLLECTIBLE_LOVECANNON
				local isWizoobsTongue = InutilLib.GetShowingActive(player) == RebekahCurse.Items.COLLECTIBLE_WIZOOBTONGUE
				local isApostate = InutilLib.GetShowingActive(player) == RebekahCurse.Items.COLLECTIBLE_APOSTATE
				local isPsalm45 = InutilLib.GetShowingActive(player) == RebekahCurse.Items.COLLECTIBLE_PSALM45
				local isBarachielsPetal = InutilLib.GetShowingActive(player) == RebekahCurse.Items.COLLECTIBLE_BARACHIELSPETAL
				local isFang = InutilLib.GetShowingActive(player) == RebekahCurse.Items.COLLECTIBLE_FANG
				local isBeelzebubsBreath = InutilLib.GetShowingActive(player) == RebekahCurse.Items.COLLECTIBLE_BEELZEBUBSBREATH
				local isMainLua = InutilLib.GetShowingActive(player) == RebekahCurse.Items.COLLECTIBLE_MAINLUA
				local isComfortersWing = InutilLib.GetShowingActive(player) == RebekahCurse.Items.COLLECTIBLE_COMFORTERSWING
				if playerdata.isReadyForSpecialAttack and not (isLoveCannon or isWizoobsTongue or isApostate or isPsalm45 or isBarachielsPetal or isFang or isComfortersWing or isBeelzebubsBreath or isMainLua) then
					playerdata.isReadyForSpecialAttack = false
				end
			end
			--switch skill (used in bone hearts?)
			--useless now?
			--[[if playerdata.specialActiveAtkCooldown <= 0 then
				if (Input.IsActionPressed(ButtonAction.ACTION_DROP, controller)) then switch actions
					if playerdata.isReadyForSpecialAttack == false then
						playerdata.isReadyForSpecialAttack = true;
						local arcane = Isaac.Spawn( EntityType.ENTITY_EFFECT, ENTITY_SPECIALBEAM, 0, player.Position, Vector(0,0), player );
						yandereWaifu.GetEntityData(arcane).parent = player
						InutilLib.SFX:Play( SoundEffect.SOUND_BLOOD_LASER , 1, 0, false, 1.2 );
					end
				elseif not (Input.IsActionPressed(ButtonAction.ACTION_DROP, controller)) then
					if playerdata.isReadyForSpecialAttack then
						playerdata.isReadyForSpecialAttack = false;
						InutilLib.SFX:Play( SoundEffect.SOUND_BLOOD_LASER , 1, 0, false, 1.6 );
						playerdata.specialSwitchCooldown = OPTIONS.SPECIAL_SWITCH_COOLDOWN;
					end
				end
				if playerdata.isReadyForSpecialAttack then
					player.FireDelay = player.MaxFireDelay
					player:SetShootingCooldown(2)
					player:CanTurnHead(true)
					print(playerdata.lastHeadDir, "  ", InutilLib.DirToVec(player:GetHeadDirection()))
				else
					playerdata.lastHeadDir = player:GetAimDirection()
				end
			end]]
		end
	end
end

function yandereWaifu:ExtraStompCooldown()
	for p = 0, InutilLib.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		local playerdata = yandereWaifu.GetEntityData(player);
		local controller = player.ControllerIndex;
		
		if not playerdata.specialBoneHeartStompCooldown then playerdata.specialBoneHeartStompCooldown = 0 end --special cooldown for stomping an entity cooldown, i dont want the stomp to be a dominant skill
		if playerdata.specialBoneHeartStompCooldown > 0 then playerdata.specialBoneHeartStompCooldown = playerdata.specialBoneHeartStompCooldown - 1 end --countdown for using dash skill
	end
end


function yandereWaifu.DoRebeccaBarrage(player, mode, direction)
	local data = yandereWaifu.GetEntityData(player)
	
	local modes
	direction = direction or data.specialAttackVector
	
	if type(mode) == 'number' then
		modes = mode
	--else
	--	modes = yandereWaifu.GetEntityData(player).currentMode
	--	print("LMAO")
	end
	
	if not data.BarrageIntro then
		data.BarrageIntro = false
	end
	
	--charging code
	--chargeDelay is like FireDelay
	if not data.chargeDelay then data.chargeDelay = 0 end
	if not data.barrageInit then data.barrageInit = false end -- tells if the barrage has started
	
	barrage.SetRebekahBarragesInit(player, modes, data, direction)
end

yandereWaifu:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, damage, amount, damageFlag, damageSource, damageCountdownFrames) --invincibilityframe when dashing or whatnot
	local player = damage:ToPlayer();
	local data = yandereWaifu.GetEntityData(player)
	if damageSource.Entity and yandereWaifu.GetEntityData(damageSource.Entity).NoHarm then return false end
	
	if yandereWaifu.IsNormalRebekah(player) then
		if yandereWaifu.GetEntityData(player).invincibleTime > 0 then

			-- non-red heart damage
			if (damageFlag & DamageFlag.DAMAGE_RED_HEARTS) == 0
			-- things that don't break through invincibility
			and (damageFlag & DamageFlag.DAMAGE_INVINCIBLE) == 0 and (damageFlag & DamageFlag.DAMAGE_IV_BAG) == 0 then
				return false;
			end
		else
			queueDamageSound = true;
		end
		
		if data.mainGlitch then
			if not data.tankAmount then data.tankAmount = 0 end
			if data.tankAmount >= 50 then 
				InutilLib.game:ShakeScreen(5);
				InutilLib.SFX:Play( SoundEffect.SOUND_FORESTBOSS_STOMPS, 1, 0, false, 1 );
				damage:Kill()
			else
				data.tankAmount = data.tankAmount + 1
				player:AddCacheFlags(CacheFlag.CACHE_DAMAGE);
				player:EvaluateItems()
				return false
			end
		end
		
		if data.Parry then --tilde parry effect
			if data.Parry:GetSprite():IsPlaying("Parry") and data.Parry:GetSprite():WasEventTriggered("Parry") and not data.Parry:GetSprite():WasEventTriggered("StopParry") then
				data.Parry:GetSprite():Play("SuccessLoop")
				data.IsParryInvul = true
				InutilLib.SFX:Play( SoundEffect.SOUND_THUMBSUP_AMPLIFIED, 0.7, 0, false, 0.5 );
				if InutilLib.IsShowingItem(player) then
					InutilLib.ToggleShowActive(player, false, InutilLib.GetShowingActiveSlot(player))
				end
				player.FireDelay = 60
				return false
			elseif data.Parry:GetSprite():IsPlaying("Parry") and data.Parry:GetSprite():WasEventTriggered("Parry") and data.Parry:GetSprite():WasEventTriggered("StopParry") then --missed parry
				data.Parry:GetSprite():Play("Fail")
				InutilLib.SFX:Play( SoundEffect.SOUND_THUMBSDOWN_AMPLIFIED, 0.7, 0, false, 0.5 );
				if InutilLib.IsShowingItem(player) then
					InutilLib.ToggleShowActive(player, false, InutilLib.GetShowingActiveSlot(player))
				end
				player.FireDelay = 60
			end
		end
		

		  
		if data.IsLeftover then
			return false
		end
		
		if data.IsParryInvul then
			InutilLib.game:ShakeScreen(5);
			InutilLib.SFX:Play( SoundEffect.SOUND_THUMBSUP_AMPLIFIED, 0.7, 0, false, 0.5 );
			return false
		end
	end
end, EntityType.ENTITY_PLAYER)

--rebekah miniisaac thing
function yandereWaifu:MiniIsaacReplaceSpritesheet(fam)
	local player = fam.Player
	local sprite = fam:GetSprite()
	if yandereWaifu.IsNormalRebekah(player) then
		sprite:ReplaceSpritesheet(0, "gfx/familiar/familiar_minisaac_rebekah.png")
		sprite:ReplaceSpritesheet(1, "gfx/familiar/familiar_minisaac_rebekah.png")
	end
	sprite:LoadGraphics()
end
yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, yandereWaifu.MiniIsaacReplaceSpritesheet, FamiliarVariant.MINISAAC)


--health stuff
yandereWaifu:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_,player)
	local data = yandereWaifu.GetEntityData(player)
	local hearts = InutilLib.GetAllMajorHearts(player) + player:GetBoneHearts()*2
	local pos = (math.ceil(player:GetSoulHearts() / 2) + player:GetBoneHearts())-1
	if yandereWaifu.IsNormalRebekah(player) then
	--	print("LTESS GOOO")
		if hearts > 12 then
			--print("WTFFF")
			if player:IsBoneHeart(pos) then
				player:AddBoneHearts(-1)
			else
				player:AddSoulHearts(-1)
			end
		end
		if player:GetMaxHearts() > 6 then
			player:AddMaxHearts(-1)
			--[[if not data.PersistentPlayerData.heartReserveMaxFillPieces then 
				data.PersistentPlayerData.heartReserveMaxFillPieces = 1 
			else
				data.PersistentPlayerData.heartReserveMaxFillPieces = data.PersistentPlayerData.heartReserveMaxFillPieces + 1
			end
			print(data.PersistentPlayerData.heartReserveMaxFillPieces)
			if data.PersistentPlayerData.heartReserveMaxFillPieces > 1 then]]
			data.heartStocksMax = data.heartStocksMax + 1 
			data.heartStocks = data.heartStocks + 1
			--[[	data.PersistentPlayerData.heartReserveMaxFillPieces = 0
			end]]
			local gulp = Isaac.Spawn( EntityType.ENTITY_EFFECT,  RebekahCurse.ENTITY_HEARTGULP, 0, player.Position, Vector(0,0), player );
			yandereWaifu.GetEntityData(gulp).Parent = player
			gulp.SpriteOffset = Vector(0,-20)
			gulp.RenderZOffset = 10000
			InutilLib.SFX:Play( SoundEffect.SOUND_VAMP_GULP , 1.3, 0, false, 1 );
		end
	end
end)