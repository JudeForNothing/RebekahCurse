local juggleTable = {
    [1] = {
        [0] = {height = -80, position = Vector(30,0)},
        [1] = {height = -75, position = Vector(30,0)},
        [2] = {height = -60, position = Vector(30,0)},
        [3] = {height = -60, position = Vector(30,0)},
        [4] = {height = -85, position = Vector(20,0)},
        [5] = {height = -95, position = Vector(10,0)},
        [6] = {height = -95, position = Vector(0,0)},
        [7] = {height = -85, position = Vector(-10,0)},
        [8] = {height = -80, position = Vector(-20,0)},
        [9] = {height = -75, position = Vector(-30,0)},
        [10] = {height = -80, position = Vector(-30,0)},
        [11] = {height = -60, position = Vector(-30,0)},
        [12] = {height = -85, position = Vector(-20,0)},
        [13] = {height = -95, position = Vector(-10,0)},
    },
    [2] = {
        [0] = {height = -80, position = Vector(-30,0)},
        [1] = {height = -75, position = Vector(-30,0)},
        [2] = {height = -60, position = Vector(-30,0)},
        [3] = {height = -60, position = Vector(-30,0)},
        [4] = {height = -85, position = Vector(-20,0)},
        [5] = {height = -90, position = Vector(-10,0)},
        [6] = {height = -90, position = Vector(0,0)},
        [7] = {height = -85, position = Vector(10,0)},
        [8] = {height = -80, position = Vector(20,0)},
        [9] = {height = -75, position = Vector(30,0)},
        [10] = {height = -80, position = Vector(30,0)},
        [11] = {height = -60, position = Vector(30,0)},
        [12] = {height = -85, position = Vector(20,0)},
        [13] = {height = -90, position = Vector(10,0)},
    },
    [3] = {
        [0] = {height = -60, position = Vector(30,0)},
        [1] = {height = -60, position = Vector(30,0)},
        [2] = {height = -105, position = Vector(20,0)},
        [3] = {height = -125, position = Vector(10,0)},
        [4] = {height = -125, position = Vector(0,0)},
        [5] = {height = -105, position = Vector(-10,0)},
        [6] = {height = -80, position = Vector(-20,0)},
        [7] = {height = -75, position = Vector(-30,0)},
        [8] = {height = -80, position = Vector(-30,0)},
        [9] = {height = -60, position = Vector(-30,0)},
        [10] = {height = -105, position = Vector(-20,0)},
        [11] = {height = -125, position = Vector(-10,0)},
        [12] = {height = -80, position = Vector(30,0)},
        [13] = {height = -75, position = Vector(30,0)},
    },
}

function yandereWaifu.SpawnRockSomewhere(pos)
    Isaac.GridSpawn(GridEntityType.GRID_ROCK, 0, pos, true)
    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BIG_SPLASH, 0, pos, Vector(0,0), nil)
end

--giant rock projectile
yandereWaifu:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, function(_, proj)
	local data = yandereWaifu.GetEntityData(proj)
    local spr = proj:GetSprite()
	if proj.FrameCount == 1 then
        if proj.SubType == 1 then
            spr:ReplaceSpritesheet(0, "gfx/effects/giant_bucket.png");
            spr:LoadGraphics();
        end
        spr:Play("Break", true)
	end
end, RebekahCurse.Enemies.ENTITY_GIANTGRIDPROJECTILE)

function yandereWaifu.BreakAllGridsInRoom()
    local grids = InutilLib.GetRoomGrids()
    for i, v in pairs(grids) do
        if v ~= nil and v:ToRock() then
            InutilLib.SetTimer( i*2, function()
                if v ~= nil and v:ToRock() and v.State ~= 2 and v.State ~= 1000 then
                    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BIG_SPLASH, 0, v.Position + Vector(10,10), Vector(0,0), nil)
                    v:Destroy()
                end
            end)
        end
    end
end

yandereWaifu:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, function(_, proj)
    if proj.Variant == RebekahCurse.Enemies.ENTITY_GIANTGRIDPROJECTILE then
        proj = proj:ToProjectile()
        InutilLib.SFX:Play(SoundEffect.SOUND_ROCK_CRUMBLE, 1.5, proj.SubType, false, 0.6);
        InutilLib.game:ShakeScreen(5)
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BIG_SPLASH, 0, proj.Position, Vector(0,0), nil)
        Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.Enemies.ENTITY_GIANTGRIDBREAK, proj.Variant, proj.Position, Vector(0,0), proj)
        if proj.SubType == 1 then
            for i = 0, math.random(0,1) do
                local polty = Isaac.Spawn(EntityType.ENTITY_POLTY, 0, 0, proj.Position, Vector(0,0), proj):ToNPC()
                polty:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
            end
            InutilLib.SFX:Play(SoundEffect.SOUND_METAL_BLOCKBREAK, 1.5, proj.SubType, false, 1.2);
            if InutilLib.GetRoomGridCount() < 9 then
                for i = 0, math.random(1,2) do
                    InutilLib.SetTimer( i*15, function() --InutilLib.room:FindFreePickupSpawnPosition(Isaac.GetRandomPosition(), 3, true, false)
                        yandereWaifu.SpawnRockSomewhere(InutilLib.room:FindFreeTilePosition (Isaac.GetRandomPosition(), 5))
                        InutilLib.game:ShakeScreen(5)
                        InutilLib.SFX:Play(SoundEffect.SOUND_ROCK_CRUMBLE, 1.5, proj.SubType, false, 0.6);
                    end)
                end
            end
        else
            if InutilLib.GetRoomGridCount() < 9 then
                for i = 0, math.random(8,12) do
                    InutilLib.SetTimer( i*20, function() --InutilLib.room:FindFreePickupSpawnPosition(Isaac.GetRandomPosition(), 3, true, false)
                        yandereWaifu.SpawnRockSomewhere(InutilLib.room:FindFreeTilePosition (Isaac.GetRandomPosition(), 5))
                        InutilLib.game:ShakeScreen(5)
                        InutilLib.SFX:Play(SoundEffect.SOUND_ROCK_CRUMBLE, 1.5, proj.SubType, false, 0.6);
                    end)
                end
            end
        end
        --water splash tears
        for i = 0, math.random(18,28) do
            InutilLib.SetTimer( i*2, function() --InutilLib.room:FindFreePickupSpawnPosition(Isaac.GetRandomPosition(), 3, true, false)
                local proj = InutilLib.FireGenericProjAttack(proj, ProjectileVariant.PROJECTILE_TEAR, 1, proj.Position, ((Vector(0,10))):Rotated(math.random(1,360)):Resized(4))
                proj.FallingSpeed = (36)*-1;
                proj.FallingAccel = 1;
                proj.Height = -50
                proj.Scale = math.random(8,15)/10
            end)
        end
    end
end, 9)


yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local sprite = eff:GetSprite()
	local data = yandereWaifu.GetEntityData(eff)
	local player = data.Parent
    if sprite:IsFinished("Break") then
        eff:Remove()
    elseif not sprite:IsPlaying("Break") then
        if proj.SubType == 1 then
            spr:ReplaceSpritesheet(0, "gfx/effects/giant_bucket_break.png");
            spr:LoadGraphics();
        end
        sprite:Play("Break", true)
    end
end, RebekahCurse.Enemies.ENTITY_GIANTGRIDBREAK);

yandereWaifu:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, ent)
	local spr = ent:GetSprite()
	local data = yandereWaifu.GetEntityData(ent)
	local player = ent:GetPlayerTarget()
	local room = InutilLib.room
	local invert = true
	if data.path == nil then data.path = ent.Pathfinder end
	if ent.Variant == RebekahCurse.Enemies.ENTITY_POLTYGEIST then
		if not data.State then
			spr:Play("Spawn", true)
            ent:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
            --ent.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
            ent.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
            ent.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
			data.State = 0
            ent.Position = ent.Position + Vector(230,0)
            InutilLib.SFX:Play(RebekahCurse.Sounds.SOUND_POLTYGEIST_TAUNT, 1, 0, false, 1);
		else
            if data.State == 0 then
                if spr:GetFrame() < 15 then
                    ent:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
		        	ent:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
                    ent.Velocity = (InutilLib.room:GetCenterPos() - ent.Position):Resized(20)
                else
                    ent.Velocity = ent.Velocity * 0.8
                end
                if spr:IsFinished("Spawn") then
					data.State = 1
                    ent.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
                end
            elseif data.State == 1 then
                if ent.FrameCount % 15 == 0 and math.random(1,4) == 4 then
                    if math.random(1,3) == 3 and ent.HitPoints < ent.MaxHitPoints/2 then
                        data.State = 4
                    else
                        if ent.Position.Y < player.Position.Y and math.random(1,3) == 3 then
                            data.State = 3
                        else
                            local grid = InutilLib.GetClosestGrid(ent, 3000, GridEntityType.GRID_ROCK)
                            if grid and math.random(1,3) == 3 then
                                data.State = 8
                            else
                                data.State = 2
                            end
                        end
                    end
				elseif not spr:IsPlaying("Idle") then
					spr:Play("Idle", true)
                else
                    --if ent.FrameCount % 30 == 0 then
                    InutilLib.MoveRandomlyTypeI(ent, InutilLib.room:GetCenterPos(), 2, 0.7, 85)
                    --end
                    --ent.Velocity = ent.Velocity * 0.9
				end
            elseif data.State == 2 then
                if spr:IsFinished("Shoot") then
					data.State = 1
				elseif not spr:IsPlaying("Shoot") then
					spr:Play("Shoot", true)
                else
                    ent.Velocity = ent.Velocity * 0.9
                    if spr:GetFrame() == 30 --[[and spr:GetFrame() % 5 == 0]] then
                        --if spr:GetFrame() == 30 then
                            InutilLib.SFX:Play(RebekahCurse.Sounds.SOUND_POLTYGEIST_SPIT, 1, 0, false, 1);
                        --end
                        for int = 0, math.random(10,14) do
                           -- InutilLib.SetTimer( int*8, function()
                                --for i = -40, 40, 20 do
                               -- for i = -40, 40, 40 do
                                    local proj = InutilLib.FireGenericProjAttack(ent, 4, 1, ent.Position, ((player.Position - ent.Position):Rotated(math.random(-15,15))):Resized(math.random(4,16)))
                                    proj.Scale = math.random(11,14)/10
                                    proj.Height = -56
                                    proj.FallingSpeed = 3
                                    proj:AddProjectileFlags(ProjectileFlags.GHOST)
                                    InutilLib.MakeProjectileLob(proj, 1.5, math.random(6,10))
                                    --proj.Color = Color(1,1,1,1,0,0,0)
                                    --proj:SetColor(Color(1,1,1,1,0,0,0), 9999999, 100, false, false)
                                    proj.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
                               -- end
                           -- end)
                        end
                    end
				end
            elseif data.State == 3 then
                if spr:IsFinished("Flip") then
					data.State = 1
				elseif not spr:IsPlaying("Flip") then
					spr:Play("Flip", true)
                    --ent.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                else
                    if spr:GetFrame() < 55 then
                        ent.Velocity = (ent.Velocity * 0.01) + ((((player.Position+Vector(0,-150))+player.Velocity) - ent.Position)*0.1)
                    else
                        ent.Velocity = ent.Velocity * 0.8
                        --ent.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
                    end
                    if spr:GetFrame() == 77 then
                        local tongue = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.Enemies.ENTITY_POLTY_TONGUE, 0, ent.Position, Vector(0,0), ent)
                        yandereWaifu.GetEntityData(tongue).PermanentAngle = 90
                        yandereWaifu.GetEntityData(tongue).Parent = ent
                        tongue.RenderZOffset = 100
                        InutilLib.SFX:Play(RebekahCurse.Sounds.SOUND_POLTYGEIST_TONGUE, 1, 0, false, 1);
                        for i = -40, 40, 20 do
                            if i ~= 0 then
                                local proj = InutilLib.FireGenericProjAttack(ent, 4, 1, ent.Position, ((Vector(0,10)):Rotated(i)):Resized(9))
                                proj.Scale = 1.1
                                --proj:AddProjectileFlags(ProjectileFlags.GHOST)
                                --proj.Color = Color(1,1,1,1,0,0,0)
                                --proj:SetColor(Color(1,1,1,1,0,0,0), 9999999, 100, false, false)
                                proj.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
                            end
                        end
                    end
				end
            elseif data.State == 4 then
                if spr:IsFinished("Leave") then
					data.State = 5
				elseif not spr:IsPlaying("Leave") then
					spr:Play("Leave", true)
                    InutilLib.SFX:Play(RebekahCurse.Sounds.SOUND_POLTYGEIST_TAUNT, 1, 0, false, 1);
                else
                    if spr:GetFrame() > 10 then
                        ent.Velocity = (ent.Velocity - Vector(10,0)):Resized(22) * 0.9
                        ent.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
                    else
                        ent.Velocity = ent.Velocity * 0.8
                    end
				end
            elseif data.State == 5 then
                if spr:IsFinished("Comeback") then
					data.State = 6
				elseif not spr:IsPlaying("Comeback") then
					spr:Play("Comeback", true)
                    if InutilLib.GetRoomGridCount() >= 9 then data.IsBucketHolding = true end
                    if data.IsBucketHolding then
                        spr:ReplaceSpritesheet(2, "gfx/effects/giant_bucket.png");
                        spr:LoadGraphics();
                    else
                        spr:ReplaceSpritesheet(2, "gfx/effects/giant_rock.png");
                        spr:LoadGraphics();
                    end
                    --rightwall teleport
                    ent.Position = Vector(math.abs(InutilLib.room:GetBottomRightPos().X--[[-ent.Position.X]]),InutilLib.room:GetCenterPos().Y) + Vector(0,10)
                else
                    if spr:GetFrame() < 12 then
                        ent.Velocity = (ent.Velocity - Vector(10,0)):Resized(6) * 0.9
                        ent.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
                    else
                        ent.Velocity = ent.Velocity * 0.8
                    end
				end
            elseif data.State == 6 then --idle with a rock
                if ent.FrameCount % 15 == 0 and math.random(1,3) == 3 or player.Position:Distance(ent.Position) < 150 then
					data.State = 7
				elseif not spr:IsPlaying("IdleRock") then
					spr:Play("IdleRock", true)
                else
                    InutilLib.MoveRandomlyTypeI(ent, InutilLib.room:GetCenterPos(), 3, 0.9, 30, 5, 15)
				end
            elseif data.State == 7 then --throwing a rock
                if spr:IsFinished("Toss") then
                    if not data.IsBucketHolding then 
                        data.IsBucketHolding = true
                    elseif data.IsBucketHolding then
                        data.IsBucketHolding = nil 
                    end
					data.State = 1
				elseif not spr:IsPlaying("Toss") then
					spr:Play("Toss", true)
                    InutilLib.SFX:Play(RebekahCurse.Sounds.SOUND_POLTYGEIST_THROW, 1, 0, false, 1);
                else
                    if spr:GetFrame() == 20 then
                        local sub = 0
                        if data.IsBucketHolding then sub = 1 end
                        local proj = InutilLib.FireGenericProjAttack(ent, RebekahCurse.Enemies.ENTITY_GIANTGRIDPROJECTILE, sub, ent.Position, ((player.Position - ent.Position)):Resized(6))
                        proj.FallingSpeed = (24)*-1;
                        proj.FallingAccel = 1;
                        proj.Height = -50
                    elseif spr:GetFrame() == 35 then
                        InutilLib.SFX:Play(RebekahCurse.Sounds.SOUND_POLTYGEIST_TAUNTY, 1, 0, false, 1);
                    else
                        ent.Velocity = ent.Velocity * 0.8
                    end
				end
            elseif data.State == 8 then
                if not spr:IsPlaying("Idle") and not spr:IsPlaying("JuggleLoop") then
					spr:Play("Idle", true)
                else
                    --if ent.FrameCount % 30 == 0 then
                    local grid = InutilLib.GetClosestGrid(ent, 3000, GridEntityType.GRID_ROCK)
                    if grid and ( not data.JugglingGrids or (data.JugglingGrids and #data.JugglingGrids < 3)) then
                        InutilLib.MoveDirectlyTowardsTarget(ent, grid, 1, 0.9)
                        local closestGrid = InutilLib.GetClosestGrid(ent, 60, GridEntityType.GRID_ROCK)
                        if closestGrid then
                            if not spr:IsPlaying("JuggleLoop") then
                                spr:Play("JuggleLoop", true)
                            end

                              -- spawn projectile
                            --got the code idea from caves and creatures, thanks for the permission!
                            local p = Isaac.Spawn(
                                EntityType.ENTITY_PROJECTILE,
                                ProjectileVariant.PROJECTILE_ROCK,
                                0,
                                ent.Position,
                                Vector.Zero,
                                ent
                            ):ToProjectile()
                            p.Height = -90
                            p.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE

                            --? maybe it's needed?
                            --p:AddProjectileFlags(ProjectileFlags.GHOST)

                            if not data.JugglingGrids then data.JugglingGrids = {} end
                            table.insert(data.JugglingGrids, p)

                            ---@type Sprite
                            local rockSprite = closestGrid:GetSprite()
                            p:GetSprite():Load(rockSprite:GetFilename(), true)
                            local anim = rockSprite:GetAnimation()
                            local frame = rockSprite:GetFrame()
                            if anim == "big" then
                                anim = "normal"
                                frame = math.random(0,2)
                            end
                            if FiendFolio then
                                p:GetSprite():ReplaceSpritesheet(0, "gfx/grid/rocks_downpour_entrance.png")
                            else
                                p:GetSprite():ReplaceSpritesheet(0, "gfx/grid/rocks_downpour.png")
                            end
                            p:GetSprite():LoadGraphics()
                            p:GetSprite():SetFrame(anim, frame)
                            --p.FallingAccel = 0
                            --p.FallingSpeed = 0
                            closestGrid:Destroy()
                        end
                    else
                        if data.JugglingGrids and #data.JugglingGrids > 0 then
                            data.State = 9
                            InutilLib.SFX:Play(RebekahCurse.Sounds.SOUND_POLTYGEIST_TAUNT, 1, 0, false, 1);
                        else
                            data.State = 1
                        end
                    end
                    --end
                    --ent.Velocity = ent.Velocity * 0.9
				end
            elseif data.State == 9 then
                if data.JugglingGrids and #data.JugglingGrids <= 0 then
                    data.State = 1
                elseif spr:GetFrame() == 4 or spr:GetFrame() == 12 then
                    InutilLib.SFX:Play( SoundEffect.SOUND_SHELLGAME, 1, 0, false, 1.1 );
                elseif math.random(1,3) == 3 and spr:GetFrame() == 11 and InutilLib.room:CheckLine(ent.Position, player.Position, 0, 900, false, false) then
                    local rng = math.random(1,#data.JugglingGrids)
                    data.JugglingGrids[rng].Velocity = (player.Position - data.JugglingGrids[rng].Position):Resized(18)
                    data.JugglingGrids[rng].Height = -35
                    --data.JugglingGrids[rng].GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
                    table.remove(data.JugglingGrids, rng)
                    InutilLib.SFX:Play( SoundEffect.SOUND_SHELLGAME, 1, 0, false, 0.9 );
                end
                InutilLib.MoveRandomlyTypeI(ent, InutilLib.room:GetCenterPos(), 2, 0.7, 85)
                ent.Velocity = ent.Velocity * 0.9
            elseif data.State == 10 then
                if ent.FrameCount % 60 == 0 then
                    local tongue = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.Enemies.ENTITY_POLTY_TONGUE, 0, ent.Position, Vector(0,0), ent)
                    yandereWaifu.GetEntityData(tongue).PermanentAngle = 90
                    yandereWaifu.GetEntityData(tongue).Parent = ent
                end
            end
            if data.JugglingGrids then
                for i = 1, 3 do
                    if data.JugglingGrids[i] and not data.JugglingGrids[i]:IsDead() then
                        data.JugglingGrids[i].RenderZOffset = 100000
                        data.JugglingGrids[i].Height = juggleTable[i][spr:GetFrame()].height
                        data.JugglingGrids[i].Position = ent.Position - juggleTable[i][spr:GetFrame()].position
                    end
                end
            end
        end
	end
end, RebekahCurse.Enemies.ENTITY_REBEKAH_ENEMY)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, function(_, ent)
	local spr = ent:GetSprite()
	local data = yandereWaifu.GetEntityData(ent)
	local player = ent:GetPlayerTarget()
	if ent.Variant == RebekahCurse.Enemies.ENTITY_POLTYGEIST and ent.SubType == 0 then
		if spr:IsPlaying("Death") and spr:GetFrame() == 1 then
			InutilLib.SFX:Play( RebekahCurse.Sounds.SOUND_POLTYGEIST_DEATH, 1, 0, false, 1);
		end
	end
end,RebekahCurse.Enemies.ENTITY_REBEKAH_ENEMY)


yandereWaifu:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, function(_, ent)
    if ent.Variant == RebekahCurse.Enemies.ENTITY_POLTYGEIST then
        yandereWaifu.BreakAllGridsInRoom()
    end
end, RebekahCurse.Enemies.ENTITY_REBEKAH_ENEMY)


yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local sprite = eff:GetSprite()
	local data = yandereWaifu.GetEntityData(eff)
	local parent = data.Parent
	eff.GridCollisionClass =  EntityGridCollisionClass.GRIDCOLL_NOPITS 
	
	local room =  Game():GetRoom()
	
	--function code
	if eff.FrameCount == 1 then
		sprite:Play("AttackHori", true)
	end
	if sprite:IsFinished("AttackHori") then
		eff:Remove()
	end 
	
	eff.Position = parent.Position
	eff.Velocity = parent.Velocity
	
	--close hitbox
	if sprite:GetFrame() >= 4 and sprite:GetFrame() <= 6 then
		for i, ent in pairs (Isaac.GetRoomEntities()) do
			if (ent.Type == 1) then
				if InutilLib.CuccoLaserCollision(eff, data.PermanentAngle, 240, ent, 20) then
				--if ent.Position:Distance((eff.Position)+ (Vector(50,0):Rotated(data.PermanentAngle))) <= 90 then
					ent:TakeDamage(1, 0, EntityRef(eff), 1)
				end
			end
		end
	end
			--parent.Velocity = Vector(0,0)
		--end
	if sprite:GetFrame() == 3 then
		InutilLib.SFX:Play(SoundEffect.SOUND_WHIP_HIT, 1, 0, false, 0.8);
	end
	--[[	local grid = room:GetGridEntity(room:GetGridIndex((eff.Position)+ (Vector(50,0):Rotated(data.PermanentAngle)))) --grids around that Rebecca stepped on
		if grid ~= nil then 
			--print( grid:GetType())
			if grid:GetType() == GridEntityType.GRID_TNT or grid:GetType() == GridEntityType.GRID_POOP then
				grid:Destroy()
			end
		end
	end]]
	eff:GetSprite().Rotation = data.PermanentAngle
end, RebekahCurse.Enemies.ENTITY_POLTY_TONGUE)

yandereWaifu:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, damage, amount, damageFlag, damageSource, damageCountdownFrames) 
    if damage.Variant == RebekahCurse.Enemies.ENTITY_POLTYGEIST and (damageFlag & DamageFlag.DAMAGE_EXPLOSION) > 0 then
        if not yandereWaifu.ACHIEVEMENT.OH_IM_DIE:IsUnlocked() and amount >= damage.HitPoints then
            yandereWaifu.ACHIEVEMENT.OH_IM_DIE:Unlock()
        end
    end
end, RebekahCurse.Enemies.ENTITY_REBEKAH_ENEMY)

if StageAPI and StageAPI.Loaded then	
	yandereWaifu.PoltygeistStageAPIRooms = {
		StageAPI.AddBossData("Poltygeist", {
			Name = "Poltygeist",
			Portrait = "gfx/ui/boss/portrait_poltygeist.png",
			Offset = Vector(0,-15),
			Bossname = "gfx/ui/boss/name_poltygeist.png",
			Weight = 1,
			Rooms = StageAPI.RoomsList("Poltygeist Rooms", require("resources.luarooms.bosses.poltygeist")),
			Entity =  {Type = RebekahCurse.Enemies.ENTITY_REBEKAH_ENEMY, Variant = RebekahCurse.Enemies.ENTITY_POLTYGEIST},
		})
	}

	StageAPI.AddBossToBaseFloorPool({BossID = "Poltygeist"},LevelStage.STAGE1_1,StageType.STAGETYPE_REPENTANCE)
	StageAPI.AddBossToBaseFloorPool({BossID = "Poltygeist"},LevelStage.STAGE1_2,StageType.STAGETYPE_REPENTANCE)
end