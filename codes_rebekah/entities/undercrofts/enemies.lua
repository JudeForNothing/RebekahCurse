local isPlayerDmg = false

yandereWaifu:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, ent)
	local spr = ent:GetSprite()
	local data = yandereWaifu.GetEntityData(ent)
	local player = ent:GetPlayerTarget()
	if ent.Variant == RebekahCurseEnemies.ENTITY_SISTER then

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
    elseif ent.Variant == RebekahCurseEnemies.ENTITY_BUMBAB then
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
                            local fist = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurseEnemies.ENTITY_BUMBAB_PUNCH, 0, ent.Position, Vector(0,0), ent)
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
                                if (InutilLib.ObjToTargetAngle(ent, entity, true) > (savedangle - 25) and InutilLib.ObjToTargetAngle(ent, entity, true) < (savedangle + 25)) and entity.Position:Distance(ent.Position) < 100 then --:Rotated(EntToTargetAngle(ent, target, true))
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
    elseif ent.Variant == RebekahCurseEnemies.ENTITY_ROACH then
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
                            InutilLib.FollowPath(ent, player, data.path, 1.5, 0.9)
                        else
                            InutilLib.MoveDirectlyTowardsTarget(ent, player, 1.5, 0.9)
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
    elseif ent.Variant == RebekahCurseEnemies.ENTITY_LONGITS then

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

    elseif ent.Variant == RebekahCurseEnemies.ENTITY_LOAFERING then

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
    elseif ent.Variant == RebekahCurseEnemies.ENTITY_FRUITFLY then

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
    elseif ent.Variant == RebekahCurseEnemies.ENTITY_EVALUATOR then
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
    end
	
end, RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY)

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
end
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, yandereWaifu.FistEffectUpdate, RebekahCurseEnemies.ENTITY_BUMBAB_PUNCH)

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