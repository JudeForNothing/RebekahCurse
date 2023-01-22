yandereWaifu:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function(_,player)
	local data = yandereWaifu.GetEntityData(player)
	--cursed spoon
	if player:HasCollectible(RebekahCurseItems.COLLECTIBLE_PATRIARCHSLIAR) and InutilLib.HasJustPickedCollectible( player, RebekahCurseItems.COLLECTIBLE_PATRIARCHSLIAR) then
	end
	if player:HasCollectible(RebekahCurseItems.COLLECTIBLE_PATRIARCHSLIAR) then	
		local wall = InutilLib.ClosestWall(player)
		local fist
		local room = ILIB.room
		for i, ent in pairs (Isaac.GetRoomEntities()) do
			if ent.Type == EntityType.ENTITY_EFFECT and ent.Variant == RebekahCurse.ENTITY_GOLEMFIST then
				fist = true
				break
			end
		end

		if not fist and (player.FrameCount % 15) <= 0 and math.random(1,10) == 10 then
			local pos = Vector.Zero
			if wall == Direction.DOWN then
				pos = Vector(player.Position.X, room:GetBottomRightPos().Y+60)
			elseif wall == Direction.UP then
				pos = Vector(player.Position.X, room:GetTopLeftPos().Y-60)
			elseif wall == Direction.RIGHT then
				pos = Vector(room:GetBottomRightPos().X+60, player.Position.Y)
			elseif wall == Direction.LEFT then
				pos = Vector(room:GetTopLeftPos().X-60, player.Position.Y)
			end
			if room:IsLShapedRoom() then
				--[[print((ILIB.room:GetDoorSlotPosition(0) - player.Position):Length())
				print((ILIB.room:GetDoorSlotPosition(1) - player.Position):Length())
				print((ILIB.room:GetDoorSlotPosition(2) - player.Position):Length())
				print((ILIB.room:GetDoorSlotPosition(3) - player.Position):Length())
				print((ILIB.room:GetDoorSlotPosition(4) - player.Position):Length())
				print((ILIB.room:GetDoorSlotPosition(5) - player.Position):Length())
				print((ILIB.room:GetDoorSlotPosition(6) - player.Position):Length())
				print((ILIB.room:GetDoorSlotPosition(7) - player.Position):Length())
				print("end")]]
				local leftWall = math.abs(ILIB.room:GetTopLeftPos().X-player.Position.X)
				local rightWall = math.abs(ILIB.room:GetBottomRightPos().X-player.Position.X)
				local topWall = math.abs(ILIB.room:GetTopLeftPos().Y-player.Position.Y)
				local bottomWall = math.abs(ILIB.room:GetBottomRightPos().Y-player.Position.Y)
				local shape = room:GetRoomShape()
				if shape == RoomShape.ROOMSHAPE_LTL then
					local topLwall = math.abs(ILIB.room:GetDoorSlotPosition(1).Y - player.Position.Y)
					local sideLwall = math.abs(ILIB.room:GetDoorSlotPosition(0).X - player.Position.X)

					if (wall == Direction.LEFT or wall == Direction.DOWN) and (topLwall <= sideLwall and leftWall <= 500 and topLwall <= topWall) then
						pos = Vector(player.Position.X, ILIB.room:GetDoorSlotPosition(1).Y-60)
						wall = Direction.UP
					elseif wall == Direction.UP and (sideLwall <= topLwall and sideLwall <= leftWall and sideLwall <= topWall) then
						pos = Vector(ILIB.room:GetDoorSlotPosition(0).X-60, player.Position.Y)
						wall = Direction.LEFT
					end
				elseif shape == RoomShape.ROOMSHAPE_LTR then
					local topLwall = math.abs(ILIB.room:GetDoorSlotPosition(5).Y - player.Position.Y)
					local sideLwall = math.abs(ILIB.room:GetDoorSlotPosition(2).X - player.Position.X)
		
					if (wall == Direction.RIGHT or wall == Direction.DOWN) and (topLwall <= sideLwall and rightWall <= 500 and topLwall <= topWall) then
						pos = Vector(player.Position.X, ILIB.room:GetDoorSlotPosition(5).Y-60)
						wall = Direction.UP
					elseif wall == Direction.UP and (sideLwall <= topLwall and sideLwall <= rightWall and sideLwall <= topWall) then
						pos = Vector(ILIB.room:GetDoorSlotPosition(2).X+60, player.Position.Y)
						wall = Direction.RIGHT
					end
				elseif shape == RoomShape.ROOMSHAPE_LBL then
					local topLwall = math.abs(ILIB.room:GetDoorSlotPosition(3).Y - player.Position.Y)
					local sideLwall = math.abs(ILIB.room:GetDoorSlotPosition(4).X - player.Position.X)
					if (wall == Direction.LEFT or wall == Direction.UP) and (topLwall <= sideLwall and leftWall <= 500 and topLwall <= topWall) then
						pos = Vector(player.Position.X, ILIB.room:GetDoorSlotPosition(3).Y+60)
						wall = Direction.DOWN
					elseif wall == Direction.DOWN and (sideLwall <= topLwall and sideLwall <= leftWall and sideLwall <= topWall) then
						pos = Vector(ILIB.room:GetDoorSlotPosition(4).X-60, player.Position.Y)
						wall = Direction.LEFT
					end
				elseif shape == RoomShape.ROOMSHAPE_LBR then
					local topLwall = math.abs(ILIB.room:GetDoorSlotPosition(7).Y - player.Position.Y)
					local sideLwall = math.abs(ILIB.room:GetDoorSlotPosition(6).X - player.Position.X)
	
					if (wall == Direction.RIGHT or wall == Direction.UP) and (topLwall <= sideLwall and rightWall <= 500 and topLwall <= topWall) then
						pos = Vector(player.Position.X, ILIB.room:GetDoorSlotPosition(7).Y+60)
						wall = Direction.DOWN
					elseif wall == Direction.DOWN and (sideLwall <= topLwall and sideLwall <= rightWall and sideLwall <= topWall) then
						pos = Vector(ILIB.room:GetDoorSlotPosition(6).X+60, player.Position.Y)
						wall = Direction.RIGHT
					end
				end
			end
			local golemfist = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_GOLEMFIST, 0, pos, Vector(0,0), player)
			if wall == Direction.DOWN then
				yandereWaifu.GetEntityData(golemfist).Angle = 270
			elseif wall == Direction.UP then
				yandereWaifu.GetEntityData(golemfist).Angle = 90
			elseif wall == Direction.RIGHT then
				yandereWaifu.GetEntityData(golemfist).Angle = 180
			elseif wall == Direction.LEFT then
				yandereWaifu.GetEntityData(golemfist).Angle = 0
			end
		end
	end
end)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local sprite = eff:GetSprite()
	local data = yandereWaifu.GetEntityData(eff)
	local player = data.Player
	
	if data.Angle then
		if eff.FrameCount == 1 then
			--sprite.Rotation = data.Angle
			if data.Angle == 90 then
				sprite:Play("HoldDown", true)
			elseif data.Angle == 270 then
				sprite:Play("HoldDown", true)
				sprite.Rotation = 180
			elseif data.Angle == 180 then
				sprite:Play("Hold2", true)
			end
			InutilLib.SFX:Play(RebekahCurseSounds.SOUND_PATRIARCHSLIARBELL, 1, 0, false, 1)
		end
		if InutilLib.IsFinishedMultiple(sprite, "Punch", "Punch2", "PunchDown")then
			if data.Angle == 90 then
				sprite:Play("DisappearDown", true)
			elseif data.Angle == 270 then
				sprite:Play("DisappearDown", true)
				sprite.Rotation = 180
			elseif data.Angle == 180 then
				sprite:Play("Disappear2", true)
			else
				sprite:Play("Disappear", true)
			end
		end
		if InutilLib.IsFinishedMultiple(sprite, "Disappear", "Disappear2", "DisappearDown") then
			eff:Remove()
		end
		if eff.FrameCount == 10 then
			if data.Angle == 90 then
				sprite:Play("PunchDown")
			elseif data.Angle == 270 then
				sprite:Play("PunchDown")
				sprite.Rotation = 180
			elseif data.Angle == 180 then
				sprite:Play("Punch2")
			else
				sprite:Play("Punch")
			end
		elseif InutilLib.IsPlayingMultiple(sprite, "Punch", "Punch2", "PunchDown") and sprite:GetFrame() == 5 then
			sprite.PlaybackSpeed = 0.5
		elseif InutilLib.IsPlayingMultiple(sprite, "Punch", "Punch2", "PunchDown") and sprite:GetFrame() == 10 then
			sprite.PlaybackSpeed = 1
		elseif InutilLib.IsPlayingMultiple(sprite, "Punch", "Punch2", "PunchDown") and sprite:GetFrame() == 13 then
			eff.Velocity = Vector.FromAngle(data.Angle)*70
		elseif eff.FrameCount > 10 and InutilLib.IsPlayingMultiple(sprite, "Punch", "Punch2", "PunchDown") and sprite:GetFrame() > 13 then
			--if eff.Velocity:Length() > 6 then
				for i, ent in pairs (Isaac.GetRoomEntities()) do
					if (ent:IsEnemy() and ent:IsVulnerableEnemy()) or ent.Type == EntityType.ENTITY_FIREPLACE and not ent:IsDead() then
						if eff.FrameCount % 3 == 0 then
							if ent.Position:Distance(eff.Position) <= 90 then
								ent:TakeDamage(20, 0, EntityRef(eff), 1)
								ent.Velocity = ent.Velocity + eff.Velocity * 3
								
								ILIB.game:ShakeScreen(10)
								
								--[[if sprite:GetFrame() > 16 then
									if data.Angle == 90 then
										sprite:Play("DisappearDown")
									elseif data.Angle == 270 then
										sprite:Play("DisappearDown")
										sprite.Rotation = 180
									elseif data.Angle == 180 then
										sprite:Play("Disappear2")
									else
										sprite:Play("Disappear")
									end
								end]]
							end
						end
					elseif ent.Type == 1 then
						if ent.Position:Distance(eff.Position) <= 35 then
							ent:TakeDamage(1, 0, EntityRef(player), 10)
							ent.Velocity = ent.Velocity + eff.Velocity * 3
							ILIB.game:ShakeScreen(10)
						end
					end
				end
			--end
			eff.Velocity = eff.Velocity * 0.8
		else
			eff.Velocity = eff.Velocity * 0.8
		end
	end
end, RebekahCurse.ENTITY_GOLEMFIST)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, function(_, eff, offset)
	if ILIB.room:GetRenderMode() >= 3 then
		local sprite = eff:GetSprite()
		local data = yandereWaifu.GetEntityData(eff)
		local player = data.Player
		local endpos = endpos or eff.Position
		if  data.Angle == 270 or data.Angle == 90 then
		--	sprite.Rotation = 0
		end
		sprite.Scale = eff.SpriteScale
		--sprite:Render(Isaac.WorldToRenderPosition(endpos) + offset)
	end
end, RebekahCurse.ENTITY_GOLEMFIST) 