local function spawnPitfalls(type)
    if type == 1 then
        for i = 0, 360 - 360/4, 360/4 do
            local mob = Isaac.Spawn(EntityType.ENTITY_PITFALL, 0, 0, InutilLib.room:GetCenterPos() + (Vector(130,0)):Rotated(i), Vector(0,0), nil );
        end
    elseif type == 2 then
        for i = 0, 360 - 360/4, 360/4 do
            local mob = Isaac.Spawn(EntityType.ENTITY_PITFALL, 0, 0, InutilLib.room:GetCenterPos() + (Vector(130,0)):Rotated(i + 45), Vector(0,0), nil );
        end
    elseif type == 3 then
        for i = 0, 360 - 360/6, 360/6 do
            local mob = Isaac.Spawn(EntityType.ENTITY_PITFALL, 0, 0, InutilLib.room:GetCenterPos() + (Vector(130,0)):Rotated(i), Vector(0,0), nil );
        end
    elseif type == 4 then
        for i = 0, 360 - 360/6, 360/6 do
            local mob = Isaac.Spawn(EntityType.ENTITY_PITFALL, 0, 0, InutilLib.room:GetCenterPos() + (Vector(130,0)):Rotated(i+30), Vector(0,0), nil );
        end
    elseif type == 5 then
        for i = -120, 120, 60 do
            local mob = Isaac.Spawn(EntityType.ENTITY_PITFALL, 0, 0, InutilLib.room:GetCenterPos() + Vector(i,0), Vector(0,0), nil );
        end
    elseif type == 6 then
        for i = -120, 120, 60 do
            local mob = Isaac.Spawn(EntityType.ENTITY_PITFALL, 0, 0, InutilLib.room:GetCenterPos() + Vector(0,i), Vector(0,0), nil );
        end
    elseif type == 7 then
        for i = -120, 120, 60 do
            if i ~= 0 then
                local mob = Isaac.Spawn(EntityType.ENTITY_PITFALL, 0, 0, InutilLib.room:GetCenterPos() + Vector(i,0), Vector(0,0), nil );
            end
        end
        for i = -120, 120, 60 do
            local mob = Isaac.Spawn(EntityType.ENTITY_PITFALL, 0, 0, InutilLib.room:GetCenterPos() + Vector(0,i), Vector(0,0), nil );
        end
    elseif type == 8 then
        for i = 0, 360 - 360/8, 360/8 do
            local mob = Isaac.Spawn(EntityType.ENTITY_PITFALL, 0, 0, InutilLib.room:GetCenterPos() + (Vector(130,0)):Rotated(i), Vector(0,0), nil );
        end
    end
end


yandereWaifu:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_,  ent) 
    local spr = ent:GetSprite()
	local data = yandereWaifu.GetEntityData(ent)
	local player = ent:GetPlayerTarget()

	--[[if ent.SubType == 0 then
		if data.State == 0 then
			if spr:IsEventTriggered("Land") then
				for k, v in pairs (Isaac.GetRoomEntities()) do
					if v.Type == EntityType.ENTITY_EFFECT and v.Variant == RebekahCurse.ENTITY_EGGSHELLS and v.Position:Distance(ent.Position) <= 10 then
						v:Remove()
					end
				end
				data.Collidable = true
			end
		end
	elseif ent.SubType == 1 then]]
    if ent.Variant == RebekahCurse.Enemies.ENTITY_RABBET then
        InutilLib.FlipXByVec(ent, true)
		ent.Velocity = ent.Velocity  * 0.9
        if not data.Init then
            data.Init = true
            data.State = 0
            ent.GridCollisionClass = GridCollisionClass.COLLISION_SOLID
            ent:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
			ent:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
            spr:Play("JumpDown", true)
        end
		if data.State == 0 then
			ent.Velocity = Vector.Zero
			if spr:IsEventTriggered("Land") then
				local mob = Isaac.Spawn( EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 2, ent.Position, Vector(0,0), player );
				InutilLib.SFX:Play(SoundEffect.SOUND_FORESTBOSS_STOMPS, 1, 0, false, 0.8)
				InutilLib.game:ShakeScreen(5)
			end
			if spr:IsFinished("JumpDown") then
				spr:Play("Roar", true)
				data.State = 1
			end
		elseif data.State == 1 then
			if spr:IsPlaying("Roar") then
				if spr:IsEventTriggered("Roar") then
					InutilLib.SFX:Play( SoundEffect.SOUND_BOSS_LITE_ROAR, 1, 0, false, 1.3 );
					for k, v in pairs (Isaac.GetRoomEntities()) do
						if v.Type == EntityType.ENTITY_EFFECT and v.Variant == RebekahCurse.ENTITY_EGGSHELLS and not yandereWaifu.GetEntityData(v).IsSmashed then
							--[[yandereWaifu.GetEntityData(v).IsSmashed = true
							InutilLib.SetTimer( (20-math.random(3,5))*k, function()
								local egg = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_RABBET_FAMILIAR, 0, v.Position, Vector.Zero, nil)
								yandereWaifu.GetEntityData(v).IsSmashed = true
								--v:Remove()
								if math.random(1,2) == 2 then
									local egg = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_RABBET_FAMILIAR, 0, InutilLib.room:GetRandomPosition(5), Vector.Zero, nil)
								end
							end)]]
						elseif v:IsEnemy() then
							v:AddEntityFlags(EntityFlag.FLAG_FEAR)
						end
					end
				end
			elseif spr:IsFinished("Roar") then
				data.State = 2
			end
		elseif data.State == 2 then

			if spr:IsFinished("Hop") then 
				if math.random(1,3) == 3 and #Isaac.FindByType(EntityType.ENTITY_PROJECTILE, -1, -1) <= 0 then
					data.State = 3
                else
                    if math.random(1,4) == 4 then
                        data.State = 4
                    else
                        spr:Play("Hop", true) 
                    end
				end
			elseif not spr:IsPlaying("Hop") then 
                spr:Play("Hop", true) 
            elseif spr:IsPlaying("Hop") then
				if spr:IsEventTriggered("Jump") then
					if player then
						if ent.Position:Distance(player.Position) <= 200 then
							ent.Velocity = (player.Position - ent.Position) / 8
						else
							InutilLib.MoveDirectlyTowardsTarget(ent, player, math.random(10,13), 0.9)
						end
					end
                    ent.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
				elseif spr:IsEventTriggered("Land") then
					ent.Velocity = Vector.Zero
					InutilLib.SFX:Play(SoundEffect.SOUND_FORESTBOSS_STOMPS, 1, 0, false, 1)
                    ent.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
				end
			end
        elseif data.State == 3 then
            if spr:IsFinished("Spit") then
                data.State = 2
            elseif not spr:IsPlaying("Spit") then
                spr:Play("Spit", true) 
            elseif spr:IsEventTriggered("Roar") then
                ent.Velocity = Vector.Zero
                InutilLib.SFX:Play( SoundEffect.SOUND_BOSS_LITE_ROAR, 1, 0, false, 1.3 );
                data.targetVector = (player.Position - ent.Position)
            elseif spr:WasEventTriggered("Roar") and spr:GetFrame() < 34 then
				local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, (data.targetVector):Rotated(math.random(-15,15)):Resized(10))
				InutilLib.MakeProjectileLob(proj, 1.5, 9+math.random(0,4))
				proj:AddProjectileFlags(ProjectileFlags.BOUNCE_FLOOR)
				proj.Scale = math.random(16,27)/10
				InutilLib.SFX:Play(SoundEffect.SOUND_WORM_SPIT, 1, 0, false, 0.8)
            end

        elseif data.State == 4 then
            if not InutilLib.IsPlayingMultiple(spr, "JumpDown", "JumpUp") and not data.BounceInstance then
                spr:Play("JumpUp", true)
                data.BounceInstance = 3
            end
			if spr:IsFinished("JumpDown") then 
				if data.BounceInstance <= 0 then
					data.State = 3
                    data.BounceInstance = nil
				else
					spr:Play("JumpUp", true)
                    data.BounceInstance = data.BounceInstance - 1
				end
            elseif spr:IsFinished("JumpUp") then 
                spr:Play("JumpDown", true)
			elseif spr:IsPlaying("JumpDown") then
				if spr:IsEventTriggered("Land") then
					ent.Velocity = Vector.Zero
					InutilLib.SFX:Play(SoundEffect.SOUND_FORESTBOSS_STOMPS, 1, 0, false, 1)
                    ent.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
                    data.targetVector = (player.Position - ent.Position)
                    if data.BounceInstance == 3 then
                        for i = 0, 360-360/4, 360/4 do
                            local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, (data.targetVector):Rotated(i):Resized(10))
                            proj:AddProjectileFlags(ProjectileFlags.CURVE_LEFT)
                            proj.Scale = 1.8
                        end
                    elseif data.BounceInstance == 2 then
                        for i = 0, 360-360/4, 360/4 do
                            local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, (data.targetVector):Rotated(i):Resized(10))
                            proj:AddProjectileFlags(ProjectileFlags.CURVE_RIGHT)
                            proj.Scale = 1.8
                        end
                    elseif data.BounceInstance == 1 then
                        for i = 0, 360-360/8, 360/8 do
                            local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, (data.targetVector):Rotated(i):Resized(10))
                            proj:AddProjectileFlags(ProjectileFlags.BOUNCE_FLOOR)
                            InutilLib.MakeProjectileLob(proj, 1.5, 9)
                            proj.Scale = 1.8
                        end
                    end
				end
            elseif spr:IsPlaying("JumpUp") then
                if spr:WasEventTriggered("Jump") then
					if player then
						if ent.Position:Distance(player.Position) <= 200 then
							ent.Velocity = (player.Position - ent.Position) / 8
						else
							InutilLib.MoveDirectlyTowardsTarget(ent, player, math.random(10,13), 0.9)
						end
					end
                    ent.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
				end
            end
		end
    elseif ent.Variant == RebekahCurse.Enemies.ENTITY_HOLEDINI then
        if not data.Init then
            data.Init = true
            data.State = 0
            ent.GridCollisionClass = GridCollisionClass.COLLISION_SOLID
            ent:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
			ent:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
            spr:Play("TeleportBack", true)
        end
        if ent.FrameCount % 5 == 0 then
            local dust = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DARK_BALL_SMOKE_PARTICLE, 0, ent.Position, Vector(0,0), ent)
        end
		if data.State == 0 then
            if spr:IsFinished("TeleportBack") then
				spr:Play("Idle", true)
				data.State = 1
			end
        elseif data.State == 1 then
            ent.Velocity = ent.Velocity * 0.9
            InutilLib.MoveRandomlyTypeI(ent, InutilLib.room:GetCenterPos(), 2, 0.7, 85)
            if not spr:IsPlaying("Idle") then
                spr:Play("Idle", true)
            end
            if math.random(1,5) == 5 and ent.FrameCount % 9 == 0 then
                if math.random(1,3) == 3 then
                    data.State = 2
                else
                    if math.random(1,2) == 2 and #Isaac.FindByType(EntityType.ENTITY_PITFALL, -1, -1) <= 0 then
                        data.State = 6
                    else
                        data.State = 5
                    end
                end
            end
        elseif data.State == 2 then
            ent.Velocity = ent.Velocity * 0.9
            if spr:IsFinished("Teleport") then 
                if #Isaac.FindByType(EntityType.ENTITY_PITFALL, -1, -1) > 0 and math.random(1,2) == 2 then
                    data.State = 3
                else
                    data.State = 4
                    ent.Position = Isaac.GetRandomPosition()
                end
            elseif not spr:IsPlaying("Teleport") then 
                spr:Play("Teleport", true) 
            elseif spr:IsPlaying("Teleport") then
            end
        elseif data.State == 3 then
            ent.Velocity = ent.Velocity * 0.9
            local function gotopitfall()
                for i, v in pairs(Isaac.FindByType(EntityType.ENTITY_PITFALL, -1, -1)) do
                    if math.random(1,3) == 3 then
                        ent.Position = v.Position
                        v:Remove()
                        return true
                    end
                end
                return false
            end
            if spr:IsFinished("ShootOut") then
                if #Isaac.FindByType(EntityType.ENTITY_PITFALL, -1, -1) > 0 then
                    local go = gotopitfall()
                    if go then
                        spr:Play("ShootOut", true) 
                    end
                else
                    if data.BunnyLoop and data.BunnyLoop > 0 then
                        data.BunnyLoop = data.BunnyLoop - 1
                        spawnPitfalls(math.random(1,8))
                        local go = gotopitfall()
                        if go then
                            spr:Play("ShootOut", true) 
                        end
                        if math.random(1,3) == 3 then
                            data.State = 7
                        end
                    else
                        data.State = 4
                        ent.Position = Isaac.GetRandomPosition()
                    end
                end
            elseif not spr:IsPlaying("ShootOut") then
                local go = gotopitfall()
                if go then
                    spr:Play("ShootOut", true) 
                end
                if ent.HitPoints < ent.MaxHitPoints/2 then
                    data.BunnyLoop = 2
                end
            elseif spr:IsPlaying("ShootOut") then
                if spr:IsEventTriggered("Shoot") then
                    for i = -30, 30, 30 do
                        local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, (player.Position - ent.Position):Rotated(i):Resized(8))
                        InutilLib.MakeProjectileLob(proj, 1.5, 9)
                        proj:AddProjectileFlags(ProjectileFlags.BOUNCE_FLOOR)
                        proj.Scale = 1.4
                        InutilLib.SFX:Play(SoundEffect.SOUND_WORM_SPIT, 1, 0, false, 0.8)
                    end
                end
            end
        elseif data.State == 4 then
            ent.Velocity = ent.Velocity * 0.9
            if spr:IsFinished("TeleportBack") then 
                data.State = 1
            elseif not spr:IsPlaying("TeleportBack") then 
                spr:Play("TeleportBack", true) 
            elseif spr:IsPlaying("TeleportBack") then
            end
        elseif data.State == 5 then
            ent.Velocity = ent.Velocity * 0.9
            if spr:IsFinished("Shoot") then 
                data.State = 1
            elseif not spr:IsPlaying("Shoot") then 
                spr:Play("Shoot", true) 
            elseif spr:IsPlaying("Shoot") then
                if spr:IsEventTriggered("Shoot") then
                    if math.random(1,3) == 3 then
                        local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, (player.Position - ent.Position):Resized(6))
                        InutilLib.MakeProjectileLob(proj, 1.5, 9)
                        proj:AddProjectileFlags(ProjectileFlags.BOUNCE_FLOOR | ProjectileFlags.BURST)
                        proj.Scale = 2.8
                        InutilLib.SFX:Play(SoundEffect.SOUND_WORM_SPIT, 1, 0, false, 0.8)
                    else
                        for i = -30, 30, 30 do
                            local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, (player.Position - ent.Position):Rotated(i):Resized(8))
                            InutilLib.MakeProjectileLob(proj, 1.5, 9)
                            proj:AddProjectileFlags(ProjectileFlags.BOUNCE_FLOOR)
                            proj.Scale = 1.6
                            InutilLib.SFX:Play(SoundEffect.SOUND_WORM_SPIT, 1, 0, false, 0.8)
                        end
                        for i = -20, 20, 10 do
                            local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, (player.Position - ent.Position):Rotated(i):Resized(6))
                            InutilLib.MakeProjectileLob(proj, 1.5, 9)
                            proj:AddProjectileFlags(ProjectileFlags.BOUNCE_FLOOR)
                            proj.Scale = 1.1
                            InutilLib.SFX:Play(SoundEffect.SOUND_WORM_SPIT, 1, 0, false, 0.8)
                        end
                    end
                end
            end
        elseif data.State == 6 then
            ent.Velocity = ent.Velocity * 0.9
            if spr:IsFinished("Slam") then 
                data.State = 1
            elseif not spr:IsPlaying("Slam") then 
                spr:Play("Slam", true) 
            elseif spr:IsPlaying("Slam") then
                if spr:IsEventTriggered("Shoot") then
                    InutilLib.SFX:Play(SoundEffect.SOUND_FORESTBOSS_STOMPS, 1, 0, false, 0.8)
                    if ent.HitPoints < ent.MaxHitPoints/2 then
                        spawnPitfalls(math.random(1,7))
                    else
                        spawnPitfalls(math.random(1,3))
                    end
                    InutilLib.game:ShakeScreen(10)
                end
            end
        elseif data.State == 7 then
            ent.Velocity = ent.Velocity * 0.9
            local function gotopitfall()
                for i, v in pairs(Isaac.FindByType(EntityType.ENTITY_PITFALL, -1, -1)) do
                    if math.random(1,3) == 3 then
                        ent.Position = v.Position
                        v:Remove()
                        return true
                    end
                end
                return false
            end
            if spr:IsFinished("ShootOut") then
                if #Isaac.FindByType(EntityType.ENTITY_PITFALL, -1, -1) > 0 then
                    local go = gotopitfall()
                    if go then
                        spr:Play("ShootOut", true) 
                    end
                else
                    if data.BunnyLoop and data.BunnyLoop > 0 then
                        data.BunnyLoop = data.BunnyLoop - 1
                        spawnPitfalls(math.random(1,8))
                        local go = gotopitfall()
                        if go then
                            spr:Play("ShootOut", true) 
                        end
                        data.State = 3
                    else
                        data.State = 4
                        ent.Position = Isaac.GetRandomPosition()
                    end
                    spr.PlaybackSpeed = 1
                end
            elseif not spr:IsPlaying("ShootOut") then
                local go = gotopitfall()
                if go then
                    spr:Play("ShootOut", true) 
                end
                if ent.HitPoints < ent.MaxHitPoints/2 then
                    data.BunnyLoop = 2
                end
                spr.PlaybackSpeed = 2
            elseif spr:IsPlaying("ShootOut") then
                if spr:IsEventTriggered("Shoot") then
                    local bomb = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, BombSubType.BOMB_SUPERTROLL, ent.Position, (player.Position - ent.Position):Resized(10), ent):ToBomb()
                    --bomb.Velocity = (player.Position - ent.Position):Resized(10)
                    bomb:ClearEntityFlags(EntityFlag.FLAG_APPEAR )
                   -- InutilLib.MakeBombLob(bomb, 1, 8 )
                    bomb.Timeout = math.random(4,7)
                end
            end
        end
    elseif ent.Variant == RebekahCurse.Enemies.ENTITY_DUKEOFFLUFF then
        if not data.Init then
            data.Init = true
            data.State = 0
            ent.GridCollisionClass = GridCollisionClass.COLLISION_SOLID
            ent:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
			ent:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
        end
        InutilLib.FlipXByVec(ent, true)
        if data.State ~= 0 then
            InutilLib.MoveDiagonalTypeI(ent, 3, false, true)
        end
        if data.State == 0 then
			ent.Velocity = Vector.Zero
			if spr:IsFinished("Appear") then
				spr:Play("Idle", true)
				data.State = 1
			end
        elseif data.State == 1 then
            if not spr:IsPlaying("Idle") then
                spr:Play("Idle", true)
            end
            if math.random(1,3) == 3 and ent.FrameCount % 15 == 0 then
                local rng = math.random(1,2)
                if rng == 1 and ent.HitPoints < ent.MaxHitPoints - ent.MaxHitPoints/3 and #Isaac.FindByType(RebekahCurse.Enemies.ENTITY_REBEKAH_ENEMY, RebekahCurse.Enemies.ENTITY_DUSTBUNNY, 1) <= 1 then
                    data.State = 3
                elseif rng == 1 and #Isaac.FindByType(RebekahCurse.Enemies.ENTITY_REBEKAH_ENEMY, RebekahCurse.Enemies.ENTITY_DUSTBUNNY, 0) < 2 then
                    data.State = 2
                elseif not data.Attack3Cooldown then
                    data.State = 4
                end
            end
        elseif data.State == 2 then
            if spr:IsFinished("Attack1") then 
                data.State = 1
            elseif not spr:IsPlaying("Attack1") then 
                spr:Play("Attack1", true) 
            elseif spr:IsPlaying("Attack1") then
                if spr:IsEventTriggered("Shoot") then
                    local fluff = Isaac.Spawn(RebekahCurse.Enemies.ENTITY_REBEKAH_ENEMY, RebekahCurse.Enemies.ENTITY_DUSTBUNNY, 0, ent.Position, (player.Position - ent.Position):Resized(10), ent):ToNPC()
                    fluff:ClearEntityFlags(EntityFlag.FLAG_APPEAR )
                end
            end
        elseif data.State == 3 then
            if spr:IsFinished("Attack2") then 
                data.State = 1
            elseif not spr:IsPlaying("Attack2") then 
                spr:Play("Attack2", true) 
            elseif spr:IsPlaying("Attack2") then
                if spr:IsEventTriggered("Shoot") then
                    for i = 0, 180, 180 do
                        local fluff = Isaac.Spawn(RebekahCurse.Enemies.ENTITY_REBEKAH_ENEMY, RebekahCurse.Enemies.ENTITY_DUSTBUNNY, 1, ent.Position, (player.Position - ent.Position):Resized(10), ent):ToNPC()
                        fluff:ClearEntityFlags(EntityFlag.FLAG_APPEAR )
                        yandereWaifu.GetEntityData(fluff).Parent = ent
                        yandereWaifu.GetEntityData(fluff).startingNum = i
                    end
                end
            end
        elseif data.State == 4 then
            if spr:IsFinished("Attack3") then 
                data.State = 1
            elseif not spr:IsPlaying("Attack3") then 
                spr:Play("Attack3", true) 
                data.Attack3Cooldown = 300
            elseif spr:IsPlaying("Attack3") then
                if spr:IsEventTriggered("Shoot") then
                    for i = 0, 360 - 360/3, 360/3 do
                        local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, (player.Position - ent.Position):Rotated(i):Resized(5))
                        InutilLib.MakeProjectileLob(proj, 1.5, 9)
                        proj:AddProjectileFlags(ProjectileFlags.BOUNCE_FLOOR)
                        proj.Scale = 1.8
                        for j = -30, 30, 15 do
                            local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, (player.Position - ent.Position):Rotated(i+j):Resized(3))
                            InutilLib.MakeProjectileLob(proj, 1.5, 9)
                            proj:AddProjectileFlags(ProjectileFlags.BOUNCE_FLOOR)
                            proj.Scale = 1.5
                        end
                    end
                    for i, v in pairs (Isaac.FindByType(RebekahCurse.Enemies.ENTITY_REBEKAH_ENEMY, RebekahCurse.Enemies.ENTITY_DUSTBUNNY, 1)) do
                        if v.Position:Distance(ent.Position) < 100 then
                            yandereWaifu.GetEntityData(v).Parent = nil
                        end
                    end
                end
            end
        end
        if data.Attack3Cooldown then 
            data.Attack3Cooldown = data.Attack3Cooldown - 1
            if data.Attack3Cooldown <= 0 then
                data.Attack3Cooldown = nil
            end
        end
    elseif ent.Variant == RebekahCurse.Enemies.ENTITY_POMPOMS then
        if not data.Init then
            data.Init = true
            data.State = 0
            ent.GridCollisionClass = GridCollisionClass.COLLISION_SOLID
            ent:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
			ent:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
            data.positionCaches = {}
        end
        local delay = 9
        table.insert(data.positionCaches, ent.Position)
        if #data.positionCaches > delay and data.positionCaches[1] then table.remove(data.positionCaches, 1) end

        if data.State == 0 then
            if not spr:IsPlaying("Side") then
                spr:Play("Side", true)
            end
            data.IsTraining = true
            data.State = 1
        elseif data.State == 1 then
            InutilLib.AnimShootFrame(ent, false, ent.Velocity, "Side", "Front", "Back")
            if not data.IsScatter and data.CanNowShoot and math.random(1,7) == 7 and ent.FrameCount % 15 == 0 then
                data.State = 2
            elseif data.IsScatter and math.random(1,7) == 7 and ent.FrameCount % 30 == 0 then
                data.State = 2
            elseif data.IsScatter and math.random(1,3) == 3 and ent.FrameCount % 30 == 0 and player.Position:Distance(ent.Position) < 150 then
                data.State = 3
            end
        elseif data.State == 2 then
            if spr:IsFinished("Shoot") then
                data.State = 1
            elseif not spr:IsPlaying("Shoot") then
                spr:Play("Shoot", true)
            elseif spr:IsEventTriggered("Shoot") then
                local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, (player.Position - ent.Position):Resized(7))
                InutilLib.MakeProjectileLob(proj, 1.5, 9)
                proj:AddProjectileFlags(ProjectileFlags.BOUNCE_FLOOR)
                proj.Scale = 1.5
                InutilLib.SFX:Play(SoundEffect.SOUND_WORM_SPIT, 1, 0, false, 1.1)
                if data.IsAngry then
                    for i = 0, math.random(1,2) do
                        local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, (player.Position - ent.Position):Rotated(math.random(-10,10)):Resized(6+math.random(-2,2)))
                        InutilLib.MakeProjectileLob(proj, 1.5, 9)
                        proj:AddProjectileFlags(ProjectileFlags.BOUNCE_FLOOR)
                        proj.Scale = 0.9
                        InutilLib.SFX:Play(SoundEffect.SOUND_WORM_SPIT, 1, 0, false, 1.1)
                    end
                end
            end 
        elseif data.State == 3 then
            if spr:IsFinished("Charge") then
                data.State = 1
            elseif not spr:IsPlaying("Charge") then
                spr:Play("Charge", true)
                if #Isaac.FindByType(ent.Type, ent.Variant, -1) < 3 then
                    spr.PlaybackSpeed = 0.5
                end
            elseif spr:IsEventTriggered("Shoot") then
                InutilLib.MoveDirectlyTowardsTarget(ent, player, 12, 0.9)
                InutilLib.SFX:Play(SoundEffect.SOUND_WORM_SPIT, 1, 0, false, 1.1)
                if #Isaac.FindByType(ent.Type, ent.Variant, -1) < 3 then
                    --InutilLib.MoveDirectlyTowardsTarget(ent, player, 0.4, 0.9)
                    InutilLib.MoveRandomlyTypeI(ent, InutilLib.room:GetCenterPos(), 12, 0.7, 85)
                    ent:BloodExplode()
                    local bomb = Isaac.Spawn(EntityType.ENTITY_BOMBDROP, BombVariant.BOMB_GIGA, 0, ent.Position, Vector.Zero, ent):ToBomb();
                    bomb.ExplosionDamage = 100
                    bomb:SetExplosionCountdown(0)
                end
            elseif spr:IsPlaying("Shoot") then
                if ent.FrameCount % 2 == 0 and #Isaac.FindByType(ent.Type, ent.Variant, -1) < 3 then
                    SFXManager():Play( RebekahCurse.Sounds.SOUND_IMDIECHIME , 1, 0, false, 1)
                end
            end
        end
        if data.IsRunning then
            local groupofBuns = Isaac.FindByType(ent.Type, ent.Variant, -1)

            data.IsRunning = data.IsRunning - 1
            if data.IsRunning <= 0 then
                data.IsRunning = nil
                data.IsSearching = true
            end
            if spr:GetFrame() == 6 then
                --InutilLib.MoveDirectlyTowardsTarget(ent, player, 0.4, 0.9)
                InutilLib.MoveAwayFromTarget(ent, player, 12, 0.9)
                --InutilLib.MoveRandomlyTypeI(ent, InutilLib.room:GetCenterPos(), 3, 0.7, 85)
            else
               ent.Velocity = ent.Velocity * 0.9
            end
        end
        if data.IsSearching then
            if ent.Parent then
                if ent.Parent.Position:Distance(ent.Position) < 50 then
                    data.IsSearching = nil
                    data.IsTraining = true
                    spr:ReplaceSpritesheet(0, "gfx/bosses/thriftshop/pompoms2.png")
                    spr:LoadGraphics()
                    data.CanNowShoot = true
                else
                    if spr:GetFrame() == 6 then
                        InutilLib.MoveDirectlyTowardsTarget(ent, ent.Parent, 12, 0.9)
                    else
                       ent.Velocity = ent.Velocity * 0.9
                    end
                end
            else
                data.IsTraining = true
                spr:ReplaceSpritesheet(0, "gfx/bosses/thriftshop/pompoms4.png")
                spr:LoadGraphics()
                data.CanNowShoot = true
                data.IsAngry = true
            end
        end
        if data.IsScatter then
            if spr:GetFrame() == 6 and not spr:IsPlaying("Charge") then
                --InutilLib.MoveDirectlyTowardsTarget(ent, player, 0.4, 0.9)
                InutilLib.MoveRandomlyTypeI(ent, InutilLib.room:GetCenterPos(), 9, 0.7, 85)
            else
               ent.Velocity = ent.Velocity * 0.9
            end
        end
        if data.IsTraining then
            if ent.SubType == 0 then
                if not ent.Child then
                    data.choochooHead = true
                    --i got this code base from FF's ossularry

                    local groupofBuns = Isaac.FindByType(ent.Type, ent.Variant, 0)
                    local current = ent

                    repeat
                        local closest
                        local distance = 60

                        for _, entity in pairs (groupofBuns) do
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
               
                if spr:GetFrame() == 6 then
                     --InutilLib.MoveDirectlyTowardsTarget(ent, player, 0.4, 0.9)
                    InutilLib.XalumMoveTowardsTarget(ent, player, 16, 0.9)
                else
                    ent.Velocity = ent.Velocity * 0.9
                end
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
    elseif ent.Variant == RebekahCurse.Enemies.ENTITY_THEPUFF then
        if not data.Init then
            data.Init = true
            data.State = 0
        end
        if ent.SubType == 1 then
            if data.State == 0 then
                ent.Velocity = Vector.Zero
                spr:Play("Eye", true)
                data.State = 1
                ent:ClearEntityFlags(EntityFlag.FLAG_APPEAR )
            end
            if data.State == 1 then
                InutilLib.MoveDiagonalTypeI(ent, 6, false, true)
            end
            if spr:GetFrame() == 12 then
                local splat = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_RED, 0, ent.Position, Vector(0,0), ent):ToEffect()
                splat.Timeout = 20
            end
        else
            if data.State == 0 then
                ent.Velocity = Vector.Zero
                if spr:IsFinished("Appear") then
                    spr:Play("Idle", true)
                    data.State = 1
                    ent:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
			        ent:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
                end
            elseif data.State == 1 then
                if not spr:IsPlaying("Idle") then
                    spr:Play("Idle", true)
                end
                if not data.BloatCooldown then data.BloatCooldown = 0 end
                if data.BloatCooldown > 0 then data.BloatCooldown = data.BloatCooldown - 1 end
                if ent.FrameCount % 30 == 0 and ent.HitPoints <= (ent.MaxHitPoints / 3)*2 and data.BloatCooldown <= 0 then
                    if InutilLib.CuccoLaserCollision(ent, 0, 700, player, 25) then
                        data.State = 9
                        --spr:Play("1ShootRight", true)
                        data.IsSides = true
                    elseif InutilLib.CuccoLaserCollision(ent, 90, 700, player, 60) then
                        data.State = 9
                        --spr:Play("1ShootFront", true)
                    elseif InutilLib.CuccoLaserCollision(ent, 180, 700, player, 25) then
                        data.State = 9
                        data.IsSides = true
                        --spr:Play("1ShootLeft", true)
                    --elseif InutilLib.CuccoLaserCollision(ent, 270, 700, player) then
                    --    data.State = 5
                        --spr:Play("1ShootBack", true)
                    end
                end
                if math.random(1,3) == 3 and ent.FrameCount % 15 == 0 then
                    if math.random(1,4) == 4 and ent.HitPoints <= (ent.MaxHitPoints / 3) then
                        if not data.FirstTimeThirdPhase then
                            data.FirstTimeThirdPhase = true
                            data.HasBrimstone = true
                            data.State = 6
                        else
                            data.State = 6
                        end
                    elseif math.random(1,2) == 2 and ent.HitPoints <= (ent.MaxHitPoints / 3)*2 and #Isaac.FindByType(ent.Type, ent.Variant, 1) <= 1 then
                        data.State = 5
                    else
                        local rng = math.random(2,4)
                        data.State = rng
                        if data.State == 4 and #Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_RED, -1) >= 12 then
                            data.State = math.random(2,3)
                        end
                    end
                elseif math.random(1,5) == 5 and ent.FrameCount % 15 == 0 then
                    ent.Velocity = ent.Velocity + (InutilLib.room:GetCenterPos()-ent.Position):Rotated(math.random(-30,30)):Resized(3)
                end
                if not data.FirstTimeSecondPhase and ent.HitPoints <= (ent.MaxHitPoints / 3)*2 then
                    data.FirstTimeSecondPhase = true
                    data.State = 6
                end
            elseif data.State == 2 then
                if spr:IsFinished("Jump") then
                    data.State = 1
                elseif not spr:IsPlaying("Jump") then
                    spr:Play("Jump", true)
                elseif spr:IsEventTriggered("Stomp") then
                    InutilLib.SFX:Play(SoundEffect.SOUND_FORESTBOSS_STOMPS, 1, 0, false, 0.8)
                    InutilLib.game:ShakeScreen(5)
                    Isaac.Spawn(EntityType.ENTITY_EFFECT, 16, 3, ent.Position, Vector.Zero, ent)
                    Isaac.Spawn(EntityType.ENTITY_EFFECT, 16, 4, ent.Position, Vector.Zero, ent)
                    local rng = math.random(-45,45)
                    for i = 0, 360 - 360/6, 360/6 do
                        local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, (Vector(10,0)):Rotated(i + rng):Resized(10))
                        for j = -7, 7, 7 do
                            if j ~= 0 then
                                local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, (Vector(10,0)):Rotated(j + i + rng):Resized(8))
                                proj.Scale = 0.5
                            end
                        end
                    end
                end
            elseif data.State == 3 then
            if spr:IsFinished("LandHigh") then 
                    data.State = 1
                elseif spr:IsFinished("JumpHigh") then 
                    spr:Play("LandHigh", true)
                elseif spr:IsPlaying("LandHigh") then
                    if spr:IsEventTriggered("Stomp") then
                        ent.Velocity = Vector.Zero
                        InutilLib.SFX:Play(SoundEffect.SOUND_FORESTBOSS_STOMPS, 1, 0, false, 0.8)
                        InutilLib.game:ShakeScreen(5)
                        Isaac.Spawn(EntityType.ENTITY_EFFECT, 16, 3, ent.Position, Vector.Zero, ent)
                        Isaac.Spawn(EntityType.ENTITY_EFFECT, 16, 4, ent.Position, Vector.Zero, ent)

                        for i = 0, 360 - 360/12, 360/12 do
                            local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, (Vector(10,0)):Rotated(i):Resized(6))
                            for j = -5, 5, 5 do
                                if j ~= 0 then
                                    local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, (Vector(10,0)):Rotated(j + i):Resized(5))
                                    proj.Scale = 0.5
                                end
                            end
                        end
                        ent.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
                    end
                elseif spr:IsPlaying("JumpHigh") then
                    if spr:WasEventTriggered("Stomp") and spr:GetFrame() < 25 then
                        if player then
                            if ent.Position:Distance(player.Position) <= 200 then
                                ent.Velocity = (player.Position - ent.Position) / 8
                            else
                                InutilLib.MoveDirectlyTowardsTarget(ent, player, math.random(10,13), 0.9)
                            end
                        end
                        ent.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                    end
                elseif not InutilLib.IsPlayingMultiple(spr, "JumpHigh", "LandHigh") then
                    spr:Play("JumpHigh", true)
                end
            elseif data.State == 4 then
                if spr:IsFinished("Pee") then
                    data.State = 1
                elseif not spr:IsPlaying("Pee") then
                    spr:Play("Pee", true)
                elseif spr:IsEventTriggered("Stomp") then
                    InutilLib.SFX:Play(SoundEffect.SOUND_PLOP, 1, 0, false, 0.8)
                    InutilLib.game:ShakeScreen(5)
                    Isaac.Spawn(EntityType.ENTITY_EFFECT, 16, 3, ent.Position, Vector.Zero, ent)
                    Isaac.Spawn(EntityType.ENTITY_EFFECT, 16, 4, ent.Position, Vector.Zero, ent)
                    local rng = math.random(2)
                    if rng == 1 then
                        local count = 0
                        for i = 0, 360 - 360/6, 360/6 do
                            InutilLib.SetTimer( count*3, function()
                                for j = 0, 90, 30 do
                                count = count + 1
                                    local splat = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_RED, 0, ent.Position + (Vector(j, 0):Rotated(i)), Vector(0,0), ent):ToEffect()
                                end
                            end)
                        end
                    --[[elseif rng == 2 then
                        local count = 0
                        data.SavedVector = player.Position - ent.Position
                        for j = 0, 300, 60 do
                            count = count + 1
                            InutilLib.SetTimer( count*15, function()
                                local splat = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_RED, 0, ent.Position + (data.SavedVector):Normalized() * j, Vector(0,0), ent):ToEffect()
                                InutilLib.RevelSetCreepData(splat)
                                InutilLib.RevelUpdateCreepSize(splat, 3, true)
                            end)
                        end]]
                    elseif rng == 2 then
                        local count = 0
                        for j = 0, math.random(3,4) do
                            count = count + 1
                            InutilLib.SetTimer( count*2, function()
                                local splat = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_RED, 0, ent.Position + Vector(math.random(-30,30), math.random(-30,30)), Vector(0,0), ent):ToEffect()
                                InutilLib.RevelSetCreepData(splat)
                                InutilLib.RevelUpdateCreepSize(splat, math.random(5,8), true)
                            end)
                        end
                    end
                    for i = 0, 2+ math.random(3) do
                        local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, (Vector(math.random(-10,10), math.random(-10,10))):Resized(math.random(7,9)))
                        InutilLib.MakeProjectileLob(proj, 1.5, 9+math.random(0,4))
                        proj:AddProjectileFlags(ProjectileFlags.BOUNCE_FLOOR)
                        proj.Scale = math.random(16,27)/10
                    end
                end
            elseif data.State == 5 then
                if spr:IsFinished("Plop") then
                    data.State = 1
                elseif not spr:IsPlaying("Plop") then
                    spr:Play("Plop", true)
                elseif spr:IsEventTriggered("Stomp") then
                    if not data.FirstTimeEyeThingy then
                        spr:ReplaceSpritesheet(0, "gfx/bosses/thriftshop/puff2.png")
                        spr:LoadGraphics()
                        data.FirstTimeEyeThingy = true
                    end
                    InutilLib.SFX:Play(SoundEffect.SOUND_PLOP, 1, 0, false, 0.8)
                    InutilLib.game:ShakeScreen(5)
                    Isaac.Spawn(EntityType.ENTITY_EFFECT, 16, 3, ent.Position, Vector.Zero, ent)
                    Isaac.Spawn(EntityType.ENTITY_EFFECT, 16, 4, ent.Position, Vector.Zero, ent)
                    --for i = 0, 1 do
                    Isaac.Spawn(ent.Type, ent.Variant, 1, ent.Position, Vector(math.random(-15, 15), math.random(-15, 15)), ent)
                    --end
                end
            elseif data.State == 6 then
                if spr:IsFinished("Hide") then
                    data.State = 7
                elseif not spr:IsPlaying("Hide") then
                    spr:Play("Hide", true)
                elseif spr:IsEventTriggered("Stomp") then
                    InutilLib.SFX:Play(SoundEffect.SOUND_PLOP, 1, 0, false, 0.8)
                end
            elseif data.State == 7 then
                if not data.Count then data.Count = 0 end
                if data.Count > 8 then
                    data.State = 8
                    data.Count = 0
                    data.HasBrimstone = false
                elseif not spr:IsPlaying("IdleHide") then
                    spr:Play("IdleHide", true)
                end
                if data.HasBrimstone then
                    InutilLib.MoveDiagonalTypeI(ent, 5, false, true)
                end
                --[[if ent.FrameCount % 7 == 0 then
                    if data.HasBrimstone then
                        if not data.SpinCount then data.SpinCount = 0 end
                        data.SpinCount = data.SpinCount + 1
                        for i = 0, 360-360/2, 360/2 do
                            local beam = EntityLaser.ShootAngle(1, ent.Position, i+data.SpinCount*30, 10, Vector(0,-50), ent):ToLaser();
                            --beam = EntityLaser.ShootAngle(1, eff.Position, angle, 5, Vector(0,-5), player):ToLaser()
                            beam.Position = ent.Position + Vector(20,10)
                            --beam:AddTearFlags(player.TearFlags)
                            beam.Timeout = 20
                            beam.MaxDistance = 200
                        end
                    end
                end]]
                if math.random(1,3) == 3 and ent.FrameCount % 5 == 0 then
                    data.Count = data.Count + 1
                    if not data.HasBrimstone then
                        ent.Velocity = ent.Velocity + (InutilLib.room:GetCenterPos()-ent.Position):Rotated(math.random(-30,30)):Resized(3)
                    end
                    local rng = math.random(5)
                    if rng == 1 then
                        local rng = math.random(-45,45)
                        for i = 0, 360 - 360/6, 360/6 do
                            local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, (Vector(10,0)):Rotated(i + rng):Resized(10))
                            for j = -7, 7, 7 do
                                if j ~= 0 then
                                    local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, (Vector(10,0)):Rotated(j + i + rng):Resized(8))
                                    proj.Scale = 0.5
                                end
                            end
                        end
                    elseif rng == 2 then
                        InutilLib.game:ShakeScreen(5)
                        Isaac.Spawn(EntityType.ENTITY_EFFECT, 16, 3, ent.Position, Vector.Zero, ent)
                        Isaac.Spawn(EntityType.ENTITY_EFFECT, 16, 4, ent.Position, Vector.Zero, ent)

                        for i = 0, 360 - 360/12, 360/12 do
                            local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, (Vector(10,0)):Rotated(i):Resized(6))
                            for j = -5, 5, 5 do
                                if j ~= 0 then
                                    local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, (Vector(10,0)):Rotated(j + i):Resized(5))
                                    proj.Scale = 0.5
                                end
                            end
                        end
                    elseif rng == 3 then
                        local rng = math.random(-45,45)
                        for i = 0, 360 - 360/8, 360/8 do
                            local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, (Vector(10,0)):Rotated(i + rng):Resized(12))
                            proj.Scale = 1.6
                        end
                    elseif rng == 4 then
                        local rng = math.random(-45,45)
                        for i = 0, 360 - 360/12, 360/12 do
                            local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, (Vector(10,0)):Rotated(i + rng):Resized(12))
                            proj.Scale = 0.8
                            proj:AddProjectileFlags(ProjectileFlags.CURVE_LEFT)
                        end
                    elseif rng == 5 then
                        local rng = math.random(-45,45)
                        for i = 0, 360 - 360/12, 360/12 do
                            local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, (Vector(10,0)):Rotated(i + rng):Resized(12))
                            proj.Scale = 0.8
                            proj:AddProjectileFlags(ProjectileFlags.CURVE_RIGHT)
                        end
                    end
                end
            elseif data.State == 8 then
                if spr:IsFinished("Unhide") then
                    data.State = 1
                elseif not spr:IsPlaying("Unhide") then
                    spr:Play("Unhide", true)
                elseif spr:IsEventTriggered("Stomp") then
                    InutilLib.SFX:Play(SoundEffect.SOUND_PLOP, 1, 0, false, 0.8)
                end
            elseif data.State == 9 then
                if spr:IsFinished("Cry") then
                    data.State = 1
                    data.IsSides = false
                    data.BloatCooldown = 120
                elseif not spr:IsPlaying("Cry") then
                    spr:Play("Cry", true)
                elseif spr:IsEventTriggered("Stomp") then
                    if data.IsSides then
                        local beam = EntityLaser.ShootAngle(1, ent.Position, 180, 10, Vector(0,-50), ent):ToLaser();
						--beam = EntityLaser.ShootAngle(1, eff.Position, angle, 5, Vector(0,-5), player):ToLaser()
						beam.Position = ent.Position + Vector(-20,10)
						--beam:AddTearFlags(player.TearFlags)
						beam.Timeout = 20
                        beam.DisableFollowParent = true
                        beam.RenderZOffset = 1000
                        local beam2 = EntityLaser.ShootAngle(1, ent.Position, 0, 10, Vector(0,-50), ent):ToLaser();
						--beam = EntityLaser.ShootAngle(1, eff.Position, angle, 5, Vector(0,-5), player):ToLaser()
						beam2.Position = ent.Position + Vector(20,10)
						--beam:AddTearFlags(player.TearFlags)
						beam2.Timeout = 20
                        beam2.DisableFollowParent = true
                        beam2.RenderZOffset = 1000
                    else
                        local beam = EntityLaser.ShootAngle(1, ent.Position, 90, 10, Vector(0,-50), ent):ToLaser();
						--beam = EntityLaser.ShootAngle(1, eff.Position, angle, 5, Vector(0,-5), player):ToLaser()
						beam.Position = ent.Position + Vector(20,10)
						--beam:AddTearFlags(player.TearFlags)
						beam.Timeout = 20
                        beam.DisableFollowParent = true
                        beam.RenderZOffset = 1000
                        local beam2 = EntityLaser.ShootAngle(1, ent.Position, 90, 10, Vector(0,-50), ent):ToLaser();
						--beam = EntityLaser.ShootAngle(1, eff.Position, angle, 5, Vector(0,-5), player):ToLaser()
						beam2.Position = ent.Position + Vector(-20,10)
						--beam:AddTearFlags(player.TearFlags)
						beam2.Timeout = 20
                        beam2.DisableFollowParent = true
                        beam2.RenderZOffset = 1000
                    end
                    InutilLib.SFX:Play(SoundEffect.SOUND_PLOP, 1, 0, false, 0.8)
                end
            end
            ent.Velocity = ent.Velocity * 0.9
        end
    
    end
end, RebekahCurse.Enemies.ENTITY_REBEKAH_ENEMY)

local takeDmg = false

yandereWaifu:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, function(_, ent)
	if ent.Type == RebekahCurse.Enemies.ENTITY_REBEKAH_ENEMY and ent.Variant == RebekahCurse.Enemies.ENTITY_POMPOMS then
        local groupofBuns = Isaac.FindByType(ent.Type, ent.Variant, -1)
        for i, v in pairs(Isaac.FindByType(RebekahCurse.Enemies.ENTITY_REBEKAH_ENEMY, RebekahCurse.Enemies.ENTITY_POMPOMS, -1)) do
            if #groupofBuns > 4 then
                if yandereWaifu.GetEntityData(v).IsTraining then
                    yandereWaifu.GetEntityData(v).IsTraining = false
                    yandereWaifu.GetEntityData(v).IsRunning = 150
                    v:GetSprite():ReplaceSpritesheet(0, "gfx/bosses/thriftshop/pompoms3.png")
                    v:GetSprite():LoadGraphics()
                end
            else
                yandereWaifu.GetEntityData(v).IsTraining = false
                yandereWaifu.GetEntityData(v).IsScatter = true
                yandereWaifu.GetEntityData(v).IsAngry = true
                v:GetSprite():ReplaceSpritesheet(0, "gfx/bosses/thriftshop/pompoms4.png")
                v:GetSprite():LoadGraphics()
            end
        end
    elseif ent.Type == RebekahCurse.Enemies.ENTITY_REBEKAH_ENEMY and ent.Variant == RebekahCurse.Enemies.ENTITY_HOLEDINI then
        for i, v in ipairs (Isaac.FindByType(EntityType.ENTITY_PITFALL, -1, -1)) do
            v:Remove()
        end
    end
end)

yandereWaifu:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, damage, amount, damageFlag, damageSource, damageCountdownFrames) --invincibilityframe when dashing or whatnot
    if not damage or not damage:IsEnemy() then return end
    if damage.Type ~= RebekahCurse.Enemies.ENTITY_REBEKAH_ENEMY and damage.Variant ~= RebekahCurse.Enemies.ENTITY_POMPOMS then return end
    if damage.HitPoints - amount <= 0 and not takeDmg then
        takeDmg = true
    elseif damage.HitPoints - amount <= 0 and takeDmg then
        InutilLib.SetTimer(15, function()
            takeDmg = false
        end)
            
         return false
	end
end)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    takeDmg = false
end)