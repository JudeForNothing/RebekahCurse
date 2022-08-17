local barrage = {}

function yandereWaifu.EndRebekahBarrage(player, data)
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

function yandereWaifu.EndRebekahBarrageIfValid(player, data) --used if autocollectible is true and needed	
	if yandereWaifu.HasAutoCollectible(player) then
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

function yandereWaifu.SetRedRebekahBarrage(player, data, direction)
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
	function yandereWaifu.IsValidRedBarrage()
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
	if yandereWaifu.HasAutoCollectible(player) then
		if (player:GetShootingInput().X ~= 0 or player:GetShootingInput().Y ~= 0) then
			if data.chargeDelay < player.MaxFireDelay then
				data.chargeDelay = data.chargeDelay + 1
			end
		else
			--if data.redcountdownFrames >= 40 then
			--	print("pslc")
			--	yandereWaifu.EndRebekahBarrageIfValid(player, data)
			--end
		end
	end
	
	data.barrageNumofShots = numofShots --initial num of shots added in
	if yandereWaifu.HasChargeCollectibles(player) then
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
	if yandereWaifu.IsValidRedBarrage() then
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
						
				if yandereWaifu.IsValidRedBarrage() then
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
					yandereWaifu.EndRebekahBarrageIfValid(player, data)
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
				--slow down rebekah
				player.Velocity = player.Velocity * 0.8
				local gunIdle = true
				if not data.FinishedPlayingCustomAnim then
					gunIdle = false
				end

				if gunIdle then
					--player:GetEffects():RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_PAUSE, -1)
					--[[for k, v in pairs (Isaac.GetRoomEntities()) do
						v:ClearEntityFlags(EntityFlag.FLAG_SLOW)
					end]]
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
					--[[for k, v in pairs (Isaac.GetRoomEntities()) do
						if v.Type ~= 1000 and v.Type ~= 1 and v.Type ~= 8 then
							v:AddEntityFlags(EntityFlag.FLAG_SLOW)
						end
					end]]
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

			yandereWaifu.RebekahRedNormalBarrage(player, data, direction, endFrameCount, numofShots, tearSize)
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
					--[[for k, v in pairs (Isaac.GetRoomEntities()) do
						v:ClearEntityFlags(EntityFlag.FLAG_SLOW)
					end]]
					data.canModifyGuns = nil
					data.tintEffect:Remove()
					data.tintEffect = nil
					data.FinishedPlayingCustomAnim = nil
					yandereWaifu.RebekahCanShoot(player, true)
					player.FireDelay = 60
					data.isPlayingCustomAnim = false
				else
					if not data.tintEffect then
						data.tintEffect = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_BACKGROUNDTINT, 0, player.Position, Vector.Zero, nil):ToEffect()
						data.tintEffect.RenderZOffset = -10
						yandereWaifu.RebekahCanShoot(player, false)
						data.isPlayingCustomAnim = true
					end
					
					--[[for k, v in pairs (Isaac.GetRoomEntities()) do
						if v.Type ~= 1000 and v.Type ~= 1 and v.Type ~= 8 then
							v:AddEntityFlags(EntityFlag.FLAG_SLOW)
						end
					end]]
					yandereWaifu.SpawnHeartParticles( 2, 4, player.Position, yandereWaifu.RandomHeartParticleVelocity(), player, RebekahHeartParticleType.Red );
					--we need to freeze the player
					--player.Position = player.Position
					--player.Velocity = Vector.Zero
					player.FireDelay = 60
				end
			end
		end
	end
end

function yandereWaifu.SetSoulRebekahBarrage(player, data, direction)
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
	
	if yandereWaifu.HasChargeCollectibles(player) then
		if (player:GetShootingInput().X ~= 0 or player:GetShootingInput().Y ~= 0) and not data.barrageInit then
			if not data.chargeDelay then data.chargeDelay = 0 end
			if data.chargeDelay < player.MaxFireDelay * 3 then
				data.chargeDelay = data.chargeDelay + 0.1
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
	
	function yandereWaifu.SoulLeadPencilBarrage()
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
	
	function yandereWaifu.FireSoulKnife(pos, dir)
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
		yandereWaifu.RebekahSoulNormalBarrage(player, data, player:GetShootingInput(), endFrameCount, modulusnum, extraTearDmg)
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
			
			--[[for k, v in pairs (Isaac.GetRoomEntities()) do
				v:ClearEntityFlags(EntityFlag.FLAG_SLOW)
			end]]
			data.tintEffect:Remove()
			data.tintEffect = nil
			yandereWaifu.RebekahCanShoot(player, true)
			player.FireDelay = 30
		end
	end
end

function yandereWaifu.SetGoldRebekahBarrage(player, data, direction)
--setup of gold personality's gun effects and barrage
	if not data.MainArcaneCircle then
		data.MainArcaneCircle = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_ARCANE_CIRCLE, 1, player.Position,  Vector.Zero, nil)
		yandereWaifu.GetEntityData(data.MainArcaneCircle).parent = player
		for i = 0, 8 do
			data.MainArcaneCircle:GetSprite():ReplaceSpritesheet(i, "gfx/effects/gold/arcane_circle.png")
		end
		data.MainArcaneCircle:GetSprite():LoadGraphics()
		data.ArcaneCircleDust = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_REBEKAH_DUST, 4, player.Position, Vector.Zero, player)
		data.ArcaneCircleDust.RenderZOffset = -1
		yandereWaifu.GetEntityData(data.ArcaneCircleDust).Parent = player
	end
	--do the weird animation first before firing the beam
	if data.BarrageIntro then
		yandereWaifu.RebekahGoldBarrage(player, direction)
		yandereWaifu.EndRebekahBarrage(player, data)
		InutilLib.SFX:Play( SoundEffect.SOUND_COIN_SLOT, 1, 0, false, 1 );
		--make guns play
		--[[for k, v in pairs (Isaac.GetRoomEntities()) do
			v:ClearEntityFlags(EntityFlag.FLAG_SLOW)
		end]]
		data.tintEffect:Remove()
		data.tintEffect = nil
		player.FireDelay = 60
		data.FinishedPlayingCustomAnim = nil
		
		yandereWaifu.PlayAllGoldGuns(player, 0)
		InutilLib.SetTimer( 30*9, function()
			yandereWaifu.RemoveGoldGun(player)
		end)
	else
		if not data.tintEffect then
			data.tintEffect = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_BACKGROUNDTINT, 0, player.Position, Vector.Zero, nil):ToEffect()
			data.tintEffect.RenderZOffset = -10
			data.isPlayingCustomAnim = true
		end
		--[[for k, v in pairs (Isaac.GetRoomEntities()) do
			if v.Type ~= 1000 and v.Type ~= 1 and v.Type ~= 8 then
				v:AddEntityFlags(EntityFlag.FLAG_SLOW)
			end
		end]]
		if player.FrameCount % 3 == 0 then
			yandereWaifu.SpawnHeartParticles( 1, 2, player.Position, yandereWaifu.RandomHeartParticleVelocity(), player, RebekahHeartParticleType.Evil );
		end
		if not data.extraHugsGold then
			local gun = yandereWaifu.SpawnGoldGun(player, Vector.FromAngle(direction:GetAngleDegrees())*(20), true)
			yandereWaifu.GetEntityData(gun).StartCountFrame = 1
		else
			local canModifyGunsGeneral = data.extraHugsGold and (#data.extraHugsGold > 0 --[[and data.canModifyGuns]])
			if canModifyGunsGeneral then
				local gunIdle = true
				for k, v in pairs(data.extraHugsGold) do
					if v:GetSprite():IsPlaying("Startup") or v:GetSprite():IsPlaying("Spawn") or InutilLib.IsPlayingMultiple(v:GetSprite(), "ShootRightTech", "ShootLeftTech", "ShootDownTech", "ShootUpTech",  "ShootRightBrimstone", "ShootLeftBrimstone", "ShootDownBrimstone", "ShootUpBrimstone") then
						gunIdle = false
						break
					end
				end	
				if gunIdle then
					data.BarrageIntro = true
					data.isPlayingCustomAnim = false
				end
			end
		end
	end
end

function yandereWaifu.SetEvilRebekahBarrage(player, data, direction)
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
		yandereWaifu.EndRebekahBarrage(player, data)
		--player:GetEffects():RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_PAUSE, -1)
		--[[for k, v in pairs (Isaac.GetRoomEntities()) do
			v:ClearEntityFlags(EntityFlag.FLAG_SLOW)
		end]]
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
			data.isPlayingCustomAnim = true
		end
		--[[for k, v in pairs (Isaac.GetRoomEntities()) do
			if v.Type ~= 1000 and v.Type ~= 1 and v.Type ~= 8 then
				v:AddEntityFlags(EntityFlag.FLAG_SLOW)
			end
		end]]
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
					data.isPlayingCustomAnim = false
				end
			end
		end
	end
end

function yandereWaifu.SetEternalRebekahBarrage(player, data, direction)
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
		yandereWaifu.EndRebekahBarrage(player, data)
		
		--make guns play
		--[[for k, v in pairs (Isaac.GetRoomEntities()) do
			v:ClearEntityFlags(EntityFlag.FLAG_SLOW)
		end]]
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
			data.isPlayingCustomAnim = true
		end
		--[[for k, v in pairs (Isaac.GetRoomEntities()) do
			if v.Type ~= 1000 and v.Type ~= 1 and v.Type ~= 8 then
				v:AddEntityFlags(EntityFlag.FLAG_SLOW)
			end
		end]]
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
					data.isPlayingCustomAnim = false
				end
			end
		end
	end
end

function yandereWaifu.SetBoneRebekahBarrage(player, data, direction)
--setup of Bone personality's gun effects and barrage
		
	if not data.hasLeech then
		if not data.MainArcaneCircle then
			data.MainArcaneCircle = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_ARCANE_CIRCLE, 1, player.Position,  Vector.Zero, nil)
			yandereWaifu.GetEntityData(data.MainArcaneCircle).parent = player
			for i = 0, 8 do
				data.MainArcaneCircle:GetSprite():ReplaceSpritesheet(i, "gfx/effects/bone/arcane_circle.png")
			end
			data.MainArcaneCircle:GetSprite():LoadGraphics()
			data.ArcaneCircleDust = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_REBEKAH_DUST, 4, player.Position, Vector.Zero, player)
			data.ArcaneCircleDust.RenderZOffset = -1
			yandereWaifu.GetEntityData(data.ArcaneCircleDust).Parent = player
		end
		--do the weird animation first before firing the beam
		if data.BarrageIntro then
			yandereWaifu.RebekahBoneBarrage(player, direction)
			
			--make guns play
			--[[for k, v in pairs (Isaac.GetRoomEntities()) do
				v:ClearEntityFlags(EntityFlag.FLAG_SLOW)
			end]]
			data.tintEffect:Remove()
			data.tintEffect = nil
			data.MainArcaneCircle:Remove()
			data.ArcaneCircleDust:Remove()
			player.FireDelay = 60
			data.FinishedPlayingCustomAnim = nil
			
			yandereWaifu.RemoveBoneGun(player)
		else
			if not data.tintEffect then
				data.tintEffect = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_BACKGROUNDTINT, 0, player.Position, Vector.Zero, nil):ToEffect()
				data.tintEffect.RenderZOffset = -10
				data.isPlayingCustomAnim = true
			end
			--[[for k, v in pairs (Isaac.GetRoomEntities()) do
				if v.Type ~= 1000 and v.Type ~= 1 and v.Type ~= 8 then
					v:AddEntityFlags(EntityFlag.FLAG_SLOW)
				end
			end]]
			player.Velocity = Vector.Zero
			player.Position = player.Position
			data.invincibleTime = 30
			if player.FrameCount % 3 == 0 then
				yandereWaifu.SpawnHeartParticles( 1, 2, player.Position, yandereWaifu.RandomHeartParticleVelocity(), player, RebekahHeartParticleType.Bone );
			end
			if not data.extraHugsBone then
				local gun = yandereWaifu.SpawnBoneGun(player, Vector.FromAngle(direction:GetAngleDegrees())*(20), true)
				yandereWaifu.GetEntityData(gun).StartCountFrame = 1
			else
				local canModifyGunsGeneral = data.extraHugsBone and (#data.extraHugsBone > 0 --[[and data.canModifyGuns]])
				if canModifyGunsGeneral then
					local gunIdle = true
					for k, v in pairs(data.extraHugsBone) do
						if v:GetSprite():IsPlaying("Startup") then
							gunIdle = false
							break
						end
					end	
					if gunIdle then
						data.BarrageIntro = true
						data.isPlayingCustomAnim = false
					end
				end
			end
		end
	else
		yandereWaifu.RebekahBoneBarrage(player, direction)
	end
end

function yandereWaifu.SetRottenRebekahBarrage(player, data, direction)
	--setup of rotten personality's gun effects and barrage
	if not data.MainArcaneCircle then
		data.MainArcaneCircle = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_ARCANE_CIRCLE, 1, player.Position,  Vector.Zero, nil)
		yandereWaifu.GetEntityData(data.MainArcaneCircle).parent = player
		for i = 0, 8 do
			data.MainArcaneCircle:GetSprite():ReplaceSpritesheet(i, "gfx/effects/rotten/arcane_circle.png")
		end
		data.MainArcaneCircle:GetSprite():LoadGraphics()
		data.ArcaneCircleDust = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_REBEKAH_DUST, 4, player.Position, Vector.Zero, player)
		data.ArcaneCircleDust.RenderZOffset = -1
		yandereWaifu.GetEntityData(data.ArcaneCircleDust).Parent = player
	end
	--do the weird animation first before firing the beam
	if data.BarrageIntro then
		yandereWaifu.RebekahRottenBarrage(player, direction)
		yandereWaifu.EndRebekahBarrage(player, data)
		InutilLib.SFX:Play( SoundEffect.SOUND_COIN_SLOT, 1, 0, false, 1 );
		--make guns play
		--[[for k, v in pairs (Isaac.GetRoomEntities()) do
			v:ClearEntityFlags(EntityFlag.FLAG_SLOW)
		end]]
		data.tintEffect:Remove()
		data.tintEffect = nil
		player.FireDelay = 60
		data.FinishedPlayingCustomAnim = nil
		
		yandereWaifu.PlayAllRottenGuns(player, 0)
		InutilLib.SetTimer( 30*9, function()
			yandereWaifu.RemoveRottenGun(player)
		end)
	else
		if not data.tintEffect then
			data.tintEffect = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_BACKGROUNDTINT, 0, player.Position, Vector.Zero, nil):ToEffect()
			data.tintEffect.RenderZOffset = -10
			data.isPlayingCustomAnim = true
		end
		--[[for k, v in pairs (Isaac.GetRoomEntities()) do
			if v.Type ~= 1000 and v.Type ~= 1 and v.Type ~= 8 then
				v:AddEntityFlags(EntityFlag.FLAG_SLOW)
			end
		end]]
		if player.FrameCount % 3 == 0 then
			yandereWaifu.SpawnHeartParticles( 1, 2, player.Position, yandereWaifu.RandomHeartParticleVelocity(), player, RebekahHeartParticleType.Evil );
		end
		if not data.extraHugsRotten then
			local gun = yandereWaifu.SpawnRottenGun(player, Vector.FromAngle(direction:GetAngleDegrees())*(20), true)
			yandereWaifu.GetEntityData(gun).StartCountFrame = 1
		else
			local canModifyGunsGeneral = data.extraHugsRotten and (#data.extraHugsRotten > 0 --[[and data.canModifyGuns]])
			if canModifyGunsGeneral then
				local gunIdle = true
				for k, v in pairs(data.extraHugsRotten) do
					if v:GetSprite():IsPlaying("Startup") or v:GetSprite():IsPlaying("Spawn") or InutilLib.IsPlayingMultiple(v:GetSprite(), "ShootRightTech", "ShootLeftTech", "ShootDownTech", "ShootUpTech",  "ShootRightBrimstone", "ShootLeftBrimstone", "ShootDownBrimstone", "ShootUpBrimstone") then
						gunIdle = false
						break
					end
				end	
				if gunIdle then
					data.BarrageIntro = true
					data.isPlayingCustomAnim = false
				end
			end
		end
	end
end

function yandereWaifu.SetBrokenRebekahBarrage(player, data, direction)
	player:UseActiveItem(CollectibleType.COLLECTIBLE_DATAMINER, true, false, false, false, -1)
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
		yandereWaifu.EndRebekahBarrage(player, data)
end

function barrage.SetRebekahBarragesInit(player, modes, data, direction)
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
		yandereWaifu.SetRedRebekahBarrage(player, data, direction)
	elseif modes == REBECCA_MODE.SoulHearts then
		yandereWaifu.SetSoulRebekahBarrage(player, data, direction)
	elseif modes == REBECCA_MODE.GoldHearts then
		yandereWaifu.SetGoldRebekahBarrage(player, data, direction)
	elseif modes == REBECCA_MODE.EvilHearts then
		yandereWaifu.SetEvilRebekahBarrage(player, data, direction)
	elseif modes == REBECCA_MODE.EternalHearts then
		yandereWaifu.SetEternalRebekahBarrage(player, data, direction)
	elseif modes == REBECCA_MODE.BoneHearts then
		yandereWaifu.SetBoneRebekahBarrage(player, data, direction)
	elseif modes == REBECCA_MODE.RottenHearts then
		yandereWaifu.SetRottenRebekahBarrage(player, data, direction)
	elseif modes == REBECCA_MODE.BrokenHearts then
		yandereWaifu.SetBrokenRebekahBarrage(player, data, direction)
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
	elseif modes == REBECCA_MODE.ImmortalHearts then
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
			yandereWaifu.RebekahImmortalBarrage(player, direction)
			yandereWaifu.EndRebekahBarrage(player, data)
			
			--make guns play
			--[[for k, v in pairs (Isaac.GetRoomEntities()) do
				v:ClearEntityFlags(EntityFlag.FLAG_SLOW)
			end]]
			data.tintEffect:Remove()
			data.tintEffect = nil
			player.FireDelay = 60
			data.FinishedPlayingCustomAnim = nil
			
		else
			if not data.tintEffect then
				data.tintEffect = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_BACKGROUNDTINT, 0, player.Position, Vector.Zero, nil):ToEffect()
				data.tintEffect.RenderZOffset = -10
			end
			--[[for k, v in pairs (Isaac.GetRoomEntities()) do
				if v.Type ~= 1000 and v.Type ~= 1 and v.Type ~= 8 then
					v:AddEntityFlags(EntityFlag.FLAG_SLOW)
				end
			end]]
			if player.FrameCount % 3 == 0 then
				yandereWaifu.SpawnHeartParticles( 1, 2, player.Position, yandereWaifu.RandomHeartParticleVelocity(), player, RebekahHeartParticleType.Evil );
			end
			if not data.isPlayingCustomAnim then
				local customBody = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_EXTRACHARANIMHELPER, 0, player.Position, Vector(0,0), nil) --body effect
				yandereWaifu.GetEntityData(customBody).Player = player
				yandereWaifu.GetEntityData(customBody).SummonImmortalBackup = true
				data.isPlayingCustomAnim = true
			end
		end
	end
end

return barrage