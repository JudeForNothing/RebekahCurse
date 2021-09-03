
function yandereWaifu.DoExtraBarrages(player, mode)
	local data = yandereWaifu.GetEntityData(player)
	if mode == 1 then
		SchoolbagAPI.SetFrameLoop(40,function()
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
				speaker:Play(SoundEffect.SOUND_TEARS_FIRE, 1, 0, false, 1.2)
			elseif data.BarFrames == 40 then
				data.BarFrames = nil
				data.BarAngle = nil
			end
		end)
	elseif mode == 2 then
		SchoolbagAPI.SetFrameLoop(0,function()
			for p = 10, 30, 10 do
				for i = 0, 360, 360/8 do
					local tears = player:FireTear(player.Position, Vector.FromAngle(i)*(p), false, false, false)
					tears.Position = player.Position
				end
			end
		end)
	elseif mode == 3 then
		local frame = true
		SchoolbagAPI.SetFrameLoop(5,function()
			local ang = math.random(10,30)
			if frame == true then
				for i = 0, 360, 360/12 do
					local tears = player:FireTear(player.Position, Vector.FromAngle(i + ang)*(8), false, false, false)
					tears.Position = player.Position
				end
				frame = false
			else
				frame = true
			end
		end)
	elseif mode == 4 then
		for k, enemy in pairs( Isaac.GetRoomEntities() ) do
			if enemy:IsEnemy() --[[and not enemy:IsEffect() and not enemy:IsInvulnurable()]] then
				if enemy.Position:Distance( player.Position ) < enemy.Size + player.Size + 100 then
					SchoolbagAPI.DoKnockbackTypeI(player, enemy, 0.5)
				end
			end
		end
		local chosenNumofBarrage =  math.random( 8, 15 );
		for i = 1, chosenNumofBarrage do
			player.Velocity = player.Velocity * 0.8; --slow him down
			--local tear = player:FireTear(player.Position, Vector.FromAngle(data.specialAttackVector:GetAngleDegrees() - math.random(-10,10))*(math.random(10,15)), false, false, false):ToTear()
			local tear = game:Spawn( EntityType.ENTITY_TEAR, 20, player.Position, Vector.FromAngle( math.random() * 360 ):Resized(BALANCE.GOLD_HEARTS_DASH_ATTACK_SPEED), player, 0, 0):ToTear()
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
				speaker:Play( SoundEffect.SOUND_WEIRD_WORM_SPIT, 1, 0, false, 1 );
			end
		end
	end
end


function yandereWaifu.DoTinyBarrages(player, vec)
	local data = yandereWaifu.GetEntityData(player)
	SchoolbagAPI.SetFrameLoop(40,function()
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
			speaker:Play(SoundEffect.SOUND_TEARS_FIRE, 1, 0, false, 1.2)
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
	local data = entity:GetData();
	if data.REBECCA_DATA == nil then
		data.REBECCA_DATA = {};
	end
	return data.REBECCA_DATA;
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
    SAPI.game:Spawn(EntityType.ENTITY_TEAR, TearVariant, Position, Velocity, Parent, 0, 0)
    for i, entity in pairs(Isaac.GetRoomEntities()) do
        if entity.Type == EntityType.ENTITY_TEAR then
            entity = entity:ToTear()
            entity:SetColor(Color, 999, 999, true, false)
        end
    end
end

function yandereWaifu.FireBarrageTear(Position, Velocity, TearVariant, Parent, Color)
    local tear = SAPI.game:Spawn(EntityType.ENTITY_TEAR, TearVariant, Position, Velocity, Parent, 0, 0)
	
	return tear
end

--im_tem made this happen, thx
function yandereWaifu.ApplyCostumes(mode, player, reloadanm2, poof)
	if poof == nil then poof = true end
	reloadanm2=reloadanm2 or true
	if reloadanm2 then
		player:GetSprite():Load('gfx/rebekahsfluidhair.anm2',false)
	end
	local player = player or Isaac.GetPlayer(0);
	local hair = RebeccaModeCostumes[mode] --reminder to iplement eternal heart wing sprite
	player:TryRemoveNullCostume(RebekahCurseCostumes.RebeccasFate);
	player:TryRemoveNullCostume(RebekahCurseCostumes.GlitchEffect);

	--for i,costume in pairs(RebeccaModeCostumes[mode]) do
	--	--player:AddNullCostume(costume);
	--	hair = costume
	--end
	local hairpath='gfx/characters/costumes/rebekah_hair/character_'..tostring(hair)..'.png'
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
function yandereWaifu.SpawnEctoplasm( position, velocity, size, parent )
	local puddle = Isaac.Spawn( EntityType.ENTITY_EFFECT, 46, 0, position, velocity, parent):ToEffect();
	--puddle.Scale = size or 1
	--puddle:PostRender()
	SchoolbagAPI.RevelSetCreepData(puddle)
	SchoolbagAPI.RevelUpdateCreepSize(puddle, size or 1, true)
	puddle:GetData().IsEctoplasm = true;
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
	
	
	if mode == REBECCA_MODE.EternalHearts then
		yandereWaifu.RebekahCanShoot(player, false)
	else
		yandereWaifu.RebekahCanShoot(player, true)
	end
	--reset effects --KIL FIX YOUR GAMEEEEEEEEE
	--local playerEffects = player:GetEffects();
	--playerEffects:RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_20_20);
	--playerEffects:RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_HEAD_OF_THE_KEEPER);
	--playerEffects:RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_SERPENTS_KISS);
	--playerEffects:RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_FATE);

	--stat evaluation =3=
	--yandereWaifu.ApplyCollectibleEffects(player);
	yandereWaifu.ApplyCostumes( mode, player );
	--local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, ENTITY_PERSONALITYPOOF, 0, player.Position, Vector.Zero, player)
	
	--make changes to Rebecca
	player:AddCacheFlags(CacheFlag.CACHE_ALL);
	player:EvaluateItems();
end

function yandereWaifu.RebekahCanShoot(player, canShoot) --alternative so that she doesnt get a weird hair do
	local data = yandereWaifu.GetEntityData(player)
	--data.currentMode = mode;
	SchoolbagAPI.DumpySetCanShoot(player, canShoot)
	yandereWaifu.ApplyCostumes( data.currentMode, player , false , false)
end

