yandereWaifu:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_,  ent) 
    local spr = ent:GetSprite()
	local data = yandereWaifu.GetEntityData(ent)
	local player = ent:GetPlayerTarget()

    if ent.Variant == RebekahCurse.Enemies.ENTITY_DUSTBUNNY then
        if ent.SubType == 1 then
            if not data.Init then
                data.Init = true
                data.State = 0
                ent.GridCollisionClass = GridCollisionClass.COLLISION_SOLID
            end
            if data.State == 0 then
                ent.Velocity = Vector.Zero
                if spr:IsFinished("Idle") then
                    spr:Play("Idle", true)
                    data.State = 1
                end
            elseif data.State == 1 then
                if not spr:IsPlaying("Idle") then
                    spr:Play("Idle", true)
                end
            elseif data.State == 2 then
                if spr:IsFinished("Shoot") then
                    data.State = 1
                elseif not spr:IsPlaying("Shoot") then
                    spr:Play("Shoot", true)
                elseif spr:IsPlaying("Shoot") and spr:GetFrame() == 4 then
                    local rng = math.random(-65,65)
                    for i = 0, 360 - 360/6, 360/6 do
                        local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, (Vector(10,0)):Rotated(i+rng):Resized(6))
                    end
                end
            end
            if data.State ~= 0 then
                if data.Parent and not data.Parent:IsDead() then
                    InutilLib.MoveOrbitAroundTargetType1(ent, data.Parent, 3, 0.9, 7, data.startingNum)
                else
                    InutilLib.MoveDirectlyTowardsTarget(ent, player, 0.5+math.random(1,2)/10, 0.85)
                end
            end
        else
        
            if not data.Init then
                data.Init = true
                data.State = 0
                ent.GridCollisionClass = GridCollisionClass.COLLISION_SOLID
            end
            if data.State == 0 then
                ent.Velocity = Vector.Zero
                if spr:IsFinished("Idle") then
                    spr:Play("Idle", true)
                    data.State = 1
                end
            elseif data.State == 1 then
                if not spr:IsPlaying("Idle") then
                    spr:Play("Idle", true)
                end
                InutilLib.MoveDirectlyTowardsTarget(ent, player, 0.2+math.random(1,2)/10, 0.85)
            elseif data.State == 2 then
                if spr:IsFinished("Shoot") then
                    data.State = 1
                elseif not spr:IsPlaying("Shoot") then
                    spr:Play("Shoot", true)
                elseif spr:IsPlaying("Shoot") and spr:GetFrame() == 4 then
                    local rng = math.random(-65,65)
                    for i = 0, 360 - 360/3, 360/3 do
                        local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, (Vector(10,0)):Rotated(i+rng):Resized(6))
                    end
                end
            end
        end
    elseif ent.Variant == RebekahCurse.Enemies.ENTITY_BUNBUN then
        if not data.Init then
            data.Init = true
            data.State = 0
            ent.GridCollisionClass = GridCollisionClass.COLLISION_SOLID
        end
        if data.State == 0 then
            if not spr:IsPlaying("Idle") then spr:Play("Idle", true) end
            if math.random(1,2) == 2 and player then --to hop
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
                        if player then
                            if ent.Position:Distance(player.Position) <= 200 then
                                ent.Velocity = (player.Position - ent.Position) / 6
                            else
                                InutilLib.MoveDirectlyTowardsTarget(ent, player, math.random(10,13), 0.9)
                            end
                            InutilLib.FlipXByVec(ent, false)
                        end
                    elseif spr:IsEventTriggered("Land") then
                        ent.Velocity = Vector.Zero
                        InutilLib.SFX:Play(SoundEffect.SOUND_FORESTBOSS_STOMPS, 1, 0, false, 1)
                    end
                end
                ent.Velocity = ent.Velocity  * 0.9
        elseif data.State == 2 then
            spr:Play("Leap")
        elseif data.State == 3 then
            if spr:IsFinished("Hop") then
                data.State = 0
            end
            if spr:IsPlaying("Hop") then
                if spr:IsEventTriggered("Jump") then
                    InutilLib.MoveRandomlyTypeI(ent, InutilLib.room:GetRandomPosition(3), 5, 0.9, 30, 30, 90)
                elseif spr:IsEventTriggered("Land") then
                    ent.Velocity = Vector.Zero
                    InutilLib.SFX:Play(SoundEffect.SOUND_FORESTBOSS_STOMPS, 1, 0, false, 1)
                end
                InutilLib.FlipXByVec(ent, false)
            end
            ent.Velocity = ent.Velocity  * 0.9
        end
        
        --[[if spr:IsFinished("Leap") then
            ent:Remove()
        end]]
    elseif ent.Variant == RebekahCurse.Enemies.ENTITY_BUNCARPET then
        if not data.Init then
            data.Init = true
            data.State = 0
            ent.GridCollisionClass = GridCollisionClass.COLLISION_SOLID
        end
        if data.State == 0 then
            if not spr:IsPlaying("Idle") then spr:Play("Idle", true) end
            if ent.FrameCount % 9 == 0 then
                if math.random(1,2) == 2 and player then --to hop
                    spr:Play("Move")
                    data.State = 1
                elseif math.random(1,4) == 4 then
                    spr:Play("Shoot")
                    data.State = 2
                end
            end 
        elseif data.State == 1 then
            if spr:IsFinished("Move") then
                data.State = 0
                ent.Velocity = Vector.Zero
                InutilLib.SFX:Play(SoundEffect.SOUND_MEAT_IMPACTS, 1, 0, false, 1)
            elseif spr:IsPlaying("Move") then
                if spr:IsEventTriggered("Move") then
                    InutilLib.MoveRandomlyTypeI(ent, InutilLib.room:GetRandomPosition(3), 12, 0.9, 90, 5, 16)
                    InutilLib.FlipXByVec(ent, false)
                end
            end
        elseif data.State == 2 then
            if spr:IsFinished("Shoot") then
                data.State = 0
            elseif spr:IsPlaying("Shoot") then
                if spr:IsEventTriggered("Shoot") then
                    local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position,(player.Position - ent.Position):Resized(7)):ToProjectile()
                    proj:AddProjectileFlags(ProjectileFlags.BOUNCE_FLOOR)
                    ent.Velocity = Vector.Zero
                    --InutilLib.SFX:Play(SoundEffect.SOUND_FORESTBOSS_STOMPS, 1, 0, false, 1)
                end
                InutilLib.FlipXByTarget(ent, player, true)
            end
        end
        ent.Velocity = ent.Velocity  * 0.9
        
        --[[if spr:IsFinished("Leap") then
            ent:Remove()
        end]]
    end


end, RebekahCurse.Enemies.ENTITY_REBEKAH_ENEMY)


yandereWaifu:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, function(_, ent)
	if ent.Type == RebekahCurse.Enemies.ENTITY_REBEKAH_ENEMY and ent.Variant == RebekahCurse.Enemies.ENTITY_DUSTBUNNY then
        local rng = math.random(-65,65)
        if ent.SubType == 1 then
            for i = 0, 360 - 360/6, 360/6 do
                local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, (Vector(10,0)):Rotated(i+rng):Resized(7))
            end
        else
            for i = 0, 360 - 360/3, 360/3 do
                local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, (Vector(10,0)):Rotated(i+rng):Resized(7))
            end
        end
    end
end)

yandereWaifu:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, damage, amount, damageFlag, damageSource, damageCountdownFrames) --invincibilityframe when dashing or whatnot
	if damage:IsEnemy() then
		if  yandereWaifu.GetEntityData(damage).State ~= 2 and damage.Type == RebekahCurse.Enemies.ENTITY_REBEKAH_ENEMY and damage.Variant == RebekahCurse.Enemies.ENTITY_DUSTBUNNY then
            local rng = math.random(-65,65)
            yandereWaifu.GetEntityData(damage).State = 2
        end
	end
end)