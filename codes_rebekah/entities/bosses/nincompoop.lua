yandereWaifu:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, ent)
	local spr = ent:GetSprite()
	local data = yandereWaifu.GetEntityData(ent)
	local player = ent:GetPlayerTarget()
	local room = ILIB.room
	local invert = true
	if data.path == nil then data.path = ent.Pathfinder end
	if ent.Variant == RebekahCurseEnemies.ENTITY_NINCOMPOOP then
		if not data.State then
			--spr:Play("Idle")
			data.State = 0
			ent:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
			ent:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
		else
			if data.State == 0 then
				if not spr:IsPlaying("Idle") then
					spr:Play("Idle", true)
				end
				if math.random(1,3) == 3 and ent.FrameCount % 5 == 0 then
					if math.random(1,2) == 2 then
						data.State = 1
					else
						data.State = 3
					end
				end
				ent:GetSprite().FlipX = false
			elseif data.State == 1 then
				if spr:IsFinished("Whistle") then
					data.State = 2
				elseif not spr:IsPlaying("Whistle") then
					spr:Play("Whistle", true)
				end
			elseif data.State == 2 then
				if spr:IsFinished("Shoot") then
					data.State = 0
				elseif not spr:IsPlaying("Shoot") then
					spr:Play("Shoot", true)
				elseif spr:IsPlaying("Shoot") then
					if spr:GetFrame() == 1 then
						if math.random(1,3) == 3 then
							for i = 0, 4 do
								InutilLib.SetTimer( i*15, function()
									--for i = -7, 7, 5 do
										local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, ((player.Position - ent.Position)):Resized(7))
										proj.Scale = 1.5
										proj:AddProjectileFlags(ProjectileFlags.SMART)
									--end
								end)
							end
						else
							for i = 0, 4 do
								InutilLib.SetTimer( i*15, function()
									for i = -15, 15, 30 do
										local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, ((player.Position - ent.Position):Rotated(i)):Resized(10))
										proj.Scale = 1.5
									end
								end)
							end
						end
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
					local rng = math.random(1,20)
					if rng <= 5 and rng >= 0 then
						data.State = 4
					elseif rng <= 10 and rng >= 6 then
						data.State = 6
					elseif rng <= 15 and rng >= 11 then
						data.State = 7
					else
						data.State = 8
					end
				elseif not spr:IsPlaying("BeginCharge") then
					spr:Play("BeginCharge", true)
				end
			elseif data.State == 4 then
				if spr:IsFinished("Dash") then
					if data.DashTimes >= 2 then
						data.State = 5
					else
						spr:Play("Dash", true)
						data.DashTimes = data.DashTimes + 1
					end
				elseif not spr:IsPlaying("Dash") then
					spr:Play("Dash", true)
					data.DashTimes = 0
				elseif spr:IsPlaying("Dash") then
					if ent.FrameCount % 3 == 0 and spr:GetFrame() < 30 then
						InutilLib.MoveDirectlyTowardsTarget(ent, player, 10, 0.8)
					elseif spr:GetFrame() > 30 then 
						ent.Velocity = ent.Velocity * 0.9
					end
				end
				InutilLib.FlipXByVec(ent, invert)
			elseif data.State == 5 then --tired
				if spr:IsFinished("Tired") then
					data.State = 0
				elseif not spr:IsPlaying("Tired") then
					spr:Play("Tired", true)
				end
			elseif data.State == 6 then
				if spr:IsFinished("LongDash") then
					data.State = 5
				elseif not spr:IsPlaying("LongDash") then
					spr:Play("LongDash", true)
				elseif spr:IsPlaying("LongDash") then
					if ent.FrameCount % 3 == 0 and spr:GetFrame() < 120 then
						InutilLib.MoveDirectlyTowardsTarget(ent, player, 10, 0.8)
						if ent.FrameCount % 30 == 0 then
							local fly = Isaac.Spawn(EntityType.ENTITY_ATTACKFLY, 0, 0, ent.Position, Vector(0,0), ent):ToNPC()
							fly:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
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
				elseif spr:IsPlaying("ShortDash") then
					if spr:GetFrame() == 1 then
						InutilLib.MoveDirectlyTowardsTarget(ent, player, 25, 0.9)
					end
				end
				InutilLib.FlipXByVec(ent, invert)
			elseif data.State == 8 then --just happy
				if spr:IsFinished("Smile") then
					data.State = 0
				elseif not spr:IsPlaying("Smile") then
					spr:Play("Smile", true)
				end
				ent:GetSprite().FlipX = false
			end
		end
		ent.Velocity = ent.Velocity * 0.7
	end
end, RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY)
