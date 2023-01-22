--MAGGY BOSS!--

local heartShapeVel = {
	[0] = 4*2,
	[1] = 3*2,
	[2] = 4*2,
	[3] = 3*2,
	[4] = 1*2,
	[5] = 3*2,
	[6] = 4*2,
	[7] = 3*2,
}

local beamColor = Color(1,1,0,0.5)

yandereWaifu:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, ent)
	local spr = ent:GetSprite()
	local data = yandereWaifu.GetEntityData(ent)
	local player = ent:GetPlayerTarget()
	if ent.Variant == RebekahCurseEnemies.ENTITY_MAGDALENE_BOSS then
		if ent.FrameCount == 1 then
			data.State = 0
			spr:Play("1Start", true)
			ent:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
		end
		if spr:IsFinished("1Start") then
			data.State = 1
			local start = 0
			for i = 0, 360 - 360/2, 360/2 do 
				local heart = Isaac.Spawn(EntityType.ENTITY_HEART, 0,0, ent.Position, Vector(0,0), ent)
				yandereWaifu.GetEntityData(heart).Parent = ent
				yandereWaifu.GetEntityData(heart).startingNum = start
				yandereWaifu.GetEntityData(heart).IsMaggyHeart = true
				heart:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
				heart:GetSprite():ReplaceSpritesheet(0, "gfx/bosses/rivals/maggy/orbitalheart.png")
				heart:GetSprite():LoadGraphics()
				start = start + 90
			end
			
			ent.HitPoints = 570
		end
		if data.State ~= 1 then
			ent.Velocity = ent.Velocity * 0.7
			--local heart = Isaac.Spawn(1000, 198,0, ent.Position, Vector(0,0), ent)
			--local heart = Isaac.Spawn(1000, 128,0, ent.Position, Vector(0,0), ent)
		end
		
		if ent:CollidesWithGrid() then
			ent.Velocity = (ent.Velocity:Rotated(180)):Resized(20)
		end
		
		if data.State == 1 then --phase one idle
			--InutilLib.MoveRandomlyTypeI(ent, ILIB.room:GetCenterPos(), 4, 0.3, 25, 20, 30)
			local path = InutilLib.GenerateAStarPath(ent.Position, player.Position)
		
			--if (ent.Position - player.Position):Length() > 300 then
			if path then
				InutilLib.FollowPath(ent, player, path, 0.3, 0.9)
			else
				InutilLib.MoveDirectlyTowardsTarget(ent, player, 0.8, 0.9)
			end
			--end
			data.State = 1
			if math.random(1,4) == 4 and ent.FrameCount % 60 == 0 then
				--ent.State = 2
				data.State = math.random(2,4)
			end
			
			InutilLib.AnimShootFrame(ent, false, ent.Velocity, "1WalkRight", "1WalkFront", "1WalkBack", "1WalkLeft")
			
			if math.random(1,2) == 2 and ent.FrameCount % 60 == 0 then
				if InutilLib.CuccoLaserCollision(ent, 0, 700, player) then
					data.State = 5
					spr:Play("1ShootRight", true)
				elseif InutilLib.CuccoLaserCollision(ent, 90, 700, player) then
					data.State = 5
					spr:Play("1ShootFront", true)
				elseif InutilLib.CuccoLaserCollision(ent, 180, 700, player) then
					data.State = 5
					spr:Play("1ShootLeft", true)
				elseif InutilLib.CuccoLaserCollision(ent, 270, 700, player) then
					data.State = 5
					spr:Play("1ShootBack", true)
				end
			end
		end
		
		if data.State == 2 then --phase one tear burst
			if spr:IsFinished("1Attack") then
				data.State = 1
			end
			if not spr:IsPlaying("1Attack") then
				spr:Play("1Attack", true)
			elseif spr:IsPlaying("1Attack") then
				if spr:GetFrame() == 8 then
					local num = 0
					local randomRot = math.random(-20,10)
					for i = 0, 360-360/8, 360/8 do
						local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, (Vector(0,40):Rotated(i+randomRot)):Resized(heartShapeVel[num]))
						num = num + 1
						proj.Scale = 1.7
					end
					--local splat = Isaac.Spawn(EntityType.ENTITY_EFFECT, 2, 6, ent.Position, Vector(0,0), ent)
				end
			end
		end
		
		if data.State == 3 then --phase one tear burst
			if spr:IsFinished("1Attack2") then
				data.State = 1
			end
			if not spr:IsPlaying("1Attack2") then
				spr:Play("1Attack2", true)
			elseif spr:IsPlaying("1Attack2") then
				if ((spr:GetFrame() >= 11 and spr:GetFrame() <= 19) or (spr:GetFrame() >= 31 and spr:GetFrame() <= 39)) and ent.FrameCount % 3 == 0 then
					--local num = 0
					--local randomRot = math.random(-20,10)
					for i = 0, 360-360/16, 360/16 do
						local proj = InutilLib.FireGenericProjAttack(ent, 0, 0, ent.Position, (Vector(0,40):Rotated(i)):Resized(8))
						--num = num + 1
					end
					--local splat = Isaac.Spawn(EntityType.ENTITY_EFFECT, 2, 6, ent.Position, Vector(0,0), ent)
				end
			end
		end
		if data.State == 4 then --phase one tear burst
			if spr:IsFinished("1Attack3") then
				data.State = math.random(1,2)
			end
			if not spr:IsPlaying("1Attack3") then
				spr:Play("1Attack3", true)
			elseif spr:IsPlaying("1Attack3") then
				if spr:GetFrame() == 10 then
					--local num = 0
					local randomRot = math.random(-3,3)
					for i = 0, 360-360/15, 360/15 do
						local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, (Vector(0,40):Rotated(i+randomRot)):Resized(10))
						proj.Scale = 0.5
						--num = num + 1
					end
					--local splat = Isaac.Spawn(EntityType.ENTITY_EFFECT, 2, 6, ent.Position, Vector(0,0), ent)
				end
			end
		end		
		if data.State == 5 then --phase one sneeze
			if InutilLib.IsFinishedMultiple(spr, "1ShootFront", "1ShootLeft", "1ShootBack", "1ShootRight") then
				data.State = 1
			end
			if spr:IsEventTriggered("Fire") then
				local angle = 0
				if spr:IsPlaying("1ShootFront") then
					angle = 90
				elseif spr:IsPlaying("1ShootLeft") then
					angle = 180
				elseif spr:IsPlaying("1ShootBack") then
					angle = 270
				elseif spr:IsPlaying("1ShootRight") then
					angle = 0
				end
				
				for i = 1, 3 do
					local adjustingAng = 0
					if i == 1 then
						adjustingAng = -30
					elseif i == 3 then
						adjustingAng = 30
					end
					local beam = EntityLaser.ShootAngle(1, ent.Position, angle + adjustingAng, 10, Vector(0,0), ent):ToLaser();
					--beam.Timeout = 7
					if i == 1 or i == 3 then
						beam.MaxDistance = 150
						--InutilLib.UpdateLaserSize(beam, 0.8, withMultiplier)
					end
				end
			end
		end
		--ent.State = 69
		
		if not data.isPhase2 then --phase 2 transition
			if ent.HitPoints <= ent.MaxHitPoints/2 then
				data.isPhase2 = true
				--data.State = 7
				data.State = 6
				spr:Play("1Transition", true)
			end
		end
		
		if data.State == 6 then--transition state
			if spr:IsFinished("1Transition") then
				data.State = 17
				for i = 1, 2 do
					local heart = Isaac.Spawn(RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY, RebekahCurseEnemies.ENTITY_MAGDALENE_HEART, 0, ent.Position, Vector(0,20):Rotated(math.random(1,360)), ent)
					heart:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
				end
			end
			if spr:IsPlaying("1Transition") then
				if spr:GetFrame() >= 10 and spr:GetFrame() <= 50 then
					--local num = 0
					local randomRot = math.random(-3,3)
					for i, v in ipairs (Isaac.GetRoomEntities()) do
						if v.Type == EntityType.ENTITY_HEART then
							if yandereWaifu.GetEntityData(v).IsMaggyHeart then
								yandereWaifu.GetEntityData(v).IsMaggyHeart = false
								yandereWaifu.GetEntityData(v).GetSucked = true 
							end
							if yandereWaifu.GetEntityData(v).GetSucked then
								InutilLib.MoveDirectlyTowardsTarget(v, ent, 14, 0.9)
								if v.Position:Distance(ent.Position) <= 30 then
									v.HitPoints = 1
									v:Kill()
									ent.HitPoints = ent.HitPoints + 100
								end
							end
						end
					end
					if math.random(1,3) == 3 then
						if math.random(1,3) == 3 then
							local suck = Isaac.Spawn(EntityType.ENTITY_EFFECT, 151, 0, ent.Position, Vector(0,0), nil)
						end
						local suckEff = Isaac.Spawn(EntityType.ENTITY_EFFECT, 151, 1, ent.Position, Vector(0,0), nil)
					end
				end
			end
		end
		
		if data.State == 17 then --phase two idle
			Isaac.DebugString("7")
			--InutilLib.MoveRandomlyTypeI(ent, ILIB.room:GetCenterPos(), 4, 0.3, 25, 20, 30)
		
			--if (ent.Position - player.Position):Length() > 300 then
			--if path then
			--	InutilLib.FollowPath(ent, player, path, 0.4, 0.9)
			--else
			InutilLib.MoveDirectlyTowardsTarget(ent, player, 1, 0.9)
			--end
			--end
			
			if math.random(1,5) == 5 and ent.FrameCount % 60 == 0 and ent.HitPoints <= 300 then
				data.State = 11
			end
			
			if math.random(1,4) == 4 and ent.FrameCount % 60 == 0 then
				data.State = math.random(9,10)
			end
			
			if not spr:IsPlaying("2FlyIdle") then
				spr:Play("2FlyIdle", true)
			end
			
			if math.random(1,5) == 5 and ent.FrameCount % 3 == 0 then
				if InutilLib.CuccoLaserCollision(ent, 0, 700, player) or InutilLib.CuccoLaserCollision(ent, 90, 700, player) or InutilLib.CuccoLaserCollision(ent, 180, 700, player) or InutilLib.CuccoLaserCollision(ent, 270, 700, player) then
					if math.random(1,2) == 2 then
						data.State = 8
						spr:Play("2Attack", true)
					else
						data.State = math.random(9,10)
					end
				end
			end
		end
		if data.State == 8 then --phase two laser thing
			Isaac.DebugString("8")
			if InutilLib.IsFinishedMultiple(spr, "2Attack") then
				data.State = 17
			end
			if spr:GetFrame() == 1 then
				data.extraAng = 0
				if math.random(1,2) == 2 then --randomly make it angle like an X
					data.extraAng = 45
				end
				--laser indicator
				for j = 0, 360 - 360/4, 360/4 do
					local angle = j + data.extraAng
					yandereWaifu.AddGenericTracer(ent.Position, beamColor, angle)
				end
			end
			if spr:GetFrame() == 16 then			
				for j = 0, 360 - 360/4, 360/4 do
					local angle = j + data.extraAng
					--[[for i = 1, 3 do
						local adjustingAng = 0
						if i == 1 then
							adjustingAng = -12
						elseif i == 3 then
							adjustingAng = 12
						end]]
						local beam = EntityLaser.ShootAngle(5, ent.Position, angle, 10, Vector(0,0), ent):ToLaser();
						--beam.Timeout = 7
					--[[	if i == 1 or i == 3 then
							beam.MaxDistance = 70
							--InutilLib.UpdateLaserSize(beam, 16, false)
						end
					end]]
				end
				for i = 0, 360-360/15, 360/15 do
					local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, (Vector(0,40):Rotated(i)):Resized(10))
					proj.Scale = 0.7
					--num = num + 1
				end
			end
		end
		
		if data.State == 9 then --phase two tear burst
			Isaac.DebugString("9")
			if spr:IsFinished("2Attack2") then
				data.State = 17
			end
			if not spr:IsPlaying("2Attack2") then
				spr:Play("2Attack2", true)
			elseif spr:IsPlaying("2Attack2") then
				if spr:GetFrame() == 17 then
					print("once alone")
					local num = 0
					--circle
					for i = 0, 360-360/15, 360/15 do
						local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, (Vector(0,40):Rotated(i)):Resized(10))
						proj.Scale = 0.5
						--num = num + 1
					end
					--smile
					for i = -30, 30, 15 do
						local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, ((ent.Position-player.Position):Rotated(i+180)):Resized(6))
						proj.Scale = 1.1
					end
					--eyes
					for i = -45, 45, 90 do
						local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, ((ent.Position-player.Position):Rotated(i)):Resized(7))
						proj.Scale = 2
					end
					local splat = Isaac.Spawn(EntityType.ENTITY_EFFECT, 2, 6, ent.Position, Vector(0,0), ent)
				end
			end
		end
		if data.State == 10 then --phase two summon
			Isaac.DebugString("10")
			if spr:IsFinished("2Attack3") then
				data.State = 17
			end
			if not spr:IsPlaying("2Attack3") then
				spr:Play("2Attack3", true)
			elseif spr:IsPlaying("2Attack3") then
				if spr:GetFrame() == 20 then
					local num = 0
					for i, v in pairs (Isaac.GetRoomEntities()) do
						if v.Type == RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY and v.Variant == RebekahCurseEnemies.ENTITY_MAGDALENE_HEART then
							num = num + 1
						end
					end
					if num < 7 then
						local ran = math.random(1,2)
						for i = 1, ran do
							local heart = Isaac.Spawn(RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY, RebekahCurseEnemies.ENTITY_MAGDALENE_HEART, 0, ent.Position, Vector(0,15):Rotated(math.random(1,360)), ent)
							heart:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
						end
					else
						for i, v in ipairs (Isaac.GetRoomEntities()) do
							if v.Type == RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY and v.Variant == RebekahCurseEnemies.ENTITY_MAGDALENE_HEART then
								if not v:GetSprite():IsPlaying("HeartAttack") then
									v:GetSprite():Play("HeartAttack", true)
								end
							end
						end
					end
					local splat = Isaac.Spawn(EntityType.ENTITY_EFFECT, 2, 6, ent.Position, Vector(0,0), ent)
				end
			end
		end	
		if data.State == 11 then
			Isaac.DebugString("11")
			if spr:IsFinished("2AttackPrepare") then
				if math.random(1,2) == 1 then
					spr:Play("2AttackChain", true)
				else
					spr:Play("2AttackChain2", true)
				end
			elseif spr:IsFinished("2AttackChain") or spr:IsFinished("2AttackChain2") then
				if data.ChainAttackTier > 2 then
					spr:Play("2AttackFinish", true)
				else
					if math.random(1,2) == 1 then
						spr:Play("2AttackChain", true)
					else
						spr:Play("2AttackChain2", true)
					end
					data.ChainAttackTier = data.ChainAttackTier + 1
				end
			elseif spr:IsPlaying("2AttackChain2") then
				--laser indicator
				if spr:GetFrame() == 1 then
					if data.ChainAttackTier == 0 then
						for j = 0, 360 - 360/4, 360/4 do
							local angle = j 
							yandereWaifu.AddGenericTracer(ent.Position, beamColor, angle, 7)
						end
					elseif data.ChainAttackTier == 1 then
						for j = 0, 360 - 360/4, 360/4 do
							local angle = j  + 45
							yandereWaifu.AddGenericTracer(ent.Position, beamColor, angle, 7)
						end
					elseif data.ChainAttackTier == 2 then
						local ext = 0
						for j = 0, 360 - 360/4, 360/4 do
							local angle = j + ext
							yandereWaifu.AddGenericTracer(ent.Position,beamColor, angle, 7)
						end
					end
				end
				if spr:IsEventTriggered("Fire") then
					if data.ChainAttackTier == 0 then
						for j = 0, 360 - 360/4, 360/4 do
							local angle = j 
							local beam = EntityLaser.ShootAngle(5, ent.Position, angle, 10, Vector(0,0), ent):ToLaser();
						end
					elseif data.ChainAttackTier == 1 then
						for j = 0, 360 - 360/4, 360/4 do
							local angle = j  + 45
							local beam = EntityLaser.ShootAngle(5, ent.Position, angle, 10, Vector(0,0), ent):ToLaser();
						end
					elseif data.ChainAttackTier == 2 then
						local ext = 0
						for j = 0, 360 - 360/4, 360/4 do
							local angle = j + ext
							local beam = EntityLaser.ShootAngle(5, ent.Position, angle, 10, Vector(0,0), ent):ToLaser();
						end
					end
				end
			elseif spr:IsPlaying("2AttackChain") then
				if spr:IsEventTriggered("Fire") then
					if data.ChainAttackTier <= 1 then
						local num = 0
						local randomRot = math.random(-20,10)
						for i = 0, 360-360/8, 360/8 do
							local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, (Vector(0,40):Rotated(i+randomRot)):Resized(heartShapeVel[num]))
							num = num + 1
							proj.Scale = 1.7
						end
					elseif data.ChainAttackTier == 2 then
						local num = 0
						local randomRot = math.random(-20,10)
						for i = 0, 360-360/8, 360/8 do
							local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, (Vector(0,40):Rotated(i+randomRot)):Resized(heartShapeVel[num]))
							local proj2 = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, (Vector(0,20):Rotated(i+randomRot)):Resized(heartShapeVel[num]))
							proj2.Scale = 0.5
							num = num + 1
						end
						for i = 0, 360-360/8, 360/8 do
							local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, (Vector(0,40):Rotated(i)):Resized(8))
							proj.Scale = 0.9
							--num = num + 1
						end
					end
					local splat = Isaac.Spawn(EntityType.ENTITY_EFFECT, 2, 6, ent.Position, Vector(0,0), ent)
				end
			elseif spr:IsPlaying("2AttackFinish") then
				if spr:GetFrame() == 20 then
					for j = 0, 360 - 360/8, 360/8 do
						local angle = j + 45
						yandereWaifu.AddGenericTracer(ent.Position, beamColor, angle, 12)
					end
				end
				if spr:GetFrame() == 32 then
					local num = 0
					local randomRot = math.random(-20,10)
					for i = 0, 360-360/8, 360/8 do
						local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, (Vector(0,40):Rotated(i+randomRot)):Resized(heartShapeVel[num]))
						local proj2 = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, (Vector(0,20):Rotated(i+randomRot)):Resized(heartShapeVel[num]))
						proj2.Scale = 0.5
						num = num + 1
					end
					for j = 0, 360 - 360/8, 360/8 do
						local angle = j + 45
						local beam = EntityLaser.ShootAngle(5, ent.Position, angle, 10, Vector(0,0), ent):ToLaser();
					end
					for i = 0, 360-360/8, 360/8 do
						local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, (Vector(0,40):Rotated(i)):Resized(8))
						proj.Scale = 0.5
						--num = num + 1
					end
					local splat = Isaac.Spawn(EntityType.ENTITY_EFFECT, 2, 6, ent.Position, Vector(0,0), ent)
				end
				if spr:GetFrame() == 54 then
					local num = 0
					local randomRot = math.random(-20,10)
					for i = 0, 360-360/8, 360/8 do
						local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, (Vector(0,40):Rotated(i+randomRot)):Resized(heartShapeVel[num]))
						local proj2 = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, (Vector(0,20):Rotated(i+randomRot)):Resized(heartShapeVel[num]))
						proj2.Scale = 0.5
						local proj3 = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, (Vector(0,30):Rotated(i+randomRot)):Resized(heartShapeVel[num]))
						proj3.Scale = 0.4
						num = num + 1
					end
					local splat = Isaac.Spawn(EntityType.ENTITY_EFFECT, 2, 6, ent.Position, Vector(0,0), ent)
				end
			elseif spr:IsFinished("2AttackFinish") then
				data.State = 17
				data.ChainAttackTier = 0
			elseif not InutilLib.IsPlayingMultiple(spr, "2AttackPrepare", "2AttackChain", "2AttackChain2", "2AttackFinish") then
				spr:Play("2AttackPrepare", true)
				data.ChainAttackTier = 0
			end
		end
		for i, v in ipairs (Isaac.GetRoomEntities()) do
			if v.Type == RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY and v.Variant == RebekahCurseEnemies.ENTITY_MAGDALENE_HEART then
				if math.floor(ent.FrameCount % math.floor(ent.HitPoints/5)) == 0 and not v:GetSprite():IsPlaying("HeartAttack") then
					v:GetSprite():Play("HeartAttack", true)
				end
			end
		end
	end

end, RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY)

yandereWaifu:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, ent)
	local data = yandereWaifu.GetEntityData(ent)
	if data.IsMaggyHeart then
		InutilLib.MoveOrbitAroundTargetType1(ent, data.Parent, 6, 0.9, 3, data.startingNum)
		ent.HitPoints = 3000
		
		if data.Parent:IsDead() then
			ent:Die()
		end
	end
	--if data.GetSucked then
		
	--end
end, EntityType.ENTITY_HEART)

yandereWaifu:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, ent)
	local spr = ent:GetSprite()
	local data = yandereWaifu.GetEntityData(ent)
	local player = ent:GetPlayerTarget()
	if ent.Variant == RebekahCurseEnemies.ENTITY_MAGDALENE_HEART then
		if ent.FrameCount == 1 then
			ent:GetSprite():ReplaceSpritesheet(0, "gfx/bosses/rivals/maggy/beatingheart.png")
			ent:GetSprite():LoadGraphics()
		end
		if ent:CollidesWithGrid() then
			ent.Velocity = (ent.Velocity:Rotated(180)):Resized(10)
		end
		
		if spr:IsPlaying("HeartAttack") then
			if spr:GetFrame() == 3 then
				InutilLib.MoveRandomlyTypeI(ent, Isaac.GetRandomPosition(), 10, 0.9, 15)
			elseif spr:IsEventTriggered("Shoot") then
				for i = 0, 360 -360/4, 360/4 do
					local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, ((Vector(40,0)):Rotated(i)):Resized(7))
				end
			end
		else
			spr:Play("Heart")
		end
		ent.Velocity = ent.Velocity *0.8
		if math.random(1,5) == 5 and ent.FrameCount % 30 == 0 then
			local heart = Isaac.Spawn(1000, 7, 1, ent.Position, Vector(0,4):Rotated(math.random(1,360)), ent)
		end
	end

end, RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY)
