
--RED HEART MODE--
do
function yandereWaifu.RebekahRedNormalBarrage(player, data, direction, endFrameCount, numofShots, tearSize)
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
					yandereWaifu.EndRebekahBarrageIfValid(player, data)
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
					yandereWaifu.EndRebekahBarrageIfValid(player, data)
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
									InutilLib.SFX:Play(RebekahCurse.Sounds.SOUND_REDFETUS1, 1, 0, false, 1)
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
						yandereWaifu.EndRebekahBarrageIfValid(player, data)
					end
				--bomb.RadiusMultiplier = 3
				end
				if player:HasWeaponType(WeaponType.WEAPON_BRIMSTONE) then
					if yandereWaifu.IsValidRedBarrage() then
						local brim = player:FireBrimstone( Vector.FromAngle( direction:GetAngleDegrees() - 45 ):Resized( RebekahCurse.REBEKAH_BALANCE.RED_HEART_ATTACK_BRIMSTONE_SIZE ) ):ToLaser();
						brim:SetActiveRotation( 0, 135, 10, false );
						brim.Position = player.Position
						brim:AddTearFlags(player.TearFlags)
						--brim:SetColor(player.TearColor, 999, 999)
						brim.CollisionDamage = player.Damage * numofShots;
						--InutilLib.UpdateLaserSize(brim, 1)
						local brim2 = player:FireBrimstone( Vector.FromAngle( direction:GetAngleDegrees() + 45 ):Resized( RebekahCurse.REBEKAH_BALANCE.RED_HEART_ATTACK_BRIMSTONE_SIZE ) ):ToLaser();
						brim2:SetActiveRotation( 0, -135, -10, false );
						brim2.Position = player.Position
						brim2:AddTearFlags(player.TearFlags)
						--brim2:SetColor(player.TearColor 999, 999)
						brim2.CollisionDamage = player.Damage * numofShots;
						--InutilLib.UpdateLaserSize(brim2, 1)
						
						if player:HasCollectible(CollectibleType.COLLECTIBLE_EYE_SORE) and data.willEyeSoreBar then
							for i, angle in pairs(data.eyeSoreBarAngles) do
								local brim = player:FireBrimstone( Vector.FromAngle( angle - 45 ):Resized( RebekahCurse.REBEKAH_BALANCE.RED_HEART_ATTACK_BRIMSTONE_SIZE ) ):ToLaser();
								brim:SetActiveRotation( 0, 135, 10, false );
								--InutilLib.UpdateLaserSize(brim, tearSize)
								local brim2 = player:FireBrimstone( Vector.FromAngle( angle + 45 ):Resized( RebekahCurse.REBEKAH_BALANCE.RED_HEART_ATTACK_BRIMSTONE_SIZE ) ):ToLaser();
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
								local brim = player:FireBrimstone( Vector.FromAngle((-7 + (15*j))*fix + (direction:GetAngleDegrees()) - baseOffset*fix ):Resized( RebekahCurse.REBEKAH_BALANCE.RED_HEART_ATTACK_BRIMSTONE_SIZE ) ):ToLaser();
								--InutilLib.UpdateLaserSize(brim, 2)
								brim.Timeout = 30
							end
							player.Velocity = player.Velocity + (Vector.FromAngle((-7 + (15*j))*fix + (direction:GetAngleDegrees()) - baseOffset*fix + 180)*(1))*0.7
						end
						yandereWaifu.EndRebekahBarrageIfValid(player, data)
					end
				end
			elseif player:HasWeaponType(WeaponType.WEAPON_LASER) then --tech barrage
				if yandereWaifu.IsValidRedBarrage() then
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
					yandereWaifu.EndRebekahBarrageIfValid(player, data)
				end
			else --if just plain old tears
				
				if data.redcountdownFrames == 0 then

				elseif yandereWaifu.IsValidRedBarrage() then
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
								if TaintedTreasure and player:HasCollectible(TaintedCollectibles.THE_BOTTLE) then
									yandereWaifu.GetEntityData(kn).IsBottle = true
								end
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
							local kn = InutilLib.game:Spawn(EntityType.ENTITY_TEAR, 0, player.Position, Vector.FromAngle(addedbarrageangle2.addedbarrageangle + direction:GetAngleDegrees()):Resized(20), player, 0, 0):ToTear()
							kn.TearFlags = kn.TearFlags | TearFlags.TEAR_PIERCING;
							kn.CollisionDamage = player.Damage * 2;
							kn:ChangeVariant(RebekahCurse.ENTITY_REDKNIFE)
							--local knife = InutilLib.SpawnKnife(player, (data.addedbarrageangle2 + direction:GetAngleDegrees()), false, 0, SchoolbagKnifeMode.FIRE_OUT_ONLY, 1, 120)
							--yandereWaifu.GetEntityData(knife).IsRed = true
							if TaintedTreasure and player:HasCollectible(TaintedCollectibles.THE_BOTTLE) then
								yandereWaifu.GetEntityData(kn).IsBottle = true
							end
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
							local kn = InutilLib.game:Spawn(EntityType.ENTITY_TEAR, 0, player.Position, Vector.FromAngle(data.addedbarrageangle2 + direction:GetAngleDegrees()):Resized(20), player, 0, 0):ToTear()
							kn.TearFlags = kn.TearFlags | TearFlags.TEAR_PIERCING;
							kn.CollisionDamage = player.Damage * 2;
							kn:ChangeVariant(RebekahCurse.ENTITY_REDKNIFE)
							--local knife = InutilLib.SpawnKnife(player, ( direction:GetAngleDegrees()), false, 0, SchoolbagKnifeMode.FIRE_OUT_ONLY, 1, 120)
							--yandereWaifu.GetEntityData(knife).IsRed = true
							if TaintedTreasure and player:HasCollectible(TaintedCollectibles.THE_BOTTLE) then
								yandereWaifu.GetEntityData(kn).IsBottle = true
							end
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
					yandereWaifu.EndRebekahBarrageIfValid(player, data)
					data.redcountdownFrames = 0 
					yandereWaifu.SpawnHeartParticles( 3, 5, player.Position, yandereWaifu.RandomHeartParticleVelocity(), player, RebekahCurse.RebekahHeartParticleType.Red );
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
	
end

yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	if eff.SubType == 0 then
		local player = yandereWaifu.GetEntityData(eff).parent
		local sprite = eff:GetSprite();
		local playerdata = yandereWaifu.GetEntityData(player)
		local data = yandereWaifu.GetEntityData(eff)
		
		if player:HasCollectible(CollectibleType.COLLECTIBLE_MARKED) then
			direction = player:GetAimDirection()
		end
		
		if eff.FrameCount == 1 then
			sprite:Stop()
		end
		
		--if not data.StartCountFrame then data.StartCountFrame= 1 end
		
		if eff.FrameCount == (data.StartCountFrame) + 1 then
			sprite:Play("Startup", true)
			InutilLib.SetTimer( data.StartCountFrame*8,function()
				InutilLib.SFX:Play(RebekahCurse.Sounds.SOUND_REDCHARGELIGHT, 1, 0, false, 1+(data.StartCountFrame/5))
			end)
		end
		
		eff.Velocity = player.Velocity;
		if data.Extra then --what am i doing
			eff.Position = player.Position + (Vector(0,20)):Rotated((data.direction):GetAngleDegrees()-90);
		else
			eff.Position = player.Position + (Vector(0,20)):Rotated((data.direction):GetAngleDegrees()-90);
		end
		
		--print(eff:GetSprite().Rotation)
		eff.RenderZOffset = 10
		sprite.Offset = Vector(0,-10)
		
		if sprite:IsFinished("Spawn") then
			sprite.Rotation = Round((data.direction):GetAngleDegrees(), 1)

			if player:HasWeaponType(WeaponType.WEAPON_BOMBS) then
				if sprite.Rotation <= 180 and sprite.Rotation >= 135 and not sprite:IsPlaying("ShootRightDr") then
					sprite:Play("ShootRightDr", true)
					--sprite.FlipY = true
				elseif (sprite.Rotation >= 0 and sprite.Rotation <= 45) or (sprite.Rotation >= -180 and sprite.Rotation <= -135) and not sprite:IsPlaying("ShootLeftDr") then
					sprite:Play("ShootLeftDr", true)
				elseif sprite.Rotation < 135 and sprite.Rotation > 45 and not sprite:IsPlaying("ShootDownDr") then
					sprite:Play("ShootDownDr", true)
				elseif sprite.Rotation > -180 and sprite.Rotation < 0 and not sprite:IsPlaying("ShootUpDr") then
					sprite:Play("ShootUpDr", true)
				end
				playerdata.BarrageIntro = true 
			elseif player:HasWeaponType(WeaponType.WEAPON_LASER) then
				if sprite.Rotation <= 180 and sprite.Rotation >= 135 and not sprite:IsPlaying("ShootRightTech") then
					sprite:Play("ShootRightTech", true)
					--sprite.FlipY = true
				elseif (sprite.Rotation >= 0 and sprite.Rotation <= 45) or (sprite.Rotation >= -180 and sprite.Rotation <= -135) and not sprite:IsPlaying("ShootLeftTech") then
					sprite:Play("ShootLeftTech", true)
				elseif sprite.Rotation < 135 and sprite.Rotation > 45 and not sprite:IsPlaying("ShootDownTech") then
					sprite:Play("ShootDownTech", true)
				elseif sprite.Rotation > -180 and sprite.Rotation < 0 and not sprite:IsPlaying("ShootUpTech") then
					sprite:Play("ShootUpTech", true)
				end
				InutilLib.SFX:Play(RebekahCurse.Sounds.SOUND_SPARKELECTRIC, 0.8, 0, false, 0.8)
			elseif player:HasWeaponType(WeaponType.WEAPON_BRIMSTONE) then
				if sprite.Rotation <= 180 and sprite.Rotation >= 135 and not sprite:IsPlaying("ShootRightBrimstone") then
					sprite:Play("ShootRightBrimstone", true)
					--sprite.FlipY = true
				elseif (sprite.Rotation >= 0 and sprite.Rotation <= 45) or (sprite.Rotation >= -180 and sprite.Rotation <= -135) and not sprite:IsPlaying("ShootLeftBrimstone") then
					sprite:Play("ShootLeftBrimstone", true)
				elseif sprite.Rotation < 135 and sprite.Rotation > 45 and not sprite:IsPlaying("ShootDownBrimstone") then
					sprite:Play("ShootDownBrimstone", true)
				elseif sprite.Rotation > -180 and sprite.Rotation < 0 and not sprite:IsPlaying("ShootUpBrimstone") then
					sprite:Play("ShootUpBrimstone", true)
				end
				InutilLib.SFX:Play(RebekahCurse.Sounds.SOUND_REDCHARGEHEAVY, 1, 0, false, 0.8)
			else
				if (sprite.Rotation <= 180 and sprite.Rotation >= 135) or (sprite.Rotation <= 0 and sprite.Rotation >= -45) and not sprite:IsPlaying("ShootRight") then
					sprite:Play("ShootRight", true)
					--sprite.FlipY = true
				elseif(sprite.Rotation >= 0 and sprite.Rotation <= 45) or (sprite.Rotation >= -180 and sprite.Rotation <= -135) and not sprite:IsPlaying("ShootLeft") then
					sprite:Play("ShootLeft", true)
				elseif sprite.Rotation < 135 and sprite.Rotation > 45 and not sprite:IsPlaying("ShootDown") then
					sprite:Play("ShootDown", true)
				elseif sprite.Rotation > -180 and sprite.Rotation < 0 and not sprite:IsPlaying("ShootUp") then
					sprite:Play("ShootUp", true)
				end
				playerdata.BarrageIntro = true 
			end
		end
		--charging item synergy stuff
		if InutilLib.IsFinishedMultiple(sprite, "ShootRightTech", "ShootLeftTech", "ShootDownTech", "ShootUpTech") then
			if sprite.Rotation <= 180 and sprite.Rotation >= 135 and not sprite:IsPlaying("ShootRightTechGo") then
				sprite:Play("ShootRightTechGo", true)
				--sprite.FlipY = true
			elseif (sprite.Rotation >= 0 and sprite.Rotation <= 45) or (sprite.Rotation >= -180 and sprite.Rotation <= -135) and not sprite:IsPlaying("ShootLeftTechGo") then
				sprite:Play("ShootLeftTechGo", true)
			elseif sprite.Rotation < 135 and sprite.Rotation > 45 and not sprite:IsPlaying("ShootDownTechGo") then
				sprite:Play("ShootDownTechGo", true)
			elseif sprite.Rotation > -180 and sprite.Rotation < 0 and not sprite:IsPlaying("ShootUpTechGo") then
				sprite:Play("ShootUpTechGo", true)
			end
			playerdata.BarrageIntro = true 
		end
		if InutilLib.IsFinishedMultiple(sprite, "ShootRightBrimstone", "ShootLeftBrimstone", "ShootDownBrimstone", "ShootUpBrimstone") then
			if sprite.Rotation <= 180 and sprite.Rotation >= 135 and not sprite:IsPlaying("ShootRightBrimstoneGo") then
				sprite:Play("ShootRightBrimstoneGo", true)
				--sprite.FlipY = true
			elseif (sprite.Rotation >= 0 and sprite.Rotation <= 45) or (sprite.Rotation >= -180 and sprite.Rotation <= -135) and not sprite:IsPlaying("ShootLeftBrimstoneGo") then
				sprite:Play("ShootLeftBrimstoneGo", true)
			elseif sprite.Rotation < 135 and sprite.Rotation > 45 and not sprite:IsPlaying("ShootDownBrimstoneGo") then
				sprite:Play("ShootDownBrimstoneGo", true)
			elseif sprite.Rotation > -180 and sprite.Rotation < 0 and not sprite:IsPlaying("ShootUpBrimstoneGo") then
				sprite:Play("ShootUpBrimstoneGo", true)
			end
			playerdata.BarrageIntro = true 
		end
		
		if data.Shoot then
			if data.Heavy then
				sprite.Rotation = (data.direction):GetAngleDegrees()
				sprite.Scale = Vector(2,2)
				if (sprite.Rotation <= 180 and sprite.Rotation >= 135) or (sprite.Rotation <= 0 and sprite.Rotation >= -45) then
					sprite:Play("ShootRight", true)
					--sprite.FlipY = true
				elseif (sprite.Rotation >= 0 and sprite.Rotation <= 45) or (sprite.Rotation >= -180 and sprite.Rotation <= -135) then
					sprite:Play("ShootLeft", true)
				elseif sprite.Rotation < 135 and sprite.Rotation > 45 then
					sprite:Play("ShootDown", true)
				elseif sprite.Rotation > -180 and sprite.Rotation < 0 then
					sprite:Play("ShootUp", true)
				end
				InutilLib.SFX:Play(RebekahCurse.Sounds.SOUND_REDSHOTHEAVY, 1, 0, false, 1)
			elseif data.DrFetus then
				sprite.Rotation = (data.direction):GetAngleDegrees()
				if (sprite.Rotation <= 180 and sprite.Rotation >= 135) or (sprite.Rotation <= 0 and sprite.Rotation >= -45) then
					sprite:Play("ShootRightDr", true)
					--sprite.FlipY = true
				elseif (sprite.Rotation >= 0 and sprite.Rotation <= 45) or (sprite.Rotation >= -180 and sprite.Rotation <= -135) then
					sprite:Play("ShootLeftDr", true)
				elseif sprite.Rotation < 135 and sprite.Rotation > 45 then
					sprite:Play("ShootDownDr", true)
				elseif sprite.Rotation > -180 and sprite.Rotation < 0 then
					sprite:Play("ShootUpDr", true)
				end
			elseif data.Tech then
				if sprite.Rotation <= 180 and sprite.Rotation >= 135 and not sprite:IsPlaying("ShootRightTechGo") then
					sprite:Play("ShootRightTechGo", true)
					--sprite.FlipY = true
				elseif (sprite.Rotation >= 0 and sprite.Rotation <= 45) or (sprite.Rotation >= -180 and sprite.Rotation <= -135) and not sprite:IsPlaying("ShootLeftTechGo") then
					sprite:Play("ShootLeftTechGo", true)
				elseif sprite.Rotation < 135 and sprite.Rotation > 45 and not sprite:IsPlaying("ShootDownTechGo") then
					sprite:Play("ShootDownTechGo", true)
				elseif sprite.Rotation > -180 and sprite.Rotation < 0 and not sprite:IsPlaying("ShootUpTechGo") then
					sprite:Play("ShootUpTechGo", true)
				end
			elseif data.Brimstone then
				if sprite.Rotation <= 180 and sprite.Rotation >= 135 and not sprite:IsPlaying("ShootRightBrimstoneGo") then
					sprite:Play("ShootRightBrimstoneGo", true)
					--sprite.FlipY = true
				elseif (sprite.Rotation >= 0 and sprite.Rotation <= 45) or (sprite.Rotation >= -180 and sprite.Rotation <= -135) and not sprite:IsPlaying("ShootLeftBrimstoneGo") then
					sprite:Play("ShootLeftBrimstoneGo", true)
				elseif sprite.Rotation < 135 and sprite.Rotation > 45 and not sprite:IsPlaying("ShootDownBrimstoneGo") then
					sprite:Play("ShootDownBrimstoneGo", true)
				elseif sprite.Rotation > -180 and sprite.Rotation < 0 and not sprite:IsPlaying("ShootUpBrimstoneGo") then
					sprite:Play("ShootUpBrimstoneGo", true)
				end
				InutilLib.SFX:Play(RebekahCurse.Sounds.SOUND_REDSHOTHEAVY, 1, 0, false, 0.8)
			else
				sprite.Rotation = (data.direction):GetAngleDegrees()
				if (sprite.Rotation <= 180 and sprite.Rotation >= 135) or (sprite.Rotation <= 0 and sprite.Rotation >= -45) then
					sprite:Play("ShootRight", true)
					--sprite.FlipY = true
				elseif (sprite.Rotation >= 0 and sprite.Rotation <= 45) or (sprite.Rotation >= -180 and sprite.Rotation <= -135) then
					sprite:Play("ShootLeft", true)
				elseif sprite.Rotation < 135 and sprite.Rotation > 45 then
					sprite:Play("ShootDown", true)
				elseif sprite.Rotation > -180 and sprite.Rotation < 0 then
					sprite:Play("ShootUp", true)
				end
				if data.Light then
					InutilLib.SFX:Play(RebekahCurse.Sounds.SOUND_REDSHOTLIGHT, 1, 0, false, 1)
				elseif data.Medium then
					InutilLib.SFX:Play(RebekahCurse.Sounds.SOUND_REDSHOTMEDIUM, 1, 0, false, 1)
				end
			end
			data.Shoot = false
		end
		
		--sounds
		--[[if InutilLib.IsPlayingMultiple(sprite, "ShootRight", "ShootLeft", "ShootDown", "ShootUp") then
			if sprite:GetFrame() == 0 then
				InutilLib.SFX:Play(RebekahCurse.Sounds.SOUND_REDSHOTMEDIUM, 1, 0, false, 1)
			end
		end]]
		if InutilLib.IsPlayingMultiple(sprite, "ShootRightDr", "ShootLeftDr", "ShootDownDr", "ShootUpDr") then
			if sprite:GetFrame() == 12 then
				InutilLib.SFX:Play(RebekahCurse.Sounds.SOUND_REDSPIT, 1, 0, false, 1)
			end
		end
		if InutilLib.IsPlayingMultiple(sprite, "ShootRightTechGo", "ShootLeftTechGo", "ShootDownTechGo", "ShootUpTechGo") then
			if sprite:GetFrame() == 0 then
				InutilLib.SFX:Play(RebekahCurse.Sounds.SOUND_REDELECTRICITY, 1, 0, false, 1)
			end
		end
	end
end, RebekahCurse.ENTITY_REBEKAHENTITYWEAPON);

function yandereWaifu.RedHeartDash(player, vector)
	local playerdata = yandereWaifu.GetEntityData(player)
	local SubType = 0
	local trinketBonus = 0
	if player:HasTrinket(RebekahCurse.Trinkets.TRINKET_ISAACSLOCKS) then
		trinketBonus = 5
	end
	
	player.Velocity = player.Velocity + vector:Resized( RebekahCurse.REBEKAH_BALANCE.RED_HEARTS_DASH_SPEED );
	
	local velAng = math.floor(player.Velocity:Rotated(-90):GetAngleDegrees())
	local subtype = RebekahCurse.DustEffects.ENTITY_REBEKAH_GENERIC_DUST
	if (velAng >= 180 - 15 and velAng <= 180 + 15) or (velAng >= -180 - 15 and  velAng <= -180 + 15) or (velAng >= 0 - 15 and  velAng <= 0 + 15) then
		subtype = RebekahCurse.DustEffects.ENTITY_REBEKAH_GENERIC_DUST_FRONT 
	end
	if (velAng >= 45 - 15 and  velAng <= 45 + 15) or (velAng >= -45 - 15 and  velAng <= -45 + 15) then
		subtype = RebekahCurse.DustEffects.ENTITY_REBEKAH_GENERIC_DUST_ANGLED
	end
	if (velAng >= 135 - 15 and  velAng <= 135 + 15) or (velAng >= -135 - 15 and  velAng <= -135 + 15) then
		subtype = RebekahCurse.DustEffects.ENTITY_REBEKAH_GENERIC_DUST_ANGLED_BACK
	end
	
	local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_REBEKAH_DUST, subtype, player.Position, Vector.Zero, player)
	--print(velAng)
	if (velAng >= 90 - 15 and velAng <= 90 + 15 and velAng >= 0) or (((velAng >= -135 - 15 and  velAng <= -135 + 15)  or (velAng >= -45 - 15 and  velAng <= -45 + 15)) and velAng <= 0) then
		poof:GetSprite().FlipX = true
	end
	--yandereWaifu.SpawnDashPoofParticle( player.Position, Vector(0,0), player, RebekahCurse.RebekahPoofParticleType.Red );

	playerdata.specialCooldown = RebekahCurse.REBEKAH_BALANCE.RED_HEARTS_DASH_COOLDOWN - trinketBonus;
	playerdata.invincibleTime = RebekahCurse.REBEKAH_BALANCE.RED_HEARTS_DASH_INVINCIBILITY_FRAMES;
	InutilLib.SFX:Play( SoundEffect.SOUND_CHILD_HAPPY_ROAR_SHORT, 1, 0, false, 0.9);
	playerdata.IsDashActive = true

end

--heart bomb effect
yandereWaifu:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE, function(_, bb)
	--for p = 0, InutilLib.game:GetNumPlayers() - 1 do
	if yandereWaifu.GetEntityData(bb).IsByAFanGirl then
		local player = bb.SpawnerEntity:ToPlayer()
		local controller = player.ControllerIndex;
		local sprite = bb:GetSprite();
		bb.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		if bb.FrameCount == 1 then
			--print("callie")
			if bb.Variant ~= BombVariant.BOMB_ROCKET then
				bb:GetSprite():Load("gfx/items/pick ups/bombs/bomb2_reb", true)
				bb:GetSprite():Play("Pulse")
				bb:GetSprite():ReplaceSpritesheet(0, "gfx/items/pick ups/bombs/red_barrage_bomb.png")
				bb:GetSprite():LoadGraphics();
			else
				bb:GetSprite():Load("gfx/items/pick ups/bombs/rocket2_reb", true)
				bb:GetSprite():Play("Pulse")
				bb:GetSprite():ReplaceSpritesheet(0, "gfx/items/pick ups/bombs/red_barrage_rocket.png")
				bb:GetSprite():LoadGraphics();
			end
		end
		if bb.Variant == BombVariant.BOMB_ROCKET then
			if bb.FrameCount % 3 == 0 then
				for i = 1, 3 do
					local tear = game:Spawn( EntityType.ENTITY_TEAR, 0, bb.Position, Vector.FromAngle(bb.Velocity:GetAngleDegrees()+math.random(-35,35)+180):Resized(8), bb, 0, 0):ToTear()
					tear.Scale = math.random() * 0.7 + 0.7;
				end
			end
		end
		local function DoTinyBarrages(player, vec, ent)
			local data = yandereWaifu.GetEntityData(ent)
			--InutilLib.SetFrameLoop(40,function()
				if not data.BarFrames then data.BarFrames = 0 end
				if not data.BarAngle then data.BarAngle = 0 end --incase if nil

				data.BarFrames = data.BarFrames + 1
				
				local angle = ent.Velocity:GetAngleDegrees()
					
				----barrage angle modifications are here :3
				if data.BarFrames % 2 then
					if data.BarFrames == 0 then
						data.BarAngle = 0
					elseif data.BarFrames > 1 and data.BarFrames < 10 then
						data.BarAngle = data.BarAngle - 1
					elseif data.BarFrames > 10 and data.BarFrames < 20 then
						data.BarAngle = data.BarAngle + 2
					elseif data.BarFrames > 20 and data.BarFrames < 30 then
						data.BarAngle = data.BarAngle - 2
					elseif data.BarFrames > 30 and data.BarFrames < 40 then
						data.BarAngle = data.BarAngle + 4
					else
						data.BarAngle = 0
					end
				end
				
				local modulusnum = 3
				if data.BarFrames == 1 then
					--direction:GetAngleDegrees() = angle
				elseif --[[data.BarFrames >= 1 and data.BarFrames < 40 and]] data.BarFrames % modulusnum == (0) then
					--ent.Velocity = ent.Velocity * 0.8 --slow him down
					for i= 1, 4, 1 do
						local tear = player:FireTear( bb.Position, Vector.FromAngle((data.BarAngle + vec:GetAngleDegrees())+(i*90)-45)*(20), false, false, false):ToTear()
						--local bomb = player:FireBomb( bb.Position,  Vector.FromAngle((data.BarAngle + vec:GetAngleDegrees())+(i*90)-45)*(20)):ToBomb()
						--yandereWaifu.GetEntityData(bomb).IsSmall = true
						tear.Position = bb.Position + Vector.FromAngle((data.BarAngle + vec:GetAngleDegrees())+(i*90)-45)*(20)
					end
					--local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0, ent.Position, Vector.FromAngle(data.BarAngle + vec:GetAngleDegrees())*(20), ent):ToTear()
					InutilLib.SFX:Play(SoundEffect.SOUND_TEARS_FIRE, 1, 0, false, 1.2)
				elseif data.BarFrames == 40 then
					data.BarFrames = nil
					data.BarAngle = nil
				end
			--end)
		end
		
		
			yandereWaifu.SpawnHeartParticles( 1, 1, bb.Position, yandereWaifu.RandomHeartParticleVelocity(), player, RebekahCurse.RebekahHeartParticleType.Red );
			--for i= 1, 4, 1 do
			DoTinyBarrages(player, (bb.Position + Vector(30,0)), bb)
			--end
			bb.ExplosionDamage = player.Damage * 17.7013;
			bb.RadiusMultiplier = 1.2;
			--[[bb.Flags = player.TearFlags
			bb.Variant = 10
			--print(tostring(bomb.Variant))
			--bb:Update()
			--bb:GetSprite():Load("gfx/love_bomb.anm2", true)
			--bb:GetSprite():LoadGraphics()
			if bb.FrameCount == 1 then
				bb:GetSprite():Load("gfx/love_bomb.anm2", true)
				bb:GetSprite():Play("Pulse", false)
				bb:GetSprite():LoadGraphics()
			elseif bb:GetSprite():IsFinished("Pulse") then
				bb:GetSprite():Play("Explode", true)
				bb:GetSprite():LoadGraphics()
			elseif bb:GetSprite():IsFinished("Explode") then
				bb:Remove()
			bb:GetSprite():ReplaceSpritesheet(0, "gfx/effects/bomb_rebeccawantsisaacalittlebittoomuch.png")
			end
			bb:GetSprite():LoadGraphics()]]
	end
end)
--[[yandereWaifu:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, damage, amount, damageFlag, damageSource, damageCountdownFrames)
	print(tostring(damageSource.Type))
	if damageSource.Type == 4 then
		print("wholesome")
		if damageSource:ToEntity():GetData().IsByAFanGirl then
			return false
		end
	end
end, EntityType.ENTITY_PLAYER)]]

--orbital target
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
		local sprite = eff:GetSprite()
		local data = yandereWaifu.GetEntityData(eff)
		local player = data.Parent
		
		local movementDirection = player:GetShootingInput();
		local roomClampSize = math.max( 5, 20 )
		if movementDirection:Length() < 0.05 then
			eff.Velocity = Vector.Zero
		else
			eff.Position = InutilLib.room:GetClampedPosition(eff.Position, roomClampSize);
			eff.Velocity = (eff.Velocity * 0.9) + movementDirection:Resized( RebekahCurse.REBEKAH_BALANCE.SOUL_HEARTS_DASH_TARGET_SPEED );
		end
		
		--for i, orb in pairs (Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.TARGET, -1, false, false)) do
		--	if not data.HasParent then
		--		data.HasParent = orb
		--	else
		--		if not data.HasParent:IsDead() then
		--eff.Velocity = Vector.Zero
		--			eff.Position = data.HasParent.Position
		--		else
		--			eff.Velocity = eff.Velocity * 0.8
		--		end
		--	end
		--end
		
		local room =  Game():GetRoom()
		--function code
		if eff.FrameCount == 1 then
			sprite:Play("Idle", true)
			yandereWaifu.RebekahCanShoot(player, false)
			data.SoundFrame = 1
		elseif sprite:IsFinished("Idle") then
			sprite:Play("Blink",true)
		elseif eff.FrameCount >= 55 then
			Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_ORBITALNUKE, 0, eff.Position, Vector.FromAngle(1*math.random(1,360))*(math.random(2,4)), player) --heart effect
			yandereWaifu.RebekahCanShoot(player, true)
			player.FireDelay = 30
			eff:Remove()
			if yandereWaifu.GetEntityData(player).barrageNumofShots > 1 then
				for i = 1, yandereWaifu.GetEntityData(player).barrageNumofShots do
					InutilLib.SetTimer( i*30, function()
						Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_ORBITALNUKE, 1, eff.Position,( Vector(0,1):Resized(math.random(8,12))):Rotated(math.random(0,360)), player) --InutilLib.room:FindFreeTilePosition( InutilLib.room:GetClampedPosition((Vector.FromAngle(1*math.random(1,360))+ eff.Position*(math.random(20,50))), roomClampSize ), 0)
					end)
				end
			end
		end
		--[[if eff.FrameCount < 55 then
			--player.Velocity = Vector(0,0)
			InutilLib.SFX:Play(RebekahCurse.Sounds.SOUND_REDCHARGELIGHT, 1, 0, false, data.SoundFrame)
			data.SoundFrame = data.SoundFrame - 0.01
		end]]
end, RebekahCurse.ENTITY_ORBITALTARGET)


yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, function(_,  eff) --orbital target
	local sprite = eff:GetSprite()
	local data = yandereWaifu.GetEntityData(eff)
	local player = data.Parent
	if not data.Init then      
		eff.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NOPITS 
		data.spr = Sprite()                                                 
		data.spr:Load("gfx/effects/red/orbital_target.anm2", true) 
		data.spr:Play("Line", true)
		data.Init = true                                              
	end      
		
	InutilLib.DeadDrawRotatedTilingSprite(data.spr, Isaac.WorldToScreen(player.Position), Isaac.WorldToScreen(eff.Position), 16, nil, 8, true)
end, RebekahCurse.ENTITY_ORBITALTARGET);


--kim jun- i mean, rebeccas rockets
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	for p = 0, InutilLib.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		local controller = player.ControllerIndex
		local sprite = eff:GetSprite()
		local data = yandereWaifu.GetEntityData(eff)
		eff.GridCollisionClass =  EntityGridCollisionClass.GRIDCOLL_NOPITS 
		
		local room =  Game():GetRoom()
		--function code
		if sprite:GetFrame() == 25 then
			eff.Velocity = Vector.Zero
		else
			eff.Velocity = eff.Velocity * 0.8
		end
		if eff.FrameCount == 1 then
			if eff.SubType == 0 then
				sprite:Play("Falling", true)
			elseif eff.SubType == 1 then
				sprite:Play("FallingSingular", true)
			end
		elseif sprite:IsEventTriggered("Blow") then
			local megumin = Isaac.Spawn(EntityType.ENTITY_BOMBDROP, 0, 0, eff.Position, Vector(0,0), eff):ToBomb() --this is a workaround to make explosions larger
			megumin:SetExplosionCountdown(1)
			megumin.Visible = false
			megumin.RadiusMultiplier = data.CustomRadius or 2.2 --my favorite part
			megumin.ExplosionDamage = data.CustomDamage or player.Damage*5
			for i, ent in pairs(Isaac.GetRoomEntities()) do
				if ent:IsEnemy() and not ent:IsVulnerableEnemy() then
					ent:AddPoison(EntityRef(eff), 5, player.Damage*17)
				end
			end
			if player:HasWeaponType(WeaponType.WEAPON_LASER) then
				for i = 0, 360, 360/8 do
					local techlaser = player:FireTechLaser(eff.Position, 0, Vector.FromAngle(i), false, true)
					techlaser.CollisionDamage = player.Damage * 5
					--techlaser.Damage = player.Damage * 5 doesn't exist lol
				end
			elseif player:HasWeaponType(WeaponType.WEAPON_BRIMSTONE) then
				for i = 0, 360, 360/8 do
					local brim = player:FireBrimstone(eff.Position, 0, Vector.FromAngle(i), false, true)
					brim.CollisionDamage = player.Damage * 5
				end
			end
			InutilLib.SFX:Play(RebekahCurse.Sounds.SOUND_REDCRASH, 1, 0, false, 1)
		elseif sprite:IsFinished("Falling") or sprite:IsFinished("FallingSingular") then
			eff:Remove()
		end
		if eff.FrameCount < 35 and eff.SubType == 0 then
			player.Velocity = Vector(0,0)
		end
	end
end, RebekahCurse.ENTITY_ORBITALNUKE)

--red knife
function yandereWaifu:RedKnifeRender(tr, _)
	if tr.Variant == RebekahCurse.ENTITY_REDKNIFE and tr.FrameCount == 1 then
		tr:GetSprite():Play("RegularTear", false);
		if TaintedTreasure and yandereWaifu.GetEntityData(tr).IsBottle then
			if tr.SpawnerEntity:GetData().BrokenBottle then
				tr:GetSprite():ReplaceSpritesheet(0, "gfx/effects/red/tear_tt_bottle_broken.png")
			else
				tr:GetSprite():ReplaceSpritesheet(0, "gfx/effects/red/tear_tt_bottle.png")
			end
		end
		tr:GetSprite():LoadGraphics();
		
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_POST_TEAR_RENDER, yandereWaifu.RedKnifeRender)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, function(_, tr)
	if tr.Variant == RebekahCurse.ENTITY_REDKNIFE and yandereWaifu.GetEntityData(tr).IsBottle then
		InutilLib.SFX:Play(TaintedSounds.BOTTLE_BREAK2)
		local shardvec = RandomVector()
		for i = 1, 2 do
			local shard = Isaac.Spawn(1000, TaintedEffects.BOTTLE_SHARD, 0, tr.Position, (shardvec * math.random(2,4)):Rotated(i * (360/5)), tr)
			shard.CollisionDamage = math.max(3.5, tr.CollisionDamage/2)
		end
	end
end, EntityType.ENTITY_TEAR)

function yandereWaifu:RedPersonalityTearUpdate(tr)
	local data = yandereWaifu.GetEntityData(tr)
	if tr.Variant == RebekahCurse.ENTITY_REDKNIFE then
		local angleNum = (tr.Velocity):GetAngleDegrees();
		tr:GetSprite().Rotation = angleNum + 90;
		tr:GetData().Rotation = tr:GetSprite().Rotation;
		tr.Velocity = tr.Velocity * 0.9
	elseif tr.Variant == 50 and data.IsJacobFetus or data.IsEsauFetus then --just using 50 since the docs doesnt seem to have enums for fetus tears
		if tr.FrameCount == 1 and data.IsJacobFetus then
			tr:GetSprite():ReplaceSpritesheet(0, "gfx/fetus_tears_jacob.png")
			tr:GetSprite():LoadGraphics();
		end
		if tr.FrameCount == 1 and data.IsEsauFetus then
			tr:GetSprite():ReplaceSpritesheet(0, "gfx/fetus_tears_esau.png")
			tr:GetSprite():LoadGraphics();
			tr.CollisionDamage = tr.BaseDamage + 2.5
		end
		if tr.FrameCount <= 200 and data.IsJacobFetus then
			tr.Height = -12
			local e = InutilLib.GetClosestGenericEnemy(tr, 500)
			if e then
				InutilLib.MoveDirectlyTowardsTarget(tr, e, 2+math.random(1,5)/10, 0.85)
			end
			tr.Velocity = tr.Velocity * (0.55+(math.random(1,5)/10))
		end
		if tr.FrameCount <= 150 and data.IsEsauFetus then
			tr.Height = -12
			local e = InutilLib.GetClosestGenericEnemy(tr, 500)
			if e then
				InutilLib.MoveDirectlyTowardsTarget(tr, e, 1+math.random(1,5)/10, 0.85)
			end
			tr.Velocity = tr.Velocity * (0.55+(math.random(1,5)/10))
		end
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, yandereWaifu.RedPersonalityTearUpdate)

function yandereWaifu:RedPersonalityTearCollision(tr, cool)
	local data = yandereWaifu.GetEntityData(tr)
	if tr.Variant == 50 and (data.IsJacobFetus or IsEsauFetus) then --just using 50 since the docs doesnt seem to have enums for fetus tears
		if tr.FrameCount <= 300 and tr.FrameCount % 30 == 0 then
			cool:TakeDamage(tr.CollisionDamage*1.5, 0, EntityRef(tr), 4)
		end
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, yandereWaifu.RedPersonalityTearCollision)

local RebekahNormalSword = {
	[1] = "1.png",
	[2] = "2.png",
	[3] = "3.png",
	[4] = "4.png",
	[5] = "5.png",
	[6] = "6.png"
}

local RebekahBigNormalSword = {
	[1] = "1.png",
	[2] = "2.png",
	[3] = "3.png",
	[4] = "4.png",
	[5] = "5.png",
	[6] = "6.png"
}

local RebekahSwordTable = {
	[1] = "1.png",
	[2] = "2.png",
	[3] = "3.png",
	[4] = "4.png",
	[5] = "5.png",
	[6] = "6.png",
	[7] = "7.png",
	[8] = "8.png",
	[9] = "9.png",
	[10] = "10.png",
	[11] = "11.png",
	[12] = "12.png",
	[13] = "13.png",
	[14] = "14.png",
	[15] = "15.png",
	[16] = "16.png",
	[17] = "17.png",
	[18] = "18.png"
}

local RebekahBigSwordTable = {
	[1] = "1.png",
	[2] = "2.png",
	[3] = "3.png",
	[4] = "4.png",
	[5] = "5.png",
	[6] = "6.png",
	[7] = "7.png"
}

local LightSaberTable = {
	[1] = "1_laser.png",
	[2] = "2_laser.png",
	[3] = "3_laser.png",
	[4] = "4_laser.png",
	[5] = "5_laser.png",
	[6] = "6_laser.png",
	[7] = "7_laser.png",
	[8] = "8_laser.png"
}

--slash effect
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	for i=0, InutilLib.game:GetNumPlayers()-1 do
		local player = Isaac.GetPlayer(i)
		local controller = player.ControllerIndex
		local sprite = eff:GetSprite()
		local data = yandereWaifu.GetEntityData(eff)
		eff.GridCollisionClass =  EntityGridCollisionClass.GRIDCOLL_NOPITS 
		
		local function HasGiantModifyingStuff() --checks if giant tear stuff exists
			if player:HasCollectible(CollectibleType.COLLECTIBLE_IPECAC) or player:HasCollectible(CollectibleType.COLLECTIBLE_POLYPHEMUS) then
				return true
			end
			return false
		end
		
		local room =  Game():GetRoom()
		--function code
		if eff.FrameCount == 1 then
			sprite:Play("Zenith", true)
			if not data.PermanentAngle then  data.PermanentAngle = eff.Velocity end
			if eff.SubType == 0 then
				local swordTable --thing stores what kind of sword table will be used 
				if HasGiantModifyingStuff() then
					swordTable = RebekahBigSwordTable
				else
					swordTable = RebekahSwordTable
				end
				local chosenNum = math.random(1,#swordTable)
				for i = 0, 15 do 
					if i == 0 or i == 4 or i == 8 or i == 12 then
						chosenNum = math.random(1,#swordTable)
					end
					if math.random(1,3) == 3 then --sets if you will get special swords to pop out
						if HasGiantModifyingStuff() then
							sprite:ReplaceSpritesheet(i, "gfx/effects/red/swords/big_special/"..RebekahBigSwordTable[chosenNum])
						else
							sprite:ReplaceSpritesheet(i, "gfx/effects/red/swords/special/"..RebekahSwordTable[chosenNum])
						end
					else
						if HasGiantModifyingStuff () then
							sprite:ReplaceSpritesheet(i, "gfx/effects/red/swords/big_normal/"..RebekahBigSwordTable[math.random(1,#RebekahNormalSword)])
						else
							sprite:ReplaceSpritesheet(i, "gfx/effects/red/swords/normal/"..RebekahSwordTable[math.random(1,#RebekahBigNormalSword)])
						end
					end
					--if HasGiantModifyingStuff() then
					--	sprite.PlaybackSpeed = 0.5
					--end
					sprite:LoadGraphics()
				end
			elseif eff.SubType == 1 then
				local chosenNum = math.random(1,#LightSaberTable)
				for i = 0, 15 do 
					if i == 0 or i == 4 or i == 8 or i == 12 then
						chosenNum = math.random(1,#LightSaberTable)
					end
					sprite:ReplaceSpritesheet(i, "gfx/effects/red/swords/starwars/"..LightSaberTable[chosenNum])
					sprite:LoadGraphics()
				end
			end
		elseif --[[eff.FrameCount == 40 or]] yandereWaifu.GetEntityData(player).IsAttackActive == false then
			eff:Remove()
		elseif sprite:IsFinished("Zenith") then
			sprite:Play("Zenith", true)
		end
		--close hitbox
		if eff.FrameCount % data.MultiTears == (0) then
			if eff.FrameCount < yandereWaifu.GetEntityData(player).redcountdownFrames then
				for i, ent in pairs (Isaac.GetRoomEntities()) do
					if ent:IsEnemy() and ent:IsVulnerableEnemy() and not ent:IsDead() then
						if ent.Position:Distance((eff.Position)) <= 50 then
							ent:TakeDamage((player.Damage * data.MultiTears) * 1.8, 0, EntityRef(eff), 1)
						end
					end
				end
				--player.Velocity = Vector(0,0)
			end
			--mid hitbox
			--local customBody = Isaac.Spawn(EntityType.ENTITY_EFFECT, 5, 0, eff.Position + (Vector(100,0):Rotated(data.PermanentAngle:GetAngleDegrees())), Vector(0,0), player) --body effect
			if eff.FrameCount < yandereWaifu.GetEntityData(player).redcountdownFrames then
				for i, ent in pairs (Isaac.GetRoomEntities()) do
					if ent:IsEnemy() and ent:IsVulnerableEnemy() and not ent:IsDead() then
						if ent.Position:Distance(eff.Position + (Vector(100,0):Rotated(data.PermanentAngle:GetAngleDegrees()))) <= 70 then
							ent:TakeDamage((player.Damage * data.MultiTears) * 1.5, 0, EntityRef(eff), 1)
						end
					end
				end
				--player.Velocity = Vector(0,0)
			end
			--far hitbox
			if eff.FrameCount < yandereWaifu.GetEntityData(player).redcountdownFrames then
				for i, ent in pairs (Isaac.GetRoomEntities()) do
					if ent:IsEnemy() and ent:IsVulnerableEnemy() and not ent:IsDead() then
						if ent.Position:Distance((eff.Position + (Vector(200,0):Rotated(data.PermanentAngle:GetAngleDegrees())))) <= 100 or
						ent.Position:Distance((eff.Position + (Vector(300,0):Rotated(data.PermanentAngle:GetAngleDegrees())))) <= 70 or
						ent.Position:Distance((eff.Position + (Vector(400,0):Rotated(data.PermanentAngle:GetAngleDegrees())))) <= 50 then
							ent:TakeDamage((player.Damage * data.MultiTears), 0, EntityRef(eff), 1)
						end
					end
				end
				--player.Velocity = Vector(0,0)
			end
		end
		eff.Velocity = player.Velocity*2
		eff:GetSprite().Rotation = data.PermanentAngle:GetAngleDegrees();
	end
end, RebekahCurse.ENTITY_SLASH)
end
