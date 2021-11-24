yandereWaifu:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function(_,player)
	local data = yandereWaifu.GetEntityData(player)
	--cursed spoon
	if player:HasCollectible(RebekahCurse.COLLECTIBLE_PATRIARCHSLIAR) and InutilLib.HasJustPickedCollectible( player, RebekahCurse.COLLECTIBLE_PATRIARCHSLIAR) then
	end
	if player:HasCollectible(RebekahCurse.COLLECTIBLE_PATRIARCHSLIAR) then	
		local wall = InutilLib.ClosestWall(player)
		local fist
		local room = ILIB.room
		for i, ent in pairs (Isaac.GetRoomEntities()) do
			if ent.Type == EntityType.ENTITY_EFFECT and ent.Variant == RebekahCurse.ENTITY_GOLEMFIST then
				fist = true
				break
			end
		end
		if not fist and player.FrameCount % 120 then
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
			sprite.Rotation = data.Angle
		end
		if sprite:IsFinished("Disappear") then
			eff:Remove()
		end
		if eff.FrameCount == 30 then
			eff.Velocity = Vector.FromAngle(data.Angle)*25
		elseif eff.FrameCount >= 30 and not sprite:IsPlaying("Disappear") then
			if eff.Velocity:Length() > 6 then
				for i, ent in pairs (Isaac.GetRoomEntities()) do
					if (ent:IsEnemy() and ent:IsVulnerableEnemy()) or ent.Type == EntityType.ENTITY_FIREPLACE and not ent:IsDead() then
						if eff.FrameCount % 3 == 0 then
							if ent.Position:Distance(eff.Position) <= 90 then
								ent:TakeDamage(5, 0, EntityRef(eff), 1)
								ent.Velocity = ent.Velocity + eff.Velocity * 3
								sprite:Play("Disappear")
							end
						end
					elseif ent.Type == 1 then
						if ent.Position:Distance(eff.Position) <= 80 then
							ent:TakeDamage(1, 0, EntityRef(player), 10)
							ent.Velocity = ent.Velocity + eff.Velocity * 3
						end
					end
				end
			else
				sprite:Play("Disappear")
			end
			eff.Velocity = eff.Velocity * 0.9
		else
			eff.Velocity = eff.Velocity * 0.9
		end
	end
end)