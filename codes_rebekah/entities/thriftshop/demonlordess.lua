local enemyList = {
    [1] = {variant = RebekahCurse.Enemies.ENTITY_DUSTBUNNY, subtype = 0},
    [2] = {variant = RebekahCurse.Enemies.ENTITY_BUNBUN, subtype = 0},
    [3] = {variant = RebekahCurse.Enemies.ENTITY_DUSTBUNNY, subtype = 1},
    [4] = {variant = RebekahCurse.Enemies.ENTITY_OVUM_EGG, subtype = 0},
    [5] = {variant = RebekahCurse.Enemies.ENTITY_BUNCARPET, subtype = 0},
    [6] = {variant = RebekahCurse.Enemies.ENTITY_ROACH, subtype = 0},
}

yandereWaifu:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, function(_, proj)
	local data = yandereWaifu.GetEntityData(proj)
	if data.BunnyBullet then
		--print(InutilLib.room:GetGridEntity(InutilLib.room:GetGridIndex((proj.Position +Vector(0,40):Rotated(data.BloodbendAngle - 90)))))
		--proj.Scale = 1.7
		--[[proj.FallingSpeed = (10)*-1;
		proj.FallingAccel = 1;]]
        proj.Height = -24
		if proj.FrameCount % 2 == 0 then
            local proj = InutilLib.FireGenericProjAttack(proj.Parent, 0, 1, proj.Position, proj.Velocity:Rotated(180+math.random(-15,15)):Resized(10))
            if math.random(2) == 2 then
                proj:AddProjectileFlags(ProjectileFlags.MEGA_WIGGLE)
            else
                proj:AddProjectileFlags(ProjectileFlags.WIGGLE)
            end
            proj.Scale = math.random(12,19)/10
        end
	end
end)

yandereWaifu:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_,  ent) 
    local spr = ent:GetSprite()
	local data = yandereWaifu.GetEntityData(ent)
	local player = ent:GetPlayerTarget()
    if ent.Variant == RebekahCurse.Enemies.ENTITY_THEDEMONLORDESS then
        if not data.Init then
            data.Init = true
            data.State = 0
            ent.GridCollisionClass = GridCollisionClass.COLLISION_SOLID
            ent:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
            ent:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
        end
        if ent.SubType == 0 then --main body
            if data.State == 0 then
                if not spr:IsPlaying("Appear") then
                    spr:Play("Appear", true)
                end
                data.State = 1
                for i = 0, 3 do
                    local doorPos = InutilLib.game:GetRoom():GetDoorSlotPosition(i)
                    local rng = math.random(0,10)
                -- if door then
                    local door = Isaac.Spawn( RebekahCurse.Enemies.ENTITY_REBEKAH_ENEMY, ent.Variant, 5, doorPos, Vector(0,0), ent );
                    if i == 0 then
                        door:GetSprite().Rotation = -90
                    elseif i == 2 then
                        door:GetSprite().Rotation = 90
                    elseif i == 3 then
                        door:GetSprite().Rotation = 180
                    end
                    --    if door:IsOpen() then
                    --        door:Bar()
                    -- end
                        --InutilLib.room:SetClear(false)
                    --end
                end
            elseif data.State == 1 then
                InutilLib.FlipXByTarget(ent, player, true)
                if spr:IsFinished("Shoot") then 
                    spr:Play("Idle", true)
                end
                ent.Velocity = ent.Velocity * 0.9
                InutilLib.MoveRandomlyTypeI(ent, InutilLib.room:GetCenterPos() + Vector(0, player.Position.Y), 2, 0.7, 85, 30, 90)
                if not spr:IsPlaying("Idle") and not spr:IsPlaying("Idle2") then
                    spr:Play("Idle", true)
                end
                if math.random(5) == 5 and ent.FrameCount % 9 == 0 then
                    if math.random(3) == 3 then
                        data.State = 2
                    else
                        local ents = Isaac.FindInRadius(ent.Position, 750, EntityPartition.ENEMY)
                        spr:Play("Idle2", true)
                        if math.random(2) == 2 and #ents < 5 then
                            data.State = 3
                        --[[else
                            data.State = 5]]
                        end
                    end
                end
            elseif data.State == 2 then
                ent.Velocity = ent.Velocity * 0.9
                if spr:IsFinished("Shoot") then 
                    data.State = 1
                elseif not spr:IsPlaying("Shoot") then 
                    spr:Play("Shoot", true) 
                    data.Attack3Cooldown = 300
                elseif spr:IsPlaying("Shoot") then
                    if spr:IsEventTriggered("Shoot") then
                        local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, (player.Position - ent.Position):Resized(12))
                        --proj:AddProjectileFlags(ProjectileFlags.SIDEWAVE)
                        proj.Scale = 2.5
                        yandereWaifu.GetEntityData(proj).BunnyBullet = true
                        ent.Velocity = (ent.Position - player.Position):Resized(13)
                            --[[for j = -30, 30, 15 do
                                local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, (player.Position - ent.Position):Rotated(i+j):Resized(3))
                                InutilLib.MakeProjectileLob(proj, 1.5, 9)
                                proj:AddProjectileFlags(ProjectileFlags.BURSTSPLIT)
                                proj.Scale = 1.5
                            end]]
                    end
                end
            elseif data.State == 3 then
                ent.Velocity = ent.Velocity * 0.9
                if spr:IsFinished("UseHorse") then 
                    data.State = 1
                elseif not spr:IsPlaying("UseHorse") then 
                    spr:Play("UseHorse", true) 
                elseif spr:IsPlaying("UseHorse") then
                    if spr:IsEventTriggered("Shoot") then
                        for i, v in pairs (Isaac.FindByType(ent.Type, ent.Variant, 5)) do
                            yandereWaifu.GetEntityData(v).State = 2
                        end
                    end
                end
            end
        elseif ent.SubType == 5 then
            if data.State == 0 then
                --spr:Load('gfx/bosses/thriftshop/demonlordess_2.anm2',true)
                spr:SetFrame("Eye", 0)
                data.State = 1
            elseif data.State == 1 then
                spr:SetFrame("Eye", 0)
            elseif data.State == 2 then
                ent.Velocity = ent.Velocity * 0.9
                if spr:IsFinished("Open") then 
                    data.State = 1
                elseif not spr:IsPlaying("Open") then 
                    spr:Play("Open", true) 
                    print("sabra")
                elseif spr:IsPlaying("Open") then
                    if spr:IsEventTriggered("Shoot") then
                        local rng = math.random(1,#enemyList)
                        local ent = Isaac.Spawn( RebekahCurse.Enemies.ENTITY_REBEKAH_ENEMY, enemyList[rng].variant, enemyList[rng].subtype, InutilLib.room:FindFreePickupSpawnPosition(ent.Position, 1), Vector(0,0), nil );
                    end
                end
            end
        end
    end
end, RebekahCurse.Enemies.ENTITY_REBEKAH_ENEMY)