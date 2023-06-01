--normal stone
function yandereWaifu:UseNormalRebekahStone(card, player, flags) 
	player:ToPlayer()
	local playerdata = yandereWaifu.GetEntityData(player)
	local rng = math.random(1,10)
	InutilLib.game:GetHUD():ShowItemText("A blessing!","or a birthright, to be accurate")

    if InutilLib.game:GetLevel():GetCurses() > 0 then
        if (InutilLib.level:GetCurses() & LevelCurse.CURSE_OF_DARKNESS ~= 0) then
            Isaac.Spawn( EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, RebekahCurse.Cards.SOUL_REBEKAHDARKNESS, InutilLib.room:FindFreePickupSpawnPosition(player.Position, 1), Vector(0,0), player );
        elseif (InutilLib.level:GetCurses() & LevelCurse.CURSE_OF_LABYRINTH ~= 0) then
            Isaac.Spawn( EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, RebekahCurse.Cards.SOUL_REBEKAHLABYRINTH, InutilLib.room:FindFreePickupSpawnPosition(player.Position, 1), Vector(0,0), player );
        elseif (InutilLib.level:GetCurses() & LevelCurse.CURSE_OF_THE_LOST ~= 0) then
            Isaac.Spawn( EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, RebekahCurse.Cards.SOUL_REBEKAHLOST, InutilLib.room:FindFreePickupSpawnPosition(player.Position, 1), Vector(0,0), player );
        elseif (InutilLib.level:GetCurses() & LevelCurse.CURSE_OF_THE_UNKNOWN ~= 0) then
            Isaac.Spawn( EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, RebekahCurse.Cards.SOUL_REBEKAHUNKNOWN, InutilLib.room:FindFreePickupSpawnPosition(player.Position, 1), Vector(0,0), player );
        elseif (InutilLib.level:GetCurses() & LevelCurse.CURSE_OF_MAZE ~= 0) then
            Isaac.Spawn( EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, RebekahCurse.Cards.SOUL_REBEKAHMAZE, InutilLib.room:FindFreePickupSpawnPosition(player.Position, 1), Vector(0,0), player );
        elseif (InutilLib.level:GetCurses() & LevelCurse.CURSE_OF_BLIND ~= 0) then
            Isaac.Spawn( EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, RebekahCurse.Cards.SOUL_REBEKAHBLIND, InutilLib.room:FindFreePickupSpawnPosition(player.Position, 1), Vector(0,0), player );
        else
            Isaac.Spawn( EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, RebekahCurse.Cards.SOUL_REBEKAHCURSED, InutilLib.room:FindFreePickupSpawnPosition(player.Position, 1), Vector(0,0), player );
        end
        Game():GetLevel():RemoveCurses(LevelCurse.CURSE_OF_DARKNESS | LevelCurse.CURSE_OF_BLIND | LevelCurse.CURSE_OF_DARKNESS | LevelCurse.CURSE_OF_LABYRINTH | LevelCurse.CURSE_OF_THE_LOST | LevelCurse.CURSE_OF_THE_UNKNOWN)
    end

    InutilLib.game:Darken(1, 300)
    InutilLib.SFX:Play(SoundEffect.SOUND_SATAN_GROW, 1, 0, false, 1)

	InutilLib.AddInnateItem(player, CollectibleType.COLLECTIBLE_BIRTHRIGHT)
    if not playerdata.PersistentPlayerData.NumberofNormalRebekahStonesUsed then playerdata.PersistentPlayerData.NumberofNormalRebekahStonesUsed = 0 end
    playerdata.PersistentPlayerData.NumberofNormalRebekahStonesUsed = playerdata.PersistentPlayerData.NumberofNormalRebekahStonesUsed + 1
end

yandereWaifu:AddCallback(ModCallbacks.MC_USE_CARD, yandereWaifu.UseNormalRebekahStone, RebekahCurse.Cards.SOUL_REBEKAHNORMAL);

--cursed stone
function yandereWaifu:UseCursedRebekahStone(card, player, flags) 
	player:ToPlayer()
	local playerdata = yandereWaifu.GetEntityData(player)
	local rng = math.random(1,10)
	InutilLib.game:GetHUD():ShowItemText("Curse of the Cursed","Where enemies now feel the hurt")

    InutilLib.game:Darken(1, 300)
    InutilLib.SFX:Play(SoundEffect.SOUND_SATAN_GROW, 1, 0, false, 1)

    playerdata.PersistentPlayerData.UsedCursedRebekahStone = true
end

yandereWaifu:AddCallback(ModCallbacks.MC_USE_CARD, yandereWaifu.UseCursedRebekahStone, RebekahCurse.Cards.SOUL_REBEKAHCURSED);

--darkness stone
function yandereWaifu:UseDarknessRebekahStone(card, player, flags) 
	player:ToPlayer()
	local playerdata = yandereWaifu.GetEntityData(player)
	local rng = math.random(1,10)
	InutilLib.game:GetHUD():ShowItemText("Curse of the Darkness","Where fear in minds infest")

    InutilLib.game:Darken(1, 300)
    InutilLib.SFX:Play(SoundEffect.SOUND_SATAN_GROW, 1, 0, false, 1)

    if not playerdata.PersistentPlayerData.UsedDarknessRebekahStone then playerdata.PersistentPlayerData.UsedDarknessRebekahStone = 0 end
    playerdata.PersistentPlayerData.UsedDarknessRebekahStone =  playerdata.PersistentPlayerData.UsedDarknessRebekahStone + 1

    player:AddCacheFlags (CacheFlag.CACHE_ALL);
	player:EvaluateItems();
end

yandereWaifu:AddCallback(ModCallbacks.MC_USE_CARD, yandereWaifu.UseDarknessRebekahStone, RebekahCurse.Cards.SOUL_REBEKAHDARKNESS);

--labyrinth stone
function yandereWaifu:UseLabyrinthRebekahStone(card, player, flags) 
	player:ToPlayer()
	local playerdata = yandereWaifu.GetEntityData(player)
	local rng = math.random(1,10)
	InutilLib.game:GetHUD():ShowItemText("Curse of the Labyrinth","May it double your plinth")

    InutilLib.game:Darken(1, 300)
    InutilLib.SFX:Play(SoundEffect.SOUND_SATAN_GROW, 1, 0, false, 1)
    
    if not playerdata.PersistentPlayerData.UsedLabyrinthRebekahStone then playerdata.PersistentPlayerData.UsedLabyrinthRebekahStone = 0 end
    playerdata.PersistentPlayerData.UsedLabyrinthRebekahStone = playerdata.PersistentPlayerData.UsedLabyrinthRebekahStone + 1

    player:AddCacheFlags (CacheFlag.CACHE_ALL);
	player:EvaluateItems();
end

yandereWaifu:AddCallback(ModCallbacks.MC_USE_CARD, yandereWaifu.UseLabyrinthRebekahStone, RebekahCurse.Cards.SOUL_REBEKAHLABYRINTH);

--blind stone
function yandereWaifu:UseBlindRebekahStone(card, player, flags) 
	player:ToPlayer()
	local playerdata = yandereWaifu.GetEntityData(player)
	local rng = math.random(1,10)
	InutilLib.game:GetHUD():ShowItemText("Curse of the Blind","May they bless what you find")

    InutilLib.game:Darken(1, 300)
    InutilLib.SFX:Play(SoundEffect.SOUND_SATAN_GROW, 1, 0, false, 1)

    local ent = Isaac.Spawn(RebekahCurse.Enemies.ENTITY_REBEKAH_ENEMY, RebekahCurse.Enemies.ENTITY_BLINDPEDESTAL, 0, InutilLib.room:FindFreePickupSpawnPosition(player.Position, 1), Vector(0,0), player);
    yandereWaifu.GetEntityData(ent).Player = player

    --playerdata.PersistentPlayerData.UsedBlindRebekahStone = true
end

yandereWaifu:AddCallback(ModCallbacks.MC_USE_CARD, yandereWaifu.UseBlindRebekahStone, RebekahCurse.Cards.SOUL_REBEKAHBLIND);

--lost stone
function yandereWaifu:UseLostRebekahStone(card, player, flags) 
	player:ToPlayer()
	local playerdata = yandereWaifu.GetEntityData(player)
	local rng = math.random(1,10)
	InutilLib.game:GetHUD():ShowItemText("Curse of the Lost","May you find those you yearn oft")

    InutilLib.game:Darken(1, 300)
    InutilLib.SFX:Play(SoundEffect.SOUND_SATAN_GROW, 1, 0, false, 1)

    playerdata.PersistentPlayerData.UsedLostRebekahStone = 1
    player:AddCacheFlags(CacheFlag.CACHE_FAMILIARS);
	player:EvaluateItems()
end

yandereWaifu:AddCallback(ModCallbacks.MC_USE_CARD, yandereWaifu.UseLostRebekahStone, RebekahCurse.Cards.SOUL_REBEKAHLOST);

--maze stone
function yandereWaifu:UseMazeRebekahStone(card, player, flags) 
	player:ToPlayer()
	local playerdata = yandereWaifu.GetEntityData(player)
	local rng = math.random(1,10)
	InutilLib.game:GetHUD():ShowItemText("Curse of the Maze","May the walls which trapped you give you grace")

    InutilLib.game:Darken(1, 300)
    InutilLib.SFX:Play(SoundEffect.SOUND_SATAN_GROW, 1, 0, false, 1)

    local ent = Isaac.Spawn(RebekahCurse.Enemies.ENTITY_REBEKAH_ENEMY, RebekahCurse.Enemies.ENTITY_MAZERUNNER, 0, InutilLib.room:FindFreePickupSpawnPosition(player.Position, 1), Vector(0,0), player);
    yandereWaifu.GetEntityData(ent).Player = player

    playerdata.PersistentPlayerData.UsedMazeRebekahStone = true
end

yandereWaifu:AddCallback(ModCallbacks.MC_USE_CARD, yandereWaifu.UseMazeRebekahStone, RebekahCurse.Cards.SOUL_REBEKAHMAZE);

--unknown stone
function yandereWaifu:UseUnknownRebekahStone(card, player, flags) 
	player:ToPlayer()
	local data = yandereWaifu.GetEntityData(player)
	local rng = math.random(1,10)
	InutilLib.game:GetHUD():ShowItemText("Curse of the Unknown","May your passion be shown")

    InutilLib.game:Darken(1, 300)
    InutilLib.game:ShakeScreen(10)
    InutilLib.SFX:Play(SoundEffect.SOUND_SATAN_GROW, 1, 0, false, 1)

    local red = {amount = math.floor(player:GetHearts()/2), id = 1}
    local blue = {amount = math.floor(player:GetSoulHearts()/2), id = 2}
    local gold = {amount = player:GetGoldenHearts(),id = 3}
    local evil = {amount = math.floor(yandereWaifu.GetPlayerBlackHearts(player)/2),id = 4}
    local eternal = {amount = player:GetEternalHearts(),id = 5}
    local bone = {amount = player:GetBoneHearts(),id = 6}
    local rotten = {amount = player:GetRottenHearts(),id = 7}

	local heartTable = {}
	--[[if player:GetHearts() >= 2 then table.insert(heartTable, red) end
	if player:GetSoulHearts() >= 2 and (player:GetSoulHearts()-yandereWaifu.GetPlayerBlackHearts(player))>= 2 then table.insert(heartTable, blue) end	
	if player:GetGoldenHearts() > 0 then table.insert(heartTable, gold) end
	if yandereWaifu.GetPlayerBlackHearts(player) >= 2 then table.insert(heartTable, evil) end
	if player:GetEternalHearts() > 0 then table.insert(heartTable, eternal) end
	if player:GetBoneHearts() > 0 then table.insert(heartTable, bone) end
	if player:GetRottenHearts() > 0 then table.insert(heartTable, rotten) end]]
    table.insert(heartTable, red)
    table.insert(heartTable, blue)
    table.insert(heartTable, gold)
    table.insert(heartTable, evil)
    table.insert(heartTable, eternal)
    table.insert(heartTable, bone)
    table.insert(heartTable, rotten)

    local direction = InutilLib.DirToVec(player:GetFireDirection())
    local didRed = false

    for i, v in pairs(heartTable) do
        for j = 1, --[[math.random(4,6)]]v.amount do
            InutilLib.SetTimer(j*10, function()
                local value = v.id
                --[[local sub = 0
                local coll = 1
                if value == 1 then
                    sub = 0
                elseif value == 2 then
                    sub = 1
                elseif value == 3 then
                    sub = 6
                elseif value == 4 then
                    coll = 3
                    sub = 2
                elseif value == 5 then
                    coll = 2
                    sub = 3
                elseif value == 6 then
                    coll = 3
                    sub = 4
                elseif value == 7 then
                    coll = 2
                    sub = 5
                elseif value == 8 then
                    sub = 0
                    player:AddBrokenHearts(-1)
                end
                local mob = Isaac.Spawn(RebekahCurse.Enemies.ENTITY_REBEKAH_ENEMY, RebekahCurse.Enemies.ENTITY_REDTATO, sub, player.Position,  player.Velocity, player):ToNPC();
                mob:AddEntityFlags(EntityFlag.FLAG_CHARM | EntityFlag.FLAG_FRIENDLY | EntityFlag.FLAG_PERSISTENT)
                mob.HitPoints = mob.HitPoints/4
                mob.CollisionDamage = mob.CollisionDamage*(120*coll)
                yandereWaifu.GetEntityData(mob).CharmedToParent = player
                InutilLib.game:ShakeScreen(10)
                InutilLib.SFX:Play(SoundEffect.SOUND_BLOOD_LASER_LARGER, 1, 0, false, 0.8)]]

                if value == 1 then
                    local rng = math.random(1,6)
					if rng == 1 then
						data.PersistentPlayerData.RedStatBuffDamage = data.PersistentPlayerData.RedStatBuffDamage + 1
					elseif rng == 2 then
						data.PersistentPlayerData.RedStatBuffFireDelay = data.PersistentPlayerData.RedStatBuffFireDelay + 1
					elseif rng == 3 then
						data.PersistentPlayerData.RedStatBuffLuck = data.PersistentPlayerData.RedStatBuffLuck + 1
					elseif rng == 4 then
						data.PersistentPlayerData.RedStatBuffRange = data.PersistentPlayerData.RedStatBuffRange + 1
					elseif rng == 5 then
						data.PersistentPlayerData.RedStatBuffShotSpeed = data.PersistentPlayerData.RedStatBuffShotSpeed + 1
					elseif rng == 6 then
						data.PersistentPlayerData.RedStatBuffSpeed = data.PersistentPlayerData.RedStatBuffSpeed + 1
					end
                    if not didRed then
                        --yandereWaifu.RebekahRedNormalBarrage(player, data, player:GetShootingInput(), 40, 1, 0)
                        yandereWaifu.DoExtraBarrages(player, 1)
                        didRed = true
                    end
				elseif value == 2 then
					--yandereWaifu.RebekahSoulNormalBarrage(player, data, player:GetShootingInput(), 40, math.ceil((player.MaxFireDelay/5)), 1)v
                    data.PersistentPlayerData.SoulStatBuff = data.PersistentPlayerData.SoulStatBuff + 1
					yandereWaifu.DoExtraBarrages(player, 5)
				elseif value == 3 then
                    --local ned = Isaac.Spawn( EntityType.ENTITY_FAMILIAR, RebekahCurse.ENTITY_NED_NORMAL, 0, player.Position, Vector( 0, 0 ), player):ToFamiliar();
                    data.PersistentPlayerData.GoldStatBuff = data.PersistentPlayerData.GoldStatBuff + 1
                    for k = 0, math.random(15,20) do
                        InutilLib.SetTimer(k*3, function()
                            local room = InutilLib.game:GetRoom()
                            local x, y
                            local lowestY, highestY = Round(math.abs(InutilLib.room:GetTopLeftPos().Y),0), Round(math.abs(InutilLib.room:GetBottomRightPos().Y),0)
                            if InutilLib.ClosestHorizontalWall(player) == Direction.LEFT then
                                x = Round(math.abs(InutilLib.room:GetTopLeftPos().X), 0) - 50
                            else
                                x = Round(math.abs(InutilLib.room:GetBottomRightPos().X), 0) + 50
                            end
                            --print(Round(math.abs(InutilLib.room:GetBottomRightPos().Y),0))
                            --print(Round(math.abs(InutilLib.room:GetTopLeftPos().Y),0))
                            local y1, y2 = Round(math.abs(player.Position.Y - 50),0), Round(math.abs(player.Position.Y + 50),0)--the ys that the randomizer will pick from
                            if y1 <= lowestY then y1 = lowestY end
                            if y2 <= highestY then y2 = highestY end
                            y = math.random( y1, y2 )
                            local position = Vector(x,y)
                            local neds = Isaac.Spawn( EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_CHRISTIANNEDEXTRA, 0, position, Vector.Zero, player)
                            yandereWaifu.GetEntityData(neds).Damage = 10.5  + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BFFS)
                            if InutilLib.ClosestHorizontalWall(player) == Direction.RIGHT then
                                neds.FlipX = true
                            end
                        end)
                    end
				elseif value == 4 then
					local didtrigger = false
                    data.PersistentPlayerData.EvilStatBuff = data.PersistentPlayerData.EvilStatBuff + 1
					--[[if player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BRIMSTONE) < 2 then
						player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_BRIMSTONE, false, player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BRIMSTONE)+2)
						didtrigger = true
					end]]
					local beam = player:FireBrimstone( direction:Rotated(math.random(-7,7)), player, 2):ToLaser();
					beam.Position = player.Position
					beam.Timeout = 20
					beam.DisableFollowParent = true
					yandereWaifu.GetEntityData(beam).IsEvil = true
					--[[if didtrigger then
						player:GetEffects():RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_BRIMSTONE, player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BRIMSTONE)+2)
					end]]
				elseif value == 5 then
                    data.PersistentPlayerData.EternalStatBuff = data.PersistentPlayerData.EternalStatBuff + 1
					yandereWaifu.RebekahEternalBarrage(player,direction)
				elseif value == 6 then
                    data.PersistentPlayerData.BoneStatBuff = data.PersistentPlayerData.BoneStatBuff + 1
					for i = 1, 2 do --extra carrion worm thingies when extra tears!!
						local leech = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, RebekahCurse.ENTITY_BONEJOCKEY, 10, player.Position, Vector(0,0), player)
						yandereWaifu.GetEntityData(leech).ParentLeech = player
						yandereWaifu.GetEntityData(leech).DeathFrame = 600
					end
				elseif value == 7 then
                    data.PersistentPlayerData.RottenStatBuff = data.PersistentPlayerData.RottenStatBuff + 1
					local ball = Isaac.Spawn( EntityType.ENTITY_FAMILIAR, RebekahCurse.ENTITY_FLYTEAR, 0, player.Position, Vector(0,0), player):ToFamiliar();
				elseif value == 8 then
                    data.PersistentPlayerData.BrokenStatBuff = data.PersistentPlayerData.BrokenStatBuff + 1
					local ball = Isaac.Spawn( EntityType.ENTITY_FAMILIAR, FamiliarVariant.ANGELIC_PRISM, 0, player.Position, Vector(0,0), player):ToFamiliar();
				end
            end)
        end
    end
end

yandereWaifu:AddCallback(ModCallbacks.MC_USE_CARD, yandereWaifu.UseUnknownRebekahStone, RebekahCurse.Cards.SOUL_REBEKAHUNKNOWN);



function yandereWaifu:FenrirPuppyDeadCache(player, cacheF) --The thing the checks and updates the game, i guess?
	local data = yandereWaifu.GetEntityData(player)
	if cacheF == CacheFlag.CACHE_FAMILIARS then  -- Especially here!
		--if data.PersistentPlayerData.UsedLostRebekahStone then
        if not data.PersistentPlayerData.UsedLostRebekahStone then data.PersistentPlayerData.UsedLostRebekahStone = 0 end
			player:CheckFamiliar(RebekahCurse.ENTITY_FENRIR, data.PersistentPlayerData.UsedLostRebekahStone + player:GetEffects():GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_BOX_OF_FRIENDS), RNG(), nil, 1)
		--end
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, yandereWaifu.FenrirPuppyDeadCache)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function(_) --The thing the checks and updates the game, i guess?
	for p = 0, InutilLib.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		local data = yandereWaifu.GetEntityData(player)
		if data.PersistentPlayerData.UsedLostRebekahStone and data.PersistentPlayerData.UsedLostRebekahStone > 0 then
			local rooms = {}
			for i, v in pairs(yandereWaifu.GetRoomsNeighborsIdx(yandereWaifu.GetUSR().SafeGridIndex)) do
				table.insert(rooms, v)
				for j, w in pairs(yandereWaifu.GetRoomsNeighborsIdx(v)) do
					table.insert(rooms, w)
				end
			end

			--check room
			for i, v in pairs(rooms) do
				if InutilLib.level:GetRoomByIdx(v, -1).SafeGridIndex == InutilLib.level:GetCurrentRoomDesc().SafeGridIndex then
					InutilLib.SFX:Play(SoundEffect.SOUND_DOG_HOWELL, 1, 0, false, 0.8)
				end
			end
			--if InutilLib.level:GetCurrentRoomDesc().Data.Type == RoomType.ROOM_ULTRASECRET then
        elseif data.PersistentPlayerData.UsedMazeRebekahStone then
            local ent = Isaac.Spawn(RebekahCurse.Enemies.ENTITY_REBEKAH_ENEMY, RebekahCurse.Enemies.ENTITY_MAZERUNNER, 0, InutilLib.room:FindFreePickupSpawnPosition(player.Position, 1), Vector(0,0), player);
            yandereWaifu.GetEntityData(ent).Player = player
		end
	end
end)

yandereWaifu:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, ent)
	local spr = ent:GetSprite()
	local data = yandereWaifu.GetEntityData(ent)
	local player = ent:GetPlayerTarget()
	if ent.Variant == RebekahCurse.Enemies.ENTITY_BLINDPEDESTAL then
		if ent.FrameCount == 1 then
			--print("wot")
			data.State = 0
			spr:Play("Pedestal", true)
			ent:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
			ent:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
		end
        if data.State == 0 then
            if not spr:IsPlaying("Idle") then spr:Play("Idle", true) end
            if not data.Target then
                local pedestalCount = #Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, -1, false, false)
                if pedestalCount > 0 then
                    local pedestal = nil
                    local range = 9000000
                    for i, v in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, -1, false, false)) do
                        if range > v.Position:Distance(data.Player.Position) and v.SubType > 0 then
                            range = v.Position:Distance(data.Player.Position)
                            pedestal = v
                        end
                    end
                    if pedestal then
                        data.Target = pedestal
                    end
                end
            else
                if data.Target and data.Target:IsDead() then
                    data.Target = nil
                else
                    data.State = 1
                end
            end
        elseif data.State == 1 then
            if spr:IsFinished("Move") then
                if data.Target.Position:Distance(ent.Position) < 30 then
                    data.State = 2
                    spr:Play("Idle", true)
                else
                    data.State = 0
                end
            elseif not spr:IsPlaying("Move") then
                spr:Play("Move", true)
            elseif spr:IsPlaying("Move") then
                    if spr:WasEventTriggered("Jump") and not spr:IsEventTriggered("Land") then
                        if data.Target then
                            if ent.Position:Distance(player.Position) <= 200 then
                                ent.Velocity = (data.Target.Position - ent.Position) / 6
                            else
                                InutilLib.MoveDirectlyTowardsTarget(ent, data.Target, math.random(10,13), 0.9)
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
            if spr:IsFinished("Hit") then
                spr:RemoveOverlay()
                spr:Play("Idle", true)
            end
            if data.Target then
                ent.Position = data.Target.Position + Vector(0,2)
                if data.Target.SubType <= 0 then
                    data.Target = nil
                    data.State = 0
                    return
                end
                if spr:IsPlaying("Idle") then
                    local pedestalCount = #Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, -1, false, false)
                    local oldTarget = data.Target
                    local newTarget = nil
                    if pedestalCount > 0 then
                        local pedestal = nil
                        local range = data.Target.Position:Distance(data.Player.Position)
                        for i, v in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, -1, false, false)) do
                            if range > v.Position:Distance(data.Player.Position) and v.SubType > 0 then
                                range = v.Position:Distance(data.Player.Position)
                                pedestal = v
                            end
                        end
                        if pedestal then
                            newTarget = pedestal
                        end
                    end
                    if newTarget and GetPtrHash(newTarget) ~= GetPtrHash(oldTarget) then
                        data.State = 1
                        data.Target = newTarget
                    end
                end
                if spr:GetOverlayFrame() == 5 then
                    local itemPool = InutilLib.game:GetItemPool()
                    local seed = RNG():SetSeed(Game():GetSeeds():GetStartSeed(), 25)
                    local pool = ItemPoolType.POOL_GOLDEN_CHEST
                    if InutilLib.room:GetType() == RoomType.ROOM_BOSS  then
                        pool = ItemPoolType.POOL_BOSS
                    elseif InutilLib.room:GetType() == RoomType.ROOM_SHOP then
                        pool = ItemPoolType.POOL_SHOP
                    elseif InutilLib.room:GetType() == RoomType.ROOM_TREASURE then
                        pool = ItemPoolType.POOL_TREASURE
                    elseif InutilLib.room:GetType() == RoomType.ROOM_SECRET then
                        pool = ItemPoolType.POOL_SECRET
                    elseif InutilLib.room:GetType() == RoomType.ROOM_CURSE then
                        pool = ItemPoolType.POOL_CURSE
                    elseif InutilLib.room:GetType() == RoomType.ROOM_LIBRARY then
                        pool = ItemPoolType.POOL_LIBRARY
                    elseif InutilLib.room:GetType() == RoomType.ROOM_DEVIL then
                        pool = ItemPoolType.POOL_DEVIL
                    elseif InutilLib.room:GetType() == RoomType.ROOM_ANGEL then
                        pool = ItemPoolType.POOL_ANGEL
                    elseif InutilLib.room:GetType() == RoomType.ROOM_ULTRASECRET then
                        pool = ItemPoolType.POOL_ULTRA_SECRET
                    elseif InutilLib.room:GetType() == RoomType.ROOM_PLANETARIUM then
                        pool = ItemPoolType.POOL_PLANETARIUM
                    end
                    local randomItem = itemPool:GetCollectible(pool, false, seed, CollectibleType.COLLECTIBLE_NULL)
                    local pickup = data.Target:ToPickup():Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, randomItem, true, true, true)
                   -- data.Target = pickup:ToPickup()
                   for i = 0, 360 - 360/16, 360/16 do
                        local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, Vector.FromAngle(i):Resized(math.random(5,14)))
                        proj.Scale = math.random(12,19)/10
                    end
                end
            else
                data.State = 0
            end
            
            --[[if math.random(1,2) == 2 and player then --to hop
                spr:Play("Hop")
                data.State = 1
            elseif math.random(1,4) == 4 then
                spr:Play("Hop")
                data.State = 3
            end]]
        --[[elseif data.State == 1 then
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
            ent.Velocity = ent.Velocity  * 0.9]]
        end
	elseif ent.Variant == RebekahCurse.Enemies.ENTITY_MAZERUNNER then
        if not data.Init then
            data.Init = true
			print("wot")
			data.State = 0
			ent:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
			ent:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
			ent:AddEntityFlags(EntityFlag.FLAG_CHARM | EntityFlag.FLAG_FRIENDLY)
            yandereWaifu.GetEntityData(ent).CharmedToParent = player
            ent.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            ent.GridCollisionClass = EntityCollisionClass.COLLISION_WALL
		end
        local lerpVal = 0.6
        --ent.Velocity = InutilLib.Lerp(ent.Velocity,(data.Player.Position + data.Player.Velocity:Resized(15))-ent.Position, lerpVal)
        if data.State == 0 then
            if not spr:IsPlaying("IdleDown") then
                spr:Play("IdleDown", true)
            end
            --if player.Velocity:Length() > 2 then
            --[[else
                --InutilLib.MoveDirectlyTowardsTarget(ent, data.Player, 1.1, 0.9)
                ent.Velocity = InutilLib.Lerp(ent.Velocity,(data.Player.Position + (ent.Position):Rotated(data.Angle):Resized(2))-ent.Position, lerpVal)
            end]]
            local proj = InutilLib.GetClosestProjectile(data.Player, 600)
            if proj then
                InutilLib.MoveDirectlyTowardsTarget(ent, proj, 1.3, 0.9)
                if proj.Position:Distance(ent.Position) <= 40 then
                    data.State = 1
                end
            else
                InutilLib.MoveDirectlyTowardsTarget(ent, data.Player, 0.5, 0.9)
                if player.Position:Distance(ent.Position) <= 40 then
                    data.State = 1
                end
            end

            if ent.FrameCount % 5 == 0 then
                Isaac.Spawn( EntityType.ENTITY_EFFECT, EffectVariant.DIRT_PILE, 0, ent.Position,  Vector(0,0), data.Player );
            end
        elseif data.State == 1 then
            if spr:IsFinished("GetUp") then
                data.State = 2
            elseif not spr:IsPlaying("GetUp") then
                spr:Play("GetUp", true)
            elseif spr:IsPlaying("GetUp") then
                if spr:IsEventTriggered("Crash") then
                    ent.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ENEMIES
                    for _, v in ipairs(Isaac.FindInRadius(ent.Position, 75, EntityPartition.ENEMY)) do
                        if v.Position:Distance(ent.Position) <= 45 then
                            v:TakeDamage(7, 0, EntityRef(player), 5)
                        end
                    end
                end
            end
            ent.Velocity = Vector(0,0)
        elseif data.State == 2 then
            if spr:IsFinished("Idle") then
                data.State = 3
            elseif not spr:IsPlaying("Idle") then
                spr:Play("Idle", true)
            elseif spr:IsPlaying("Idle") then
                for i, v in pairs (Isaac.GetRoomEntities()) do
                    if v.Position:Distance(ent.Position) <= 20 and v.Type ~= EntityType.ENTITY_PLAYER and v.Type ~= EntityType.ENTITY_EFFECT and v.Type ~= EntityType.ENTITY_TEAR then
                        local vec = v.Position-ent.Position
                        v.Velocity = vec:Resized(10)
                    end
                end
            end
            ent.Velocity = Vector(0,0)
        elseif data.State == 3 then
            if spr:IsFinished("GetDown") then
                data.State = 0
            elseif not spr:IsPlaying("GetDown") then
                spr:Play("GetDown", true)
            elseif spr:IsPlaying("GetDown") then
                if spr:IsEventTriggered("Crash") then
                    ent.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                end
            end
            ent.Velocity = Vector(0,0)
        end
        if data.State >= 1 then
            for _, v in ipairs(Isaac.FindByType(EntityType.ENTITY_PROJECTILE, -1, -1, false, true)) do
                if v.Position:Distance(ent.Position) <= 45 then
                    v:Kill()
                end
            end
        end
    end
end, RebekahCurse.Enemies.ENTITY_REBEKAH_ENEMY)

yandereWaifu:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, ent, damage, dmgFlag, dmgSource, dmgCountdownFrames)
	--dmgSource = dmgSource:ToLaser()
	if ent.Type == RebekahCurse.Enemies.ENTITY_REBEKAH_ENEMY and ent.Variant == RebekahCurse.Enemies.ENTITY_BLINDPEDESTAL then
		local spr = ent:GetSprite()
	    local data = yandereWaifu.GetEntityData(ent)
        data.State = 2
        spr:PlayOverlay("Swirl", true)
        spr:Play("Hit", true)
        return false
	end
end)


yandereWaifu:AddCallback("MC_POST_CLEAR_ROOM", function(_, room)
    for p = 0, InutilLib.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		local data = yandereWaifu.GetEntityData(player)
        if data.PersistentPlayerData.UsedLabyrinthRebekahStone then
            for i, v in pairs(Isaac.GetRoomEntities()) do
                if v.Type == 5 and v.FrameCount < 15 then
                    for i = 1, data.PersistentPlayerData.UsedLabyrinthRebekahStone do
                        if not yandereWaifu.GetEntityData(v).IsDuplicatedFromRune then
                            local sub = v.SubType
                            if v.Variant == 100 then
                                sub = -1 
                            end
                            local ent = Isaac.Spawn( v.Type, v.Variant, sub, InutilLib.room:FindFreePickupSpawnPosition(v.Position, 1), Vector(0,0), v );
                            yandereWaifu.GetEntityData(ent).IsDuplicatedFromRune = true
                        end
                    end
                end
            end
        end
	end
    for _, fam in pairs(Isaac.FindByType(3, RebekahCurse.ENTITY_FENRIR, 1, false, false)) do
		local fam = fam:ToFamiliar()
		fam.Coins = fam.Coins + 1
	end
end)
    

yandereWaifu:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
	for p = 0, InutilLib.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		local data = yandereWaifu.GetEntityData(player)
		if  data.PersistentPlayerData.NumberofNormalRebekahStonesUsed then
			for i = 1, data.PersistentPlayerData.NumberofNormalRebekahStonesUsed do
				InutilLib.RemoveInnateItem(player, CollectibleType.COLLECTIBLE_BIRTHRIGHT)
			end
            data.PersistentPlayerData.NumberofNormalRebekahStonesUsed = nil
		end
        data.PersistentPlayerData.UsedCursedRebekahStone = nil
        data.PersistentPlayerData.UsedDarknessRebekahStone = nil
        data.PersistentPlayerData.UsedLabyrinthRebekahStone = nil
        data.PersistentPlayerData.UsedLostRebekahStone = 0
        data.PersistentPlayerData.UsedMazeRebekahStone = nil
        player:AddCacheFlags (CacheFlag.CACHE_ALL);
	    player:EvaluateItems();
	end
end)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_,player)
	local data = yandereWaifu.GetEntityData(player)
	if data.PersistentPlayerData.UsedDarknessRebekahStone then
        player:SetColor(Color(0,0,0,1,0,0,0),3,1,false,false)
        if player.FrameCount % 300 == 0 then
            for i, e in pairs(Isaac.GetRoomEntities()) do
				if e:IsEnemy() then
					e:AddFear(EntityRef(player), 60)
				end
			end
            InutilLib.SFX:Play( SoundEffect.SOUND_HEARTBEAT, 1, 0, false, 1);
            InutilLib.game:Darken(1, 10)
        end
    end
end)

function yandereWaifu:RebekahSoulStoneCache(player, cacheF) --The thing the checks and updates the game, i guess?
    local data = yandereWaifu.GetEntityData(player)
    if data.PersistentPlayerData.UsedDarknessRebekahStone then -- Especially here!
        if cacheF == CacheFlag.CACHE_FIREDELAY then
            player.MaxFireDelay = player.MaxFireDelay -2*data.PersistentPlayerData.UsedDarknessRebekahStone
        end
        if cacheF == CacheFlag.CACHE_SPEED then
            player.MoveSpeed = player.MoveSpeed + 0.20*(data.PersistentPlayerData.UsedDarknessRebekahStone*0.5)
        end
        if cacheF == CacheFlag.CACHE_DAMAGE then
            player.Damage = player.Damage + 5*data.PersistentPlayerData.UsedDarknessRebekahStone
        end
    end
end
yandereWaifu:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, yandereWaifu.RebekahSoulStoneCache)

local antiRecursion

local function isRebekahCurseStones(stone)
    if stone == RebekahCurse.Cards.SOUL_REBEKAHCURSED or
    stone == RebekahCurse.Cards.SOUL_REBEKAHBLIND or
    stone == RebekahCurse.Cards.SOUL_REBEKAHDARKNESS or
    stone == RebekahCurse.Cards.SOUL_REBEKAHLABYRINTH or
    stone == RebekahCurse.Cards.SOUL_REBEKAHLOST or
    stone == RebekahCurse.Cards.SOUL_REBEKAHUNKNOWN or
    stone == RebekahCurse.Cards.SOUL_REBEKAHMAZE then
        return true
    else
        return false
    end
end

yandereWaifu:AddCallback(ModCallbacks.MC_GET_CARD, function(_, rng, card, canSuit, canRune, forceRune)
	--if (yandereWaifu.IsCardLocked(card) or yandereWaifu.NoCardNaturalSpawn(card)) and not antiRecursion then
    
		antiRecursion = true

		local itempool = InutilLib.game:GetItemPool()
		local new
		local i = 0

		repeat
			i = i + 1
			new = itempool:GetCard(rng:GetSeed() + i, canSuit, canRune, forceRune)
            --print("test")
            --print(rng:GetSeed() + i)
		until not (isRebekahCurseStones(new))

		antiRecursion = false

		return new
	--end
end)