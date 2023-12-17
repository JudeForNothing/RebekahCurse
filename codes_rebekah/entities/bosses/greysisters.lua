yandereWaifu:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, function(_, proj)
	local data = yandereWaifu.GetEntityData(proj)
	if data.EnyoTear then
		--print(InutilLib.room:GetGridEntity(InutilLib.room:GetGridIndex((proj.Position +Vector(0,40):Rotated(data.BloodbendAngle - 90)))))
        InutilLib.MoveOrbitAroundTargetType1(proj, data.Parent, 3, 0.9, 7, data.startingNum)
        proj.GridCollisionClass = GridCollisionClass.COLLISION_NONE

        if proj.Parent:IsDead() then
            proj:Remove()
        end
	end
end)


local function getClosestEye(pos)
    local dist = 9999999999
    local ent = nil
    for i, v in pairs (Isaac.GetRoomEntities()) do
        if v.Type == RebekahCurse.Enemies.ENTITY_REBEKAH_ENEMY and v.Variant == RebekahCurse.Enemies.ENTITY_GREYSISTEREYE and v.SubType == 10 then
            if dist > v.Position:Distance(pos) then
                dist = v.Position:Distance(pos)
                ent = v
            end
        end
    end
    return ent
end

local function getClosestTooth(pos)
    local dist = 9999999999
    local ent = nil
    for i, v in pairs (Isaac.GetRoomEntities()) do
        if v.Type == RebekahCurse.Enemies.ENTITY_REBEKAH_ENEMY and v.Variant == RebekahCurse.Enemies.ENTITY_GREYSISTEREYE and v.SubType == 20 then
            if dist > v.Position:Distance(pos) then
                dist = v.Position:Distance(pos)
                ent = v
            end
        end
    end
    return ent
end

local function isGreySister(ent)
    if (ent.Variant == RebekahCurse.Enemies.ENTITY_ENYO or ent.Variant == RebekahCurse.Enemies.ENTITY_DEINO or ent.Variant == RebekahCurse.Enemies.ENTITY_PEMPHREDO) and ent.SubType ~= 10 then
        return true
    else
        return false
    end
end

function yandereWaifu:SisterRenderPost(entity, renderOffset)
	if not isGreySister(entity) then
		return
	end
	local data = entity:GetData()
	local sprite = entity:GetSprite()
	if sprite:IsFinished("Death") and not data.Explode then
		data.Explode = true
		entity:BloodExplode()
	end

end
yandereWaifu:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, yandereWaifu.SisterRenderPost, RebekahCurse.Enemies.ENTITY_REBEKAH_ENEMY)

--eye and tooth init
yandereWaifu:AddCallback(ModCallbacks.MC_POST_NPC_INIT, function(_, ent)
	local spr = ent:GetSprite()
	local data = yandereWaifu.GetEntityData(ent)
	local player = ent:GetPlayerTarget()
	local room = InutilLib.room
	if data.Explode == nil then
		data.Explode = false
	end
    if ent.Variant == RebekahCurse.Enemies.ENTITY_DEINO and (ent.SubType == 10 or ent.SubType == 20) then
        ent.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
		
	end
end, RebekahCurse.Enemies.ENTITY_REBEKAH_ENEMY)


yandereWaifu:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, ent)
	local spr = ent:GetSprite()
	local data = yandereWaifu.GetEntityData(ent)
	local player = ent:GetPlayerTarget()
	local room = InutilLib.room
	
    if (ent.SubType == 10 or ent.SubType == 20) and ent.Variant == RebekahCurse.Enemies.ENTITY_GREYSISTEREYE then 
    else
        local function pickEyeorTooth()
            if ent.SubType == 10 or ent.SubType == 20 then return end
            if not data.HasEye or not data.HasTooth then
                local eye = getClosestEye(ent.Position)
                if eye and ent.Position:Distance(eye.Position) < 50 + ent.Size + eye.Size and not yandereWaifu.GetEntityData(eye).IsTaken then
                    data.HasEye = true
                    eye:Remove()
                    yandereWaifu.GetEntityData(eye).IsTaken = true
                    data.Usages = math.random(1,4)
                    InutilLib.SFX:Play(SoundEffect.SOUND_PLOP, 1, 0, false, 1)
                    return
                end
                local tooth = getClosestTooth(ent.Position)
                if tooth and not tooth:GetSprite():IsPlaying("Drop") and ent.Position:Distance(tooth.Position) < 30 + ent.Size + tooth.Size and not yandereWaifu.GetEntityData(tooth).IsTaken then
                    data.HasTooth = true
                    tooth:Remove()
                    yandereWaifu.GetEntityData(tooth).IsTaken = true
                    data.Usages = math.random(1,4)
                    InutilLib.SFX:Play(SoundEffect.SOUND_PLOP, 1, 0, false, 1)
                    return
                end
            end
        end
        local function detectEyeorTooth()
            if ent.SubType == 10 or ent.SubType == 20 then return end
            if data.State > 1 then return end
            if not data.HasEye or not data.HasTooth then
                local eye = getClosestEye(ent.Position)
                if eye and ent.Position:Distance(eye.Position) < 50 + ent.Size + eye.Size and not yandereWaifu.GetEntityData(eye).IsTaken then
                    data.State = 5
                    eye.Velocity = eye.Velocity * 0.5
                    return true
                end
                local tooth = getClosestTooth(ent.Position)
                if tooth and not tooth:GetSprite():IsPlaying("Drop") and ent.Position:Distance(tooth.Position) < 30 + ent.Size + tooth.Size and not yandereWaifu.GetEntityData(tooth).IsTaken then
                    data.State = 5
                    tooth.Velocity = tooth.Velocity * 0.5
                    return true
                end
            end
            return false
        end
        local function detectClosestEmptyHanded()
            if ent.SubType == 10 then return end
            local pos = ent.Position
            local dist = 9999999999
            local result = nil
            for i, v in pairs (Isaac.GetRoomEntities()) do
                if v.Type == RebekahCurse.Enemies.ENTITY_REBEKAH_ENEMY and isGreySister(v) and not yandereWaifu.GetEntityData(v).HasEye and not yandereWaifu.GetEntityData(v).HasTooth then
                    if dist > v.Position:Distance(pos) then
                        dist = v.Position:Distance(pos)
                        result = v
                    end
                end
            end

            return result
        end
        local function checkifParentDead()
            if ent.Parent then
                if ent.Parent:IsDead() then
                    ent.Parent:Remove()
                    ent:Kill() 
                end
            else
                ent:Kill()
            end
        end
        if ent.Variant == RebekahCurse.Enemies.ENTITY_ENYO then
            checkifParentDead()
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
                    if math.random(1,3) == 3 and ent.FrameCount % 3 == 0 and player.Position:Distance(ent.Position) <= 120 then
                        data.State = 1
                    elseif math.random(1,2) == 2 and ent.FrameCount % 3 == 0 then
                        local eye = getClosestEye(ent.Position)
                        local tooth = getClosestTooth(ent.Position)
                        if eye or tooth then
                            local grabbie
                            if eye then
                                grabbie = eye
                            elseif tooth then
                                grabbie = tooth
                            end
                            if grabbie then
                                InutilLib.StrafeAroundTarget(ent, grabbie, 7, 0.9, 15)
                            end
                        end
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
                    if spr:IsFinished("StartupEye") then
                        local pos = InutilLib.WillFlip((player.Position - ent.Position):GetAngleDegrees(), false) 
                        InutilLib.SFX:Play(SoundEffect.SOUND_CUTE_GRUNT, 1, 0, false, 1)
						if pos then
                            spr:Play("BrimstoneLeft", true)
                        else
                            spr:Play("BrimstoneRight", true)
                        end
                        data.laserangle = (player.Position - ent.Position):GetAngleDegrees()
                        local beamColor = Color(1,0,0,1)
                        yandereWaifu.AddGenericTracer(ent.Position, beamColor, data.laserangle, 7)
                    elseif InutilLib.IsFinishedMultiple(spr, "BrimstoneLeft", "BrimstoneRight") then
                        if data.Usages <= 0 then
                            data.State = 4
                        else
                            data.Usages = data.Usages - 1
                            data.State = 2
                        end
                    elseif not InutilLib.IsPlayingMultiple(spr, "BrimstoneLeft", "BrimstoneRight") and not spr:IsPlaying("StartupEye")  then
                        local pos = InutilLib.WillFlip((player.Position - ent.Position):GetAngleDegrees(), false) 
                        InutilLib.SFX:Play(SoundEffect.SOUND_CUTE_GRUNT, 1, 0, false, 1)
						if pos then
                            spr:Play("BrimstoneLeft", true)
                        else
                            spr:Play("BrimstoneRight", true)
                        end
                    elseif InutilLib.IsPlayingMultiple(spr, "BrimstoneLeft", "BrimstoneRight") then
                        --[[if spr:GetFrame() == 1 then
                            data.laserangle = (player.Position - ent.Position):GetAngleDegrees()
                            local beamColor = Color(1,0,0,1)
                            yandereWaifu.AddGenericTracer(ent.Position, beamColor, data.laserangle, 7)
                        else]]if spr:GetFrame() == 8 then
                            local beam = EntityLaser.ShootAngle(LaserVariant.THIN_RED, ent.Position - Vector(0,-3), data.laserangle, 10, Vector(-12,-64), ent):ToLaser();
                            beam.Timeout = 7
                            beam.RenderZOffset = -100
                            ent.Velocity = Vector.FromAngle(data.laserangle):Rotated(180):Resized(8)
                        end
                    end
                elseif data.State == 4 then
                    if spr:IsFinished("Throw") then
                        data.State = 0
                        data.HasEye = false
                        data.HasTooth = false
                    elseif not spr:IsPlaying("Throw") then
						InutilLib.SFX:Play(SoundEffect.SOUND_CUTE_GRUNT, 1, 0, false, 1)
                        spr:Play("Throw", true)
                    elseif spr:GetFrame() == 30 then
                        local pos = detectClosestEmptyHanded()
                        if data.HasEye then
                            local eye = Isaac.Spawn(RebekahCurse.Enemies.ENTITY_REBEKAH_ENEMY, RebekahCurse.Enemies.ENTITY_DEINO, 10, ent.Position, (pos.Position - ent.Position):Resized(20), ent)
                            eye:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                        end
                        if data.HasTooth then
                            local tooth = Isaac.Spawn(RebekahCurse.Enemies.ENTITY_REBEKAH_ENEMY, RebekahCurse.Enemies.ENTITY_DEINO, 20, ent.Position, (pos.Position - ent.Position):Resized(20), ent)
                            tooth:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                        end
                    end
                elseif data.State == 5 then
                    if spr:IsFinished("Catch") then
                        if data.HasEye then
                            data.State = 2
                        elseif data.HasTooth then
                            data.State = 6
                        else
                            data.State = 1
                        end
                    elseif not spr:IsPlaying("Catch") then
                        spr:Play("Catch", true)
                    end
                    if spr:IsEventTriggered("Grabbed") then
                        pickEyeorTooth()
                    end
                elseif data.State == 6 then
                    if InutilLib.IsPlayingMultiple(spr, "IdleTooth", "IdleTooth2") then
                        ent.Velocity = (player.Position - ent.Position):Resized(2) * 0.9
                    end
                    if spr:IsFinished("IdleTooth") then
                        data.State = 6
                    elseif spr:IsFinished("ToothShoot2") then
                        data.State = 4
                    elseif not InutilLib.IsPlayingMultiple(spr, "IdleTooth", "IdleTooth2", "ToothShoot", "ToothShoot2") or InutilLib.IsFinishedMultiple(spr, "IdleTooth", "IdleTooth2", "ToothShoot", "ToothShoot2") then
                        if data.OrbitalTears and #data.OrbitalTears > 0 then
                            spr:Play("IdleTooth2", true)
                        else
                            spr:Play("IdleTooth", true)
                        end
                    elseif ent.FrameCount % 15 == 0 then
                        if math.random(1,2) == 2 and not InutilLib.IsPlayingMultiple(spr, "ToothShoot", "ToothShoot2") then
                            if data.Usages <= 0 then
                                spr:Play("ToothShoot2", true)
                                for i, v in pairs (data.OrbitalTears) do
                                    local projdata = yandereWaifu.GetEntityData(v)
                                    projdata.laserangle = (v.Position - ent.Position):GetAngleDegrees()
                                    local beamColor = Color(1,0,0,1)
                                    yandereWaifu.AddGenericTracer(ent.Position, beamColor, projdata.laserangle, 7)
                                    projdata.EnyoWillBurst = true
                                    projdata.EnyoTear = false
                                    v.Velocity = Vector.Zero
                                    InutilLib.SetTimer( 30, function()
                                        local beam = EntityLaser.ShootAngle(LaserVariant.THICK_RED, v.Position - Vector(0,-3), projdata.laserangle, 10, Vector(-12,-64), ent):ToLaser();
                                        beam.Timeout = 7
                                        beam.RenderZOffset = -100
                                        beam.DisableFollowParent = true
                                        beam.Position = v.Position
                                        v:Kill()
                                        ent.Velocity = Vector.FromAngle(projdata.laserangle):Rotated(180):Resized(8)
                                    end)
                                end
                                data.OrbitalTears = nil
                            else
                                spr:Play("ToothShoot", true)
                            end
                        end
                    end
                    if spr:IsEventTriggered("Spit") then
						InutilLib.SFX:Play(SoundEffect.SOUND_LITTLE_SPIT, 1, 0, false, 1)
                        local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, Vector(0,50))
                        proj.Scale = 2
                        proj.FallingSpeed = 0
                        proj.FallingAccel = -0.1
                        yandereWaifu.GetEntityData(proj).EnyoTear = true
                        yandereWaifu.GetEntityData(proj).startingNum = 90
                        yandereWaifu.GetEntityData(proj).Parent = ent
                        if not data.OrbitalTears then data.OrbitalTears = {} end
                        table.insert(data.OrbitalTears, proj)

                        ent.Velocity = (ent.Position - player.Position):Resized(6)
                        data.Usages = data.Usages - 1
                        InutilLib.SFX:Play(SoundEffect.SOUND_PLOP, 1, 0, false, 1)
                    end
                end
                ent.Velocity = ent.Velocity * 0.9
            end
        elseif ent.Variant == RebekahCurse.Enemies.ENTITY_DEINO then
            --tooth stuff
            if ent.SubType == 20 then
                if spr:IsEventTriggered("ToothDrop") then
                    InutilLib.SFX:Play(SoundEffect.SOUND_BONE_DROP, 1, 0, false, 1)
                end
                ent.Velocity = ent.Velocity * 0.8
            end
            if ent.SubType == 10 then
                ent.Velocity = ent.Velocity * 0.8
            end
            checkifParentDead()
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
                    elseif spr:GetFrame() >= 11 and spr:GetFrame() <= 13 then
                        local eye = getClosestEye(ent.Position)
                        local tooth = getClosestTooth(ent.Position)
                        if eye or tooth then
                            local grabbie
                            if eye then
                                grabbie = eye
                            elseif tooth then
                                grabbie = tooth
                            end
                            if grabbie then
                                InutilLib.StrafeAroundTarget(ent, grabbie, 3, 0.9, 15)
                            end
                        else
                            InutilLib.StrafeAroundTarget(ent, player, 3, 0.9, 15)
                        end
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
                        local pos = InutilLib.WillFlip((player.Position - ent.Position):GetAngleDegrees(), false) 
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
                        InutilLib.game:MakeShockwave(ent.Position, 0.065, 0.025, 10)

                        --[[for i = 0, 360 - 360/16, 360/16 do
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
                        end]]
                        InutilLib.SFX:Play(SoundEffect.SOUND_FORESTBOSS_STOMPS, 1, 0, false, 0.5)
                        --[[for i = 0, math.random(15,25) do
                            local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, (data.storedVelocity):Resized(math.random(5,10)):Rotated(math.random(-75,75)+180))
                            proj.Scale = math.random(9,12)/10
                            InutilLib.MakeProjectileLob(proj, 1.5, math.random(7,10) )
                        end]]
                    elseif not InutilLib.IsPlayingMultiple(spr, "Flying", "Crash") then
                        local pos = InutilLib.WillFlip(data.Dir:GetAngleDegrees(), false) 
                        InutilLib.SFX:Play(SoundEffect.SOUND_CHILD_HAPPY_ROAR_SHORT, 1, 0, false, 1)
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
                        if ent.FrameCount % 3 == 0 then
                            yandereWaifu:GuwahMakeAfterimage(ent)
                        end
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
                        if data.HasEye then
                            local eye = Isaac.Spawn(RebekahCurse.Enemies.ENTITY_REBEKAH_ENEMY, RebekahCurse.Enemies.ENTITY_DEINO, 10, ent.Position, (pos.Position - ent.Position):Resized(20), ent)
                            eye:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                        end
                        if data.HasTooth then
                            local tooth = Isaac.Spawn(RebekahCurse.Enemies.ENTITY_REBEKAH_ENEMY, RebekahCurse.Enemies.ENTITY_DEINO, 20, ent.Position, (pos.Position - ent.Position):Resized(20), ent)
                            tooth:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                        end
                    end
                elseif data.State == 5 then
                    if spr:IsFinished("Catch") then
                        if data.HasEye then
                            data.State = 2
                        elseif data.HasTooth then
                            data.State = 6
                        else
                            data.State = 1
                        end
                    elseif not spr:IsPlaying("Catch") then
                        spr:Play("Catch", true)
                    end
                    if spr:IsEventTriggered("Grabbed") then
                        pickEyeorTooth()
                    end
                elseif data.State == 6 then
                    if spr:IsFinished("ToothShoot") then
                        for i = -30, 30, 30 do
                            local proj = InutilLib.FireGenericProjAttack(ent, ProjectileVariant.PROJECTILE_ROCK, 0, ent.Position, (player.Position - ent.Position):Rotated(i):Resized(4))
                            proj:AddProjectileFlags(ProjectileFlags.BOUNCE)
                            yandereWaifu.GetEntityData(proj).trail = InutilLib.SpawnTrail(proj, Color(1,1,1,1), proj.Position - Vector(1, 22))
                            --proj.Height = -15
                            proj.FallingAccel = -0.092
                            proj.FallingSpeed = 1.2
                        end
                        InutilLib.SFX:Play(SoundEffect.SOUND_PLOP, 1, 0, false, 0.5)
                        if data.Usages <= 0 then
                            data.State = 4
                        else
                            data.Usages = data.Usages - 1
                            data.State = 6
                            spr:Play("IdleTooth", true)
                        end
                    elseif not spr:IsPlaying("ToothShoot") then
                        if not spr:IsPlaying("IdleTooth") then
                            spr:Play("IdleTooth", true)
                        elseif ent.FrameCount % 15 == 0 and math.random(1,3) == 3 then
                            spr:Play("ToothShoot", true)
                        end
                    end
                    if math.random(1,3) == 3 and ent.FrameCount % 15 == 0 then
                        InutilLib.StrafeAroundTarget(ent, player, 10, 0.9, -90)
                    end
                end
                ent.Velocity = ent.Velocity * 0.9
            end
        elseif ent.Variant == RebekahCurse.Enemies.ENTITY_PEMPHREDO then
            checkifParentDead()
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
                    if math.random(1,4) == 4 and ent.FrameCount % 7 == 0 then
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
                    end
                    --elseif spr:GetFrame() == 11 then
                    if spr:GetFrame() == 13 then
                        InutilLib.StrafeAroundTarget(ent, player, 7, 0.9, -90)
                    elseif spr:GetFrame() >= 13 then
                        InutilLib.StrafeAroundTarget(ent, player, 1, 0.9, -45)
                    end
                    InutilLib.FlipXByVec(ent, true)
                elseif data.State == 2 then
                    if spr:IsFinished("StartupEye") then
                        data.State = 3
                        data.CryFrame = 120
                    elseif spr:IsFinished("IdleEye") then
                        data.State = 1
                    elseif not spr:IsPlaying("IdleEye") and not spr:IsPlaying("StartupEye") then
                        spr:Play("IdleEye", true)
                    elseif ent.FrameCount % 15 == 0 and not spr:IsPlaying("StartupEye") then
                        if math.random(1,2) == 2 then
                            spr:Play("StartupEye", true)
                        else
                            data.State = 1
                        end
                    end
                    
                elseif data.State == 3 then 
                    if spr:IsFinished("CryEnd") then
                        data.State = 4
                    elseif not spr:IsPlaying("Cry") and not spr:IsPlaying("CryEnd") then
					InutilLib.SFX:Play(SoundEffect.SOUND_SCARED_WHIMPER, 1, 0, false, 1.2)
                        spr:Play("Cry", true)
                    end
                    if data.CryFrame and not spr:IsPlaying("CryEnd") then
                        if data.CryFrame <= 0 then
                            spr:Play("CryEnd", true)
                        end
                        data.CryFrame = data.CryFrame - 1
                    end
                    if data.CryFrame and data.CryFrame % 10 == 0 and not spr:IsPlaying("CryEnd") then
                        for i = 0, 360 - 360/2, 360/2 do
                            local proj = InutilLib.FireGenericProjAttack(ent, ProjectileVariant.PROJECTILE_TEAR, 0, ent.Position, Vector.FromAngle(i+math.random(-30,30)):Resized(7))
                            proj.Scale = math.random(10,18)/10
                            --proj:AddProjectileFlags(ProjectileFlags.SMART_PERFECT)
                            proj.FallingSpeed = 0
                            proj.FallingAccel = -0.1
                        end
                        for i = 0, 360 - 360/4, 360/4 do
                            local proj = InutilLib.FireGenericProjAttack(ent, ProjectileVariant.PROJECTILE_TEAR, 1, ent.Position, Vector.FromAngle(i):Resized(7))
                            proj.Scale = 0.9
                            proj:AddProjectileFlags(ProjectileFlags.CURVE_LEFT)
                            proj.FallingAccel = 0.3
                        end
                        for i = 0, 360 - 360/4, 360/4 do
                            local proj = InutilLib.FireGenericProjAttack(ent, ProjectileVariant.PROJECTILE_TEAR, 1, ent.Position, Vector.FromAngle(i):Resized(6))
                            proj.Scale = 1.4
                            proj:AddProjectileFlags(ProjectileFlags.CURVE_RIGHT)
                            proj.FallingSpeed = 0.3
                        end
                    end
                elseif data.State == 4 then
                    if spr:IsFinished("Throw") then
                        data.State = 0
                        data.HasEye = false
                        data.HasTooth = false
                    elseif not spr:IsPlaying("Throw") then
                        spr:Play("Throw", true)
                    elseif spr:GetFrame() == 24 then
                        local pos = detectClosestEmptyHanded()
                        if data.HasEye then
                            local eye = Isaac.Spawn(RebekahCurse.Enemies.ENTITY_REBEKAH_ENEMY, RebekahCurse.Enemies.ENTITY_DEINO, 10, ent.Position, (pos.Position - ent.Position):Resized(20), ent)
                            eye:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                        end
                        if data.HasTooth then
                            local tooth = Isaac.Spawn(RebekahCurse.Enemies.ENTITY_REBEKAH_ENEMY, RebekahCurse.Enemies.ENTITY_DEINO, 20, ent.Position, (pos.Position - ent.Position):Resized(20), ent)
                            tooth:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                        end
                    end
                elseif data.State == 5 then
                    if spr:IsFinished("Catch") then
                        if data.HasEye then
                            data.State = 2
                        elseif data.HasTooth then
                            data.State = 6
                        else
                            data.State = 1
                        end
                    elseif not spr:IsPlaying("Catch") then
                        spr:Play("Catch", true)
                    end
                    if spr:IsEventTriggered("Grabbed") then
                        pickEyeorTooth()
                    end
                elseif data.State == 6 then
                    if spr:IsFinished("ToothShoot") then
                        spr:Play("Scream", true)
                        InutilLib.SFX:Play(SoundEffect.SOUND_SIREN_SCREAM, 1, 0, false, 1.2)
                        data.CryLikeABFrame = math.random(90,150)
                    elseif spr:IsFinished("ScreamEnd") then
                        data.State = 4
                    elseif not InutilLib.IsPlayingMultiple(spr, "ToothShoot", "Scream", "ScreamEnd") then
                        if not spr:IsPlaying("IdleTooth") then
                            spr:Play("IdleTooth", true)
                        elseif ent.FrameCount % 9 == 0 and math.random(1,3) == 3 then
                            spr:Play("ToothShoot", true)
                        end
                    end
                    if math.random(1,3) == 3 and ent.FrameCount % 15 == 0 then
                        InutilLib.MoveDirectlyTowardsTarget(ent, player, 2, 0.9)
                    end
                    if spr:IsPlaying("Scream") then
                        if data.CryLikeABFrame then
                            data.CryLikeABFrame = data.CryLikeABFrame - 1
                            if data.CryLikeABFrame < 0 then
                                spr:Play("ScreamEnd", true)
                            else
                                if data.CryLikeABFrame % 30 == 0 then
                                    local rng = math.random(-15,15)
                                    for i = 0, 360 - 360/8, 360/8 do
                                        local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, Vector.FromAngle(i+rng):Resized(4))
                                        proj.Scale = 1.2
                                        proj:AddProjectileFlags(ProjectileFlags.SINE_VELOCITY)
                                        proj.FallingSpeed = -4
                                    end
                                    for i = 0, 360 - 360/8, 360/8 do
                                        local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, Vector.FromAngle(i):Resized(8))
                                        proj.Scale = 0.9
                                        proj:AddProjectileFlags(ProjectileFlags.CURVE_LEFT)
                                        proj.FallingAccel = 0.3
                                    end
                                    local cut = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SIREN_RING, 0, ent.Position, Vector(0,0), ent);
                                end
                            end
                        end
                    end
                end
                ent.Velocity = ent.Velocity * 0.9
            end
        elseif ent.Variant == RebekahCurse.Enemies.ENTITY_PERSIS then
            if not data.Init then
                --[[if ent.SubType == 10 then return end
                local pos = ent.Position
                local sisters = {
                    deino = {dist = 9999999999, ent = nil},
                    pemp = {dist = 9999999999, ent = nil},
                    eny = {dist = 9999999999, ent = nil},
                }
                for i, v in pairs (Isaac.GetRoomEntities()) do
                    if v.Type == RebekahCurse.Enemies.ENTITY_REBEKAH_ENEMY and isGreySister(v) and v.SubType == 0 then
                        if ent.Variant == RebekahCurse.Enemies.ENTITY_ENYO and sisters.eny.dist > v.Position:Distance(pos) then
                            sisters.eny.dist = v.Position:Distance(pos)
                            sisters.eny.ent = v
                        end
                        if ent.Variant == RebekahCurse.Enemies.ENTITY_DEINO and sisters.deino.dist > v.Position:Distance(pos) then
                            sisters.deino.dist = v.Position:Distance(pos)
                            sisters.deino.ent = v
                        end
                        if ent.Variant == RebekahCurse.Enemies.ENTITY_PEMPHREDO and sisters.pemp.dist > v.Position:Distance(pos) then
                            sisters.pemp.dist = v.Position:Distance(pos)
                            sisters.pemp.ent = v
                        end
                    end
                end
                data.eny = sisters.eny.ent
                data.deino = sisters.deino.ent
                data.pemp = sisters.pemp.ent

                data.deino.Parent = ent
                data.eny.Parent = ent
                data.pemp.Parent = ent]]

                for i = 0, 2 do
                    local vecfun = Vector(0,50):Rotated(i * (360/3))
                    local gurls = Isaac.Spawn(RebekahCurse.Enemies.ENTITY_REBEKAH_ENEMY, RebekahCurse.Enemies.ENTITY_ENYO+i, 0, ent.Position + vecfun, Vector.Zero, ent)
                    gurls:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                    gurls:AddEntityFlags(EntityFlag.FLAG_DONT_COUNT_BOSS_HP)
                    gurls.Parent = ent
                end

                ent.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                ent.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
                ent:AddEntityFlags(EntityFlag.FLAG_NO_FLASH_ON_DAMAGE | EntityFlag.FLAG_NO_STATUS_EFFECTS)
                ent.Color = Color(1,1,1,0,0,0,0)
                ent.Visible = false

                data.Init = true
            else
                if ent.HitPoints <= ent.MaxHitPoints / 2 and not data.SpawnedTooth then
                    local tooth = Isaac.Spawn(RebekahCurse.Enemies.ENTITY_REBEKAH_ENEMY, RebekahCurse.Enemies.ENTITY_DEINO, 20, ent.Position, Vector.Zero, ent)
                    tooth:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                    tooth:GetSprite():Play("Drop", true)
                    data.SpawnedTooth = true
                end
            end
        end
    end
end, RebekahCurse.Enemies.ENTITY_REBEKAH_ENEMY)

function yandereWaifu:sisterGreyHurt(ent, damage, flag, source)
    ent = ent:ToNPC()
	if isGreySister(ent) then
        local data = yandereWaifu.GetEntityData(ent)
		if ent.Parent and ent.Parent.Variant == RebekahCurse.Enemies.ENTITY_PERSIS then
            local damageFlashColor = Color(0.5, 0.5, 0.5, 1.0, 200/255, 0/255, 0/255) --taken from FF
    
			--ent:SetColor(damageFlashColor, 2, 0, false, false)
			ent.Parent:TakeDamage(damage, flag, EntityRef(ent), 0)

            if ent.Parent.HitPoints < damage then
                ent.Parent:Kill()
            end
			
		end
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, --[[CallbackPriority.LATE,]] yandereWaifu.sisterGreyHurt, RebekahCurse.Enemies.ENTITY_REBEKAH_ENEMY)

if StageAPI then	
	yandereWaifu.StageAPIBosses = {
		StageAPI.AddBossData("Grey Sisters", {
			Name = "Grey Sisters",
			Portrait = "gfx/ui/boss/portrait_greysisters.png",
			Offset = Vector(0,-15),
			Bossname = "gfx/ui/boss/name_greysisters.png",
			Weight = 2,
			Rooms = StageAPI.RoomsList("Grey Sisters Rooms", require("resources.luarooms.bosses.grey_sisters")),
			Entity = {Type = RebekahCurse.Enemies.ENTITY_REBEKAH_ENEMY, Variant = RebekahCurse.Enemies.ENTITY_THEMOON},
		})
	}
	StageAPI.AddBossToBaseFloorPool({BossID = "Grey Sisters"}, LevelStage.STAGE3_1,StageType.STAGETYPE_REPENTANCE_B)
end
