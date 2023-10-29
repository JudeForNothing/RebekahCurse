--Red
local redColor = Color(1,0,0,1.0,0,0,0)
--Orang
local orangeColor = Color(3,1,1,1.0,0,0,0)
--Yellow
local yellowColor = Color(5,5,1,1.0,0,0,0)
--Green
local greenColor = Color(1,2,1,1.0,0,0,0)
--Blue
local blueColor = Color(0,1,3,1.0,0,0,0)
--Purple
local purpleColor = Color(3,0,3,1.0,0,0,0)

local colorTable = {
	[1] = redColor, 
	[2] = orangeColor,
	[3] = yellowColor,
	[4] = greenColor,
	[5] = blueColor,
	[6] = purpleColor
}

yandereWaifu:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, ent)
	local spr = ent:GetSprite()
	local data = yandereWaifu.GetEntityData(ent)
	local player = ent:GetPlayerTarget()
	local room = InutilLib.room
	local invert = true
	if data.path == nil then data.path = ent.Pathfinder end
	if ent.Variant == RebekahCurse.Enemies.ENTITY_NINCOMPOOP then
		if not data.State then
			--spr:Play("Idle")
			data.State = 0
			ent:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
			ent:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
			ent:AddEntityFlags(EntityFlag.FLAG_SLIPPERY_PHYSICS)
		else
			if data.State == 0 then
				if not spr:IsPlaying("Idle") then
					spr:Play("Idle", true)
				end
				if math.random(1,3) == 3 and ent.FrameCount % 5 == 0 then
					if math.random(1,2) == 2 then
						data.State = 1
					else
						if (math.random(1,2) == 2 or #Isaac.FindByType(EntityType.ENTITY_DIP, -1, -1) > 2) and ent.HitPoints < ent.MaxHitPoints/2 then
							data.State = 9
						else
							data.State = 3
						end
					end
				end
				ent:GetSprite().FlipX = false
			elseif data.State == 1 then
				if spr:IsFinished("Whistle") then
					if math.random(1,3) == 3 then
						data.State = 7
					elseif ent.HitPoints >= ent.MaxHitPoints/2 then
						data.State = 2
					end
					InutilLib.SFX:Stop( RebekahCurse.Sounds.SOUND_NINCOMPOOP_WHISTLE);
				elseif not spr:IsPlaying("Whistle") then
					spr:Play("Whistle", true)
					InutilLib.SFX:Play( RebekahCurse.Sounds.SOUND_NINCOMPOOP_WHISTLE, 1, 0, false, 1.4);
				end
			elseif data.State == 2 then
				if spr:IsFinished("Shoot") or spr:IsFinished("SmileShoot") then
					data.State = 0
				elseif not spr:IsPlaying("Shoot") and not spr:IsPlaying("SmileShoot") then
					local rng = math.random(1,2)
					if rng == 1 then
						spr:Play("Shoot", true)
					else
						spr:Play("SmileShoot", true)
					end
				elseif spr:IsPlaying("Shoot") then
					if spr:GetFrame() == 1 then
						for i = 0, 4 do
							InutilLib.SetTimer( i*15, function()
								for i = -15, 15, 30 do
									local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, ((player.Position - ent.Position):Rotated(i)):Resized(10))
									proj.Scale = 1.5
								end
							end)
						end
						InutilLib.SFX:Play( RebekahCurse.Sounds.SOUND_NINCOMPOOP_SPIT, 1, 0, false, 1.3);
					end
				elseif spr:IsPlaying("SmileShoot") then
					if spr:GetFrame() == 22 then
						for i = -45, 45, 30 do
							--if i ~= 0 then
								local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, ((player.Position - ent.Position):Rotated(i)):Resized(10))
								proj.Scale = 1.5
							--end
						end
						InutilLib.SFX:Play( RebekahCurse.Sounds.SOUND_NINCOMPOOP_SPIT, 1, 0, false, 1.3);
					elseif spr:GetFrame() == 27 then
						for i = -30, 30, 30 do
							local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, ((player.Position - ent.Position):Rotated(i)):Resized(10))
							proj.Scale = 1.5
						end
						InutilLib.SFX:Play( RebekahCurse.Sounds.SOUND_NINCOMPOOP_SPIT, 1, 0, false, 1.3);
					end
				end
				local angle = (player.Position - ent.Position):GetAngleDegrees()
				if angle >= -90 and angle <= 90 then -- Left
					if invert == true then result = true else result = false end
				elseif angle >= 90 or angle <= -90 then -- Right
					if invert == true then result = false else result = true end
				end
				ent:GetSprite().FlipX = result
			elseif data.State == 3 then
				if spr:IsFinished("BeginCharge") then
					local rng = math.random(1,3)
					--[[if rng <= 10 and rng >= 0 then
						data.State = 4
					elseif rng <= 15 and rng >= 10 then
						data.State = 6
					elseif rng <= 18 and rng >= 15 then
						data.State = 7
					else
						data.State = 8
					end]]
					if rng == 1 and ent.HitPoints >= ent.MaxHitPoints/2 then
						data.State = 4
					elseif rng == 2 then
						data.State = 8
					else
						data.State = 6
					end
				elseif not spr:IsPlaying("BeginCharge") then
					spr:Play("BeginCharge", true)
				end
			elseif data.State == 4 then
				if ent.FrameCount % 3 == 0 then
					yandereWaifu:GuwahMakeAfterimage(ent)
				end
				if spr:IsFinished("DashBeautiful") then
					if data.DashTimes >= 3 then
						data.State = 5
					else
						spr:Play("DashBeautiful", true)
						data.DashTimes = data.DashTimes + 1
						data.OriginalDash = (player.Position - ent.Position)
					end
				elseif not spr:IsPlaying("DashBeautiful") then
					spr:Play("DashBeautiful", true)
					data.DashTimes = 0
					data.OriginalDash = (player.Position - ent.Position)
					InutilLib.SFX:Play( RebekahCurse.Sounds.SOUND_NINCOMPOOP_SPIT, 1, 0, false, 1);
				elseif spr:IsPlaying("DashBeautiful") then
					if spr:GetFrame() < 10 then
						if ent.FrameCount % 5 == 0 then
							ent.Velocity = ent.Velocity + data.OriginalDash:Resized(5.5)
							--[[local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_SLIPPERY_BROWN, 0, ent.Position, Vector(0,0), ent):ToEffect();
							creep:Update()
							creep.Timeout = 550]]
						end
					--[[elseif spr:GetFrame() < 20 and ent.FrameCount % 3 == 0 then
						ent.Velocity = ent.Velocity * 0.99]]
					elseif ent.FrameCount % 3 == 0 and spr:GetFrame() < 20 then
						InutilLib.MoveDirectlyTowardsTarget(ent, player, 4.5, 1)
						--[[if ent.FrameCount % 5 == 0 then
							local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_SLIPPERY_BROWN, 0, ent.Position, Vector(0,0), ent):ToEffect();
							creep:Update()
							creep.Timeout = 550
						end]]
					elseif spr:GetFrame() > 25 then 
						--ent.Velocity = ent.Velocity * 0.99
					else
						ent.Velocity = ent.Velocity * 0.999
					end
				end
				InutilLib.FlipXByVec(ent, invert)
			elseif data.State == 5 then --tired
				if spr:IsFinished("Tired") then
					data.State = 0
					--InutilLib.SFX:Stop( RebekahCurse.Sounds.SOUND_NINCOMPOOP_PANT);
				elseif spr:IsEventTriggered("Pant") then
					--InutilLib.SFX:Play( RebekahCurse.Sounds.SOUND_NINCOMPOOP_PANT, 1, 0, false, 1);
				elseif not spr:IsPlaying("Tired") then
					spr:Play("Tired", true)
				end
			elseif data.State == 6 then
				if spr:IsFinished("LongDash") then
					data.State = 5
				elseif not spr:IsPlaying("LongDash") then
					spr:Play("LongDash", true)
				elseif spr:IsPlaying("LongDash") then
					if spr:GetFrame() == 1 then
						InutilLib.MoveDirectlyTowardsTarget(ent, player, 11, 0.9)
					end
					if ent.FrameCount % 3 == 0 and spr:GetFrame() < 120 then
						--[[if ent.FrameCount % 5 == 0 then
							local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_SLIPPERY_BROWN, 0, ent.Position, Vector(0,0), ent):ToEffect();
							creep:Update()
							creep.Timeout = 550
						end]]
						if ent.FrameCount % 30 == 0 then
							InutilLib.MoveDirectlyTowardsTarget(ent, player, 11, 0.9)
							local dipCount = #Isaac.FindByType(EntityType.ENTITY_DIP, -1, -1)
							if dipCount < 6 then
								local fly = Isaac.Spawn(EntityType.ENTITY_DIP, 0, 0, ent.Position, Vector(0,0), ent):ToNPC()
								fly:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
								fly:GetSprite():ReplaceSpritesheet(0, "gfx/bosses/normal/greyscale_dip.png")
								if not data.Color then
									data.Color = 1
								else
									data.Color = data.Color + 1
									if data.Color > 6 then
										data.Color = 1
									end
								end
								fly:SetColor(colorTable[data.Color], 99999, 999999)
								fly:GetSprite():LoadGraphics()
								--InutilLib.SFX:Play( SoundEffect.SOUND_FART, 1, 0, false, 1);
								fly.HitPoints = 25
							end
							InutilLib.game:Fart(ent.Position, 100, ent, 1, 0)
							--[[local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_SLIPPERY_BROWN, 0, ent.Position, Vector(0,0), ent):ToEffect();
							creep.Scale = 1.5
							creep.SpriteScale = Vector(1.5, 1.5)
							creep:Update()
							creep.Timeout = 550]]
						end
					elseif spr:GetFrame() > 120 then
						ent.Velocity = ent.Velocity * 0.95
					end
				end
				InutilLib.FlipXByVec(ent, invert)
			elseif data.State == 7 then
				if spr:IsFinished("ShortDash") then
					data.State = 0
				elseif not spr:IsPlaying("ShortDash") then
					spr:Play("ShortDash", true)
					InutilLib.SFX:Play( RebekahCurse.Sounds.SOUND_NINCOMPOOP_SPIT, 1, 0, false, 1);
				elseif spr:IsPlaying("ShortDash") then
					if spr:GetFrame() == 1 then
						InutilLib.MoveDirectlyTowardsTarget(ent, player, 8, 0.9)
					end
				end
				InutilLib.FlipXByVec(ent, invert)
			elseif data.State == 8 then --just happy
				if spr:IsFinished("Shoot") then
					data.State = 0
				elseif not spr:IsPlaying("Shoot") then
					spr:Play("Shoot", true)
					InutilLib.SFX:Play( RebekahCurse.Sounds.SOUND_NINCOMPOOP_SPIT, 1, 0, false, 1);
				elseif spr:IsPlaying("Shoot") then
					if spr:GetFrame() == 1 then
						for i = 0, 4 do
							InutilLib.SetTimer( i*15, function()
								local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, ((player.Position - ent.Position)):Resized(10))
								proj.Scale = 1.5
								proj:AddProjectileFlags(ProjectileFlags.SMART)
							end)
						end
						InutilLib.SFX:Play( RebekahCurse.Sounds.SOUND_NINCOMPOOP_SPIT, 1, 0, false, 1.3);
					end
				end
				ent:GetSprite().FlipX = false
			elseif data.State == 9 then --charge like crazy
				if spr:IsFinished("BeginCharge2") then
					local rng = math.random(1,10)
					if #Isaac.FindByType(EntityType.ENTITY_DIP, -1, -1) > 0 and rng <= 5 and rng >= 1 then
						data.State = 10
					elseif rng <= 10 and rng >= 5 then
						data.State = 11
					end
					InutilLib.SFX:Stop( RebekahCurse.Sounds.SOUND_NINCOMPOOP_CHARGE);
				elseif not spr:IsPlaying("BeginCharge2") then
					spr:Play("BeginCharge2", true)
					InutilLib.SFX:Play( RebekahCurse.Sounds.SOUND_NINCOMPOOP_CHARGE, 1, 0, false, 1);
				end
				ent:GetSprite().FlipX = false
			elseif data.State == 10 then --dash wild
				yandereWaifu:GuwahMakeAfterimage(ent)
				--if close then
				for i, dip in pairs (Isaac.FindByType(EntityType.ENTITY_DIP, -1, -1)) do
					if ent.Position:Distance(dip.Position) <= 60 then
						dip:Die()
						InutilLib.game:MakeShockwave(ent.Position, 0.035, 0.025, 10)
						InutilLib.game:ShakeScreen(10)
						InutilLib.SFX:Play( RebekahCurse.Sounds.SOUND_NINCOMPOOP_PASS_BY, 1, 0, false, math.random(9,11)/10);
					end
				end
				if ent:CollidesWithGrid() then
					InutilLib.game:MakeShockwave(ent.Position, 0.035, 0.025, 10)
					InutilLib.game:ShakeScreen(10)
				end
				local dipCount = #Isaac.FindByType(EntityType.ENTITY_DIP, -1, -1)
				local function dash()
					local target
					local nearestDip = 0 -- labels the closest enemy
					for i, ent in pairs (Isaac.FindByType(EntityType.ENTITY_DIP, -1, -1)) do
						if nearestDip < ent.Position:Distance(player.Position) then
							nearestDip = ent.Position:Distance(player.Position)
							target = ent
						end
					end
					return target
				end
				if spr:IsFinished("Dash2") then
					if dipCount <= 0 then
						data.State = 2
						ent.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
						ent.Velocity = ent.Velocity * 0.25
						InutilLib.SFX:Play( RebekahCurse.Sounds.SOUND_NINCOMPOOP_CHARGE, 1, 0, false, math.random(9,11)/10);
					else
						spr:Play("Dash2", true)
						data.DashTimes = data.DashTimes + 1
						local target = dash()
						if target then
							data.OriginalDash = (target.Position - ent.Position)
						--[[else
							data.OriginalDash = (player.Position - ent.Position)]]
						end
					end
				elseif not spr:IsPlaying("Dash2") then
					spr:Play("Dash2", true)
					data.DashTimes = 0
					InutilLib.SFX:Play( RebekahCurse.Sounds.SOUND_NINCOMPOOP_SPIT, 1, 0, false, 1);
					local target = dash()
					if target then
						data.OriginalDash = (target.Position - ent.Position)
					end
					ent.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
				elseif spr:IsPlaying("Dash2") then
					if spr:GetFrame() < 10 then
						--if ent.FrameCount % 5 == 0 then
							local target = dash()
							if target then
								data.OriginalDash = (target.Position - ent.Position)
							--[[else
								data.OriginalDash = (player.Position - ent.Position)]]
							end
							ent.Velocity = ent.Velocity + data.OriginalDash:Resized(8)
						--end
					--[[elseif ent.FrameCount % 3 == 0 and spr:GetFrame() < 25 then
						InutilLib.MoveDirectlyTowardsTarget(ent, player, 4.5, 1)]]
					elseif spr:GetFrame() > 25 then 
						--ent.Velocity = ent.Velocity * 0.99
					else
						ent.Velocity = ent.Velocity * 0.999
					end
				end
				InutilLib.FlipXByVec(ent, invert)
			elseif data.State == 11 then --shoot nuts
				if spr:IsFinished("Shoot2") then
					data.State = 5
				elseif not spr:IsPlaying("Shoot2") then
					spr:Play("Shoot2", true)
				elseif spr:IsPlaying("Shoot2") then
					if spr:GetFrame() == 4 then
						data.ShootAngle = (ent.Position - player.Position):GetAngleDegrees() + 180
						yandereWaifu.AddGenericTracer(ent.Position, Color(1,0,0,1), data.ShootAngle, 14)
					elseif spr:GetFrame() == 18 then
						--[[local flip = InutilLib.WillFlip((ent.Position - player.Position):GetAngleDegrees(), false)
						if flip then
							data.ShootAngle = 0
						else
							data.ShootAngle = 180
						end]]
						InutilLib.game:MakeShockwave(ent.Position, 0.035, 0.025, 10)
						InutilLib.game:ShakeScreen(10)
						data.laser = EntityLaser.ShootAngle(14, ent.Position, data.ShootAngle, 88, Vector(0,-25), ent)
						data.laser.ParentOffset = Vector(15,0):Rotated(data.ShootAngle)
						yandereWaifu.GetEntityData(data.laser).IsRainbowNincompoop = true
						InutilLib.SFX:Play( SoundEffect.SOUND_LASERRING_STRONG, 1, 0, false, 1);
						InutilLib.FlipXByTarget(ent, player, false)
						--ent.Velocity = ent.Velocity + Vector(10,0):Rotated(data.ShootAngle):Resized(25)
					elseif spr:GetFrame() > 18 then
						ent.Velocity = ent.Velocity + Vector(10,0):Rotated(data.ShootAngle + 180):Resized(25)
						if ent:CollidesWithGrid() then
							InutilLib.game:MakeShockwave(ent.Position, 0.035, 0.025, 10)
							InutilLib.game:ShakeScreen(10)
							data.State = 5
							data.laser.Timeout = data.laser.FrameCount * 5 + 5
							ent.Velocity = Vector.Zero
						end 
					end
				end
			end
		end
		ent.Velocity = ent.Velocity * 0.95
	end
end, RebekahCurse.Enemies.ENTITY_REBEKAH_ENEMY)


yandereWaifu:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, damage, amount, damageFlag, damageSource, damageCountdownFrames) --invincibilityframe when dashing or whatnot
	if damage:IsEnemy() and damage:ToNPC().Type == RebekahCurse.Enemies.ENTITY_REBEKAH_ENEMY and damage:ToNPC().Variant == RebekahCurse.Enemies.ENTITY_NINCOMPOOP then
		if damage:ToNPC():GetSprite():IsPlaying("DashBeautiful") or (damage:ToNPC():GetSprite():IsPlaying("BeginCharge") and damage:ToNPC():GetSprite():GetFrame() >= 15) then
			return false
		end
	end
end)


if StageAPI and StageAPI.Loaded then	
	yandereWaifu.NincompoopStageAPIRooms = {
		StageAPI.AddBossData("Nincompoop", {
			Name = "Nincompoop",
			Portrait = "gfx/ui/boss/portrait_nincompoop.png",
			Offset = Vector(0,-15),
			Bossname = "gfx/ui/boss/name_nincompoop.png",
			Weight = 2,
			Rooms = StageAPI.RoomsList("Nincompoop Rooms", require("resources.luarooms.bosses.nincompoop")),
			Entity =  {Type = RebekahCurse.Enemies.ENTITY_REBEKAH_ENEMY, Variant = RebekahCurse.Enemies.ENTITY_NINCOMPOOP},
		})
	}

	StageAPI.AddBossToBaseFloorPool({BossID = "Nincompoop"},LevelStage.STAGE1_1,StageType.STAGETYPE_REPENTANCE_B)
	StageAPI.AddBossToBaseFloorPool({BossID = "Nincompoop"},LevelStage.STAGE1_2,StageType.STAGETYPE_REPENTANCE_B)
end