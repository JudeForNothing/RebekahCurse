
--SOUL HEART --
do
function yandereWaifu.SoulHeartTeleport(player, vector)
	local playerdata = yandereWaifu.GetEntityData(player)
	local SubType = 0
	local trinketBonus = 0
	if player:HasTrinket(RebekahCurse.TRINKET_ISAACSLOCKS) then
		trinketBonus = 5
	end
	--local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_PERSONALITYPOOF, 0, player.Position, Vector.Zero, player)
	
	local customBody = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_EXTRACHARANIMHELPER, 0, player.Position, Vector(0,0), player) --body effect
	yandereWaifu.GetEntityData(customBody).Player = player
	yandereWaifu.GetEntityData(customBody).WizoobIn = true
	player.Velocity = Vector( 0, 0 );
	player.ControlsEnabled = false;
	--yandereWaifu.SpawnPoofParticle( player.Position, Vector(0,0), player, RebekahPoofParticleType.Blue );
	yandereWaifu.SpawnHeartParticles( 3, 5, player.Position, yandereWaifu.RandomHeartParticleVelocity(), player, RebekahHeartParticleType.Blue );
	playerdata.specialCooldown = REBEKAH_BALANCE.SOUL_HEARTS_DASH_COOLDOWN - trinketBonus;
	playerdata.invincibleTime = REBEKAH_BALANCE.SOUL_HEARTS_DASH_INVINCIBILITY_FRAMES;
	InutilLib.SFX:Play( SoundEffect.SOUND_WEIRD_WORM_SPIT, 1, 0, false, 1 );
	playerdata.IsUninteractible = true
	playerdata.IsDashActive = true
	
	--set opened damage buff
	playerdata.SoulBuff = true
	player:AddCacheFlags(CacheFlag.CACHE_DAMAGE);
	player:EvaluateItems()
	--happy costume code
	yandereWaifu.ApplyCostumes( yandereWaifu.GetEntityData(player).currentMode, player , false, false)
	player:AddCostume(Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_NUMBER_ONE))
	yandereWaifu.RebekahCanShoot(player, false)
end

function yandereWaifu.RebekahSoulNormalBarrage(player, data, direction, endFrameCount, modulusnum, extraTearDmg)
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
		yandereWaifu.EndRebekahBarrageIfValid(player, data)
	--epic fetus synergy
	elseif player:HasWeaponType(WeaponType.WEAPON_ROCKETS) then --rocket synergy
		local target = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_GHOSTTARGET, 0, player.Position,  Vector.FromAngle(direction:GetAngleDegrees())*(9), nil)
		yandereWaifu.GetEntityData(target).Parent = player
		yandereWaifu.GetEntityData(target).ExtraTears = extraTearDmg
		yandereWaifu.EndRebekahBarrageIfValid(player, data)
	---if player:HasWeaponType(WeaponType.WEAPON_ROCKETS) then --rocket synergy
	---	Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_WIZOOB_MISSILE, 0, player.Position,  Vector.FromAngle(direction:GetAngleDegrees())*(9), player)
	--	yandereWaifu.EndRebekahBarrage(player, data)
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
							yandereWaifu.FireSoulKnife(ludoTear.Position, Vector.FromAngle(i + data.soulcountdownFrames*5 - j):Resized(13))
						end
						--print(modulusnum)
						--local knife = InutilLib.SpawnKnife(player, (i + data.soulcountdownFrames*5), false, 0, SchoolbagKnifeMode.FIRE_ONCE, 1, 20, data.KnifeHelper)
						--yandereWaifu.GetEntityData(knife).IsSoul = true
						--local knife2 = InutilLib.SpawnKnife(player, ((i + data.soulcountdownFrames*10)+90), false, 0, SchoolbagKnifeMode.FIRE_ONCE, 1, 20, data.KnifeHelper)
						--yandereWaifu.GetEntityData(knife2).IsSoul = true
					elseif data.soulcountdownFrames >= endFrameCount then
						yandereWaifu.EndRebekahBarrage(player, data)
						--player.ControlsEnabled = true;
						data.soulcountdownFrames = 0;
						yandereWaifu.SoulLeadPencilBarrage()
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
							yandereWaifu.EndRebekahBarrage(player, data)
							yandereWaifu.SoulLeadPencilBarrage()
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
						yandereWaifu.EndRebekahBarrage(player, data)
						--player.ControlsEnabled = true;
						data.soulcountdownFrames = 0;
						yandereWaifu.SoulLeadPencilBarrage()
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
							yandereWaifu.EndRebekahBarrage(player, data)
							yandereWaifu.SoulLeadPencilBarrage()
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
								yandereWaifu.FireSoulKnife(player.Position, Vector.FromAngle(direction:GetAngleDegrees() - i):Resized(8))
								InutilLib.SFX:Play(RebekahCurseSounds.SOUND_SOULSHOTLIGHT, 1, 0, false, 1.2)
							end)
							delay = delay + 20
						end
					elseif data.soulcountdownFrames >= endFrameCount then
						yandereWaifu.EndRebekahBarrage(player, data)
						player.ControlsEnabled = true;
						data.soulcountdownFrames = 0;
						yandereWaifu.SoulLeadPencilBarrage()
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
							yandereWaifu.EndRebekahBarrage(player, data)
							yandereWaifu.SoulLeadPencilBarrage()
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
						yandereWaifu.EndRebekahBarrage(player, data)
						yandereWaifu.SoulLeadPencilBarrage()
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
					yandereWaifu.EndRebekahBarrage(player, data)
					yandereWaifu.SoulLeadPencilBarrage()
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
					yandereWaifu.EndRebekahBarrage(player, data)
					yandereWaifu.SoulLeadPencilBarrage()
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
						yandereWaifu.EndRebekahBarrage(player, data)
						yandereWaifu.SoulLeadPencilBarrage()
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
end

--soul heart movement
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local player = yandereWaifu.GetEntityData(eff).Parent
	local controller = player.ControllerIndex;
	local sprite = eff:GetSprite();
	local room =  Game():GetRoom();
	local data = yandereWaifu.GetEntityData(player)
    local roomClampSize = math.max( player.Size, 20 );
	
	yandereWaifu.GetEntityData(player).invincibleTime = 10
	--movement code
	eff.GridCollisionClass =  EntityGridCollisionClass.GRIDCOLL_NOPITS;

	--local movementDirection = player:GetMovementInput();
	--if movementDirection:Length() < 0.05 then
	
	player.Velocity = player.Velocity * 1.1
	eff.Velocity = player.Velocity;
	eff.Position = player.Position --room:GetClampedPosition(eff.Position, roomClampSize);
	
		--eff.Velocity = player.Velocity;
	--else
	--	eff.Velocity = (eff.Velocity * 0.9) + movementDirection:Resized( REBEKAH_BALANCE.SOUL_HEARTS_DASH_TARGET_SPEED );
	--end
	
	--function code
	--player.Velocity = (room:GetClampedPosition(eff.Position, roomClampSize) - player.Position)--*0.5;
	if eff.FrameCount == 1 then
		player.Visible = true
		--InutilLib.SFX:Play( RebekahCurseSounds.SOUND_SOULJINGLE, 1, 0, false, 1 );
		sprite:Play("Idle", true);
		data.LastEntityCollisionClass = player.EntityCollisionClass;
		data.LastGridCollisionClass = player.GridCollisionClass;
		--trail
		data.trail = InutilLib.SpawnTrail(eff, Color(0,0.5,1,0.5))
	elseif sprite:IsFinished("Idle") then
		sprite:Play("Blink",true);
	end
	
    if eff.FrameCount == 40 then
        if REBEKAH_BALANCE.SOUL_HEARTS_DASH_RETAINS_VELOCITY == false then
            player.Velocity = Vector( 0, 0 );
        else
            player.Velocity = eff.Velocity;
        end
    	if player.CanFly == true and room:GetType() ~= RoomType.ROOM_DUNGEON then
    		player.Position = eff.Position;
            if room:IsPositionInRoom(player.Position, 0) == false then
                player.Velocity = Vector( 0, 0 );
                player.Position = room:GetClampedPosition( player.Position, roomClampSize );
            end
    	else
            player.Position = room:FindFreeTilePosition( eff.Position, 0 )
            if room:IsPositionInRoom(player.Position, 0) == false then
                player.Velocity = Vector( 0, 0 );
                player.Position = room:FindFreeTilePosition( room:GetClampedPosition( player.Position, roomClampSize ), 0 );
            end
        end
		local customBody = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_EXTRACHARANIMHELPER, 0, player.Position, Vector(0,0), player) --body effect
		yandereWaifu.GetEntityData(customBody).Player = player
		yandereWaifu.GetEntityData(customBody).WizoobOut = true
		player.ControlsEnabled = false
    	eff:Remove();
		data.trail:Remove()
		
		yandereWaifu.GetEntityData(player).LeaksJuices = math.random(30,40)
    	
    	data.IsUninteractible = false;
    	InutilLib.SFX:Play( SoundEffect.SOUND_WEIRD_WORM_SPIT, 1, 0, false, 1 );
    else
		player:SetColor(Color(0,0,0,0.2,0,0,0),3,1,false,false)
    	player.GridCollisionClass =  EntityGridCollisionClass.GRIDCOLL_WALLS;
		player.EntityCollisionClass =  EntityCollisionClass.ENTCOLL_PLAYEROBJECTS;
    end
	--if eff.FrameCount < 35 then
	--	player.Velocity = Vector( 0, 0 );
	--end
end, RebekahCurse.ENTITY_SOULTARGET)

	--ectoplasm
	yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, function(_, eff)
		local sprite = eff:GetSprite()
		local data = yandereWaifu.GetEntityData(eff)
		
		if eff:GetData().IsEctoplasm and eff.FrameCount == 0 then 
			sprite:ReplaceSpritesheet(0, "gfx/effects/ectoplasm.png")
			sprite:LoadGraphics()
		end
	end, 46)

	--[[ecto tears
	yandereWaifu:AddCallback(ModCallbacks.MC_POST_TEAR_RENDER, function(_, tr)
		local data = yandereWaifu.GetEntityData(tr)
		local player = Isaac.GetPlayer(0)
		local sprite = tr:GetSprite()
		if tr:GetData().IsEctoplasm then
			sprite:ReplaceSpritesheet(0, "gfx/tears_ecto.png")
			sprite:LoadGraphics()
		end
	end)

	yandereWaifu:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, function(_, tr)
		local data = yandereWaifu.GetEntityData(tr)
		local player = Isaac.GetPlayer(0)
		local sprite = tr:GetSprite()
		if tr:GetData().IsEctoplasm then
			if tr.Height >= -7 or tr:CollidesWithGrid() then
				SpawnEctoplasm( tr.Position, Vector ( 0, 0 ) );
				tr:Remove();
			end
		end
	end)]]


	--haunted knife
	function yandereWaifu:HauntedKnifeRender(tr, _)
		if tr.Variant == RebekahCurse.ENTITY_HAUNTEDKNIFE then
			tr:GetSprite():Play("RegularTear", false);
			--tr:GetSprite():LoadGraphics();
		end
	end
	yandereWaifu:AddCallback(ModCallbacks.MC_POST_TEAR_RENDER, yandereWaifu.HauntedKnifeRender)

	function yandereWaifu:HauntedKnifeUpdate(tr)
		local data = yandereWaifu.GetEntityData(tr)
		if tr.Variant == RebekahCurse.ENTITY_HAUNTEDKNIFE then
			local angleNum = (tr.Velocity):GetAngleDegrees();
			tr:GetSprite().Rotation = angleNum + 90;
			tr:GetData().Rotation = tr:GetSprite().Rotation;
			--make it float for a while
			if tr.FrameCount == 1 then
				data.trail = InutilLib.SpawnTrail(tr, Color(0,0,0,0.7,170,170,210), tr.Position - Vector(0,20))
				data.firstHeight = tr.Height
			elseif tr.FrameCount < 300 then
				tr.Height = data.firstHeight
			end
			--dash ability
			local target = InutilLib.GetClosestGenericEnemy(tr, 10000)
			if math.random(1,5) == 1 and tr.FrameCount % 3 == 0 then
				if target then
					InutilLib.MoveDirectlyTowardsTarget(tr, target, 20, 0.9)
				else
					InutilLib.MoveDirectlyTowardsTarget(tr, tr.SpawnerEntity:ToPlayer(), 20, 0.9)
					--InutilLib.MoveRandomlyTypeI(tr, tr.SpawnerEntity:ToPlayer().Position, 10, 0.9, 30, 30, 60)
				end
			else
				tr.Velocity = tr.Velocity * 0.95
			end
			--damage apparently
			if tr.FrameCount % 5 == 0 then
				for i, e in pairs(Isaac.GetRoomEntities()) do
					if e:IsActiveEnemy() and e:IsVulnerableEnemy() then
						if (tr.Position - e.Position):Length() < tr.Size + e.Size + 3 then
							e:TakeDamage(tr.CollisionDamage/1.5, 0, EntityRef(tr), 4)
						end
					end
				end
			end
			--on death
			if tr.Height >= -7 or tr:CollidesWithGrid() then
				yandereWaifu.SpawnPoofParticle( tr.Position, Vector(0,0), tr, RebekahPoofParticleType.Soul )
				tr:Remove()
				data.trail:Remove()
			end
		end
	end
	yandereWaifu:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, yandereWaifu.HauntedKnifeUpdate)

	function yandereWaifu:EctoplasmaRender(tr, _)
		if tr.Variant == RebekahCurse.ENTITY_ECTOPLASMA then
			tr:GetSprite():Play("RegularTear", false);
		end
	end
	yandereWaifu:AddCallback(ModCallbacks.MC_POST_TEAR_RENDER, yandereWaifu.EctoplasmaRender)
	
	function yandereWaifu:EctoplasmaUpdate(tr)
		if tr.Variant == RebekahCurse.ENTITY_ECTOPLASMA then
			local data = yandereWaifu.GetEntityData(tr)
			local player = yandereWaifu.GetEntityData(tr).Parent
			tr.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE 
			if tr.FrameCount == 1 then
				data.firstHeight = tr.Height
			elseif tr.FrameCount < 60 then
				tr.Height = data.firstHeight
			end
			for i, enemy in pairs (Isaac.GetRoomEntities()) do
				if enemy:IsVulnerableEnemy() then
					if enemy.Position:Distance(tr.Position) < enemy.Size + (tr.Size * 5) then
						enemy:TakeDamage(Isaac.GetPlayer(0).Damage * 2, 0, EntityRef(tr), 1);
					end
				end
			end
			--if math.random(1,3) == 3 and tr.FrameCount % 2 == 0 then
			--	local laser = EntityLaser.ShootAngle(2, tr.Position, math.random(1,360), 2, Vector(0,-20), Isaac.GetPlayer(0))
			--	laser:SetColor(Color(0,0,0,0.7,170,170,210),9999999,99,false,false);
			--	laser:SetHomingType(1)
			--end
			local rand = math.random(1,2)
			if tr.FrameCount % 8 == 0 then
				for i = 1, rand do
					local circle = player:FireTechXLaser(tr.Position, Vector.FromAngle(math.random(1,360))*(20), math.random(10,20))
					circle:SetColor(Color(0,0,0,0.7,170,170,210),9999999,99,false,false);
				end
			end
		end
	end
	yandereWaifu:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, yandereWaifu.EctoplasmaUpdate)
	
function yandereWaifu:SoulPersonalityTearUpdate(tr)
	local data = yandereWaifu.GetEntityData(tr)
	if tr.Variant == 50 and data.IsSoulFetus then --just using 50 since the docs doesnt seem to have enums for fetus tears
		if tr.FrameCount == 1 and data.IsSoulFetus then
			tr:GetSprite():ReplaceSpritesheet(0, "gfx/fetus_tears_blue.png")
			tr:GetSprite():LoadGraphics();
		end
		if tr.FrameCount <= 300 and data.IsSoulFetus then
			tr.Height = -12
			local e = InutilLib.GetClosestGenericEnemy(tr, 500)
			if e then
				InutilLib.MoveDirectlyTowardsTarget(tr, e, 2+math.random(1,5)/10, 0.85)
			end
			tr.Velocity = tr.Velocity * 0.95
		end
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, yandereWaifu.SoulPersonalityTearUpdate)

function yandereWaifu:SoulPersonalityTearCollision(tr, cool)
	local data = yandereWaifu.GetEntityData(tr)
	if tr.Variant == 50 and data.IsSoulFetus then --just using 50 since the docs doesnt seem to have enums for fetus tears
		if tr.FrameCount <= 300 and tr.FrameCount % 7 == 0 and data.IsSoulFetus then
			cool:TakeDamage(tr.CollisionDamage, 0, EntityRef(tr), 4)
		end
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, yandereWaifu.SoulPersonalityTearCollision)

	
	yandereWaifu:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, function(_, tr)
		if tr.Variant == RebekahCurse.ENTITY_ECTOPLASMA then
			local player = yandereWaifu.GetEntityData(tr).Parent
			local part = Isaac.Spawn(EntityType.ENTITY_EFFECT, ENTITY_LIGHTBOOM, 0, tr.Position, Vector(0,0), tr);
			part:GetSprite():ReplaceSpritesheet(0, "gfx/effects/plasmaboom.png");
			part:GetData().NotEternal = true;
			local rand = math.random(3,6)
			for i = 1, rand do
				local circle = player:FireTechXLaser(tr.Position, Vector.FromAngle(math.random(1,360))*(20), math.random(10,20))
				circle:SetColor(Color(0,0,0,0.7,170,170,210),9999999,99,false,false);
			end
			--SpawnEctoplasm( tr.Position, Vector ( 0, 0 ) , math.random(12,35)/10, player);
		end
	end, EntityType.ENTITY_TEAR)

	--wizoob dropping missile guy
	yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
		local player = Isaac.GetPlayer(0)
		local controller = player.ControllerIndex
		local sprite = eff:GetSprite()
		local data = yandereWaifu.GetEntityData(eff)
		eff.GridCollisionClass =  EntityGridCollisionClass.GRIDCOLL_NOPITS 
		
		local room =  Game():GetRoom()
		
		for i, orb in pairs (Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.TARGET, -1, false, false)) do
			if not data.HasParent then
				data.HasParent = orb
			else
				if not data.HasParent:IsDead() then
					eff.Velocity = data.HasParent.Velocity
					eff.Position = data.HasParent.Position
				else
					eff.Velocity = eff.Velocity * 0.9
				end
			end
		end
		--function code
		if eff.FrameCount == 1 then
			sprite:Play("AppearDown", true)
			eff.SpriteOffset = Vector(0,-50)
		elseif sprite:IsFinished("AppearDown") then
			sprite:Play("ShootDown", true)
		elseif sprite:IsPlaying("ShootDown") then
			if sprite:IsEventTriggered("Shoot") then
				local ghostvomit = Isaac.Spawn(EntityType.ENTITY_BOMBDROP, 0, 0, eff.Position, Vector(0,0), eff):ToBomb() --this is a workaround to make explosions larger
				ghostvomit:SetExplosionCountdown(1)
				ghostvomit.Visible = false
				ghostvomit.RadiusMultiplier = 1.2 --my favorite part
				ghostvomit.ExplosionDamage = player.Damage*17.7013
				if player:HasWeaponType(WeaponType.WEAPON_LASER) then
					for i = 0, 360, 360/8 do
						local techlaser = player:FireTechLaser(eff.Position, 0, Vector.FromAngle(i), false, true)
						techlaser.CollisionDamage = player.Damage * 5
					end
				elseif player:HasWeaponType(WeaponType.WEAPON_BRIMSTONE) then
					for i = 0, 360, 360/8 do
						local brim = player:FireBrimstone(eff.Position, 0, Vector.FromAngle(i), false, true)
						brim.CollisionDamage = player.Damage * 2
						--brim:GetData().IsEctoplasm = true
					end
				else
					local chosenNumofBarrage =  math.random( 4, 8 );
					for i = 1, chosenNumofBarrage do
						local tear = player:FireTear( eff.Position,  Vector.FromAngle( math.random() * 360 ):Resized(7), false, false, false):ToTear()
						tear.Position = eff.Position
						tear.Scale = math.random() * 0.7 + 0.7;
						tear.FallingSpeed = -9 + math.random() * 2 ;
						tear.FallingAcceleration = 0.95;
						tear.CollisionDamage = player.Damage * 3.3;
						tear.TearFlags = tear.TearFlags | TearFlags.TEAR_EXPLOSIVE;
					end
				end
			end
		elseif sprite:IsFinished("ShootDown") then
			sprite:Play("VanishDown", true)
		elseif sprite:IsFinished("VanishDown") then
			eff:Remove()
		end
	end, RebekahCurse.ENTITY_WIZOOB_MISSILE)
	
	
--ghost missile
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
		local player = yandereWaifu.GetEntityData(eff).Parent
		local sprite = eff:GetSprite()
		local data = yandereWaifu.GetEntityData(eff)
		
		local movementDirection = player:GetShootingInput();
		local roomClampSize = math.max( player.Size, 20 )
		if movementDirection:Length() < 0.05 then
			eff.Velocity = Vector.Zero
		else
			eff.Position = ILIB.room:GetClampedPosition(eff.Position, roomClampSize);
			eff.Velocity = (eff.Velocity * 0.9) + movementDirection:Resized( REBEKAH_BALANCE.SOUL_HEARTS_DASH_TARGET_SPEED );
		end
		
		local room =  Game():GetRoom()
		--function code
		if eff.FrameCount == 1 then
			sprite:Play("Idle", true)
			yandereWaifu.RebekahCanShoot(player, false)
		elseif sprite:IsFinished("Idle") then
			sprite:Play("Blink",true)
		elseif eff.FrameCount == 55 then
			local missile = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_GHOSTMISSILE, 0, eff.Position, Vector.Zero, player) --heart effect
			yandereWaifu.GetEntityData(missile).ExtraTears = data.ExtraTears
			eff:Remove()
			yandereWaifu.RebekahCanShoot(player, true)
			player.FireDelay = 30
		end
		if eff.FrameCount < 35 then
			--player.Velocity = Vector(0,0)
		end
end, RebekahCurse.ENTITY_GHOSTTARGET)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, function(_,  eff) --eternal star
	local player = yandereWaifu.GetEntityData(eff).Parent
	local sprite = eff:GetSprite()
	local data = yandereWaifu.GetEntityData(eff)
	if not data.Init then      
		eff.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NOPITS 
		data.spr = Sprite()                                                 
		data.spr:Load("gfx/effects/soul/orbital_target.anm2", true) 
		data.spr:Play("Line", true)
		data.Init = true                                              
	end      
		
	InutilLib.DeadDrawRotatedTilingSprite(data.spr, Isaac.WorldToScreen(player.Position), Isaac.WorldToScreen(eff.Position), 16, nil, 8, true)
end, RebekahCurse.ENTITY_GHOSTTARGET);

yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	for p = 0, ILIB.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		local controller = player.ControllerIndex
		local sprite = eff:GetSprite()
		local data = yandereWaifu.GetEntityData(eff)
		eff.GridCollisionClass =  EntityGridCollisionClass.GRIDCOLL_NOPITS 
		
		local room =  Game():GetRoom()
		--function code
		if eff.FrameCount == 1 then
			sprite:Play("Falling", true)
			InutilLib.SFX:Play( RebekahCurseSounds.SOUND_SOULJINGLE, 1, 0, false, 1 );
		elseif sprite:IsEventTriggered("Blow") then
			local megumin = Isaac.Spawn(EntityType.ENTITY_BOMBDROP, 0, 0, eff.Position, Vector(0,0), eff):ToBomb() --this is a workaround to make explosions larger
			megumin:SetExplosionCountdown(1)
			megumin.Visible = false
			megumin.RadiusMultiplier = 1.6 --my favorite part
			megumin.ExplosionDamage = player.Damage*5
			ILIB.room:MamaMegaExplosion(megumin.Position)
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
			for i = 1, 2 do
				local minions = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PURGATORY, 1, eff.Position, Vector(0,0), player)
				minions:GetSprite():ReplaceSpritesheet(0, "gfx/effects/soul/purgatory_soul.png")
				minions:GetSprite():ReplaceSpritesheet(1, "gfx/effects/soul/purgatory_soul.png")
				minions:GetSprite():LoadGraphics()
			end
			local crack = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_SOULNUKECRACK, 0, eff.Position, Vector(0,0), player)
			yandereWaifu.GetEntityData(crack).ExtraTears = data.ExtraTears
		elseif sprite:IsFinished("Falling") then
			eff:Remove()
		end
		if eff.FrameCount < 35 then
			player.Velocity = Vector(0,0)
		end
	end
end, RebekahCurse.ENTITY_GHOSTMISSILE)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	for p = 0, ILIB.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		local controller = player.ControllerIndex
		local sprite = eff:GetSprite()
		local data = yandereWaifu.GetEntityData(eff)
		eff.GridCollisionClass =  EntityGridCollisionClass.GRIDCOLL_NOPITS 
		
		local room =  Game():GetRoom()
		--function code
		if eff.FrameCount == 1 then
			sprite:Play("HoleOpen_old", true)
		elseif sprite:IsFinished("HoleOpen_old") then
			sprite:Play("HoleIdle", true)
		elseif sprite:IsPlaying("HoleIdle") then
			if sprite:GetFrame() == 5 and math.random(1,3) == 3 then
				for i = 1, math.random(1,2) + data.ExtraTears do
					local minions = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PURGATORY, 1, eff.Position, Vector(0,0), player)
					minions:GetSprite():ReplaceSpritesheet(0, "gfx/effects/soul/purgatory_soul.png")
					minions:GetSprite():ReplaceSpritesheet(1, "gfx/effects/soul/purgatory_soul.png")
					minions:GetSprite():LoadGraphics()
				end
			end
		elseif sprite:IsFinished("HoleClose") then
			eff:Remove()
		end
		if eff.FrameCount > 105 then
			sprite:Play("HoleClose", false)
		end
		eff.RenderZOffset = -100
	end
end, RebekahCurse.ENTITY_SOULNUKECRACK)

	
	function yandereWaifu:EctoplasmLaser(lz)
		 if lz:GetData().IsEctoplasm then
			if lz.FrameCount == 1 then
				lz:SetColor(Color(0,0,0,0.7,170,170,210),9999999,99,false,false);
				lz:GetSprite():Load("gfx/effect_ectoplasmlaser.anm2", true)
				lz:GetSprite():Play("LargeRedLaser", true)
				if lz.Child ~= nil then
					lz.Child:GetSprite():Load("gfx/effect_ectoplasmlaserend.anm2", true)
					lz.Child:GetSprite():LoadGraphics()
					lz.Child.Color = lz.Parent:GetSprite().Color
				end
			end
		 end
		 if yandereWaifu.GetEntityData(lz).IsEctoplasm then
			local player = lz.SpawnerEntity:ToPlayer()
			local rand = math.random(1,2)
			if lz.FrameCount % 5 == 0 then
				for i = 1, rand do
					local circle = player:FireTechXLaser(lz.Position, Vector.FromAngle(math.random(1,360))*(20), math.random(20,40))
					yandereWaifu.GetEntityData(circle).IsEctoplasmLaserX = true
					circle.Visible = false
					--circle:SetColor(Color(0,0,0,0.7,170,170,210),9999999,99,false,false);
				end
			end
		end
		if yandereWaifu.GetEntityData(lz).IsEctoplasmLaser then
			lz.Visible = true
			lz:GetSprite():ReplaceSpritesheet(0, "gfx/effects/soul/techlaser.png");
			lz:GetSprite():LoadGraphics();
			if lz.Child ~= nil then
				lz.Child.Visible = true
				lz.Child:GetSprite():ReplaceSpritesheet(0, "gfx/effects/soul/tech_dot.png");
				lz.Child:GetSprite():LoadGraphics();
			end
		 end
		  if yandereWaifu.GetEntityData(lz).IsEctoplasmLaserX then
			lz.Visible = true
			lz:GetSprite():ReplaceSpritesheet(0, "gfx/effects/soul/techlaser.png");
			lz:GetSprite():LoadGraphics();
			if lz.Child ~= nil then
				lz.Child.Visible = true
				lz.Child:GetSprite():ReplaceSpritesheet(0, "gfx/effects/soul/techimpact.png");
				lz.Child:GetSprite():LoadGraphics();
			end
		 end
		if yandereWaifu.GetEntityData(lz).IsMonstrosLung and yandereWaifu.GetEntityData(lz).LaserCount > 0 then
			local player = lz.SpawnerEntity:ToPlayer()
			local techlaser = player:FireTechLaser(lz:GetEndPoint(), 0, Vector.FromAngle(lz.Angle + math.random(-30,30)), false, true)
			yandereWaifu.GetEntityData(techlaser).LaserCount = yandereWaifu.GetEntityData(lz).LaserCount - 1
			yandereWaifu.GetEntityData(techlaser).IsMonstrosLung = true
			yandereWaifu.GetEntityData(techlaser).IsEctoplasmLaser = true
			techlaser.Visible = false
			techlaser.OneHit = true;
			techlaser.Timeout = 1;
			techlaser:SetMaxDistance(60)
			techlaser.CollisionDamage = player.Damage;
		end
	end
	yandereWaifu:AddCallback(ModCallbacks.MC_POST_LASER_UPDATE, yandereWaifu.EctoplasmLaser)


	--bomb bundle tear
	function yandereWaifu:SBombRender(tr, _)
		if tr.Variant == RebekahCurse.ENTITY_SBOMBBUNDLE then
			tr:GetSprite():Play("RegularTear", false);
			--tr:GetSprite():LoadGraphics();
		end
	end
	yandereWaifu:AddCallback(ModCallbacks.MC_POST_TEAR_RENDER, yandereWaifu.SBombRender)

	--after bomb bundle coll functionality 
	yandereWaifu:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, function(_, tr)
		if tr.Variant == RebekahCurse.ENTITY_SBOMBBUNDLE then
			local player = yandereWaifu.GetEntityData(tr).Parent
			--print(tr.CollisionDamage)
			Isaac.Explode(tr.Position, tr, tr.CollisionDamage * 17.7)
			InutilLib.SFX:Play(RebekahCurseSounds.SOUND_SOULFETUS1, 1, 0, false, 1.2)
			for i = 1, math.random(7,10) + 3 * yandereWaifu.GetEntityData(tr).ExtraTears do
                InutilLib.SetTimer( i*8, function()
					local bomb = player:FireBomb( tr.Position + Vector(math.random(1,10),math.random(1,10)),  Vector(0,5):Rotated(math.random(1,360)):Resized(4))
                    --local bomb = Isaac.Spawn(EntityType.ENTITY_BOMBDROP, 0, 0, tr.Position + Vector(math.random(1,10),math.random(1,10)),  Vector(0,5):Rotated(math.random(1,360)):Resized(15), tr):ToBomb();
					local rng = math.random(1,3)
					if rng == 1 then
						yandereWaifu.GetEntityData(bomb).IsSmall = true
					elseif rng == 2 then
						yandereWaifu.GetEntityData(bomb).IsLarge = true
					end
					yandereWaifu.GetEntityData(bomb).IsGhostBombs = true
					bomb.ExplosionDamage = player.Damage*2.7
					InutilLib.MakeBombLob(bomb, 1, 15 )
                end);
			end
			yandereWaifu.SpawnEctoplasm( tr.Position, Vector ( 0, 0 ) , math.random(35,40)/10, player);
		end
	end, EntityType.ENTITY_TEAR)

	--"ectoplasm leaking after just teleporting" mechanic
	function yandereWaifu:EctoplasmLeaking(player) 
		local data = yandereWaifu.GetEntityData(player)
		if yandereWaifu.GetEntityData(player).currentMode == REBECCA_MODE.SoulHearts then	
			if data.LeaksJuices and data.LeaksJuices > 0 then
				data.LeaksJuices = data.LeaksJuices - 1
				if math.random(1,5) == 3 then
					yandereWaifu.SpawnEctoplasm( player.Position, Vector ( 0, 0 ) , 1, player);
				end
			end
			if data.LeakingSoulBuff then
				if data.LeakingSoulBuff <= 0 then
					yandereWaifu.GetEntityData(player).SoulBuff = false
					player:AddCacheFlags(CacheFlag.CACHE_DAMAGE);
					player:EvaluateItems()
					--become depressed again
					yandereWaifu.ApplyCostumes( yandereWaifu.GetEntityData(player).currentMode, data.Player , false, false)
					player:RemoveCostume(Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_NUMBER_ONE))
					player:AddNullCostume(RebekahCurseCostumes.WizoobHairGoingDown)
					InutilLib.SetTimer( 10*3, function()
						player:TryRemoveNullCostume(RebekahCurseCostumes.WizoobHairGoingDown)
					end)
					data.LeakingSoulBuff = nil
				else
					if not yandereWaifu.GetEntityData(player).IsAttackActive then
						data.LeakingSoulBuff = data.LeakingSoulBuff - 1
					end
					if not yandereWaifu.GetEntityData(player).SoulBuff then data.LeakingSoulBuff = nil end
				end
			end
		end
	end
	yandereWaifu:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, yandereWaifu.EctoplasmLeaking)
	
	--soul buff 
	yandereWaifu:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, function(_,tear)
		local parent, spr, data = tear.Parent, tear:GetSprite(), yandereWaifu.GetEntityData(tear)
		local player = parent:ToPlayer()
		
		if yandereWaifu.IsNormalRebekah(player) and yandereWaifu.GetEntityData(player).currentMode == REBECCA_MODE.SoulHearts then
			if yandereWaifu.GetEntityData(player).SoulBuff and not yandereWaifu.GetEntityData(player).IsAttackActive then --give lenience to the barrage
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
		end
	end)
	
	InutilLib.AddCustomCallback(yandereWaifu, ILIBCallbacks.MC_POST_FIRE_LASER, function(_, lz)
		if lz.SpawnerEntity then
			local player = lz.SpawnerEntity:ToPlayer()
			if player then
				if yandereWaifu.IsNormalRebekah(player) and yandereWaifu.GetEntityData(player).currentMode == REBECCA_MODE.SoulHearts then
					if yandereWaifu.GetEntityData(player).SoulBuff and not yandereWaifu.GetEntityData(player).IsAttackActive then --give lenience to the barrage
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
				end
			end
		end
	end)

	InutilLib.AddCustomCallback(yandereWaifu, ILIBCallbacks.MC_POST_FIRE_BOMB, function(_, bb)
		local player = bb.SpawnerEntity:ToPlayer()
		local pldata = yandereWaifu.GetEntityData(player)
		if player then
			if yandereWaifu.IsNormalRebekah(player) and yandereWaifu.GetEntityData(player).currentMode == REBECCA_MODE.SoulHearts then
				if yandereWaifu.GetEntityData(player).SoulBuff and not yandereWaifu.GetEntityData(player).IsAttackActive then --give lenience to the barrage
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
			end
		end
	end)

	yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, function(_,  eff)
		--local parent = eff.Parent
		local player = eff.SpawnerEntity:ToPlayer()
		--print(player)
		if player and player.Type == EntityType.ENTITY_PLAYER then
			if player then
				if yandereWaifu.IsNormalRebekah(player) and yandereWaifu.GetEntityData(player).currentMode == REBECCA_MODE.SoulHearts then
					if yandereWaifu.GetEntityData(player).SoulBuff and not yandereWaifu.GetEntityData(player).IsAttackActive then --give lenience to the barrage
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
				end
			end
		end
	end, EffectVariant.TARGET);

	InutilLib:AddCallback(ModCallbacks.MC_POST_KNIFE_UPDATE, function(_, kn)

		local player = kn.SpawnerEntity:ToPlayer()
		local pldata = yandereWaifu.GetEntityData(player)
		if player then
			if yandereWaifu.IsNormalRebekah(player) and yandereWaifu.GetEntityData(player).currentMode == REBECCA_MODE.SoulHearts then
				if yandereWaifu.GetEntityData(player).SoulBuff and not yandereWaifu.GetEntityData(player).IsAttackActive then --give lenience to the barrage
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
			end
		end
	end)
	
--sword drop
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
		local player = yandereWaifu.GetEntityData(eff).Parent
		local sprite = eff:GetSprite()
		local data = yandereWaifu.GetEntityData(eff)
		
		local room =  Game():GetRoom()
		--function code
		if eff.FrameCount == 1 then
			sprite:Play("Drop", true)
		elseif sprite:IsFinished("Drop") then
			eff:Remove()
		end
		if player then
			local damage = player.Damage*3 or 3.5
			if sprite:IsEventTriggered("Hurt") then
				InutilLib.SFX:Play(SoundEffect.SOUND_SWORD_SPIN, 0.5, 0, false, 1)
				InutilLib.SFX:Play(SoundEffect.SOUND_GOLD_HEART_DROP, 0.5, 0, false, 1)
				ILIB.game:ShakeScreen(5)
				for i, e in pairs(Isaac.GetRoomEntities()) do
					if e:IsActiveEnemy() and e:IsVulnerableEnemy() then
						if (eff.Position - e.Position):Length() < 80 then
							e:TakeDamage(damage, 0, EntityRef(eff), 4)
						end
					end
				end
			end
		end
end, RebekahCurse.ENTITY_SWORDDROP)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE, function(_, bb)
	if yandereWaifu.GetEntityData(bb).IsGhostBombs then
		local sprite = bb:GetSprite();
		if bb.Variant == BombVariant.BOMB_ROCKET then
			if bb.FrameCount == 1 then
				if yandereWaifu.GetEntityData(bb).IsSmall then
					bb:GetSprite():Load("gfx/items/pick ups/bombs/rocket0_reb.anm2", true)
					--bb.SpriteScale =  Vector(0.5,0.5)
					bb.SizeMulti = Vector(0.5,0.5)
				elseif  yandereWaifu.GetEntityData(bb).IsLarge then
					bb:GetSprite():Load("gfx/items/pick ups/bombs/rocket3_reb.anm2", true)
					--bb.SpriteScale =  Vector(1.5,1.5)
					bb.SizeMulti = Vector(1.5,1.5)
				else
					bb:GetSprite():Load("gfx/items/pick ups/bombs/rocket2_reb.anm2", true)
				end
				bb:GetSprite():Play("Pulse")
				bb:GetSprite():ReplaceSpritesheet(0, "gfx/items/pick ups/bombs/soul_barrage_rocket.png");
				bb:GetSprite():LoadGraphics();
			end
		else
			if bb.FrameCount == 1 then
				if yandereWaifu.GetEntityData(bb).IsSmall then
					bb:GetSprite():Load("gfx/items/pick ups/bombs/bomb0_reb.anm2", true)
					--bb.SpriteScale =  Vector(0.5,0.5)
					bb.SizeMulti = Vector(0.5,0.5)
				elseif  yandereWaifu.GetEntityData(bb).IsLarge then
					bb:GetSprite():Load("gfx/items/pick ups/bombs/bomb3_reb.anm2", true)
					--bb.SpriteScale =  Vector(1.5,1.5)
					bb.SizeMulti = Vector(1.5,1.5)
				else
					bb:GetSprite():Load("gfx/items/pick ups/bombs/bomb2_reb.anm2", true)
				end
				bb:GetSprite():Play("Pulse")
				bb:GetSprite():ReplaceSpritesheet(0, "gfx/items/pick ups/bombs/soul_barrage_bomb.png");
				bb:GetSprite():LoadGraphics();
			end
		end
	end
end)
end

