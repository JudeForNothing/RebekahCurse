local isGore = false

yandereWaifu:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, function(_, proj)
	local data = yandereWaifu.GetEntityData(proj)
	if data.BunnyBullet then
		--print(InutilLib.room:GetGridEntity(InutilLib.room:GetGridIndex((proj.Position +Vector(0,40):Rotated(data.BloodbendAngle - 90)))))
		--proj.Scale = 1.7
		--[[proj.FallingSpeed = (10)*-1;
		proj.FallingAccel = 1;]]
        proj.Height = -24
		if proj.FrameCount % 3 == 0 then
            local proj = InutilLib.FireGenericProjAttack(proj.Parent, 0, 1, proj.Position, proj.Velocity:Rotated(180+math.random(-15,15)):Resized(10))
            if math.random(2) == 2 then
                proj:AddProjectileFlags(ProjectileFlags.MEGA_WIGGLE)
            else
                proj:AddProjectileFlags(ProjectileFlags.WIGGLE)
            end
            proj.Scale = math.random(12,19)/10
        end
    elseif data.FastBunnyBullet then
		--print(InutilLib.room:GetGridEntity(InutilLib.room:GetGridIndex((proj.Position +Vector(0,40):Rotated(data.BloodbendAngle - 90)))))
		--proj.Scale = 1.7
		--[[proj.FallingSpeed = (10)*-1;
		proj.FallingAccel = 1;]]
        proj.Height = -24
    elseif data.SlowBunnyBullet then
		--print(InutilLib.room:GetGridEntity(InutilLib.room:GetGridIndex((proj.Position +Vector(0,40):Rotated(data.BloodbendAngle - 90)))))
		--proj.Scale = 1.7
		--[[proj.FallingSpeed = (10)*-1;
		proj.FallingAccel = 1;]]
        proj.Height = -24
		if proj.FrameCount % 15 == 0 then
            for i = 0, math.random(2) do
                local proj = InutilLib.FireGenericProjAttack(proj.Parent, 0, 1, proj.Position, proj.Velocity:Rotated(180+math.random(0,360)):Resized(10))
                if math.random(2) == 2 then
                    proj:AddProjectileFlags(ProjectileFlags.MEGA_WIGGLE)
                else
                    proj:AddProjectileFlags(ProjectileFlags.WIGGLE)
                end
                proj.Scale = math.random(12,19)/10
            end
        end
	end
end)


local seedtbl = {
    [0] = {seed = SeedEffect.SEED_KAPPA, name = "Kappa", subname = "Kappa", sound = RebekahCurse.Sounds.SOUND_KAPPA},--
    [1] = {seed = SeedEffect.SEED_CAMO_ISAAC, name = "Isaac is now hidden!", subname = "You can't see yourself!", sound = RebekahCurse.Sounds.SOUND_ISAAC_HIDDEN},--
    [2] = {seed = SeedEffect.SEED_CAMO_ENEMIES, name = "Foes are now hidden!", subname = "Rise above hate!", sound = RebekahCurse.Sounds.SOUND_FOES_HIDDEN}, --
    [3] = {seed = SeedEffect.SEED_DYSLEXIA, name = "Dyslexia", subname = "a 0  jA hb a", sound = RebekahCurse.Sounds.SOUND_DYSLEXIA},--
    [4] = {seed = SeedEffect.SEED_OLD_TV, name = "Dogma's Vision", subname = "Who's Steve?", sound = RebekahCurse.Sounds.SOUND_DOGMAS_VISION}, 
    [5] = {seed = SeedEffect.SEED_EXTRA_BLOOD, name = "More Gore!", subname = "Rip your enemies!", sound = RebekahCurse.Sounds.SOUND_MORE_GORE}, --
    --[6] = {seed = SeedEffect.SEED_BIG_HEAD, name = "Megahead!", subname = "A severe lack of female companions?", sound = RebekahCurse.Sounds.SOUND_MEGAHEAD}, 
    --[7] = {seed = SeedEffect.SEED_SMALL_HEAD, name = "Tinyhead", subname = "One brain cell left", sound = RebekahCurse.Sounds.SOUND_TINYHEAD},
    [6] = {seed = SeedEffect.SEED_BLACK_ISAAC, name = "Sillouhette", subname = "Who's that Isaac?", sound = RebekahCurse.Sounds.SOUND_SILLOUHETTE}, --
    [7] = {seed = SeedEffect.SEED_SLOW_MUSIC, name = "Relax!", subname = "Listen and chill", sound = RebekahCurse.Sounds.SOUND_RELAX},--
    [8] = {seed = SeedEffect.SEED_FAST_MUSIC, name = "Rock on!", subname = "Gotta go fast!", sound = RebekahCurse.Sounds.SOUND_ROCK_ON}, --
    [9] = {seed = SeedEffect.SEED_ICE_PHYSICS, name = "Slippery slope", subname = "Careful", sound = RebekahCurse.Sounds.SOUND_SLIPPERY_SLOPE}, --
    [10] = {seed = SeedEffect.SEED_RETRO_VISION, name = "Retro Vision!", subname = "Again??", sound = RebekahCurse.Sounds.SOUND_RETRO_VISION}, --
    [11] = {seed = SeedEffect.SEED_ALL_CHAMPIONS, name = "All stars!", subname = "Everyone is a champion", sound = nil},--
    [12] = {seed = SeedEffect.SEED_G_FUEL, name = "G FUEL!", subname = "Gamer drink", sound = nil},
    [13] = {seed = SeedEffect.SEED_INVINCIBLE, name = "Undefeatable!", subname = "Damage = no damage", sound = nil},--
    [14] = {seed = SeedEffect.SEED_POOP_TRAIL, name = "Poo Poo!", subname = "FARTFARTFARTFART", sound = nil},--
    [15] = {seed = SeedEffect.SEED_ULTRA_SLOW_MUSIC, name = "Relax...", subname = "beats to relax/study to", sound = RebekahCurse.Sounds.SOUND_RELAX2}, --
    [16] = {seed = SeedEffect.SEED_ULTRA_FAST_MUSIC, name = "ROCK ON!!!", subname = "Now listen with 2x", sound = RebekahCurse.Sounds.SOUND_ROCK_ON2}, --
}

local lordJustUsedEggs = false

local function ClearEasterEggs(ent)
    for k, v in ipairs(seedtbl) do
		InutilLib.game:GetSeeds():RemoveSeedEffect(v.seed)
	end
    yandereWaifu.GetEntityData(ent).SlowDownIsaac  = false
    yandereWaifu.GetEntityData(ent).SpeedUpIsaac  = false
    yandereWaifu.GetEntityData(ent).IsSillouhette  = false
    yandereWaifu.GetEntityData(ent).IsPoopTrail  = false
    yandereWaifu.GetEntityData(ent).IsDank  = false
    yandereWaifu.GetEntityData(ent).IsInvincible  = false
    yandereWaifu.GetEntityData(ent).SlowDownMore  = false
    yandereWaifu.GetEntityData(ent).FastUpMore  = false
    yandereWaifu.GetEntityData(ent).IsAllChampions  = false
    yandereWaifu.GetEntityData(ent).IsTV  = false
    isGore = false
    local ents = (Isaac.GetRoomEntities())
    for _, ent in pairs(ents) do
        --if ent:IsEnemy() or player.Type == 1 then
            ent:SetColor(Color(1.5, 1.5, 1.5, 1.0, 50/255, 50/255, 50/255), 1, 1)
        --end
    end

end

local function UseEnemyEasterEgg(ent, num)
    ClearEasterEggs(ent)
    local rng = math.random(0,#seedtbl)
    
    if num then
        rng = num
    end
    if seedtbl[rng].seed == SeedEffect.SEED_BLACK_ISAAC then
        yandereWaifu.GetEntityData(ent).IsSillouhette = true
    elseif seedtbl[rng].seed == SeedEffect.SEED_POOP_TRAIL then
        yandereWaifu.GetEntityData(ent).IsPoopTrail  = true
    elseif seedtbl[rng].seed == SeedEffect.SEED_G_FUEL then
        yandereWaifu.GetEntityData(ent).IsDank  = true
    elseif seedtbl[rng].seed == SeedEffect.SEED_INVINCIBLE then
        yandereWaifu.GetEntityData(ent).IsInvincible  = true
    elseif seedtbl[rng].seed == SeedEffect.SEED_ALL_CHAMPIONS then
        yandereWaifu.GetEntityData(ent).IsAllChampions  = true
    else
        InutilLib.game:GetSeeds():AddSeedEffect(seedtbl[rng].seed)	
    end
    yandereWaifu.GetEntityData(ent).SeedEffectCount = 500
    yandereWaifu.GetEntityData(ent).IsRefreshed = false
	InutilLib.game:GetHUD():ShowItemText(seedtbl[rng].name,seedtbl[rng].subname)

    if seedtbl[rng].seed == SeedEffect.SEED_SLOW_MUSIC or seedtbl[rng].seed == SeedEffect.SEED_ULTRA_SLOW_MUSIC  then
        yandereWaifu.GetEntityData(ent).SlowDownIsaac = true
        if seedtbl[rng].seed == SeedEffect.SEED_ULTRA_SLOW_MUSIC then
            yandereWaifu.GetEntityData(ent).SlowDownMore = true
        end
    end
    if seedtbl[rng].seed == SeedEffect.SEED_FAST_MUSIC or seedtbl[rng].seed == SeedEffect.SEED_ULTRA_FAST_MUSIC  then
        yandereWaifu.GetEntityData(ent).SpeedUpIsaac = true
        if seedtbl[rng].seed == SeedEffect.SEED_ULTRA_FAST_MUSIC then
            yandereWaifu.GetEntityData(ent).FastUpMore = true
        end
    end
    if seedtbl[rng].seed == SeedEffect.SEED_EXTRA_BLOOD then
        isGore = true
    end
    if seedtbl[rng].seed == SeedEffect.SEED_OLD_TV then
        yandereWaifu.GetEntityData(ent).IsTV = true
    end
    lordJustUsedEggs = true
end

yandereWaifu:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(_, new)
	if not new and lordJustUsedEggs then
        local num_players = InutilLib.game:GetNumPlayers()
        for i=0,(num_players-1) do
            local ent = Isaac.GetPlayer(i)
            ClearEasterEggs(ent)
        end
        lordJustUsedEggs = false
    end
        --[[for k, v in ipairs(seedtbl) do
            InutilLib.game:GetSeeds():RemoveSeedEffect(v.seed)
        end
        local OldChallenge = player:CanShoot()
        local playerType = player:GetPlayerType()
        if playerType == PlayerType.PLAYER_THEFORGOTTEN_B then
            local player = player:GetOtherTwin()
            local rng = math.random(0,#seedtbl)
            InutilLib.game:GetSeeds():AddSeedEffect(seedtbl[rng].seed)	
            InutilLib.game:GetHUD():ShowItemText(seedtbl[rng].name,seedtbl[rng].subname)
            ReloadForgottenB(player)
            if math.random(1,2) == 2 and seedtbl[rng].sound then
                InutilLib.SFX:Play( seedtbl[rng].sound, 1, 0, false, 0.9 );
            end
    
            yandereWaifu.GetEntityData(player).PersistentPlayerData.EasterEggSeeds = seedtbl[rng].seed
        else
            player:ChangePlayerType(playerType)
            local rng = math.random(0,#seedtbl)
            InutilLib.game:GetSeeds():AddSeedEffect(seedtbl[rng].seed)	
            InutilLib.game:GetHUD():ShowItemText(seedtbl[rng].name,seedtbl[rng].subname)
            player:ChangePlayerType(playerType)
            if math.random(1,2) == 2 and seedtbl[rng].sound then
                InutilLib.SFX:Play( seedtbl[rng].sound, 1, 0, false, 0.9 );
            end
            
            yandereWaifu.GetEntityData(player).PersistentPlayerData.EasterEggSeeds = seedtbl[rng].seed
            if not OldChallenge then 
                InutilLib.DumpySetCanShoot(player, false)
            end
            if yandereWaifu.IsNormalRebekah(player) or yandereWaifu.IsTaintedRebekah(player) then
                yandereWaifu.RebekahRefreshCostume(player)
            end
        end
        hasAnyEasterEggSeedEffectActive = true
    end]]
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
            lordJustUsedEggs = false
        end

        --easter egg stuff
        if data.IsSillouhette then
            ent:SetColor(Color(0,0,0,1,0,0,0),3,1,false,false)
        end
        
        if data.SlowDownIsaac then
            local ents = (Isaac.GetRoomEntities())
            for _, player in pairs(ents) do
                if player:IsEnemy() or player.Type == 1 then
                    player:AddSlowing(EntityRef(nil), 1, 0.5, Color(1.5, 1.5, 1.5, 1.0, 50/255, 50/255, 50/255))
                end
            end
        end
        if data.SpeedUpIsaac then
            local ents = (Isaac.GetRoomEntities())
            for _, player in pairs(ents) do
                if player:IsEnemy() or player.Type == 1 then
                    player.Velocity = player.Velocity * 1.1
                end
            end
        end

        if data.IsPoopTrail then
            if ent.Velocity:Length() > 1 then
                if ent.FrameCount % 15 == 0 then
                    InutilLib.game:Fart(ent.Position, 100, ent, 1, 0)
                    local rng = math.random(-65,65)
                    for i = 0, 360 - 360/8, 360/8 do
                        local proj = InutilLib.FireGenericProjAttack(ent, 3, 1, ent.Position, (Vector(10,0)):Rotated(i+rng):Resized(math.random(0,3)))
                        proj.Scale = 0.9
						InutilLib.MakeProjectileLob(proj, 1.5, math.random(7,10))
                    end
                end
            end
        end

        if ent.SubType == 0 then --main body
            if data.SeedEffectCount and data.SeedEffectCount > 0 then
                data.SeedEffectCount = data.SeedEffectCount - 1
            elseif data.SeedEffectCount == 0 and not data.IsRefreshed then
                ClearEasterEggs(ent)
                data.IsRefreshed = true
            end
            if not data.SeedEffectCount then
                data.SeedEffectCount = 0
            end
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
                    door:AddEntityFlags(EntityFlag.FLAG_CHARM | EntityFlag.FLAG_FRIENDLY)
                    door:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                    door.RenderZOffset = -100000
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
                if math.random(3) == 3 and ent.FrameCount % 5 == 0 then
                    if math.random(6) == 6 then
                        if math.random(2) == 2 and ent.HitPoints <= (ent.MaxHitPoints / 2) then
                            data.State = 5
                        elseif math.random(2) == 2 then
                            data.State = 2
                        end
                    else
                        local ents = Isaac.FindInRadius(ent.Position, 750, EntityPartition.ENEMY)
                        spr:Play("Idle2", true)
                        if math.random(2) == 2 and #ents <= 6 then
                            data.State = 3
                        --[[else
                            data.State = 5]]
                        elseif math.random(3) == 3 and (data.SeedEffectCount and data.SeedEffectCount <= 0) and ent.HitPoints <= (ent.MaxHitPoints / 3)*2 then
                            data.State = 4
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
                    if data.IsDank then
                        if spr:WasEventTriggered("Shoot") and spr:GetFrame() % 3 == 0 then
                            InutilLib.SFX:Play(SoundEffect.SOUND_GFUEL_GUNSHOT_LARGE, 1, 0, false, 1 );
                            local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, (player.Position - ent.Position):Rotated(-5,5):Resized(15))
                            --proj:AddProjectileFlags(ProjectileFlags.SIDEWAVE)
                            proj.Scale = math.random(15,20)/10
                            ent.Velocity = (ent.Position - player.Position):Resized(13)
                        end
                    else
                        if spr:IsEventTriggered("Shoot") then
                            InutilLib.SFX:Play(SoundEffect.SOUND_GFUEL_GUNSHOT, 1, 0, false, 1 );
                            local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, (player.Position - ent.Position):Resized(12))
                            --proj:AddProjectileFlags(ProjectileFlags.SIDEWAVE)
                            proj.Scale = 2.5
                            if data.SlowDownMore then
                                yandereWaifu.GetEntityData(proj).SlowBunnyBullet = true
                                proj.Velocity = proj.Velocity*0.4
                            elseif data.FastUpMore then
                                yandereWaifu.GetEntityData(proj).FastBunnyBullet = true
                                proj.Velocity = proj.Velocity*1.3
                            else
                                yandereWaifu.GetEntityData(proj).BunnyBullet = true
                            end
                            ent.Velocity = (ent.Position - player.Position):Resized(13)
                                --[[for j = -30, 30, 15 do
                                    local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, (player.Position - ent.Position):Rotated(i+j):Resized(3))
                                    InutilLib.MakeProjectileLob(proj, 1.5, 9)
                                    proj:AddProjectileFlags(ProjectileFlags.BURSTSPLIT)
                                    proj.Scale = 1.5
                                end]]
                        end
                    end
                end
            elseif data.State == 3 then
                ent.Velocity = ent.Velocity * 0.9
                if spr:IsFinished("UseHorse") then 
                    data.State = 1
                elseif not spr:IsPlaying("UseHorse") then 
                    spr:Play("UseHorse", true) 
                elseif spr:IsPlaying("UseHorse") then
                    if ent.FrameCount % 5 == 0 and spr:GetFrame() >= 17 then
                        InutilLib.SFX:Play(SoundEffect.SOUND_SHELLGAME, 1, 0, false, 1 );
                    end
                    if spr:IsEventTriggered("Shoot") then
                        for i, v in pairs (Isaac.FindByType(ent.Type, ent.Variant, 5)) do
                            yandereWaifu.GetEntityData(v).State = 2
                            if data.IsAllChampions then
                                yandereWaifu.GetEntityData(v).IsChampion = true
                            end
                        end
                    end
                end
            elseif data.State == 4 then
                ent.Velocity = ent.Velocity * 0.9
                if spr:IsFinished("UseHorseShort") then 
                    data.State = 1
                elseif not spr:IsPlaying("UseHorseShort") then 
                    spr:Play("UseHorseShort", true) 
                elseif spr:IsPlaying("UseHorseShort") then
                    if ent.FrameCount % 5 == 0 and spr:GetFrame() >= 17 then
                        InutilLib.SFX:Play(SoundEffect.SOUND_SHELLGAME, 1, 0, false, 1 );
                    end
                    if spr:IsEventTriggered("Shoot") then
                        if ent.HitPoints <= (ent.MaxHitPoints / 4) then
                            UseEnemyEasterEgg(ent, math.random(0,16))
                        else
                            UseEnemyEasterEgg(ent,  math.random(0,8))
                        end
                    end
                end
            elseif data.State == 5 then
                ent.Velocity = ent.Velocity * 0.9
                if not data.IsPickedAWall then 
                    spr:Play("Appear", true) 
                    ent.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
                    --ent.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
                    data.wall = InutilLib.ClosestHorizontalWall(ent)
	                data.wallPos = yandereWaifu:GetClosestHorizontalWallPos(data.wall, ent)

                    --[[if data.wall == Direction.LEFT then
                        data.wallPos = data.wallPos + Vector(-80,0)
                    elseif data.wall == Direction.RIGHT then
                        data.wallPos = data.wallPos + Vector(80,0)
                    end]]
                    data.IsPickedAWall = true
                elseif data.IsPickedAWall then
                    ent.Velocity = (data.wallPos - ent.Position):Resized(12)
                    InutilLib.FlipXByVec(ent, false)
                    if data.wallPos:Distance(ent.Position) <= 20 then
                        data.State = 6
                        data.IsPickedAWall = false
                    end
                end
            elseif data.State == 6 then
                ent.Velocity = ent.Velocity * 0.9
                if not data.IsPickedAWall then 
                    local animNum = math.random(1,3)
                    spr:Play("Pass"..tostring(animNum), true) 
                    ent.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
                    --ent.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
                    data.wall = InutilLib.ClosestHorizontalWall(ent)

                    --[[if data.wall == Direction.LEFT then
                        data.wall = Direction.RIGHT
                    elseif data.wall == Direction.RIGHT then
                        data.wall = Direction.LEFT
                    end]]

	                data.wallPos = yandereWaifu:GetClosestHorizontalWallPos(data.wall, ent)
                    local beamColor = Color(1,0,0,1)
                    local angle = 0 

                    if data.wall == Direction.LEFT then
                        data.wallPos = data.wallPos + Vector(-200,0)
                        angle = 0
                    elseif data.wall == Direction.RIGHT then
                        data.wallPos = data.wallPos + Vector(200,0)
                        angle = 180
                    end
                    --local leftWall = math.abs(room:GetTopLeftPos().X-ent.Position.X)
			        --local rightWall = math.abs(room:GetBottomRightPos().X-ent.Position.X)

                    --[[if data.wall == Direction.LEFT then
                        data.wallPos = Vector(rightWall, player.Position.Y)
                    elseif data.wall == Direction.RIGHT then
                        data.wallPos = Vector(leftWall, player.Position.Y)
                    end]]
                    data.IsPickedAWall = true
                    print("go")
                    local pos = Vector(data.wallPos.X, InutilLib.GetExpectedCenterPos(InutilLib.game:GetRoom()).Y) + Vector(0, math.random(-100,100))

				    yandereWaifu.AddGenericTracer(Vector(yandereWaifu:GetClosestHorizontalWallPos(data.wall, ent).X, pos.Y), beamColor, angle, 30)
                    ent.Position = pos

                    --InutilLib.game:Fart( Vector(yandereWaifu:GetClosestHorizontalWallPos(data.wall, ent).X, pos.Y), 100, ent, 1, 0)
                elseif data.IsPickedAWall then
                    local oppositeWall 
                    if data.wall == Direction.LEFT then
                        oppositeWall = Direction.RIGHT
                    elseif data.wall == Direction.RIGHT then
                        oppositeWall = Direction.LEFT
                    end
                    local oppositewallPos = yandereWaifu:GetClosestHorizontalWallPos(oppositeWall, ent)

                    ent.Velocity =(ent.Velocity +  (oppositewallPos - ent.Position):Resized(6)) * 0.9
                    InutilLib.FlipXByVec(ent, false)
                    local centerPos = InutilLib.GetExpectedCenterPos(InutilLib.game:GetRoom())
                    if centerPos.X < ent.Position.X + 40 and centerPos.X > ent.Position.X -40 and not data.ShatFeathers and data.IsTV then
                        local rng = math.random(-65,65)
                        for i = 0, 360 - 360/6, 360/6 do
                            local proj = InutilLib.FireGenericProjAttack(ent, ProjectileVariant.PROJECTILE_WING, 1, ent.Position, (Vector(10,0)):Rotated(i+rng):Resized(7))
                        end
                        data.ShatFeathers = true
                    end
                    --print("GIOOO")
                    if oppositewallPos:Distance(ent.Position) <= 50 then
                        print("PING")
                        if not data.RePeatDashOffscreen then data.RePeatDashOffscreen = 0 end
                        if data.RePeatDashOffscreen < 3 then
                            data.RePeatDashOffscreen = data.RePeatDashOffscreen + 1
                        else
                            data.State = 7
                            data.RePeatDashOffscreen = 0 
                        end
                        data.IsPickedAWall = false
                        data.ShatFeathers = false
                    end
                    if ent.FrameCount % 3 == 0 then
                        yandereWaifu:GuwahMakeAfterimage(ent)
                    end
                    --InutilLib.game:Fart(oppositewallPos, 100, ent, 1, 0)
                end
            elseif data.State == 7 then
                ent.Velocity = ent.Velocity * 0.9
                local centerPos = InutilLib.GetExpectedCenterPos(InutilLib.game:GetRoom())
                if centerPos:Distance(ent.Position) < 20 then
                    data.State = 1
                    ent.GridCollisionClass = GridCollisionClass.COLLISION_SOLID
                else
                    ent.Velocity = (ent.Velocity + (centerPos- ent.Position):Resized(1)) * 0.9
                end
                InutilLib.FlipXByVec(ent, false)
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
                elseif spr:IsPlaying("Open") then
                    local enemyList = yandereWaifu.eastereggenemyList
                    if spr:IsEventTriggered("Shoot") then
                        local rng = math.random(1,#enemyList)
                        local ent = Isaac.Spawn( enemyList[rng].type, enemyList[rng].variant, enemyList[rng].subtype, InutilLib.room:FindFreePickupSpawnPosition(ent.Position, 1), Vector(0,0), nil ):ToNPC();
                        if data.IsChampion == true then
                            ent:MakeChampion(math.random(1,10), -1, false)
                            data.IsChampion = false
                        end
                    end
                end
            end
        end
    end
end, RebekahCurse.Enemies.ENTITY_REBEKAH_ENEMY)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, function(_, ent)
	if isGore then
        local rng = math.random(-65,65)
        if ent.HitPoints >= 20 then
            for i = 0, 360 - 360/6, 360/6 do
                local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, (Vector(10,0)):Rotated(i+rng):Resized(7))
                InutilLib.MakeProjectileLob(proj, 1.5, math.random(7,10))
            end
        elseif ent.HitPoints >= 10 then
            for i = 0, 360 - 360/4, 360/4 do
                local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, (Vector(10,0)):Rotated(i+rng):Resized(7))
                InutilLib.MakeProjectileLob(proj, 1.5, math.random(7,10))
            end
        else
            for i = 0, 360 - 360/3, 360/3 do
                local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, (Vector(10,0)):Rotated(i+rng):Resized(7))
                InutilLib.MakeProjectileLob(proj, 1.5, math.random(7,10))
            end
        end
    end
end)

yandereWaifu:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, damage, amount, damageFlag, damageSource, damageCountdownFrames)
    if damage.Variant == RebekahCurse.Enemies.ENTITY_THEDEMONLORDESS then
        if yandereWaifu.GetEntityData(damage).IsInvincible then
            damage:SetColor(Color(1.5, 1.5, 1.5, 1.0, 50/255, 50/255, 50/255), 2, 1, true)
            InutilLib.SFX:Play(SoundEffect.SOUND_METAL_BLOCKBREAK, 1, 0, false, 1 );
            --local splat = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BISHOP_SHIELD, 0, damage.Position, Vector(0,0), damage) 
            return false
        end
    end
end,  RebekahCurse.Enemies.ENTITY_REBEKAH_ENEMY)

yandereWaifu:AddCallback(ModCallbacks.MC_PRE_NPC_COLLISION, function(_, ent, coll, low)
	local spr = ent:GetSprite()
	local data = yandereWaifu.GetEntityData(ent)
	local player = ent:GetPlayerTarget()
    if ent.Variant == RebekahCurse.Enemies.ENTITY_THEDEMONLORDESS and data.State == 6 and coll:IsEnemy() then
        coll:TakeDamage( 30, 0, EntityRef(ent), 0);
	end

end, RebekahCurse.Enemies.ENTITY_REBEKAH_ENEMY)