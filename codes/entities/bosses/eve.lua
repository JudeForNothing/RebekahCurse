--EVE BOSS!--
yandereWaifu:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, function(_, proj)
	local data = yandereWaifu.GetEntityData(proj)
	if data.Bloodbend1 and proj.FrameCount == 1 then
		--print(ILIB.room:GetGridEntity(ILIB.room:GetGridIndex((proj.Position +Vector(0,40):Rotated(data.BloodbendAngle - 90)))))
		proj.Scale = 1.7
		proj.FallingSpeed = (10)*-1;
		proj.FallingAccel = 1;
		if ILIB.room:GetGridEntity(ILIB.room:GetGridIndex((proj.Position +Vector(0,40):Rotated(data.BloodbendAngle - 90)))) == nil then
			local splat = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_RED, 0, proj.Position + (Vector(0,40):Rotated(data.BloodbendAngle - 90)), Vector(0,0), nil)
			local proje = InutilLib.FireGenericProjAttack(proj, 0, 1, proj.Position + (Vector(0,40):Rotated(data.BloodbendAngle - 90)), Vector.Zero)
			yandereWaifu.GetEntityData(proje).Bloodbend1 = true
			yandereWaifu.GetEntityData(proje).BloodbendAngle = data.BloodbendAngle
		end
	elseif data.Bloodbend2 then
		if proj.FrameCount == 1 then
			proj.Scale = 1.7
			proj.FallingSpeed = (10)*-1;
			proj.FallingAccel = 1;
		else
			if proj.Height <= 12 then
				proj.Height = -24
			end
			proj.FallingAccel = 0
		end
	end
end)


yandereWaifu:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, ent)
	local spr = ent:GetSprite()
	local data = yandereWaifu.GetEntityData(ent)
	local player = ent:GetPlayerTarget()
	if ent.Variant == RebekahCurseEnemies.ENTITY_EVE_BOSS then
		if ent.FrameCount == 1 then
			print("wot")
			data.State = 0
			spr:Play("1Start", true)
			ent:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
			ent:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
			data.SummonTimes = 1
		end
		if spr:IsFinished("1Start") then
			data.State = 1
			data.SummonTimes = 1
		end
		
		if spr:IsPlaying("1Transition") then
			ent.Velocity = ent.Velocity * 0.7
		end
		
		--[[if ent:CollidesWithGrid() then
			ent.Velocity = (ent.Velocity:Rotated(180)):Resized(6)
		end]]
		
		if not data.SummonOne and ent.HitPoints <= 500 then
			data.SummonTimes = data.SummonTimes + 1
			data.SummonOne = true
		end
		if not data.SummonTwo and ent.HitPoints <= 400 then
			data.SummonTimes = data.SummonTimes + 1
			data.SummonTwo = true
		end
		if not data.SummonThree and ent.HitPoints <= 300 then
			data.SummonTimes = data.SummonTimes + 1
			data.SummonThree = true
		end
		
		if spr:IsFinished("1Transition") then
			spr:Load("gfx/bosses/rivals/eve2.anm2", true)
			data.State = 1
		elseif not spr:IsPlaying("1Transition") then
			if ent.HitPoints <= 200 and not data.SecondPhase then
				data.State = 0
				data.SecondPhase = true
				spr:Play("1Transition", true)
			end
			if data.State == 1 then --phase one idle
				--InutilLib.MoveRandomlyTypeI(ent, ILIB.room:GetCenterPos(), 4, 0.3, 25, 20, 30)
				--local path = InutilLib.GenerateAStarPath(ent.Position, player.Position)
			
				
				--if path then
				--	InutilLib.FollowPath(ent, player, path, 0.7, 0.9)
				--else
				--	InutilLib.MoveDirectlyTowardsTarget(ent, player, 1.2, 0.9)
				--end
				--if (ent.Position - player.Position):Length() > 250 then
					--InutilLib.MoveRandomlyTypeI(ent, player.Position, 2.2, 0.9, 75, 15, 30)
				if data.SecondPhase then
					InutilLib.StrafeAroundTarget(ent, player, 0.8, 0.9, data.strafeNum or 30)
				else
					InutilLib.StrafeAroundTarget(ent, player, 0.7, 0.9, data.strafeNum or 30)
				end
				--else
				--	InutilLib.MoveAwayFromTarget(ent, player, 5.2, 0.9)
				--	InutilLib.StrafeAroundTarget(ent, player, 0.7, 0.9, 30)
				--end
				--end
				data.State = 1
				if (math.random(1,5) == 5 and ent.FrameCount % 30 == 0) or ent:CollidesWithGrid() then
					--ent.State = 2
				--	data.State = math.random(2,4)
					if data.strafeNum == 30 then
						data.strafeNum = -30
					else
						data.strafeNum = 30
					end
				end
				
				if ent.FrameCount % 15 == 0 then
					local splat = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_RED, 0, ent.Position, Vector(0,0), nil):ToEffect()
				end
				
				InutilLib.AnimShootFrame(ent, false, ent.Velocity, "1WalkRight", "1WalkFront", "1WalkBack", "1WalkLeft")
				
				if ent.FrameCount % 15 == 0 then
					if InutilLib.CuccoLaserCollision(ent, 0, 700, player) then
						if math.random(1,2) == 2 then
							data.State = 2
							spr:Play("1AttackRight", true)
						else
							data.State = 3
							spr:Play("1SwipeRight", true)
						end
					elseif InutilLib.CuccoLaserCollision(ent, 90, 700, player) then
						data.State = 2
						spr:Play("1AttackFront", true)
					elseif InutilLib.CuccoLaserCollision(ent, 180, 700, player) then
						if math.random(1,2) == 2 then
							data.State = 2
							spr:Play("1AttackLeft", true)
						else
							data.State = 3
							spr:Play("1SwipeLeft", true)
						end
					elseif InutilLib.CuccoLaserCollision(ent, 270, 700, player) then
						data.State = 2
						spr:Play("1AttackBack", true)
					end
					
					if math.random(1,4) == 4 and data.State == 1 then
						local creepCount = 0
						for i, v in ipairs (Isaac.GetRoomEntities()) do
							if v and not v:IsDead() then
								if v.Type == EntityType.ENTITY_EFFECT and v.Variant == EffectVariant.CREEP_RED then
									creepCount = creepCount + 1
								end
							end
						end
						if creepCount > 4 and math.random(1,3) then
							data.State = 5
							spr:Play("1Attack2", true)
						elseif ent.HitPoints <= 350 then
							local cleared
							for i, v in pairs (Isaac.GetRoomEntities()) do
								if (v.Type == RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY and (v.Variant == RebekahCurseEnemies.ENTITY_BLOOD_SLOTH or v.Variant == RebekahCurseEnemies.ENTITY_BLOOD_WRATH) or v.Type == EntityType.ENTITY_BEGOTTEN) and not v:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
									cleared = false
									break
								end
								cleared = true
							end
							if cleared and not data.SecondPhase and data.SummonTimes > 0 then
								data.State = 4
								spr:Play("1PrepareSpecial", true)
							end
						end
					elseif math.random(1,2) == 2 and data.SecondPhase then
						spr:Play("Rage", true)
						data.State = 6
					end
				end
			end
			
			if data.State == 2 then --phase one tear burst
				if InutilLib.IsFinishedMultiple(spr, "1AttackFront", "1AttackLeft", "1AttackBack", "1AttackRight") then
					data.State = 1
				end
				if spr:IsEventTriggered("Attack") then
					local angle = 0
					if spr:IsPlaying("1AttackFront") then
						angle = 90
					elseif spr:IsPlaying("1AttackLeft") then
						angle = 180
					elseif spr:IsPlaying("1AttackBack") then
						angle = 270
					elseif spr:IsPlaying("1AttackRight") then
						angle = 0
					end
					
					for i = -30, 30, 15 do
						local adjustingAng = 0
						if i == 1 then
							adjustingAng = -30
						elseif i == 3 then
							adjustingAng = 30
						end
						local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, (Vector(0,40):Rotated(i + angle - 90)):Resized(10))
						proj.Scale = 1.5
					end
				end
				ent.Velocity = ent.Velocity * 0.8
			end
			if data.State == 3 then --phase one tear burst
				if InutilLib.IsFinishedMultiple(spr, "1SwipeRight", "1SwipeLeft") then
					data.State = 1
				end
				if spr:IsEventTriggered("Attack") then
					local angle = 0
					if spr:IsPlaying("1SwipeLeft") then
						angle = 180
					elseif spr:IsPlaying("1SwipeRight") then
						angle = 0
					end
					
					local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position + (Vector(0,40):Rotated(angle - 90)):Resized(10), Vector.Zero)
					yandereWaifu.GetEntityData(proj).Bloodbend1 = true
					yandereWaifu.GetEntityData(proj).BloodbendAngle = angle
					local splat = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_RED, 0, ent.Position + (Vector(0,40):Rotated(angle - 90)):Resized(10), Vector(0,0), nil)
					
				end
				ent.Velocity = ent.Velocity * 0.8
			end
			if data.State == 4 then
				--print((ent.Position - ILIB.room:GetCenterPos()):Length())
				if math.floor((ent.Position - ILIB.room:GetCenterPos()):Length()) <= 4 then
					if spr:IsPlaying("1Special") then
						if spr:GetFrame() == 30 then
							local splat = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_EVESUMMONCIRCLE, math.random(0,3), ent.Position, Vector(0,0), nil)
						end
					end
					ent.Velocity = ent.Velocity * 0.3
					
					if spr:IsFinished("1Special") then
						data.State = 7
					end
					
					if not spr:IsPlaying("1Special") and not spr:IsFinished("1Special") then
						spr:Play("1Special", false)
					end
				else
					InutilLib.AnimShootFrame(ent, false, ent.Velocity, "1WalkRight", "1WalkFront", "1WalkBack", "1WalkLeft")
					ent.Velocity = ent.Velocity + (ILIB.room:GetCenterPos()-ent.Position):Resized(2)
					ent.Velocity = ent.Velocity * 0.8
				end
			end
			if data.State == 5 then
				if spr:IsFinished("1Attack2") then
					data.State = 1
				end
				if spr:IsPlaying("1Attack2") then
					if spr:GetFrame() > 1 and spr:GetFrame() < 30 then
						for i, v in ipairs (Isaac.GetRoomEntities()) do
							if v and not v:IsDead() then
								if v.Type == EntityType.ENTITY_EFFECT and v.Variant == EffectVariant.CREEP_RED then
									InutilLib.SetTimer( i*3, function()
										if v and not v:IsDead() then
											local proje = InutilLib.FireGenericProjAttack(ent, 0, 1, v.Position, Vector.Zero)
											yandereWaifu.GetEntityData(proje).Bloodbend2 = true
											yandereWaifu.GetEntityData(proje).Target = player
											proje.Scale = math.random(9, 18)/10
											v:Die()
										end
									end)
								end
							end
						end
					end
					if spr:IsEventTriggered("Attack") then 
						for i, v in ipairs (Isaac.GetRoomEntities()) do
							if v and not v:IsDead() then
								if v.Type == EntityType.ENTITY_PROJECTILE and yandereWaifu.GetEntityData(v).Bloodbend2 then
									InutilLib.SetTimer( i*3, function()
										if v and not v:IsDead() then
											v.Velocity = (player.Position - v.Position):Resized(10)
											v:ToProjectile().FallingAccel = 1;
										end
									end)
								end
							end
						end
					end
				end
				ent.Velocity = ent.Velocity * 0.8
			end
			if data.State == 6 then
				if spr:IsFinished("Rage") and not data.DashRage then
					data.DashRage = true
					data.LastPosition = player.Position - ent.Position
				end
				if data.DashRage then
					ent.Velocity = ent.Velocity + (data.LastPosition):Resized(4)
					InutilLib.AnimShootFrame(ent, false, ent.Velocity, "1WalkRight", "1WalkFront", "1WalkBack", "1WalkLeft")
					if ent:CollidesWithGrid() then
						data.State = 1
						data.DashRage = nil
						data.LastPosition = nil
						ILIB.game:ShakeScreen(8)
						for i = 0, 360 - 360/16, 360/16 do
							local proj2 = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, (Vector(10,0)):Resized(10):Rotated(i)):ToProjectile()
							proj2.Scale = 1.1
						end
						ent.Velocity = Vector.Zero
					end
				end
				ent.Velocity = ent.Velocity * 0.8
			end
			if data.State == 7 then --blocking stuff
				local cleared
				for i, v in pairs (Isaac.GetRoomEntities()) do
					if( v.Type == RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY and (v.Variant == RebekahCurseEnemies.ENTITY_BLOOD_SLOTH or v.Variant == RebekahCurseEnemies.ENTITY_BLOOD_WRATH)or v.Type == EntityType.ENTITY_BEGOTTEN) and not v:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
						cleared = false
						break
					end
					cleared = true
				end
				if not cleared then
					data.BlockAllDmg = true
					data.State = 7
				else
					data.BlockAllDmg = false
					data.State = 1
				end
			end
		end
	end

end, RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY)


InutilLib:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, damage, amount, damageFlag, damageSource, damageCountdownFrames) 
	if damage.Type == RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY and damage.Variant == RebekahCurseEnemies.ENTITY_EVE_BOSS then
		local data = yandereWaifu.GetEntityData(damage)
		if data.BlockAllDmg then
			local splat = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BISHOP_SHIELD, 0, damage.Position, Vector(0,0), damage) 
			return false
		end
		if damageSource.Type == RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY and (damageSource.Variant == RebekahCurseEnemies.ENTITY_BLOOD_WRATH or damageSource.Variant == RebekahCurseEnemies.ENTITY_BLOOD_SLOTH) then
			return false
		end
	end
end)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_,eff)
	--local player = Isaac.GetPlayer(0);
    local room = Game():GetRoom();
	local data = yandereWaifu.GetEntityData(eff)

	if eff.Variant == RebekahCurse.ENTITY_EVESUMMONCIRCLE then
		if eff.FrameCount == 1 then
			if eff.SubType == 0 then
				eff:GetSprite():ReplaceSpritesheet(0, "gfx/bosses/rivals/eve/anarchy_circle.png")
			elseif eff.SubType == 1 then
				eff:GetSprite():ReplaceSpritesheet(0, "gfx/bosses/rivals/eve/cross_circle.png")
			elseif eff.SubType == 2 then
				eff:GetSprite():ReplaceSpritesheet(0, "gfx/bosses/rivals/eve/pentagram_circle.png")
			elseif eff.SubType == 3 then
				eff:GetSprite():ReplaceSpritesheet(0, "gfx/bosses/rivals/eve/sin_circle.png")
			end
			eff:GetSprite():LoadGraphics()
			eff:GetSprite():Play("Spawn")
		end
		if eff:GetSprite():GetFrame() == 15  then
			eff:Remove()
			if eff.SubType == 0 then
				local splat = Isaac.Spawn(RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY, RebekahCurseEnemies.ENTITY_BLOOD_WRATH, 0, eff.Position, Vector(0,0), nil)
			elseif eff.SubType == 1 then
				for i = 1, 5 do
					InutilLib.SetTimer( i*3, function()
						local splat = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACK_THE_SKY, 0, ILIB.room:GetRandomPosition(2), Vector(0,0), eff) 
					end)
				end
			elseif eff.SubType == 2 then
				for i = 1, 3 do
					local splat = Isaac.Spawn(EntityType.ENTITY_BEGOTTEN, 0, 0, ILIB.room:GetRandomPosition(2) , Vector(0,0), nil)
					splat:AddEntityFlags(EntityFlag.FLAG_AMBUSH)
					splat.HitPoints = 20
					splat.MaxHitPoints = 20
				end
			elseif eff.SubType == 3 then
				local splat = Isaac.Spawn(RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY, RebekahCurseEnemies.ENTITY_BLOOD_SLOTH, 0, eff.Position, Vector(0,0), nil)
			end
		end
	end
end)