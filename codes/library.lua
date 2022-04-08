
function yandereWaifu.DoExtraBarrages(player, mode)
	local data = yandereWaifu.GetEntityData(player)
	local game = ILIB.game
	if mode == 1 then
		InutilLib.SetFrameLoop(40,function()
			if not data.BarFrames then data.BarFrames = 0 end
			if not data.BarAngle then data.BarAngle = 0 end --incase if nil

			data.BarFrames = data.BarFrames + 1
		
			local angle = player.Velocity:GetAngleDegrees()
			
			--barrage angle modifications are here :3
			if data.BarFrames % 2 then
				if data.BarFrames == 0 then
					data.BarAngle = 0
				elseif data.BarFrames > 1 and data.BarFrames < 10 then
					data.BarAngle = data.BarAngle - 1
				elseif data.BarFrames > 10 and data.BarFrames < 20 then
					data.BarAngle = data.BarAngle + 2
				elseif data.BarFrames > 20 and data.BarFrames < 30 then
					data.BarAngle = data.BarAngle - 2
				elseif data.BarFrames > 30 and data.BarFrames < 40 then
					data.BarAngle = data.BarAngle + 4
				else
					data.BarAngle = 0
				end
			end
			local modulusnum = math.ceil((player.MaxFireDelay/5))
			if data.BarFrames == 1 then
				--data.specialAttackVector:GetAngleDegrees() = angle
			elseif data.BarFrames >= 1 and data.BarFrames < 40 and data.BarFrames % modulusnum == (0) then
				player.Velocity = player.Velocity * 0.8 --slow him down
				local tears = player:FireTear(player.Position, Vector.FromAngle(data.BarAngle + data.specialAttackVector:GetAngleDegrees())*(20), false, false, false)
				tears.Position = player.Position
				InutilLib.SFX:Play(SoundEffect.SOUND_TEARS_FIRE, 1, 0, false, 1.2)
			elseif data.BarFrames == 40 then
				data.BarFrames = nil
				data.BarAngle = nil
			end
		end)
	elseif mode == 2 then
		InutilLib.SetFrameLoop(0,function()
			for p = 10, 30, 10 do
				for i = 0, 360, 360/8 do
					local tears = player:FireTear(player.Position, Vector.FromAngle(i)*(p), false, false, false)
					tears.Position = player.Position
				end
			end
		end)
	elseif mode == 3 then
		local frame = true
		InutilLib.SetFrameLoop(30,function()
			--if not data.BarFrames then data.BarFrames = 0 end
			
			--data.BarFrames = data.BarFrames + 1
			
			local modulusnum = math.ceil((player.MaxFireDelay/5))
			local ang = math.random(10,30)
			if player.FrameCount % modulusnum == (0) then
				if frame == true then
					for i = 0, 360, 360/12 do
						local tears = player:FireTear(player.Position, Vector.FromAngle(i + ang)*(8), false, false, false)
						tears.Position = player.Position
					end
					frame = false
				else
					frame = true
				end
			end
		end)
	elseif mode == 4 then
		for k, enemy in pairs( Isaac.GetRoomEntities() ) do
			if enemy:IsEnemy() --[[and not enemy:IsEffect() and not enemy:IsInvulnurable()]] then
				if enemy.Position:Distance( player.Position ) < enemy.Size + player.Size + 100 then
					InutilLib.DoKnockbackTypeI(player, enemy, 0.5)
				end
			end
		end
		local chosenNumofBarrage =  math.random( 8, 15 );
		for i = 1, chosenNumofBarrage do
			player.Velocity = player.Velocity * 0.8; --slow him down
			--local tear = player:FireTear(player.Position, Vector.FromAngle(data.specialAttackVector:GetAngleDegrees() - math.random(-10,10))*(math.random(10,15)), false, false, false):ToTear()
			local tear = game:Spawn( EntityType.ENTITY_TEAR, 20, player.Position, Vector.FromAngle( math.random() * 360 ):Resized(REBEKAH_BALANCE.GOLD_HEARTS_DASH_ATTACK_SPEED), player, 0, 0):ToTear()
			tear.Scale = math.random() * 0.7 + 0.7;
			tear.FallingSpeed = -9 + math.random() * 2 ;
			tear.FallingAcceleration = 0.5;
			tear.CollisionDamage = player.Damage * 1.3;
			--tear.BaseDamage = player.Damage * 2
		end
	elseif mode == 5 then
		local chosenNumofBarrage = math.random(8,15)
		for i = 1, chosenNumofBarrage do
			player.Velocity = player.Velocity * 0.8; --slow him down
			local tear = player:FireTear( player.Position, Vector.FromAngle(data.specialAttackVector:GetAngleDegrees() - math.random(-10,10)):Resized(math.random(10,15)), false, false, false):ToTear()
			tear.Position = player.Position
			tear.Scale = math.random() * 0.7 + 0.7;
			tear.FallingSpeed = -9 + math.random() * 2;
			tear.FallingAcceleration = 0.5;
			tear.TearFlags = tear.TearFlags | TearFlags.TEAR_SPECTRAL;
			tear.CollisionDamage = player.Damage * 1.3;
			if i == chosenNumofBarrage then
				InutilLib.SFX:Play( SoundEffect.SOUND_WEIRD_WORM_SPIT, 1, 0, false, 1 );
			end
		end
	end
end


function yandereWaifu.DoTinyBarrages(player, vec)
	local data = yandereWaifu.GetEntityData(player)
	InutilLib.SetFrameLoop(40,function()
		if not data.BarFrames then data.BarFrames = 0 end
		if not data.BarAngle then data.BarAngle = 0 end --incase if nil

		data.BarFrames = data.BarFrames + 1
		
		local angle = player.Velocity:GetAngleDegrees()
			
		--barrage angle modifications are here :3
		if data.BarFrames % 2 then
			if data.BarFrames == 0 then
				data.BarAngle = 0
			elseif data.BarFrames > 1 and data.BarFrames < 10 then
				data.BarAngle = data.BarAngle - 1
			elseif data.BarFrames > 10 and data.BarFrames < 20 then
				data.BarAngle = data.BarAngle + 2
			elseif data.BarFrames > 20 and data.BarFrames < 30 then
				data.BarAngle = data.BarAngle - 2
			elseif data.BarFrames > 30 and data.BarFrames < 40 then
				data.BarAngle = data.BarAngle + 4
			else
				data.BarAngle = 0
			end
		end
		
		local modulusnum = 3
		if data.BarFrames == 1 then
			--data.specialAttackVector:GetAngleDegrees() = angle
		elseif data.BarFrames >= 1 and data.BarFrames < 40 and data.BarFrames % modulusnum == (0) then
			player.Velocity = player.Velocity * 0.8 --slow him down
			local tears = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0, player.Position, Vector.FromAngle(data.BarAngle + vec:GetAngleDegrees())*(20), player):ToTear()
			tears.Scale = 0.5
			InutilLib.SFX:Play(SoundEffect.SOUND_TEARS_FIRE, 1, 0, false, 1.2)
		elseif data.BarFrames == 40 then
			data.BarFrames = nil
			data.BarAngle = nil
		end
	end)
end


function yandereWaifu.AddRandomHeart(player)
	local rng = math.random(1,20)
	if rng <= 2 then
		player:AddHearts(2)
		player:AddMaxHearts(2)
	elseif rng <= 6 then
		player:AddSoulHearts(2)
	elseif rng <= 10 then
		player:AddBlackHearts(2)
	elseif rng <= 14 then
		player:AddEternalHearts(1)
	elseif rng <= 16 then
		player:AddGoldenHearts(1)
	elseif rng <= 18 then
		player:AddBoneHearts(1)
	elseif rng <= 20 then
		player:AddRottenHearts(1)
	end
end

function yandereWaifu.GetEntityData( entity )
	if entity then
		local data = entity:GetData();
		if data.REBECCA_DATA == nil then
			data.REBECCA_DATA = {};
		end
		return data.REBECCA_DATA;
	end
end

function yandereWaifu.GetMainEFetusTarget( target , player )
	local mainTarget
	if target.Parent.Variant == EntityType.ENTITY_PLAYER then
		local player = target.Parent:ToPlayer();
		mainTarget = player:GetActiveWeaponEntity();
	end
	return mainTarget
end

function yandereWaifu.GetOwnerOfEFetusMainTarget()
	local player = Isaac.GetPlayer(0)
    for i = 1, Game():GetNumPlayers() do
        local p = Isaac.GetPlayer(i - 1)
         if p:HasCollectible(CollectibleType.COLLECTIBLE_EPIC_FETUS) and (Input.IsActionTriggered(ButtonAction.ACTION_SHOOTLEFT, p.ControllerIndex) or Input.IsActionTriggered(ButtonAction.ACTION_SHOOTRIGHT, p.ControllerIndex) or Input.IsActionTriggered(ButtonAction.ACTION_SHOOTUP, p.ControllerIndex) or Input.IsActionTriggered(ButtonAction.ACTION_SHOOTDOWN, p.ControllerIndex)) then
            player = p
            break
        end
    end
    return player
end

function yandereWaifu.RandomHeartParticleVelocity()
	return Vector.FromAngle( math.random() * 360 ):Resized( math.random() * 6 + 2 );
end

function yandereWaifu.GetPlayerBlackHearts(player) -- Kilburn's code thingy that came from SOul Heart Rebalnce mod thingy that happens to be authored by Cucco. SO uhm, thanks Cucco and Kilburn or both of ya!
    local soulHearts = player:GetSoulHearts()
    local blackHearts = 0
    local currentSoulHeart = 0
    for i=0, (math.ceil(player:GetSoulHearts() / 2) + player:GetBoneHearts())-1 do
        if not player:IsBoneHeart(i) then
            if player:IsBlackHeart(currentSoulHeart+1) then
                if soulHearts - currentSoulHeart >= 2 then
                    blackHearts = blackHearts + 2
                elseif soulHearts - currentSoulHeart == 1 then
                    blackHearts = blackHearts + 1
                end
            end
            currentSoulHeart = currentSoulHeart + 2
        end
    end
    return blackHearts
end
--barragetears, so I don't use FireTear, it can get broken
function yandereWaifu.FireKeeperTear(Position, Velocity, TearVariant, Parent, Color)
    ILIB.game:Spawn(EntityType.ENTITY_TEAR, TearVariant, Position, Velocity, Parent, 0, 0)
    for i, entity in pairs(Isaac.GetRoomEntities()) do
        if entity.Type == EntityType.ENTITY_TEAR then
            entity = entity:ToTear()
            entity:SetColor(Color, 999, 999, true, false)
        end
    end
end

function yandereWaifu.FireBarrageTear(Position, Velocity, TearVariant, Parent, Color)
    local tear = ILIB.game:Spawn(EntityType.ENTITY_TEAR, TearVariant, Position, Velocity, Parent, 0, 0)
	
	return tear
end

--im_tem made this happen, thx
function yandereWaifu.ApplyCostumes(mode, player, reloadanm2, poof)
	if poof == nil then poof = true end
	reloadanm2=reloadanm2 or true
	if reloadanm2 then
		if mode == REBECCA_MODE.SoulHearts then --special interacts
			player:GetSprite():Load('gfx/rebekahsfluidhairforsoul.anm2',false)
		else
			player:GetSprite():Load('gfx/rebekahsfluidhair.anm2',false)
		end
	end
	local player = player or Isaac.GetPlayer(0);
	local playerType = player:GetPlayerType()
	local hair = RebeccaModeCostumes[mode] --reminder to iplement eternal heart wing sprite
	player:TryRemoveNullCostume(RebekahCurseCostumes.RebeccasFate);
	player:TryRemoveNullCostume(RebekahCurseCostumes.GlitchEffect);
	local name = RebeccaModeNames[mode]
	local skincolor = ""
	if player:GetHeadColor() == SkinColor.SKIN_WHITE then
		skincolor = "_white"
	elseif player:GetHeadColor() == SkinColor.SKIN_BLACK then
		skincolor = "_black"
	elseif player:GetHeadColor() == SkinColor.SKIN_BLUE then
		skincolor = "_blue"
	elseif player:GetHeadColor() == SkinColor.SKIN_RED then
		skincolor = "_red"
	elseif player:GetHeadColor() == SkinColor.SKIN_GREEN then
		skincolor = "_green"
	elseif player:GetHeadColor() == SkinColor.SKIN_GREY then
		skincolor = "_grey"
	end
	local skinpath='gfx/characters/costumes/character_rebekah_'..tostring(name)..tostring(skincolor)..'.png'
	player:GetSprite():ReplaceSpritesheet(12,skinpath)	
	player:GetSprite():ReplaceSpritesheet(4,skinpath)
	player:GetSprite():ReplaceSpritesheet(1,skinpath)
	local hairpath='gfx/characters/costumes/rebekah_hair/character_'..tostring(hair)..'.png'
	if yandereWaifu.IsNormalRebekah(player) then
		if mode == REBECCA_MODE.SoulHearts then --special interacts
			if yandereWaifu.GetEntityData(player).SoulBuff then
				hairpath='gfx/characters/costumes/rebekah_hair/character_wizoobopenhair.png'
			end
		elseif mode == REBECCA_MODE.EternalHearts then
			player:AddNullCostume(RebekahCurseCostumes.RebeccasFate);
		elseif mode == REBECCA_MODE.RottenHearts then
			if yandereWaifu.GetEntityData(player).extraHeadsPresent then 
				hairpath='gfx/characters/costumes/rebekah_hair/character_crazyhair_skinless.png'
			end
		elseif mode == REBECCA_MODE.BrokenHearts then
			player:AddNullCostume(RebekahCurseCostumes.GlitchEffect)
		end
	elseif playerType == RebekahCurse.WISHFUL_ISAAC then
		hairpath='gfx/characters/costumes/character_wishfulhair.png'
	end
	local config=Isaac.GetItemConfig():GetNullItem(7)
	player:GetSprite():ReplaceSpritesheet(15,hairpath)		--loading the hairstyle for layer 15
	player:GetSprite():ReplaceSpritesheet(17,hairpath)		--for layer 17 too because of some anims
	player:GetSprite():LoadGraphics() 						--loading graphics is required
	player:ReplaceCostumeSprite(config,hairpath,0)	--replacing maggy hair costume sprite for fire anims
	--yandereWaifu.GetEntityData(player).hairpath = hairpath
	
	if poof then
		local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_PERSONALITYPOOF, 0, player.Position, Vector.Zero, player)
	end
end


function yandereWaifu.SpawnParticles( type, variant, subvariant, amount, position, velocity, spawner, spriteSheet )
	local particles = {}
	for i = 1, amount do
		local particle = Isaac.Spawn( type, variant, subvariant or 0, position, velocity, player );
		if spriteSheet ~= nil then
			local sprite = particle:GetSprite();
			sprite:ReplaceSpritesheet( 0, spriteSheet );
			sprite:LoadGraphics();
		end
		table.insert( particles, particle );
	end
	return particles;
end

function yandereWaifu.SpawnHeartParticles( minimum, maximum, position, velocity, spawner, heartType )
	local particles = yandereWaifu.SpawnParticles( EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_HEARTPARTICLE, 0, math.random( minimum, maximum ), position, velocity, spawner, RebekahHeartParticleSpriteByType[heartType] );
	for i,particle in ipairs(particles) do
		local size = math.random(1,3);
		local data = yandereWaifu.GetEntityData( particle );
		if size == 1 then
			if not data.Large then data.Large = true end
		elseif size == 2 then
			if not data.Small then data.Small = true end
		end
		particle:GetSprite():Stop();
	end
end

function yandereWaifu.SpawnPoofParticle( position, velocity, spawner, poofType )
	local particles = yandereWaifu.SpawnParticles( EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_HEARTPOOF, 0, 1, position, velocity, spawner, RebekahPoofParticleSpriteByType[poofType] );
	return particles[1];
end

-- spawn poof based on spawner velocity
function yandereWaifu.SpawnDashPoofParticle( position, velocity, spawner, poofType )
	local particles = yandereWaifu.SpawnParticles( EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_HEARTPOOF, 0, 1, position, velocity, spawner, RebekahPoofParticleSpriteByType[poofType] );
	local poof = particles[1];
	local poofSprite = poof:GetSprite();
	poofSprite.Scale = Vector( 0.6, 0.6 );
	poofSprite.Rotation = spawner.Velocity:Rotated(-90):GetAngleDegrees();
	return poof;
end

---spawn ectoplasm in one place
function yandereWaifu.SpawnEctoplasm( position, velocity, size, parent, dontupdate)
	local puddle = Isaac.Spawn( EntityType.ENTITY_EFFECT, 46, 0, position, velocity, parent):ToEffect();
	--puddle.Scale = size or 1
	--puddle:PostRender()
	if not dontupdate then
		InutilLib.RevelSetCreepData(puddle)
		InutilLib.RevelUpdateCreepSize(puddle, size or 1, true)
	end
	puddle:GetData().IsEctoplasm = true;
end

function yandereWaifu:SetRebekahPocketActiveItem( player, mode )
	if mode == REBECCA_MODE.RedHearts then
		player:SetPocketActiveItem(RebekahCurse.COLLECTIBLE_LOVECANNON)
	elseif mode == REBECCA_MODE.SoulHearts then
		player:SetPocketActiveItem(RebekahCurse.COLLECTIBLE_WIZOOBTONGUE)
	elseif mode == REBECCA_MODE.GoldHearts then
		player:SetPocketActiveItem(RebekahCurse.COLLECTIBLE_PSALM45)
	elseif mode == REBECCA_MODE.EvilHearts then
		player:SetPocketActiveItem(RebekahCurse.COLLECTIBLE_APOSTATE)
	elseif mode == REBECCA_MODE.EternalHearts then
		player:SetPocketActiveItem(RebekahCurse.COLLECTIBLE_BARACHIELSPETAL)
	elseif mode == REBECCA_MODE.BoneHearts then
		player:SetPocketActiveItem(RebekahCurse.COLLECTIBLE_FANG)
	elseif mode == REBECCA_MODE.RottenHearts then
		player:SetPocketActiveItem(RebekahCurse.COLLECTIBLE_BEELZEBUBSBREATH)
	elseif mode == REBECCA_MODE.BrokenHearts then
		player:SetPocketActiveItem(RebekahCurse.COLLECTIBLE_MAINLUA)
	end
end

function yandereWaifu.ChangeMode( player, mode, free, fanfare )
	local data = yandereWaifu.GetEntityData(player)
	data.currentMode = mode;
	
	if free ~= true then 
		if mode == REBECCA_MODE.RedHearts then
			player:AddHearts(-2);
		elseif mode == REBECCA_MODE.SoulHearts then
			player:AddSoulHearts(-2);
		elseif mode == REBECCA_MODE.GoldHearts then
			player:AddGoldenHearts(-1);
		elseif mode == REBECCA_MODE.EvilHearts then
			player:RemoveBlackHeart(2);
			player:AddSoulHearts(-2);
		elseif mode == REBECCA_MODE.EternalHearts  then
			player:AddEternalHearts(-1);
		elseif mode == REBECCA_MODE.BoneHearts then
			player:AddBoneHearts(-1);
		elseif mode == REBECCA_MODE.RottenHearts then
			player:AddRottenHearts(-1);
		--elseif mode == REBECCA_MODE.BrokenHearts then --lets make life hard
		--	player:AddBrokenHearts(-1);
		end
	end
	yandereWaifu.resetReserve(player)
	if mode == REBECCA_MODE.RedHearts then
		data.heartReserveMaxFill = 100
	elseif mode == REBECCA_MODE.SoulHearts then
		data.heartReserveMaxFill = 120
	elseif mode == REBECCA_MODE.GoldHearts then
		data.heartReserveMaxFill = 50
	elseif mode == REBECCA_MODE.EvilHearts then
		data.heartReserveMaxFill = 140
	elseif mode == REBECCA_MODE.EternalHearts then
		data.heartReserveMaxFill = 80
	elseif mode == REBECCA_MODE.BoneHearts then
		data.heartReserveMaxFill = 100
	elseif mode == REBECCA_MODE.RottenHearts then
		data.heartReserveMaxFill = 100
	elseif mode == REBECCA_MODE.BrokenHearts then
		data.heartReserveMaxFill = 100
	end

	if fanfare ~= false then
		yandereWaifu.SpawnPoofParticle( player.Position + Vector( 0, 1 ), Vector( 0, 0 ), player, RebekahPoofParticleTypeByMode[ mode ] );
	end
	
	if mode == REBECCA_MODE.RedHearts then
		player:ChangePlayerType(RebekahCurse.REB_RED)
	elseif mode == REBECCA_MODE.SoulHearts then
		player:ChangePlayerType(RebekahCurse.REB_SOUL)
	elseif mode == REBECCA_MODE.GoldHearts then
		player:ChangePlayerType(RebekahCurse.REB_GOLD)
	elseif mode == REBECCA_MODE.EvilHearts then
		player:ChangePlayerType(RebekahCurse.REB_EVIL)
	elseif mode == REBECCA_MODE.EternalHearts then
		player:ChangePlayerType(RebekahCurse.REB_ETERNAL)
	elseif mode == REBECCA_MODE.BoneHearts then
		player:ChangePlayerType(RebekahCurse.REB_BONE)
	elseif mode == REBECCA_MODE.RottenHearts then
		player:ChangePlayerType(RebekahCurse.REB_ROTTEN)
	elseif mode == REBECCA_MODE.BrokenHearts then
		player:ChangePlayerType(RebekahCurse.REB_BROKEN)
	end
	
	yandereWaifu:SetRebekahPocketActiveItem(player,mode)
	--reset effects --KIL FIX YOUR GAMEEEEEEEEE
	--local playerEffects = player:GetEffects();
	--playerEffects:RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_20_20);
	--playerEffects:RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_HEAD_OF_THE_KEEPER);
	--playerEffects:RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_SERPENTS_KISS);
	--playerEffects:RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_FATE);

	--stat evaluation =3=
	--yandereWaifu.ApplyCollectibleEffects(player);
	
	if mode == REBECCA_MODE.EternalHearts then
		yandereWaifu.RebekahCanShoot(player, false)
	else
		yandereWaifu.RebekahCanShoot(player, true)
	end
	
	yandereWaifu.ApplyCostumes( mode, player );
	--local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, ENTITY_PERSONALITYPOOF, 0, player.Position, Vector.Zero, player)
	
	--make changes to Rebecca
	player:AddCacheFlags(CacheFlag.CACHE_ALL);
	player:EvaluateItems();
	
	yandereWaifu.GetEntityData(player).countdownFrames = 0
	yandereWaifu.GetEntityData(player).IsDashActive = false
end

function yandereWaifu.RebekahCanShoot(player, canShoot) --alternative so that she doesnt get a weird hair do
	local data = yandereWaifu.GetEntityData(player)
	--data.currentMode = mode;
	InutilLib.DumpySetCanShoot(player, canShoot)
	yandereWaifu.ApplyCostumes( data.currentMode, player , false , false)
end

function yandereWaifu.SpawnStartingRebekahRoomControls(mode)
	local centerPos = InutilLib.room:GetCenterPos()
	local playerType = Isaac.GetPlayer(0):GetPlayerType()
	local playerInfo 
	if InutilLib.ListOfRegPlayers[playerType] then playerInfo = InutilLib.ListOfRegPlayers[playerType] end
	local stageType = InutilLib.level:GetStageType()
	local controlsPos = centerPos
	
	--controlsPos = centerPos + Vector(0,-65)
	
	if playerInfo then
		if playerInfo.instructions then
			local column = TableLength(playerInfo.instructions)
			local Pos = {}
			if column then
				if column == 1 then --definitions
					Pos[1] = Vector(0,0)
				elseif column == 2 then 
					Pos[1] = Vector(0,-55)
					Pos[2] = Vector(0, 55)
				elseif column == 3 then
					Pos[1] = Vector(0,-95)
					Pos[2] = Vector(0,0)
					Pos[3] = Vector(0, 95)
				end
				for i = 1, column do 
					local controlsEffect = InutilLib.SpawnFloorEffect(controlsPos + Pos[i], Vector(0,0), nil, "gfx/backdrop/controls.anm2", true)
					local controlsSprite = controlsEffect:GetSprite()
					controlsSprite:Play("Idle")
					controlsSprite:ReplaceSpritesheet(0, playerInfo.instructions[i])
					controlsSprite:LoadGraphics()
					if column == 3 then controlsEffect.SpriteScale = Vector(0.8, 0.8) end
					
					if stageType == StageType.STAGETYPE_AFTERBIRTH then
						controlsSprite.Color = burningBasementColor
					elseif REVEL then
						if REVEL.STAGE.Glacier:IsStage() then
							controlsSprite.Color = glacierColor
						end
					end
				end
			end
		end
	elseif CommunityRemixRemixed and playerType == p20PlayerType.PLAYER_ADAM then --crr compat, I have to do this unless they like to fix it in their side
		--do nothing
	else
		if playerType ~= PlayerType.PLAYER_THEFORGOTTEN and playerType ~= PlayerType.PLAYER_THESOUL then
			local controlsEffect = InutilLib.SpawnFloorEffect(controlsPos, Vector(0,0), nil, "gfx/backdrop/controls.anm2", true)
			local controlsSprite = controlsEffect:GetSprite()
			controlsSprite:Play("Idle")
			--controlsSprite:ReplaceSpritesheet(0, InutilLib.DefaultInstructions)
			controlsSprite:LoadGraphics()

			if stageType == StageType.STAGETYPE_AFTERBIRTH then
				controlsSprite.Color = burningBasementColor
			elseif REVEL then
				if REVEL.STAGE.Glacier:IsStage() then
					controlsSprite.Color = glacierColor
				end
			end
		end
	end
end

function yandereWaifu.AddGenericTracer(position, color, angle, timeout)     
	local timeout = timeout or 30
	local line = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_UNGENERICTRACER, 0, position, Vector(0,0), ent)
	line:GetSprite().Rotation = angle
	line.Color = color
	yandereWaifu.GetEntityData(line).Timeout = timeout
	return line
end
function yandereWaifu.HasCollectibleMultiple(player, ...)
	for _, coll in ipairs({...}) do
		if player:HasCollectible(coll) then
			return true
		end
	end
	return false
end
		
function yandereWaifu.HasCollectibleConfirmedUseMultiple(player, ...)
	for _, coll in ipairs({...}) do
		if InutilLib.ConfirmUseActive( player, coll )  then
			return true
		end
	end
	return false
end

function yandereWaifu.SpawnRedGun(player, direction, extra)
	local data = yandereWaifu.GetEntityData(player)
	if not data.HugsRed then
		if extra then
			if not data.extraHugsRed then data.extraHugsRed = {} end
			local gun = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_REBEKAHENTITYWEAPON, 0, player.Position,  Vector.Zero, player):ToEffect()
			yandereWaifu.GetEntityData(gun).parent = player
			yandereWaifu.GetEntityData(gun).direction = direction
			table.insert( data.extraHugsRed, gun )
			return gun
		else
			data.HugsRed = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_REBEKAHENTITYWEAPON, 0, player.Position,  Vector.Zero, player):ToEffect()
			yandereWaifu.GetEntityData(data.HugsRed).parent = player
			yandereWaifu.GetEntityData(data.HugsRed).direction = direction
		end
	end
end

function yandereWaifu.RemoveRedGun(player)
	local data = yandereWaifu.GetEntityData(player)
		if data.HugsRed then
			data.HugsRed:Remove()
			data.HugsRed = nil
		end
		if data.extraHugsRed then
			for k, v in pairs(data.extraHugsRed) do
				v:Remove()
			end
			data.extraHugsRed = nil
		end
end

function yandereWaifu.PlayAllRedGuns(player, mode)
	mode = mode or 0
	local data = yandereWaifu.GetEntityData(player)
	for k, v in pairs (data.extraHugsRed) do
		yandereWaifu.GetEntityData(v).Shoot = true
		
		if mode == 0 then
			yandereWaifu.GetEntityData(v).Medium = true
		end
		if mode == 1 then
			yandereWaifu.GetEntityData(v).Light = true
		end
		if mode == 2 then
			yandereWaifu.GetEntityData(v).Heavy = true
		end
		if mode == 3 then
			yandereWaifu.GetEntityData(v).DrFetus = true
		end
		if mode == 4 then
			yandereWaifu.GetEntityData(v).Tech = true
		end
		if mode == 5 then
			yandereWaifu.GetEntityData(v).Brimstone = true
		end
	end
end

function yandereWaifu.IsNormalRebekah(player)
	if player:GetPlayerType() == RebekahCurse.REB_RED or player:GetPlayerType() == RebekahCurse.REB_SOUL or player:GetPlayerType() == RebekahCurse.REB_EVIL or player:GetPlayerType() == RebekahCurse.REB_GOLD or player:GetPlayerType() == RebekahCurse.REB_ETERNAL or player:GetPlayerType() == RebekahCurse.REB_BONE or player:GetPlayerType() == RebekahCurse.REB_ROTTEN or player:GetPlayerType() == RebekahCurse.REB_BROKEN then
		return true
	end
end