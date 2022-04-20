
local spawnedRabbet = false

yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_,  fam) 
    local spr = fam:GetSprite()
	local data = yandereWaifu.GetEntityData(fam)
	local player = fam.Player
	player:ToPlayer()
	local playerdata = yandereWaifu.GetEntityData(player)
	local enemy = InutilLib.GetClosestGenericEnemy(fam, 500)
	if not data.Init then
		data.Init = true
		data.State = 0
		fam.GridCollisionClass = GridCollisionClass.COLLISION_SOLID
	end
	
	--fam:FollowParent()
	
	if data.State == 0 then
		if not spr:IsPlaying("Idle") then spr:Play("Idle", true) end
		if math.random(1,2) == 2 and enemy then --to hop
			spr:Play("Hop")
			data.State = 1
		elseif math.random(1,4) == 4 then
			spr:Play("Hop")
			data.State = 3
		end
	elseif data.State == 1 then
		if spr:IsFinished("Hop") then
			data.State = 0
		end
			if spr:IsPlaying("Hop") then
				if spr:IsEventTriggered("Jump") then
					if enemy then
						if fam.Position:Distance(enemy.Position) <= 200 then
							fam.Velocity = (enemy.Position - fam.Position) / 6
						else
							InutilLib.MoveDirectlyTowardsTarget(fam, enemy, math.random(10,13), 0.9)
						end
						InutilLib.FlipXByVec(fam, false)
					end
				elseif spr:IsEventTriggered("Land") then
					fam.Velocity = Vector.Zero
				end
			end
			fam.Velocity = fam.Velocity  * 0.9
	elseif data.State == 2 then
		spr:Play("Leap")
	elseif data.State == 3 then
		if spr:IsFinished("Hop") then
			data.State = 0
		end
		if spr:IsPlaying("Hop") then
			if spr:IsEventTriggered("Jump") then
				InutilLib.MoveRandomlyTypeI(fam, ILIB.room:GetRandomPosition(3), 5, 0.9, 30, 30, 90)
			elseif spr:IsEventTriggered("Land") then
				fam.Velocity = Vector.Zero
			end
			InutilLib.FlipXByVec(fam, false)
		end
		fam.Velocity = fam.Velocity  * 0.9
	end
	
	if spr:IsFinished("Leap") then
		fam:Remove()
	end
	
end, RebekahCurse.ENTITY_BUNBUN_FAMILIAR);


yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_,  fam) 
    local spr = fam:GetSprite()
	local data = yandereWaifu.GetEntityData(fam)
	--[[local player = fam.Player
	player:ToPlayer()]]
	local playerdata = yandereWaifu.GetEntityData(player)
	local enemy = InutilLib.GetClosestGenericEnemy(fam, 500)
	if not data.Init then
		data.Init = true
		data.State = 0
		fam.GridCollisionClass = GridCollisionClass.COLLISION_SOLID
		spr:Play("JumpDown", true)
	end
	
	--fam:FollowParent()
	
	fam.Velocity = Vector.Zero
	
	if fam.SubType == 0 then
		if data.State == 0 then
			if spr:IsEventTriggered("Land") then
				for k, v in pairs (Isaac.GetRoomEntities()) do
					if v.Type == EntityType.ENTITY_EFFECT and v.Variant == RebekahCurse.ENTITY_EGGSHELLS and v.Position:Distance(fam.Position) <= 10 then
						v:Remove()
					end
				end
				data.Collidable = true
			end
		end
	elseif fam.SubType == 1 then
		if data.State == 0 then
			if spr:IsEventTriggered("Land") then
				data.Collidable = true
			end
			if spr:IsFinished("JumpDown") then
				spr:Play("Roar", true)
				data.State = 1
			end
		elseif data.State == 1 then
			if spr:IsPlaying("Roar") then
				if spr:IsEventTriggered("Roar") then
					for k, v in pairs (Isaac.GetRoomEntities()) do
						if v.Type == EntityType.ENTITY_EFFECT and v.Variant == RebekahCurse.ENTITY_EGGSHELLS and not yandereWaifu.GetEntityData(v).IsSmashed then
							yandereWaifu.GetEntityData(v).IsSmashed = true
							InutilLib.SetTimer( (20-math.random(3,5))*k, function()
								local egg = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_RABBET_FAMILIAR, 0, v.Position, Vector.Zero, nil)
								yandereWaifu.GetEntityData(v).IsSmashed = true
								--v:Remove()
								if math.random(1,2) == 2 then
									local egg = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_RABBET_FAMILIAR, 0, ILIB.room:GetRandomPosition(5), Vector.Zero, nil)
								end
							end)
						end
					end
				end
			elseif spr:IsFinished("Roar") then
				local continue = true
				for k, v in pairs (Isaac.GetRoomEntities()) do
					if v.Type == EntityType.ENTITY_EFFECT and v.Variant == RebekahCurse.ENTITY_RABBET_FAMILIAR then
						if v:GetSprite():IsPlaying("JumpDown") then
							continue = false
						end
					end
				end
				if continue then
					for k, v in pairs (Isaac.GetRoomEntities()) do
						if v.Type == EntityType.ENTITY_EFFECT and v.Variant == RebekahCurse.ENTITY_RABBET_FAMILIAR then
							v:GetSprite():Play("Roar", true)
							yandereWaifu.GetEntityData(v).State = 1
						elseif v:IsEnemy() then
							v:AddEntityFlags(EntityFlag.ENTITY_FEAR)
						end
					end
					data.State = 2
				end
			end
		elseif data.State == 2 then
			local continue = true
			for k, v in pairs (Isaac.GetRoomEntities()) do
				if v.Type == EntityType.ENTITY_EFFECT and v.Variant == RebekahCurse.ENTITY_RABBET_FAMILIAR then
					if v:GetSprite():IsPlaying("Roar") or v:GetSprite():IsPlaying("JumpDown") then
						continue = false
					end
				end
			end
			if continue then
				for k, v in pairs (Isaac.GetRoomEntities()) do
					InutilLib.SetTimer( 5*k+math.random(1,10), function()
						if v.Type == EntityType.ENTITY_EFFECT and v.Variant == RebekahCurse.ENTITY_RABBET_FAMILIAR and not yandereWaifu.GetEntityData(v).IsLeaving then
							v:GetSprite():Play("JumpUp", true)
							yandereWaifu.GetEntityData(v).State = 1
							yandereWaifu.GetEntityData(v).IsLeaving = true
						elseif v.Type == EntityType.ENTITY_FAMILIAR and v.Variant == RebekahCurse.ENTITY_BUNBUN_FAMILIAR and not yandereWaifu.GetEntityData(v).IsLeaving then
							yandereWaifu.GetEntityData(v).State = 2
							yandereWaifu.GetEntityData(v).IsLeaving = true
						end
					end)
				end
				spr:Play("JumpUp", true)
			end
		end
	end
	
	if data.Collidable then
		for k, v in pairs (Isaac.GetRoomEntities()) do
			if v.Type == 1 and v.Position:Distance(fam.Position) <= 60 then
				v:TakeDamage(1, 0, EntityRef(fam), 1)
			elseif v:IsEnemy() and v.Position:Distance(fam.Position) <= 60 then
				v:TakeDamage(5, 0, EntityRef(fam), 1)
			end
		end
		if spr:IsEventTriggered("Jump") then
			data.Collidable = false
		end
	end
	if spr:IsFinished("JumpUp") then
		fam:Remove()
	end
	
end, RebekahCurse.ENTITY_RABBET_FAMILIAR);


yandereWaifu:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_,player)
    local room = Game():GetRoom();
	local data = yandereWaifu.GetEntityData(player)
	if player:HasCollectible(RebekahCurse.COLLECTIBLE_EGGSHELLWALK) and InutilLib.HasJustPickedCollectible( player, RebekahCurse.COLLECTIBLE_EGGSHELLWALK ) then
		
		
	end
end)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_,eff)
    local room = Game():GetRoom();
	local data = yandereWaifu.GetEntityData(eff)
	local spr = eff:GetSprite()
	if eff.FrameCount == 1 then
		data.Idle = true
		spr:Play("Spawn")
	end
	if data.Idle then
		if spr:IsFinished("Break") then
			spr:Play("Idle")
		end
		if data.BreakFrame then
			print(data.BreakFrame )
			print(data.BreakFrame/5)
			spr:SetFrame("Break", math.floor(data.BreakFrame/5))
		end
		for p = 0, ILIB.game:GetNumPlayers() - 1 do
			local player = Isaac.GetPlayer(p)
			if player.Position:Distance(eff.Position) <= 20 then
				if not data.BreakFrame then
					data.BreakFrame = 0
				elseif data.BreakFrame > 40 then
					spr:Play("BreakFull", true)
					data.Idle = false
					break
				else
					data.BreakFrame = data.BreakFrame + 1
				end
			end
		end
		
	else
		if spr:IsFinished("BreakFull") then
			eff:Remove()
		else
			if spr:GetFrame() == 5 then
				if #Isaac.FindByType(EntityType.ENTITY_FAMILIAR, RebekahCurse.ENTITY_BUNBUN_FAMILIAR, -1, false, true) < 2 then
					local egg = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, RebekahCurse.ENTITY_BUNBUN_FAMILIAR, 0, eff.Position, Vector.Zero, yandereWaifu.GetEntityData(eff).Player)
				elseif not spawnedRabbet then
					spawnedRabbet = true
					local egg = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_RABBET_FAMILIAR, 1, eff.Position, Vector.Zero, yandereWaifu.GetEntityData(eff).Player)
				end
			end
		end
	end
end, RebekahCurse.ENTITY_EGGSHELLS)

function yandereWaifu:EggshellWalkNewRoom()
	for k, v in pairs (Isaac.GetRoomEntities()) do
		if (v.Type == EntityType.ENTITY_FAMILIAR and v.Variant == RebekahCurse.ENTITY_BUNBUN_FAMILIAR) or (v.Type == EntityType.ENTITY_EFFECT or v.Variant == RebekahCurse.ENTITY_RABBET_FAMILIAR) then
			v:Remove()
		end
	end
	spawnedRabbet = false
	for p = 0, ILIB.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		local data = yandereWaifu.GetEntityData(player)
		local room = ILIB.game:GetRoom()
		if player:HasCollectible(RebekahCurse.COLLECTIBLE_EGGSHELLWALK) and not room:IsClear() then
			for i = 0, math.random(10,20) do
				local egg = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_EGGSHELLS, 0, ILIB.room:FindFreePickupSpawnPosition(Isaac.GetRandomPosition(),3) , Vector.Zero, player)
				yandereWaifu.GetEntityData(egg).Player = player
			end
		end
	end
end
yandereWaifu:AddCallback( ModCallbacks.MC_POST_NEW_ROOM, yandereWaifu.EggshellWalkNewRoom)