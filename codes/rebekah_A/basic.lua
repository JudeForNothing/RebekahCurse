local wasFromTaintedLocked = false

local IsaacPresent = false
local JacobPresent = false


local hasInit = false;
--local currentMode = REBECCA_MODE.RedHearts;
local bossRoomsCleared = {}; --tells which rooms says what room is cleared to spawn the mirror

local didKillSatan = false

local giant = Sprite()
giant:Load("gfx/characters/big_rebekah.anm2",true)

local function BasicRebeccaInit(player, mode) --sets up basic attributes for Rebekah
	local data = yandereWaifu.GetEntityData(player)
	if mode then data.currentMode = mode else data.currentMode = nil end
	--player:AddNullCostume(NerdyGlasses)
	
	--data.currentMode = REBECCA_MODE.RedHearts
	--player:AddCacheFlags (CacheFlag.CACHE_ALL);
	--player:EvaluateItems();
	
	--heart reserve
	data.heartReserveFill = 0
	data.heartReserveMaxFill = 0 
	data.heartStocks = 0
	
	data.DASH_DOUBLE_TAP:Reset();
end

local function RebeccaInit(player)
	IsaacPresent = false
	JacobPresent = false
	
	local data = yandereWaifu.GetEntityData(player)
	player:AddHearts(-REBEKAH_BALANCE.INIT_REMOVE_HEARTS);
	--heart reserve
	BasicRebeccaInit(player)
	
	yandereWaifu.ChangeMode( player, REBECCA_MODE.RedHearts, true );
	yandereWaifu.AddRandomHeart(player)
	

	data.ATTACK_DOUBLE_TAP:Reset();
	
	if RebekahLocalSavedata.CurrentRebeccaUnlocks == nil then RebekahLocalSavedata.CurrentRebeccaUnlocks = BaseRebeccaUnlocks end
	if RebekahLocalSavedata.CurrentRebeccaUnlocks.HAS_LOVERS_CARD then --MEGA STAN UNLOCK
		player:AddCard(Card.CARD_LOVERS)
	end
	
	--for other characters who comes in but not on game_start
	if Game():GetRoom():GetFrameCount() > -1 and not yandereWaifu.HasCollectibleMultiple(player, RebekahCurse.COLLECTIBLE_LOVECANNON, RebekahCurse.COLLECTIBLE_WIZOOBTONGUE, RebekahCurse.COLLECTIBLE_APOSTATE, RebekahCurse.COLLECTIBLE_MAINLUA, RebekahCurse.COLLECTIBLE_PSALM45, RebekahCurse.COLLECTIBLE_BARACHIELSPETAL, RebekahCurse.COLLECTIBLE_FANG, RebekahCurse.COLLECTIBLE_BEELZEBUBSBREATH) then
		yandereWaifu:SetRebekahPocketActiveItem( player, yandereWaifu.GetEntityData(player).currentMode )
		--player:SetPocketActiveItem(RebekahCurse.COLLECTIBLE_LOVECANNON)
	end
	
	player.Visible = true
	local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_PERSONALITYPOOF, 0, player.Position, Vector.Zero, player)
end



yandereWaifu:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function(_,player)
	--local player = Isaac.GetPlayer(0);
    local room = Game():GetRoom();
	local data = yandereWaifu.GetEntityData(player)
	--print(player:GetPlayerType())
	--print(RebekahCurse.SADREBEKAH)
	if player:GetPlayerType() == RebekahCurse.SADREBEKAH then 
		if ILIB.game:GetFrameCount() > 1 then
			--InutilLib.AnimateIsaacAchievement("gfx/ui/achievements/locked_tainted_rebekah.png", nil, true, 300)
			--[[if ILIB.game:GetFrameCount() >= 1 then
				print("fel")
			end]]
			
			player:ChangePlayerType(RebekahCurse.REB_RED)
			--local data = yandereWaifu.GetEntityData(player)
				
			if player.FrameCount <= 2 then --trying to make it visually pleasing when she spawns in
				player.Visible = false
			end
			yandereWaifu.ChangeMode( player, REBECCA_MODE.RedHearts, true );
			
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
	end
	
	if yandereWaifu.IsNormalRebekah(player) then
	
		--double tap local dash function
		local function RebekahDoubleTapDash(vector, playerTapping)
			for p = 0, ILIB.game:GetNumPlayers() - 1 do
				local player = Isaac.GetPlayer(p)
				--print(GetPtrHash( playerTapping), "     vector!", GetPtrHash( player))
				if GetPtrHash( playerTapping ) == GetPtrHash( player) then
					local psprite = player:GetSprite()
					local playerdata = yandereWaifu.GetEntityData(player);

					--print(playerdata.IsDashActive , playerdata.IsAttackActive , playerdata.NoBoneSlamActive)
					local trinketBonus = 0
					if player:HasTrinket(RebekahCurse.TRINKET_ISAACSLOCKS) then
						trinketBonus = 5
					end
					if not (psprite:IsPlaying("Trapdoor") or psprite:IsPlaying("Jump") or psprite:IsPlaying("HoleIn") or psprite:IsPlaying("HoleDeath") or psprite:IsPlaying("JumpOut") or
					psprite:IsPlaying("LightTravel") or psprite:IsPlaying("Appear") or psprite:IsPlaying("Death") 
					or psprite:IsPlaying("TeleportUp") or psprite:IsPlaying("TeleportDown")) and not (playerdata.IsUninteractible)
					and not playerdata.IsAttackActive and data.specialCooldown <= 0 and not data.IsParalysed then
						if yandereWaifu.GetEntityData(player).currentMode == REBECCA_MODE.RedHearts then --IF RED HEART MODE
							yandereWaifu.RedHeartDash(player, vector)
						elseif yandereWaifu.GetEntityData(player).currentMode == REBECCA_MODE.SoulHearts then --if blue
							yandereWaifu.SoulHeartTeleport(player, vector)
						elseif yandereWaifu.GetEntityData(player).currentMode == REBECCA_MODE.GoldHearts then --if yellow
							yandereWaifu.GoldHeartSlam(player, vector)
						elseif yandereWaifu.GetEntityData(player).currentMode == REBECCA_MODE.EvilHearts then --if black
							yandereWaifu.EvilHeartTeleport(player, vector)
							--yandereWaifu.EvilHeartDash(player, vector)
						elseif yandereWaifu.GetEntityData(player).currentMode == REBECCA_MODE.EternalHearts then --if eternalhearts
							yandereWaifu.EternalHeartDash(player, vector)
						elseif yandereWaifu.GetEntityData(player).currentMode == REBECCA_MODE.BoneHearts then --if bonehearts
							yandereWaifu.BoneHeartPunch(player, vector)
						elseif yandereWaifu.GetEntityData(player).currentMode == REBECCA_MODE.RottenHearts then
							if not data.noHead then
								local head = Isaac.Spawn( EntityType.ENTITY_FAMILIAR, RebekahCurse.ENTITY_ROTTENHEAD, 0, player.Position, vector:Resized(15), player):ToFamiliar();
								data.noHead = true
								data.RebHead = head
								
								for i, v in pairs (data.RottenFlyTable) do
									--if not v:IsDead() and v:Exists() then
										yandereWaifu.GetEntityData(v).Parent = head
									--end
								end
								
								data.extraHeadsPresent = false
								--code that checks if extra heads exist
								for i, v in pairs (Isaac.GetRoomEntities()) do
									if v.Type == EntityType.ENTITY_FAMILIAR then
										if v.Variant == FamiliarVariant.SCISSORS or v.Variant == FamiliarVariant.DECAP_ATTACK then
											data.extraHeadsPresent = true
											--print("Something wrong")
										end
									end
								end
								if data.extraHeadsPresent == false then
									player:AddNullCostume(RebekahCurseCostumes.HeadlessHead)
								else
									player:AddNullCostume(RebekahCurseCostumes.SkinlessHead)
									yandereWaifu.ApplyCostumes( yandereWaifu.GetEntityData(player).currentMode, player , false, false)
								end
							else
								data.RebHead.Velocity = vector:Resized(15)
								yandereWaifu.GetEntityData(data.RebHead).PickupFrames = 30
							end
							for i, v in pairs(data.RottenFlyTable) do
								--if not v:IsDead() or v:Exists() then
									v.Velocity = v.Velocity + vector:Resized( REBEKAH_BALANCE.ROTTEN_HEARTS_DASH_SPEED );
									yandereWaifu.GetEntityData(v).SpecialDash = true
								--end
							end
							for i, entity in pairs(Isaac.GetRoomEntities()) do
								if entity.Type == EntityType.ENTITY_FAMILIAR and entity.Variant == ENTITY_ROTTENFLYBALL then
									if GetPtrHash(entity:ToFamiliar().Player) == GetPtrHash(player) then
										entity.Velocity = entity.Velocity + vector:Resized( REBEKAH_BALANCE.ROTTEN_HEARTS_DASH_SPEED );
										yandereWaifu.GetEntityData(entity).SpecialDash = true
									end
								end
							end
							
							playerdata.specialCooldown = REBEKAH_BALANCE.ROTTEN_HEARTS_DASH_COOLDOWN - trinketBonus;
						elseif yandereWaifu.GetEntityData(player).currentMode == REBECCA_MODE.BrideRedHearts then --if red 
							player.Velocity = player.Velocity + vector:Resized( REBEKAH_BALANCE.RED_HEARTS_DASH_SPEED );
							yandereWaifu.SpawnDashPoofParticle( player.Position, Vector(0,0), player, RebekahPoofParticleType.Red );
							yandereWaifu.SpawnHeartParticles( 3, 5, player.Position, player.Velocity:Rotated(180):Resized( player.Velocity:Length() * (math.random() * 0.5 + 0.5) ), player, RebekahHeartParticleType.Red );
							playerdata.specialCooldown = REBEKAH_BALANCE.RED_HEARTS_DASH_COOLDOWN - trinketBonus;
							playerdata.invincibleTime = REBEKAH_BALANCE.RED_HEARTS_DASH_INVINCIBILITY_FRAMES;
							InutilLib.SFX:Play( SoundEffect.SOUND_CHILD_HAPPY_ROAR_SHORT, 1, 0, false, 1.5 );
							
							playerdata.DashVector = vector;
							playerdata.IsDashActive = true;
						elseif yandereWaifu.GetEntityData(player).currentMode == REBECCA_MODE.BrokenHearts then
							
							local tilde = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_EXTRACHARANIMHELPER, 0, player.Position, Vector(0,0), nil) --body effect
							yandereWaifu.GetEntityData(tilde).Player = player
							yandereWaifu.GetEntityData(tilde).DontFollowPlayer = true
							yandereWaifu.GetEntityData(tilde).TildeConsole = true
							yandereWaifu.GetEntityData(player).Parry = tilde
							tilde.RenderZOffset = 100;
							playerdata.specialCooldown = REBEKAH_BALANCE.BROKEN_HEARTS_DASH_COOLDOWN - trinketBonus;
						end
						playerdata.specialMaxCooldown = playerdata.specialCooldown --gain the max amount dash cooldown
						-- update the dash double tap cooldown based on Rebecca's mode specific cooldown
					end
					playerdata.DASH_DOUBLE_TAP.cooldown = playerdata.specialCooldown;
				end
			end
		end
		
		yandereWaifu.barrageAndSP( player );
		yandereWaifu.RenderUnderlay( player ) 
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
		--mega mush custom sprite
		if player:GetEffects():GetCollectibleEffect(CollectibleType.COLLECTIBLE_MEGA_MUSH) and not data.IsThicc then
			--data.IsThicc = true
			--player:GetSprite():Load("gfx/characters/big_rebekah.anm2",true)
			--player:GetSprite():LoadGraphics()
		end
		if not  player:GetEffects():GetCollectibleEffect(CollectibleType.COLLECTIBLE_MEGA_MUSH) and data.IsThicc then
			--data.IsThicc = false
		end
		if player:GetSprite():GetFrame() == 12 and player:GetSprite():IsPlaying("Death") == true then
			local glasses = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_BROKEN_GLASSES, 0, player.Position, Vector(-2,0) * 2, player)
		end
		
		--dash skill
		local keyboardKey=Keyboard.KEY_C
		local controllerKey=0
		local enableDashByKey = false
		local controller = player.ControllerIndex;
		if ModConfigMenu then
			keyboardKey = ModConfigMenu.Config["Cursed Rebekah"]["Rebekah Dash Keyboard Binding"]
			controllerKey = ModConfigMenu.Config["Cursed Rebekah"]["Rebekah Dash Controller Binding"]
			enableDashByKey = ModConfigMenu.Config["Cursed Rebekah"]["Rebekah Dash Alternative Key Enable"]
		end
		
		if enableDashByKey and (player:GetMovementInput().X ~= 0 or player:GetMovementInput().Y ~= 0) then
			if (Input.IsButtonTriggered(keyboardKey,controller) or Input.IsButtonTriggered(controllerKey,controller)) then
				RebekahDoubleTapDash(player:GetMovementInput(), player)
			end
			if data.DASH_DOUBLE_TAP_READY then
				data.DASH_DOUBLE_TAP_READY = nil
				data.DASH_DOUBLE_TAP = nil
			end
		else
			if not data.DASH_DOUBLE_TAP_READY then
				if not data.DASH_DOUBLE_TAP then
					data.DASH_DOUBLE_TAP = InutilLib.DoubleTap:New();
				end
				yandereWaifu.GetEntityData(player).DASH_DOUBLE_TAP:AttachCallback( function(vector, playerTapping)
					-- old random velocity code
					-- yandereWaifu.RandomHeartParticleVelocity()
					if not enableDashByKey then
						RebekahDoubleTapDash(vector, playerTapping)
					end
				end)
				data.DASH_DOUBLE_TAP_READY = true
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
		if yandereWaifu.HasCollectibleMultiple(player, RebekahCurse.COLLECTIBLE_LOVECANNON, RebekahCurse.COLLECTIBLE_WIZOOBTONGUE, RebekahCurse.COLLECTIBLE_APOSTATE, RebekahCurse.COLLECTIBLE_MAINLUA, RebekahCurse.COLLECTIBLE_PSALM45, RebekahCurse.COLLECTIBLE_BARACHIELSPETAL, RebekahCurse.COLLECTIBLE_FANG, RebekahCurse.COLLECTIBLE_BEELZEBUBSBREATH) then
			if yandereWaifu.HasCollectibleConfirmedUseMultiple(player, RebekahCurse.COLLECTIBLE_LOVECANNON, RebekahCurse.COLLECTIBLE_WIZOOBTONGUE, RebekahCurse.COLLECTIBLE_APOSTATE, RebekahCurse.COLLECTIBLE_MAINLUA, RebekahCurse.COLLECTIBLE_PSALM45, RebekahCurse.COLLECTIBLE_BARACHIELSPETAL, RebekahCurse.COLLECTIBLE_FANG, RebekahCurse.COLLECTIBLE_BEELZEBUBSBREATH) then
				local vector = InutilLib.DirToVec(player:GetFireDirection())
				local playerdata = yandereWaifu.GetEntityData(player);
				local psprite = player:GetSprite()
				local controller = player.ControllerIndex;
				if not (psprite:IsPlaying("Trapdoor") or psprite:IsPlaying("Jump") or psprite:IsPlaying("HoleIn") or psprite:IsPlaying("HoleDeath") or psprite:IsPlaying("JumpOut") or psprite:IsPlaying("LightTravel") or psprite:IsPlaying("Appear") or psprite:IsPlaying("Death") or psprite:IsPlaying("TeleportUp") or psprite:IsPlaying("TeleportDown")) and not (playerdata.IsUninteractible) then
					--if --[[OPTIONS.HOLD_DROP_FOR_SPECIAL_ATTACK == false or Input.IsActionPressed(ButtonAction.ACTION_DROP, controller)]] playerdata.isReadyForSpecialAttack then
					if (yandereWaifu.getReserveStocks(player) >= 1 and playerdata.NoBoneSlamActive and (yandereWaifu.GetEntityData(player).currentMode ~= REBECCA_MODE.BrokenHearts--[[and yandereWaifu.GetEntityData(player).currentMode ~= REBECCA_MODE.RottenHearts]]))
						or (yandereWaifu.GetEntityData(player).currentMode == REBECCA_MODE.BrokenHearts --[[or (yandereWaifu.GetEntityData(player).currentMode == REBECCA_MODE.RottenHearts and ((not data.noHead) or (data.noHead and yandereWaifu.getReserveStocks(player) >= 1)))]]) then --((player:GetSoulHearts() >= 2 and player:GetHearts() > 0) or player:GetHearts() > 2) and playerdata.NoBoneSlamActive then
						if yandereWaifu.GetEntityData(player).currentMode == REBECCA_MODE.RedHearts then --if red 
							playerdata.specialActiveAtkCooldown = 120;
							playerdata.invincibleTime = 10;
							playerdata.redcountdownFrames = 0;  --just in case, it kinda breaks occasionally, so that's weird
						elseif yandereWaifu.GetEntityData(player).currentMode == REBECCA_MODE.SoulHearts then --if blue 
							playerdata.specialActiveAtkCooldown = 60;
							playerdata.soulcountdownFrames = 0;
						elseif yandereWaifu.GetEntityData(player).currentMode == REBECCA_MODE.GoldHearts then --if yellow 
							playerdata.specialActiveAtkCooldown = 30;
						elseif yandereWaifu.GetEntityData(player).currentMode == REBECCA_MODE.EvilHearts then --if black 
							playerdata.specialActiveAtkCooldown = 75;
						elseif yandereWaifu.GetEntityData(player).currentMode == REBECCA_MODE.EternalHearts then --if eternal 
							playerdata.specialActiveAtkCooldown = 120;
						elseif yandereWaifu.GetEntityData(player).currentMode == REBECCA_MODE.BoneHearts then --if bone 
							playerdata.specialActiveAtkCooldown = 20;
						elseif yandereWaifu.GetEntityData(player).currentMode == REBECCA_MODE.RottenHearts then --if rotten 
							playerdata.specialActiveAtkCooldown = 80;
						elseif yandereWaifu.GetEntityData(player).currentMode == REBECCA_MODE.BrokenHearts then --if broken 
							playerdata.specialActiveAtkCooldown = 80;
						elseif yandereWaifu.GetEntityData(player).currentMode == REBECCA_MODE.BrideRedHearts then --if bred 
							playerdata.specialActiveAtkCooldown = 80;
							playerdata.invincibleTime = 10;
							playerdata.redcountdownFrames = 0;  --just in case, it kinda breaks occasionally, so that's weird
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
					else
						yandereWaifu.purchaseReserveStocks(player, 1, true)
						--InutilLib.ToggleShowActive(player, false, InutilLib.GetShowingActiveSlot(player))

						--InutilLib.ToggleShowActive(player, false, true)
						InutilLib.SFX:Play( SoundEffect.SOUND_THUMBS_DOWN, 1, 0, false, 1 );
						--playerdata.ATTACK_DOUBLE_TAP.cooldown = OPTIONS.FAILED_SPECIAL_ATTACK_COOLDOWN;
						
						--local charge = Isaac.Spawn( EntityType.ENTITY_EFFECT, EffectVariant.HEART, 0, player.Position, Vector(0,0), player );
						--charge.SpriteOffset = Vector(0,-40)
						local gulp = Isaac.Spawn( EntityType.ENTITY_EFFECT,  RebekahCurse.ENTITY_HEARTGULP, 0, player.Position, Vector(0,0), player );
						yandereWaifu.GetEntityData(gulp).Parent = parent
						gulp.SpriteOffset = Vector(0,-20)
						gulp.RenderZOffset = 10000
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
yandereWaifu:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function(_,player)
	--local player = Isaac.GetPlayer(0);
    local room = Game():GetRoom();
	local data = yandereWaifu.GetEntityData(player)
	
	if not yandereWaifu.IsNormalRebekah(player) then
		
		if yandereWaifu.HasCollectibleMultiple(player, RebekahCurse.COLLECTIBLE_LOVECANNON, RebekahCurse.COLLECTIBLE_WIZOOBTONGUE, RebekahCurse.COLLECTIBLE_APOSTATE, RebekahCurse.COLLECTIBLE_MAINLUA, RebekahCurse.COLLECTIBLE_PSALM45, RebekahCurse.COLLECTIBLE_BARACHIELSPETAL, RebekahCurse.COLLECTIBLE_FANG, RebekahCurse.COLLECTIBLE_BEELZEBUBSBREATH) then
			if yandereWaifu.HasCollectibleConfirmedUseMultiple(player, RebekahCurse.COLLECTIBLE_LOVECANNON, RebekahCurse.COLLECTIBLE_WIZOOBTONGUE, RebekahCurse.COLLECTIBLE_APOSTATE, RebekahCurse.COLLECTIBLE_MAINLUA, RebekahCurse.COLLECTIBLE_PSALM45, RebekahCurse.COLLECTIBLE_BARACHIELSPETAL, RebekahCurse.COLLECTIBLE_FANG, RebekahCurse.COLLECTIBLE_BEELZEBUBSBREATH) then
				local vector = InutilLib.DirToVec(player:GetFireDirection())
				local playerdata = yandereWaifu.GetEntityData(player);
				local psprite = player:GetSprite()
				local controller = player.ControllerIndex;
				playerdata.specialAttackVector = Vector( vector.X, vector.Y );
				if InutilLib.ConfirmUseActive( player, RebekahCurse.COLLECTIBLE_WIZOOBTONGUE ) then
					yandereWaifu.DoExtraBarrages(player, 5)
				elseif InutilLib.ConfirmUseActive( player, RebekahCurse.COLLECTIBLE_APOSTATE ) then
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
				elseif InutilLib.ConfirmUseActive( player, RebekahCurse.COLLECTIBLE_PSALM45 ) then
					local ned = Isaac.Spawn( EntityType.ENTITY_FAMILIAR, RebekahCurse.ENTITY_NED_NORMAL, 0, player.Position, Vector( 0, 0 ), player):ToFamiliar();
				elseif InutilLib.ConfirmUseActive( player, RebekahCurse.COLLECTIBLE_BARACHIELSPETAL ) then
					local angle = vector:GetAngleDegrees()
					local beam = EntityLaser.ShootAngle(5, player.Position, angle, 10, Vector(0,10), player):ToLaser()
					if not yandereWaifu.GetEntityData(beam).IsLvlOneBeam then yandereWaifu.GetEntityData(beam).IsLvlOneBeam = true end
				elseif InutilLib.ConfirmUseActive( player, RebekahCurse.COLLECTIBLE_FANG ) then
					for i = 1, 4 do --extra carrion worm thingies when extra tears!!
						local leech = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, RebekahCurse.ENTITY_BONEJOCKEY, 10, player.Position, Vector(0,0), player)
						yandereWaifu.GetEntityData(leech).ParentLeech = player
					end
				elseif InutilLib.ConfirmUseActive( player, RebekahCurse.COLLECTIBLE_BEELZEBUBSBREATH ) then
					local ball = Isaac.Spawn( EntityType.ENTITY_FAMILIAR, RebekahCurse.ENTITY_ROTTENFLYBALL, 0, player.Position, vector, player):ToFamiliar();
				elseif InutilLib.ConfirmUseActive( player, RebekahCurse.COLLECTIBLE_MAINLUA ) then
					Isaac.Explode(player.Position, player, 500)
					player:TakeDamage(2, 0, EntityRef(player), 1)
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
						local tear = ILIB.game:Spawn( EntityType.ENTITY_TEAR, 1, player.Position, Vector.FromAngle(data.shiftyBeam.Angle + math.random(-5,5)):Resized(math.random(10,25)), player, 0, 0):ToTear()
					else
						local tear = ILIB.game:Spawn( EntityType.ENTITY_TEAR, 0, player.Position, Vector.FromAngle(data.shiftyBeam.Angle + math.random(-5,5)):Resized(math.random(10,25)), player, 0, 0):ToTear()
						tear:GetSprite():Load("gfx/009.005_corn projectile.anm2", true)
						tear:GetSprite():Play("Small01", true)
					end
				end
			end
		else
			data.shiftyBeam = nil
		end
	end
	if data.currentMode == REBECCA_MODE.SoulHearts then
		if data.isPlayingCustomAnim2 then
			--if not data.soulspitframecount then data.soulspitframecount = 0 end
			if data.soulspitframecount == 5 then
				data.BarrageIntro = true
			elseif data.soulspitframecount == 45 then
				player:TryRemoveNullCostume(RebekahCurseCostumes.RebekahSpitsOut)
				data.isPlayingCustomAnim2 = false
				data.isPlayingCustomAnim = false
			end
			data.soulspitframecount = data.soulspitframecount + 1
		end
	end
	if data.currentMode == REBECCA_MODE.RedHearts or data.currentMode == REBECCA_MODE.BoneHearts then
		if data.IsDashActive then --movement code
			local heartType = RebekahHeartParticleType.Red
			if data.currentMode == REBECCA_MODE.RedHearts then
				heartType = RebekahHeartParticleType.Red
			else
				heartType = RebekahHeartParticleType.Black
			end
			
			
			if not data.countdownFrames then data.countdownFrames = 7 end
			data.countdownFrames = data.countdownFrames - 1
			
			if data.countdownFrames < 0 then
				--if data.boneSuccessDash then
				if data.currentMode == REBECCA_MODE.BoneHearts then 
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
			--if not data.currentMode == REBECCA_MODE.EvilHearts then
				yandereWaifu.SpawnHeartParticles( 1, 3, player.Position, player.Velocity:Rotated(180+math.random(-5,5)):Resized( player.Velocity:Length() * (math.random() * 0.5 + 0.5) ), player, heartType );
			end
			
		end
		if data.currentMode == REBECCA_MODE.BoneHearts then
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
	
	if data.currentMode == REBECCA_MODE.EternalHearts then	
		yandereWaifu.FlamethrowerLogic(player)
		--ludo stuff
		if player:HasWeaponType(WeaponType.WEAPON_LUDOVICO_TECHNIQUE) and not data.EternalLudo then
			data.EternalLudo = true
			player:AddCacheFlags(CacheFlag.CACHE_FAMILIARS);
			player:EvaluateItems()
		end
	elseif data.currentMode ~= REBECCA_MODE.EternalHearts and data.EternalLudo then	
		data.EternalLudo = false
		player:AddCacheFlags(CacheFlag.CACHE_FAMILIARS);
		player:EvaluateItems()
	end
	
	if data.currentMode == REBECCA_MODE.EvilHearts and ILIB.game:GetFrameCount() >= 1 then	 --weird bug happens
		--[[if player:GetHearts() <= 0 then
			if player:GetMovementInput():Length() < 1 and not data.OpenedMaw then
				local maw = Isaac.Spawn(EntityType.ENTITY_EFFECT, ENTITY_DARKMAW, 0, player.Position, player.Velocity, player) --feather attack
				data.OpenedMaw = maw
			elseif player:GetMovementInput():Length() >= 1 and data.OpenedMaw then
				data.OpenedMaw:GetSprite():Play("Die",true) --kill it
				data.OpenedMaw = nil
			end
		end
		if not data.EvilType then
			if player:GetHearts() <= 0 then
				data.EvilType = 1
			else
				data.EvilType = 0
			end
		end
		local currentType
		if player:GetHearts() <= 0 then
			currentType = 1
		else
			currentType = 0
		end
		if data.EvilType ~= currentType then
			player:AddCacheFlags(CacheFlag.CACHE_ALL);
			player:EvaluateItems()
			data.EvilType = currentType
			if data.EvilType == 1 then
				InutilLib.AnimateGiantbook(nil, nil, "Shake", "gfx/ui/giantbook/giantbook_void_black_heart.anm2", true)
			end
		end]]
	end

	if data.currentMode == REBECCA_MODE.BrokenHearts then --decrement of tankAmount
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
		
		if yandereWaifu.IsNormalRebekah(player) and yandereWaifu.GetEntityData(player).currentMode == REBECCA_MODE.BrokenHearts then
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
		yandereWaifu.DoRebeccaBarrage(player, data.currentMode, data.specialAttackVector)
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


function yandereWaifu.RenderUnderlay(player) 
	--local player = Isaac.GetPlayer(0)
	local psprite = player:GetSprite()
	if yandereWaifu.GetEntityData(player).currentMode == REBECCA_MODE.BrideRedHearts then	
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
end
--yandereWaifu:AddCallback(ModCallbacks.MC_POST_RENDER, yandereWaifu.RenderUnderlay) 




function yandereWaifu:RenderMegaMushOverlay() 
	--local player = Isaac.GetPlayer(0)
	for p = 0, ILIB.game:GetNumPlayers() - 1 do
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
yandereWaifu:AddCallback(ModCallbacks.MC_POST_RENDER, yandereWaifu.RenderMegaMushOverlay) 

--pickup shizz, because i dont want you to ghost around and pick up random things
yandereWaifu:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, pickup)
	for p = 0, ILIB.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		local entityData = yandereWaifu.GetEntityData(player);
		if yandereWaifu.IsNormalRebekah(player) and not entityData.currentMode == REBECCA_MODE.SoulHearts then
			if ( entityData.invincibleTime or 0 ) > 0 then
				pickup.Wait = 10;
			end
		end
	end
end)


yandereWaifu:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, function(_, ent)
	for p = 0, ILIB.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		local playerType = player:GetPlayerType()
		local room = ILIB.game:GetRoom()
		
		if yandereWaifu.IsNormalRebekah(player) then
			if ent.Type == EntityType.ENTITY_ISAAC or (ent.Type == EntityType.ENTITY_SATAN and not didKillSatan ) then -- isaac heart spawn
				if ILIB.game:GetLevel():GetStage() == 10 then
					didKillSatan = true
					--local spawnPosition = room:FindFreePickupSpawnPosition(room:GetGridPosition(97), 1);
					--local newpickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, 100, CollectibleType.COLLECTIBLE_ISAACS_HEART, spawnPosition, Vector(0,0), player)
				end
			end
			local maxHealth = ent.MaxHitPoints
			if yandereWaifu.getReserveStocks(player) < yandereWaifu.GetEntityData(player).heartStocksMax and not ent:IsInvincible() --[[(ent.Variant == EntityType.ENTITY_STONEY)]] then
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

yandereWaifu:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, damage, amount, damageFlag, damageSource, damageCountdownFrames) --invincibilityframe when dashing or whatnot
	if damage:IsEnemy() then
		if damageSource.Type == 3 and damageSource.Variant == ENTITY_BONEJOCKEY then
			yandereWaifu.GetEntityData(damage).BurstGuts = true
		end
		if REBEKAHMODE_EXPERIMENTAL.lovelove and dmgFlag ~= DamageFlag.DAMAGE_POISON_BURN then
			--print(damageSource.Entity.SpawnerEntity.Type)
			--print(damageSource.Type)
			if (damageSource.Type == 1 --[[or damageSource.Entity.SpawnerType == 1]]) then
				local player = damageSource.Entity:ToPlayer()
				local playerType = player:GetPlayerType()
				local room = ILIB.game:GetRoom()
				
				if yandereWaifu.IsNormalRebekah(player) and not yandereWaifu.GetEntityData(player).IsAttackActive then
					local maxHealth = damage.MaxHitPoints

					if yandereWaifu.getReserveStocks(player) < yandereWaifu.GetEntityData(player).heartStocksMax then
						yandereWaifu.addReserveFill(player, math.floor(amount))
					end
				end
			end
		end
	end
end)

function yandereWaifu:RebekahNewRoom()	
	yandereWaifu.InsertMirrorData()
	for p = 0, ILIB.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		local data = yandereWaifu.GetEntityData(player)
		local room = ILIB.game:GetRoom()
		if yandereWaifu.IsNormalRebekah(player) then
			--spawn main room mirror
			if ILIB.game:GetLevel():GetStartingRoomIndex() == ILIB.game:GetLevel():GetCurrentRoomDesc().SafeGridIndex and not isGreed and room:IsFirstVisit() and ILIB.level:GetStage() == LevelStage.STAGE1_1 and (ILIB.level:GetStageType() ~= StageType.STAGETYPE_REPENTANCE and ILIB.level:GetStageType() ~= StageType.STAGETYPE_REPENTANCE_B) then
				local spawnPosition = room:FindFreePickupSpawnPosition(room:GetGridPosition(19), 1);
				local mir = Isaac.Spawn(EntityType.ENTITY_SLOT, RebekahCurse.ENTITY_REBMIRROR, 10, spawnPosition, Vector(0,0), player);
				yandereWaifu.GetEntityData(mir).Init = false
				mir:GetSprite():Play("Appear")
			end
			
			--in case it is taken away, because of some softlocks
			if not yandereWaifu.HasCollectibleMultiple(player, RebekahCurse.COLLECTIBLE_LOVECANNON, RebekahCurse.COLLECTIBLE_WIZOOBTONGUE, RebekahCurse.COLLECTIBLE_APOSTATE, RebekahCurse.COLLECTIBLE_MAINLUA, RebekahCurse.COLLECTIBLE_PSALM45, RebekahCurse.COLLECTIBLE_BARACHIELSPETAL, RebekahCurse.COLLECTIBLE_FANG, RebekahCurse.COLLECTIBLE_BEELZEBUBSBREATH) then
				yandereWaifu:SetRebekahPocketActiveItem( player, yandereWaifu.GetEntityData(player).currentMode )
				--player:SetPocketActiveItem(RebekahCurse.COLLECTIBLE_LOVECANNON)
			end
			data.DASH_DOUBLE_TAP:Reset();
			data.ATTACK_DOUBLE_TAP:Reset();
			--neded for soul heart and bone heart movement lol
			--if this was tampered to being with
			if data.IsUninteractible then 
				if data.currentMode == REBECCA_MODE.SoulHearts or data.currentMode == REBECCA_MODE.EvilHearts then
					yandereWaifu.RebekahCanShoot(player, true)
				end
				data.IsUninteractible = false 
			end --reset orbitals
			print(data.specialActiveAtkCooldown)
			if data.specialActiveAtkCooldown and data.specialActiveAtkCooldown > 0 then --reset special attack
				yandereWaifu.RebekahCanShoot(player, true)
				player.FireDelay = 60
				data.FinishedPlayingCustomAnim = nil
				data.IsAttackActive = false
				data.chargeDelay = 0
				data.barrageInit = false
				
				data.isPlayingCustomAnim = nil
				--data.soulspitframecount = 0
				data.FinishedPlayingCustomAnim = nil
				data.isPlayingCustomAnim2  = nil
				
				data.BarrageIntro = false
				
				yandereWaifu.RemoveRedGun(player)
				yandereWaifu.RemoveEvilGun(player)
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

			data.isReadyForSpecialAttack = false
			data.IsParryInvul = false
			
			data.lastMode = data.currentMode
			data.lastHeartReserve = yandereWaifu.getReserveFill(player)
			data.lastStockReserve = yandereWaifu.getReserveStocks(player)
			
			
			--workaround for when you go bald in the knife dimension, because theres no way to check what dimension you are in for some reason.......
			--yandereWaifu.ApplyCostumes( yandereWaifu.GetEntityData(player).currentMode, player )
			--print("im no bald")
			
			--heal back tf2 soldiers
			for i, soldier in pairs (Isaac.GetRoomEntities()) do
				if soldier.Variant == RebekahCurse.ENTITY_CHRISTIANNED and soldier.SubType == 2 then
					if soldier:GetSprite():IsFinished("LandFail") then
						soldier:GetSprite():Play("Spawn", true)
					end
				end
			end
			
			if data.mainGlitch then
				if not data.mainGlitch:Exists() then
					data.mainGlitch = nil 
					
					if player:GetBrokenHearts() > 11 then
						player:Die()
					else
						if player:GetHearts() <= 1 then
							player:AddBrokenHearts(1)
						end
						player:TakeDamage( 2, DamageFlag.DAMAGE_NOKILL | DamageFlag.DAMAGE_RED_HEARTS, EntityRef(player), 0);
						player:ResetDamageCooldown()
					end
				end
			end
			if data.debug7 then
				Isaac.ExecuteCommand("debug 7")
				data.debug7 = false
			end
			if data.currentMode == REBECCA_MODE.RottenHearts then
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
				player:AddNullCostume(RebekahCurseCostumes.WizoobHairGoingDown)
				InutilLib.SetTimer( 10*3, function()
					player:TryRemoveNullCostume(RebekahCurseCostumes.WizoobHairGoingDown)
				end)
			end
		end
	end
end
yandereWaifu:AddCallback( ModCallbacks.MC_POST_NEW_ROOM, yandereWaifu.RebekahNewRoom)

--stat cache for each mode
function yandereWaifu:Rebekahcacheregister(player, cacheF) --The thing the checks and updates the game, i guess?
		local data = yandereWaifu.GetEntityData(player)
		local num, num2, num3
		if data.currentMode == REBECCA_MODE.BrideRedHearts and yandereWaifu.IsNormalRebekah(player) then num1 = 1 else num1 = 0 end
		if data.currentMode == REBECCA_MODE.EternalHearts and yandereWaifu.IsNormalRebekah(player) then num2 = 1 else num2 = 0 end
		--if data.currentMode == REBECCA_MODE.BoneHearts and yandereWaifu.IsNormalRebekah(player) then num3 = 1 else num3 = 0 end
		if cacheF == CacheFlag.CACHE_FAMILIARS then
			player:CheckFamiliar(RebekahCurse.ENTITY_LABAN, num1, RNG())
			player:CheckFamiliar(RebekahCurse.ENTITY_MORNINGSTAR, num2, RNG())
		--	player:CheckFamiliar(RebekahCurse.ENTITY_BONEJOCKEY, num3, RNG())
		end
		if yandereWaifu.IsNormalRebekah(player) then -- Especially here!
			--if data.UpdateHair then
			--	print("tuck")
			if ILIB.room:GetFrameCount() < 1 then
				yandereWaifu.ApplyCostumes( yandereWaifu.GetEntityData(player).currentMode, player , false, false)
			end
			--	data.UpdateHair = false
			--end
			if (data.currentMode == REBECCA_MODE.RedHearts or data.currentMode == REBECCA_MODE.SoulHearts) then
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
			if data.currentMode == REBECCA_MODE.RedHearts then
				if cacheF == CacheFlag.CACHE_DAMAGE then
					player.Damage = player.Damage -- 0.73 --1.73
				end
				if cacheF == CacheFlag.CACHE_LUCK then
					player.Luck = player.Luck - 0.13
				end
			elseif data.currentMode == REBECCA_MODE.SoulHearts then
				if cacheF == CacheFlag.CACHE_DAMAGE then
					if yandereWaifu.GetEntityData(player).SoulBuff then
						player.Damage = player.Damage * 3
					else
						player.Damage = player.Damage + 0.5
					end
				end
				if cacheF == CacheFlag.CACHE_FIREDELAY then	
					if player.MaxFireDelay >= 4 then
						player.MaxFireDelay = player.MaxFireDelay - 1
					end
				end
				if cacheF == CacheFlag.CACHE_RANGE then
					player.TearHeight = player.TearHeight - 5.25
				end
				if cacheF == CacheFlag.CACHE_SPEED then
					player.MoveSpeed = player.MoveSpeed + 0.25
				end
				if cacheF == CacheFlag.CACHE_LUCK then
					player.Luck = player.Luck - 1
				end
				if cacheF == CacheFlag.CACHE_TEARFLAG then
					player.TearFlags = player.TearFlags | TearFlags.TEAR_SPECTRAL
				end
				if cacheF == CacheFlag.CACHE_TEARCOLOR then
					player.TearColor = Color(1.0, 1.0, 1.0, 1.0, 0, 0, 0)
				end
				if cacheF == CacheFlag.CACHE_FAMILIARS then
					if player:HasCollectible(CollectibleType.COLLECTIBLE_LIL_HAUNT) then hauntMinions = 3 else hauntMinions = 0 end
					player:CheckFamiliar(FamiliarVariant.LIL_HAUNT, hauntMinions, RNG())
					--end
				end
			elseif data.currentMode == REBECCA_MODE.GoldHearts then
				if cacheF == CacheFlag.CACHE_DAMAGE then
					player.Damage = player.Damage + 1.00
				end
				if cacheF == CacheFlag.CACHE_SPEED then
					player.MoveSpeed = player.MoveSpeed - 0.25
				end
				if cacheF == CacheFlag.CACHE_FIREDELAY then
					player.MaxFireDelay = player.MaxFireDelay + 4
				end
				if cacheF == CacheFlag.CACHE_LUCK then
					player.Luck = player.Luck + 3
				end
			elseif data.currentMode == REBECCA_MODE.EvilHearts then
				--[[if player:GetHearts() < 1 then
					if cacheF == CacheFlag.CACHE_DAMAGE then
						player.Damage = player.Damage / 2
					end
					if cacheF == CacheFlag.CACHE_FIREDELAY then
						player.MaxFireDelay = player.MaxFireDelay - 2
					end
					if cacheF == CacheFlag.CACHE_SPEED then
						player.MoveSpeed = player.MoveSpeed + 0.20
					end
					if cacheF == CacheFlag.CACHE_LUCK then
						player.Luck = player.Luck
					end
				else]]
					if cacheF == CacheFlag.CACHE_DAMAGE then
						player.Damage = player.Damage * 1.20
					end
					if cacheF == CacheFlag.CACHE_FIREDELAY then
						player.MaxFireDelay = player.MaxFireDelay + 2
					end
					if cacheF == CacheFlag.CACHE_SPEED then
						player.MoveSpeed = player.MoveSpeed - 0.10
					end
					if cacheF == CacheFlag.CACHE_LUCK then
						player.Luck = player.Luck - 1
					end
				--end
			elseif data.currentMode == REBECCA_MODE.EternalHearts then
				if cacheF == CacheFlag.CACHE_FIREDELAY then
					player.MaxFireDelay = player.MaxFireDelay + 2
				end
				if cacheF == CacheFlag.CACHE_DAMAGE then
					player.Damage = player.Damage * 0.4
				end
				if cacheF == CacheFlag.CACHE_SPEED then
					player.MoveSpeed = player.MoveSpeed + 0.20
				end
				if cacheF == CacheFlag.CACHE_LUCK then
					player.Luck = player.Luck - 2
				end
				if cacheF == CacheFlag.CACHE_FLYING then
					player.CanFly = true
				end
			elseif data.currentMode == REBECCA_MODE.BoneHearts then
				if cacheF == CacheFlag.CACHE_DAMAGE then
					player.Damage = player.Damage * 1.1
				end
				if cacheF == CacheFlag.CACHE_FIREDELAY then
					player.MaxFireDelay = player.MaxFireDelay
				end
				if cacheF == CacheFlag.CACHE_SPEED then
					player.MoveSpeed = player.MoveSpeed + 0.30
				end
			elseif data.currentMode == REBECCA_MODE.BrideRedHearts then
				if cacheF == CacheFlag.CACHE_DAMAGE then
					player.Damage = player.Damage - 1.73
				end
				if cacheF == CacheFlag.CACHE_LUCK then
					player.Luck = player.Luck - 0.13
				end
				if cacheF == CacheFlag.CACHE_FLYING then
					player.CanFly = true
				end
			elseif data.currentMode == REBECCA_MODE.RottenHearts then
				if cacheF == CacheFlag.CACHE_FIREDELAY then
					player.MaxFireDelay = player.MaxFireDelay - 2
				end
				if cacheF == CacheFlag.CACHE_SPEED then
					player.MoveSpeed = player.MoveSpeed - 0.10
				end
				if cacheF == CacheFlag.CACHE_DAMAGE then
					player.Damage = player.Damage / 2
				end
			elseif data.currentMode == REBECCA_MODE.BrokenHearts then
				if cacheF == CacheFlag.CACHE_SPEED then
					player.MoveSpeed = player.MoveSpeed - 0.40
				end
				if cacheF == CacheFlag.CACHE_DAMAGE then
					if yandereWaifu.GetEntityData(player).BrokenBuff then
						player.Damage = player.Damage + 40.00
					else
						player.Damage = player.Damage
					end
				end
				if cacheF == CacheFlag.CACHE_LUCK then
					if yandereWaifu.GetEntityData(player).BrokenLuck then
						player.Luck = player.Luck + 50.00
					else
						player.Luck = player.Luck
					end
				end
			end
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
			--actual items
		end
		
	end
yandereWaifu:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, yandereWaifu.Rebekahcacheregister)
	

yandereWaifu:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, function(_,player)
	Isaac.DebugString("b")
	if player:GetPlayerType() == RebekahCurse.SADREBEKAH then 
		if ILIB.game:GetFrameCount() > 1 then
			--print("fellow")
			InutilLib.AnimateIsaacAchievement("gfx/ui/achievements/locked_tainted_rebekah.png", nil, true, 300)
			--print("fellow")
			player:ChangePlayerType(RebekahCurse.REB_RED)
			local data = yandereWaifu.GetEntityData(player)
				
			if player:GetFrameCount() <= 2 then --trying to make it visually pleasing when she spawns in
				player.Visible = false
			end
			RebekahCurse.ChangeMode( player, REBECCA_MODE.RedHearts, true );
				
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
			--print("sol")
			--print(tostring(RebekahCurse.REB))
			Isaac.ExecuteCommand("restart "..RebekahCurse.REB_RED)
			--print("did it work?")
		end
	end
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
		--yandereWaifu.ApplyCostumes( data.currentMode, player );

		if not data.NoBoneSlamActive then data.NoBoneSlamActive = true end
	end
end)

local function Init(force)
	if force == true then
		for i=0, ILIB.game:GetNumPlayers()-1 do
			local player = Isaac.GetPlayer(i)
			--Isaac.DebugString("1")
			hasInit = true;
			
			bossRoomsCleared = {};
			--lastSaveTime = 0;
			--RebeccaInit(player)

			--Isaac.DebugString("4")
			
			--Isaac.DebugString("5")
			didKillSatan = false
			
			
			--set for player 1
			if not yandereWaifu.HasCollectibleMultiple(player, RebekahCurse.COLLECTIBLE_LOVECANNON, RebekahCurse.COLLECTIBLE_WIZOOBTONGUE, RebekahCurse.COLLECTIBLE_APOSTATE, RebekahCurse.COLLECTIBLE_MAINLUA, RebekahCurse.COLLECTIBLE_PSALM45, RebekahCurse.COLLECTIBLE_BARACHIELSPETAL, RebekahCurse.COLLECTIBLE_FANG, RebekahCurse.COLLECTIBLE_BEELZEBUBSBREATH) then
				yandereWaifu:SetRebekahPocketActiveItem( player, mode )
				--player:SetPocketActiveItem(RebekahCurse.COLLECTIBLE_LOVECANNON)
				local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_PERSONALITYPOOF, 0, player.Position, Vector.Zero, player)
			end
		end
	end
end
	
function yandereWaifu:RebeccaGameInit(hasstarted) --Init
	IsaacPresent = false
	JacobPresent = false
	
	for i=0, ILIB.game:GetNumPlayers()-1 do
		local player = Isaac.GetPlayer(i)
		if yandereWaifu.IsNormalRebekah(player) then
			if wasFromTaintedLocked then 
				wasFromTaintedLocked = false
				--print("fel")
				InutilLib.AnimateIsaacAchievement("gfx/ui/achievements/locked_tainted_rebekah.png", nil, true, 300)
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
	
	for p = 0, ILIB.game:GetNumPlayers() - 1 do
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
			if yandereWaifu.GetEntityData(player).currentMode ~= REBECCA_MODE.BrideRedHearts then
				yandereWaifu.TrySpawnMirror();
			end
			--yandereWaifu.RenderMegaMushOverlay(player)
			
			if IsaacPresent and not yandereWaifu.GetEntityData(player).IsaacPresent then
				player:AddNullCostume(RebekahCurseCostumes.IsaacOverdose)
				yandereWaifu.GetEntityData(player).IsaacPresent = true
			end
			
			if JacobPresent and not yandereWaifu.GetEntityData(player).JacobPresent then
				player:AddNullCostume(RebekahCurseCostumes.JacobEsauGlad)
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
		--[[if player:HasCollectible(RebekahCurse.COLLECTIBLE_ETERNALBOND) then
			yandereWaifu.AddTinyCharacters(player)
		else
		--	yandereWaifu.RemoveTinyCharacters(player)
		end]]
	end
end);

	-- re-add the appropriate costume when the player rerolls (with d4 or d100)
	function yandereWaifu:useReroll(collItem, rng, player)
		--for p = 0, ILIB.game:GetNumPlayers() - 1 do
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
	if slot == ActiveSlot.SLOT_POCKET then
		ispocket = true
	end

	if data.lastActiveUsedFrameCount then
		if ILIB.game:GetFrameCount() == data.lastActiveUsedFrameCount then
			return
		end
						
		data.lastActiveUsedFrameCount = ILIB.game:GetFrameCount()
	else
		data.lastActiveUsedFrameCount = ILIB.game:GetFrameCount()
	end

	if (not data.IsAttackActive and yandereWaifu.IsNormalRebekah(player)) and ispocket then
		InutilLib.ToggleShowActive(player, false, ispocket)
	else
		InutilLib.RefundActiveCharge(player, 0, ispocket) --just in case
		InutilLib.ToggleShowActive(player, false, ispocket)
	end
end
yandereWaifu:AddCallback( ModCallbacks.MC_USE_ITEM, yandereWaifu.usePocketCannon, RebekahCurse.COLLECTIBLE_LOVECANNON );
yandereWaifu:AddCallback( ModCallbacks.MC_USE_ITEM, yandereWaifu.usePocketCannon, RebekahCurse.COLLECTIBLE_WIZOOBTONGUE );
yandereWaifu:AddCallback( ModCallbacks.MC_USE_ITEM, yandereWaifu.usePocketCannon, RebekahCurse.COLLECTIBLE_APOSTATE );
yandereWaifu:AddCallback( ModCallbacks.MC_USE_ITEM, yandereWaifu.usePocketCannon, RebekahCurse.COLLECTIBLE_PSALM45 );
yandereWaifu:AddCallback( ModCallbacks.MC_USE_ITEM, yandereWaifu.usePocketCannon, RebekahCurse.COLLECTIBLE_FANG );
yandereWaifu:AddCallback( ModCallbacks.MC_USE_ITEM, yandereWaifu.usePocketCannon, RebekahCurse.COLLECTIBLE_BARACHIELSPETAL );
yandereWaifu:AddCallback( ModCallbacks.MC_USE_ITEM, yandereWaifu.usePocketCannon, RebekahCurse.COLLECTIBLE_BEELZEBUBSBREATH );
yandereWaifu:AddCallback( ModCallbacks.MC_USE_ITEM, yandereWaifu.usePocketCannon, RebekahCurse.COLLECTIBLE_MAINLUA );

--custom actions code
function yandereWaifu:customMovesInput()
	for p = 0, ILIB.game:GetNumPlayers() - 1 do
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
			--setting max heartStocks
			if not playerdata.heartStocksMax then playerdata.heartStocksMax = 3 end
			if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) then
				playerdata.heartStocksMax = 6
			else
				playerdata.heartStocksMax = 3
			end
			
			--charge pocket item after ready

			if playerdata.specialActiveAtkCooldown == 0 and player:GetActiveCharge(ActiveSlot.SLOT_POCKET) < InutilLib.config:GetCollectible(player:GetActiveItem(ActiveSlot.SLOT_POCKET)).MaxCharges and yandereWaifu.HasCollectibleMultiple(player, RebekahCurse.COLLECTIBLE_LOVECANNON, RebekahCurse.COLLECTIBLE_WIZOOBTONGUE, RebekahCurse.COLLECTIBLE_APOSTATE, RebekahCurse.COLLECTIBLE_MAINLUA, RebekahCurse.COLLECTIBLE_PSALM45, RebekahCurse.COLLECTIBLE_BARACHIELSPETAL, RebekahCurse.COLLECTIBLE_FANG, RebekahCurse.COLLECTIBLE_BEELZEBUBSBREATH) then --could need attendance later, this can be optimized
				InutilLib.RefundActiveCharge(player, 0, true, true)
			end
			if playerdata.specialCooldown == 1 then --1 is already close to 0 without being 0 so eh
				local charge = Isaac.Spawn( EntityType.ENTITY_EFFECT, EffectVariant.HEART, 0, player.Position, Vector(0,0), player );
				charge.SpriteOffset = Vector(0,-40)
				charge:GetSprite():ReplaceSpritesheet(0, "gfx/effects/move_effect_filled.png");
				charge:GetSprite():LoadGraphics();
				InutilLib.SFX:Play( SoundEffect.SOUND_MIRROR_EXIT , 1.3, 0, false, 1.2 );
			end
			if playerdata.specialActiveAtkCooldown == 1 then
				local charge = Isaac.Spawn( EntityType.ENTITY_EFFECT, EffectVariant.HEART, 0, player.Position, Vector(0,0), player );
				charge.SpriteOffset = Vector(0,-40)
				charge:GetSprite():ReplaceSpritesheet(0, "gfx/effects/attack_effect_filled.png");
				charge:GetSprite():LoadGraphics();
				InutilLib.SFX:Play( SoundEffect.SOUND_MIRROR_EXIT , 1.2, 0, false, 0.4 );
			end
			
			local isLoveCannon = InutilLib.GetShowingActive(player) == RebekahCurse.COLLECTIBLE_LOVECANNON
			local isWizoobsTongue = InutilLib.GetShowingActive(player) == RebekahCurse.COLLECTIBLE_WIZOOBTONGUE
			local isApostate = InutilLib.GetShowingActive(player) == RebekahCurse.COLLECTIBLE_APOSTATE
			local isPsalm45 = InutilLib.GetShowingActive(player) == RebekahCurse.COLLECTIBLE_PSALM45
			local isBarachielsPetal = InutilLib.GetShowingActive(player) == RebekahCurse.COLLECTIBLE_BARACHIELSPETAL
			local isFang = InutilLib.GetShowingActive(player) == RebekahCurse.COLLECTIBLE_FANG
			local isBeelzebubsBreath = InutilLib.GetShowingActive(player) == RebekahCurse.COLLECTIBLE_BEELZEBUBSBREATH
			local isMainLua = InutilLib.GetShowingActive(player) == RebekahCurse.COLLECTIBLE_MAINLUA
			--special beam thing
			--print(InutilLib.GetShowingActive(player))
			if playerdata.isReadyForSpecialAttack == false and (isLoveCannon or isWizoobsTongue or isApostate or isPsalm45 or isBarachielsPetal or isFang or isBeelzebubsBreath or isMainLua) and yandereWaifu.getReserveStocks(player) >= 1 then
				playerdata.isReadyForSpecialAttack = true;
				local arcane = Isaac.Spawn( EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_SPECIALBEAM, 0, player.Position, Vector(0,0), player );
				yandereWaifu.GetEntityData(arcane).parent = player
				InutilLib.SFX:Play( SoundEffect.SOUND_BLOOD_LASER , 1, 0, false, 1.2 );
				if yandereWaifu.GetEntityData(player).currentMode == REBECCA_MODE.SoulHearts then
					for i = 0, 6 do
						arcane:GetSprite():ReplaceSpritesheet(i, "gfx/effects/soul/special_beam.png")
					end
				elseif yandereWaifu.GetEntityData(player).currentMode == REBECCA_MODE.EvilHearts then
					for i = 0, 6 do
						arcane:GetSprite():ReplaceSpritesheet(i, "gfx/effects/evil/special_beam.png")
					end
				elseif yandereWaifu.GetEntityData(player).currentMode == REBECCA_MODE.EternalHearts then
					for i = 0, 6 do
						arcane:GetSprite():ReplaceSpritesheet(i, "gfx/effects/eternal/special_beam.png")
					end
				elseif yandereWaifu.GetEntityData(player).currentMode == REBECCA_MODE.GoldHearts then
					for i = 0, 6 do
						arcane:GetSprite():ReplaceSpritesheet(i, "gfx/effects/gold/special_beam.png")
					end
				elseif yandereWaifu.GetEntityData(player).currentMode == REBECCA_MODE.RottenHearts then
					for i = 0, 6 do
						arcane:GetSprite():ReplaceSpritesheet(i, "gfx/effects/rotten/special_beam.png")
					end
				elseif yandereWaifu.GetEntityData(player).currentMode == REBECCA_MODE.BrokenHearts then
					for i = 0, 6 do
						arcane:GetSprite():ReplaceSpritesheet(i, "gfx/effects/broken/special_beam.png")
					end
				end
				arcane:GetSprite():LoadGraphics()
			else
				local isLoveCannon = InutilLib.GetShowingActive(player) == RebekahCurse.COLLECTIBLE_LOVECANNON
				local isWizoobsTongue = InutilLib.GetShowingActive(player) == RebekahCurse.COLLECTIBLE_WIZOOBTONGUE
				local isApostate = InutilLib.GetShowingActive(player) == RebekahCurse.COLLECTIBLE_APOSTATE
				local isPsalm45 = InutilLib.GetShowingActive(player) == RebekahCurse.COLLECTIBLE_PSALM45
				local isBarachielsPetal = InutilLib.GetShowingActive(player) == RebekahCurse.COLLECTIBLE_BARACHIELSPETAL
				local isFang = InutilLib.GetShowingActive(player) == RebekahCurse.COLLECTIBLE_FANG
				local isBeelzebubsBreath = InutilLib.GetShowingActive(player) == RebekahCurse.COLLECTIBLE_BEELZEBUBSBREATH
				local isMainLua = InutilLib.GetShowingActive(player) == RebekahCurse.COLLECTIBLE_MAINLUA
				if playerdata.isReadyForSpecialAttack and not (isLoveCannon or isWizoobsTongue or isApostate or isPsalm45 or isBarachielsPetal or isFang or isBeelzebubsBreath or isMainLua) then
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
	for p = 0, ILIB.game:GetNumPlayers() - 1 do
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
	else
		modes = yandereWaifu.GetEntityData(player).currentMode
	end
	local function HasChargeCollectibles(player)
		if player:HasCollectible(CollectibleType.COLLECTIBLE_CHOCOLATE_MILK) or 
			player:HasCollectible(CollectibleType.COLLECTIBLE_CURSED_EYE) then
			return true
		else
			return false
		end
	end
		
	local function HasAutoCollectible(player)
		if player:HasCollectible(CollectibleType.COLLECTIBLE_ALMOND_MILK) or 
		player:HasCollectible(CollectibleType.COLLECTIBLE_SOY_MILK) then
			return true
		else
			return false
		end
	end
	
	if not data.BarrageIntro then
		data.BarrageIntro = false
	end
	
	local function EndBarrage()
		data.IsAttackActive = false
		data.chargeDelay = 0
		data.barrageInit = false
		if (not data.noHead and yandereWaifu.GetEntityData(player).currentMode == REBECCA_MODE.RottenHearts) or not (yandereWaifu.GetEntityData(player).currentMode == REBECCA_MODE.RottenHearts and yandereWaifu.GetEntityData(player).currentMode == REBECCA_MODE.BrokenHearts) then
			yandereWaifu.purchaseReserveStocks(player, 1)
		end
		--InutilLib.RefundActiveCharge(player, 1, true)
		
		--soul heart
		if yandereWaifu.GetEntityData(player).SoulBuff then
			yandereWaifu.GetEntityData(player).SoulBuff = false
			player:AddCacheFlags(CacheFlag.CACHE_DAMAGE);
			player:EvaluateItems()
			--become depressed again
			yandereWaifu.ApplyCostumes( yandereWaifu.GetEntityData(player).currentMode, player , false, false)
			player:RemoveCostume(Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_NUMBER_ONE))
			player:AddNullCostume(RebekahCurseCostumes.WizoobHairGoingDown)
			InutilLib.SetTimer( 10*3, function()
				player:TryRemoveNullCostume(RebekahCurseCostumes.WizoobHairGoingDown)
			end)
		end
		
		data.IsLokiHornsTriggered = nil
		
		yandereWaifu.RemoveRedGun(player)
		
		data.BarrageIntro = false
		
		if data.MainArcaneCircle then
			data.MainArcaneCircle:GetSprite():Play("FadeOut", true)
			data.MainArcaneCircle = nil
			data.ArcaneCircleDust:Remove()
		end
	end
	
	local function EndBarrageIfValid() --used if autocollectible is true and needed	
		if HasAutoCollectible(player) then
			data.chargeDelay = 0
			-- if out or stops holding
			if (yandereWaifu.getReserveStocks(player) <= 0) or ((player:GetShootingInput().X == 0 and player:GetShootingInput().Y == 0) ) then
				data.IsAttackActive = false
				data.chargeDelay = 0
				data.barrageInit = false
				
				data.IsLokiHornsTriggered = nil
				
				yandereWaifu.RemoveRedGun(player)
				
				data.BarrageIntro = false
				--print("a")
				--InutilLib.RefundActiveCharge(player, 1, true)
				if data.MainArcaneCircle then
					data.MainArcaneCircle:GetSprite():Play("FadeOut", true)
					data.MainArcaneCircle = nil
					data.ArcaneCircleDust:Remove()
				end
			else
				--yandereWaifu.addReserveFill(player, -20)
				--yandereWaifu.purchaseReserveStocks(player, 1)
				--print("b")
			end
			if (not data.noHead and yandereWaifu.GetEntityData(player).currentMode == REBECCA_MODE.RottenHearts) or not (yandereWaifu.GetEntityData(player).currentMode == REBECCA_MODE.RottenHearts and yandereWaifu.GetEntityData(player).currentMode == REBECCA_MODE.BrokenHearts) then
				yandereWaifu.purchaseReserveStocks(player, 1)
			end
		else
			--print("c")
			data.IsAttackActive = false
			data.chargeDelay = 0
			data.barrageInit = false
			if (not data.noHead and yandereWaifu.GetEntityData(player).currentMode == REBECCA_MODE.RottenHearts) or not (yandereWaifu.GetEntityData(player).currentMode == REBECCA_MODE.RottenHearts and yandereWaifu.GetEntityData(player).currentMode == REBECCA_MODE.BrokenHearts) then
				yandereWaifu.purchaseReserveStocks(player, 1)
			end
			
			data.IsLokiHornsTriggered = nil
			
			yandereWaifu.RemoveRedGun(player)
			data.BarrageIntro = false
			--InutilLib.RefundActiveCharge(player, 1, true)
			if data.MainArcaneCircle then
				data.MainArcaneCircle:GetSprite():Play("FadeOut", true)
				data.MainArcaneCircle = nil
				data.ArcaneCircleDust:Remove()
			end
		end
	end
	
	--charging code
	--chargeDelay is like FireDelay
	if not data.chargeDelay then data.chargeDelay = 0 end
	if not data.barrageInit then data.barrageInit = false end -- tells if the barrage has started
	
	
	--KIL FIX THIS PLEASE (HasCollectibleEffect)
	--local curAng -- marks the current angle for the spread tears! then we add here to make it move or something around those lines lol
	local numofShots = 1
	local tearSize = 0
		
	if player:HasCollectible(CollectibleType.COLLECTIBLE_MUTANT_SPIDER) then
		--curAng = -25
		numofShots = numofShots + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_MUTANT_SPIDER) * 3
	end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_20_20) then
		--curAng = -25
		numofShots = numofShots + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_20_20) 
	end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_INNER_EYE) then
		--curAng = -20
		numofShots = numofShots + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_INNER_EYE) * 2
	end

	if modes == REBECCA_MODE.RedHearts then
		
		if player:HasCollectible(CollectibleType.COLLECTIBLE_MARKED) then
			direction = player:GetAimDirection()
		end
		
		local modulusnum
		
		if player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_KNIFE) and player:HasCollectible(CollectibleType.COLLECTIBLE_LUDOVICO_TECHNIQUE) then
			modulusnum = math.ceil(player.MaxFireDelay/3)
		elseif player:HasCollectible(CollectibleType.COLLECTIBLE_C_SECTION) then
			modulusnum = math.ceil(player.MaxFireDelay/2)
		else
			modulusnum = math.ceil((player.MaxFireDelay/5))
		end
		if player:HasWeaponType(WeaponType.WEAPON_BRIMSTONE) then
			modulusnum = modulusnum - 2
		end
		
		local endFrameCount = 40
		
		if player:HasCollectible(CollectibleType.COLLECTIBLE_SPIRIT_SWORD) then
			endFrameCount = 120
		else
			endFrameCount = 40
		end
		
		if player:HasCollectible(CollectibleType.COLLECTIBLE_CAR_BATTERY) then
			endFrameCount = endFrameCount * (player:GetCollectibleNum(CollectibleType.COLLECTIBLE_CAR_BATTERY) * 2)
		end
		
		--print("weaponss"..modulusnum)
		local function IsValidRedBarrage()
			if data.BarrageIntro and data.redcountdownFrames >= 1 and data.redcountdownFrames < endFrameCount and data.redcountdownFrames % modulusnum == (0) then
				return true
			else 
				return false
			end
		end
		
		
		
		if not data.redcountdownFrames then data.redcountdownFrames = 0 end
		if not data.addedbarrageangle then data.addedbarrageangle = 0 data.addedbarrageangle2 = 0 end --incase if nil
		if not data.Xsize then data.Xsize = 0 end
	
		local angle = player.Velocity:GetAngleDegrees()

		
		--checks if you can shoot
		local canFire = true
		
		--this seems to make a stack overflow?
		if HasAutoCollectible(player) then
			if (player:GetShootingInput().X ~= 0 or player:GetShootingInput().Y ~= 0) then
				if data.chargeDelay < player.MaxFireDelay then
					data.chargeDelay = data.chargeDelay + 1
				end
			else
				--if data.redcountdownFrames >= 40 then
				--	print("pslc")
				--	EndBarrageIfValid()
				--end
			end
		end
		
		data.barrageNumofShots = numofShots --initial num of shots added in
		if HasChargeCollectibles(player) then
			if (player:GetShootingInput().X ~= 0 or player:GetShootingInput().Y ~= 0) and not data.barrageInit then
				if data.chargeDelay < player.MaxFireDelay * 1.3 then
					data.chargeDelay = data.chargeDelay + 0.1
					print(math.floor(data.chargeDelay*10) % 5)
					if math.floor(data.chargeDelay*10) % 5 == 0 then
						local charge = Isaac.Spawn( EntityType.ENTITY_EFFECT, EffectVariant.HEART, 0, player.Position, Vector(0,0), player );
						charge.SpriteOffset = Vector(0,-40)
						charge:GetSprite():ReplaceSpritesheet(0, "gfx/effects/red/chocolate_charge.png");
						charge:GetSprite():ReplaceSpritesheet(1, "gfx/effects/red/chocolate_charge.png");
						charge:GetSprite():LoadGraphics();
						InutilLib.SFX:Play( SoundEffect.SOUND_BATTERYCHARGE , 1, 0, false, data.chargeDelay/10);
						InutilLib.SFX:Play(RebekahCurseSounds.SOUND_REDCHARGEHEAVY, 1, 0, false, 0.5)
					end
				end
			end
			
			if not data.barrageInit then
				canFire = false
			end
			
			if player:GetShootingInput().X == 0 and player:GetShootingInput().Y == 0 then
				if player:HasCollectible(CollectibleType.COLLECTIBLE_CHOCOLATE_MILK) then
					local chargeFrameToPercent = (data.chargeDelay/player.MaxFireDelay)*2
					tearSize = math.floor(chargeFrameToPercent)
				end
				if player:HasCollectible(CollectibleType.COLLECTIBLE_CURSED_EYE) then
					local chargeFrameToPercent = (data.chargeDelay/player.MaxFireDelay)*5
					numofShots = numofShots + math.floor(chargeFrameToPercent)
				end
				canFire = true
				data.barrageNumofShots = numofShots --update to new because charged shots changes it
			end
		end
		
		--barrage angle modifications are here :3
		if data.redcountdownFrames % 2 then
			if data.redcountdownFrames == 0 then
				data.addedbarrageangle = 0
				data.addedbarrageangle2 = 0
			elseif data.redcountdownFrames > 1 and data.redcountdownFrames < 10 then
				data.addedbarrageangle = data.addedbarrageangle - 0.5
				data.addedbarrageangle2 = data.addedbarrageangle2 + 0.5
				data.Xsize = data.Xsize + 1
			elseif data.redcountdownFrames > 10 and data.redcountdownFrames < 20 then
				data.addedbarrageangle = data.addedbarrageangle + 1
				data.addedbarrageangle2 = data.addedbarrageangle2 - 1
				data.Xsize = data.Xsize + 2
			elseif data.redcountdownFrames > 20 and data.redcountdownFrames < 30 then
				data.addedbarrageangle = data.addedbarrageangle - 1
				data.addedbarrageangle2 = data.addedbarrageangle2 + 1
				data.Xsize = data.Xsize + 4
			elseif data.redcountdownFrames > 30 and data.redcountdownFrames < 40 then
				data.addedbarrageangle = data.addedbarrageangle + 2
				data.addedbarrageangle2 = data.addedbarrageangle2 - 2
				data.Xsize = data.Xsize + 6
			elseif data.redcountdownFrames >= 40 then
				if ((data.redcountdownFrames/10) % 1) == (0) then --reset for a bit
					data.addedbarrageangle = 0
					data.addedbarrageangle2 = 0
				end
				if (math.floor(data.redcountdownFrames/10) % 2) == 1 then
					data.addedbarrageangle = data.addedbarrageangle + 2
					data.addedbarrageangle2 = data.addedbarrageangle2 - 2
				elseif (math.floor(data.redcountdownFrames/10) % 2) == 0 then
					data.addedbarrageangle = data.addedbarrageangle - 2
					data.addedbarrageangle2 = data.addedbarrageangle2 + 2
				end
			else
				data.addedbarrageangle = 0
				data.addedbarrageangle2 = 0
				data.Xsize = 0
			end
		end
		
		
		--fixed angle code block
		if IsValidRedBarrage() then
			data.addedfixedbarrageangle = data.addedbarrageangle
			data.addedfixedbarrageangle2 = data.addedbarrageangle2
		end
		
		if canFire == true then
			if not data.isPlayingCustomAnim and data.BarrageIntro then --only add frames if custom anim is not occuring
				data.redcountdownFrames = data.redcountdownFrames + 1
			end
			
			if data.IsLokiHornsTriggered == nil and not data.BarrageIntro then
				if player:HasCollectible(CollectibleType.COLLECTIBLE_LOKIS_HORNS) and math.random(0,10) + player.Luck >= 10 then
					data.IsLokiHornsTriggered = true
				else
					data.IsLokiHornsTriggered = false
				end
			end
			
			if data.redcountdownFrames == 0 then	
			
			end
			
			if data.redcountdownFrames >= endFrameCount then
				--moms wig synergy
				if player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_WIG) then
					local numLimit = 5
					for i = 1, numLimit do
						player.Velocity = player.Velocity * 0.8 --slow him down

						InutilLib.SetTimer( i+5, function()
							local trite = Isaac.Spawn(EntityType.ENTITY_HOPPER, 1, 0, player.Position,  Vector.FromAngle(direction:GetAngleDegrees())*(math.random(3,6)), player)
							trite:AddEntityFlags(EntityFlag.FLAG_FRIENDLY)
							trite:AddEntityFlags(EntityFlag.FLAG_CHARM)
							trite:AddEntityFlags(EntityFlag.FLAG_APPEAR)
							trite:AddEntityFlags(EntityFlag.FLAG_PERSISTENT)
							yandereWaifu.GetEntityData(trite).CharmedToParent = player
							trite.CollisionDamage = player.Damage * 2
						end);
					end
				end
				--lead pencil synergy
				if player:HasCollectible(CollectibleType.COLLECTIBLE_LEAD_PENCIL) then
					local numLimit = 9
					for i = 1, numLimit do
						
						InutilLib.SetTimer( i * 15, function()
							local chosenNumofBarrage = 4

							for i = 1, chosenNumofBarrage do
								local tear = player:FireTear(player.Position, Vector.FromAngle(direction:GetAngleDegrees() - math.random(-10,10))*(math.random(7,12)), false, false, false):ToTear()
								tear.Position = player.Position
								if tear.Variant == 0 then tear:ChangeVariant(TearVariant.BLOOD) end
								tear.Scale = math.random(07,14)/10
								tear.Scale = tear.Scale + tearSize
								tear.FallingSpeed = -10 + math.random(1,3)
								tear.FallingAcceleration = 0.5
								tear.CollisionDamage = player.Damage * 3.5
								--tear.BaseDamage = player.Damage * 2
							end
						end)
					end
				end
								
				--revelation synergy
				if player:HasCollectible(CollectibleType.COLLECTIBLE_REVELATION) then
					local angle = direction:GetAngleDegrees()
					local beam = EntityLaser.ShootAngle(5, player.Position, angle, 10, Vector(0,10), player):ToLaser()
					for i = -15, 15, 30 do
						local beam = EntityLaser.ShootAngle(5, player.Position, angle + i, 10, Vector(0,10), player):ToLaser();
						beam.MaxDistance = 500
					end
					for i = -30, 30, 60 do
						local beam = EntityLaser.ShootAngle(5, player.Position, angle + i, 10, Vector(0,10), player):ToLaser()
						beam.MaxDistance = 250
					end
				end
								
				--montezuma's revenge synergy

				if player:HasCollectible(CollectibleType.COLLECTIBLE_MONTEZUMAS_REVENGE) then
					local angle = direction:GetAngleDegrees()
					local beam = EntityLaser.ShootAngle(12, player.Position, angle + 180, 30, Vector(0,0), player):ToLaser()
					beam.MaxDistance = 250
					--InutilLib.UpdateLaserSize(beam, 2)
					data.shiftyBeam = beam
				end
			end
			--setup of red personality's gun effects and barrage
			if not data.MainArcaneCircle then
				data.MainArcaneCircle = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_ARCANE_CIRCLE, 0, player.Position,  Vector.Zero, nil)
				yandereWaifu.GetEntityData(data.MainArcaneCircle).parent = player
				data.ArcaneCircleDust = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_REBEKAH_DUST, 4, player.Position, Vector.Zero, player)
				data.ArcaneCircleDust.RenderZOffset = -1
				yandereWaifu.GetEntityData(data.ArcaneCircleDust).Parent = player --why this parent and Parent isnt consistent is beyond me and im too lazy to fix it
			end
				
			local ludoTear
			if player:HasCollectible(CollectibleType.COLLECTIBLE_LUDOVICO_TECHNIQUE) and not player:HasWeaponType(WeaponType.WEAPON_BOMBS) and not player:HasWeaponType(WeaponType.WEAPON_TECH_X) then
				ludoTear = InutilLib.GetPlayerLudo(player)
				
				if data.BarrageIntro then
							
					if IsValidRedBarrage() then
						if ludoTear then
							--if not data.KnifeHelper then data.KnifeHelper = InutilLib:SpawnKnifeHelper(ludoTear, player) else
							--	if not data.KnifeHelper.incubus:Exists() then
							--		data.KnifeHelper = InutilLib:SpawnKnifeHelper(ludoTear, player)
							--	end
							--end
							mainLudoSpawned = false -- sets if the main tear pointer has spawned
							for i = 0, 270, 360/4 do
								--knife sucks
								if player:HasWeaponType(WeaponType.WEAPON_KNIFE) then
									ludoTear.Velocity = ludoTear.Velocity * 0.7
									local kn = ILIB.game:Spawn(EntityType.ENTITY_TEAR, 0, ludoTear.Position, Vector.FromAngle(i + data.addedbarrageangle + direction:GetAngleDegrees()):Resized(20), player, 0, 0):ToTear()
									kn.TearFlags = kn.TearFlags | TearFlags.TEAR_PIERCING;
									kn.CollisionDamage = player.Damage * numofShots;
									kn:ChangeVariant(RebekahCurse.ENTITY_REDKNIFE);
									if not mainLudoSpawned then
										mainLudoSpawned = true
										kn.Scale = kn.Scale + .2
										kn.CollisionDamage = kn.CollisionDamage * 1.5
									end
									--this makes so much bugs
									--data.KnifeHelper.incubus.Position = ludoTear.Position
									--InutilLib.SpawnKnife(player, (i + data.addedbarrageangle + direction:GetAngleDegrees()), false, 0, SchoolbagKnifeMode.FIRE_ONCE, 1, 300, data.KnifeHelper)
								elseif player:HasWeaponType(WeaponType.WEAPON_BRIMSTONE) then
									--local brim = player:FireBrimstone( Vector.FromAngle( i + direction:GetAngleDegrees() - 45 ):Resized( REBEKAH_BALANCE.RED_HEART_ATTACK_BRIMSTONE_SIZE ) ):ToLaser();
									local brim = EntityLaser.ShootAngle(1, ludoTear.Position, i + direction:GetAngleDegrees() - 45, 5, Vector(0,-5), player):ToLaser()
									brim:SetActiveRotation( 0, 135, 10, false );
									brim:AddTearFlags(player.TearFlags)
									brim:SetColor(ludoTear:GetColor(), 999, 999)
									brim.DisableFollowParent = true
									brim.CollisionDamage = player.Damage * numofShots;
									--brim.Position = ludoTear.Position
									--local brim2 = player:FireBrimstone( Vector.FromAngle( i + direction:GetAngleDegrees() + 45 ):Resized( REBEKAH_BALANCE.RED_HEART_ATTACK_BRIMSTONE_SIZE ) ):ToLaser();
									local brim2 = EntityLaser.ShootAngle(1, ludoTear.Position, i + direction:GetAngleDegrees() + 45, 5, Vector(0,-5), player):ToLaser()
									brim2:SetActiveRotation( 0, -135, -10, false );
									brim2:AddTearFlags(player.TearFlags)
									brim2:SetColor(ludoTear:GetColor(), 999, 999)
									brim2.DisableFollowParent = true
									brim2.CollisionDamage = player.Damage * numofShots;
									if not mainLudoSpawned then
										mainLudoSpawned = true
										InutilLib.UpdateLaserSize(brim, 6 * (tearSize + .2))
										brim.CollisionDamage = brim.CollisionDamage * 1.5
										InutilLib.UpdateLaserSize(brim2, 6 * (tearSize + .2))
										brim2.CollisionDamage = brim2.CollisionDamage * 1.5
									end
									--brim2.Position = ludoTear.Position
								elseif player:HasWeaponType(WeaponType.WEAPON_LASER) then
									local randomAngleperLaser = math.random(-15,15) --used to be 45, but now the synergy feels so boring
									--print("fire")
									local techlaser = player:FireTechLaser(ludoTear.Position, 0, Vector.FromAngle(i + direction:GetAngleDegrees() + randomAngleperLaser), false, true)
									techlaser.DisableFollowParent = true
									techlaser.OneHit = true;
									techlaser.Timeout = 1;
									techlaser.CollisionDamage = player.Damage * numofShots;
									techlaser:SetHomingType(1)
									InutilLib.UpdateLaserSize(techlaser, 6 * tearSize)
									if not mainLudoSpawned then
										mainLudoSpawned = true
										InutilLib.UpdateLaserSize(techlaser, 6 * (tearSize + .2))
										techlaser.CollisionDamage = techlaser.CollisionDamage * 1.5
									end
								else
									--local num = 1
									--for j = 0, 90, 90/numofShots do
										--print(num)
										--num = num + 1
										--local fix
										--if numofShots > 1 then fix = 1 else fix = 0 end
										local tears = player:FireTear(ludoTear.Position, Vector.FromAngle(--[[i + (j - 45)*fix +]] (i + data.addedbarrageangle + direction:GetAngleDegrees()))*(10), false, false, false):ToTear()
										tears.Position = ludoTear.Position
										tears.Scale = tears.Scale + tearSize
										tears.CollisionDamage = player.Damage * numofShots
										if not mainLudoSpawned then
											mainLudoSpawned = true
											tears.Scale = tears.Scale + .2
											tears.CollisionDamage = tears.CollisionDamage * 1.5
										end
										if player:HasCollectible(CollectibleType.COLLECTIBLE_GHOST_PEPPER) and math.random(1,14) + player.Luck >= 14 then
											local tears2 = player:FireTear(ludoTear.Position, Vector.FromAngle(--[[i + (j - 45)*fix +]] (i + data.addedbarrageangle + direction:GetAngleDegrees()))*(10), false, false, false):ToTear()
											tears2.CollisionDamage = player.Damage * 0.8
											tears2:ChangeVariant(TearVariant.FIRE)
											tears2.Scale = 1.5
										end
										if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRDS_EYE) and math.random(1,14) + player.Luck >= 14 then
											local fire = Isaac.Spawn(EntityType.ENTITY_EFFECT, 51, 0, ludoTear.Position, Vector.FromAngle(--[[i + (j - 45)*fix +]] (i + data.addedbarrageangle + direction:GetAngleDegrees()))*(14), player):ToEffect()
											fire.Scale = tears.Scale
											fire:GetSprite().Scale = Vector(tears.Scale,tears.Scale)
										end
									--end
								end
							end
						end
						if player.MaxFireDelay <= 5 and player.MaxFireDelay > 1 then
							if ludoTear then
								for i = 0, 360, 360/3 do
									local tears = player:FireTear(ludoTear.Position, Vector.FromAngle(i + data.addedbarrageangle2 + direction:GetAngleDegrees())*(10), false, false, false):ToTear()
									tears.Position = ludoTear.Position
									tears.Scale = tears.Scale + tearSize
								end
							end
						end
					elseif data.redcountdownFrames >= endFrameCount then
						EndBarrageIfValid()
					end
				else
					if data.redcountdownFrames == 0 and not data.isPlayingCustomAnim then
						local customBody = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_EXTRACHARANIMHELPER, 0, player.Position, Vector(0,0), nil) --body effect
						yandereWaifu.GetEntityData(customBody).Player = player
						yandereWaifu.GetEntityData(customBody).RedIsShootingHigh = true
						yandereWaifu.GetEntityData(customBody).RedLudo = true
						data.isPlayingCustomAnim = true
					end
					if not data.canModifyGuns then data.canModifyGuns = true end
				end
				
				local canModifyGunsLudo = player:HasCollectible(CollectibleType.COLLECTIBLE_LUDOVICO_TECHNIQUE) and data.canModifyGuns
				if canModifyGunsLudo then
					local gunIdle = true
					if not data.FinishedPlayingCustomAnim then
						gunIdle = false
					end

					if gunIdle then
						--player:GetEffects():RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_PAUSE, -1)
						for k, v in pairs (Isaac.GetRoomEntities()) do
							v:ClearEntityFlags(EntityFlag.FLAG_SLOW)
						end
						data.tintEffect:Remove()
						data.tintEffect = nil
						yandereWaifu.RebekahCanShoot(player, true)
						player.FireDelay = 60
						data.canModifyGuns = nil
						data.FinishedPlayingCustomAnim = nil
					else
						if not data.tintEffect then
							data.tintEffect = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_BACKGROUNDTINT, 0, player.Position, Vector.Zero, nil):ToEffect()
							data.tintEffect.RenderZOffset = -10
							yandereWaifu.RebekahCanShoot(player, false)
						end
						for k, v in pairs (Isaac.GetRoomEntities()) do
							if v.Type ~= 1000 and v.Type ~= 1 and v.Type ~= 8 then
								v:AddEntityFlags(EntityFlag.FLAG_SLOW)
							end
						end
						if player.FrameCount % 3 == 0 then
							yandereWaifu.SpawnHeartParticles( 1, 2, player.Position, yandereWaifu.RandomHeartParticleVelocity(), player, RebekahHeartParticleType.Red );
						end
						--we need to freeze the player
						--player.Position = player.Position
						--player.Velocity = Vector.Zero
						player.FireDelay = 60
					end
				end
			else
				local gunCount = 0 
				if not player:HasWeaponType(WeaponType.WEAPON_ROCKETS) then --epic fetus has 
					if not data.extraHugsRed then --for her neutral special, she weilds a gun
						for lhorns = 0, 270, 360/4 do
							direction = Vector.FromAngle(direction:GetAngleDegrees() + lhorns) --lokis horns offset
							local oldDir = direction
							for wizAng = -45, 90, 135 do
								if player:HasCollectible(CollectibleType.COLLECTIBLE_THE_WIZ) and lhorns == 0 then --sets the wiz angles
									direction = Vector.FromAngle(direction:GetAngleDegrees() + wizAng)
								end
								
								for j = 0, numofShots do -- 90, 90/numofShots do
									--InutilLib.SetTimer( j * 3, function()
										local fix = 0
										local baseOffset = 7 * (numofShots) --offset set depending on how much multishots are there
										if numofShots > 1 then fix = 1 else fix = 0 end
										if j > 0 then --idk what this is
			
											local gun = yandereWaifu.SpawnRedGun(player, Vector.FromAngle((-7 + (15*j))*fix + (data.addedbarrageangle + direction:GetAngleDegrees()) - baseOffset*fix )*(20), true)
											yandereWaifu.GetEntityData(gun).StartCountFrame = gunCount
											
											gunCount = gunCount + 1
										end
									--end)
								end
					
								if wizAng == -45 and not player:HasCollectible(CollectibleType.COLLECTIBLE_THE_WIZ) then
									break -- just makes sure it doesnt duplicate
								end
							end
							direction = oldDir
							if not data.IsLokiHornsTriggered then 
								break
							end --break if not loki horns is triggered
						end	
						if not data.canModifyGuns then data.canModifyGuns = true end
						--if not data.gunFrameCount then data.gunFrameCount = player.FrameCount + (gunCount)*5 end
					end
				else
					if not data.canModifyGuns then data.canModifyGuns = true end
				end

				for lhorns = 0, 270, 360/4 do
					direction = Vector.FromAngle(direction:GetAngleDegrees() + lhorns) --lokis horns offset
					local oldDir = direction

					for wizAng = -45, 90, 135 do
						if player:HasCollectible(CollectibleType.COLLECTIBLE_THE_WIZ) and lhorns == 0 then --sets the wiz angles
							direction = Vector.FromAngle(direction:GetAngleDegrees() + wizAng)
						end
						--print(direction:GetAngleDegrees())
						--print("i feel dazed")
						--eye sore synergy
						if data.redcountdownFrames == 1 then
							if player:HasCollectible(CollectibleType.COLLECTIBLE_EYE_SORE) then
								if math.random(1,3) == 3 then
									data.willEyeSoreBar = true
									data.eyeSoreBarAngles = {
										[1] = math.random(0,360),
										[2] = math.random(0,360)
									}
								else
									data.willEyeSoreBar = false
									data.eyeSoreBarAngles = nil
								end
							end
						end
						
						--epiphora synergy
						if data.redcountdownFrames == 5 or data.redcountdownFrames == 10 or data.redcountdownFrames == 20 or data.redcountdownFrames == 30 or data.redcountdownFrames == 15 or data.redcountdownFrames == 25 or data.redcountdownFrames == 35 then
							if player:HasCollectible(CollectibleType.COLLECTIBLE_EPIPHORA) then
								--incase
								if not yandereWaifu.GetEntityData(player).EpiphoraBuff then yandereWaifu.GetEntityData(player).EpiphoraBuff = 0 end
								yandereWaifu.GetEntityData(player).EpiphoraBuff = yandereWaifu.GetEntityData(player).EpiphoraBuff + 1
								player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY);
								player:EvaluateItems()
							end
						elseif data.redcountdownFrames == 40 then
							if player:HasCollectible(CollectibleType.COLLECTIBLE_EPIPHORA) then
								yandereWaifu.GetEntityData(player).EpiphoraBuff = 0
								player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY);
								player:EvaluateItems()
							end
						end
						data.barrageInit = true
						if player:HasWeaponType(WeaponType.WEAPON_ROCKETS) then --rocket synergy
							if data.BarrageIntro then
								local target = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_ORBITALTARGET, 0, player.Position,  Vector.FromAngle(direction:GetAngleDegrees())*(120), nil)
								yandereWaifu.GetEntityData(target).Parent = player
								EndBarrageIfValid()
							elseif data.redcountdownFrames == 0 and not data.isPlayingCustomAnim then
								local customBody = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_EXTRACHARANIMHELPER, 0, player.Position, Vector(0,0), nil) --body effect
								yandereWaifu.GetEntityData(customBody).Player = player
								yandereWaifu.GetEntityData(customBody).RedIsShootingHigh = true
								data.isPlayingCustomAnim = true
							end
						elseif player:HasWeaponType(WeaponType.WEAPON_SPIRIT_SWORD) then --slashing time! sword effect 
							if data.redcountdownFrames == 1 and not data.isPlayingCustomAnim then --too lazy to set data.isPlayingCustomAnim to every condition, might have to one day
								if player:HasCollectible(CollectibleType.COLLECTIBLE_TECHNOLOGY) then
									local customBody = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_EXTRACHARANIMHELPER, 0, player.Position, Vector(0,0), nil) --body effect
									yandereWaifu.GetEntityData(customBody).Player = player
									yandereWaifu.GetEntityData(customBody).IsGreivous = true
									yandereWaifu.GetEntityData(customBody).PermanentAngle = direction
									yandereWaifu.GetEntityData(customBody).MultiTears = numofShots
									yandereWaifu.GetEntityData(customBody).TearDelay = modulusnum
									data.isPlayingCustomAnim = true
								else
									local cut = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_SLASH, 0, player.Position--[[+Vector.FromAngle(direction:GetAngleDegrees()):Resized(40)]], Vector(0,0), player);
									yandereWaifu.GetEntityData(cut).PermanentAngle = direction
									yandereWaifu.GetEntityData(cut).MultiTears = numofShots
									yandereWaifu.GetEntityData(cut).TearDelay = modulusnum
								end
								player.ControlsEnabled = false;
							elseif data.redcountdownFrames >= 1 and data.redcountdownFrames < endFrameCount and data.redcountdownFrames % modulusnum == (0) then
								--player.Velocity = ( player.Velocity * 0.2 ) + Vector.FromAngle( direction:GetAngleDegrees() );
								InutilLib.SFX:Play( SoundEffect.SOUND_SWORD_SPIN, 1, 0, false, 1.5 );
							elseif data.redcountdownFrames == endFrameCount then
								data.IsAttackActive = false;
								player.ControlsEnabled = true;
								EndBarrageIfValid()
							end
						
						elseif player:HasWeaponType(WeaponType.WEAPON_BOMBS) or player:HasWeaponType(WeaponType.WEAPON_BRIMSTONE) then --if bombs
							if player:HasWeaponType(WeaponType.WEAPON_BOMBS) then
								if data.redcountdownFrames == 1 then
									local num = 1
									yandereWaifu.PlayAllRedGuns(player, 3)
									for j = 0, numofShots do
										--print(num)
										InutilLib.SetTimer( 30, function() --predicting this shoots at the same time dr fetus comes out because i dont wanna code a queue system
											num = num + 1
											local fix
											local baseOffset = 7 * (numofShots)
											if numofShots > 1 then fix = 1 else fix = 0 end
											if (j == 0 and numofShots <= 1) or (j > 0 and numofShots > 1) then --tells if you need to shoot once if you have 1 numofShots or if more than 1 numofShots, no need for shoot once correction
												local bomb = player:FireBomb(player.Position, Vector.FromAngle((-7 + (15*j))*fix + (data.addedbarrageangle + direction:GetAngleDegrees()) - baseOffset*fix )*(10))
												--local bomb = Isaac.Spawn(EntityType.ENTITY_BOMBDROP, 0, 0, player.Position,  Vector.FromAngle(direction:GetAngleDegrees()):Resized( 9 ), player);
												yandereWaifu.GetEntityData(bomb).IsByAFanGirl = true; --makes sure that it's Rebecca's bombs
												bomb:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
												InutilLib.SFX:Play(RebekahCurseSounds.SOUND_REDFETUS1, 1, 0, false, 1)
												player.Velocity = player.Velocity + (Vector.FromAngle((-7 + (15*j))*fix + (direction:GetAngleDegrees()) - baseOffset*fix + 180)*(12))*0.7
											end
										end)
									end
									if player:HasCollectible(CollectibleType.COLLECTIBLE_EYE_SORE) and data.willEyeSoreBar then
										for i, angle in pairs(data.eyeSoreBarAngles) do
											local bomb = player:FireBomb(player.Position, Vector.FromAngle(angle + direction:GetAngleDegrees())*(8))
											yandereWaifu.GetEntityData(bomb).IsByAFanGirl = true; --makes sure that it's Rebecca's bombs
											bomb:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
										end
									end
								elseif data.redcountdownFrames >= endFrameCount then
									EndBarrageIfValid()
								end
							--bomb.RadiusMultiplier = 3
							end
							if player:HasWeaponType(WeaponType.WEAPON_BRIMSTONE) then
								if IsValidRedBarrage() then
									local brim = player:FireBrimstone( Vector.FromAngle( direction:GetAngleDegrees() - 45 ):Resized( REBEKAH_BALANCE.RED_HEART_ATTACK_BRIMSTONE_SIZE ) ):ToLaser();
									brim:SetActiveRotation( 0, 135, 10, false );
									brim.Position = player.Position
									brim:AddTearFlags(player.TearFlags)
									--brim:SetColor(player.TearColor, 999, 999)
									brim.CollisionDamage = player.Damage * numofShots;
									--InutilLib.UpdateLaserSize(brim, 1)
									local brim2 = player:FireBrimstone( Vector.FromAngle( direction:GetAngleDegrees() + 45 ):Resized( REBEKAH_BALANCE.RED_HEART_ATTACK_BRIMSTONE_SIZE ) ):ToLaser();
									brim2:SetActiveRotation( 0, -135, -10, false );
									brim2.Position = player.Position
									brim2:AddTearFlags(player.TearFlags)
									--brim2:SetColor(player.TearColor 999, 999)
									brim2.CollisionDamage = player.Damage * numofShots;
									--InutilLib.UpdateLaserSize(brim2, 1)
									
									if player:HasCollectible(CollectibleType.COLLECTIBLE_EYE_SORE) and data.willEyeSoreBar then
										for i, angle in pairs(data.eyeSoreBarAngles) do
											local brim = player:FireBrimstone( Vector.FromAngle( angle - 45 ):Resized( REBEKAH_BALANCE.RED_HEART_ATTACK_BRIMSTONE_SIZE ) ):ToLaser();
											brim:SetActiveRotation( 0, 135, 10, false );
											--InutilLib.UpdateLaserSize(brim, tearSize)
											local brim2 = player:FireBrimstone( Vector.FromAngle( angle + 45 ):Resized( REBEKAH_BALANCE.RED_HEART_ATTACK_BRIMSTONE_SIZE ) ):ToLaser();
											brim2:SetActiveRotation( 0, -135, -10, false );
											--InutilLib.UpdateLaserSize(brim2, tearSize)
										end
									end
									player.Velocity = player.Velocity + (Vector.FromAngle( angle - 180 ):Resized( 2 ))*0.7
									yandereWaifu.PlayAllRedGuns(player, 5)
								elseif data.redcountdownFrames >= endFrameCount then
									local num = 1
									for j = 0, numofShots do
										num = num + 1
										local fix
										local baseOffset = 7 * (numofShots)
										if numofShots > 1 then fix = 1 else fix = 0 end
										if (j == 0 and numofShots <= 1) or (j > 0 and numofShots > 1) then --tells if you need to shoot once if you have 1 numofShots or if more than 1 numofShots, no need for shoot once correction
											local brim = player:FireBrimstone( Vector.FromAngle((-7 + (15*j))*fix + (direction:GetAngleDegrees()) - baseOffset*fix ):Resized( REBEKAH_BALANCE.RED_HEART_ATTACK_BRIMSTONE_SIZE ) ):ToLaser();
											--InutilLib.UpdateLaserSize(brim, 2)
											brim.Timeout = 30
										end
										player.Velocity = player.Velocity + (Vector.FromAngle((-7 + (15*j))*fix + (direction:GetAngleDegrees()) - baseOffset*fix + 180)*(1))*0.7
									end
									EndBarrageIfValid()
								end
							end
						elseif player:HasWeaponType(WeaponType.WEAPON_LASER) then --tech barrage
							if IsValidRedBarrage() then
								--for i = 0, 360-360/8, 360/8 do
								for i = 1, 3 do
									local randomAngleperLaser = math.random(-15,15) --used to be 45, but now the synergy feels so boring
									local techlaser = player:FireTechLaser(player.Position, 6, Vector.FromAngle(direction:GetAngleDegrees() + randomAngleperLaser), false, true)
									techlaser.OneHit = true;
									techlaser.Timeout = 1;
									techlaser.CollisionDamage = player.Damage * 2;
									techlaser:SetHomingType(1)
									InutilLib.UpdateLaserSize(techlaser, 6 * (1+ tearSize))
									techlaser.DisableFollowParent = true
								end
								player.Velocity = player.Velocity + (Vector.FromAngle( direction:GetAngleDegrees() + 180)*(1))*0.7
									--techlaser.Damage = player.Damage * 5 doesn't exist lol
								--end
								if player:HasCollectible(CollectibleType.COLLECTIBLE_EYE_SORE) and data.willEyeSoreBar then
									for i, angle in pairs(data.eyeSoreBarAngles) do
										local randomAngleperLaser = math.random(-15,15) --used to be 45, but now the synergy feels so boring
										local techlaser = player:FireTechLaser(player.Position, 0,  Vector.FromAngle(angle + (data.addedbarrageangle))*(20), false, true)
										techlaser.OneHit = true;
										techlaser.Timeout = 1;
										techlaser.CollisionDamage = player.Damage * 2;
										techlaser:SetHomingType(1)
										InutilLib.UpdateLaserSize(techlaser, 6 * (1+ tearSize))
									end
								end
								--for i = 1, 3, 1 do
								--	local techlaser = player:FireTechLaser(player.Position, 0, Vector.FromAngle(direction:GetAngleDegrees() + randomAngleperLaser), false, true)
								--	local techlaser2 = player:FireTechLaser(player.Position, 0, Vector.FromAngle(direction:GetAngleDegrees() + -randomAngleperLaser), false, true)
								--end
								yandereWaifu.PlayAllRedGuns(player, 4)
							elseif data.redcountdownFrames >= endFrameCount then
								EndBarrageIfValid()
							end
						else --if just plain old tears
							
							if data.redcountdownFrames == 0 then
			
							elseif IsValidRedBarrage() then
								player.Velocity = player.Velocity * 0.8 --slow him down
								
								if player:HasWeaponType(WeaponType.WEAPON_KNIFE) then
									--local knife = player:FireKnife(player, (data.addedbarrageangle + direction:GetAngleDegrees()), false):ToKnife()
									--knife:Shoot(3,300)
									local num = 1
									for j = 0, numofShots do
										
										num = num + 1
										local fix
										local baseOffset = 7 * (numofShots)
										if numofShots > 1 then fix = 1 else fix = 0 end
										if (j == 0 and numofShots <= 1) or (j > 0 and numofShots > 1) then --tells if you need to shoot once if you have 1 numofShots or if more than 1 numofShots, no need for shoot once correction
											local kn = player:FireTear(player.Position, Vector.FromAngle((-7 + (15*j))*fix + (data.addedbarrageangle + direction:GetAngleDegrees()) - baseOffset*fix )*(20), false, false, false):ToTear()
											kn.Position = player.Position
											kn.Scale = kn.Scale + tearSize
											kn.CollisionDamage = kn.CollisionDamage * 1.2
											kn.TearFlags = kn.TearFlags | TearFlags.TEAR_PIERCING;
											kn.CollisionDamage = player.Damage * 2;
											kn:ChangeVariant(RebekahCurse.ENTITY_REDKNIFE)
										end
									end
									--local knife = InutilLib.SpawnKnife(player, (data.addedbarrageangle + direction:GetAngleDegrees()), false, 0, SchoolbagKnifeMode.FIRE_OUT_ONLY, 1, 120)
									--yandereWaifu.GetEntityData(knife).IsRed = true
								elseif player:HasWeaponType(WeaponType.WEAPON_TECH_X) then
									local circle = player:FireTechXLaser(player.Position, Vector.FromAngle(data.addedbarrageangle + direction:GetAngleDegrees())*(20), data.Xsize)
									--eye sore synergy
									if player:HasCollectible(CollectibleType.COLLECTIBLE_EYE_SORE) and data.willEyeSoreBar then
										for i, angle in pairs(data.eyeSoreBarAngles) do
											local tears = player:FireTechXLaser(player.Position, Vector.FromAngle(angle + (data.addedbarrageangle))*(20), data.Xsize)
											tears.Position = player.Position
											tears.Size = tears.Size + tearSize
											tears.CollisionDamage = tears.CollisionDamage * 1.2
										end
									end
									yandereWaifu.PlayAllRedGuns(player, 4)
								else
									--tear particle effect thing
									local isBlood = false
									local num = 1
									for j = 0, numofShots do
										num = num + 1
										local fix
										local baseOffset = 7 * (numofShots)
										local isFetus = 0
										if player:HasCollectible(CollectibleType.COLLECTIBLE_C_SECTION) then
											isFetus = 18
										end
										if numofShots > 1 then fix = 1 else fix = 0 end
										if (j == 0 and numofShots <= 1) or (j > 0 and numofShots > 1) then --tells if you need to shoot once if you have 1 numofShots or if more than 1 numofShots, no need for shoot once correction
											local tears = player:FireTear(player.Position, Vector.FromAngle((-7 + (15*j))*fix + (data.addedbarrageangle + direction:GetAngleDegrees()) - baseOffset*fix )*(20-isFetus), false, false, false):ToTear()
											tears.Position = player.Position
											tears.Scale = tears.Scale + tearSize
											tears.CollisionDamage = tears.CollisionDamage * 1.2
											if tears.Variant == 1 then isBlood = true end
											player.Velocity = player.Velocity + (Vector.FromAngle((-7 + (15*j))*fix + (data.addedbarrageangle + direction:GetAngleDegrees()) - baseOffset*fix + 180)*(1))*0.7
											if player:HasCollectible(CollectibleType.COLLECTIBLE_C_SECTION) then
												tears:ChangeVariant(50)
												tears.TearFlags = tears.TearFlags | TearFlags.TEAR_PIERCING | TearFlags.TEAR_SPECTRAL
												if math.random(1,3) == 3 then
													yandereWaifu.GetEntityData(tears).IsEsauFetus = true
												else
													yandereWaifu.GetEntityData(tears).IsJacobFetus = true
												end
											end
											if player:HasCollectible(CollectibleType.COLLECTIBLE_GHOST_PEPPER) and math.random(1,14) + player.Luck >= 14 then
												local tears2 = player:FireTear(player.Position, Vector.FromAngle((-7 + (15*j))*fix + (data.addedbarrageangle + direction:GetAngleDegrees()) - baseOffset*fix )*(20-isFetus), false, false, false):ToTear()
												tears2.CollisionDamage = player.Damage * 0.8
												tears2:ChangeVariant(TearVariant.FIRE)
												tears2.Scale = 1.5
											end
											if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRDS_EYE) and math.random(1,14) + player.Luck >= 14 then
												local fire = Isaac.Spawn(EntityType.ENTITY_EFFECT, 51, 0, player.Position, Vector.FromAngle((-7 + (15*j))*fix + (data.addedbarrageangle + direction:GetAngleDegrees()) - baseOffset*fix )*(20-isFetus), player):ToEffect()
												fire.Scale = tears.Scale
												fire:GetSprite().Scale = Vector(tears.Scale,tears.Scale)
											end
										end
									end
									--eye drop synergy
									if player:HasCollectible(CollectibleType.COLLECTIBLE_EYE_DROPS)  and math.random(1,3) == 1 then
										local tears = player:FireTear(player.Position, Vector.FromAngle( math.random(-10,10)+ (data.addedbarrageangle + direction:GetAngleDegrees()))*(20), false, false, false):ToTear()
										tears.Position = player.Position
										tears.Scale = tears.Scale + tearSize
										tears.CollisionDamage = tears.CollisionDamage * 1.2
										if tears.Variant == 1 then isBlood = true end
									end
									--eye sore synergy
									if player:HasCollectible(CollectibleType.COLLECTIBLE_EYE_SORE) and data.willEyeSoreBar then
										for i, angle in pairs(data.eyeSoreBarAngles) do
											local tears = player:FireTear(player.Position, Vector.FromAngle(angle + (data.addedbarrageangle))*(20), false, false, false):ToTear()
											tears.Position = player.Position
											tears.Scale = tears.Scale + tearSize
											tears.CollisionDamage = tears.CollisionDamage * 1.2
											if tears.Variant == 1 then isBlood = true end
										end
									end
									--[[local poofVar = 13
									if isBlood then poofVar = 11 end
									if player then
										local splat = Isaac.Spawn(EntityType.ENTITY_EFFECT, poofVar, 1, player.Position + Vector.FromAngle((Vector(0,100)):GetAngleDegrees() + 90), Vector(0,0), player)
										--splat.RenderZOffset = 10000
										if math.random(1,2)== 2 then splat:GetSprite().FlipX = true end
										if math.random(1,2)== 2 then splat:GetSprite().FlipY = true end
									end]]
									local mode = 0
									if player.MaxFireDelay <= 1 then
										mode = 1
									elseif player:HasCollectible(CollectibleType.COLLECTIBLE_IPECAC) or player:HasCollectible(CollectibleType.COLLECTIBLE_POLYPHEMUS) then
										mode = 2
									end
									yandereWaifu.PlayAllRedGuns(player, mode)
								end
								InutilLib.SFX:Play(SoundEffect.SOUND_TEARS_FIRE, 1, 0, false, 1.2)
								if player.MaxFireDelay <= 5 and player.MaxFireDelay > 1 then
									local isFetus = 0
									if player:HasCollectible(CollectibleType.COLLECTIBLE_C_SECTION) then
										isFetus = 18
									end
									if player:HasWeaponType(WeaponType.WEAPON_KNIFE) then
										local kn = ILIB.game:Spawn(EntityType.ENTITY_TEAR, 0, player.Position, Vector.FromAngle(addedbarrageangle2.addedbarrageangle + direction:GetAngleDegrees()):Resized(20), player, 0, 0):ToTear()
										kn.TearFlags = kn.TearFlags | TearFlags.TEAR_PIERCING;
										kn.CollisionDamage = player.Damage * 2;
										kn:ChangeVariant(RebekahCurse.ENTITY_REDKNIFE)
										--local knife = InutilLib.SpawnKnife(player, (data.addedbarrageangle2 + direction:GetAngleDegrees()), false, 0, SchoolbagKnifeMode.FIRE_OUT_ONLY, 1, 120)
										--yandereWaifu.GetEntityData(knife).IsRed = true
									elseif player:HasWeaponType(WeaponType.WEAPON_TECH_X) then
										local circle = player:FireTechXLaser(player.Position, Vector.FromAngle(data.addedbarrageangle2 + direction:GetAngleDegrees())*(20), data.Xsize)
									else
										local tears = player:FireTear(player.Position, Vector.FromAngle((data.addedbarrageangle2) + direction:GetAngleDegrees())*(20-isFetus), false, false, false)
										tears.Position = player.Position
										tears.Scale = tears.Scale + tearSize
										tears.CollisionDamage = tears.CollisionDamage * 1.2
										if player:HasCollectible(CollectibleType.COLLECTIBLE_C_SECTION) then
											tears:ChangeVariant(50)
											tears.TearFlags = tears.TearFlags | TearFlags.TEAR_PIERCING | TearFlags.TEAR_SPECTRAL
											yandereWaifu.GetEntityData(tears).IsEsauFetus = true
										end
									end
									yandereWaifu.PlayAllRedGuns(player, 0)
								end
								if player.MaxFireDelay <= 1 then
									local isFetus = 0
									if player:HasCollectible(CollectibleType.COLLECTIBLE_C_SECTION) then
										isFetus = 18
									end
									if player:HasWeaponType(WeaponType.WEAPON_KNIFE) then
										local kn = ILIB.game:Spawn(EntityType.ENTITY_TEAR, 0, player.Position, Vector.FromAngle(data.addedbarrageangle2 + direction:GetAngleDegrees()):Resized(20), player, 0, 0):ToTear()
										kn.TearFlags = kn.TearFlags | TearFlags.TEAR_PIERCING;
										kn.CollisionDamage = player.Damage * 2;
										kn:ChangeVariant(RebekahCurse.ENTITY_REDKNIFE)
										--local knife = InutilLib.SpawnKnife(player, ( direction:GetAngleDegrees()), false, 0, SchoolbagKnifeMode.FIRE_OUT_ONLY, 1, 120)
										--yandereWaifu.GetEntityData(knife).IsRed = true
									elseif player:HasWeaponType(WeaponType.WEAPON_TECH_X) then
										local circle = player:FireTechXLaser(player.Position, Vector.FromAngle((data.addedbarrageangle2) - direction:GetAngleDegrees())*(20), data.Xsize)
									else
										local tears = player:FireTear(player.Position, Vector.FromAngle(direction:GetAngleDegrees())*(20-isFetus), false, false, false)
										tears.Position = player.Position
										tears.Scale = tears.Scale + tearSize
										tears.CollisionDamage = tears.CollisionDamage * 1.2
										if player:HasCollectible(CollectibleType.COLLECTIBLE_C_SECTION) then
											tears:ChangeVariant(50)
											tears.TearFlags = tears.TearFlags | TearFlags.TEAR_PIERCING | TearFlags.TEAR_SPECTRAL
											yandereWaifu.GetEntityData(tears).IsJacobFetus = true
										end
									end
									yandereWaifu.PlayAllRedGuns(player, 1)
								end
								
								if player:HasWeaponType(WeaponType.WEAPON_MONSTROS_LUNGS) then
								local chosenNumofBarrage =  math.random(15,20)
									for i = 1, chosenNumofBarrage do
										local tear = player:FireTear(player.Position, Vector.FromAngle(direction:GetAngleDegrees() - math.random(-10,10))*(math.random(5,15)), false, false, false):ToTear()
										tear.Position = player.Position
										tear.Scale = math.random(07,14)/10
										tear.Scale = tear.Scale + tearSize
										tear.FallingSpeed = -10 + math.random(1,3)
										tear.FallingAcceleration = 0.5
										tear.CollisionDamage = player.Damage * 3.5
										--tear.BaseDamage = player.Damage * 2
										yandereWaifu.PlayAllRedGuns(player, 0)
									end
								end
								
							elseif data.redcountdownFrames >= endFrameCount then
								EndBarrageIfValid()
								data.redcountdownFrames = 0 
								yandereWaifu.SpawnHeartParticles( 3, 5, player.Position, yandereWaifu.RandomHeartParticleVelocity(), player, RebekahHeartParticleType.Red );
							end
							--if wizAng == -45 and not player:HasCollectible(CollectibleType.COLLECTIBLE_THE_WIZ) then
							--	break -- just makes sure it doesnt duplicate
							--end
						end
						if wizAng == -45 and not player:HasCollectible(CollectibleType.COLLECTIBLE_THE_WIZ) then
							break -- just makes sure it doesnt duplicate
						end
						--if wizAng >= 0 then
						--	break -- just makes sure it doesnt duplicate
						--end
					end
					direction = oldDir
					if not data.IsLokiHornsTriggered then 
						break
					end --break if not loki horns is triggered
					
				end	
				
				--checks if red personality's gun is done
				local canModifyGunsGeneral = data.extraHugsRed and (#data.extraHugsRed > 0 and data.canModifyGuns)
				local canModifyGunsEpicFetus = player:HasWeaponType(WeaponType.WEAPON_ROCKETS) and data.canModifyGuns

				if canModifyGunsGeneral or canModifyGunsEpicFetus then
					local gunIdle = true
					if canModifyGunsGeneral then
						for k, v in pairs(data.extraHugsRed) do
							if v:GetSprite():IsPlaying("Startup") or InutilLib.IsPlayingMultiple(v:GetSprite(), "ShootRightTech", "ShootLeftTech", "ShootDownTech", "ShootUpTech",  "ShootRightBrimstone", "ShootLeftBrimstone", "ShootDownBrimstone", "ShootUpBrimstone") then
								gunIdle = false
								break
							end
						end	
					end
					if not data.FinishedPlayingCustomAnim and canModifyGunsEpicFetus then
						gunIdle = false
					end

					if gunIdle then
						if canModifyGunsGeneral then
							for k, v in pairs(data.extraHugsRed) do
								v:GetSprite():Play("Spawn", true)
							end
						end
						for k, v in pairs (Isaac.GetRoomEntities()) do
							v:ClearEntityFlags(EntityFlag.FLAG_SLOW)
						end
						data.canModifyGuns = nil
						data.tintEffect:Remove()
						data.tintEffect = nil
						data.FinishedPlayingCustomAnim = nil
						yandereWaifu.RebekahCanShoot(player, true)
						player.FireDelay = 60
					else
						if not data.tintEffect then
							data.tintEffect = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_BACKGROUNDTINT, 0, player.Position, Vector.Zero, nil):ToEffect()
							data.tintEffect.RenderZOffset = -10
							yandereWaifu.RebekahCanShoot(player, false)
						end
						
						for k, v in pairs (Isaac.GetRoomEntities()) do
							if v.Type ~= 1000 and v.Type ~= 1 and v.Type ~= 8 then
								v:AddEntityFlags(EntityFlag.FLAG_SLOW)
							end
						end
						yandereWaifu.SpawnHeartParticles( 2, 4, player.Position, yandereWaifu.RandomHeartParticleVelocity(), player, RebekahHeartParticleType.Red );
						--we need to freeze the player
						--player.Position = player.Position
						--player.Velocity = Vector.Zero
						player.FireDelay = 60
					end
				end
			end
		end
	elseif modes == REBECCA_MODE.SoulHearts then

		local extraTearDmg = 1--keeps how much extra damage might be needed, instead of adding more tears. It might be laggy.
		local chosenNumofBarrage =  9; --chosenNumofBarrage or math.random( 8, 15 );
		local modulusnum
		if player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_KNIFE) --[[and player:HasCollectible(CollectibleType.COLLECTIBLE_LUDOVICO_TECHNIQUE) ]]then
			modulusnum = math.ceil(player.MaxFireDelay*3)
		elseif player:HasWeaponType(WeaponType.WEAPON_LASER) then
			if player:HasCollectible(CollectibleType.COLLECTIBLE_LUDOVICO_TECHNIQUE) then
				modulusnum = math.ceil((player.MaxFireDelay))
			else
				modulusnum = math.ceil(player.MaxFireDelay/3)
			end
		else
			modulusnum = math.ceil((player.MaxFireDelay/5))
		end
		if not data.soulcountdownFrames then data.soulcountdownFrames = 0 end
		
		local endFrameCount = 40
		
		if player:HasWeaponType(WeaponType.WEAPON_KNIFE) or player:HasWeaponType(WeaponType.WEAPON_LASER) then
			endFrameCount = 36
		elseif player:HasCollectible(CollectibleType.COLLECTIBLE_C_SECTION) then
			endFrameCount = 10
		else
			endFrameCount = 20
		end
		
		if data.BarrageIntro then
			data.soulcountdownFrames = data.soulcountdownFrames + 1
		end
		
		local canFire = true
		
		--tear-damage configuration thingy
		if player:HasCollectible(CollectibleType.COLLECTIBLE_20_20) then
			extraTearDmg = extraTearDmg + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_20_20) 
		end
		if player:HasCollectible(CollectibleType.COLLECTIBLE_MUTANT_SPIDER) then
			extraTearDmg = extraTearDmg + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_MUTANT_SPIDER) * 3
		end
		if player:HasCollectible(CollectibleType.COLLECTIBLE_INNER_EYE) then
			extraTearDmg = extraTearDmg + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_INNER_EYE) * 2
		end
		if player:HasCollectible(CollectibleType.COLLECTIBLE_MONSTROS_LUNG) then
			extraTearDmg = extraTearDmg + math.random(3,5);
		end
		
		if player:HasCollectible(CollectibleType.COLLECTIBLE_CAR_BATTERY) then
			endFrameCount = endFrameCount * 2
			extraTearDmg = extraTearDmg * (player:GetCollectibleNum(CollectibleType.COLLECTIBLE_CAR_BATTERY) * 1.5)
		end
		
		if HasChargeCollectibles(player) then
			if (player:GetShootingInput().X ~= 0 or player:GetShootingInput().Y ~= 0) and not data.barrageInit then
				if not data.chargeDelay then data.chargeDelay = 0 end
				if data.chargeDelay < player.MaxFireDelay * 3 then
					data.chargeDelay = data.chargeDelay + 0.1
					print(math.floor(data.chargeDelay*10) % 5)
					if math.floor(data.chargeDelay*10) % 5 == 0 then
						local charge = Isaac.Spawn( EntityType.ENTITY_EFFECT, EffectVariant.HEART, 0, player.Position, Vector(0,0), player );
						charge.SpriteOffset = Vector(0,-40)
						charge:GetSprite():ReplaceSpritesheet(0, "gfx/effects/red/chocolate_charge.png");
						charge:GetSprite():ReplaceSpritesheet(1, "gfx/effects/red/chocolate_charge.png");
						charge:GetSprite():LoadGraphics();
						InutilLib.SFX:Play( SoundEffect.SOUND_BATTERYCHARGE , 1, 0, false, data.chargeDelay/10);
						--InutilLib.SFX:Play(RebekahCurseSounds.SOUND_SOULCHARGEHEAVY, 1, 0, false, 0.5)
					end
				end
			end
			
			if not data.barrageInit then
				canFire = false
			end
			
			if player:GetShootingInput().X == 0 and player:GetShootingInput().Y == 0 then
				if player:HasCollectible(CollectibleType.COLLECTIBLE_CHOCOLATE_MILK) then
					local chargeFrameToPercent = (data.chargeDelay/player.MaxFireDelay)*0.5
					print(chargeFrameToPercent)
					extraTearDmg = data.soulcountdownFrames + math.ceil(chargeFrameToPercent)
				end
				if player:HasCollectible(CollectibleType.COLLECTIBLE_CURSED_EYE) then
					local chargeFrameToPercent = (data.chargeDelay/player.MaxFireDelay)*1.5
					extraTearDmg = data.soulcountdownFrames + math.ceil(chargeFrameToPercent)
				end
				canFire = true
				data.barrageNumofShots = extraTearDmg --update to new because charged shots changes it
			end
		end
		
		local function SoulLeadPencilBarrage()
		--lead pencil synergy
			if player:HasCollectible(CollectibleType.COLLECTIBLE_LEAD_PENCIL) then
				--local numLimit = 9
				--for i = 1, numLimit do
						
					--InutilLib.SetTimer( i * 15, function()
						local chosenNumofBarrage = math.random(8,15)
						for i = 1, chosenNumofBarrage do
							local tear = player:FireTear(player.Position, Vector.FromAngle(direction:GetAngleDegrees() - math.random(-10,10))*(math.random(17,22)), false, false, false):ToTear()
							tear.Position = player.Position
							if tear.Variant == 0 then tear:ChangeVariant(TearVariant.BLOOD) end
							tear.Scale = math.random(15,18)/10
							tear.Scale = tear.Scale + tearSize
							--tear.FallingSpeed = -10 + math.random(1,3)
							--tear.FallingAcceleration = 0.5
							tear.CollisionDamage = player.Damage * 3.5  * extraTearDmg
							tear.TearFlags = tear.TearFlags | TearFlags.TEAR_SPECTRAL | TearFlags.TEAR_PIERCING | TearFlags.TEAR_WIGGLE;
							--tear.BaseDamage = player.Damage * 2
						end
				--	end)
				--end
			end
		end
		
		--setup of soul personality's gun effects and barrage
		if not data.MainArcaneCircle then
			data.MainArcaneCircle = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_ARCANE_CIRCLE, 1, player.Position,  Vector.Zero, nil)
			yandereWaifu.GetEntityData(data.MainArcaneCircle).parent = player
			for i = 0, 8 do
				data.MainArcaneCircle:GetSprite():ReplaceSpritesheet(i, "gfx/effects/soul/arcane_circle.png")
			end
			data.MainArcaneCircle:GetSprite():LoadGraphics()
			data.ArcaneCircleDust = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_REBEKAH_DUST, 4, player.Position, Vector.Zero, player)
			data.ArcaneCircleDust.RenderZOffset = -1
			yandereWaifu.GetEntityData(data.ArcaneCircleDust).Parent = player
		end
		
		local function FireSoulKnife(pos, dir)
			local knife = player:FireTear( pos, dir, false, false, false):ToTear()
			knife.Position = pos
			----local tear = ILIB.game:Spawn(EntityType.ENTITY_TEAR, 0, player.Position, Vector.FromAngle(direction:GetAngleDegrees() - math.random(-10,10))*(math.random(10,15)), player, 0, 0):ToTear()
			knife.TearFlags = knife.TearFlags | TearFlags.TEAR_PIERCING;
			--knife.CollisionDamage = player.Damage * 4;
			knife:ChangeVariant(RebekahCurse.ENTITY_HAUNTEDKNIFE);
			--player.Velocity = ( player.Velocity * 0.8 ) + Vector.FromAngle( (direction):GetAngleDegrees() +180 );
			--InutilLib.SFX:Play( SoundEffect.SOUND_BIRD_FLAP, 1, 0, false, 1.5 );
			--local knife = InutilLib.SpawnKnife(player, (direction:GetAngleDegrees() - math.random(-10,10)), false, 0, SchoolbagKnifeMode.FIRE_ONCE, 1, 90)
			yandereWaifu.GetEntityData(knife).IsSoul = true
		end
		
		if data.BarrageIntro and canFire then
			if player:HasCollectible(CollectibleType.COLLECTIBLE_SPIRIT_SWORD) then
				local arcane = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_REBEKAH_DUST, 8, player.Position, Vector.Zero, nil)
				for i = 1, math.random(10,20) do --loop possible times a sword will drop from the sky
					local hasNoEnemies = false
					for i, e in pairs(Isaac.GetRoomEntities()) do
						if e:IsActiveEnemy() and e:IsVulnerableEnemy() then
							if (player.Position - e.Position):Length() < 750 then
								InutilLib.SetTimer( i * math.random(10,20), function()
									local target = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_SWORDDROP, 0, e.Position + Vector(0,math.random(3,50)):Rotated(math.random(0,360)), Vector.Zero, nil)
									yandereWaifu.GetEntityData(target).Parent = player
									--[[if math.random(1,3) == 3 and i < 5 then
										local arcane = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_REBEKAH_DUST, 8, target.Position, Vector.Zero, nil)
									end]]
								end)
							end
						end
					end
					--if hasNoEnemies then
						InutilLib.SetTimer( i * math.random(5,20), function()
							local target = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_SWORDDROP, 0, Isaac.GetRandomPosition() + Vector(0,math.random(3,50)):Rotated(math.random(0,360)), Vector.Zero, nil)
							yandereWaifu.GetEntityData(target).Parent = player
						end)
					--end
				end
				EndBarrageIfValid()
			--epic fetus synergy
			elseif player:HasWeaponType(WeaponType.WEAPON_ROCKETS) then --rocket synergy
				local target = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_GHOSTTARGET, 0, player.Position,  Vector.FromAngle(direction:GetAngleDegrees())*(9), nil)
				yandereWaifu.GetEntityData(target).Parent = player
				yandereWaifu.GetEntityData(target).ExtraTears = extraTearDmg
				EndBarrageIfValid()
			---if player:HasWeaponType(WeaponType.WEAPON_ROCKETS) then --rocket synergy
			---	Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_WIZOOB_MISSILE, 0, player.Position,  Vector.FromAngle(direction:GetAngleDegrees())*(9), player)
			--	EndBarrage()
			--ludo synergy
			elseif player:HasCollectible(CollectibleType.COLLECTIBLE_LUDOVICO_TECHNIQUE) and not player:HasWeaponType(WeaponType.WEAPON_BOMBS) and not player:HasWeaponType(WeaponType.WEAPON_TECH_X) then
				local ludoTear
				ludoTear = InutilLib.GetPlayerLudo(player)
				if ludoTear then
					--[[if not data.KnifeHelper then data.KnifeHelper = InutilLib:SpawnKnifeHelper(ludoTear, player) else
						if not data.KnifeHelper.incubus:Exists() then
							data.KnifeHelper = InutilLib:SpawnKnifeHelper(ludoTear, player)
						else
							data.KnifeHelper.incubus.Position = ludoTear.Position
						end
					end]]
					local division = 360/8
					if player:HasWeaponType(WeaponType.WEAPON_BRIMSTONE) or player:HasWeaponType(WeaponType.WEAPON_KNIFE) then
						division = 360/4
					end
					for i = 0, 360, division do
						--knife sucks
						if player:HasWeaponType(WeaponType.WEAPON_KNIFE) then
							if data.soulcountdownFrames == 1 then
								--player.ControlsEnabled = false;
							elseif data.soulcountdownFrames >= 1 and data.soulcountdownFrames < endFrameCount and data.soulcountdownFrames % modulusnum == (0) then
								for j = -30, 30, 15 do
									FireSoulKnife(ludoTear.Position, Vector.FromAngle(i + data.soulcountdownFrames*5 - j):Resized(13))
								end
								--print(modulusnum)
								--local knife = InutilLib.SpawnKnife(player, (i + data.soulcountdownFrames*5), false, 0, SchoolbagKnifeMode.FIRE_ONCE, 1, 20, data.KnifeHelper)
								--yandereWaifu.GetEntityData(knife).IsSoul = true
								--local knife2 = InutilLib.SpawnKnife(player, ((i + data.soulcountdownFrames*10)+90), false, 0, SchoolbagKnifeMode.FIRE_ONCE, 1, 20, data.KnifeHelper)
								--yandereWaifu.GetEntityData(knife2).IsSoul = true
							elseif data.soulcountdownFrames >= endFrameCount then
								EndBarrage()
								--player.ControlsEnabled = true;
								data.soulcountdownFrames = 0;
								SoulLeadPencilBarrage()
							end
						elseif player:HasWeaponType(WeaponType.WEAPON_BRIMSTONE) then
							for j = 1, math.floor(chosenNumofBarrage/2) do
								if j == 1 then
									local brim = EntityLaser.ShootAngle(1, ludoTear.Position, i + direction:GetAngleDegrees() - 45, 5, Vector(0,-5), player):ToLaser()
									brim:SetActiveRotation( 0, 135, 10, false );
									brim:AddTearFlags(player.TearFlags)
									brim:SetColor(ludoTear:GetColor(), 999, 999)
									brim.DisableFollowParent = true
									brim:GetData().IsEctoplasm = true;
									brim.CollisionDamage = player.Damage * 2 * extraTearDmg
									brim:SetHomingType(1)
									yandereWaifu.GetEntityData(brim).IsEcto = true
								else
									local brim2 = EntityLaser.ShootAngle(1, ludoTear.Position, i + direction:GetAngleDegrees()  - math.random(-10,10) + 45, 5, Vector(0,-5), player):ToLaser()
									brim2:SetActiveRotation( 0, -135, -10, false );
									brim2:AddTearFlags(player.TearFlags)
									brim2:SetColor(ludoTear:GetColor(), 999, 999)
									brim2.DisableFollowParent = true
									brim2:GetData().IsEctoplasm = true;
									brim2.Timeout = 1;
									brim2:SetHomingType(1)
									yandereWaifu.GetEntityData(brim2).IsEcto = true
								end
								if j == math.floor(chosenNumofBarrage/2) then
									InutilLib.SFX:Play( SoundEffect.SOUND_WEIRD_WORM_SPIT, 1, 0, false, 1 );
									EndBarrage()
									SoulLeadPencilBarrage()
								end
							end
						elseif player:HasWeaponType(WeaponType.WEAPON_LASER) then
							if data.soulcountdownFrames == 1 then
								--player.ControlsEnabled = false;
							elseif data.soulcountdownFrames >= 1 and data.soulcountdownFrames < endFrameCount and data.soulcountdownFrames % modulusnum == (0) then
								local techlaser = player:FireTechLaser(ludoTear.Position, 0, Vector.FromAngle(i + direction:GetAngleDegrees() + math.random(-15,15)):Resized( REBEKAH_BALANCE.RED_HEART_ATTACK_BRIMSTONE_SIZE ), false, true)
								techlaser.OneHit = true;
								techlaser.Timeout = 1;
								techlaser.DisableFollowParent = true
								techlaser.CollisionDamage = (player.Damage * 1.5) * (extraTearDmg*2.5);
								techlaser:SetMaxDistance(math.random(100,120))
								yandereWaifu.GetEntityData(techlaser).IsMonstrosLung = true
								yandereWaifu.GetEntityData(techlaser).LaserCount = 2
								techlaser:GetSprite():ReplaceSpritesheet(0, "gfx/effects/soul/techlaser.png");
								if techlaser.Child then
									techlaser.Child:GetSprite():ReplaceSpritesheet(0, "gfx/effects/soul/tech_dot.png");
								end
								techlaser:GetSprite():LoadGraphics();
								yandereWaifu.GetEntityData(techlaser).IsEctoplasmLaser = true
							elseif data.soulcountdownFrames >= endFrameCount then
								EndBarrage()
								--player.ControlsEnabled = true;
								data.soulcountdownFrames = 0;
								SoulLeadPencilBarrage()
							end
						else
							for j = 1, math.floor(chosenNumofBarrage/2) do
								player.Velocity = player.Velocity * 0.8; --slow him down
									local tear = player:FireTear( ludoTear.Position, Vector.FromAngle(i + direction:GetAngleDegrees() - math.random(-10,10)):Resized(math.random(4,6)), false, false, false):ToTear()
									tear.Position = ludoTear.Position
									--local tear = ILIB.game:Spawn(EntityType.ENTITY_TEAR, 0, player.Position, Vector.FromAngle(direction:GetAngleDegrees() - math.random(-10,10))*(math.random(10,15)), player, 0, 0):ToTear()
									tear.Scale = math.random() * 0.7 + 0.7;
									tear.FallingSpeed = -9 + math.random() * 2;
									tear.FallingAcceleration = 0.5;
									tear.TearFlags = tear.TearFlags | TearFlags.TEAR_SPECTRAL | TearFlags.TEAR_PIERCING;
									tear.CollisionDamage = player.Damage * 1.6 * extraTearDmg;
									--if not tear:GetData().IsEctoplasm then  tear:GetData().IsEctoplasm = true end
									--print(tear:GetData().IsEctoplasm)
									--tear.BaseDamage = player.Damage * 2
									if player:HasCollectible(CollectibleType.COLLECTIBLE_GHOST_PEPPER) and math.random(1,14) + player.Luck >= 14 then
										local tears2 = player:FireTear(ludoTear.Position, Vector.FromAngle(i + direction:GetAngleDegrees() - math.random(-10,10)):Resized(math.random(4,6)), false, false, false):ToTear()
										tears2.CollisionDamage = player.Damage * 0.8
										tears2:ChangeVariant(TearVariant.FIRE)
										tears2.Scale = 1.5
									end
									if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRDS_EYE) and math.random(1,14) + player.Luck >= 14 then
										local fire = Isaac.Spawn(EntityType.ENTITY_EFFECT, 51, 0, ludoTear.Position, Vector.FromAngle(i + direction:GetAngleDegrees() - math.random(-10,10)):Resized(math.random(4,6)), player):ToEffect()
										fire.Scale = tear.Scale
										fire:GetSprite().Scale = Vector(tear.Scale,tear.Scale)
									end
								if j == math.floor(chosenNumofBarrage/2) then
									InutilLib.SFX:Play( SoundEffect.SOUND_WEIRD_WORM_SPIT, 1, 0, false, 1 );
									EndBarrage()
									SoulLeadPencilBarrage()
								end
							end
						end
					end
				end
			--knife synergy
			else
				if data.soulcountdownFrames == 1 then
					--lokis horns
					if player:HasCollectible(CollectibleType.COLLECTIBLE_LOKIS_HORNS) and math.random(0,10) + player.Luck >= 10 then
						data.IsLokiHornsTriggered = true
					else
						data.IsLokiHornsTriggered = false
					end
				end
				--lokis horns
				for lhorns = 0, 270, 360/4 do
					direction = Vector.FromAngle(direction:GetAngleDegrees() + lhorns) --lokis horns offset
					local oldDir = direction
					--effect thing
					if data.soulcountdownFrames == 1 then
						local dust = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_REBEKAH_DUST, 7, player.Position, Vector(0,0), nil) 
						dust:GetSprite().Rotation = direction:GetAngleDegrees() + 90
					end
					--[[spit effect
					local spit = Isaac.Spawn( EntityType.ENTITY_EFFECT, 2, 5, player.Position, Vector(0,0), player );
					spit:GetSprite():ReplaceSpritesheet(4,"gfx/effects/soul/ectoplasm_spit.png")
					spit:GetSprite():LoadGraphics()
					spit.RenderZOffset = 1000]]
					
					--wiz synergy
					for wizAng = -45, 90, 135 do
						if player:HasCollectible(CollectibleType.COLLECTIBLE_THE_WIZ) and lhorns == 0 then --sets the wiz angles
							direction = Vector.FromAngle(direction:GetAngleDegrees() + wizAng)
						end
						if player:HasWeaponType(WeaponType.WEAPON_KNIFE) then
							if data.soulcountdownFrames == 1 then
								player.ControlsEnabled = false;
							elseif data.soulcountdownFrames >= 1 and data.soulcountdownFrames < endFrameCount and data.soulcountdownFrames % modulusnum == (0) then
								local delay = 0
								for i = -30, 30, 15 do
									InutilLib.SetTimer( 1*delay, function()
										FireSoulKnife(player.Position, Vector.FromAngle(direction:GetAngleDegrees() - i):Resized(8))
										InutilLib.SFX:Play(RebekahCurseSounds.SOUND_SOULSHOTLIGHT, 1, 0, false, 1.2)
									end)
									delay = delay + 20
								end
							elseif data.soulcountdownFrames >= endFrameCount then
								EndBarrage()
								player.ControlsEnabled = true;
								data.soulcountdownFrames = 0;
								SoulLeadPencilBarrage()
							end
						--brimstone synergy
						elseif player:HasWeaponType(WeaponType.WEAPON_BRIMSTONE) then
							for i = 1, chosenNumofBarrage do
								if i == 1 then
									local didtrigger = false
									if player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BRIMSTONE) < 2 then
										player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_BRIMSTONE, false, player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BRIMSTONE)+1)
										didtrigger = true
									end
									local brim = player:FireBrimstone( Vector.FromAngle( direction:GetAngleDegrees()):Resized( REBEKAH_BALANCE.RED_HEART_ATTACK_BRIMSTONE_SIZE ) ):ToLaser(); --i'm just gonna use the same brim size as the red heart :/
									brim:GetData().IsEctoplasm = true;
									brim.CollisionDamage = player.Damage * 2 * extraTearDmg
									yandereWaifu.GetEntityData(brim).IsEcto = true
									if didtrigger then
										player:GetEffects():RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_BRIMSTONE, player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BRIMSTONE)+1)
									end
								else
									player.Velocity = player.Velocity * 0.8; --slow him down
									local brim = player:FireBrimstone( Vector.FromAngle( direction:GetAngleDegrees() - math.random(-10,10)):Resized( REBEKAH_BALANCE.RED_HEART_ATTACK_BRIMSTONE_SIZE ) ):ToLaser();
									brim:GetData().IsEctoplasm = true;
									brim.Timeout = 1;
									yandereWaifu.GetEntityData(brim).IsEcto = true
								end
								if i == chosenNumofBarrage then
									InutilLib.SFX:Play( SoundEffect.SOUND_WEIRD_WORM_SPIT, 1, 0, false, 1 );
									EndBarrage()
									SoulLeadPencilBarrage()
								end
							end
							InutilLib.SFX:Play(RebekahCurseSounds.SOUND_SOULSHOTHEAVY, 1, 0, false, 1.2)
							local dust = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_REBEKAH_DUST, 7, player.Position, Vector(0,0), nil) 
							dust:GetSprite().Rotation = direction:GetAngleDegrees() + 90
						--technology synergy
						elseif player:HasWeaponType(WeaponType.WEAPON_LASER) then --tech barrage
							if data.soulcountdownFrames >= 1 and data.soulcountdownFrames < endFrameCount and data.soulcountdownFrames % modulusnum == (0) then
								local techlaser = player:FireTechLaser(player.Position, 0, Vector.FromAngle(direction:GetAngleDegrees() - math.random(-30,30)):Resized( REBEKAH_BALANCE.RED_HEART_ATTACK_BRIMSTONE_SIZE ), false, true)
								techlaser.OneHit = true;
								techlaser.Timeout = 1;
								techlaser.CollisionDamage = (player.Damage * 1.5) * (extraTearDmg*2.5);
								techlaser:SetMaxDistance(math.random(100,120))
								yandereWaifu.GetEntityData(techlaser).IsMonstrosLung = true
								yandereWaifu.GetEntityData(techlaser).LaserCount = 3
								techlaser:GetSprite():ReplaceSpritesheet(0, "gfx/effects/soul/techlaser.png");
								if techlaser.Child then
									techlaser.Child:GetSprite():ReplaceSpritesheet(0, "gfx/effects/soul/tech_dot.png");
								end
								techlaser:GetSprite():LoadGraphics();
								yandereWaifu.GetEntityData(techlaser).IsEctoplasmLaser = true
								--techlaser:SetHomingType(1)
							elseif data.soulcountdownFrames >= endFrameCount then
								InutilLib.SFX:Play( SoundEffect.SOUND_WEIRD_WORM_SPIT, 1, 0, false, 1 );
								EndBarrage()
								SoulLeadPencilBarrage()
							end
							if data.soulcountdownFrames == 1 then
								InutilLib.SFX:Play(RebekahCurseSounds.SOUND_SOULELECTRICITY, 1, 0, false, 1.2)
							end
						--tech x synergy
						elseif player:HasWeaponType(WeaponType.WEAPON_TECH_X) then
							--local tear = player:FireTear( player.Position, Vector.FromAngle(direction:GetAngleDegrees()):Resized(4), false, false, false):ToTear()
							---tear.Position = player.Position
							--tear:ClearTearFlags(tear.TearFlags)
							--print(tear.TearFlags)
							--tear.TearFlags = TearFlags.TEAR_SPECTRAL;
							--tear.CollisionDamage = player.Damage * 2;
							local circle = player:FireTechXLaser(player.Position, Vector.FromAngle(direction:GetAngleDegrees()):Resized(4), 50)
							--circle:SetColor(Color(0,0,0,0.7,170,170,210),9999999,99,false,false);
							circle.CollisionDamage = player.Damage * 3 * extraTearDmg;
							yandereWaifu.GetEntityData(circle).IsEctoplasmLaserX = true
							yandereWaifu.GetEntityData(circle).IsEctoplasm = true
							--tear:ChangeVariant(ENTITY_ECTOPLASMA);
							--yandereWaifu.GetEntityData(tear).Parent = player;
							player.Velocity = ( player.Velocity * 0.8 ) + Vector.FromAngle( (direction):GetAngleDegrees() +180 );
							InutilLib.SFX:Play( SoundEffect.SOUND_WEIRD_WORM_SPIT, 1, 0, false, 1 );
							EndBarrage()
							SoulLeadPencilBarrage()
							if data.soulcountdownFrames == 1 then
								InutilLib.SFX:Play(RebekahCurseSounds.SOUND_SOULELECTRICITY, 1.2, 0, false, 0.5)
							end
						elseif player:HasWeaponType(WeaponType.WEAPON_BOMBS) then
							InutilLib.SFX:Play(RebekahCurseSounds.SOUND_SOULSPIT, 1.2, 0, false, 1)
							local tear = player:FireTear( player.Position, Vector.FromAngle(direction:GetAngleDegrees()):Resized(10), false, false, false):ToTear()
							tear.Position = player.Position
							tear:ChangeVariant(RebekahCurse.ENTITY_SBOMBBUNDLE);
							tear.FallingSpeed = -9 + math.random() * 2;
							tear.FallingAcceleration = 0.5;
							yandereWaifu.GetEntityData(tear).Parent = player
							yandereWaifu.GetEntityData(tear).ExtraTears = extraTearDmg
							EndBarrage()
							SoulLeadPencilBarrage()
							InutilLib.SFX:Play(RebekahCurseSounds.SOUND_SOULSHOTHEAVY, 1.2, 0, false, 1)
							local dust = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_REBEKAH_DUST, 7, player.Position, Vector(0,0), nil) 
							dust:GetSprite().Rotation = direction:GetAngleDegrees() + 90
						else
							local chosenNumofBarrage = math.random(1,3)
							if data.soulcountdownFrames >= 1 and data.soulcountdownFrames < endFrameCount and data.soulcountdownFrames % modulusnum == (0) then
								for i = 1, chosenNumofBarrage do
									player.Velocity = player.Velocity * 0.8; --slow him down
										local tear = player:FireTear( player.Position, Vector.FromAngle(direction:GetAngleDegrees() - math.random(-10,10)):Resized(math.random(6,9)), false, false, false):ToTear()
										tear.Position = player.Position
										tear.TearFlags = tear.TearFlags | TearFlags.TEAR_SPECTRAL;
										tear.CollisionDamage = player.Damage * 1.3 * extraTearDmg;
										--if not tear:GetData().IsEctoplasm then  tear:GetData().IsEctoplasm = true end
										--print(tear:GetData().IsEctoplasm)
										--tear.BaseDamage = player.Damage * 2
										if player:HasCollectible(CollectibleType.COLLECTIBLE_C_SECTION) then
											tear:ChangeVariant(50)
											tear.TearFlags = tear.TearFlags | TearFlags.TEAR_PIERCING | TearFlags.TEAR_SPECTRAL
											yandereWaifu.GetEntityData(tear).IsSoulFetus = true
										else
											tear.Scale = math.random() * 0.7 + 0.7;
											tear.FallingSpeed = -9 + math.random() * 2;
											tear.FallingAcceleration = 0.5;
										end
										if player:HasCollectible(CollectibleType.COLLECTIBLE_GHOST_PEPPER) and math.random(1,14) + player.Luck >= 14 then
											local tears2 = player:FireTear(player.Position, Vector.FromAngle(direction:GetAngleDegrees() - math.random(-10,10)):Resized(math.random(6,9)), false, false, false):ToTear()
											tears2.CollisionDamage = player.Damage * 0.8
											tears2:ChangeVariant(TearVariant.FIRE)
											tears2.Scale = 1.5
										end
										if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRDS_EYE) and math.random(1,14) + player.Luck >= 14 then
											local fire = Isaac.Spawn(EntityType.ENTITY_EFFECT, 51, 0, player.Position, Vector.FromAngle(direction:GetAngleDegrees() - math.random(-10,10)):Resized(math.random(6,9)), player):ToEffect()
											fire.Scale = tear.Scale
											fire:GetSprite().Scale = Vector(tear.Scale,tear.Scale)
										end
									if i == chosenNumofBarrage then
										InutilLib.SFX:Play( SoundEffect.SOUND_WEIRD_WORM_SPIT, 1, 0, false, 0.5 );
									end
								end
							elseif data.soulcountdownFrames >= endFrameCount then
								InutilLib.SFX:Play( SoundEffect.SOUND_WEIRD_WORM_SPIT, 1, 0, false, 1 );
								EndBarrage()
								SoulLeadPencilBarrage()
							end
							if data.soulcountdownFrames == 1 then
								InutilLib.SFX:Play(RebekahCurseSounds.SOUND_SOULSHOTMEDIUM, 1.2, 0, false, 1.2)
							end
							
						end
						--epiphora synergy
						if player:HasCollectible(CollectibleType.COLLECTIBLE_EPIPHORA) then
							for i = 1, math.random(18,22) do
								InutilLib.SetTimer( i*10, function()
									for j = 1, math.random(4,6) do
										local tear = player:FireTear( player.Position, Vector.FromAngle(direction:GetAngleDegrees() - math.random(-10,10)):Resized(math.random(12,15)), false, false, false):ToTear()
										tear.Position = player.Position
										--local tear = ILIB.game:Spawn(EntityType.ENTITY_TEAR, 0, player.Position, Vector.FromAngle(direction:GetAngleDegrees() - math.random(-10,10))*(math.random(10,15)), player, 0, 0):ToTear()
										tear.Scale = math.random() * 0.7
										tear.CollisionDamage = player.Damage * 0.5 * extraTearDmg;
									end
								end)
							end
						end
						--moms wig synergy
						if player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_WIG) then
							local numLimit = 5
							for i = 1, numLimit do
								InutilLib.SetTimer( i+5, function()
									player:ThrowBlueSpider(player.Position, player.Position + Vector.FromAngle(direction:GetAngleDegrees()):Resized(math.random(40,55)))
								end);
							end
						end
						--montezuma's revenge synergy
						if player:HasCollectible(CollectibleType.COLLECTIBLE_MONTEZUMAS_REVENGE) then
							local angle = direction:GetAngleDegrees()
							local beam = EntityLaser.ShootAngle(12, player.Position, angle + 180, 30, Vector(0,0), player):ToLaser()
							beam.MaxDistance = 250
							--InutilLib.UpdateLaserSize(beam, 2, false)
							--stream of painful blood
							for i = 1, math.random(20,30) do
								player.Velocity = player.Velocity * 0.8; --slow him down
								local tear = player:FireTear( player.Position, Vector.FromAngle(direction:GetAngleDegrees() + 180 - math.random(-45,45)):Resized(math.random(3,15)), false, false, false):ToTear()
								tear.Position = player.Position
								tear:ChangeVariant(TearVariant.BLOOD)
								--local tear = ILIB.game:Spawn(EntityType.ENTITY_TEAR, 0, player.Position, Vector.FromAngle(direction:GetAngleDegrees() - math.random(-10,10))*(math.random(10,15)), player, 0, 0):ToTear()
								tear.Scale = math.random() * 0.7 + 0.7;
								tear.FallingSpeed = -9 + math.random() * 2;
								tear.FallingAcceleration = 0.5;
								tear.TearFlags = tear.TearFlags | TearFlags.TEAR_SPECTRAL;
								tear.CollisionDamage = player.Damage * 1.3 * extraTearDmg;
								if math.random(1,3) == 3 then
									tear:GetSprite():Load("gfx/009.005_corn projectile.anm2", true)
									tear:GetSprite():Play("Small01", true)
								end
							end
							ILIB.game:ShakeScreen(20);
							--blood pain
							local puddle = ILIB.game:Spawn( EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_RED, player.Position, Vector(0,0), player, 0, 0):ToEffect()
							InutilLib.RevelSetCreepData(puddle)
							InutilLib.RevelUpdateCreepSize(puddle, math.random(12,17), true)
							--puddle.Scale = math.random(5,7)
							--puddle:Update()
						end
						--revelation synergy
						if player:HasCollectible(CollectibleType.COLLECTIBLE_REVELATION) then
							local angle = direction:GetAngleDegrees()
							local beam = EntityLaser.ShootAngle(5, player.Position, angle, 10, Vector(0,10), player):ToLaser()
							for i = 1, math.random(5,7) do
								local beam = EntityLaser.ShootAngle(5, player.Position, angle + math.random(-15,15), 10, Vector(0,10), player):ToLaser();
								beam.MaxDistance = math.random(250,500)
								InutilLib.UpdateLaserSize(beam, 0.5)
							end
						end
						if wizAng == -45 and not player:HasCollectible(CollectibleType.COLLECTIBLE_THE_WIZ) then
							break -- just makes sure it doesnt duplicate
						end
					end
					direction = oldDir
					if not data.IsLokiHornsTriggered then 
						break
					end --break if not loki horns is triggered
				end
			end
		elseif not data.BarrageIntro and canFire then
			if not data.isPlayingCustomAnim then
				data.isPlayingCustomAnim = true
				local customBody = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_EXTRACHARANIMHELPER, 0, player.Position, Vector(0,0), nil) --body effect
				yandereWaifu.GetEntityData(customBody).Player = player
				yandereWaifu.GetEntityData(customBody).SoulIsPukingUp = true
				
				local extra = player:HasCollectible(CollectibleType.COLLECTIBLE_LUDOVICO_TECHNIQUE) or player:HasWeaponType(WeaponType.WEAPON_SPIRIT_SWORD) or player:HasWeaponType(WeaponType.WEAPON_ROCKETS) 
				
				if player:HasCollectible(CollectibleType.COLLECTIBLE_LUDOVICO_TECHNIQUE) and InutilLib.GetPlayerLudo(player) then
					yandereWaifu.GetEntityData(customBody).SoulLudo = true
				end
				if extra then
					yandereWaifu.GetEntityData(customBody).extraAction = true
				end
				InutilLib.SFX:Play(RebekahCurseSounds.SOUND_SOULGARGLE, 1, 0, false, 0.9)
				if not data.tintEffect then
					data.tintEffect = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_BACKGROUNDTINT, 0, player.Position, Vector.Zero, nil):ToEffect()
					data.tintEffect.RenderZOffset = -10
					yandereWaifu.RebekahCanShoot(player, false)
				end
			elseif data.FinishedPlayingCustomAnim then
				data.soulspitframecount = 0
				data.FinishedPlayingCustomAnim = nil
				data.isPlayingCustomAnim2 = true --kinda sucks that theres a part two of the animation and i set it up like this, gross
				player:AddNullCostume(RebekahCurseCostumes.RebekahSpitsOut)
				
				for k, v in pairs (Isaac.GetRoomEntities()) do
					v:ClearEntityFlags(EntityFlag.FLAG_SLOW)
				end
				data.tintEffect:Remove()
				data.tintEffect = nil
				yandereWaifu.RebekahCanShoot(player, true)
				player.FireDelay = 30
			end
		end
	elseif modes == REBECCA_MODE.GoldHearts then
		yandereWaifu.RebekahGoldBarrage(player, direction)
		EndBarrage()
		InutilLib.SFX:Play( SoundEffect.SOUND_COIN_SLOT, 1, 0, false, 1 );
	elseif modes == REBECCA_MODE.EvilHearts then
		--set mainarcanecircle of evil
		if not data.MainArcaneCircle then
			data.MainArcaneCircle = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_ARCANE_CIRCLE, 1, player.Position,  Vector.Zero, nil)
			yandereWaifu.GetEntityData(data.MainArcaneCircle).parent = player
			for i = 0, 8 do
				data.MainArcaneCircle:GetSprite():ReplaceSpritesheet(i, "gfx/effects/evil/arcane_circle.png")
			end
			data.MainArcaneCircle:GetSprite():LoadGraphics()
			data.ArcaneCircleDust = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_REBEKAH_DUST, 4, player.Position, Vector.Zero, player)
			data.ArcaneCircleDust.RenderZOffset = -1
			yandereWaifu.GetEntityData(data.ArcaneCircleDust).Parent = player
		end
		
		--do the weird animation first before firing the beam
		if data.BarrageIntro then
					
			--Isaac.Spawn( EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_ARCANE_EXPLOSION, 0, player.Position, Vector.FromAngle( direction:GetAngleDegrees() ):	Resized(15), player );
			local target
			local nearestOrb = 177013 -- labels the highest enemy hp
			for i, ent in pairs (Isaac.GetRoomEntities()) do
				if ent.Type == EntityType.ENTITY_EFFECT and ent.Variant == RebekahCurse.ENTITY_EVILORB then
					if nearestOrb >= ent.Position:Distance(player.Position) then
						nearestOrb = ent.Position:Distance(player.Position)
						target = ent
					end
				end
			end
			
			local beam
			local angle = direction:GetAngleDegrees()
			local ludoTear = InutilLib.GetPlayerLudo(player)
			local hasWiz = 0
			if player:HasCollectible(CollectibleType.COLLECTIBLE_THE_WIZ) then --derp
				hasWiz = 1
			end
			for i = -15, 15, 30 do
				if ludoTear then
					angle = InutilLib.ObjToTargetAngle(player, ludoTear, true)
					beam = player:FireBrimstone( Vector.FromAngle(angle + i * hasWiz), player, 2):ToLaser();
					beam.MaxDistance = player.Position:Distance(ludoTear.Position)
					beam.DepthOffset = -400
					if player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_KNIFE) then
						for j = 1, 5 do
							InutilLib.SetTimer( j*15,function()
								yandereWaifu.ThrowDarkKnife(player, player.Position, Vector.FromAngle(angle + i * hasWiz):Resized(15))
							end)
						end
					end
				--	yandereWaifu.GetEntityData(target).Heretic = true
					beam.DisableFollowParent = true
					for i, ent in pairs (Isaac.GetRoomEntities()) do
						if ent.Type == EntityType.ENTITY_EFFECT and ent.Variant == RebekahCurse.ENTITY_EVILORB then
							for i2 = -15, 15, 30 do
								local extrabeam = player:FireBrimstone( Vector.FromAngle(InutilLib.ObjToTargetAngle(ludoTear, ent, true)+ i2 * hasWiz), player, 2):ToLaser();
								extrabeam.Position = ludoTear.Position
								extrabeam.MaxDistance = ludoTear.Position:Distance(ent.Position)
								extrabeam.DisableFollowParent = true
								yandereWaifu.GetEntityData(ent).Heretic = true
								extrabeam:SetColor(Color(0,0,0,1,0.8,0,1),9999999,99,false,false)
								extrabeam.DepthOffset = -400
								yandereWaifu.GetEntityData(extrabeam).IsEvil = true
								if player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_KNIFE) then
									for j = 1, 5 do
										InutilLib.SetTimer( j*15,function()
											yandereWaifu.ThrowDarkKnife(player, ludoTear.Position, Vector.FromAngle(InutilLib.ObjToTargetAngle(ludoTear, ent, true) + i2 * hasWiz):Resized(15))
										end)
									end
								end
								if hasWiz == 0 then break end
							end
						end
					end
				else
					if target then --aims then to the furthest orb
						angle = InutilLib.ObjToTargetAngle(player, target, true)
						beam = player:FireBrimstone( Vector.FromAngle(angle + i * hasWiz), player, 2):ToLaser();
						beam.MaxDistance = nearestOrb
						yandereWaifu.GetEntityData(target).Heretic = true
						beam.DisableFollowParent = true
						yandereWaifu.GetEntityData(beam).IsEvil = true
						beam.DepthOffset = -400
						if player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_KNIFE) then
							for j = 1, 5 do
								InutilLib.SetTimer( j*15,function()
									yandereWaifu.ThrowDarkKnife(player, player.Position, Vector.FromAngle(angle + i * hasWiz):Resized(15))
								end)
							end
						end
					else
						beam = player:FireBrimstone( Vector.FromAngle(angle + i * hasWiz), player, 2):ToLaser();
						beam.MaxDistance = 150
						beam.DepthOffset = -400
						yandereWaifu.GetEntityData(beam).IsEvil = true
						if player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_KNIFE) then
							for j = 1, 5 do
								InutilLib.SetTimer( j*15,function()
									yandereWaifu.ThrowDarkKnife(player, player.Position, Vector.FromAngle(angle + i * hasWiz):Resized(15))
								end)
							end
						end
					end
				end
				beam.Timeout = 20
				--EntityLaser.ShootAngle(1, player.Position, angle, 10, Vector(0,10), player):ToLaser()
				beam:SetColor(Color(0,0,0,1,0.8,0,1),9999999,99,false,false)
				beam.CollisionDamage = player.Damage * (3);
				beam.DisableFollowParent = true
				if hasWiz == 0 then break end
			end
			yandereWaifu.SpawnPoofParticle( player.Position, Vector( 0, 0 ), player, RebekahPoofParticleType.Black );
			InutilLib.SFX:Play( SoundEffect.SOUND_MONSTER_GRUNT_0, 1, 0, false, 1.2 );
			EndBarrage()
			--player:GetEffects():RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_PAUSE, -1)
			for k, v in pairs (Isaac.GetRoomEntities()) do
				v:ClearEntityFlags(EntityFlag.FLAG_SLOW)
			end
			data.tintEffect:Remove()
			data.tintEffect = nil
			yandereWaifu.RebekahCanShoot(player, true)
			player.FireDelay = 60
			data.FinishedPlayingCustomAnim = nil
			
			yandereWaifu.PlayAllEvilGuns(player, 0)
			InutilLib.SetTimer( 30*9, function()
				yandereWaifu.RemoveEvilGun(player)
			end)
		else
			if not data.tintEffect then
				data.tintEffect = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_BACKGROUNDTINT, 0, player.Position, Vector.Zero, nil):ToEffect()
				data.tintEffect.RenderZOffset = -10
				yandereWaifu.RebekahCanShoot(player, false)
			end
			for k, v in pairs (Isaac.GetRoomEntities()) do
				if v.Type ~= 1000 and v.Type ~= 1 and v.Type ~= 8 then
					v:AddEntityFlags(EntityFlag.FLAG_SLOW)
				end
			end
			if player.FrameCount % 3 == 0 then
				yandereWaifu.SpawnHeartParticles( 1, 2, player.Position, yandereWaifu.RandomHeartParticleVelocity(), player, RebekahHeartParticleType.Evil );
			end
			if not data.extraHugsEvil then
				local gun = yandereWaifu.SpawnEvilGun(player, Vector.FromAngle(direction:GetAngleDegrees())*(20), true)
				yandereWaifu.GetEntityData(gun).StartCountFrame = 1
			else
				local canModifyGunsGeneral = data.extraHugsEvil and (#data.extraHugsEvil > 0 --[[and data.canModifyGuns]])
				if canModifyGunsGeneral then
					local gunIdle = true
					for k, v in pairs(data.extraHugsEvil) do
						if v:GetSprite():IsPlaying("Startup") or v:GetSprite():IsPlaying("Spawn") or InutilLib.IsPlayingMultiple(v:GetSprite(), "ShootRightTech", "ShootLeftTech", "ShootDownTech", "ShootUpTech",  "ShootRightBrimstone", "ShootLeftBrimstone", "ShootDownBrimstone", "ShootUpBrimstone") then
							gunIdle = false
							break
						end
					end	
					if gunIdle then
						data.BarrageIntro = true
					end
				end
			end
		end
	elseif modes == REBECCA_MODE.EternalHearts then
		--setup of eternal personality's gun effects and barrage
		if not data.MainArcaneCircle then
			data.MainArcaneCircle = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_ARCANE_CIRCLE, 1, player.Position,  Vector.Zero, nil)
			yandereWaifu.GetEntityData(data.MainArcaneCircle).parent = player
			for i = 0, 8 do
				data.MainArcaneCircle:GetSprite():ReplaceSpritesheet(i, "gfx/effects/eternal/arcane_circle.png")
			end
			data.MainArcaneCircle:GetSprite():LoadGraphics()
			data.ArcaneCircleDust = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_REBEKAH_DUST, 4, player.Position, Vector.Zero, player)
			data.ArcaneCircleDust.RenderZOffset = -1
			yandereWaifu.GetEntityData(data.ArcaneCircleDust).Parent = player
		end
		--do the weird animation first before firing the beam
		if data.BarrageIntro then
			yandereWaifu.RebekahEternalBarrage(player, direction)
			EndBarrage()
			
			--make guns play
			for k, v in pairs (Isaac.GetRoomEntities()) do
				v:ClearEntityFlags(EntityFlag.FLAG_SLOW)
			end
			data.tintEffect:Remove()
			data.tintEffect = nil
			player.FireDelay = 60
			data.FinishedPlayingCustomAnim = nil
			
			yandereWaifu.PlayAllEternalGuns(player, 0)
			InutilLib.SetTimer( 30*9, function()
				yandereWaifu.RemoveEternalGun(player)
			end)
		else
			if not data.tintEffect then
				data.tintEffect = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_BACKGROUNDTINT, 0, player.Position, Vector.Zero, nil):ToEffect()
				data.tintEffect.RenderZOffset = -10
			end
			for k, v in pairs (Isaac.GetRoomEntities()) do
				if v.Type ~= 1000 and v.Type ~= 1 and v.Type ~= 8 then
					v:AddEntityFlags(EntityFlag.FLAG_SLOW)
				end
			end
			if player.FrameCount % 3 == 0 then
				yandereWaifu.SpawnHeartParticles( 1, 2, player.Position, yandereWaifu.RandomHeartParticleVelocity(), player, RebekahHeartParticleType.Evil );
			end
			if not data.extraHugsEternal then
				local gun = yandereWaifu.SpawnEternalGun(player, Vector.FromAngle(direction:GetAngleDegrees())*(20), true)
				yandereWaifu.GetEntityData(gun).StartCountFrame = 1
			else
				local canModifyGunsGeneral = data.extraHugsEternal and (#data.extraHugsEternal > 0 --[[and data.canModifyGuns]])
				if canModifyGunsGeneral then
					local gunIdle = true
					for k, v in pairs(data.extraHugsEternal) do
						if v:GetSprite():IsPlaying("Startup") or v:GetSprite():IsPlaying("Spawn") or InutilLib.IsPlayingMultiple(v:GetSprite(), "ShootRightTech", "ShootLeftTech", "ShootDownTech", "ShootUpTech",  "ShootRightBrimstone", "ShootLeftBrimstone", "ShootDownBrimstone", "ShootUpBrimstone") then
							gunIdle = false
							break
						end
					end	
					if gunIdle then
						data.BarrageIntro = true
					end
				end
			end
		end
	elseif modes == REBECCA_MODE.BoneHearts then
		yandereWaifu.RebekahBoneBarrage(player, direction)
	elseif modes == REBECCA_MODE.RottenHearts then
		yandereWaifu.RebekahRottenBarrage(player, direction)
		EndBarrage()
	elseif modes == REBECCA_MODE.BrokenHearts then
		if data.mainGlitch then
			if not data.mainGlitch:Exists() then
				data.mainGlitch = nil 
			end
		end
		if not data.mainGlitch then
			local customBody = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_EXTRACHARANIMHELPER, 0, player.Position, Vector(0,0), nil) --body effect
			yandereWaifu.GetEntityData(customBody).Player = player
			yandereWaifu.GetEntityData(customBody).DontFollowPlayer = true
			yandereWaifu.GetEntityData(customBody).DashBrokenGlitch = true
			data.mainGlitch = customBody
		else
			data.mainGlitch:Remove()
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
		EndBarrage()
	elseif modes == REBECCA_MODE.BrideRedHearts then

		if not data.redcountdownFrames then data.redcountdownFrames = 0 end
		if not data.addedbarrageangle then data.addedbarrageangle = 0 data.addedbarrageangle2 = 0 end --incase if nil
		if not data.Xsize then data.Xsize = 0 end

		data.redcountdownFrames = data.redcountdownFrames + 1
	
		local angle = player.Velocity:GetAngleDegrees()
		
		--barrage angle modifications are here :3
		if data.redcountdownFrames % 2 then
			if data.redcountdownFrames == 0 then
				data.addedbarrageangle = 0
				data.addedbarrageangle2 = 0
			elseif data.redcountdownFrames > 1 and data.redcountdownFrames < 10 then
				data.addedbarrageangle = data.addedbarrageangle - 1
				data.addedbarrageangle2 = data.addedbarrageangle2 + 1
				data.Xsize = data.Xsize + 1
			elseif data.redcountdownFrames > 10 and data.redcountdownFrames < 20 then
				data.addedbarrageangle = data.addedbarrageangle + 2
				data.addedbarrageangle2 = data.addedbarrageangle2 - 2
				data.Xsize = data.Xsize + 2
			elseif data.redcountdownFrames > 20 and data.redcountdownFrames < 30 then
				data.addedbarrageangle = data.addedbarrageangle - 2
				data.addedbarrageangle2 = data.addedbarrageangle2 + 2
				data.Xsize = data.Xsize + 4
			elseif data.redcountdownFrames > 30 and data.redcountdownFrames < 40 then
				data.addedbarrageangle = data.addedbarrageangle + 4
				data.addedbarrageangle2 = data.addedbarrageangle2 - 4
				data.Xsize = data.Xsize + 6
			else
				data.addedbarrageangle = 0
				data.addedbarrageangle2 = 0
				data.Xsize = 0
			end
		end
		local modulusnum = math.ceil((player.MaxFireDelay/5))
		--print(tostring(data.redcountdownFrames % modulusnum))
		if player:HasWeaponType(WeaponType.WEAPON_ROCKETS) then --rocket synergy
			Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_ORBITALTARGET, 0, player.Position,  Vector.FromAngle(direction:GetAngleDegrees())*(9), player)
		elseif player:HasWeaponType(WeaponType.WEAPON_KNIFE) then --slashing time! knife effect
			if data.redcountdownFrames == 1 then
				local cut = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_SLASH, 0, player.Position+Vector.FromAngle(direction:GetAngleDegrees()):Resized(40), Vector(0,0), player);
				player.ControlsEnabled = false;
			elseif data.redcountdownFrames >= 1 and data.redcountdownFrames < 40 and data.redcountdownFrames % modulusnum == (0) then
				player.Velocity = ( player.Velocity * 0.8 ) + Vector.FromAngle( direction:GetAngleDegrees() );
				InutilLib.SFX:Play( SoundEffect.SOUND_BIRD_FLAP, 1, 0, false, 1.5 );
			elseif data.redcountdownFrames == 40 then
				player.ControlsEnabled = true;
			end
		elseif player:HasWeaponType(WeaponType.WEAPON_BOMBS) or player:HasWeaponType(WeaponType.WEAPON_BRIMSTONE) then
			if player:HasWeaponType(WeaponType.WEAPON_BOMBS) then
				if data.redcountdownFrames == 1 then
					--local bomb = player:FireBomb(player.Position, Vector.FromAngle(direction:GetAngleDegrees())*(3))
					local bomb = Isaac.Spawn(EntityType.ENTITY_BOMBDROP, 0, 0, player.Position,  Vector.FromAngle(direction:GetAngleDegrees()):Resized( 9 ), player);
					yandereWaifu.GetEntityData(bomb).IsByAFanGirl = true; --makes sure that it's Rebecca's bombs
					bomb:ToBomb();
					--bomb:GetSprite():ReplaceSpritesheet(0, "gfx/effects/bomb_rebeccawantsisaacalittlebittoomuch.png");
					bomb:GetSprite():LoadGraphics();
				elseif data.redcountdownFrames >= 40 then
				end
			--bomb.RadiusMultiplier = 3
			end
			if player:HasWeaponType(WeaponType.WEAPON_BRIMSTONE) then
				if data.redcountdownFrames >= 1 and data.redcountdownFrames < 40 and data.redcountdownFrames % modulusnum == (0) then
					local brim = player:FireBrimstone( Vector.FromAngle( direction:GetAngleDegrees() - 45 ):Resized( REBEKAH_BALANCE.RED_HEART_ATTACK_BRIMSTONE_SIZE ) ):ToLaser();
					brim:SetActiveRotation( 0, 135, 10, false );
					local brim2 = player:FireBrimstone( Vector.FromAngle( direction:GetAngleDegrees() + 45 ):Resized( REBEKAH_BALANCE.RED_HEART_ATTACK_BRIMSTONE_SIZE ) ):ToLaser();
					brim2:SetActiveRotation( 0, -135, -10, false );
				elseif data.redcountdownFrames >= 40 then
				end
			end
		elseif player:HasWeaponType(WeaponType.WEAPON_LASER) then --tech barrage
			if data.redcountdownFrames >= 1 and data.redcountdownFrames < 40 and data.redcountdownFrames*4 % modulusnum == (0) then
				local randomAngleperLaser = math.random(0,45)
				for i = 0, 360-360/8, 360/8 do
					local techlaser = player:FireTechLaser(player.Position, 0, Vector.FromAngle(i + randomAngleperLaser), false, true)
					techlaser.OneHit = true;
					techlaser.Timeout = 1;
					techlaser.CollisionDamage = player.Damage * 2;
					techlaser:SetHomingType(1)
					--techlaser.Damage = player.Damage * 5 doesn't exist lol
				end
			elseif data.redcountdownFrames >= 40 then
			end
		else

			if data.redcountdownFrames == 1 then
				--direction:GetAngleDegrees() = angle
			elseif data.redcountdownFrames >= 1 and data.redcountdownFrames < 40 and data.redcountdownFrames % modulusnum == (0) then
				player.Velocity = player.Velocity * 0.8 --slow him down
				--print("josh")
				if player:HasWeaponType(WeaponType.WEAPON_TECH_X) then
					local circle = player:FireTechXLaser(player.Position, Vector.FromAngle(data.addedbarrageangle + direction:GetAngleDegrees())*(20), data.Xsize)
				else
					local tears = player:FireTear(player.Position, Vector.FromAngle(data.addedbarrageangle + direction:GetAngleDegrees())*(20), false, false, false)
					tears.Position = player.Position
				end
				InutilLib.SFX:Play(SoundEffect.SOUND_TEARS_FIRE, 1, 0, false, 1.2)
				if player.MaxFireDelay <= 5 and player.MaxFireDelay > 1 then
					if player:HasWeaponType(WeaponType.WEAPON_TECH_X) then
						local circle = player:FireTechXLaser(player.Position, Vector.FromAngle(data.addedbarrageangle2 + direction:GetAngleDegrees())*(20), data.Xsize)
					else
						local tears = player:FireTear(player.Position, Vector.FromAngle((data.addedbarrageangle2) + direction:GetAngleDegrees())*(20), false, false, false)
						tears.Position = player.Position
					end
				end
				if player.MaxFireDelay == 1 then
					if player:HasWeaponType(WeaponType.WEAPON_TECH_X) then
						local circle = player:FireTechXLaser(player.Position, Vector.FromAngle((data.addedbarrageangle2) - direction:GetAngleDegrees())*(20), data.Xsize)
					else
						local tears = player:FireTear(player.Position, Vector.FromAngle(direction:GetAngleDegrees())*(20), false, false, false)
						tears.Position = player.Position
					end
				end
				local curAng -- marks the current angle for the spread tears! then we add here to make it move or something around those lines lol
				if player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_MUTANT_SPIDER) and player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_INNER_EYE) then
					curAng = -40
					numofShots = 7
				elseif player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_MUTANT_SPIDER) then
					curAng = -30
					numofShots = 4
				elseif player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_INNER_EYE) then
					curAng = -20
					numofShots = 3
				end
				if player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_MUTANT_SPIDER) or player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_INNER_EYE) then
					for i = 1, numofShots, 1 do
						curAng = curAng + 10
						if player:HasWeaponType(WeaponType.WEAPON_TECH_X) then
							local circle = player:FireTechXLaser(player.Position, Vector.FromAngle((data.addedbarrageangle2) - direction:GetAngleDegrees())*(20), data.Xsize)
						else
							local tears = player:FireTear(player.Position, Vector.FromAngle(direction:GetAngleDegrees() + curAng)*(15), false, false, false)
							tears.Position = player.Position
						end
					end
				end
				if player:HasWeaponType(WeaponType.WEAPON_MONSTROS_LUNGS) then
				local chosenNumofBarrage =  math.random(10,20)
					for i = 1, chosenNumofBarrage do
						local tear = player:FireTear(player.Position, Vector.FromAngle(direction:GetAngleDegrees() - math.random(-10,10))*(math.random(10,15)), false, false, false):ToTear()
						tear.Position = player.Position
						tear.Scale = math.random(07,14)/10
						tear.FallingSpeed = -10 + math.random(1,3)
						tear.FallingAcceleration = 0.5
						tear.CollisionDamage = player.Damage * 4.3
						--tear.BaseDamage = player.Damage * 2
					end
				end
			elseif data.redcountdownFrames >= 40 then
				data.redcountdownFrames = 0 
				yandereWaifu.SpawnHeartParticles( 3, 5, player.Position, yandereWaifu.RandomHeartParticleVelocity(), player, RebekahHeartParticleType.Red );
			end
		end
	end
end

yandereWaifu:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, damage, amount, damageFlag, damageSource, damageCountdownFrames) --invincibilityframe when dashing or whatnot
	local player = damage:ToPlayer();
	local data = yandereWaifu.GetEntityData(player)

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
				ILIB.game:ShakeScreen(5);
				InutilLib.SFX:Play( SoundEffect.SOUND_FORESTBOSS_STOMPS, 1, 0, false, 1 );
				damage:Kill()
			else
				data.tankAmount = data.tankAmount + 1
				return false
			end
		end
		
		if data.Parry then --tilde parry effect
			if data.Parry:GetSprite():IsPlaying("Parry") and data.Parry:GetSprite():WasEventTriggered("Parry") and not data.Parry:GetSprite():WasEventTriggered("StopParry") then
				data.Parry:GetSprite():Play("SuccessLoop")
				data.IsParryInvul = true
				InutilLib.SFX:Play( SoundEffect.SOUND_THUMBSUP_AMPLIFIED, 0.7, 0, false, 0.5 );
				return false
			elseif data.Parry:GetSprite():IsPlaying("Parry") and data.Parry:GetSprite():WasEventTriggered("Parry") and data.Parry:GetSprite():WasEventTriggered("StopParry") then --missed parry
				data.Parry:GetSprite():Play("Fail")
				InutilLib.SFX:Play( SoundEffect.SOUND_THUMBSDOWN_AMPLIFIED, 0.7, 0, false, 0.5 );
			end
		end
		
		if data.IsLeftover then
			return false
		end
		
		if data.IsParryInvul then
			ILIB.game:ShakeScreen(5);
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
