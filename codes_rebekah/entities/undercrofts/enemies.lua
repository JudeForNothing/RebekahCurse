local isPlayerDmg = false

yandereWaifu:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, ent)
	local spr = ent:GetSprite()
	local data = yandereWaifu.GetEntityData(ent)
	local player = ent:GetPlayerTarget()
	if ent.Variant == RebekahCurse.Enemies.ENTITY_SISTER then

        if not data.Init then
            --if spr:IsFinished("Spawn") then
                data.Init = true
            --end
            --if not spr:IsPlaying("Spawn") then
            --	spr:Play("Spawn")
            --end
            data.FlipX = false
            spr:PlayOverlay("Head", true)
            data.State = 0
        else
            if data.State == 0 then
                if ent.SubType == 1 then
                    if not data.SimpedPerson or not data.SimpedPerson:Exists() then
                        data.SimpedPerson = InutilLib.GetStrongestEnemy(ent, 500, true)
                    end
                    if data.SimpedPerson then
                        player = data.SimpedPerson
                    end
                end
                if not data.path then
                    data.path = InutilLib.GenerateAStarPath(ent.Position, player.Position)
                else
                    if ent.FrameCount % 15 == 0 then
                        data.path = InutilLib.GenerateAStarPath(ent.Position, player.Position)
                    end
                end
                local angle = (ent.Position - player.Position):GetAngleDegrees()
                
                ent:AnimWalkFrame("WalkHori", "WalkVert", 1)

                if not spr:IsOverlayPlaying("Head") then
                    spr:PlayOverlay("Head", true)
                end

                if ent.SubType == 0 and ent.FrameCount % 30 == 0 and math.random(1,5) == 5 and not data.HasHealed then
                    data.State = 1 
                    data.HasHealed = true -- so it only uses it once lol
                end
                if ent.SubType == 1 and player.HitPoints <= player.MaxHitPoints/2 and not data.HasHealed then -- emergency heal
                    data.State = 1 
                    data.HasHealed = true -- so it only uses it once lol
                    ent:Morph(ent.Type, ent.Variant, 0, ent:GetChampionColorIdx())
                end
                if data.path then
                    if not InutilLib.room:CheckLine(ent.Position, player.Position, 0, 0) then
                        InutilLib.FollowPath(ent, player, data.path, 0.5, 0.9)
                    else
                        InutilLib.MoveDirectlyTowardsTarget(ent, player, 0.5, 0.9)
                    end
                    if not spr:IsPlaying("Walk") then
                        spr:Play("Walk", true)
                    end
                else
                    if not spr:IsPlaying("Idle") then
                        spr:Play("Idle", true)
                    end
                    ent.Velocity = Vector.Zero
                end
            elseif data.State == 1 then
                ent.Velocity = ent.Velocity * 0.7
                if spr:IsFinished("Heal") then
                    data.State = 0
                elseif not spr:IsPlaying("Heal") then
                    spr:RemoveOverlay()
                    spr:Play("Heal", true)
                else
                    if spr:GetFrame() == 15 then
                        for i, v in pairs (Isaac.GetRoomEntities()) do
                            if v:IsVulnerableEnemy() and v.Position:Distance(ent.Position) <= 150 then
                                local addend = 15
                                if v.HitPoints + addend >= v.MaxHitPoints then
                                    v.HitPoints = v.MaxHitPoints
                                else
                                    v.HitPoints = v.HitPoints + addend
                                end
                                local charge = Isaac.Spawn( EntityType.ENTITY_EFFECT, EffectVariant.HEART, 0, v.Position, Vector(0,0), v );
                                charge.SpriteOffset = Vector(0,-40)
                                InutilLib.SFX:Play( SoundEffect.SOUND_VAMP_GULP , 1.3, 0, false, 1.2 );
                            end
                        end
                    end
                end
            end
        end
    elseif ent.Variant == RebekahCurse.Enemies.ENTITY_BUMBAB then
		--[[if not data.Init then
			data.HeadType = math.random(1,4)
			data.skinColor = math.random(1,2)
			data.Init = true
		end
	
		if data.skinColor == 2 then
			sprite:ReplaceSpritesheet(0, "gfx/monsters/garden/monster_whiteskin.png")
			sprite:ReplaceSpritesheet(1, "gfx/monsters/garden/monster_head_noob2.png")
			sprite:LoadGraphics()
			if data.fist then
				data.fist:GetSprite():ReplaceSpritesheet(0, "gfx/effects/effect_noobfist2.png")
				data.fist:GetSprite():LoadGraphics()
			end
		end
		if not sprite:IsOverlayPlaying("Head5") then
			if data.HeadType == 1 then sprite:PlayOverlay("Head", false) else sprite:PlayOverlay("Head"..data.HeadType, false) end
		end]]
        InutilLib.FlipXByVec(ent, false) 
        local pickup = InutilLib.GetClosestPickup(ent, 400, -1, -1)
        if pickup and (pickup.SubType == 1 or pickup.SubType == 2 or pickup.SubType == 5 or pickup.SubType == 9 or pickup.SubType == 10) then
            if (pickup.Position-ent.Position):Length() < 40 and not pickup.Touched then
                local picked = InutilLib.PickupPickup(pickup)
            end
        end
        if not data.Init then
			data.State = 0
            spr:Play("Idle", true)
            data.Init = true
        else
            if data.State == 0 then
                if spr:IsFinished("Prize") then
                    data.State = 1
                elseif not spr:IsPlaying("Prize") then
                    if math.random(1,5) == 5 and ent.FrameCount % 5 == 0 then
                        spr:Play("Prize", true)
                    end
                end
            elseif data.State == 1 then
                local pickup = InutilLib.GetClosestPickup(ent, 400, 10, -1)
                if --[[math.random(1,4) == 4 and ent.FrameCount % 15 == 0 and]] pickup then
                    data.State = 3
                else
                    if not data.path then
                        data.path = InutilLib.GenerateAStarPath(ent.Position, player.Position)
                    else
                        if ent.FrameCount % 15 == 0 then
                            data.path = InutilLib.GenerateAStarPath(ent.Position, player.Position)
                        end
                    end
                    if data.path then
                        if not spr:IsPlaying("Walk") then
                            spr:Play("Walk", true)
                        else
                            if spr:GetFrame() == 8 then
                                if not InutilLib.room:CheckLine(ent.Position, player.Position, 0, 0) then
                                    InutilLib.FollowPath(ent, player, data.path, 16, 0.9)
                                else
                                    InutilLib.MoveDirectlyTowardsTarget(ent, player, 16, 0.9)
                                end
                            elseif spr:GetFrame() == 15 then
                                ent.Velocity = Vector.Zero
                            end
                        end
                    else
                        if not spr:IsPlaying("IdleAttack") then
                            spr:Play("IdleAttack", true)
                        end
                        ent.Velocity = Vector.Zero
                    end
                end
            elseif data.State == 2 then
                if spr:IsFinished("Attack") then
                    data.State = 1
                    data.fist.Visible = (false)

                elseif not spr:IsPlaying("Attack") then
                    spr:Play("Attack", true)
                else
                    if spr:GetFrame() == 20 then
                        if not data.fist then
                            local fist = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.Enemies.ENTITY_BUMBAB_PUNCH, 0, ent.Position, Vector(0,0), ent)
                            data.fist = fist
                            yandereWaifu.GetEntityData(data.fist).fistowner = ent
                            data.fist.Visible = (false)
                        end
                        local fistSprite = data.fist:GetSprite()
                        fistSprite.Rotation = InutilLib.ObjToTargetAngle(ent, player, true) - 90
                        data.fist.Visible = (true)
                        if (fistSprite.Rotation >= -180 and fistSprite.Rotation <= 0) then	
                            fistSprite:Play("Punch2", true)
                        elseif (fistSprite.Rotation >= 0 and fistSprite.Rotation <= 180) then	
                            fistSprite:Play("Punch", true)
                        end
                        local savedangle = InutilLib.ObjToTargetAngle(ent, player, true)
                        for i, entity in pairs(Isaac.GetRoomEntities()) do
                           if (entity.Type == EntityType.ENTITY_PLAYER or entity:IsEnemy()) and GetPtrHash(entity) ~= GetPtrHash(ent) then
                                if (InutilLib.ObjToTargetAngle(ent, entity, true) > (savedangle - 25) and InutilLib.ObjToTargetAngle(ent, entity, true) < (savedangle + 25)) and entity.Position:Distance(ent.Position) < 100 then --:Rotated(ObjToTargetAngle(ent, target, true))
                                    InutilLib.DoKnockbackTypeI(ent, entity, 0.3)
                                    entity:TakeDamage(1, 0, EntityRef(ent), 1)
                                end
                            end
                        end
                    end
                end
            elseif data.State == 3 then
                local pickup = InutilLib.GetClosestPickup(ent, 400, 10, -1)
                if pickup then
                    if not data.path then
                        data.path = InutilLib.GenerateAStarPath(ent.Position, pickup.Position)
                    else
                        if ent.FrameCount % 15 == 0 then
                            data.path = InutilLib.GenerateAStarPath(ent.Position, pickup.Position)
                        end
                    end
                    if data.path then
                        if not spr:IsPlaying("Walk") then
                            spr:Play("Walk", true)
                        else
                            if spr:GetFrame() == 8 then
                                if not InutilLib.room:CheckLine(ent.Position, pickup.Position, 0, 0) then
                                    InutilLib.FollowPath(ent, pickup, data.path, 16, 0.9)
                                else
                                    InutilLib.MoveDirectlyTowardsTarget(ent, pickup, 16, 0.9)
                                end
                            elseif spr:GetFrame() == 15 then
                                ent.Velocity = Vector.Zero
                                data.State = 1
                            end
                        end
                    else
                        if not spr:IsPlaying("IdleAttack") then
                            spr:Play("IdleAttack", true)
                        end
                        ent.Velocity = Vector.Zero
                    end
                end
            end
		end
        ent.Velocity = ent.Velocity * 0.8
    elseif ent.Variant == RebekahCurse.Enemies.ENTITY_ROACH then
        if not data.Init then
            --if spr:IsFinished("Spawn") then
                data.Init = true
            --end
            --if not spr:IsPlaying("Spawn") then
            --	spr:Play("Spawn")
            --end
            data.FlipX = false
            data.State = 0
        else
            if data.State == 0 then
                if not spr:IsPlaying("Idle") then
                    spr:Play("Idle", true)
                end
                if math.random(1,3) == 3 and ent.FrameCount % 9 == 0 then
                    data.State = 1
                else
                    if math.random(1,2) == 2 and ent.FrameCount % 5 == 0 then
                        if InutilLib.CuccoLaserCollision(ent, 0, 700, player) then
                            data.State = 2
                            spr:Play("StartDash", true)
                            data.DashVector = Vector(10,0)
                        elseif InutilLib.CuccoLaserCollision(ent, 90, 700, player) then
                            data.State = 2
                            spr:Play("StartDash", true)
                            data.DashVector = Vector(0,10)
                        elseif InutilLib.CuccoLaserCollision(ent, 180, 700, player) then
                            data.State = 2
                            spr:Play("StartDash", true)
                            data.DashVector = Vector(-10,0)
                        elseif InutilLib.CuccoLaserCollision(ent, 270, 700, player) then
                            data.State = 2
                            spr:Play("StartDash", true)
                            data.DashVector = Vector(0,-10)
                        end
                    end
                end
                ent.Velocity = ent.Velocity * 0.6
            elseif data.State == 1 then
                if spr:IsFinished("Walk") then
                    data.State = 0
                    ent.Velocity = Vector.Zero
                end
                if not data.path then
                    data.path = InutilLib.GenerateAStarPath(ent.Position, player.Position)
                else
                    if ent.FrameCount % 15 == 0 then
                        data.path = InutilLib.GenerateAStarPath(ent.Position, player.Position)
                    end
                end
                if data.path then
                    if not spr:IsPlaying("Walk") then
                        spr:Play("Walk", true)
                    else
                        if not InutilLib.room:CheckLine(ent.Position, player.Position, 0, 0) then
                            InutilLib.FollowPath(ent, player, data.path, 1, 0.9)
                        else
                            InutilLib.MoveDirectlyTowardsTarget(ent, player, 1, 0.9)
                        end
                    end
                else
                    if not spr:IsPlaying("Walk") then
                        spr:Play("Walk", true)
                    end
                    InutilLib.MoveRandomlyTypeI(ent, Isaac.GetRandomPosition(), 1.5, 0.9, 45, 30, 60)
                    ent.Velocity = Vector.Zero
                end
            elseif data.State == 2 then
                if not InutilLib.IsPlayingMultiple(spr, "Dash", "DashDown", "DashUp") then
                    ent.Velocity = data.DashVector
                    InutilLib.AnimShootFrame(ent, false, ent.Velocity, "Dash", "DashDown", "DashUp")
                elseif InutilLib.IsPlayingMultiple(spr, "Dash", "DashDown", "DashUp") then
                    ent.Velocity = data.DashVector
                end
                if ent:CollidesWithGrid() then
                    data.State = 0
                    ent.Velocity = Vector.Zero
                end
            end
            InutilLib.FlipXByVec(ent, false) 
        end
    elseif ent.Variant == RebekahCurse.Enemies.ENTITY_LONGITS then

        if not data.Init then
            if spr:IsFinished("Appear") then
                data.Init = true
            end
            if not spr:IsPlaying("Appear") then
            	spr:Play("Appear")
            end
            data.FlipX = false
            data.State = 0
        else
            if data.State == 0 then
                if not spr:IsPlaying("Move") then
                    spr:Play("Move", true)
                end
                InutilLib.MoveDirectlyTowardsTarget(ent, player, 0.4, 0.9)
                if ent.FrameCount % 45 == 0 and math.random(1,4) == 4  then
                    data.State = 1 
                end
            elseif data.State == 1 then --recoil
                if spr:IsFinished("Recoil") then
                    data.State = 3
                elseif not spr:IsPlaying("Recoil") then
                    spr:Play("Recoil", true)
                else
                    if spr:GetFrame() == 7 then
                        ent.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                    end
                end
            elseif data.State == 2 then --recoil back down
                if spr:IsFinished("BackDown") then
                    data.State = 0
                elseif not spr:IsPlaying("BackDown") then
                    spr:Play("BackDown", true)
                else
                    if spr:GetFrame() == 8 then
                        ent.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
                    end
                end
            elseif data.State == 3 then 
                if not spr:IsPlaying("Stay") then
                    spr:Play("Stay", true)
                else
                    if ent.FrameCount % 15 == 0 and math.random(1,3) == 3 and (player:ToPlayer() and player:ToPlayer():GetShootingInput().X == 0 and player:ToPlayer():GetShootingInput().Y == 0) then
                        data.State = 2 
                    end
                end
                ent.Velocity = ent.Velocity * 0.8
            end
        end
        InutilLib.FlipXByVec(ent, true)

    elseif ent.Variant == RebekahCurse.Enemies.ENTITY_LOAFERING then

        if not data.Init then
            if spr:IsFinished("Appear") then
                data.Init = true
            end
            if not spr:IsPlaying("Appear") then
            	spr:Play("Appear")
            end
            data.FlipX = false
            data.State = 0
            data.SpawnPoint = ent.Position
        else
            if data.State == 0 then
                if not spr:IsPlaying("Move") then
                    spr:Play("Move", true)
                end
                InutilLib.MoveRandomlyTypeI(ent, data.SpawnPoint, 1.2, 0.9, 15, 0, 15)
                --local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, Vector.FromAngle(math.random(1,360)):Resized(11))
                if ent.FrameCount % 45 == 0 and math.random(1,4) == 4  then
                    data.State = 1 
                end
                ent.Velocity = ent.Velocity * 0.9
            elseif data.State == 1 then --recoil
                if spr:IsFinished("Hiccup") then
                    data.State = 0
                elseif not spr:IsPlaying("Hiccup") then
                    spr:Play("Hiccup", true)
                else
                    if spr:GetFrame() == 7 then
                        for i = 0, 360, 360/16 do
                             local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, Vector(0,7):Rotated(i))
                             proj.Scale = 0.4
                        end
                    end
                end
                ent.Velocity = ent.Velocity * 0.7
            end
            InutilLib.FlipXByVec(ent, true)
        end
    elseif ent.Variant == RebekahCurse.Enemies.ENTITY_FRUITFLY then

        if not data.Init then
            if spr:IsFinished("Appear") then
                data.Init = true
            end
            if not spr:IsPlaying("Appear") then
            	spr:Play("Appear")
            end
            data.FlipX = false
            data.State = 0
        else
            if data.State == 0 then
                if not spr:IsPlaying("Idle") then
                    spr:Play("Idle", true)
                end
                InutilLib.MoveDirectlyTowardsTarget(ent, player, 0.4, 0.9)
            end
        end
        InutilLib.FlipXByVec(ent, false)
    elseif ent.Variant == RebekahCurse.Enemies.ENTITY_EVALUATOR then
        if not data.Init then
            data.Init = true
            spr:Play("Idle", true)
            data.FlipX = false
            data.State = 0
        else
            if data.State == 0 then
                if InutilLib.room:IsClear() then
                    data.State = 1
                    data.RoomTimeScore = InutilLib.room:GetFrameCount()/30
                end
                InutilLib.FlipXByTarget(ent, player, false)
            else
                if spr:IsFinished("Evaluate") then
                    ent:Remove()
                elseif not spr:IsPlaying("Evaluate") then
                    spr:Play("Evaluate", true)
                else
                    if spr:GetFrame() == 40 then
                        local score = 0
                        if data.RoomTimeScore >= 30 then
                            score = score + 1
                        end
                        if isPlayerDmg then
                            score = score + 1
                        end
                        spr:SetOverlayFrame("Score", score)

                        if score == 0 then
                            Isaac.Spawn( EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_CHEST, 0, ent.Position, Vector.FromAngle(math.random(1,360)):Resized(math.random(4,6)), player );
                        elseif score == 1 then
                            local rng = math.random(1,3)
                            if rng == 1 then
                                Isaac.Spawn( EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, 0,  ent.Position,  Vector.FromAngle(math.random(1,360)):Resized(math.random(4,6)), player );
                            elseif rng == 2 then
                                Isaac.Spawn( EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, 0,  ent.Position,  Vector.FromAngle(math.random(1,360)):Resized(math.random(4,6)), player );
                            elseif rng == 3 then
                                Isaac.Spawn( EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_KEY, 0,  ent.Position,  Vector.FromAngle(math.random(1,360)):Resized(math.random(4,6)), player );
                            end
                        elseif score == 2 then
                            local rng = math.random(1,3)
                            if rng == 1 then
                                Isaac.Spawn( EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, 0,  ent.Position,  Vector.FromAngle(math.random(1,360)):Resized(math.random(4,6)), player );
                            elseif rng == 2 then
                                Isaac.Spawn( EntityType.ENTITY_SPIDER, 0, 0,  ent.Position,  Vector.FromAngle(math.random(1,360)):Resized(math.random(4,6)), player );
                            elseif rng == 3 then
                                Isaac.Spawn( EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_KEY, 0,  ent.Position,  Vector.FromAngle(math.random(1,360)):Resized(math.random(4,6)), player );
                            end
                        end
                    end
                    if spr:GetFrame() == 54 then
                        spr:RemoveOverlay()
                    end
                end
                spr.FlipX = false
            end
            ent.Velocity = ent.Velocity * 0.7
        end
    
    elseif ent.Variant == RebekahCurse.Enemies.ENTITY_DEVOTEE then
        if not data.Init then
            data.Init = true
            if not spr:IsPlaying("Idle") then
            	spr:Play("Idle")
            end
            data.FlipX = false
            data.State = 0
            data.positionCaches = {}
            ent:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
            ent:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
            ent.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS

            local rng = ent:GetDropRNG()

            if rng:RandomFloat() < 0.80 then
                spr:ReplaceSpritesheet(1, "gfx/monsters/academy/devotee_2.png")
            elseif rng:RandomFloat() < 0.60 then
                spr:ReplaceSpritesheet(1, "gfx/monsters/academy/devotee_3.png")
            elseif rng:RandomFloat() < 0.40 then
                spr:ReplaceSpritesheet(1, "gfx/monsters/academy/devotee_4.png")
            end
            if rng:RandomFloat() < 0.02 then
                spr:ReplaceSpritesheet(2, "gfx/monsters/academy/devotee_pray_hands.png")
            end

            spr:LoadGraphics()
        else
            local delay = 18
            table.insert(data.positionCaches, ent.Position)
		    if #data.positionCaches > delay and data.positionCaches[1] then table.remove(data.positionCaches, 1) end

            if data.State == 0 then
                if not spr:IsPlaying("Idle") then
                    spr:Play("Idle", true)
                end
            end
            if ent.SubType == 0 then
                if not ent.Child then
                    data.choochooHead = true
                    --i got this code base from FF's ossularry

                    local groupOfNuns = Isaac.FindByType(ent.Type, ent.Variant, 0)
                    local current = ent

                    repeat
                        local closest
                        local distance = 60

                        for _, entity in pairs (groupOfNuns) do
                            if entity.Position:Distance(current.Position) < distance and not yandereWaifu.GetEntityData(entity).choochooHead and entity.SubType == 0 then
                                closest = entity
                                distance = entity.Position:Distance(current.Position)
                            end
                        end

                        if closest then
                            current.Child = closest
                            closest.Parent = current
                            closest.SubType = 1
                            current = closest
                        end
                    until not closest
                end
                InutilLib.MoveDirectlyTowardsTarget(ent, player, 0.4, 0.9)
            else
                if ent.Parent then    
                    local parentData = yandereWaifu.GetEntityData(ent.Parent)
                    if parentData.positionCaches then
                        local targetPos = parentData.positionCaches[1] or ent.Position
                        local targetVelocity = (targetPos - ent.Position)
                        local lerpVal = 0.2
                        ent.Velocity = InutilLib.Lerp(ent.Velocity, targetVelocity, lerpVal)
                        data.positionCaches[#data.positionCaches] = targetPos
                    end
    
                    if ent.Parent:IsDead() then
                        ent.SubType = 0
                        data.choochooHead = true
                        ent.Parent = nil
                    end
                else
                    ent.SubType = 0
                    data.choochooHead = true
                    ent.Parent = nil
                end
            end
        end
    elseif ent.Variant == RebekahCurse.Enemies.ENTITY_GOSSIPER then
        if not data.Init then
            data.Init = true
            if not spr:IsPlaying("Idle") then
            	spr:Play("Idle")
            end
            data.FlipX = false
            data.State = 0
            ent:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
            ent:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
            ent.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
        end

        if not data.IsQueen and not data.Queen and not data.IsMinion then --init setup
			if data.State == 0 then
				local beeSpawn = 5
				for i = 0, beeSpawn, 1 do
					local minions = Isaac.Spawn(RebekahCurse.Enemies.ENTITY_REBEKAH_ENEMY, RebekahCurse.Enemies.ENTITY_GOSSIPER, 1, ent.Position, Vector(0,0), ent)
					local minionData = yandereWaifu.GetEntityData(minions)
					minionData.Queen = ent
					minionData.IsMinion = true
				end
				data.State = 1
                data.IsQueen = true
            end
        elseif data.IsQueen then
			if data.State == 1 then
				if not spr:IsPlaying("Idle") then
					spr:Play("Idle", true)
				end
                InutilLib.MoveDirectlyTowardsTarget(ent, player, 3, 0.9)
				ent.Velocity = ent.Velocity * 0.6
            end
		elseif data.IsMinion then
			if data.State == 0 then
				ent.Velocity = ent.Velocity + Vector(1,0):Rotated(math.random(0,360) * 5)
				data.State = 1
				data.StateFrame = 0
				data.randomNum = math.random(1,359)
			elseif data.State == 1 then
				if not spr:IsPlaying("Idle") then
					spr:Play("Idle", true)
				end
                if data.Queen:IsDead() then
                    local closest
                    local distance = 350
                    for _, entity in pairs (Isaac.FindByType( RebekahCurse.Enemies.ENTITY_REBEKAH_ENEMY, ent.Variant, -1, false, false)) do
                        if entity.Position:Distance(ent.Position) < distance and GetPtrHash(entity) ~= GetPtrHash(ent) and (entity.SubType == 1 or yandereWaifu.GetEntityData(entity).IsQueen) then
                            closest = entity
                            distance = entity.Position:Distance(ent.Position)
                        end
                    end

                    if closest then
                        yandereWaifu.GetEntityData(closest).IsQueen = true
                        yandereWaifu.GetEntityData(closest).IsMinion = false
                        data.Queen = closest
                        closest.SubType = 0
                    end
                end
			end
		
			if not data.Queen:IsDead() then --if the leading Queen isn't dead
				--InutilLib.MoveOrbitAroundTargetType1(ent, data.Queen, 2, 0.8, 3, data.randomNum)
                if ent.FrameCount % 5 == 0 then
                    InutilLib.MoveDirectlyTowardsTarget(ent, data.Queen, 5, 0.7)
                    ent.Velocity = ent.Velocity * 0.8 + (Vector.FromAngle(1*1)*(3.5)):Rotated(math.random(0,360))
                end
			else --else if she is
				InutilLib.MoveDirectlyTowardsTarget(ent, player, 3, 0.7)
			end
            ent.Velocity = ent.Velocity * 0.95
		end
    elseif ent.Variant == RebekahCurse.Enemies.ENTITY_FOUNDATION then
        if not data.Init then
            data.Init = true
            if not spr:IsPlaying("Idle") then
            	spr:Play("Idle")
            end
            data.FlipX = false
            data.State = 0
            data.positionCaches = {}
            ent:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
            ent:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
            ent.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS

            local rng = ent:GetDropRNG()

            --[[if rng:RandomFloat() < 0.80 then
                spr:ReplaceSpritesheet(1, "gfx/monsters/academy/devotee_2.png")
            elseif rng:RandomFloat() < 0.60 then
                spr:ReplaceSpritesheet(1, "gfx/monsters/academy/devotee_3.png")
            elseif rng:RandomFloat() < 0.40 then
                spr:ReplaceSpritesheet(1, "gfx/monsters/academy/devotee_4.png")
            end
            if rng:RandomFloat() < 0.02 then
                spr:ReplaceSpritesheet(2, "gfx/monsters/academy/devotee_pray_hands.png")
            end]]

            spr:LoadGraphics()
        else
            if data.State == 0 then
                if not spr:IsPlaying("Idle") then
                    spr:Play("Idle", true)
                end
                InutilLib.MoveDirectlyTowardsTarget(ent, player, 0.1, 0.8)
            end
        end
    elseif ent.Variant == RebekahCurse.Enemies.ENTITY_NPC then
        if not data.Init then
			data.HeadType = math.random(1,4)
			--data.skinColor = math.random(1,2)
			data.Init = true
            data.State = 1
		end
	
		--[[if data.skinColor == 2 then
			sprite:ReplaceSpritesheet(0, "gfx/monsters/garden/monster_whiteskin.png")
			sprite:ReplaceSpritesheet(1, "gfx/monsters/garden/monster_head_noob2.png")
			sprite:LoadGraphics()
			if data.fist then
				data.fist:GetSprite():ReplaceSpritesheet(0, "gfx/effects/effect_noobfist2.png")
				data.fist:GetSprite():LoadGraphics()
			end
		end]]
		if not spr:IsOverlayPlaying("Head5") then
			if data.HeadType == 1 then spr:PlayOverlay("Head", false) else spr:PlayOverlay("Head"..data.HeadType, false) end
		end

	
		if data.path == nil then data.path = ent.Pathfinder end
		if ent.SubType == 1 then
            local otherpersontheywannapunchforsomereason = InutilLib.GetClosestGenericEnemy(ent, 300)
            if otherpersontheywannapunchforsomereason then
                player = otherpersontheywannapunchforsomereason
            end
        end
		if data.State == 0 then
			data.State = 1
		elseif data.State == 1 then
			if data.path:HasPathToPos(player.Position, false) then
				data.State = 2
			end
		elseif data.State == 2 then
			InutilLib.XalumMoveTowardsTarget(ent, player, 4.5, 0.9, false)
			if ent.FrameCount % 15 == 0 and player.Position:Distance(ent.Position) <= 75 then
				data.State = 3
			end
		elseif data.State == 3 then
			if not data.fist then
                local fist = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.Enemies.ENTITY_BUMBAB_PUNCH, 0, ent.Position, Vector(0,0), ent)
                data.fist = fist
                yandereWaifu.GetEntityData(data.fist).fistowner = ent
                data.fist.Visible = (false)
			end
			local fistSprite = data.fist:GetSprite()
            if spr:IsFinished("Punch") then
				data.fist.Visible = (false)
				data.State = 1
			elseif not spr:IsPlaying("Punch") then
				spr:Play("Punch", true)
				fistSprite.Rotation = InutilLib.ObjToTargetAngle(ent, player, true) - 90
			elseif spr:IsEventTriggered("Punch") then
				data.fist.Visible = (true)
				if (fistSprite.Rotation >= -180 and fistSprite.Rotation <= 0) then	
					fistSprite:Play("Punch2", true)
				elseif (fistSprite.Rotation >= 0 and fistSprite.Rotation <= 180) then	
					fistSprite:Play("Punch", true)
				end
			--[[elseif fistSprite:IsEventTriggered("Hit") then
				local savedangle = fistSprite.Rotation + 90
				for i, entity in pairs (Isaac.GetRoomEntities()) do
					if (entity.Type == EntityType.ENTITY_PLAYER or entity:IsEnemy()) and GetPtrHash(entity) ~= GetPtrHash(ent) then
						if InutilLib.CuccoLaserCollision(ent, savedangle, 70, player, 30) and entity.Position:Distance(ent.Position) < 100 then --:Rotated(ObjToTargetAngle(ent, target, true))
							InutilLib.DoKnockbackTypeI(ent, entity, 0.3)
							entity:TakeDamage(1, 0, EntityRef(ent), 1)
                            SFXManager():Play( RebekahCurse.Sounds.SOUND_PUNCH, 1, 0, false, 1 );
						end
					end
				end]]
			end
			ent.Velocity = ent.Velocity * 0.7
		end
		if data.State ~= 3 then
			ent:AnimWalkFrame("WalkHori", "WalkVert", 0.1)
		end
    end
	
end, RebekahCurse.Enemies.ENTITY_REBEKAH_ENEMY)

function yandereWaifu:FistEffectUpdate(eff)
	local sprite = eff:GetSprite()
	local data = yandereWaifu.GetEntityData(eff)
	sprite.Offset = Vector(0, -5)
	eff.Position = data.fistowner.Position
	eff.Velocity = data.fistowner.Velocity--data.fistowner.Velocity
	if data.fistowner:IsDead() then
		eff:Remove()
	end
	if (sprite.Rotation >= -90 and sprite.Rotation <= 90) then	
		eff.RenderZOffset = 10
	elseif (sprite.Rotation >= -270 and sprite.Rotation <= -90) then
		eff.RenderZOffset = -10
	end
    if sprite:IsEventTriggered("Hit") then
        local savedangle = sprite.Rotation + 90
        for i, entity in pairs (Isaac.GetRoomEntities()) do
            if (entity.Type == EntityType.ENTITY_PLAYER or entity:IsEnemy()) and GetPtrHash(entity) ~= GetPtrHash(data.fistowner) then
                if InutilLib.CuccoLaserCollision(eff, savedangle, 70, entity, 30) and entity.Position:Distance( entity.Position) < 100 then --:Rotated(ObjToTargetAngle(ent, target, true))
                    InutilLib.DoKnockbackTypeI(eff, entity, 0.3)
                    entity:TakeDamage(1, 0, EntityRef(eff), 1)
                    SFXManager():Play( RebekahCurse.Sounds.SOUND_PUNCH, 1, 0, false, 1 );
                end
            end
        end
    end
end
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, yandereWaifu.FistEffectUpdate, RebekahCurse.Enemies.ENTITY_BUMBAB_PUNCH)

yandereWaifu:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, ent, damage, flags, source, countdown)
    if ent:ToPlayer() then
        if flags & DamageFlag.DAMAGE_FAKE ~= DamageFlag.DAMAGE_FAKE then
            isPlayerDmg = true
        end
    end
end)
yandereWaifu:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    isPlayerDmg = false
end)


yandereWaifu:AddCallback(ModCallbacks.MC_PRE_NPC_COLLISION, function(_, ent, coll, low)
	local data = yandereWaifu.GetEntityData(ent)
    if ent.Variant == RebekahCurse.Enemies.ENTITY_DEVOTEE then
        if coll.Type == ent.Type and coll.Variant == ent.Variant then
            if (ent.Parent and GetPtrHash(ent.Parent) == GetPtrHash(coll)) or (ent.Child and GetPtrHash(ent.Child) == GetPtrHash(coll)) then
                return true
            end
        end
    end
    --[[if ent.Variant == RebekahCurse.Enemies.ENTITY_GOSSIPER then
        if coll.Type == ent.Type and coll.Variant == ent.Variant then
            return true
        end
    end]]
end, RebekahCurse.Enemies.ENTITY_REBEKAH_ENEMY)