local function SpawnRandomReward(player)
	local rng = math.random(1,10)
	if rng == 1 then
		Isaac.Spawn( EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_CHEST, 0, ILIB.room:FindFreePickupSpawnPosition(player.Position, 1), Vector(0,0), player );
	elseif rng == 2 then
		for i = 1, math.random(3,8) do
			Isaac.Spawn( EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, 0,ILIB.room:FindFreePickupSpawnPosition(player.Position, 1), Vector(0,0), player );
		end
	elseif rng == 3 then
		for i = 1, math.random(3,5) do
			Isaac.Spawn( EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_KEY, 0, ILIB.room:FindFreePickupSpawnPosition(player.Position, 1), Vector(0,0), player );
		end
	elseif rng == 4 then
		for i = 1, math.random(3,5) do
			Isaac.Spawn( EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, 0, ILIB.room:FindFreePickupSpawnPosition(player.Position, 1), Vector(0,0), player );
		end
	elseif rng == 5 then
		for i = 1, 3 do
			Isaac.Spawn( EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_PILL, 0, ILIB.room:FindFreePickupSpawnPosition(player.Position, 1), Vector(0,0), player );
		end
	elseif rng == 6 then
		Isaac.Spawn( EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_ETERNALCHEST, 0, ILIB.room:FindFreePickupSpawnPosition(player.Position, 1), Vector(0,0), player );
	elseif rng == 7 then
		for i = 1, 3 do
			Isaac.Spawn( EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, 0, ILIB.room:FindFreePickupSpawnPosition(player.Position, 1), Vector(0,0), player );
		end
	elseif rng == 8 then
		local rng2 = math.random(1,3)
		for i = 1, 3 do
			if rng2 == 1 then
				local mob = Isaac.Spawn( EntityType.ENTITY_SLOTH, 0, 0, player.Position, Vector(0,0), player ):ToNPC();
				mob:AddEntityFlags(EntityFlag.FLAG_CHARM | EntityFlag.FLAG_FRIENDLY | EntityFlag.FLAG_PERSISTENT)
				mob.HitPoints = mob.MaxHitPoints / 2
				break
			elseif rng2 == 2 then
				local mob = Isaac.Spawn( EntityType.ENTITY_MULLIGAN, 0, 0, player.Position, Vector(0,0), player ):ToNPC();
				mob:AddEntityFlags(EntityFlag.FLAG_CHARM | EntityFlag.FLAG_FRIENDLY | EntityFlag.FLAG_PERSISTENT)
			elseif rng2 == 3 then
				local mob = Isaac.Spawn( EntityType.ENTITY_LUST, 0, 0, player.Position, Vector(0,0), player ):ToNPC();
				mob:AddEntityFlags(EntityFlag.FLAG_CHARM | EntityFlag.FLAG_FRIENDLY | EntityFlag.FLAG_PERSISTENT)
				mob.HitPoints = mob.MaxHitPoints / 2
				break
			end
		end
	elseif rng == 9 then
		for i = 1, 3 do
			Isaac.Spawn( EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_REDCHEST, 0, ILIB.room:FindFreePickupSpawnPosition(player.Position, 1), Vector(0,0), player );
		end
	elseif rng == 10 then
		Isaac.Spawn( EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_MEGACHEST, 0, ILIB.room:FindFreePickupSpawnPosition(player.Position, 1), Vector(0,0), player );
	end
end

local seedtbl = {
		[0] = {seed = SeedEffect.SEED_KAPPA, name = "Kappa", subname = "Kappa", sound = RebekahCurseSounds.SOUND_KAPPA},
		[1] = {seed = SeedEffect.SEED_CAMO_ISAAC, name = "Isaac is now hidden!", subname = "You can't see me", sound = RebekahCurseSounds.SOUND_ISAAC_HIDDEN},
		[2] = {seed = SeedEffect.SEED_CAMO_ENEMIES, name = "Foes are now hidden!", subname = "Rise above hate!", sound = RebekahCurseSounds.SOUND_FOES_HIDDEN},
		[3] = {seed = SeedEffect.SEED_CAMO_PICKUPS, name = "Loot is now hidden!", subname = "If you don't learn from your mistakes, then they become regrets", sound = RebekahCurseSounds.SOUND_LOOT_HIDDEN},
		[4] = {seed = SeedEffect.SEED_DYSLEXIA, name = "Dyslexia", subname = "a 0  jA hb a", sound = RebekahCurseSounds.SOUND_DYSLEXIA},
		[5] = {seed = SeedEffect.SEED_OLD_TV, name = "Dogma's Vision", subname = "Who's Steve?", sound = RebekahCurseSounds.SOUND_DOGMAS_VISION},
		[6] = {seed = SeedEffect.SEED_EXTRA_BLOOD, name = "More Gore!", subname = "Rip your enemies!", sound = RebekahCurseSounds.SOUND_MORE_GORE},
		[7] = {seed = SeedEffect.SEED_BIG_HEAD, name = "Megahead!", subname = "A severe lack of female companions?", sound = RebekahCurseSounds.SOUND_MEGAHEAD},
		[8] = {seed = SeedEffect.SEED_SMALL_HEAD, name = "Tinyhead", subname = "One brain cell left", sound = RebekahCurseSounds.SOUND_TINYHEAD},
		[9] = {seed = SeedEffect.SEED_BLACK_ISAAC, name = "Sillouhette", subname = "Who's that Isaac?", sound = RebekahCurseSounds.SOUND_SILLOUHETTE},
		[10] = {seed = SeedEffect.SEED_SLOW_MUSIC, name = "Relax!", subname = "Listen and chill", sound = RebekahCurseSounds.SOUND_RELAX},
		[11] = {seed = SeedEffect.SEED_ULTRA_SLOW_MUSIC, name = "Relax...", subname = "beats to relax/study to", sound = RebekahCurseSounds.SOUND_RELAX2},
		[12] = {seed = SeedEffect.SEED_FAST_MUSIC, name = "Rock on!", subname = "Gotta go fast!", sound = RebekahCurseSounds.SOUND_ROCK_ON},
		[13] = {seed = SeedEffect.SEED_ULTRA_FAST_MUSIC, name = "ROCK ON!!!", subname = "Now listen with 2x", sound = RebekahCurseSounds.SOUND_ROCK_ON2},
		[14] = {seed = SeedEffect.SEED_ICE_PHYSICS, name = "Slippery slope", subname = "Careful", sound = RebekahCurseSounds.SOUND_SLIPPERY_SLOPE},
		[15] = {seed = SeedEffect.SEED_CHRISTMAS, name = "Christmas!", subname = "On an Easter Egg?", sound = RebekahCurseSounds.SOUND_CHRISTMAS},
		[16] = {seed = SeedEffect.SEED_RETRO_VISION, name = "Retro Vision!", subname = "Again??", sound = RebekahCurseSounds.SOUND_RETRO_VISION},
		[17] = {seed = SeedEffect.SEED_PICKUPS_TIMEOUT, name = "Loot rots!", subname = "Matthew 6:19", sound = RebekahCurseSounds.SOUND_LOOT_ROTS},
		[18] = {seed = SeedEffect.SEED_SHOOT_IN_MOVEMENT_DIRECTION, name = "Bravery!", subname = "Fight fearless!", sound = RebekahCurseSounds.SOUND_BRAVERY},
		[19] = {seed = SeedEffect.SEED_SHOOT_OPPOSITE_MOVEMENT_DIRECTION, name = "Cowardice...", subname = "Fight in fear", sound = RebekahCurseSounds.SOUND_COWARDICE},
	}

local function UseRandomSeedEffect(player)
	for k, v in ipairs(seedtbl) do
		ILIB.game:GetSeeds():RemoveSeedEffect(v.seed)
	end
	local OldChallenge = player:CanShoot()
	player:ChangePlayerType(player:GetPlayerType())
	local rng = math.random(0,19)
	ILIB.game:GetSeeds():AddSeedEffect(seedtbl[rng].seed)	
	ILIB.game:GetHUD():ShowItemText(seedtbl[rng].name,seedtbl[rng].subname)
	player:ChangePlayerType(player:GetPlayerType())
	if math.random(1,2) == 2 then
		InutilLib.SFX:Play( seedtbl[rng].sound, 1, 0, false, 0.9 );
	end
	
	yandereWaifu.GetEntityData(player).PersistentPlayerData.EasterEggSeeds = seedtbl[rng].seed
	
	if not OldChallenge then 
		InutilLib.DumpySetCanShoot(player, false)
	end
	if yandereWaifu.IsNormalRebekah(player) then
		yandereWaifu.RebekahRefreshCostume(player)
	end
	
	yandereWaifu.GetEntityData(player).PersistentPlayerData.EasterEggDecreaseTick = 30
end

yandereWaifu:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_,player)
	--local player = Isaac.GetPlayer(0);
    local room = Game():GetRoom();
	local data = yandereWaifu.GetEntityData(player)
	if data.PersistentPlayerData.EasterEggSeeds then
		if not data.PersistentPlayerData.EasterEggDecreaseTick then data.PersistentPlayerData.EasterEggDecreaseTick = 1200 end
		
		data.PersistentPlayerData.EasterEggDecreaseTick = data.PersistentPlayerData.EasterEggDecreaseTick - 1
		
		print(data.PersistentPlayerData.EasterEggDecreaseTick)
		
		if data.PersistentPlayerData.EasterEggDecreaseTick <= 0 then --clear seed effect
			ILIB.game:GetSeeds():RemoveSeedEffect(data.PersistentPlayerData.EasterEggSeeds)
			
			print("did went here")
			local OldChallenge = player:CanShoot()
			player:ChangePlayerType(player:GetPlayerType())

			
			if not OldChallenge then 
				InutilLib.DumpySetCanShoot(player, false)
			end
			if yandereWaifu.IsNormalRebekah(player) then
				yandereWaifu.RebekahRefreshCostume(player)
			end
			data.PersistentPlayerData.EasterEggDecreaseTick = nil
			data.PersistentPlayerData.EasterEggSeeds = nil
		end
	end
end)

local chance = 1/4
yandereWaifu:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, function(_, pickup)
	local rng = pickup:GetDropRNG()
	for p = 0, ILIB.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		local entityData = yandereWaifu.GetEntityData(player);
		if player:HasTrinket(RebekahCurse.TRINKET_RABBITSFOOT) or REBEKAHMODE_EXPERIMENTAL.easter then
			if isEaster and player:HasTrinket(RebekahCurse.TRINKET_RABBITSFOOT) then chance = 1/2 end
			--pickup.Wait = 10;
			local validPickup = (pickup.Variant == PickupVariant.PICKUP_COIN or pickup.Variant == PickupVariant.PICKUP_KEY or pickup.Variant == PickupVariant.PICKUP_BOMB or pickup.Variant == PickupVariant.PICKUP_CHEST or pickup.Variant == PickupVariant.PICKUP_PILL)
			if rng:RandomFloat() <= (chance) and validPickup and ILIB.room:IsFirstVisit() and not pickup.Parent then
				local newpickup = yandereWaifu.SpawnEasterEgg(pickup.Position, player, 1, pickup:IsShopItem())
				--local newpickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, RebekahCurse.CARD_EASTEREGG, pickup.Position, Vector(0,0), player):ToPickup()
				newpickup.OptionsPickupIndex = pickup.OptionsPickupIndex
				pickup:Remove()
			end
		end
	end
end)


local enemytbl = {
		[0] = {type = EntityType.ENTITY_GAPER, variant = 0, subtype = 0},
		[1] = {type = EntityType.ENTITY_ATTACKFLY, variant = 0, subtype = 0},
		[2] = {type = EntityType.ENTITY_CHARGER, variant = 0, subtype = 0},
		[3] = {type = EntityType.ENTITY_CLOTTY, variant = 0, subtype = 0},
		[4] = {type = EntityType.ENTITY_HORF, variant = 0, subtype = 0},
		[5] = {type = EntityType.ENTITY_POOTER, variant = 0, subtype = 0},
		[6] = {type = EntityType.ENTITY_GAPER, variant = 1, subtype = 0},
		[7] = {type = EntityType.ENTITY_POOTER, variant = 1, subtype = 0},
		[8] = {type = EntityType.ENTITY_MAGGOT, variant = 0, subtype = 0},
		[9] = {type = EntityType.ENTITY_MAW, variant = 0, subtype = 0},
		[10] = {type = EntityType.ENTITY_MAW, variant = 1, subtype = 0},
	}


local function UseRandomAmbush(level)
	for i = 0, 7 do
		local door = ILIB.game:GetRoom():GetDoor(i)
		currentLevelIDX = ILIB.level:GetCurrentRoomDesc().GridIndex
		local rng = math.random(0,10)
		if door then
			Isaac.Spawn( enemytbl[rng].type, enemytbl[rng].variant, enemytbl[rng].subtype, ILIB.room:FindFreePickupSpawnPosition(door.Position, 1), Vector(0,0), nil );
			if door:IsOpen() then
				door:Bar()
			end
		end
	end
end

local cursetbl = {
		[1] = {curse = LevelCurse.CURSE_OF_DARKNESS, name = "Permanent Darkness", sound = RebekahCurseSounds.SOUND_CURSE_DARKNESS},
		[2] = {curse = LevelCurse.CURSE_OF_LABYRINTH, name = "Inescapable Labyrinth", sound = RebekahCurseSounds.SOUND_CURSE_LABYRINTH},
		[3] = {curse = LevelCurse.CURSE_OF_THE_LOST, name = "Hopelessly Lost", sound = RebekahCurseSounds.SOUND_CURSE_LOST},
		[4] = {curse = LevelCurse.CURSE_OF_THE_UNKNOWN, name = "Forever Unknown", sound = RebekahCurseSounds.SOUND_CURSE_UNKNOWN},
		[5] = {curse = LevelCurse.CURSE_OF_MAZE, name = "Unending Maze", sound = RebekahCurseSounds.SOUND_CURSE_MAZE},
		[6] = {curse = LevelCurse.CURSE_OF_BLIND, name = "Incurable Blindness", sound = RebekahCurseSounds.SOUND_CURSE_BLINDNESS},
		[7] = {curse = LevelCurse.CURSE_OF_THE_CURSED, name = "Horrible Curse", sound = RebekahCurseSounds.SOUND_CURSE_CURSED},
	}

local function ApplyRandomCurse(pl)
	local rng = math.random(1,6)
	if yandereWaifu.GetEntityData(pl).EasterCurse then
		ILIB.level:RemoveCurses(yandereWaifu.GetEntityData(pl).EasterCurse)
	end
	 yandereWaifu.GetEntityData(pl).EasterCurse = cursetbl[rng].curse
	 ILIB.game:GetHUD():ShowItemText(cursetbl[rng].name)
	 ILIB.level:AddCurse(yandereWaifu.GetEntityData(pl).EasterCurse)
	 InutilLib.SFX:Play( cursetbl[rng].sound, 1, 0, false, 0.9 );
end

function yandereWaifu:UseEasterEgg(card, player, flags) 
	player:ToPlayer()
	local playerdata = yandereWaifu.GetEntityData(player)
	local rng = math.random(1,10)
	
	if rng > 5 then
		UseRandomSeedEffect(player)
	else
		if rng < 4 then
			SpawnRandomReward(player)
		else
			UseRandomAmbush()
		end
	end
end

function yandereWaifu:UseEasterEgg2(card, player, flags) 
	player:ToPlayer()
	local playerdata = yandereWaifu.GetEntityData(player)
	local rng = math.random(1,10)
	
	if rng > 8 then
		UseRandomSeedEffect(player)
	else
		if rng < 7 then
			SpawnRandomReward(player)
		else
			UseRandomAmbush()
		end
	end
end

function yandereWaifu:UseCursedEgg(card, player, flags) 
	if math.random(1,3) == 3 then
		for i = 0, 2 do
			local item = Isaac.Spawn( EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, 0, ILIB.room:FindFreePickupSpawnPosition(player.Position, 1), Vector(0,0), player ):ToPickup();
			item.OptionsPickupIndex = 10
		end
	else
		ApplyRandomCurse(player)
	end
end

function yandereWaifu:UseBlessedEgg(card, player, flags) 
	Isaac.Spawn( EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, 0, ILIB.room:FindFreePickupSpawnPosition(player.Position, 1), Vector(0,0), player );
end

local goldentbl = {
		[0] = RebekahCurse.CARD_EASTEREGG,
		[1] = RebekahCurse.CARD_AQUA_EASTEREGG,
		[2] = RebekahCurse.CARD_YELLOW_EASTEREGG,
		[3] = RebekahCurse.CARD_GREEN_EASTEREGG,
		[4] = RebekahCurse.CARD_BLUE_EASTEREGG,
		[5] = RebekahCurse.CARD_PINK_EASTEREGG,

		[6] = RebekahCurse.CARD_STRIPE_EASTEREGG,
		[7] = RebekahCurse.CARD_STRIPE_AQUA_EASTEREGG,
		[8] = RebekahCurse.CARD_ZIGZAG_YELLOW_EASTEREGG,
		[9] = RebekahCurse.CARD_ZIGZAG_GREEN_EASTEREGG,
		[10] = RebekahCurse.CARD_ZIGZAG_BLUE_EASTEREGG,
		[11] = RebekahCurse.CARD_STRIPE_PINK_EASTEREGG
	}

function yandereWaifu:UseGoldenEgg(card, player, flags) 
	for i = 0, math.random(1,12) do
		InutilLib.SetTimer( i * 90, function()
			player:UseCard(goldentbl[math.random(0,11)], _)
		end)
	end
end

function yandereWaifu:EggResetGameInit(hasstarted) --Init
	if not hasstarted then
		for k, v in ipairs(seedtbl) do
			ILIB.game:GetSeeds():RemoveSeedEffect(v.seed)
		end
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, yandereWaifu.EggResetGameInit)

function yandereWaifu:EggAddCurses(curse) --Init
	for i=0, ILIB.game:GetNumPlayers()-1 do
		local pl = Isaac.GetPlayer(i)
		if yandereWaifu.GetEntityData(pl).EasterCurse then
			ILIB.level:AddCurse(yandereWaifu.GetEntityData(pl).EasterCurse)
		end
	end
end

yandereWaifu:AddCallback(ModCallbacks.MC_POST_CURSE_EVAL, yandereWaifu.EggAddCurses);

yandereWaifu:AddCallback(ModCallbacks.MC_USE_CARD, yandereWaifu.UseEasterEgg, RebekahCurse.CARD_EASTEREGG);
yandereWaifu:AddCallback(ModCallbacks.MC_USE_CARD, yandereWaifu.UseEasterEgg, RebekahCurse.CARD_AQUA_EASTEREGG);
yandereWaifu:AddCallback(ModCallbacks.MC_USE_CARD, yandereWaifu.UseEasterEgg, RebekahCurse.CARD_YELLOW_EASTEREGG);
yandereWaifu:AddCallback(ModCallbacks.MC_USE_CARD, yandereWaifu.UseEasterEgg, RebekahCurse.CARD_GREEN_EASTEREGG);
yandereWaifu:AddCallback(ModCallbacks.MC_USE_CARD, yandereWaifu.UseEasterEgg, RebekahCurse.CARD_BLUE_EASTEREGG);
yandereWaifu:AddCallback(ModCallbacks.MC_USE_CARD, yandereWaifu.UseEasterEgg, RebekahCurse.CARD_PINK_EASTEREGG);

yandereWaifu:AddCallback(ModCallbacks.MC_USE_CARD, yandereWaifu.UseEasterEgg2, RebekahCurse.CARD_STRIPE_EASTEREGG);
yandereWaifu:AddCallback(ModCallbacks.MC_USE_CARD, yandereWaifu.UseEasterEgg2, RebekahCurse.CARD_STRIPE_AQUA_EASTEREGG);
yandereWaifu:AddCallback(ModCallbacks.MC_USE_CARD, yandereWaifu.UseEasterEgg2, RebekahCurse.CARD_ZIGZAG_YELLOW_EASTEREGG);
yandereWaifu:AddCallback(ModCallbacks.MC_USE_CARD, yandereWaifu.UseEasterEgg2, RebekahCurse.CARD_ZIGZAG_GREEN_EASTEREGG);
yandereWaifu:AddCallback(ModCallbacks.MC_USE_CARD, yandereWaifu.UseEasterEgg2, RebekahCurse.CARD_ZIGZAG_BLUE_EASTEREGG);
yandereWaifu:AddCallback(ModCallbacks.MC_USE_CARD, yandereWaifu.UseEasterEgg2, RebekahCurse.CARD_STRIPE_PINK_EASTEREGG);

yandereWaifu:AddCallback(ModCallbacks.MC_USE_CARD, yandereWaifu.UseCursedEgg, RebekahCurse.CARD_CURSED_EASTEREGG);
yandereWaifu:AddCallback(ModCallbacks.MC_USE_CARD, yandereWaifu.UseBlessedEgg, RebekahCurse.CARD_BLESSED_EASTEREGG);
yandereWaifu:AddCallback(ModCallbacks.MC_USE_CARD, yandereWaifu.UseGoldenEgg, RebekahCurse.CARD_GOLDEN_EASTEREGG);


yandereWaifu:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, function(_, pickup)
	local chance = 1/16
	local rng = pickup:GetDropRNG()
	for p = 0, ILIB.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		local entityData = yandereWaifu.GetEntityData(player);
		if player:HasTrinket(RebekahCurse.TRINKET_RABBITSFOOT) then
			--pickup.Wait = 10;
			local validPickup = (pickup.Variant == PickupVariant.PICKUP_TAROTCARD and (pickup.SubType >= RebekahCurse.CARD_EASTEREGG and pickup.SubType <= RebekahCurse.CARD_PINK_EASTEREGG) )
			if rng:RandomFloat() <= (chance) and validPickup then
				local newpickup = yandereWaifu.SpawnEasterEgg(pickup.Position, player, 2)
				--local newpickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, RebekahCurse.CARD_EASTEREGG, pickup.Position, Vector(0,0), player):ToPickup()
				newpickup.OptionsPickupIndex = pickup.OptionsPickupIndex
				pickup:Remove()
			end
		end
	end
end)
