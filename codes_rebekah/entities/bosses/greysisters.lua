local function getClosestEye(pos)
    local dist = 9999999999
    local ent = nil
    for i, v in pairs (Isaac.GetRoomEntities()) do
        if v.Type == RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY and v.Variant == RebekahCurseEnemies.ENTITY_GREYSISTEREYE and v.SubType == 10 then
            if dist > v.Position:Distance(pos) then
                dist = v.Position:Distance(pos)
                ent = v
            end
        end
    end
    return ent
end

local function isGreySister(ent)
    if (ent.Variant == RebekahCurseEnemies.ENTITY_ENYO or ent.Variant == RebekahCurseEnemies.ENTITY_DEINO or ent.Variant == RebekahCurseEnemies.ENTITY_PEMPHREDO) and ent.SubType ~= 10 then
        return true
    else
        return false
    end
end

--eye and tooth init
yandereWaifu:AddCallback(ModCallbacks.MC_POST_NPC_INIT, function(_, ent)
	local spr = ent:GetSprite()
	local data = yandereWaifu.GetEntityData(ent)
	local player = ent:GetPlayerTarget()
	local room = InutilLib.room
    if ent.Variant == RebekahCurseEnemies.ENTITY_DEINO and ent.SubType == 10 then
        ent.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
    end
end, RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY)


yandereWaifu:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, ent)
	local spr = ent:GetSprite()
	local data = yandereWaifu.GetEntityData(ent)
	local player = ent:GetPlayerTarget()
	local room = InutilLib.room

    if ent.SubType == 10 and ent.Variant == RebekahCurseEnemies.ENTITY_GREYSISTEREYE then 
    else
        local function detectEyeorTooth()
            if ent.SubType == 10 then return end
            if not data.HasEye and not data.HasTooth then
                local eye = getClosestEye(ent.Position)
                if eye and ent.Position:Distance(eye.Position) < 30 + ent.Size + eye.Size and not yandereWaifu.GetEntityData(eye).IsTaken then
                    data.HasEye = true
                    data.State = 5
                    eye:Remove()
                    yandereWaifu.GetEntityData(eye).IsTaken = true
                    data.Usages = math.random(5,7)
                end
            end
        end
        local function detectClosestEmptyHanded()
            if ent.SubType == 10 then return end
            local pos = ent.Position
            local dist = 9999999999
            local result = nil
            for i, v in pairs (Isaac.GetRoomEntities()) do
                if v.Type == RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY and isGreySister(v) and not yandereWaifu.GetEntityData(v).HasEye and not yandereWaifu.GetEntityData(v).HasTooth then
                    if dist > v.Position:Distance(pos) then
                        dist = v.Position:Distance(pos)
                        result = v
                    end
                end
            end
            print(result)
            return result
        end
        if ent.Variant == RebekahCurseEnemies.ENTITY_ENYO then
            if not data.State then
                spr:Play("Idle")
                data.State = 0
                ent:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
                ent:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
            else
                if data.State ~= 4 then 
                    detectEyeorTooth()
                end
                if data.State == 0 then
                    if spr:IsFinished("Idle") then
                        data.State = 1
                    elseif not spr:IsPlaying("Idle") then
                        spr:Play("Idle", true)
                    end
                    if math.random(1,3) == 3 and ent.FrameCount % 3 == 0 then
                        data.State = 1
                    end
                elseif data.State == 1 then
                    if spr:IsFinished("Avoid") then
                        if data.HasEye then
                            data.State = 2
                        else
                            data.State = 0
                        end
                        spr.FlipX = false -- force
                        return
                    elseif not spr:IsPlaying("Avoid") then
                        spr:Play("Avoid", true)
                    elseif spr:GetFrame() == 11 then
                        InutilLib.MoveAwayFromTarget(ent, player, 12, 0.9)
                    end
                    InutilLib.FlipXByVec(ent, false)
                elseif data.State == 2 then
                    if spr:IsFinished("IdleEye") then
                        data.State = 1
                    elseif spr:IsFinished("StartupEye") then
                        data.State = 3
                    elseif not spr:IsPlaying("IdleEye") then
                        spr:Play("IdleEye", true)
                    elseif ent.FrameCount % 15 == 0 then
                        if math.random(1,2) == 2 then
                            data.State = 3
                            spr:Play("StartupEye", true)
                        else
                            data.State = 1
                        end
                    end
                    
                elseif data.State == 3 then 
                    if InutilLib.IsFinishedMultiple(spr, "BrimstoneLeft", "BrimstoneRight") then
                        if data.Usages <= 0 then
                            data.State = 4
                        else
                            data.Usages = data.Usages - 1
                            data.State = 2
                        end
                    elseif not InutilLib.IsPlayingMultiple(spr, "BrimstoneLeft", "BrimstoneRight")  then
                        local pos = InutilLib.WillFlip((player.Position - ent.Position):GetAngleDegrees(), false) 
                        if pos then
                            spr:Play("BrimstoneLeft", true)
                        else
                            spr:Play("BrimstoneRight", true)
                        end
                    end
                    if spr:GetFrame() == 0 then
                        data.laserangle = (player.Position - ent.Position):GetAngleDegrees()
                        local beamColor = Color(1,0,0,1)
                        yandereWaifu.AddGenericTracer(ent.Position, beamColor, data.laserangle, 7)
                    end
                    if spr:GetFrame() == 8 then
                        local beam = EntityLaser.ShootAngle(LaserVariant.THIN_RED, ent.Position - Vector(0,-3), data.laserangle, 10, Vector(-12,-64), ent):ToLaser();
                        beam.Timeout = 7
                        beam.RenderZOffset = -100
                    end
                elseif data.State == 4 then
                    if spr:IsFinished("Throw") then
                        data.State = 0
                        data.HasEye = false
                        data.HasTooth = false
                    elseif not spr:IsPlaying("Throw") then
                        spr:Play("Throw", true)
                    elseif spr:GetFrame() == 30 then
                        local pos = detectClosestEmptyHanded()
                        local eye = Isaac.Spawn(RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY, RebekahCurseEnemies.ENTITY_DEINO, 10, ent.Position, (pos.Position - ent.Position):Resized(20), ent)
                        eye:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                    end
                elseif data.State == 5 then
                    if spr:IsFinished("Catch") then
                        if data.HasEye then
                            data.State = 2
                        elseif data.HasTooth then
                            data.State = 0
                        end
                    elseif not spr:IsPlaying("Catch") then
                        spr:Play("Catch", true)
                    end
                end
                ent.Velocity = ent.Velocity * 0.9
            end
        elseif ent.Variant == RebekahCurseEnemies.ENTITY_DEINO then
            if not data.State then
                spr:Play("Idle")
                data.State = 0
                ent:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
                ent:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
            else
                detectEyeorTooth()
                if data.State == 0 then
                    if spr:IsFinished("Idle") then
                        data.State = 1
                    elseif not spr:IsPlaying("Idle") then
                        spr:Play("Idle", true)
                    end
                    if math.random(1,3) == 3 and ent.FrameCount % 3 == 0 then
                        data.State = 1
                    end
                elseif data.State == 1 then
                    if spr:IsFinished("Avoid") then
                        if data.HasEye then
                            data.State = 2
                        else
                            data.State = 0
                        end
                        spr.FlipX = false -- force
                        return
                    elseif not spr:IsPlaying("Avoid") then
                        spr:Play("Avoid", true)
                    elseif spr:GetFrame() == 11 then
                        InutilLib.StrafeAroundTarget(ent, player, 6, 0.9, 90)
                    end
                    InutilLib.FlipXByVec(ent, false)
                elseif data.State == 2 then
                    if spr:IsFinished("IdleEye") then
                        data.State = 1
                    elseif spr:IsFinished("StartupEye") then
                        data.State = 3
                        data.Dir = player.Position - ent.Position
                    elseif spr:IsPlaying("StartupEye") then
                        local x
                        if InutilLib.ClosestHorizontalWall(ent) == Direction.LEFT then
                            x = Round(math.abs(InutilLib.room:GetTopLeftPos().X), 0) + 50
                            spr.FlipX = true
                        else
                            x = Round(math.abs(InutilLib.room:GetBottomRightPos().X), 0) - 50
                        end
                        local pos = Vector(x, player.Position.Y)
                        ent.Velocity = (ent.Velocity * 0.01) + ((pos - ent.Position)*0.05)
                    elseif not spr:IsPlaying("IdleEye") then
                        spr:Play("IdleEye", true)
                    elseif ent.FrameCount % 15 == 0 then
                        if math.random(1,2) == 2 then
                            spr:Play("StartupEye", true)
                        else
                            data.State = 1
                        end
                    end
                    
                elseif data.State == 3 then 
                    if spr:IsFinished("Crash") then
                        if data.Usages <= 0 then
                            data.State = 4
                        else
                            data.Usages = data.Usages - 1
                            data.State = 2
                        end
                        spr.FlipX = false
                    elseif ent:CollidesWithGrid() then
                        spr:Play("Crash", true)
                        ent.Velocity = Vector.Zero
                        InutilLib.game:ShakeScreen(5)

                        for i = 0, 360 - 360/16, 360/16 do
                            local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, Vector.FromAngle(i):Resized(12))
                            proj.Scale = 0.9
                            proj:AddProjectileFlags(ProjectileFlags.CURVE_LEFT)
                            proj.FallingAccel = 0.3
                        end
                        for i = 0, 360 - 360/8, 360/8 do
                            local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, Vector.FromAngle(i):Resized(11))
                            proj.Scale = 1.4
                            proj:AddProjectileFlags(ProjectileFlags.CURVE_RIGHT)
                            proj.FallingSpeed = 0.3
                        end

                        --[[for i = 0, math.random(15,25) do
                            local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, (data.storedVelocity):Resized(math.random(5,10)):Rotated(math.random(-75,75)+180))
                            proj.Scale = math.random(9,12)/10
                            InutilLib.MakeProjectileLob(proj, 1.5, math.random(7,10) )
                        end]]
                    elseif not InutilLib.IsPlayingMultiple(spr, "Flying", "Crash") then
                        local pos = InutilLib.WillFlip(data.Dir:GetAngleDegrees(), false) 
                        if pos then
                            spr:Play("Flying", true)
                        else
                            spr:Play("Flying", true)
                        end
                    elseif spr:IsPlaying("Flying") then
                        ent.Velocity = (ent.Velocity * 0.9) + data.Dir:Resized(8)
                        data.storedVelocity = ent.Velocity
                        local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, (ent.Velocity):Resized(3):Rotated(math.random(-15,15)+180))
                        proj.Scale = 1.3
                        proj:AddProjectileFlags(ProjectileFlags.BURST)
                    end
                elseif data.State == 4 then
                    if spr:IsFinished("Throw") then
                        data.State = 0
                        data.HasEye = false
                        data.HasTooth = false
                    elseif not spr:IsPlaying("Throw") then
                        spr:Play("Throw", true)
                    elseif spr:GetFrame() == 30 then
                        local pos = detectClosestEmptyHanded()
                        local eye = Isaac.Spawn(RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY, RebekahCurseEnemies.ENTITY_DEINO, 10, ent.Position, (pos.Position - ent.Position):Resized(20), ent)
                        eye:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                    end
                elseif data.State == 5 then
                    if spr:IsFinished("Catch") then
                        if data.HasEye then
                            data.State = 2
                        elseif data.HasTooth then
                            data.State = 0
                        end
                    elseif not spr:IsPlaying("Catch") then
                        spr:Play("Catch", true)
                    end
                end
                ent.Velocity = ent.Velocity * 0.9
            end
        elseif ent.Variant == RebekahCurseEnemies.ENTITY_PEMPHREDO then
            if not data.State then
                spr:Play("Idle")
                data.State = 0
                ent:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
                ent:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
            else
                detectEyeorTooth()
                if data.State == 0 then
                    if spr:IsFinished("Idle") then
                        data.State = 1
                    elseif not spr:IsPlaying("Idle") then
                        spr:Play("Idle", true)
                    end
                    if math.random(1,3) == 3 and ent.FrameCount % 3 == 0 then
                        data.State = 1
                    end
                elseif data.State == 1 then
                    if spr:IsFinished("Avoid") then
                        if data.HasEye then
                            data.State = 2
                        else
                            data.State = 0
                        end
                        spr.FlipX = false -- force
                        return
                    elseif not spr:IsPlaying("Avoid") then
                        spr:Play("Avoid", true)
                    elseif spr:GetFrame() == 11 then
                        InutilLib.StrafeAroundTarget(ent, player, 6, 0.9, -90)
                    end
                    InutilLib.FlipXByVec(ent, true)
                elseif data.State == 2 then
                    if spr:IsFinished("IdleEye") then
                        data.State = 1
                    elseif spr:IsFinished("StartupEye") then
                        data.State = 3
                    elseif not spr:IsPlaying("IdleEye") then
                        spr:Play("IdleEye", true)
                    elseif ent.FrameCount % 15 == 0 then
                        if math.random(1,2) == 2 then
                            data.State = 3
                            spr:Play("StartupEye", true)
                        else
                            data.State = 1
                        end
                    end
                    
                elseif data.State == 3 then 
                    if InutilLib.IsFinishedMultiple(spr, "BrimstoneLeft", "BrimstoneRight") then
                        data.State = 2
                    elseif not InutilLib.IsPlayingMultiple(spr, "BrimstoneLeft", "BrimstoneRight")  then
                        local pos = InutilLib.WillFlip((player.Position - ent.Position):GetAngleDegrees(), false) 
                        if pos then
                            spr:Play("BrimstoneLeft", true)
                        else
                            spr:Play("BrimstoneRight", true)
                        end
                    end
                    if spr:GetFrame() == 0 then
                        data.laserangle = (player.Position - ent.Position):GetAngleDegrees()
                        local beamColor = Color(1,0,0,1)
                        yandereWaifu.AddGenericTracer(ent.Position, beamColor, data.laserangle, 7)
                    end
                    if spr:GetFrame() == 8 then
                        local beam = EntityLaser.ShootAngle(LaserVariant.THIN_RED, ent.Position - Vector(0,-3), data.laserangle, 10, Vector(-12,-64), ent):ToLaser();
                        beam.Timeout = 7
                        beam.RenderZOffset = -100
                    end
                end
                ent.Velocity = ent.Velocity * 0.9
            end
        end
    end
end, RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY)

