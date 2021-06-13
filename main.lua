-- Welcome to my crappy code

yandereWaifu = RegisterMod("Rebekah", 1)

local game = Game(); --Calls the Game
local speaker = SFXManager();
local Reb = Isaac.GetPlayerTypeByName("Rebekah") --Sets an ID for this -- no, this is a Christian channel now

local InnocentHair = Isaac.GetCostumeIdByPath("gfx/characters/innocenthair.anm2");
local NerdyGlasses = Isaac.GetCostumeIdByPath("gfx/characters/nerdyglasses.anm2");
local WizoobHair = Isaac.GetCostumeIdByPath("gfx/characters/wizoobhair.anm2");
local SwagHair = Isaac.GetCostumeIdByPath("gfx/characters/swaghair.anm2");
local HadFunHair = Isaac.GetCostumeIdByPath("gfx/characters/hadfunhair.anm2");
local AoDHair = Isaac.GetCostumeIdByPath("gfx/characters/angelofdeathhair.anm2");
local RebeccasFate = Isaac.GetCostumeIdByPath("gfx/characters/rebeccasfate.anm2");
local DeadHair = Isaac.GetCostumeIdByPath("gfx/characters/deadhair.anm2");
local boneStackForAnim = 0 --asks how much number is there for the anim

local BridalHair = Isaac.GetCostumeIdByPath("gfx/characters/bridalhair.anm2");
--local BridalStockings = Isaac.GetCostumeIdByPath("gfx/characters/weddedstockings.anm2");
local FulfilledFace = Isaac.GetCostumeIdByPath("gfx/characters/fulfilled.anm2");

local LovePower = Isaac.GetCostumeIdByPath("gfx/characters/love_power.anm2");
local LunchboxCos = Isaac.GetCostumeIdByPath("gfx/characters/lunchbox.anm2");
local CursedMawCos = Isaac.GetCostumeIdByPath("gfx/characters/cursedmaw.anm2");
local LoveSickCos = Isaac.GetCostumeIdByPath("gfx/characters/lovesick.anm2");
local UnsnappedCos = Isaac.GetCostumeIdByPath("gfx/characters/unsnapped.anm2");
local SnappedCos = Isaac.GetCostumeIdByPath("gfx/characters/snap.anm2");

--hud
local moveMeter = Sprite();
moveMeter:Load("gfx/special_move_meter.anm2", true);
local attackMeter = Sprite();
attackMeter:Load("gfx/special_attack_meter.anm2", true);
local bonestackMeter = Sprite();
bonestackMeter:Load("gfx/special_bonestack_meter.anm2", true);

local heartReserve = Sprite();
heartReserve:Load("gfx/ui/ui_heart_reserve.anm2", true);

-- don't potentially overwrite information in global tables, keep this local
--items
local COLLECTIBLE_LOVECANNON = Isaac.GetItemIdByName("Hugs N' Roses");

--unlockables
local COLLECTIBLE_LUNCHBOX = Isaac.GetItemIdByName("A Lunchbox");
local COLLECTIBLE_ROMCOM = Isaac.GetItemIdByName("Typical Rom-Com");
local COLLECTIBLE_MIRACULOUSWOMB = Isaac.GetItemIdByName("Miraculous Womb");
local COLLECTIBLE_ETERNALBOND = Isaac.GetItemIdByName("Eternal Bond");
local COLLECTIBLE_POWERLOVE = Isaac.GetItemIdByName("Love = Power");
local COLLECTIBLE_CURSEDSPOON = Isaac.GetItemIdByName("Cursed Spoon");
local COLLECTIBLE_DICEOFFATE = Isaac.GetItemIdByName("Dice of Fate");
local TRINKET_ISAACSLOCKS = Isaac.GetTrinketIdByName("Isaac's Locks");
local COLLECTIBLE_LOVESICK = Isaac.GetItemIdByName("Lovesick");
local COLLECTIBLE_SNAP = Isaac.GetItemIdByName("Snap!");

local COLLECTIBLE_UNREQUITEDLOVE = Isaac.GetItemIdByName("Unrequited Love");

local ENTITY_ORBITALESAU = Isaac.GetEntityVariantByName("Orbital Esau");
local ENTITY_ORBITALJACOB = Isaac.GetEntityVariantByName("Orbital Jacob");
local ENTITY_TINYFELLOW = Isaac.GetEntityTypeByName("Tiny Becca");
local ENTITY_TINYBECCA = Isaac.GetEntityVariantByName("Tiny Becca");
local ENTITY_TINYISAAC = Isaac.GetEntityVariantByName("Tiny Isaac");
local ENTITY_PHEROMONES_RING = Isaac.GetEntityVariantByName("Pheromone Ring");
local ENTITY_SNAP_HEARTBEAT = Isaac.GetEntityVariantByName("Snap Heartbeat");
local ENTITY_SNAP_EFFECT = Isaac.GetEntityVariantByName("Snap Effect");
local ENTITY_LOVEHOOK = Isaac.GetEntityVariantByName("Love Hook");
local ENTITY_CURSEDMAW = Isaac.GetEntityVariantByName("Cursed Maw");
--others
local ENTITY_ARCANE_CIRCLE = Isaac.GetEntityVariantByName("Arcane Circle");
local ENTITY_SPECIALBEAM = Isaac.GetEntityVariantByName("Special Beam");
local ENTITY_BROKEN_GLASSES = Isaac.GetEntityVariantByName("Broken Glasses");
--red heart mode
local ENTITY_ORBITALTARGET = Isaac.GetEntityVariantByName("Orbital Target");
local ENTITY_ORBITALNUKE = Isaac.GetEntityVariantByName("Nuclear Rocket");
local ENTITY_SLASH = Isaac.GetEntityVariantByName("Slash Effect");
--soul heart mode
local ENTITY_SOULTARGET = Isaac.GetEntityVariantByName("Soul Target");
local ENTITY_HAUNTEDKNIFE = Isaac.GetEntityVariantByName("Haunted Knife");
local ENTITY_ECTOPLASMA = Isaac.GetEntityVariantByName("Ectoplasma Tear");
local ENTITY_WIZOOB_MISSILE = Isaac.GetEntityVariantByName("Wizoob Missile");
local ENTITY_SBOMBBUNDLE = Isaac.GetEntityVariantByName("S. Bomb Bundle");
--gold heart mode
--local ENTITY_NED = Isaac.GetEntityTypeByName("Ned");
local ENTITY_NED_NORMAL = Isaac.GetEntityVariantByName("Ned");
local ENTITY_SQUIRENED = Isaac.GetEntityVariantByName("Ned the Squire");
local ENTITY_WIND_SLASH = Isaac.GetEntityVariantByName("Wind Slash");
local ENTITY_CHRISTIANNED = Isaac.GetEntityVariantByName("Christian Ned");
local ENTITY_SCREAMINGNED = Isaac.GetEntityVariantByName("Screaming Ned");
local ENTITY_BARBARICNED = Isaac.GetEntityVariantByName("Barbaric Ned");
local ENTITY_DEFENDINGNED = Isaac.GetEntityVariantByName("Defending Ned");
local ENTITY_SPEAR_NED = Isaac.GetEntityVariantByName("Spear Ned");
--evil heart mode
local ENTITY_ARCANE_EXPLOSION = Isaac.GetEntityVariantByName("Arcane Explosion");
local ENTITY_LABAN_STOMP = Isaac.GetEntityVariantByName("Laban Stomp");
local ENTITY_DARKBEAMINTHESKY = Isaac.GetEntityVariantByName("Dark Beam In The Sky");
local ENTITY_EVILORB = Isaac.GetEntityVariantByName("Evil Orb");
local ENTITY_HOLEFABRIC = Isaac.GetEntityVariantByName("Hole Fabric");
local ENTITY_DARKBOOM = Isaac.GetEntityVariantByName("Dark Boom");
local ENTITY_DARKBOOM2 = Isaac.GetEntityVariantByName("Dark Boom 2");
local ENTITY_DARKMAW = Isaac.GetEntityVariantByName("Dark Maw");
local ENTITY_DARKKNIFE = Isaac.GetEntityVariantByName("Dark Knife Tear");
local ENTITY_DARKKNIFEFADE = Isaac.GetEntityVariantByName("Dark Knife Tear Fade");
local ENTITY_DARKPLASMA = Isaac.GetEntityVariantByName("Dark Plasma");
local ENTITY_DARKSUPERNOVA = Isaac.GetEntityVariantByName("Dark Supernova");
--eternal heart mode
local ENTITY_ETERNALFEATHER = Isaac.GetEntityVariantByName("Eternal Feather");
local ENTITY_LIGHTBOOM = Isaac.GetEntityVariantByName("Light Boom");
local ENTITY_FEATHERBREAK = Isaac.GetEntityVariantByName("Feather Break");
local ENTITY_MORNINGSTAR = Isaac.GetEntityVariantByName("Morning Star");
--bone heart mode
local ENTITY_BONESTAND = Isaac.GetEntityVariantByName("Bone Stand");
local ENTITY_EXTRACHARANIMHELPER = Isaac.GetEntityVariantByName("Extra Character Anim Helper");
local ENTITY_BONEVAULT = Isaac.GetEntityVariantByName("Bone Vault");
local ENTITY_SLAMDUST = Isaac.GetEntityVariantByName("Slamdust Effect");
local ENTITY_BONETARGET = Isaac.GetEntityVariantByName("Bone Target");
local ENTITY_RIBTEAR = Isaac.GetEntityVariantByName("Rib Tear");
local ENTITY_SKULLTEAR = Isaac.GetEntityVariantByName("Skull Tear");
local ENTITY_HEARTTEAR = Isaac.GetEntityVariantByName("Heart Tear");
local ENTITY_RAPIDPUNCHTEAR = Isaac.GetEntityVariantByName("Rapid Punch Tear");
--bride red heart mode
local ENTITY_LABAN = Isaac.GetEntityVariantByName("Best Man");
--misc
local ENTITY_HEARTPOOF = Isaac.GetEntityVariantByName("Heart Poof");
local ENTITY_HEARTPARTICLE = Isaac.GetEntityVariantByName("Heart Particle");
local ENTITY_REBMIRROR = Isaac.GetEntityVariantByName("Rebecca's Mirror");

local SOUND_REBHURT = Isaac.GetSoundIdByName("RebekahHurt")
local SOUND_REBDIE = Isaac.GetSoundIdByName("RebekahDie")

local SOUND_CHRISTIAN_CHANT = Isaac.GetSoundIdByName("Christian Chant")
local SOUND_CHRISTIAN_OVERTAKE = Isaac.GetSoundIdByName("Christian Overtake")
local SOUND_CHRISTIAN_READ = Isaac.GetSoundIdByName("Christian Read")
local SOUND_BARBARIAN_LAUGH = Isaac.GetSoundIdByName("Barbarian Laugh")
local SOUND_BARBARIAN_GRUNT = Isaac.GetSoundIdByName("Barbarian Grunt")
local SOUND_SCREAMING_SCREAM = Isaac.GetSoundIdByName("Screaming Scream")
local SOUND_STRIKE = Isaac.GetSoundIdByName("Metal Strike")
local SOUND_RATTLEARMOR = Isaac.GetSoundIdByName("Armor Rattle")

local SOUND_LASEREXPLOSION = Isaac.GetSoundIdByName("Laser Explosion")
local SOUND_DEEPELECTRIC = Isaac.GetSoundIdByName("Deep Electricity")
local SOUND_ELECTRIC = Isaac.GetSoundIdByName("Electricity")
local SOUND_PUNCH = Isaac.GetSoundIdByName("Punch Effect")

local BALANCE = {
	INIT_REMOVE_HEARTS = 2,
	RED_HEARTS_DASH_SPEED = 15,
	RED_HEARTS_DASH_INVINCIBILITY_FRAMES = 10,
	RED_HEARTS_DASH_COOLDOWN = 40, --15
	RED_HEART_ATTACK_BRIMSTONE_SIZE = 15,
	ETERNAL_HEARTS_DASH_SPEED = 20,
	ETERNAL_HEARTS_DASH_INVINCIBILITY_FRAMES = 10,
	ETERNAL_HEARTS_DASH_COOLDOWN = 110, --55
	ETERNAL_HEARTS_DASH_ATTACK_COUNTDOWN = 7,
	ETERNAL_HEARTS_DASH_FEATHER_SPEED = 5,
	SOUL_HEARTS_DASH_COOLDOWN = 120, --120
	SOUL_HEARTS_DASH_INVINCIBILITY_FRAMES = 35,
	SOUL_HEARTS_DASH_RETAINS_VELOCITY = true,
	SOUL_HEARTS_DASH_TARGET_SPEED = 3,
	GOLD_HEARTS_DASH_KNOCKBACK_RANGE = 50,
	GOLD_HEARTS_DASH_COOLDOWN = 120, --60
	GOLD_HEARTS_DASH_INVINCIBILITY_FRAMES = 15,
	GOLD_HEARTS_DASH_ATTACK_SPEED = 5,
	EVIL_HEARTS_DASH_COOLDOWN = 90, --60
	EMPTY_EVIL_HEARTS_DASH_COOLDOWN = 30,
	EVIL_HEARTS_DASH_SPEED = 5,
	EVIL_HEARTS_DASH_INVINCIBILITY_FRAMES = 0,
	BONE_HEARTS_DASH_COOLDOWN = 80, --80
	BONE_HEARTS_DASH_INVINCIBILITY_FRAMES = 25,
	BONE_HEARTS_MODIFIED_DASH_COOLDOWN = 150, --150
	BONE_HEARTS_MODIFIED_DASH_INVINCIBILITY_FRAMES = 160,
	BONE_HEARTS_VAULT_VELOCITY = 6,
	BONE_HEARTS_DASH_TARGET_SPEED = 3,
	BRIDE_RED_HEARTS_DASH_SPEED = 25
}

local OPTIONS = {
	CUSTOM_DAMAGE_SOUND = true,
	CUSTOM_DAMAGE_SOUND_ID = SoundEffect.SOUND_CUTE_GRUNT,
	CUSTOM_DAMAGE_SOUND_PITCH = 1.4,
	CUSTOM_DEATH_SOUND = true,
	CUSTOM_DEATH_SOUND_ID = SoundEffect.SOUND_CHILD_ANGRY_ROAR,
	CUSTOM_DEATH_SOUND_PITCH = 0.75,
	-- for when you don't have enough hp to perform a special attack, how soon after you can try again
	FAILED_SPECIAL_ATTACK_COOLDOWN = 0.4,
	HOLD_DROP_FOR_SPECIAL_ATTACK = true,
	SPECIAL_SWITCH_COOLDOWN = 0.3,
	-- save every 10 seconds (30 fps) (really you should only save per floor or on exit, as the game only saves at those times)
	SAVE_INTERVAL = 30 * 5,
	-- set to 90 to only allow cardinals like the previous behaviour, 45 to allow 8 directions like analog
	-- affects both dash and special attack
	DOUBLE_TAP_ANGLE_ROUNDING = 1
}

local REBECCA_MODE = {
	RedHearts = 1,
	SoulHearts = 2,
	EternalHearts = 3,
	GoldHearts = 4,
	EvilHearts = 5,
	BoneHearts = 6,
	RottenHearts = 7,
	BrokenHearts = 8,
	
	BrideRedHearts = 12
}

local RebeccaModeCostumes = {
	[REBECCA_MODE.RedHearts] = "innocenthair", --InnocentHair,
	[REBECCA_MODE.SoulHearts] = "wizoobhair", --WizoobHair,
	[REBECCA_MODE.GoldHearts] = "swaghair", --SwagHair,
	[REBECCA_MODE.EvilHearts] = "hadfunhair", --HadFunHair,
	[REBECCA_MODE.EternalHearts] = "angelofdeathhair", --AoDHair,
	[REBECCA_MODE.BoneHearts] =  "deadhair", --DeadHair,
	[REBECCA_MODE.RottenHearts] =  "crazyhair",
	[REBECCA_MODE.BrokenHearts] =  "fourthwallhair",
	[REBECCA_MODE.BrideRedHearts] = "bridalhair" --BridalHair
}

local RebeccaModeEffects = {
	[REBECCA_MODE.RedHearts] = CollectibleType.COLLECTIBLE_20_20,
	--[REBECCA_MODE.SoulHearts] = N/A,
	[REBECCA_MODE.GoldHearts] = CollectibleType.COLLECTIBLE_HEAD_OF_THE_KEEPER,
	[REBECCA_MODE.EvilHearts] = CollectibleType.COLLECTIBLE_SERPENTS_KISS,
	[REBECCA_MODE.EternalHearts] = CollectibleType.COLLECTIBLE_FATE,
	[REBECCA_MODE.BoneHearts] = CollectibleType.COLLECTIBLE_COMPOUND_FRACTURE,
	
	[REBECCA_MODE.BrideRedHearts] = CollectibleType.COLLECTIBLE_20_20
}

local HeartParticleType = {
	None = 0,
	Red = 1,
	Blue = 2,
	Soul = 2,
	Gold = 3,
	Black = 4,
	Evil = 4,
	Eternal = 5,
	White = 5,
	Bone = 6
}

local HeartParticleSpriteByType = {
	[HeartParticleType.Red] = "gfx/effects/heart_red.png",
	[HeartParticleType.Blue] = "gfx/effects/heart_blue.png",
	[HeartParticleType.Soul] = "gfx/effects/heart_blue.png",
	[HeartParticleType.Gold] = "gfx/effects/heart_gold.png",
	[HeartParticleType.Black] = "gfx/effects/heart_black.png",
	[HeartParticleType.Evil] = "gfx/effects/heart_black.png",
	[HeartParticleType.White] = "gfx/effects/heart_eternal.png",
	[HeartParticleType.Eternal] = "gfx/effects/heart_eternal.png",
	[HeartParticleType.Bone] = "gfx/effects/heart_bone.png"
}

local HeartParticleTypeByMode = {
	[REBECCA_MODE.RedHearts] = HeartParticleType.Red,
	[REBECCA_MODE.SoulHearts] = HeartParticleType.Blue,
	[REBECCA_MODE.GoldHearts] = HeartParticleType.Gold,
	[REBECCA_MODE.EvilHearts] = HeartParticleType.Evil,
	[REBECCA_MODE.EternalHearts] = HeartParticleType.Eternal,
	[REBECCA_MODE.BoneHearts] = HeartParticleType.Bone
}

local PoofParticleType = {
	None = 0,
	Red = 1,
	Blue = 2,
	Soul = 2,
	Gold = 3,
	Black = 4,
	Evil = 4,
	Eternal = 5,
	White = 5,
	Bone = 6
}

local PoofParticleSpriteByType = {
	[PoofParticleType.Red] = "gfx/effects/poof_red.png",
	[PoofParticleType.Blue] = "gfx/effects/poof_blue.png",
	[PoofParticleType.Soul] = "gfx/effects/poof_blue.png",
	[PoofParticleType.Gold] = "gfx/effects/poof_gold.png",
	[PoofParticleType.Black] = "gfx/effects/poof_black.png",
	[PoofParticleType.Evil] = "gfx/effects/poof_black.png",
	[PoofParticleType.Eternal] = "gfx/effects/poof_eternal.png",
	[PoofParticleType.White] = "gfx/effects/poof_eternal.png",
	[PoofParticleType.Bone] = "gfx/effects/poof_bone.png"
}

local PoofParticleTypeByMode = {
	[REBECCA_MODE.RedHearts] = PoofParticleType.Red,
	[REBECCA_MODE.SoulHearts] = PoofParticleType.Blue,
	[REBECCA_MODE.GoldHearts] = PoofParticleType.Gold,
	[REBECCA_MODE.EvilHearts] = PoofParticleType.Evil,
	[REBECCA_MODE.EternalHearts] = PoofParticleType.Eternal,
	[REBECCA_MODE.BoneHearts] = PoofParticleType.Bone
}

local MirrorHeartDrop = {
	[1] = 1, --red
	[2] = 3, --soul
	[3] = 4, --eternal
	[4] = 6, --evil
	[5] = 7, --gold
	[6] = 11 --bone
}

---------------
-- UNLOCKS!! --
---------------

--boolean item stuff
local BaseRebeccaUnlocks = {
	COLLECTIBLE_LUNCHBOX = false,
	COLLECTIBLE_ROMCOM = false,
	COLLECTIBLE_MIRACULOUSWOMB = false,
	COLLECTIBLE_ETERNALBOND = false,
	COLLECTIBLE_POWERLOVE = false,
	COLLECTIBLE_CURSEDSPOON = false,
	COLLECTIBLE_DICEOFFATE = false,
	TRINKET_ISAACSLOCKS = false,
	COLLECTIBLE_LOVESICK = false,
	COLLECTIBLE_SNAP = false,
	HAS_LOVERS_CARD = false,

	COLLECTIBLE_UNREQUITEDLOVE = false
}

local CurrentRebeccaUnlocks = nil


--local lastSaveTime = 0;
--local moveMeterFadeStartFrame = 0;
--local attackMeterFadeStartFrame = 0;
--local bonestackMeterFadeStartFrame = 0;

local hasInit = false;
--local currentMode = REBECCA_MODE.RedHearts;
local bossRoomsCleared = {};
local didKillSatan = false

JSON = require("json");
--schoolbagapi = require "!SchoolbagAPIext.main";

--local DASH_DOUBLE_TAP = SchoolbagAPI.DoubleTap:New();
--local ATTACK_DOUBLE_TAP = SchoolbagAPI.DoubleTap:New();

local REBECCA_INFO = SchoolbagAPI.Players:New({}, Reb, SOUND_REBHURT, SOUND_REBDIE, {SchoolbagAPI.DefaultInstructions, "gfx/backdrop/controls_rebecca_extra.png"});

local function GetEntityData( entity )
	local data = entity:GetData();
	if data.REBECCA_DATA == nil then
		data.REBECCA_DATA = {};
	end
	return data.REBECCA_DATA;
end

local function GetMainEFetusTarget( target , player )
	local mainTarget
	if target.Parent.Variant == EntityType.ENTITY_PLAYER then
		local player = target.Parent:ToPlayer();
		mainTarget = player:GetActiveWeaponEntity();
	end
	return mainTarget
end

local function GetOwnerOfEFetusMainTarget()
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

local function RandomHeartParticleVelocity()
	return Vector.FromAngle( math.random() * 360 ):Resized( math.random() * 6 + 2 );
end

local function GetPlayerBlackHearts(player) -- Kilburn's code thingy that came from SOul Heart Rebalnce mod thingy that happens to be authored by Cucco. SO uhm, thanks Cucco and Kilburn or both of ya!
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
local function FireKeeperTear(Position, Velocity, TearVariant, Parent, Color)
    local getPlayer = Isaac.GetPlayer(0)
    game:Spawn(EntityType.ENTITY_TEAR, TearVariant, Position, Velocity, Parent, 0, 0)
    for i, entity in pairs(Isaac.GetRoomEntities()) do
        if entity.Type == EntityType.ENTITY_TEAR then
            entity = entity:ToTear()
            entity:SetColor(Color, 999, 999, true, false)
        end
    end
end

local function FireBarrageTear(Position, Velocity, TearVariant, Parent, Color)
    local getPlayer = Isaac.GetPlayer(0)
    game:Spawn(EntityType.ENTITY_TEAR, TearVariant, Position, Velocity, Parent, 0, 0)
    for i, entity in pairs(Isaac.GetRoomEntities()) do
        if entity.Type == EntityType.ENTITY_TEAR then
            --entity = entity:ToTear()
            --entity:SetColor(Color, 999, 999, true, false)
        end
    end
end

--im_tem made this happen, thx
local function ApplyCostumes(mode, player, reloadanm2)
	reloadanm2=reloadanm2 or true
	if reloadanm2 then
		player:GetSprite():Load('gfx/rebekahsfluidhair.anm2',false)
	end
	local player = player or Isaac.GetPlayer(0);
	local hair = RebeccaModeCostumes[mode] --reminder to iplement eternal heart wing sprite
	player:TryRemoveNullCostume(RebeccasFate);
	
	--for i,costume in pairs(RebeccaModeCostumes[mode]) do
	--	--player:AddNullCostume(costume);
	--	hair = costume
	--end
	local hairpath='gfx/characters/costumes/rebekah_hair/character_'..tostring(hair)..'.png'
	if mode == REBECCA_MODE.SoulHearts then --special interacts
		if GetEntityData(player).SoulBuff then
			hairpath='gfx/characters/costumes/rebekah_hair/character_wizoobopenhair.png'
		end
	elseif mode == REBECCA_MODE.EternalHearts then
		player:AddNullCostume(RebeccasFate);
	end
	local config=Isaac.GetItemConfig():GetNullItem(7)
	player:GetSprite():ReplaceSpritesheet(15,hairpath)		--loading the hairstyle for layer 15
	player:GetSprite():ReplaceSpritesheet(17,hairpath)		--for layer 17 too because of some anims
	player:GetSprite():LoadGraphics() 						--loading graphics is required
	player:ReplaceCostumeSprite(config,hairpath,0)	--replacing eve hair costume sprite for fire anims
	--GetEntityData(player).hairpath = hairpath
end


local function SpawnParticles( type, variant, subvariant, amount, position, velocity, spawner, spriteSheet )
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

local function SpawnHeartParticles( minimum, maximum, position, velocity, spawner, heartType )
	local particles = SpawnParticles( EntityType.ENTITY_EFFECT, ENTITY_HEARTPARTICLE, 0, math.random( minimum, maximum ), position, velocity, spawner, HeartParticleSpriteByType[heartType] );
	for i,particle in ipairs(particles) do
		local size = math.random(1,3);
		local data = GetEntityData( particle );
		if size == 1 then
			if not data.Large then data.Large = true end
		elseif size == 2 then
			if not data.Small then data.Small = true end
		end
		particle:GetSprite():Stop();
	end
end

local function SpawnPoofParticle( position, velocity, spawner, poofType )
	local particles = SpawnParticles( EntityType.ENTITY_EFFECT, ENTITY_HEARTPOOF, 0, 1, position, velocity, spawner, PoofParticleSpriteByType[poofType] );
	return particles[1];
end

-- spawn poof based on spawner velocity
local function SpawnDashPoofParticle( position, velocity, spawner, poofType )
	local particles = SpawnParticles( EntityType.ENTITY_EFFECT, ENTITY_HEARTPOOF, 0, 1, position, velocity, spawner, PoofParticleSpriteByType[poofType] );
	local poof = particles[1];
	local poofSprite = poof:GetSprite();
	poofSprite.Scale = Vector( 0.6, 0.6 );
	poofSprite.Rotation = spawner.Velocity:Rotated(-90):GetAngleDegrees();
	return poof;
end

---spawn ectoplasm in one place
local function SpawnEctoplasm( position, velocity, size, parent )
	local puddle = Isaac.Spawn( EntityType.ENTITY_EFFECT, 46, 0, position, velocity, parent):ToEffect();
	puddle.Scale = size or 1
	puddle:PostRender()
	puddle:GetData().IsEctoplasm = true;
end

local function ChangeMode( player, mode, free, fanfare )
	local data = GetEntityData(player)
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
		elseif mode == REBECCA_MODE.BrokenHearts then
			player:AddBrokenHearts(-1);
		end
	end
	yandereWaifu:resetReserve(player)
	if mode == REBECCA_MODE.RedHearts then
		data.heartReserveMaxFill = 100
	elseif mode == REBECCA_MODE.SoulHearts then
		data.heartReserveMaxFill = 120
	elseif mode == REBECCA_MODE.GoldHearts then
		data.heartReserveMaxFill = 50
	elseif mode == REBECCA_MODE.EvilHearts then
		data.heartReserveMaxFill = 140
	elseif mode == REBECCA_MODE.EternalHearts  then
		data.heartReserveMaxFill = 80
	elseif mode == REBECCA_MODE.BoneHearts then
		data.heartReserveMaxFill = 100
	end

	if fanfare ~= false then
		SpawnPoofParticle( player.Position + Vector( 0, 1 ), Vector( 0, 0 ), player, PoofParticleTypeByMode[ mode ] );
	end

	--reset effects --KIL FIX YOUR GAMEEEEEEEEE
	--local playerEffects = player:GetEffects();
	--playerEffects:RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_20_20);
	--playerEffects:RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_HEAD_OF_THE_KEEPER);
	--playerEffects:RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_SERPENTS_KISS);
	--playerEffects:RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_FATE);

	--stat evaluation =3=
	yandereWaifu:ApplyCollectibleEffects();
	ApplyCostumes( mode, player );

	--make changes to Rebecca
	player:AddCacheFlags(CacheFlag.CACHE_ALL);
	player:EvaluateItems();
end

local function RebekahCanShoot(player, canShoot) --alternative so that she doesnt get a weird hair do
	local data = GetEntityData(player)
	--data.currentMode = mode;
	SchoolbagAPI.DumpySetCanShoot(player, canShoot)
	ApplyCostumes( data.currentMode, player )
end

local function BasicRebeccaInit(player, mode) --sets up basic attributes for Rebekah
	local data = GetEntityData(player)
	if mode then data.currentMode = mode else data.currentMode = nil end
	--player:AddNullCostume(NerdyGlasses)
	
	--data.currentMode = REBECCA_MODE.RedHearts
	--player:AddCacheFlags (CacheFlag.CACHE_ALL);
	--player:EvaluateItems();
	
	--heart reserve
	data.heartReserveFill = 0
	data.heartReserveMaxFill = 0 
	data.heartStocks = 0
	
	data.DASH_DOUBLE_TAP:Reset();
end


local function RebeccaInit(player)
	local data = GetEntityData(player)
	--player:AddNullCostume(NerdyGlasses)
	player:AddHearts(-BALANCE.INIT_REMOVE_HEARTS);
	
	--data.currentMode = REBECCA_MODE.RedHearts
	--player:AddCacheFlags (CacheFlag.CACHE_ALL);
	--player:EvaluateItems();
	
	--heart reserve
	
	BasicRebeccaInit(player)
	
	ChangeMode( player, REBECCA_MODE.RedHearts, true );
	yandereWaifu:AddRandomHeart(player)
	
	data.ATTACK_DOUBLE_TAP:Reset();
	
	if CurrentRebeccaUnlocks == nil then CurrentRebeccaUnlocks = BaseRebeccaUnlocks end
	if CurrentRebeccaUnlocks.HAS_LOVERS_CARD then --MEGA STAN UNLOCK
		player:AddCard(Card.CARD_LOVERS)
	end
	
	player:SetPocketActiveItem(COLLECTIBLE_LOVECANNON)
end


yandereWaifu:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, function(self, player)
	if player:GetPlayerType() == Reb then
		local data = GetEntityData(player)
		
		--personalized doubletap classes
		data.DASH_DOUBLE_TAP = SchoolbagAPI.DoubleTap:New();
		data.ATTACK_DOUBLE_TAP = SchoolbagAPI.DoubleTap:New();
		-- start the meters invisible
		data.moveMeterFadeStartFrame = -20;
		data.attackMeterFadeStartFrame = -20;
		data.bonestackMeterFadeStartFrame = 0;
		
		RebeccaInit(player)
		--ApplyCostumes( data.currentMode, player );
		
		if not data.NoBoneSlamActive then data.NoBoneSlamActive = true end
	end
end)

local function Init(force)
	if force == true then
		for i,player in ipairs(SAPI.players) do
			Isaac.DebugString("1")
			hasInit = true;
			
			bossRoomsCleared = {};
			--lastSaveTime = 0;
			--RebeccaInit(player)

			Isaac.DebugString("4")
			
			Isaac.DebugString("5")
			didKillSatan = false
			
		end
	end
end



local function RecapRebekahData()
	local saveData = {}
	saveData.currentMode = {};
	saveData.NedHealth = {} -- first ned
	for i,player in ipairs(SAPI.players) do
		if player:GetPlayerType() == Reb then
			saveData.currentMode[i] = GetEntityData(player).currentMode
		else
			saveData.currentMode[i] = nil
		end
		for c, ned in pairs( Isaac.FindByType(EntityType.ENTITY_FAMILIAR, -1, -1, false, false) ) do
		--check for knights health
			if ned.Variant == ENTITY_NED_NORMAL or ned.Variant == ENTITY_SQUIRENED then 
				local tbl = {}
				if not saveData.NedHealth[i] then saveData.NedHealth[i] = {} end
				
				local name = tonumber(ned.Variant..ned.SubType)
				print(name)
				--if not tbl[name] then tbl[name] = {} end
				
				if GetPtrHash(player) == GetPtrHash(ned:ToFamiliar().Player) then
				--	table.insert(saveData.NedHealth[i][name], GetEntityData(ned).Health)
				end
			end
		end
	end
	saveData.bossRoomsCleared = bossRoomsCleared;
	saveData.unlocks = CurrentRebeccaUnlocks;
	
	return saveData
end

local function IsRebekahPlayer(player)
	if player:GetPlayerType() == Reb or player.GetPlayerTypeByName == Isaac.GetPlayerTypeByName("Isaac") then
		return true
	else
		return false
	end
end

-- Load Moddata
yandereWaifu:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function()
	local data = JSON.decode(Isaac.LoadModData(yandereWaifu));
	if data ~= nil then
		if data.currentMode ~= nil then 
			for i,player in ipairs(SAPI.players) do
				if player:GetPlayerType() == Reb then
					GetEntityData(player).currentMode = data.currentMode[i]
				end
			end
		end
		--this is being called a lot if theres a lot of players, I feel like i should change this
		if data.bossRoomsCleared ~= nil then bossRoomsCleared = data.bossRoomsCleared end
		if data.unlocks ~= nil then CurrentRebeccaUnlocks = data.unlocks end
		
		if data.NedHealth then
			--for i,player in ipairs(SAPI.players) do
			--	for c, ned in pairs( Isaac.FindByType(EntityType.ENTITY_FAMILIAR, -1, -1, false, false) ) do
			--	local name = tonumber(ned.Variant..ned.SubType)
			--	print(name)
				--check for knights health
			--		if ned.Variant == ENTITY_NED_NORMAL or ned.Variant == ENTITY_SQUIRENED then 
			--			if GetPtrHash(player) == GetPtrHash(ned:ToFamiliar().Player) then
			--				GetEntityData(ned).Health = data.NedHealth[i][name][c]
			--			end
			--		end
			--	end
			--end
		end
	end
end)

-- Save Moddata
-- this doesn't need to be called every frame and especially not for characters that aren't rebecca
function yandereWaifu:Save()
	local saveData = RecapRebekahData()
	Isaac.SaveModData(yandereWaifu, JSON.encode( saveData ) );
end

yandereWaifu:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
	yandereWaifu:Save()
end)
yandereWaifu:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, function(_, boo)
	if boo then
		yandereWaifu:Save()
	end
end)
yandereWaifu:AddCallback(ModCallbacks.MC_POST_GAME_END, function(_, boo)
	currentMode = nil;
	yandereWaifu:Save()
end)

function yandereWaifu:RebeccaGameInit(hasstarted) --Init
	for i,player in ipairs(SAPI.players) do
		if player:GetPlayerType() == Reb then
		-- this was commented out as it seems to be a bug that allows players to gain 20/20 when in different modes when continuing a run
		--player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_20_20, false)
			-- if it's a new run
			if not hasstarted then
				Init(true);
			end

		print("ffff", GetEntityData(player).currentMode)
		ApplyCostumes( GetEntityData(player).currentMode, player, false )
		player:AddCacheFlags(CacheFlag.CACHE_ALL);
		player:EvaluateItems()
		--fix again later
		if not GetEntityData(player).NoBoneSlamActive then GetEntityData(player).NoBoneSlamActive = true end
		end
    end
end
yandereWaifu:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, yandereWaifu.RebeccaGameInit)


--got an idea from community remix. thx

--delirium check
local deliriumWasInRoom = false
yandereWaifu:AddCallback(ModCallbacks.MC_POST_NPC_INIT, function(_, npc)
	deliriumWasInRoom = true
end, EntityType.ENTITY_DELIRIUM)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	deliriumWasInRoom = false
	--local deliriumCount = Isaac.CountEntities(nil, EntityType.ENTITY_DELIRIUM, -1, -1)
	--if deliriumCount then
	--	if deliriumCount > 0 then
	--		deliriumWasInRoom = true
	--	end
	--end
end)


function yandereWaifu:CheckIfAllUnlocksTrue()
	local unlockAll = true
	if CurrentRebeccaUnlocks then
		for i, v in pairs(CurrentRebeccaUnlocks) do
			if v == false and tostring(i) ~= "COLLECTIBLE_UNREQUITEDLOVE" then
				unlockAll = false
				break
				
			end
		end
	end
	return unlockAll
end

local bossRushWasCompleted = false
local ultraGreedWasDefeated = false
local roomWasCleared = false

yandereWaifu:AddCallback(ModCallbacks.MC_POST_UPDATE, function()

	local room = game:GetRoom()
	local roomIsClear = room:IsClear()
	
	local currentStage = game:GetLevel():GetStage()
	local roomType = room:GetType()
	
	for i,player in ipairs(SAPI.players) do
		if player:GetPlayerType() == Reb and CurrentRebeccaUnlocks then
			
			if game:IsGreedMode() then
				if not ultraGreedWasDefeated then
					if currentStage == LevelStage.STAGE7_GREED then
						if not roomWasCleared and roomIsClear and roomType == RoomType.ROOM_BOSS and room:IsCurrentRoomLastBoss() then
							if not CurrentRebeccaUnlocks.COLLECTIBLE_POWERLOVE then --greed
								CurrentRebeccaUnlocks.COLLECTIBLE_POWERLOVE = true

								SchoolbagAPI.AnimateIsaacAchievement("gfx/ui/achievements/achievement_love_power.png", nil, true)
							end
							if game.Difficulty == Difficulty.DIFFICULTY_GREEDIER then --ier
								if not CurrentRebeccaUnlocks.COLLECTIBLE_LOVESICK then
									CurrentRebeccaUnlocks.COLLECTIBLE_LOVESICK = true

									SchoolbagAPI.AnimateIsaacAchievement("gfx/ui/achievements/achievement_lovesick.png", nil, true)
								end
							end
						end
					end
				end
			else
				--do boss rush unlock
				if not bossRushWasCompleted then
					if roomType == RoomType.ROOM_BOSSRUSH and room:IsAmbushDone() then
						if not CurrentRebeccaUnlocks.COLLECTIBLE_LUNCHBOX then
							CurrentRebeccaUnlocks.COLLECTIBLE_LUNCHBOX = true

							SchoolbagAPI.AnimateIsaacAchievement("gfx/ui/achievements/achievement_lunchbox.png", nil, true)
						end
					end
				end
				
				--do other unlocks if the other methods didnt work
				if not roomWasCleared and roomIsClear and roomType == RoomType.ROOM_BOSS then
					local currentStageType = game:GetLevel():GetStageType()
					local curses =	game:GetLevel():GetCurses()
					
					if currentStage == 8 or (currentStage == 7 and curses & LevelCurse.CURSE_OF_LABYRINTH ~= 0 and room:IsCurrentRoomLastBoss()) then --womb 2
						if not CurrentRebeccaUnlocks.COLLECTIBLE_MIRACULOUSWOMB then
							CurrentRebeccaUnlocks.COLLECTIBLE_MIRACULOUSWOMB = true

							SchoolbagAPI.AnimateIsaacAchievement("gfx/ui/achievements/achievement_miraculous_womb.png", nil, true)
						end
					elseif currentStage == 10 then
						if currentStageType == 1 then --cathedral
							if not CurrentRebeccaUnlocks.COLLECTIBLE_DICEOFFATE then
								CurrentRebeccaUnlocks.COLLECTIBLE_DICEOFFATE = true

								SchoolbagAPI.AnimateIsaacAchievement("gfx/ui/achievements/achievement_dice_of_fate.png", nil, true)
							end
						elseif currentStageType == 0 then --sheol
							if not CurrentRebeccaUnlocks.COLLECTIBLE_CURSEDSPOON then
								CurrentRebeccaUnlocks.COLLECTIBLE_CURSEDSPOON = true

								SchoolbagAPI.AnimateIsaacAchievement("gfx/ui/achievements/achievement_cursed_spoon.png", nil, true)
							end
						end
					elseif currentStage == 11 then
						local backdrop = room:GetBackdropType()
						if backdrop == 18 then --mega satan arena
							if not CurrentRebeccaUnlocks.HAS_LOVERS_CARD then
								CurrentRebeccaUnlocks.HAS_LOVERS_CARD = true

								SchoolbagAPI.AnimateIsaacAchievement("gfx/ui/achievements/achievement_rebekahsfatesealed.png", nil, true)
							end
						elseif currentStageType == 1 then --chest
							if not CurrentRebeccaUnlocks.COLLECTIBLE_ETERNALBOND then
								CurrentRebeccaUnlocks.COLLECTIBLE_ETERNALBOND = true

								SchoolbagAPI.AnimateIsaacAchievement("gfx/ui/achievements/achievement_eternal_bond.png", nil, true)
							end
						elseif currentStageType == 0 then --dark room
							if not CurrentRebeccaUnlocks.TRINKET_ISAACSLOCKS then
								CurrentRebeccaUnlocks.TRINKET_ISAACSLOCKS = true

								SchoolbagAPI.AnimateIsaacAchievement("gfx/ui/achievements/achievement_isaacs_locks.png", nil, true)
							end
						end
					elseif currentStage == 9 then --blue womb
						if not CurrentRebeccaUnlocks.COLLECTIBLE_ROMCOM then
							CurrentRebeccaUnlocks.COLLECTIBLE_ROMCOM = true

							SchoolbagAPI.AnimateIsaacAchievement("gfx/ui/achievements/achievement_typical_romcom.png", nil, true)
						end
					elseif currentStage == 12 then --the void
						if deliriumWasInRoom then
							if not CurrentRebeccaUnlocks.COLLECTIBLE_SNAP then
								CurrentRebeccaUnlocks.COLLECTIBLE_SNAP = true

								SchoolbagAPI.AnimateIsaacAchievement("gfx/ui/achievements/achievement_snap.png", nil, true)
							end
		
						end
					end
				end
			end
			if not roomWasCleared and roomIsClear then
				local istrue = yandereWaifu:CheckIfAllUnlocksTrue()
				if not CurrentRebeccaUnlocks.COLLECTIBLE_UNREQUITEDLOVE and istrue then --EVERYONE
					CurrentRebeccaUnlocks.COLLECTIBLE_UNREQUITEDLOVE = true

					SchoolbagAPI.AnimateIsaacAchievement("gfx/ui/achievements/achievement_unrequited_love.png", nil, true)
				end
			end
		end
	end
	roomWasCleared = roomIsClear
end)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(_, isSaveGame)
	bossRushWasCompleted = false
	ultraGreedWasDefeated = false
end)

--item pool unlockables!
yandereWaifu:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	local itemPool = game:GetItemPool()
	if CurrentRebeccaUnlocks then
		if not CurrentRebeccaUnlocks.COLLECTIBLE_LUNCHBOX then --boss rush
			itemPool:RemoveCollectible(COLLECTIBLE_LUNCHBOX)
		end
		if not CurrentRebeccaUnlocks.COLLECTIBLE_MIRACULOUSWOMB then --it lives
			itemPool:RemoveCollectible(COLLECTIBLE_MIRACULOUSWOMB)
		end
		if not CurrentRebeccaUnlocks.COLLECTIBLE_CURSEDSPOON then --satan
			itemPool:RemoveCollectible(COLLECTIBLE_CURSEDSPOON)
		end
		if not CurrentRebeccaUnlocks.COLLECTIBLE_DICEOFFATE then --isaac
			itemPool:RemoveCollectible(COLLECTIBLE_DICEOFFATE)
		end
		if not CurrentRebeccaUnlocks.TRINKET_ISAACSLOCKS then --lamb
			itemPool:RemoveTrinket(TRINKET_ISAACSLOCKS)
		end
		if not CurrentRebeccaUnlocks.COLLECTIBLE_ETERNALBOND then --???
			itemPool:RemoveCollectible(COLLECTIBLE_ETERNALBOND)
		end
		if not CurrentRebeccaUnlocks.COLLECTIBLE_POWERLOVE then --greed
			itemPool:RemoveCollectible(COLLECTIBLE_POWERLOVE)
		end
		if not CurrentRebeccaUnlocks.COLLECTIBLE_LOVESICK then --ier
			itemPool:RemoveCollectible(COLLECTIBLE_LOVESICK)
		end
		if not CurrentRebeccaUnlocks.COLLECTIBLE_ROMCOM then --hush
			itemPool:RemoveCollectible(COLLECTIBLE_ROMCOM)
		end
		if not CurrentRebeccaUnlocks.COLLECTIBLE_SNAP then --delirium
			itemPool:RemoveCollectible(COLLECTIBLE_SNAP)
		end
		
		if not CurrentRebeccaUnlocks.COLLECTIBLE_UNREQUITEDLOVE then --IF ALL
			itemPool:RemoveCollectible(COLLECTIBLE_UNREQUITEDLOVE)
		end
	end
end)

--stuff to check how much boss room you cleared
function yandereWaifu:TrySpawnMirror()
	for p = 0, SAPI.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		if player:GetPlayerType() == Reb  then
			local room = game:GetRoom()
			local level = game:GetLevel()
			-- if we're in a boss room and the room is clear
			local isGreed = game.Difficulty == Difficulty.DIFFICULTY_GREED or game.Difficulty == Difficulty.DIFFICULTY_GREEDIER
			if (room:GetType() == RoomType.ROOM_BOSS or (isGreed and level:GetCurrentRoomIndex() == 110 --[[room:GetType() == RoomType.ROOM_SHOP]])) and room:IsClear() then
				local add = false
				-- iterate through the saved boss rooms
				for i, something in pairs(bossRoomsCleared) do 
					-- if we're in a room that had been cleared before, flag it
					if bossRoomsCleared[i][1] == level:GetCurrentRoomIndex() and bossRoomsCleared[i][2] == level:GetStage() then
						add = true
					end
				end
				-- if not flagged, add a mirror entity at the center of the room
				if not add then
					table.insert(bossRoomsCleared, {level:GetCurrentRoomIndex(), level:GetStage()} );
					local spawnPosition = room:FindFreePickupSpawnPosition(room:GetCenterPos(), 1);
					local subtype
					if ( GetEntityData(player).currentMode==REBECCA_MODE.RedHearts and level:GetStage() == 10 ) then subtype = 1 else subtype = 0 end
					local mir = Isaac.Spawn(EntityType.ENTITY_SLOT, ENTITY_REBMIRROR, subtype, spawnPosition, Vector(0,0), player);
					mir:GetSprite():Play("Appear")
				end
			end
		end
	end
end

function yandereWaifu:AddRandomHeart(player)
	local rng = math.random(1,18)
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
	end
end


------
	-- ensures that rebecca maintains the collectible effects she should have
	function yandereWaifu:ApplyCollectibleEffects()
		for p = 0, SAPI.game:GetNumPlayers() - 1 do
			local player = Isaac.GetPlayer(p)
			if player:GetPlayerType() == Reb then
				local effect = RebeccaModeEffects[GetEntityData(player).currentMode];
				if effect ~= nil and player:GetEffects():HasCollectibleEffect( effect ) == false then
					Isaac.DebugString(tostring(effect))
					--KIL FIX YOUR GAME
					--player:GetEffects():AddCollectibleEffect(effect, false, 1);
				end
			end
		end
	end
	yandereWaifu:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, yandereWaifu.ApplyCollectibleEffects)
	yandereWaifu:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, yandereWaifu.ApplyCollectibleEffects)
	yandereWaifu:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, yandereWaifu.ApplyCollectibleEffects)
	
	--stat cache for each mode
	function yandereWaifu:cacheregister(player, cacheF) --The thing the checks and updates the game, i guess?
		local data = GetEntityData(player)
		local num
		if data.currentMode == REBECCA_MODE.BrideRedHearts and  player:GetPlayerType() == Reb then num1 = 1 else num1 = 0 end
		if data.currentMode == REBECCA_MODE.EternalHearts and  player:GetPlayerType() == Reb then num2 = 1 else num2 = 0 end
		if cacheF == CacheFlag.CACHE_FAMILIARS then
			player:CheckFamiliar(ENTITY_LABAN, num1, RNG())
			player:CheckFamiliar(ENTITY_MORNINGSTAR, num2, RNG())
		end
		if player:GetPlayerType() == Reb then -- Especially here!
			if data.currentMode == REBECCA_MODE.RedHearts then
				if cacheF == CacheFlag.CACHE_DAMAGE then
					player.Damage = player.Damage - 1.73
				end
				if cacheF == CacheFlag.CACHE_LUCK then
					player.Luck = player.Luck - 0.13
				end
			elseif data.currentMode == REBECCA_MODE.SoulHearts then
				if cacheF == CacheFlag.CACHE_DAMAGE then
					if GetEntityData(player).SoulBuff then
						player.Damage = player.Damage * 1.5
					else
						player.Damage = player.Damage + 0.5
					end
				end
				if cacheF == CacheFlag.CACHE_FIREDELAY then
					player.MaxFireDelay = player.MaxFireDelay - 1
				end
				if cacheF == CacheFlag.CACHE_RANGE then
					player.TearHeight = player.TearHeight - 5.25
				end
				if cacheF == CacheFlag.CACHE_SPEED then
					player.MoveSpeed = player.MoveSpeed + 0.25
				end
				if cacheF == CacheFlag.CACHE_LUCK then
					player.Luck = player.Luck - 1
				end
				if cacheF == CacheFlag.CACHE_TEARFLAG then
					player.TearFlags = player.TearFlags | TearFlags.TEAR_SPECTRAL
				end
				if cacheF == CacheFlag.CACHE_TEARCOLOR then
					player.TearColor = Color(1.0, 1.0, 1.0, 1.0, 0, 0, 0)
				end
			elseif data.currentMode == REBECCA_MODE.GoldHearts then
				if cacheF == CacheFlag.CACHE_DAMAGE then
					player.Damage = player.Damage + 2.00
				end
				if cacheF == CacheFlag.CACHE_SPEED then
					player.MoveSpeed = player.MoveSpeed - 0.25
				end
				if cacheF == CacheFlag.CACHE_FIREDELAY then
					player.MaxFireDelay = player.MaxFireDelay + 3
				end
				if cacheF == CacheFlag.CACHE_LUCK then
					player.Luck = player.Luck + 3
				end
			elseif data.currentMode == REBECCA_MODE.EvilHearts then
				if player:GetHearts() < 1 then
					if cacheF == CacheFlag.CACHE_DAMAGE then
						player.Damage = player.Damage / 2
					end
					if cacheF == CacheFlag.CACHE_FIREDELAY then
						player.MaxFireDelay = player.MaxFireDelay - 2
					end
					if cacheF == CacheFlag.CACHE_SPEED then
						player.MoveSpeed = player.MoveSpeed + 0.20
					end
					if cacheF == CacheFlag.CACHE_LUCK then
						player.Luck = player.Luck
					end
				else
					if cacheF == CacheFlag.CACHE_DAMAGE then
						player.Damage = player.Damage * 1.20
					end
					if cacheF == CacheFlag.CACHE_FIREDELAY then
						player.MaxFireDelay = player.MaxFireDelay + 2
					end
					if cacheF == CacheFlag.CACHE_SPEED then
						player.MoveSpeed = player.MoveSpeed - 0.10
					end
					if cacheF == CacheFlag.CACHE_LUCK then
						player.Luck = player.Luck - 1
					end
				end
			elseif data.currentMode == REBECCA_MODE.EternalHearts then
				if cacheF == CacheFlag.CACHE_FIREDELAY then
					player.MaxFireDelay = player.MaxFireDelay + 2
				end
				if cacheF == CacheFlag.CACHE_DAMAGE then
					player.Damage = player.Damage * 0.7
				end
				if cacheF == CacheFlag.CACHE_SPEED then
					player.MoveSpeed = player.MoveSpeed + 0.20
				end
				if cacheF == CacheFlag.CACHE_LUCK then
					player.Luck = player.Luck - 2
				end
				if cacheF == CacheFlag.CACHE_FLYING then
					player.CanFly = true
				end
			elseif data.currentMode == REBECCA_MODE.BoneHearts then
				if cacheF == CacheFlag.CACHE_DAMAGE then
					player.Damage = player.Damage * 1.1
				end
				if cacheF == CacheFlag.CACHE_FIREDELAY then
					player.MaxFireDelay = player.MaxFireDelay
				end
				if cacheF == CacheFlag.CACHE_SPEED then
					player.MoveSpeed = player.MoveSpeed - 0.10
				end
			elseif data.currentMode == REBECCA_MODE.BrideRedHearts then
				if cacheF == CacheFlag.CACHE_DAMAGE then
					player.Damage = player.Damage - 1.73
				end
				if cacheF == CacheFlag.CACHE_LUCK then
					player.Luck = player.Luck - 0.13
				end
				if cacheF == CacheFlag.CACHE_FLYING then
					player.CanFly = true
				end
			end
			
			--special interactions
			--isaac's tears, the d6, fate, maggy's bow, transcedence, divorce papers, polaroid and negative, isaac's head
			if player:HasCollectible(CollectibleType.COLLECTIBLE_ISAACS_TEARS) then
				if cacheF == CacheFlag.CACHE_FIREDELAY then
					player.MaxFireDelay = player.MaxFireDelay - 2
				end
			end
			if player:HasCollectible(CollectibleType.COLLECTIBLE_D6) then
				if cacheF == CacheFlag.CACHE_SPEED then
					player.MoveSpeed = player.MoveSpeed + 0.20
				end
			end
			if player:HasCollectible(CollectibleType.COLLECTIBLE_FATE) then
				if cacheF == CacheFlag.CACHE_FIREDELAY then
					player.MaxFireDelay = player.MaxFireDelay - 2
				end
			end	
			if player:HasCollectible(CollectibleType.COLLECTIBLE_MAGGYS_BOW) then
				if cacheF == CacheFlag.CACHE_DAMAGE then
					player.Damage = player.Damage + 1.77
				end
			end
			if player:HasCollectible(CollectibleType.COLLECTIBLE_WHORE_OF_BABYLON) then
				if cacheF == CacheFlag.CACHE_DAMAGE then
					player.Damage = player.Damage + 1.77
				end
			end
			if player:HasCollectible(CollectibleType.COLLECTIBLE_BOX_OF_FRIENDS) then
				if cacheF == CacheFlag.CACHE_DAMAGE then
					player.Damage = player.Damage + 1.77
				end
			end
			if player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_KNIFE) then
				if cacheF == CacheFlag.CACHE_SPEED then
					player.MoveSpeed = player.MoveSpeed + 0.20
				end
			end
			if player:HasCollectible(CollectibleType.COLLECTIBLE_TRANSCENDENCE) then
				if cacheF == CacheFlag.CACHE_FIREDELAY then
					player.MaxFireDelay = player.MaxFireDelay - 2
				end
			end
			if player:HasCollectible(CollectibleType.COLLECTIBLE_DIVORCE_PAPERS) then
				if cacheF == CacheFlag.CACHE_FIREDELAY then
					player.MaxFireDelay = player.MaxFireDelay - 1
				end
			end
			if player:HasCollectible(CollectibleType.COLLECTIBLE_POLAROID) then 
				if cacheF == CacheFlag.CACHE_FIREDELAY then
					player.MaxFireDelay = player.MaxFireDelay - 1
					--player.Damage = player.Damage + 1.77
				end
			end
			if player:HasCollectible(CollectibleType.COLLECTIBLE_NEGATIVE) then
				if cacheF == CacheFlag.CACHE_FIREDELAY then
					player.MaxFireDelay = player.MaxFireDelay - 1
					--player.Damage = player.Damage + 1.77
				end
			end
			--actual items
		end
		if cacheF == CacheFlag.CACHE_FAMILIARS then
			--Miraculous Womb
			player:CheckFamiliar(ENTITY_ORBITALESAU, player:GetCollectibleNum(COLLECTIBLE_MIRACULOUSWOMB), player:GetCollectibleRNG(COLLECTIBLE_MIRACULOUSWOMB))
			player:CheckFamiliar(ENTITY_ORBITALJACOB, player:GetCollectibleNum(COLLECTIBLE_MIRACULOUSWOMB), player:GetCollectibleRNG(COLLECTIBLE_MIRACULOUSWOMB))
		end
		--love = power
		if player:HasCollectible(COLLECTIBLE_POWERLOVE) then
			local maxH, H = player:GetMaxHearts(), player:GetHearts()
			if maxH >= 1 then
				local emptyH, fullH = (maxH - H), H 
				if cacheF == CacheFlag.CACHE_SPEED then
					player.MoveSpeed = player.MoveSpeed + (0.02 * emptyH)
				end
				if cacheF == CacheFlag.CACHE_DAMAGE then
					player.Damage = player.Damage + (0.50 * H)
				end
			end
		end
		if player:HasCollectible(COLLECTIBLE_SNAP) then
			if data.SnapDelay then
				if cacheF == CacheFlag.CACHE_FIREDELAY then
					player.FireDelay = player.FireDelay - data.SnapDelay
				end
			end
		end
	end
	yandereWaifu:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, yandereWaifu.cacheregister)

	-- re-add the appropriate costume when the player rerolls (with d4 or d100)
	function yandereWaifu:useReroll(collItem, rng)
		for p = 0, SAPI.game:GetNumPlayers() - 1 do
			local player = Isaac.GetPlayer(p)
			if player:GetPlayerType() == Reb then
				ApplyCostumes( GetEntityData(player).currentMode, player );
				--player:AddNullCostume(NerdyGlasses)
			end
		end
	end
	yandereWaifu:AddCallback(ModCallbacks.MC_USE_ITEM, yandereWaifu.useReroll, CollectibleType.COLLECTIBLE_D4)
	yandereWaifu:AddCallback(ModCallbacks.MC_USE_ITEM, yandereWaifu.useReroll, CollectibleType.COLLECTIBLE_D100)

	--romcom code
	function yandereWaifu:useRomComBook(collItem, rng, player)
		SchoolbagAPI.ToggleShowActive(player, true)
	end
	yandereWaifu:AddCallback( ModCallbacks.MC_USE_ITEM, yandereWaifu.useRomComBook, COLLECTIBLE_ROMCOM );

	--dice of fate code
	function yandereWaifu:useDiceOfFate(collItem, rng, player)
			local hearts = player:GetMaxHearts() + player:GetSoulHearts() + player:GetGoldenHearts() + player:GetEternalHearts() + player:GetBoneHearts()
			--remove all hearts first
			if player:GetPlayerType() == PlayerType.PLAYER_KEEPER then
				rng = math.random(1,20)
				if rng < 6 then --red add
					player:AddBlueFlies(1, player.Position, player)
				elseif rng < 8 then
					player:AddBlueFlies(2, player.Position, player)
				elseif rng < 12 then
					player:AddBlueFlies(3, player.Position, player)
				elseif rng < 15 then
					player:AddBlueSpider(player.Position)
				elseif rng < 17 then
					player:AddBlueFlies(1, player.Position, player)
					player:AddBlueSpider(player.Position)
				else
					player:AddBlueFlies(3, player.Position, player)
					for i = 1, 3, 1 do
						player:AddBlueSpider(player.Position)
					end
				end
			elseif player:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN then
				player:AddGoldenHearts(-player:GetGoldenHearts())
				player:AddMaxHearts(-player:GetMaxHearts())
				player:AddHearts(-player:GetHearts())
				player:AddSoulHearts(-player:GetSoulHearts())
				player:AddEternalHearts(-player:GetEternalHearts())
				player:AddBoneHearts(-player:GetBoneHearts())
				player:AddBlackHearts(-GetPlayerBlackHearts(player))
				
				local hadEternal = false
				for i = 0, hearts/2 do
					rng = math.random(1,20)
					if rng < 6 then --red add
						player:AddMaxHearts(2)
						player:AddHearts(2)
					elseif rng < 8 then
						player:AddGoldenHearts(1)
					elseif rng < 12 then
						player:AddSoulHearts(2)
					elseif rng < 15 then
						if not hadEternal then
							player:AddEternalHearts(1)
							hadEternal = true
						else
							player:AddSoulHearts(1)
						end
					elseif rng < 17 then
						player:AddBlackHearts(2)
					else
						player:AddBoneHearts(1)
					end
				end
				if player:GetBoneHearts() <= 0 then
					player:AddBoneHearts(1)
				end
			else
				player:AddGoldenHearts(-player:GetGoldenHearts())
				player:AddMaxHearts(-player:GetMaxHearts())
				player:AddHearts(-player:GetHearts())
				player:AddSoulHearts(-player:GetSoulHearts())
				player:AddEternalHearts(-player:GetEternalHearts())
				player:AddBoneHearts(-player:GetBoneHearts())
				player:AddBlackHearts(-GetPlayerBlackHearts(player))
				
				local hadEternal = false
				for i = 0, hearts/2 do
					rng = math.random(1,20)
					if rng < 6 then --red add
						player:AddMaxHearts(2)
						player:AddHearts(2)
					elseif rng < 8 then
						player:AddGoldenHearts(1)
					elseif rng < 12 then
						player:AddSoulHearts(2)
					elseif rng < 15 then
						if not hadEternal then
							player:AddEternalHearts(1)
							hadEternal = true
						else
							player:AddSoulHearts(1)
						end
					elseif rng < 17 then
						player:AddBlackHearts(2)
					else
						player:AddBoneHearts(1)
					end
				end
		end
	return true
end
yandereWaifu:AddCallback( ModCallbacks.MC_USE_ITEM, yandereWaifu.useDiceOfFate, COLLECTIBLE_DICEOFFATE );

--unrequited love code
function yandereWaifu:useUnLove(collItem, rng, player)
	--for i,player in ipairs(SAPI.players) do
	SchoolbagAPI.ToggleShowActive(player, true)
	--end
end
yandereWaifu:AddCallback( ModCallbacks.MC_USE_ITEM, yandereWaifu.useUnLove, COLLECTIBLE_UNREQUITEDLOVE );

function yandereWaifu:usePocketCannon(collItem, rng, player)
	--for i,player in ipairs(SAPI.players) do
	SchoolbagAPI.ConsumeActiveCharge(player, true) --just in case
	SchoolbagAPI.ToggleShowActive(player, false, true)
	--end
end
yandereWaifu:AddCallback( ModCallbacks.MC_USE_ITEM, yandereWaifu.usePocketCannon, COLLECTIBLE_LOVECANNON );

----------------
--<3 RESERVE CODE--

function yandereWaifu:getReserveStocks(player)
	return GetEntityData(player).heartStocks
end

function yandereWaifu:addReserveStocks(player, number)
	GetEntityData(player).heartStocks = GetEntityData(player).heartStocks + number
end

function yandereWaifu:purchaseReserveStocks(player, number, restore)
	number = number or 1
	if yandereWaifu:getReserveStocks(player) >= 1 then
		yandereWaifu:addReserveStocks(player, -number)
		--just in case, i dont wannt negatives
		if yandereWaifu:getReserveStocks(player) <= 0 then
			GetEntityData(player).heartStocks = 0
		end
	else
		--player:AddHearts( -1 )
		if restore then
			if player:GetHearts() + player:GetSoulHearts() + player:GetGoldenHearts() + player:GetBoneHearts() + player:GetEternalHearts() + player:GetRottenHearts() <= 1 then
				player:AddBrokenHearts(1)
			end
			yandereWaifu:addReserveStocks(player, 1)
			player:TakeDamage( 1, DamageFlag.DAMAGE_NOKILL | DamageFlag.DAMAGE_RED_HEARTS, EntityRef(player), 0);
			player:ResetDamageCooldown()
		end
	end
end

function yandereWaifu:getReserveFill(player)
	return GetEntityData(player).heartReserveFill
end

function yandereWaifu:addReserveFill(player, number)
	if GetEntityData(player).heartReserveFill > 0 then
		GetEntityData(player).heartReserveFill = GetEntityData(player).heartReserveFill + number
	else
		--calculate broken down stocks into pure reserve
		local newReserve = yandereWaifu:getReserveStocks(player) * GetEntityData(player).heartReserveMaxFill
		GetEntityData(player).heartReserveFill = GetEntityData(player).heartReserveFill + newReserve
		GetEntityData(player).heartReserveFill = GetEntityData(player).heartReserveFill + number
	end
end

function yandereWaifu:resetReserve(player) --used to reset the stocks back into reserve so that the game can recalculate it for other modes
	if yandereWaifu:getReserveStocks(player) > 0 then
		local savedLastStocks = (yandereWaifu:getReserveStocks(player))
		yandereWaifu:addReserveStocks(player, -(yandereWaifu:getReserveStocks(player)))
		yandereWaifu:addReserveFill(player, -yandereWaifu:getReserveFill(player))
		local newReserve = savedLastStocks * GetEntityData(player).heartReserveMaxFill
		yandereWaifu:addReserveFill(player, newReserve/2)
	end
end

function yandereWaifu:heartReserveLogic(player)
	--for p = 0, game:GetNumPlayers() - 1 do
	--local player = Isaac.GetPlayer(p)
	local playerdata = GetEntityData(player);
	--print("donkey")
	--print(playerdata.heartReserveFill,"  ",playerdata.heartReserveMaxFill)
	if playerdata.heartReserveFill >= playerdata.heartReserveMaxFill then
		local number = 0
		local remainder = math.floor(playerdata.heartReserveFill/playerdata.heartReserveMaxFill)
		for j = 0, remainder, 1 do
			number = j
		end
		--print(remainder)
		if number > 0 then
			yandereWaifu:addReserveStocks(player, number)
			yandereWaifu:addReserveFill(player, -playerdata.heartReserveMaxFill) --decrease reserve to fit in more reserve
		end
	--end
	end
end

--custom actions code
function yandereWaifu:customMovesInput()
	for p = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		if player:GetPlayerType() == Reb then
			local playerdata = GetEntityData(player);
			local controller = player.ControllerIndex;
			
			if not playerdata.specialSwitchCooldown then playerdata.specialSwitchCooldown = 0 end --cooldown for click switch detection
			if not playerdata.specialCooldown then playerdata.specialCooldown = 0 end --cooldown special
			if not playerdata.specialActiveAtkCooldown then playerdata.specialActiveAtkCooldown = 0 end  --atk cooldown special
			if not playerdata.invincibleTime then playerdata.invincibleTime = 0 end --invincible time
			
			if playerdata.specialSwitchCooldown > 0 then playerdata.specialSwitchCooldown = playerdata.specialSwitchCooldown - 1 end
			if playerdata.specialCooldown > 0 and not playerdata.IsDashActive then playerdata.specialCooldown = playerdata.specialCooldown - 1 end --countdown for using dash skill
			if playerdata.specialActiveAtkCooldown > 0 and not playerdata.IsAttackActive then playerdata.specialActiveAtkCooldown = playerdata.specialActiveAtkCooldown - 1 end --countdown for using atk skill
			if playerdata.invincibleTime > 0 then playerdata.invincibleTime = playerdata.invincibleTime - 1 end --frames on counting down how much time you can be invincible
			
			if not playerdata.isReadyForSpecialAttack then playerdata.isReadyForSpecialAttack = false end
			
			--charge pocket item after ready

			if playerdata.specialActiveAtkCooldown == 0 and player:GetActiveCharge(ActiveSlot.SLOT_POCKET) <= 0 and player:HasCollectible(COLLECTIBLE_LOVECANNON) then --could need attendance later, this can be optimized
				SchoolbagAPI.RefundActiveCharge(player, 0, true)
			end
			--switch skill (used in bone hearts?)
			--useless now?
			--[[if playerdata.specialActiveAtkCooldown <= 0 then
				if (Input.IsActionPressed(ButtonAction.ACTION_DROP, controller)) then switch actions
					if playerdata.isReadyForSpecialAttack == false then
						playerdata.isReadyForSpecialAttack = true;
						local arcane = Isaac.Spawn( EntityType.ENTITY_EFFECT, ENTITY_SPECIALBEAM, 0, player.Position, Vector(0,0), player );
						GetEntityData(arcane).parent = player
						speaker:Play( SoundEffect.SOUND_BLOOD_LASER , 1, 0, false, 1.2 );
					end
				elseif not (Input.IsActionPressed(ButtonAction.ACTION_DROP, controller)) then
					if playerdata.isReadyForSpecialAttack then
						playerdata.isReadyForSpecialAttack = false;
						speaker:Play( SoundEffect.SOUND_BLOOD_LASER , 1, 0, false, 1.6 );
						playerdata.specialSwitchCooldown = OPTIONS.SPECIAL_SWITCH_COOLDOWN;
					end
				end
				if playerdata.isReadyForSpecialAttack then
					player.FireDelay = player.MaxFireDelay
					player:SetShootingCooldown(2)
					player:CanTurnHead(true)
					print(playerdata.lastHeadDir, "  ", SchoolbagAPI.DirToVec(player:GetHeadDirection()))
				else
					playerdata.lastHeadDir = player:GetAimDirection()
				end
			end]]
		end
	end
end

function yandereWaifu:ExtraStompCooldown()
	for p = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		local playerdata = GetEntityData(player);
		local controller = player.ControllerIndex;
		
		if not playerdata.specialBoneHeartStompCooldown then playerdata.specialBoneHeartStompCooldown = 0 end --special cooldown for stomping an entity cooldown, i dont want the stomp to be a dominant skill
		if playerdata.specialBoneHeartStompCooldown > 0 then playerdata.specialBoneHeartStompCooldown = playerdata.specialBoneHeartStompCooldown - 1 end --countdown for using dash skill
	end
end


function yandereWaifu:DoRebeccaBarrage(player, mode)
	local modes
	if type(mode) == 'number' then
		modes = mode
	else
		modes = GetEntityData(player).currentMode
	end
	local data = GetEntityData(player)
	
	local function HasChargeCollectibles(player)
		if player:HasCollectible(CollectibleType.COLLECTIBLE_CHOCOLATE_MILK) or 
			player:HasCollectible(CollectibleType.COLLECTIBLE_CURSED_EYE) then
			return true
		else
			return false
		end
	end
		
	local function HasAutoCollectible(player)
		if player:HasCollectible(CollectibleType.COLLECTIBLE_ALMOND_MILK) or 
		player:HasCollectible(CollectibleType.COLLECTIBLE_SOY_MILK) then
			return true
		else
			return false
		end
	end
	
	local function EndBarrage()
		data.IsAttackActive = false
		data.chargeDelay = 0
		data.barrageInit = false
		yandereWaifu:purchaseReserveStocks(player, 1)
		--SchoolbagAPI.RefundActiveCharge(player, 1, true)
		
		--soul heart
		if GetEntityData(player).SoulBuff then
			GetEntityData(player).SoulBuff = false
			player:AddCacheFlags(CacheFlag.CACHE_DAMAGE);
			player:EvaluateItems()
			--become depressed again
			ApplyCostumes( GetEntityData(player).currentMode, player , false)
			player:RemoveCostume(Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_NUMBER_ONE))
		end
	end
	
	local function EndBarrageIfValid() --used if autocollectible is true and needed	
		if HasAutoCollectible(player) then
			data.chargeDelay = 0
			-- if out or stops holding
			if (yandereWaifu:getReserveStocks(player) <= 0) or ((player:GetShootingInput().X == 0 and player:GetShootingInput().Y == 0) ) then
				data.IsAttackActive = false
				data.chargeDelay = 0
				data.barrageInit = false
				print("a")
				--SchoolbagAPI.RefundActiveCharge(player, 1, true)
			else
				--yandereWaifu:addReserveFill(player, -20)
				--yandereWaifu:purchaseReserveStocks(player, 1)
				print("b")
			end
			yandereWaifu:purchaseReserveStocks(player, 1)
		else
			print("c")
			data.IsAttackActive = false
			data.chargeDelay = 0
			data.barrageInit = false
			yandereWaifu:purchaseReserveStocks(player, 1)
			--SchoolbagAPI.RefundActiveCharge(player, 1, true)
		end
		
	end
	
	--charging code
	--chargeDelay is like FireDelay
	if not data.chargeDelay then data.chargeDelay = 0 end
	if not data.barrageInit then data.barrageInit = false end -- tells if the barrage has started
	
	
	--KIL FIX THIS PLEASE (HasCollectibleEffect)
	--local curAng -- marks the current angle for the spread tears! then we add here to make it move or something around those lines lol
	local numofShots = 1
	local tearSize = 0
		
	if player:HasCollectible(CollectibleType.COLLECTIBLE_MUTANT_SPIDER) then
		--curAng = -25
		numofShots = numofShots + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_MUTANT_SPIDER) * 2
	elseif player:HasCollectible(CollectibleType.COLLECTIBLE_INNER_EYE) then
		--curAng = -20
		numofShots = numofShots + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_INNER_EYE)
	end
	if modes == REBECCA_MODE.RedHearts then

		if player:HasCollectible(CollectibleType.COLLECTIBLE_MARKED) then
			data.specialAttackVector = player:GetAimDirection()
		end
		
		local modulusnum = math.ceil((player.MaxFireDelay/5))
		
		local function IsValidRedBarrage()
			if data.redcountdownFrames >= 1 and data.redcountdownFrames < 40 and data.redcountdownFrames % modulusnum == (0) then
				return true
			else 
				return false
			end
		end
		
		
		
		if not data.redcountdownFrames then data.redcountdownFrames = 0 end
		if not data.addedbarrageangle then data.addedbarrageangle = 0 data.addedbarrageangle2 = 0 end --incase if nil
		if not data.Xsize then data.Xsize = 0 end
	
		local angle = player.Velocity:GetAngleDegrees()

		
		--checks if you can shoot
		local canFire = true
		
		--this seems to make a stack overflow?
		if HasAutoCollectible(player) then
			if (player:GetShootingInput().X ~= 0 or player:GetShootingInput().Y ~= 0) then
				if data.chargeDelay < player.MaxFireDelay then
					data.chargeDelay = data.chargeDelay + 1
				end
			else
				--if data.redcountdownFrames >= 40 then
				--	print("pslc")
				--	EndBarrageIfValid()
				--end
			end
		end
		
		if HasChargeCollectibles(player) then
			if (player:GetShootingInput().X ~= 0 or player:GetShootingInput().Y ~= 0) and not data.barrageInit then
				if data.chargeDelay < player.MaxFireDelay * 1.3 then
					data.chargeDelay = data.chargeDelay + 1
				end
			end
			
			if not data.barrageInit then
				canFire = false
			end
			
			if player:GetShootingInput().X == 0 and player:GetShootingInput().Y == 0 then
				--print(player:GetShootingInput())
				if player:HasCollectible(CollectibleType.COLLECTIBLE_CHOCOLATE_MILK) then
					local chargeFrameToPercent = (data.chargeDelay/player.MaxFireDelay)*2
					tearSize = math.floor(chargeFrameToPercent)
					--print(tearSize)
				end
				if player:HasCollectible(CollectibleType.COLLECTIBLE_CURSED_EYE) then
					local chargeFrameToPercent = (data.chargeDelay/player.MaxFireDelay)*5
					numofShots = numofShots + math.floor(chargeFrameToPercent)
				end
				canFire = true
			end
		end
		
		--barrage angle modifications are here :3
		if data.redcountdownFrames % 2 then
			if data.redcountdownFrames == 0 then
				data.addedbarrageangle = 0
				data.addedbarrageangle2 = 0
			elseif data.redcountdownFrames > 1 and data.redcountdownFrames < 10 then
				data.addedbarrageangle = data.addedbarrageangle - 1
				data.addedbarrageangle2 = data.addedbarrageangle2 + 1
				data.Xsize = data.Xsize + 1
			elseif data.redcountdownFrames > 10 and data.redcountdownFrames < 20 then
				data.addedbarrageangle = data.addedbarrageangle + 2
				data.addedbarrageangle2 = data.addedbarrageangle2 - 2
				data.Xsize = data.Xsize + 2
			elseif data.redcountdownFrames > 20 and data.redcountdownFrames < 30 then
				data.addedbarrageangle = data.addedbarrageangle - 2
				data.addedbarrageangle2 = data.addedbarrageangle2 + 2
				data.Xsize = data.Xsize + 4
			elseif data.redcountdownFrames > 30 and data.redcountdownFrames < 40 then
				data.addedbarrageangle = data.addedbarrageangle + 4
				data.addedbarrageangle2 = data.addedbarrageangle2 - 4
				data.Xsize = data.Xsize + 6
			else
				data.addedbarrageangle = 0
				data.addedbarrageangle2 = 0
				data.Xsize = 0
			end
		end
		
		
		--fixed angle code block
		if IsValidRedBarrage() then
			data.addedfixedbarrageangle = data.addedbarrageangle
			data.addedfixedbarrageangle2 = data.addedbarrageangle2
		end
		
		if canFire == true then
			data.redcountdownFrames = data.redcountdownFrames + 1
		
			data.barrageInit = true
			if player:HasWeaponType(WeaponType.WEAPON_ROCKETS) then --rocket synergy
				local target = Isaac.Spawn(EntityType.ENTITY_EFFECT, ENTITY_ORBITALTARGET, 0, player.Position,  Vector.FromAngle(data.specialAttackVector:GetAngleDegrees())*(9), nil)
				GetEntityData(target).Parent = player
				EndBarrageIfValid()
				
			--elseif player:HasWeaponType(WeaponType.WEAPON_KNIFE) then --slashing time! knife effect --I want synergiessssss, sorry
			--	if data.redcountdownFrames == 1 then
			--		local cut = Isaac.Spawn(EntityType.ENTITY_EFFECT, ENTITY_SLASH, 0, player.Position+Vector.FromAngle(data.specialAttackVector:GetAngleDegrees()):Resized(40), Vector(0,0), player);
			--		player.ControlsEnabled = false;
			--	elseif data.redcountdownFrames >= 1 and data.redcountdownFrames < 40 and data.redcountdownFrames % modulusnum == (0) then
			--		player.Velocity = ( player.Velocity * 0.8 ) + Vector.FromAngle( data.specialAttackVector:GetAngleDegrees() );
			--		speaker:Play( SoundEffect.SOUND_BIRD_FLAP, 1, 0, false, 1.5 );
			--	elseif data.redcountdownFrames == 40 then
			--		data.IsAttackActive = false;
			--		player.ControlsEnabled = true;
			--	end
			local ludoTear
			elseif player:HasCollectible(CollectibleType.COLLECTIBLE_LUDOVICO_TECHNIQUE) then
				ludoTear = SchoolbagAPI.GetPlayerLudo(player)
				if IsValidRedBarrage() then
					if ludoTear then
						if not data.KnifeHelper then data.KnifeHelper = SchoolbagAPI:SpawnKnifeHelper(ludoTear, player) else
							if not data.KnifeHelper.incubus:Exists() then
								data.KnifeHelper = SchoolbagAPI:SpawnKnifeHelper(ludoTear, player)
							end
						end
						for i = 0, 360, 360/3 do
							--knife sucks
							if player:HasWeaponType(WeaponType.WEAPON_KNIFE) then
								SchoolbagAPI.SpawnKnife(player, (i + data.addedbarrageangle + data.specialAttackVector:GetAngleDegrees()), false, 0, SchoolbagKnifeMode.FIRE_ONCE, 1, 300, data.KnifeHelper)
							elseif player:HasWeaponType(WeaponType.WEAPON_BRIMSTONE) then
								--local brim = player:FireBrimstone( Vector.FromAngle( i + data.specialAttackVector:GetAngleDegrees() - 45 ):Resized( BALANCE.RED_HEART_ATTACK_BRIMSTONE_SIZE ) ):ToLaser();
								local brim = EntityLaser.ShootAngle(1, ludoTear.Position, i + data.specialAttackVector:GetAngleDegrees() - 45, 5, Vector(0,-5), player):ToLaser()
								brim:SetActiveRotation( 0, 135, 10, false );
								brim:AddTearFlags(player.TearFlags)
								brim:SetColor(ludoTear:GetColor(), 999, 999)
								brim.DisableFollowParent = true
								--brim.Position = ludoTear.Position
								--local brim2 = player:FireBrimstone( Vector.FromAngle( i + data.specialAttackVector:GetAngleDegrees() + 45 ):Resized( BALANCE.RED_HEART_ATTACK_BRIMSTONE_SIZE ) ):ToLaser();
								local brim2 = EntityLaser.ShootAngle(1, ludoTear.Position, i + data.specialAttackVector:GetAngleDegrees() + 45, 5, Vector(0,-5), player):ToLaser()
								brim2:SetActiveRotation( 0, -135, -10, false );
								brim2:AddTearFlags(player.TearFlags)
								brim2:SetColor(ludoTear:GetColor(), 999, 999)
								brim2.DisableFollowParent = true
								--brim2.Position = ludoTear.Position
							elseif player:HasWeaponType(WeaponType.WEAPON_LASER) then
								local randomAngleperLaser = math.random(-15,15) --used to be 45, but now the synergy feels so boring
								local techlaser = player:FireTechLaser(player.Position, 0, Vector.FromAngle(i + data.specialAttackVector:GetAngleDegrees() + randomAngleperLaser), false, true)
								techlaser.OneHit = true;
								techlaser.Timeout = 1;
								techlaser.CollisionDamage = player.Damage * 2;
								techlaser:SetHomingType(1)
								SchoolbagAPI.UpdateLaserSize(techlaser, 6 * tearSize)
							else
								for j = 0, 180, 180/numofShots do
									local fix
									if numofShots > 1 then fix = 1 else fix = 0 end
									local tears = player:FireTear(ludoTear.Position, Vector.FromAngle(i + (j - 90)*fix + (data.addedbarrageangle + data.specialAttackVector:GetAngleDegrees()))*(10), false, false, false):ToTear()
									tears.Scale = tears.Scale + tearSize
								end
							end
						end
					end
					if player.MaxFireDelay <= 5 and player.MaxFireDelay > 1 then
						if ludoTear then
							for i = 0, 360, 360/3 do
								local tears = player:FireTear(ludoTear.Position, Vector.FromAngle(i + data.addedbarrageangle2 + data.specialAttackVector:GetAngleDegrees())*(10), false, false, false):ToTear()
								tears.Scale = tears.Scale + tearSize
							end
						end
					end
				elseif data.redcountdownFrames >= 40 then
					EndBarrageIfValid()
				end
			elseif player:HasWeaponType(WeaponType.WEAPON_BOMBS) or player:HasWeaponType(WeaponType.WEAPON_BRIMSTONE) then --if bombs
				if player:HasWeaponType(WeaponType.WEAPON_BOMBS) then
					if data.redcountdownFrames == 1 then
						local bomb = player:FireBomb(player.Position, Vector.FromAngle(data.specialAttackVector:GetAngleDegrees())*(3))
						--local bomb = Isaac.Spawn(EntityType.ENTITY_BOMBDROP, 0, 0, player.Position,  Vector.FromAngle(data.specialAttackVector:GetAngleDegrees()):Resized( 9 ), player);
						GetEntityData(bomb).IsByAFanGirl = true; --makes sure that it's Rebecca's bombs
						--bomb:ToBomb();
						bomb:GetSprite():ReplaceSpritesheet(0, "gfx/effects/bomb_rebeccawantsisaacalittlebittoomuch.png");
						--bomb:GetSprite():LoadGraphics();
					elseif data.redcountdownFrames >= 40 then
						EndBarrageIfValid()
					end
				--bomb.RadiusMultiplier = 3
				end
				if player:HasWeaponType(WeaponType.WEAPON_BRIMSTONE) then
					if IsValidRedBarrage() then
						local brim = player:FireBrimstone( Vector.FromAngle( data.specialAttackVector:GetAngleDegrees() - 45 ):Resized( BALANCE.RED_HEART_ATTACK_BRIMSTONE_SIZE ) ):ToLaser();
						brim:SetActiveRotation( 0, 135, 10, false );
						--SchoolbagAPI.UpdateLaserSize(brim, tearSize)
						local brim2 = player:FireBrimstone( Vector.FromAngle( data.specialAttackVector:GetAngleDegrees() + 45 ):Resized( BALANCE.RED_HEART_ATTACK_BRIMSTONE_SIZE ) ):ToLaser();
						brim2:SetActiveRotation( 0, -135, -10, false );
						--SchoolbagAPI.UpdateLaserSize(brim2, tearSize)
					elseif data.redcountdownFrames >= 40 then
						EndBarrageIfValid()
					end
				end
			elseif player:HasWeaponType(WeaponType.WEAPON_LASER) then --tech barrage
				if IsValidRedBarrage() then
					--for i = 0, 360-360/8, 360/8 do
					for i = 1, 3 do
						local randomAngleperLaser = math.random(-15,15) --used to be 45, but now the synergy feels so boring
						local techlaser = player:FireTechLaser(player.Position, 0, Vector.FromAngle(data.specialAttackVector:GetAngleDegrees() + randomAngleperLaser), false, true)
						techlaser.OneHit = true;
						techlaser.Timeout = 1;
						techlaser.CollisionDamage = player.Damage * 2;
						techlaser:SetHomingType(1)
						SchoolbagAPI.UpdateLaserSize(techlaser, 6 * (1+ tearSize))
					end
						--techlaser.Damage = player.Damage * 5 doesn't exist lol
					--end
					
					--for i = 1, 3, 1 do
					--	local techlaser = player:FireTechLaser(player.Position, 0, Vector.FromAngle(data.specialAttackVector:GetAngleDegrees() + randomAngleperLaser), false, true)
					--	local techlaser2 = player:FireTechLaser(player.Position, 0, Vector.FromAngle(data.specialAttackVector:GetAngleDegrees() + -randomAngleperLaser), false, true)
					--end
				elseif data.redcountdownFrames >= 40 then
					EndBarrageIfValid()
				end
			else --if just plain old tears
				if data.redcountdownFrames == 1 then
					--data.specialAttackVector:GetAngleDegrees() = angle
				elseif IsValidRedBarrage() then
					player.Velocity = player.Velocity * 0.8 --slow him down
					
					if player:HasWeaponType(WeaponType.WEAPON_KNIFE) then
						--local knife = player:FireKnife(player, (data.addedbarrageangle + data.specialAttackVector:GetAngleDegrees()), false):ToKnife()
						--knife:Shoot(3,300)
						local knife = SchoolbagAPI.SpawnKnife(player, (data.addedbarrageangle + data.specialAttackVector:GetAngleDegrees()), false, 0, SchoolbagKnifeMode.FIRE_OUT_ONLY, 1, 120)
						GetEntityData(knife).IsRed = true
					elseif player:HasWeaponType(WeaponType.WEAPON_TECH_X) then
						local circle = player:FireTechXLaser(player.Position, Vector.FromAngle(data.addedbarrageangle + data.specialAttackVector:GetAngleDegrees())*(20), data.Xsize)
					else
						for j = 0, 180, 180/numofShots do
							local fix
							if numofShots > 1 then fix = 1 else fix = 0 end
							local tears = player:FireTear(player.Position, Vector.FromAngle((j - 90)*fix + (data.addedbarrageangle + data.specialAttackVector:GetAngleDegrees()))*(20), false, false, false):ToTear()
							tears.Scale = tears.Scale + tearSize
						end
					end
					speaker:Play(SoundEffect.SOUND_TEARS_FIRE, 1, 0, false, 1.2)
					if player.MaxFireDelay <= 5 and player.MaxFireDelay > 1 then
						if player:HasWeaponType(WeaponType.WEAPON_KNIFE) then
							local knife = SchoolbagAPI.SpawnKnife(player, (data.addedbarrageangle2 + data.specialAttackVector:GetAngleDegrees()), false, 0, SchoolbagKnifeMode.FIRE_OUT_ONLY, 1, 120)
							GetEntityData(knife).IsRed = true
						elseif player:HasWeaponType(WeaponType.WEAPON_TECH_X) then
							local circle = player:FireTechXLaser(player.Position, Vector.FromAngle(data.addedbarrageangle2 + data.specialAttackVector:GetAngleDegrees())*(20), data.Xsize)
						else
							local tears = player:FireTear(player.Position, Vector.FromAngle((data.addedbarrageangle2) + data.specialAttackVector:GetAngleDegrees())*(20), false, false, false)
							tears.Scale = tears.Scale + tearSize
						end
					end
					if player.MaxFireDelay == 1 then
						if player:HasWeaponType(WeaponType.WEAPON_KNIFE) then
							local knife = SchoolbagAPI.SpawnKnife(player, ( data.specialAttackVector:GetAngleDegrees()), false, 0, SchoolbagKnifeMode.FIRE_OUT_ONLY, 1, 120)
							GetEntityData(knife).IsRed = true
						elseif player:HasWeaponType(WeaponType.WEAPON_TECH_X) then
							local circle = player:FireTechXLaser(player.Position, Vector.FromAngle((data.addedbarrageangle2) - data.specialAttackVector:GetAngleDegrees())*(20), data.Xsize)
						else
							local tears = player:FireTear(player.Position, Vector.FromAngle(data.specialAttackVector:GetAngleDegrees())*(20), false, false, false)
							tears.Scale = tears.Scale + tearSize
						end
					end
					
					--if player:HasCollectible(CollectibleType.COLLECTIBLE_MUTANT_SPIDER) or player:HasCollectible(CollectibleType.COLLECTIBLE_INNER_EYE) then
					--	for i = 1, numofShots, 1 do
					--		curAng = curAng + 10
					--		if player:HasWeaponType(WeaponType.WEAPON_TECH_X) then
					--			local circle = player:FireTechXLaser(player.Position, Vector.FromAngle((data.addedbarrageangle2) - data.specialAttackVector:GetAngleDegrees())*(20), data.Xsize)
					--		else
					--			local tears = player:FireTear(player.Position, Vector.FromAngle((data.addedbarrageangle2) + curAng + data.specialAttackVector:GetAngleDegrees())*(15), false, false, false)
					--			print((data.addedbarrageangle2) - curAng - data.specialAttackVector:GetAngleDegrees())
					--		end
					--	end
					--	print("stress")
					--end
					if player:HasWeaponType(WeaponType.WEAPON_MONSTROS_LUNGS) then
					local chosenNumofBarrage =  math.random(10,20)
						for i = 1, chosenNumofBarrage do
							local tear = player:FireTear(player.Position, Vector.FromAngle(data.specialAttackVector:GetAngleDegrees() - math.random(-10,10))*(math.random(10,15)), false, false, false):ToTear()
							tear.Scale = math.random(07,14)/10
							tear.Scale = tear.Scale + tearSize
							tear.FallingSpeed = -10 + math.random(1,3)
							tear.FallingAcceleration = 0.5
							tear.CollisionDamage = player.Damage * 4.3
							--tear.BaseDamage = player.Damage * 2
						end
					end
				elseif data.redcountdownFrames >= 40 then
					EndBarrageIfValid()
					data.redcountdownFrames = 0 
					SpawnHeartParticles( 3, 5, player.Position, RandomHeartParticleVelocity(), player, HeartParticleType.Red );
				end
			end
		end
	elseif modes == REBECCA_MODE.SoulHearts then
		local extraTearDmg = 1--keeps how much extra damage might be needed, instead of adding more tears. It might be laggy.
		local chosenNumofBarrage =  9; --chosenNumofBarrage or math.random( 8, 15 );
		local modulusnum = math.ceil((player.MaxFireDelay/5));
		if not data.soulcountdownFrames then data.soulcountdownFrames = 0 end
		
		data.soulcountdownFrames = data.soulcountdownFrames + 1
		
		--tear-damage configuration thingy
		if player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_20_20) then
			extraTearDmg = extraTearDmg + 1
		end
		if player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_MUTANT_SPIDER) then
			extraTearDmg = extraTearDmg + 3
		end
		if player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_INNER_EYE) then
			extraTearDmg = extraTearDmg + 2
		end
		if player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_MONSTROS_LUNG) then
			extraTearDmg = extraTearDmg + math.random(1,2);
		end
		--epic fetus synergy
		if player:HasWeaponType(WeaponType.WEAPON_ROCKETS) then --rocket synergy
			Isaac.Spawn(EntityType.ENTITY_EFFECT, ENTITY_WIZOOB_MISSILE, 0, player.Position,  Vector.FromAngle(data.specialAttackVector:GetAngleDegrees())*(9), player)
			EndBarrage()
		--knife synergy
		elseif player:HasWeaponType(WeaponType.WEAPON_KNIFE) then
			if data.soulcountdownFrames == 1 then
				player.ControlsEnabled = false;
			elseif data.soulcountdownFrames >= 1 and data.soulcountdownFrames < 40 and data.soulcountdownFrames % modulusnum == (0) then
				local tear = player:FireTear( player.Position, Vector.FromAngle(data.specialAttackVector:GetAngleDegrees() - math.random(-10,10)):Resized(25), false, false, false):ToTear()
				--local tear = game:Spawn(EntityType.ENTITY_TEAR, 0, player.Position, Vector.FromAngle(data.specialAttackVector:GetAngleDegrees() - math.random(-10,10))*(math.random(10,15)), player, 0, 0):ToTear()
				tear.TearFlags = tear.TearFlags | TearFlags.TEAR_HOMING | TearFlags.TEAR_PIERCING;
				tear.CollisionDamage = player.Damage * 2;
				tear:ChangeVariant(ENTITY_HAUNTEDKNIFE);
				player.Velocity = ( player.Velocity * 0.8 ) + Vector.FromAngle( (data.specialAttackVector):GetAngleDegrees() +180 );
				speaker:Play( SoundEffect.SOUND_BIRD_FLAP, 1, 0, false, 1.5 );
			elseif data.soulcountdownFrames == 40 then
				EndBarrage()
				player.ControlsEnabled = true;
				data.soulcountdownFrames = 0;
			end
		--brimstone synergy
		elseif player:HasWeaponType(WeaponType.WEAPON_BRIMSTONE) then
			for i = 1, chosenNumofBarrage do
				if i == 1 then
					local brim = player:FireBrimstone( Vector.FromAngle( data.specialAttackVector:GetAngleDegrees()):Resized( BALANCE.RED_HEART_ATTACK_BRIMSTONE_SIZE ) ):ToLaser(); --i'm just gonna use the same brim size as the red heart :/
					brim:GetData().IsEctoplasm = true;
					brim:SetHomingType(1)
				else
					player.Velocity = player.Velocity * 0.8; --slow him down
					local brim = player:FireBrimstone( Vector.FromAngle( data.specialAttackVector:GetAngleDegrees() - math.random(-10,10)):Resized( BALANCE.RED_HEART_ATTACK_BRIMSTONE_SIZE ) ):ToLaser();
					brim:GetData().IsEctoplasm = true;
					brim.Timeout = 1;
					brim:SetHomingType(1)
				end
				if i == chosenNumofBarrage then
					speaker:Play( SoundEffect.SOUND_WEIRD_WORM_SPIT, 1, 0, false, 1 );
					EndBarrage()
				end
			end
		--technology synergy
		elseif player:HasWeaponType(WeaponType.WEAPON_LASER) then --tech barrage
			if data.soulcountdownFrames >= 1 and data.soulcountdownFrames < 40 and data.soulcountdownFrames*4 % modulusnum == (0) then
				local techlaser = player:FireTechLaser(player.Position, 0, Vector.FromAngle(data.specialAttackVector:GetAngleDegrees() - math.random(-30,30)):Resized( BALANCE.RED_HEART_ATTACK_BRIMSTONE_SIZE ), false, true)
				techlaser.OneHit = true;
				techlaser.Timeout = 1;
				techlaser.CollisionDamage = player.Damage * 3;
				techlaser:SetMaxDistance(math.random(200,240))
				techlaser:SetHomingType(1)
			elseif data.soulcountdownFrames == 40 then
				speaker:Play( SoundEffect.SOUND_WEIRD_WORM_SPIT, 1, 0, false, 1 );
				EndBarrage()
			end
		--tech x synergy
		elseif player:HasWeaponType(WeaponType.WEAPON_TECH_X) then
			local tear = player:FireTear( player.Position, Vector.FromAngle(data.specialAttackVector:GetAngleDegrees()):Resized(8), false, false, false):ToTear()
			tear.TearFlags = tear.TearFlags | TearFlags.TEAR_SPECTRAL;
			tear.CollisionDamage = player.Damage * 2;
			tear:ChangeVariant(ENTITY_ECTOPLASMA);
			GetEntityData(tear).Parent = player;
			player.Velocity = ( player.Velocity * 0.8 ) + Vector.FromAngle( (data.specialAttackVector):GetAngleDegrees() +180 );
			speaker:Play( SoundEffect.SOUND_WEIRD_WORM_SPIT, 1, 0, false, 1 );
			EndBarrage()
		elseif player:HasWeaponType(WeaponType.WEAPON_BOMBS) then
			local tear = player:FireTear( player.Position, Vector.FromAngle(data.specialAttackVector:GetAngleDegrees()):Resized(10), false, false, false):ToTear()
			tear:ChangeVariant(ENTITY_SBOMBBUNDLE);
			EndBarrage()
		else
			for i = 1, chosenNumofBarrage do
				player.Velocity = player.Velocity * 0.8; --slow him down
					local tear = player:FireTear( player.Position, Vector.FromAngle(data.specialAttackVector:GetAngleDegrees() - math.random(-10,10)):Resized(math.random(10,15)), false, false, false):ToTear()
					--local tear = game:Spawn(EntityType.ENTITY_TEAR, 0, player.Position, Vector.FromAngle(data.specialAttackVector:GetAngleDegrees() - math.random(-10,10))*(math.random(10,15)), player, 0, 0):ToTear()
					tear.Scale = math.random() * 0.7 + 0.7;
					tear.FallingSpeed = -9 + math.random() * 2;
					tear.FallingAcceleration = 0.5;
					tear.TearFlags = tear.TearFlags | TearFlags.TEAR_SPECTRAL;
					tear.CollisionDamage = player.Damage * 1.3 * extraTearDmg;
					--if not tear:GetData().IsEctoplasm then  tear:GetData().IsEctoplasm = true end
					--print(tear:GetData().IsEctoplasm)
					--tear.BaseDamage = player.Damage * 2
				if i == chosenNumofBarrage then
					speaker:Play( SoundEffect.SOUND_WEIRD_WORM_SPIT, 1, 0, false, 1 );
					EndBarrage()
				end
			end
		end
	elseif modes == REBECCA_MODE.GoldHearts then
		local coins = player:GetNumCoins(); --check amount of coins for Ned
		local nedClones;
		if coins >= 25 and coins < 50 then nedClones = 3
		elseif coins >= 50 and coins < 75 then nedClones = 4
		elseif coins >= 75 then nedClones = 5
		else nedClones = 2
		end
		
		for i = 1, nedClones do
			--ned weapon type randomizer
			local subtype = 0
			local rng = math.random(0,10)
			if rng < 6 and player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_KNIFE) then
				subtype = 1
			elseif rng < 5 and player:HasCollectible(CollectibleType.COLLECTIBLE_BRIMSTONE) then
				subtype = 4
			end
			local ned = Isaac.Spawn( EntityType.ENTITY_FAMILIAR, ENTITY_NED_NORMAL, subtype, player.Position, Vector( 0, 0 ), player):ToFamiliar();
			ned.Player = player
			if i == 5 then yandereWaifu:purchaseReserveStocks(player, 1) --[[player:AddHearts( -1 )]] end
		end
		for i, enemies in pairs( Isaac.GetRoomEntities() ) do
			if enemies:IsEnemy() then
				if math.random(1,10) == 10 then --gold freeze
					if enemies.Position:Distance(player.Position) < enemies.Size + player.Size + 50 then
						enemies:AddMidasFreeze( EntityRef(player), math.random( 13, 177 ) );
					end
				end
			end
		end
		SpawnPoofParticle( player.Position, Vector( 0, 0 ), player, PoofParticleType.Gold );
		SpawnHeartParticles( 3, 5, player.Position, RandomHeartParticleVelocity(), player, HeartParticleType.Gold );
		EndBarrage()
		speaker:Play( SoundEffect.SOUND_COIN_SLOT, 1, 0, false, 1 );
	elseif modes == REBECCA_MODE.EvilHearts then
		--Isaac.Spawn( EntityType.ENTITY_EFFECT, ENTITY_ARCANE_EXPLOSION, 0, player.Position, Vector.FromAngle( data.specialAttackVector:GetAngleDegrees() ):	Resized(15), player );
		local target
		local nearestOrb = 177013 -- labels the highest enemy hp
		for i, ent in pairs (Isaac.GetRoomEntities()) do
			if ent.Type == EntityType.ENTITY_EFFECT and ent.Variant == ENTITY_EVILORB then
				if nearestOrb >= ent.Position:Distance(player.Position) then
					nearestOrb = ent.Position:Distance(player.Position)
					target = ent
				end
			end
		end
		
		local beam
		local angle = data.specialAttackVector:GetAngleDegrees()
		if target then --aims then to the furthest orb
			angle = SchoolbagAPI.ObjToTargetAngle(player, target, true)
			beam = player:FireBrimstone( Vector.FromAngle(angle), player, 2):ToLaser();
			beam.MaxDistance = nearestOrb
			GetEntityData(target).Heretic = true
		else
			beam = player:FireBrimstone( Vector.FromAngle(angle), player, 2):ToLaser();
			beam.MaxDistance = 50
		end
		beam.Timeout = 20
		--EntityLaser.ShootAngle(1, player.Position, angle, 10, Vector(0,10), player):ToLaser()
		beam:SetColor(Color(0,0,0,1,0.8,0,1),9999999,99,false,false)
		beam.CollisionDamage = player.Damage * 2;
		beam.DisableFollowParent = true
		SpawnPoofParticle( player.Position, Vector( 0, 0 ), player, PoofParticleType.Black );
		speaker:Play( SoundEffect.SOUND_MONSTER_GRUNT_0, 1, 0, false, 1.2 );
		EndBarrage()
	elseif modes == REBECCA_MODE.EternalHearts then
		for j = 0, 180, 180/16 do --too lazy to calculate what 36--360-16 is lol
			local tickle = Isaac.Spawn(EntityType.ENTITY_TEAR, ENTITY_ETERNALFEATHER, 0, player.Position, Vector.FromAngle(j+(data.specialAttackVector:GetAngleDegrees())-90)*(5), player):ToTear() --feather attack
			tickle.TearFlags = player.TearFlags | TearFlags.TEAR_SPECTRAL | TearFlags.TEAR_LIGHT_FROM_HEAVEN
			tickle.CollisionDamage = player.Damage * 3
		end
		local angle = data.specialAttackVector:GetAngleDegrees()
		local beam = EntityLaser.ShootAngle(5, player.Position, angle, 10, Vector(0,10), player):ToLaser()
		if not beam:GetData().IsLvlOneBeam then beam:GetData().IsLvlOneBeam = true end
		EndBarrage()
	elseif modes == REBECCA_MODE.BoneHearts then
		data.LastGridCollisionClass = player.GridCollisionClass;
		data.LastEntityCollisionClass = player.EntityCollisionClass;
		--Isaac.Spawn(EntityType.ENTITY_EFFECT, ENTITY_BONETARGET, 0, player.Position, Vector(0,0), player)
		--player:AnimateLightTravel()
		local customBody = Isaac.Spawn(EntityType.ENTITY_EFFECT, ENTITY_EXTRACHARANIMHELPER, 0, player.Position, Vector(0,0), nil) --body effect
		GetEntityData(customBody).Player = player
		GetEntityData(customBody).DontFollowPlayer = true
		GetEntityData(customBody).IsLeftover = true
		customBody.RenderZOffset = -10
		
		local stand = Isaac.Spawn( EntityType.ENTITY_FAMILIAR, ENTITY_BONESTAND, 0, player.Position, Vector( 0, 0 ), player):ToFamiliar();
		GetEntityData(stand).Body = customBody
		GetEntityData(stand).Angle = SchoolbagAPI.AnimShootFrame(stand, true, data.specialAttackVector, "MoveSideward", "MoveForward", "MoveBackward")
		
		local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, ENTITY_SLAMDUST, 0, player.Position, Vector(0,0), player)
		--player.Invincible = true --player.Position = Vector(0,0) --player.GridCollisionClass =  EntityGridCollisionClass.GRIDCOLL_NOPITS 
		player.Velocity = Vector(0,0)
		player.ControlsEnabled = false
		player.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
		player.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		--EndBarrage()
		data.NoBoneSlamActive = false
		
		print(data.specialAttackVector:GetAngleDegrees(),"quantum")
	elseif modes == REBECCA_MODE.BrideRedHearts then

		if not data.redcountdownFrames then data.redcountdownFrames = 0 end
		if not data.addedbarrageangle then data.addedbarrageangle = 0 data.addedbarrageangle2 = 0 end --incase if nil
		if not data.Xsize then data.Xsize = 0 end

		data.redcountdownFrames = data.redcountdownFrames + 1
	
		local angle = player.Velocity:GetAngleDegrees()
		
		--barrage angle modifications are here :3
		if data.redcountdownFrames % 2 then
			if data.redcountdownFrames == 0 then
				data.addedbarrageangle = 0
				data.addedbarrageangle2 = 0
			elseif data.redcountdownFrames > 1 and data.redcountdownFrames < 10 then
				data.addedbarrageangle = data.addedbarrageangle - 1
				data.addedbarrageangle2 = data.addedbarrageangle2 + 1
				data.Xsize = data.Xsize + 1
			elseif data.redcountdownFrames > 10 and data.redcountdownFrames < 20 then
				data.addedbarrageangle = data.addedbarrageangle + 2
				data.addedbarrageangle2 = data.addedbarrageangle2 - 2
				data.Xsize = data.Xsize + 2
			elseif data.redcountdownFrames > 20 and data.redcountdownFrames < 30 then
				data.addedbarrageangle = data.addedbarrageangle - 2
				data.addedbarrageangle2 = data.addedbarrageangle2 + 2
				data.Xsize = data.Xsize + 4
			elseif data.redcountdownFrames > 30 and data.redcountdownFrames < 40 then
				data.addedbarrageangle = data.addedbarrageangle + 4
				data.addedbarrageangle2 = data.addedbarrageangle2 - 4
				data.Xsize = data.Xsize + 6
			else
				data.addedbarrageangle = 0
				data.addedbarrageangle2 = 0
				data.Xsize = 0
			end
		end
		local modulusnum = math.ceil((player.MaxFireDelay/5))
		--print(tostring(data.redcountdownFrames % modulusnum))
		if player:HasWeaponType(WeaponType.WEAPON_ROCKETS) then --rocket synergy
			Isaac.Spawn(EntityType.ENTITY_EFFECT, ENTITY_ORBITALTARGET, 0, player.Position,  Vector.FromAngle(data.specialAttackVector:GetAngleDegrees())*(9), player)
		elseif player:HasWeaponType(WeaponType.WEAPON_KNIFE) then --slashing time! knife effect
			if data.redcountdownFrames == 1 then
				local cut = Isaac.Spawn(EntityType.ENTITY_EFFECT, ENTITY_SLASH, 0, player.Position+Vector.FromAngle(data.specialAttackVector:GetAngleDegrees()):Resized(40), Vector(0,0), player);
				player.ControlsEnabled = false;
			elseif data.redcountdownFrames >= 1 and data.redcountdownFrames < 40 and data.redcountdownFrames % modulusnum == (0) then
				player.Velocity = ( player.Velocity * 0.8 ) + Vector.FromAngle( data.specialAttackVector:GetAngleDegrees() );
				speaker:Play( SoundEffect.SOUND_BIRD_FLAP, 1, 0, false, 1.5 );
			elseif data.redcountdownFrames == 40 then
				player.ControlsEnabled = true;
			end
		elseif player:HasWeaponType(WeaponType.WEAPON_BOMBS) or player:HasWeaponType(WeaponType.WEAPON_BRIMSTONE) then
			if player:HasWeaponType(WeaponType.WEAPON_BOMBS) then
				if data.redcountdownFrames == 1 then
					--local bomb = player:FireBomb(player.Position, Vector.FromAngle(data.specialAttackVector:GetAngleDegrees())*(3))
					local bomb = Isaac.Spawn(EntityType.ENTITY_BOMBDROP, 0, 0, player.Position,  Vector.FromAngle(data.specialAttackVector:GetAngleDegrees()):Resized( 9 ), player);
					GetEntityData(bomb).IsByAFanGirl = true; --makes sure that it's Rebecca's bombs
					bomb:ToBomb();
					bomb:GetSprite():ReplaceSpritesheet(0, "gfx/effects/bomb_rebeccawantsisaacalittlebittoomuch.png");
					bomb:GetSprite():LoadGraphics();
				elseif data.redcountdownFrames >= 40 then
				end
			--bomb.RadiusMultiplier = 3
			end
			if player:HasWeaponType(WeaponType.WEAPON_BRIMSTONE) then
				if data.redcountdownFrames >= 1 and data.redcountdownFrames < 40 and data.redcountdownFrames % modulusnum == (0) then
					local brim = player:FireBrimstone( Vector.FromAngle( data.specialAttackVector:GetAngleDegrees() - 45 ):Resized( BALANCE.RED_HEART_ATTACK_BRIMSTONE_SIZE ) ):ToLaser();
					brim:SetActiveRotation( 0, 135, 10, false );
					local brim2 = player:FireBrimstone( Vector.FromAngle( data.specialAttackVector:GetAngleDegrees() + 45 ):Resized( BALANCE.RED_HEART_ATTACK_BRIMSTONE_SIZE ) ):ToLaser();
					brim2:SetActiveRotation( 0, -135, -10, false );
				elseif data.redcountdownFrames >= 40 then
				end
			end
		elseif player:HasWeaponType(WeaponType.WEAPON_LASER) then --tech barrage
			if data.redcountdownFrames >= 1 and data.redcountdownFrames < 40 and data.redcountdownFrames*4 % modulusnum == (0) then
				local randomAngleperLaser = math.random(0,45)
				for i = 0, 360-360/8, 360/8 do
					local techlaser = player:FireTechLaser(player.Position, 0, Vector.FromAngle(i + randomAngleperLaser), false, true)
					techlaser.OneHit = true;
					techlaser.Timeout = 1;
					techlaser.CollisionDamage = player.Damage * 2;
					techlaser:SetHomingType(1)
					--techlaser.Damage = player.Damage * 5 doesn't exist lol
				end
			elseif data.redcountdownFrames >= 40 then
			end
		else

			if data.redcountdownFrames == 1 then
				--data.specialAttackVector:GetAngleDegrees() = angle
			elseif data.redcountdownFrames >= 1 and data.redcountdownFrames < 40 and data.redcountdownFrames % modulusnum == (0) then
				player.Velocity = player.Velocity * 0.8 --slow him down
				--print("josh")
				if player:HasWeaponType(WeaponType.WEAPON_TECH_X) then
					local circle = player:FireTechXLaser(player.Position, Vector.FromAngle(data.addedbarrageangle + data.specialAttackVector:GetAngleDegrees())*(20), data.Xsize)
				else
					local tears = player:FireTear(player.Position, Vector.FromAngle(data.addedbarrageangle + data.specialAttackVector:GetAngleDegrees())*(20), false, false, false)
				end
				speaker:Play(SoundEffect.SOUND_TEARS_FIRE, 1, 0, false, 1.2)
				if player.MaxFireDelay <= 5 and player.MaxFireDelay > 1 then
					if player:HasWeaponType(WeaponType.WEAPON_TECH_X) then
						local circle = player:FireTechXLaser(player.Position, Vector.FromAngle(data.addedbarrageangle2 + data.specialAttackVector:GetAngleDegrees())*(20), data.Xsize)
					else
						local tears = player:FireTear(player.Position, Vector.FromAngle((data.addedbarrageangle2) + data.specialAttackVector:GetAngleDegrees())*(20), false, false, false)
					end
				end
				if player.MaxFireDelay == 1 then
					if player:HasWeaponType(WeaponType.WEAPON_TECH_X) then
						local circle = player:FireTechXLaser(player.Position, Vector.FromAngle((data.addedbarrageangle2) - data.specialAttackVector:GetAngleDegrees())*(20), data.Xsize)
					else
						local tears = player:FireTear(player.Position, Vector.FromAngle(data.specialAttackVector:GetAngleDegrees())*(20), false, false, false)
					end
				end
				local curAng -- marks the current angle for the spread tears! then we add here to make it move or something around those lines lol
				if player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_MUTANT_SPIDER) and player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_INNER_EYE) then
					curAng = -40
					numofShots = 7
				elseif player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_MUTANT_SPIDER) then
					curAng = -30
					numofShots = 4
				elseif player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_INNER_EYE) then
					curAng = -20
					numofShots = 3
				end
				if player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_MUTANT_SPIDER) or player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_INNER_EYE) then
					for i = 1, numofShots, 1 do
						curAng = curAng + 10
						if player:HasWeaponType(WeaponType.WEAPON_TECH_X) then
							local circle = player:FireTechXLaser(player.Position, Vector.FromAngle((data.addedbarrageangle2) - data.specialAttackVector:GetAngleDegrees())*(20), data.Xsize)
						else
							local tears = player:FireTear(player.Position, Vector.FromAngle(data.specialAttackVector:GetAngleDegrees() + curAng)*(15), false, false, false)
						end
					end
				end
				if player:HasWeaponType(WeaponType.WEAPON_MONSTROS_LUNGS) then
				local chosenNumofBarrage =  math.random(10,20)
					for i = 1, chosenNumofBarrage do
						local tear = player:FireTear(player.Position, Vector.FromAngle(data.specialAttackVector:GetAngleDegrees() - math.random(-10,10))*(math.random(10,15)), false, false, false):ToTear()
						tear.Scale = math.random(07,14)/10
						tear.FallingSpeed = -10 + math.random(1,3)
						tear.FallingAcceleration = 0.5
						tear.CollisionDamage = player.Damage * 4.3
						--tear.BaseDamage = player.Damage * 2
					end
				end
			elseif data.redcountdownFrames >= 40 then
				data.redcountdownFrames = 0 
				SpawnHeartParticles( 3, 5, player.Position, RandomHeartParticleVelocity(), player, HeartParticleType.Red );
			end
		end
	end
end

--special beam circle effect
do
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local player = GetEntityData(eff).parent
		local sprite = eff:GetSprite();
		local playerdata = GetEntityData(player)
		
		if eff.FrameCount == 1 then
			sprite:Play("Start", true) --normal attack
			--eff.RenderZOffset = 10000;
		elseif sprite:IsFinished("Start") then
			sprite:Play("Loop")
		end
		--eff.Velocity = eff.Velocity * 0.88;
		if not playerdata.isReadyForSpecialAttack then 
			sprite:Play("End")
		end
		if sprite:IsFinished("End") then
			eff:Remove()
		end
		eff.Velocity = player.Velocity;
		eff.Position = player.Position;
end, ENTITY_SPECIALBEAM);
end

--broken glasses effect
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	--for i,player in ipairs(SAPI.players) do
		local sprite = eff:GetSprite();
		local playerdata = GetEntityData(player)
		
		if not sprite:IsPlaying("Flying") then
			if eff.FrameCount == 1 then
				sprite:Play("Flying", true) --normal attack
			elseif sprite:IsFinished("Flying") then
				sprite:Play("Land")
			end
		end
		eff.Velocity = eff.Velocity * 0.9
		SchoolbagAPI.FlipXByVec(eff, true)
	--end
end, ENTITY_BROKEN_GLASSES);


--RED HEART MODE--
do

--heart bomb effect
yandereWaifu:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE, function(_, bb)
	for p = 0, SAPI.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		local controller = player.ControllerIndex;
		local sprite = bb:GetSprite();
		
		if GetEntityData(bb).IsByAFanGirl then
			SpawnHeartParticles( 1, 1, bb.Position, RandomHeartParticleVelocity(), player, HeartParticleType.Red );
			bb.ExplosionDamage = player.Damage * 17.7013;
			bb.RadiusMultiplier = 1.2;
			--[[bb.Flags = player.TearFlags
			bb.Variant = 10
			--print(tostring(bomb.Variant))
			--bb:Update()
			--bb:GetSprite():Load("gfx/love_bomb.anm2", true)
			--bb:GetSprite():LoadGraphics()
			if bb.FrameCount == 1 then
				bb:GetSprite():Load("gfx/love_bomb.anm2", true)
				bb:GetSprite():Play("Pulse", false)
				bb:GetSprite():LoadGraphics()
			elseif bb:GetSprite():IsFinished("Pulse") then
				bb:GetSprite():Play("Explode", true)
				bb:GetSprite():LoadGraphics()
			elseif bb:GetSprite():IsFinished("Explode") then
				bb:Remove()
			--bb:GetSprite():ReplaceSpritesheet(0, "gfx/effects/bomb_rebeccawantsisaacalittlebittoomuch.png")
			end
			bb:GetSprite():LoadGraphics()]]
		end
	end
end)
--[[yandereWaifu:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, damage, amount, damageFlag, damageSource, damageCountdownFrames)
	print(tostring(damageSource.Type))
	if damageSource.Type == 4 then
		print("wholesome")
		if damageSource:ToEntity():GetData().IsByAFanGirl then
			return false
		end
	end
end, EntityType.ENTITY_PLAYER)]]

--orbital target
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
		local player = GetEntityData(eff).Parent
		local sprite = eff:GetSprite()
		local data = GetEntityData(eff)
		
		local movementDirection = player:GetShootingInput();
		local roomClampSize = math.max( player.Size, 20 )
		if movementDirection:Length() < 0.05 then
			eff.Velocity = Vector.Zero
		else
			eff.Position = SAPI.room:GetClampedPosition(eff.Position, roomClampSize);
			eff.Velocity = (eff.Velocity * 0.9) + movementDirection:Resized( BALANCE.SOUL_HEARTS_DASH_TARGET_SPEED );
		end
		
		--for i, orb in pairs (Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.TARGET, -1, false, false)) do
		--	if not data.HasParent then
		--		data.HasParent = orb
		--	else
		--		if not data.HasParent:IsDead() then
		--eff.Velocity = Vector.Zero
		--			eff.Position = data.HasParent.Position
		--		else
		--			eff.Velocity = eff.Velocity * 0.8
		--		end
		--	end
		--end
		
		local room =  Game():GetRoom()
		--function code
		if eff.FrameCount == 1 then
			sprite:Play("Idle", true)
			RebekahCanShoot(player, false)
		elseif sprite:IsFinished("Idle") then
			sprite:Play("Blink",true)
		elseif eff.FrameCount == 55 then
			Isaac.Spawn(EntityType.ENTITY_EFFECT, ENTITY_ORBITALNUKE, 0, eff.Position, Vector.FromAngle(1*math.random(1,360))*(math.random(2,4)), player) --heart effect
			eff:Remove()
			RebekahCanShoot(player, true)
		end
		if eff.FrameCount < 35 then
			--player.Velocity = Vector(0,0)
		end
end, ENTITY_ORBITALTARGET)


yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, function(_,  eff) --eternal star
	local player = GetEntityData(eff).Parent
	local sprite = eff:GetSprite()
	local data = GetEntityData(eff)
	if not data.Init then      
		eff.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NOPITS 
		data.spr = Sprite()                                                 
		data.spr:Load("gfx/effects/red/orbital_target.anm2", true) 
		data.spr:Play("Line", true)
		data.Init = true                                              
	end      
		
	SchoolbagAPI.DeadDrawRotatedTilingSprite(data.spr, Isaac.WorldToScreen(player.Position), Isaac.WorldToScreen(eff.Position), 16, nil, 8, true)
end, ENTITY_ORBITALTARGET);


--kim jun- i mean, rebeccas rockets
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	for p = 0, SAPI.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		local controller = player.ControllerIndex
		local sprite = eff:GetSprite()
		local data = GetEntityData(eff)
		eff.GridCollisionClass =  EntityGridCollisionClass.GRIDCOLL_NOPITS 
		
		local room =  Game():GetRoom()
		--function code
		if eff.FrameCount == 1 then
			sprite:Play("Falling", true)
		elseif sprite:IsEventTriggered("Blow") then
			local megumin = Isaac.Spawn(EntityType.ENTITY_BOMBDROP, 0, 0, eff.Position, Vector(0,0), eff):ToBomb() --this is a workaround to make explosions larger
			megumin:SetExplosionCountdown(1)
			megumin.Visible = false
			megumin.RadiusMultiplier = 2.2 --my favorite part
			megumin.ExplosionDamage = player.Damage*20
			for i, ent in pairs(Isaac.GetRoomEntities()) do
				if ent:IsEnemy() and not ent:IsVulnerableEnemy() then
					ent:AddPoison(EntityRef(eff), 5, player.Damage*17)
				end
			end
			if player:HasWeaponType(WeaponType.WEAPON_LASER) then
				for i = 0, 360, 360/8 do
					local techlaser = player:FireTechLaser(eff.Position, 0, Vector.FromAngle(i), false, true)
					techlaser.CollisionDamage = player.Damage * 5
					--techlaser.Damage = player.Damage * 5 doesn't exist lol
				end
			elseif player:HasWeaponType(WeaponType.WEAPON_BRIMSTONE) then
				for i = 0, 360, 360/8 do
					local brim = player:FireBrimstone(eff.Position, 0, Vector.FromAngle(i), false, true)
					brim.CollisionDamage = player.Damage * 5
				end
			end
		elseif sprite:IsFinished("Falling") then
			eff:Remove()
		end
		if eff.FrameCount < 35 then
			player.Velocity = Vector(0,0)
		end
	end
end, ENTITY_ORBITALNUKE)

--slash effect
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	for i,player in ipairs(SAPI.players) do
		local controller = player.ControllerIndex
		local sprite = eff:GetSprite()
		local data = GetEntityData(eff)
		eff.GridCollisionClass =  EntityGridCollisionClass.GRIDCOLL_NOPITS 
		
		local room =  Game():GetRoom()
		--function code
		if eff.FrameCount == 1 then
			sprite:Play("Slash", true)
		elseif eff.FrameCount == 40 or GetEntityData(player).IsAttackActive == false then
			eff:Remove()
		elseif sprite:IsFinished("Slash") then
			sprite:Play("Slash", true)
		end
		if eff.FrameCount < GetEntityData(player).redcountdownFrames then
			for i, ent in pairs (Isaac.GetRoomEntities()) do
				if ent:IsEnemy() and ent:IsVulnerableEnemy() and not ent:IsDead() then
					if ent.Position:Distance((eff.Position)) <= 50 then
						ent:TakeDamage(player.Damage * 7, 0, EntityRef(eff), 1)
					end
				end
			end
			--player.Velocity = Vector(0,0)
		end
		eff.Velocity = player.Velocity*2
	end
end, ENTITY_SLASH)
end

function AddRebekahDashEffect(player)
	local customBody = Isaac.Spawn(EntityType.ENTITY_EFFECT, ENTITY_EXTRACHARANIMHELPER, 0, player.Position, Vector(0,0), player) --body effect
	GetEntityData(customBody).Player = player
	GetEntityData(customBody).DashEffect = true
	GetEntityData(customBody).DontFollowPlayer = true
end



--SOUL HEART --
do
--soul heart movement
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local player = GetEntityData(eff).Parent
	local controller = player.ControllerIndex;
	local sprite = eff:GetSprite();
	local room =  Game():GetRoom();
	local data = GetEntityData(player)
    local roomClampSize = math.max( player.Size, 20 );
	--movement code
	eff.GridCollisionClass =  EntityGridCollisionClass.GRIDCOLL_NOPITS;

	--local movementDirection = player:GetMovementInput();
	--if movementDirection:Length() < 0.05 then
	
	player.Velocity = player.Velocity * 1.1
	eff.Velocity = player.Velocity;
	eff.Position = player.Position --room:GetClampedPosition(eff.Position, roomClampSize);
	
		--eff.Velocity = player.Velocity;
	--else
	--	eff.Velocity = (eff.Velocity * 0.9) + movementDirection:Resized( BALANCE.SOUL_HEARTS_DASH_TARGET_SPEED );
	--end
	
	--trail
	local trail = SchoolbagAPI.SpawnTrail(eff, Color(0,0.5,1,0.5))
	--function code
	--player.Velocity = (room:GetClampedPosition(eff.Position, roomClampSize) - player.Position)--*0.5;
	if eff.FrameCount == 1 then
		player.Visible = true
	
	
		sprite:Play("Idle", true);
		data.LastEntityCollisionClass = player.EntityCollisionClass;
		data.LastGridCollisionClass = player.GridCollisionClass;
		SpawnEctoplasm( player.Position, Vector ( 0, 0 ) , math.random(13,15)/10, player);
	elseif sprite:IsFinished("Idle") then
		sprite:Play("Blink",true);
	end
	
    if eff.FrameCount == 35 then
        if BALANCE.SOUL_HEARTS_DASH_RETAINS_VELOCITY == false then
            player.Velocity = Vector( 0, 0 );
        else
            player.Velocity = eff.Velocity;
        end
    	if player.CanFly == true and room:GetType() ~= RoomType.ROOM_DUNGEON then
    		player.Position = eff.Position;
            if room:IsPositionInRoom(player.Position, 0) == false then
                player.Velocity = Vector( 0, 0 );
                player.Position = room:GetClampedPosition( player.Position, roomClampSize );
            end
    	else
            player.Position = room:FindFreeTilePosition( eff.Position, 0 )
            if room:IsPositionInRoom(player.Position, 0) == false then
                player.Velocity = Vector( 0, 0 );
                player.Position = room:FindFreeTilePosition( room:GetClampedPosition( player.Position, roomClampSize ), 0 );
            end
        end
		local customBody = Isaac.Spawn(EntityType.ENTITY_EFFECT, ENTITY_EXTRACHARANIMHELPER, 0, player.Position, Vector(0,0), player) --body effect
		GetEntityData(customBody).Player = player
		GetEntityData(customBody).WizoobOut = true
		player.ControlsEnabled = false
    	eff:Remove();
    	
    	data.IsUninteractible = false;
    	speaker:Play( SoundEffect.SOUND_WEIRD_WORM_SPIT, 1, 0, false, 1 );
    else
		player:SetColor(Color(0,0,0,0.2,0,0,0),3,1,false,false)
    	player.GridCollisionClass =  EntityGridCollisionClass.GRIDCOLL_WALLS;
		player.EntityCollisionClass =  EntityCollisionClass.ENTCOLL_NONE;
    end
	--if eff.FrameCount < 35 then
	--	player.Velocity = Vector( 0, 0 );
	--end
end, ENTITY_SOULTARGET)

	--ectoplasm
	yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, function(_, eff)
		local sprite = eff:GetSprite()
		local data = GetEntityData(eff)
		
		if eff:GetData().IsEctoplasm and eff.FrameCount == 0 then 
			sprite:ReplaceSpritesheet(0, "gfx/effects/ectoplasm.png")
			sprite:LoadGraphics()
		end
	end, 46)

	--[[ecto tears
	yandereWaifu:AddCallback(ModCallbacks.MC_POST_TEAR_RENDER, function(_, tr)
		local data = GetEntityData(tr)
		local player = Isaac.GetPlayer(0)
		local sprite = tr:GetSprite()
		if tr:GetData().IsEctoplasm then
			sprite:ReplaceSpritesheet(0, "gfx/tears_ecto.png")
			sprite:LoadGraphics()
		end
	end)

	yandereWaifu:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, function(_, tr)
		local data = GetEntityData(tr)
		local player = Isaac.GetPlayer(0)
		local sprite = tr:GetSprite()
		if tr:GetData().IsEctoplasm then
			if tr.Height >= -7 or tr:CollidesWithGrid() then
				SpawnEctoplasm( tr.Position, Vector ( 0, 0 ) );
				tr:Remove();
			end
		end
	end)]]


	--haunted knife
	function yandereWaifu:HauntedKnifeRender(tr, _)
		if tr.Variant == ENTITY_HAUNTEDKNIFE then
			tr:GetSprite():Play("RegularTear", false);
			--tr:GetSprite():LoadGraphics();
			
			local angleNum = (tr.Velocity):GetAngleDegrees();
			tr:GetSprite().Rotation = angleNum + 90;
			tr:GetData().Rotation = tr:GetSprite().Rotation;
		end
	end
	yandereWaifu:AddCallback(ModCallbacks.MC_POST_TEAR_RENDER, yandereWaifu.HauntedKnifeRender)

	function yandereWaifu:HauntedKnifeUpdate(tr)
		local data = GetEntityData(tr)
		local player = Isaac.GetPlayer(0)
		if tr.Variant == ENTITY_HAUNTEDKNIFE then
		end
	end
	yandereWaifu:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, yandereWaifu.HauntedKnifeUpdate)

	function yandereWaifu:EctoplasmaRender(tr, _)
		if tr.Variant == ENTITY_ECTOPLASMA then
			tr:GetSprite():Play("RegularTear", false);
		end
	end
	yandereWaifu:AddCallback(ModCallbacks.MC_POST_TEAR_RENDER, yandereWaifu.EctoplasmaRender)
	
	function yandereWaifu:EctoplasmaUpdate(tr)
		if tr.Variant == ENTITY_ECTOPLASMA then
		
			tr.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE 

			for i, enemy in pairs (Isaac.GetRoomEntities()) do
				if enemy:IsVulnerableEnemy() then
					if enemy.Position:Distance(tr.Position) < enemy.Size + (tr.Size * 5) then
						enemy:TakeDamage(Isaac.GetPlayer(0).Damage * 2, 0, EntityRef(tr), 1);
					end
				end
			end
			if math.random(1,3) == 3 and tr.FrameCount % 2 == 0 then
				local laser = EntityLaser.ShootAngle(2, tr.Position, math.random(1,360), 2, Vector(0,-20), Isaac.GetPlayer(0))
				laser:SetColor(Color(0,0,0,0.7,170,170,210),9999999,99,false,false);
				laser:SetHomingType(1)
			end
		end
	end
	yandereWaifu:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, yandereWaifu.EctoplasmaUpdate)
	
	yandereWaifu:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, function(_, tr)
		if tr.Variant == ENTITY_ECTOPLASMA then
			local player = GetEntityData(tr).Parent
			local part = Isaac.Spawn(EntityType.ENTITY_EFFECT, ENTITY_LIGHTBOOM, 0, tr.Position, Vector(0,0), tr);
			part:GetSprite():ReplaceSpritesheet(0, "gfx/effects/plasmaboom.png");
			part:GetData().NotEternal = true;
			local random = math.random(3,6)
			for i = 1, random do
				local circle = player:FireTechXLaser(tr.Position, Vector.FromAngle(math.random(1,360))*(20), math.random(10,20))
				circle:SetColor(Color(0,0,0,0.7,170,170,210),9999999,99,false,false);
			end
			SpawnEctoplasm( tr.Position, Vector ( 0, 0 ) , math.random(12,35)/10, player);
		end
	end, EntityType.ENTITY_TEAR)

	--wizoob dropping missile guy
	yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
		local player = Isaac.GetPlayer(0)
		local controller = player.ControllerIndex
		local sprite = eff:GetSprite()
		local data = GetEntityData(eff)
		eff.GridCollisionClass =  EntityGridCollisionClass.GRIDCOLL_NOPITS 
		
		local room =  Game():GetRoom()
		
		for i, orb in pairs (Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.TARGET, -1, false, false)) do
			if not data.HasParent then
				data.HasParent = orb
			else
				if not data.HasParent:IsDead() then
					eff.Velocity = data.HasParent.Velocity
					eff.Position = data.HasParent.Position
				else
					eff.Velocity = eff.Velocity * 0.9
				end
			end
		end
		--function code
		if eff.FrameCount == 1 then
			sprite:Play("AppearDown", true)
			eff.SpriteOffset = Vector(0,-50)
		elseif sprite:IsFinished("AppearDown") then
			sprite:Play("ShootDown", true)
		elseif sprite:IsPlaying("ShootDown") then
			if sprite:IsEventTriggered("Shoot") then
				local ghostvomit = Isaac.Spawn(EntityType.ENTITY_BOMBDROP, 0, 0, eff.Position, Vector(0,0), eff):ToBomb() --this is a workaround to make explosions larger
				ghostvomit:SetExplosionCountdown(1)
				ghostvomit.Visible = false
				ghostvomit.RadiusMultiplier = 1.2 --my favorite part
				ghostvomit.ExplosionDamage = player.Damage*17.7013
				if player:HasWeaponType(WeaponType.WEAPON_LASER) then
					for i = 0, 360, 360/8 do
						local techlaser = player:FireTechLaser(eff.Position, 0, Vector.FromAngle(i), false, true)
						techlaser.CollisionDamage = player.Damage * 5
					end
				elseif player:HasWeaponType(WeaponType.WEAPON_BRIMSTONE) then
					for i = 0, 360, 360/8 do
						local brim = player:FireBrimstone(eff.Position, 0, Vector.FromAngle(i), false, true)
						brim.CollisionDamage = player.Damage * 2
						--brim:GetData().IsEctoplasm = true
					end
				else
					local chosenNumofBarrage =  math.random( 4, 8 );
					for i = 1, chosenNumofBarrage do
						local tear = player:FireTear( eff.Position,  Vector.FromAngle( math.random() * 360 ):Resized(7), false, false, false):ToTear()
						tear.Scale = math.random() * 0.7 + 0.7;
						tear.FallingSpeed = -9 + math.random() * 2 ;
						tear.FallingAcceleration = 0.95;
						tear.CollisionDamage = player.Damage * 3.3;
						tear.TearFlags = tear.TearFlags | TearFlags.TEAR_EXPLOSIVE;
					end
				end
			end
		elseif sprite:IsFinished("ShootDown") then
			sprite:Play("VanishDown", true)
		elseif sprite:IsFinished("VanishDown") then
			eff:Remove()
		end
	end, ENTITY_WIZOOB_MISSILE)

	function yandereWaifu:EctoplasmLaser(lz)
		 if lz:GetData().IsEctoplasm then
			if lz.FrameCount == 1 then
				lz:GetSprite():Load("gfx/effect_ectoplasmlaser.anm2", true)
				lz:GetSprite():Play("LargeRedLaser", true)
				if lz.Child ~= nil then
					lz.Child:GetSprite():Load("gfx/effect_ectoplasmlaserend.anm2", true)
					lz.Child:GetSprite():LoadGraphics()
					lz.Child.Color = lz.Parent:GetSprite().Color
				end
			end
		 end
	end
	yandereWaifu:AddCallback(ModCallbacks.MC_POST_LASER_UPDATE, yandereWaifu.EctoplasmLaser)


	--bomb bundle tear
	function yandereWaifu:SBombRender(tr, _)
		if tr.Variant == ENTITY_SBOMBBUNDLE then
			tr:GetSprite():Play("RegularTear", false);
			--tr:GetSprite():LoadGraphics();
		end
	end
	yandereWaifu:AddCallback(ModCallbacks.MC_POST_TEAR_RENDER, yandereWaifu.SBombRender)

	--after bomb bundle coll functionality 
	yandereWaifu:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, function(_, tr)
		if tr.Variant == ENTITY_SBOMBBUNDLE then
			Isaac.Explode(tr.Position, tr, 0)
			for i = 1, 5 do
			local bomb = Isaac.Spawn(EntityType.ENTITY_BOMBDROP, 0, 0, tr.Position + Vector(math.random(1,10),math.random(1,10)),  Vector(0,0), tr):ToBomb();
			bomb:GetSprite():ReplaceSpritesheet(0, "gfx/effects/bomb_soulheart.png");
			bomb:GetSprite():LoadGraphics();
			--bomb.Size = 0.5;
			--bomb.SpriteScale = Vector(0.5, 0.5);
			--bomb.RadiusMultiplier = 0.8;
			bomb.ExplosionDamage = tr:ToTear().BaseDamage * 1.77013;
			end
		end
	end, EntityType.ENTITY_TEAR)

	--"ectoplasm leaking after just teleporting" mechanic
	function yandereWaifu:EctoplasmLeaking(player) 
		local data = GetEntityData(player)
		if GetEntityData(player).currentMode == REBECCA_MODE.SoulHearts then	
			if data.LeaksJuices and data.LeaksJuices > 0 then
				data.LeaksJuices = data.LeaksJuices - 1
				if math.random(1,5) == 3 then
					SpawnEctoplasm( player.Position, Vector ( 0, 0 ) , 1, player);
				end
			end
		end
	end
	
	--soul buff 
	yandereWaifu:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, function(_,tear)
		local parent, spr, data = tear.Parent, tear:GetSprite(), GetEntityData(tear)
		local player = parent:ToPlayer()
		
		if player:GetPlayerType() == Reb and GetEntityData(player).currentMode == REBECCA_MODE.SoulHearts then
			if GetEntityData(player).SoulBuff and GetEntityData(player).specialCooldown <= 0 then --give lenience to the barrage
				GetEntityData(player).SoulBuff = false
				player:AddCacheFlags(CacheFlag.CACHE_DAMAGE);
				player:EvaluateItems()
				--become depressed again
				ApplyCostumes( GetEntityData(player).currentMode, player , false)
				player:RemoveCostume(Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_NUMBER_ONE))
			end
		end
	end)
end


--GOLD HEART--
do

--lvl one ned
function yandereWaifu:onFamiliarNedInit(fam)
	fam.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
	fam.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ENEMIES
    local sprite = fam:GetSprite()
    sprite:Play("Init", true)
	
	if fam.SubType == 1 then --moms knife
		sprite:ReplaceSpritesheet(0, "gfx/effects/gold/knife/familiar_ned.png") 
		sprite:ReplaceSpritesheet(1, "gfx/effects/gold/knife/familiar_ned.png") 
	elseif fam.SubType == 2 then --dr fetus
	elseif fam.SubType == 3 then --epic fetus
	elseif fam.SubType == 4 then --brimstone
		sprite:ReplaceSpritesheet(0, "gfx/effects/gold/brimstone/familiar_ned.png") 
		sprite:ReplaceSpritesheet(1, "gfx/effects/gold/brimstone/familiar_ned.png") 
	end
	sprite:LoadGraphics()
end
yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, yandereWaifu.onFamiliarNedInit, ENTITY_NED_NORMAL);

yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_,  fam) --nerdy keeper function
    local spr = fam:GetSprite()
	local rng = math.random(1, 100)
	local data = GetEntityData(fam)
	local player = fam.Player
	
	if not data.Health then
		data.Health = 3
	end
	
	for i, e in pairs(Isaac.GetRoomEntities()) do
		if e.Type ~= EntityType.ENTITY_PLAYER then
			if e.Type == EntityType.ENTITY_PROJECTILE then
				if (e.Position - fam.Position):Length() < 10 then
					if data.Health > 1 then
						data.Health = data.Health - 1
					else
						fam:Die()
					end
					e:Die()
					if math.random(1,3) == 3 then
						if rng < 10 then
							game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, fam.Position, fam.Velocity/5, Parent, HeartSubType.HEART_HALF_SOUL, 0)
						end
					end
				end
				if (e.Position - fam.Position):Length() < 75 then
					if not spr:IsPlaying("Move") then
						spr:Play("Move", true)
						fam.Velocity = fam.Velocity + (fam.Position - e.Position)/3
					end
				end
			end
		end
	end
	
	--if ned is too far from player
	if (player.Position - fam.Position):Length() > 100 then
		if game:GetFrameCount() % 7 == 0 then
			spr:Play("Move", true)
			fam.Velocity = fam.Velocity + Vector.FromAngle(((player.Position - fam.Position)):GetAngleDegrees()+math.random(-10,10)):Resized(10)
		end
	end
	fam.Velocity = fam.Velocity - fam.Velocity*0.25
	
   -- if spr:IsPlaying("Init") == true and spr:GetFrame() == 14 then
	--	if spr:IsPlaying("Move") == false then
	--		spr:Play("Idle", true)
	--	end
	--end
	if (spr:IsFinished("Shoot")) then
		spr:Play("Idle", true)
	end
	if spr:IsFinished("Shoot") or spr:IsFinished("Move") or spr:IsFinished("Idle") then
			if rng > 70 then
				spr:Play("Move", true)
				fam.Velocity = fam.Velocity + Vector( math.random(-15, 15), math.random(-15, 15) )
			end
			if rng < 71 then
				--spr:Play("Move", false)
			--	fam.Velocity = fam.Velocity + Vector( math.random(-15, 15), math.random(-15, 15) )
				local target = nil
				for i, e in pairs(Isaac.GetRoomEntities()) do
					if e.Type ~= EntityType.ENTITY_PLAYER and e.Type ~= ENTITY_TINYFELLOW then
						if e:IsActiveEnemy() == true then
							if e:IsVulnerableEnemy() == true then
								if (fam.Position - e.Position):Length() < 250 then
									target = e
								end
							end
						end
					end
				end
				--shoot code
				if target then
					spr:Play("Shoot", true)
					data.target = target
				end
			end
	elseif spr:IsPlaying("Shoot") then
		if spr:GetFrame() == 2 then
			if fam.SubType == 1 then
				SchoolbagAPI.SpawnKnife(player, ((data.target.Position - fam.Position):GetAngleDegrees()), false, 0, SchoolbagKnifeMode.FIRE_ONCE, 1, 150, SchoolbagAPI:SpawnKnifeHelper(fam, player, true), true)
			elseif fam.SubType == 4 then
				beam = EntityLaser.ShootAngle(1, fam.Position, (data.target.Position - fam.Position):GetAngleDegrees(), 5, Vector(0,-5), fam):ToLaser()
				beam.CollisionDamage = player.Damage / 1.4
				beam.DisableFollowParent = true
				SchoolbagAPI.UpdateLaserSize(beam, 0.5)
			else
				FireBarrageTear(fam.Position, (Vector(0, 0) + fam.Velocity/5 + (data.target.Position - fam.Position):Resized(10)), TearVariant.BLOOD, fam)
			end
			speaker:Play(SoundEffect.SOUND_WORM_SPIT, 1, 0, false, 1)
			data.target = nil
		end
	end
end, ENTITY_NED_NORMAL);

yandereWaifu:AddCallback(ModCallbacks.MC_POST_FAMILIAR_RENDER, function(_,  fam) --render stuff
	if GetEntityData(fam).Health then
		local Sprite = Sprite()
		Sprite:Load("gfx/effects/gold/ui/ui_hearts.anm2", true)
		
		for i = 1, 3 do
			local state = "Full"
			pos = Isaac.WorldToScreen(fam.Position) + Vector(-12+ i*6, 5) --heart position
			
			if GetEntityData(fam).Health < i then
				state = "Empty"
			end
			
			Sprite:Play(state, true)
			Sprite:Render(pos, Vector.Zero, Vector.Zero)
		end
	end
end, ENTITY_NED_NORMAL);

--lvl two ned
function yandereWaifu:onFamiliarNed2Init(fam)
    fam.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
    local sprite = fam:GetSprite()
    sprite:Play("Init", true)
end
yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, yandereWaifu.onFamiliarNed2Init, ENTITY_SQUIRENED);

--wind slash
function yandereWaifu:WindSlashRender(tr, _)
	if tr.Variant == ENTITY_WIND_SLASH then
		tr:GetSprite():Play("RegularTear", false);
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_POST_TEAR_RENDER, yandereWaifu.WindSlashRender)
function yandereWaifu:WindSlashUpdate(tr, _)
	if tr.Variant == ENTITY_WIND_SLASH then
		local angleNum = (tr.Velocity):GetAngleDegrees();
		for k, enemy in pairs( Isaac.GetRoomEntities() ) do
			if enemy:IsVulnerableEnemy() then
				if enemy.Position:Distance( tr.Position ) < enemy.Size + tr.Size + 30 then
					local targetAngle = (enemy.Position - tr.Position):GetAngleDegrees()
					if targetAngle >= (angleNum - 90) and targetAngle <= (angleNum + 90) then
						enemy:TakeDamage(1.5, 0, EntityRef(tr), 4)
					end
				end
			end
		end
		local angleNum = (tr.Velocity):GetAngleDegrees();
		tr:GetSprite().Rotation = angleNum + 90;
		tr:GetData().Rotation = tr:GetSprite().Rotation;
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, yandereWaifu.WindSlashUpdate)

yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_,  fam) --squire keeper function
    local spr = fam:GetSprite()
	local rng = math.random(1, 100)
	local player = fam.Player
	local data = GetEntityData(fam)
	
	if not data.Health then
		data.Health = 5
	end
	
	--hurt stuff	
	for i, e in pairs(Isaac.GetRoomEntities()) do
		if e.Type ~= EntityType.ENTITY_PLAYER then
			if e.Type == EntityType.ENTITY_PROJECTILE then
				if (e.Position - fam.Position):Length() < 10 then
					e:Die()
					fam:Die()
					if math.random(1,3) == 3 then
						if rng < 11 then
							game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, fam.Position, fam.Velocity/5, Parent, HeartSubType.HEART_HALF_SOUL, 0)
						end
					end
				end
				if (e.Position - fam.Position):Length() < 75 then
					if game:GetFrameCount() % 6 == 0 then
						local Mrng = math.random(1,3)
						spr:Play("Move", true)
						if Mrng == 1 then
							fam.Velocity = fam.Velocity + (fam.Position - e.Position)/3
						elseif Mrng == 2 then
							fam.Velocity = fam.Velocity + Vector( math.random(-15, 15), math.random(-15, 15) )
						end
					end
				end
			end
		end
	end
	
	if (player.Position - fam.Position):Length() > 200 then
		if game:GetFrameCount() % 7 == 0 then
			fam.Velocity = fam.Velocity + (player.Position - fam.Position)*0.125*0.6
		end
	end
	
	fam.Velocity = fam.Velocity - fam.Velocity*0.25
    if spr:IsFinished("Init") == true then
		spr:Play("Idle", true)
	end
	--[[if spr:IsPlaying("Repel") then
		if spr:IsEventTriggered("Repel") then
			for k, enemy in pairs( Isaac.GetRoomEntities() ) do
				if enemy.Variant == EntityType.ENTITY_PROJECTILE then
					if enemy.Position:Distance( fam.Position ) < enemy.Size + fam.Size + 200 then
						enemy:ToProjectile();
						enemy.Velocity = enemy.Velocity * 0.6 + (enemy.Position - fam.Position):Resized((enemy.Position - fam.Position):Length())
					end
				end
			end
			local chosenNumofBarrage =  math.random( 3, 6 );
			for i = 1, chosenNumofBarrage do
				local tear = game:Spawn( EntityType.ENTITY_TEAR, 20, fam.Position, Vector.FromAngle( math.random() * 360 ):Resized(BALANCE.GOLD_HEARTS_DASH_ATTACK_SPEED), fam.Player, 0, 0):ToTear()
				tear.Scale = math.random() * 0.7 + 0.7;
				tear.FallingSpeed = -9 + math.random() * 2 ;
				tear.FallingAcceleration = 0.5;
				tear.CollisionDamage = fam.Player.Damage;
			end
			SpawnPoofParticle( fam.Position, Vector(0,0), fam, PoofParticleType.Gold );
			SpawnHeartParticles( 3, 5, fam.Position, RandomHeartParticleVelocity(), fam, HeartParticleType.Gold );
		end]]
	if spr:IsFinished("Repel") or spr:IsFinished("Attack_Front") or spr:IsFinished("Attack_Back") or spr:IsFinished("Attack_Side") then
		spr:Play("Idle", false)
	end
	if spr:IsPlaying("Idle") == true then
		for k, enemy in pairs( Isaac.GetRoomEntities() ) do
			if enemy:IsVulnerableEnemy() --[[and not enemy:IsEffect() and not enemy:IsInvulnurable()]] then
				if enemy.Position:Distance( fam.Position ) < enemy.Size + fam.Size + 300 then
					data.target = enemy
				end
			end
		end
		if game:GetFrameCount() % 30 == 0 then
			if data.target then -- every one second
				--doesnt make you stay too close
				if (fam.Position - data.target.Position):Length() > 50 then
					fam.Velocity = fam.Velocity * 0.9 + ((data.target.Position - fam.Position):Resized(8)) + Vector( math.random(-15, 15), math.random(-15, 15) );
				end
				if (fam.Position - data.target.Position):Length() < 230 then
					local angle = (data.target.Position - fam.Position):GetAngleDegrees();
					local slashAngle
					if angle >= 45 and angle <= 135 then --front
						spr:Play("Attack_Front")
						slashAngle = 90
					elseif angle <= -45 and angle >= -135 then --back
						spr:Play("Attack_Back")
						slashAngle = 270
					elseif (angle >= 135 and angle <= 180) or (angle <= -135 and angle >= -180) then
						spr:Play("Attack_Side")
						spr.FlipX = true
						slashAngle = 180
					elseif (angle >= 0 and angle <= 45) or (angle <= 0 and angle >= -45) then
						spr:Play("Attack_Side")
						spr.FlipX = false
						slashAngle = 0
					end
					local tear = game:Spawn( EntityType.ENTITY_TEAR, ENTITY_WIND_SLASH, fam.Position, Vector.FromAngle( slashAngle ):Resized(12), fam.Player, 0, 0):ToTear()
				end
			else
				if rng > 75 then
					spr:Play("Move", true)
					fam.Velocity = fam.Velocity + Vector( math.random(-15, 15), math.random(-15, 15) )
				end
				if rng < 76 then
					spr:Play("Move", false)
					fam.Velocity = fam.Velocity + Vector( math.random(-15, 15), math.random(-15, 15) )
				end
			end
		end	
	end
	--target detection, if the target is dead lol
	if data.target then
		if data.target:IsDead() then
			data.target = nil
		end
	end
end, ENTITY_SQUIRENED);

yandereWaifu:AddCallback(ModCallbacks.MC_POST_FAMILIAR_RENDER, function(_,  fam) --render stuff
	if GetEntityData(fam).Health then
		local Sprite = Sprite()
		Sprite:Load("gfx/effects/gold/ui/ui_hearts.anm2", true)
		
		for i = 1, 5 do
			local state = "Full"
			pos = Isaac.WorldToScreen(fam.Position) + Vector(-18+ i*6, 5) --heart position
			
			if GetEntityData(fam).Health < i then
				state = "Empty"
			end
			
			Sprite:Play(state, true)
			Sprite:Render(pos, Vector.Zero, Vector.Zero)
		end
	end
end, ENTITY_SQUIRENED);

--christian ned
function yandereWaifu:onFamiliarChristianInit(fam)
    fam.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
	local data = GetEntityData(fam)
    local sprite = fam:GetSprite()
    sprite:Play("Spawn", true)
	data.IncreasedBuff = 0
end
yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, yandereWaifu.onFamiliarChristianInit, ENTITY_CHRISTIANNED);

yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_,  fam) --christian nerd
	local spr = fam:GetSprite()
	local rng = math.random(1, 100)
	local player = Isaac.GetPlayer(0)
	local data = GetEntityData(fam)
	
	if spr:IsFinished("Spawn") then
		spr:Play("Idle", true)
	end
	
	--reading Bible mechanic
	if game:GetRoom():GetFrameCount() == 1 and game:GetRoom():GetType() == RoomType.ROOM_BOSS then
		for i, e in pairs(Isaac.GetRoomEntities()) do
			if e.Type == EntityType.ENTITY_MOM or e.Type == EntityType.ENTITY_MOMS_HEART or e.Type == EntityType.ENTITY_IT_LIVES then
				spr:Play("DeusVult",true)
				speaker:Play( SOUND_CHRISTIAN_READ, 1, 0, false, 1 );
			elseif e.Type == EntityType.ENTITY_SATAN then
				spr:Play("ForJerusalem",true)
				speaker:Play( SOUND_CHRISTIAN_READ, 1, 0, false, 1 );
			end
		end
	end
	--flip sprite mechanic
	if spr:IsPlaying("Idle") then
		SchoolbagAPI.FlipXByVec(fam, false)
	end
	if spr:IsEventTriggered("Hit") then
		speaker:Play( SOUND_STRIKE, 2, 0, false, 1 );
	end
	fam.Velocity = fam.Velocity - fam.Velocity*0.25
	if spr:IsPlaying("Idle") then

		--movement code
		if data.HasCommander then
			fam:FollowPosition ( data.HasCommander.Position );
		else
			fam:FollowParent();
			fam:MoveDelayed( 60 );
		end
		--if game:GetFrameCount() % 120 == 0 then -- every one second
			for i, e in pairs(Isaac.GetRoomEntities()) do
				if e.Type ~= EntityType.ENTITY_PLAYER then
					if e:IsActiveEnemy() then
						if e:IsVulnerableEnemy() then
							if (fam.Position - e.Position):Length() < 250 then
								local angle = (e.Position - fam.Position):GetAngleDegrees();
								if ((angle >= 175 and angle <= 180) or (angle <= -175 and angle >= -180)) then
									spr.FlipX = true
									data.ChargeTo = 0
									spr:Play("Charge", true)
									data.target = e
									speaker:Play( SOUND_CHRISTIAN_OVERTAKE, 3, 0, false, 1 );
									speaker:Play( SoundEffect.SOUND_FORESTBOSS_STOMPS, 1, 0, false, 1 );
								elseif ((angle >= 0 and angle <= 10) or (angle <= 0 and angle >= -10)) then 
									spr.FlipX = false 
									data.ChargeTo = 1
									spr:Play("Charge", true)
									data.target = e
									speaker:Play( SOUND_CHRISTIAN_OVERTAKE, 3, 0, false, 1 );
									speaker:Play( SoundEffect.SOUND_FORESTBOSS_STOMPS, 1, 0, false, 1 );
								end
							end
						end
					end
					if e.Type == EntityType.ENTITY_FAMILIAR and e.Variant == ENTITY_SCREAMINGNED then
						data.HasCommander = e
					end
					if data.HasCommander and GetPtrHash(e) == GetPtrHash(data.HasCommander) and (fam.Position - e.Position):Length() < 250 then
						data.IncreasedBuff = 2
					else
						data.IncreasedBuff = 0
					end
				end
			end
		--end	
	elseif spr:IsFinished("Idle") then
		spr:Play("Idle", true)
		speaker:Play( SOUND_CHRISTIAN_CHANT, 2, 0, false, 1 );
	--charge ai
	elseif spr:IsFinished("Charge") then
		if data.ChargeTo == 0 then
			data.savedVelocity = Vector(-10,0) --needed for the velocity it goes + detection what grid is in front
		elseif data.ChargeTo == 1 then
			data.savedVelocity = Vector(10,0)
		end
		spr:Play("Charging", true)
	elseif spr:IsPlaying("Charging") then
		
		fam.Velocity = fam.Velocity * 0.75 + data.savedVelocity
		for k, enemy in pairs( Isaac.GetRoomEntities() ) do
			if enemy:IsVulnerableEnemy() then
				if enemy.Position:Distance( fam.Position ) < enemy.Size + fam.Size + 30 then
					enemy:TakeDamage(3.5 + data.IncreasedBuff + fam.Player:GetNumCoins()/8 + fam.Player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BFFS), 0, EntityRef(fam), 4)
				end
			end
		end
		local room = game:GetRoom()
		--local setAngle = (fam.Velocity):GetAngleDegrees()
		if data.savedVelocity then
			local checkingVector = (room:GetGridEntity(room:GetGridIndex(fam.Position + data.savedVelocity*4)))
			if checkingVector and (checkingVector:GetType() == GridEntityType.GRID_WALL or checkingVector:GetType() == GridEntityType.GRID_DOOR) then 
				spr:Play("Charged", true)
				speaker:Play( SOUND_STRIKE, 1, 0, false, 1 );
			end
		end
	elseif spr:IsPlaying("Charged") then
		if spr:GetFrame() <= 35 then
			fam.Velocity = Vector( 0 , 0 );
		else
			if spr:GetFrame() == 36 then
				fam.Velocity = data.savedVelocity:Resized(50)
			end
		end
	elseif spr:IsFinished("Charged") then
		spr:Play("Idle")
	elseif spr:IsPlaying("DeusVult") then
		fam.Velocity = fam.Velocity * 0.8
		if spr:GetFrame() == 40 then
			for i, e in pairs(Isaac.GetRoomEntities()) do
				if e.Type == EntityType.ENTITY_MOM or e.Type == EntityType.ENTITY_MOMS_HEART or e.Type == EntityType.ENTITY_IT_LIVES then
					e:Kill()
				end
			end
		end
	elseif spr:IsFinished("DeusVult") then
		spr:Play("Idle")
	elseif spr:IsFinished("ForJerusalem") then
		fam:Remove()
	end
end, ENTITY_CHRISTIANNED);

--screamin ned
function yandereWaifu:onFamiliarScreamingInit(fam)
    fam.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
    local sprite = fam:GetSprite()
    sprite:Play("Spawn", true)
end
yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, yandereWaifu.onFamiliarScreamingInit, ENTITY_SCREAMINGNED);

function yandereWaifu:ThrownSpearUpdate(fam, _)
	local spr = fam:GetSprite()
	local data = GetEntityData(fam)
	if fam.FrameCount == 1 then--init
		if not data.Height then
			data.Height = -25
		end
	end
	if not fam:GetData().Stuck then
		if fam.FrameCount % 2 == 0 and data.Height then
			data.Height = data.Height + 1
		end
		local angleNum = (fam.Velocity):GetAngleDegrees();
		for k, enemy in pairs( Isaac.GetRoomEntities() ) do
			if enemy:IsVulnerableEnemy() then
				if enemy.Position:Distance( fam.Position ) < enemy.Size + fam.Size + 30 then
					enemy:TakeDamage(4.5 + fam.Player:GetNumCoins()/6 + fam.Player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BFFS), 0, EntityRef(fam), 4)
				end
			end
		end
		--flip sprite
		SchoolbagAPI.FlipXByVec(fam, false)
		--stuck code
		local room = game:GetRoom()
		local checkingVector = (room:GetGridEntity(room:GetGridIndex(fam.Position + fam:GetData().savedVelocity*4)))
		if checkingVector and (checkingVector:GetType() == GridEntityType.GRID_WALL or checkingVector:GetType() == GridEntityType.GRID_DOOR) then 
			spr:Play("Flyingn't", true)
			fam:GetData().Stuck = true
			fam.Velocity = Vector( 0,0 );
			spr.FlipX = data.willFlipX
			
			speaker:Play( SOUND_STRIKE, 1, 0, false, 1 );
		end
		--height sprite
		if data.Height then
			fam.SpriteOffset = Vector ( 0, data.Height )
		end
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, yandereWaifu.ThrownSpearUpdate, ENTITY_SPEAR_NED)

yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_,  fam)
	local spr = fam:GetSprite()
	local rng = math.random(1, 100)
	local player = Isaac.GetPlayer(0)
	local data = GetEntityData(fam)
	
	if spr:IsFinished("Spawn") then
		spr:Play("Idle", true)
	end
	
	--refresh spear
	if game:GetRoom():GetFrameCount() == 1 then
		spr:Play("Idle", true) --force have spear
	end
	
	--flip sprite mechanic
	if spr:IsPlaying("Idle") or spr:IsPlaying("March") then
		SchoolbagAPI.FlipXByVec(fam, false)
	end
	
	fam.Velocity = fam.Velocity - fam.Velocity*0.25
	if spr:IsPlaying("Idle") then
		--code for natural following THOTGIRL and throwing spear
		for i, e in pairs(Isaac.GetRoomEntities()) do
			if e.Type == EntityType.ENTITY_PLAYER then
				if (fam.Position - e.Position):Length() <= 150 then
					fam:FollowParent()
					fam:MoveDelayed( 10 )
				else
					fam.Velocity = fam.Velocity * 0.8 + ( e.Position - fam.Position):Resized(2);
				end
			end
			if e.Type ~= EntityType.ENTITY_PLAYER then
				if e:IsActiveEnemy() then
					if e:IsVulnerableEnemy() then
						if fam.FrameCount % 120 == 0 then
							spr:Play("Scream")
						end
						if (fam.Position - e.Position):Length() < 235 then
							local angle = (e.Position - fam.Position):GetAngleDegrees();
							if ((angle >= 178 and angle <= 180) or (angle <= -178 and angle >= -180)) then
								spr.FlipX = true
								data.ChargeTo = 0
								spr:Play("Throw", true)
								--data.target = e
							elseif ((angle >= 0 and angle <= 2) or (angle <= 0 and angle >= -2)) then 
								spr.FlipX = false
								data.ChargeTo = 1
								spr:Play("Throw", true)
								--data.target = e
							end
						end
					end
				end
			end
		end
	elseif spr:IsFinished("Idle") then
		spr:Play("Idle", true)
	--throw ai
	elseif spr:IsPlaying("Throw") then
		if spr:GetFrame() == 20 then
			local savedVelocity
			if data.ChargeTo == 0 then
				savedVelocity = Vector(-10,0) --needed for the velocity it goes + detection what grid is in front
			elseif data.ChargeTo == 1 then
				savedVelocity = Vector(10,0)
			end
			local spear = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, ENTITY_SPEAR_NED, 0, fam.Position, savedVelocity*3.5, fam)
			if savedVelocity == Vector(-10,0) then spr.FlipX = true end
			--set spear flip as well
			GetEntityData(spear).willFlipX = spr.FlipX
			local speardata = spear:GetData()
			if not speardata.savedVelocity then speardata.savedVelocity = savedVelocity end
			spear:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		end
	elseif spr:IsFinished("Throw") then
		spr:Play("March", true)
	elseif spr:IsPlaying("March") then
		if fam.FrameCount % 3 == 0 then
			speaker:Play( SOUND_RATTLEARMOR, 1, 0, false, 1 );
		end
		local spear
		for i, e in pairs(Isaac.GetRoomEntities()) do
			if e.Type == EntityType.ENTITY_FAMILIAR and e.Variant == ENTITY_SPEAR_NED then
				spear = e
				if (fam.Position - e.Position):Length() < 45 and e:GetData().Stuck then
					e:Remove()
					spr:Play("Idle")
				end
			end
		end
		if spear:GetData().Stuck then --if stuck
			fam.Velocity = fam.Velocity * 0.8 + ( spear.Position - fam.Position):Resized(2);
		end
	elseif spr:IsPlaying("Scream") then
		if spr:GetFrame() == 11 then
			speaker:Play( SOUND_SCREAMING_SCREAM, 1, 0, false, 1 );
			for i, e in pairs(Isaac.GetRoomEntities()) do
				if e:IsEnemy() then
					e.Target = fam
				end
			end
		end
	elseif spr:IsFinished("Scream") then
		spr:Play("Idle", true)
	end
	if fam.FrameCount % 90 == 0 then
		for i, e in pairs(Isaac.GetRoomEntities()) do --reset target
			if e.Type ~= EntityType.ENTITY_PLAYER then
				if e:IsActiveEnemy() then
					if e:IsVulnerableEnemy() then
						e.Target = nil
					end
				end
			end
		end
	end
end, ENTITY_SCREAMINGNED);

--barbaric ned
yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_,  fam)
	local spr = fam:GetSprite()
	local rng = math.random(1, 100)
	local player = Isaac.GetPlayer(0)
	local data = GetEntityData(fam)
	
	if spr:IsFinished("Spawn") then
		spr:Play("Idle", true)
		speaker:Play( SOUND_BARBARIAN_LAUGH, 1, 0, false, 1 );
	end
	
	--flip sprite mechanic
	if spr:IsPlaying("Idle")  then
		SchoolbagAPI.FlipXByVec(fam, false)
	end
	
	fam.Velocity = fam.Velocity - fam.Velocity*0.25
	if spr:IsPlaying("Idle") then
		--movement code
		if data.HasCommander then
			fam:FollowPosition ( data.HasCommander.Position );
			fam:MoveDelayed( 20 );
		else
			if (fam.Player.Position - fam.Position):Length() <= 150 then
				fam:FollowParent()
				fam:MoveDelayed( 40 )
			else
				fam.Velocity = fam.Velocity * 0.8 + ( fam.Player.Position - fam.Position):Resized(3.4);
			end
		end
			for i, e in pairs(Isaac.GetRoomEntities()) do
				if e.Type ~= EntityType.ENTITY_PLAYER then
					if e:IsActiveEnemy() then
						if e:IsVulnerableEnemy() then
							if (fam.Position - e.Position):Length() < 250 then
								if math.random(1,5) == 5 then
									spr:Play("Boo")
									speaker:Play( SOUND_BARBARIAN_LAUGH, 1, 0, false, 1 );
								else
									spr:Play("StartSpin", true)
									speaker:Play( SOUND_BARBARIAN_GRUNT, 1, 0, false, 1 );
								end
							end
						end
					end
					if e.Type == EntityType.ENTITY_FAMILIAR and e.Variant == ENTITY_SCREAMINGNED then
						data.HasCommander = e
					end
					if data.HasCommander and GetPtrHash(e) == GetPtrHash(data.HasCommander) and (fam.Position - e.Position):Length() < 250 then
						data.IncreasedBuff = 2
					else
						data.IncreasedBuff = 0
					end
				end
			end
	elseif spr:IsFinished("Idle") then
		spr:Play("Idle", true)
	--throw ai
	elseif spr:IsPlaying("StartSpin") then
		if spr:GetFrame() >= 20 then
			for i, e in pairs(Isaac.GetRoomEntities()) do
				if e.Type ~= EntityType.ENTITY_PLAYER then
					if e:IsActiveEnemy() then
						if e:IsVulnerableEnemy() then
							if (fam.Position - e.Position):Length() < 45 then
								e:TakeDamage(2.5 * fam.Player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BFFS), 0, EntityRef(fam),4)
							end
						end
					end
				end
			end
		end
	elseif spr:IsFinished("StartSpin") then
		spr:Play("Spin", true)
	elseif spr:IsPlaying("Spin") then
		if fam.FrameCount % 5 == 0 then
			speaker:Play( SoundEffect.SOUND_SHELLGAME, 1, 0, false, 0.6 );
		end
		data.closestDist = 177013 --saved Dist to check who is the closest enemy
		data.target = nil
		for i, e in pairs(Isaac.GetRoomEntities()) do
			if e.Type ~= EntityType.ENTITY_PLAYER then
				if e:IsActiveEnemy() then
					if e:IsVulnerableEnemy() then
						if (fam.Position - e.Position):Length() < 45 then
							e:TakeDamage(2.5 + data.IncreasedBuff + fam.Player:GetNumCoins()/8 + fam.Player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BFFS), 0, EntityRef(fam),10)
						end
						if (fam.Position - e.Position):Length() < 500 then
							if (fam.Position - e.Position):Length() <= data.closestDist then
								data.target = e
								data.closestDist = (fam.Position - e.Position):Length()
							end							
						end
					end
				end
			end
		end
		if data.target and not data.target:IsDead() then
			fam.Velocity = fam.Velocity * 0.8 + ( data.target.Position - fam.Position):Resized(2);
		else
			data.target = nil
			if data.HasCommander then
				fam:FollowPosition ( data.HasCommander.Position );
				fam:MoveDelayed( 40 );
			else
				fam:FollowParent();
				fam:MoveDelayed( 40 );
			end
		end
	elseif spr:IsFinished("Spin") then
		spr:Play("EndSpin", true)
		speaker:Play( SOUND_BARBARIAN_LAUGH, 1, 0, false, 0.5 );
	--[[elseif spr:IsPlaying("EndSpin") then
		if spr:GetFrame() >= 6 and spr:GetFrame() <= 215 then
			fam:AddConfusion(EntityRef(fam), 2, false)
		end]]
	elseif spr:IsFinished("EndSpin") then
		spr:Play("Idle", true)
	elseif spr:IsPlaying("Boo") then
		if spr:GetFrame() == 11 then
			for i, e in pairs(Isaac.GetRoomEntities()) do
				if e:IsEnemy() then
					e:AddFear(EntityRef(fam), 60)
				end
			end
		end
	elseif spr:IsFinished("Boo") then
		spr:Play("Idle", true)
	end
	if fam.FrameCount % 90 == 0 then
		for i, e in pairs(Isaac.GetRoomEntities()) do --reset target
			if e.Type ~= EntityType.ENTITY_PLAYER then
				if e:IsActiveEnemy() then
					if e:IsVulnerableEnemy() then
						e.Target = nil
					end
				end
			end
		end
	end
end, ENTITY_BARBARICNED);

--defending ned
yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_,  fam)
	local spr = fam:GetSprite()
	local rng = math.random(1, 100)
	local player = Isaac.GetPlayer(0)
	local data = GetEntityData(fam)
	
	if spr:IsFinished("Spawn") then
		spr:Play("Side", true)
	end
	
	local currentSide = nil
	local princessProtectorAngle = (fam.Player.Velocity):GetAngleDegrees()
	local willFlip = false
	local neededPosition = fam.Player.Position + Vector(40,0):Rotated(princessProtectorAngle)
	
	if not spr:IsPlaying("CMASlamAWTTJam") then
		fam.Velocity = fam.Velocity * 2
		if princessProtectorAngle >= 45 and princessProtectorAngle <= 135 and currentSide ~= "down" then
			currentSide = "down"
			if not spr:IsPlaying("Front") then spr:Play("Front", true) end
		elseif princessProtectorAngle <= -45 and princessProtectorAngle >= -135 and currentSide ~= "up" then
			currentSide = "up"
			if not spr:IsPlaying("Back") then spr:Play("Back", true) end
		elseif (princessProtectorAngle <= 0 and princessProtectorAngle >= -45) or (princessProtectorAngle >= 0 and princessProtectorAngle <= 45) and currentSide ~= "right" then
			currentSide = "right"
			if not spr:IsPlaying("Side") then spr:Play("Side", true) end
			spr.FlipX = false;
			willFlip = false;
		elseif (princessProtectorAngle <= 180 and princessProtectorAngle >= 135) or (princessProtectorAngle >= -180 and princessProtectorAngle <= -135) and currentSide ~= "left" then
			currentSide = "left"
			if not spr:IsPlaying("Side") then spr:Play("Side", true) end
			spr.FlipX = true;
			willFlip = true;
		end
		--stay where?
		--fam:FollowPosition ( neededPosition );
		fam.Velocity = (neededPosition - fam.Position)*0.4;
		--blocking code
		for i, e in pairs(Isaac.GetRoomEntities()) do
			if e.Type == EntityType.ENTITY_PROJECTILE then
				local addedColl = 0
				if fam.Player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BFFS) then addedColl = fam.Player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BFFS) end
				if (fam.Position - e.Position):Length() <= 15 + addedColl then
					e:Die()
					--if not data.TimesBlocked then data.TimesBlocked = 0 else data.TimesBlocked = data.TimesBlocked + 1 end
				end
			end
		end
		--print(tostring(data.TimesBlocked))
		--if data.TimesBlocked and data.TimesBlocked >= 10 then --slam code
		if not game:GetRoom():IsClear() then
			if fam.FrameCount % 270 == 0 then
				spr:Play("CMASlamAWTTJam")
				data.TimesBlocked = 0
			end
		end
	end
	
	--end
	if spr:IsPlaying("CMASlamAWTTJam") then --slam stun code
		data.closestDist = 177013 --saved Dist to check who is the closest enemy
		data.target = nil
		if spr:GetFrame() < 22 then
			for i, e in pairs(Isaac.GetRoomEntities()) do
				if e.Type ~= EntityType.ENTITY_PLAYER then
					if e:IsActiveEnemy() then
						if e:IsVulnerableEnemy() then
							if (fam.Position - e.Position):Length() < 500 then
								if (fam.Position - e.Position):Length() <= data.closestDist then
									data.target = e
									data.closestDist = (fam.Position - e.Position):Length()
								end							
							end
						end
					end
				end
			end
			if data.target and not data.target:IsDead() then
				fam.Velocity =(data.target.Position - fam.Position)*0.4;
			end
		end
		if spr:GetFrame() == 22 then
			for i, e in pairs(Isaac.GetRoomEntities()) do
				if e:IsVulnerableEnemy() then
					if (fam.Position - e.Position):Length() <= 100 then
						e:AddConfusion(EntityRef(fam), math.random(10,30), false)
						e:TakeDamage(5.5/((fam.Position - e.Position):Length() + fam.Player:GetNumCoins()/10), 0, EntityRef(fam),10)
					end
				end
			end
			game:ShakeScreen(5);
			speaker:Play( SoundEffect.SOUND_FORESTBOSS_STOMPS, 1, 0, false, 1 );
			SpawnPoofParticle( player.Position, Vector( 0, 0 ), player, PoofParticleType.Gold );
		end
		fam.Velocity = fam.Velocity * 0.9
	end
	--no need to set anim after this animation because it is automatic apparently

	
end, ENTITY_DEFENDINGNED);

function yandereWaifu:LevelUpNeds()
	local AvailableKnights = {
		[1] = false, --ENTITY_CHRISTIANNED
		[2] = false, --ENTITY_SCREAMINGNED
		[3] = false, --ENTITY_BARBARICNED
		[4] = false, --ENTITY_DEFENDINGNED
		[5] = false --squire
	}
	for c, ned in pairs( Isaac.FindByType(EntityType.ENTITY_FAMILIAR, -1, -1, false, false) ) do
		--check for knights system
		if ned.Variant == ENTITY_CHRISTIANNED then AvailableKnights[1] = true end
		if ned.Variant == ENTITY_SCREAMINGNED then AvailableKnights[2] = true end
		if ned.Variant == ENTITY_BARBARICNED then AvailableKnights[3] = true end
		if ned.Variant == ENTITY_DEFENDINGNED then AvailableKnights[4]  = true end
		--rank up system
	end
	for n, ned in pairs( Isaac.FindByType(EntityType.ENTITY_FAMILIAR, -1, -1, false, false) ) do
		if ned.Variant == ENTITY_NED_NORMAL then
			local squire = game:Spawn( EntityType.ENTITY_FAMILIAR, ENTITY_SQUIRENED, ned.Position, Vector( 0, 0 ), ned, 0, 0);
			ned:Remove()
		elseif ned.Variant == ENTITY_SQUIRENED then
			local rng = math.random(1, 10)
			if rng >= 0 and rng <= 2 and not AvailableKnights[4] then
				local defender = game:Spawn( EntityType.ENTITY_FAMILIAR, ENTITY_DEFENDINGNED, ned.Position, Vector( 0, 0 ), ned, 0, 0);
				AvailableKnights[4] = true
				ned:Remove()
				--print("1")
			elseif rng >= 3 and rng <= 4 and not AvailableKnights[3] then
				local jugger = game:Spawn( EntityType.ENTITY_FAMILIAR, ENTITY_BARBARICNED, ned.Position, Vector( 0, 0 ), ned, 0, 0);
				AvailableKnights[3] = true
				ned:Remove()
				--print("2")
			elseif rng >= 5 and rng <= 6 and not AvailableKnights[2] then
				local command = game:Spawn( EntityType.ENTITY_FAMILIAR, ENTITY_SCREAMINGNED, ned.Position, Vector( 0, 0 ), ned, 0, 0);
				AvailableKnights[2] = true
				ned:Remove()
				--print("3")
			elseif rng >= 7 and rng <= 10 and not AvailableKnights[1] then
				local christian = game:Spawn( EntityType.ENTITY_FAMILIAR, ENTITY_CHRISTIANNED, ned.Position, Vector( 0, 0 ), ned, 0, 0);
				AvailableKnights[1] = true
				ned:Remove()
				--print("4")
			else
				local elseEnum = 0
				local loopNum = 0
				--print("wen")
				for i, nedValue in pairs (AvailableKnights) do
					--loopNum = loopNum + 1
					if i == 1 then --these numbers for some reason arent savng to elseEnum
						elseEnum = ENTITY_CHRISTIANNED;
					elseif i == 2 then
						elseEnum = ENTITY_SCREAMINGNED;
					elseif i == 3 then
						elseEnum = ENTITY_BARBARICNED;
					elseif i == 4 then
						elseEnum = ENTITY_DEFENDINGNED;
					--[[elseif i == 5 then
						elseEnum = ENTITY_SQUIRENED;]] --weird bug that deletes rest f ther squire neds after getting all the four knights the first time
					end
					--print(tostring(i))
					if nedValue == false then
						--print("5"..tostring(i)..tostring(nedValue)..tostring(elseEnum)..tostring(loopNum))
						--[[if tostring(i) == "ENTITY_CHRISTIANNED" then --these numbers for some reason arent savng to elseEnum
							elseEnum = ENTITY_CHRISTIANNED;
						elseif tostring(i) == "ENTITY_SCREAMINGNED" then
							elseEnum = ENTITY_SCREAMINGNED;
						elseif tostring(i) == "ENTITY_BARBARICNED" then
							elseEnum = ENTITY_BARBARICNED;
						elseif tostring(i) == "ENTITY_DEFENDINGNED" then
							elseEnum = ENTITY_DEFENDINGNED;
						end]]
						--print("5"..tostring(i)..tostring(nedValue)..tostring(elseEnum) ..ENTITY_CHRISTIANNED)
						--if elseEnum ~= ENTITY_CHRISTIANNED and elseEnum ~= ENTITY_SCREAMINGNED and elseEnum ~= ENTITY_BARBARICNED and elseEnum ~= ENTITY_DEFENDINGNED then
						if elseEnum ~= 0 then
							if i < 5 then
								local elseNed = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, elseEnum, 0, ned.Position, Vector(0,0), ned);
								AvailableKnights[i] = true
								ned:Remove()
								--print("fell here")
								--print(tostring(n)..tostring(nedValue)..tostring(elseEnum)..tostring(i))
								break
							else
							end
						end
						--end
					end
				end
			end
		end
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, yandereWaifu.LevelUpNeds)
end

--BLACK HEART --
do
--dark beam effect misc
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, function(_, eff)
	--sprite:LoadGraphics()
end, ENTITY_ARCANE_EXPLOSION);

yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local player = eff.SpawnerEntity;
	local sprite = eff:GetSprite();
	
	if not sprite:IsPlaying("Megumin") then
		--sprite.Scale = Vector(0.2,0.2);
		--sprite:LoadGraphics();
		if eff.FrameCount == 1 then
			sprite:Play("Pentagram", true) --normal attack
			eff.RenderZOffset = -10000;
		else
			local target
			local highestHP = 0 -- labels the highest enemy hp
			for i, ent in pairs (Isaac.GetRoomEntities()) do
				if ent.Position:Distance(eff.Position) < ent.Size + eff.Size + 10 then
					print(ent.Variant, "  ", ENTITY_EVILORB)
					if ent.Type == EntityType.ENTITY_EFFECT and ent.Variant == ENTITY_EVILORB then
						target = ent
						break
					else
						if ent:IsVulnerableEnemy() then
							if highestHP <= ent.MaxHitPoints then
								highestHP = ent.MaxHitPoints
								target = ent
							end
						end
					end
				end
			end
			if target then
				if target.Type == EntityType.ENTITY_EFFECT and target.Variant == ENTITY_EVILORB then
					local hole = Isaac.Spawn(EntityType.ENTITY_EFFECT, ENTITY_HOLEFABRIC, 0, target.Position, Vector(0,0), player);
					GetEntityData(hole).Parent = player
				else
					local stomp = Isaac.Spawn(EntityType.ENTITY_EFFECT, ENTITY_LABAN_STOMP, 0, target.Position, Vector(0,0), player)
					GetEntityData(stomp).Parent = player
				end
				eff:Remove()
			end
		end
		--elseif eff.FrameCount == 20 then
		--	Isaac.Spawn(EntityType.ENTITY_EFFECT, ENTITY_DARKBEAMINTHESKY, 0, eff.Position, Vector(0,0), player)
		--	for i, entities in pairs(Isaac.GetRoomEntities()) do
				--[[if entities[i]:IsVulnerableEnemy() then
					if entities[i].Position:Distance(eff.Position) < entities[i].Size + eff.Size + 10 then
						entities[i]:TakeDamage(player.Damage * 2, 0, EntityRef(eff), 1)
					end
				end]]
		--		if entities.Type == EntityType.ENTITY_EFFECT and entities.Variant == ENTITY_EVILORB then
		--			if entities.Position:Distance(eff.Position) < entities.Size + eff.Size + 50 then
		--				Isaac.Spawn(EntityType.ENTITY_EFFECT, ENTITY_HOLEFABRIC, 0, entities.Position, Vector(0,0), player);
		--				entities:Remove();
		--			end
		--		end
		--	eff:Remove();
		
	end
	eff.Velocity = eff.Velocity * 0.88;
end, ENTITY_ARCANE_EXPLOSION);

yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local player = GetEntityData(eff).Parent:ToPlayer()
	local sprite = eff:GetSprite()
	
	if eff.FrameCount == 1 then
		sprite:Play("Stomp", true) --normal attack
		--speaker:Play(SoundEffect.SOUND_MAW_OF_VOID, 1, 0, false, 1)
	else
		if sprite:IsEventTriggered("Stomp") then
			game:ShakeScreen(10)
			speaker:Play(SoundEffect.SOUND_FORESTBOSS_STOMPS, 1, 0, false, 0.5);
			local entities = Isaac.GetRoomEntities()
			for i = 1, #entities do
				if entities[i]:IsVulnerableEnemy() then
					if entities[i].Position:Distance(eff.Position) < entities[i].Size + eff.Size + 20 then
						entities[i]:TakeDamage(player.Damage * 35, 0, EntityRef(eff), 1)
					end
				end
			end
			SpawnHeartParticles( 1, 1, eff.Position, RandomHeartParticleVelocity(), player, HeartParticleType.Black );
		else
			local entities = Isaac.GetRoomEntities()
			for i = 1, #entities do
				if entities[i]:IsVulnerableEnemy() then
					if entities[i].Position:Distance(eff.Position) < entities[i].Size + eff.Size + 20 then
						entities[i]:AddSlowing(EntityRef(player), 10, 0.2, entities[i].Color)
					end
				end
			end
		end
		if sprite:IsFinished("Stomp") then
			eff:Remove();
		end
	end
end, ENTITY_LABAN_STOMP);

yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local player = Isaac.GetPlayer(0)
	local controller = player.ControllerIndex
	local sprite = eff:GetSprite()
	
	if eff.FrameCount == 1 then
		sprite:Play("Start", true) --normal attack
		speaker:Play(SoundEffect.SOUND_MAW_OF_VOID, 1, 0, false, 1)
	elseif sprite:IsFinished("Start") then
		sprite:Play("Loop", true)
	elseif eff.FrameCount < 30 and not sprite:IsPlaying("Start")then
		local entities = Isaac.GetRoomEntities()
		for i = 1, #entities do
			if entities[i]:IsVulnerableEnemy() then
				if entities[i].Position:Distance(eff.Position) < entities[i].Size + eff.Size + 50 then
					entities[i]:TakeDamage(player.Damage * 2, 0, EntityRef(eff), 1)
				end
			end
		end
		SpawnHeartParticles( 1, 1, eff.Position, RandomHeartParticleVelocity(), player, HeartParticleType.Black );
	elseif eff.FrameCount == 30 then
		sprite:Play("End", true);
	elseif sprite:IsFinished("End") then
		eff:Remove();
	end
end, ENTITY_DARKBEAMINTHESKY);

--evilorb effect
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local sprite = eff:GetSprite()
	local data = GetEntityData(eff)
	local player = data.Parent
	
	if eff.SubType == 0 then
		if eff.FrameCount == 1 then
			if not data.setDespawn then data.setDespawn = math.random(500,700) end
			if not data.HitPoints then data.HitPoints = 10 end
			eff.SpriteScale = Vector(1.5, 1.5);
		end

		for i, entenmies in pairs(Isaac.GetRoomEntities()) do
			--local ents = Isaac.GetRoomEntities() --shorten this damn thing lol
			if entenmies:IsEnemy() --[[and not entenmies:IsEffect() and not entenmies:IsInvulnurable()]] then
				if entenmies.Position:Distance(eff.Position) < entenmies.Size + eff.Size + 15 then
					if eff.FrameCount % 5 == (0) then
						entenmies:TakeDamage(player.Damage/3, 0, EntityRef(eff), 4)
						--data.HitPoints = data.HitPoints - 1
					end
					--gotta nerf this sucking thing
					--entenmies.Velocity = (eff.Position - entenmies.Position):Resized(2)
				end
			end
		end
		if eff.FrameCount == data.setDespawn or data.HitPoints <= 0 then 
			eff:Remove()
			local numofParticles = math.random(1,3)
			for i = 1, numofParticles do
				local part = Isaac.Spawn(EntityType.ENTITY_EFFECT, ENTITY_HEARTPARTICLE, 0, eff.Position, Vector.FromAngle(1*math.random(1,360))*(math.random(2,4)), player) --heart effect
				if not GetEntityData(part).Small then GetEntityData(part).Small = true end
				part:GetSprite():ReplaceSpritesheet(0, "gfx/effects/heart_black.png") 
				part:GetSprite():LoadGraphics()
			end
		end
		if data.ChainExplode then --deprecated?
			for i, orb in pairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, ENTITY_EVILORB, -1, false, false)) do
				if orb.Position:Distance(eff.Position) < orb.Size + eff.Size + 120 then
					GetEntityData(orb).ChainExplode = true
				end
			end
			for i, entenmies in pairs(Isaac.GetRoomEntities()) do
				if entenmies:IsEnemy() then
					if entenmies.Position:Distance(eff.Position) < entenmies.Size + eff.Size + 140 then
						entenmies:TakeDamage(player.Damage*6.5, 0, EntityRef(eff), 4)
					end
				end
			end
			local part = Isaac.Spawn(EntityType.ENTITY_EFFECT, ENTITY_DARKBOOM2, 0, eff.Position, Vector(0,0), player);
			game:ShakeScreen(10)
			speaker:Play(SoundEffect.SOUND_FORESTBOSS_STOMPS, 1, 0, false, 0.5);
			eff:Remove();
		end
		if data.Heretic and not data.beam then
			local target
			local farthestOrb = 0 -- labels the farthest enemy
			for i, ent in pairs (Isaac.GetRoomEntities()) do
				if ent.Type == EntityType.ENTITY_EFFECT and ent.Variant == ENTITY_EVILORB and not GetEntityData(ent).Heretic then
					--print(ent.Variant, "  ", ENTITY_EVILORB)
					if farthestOrb <= ent.Position:Distance(eff.Position) then
						farthestOrb = ent.Position:Distance(eff.Position)
						target = ent
					end
				end
			end
			
			local beam
			local angle
			print(target)
			if target then --aims then to the furthest orb
				angle = SchoolbagAPI.ObjToTargetAngle(eff, target, true)
				beam = player:FireBrimstone( Vector.FromAngle(angle), eff, 2):ToLaser();
				--beam = EntityLaser.ShootAngle(1, eff.Position, angle, 5, Vector(0,-5), player):ToLaser()
				beam.Position = eff.Position
				beam:AddTearFlags(player.TearFlags)
				beam.MaxDistance = farthestOrb
				beam.Timeout = 20
				beam.DisableFollowParent = true
				GetEntityData(target).Heretic = true
				beam:SetColor(Color(0,0,0,1,0.8,0,1),9999999,99,false,false)
			else
				local newTarget
				local strongestHP = 0 -- labels the highest enemy hp
				for i, entenmies in pairs(Isaac.GetRoomEntities()) do
					if entenmies:IsEnemy() and entenmies:IsVulnerableEnemy() then
						if strongestHP <= entenmies.MaxHitPoints then
							strongestHP = entenmies.MaxHitPoints
							newTarget = entenmies
						end
					end
				end
				if newTarget then
					angle = SchoolbagAPI.ObjToTargetAngle(eff, newTarget, true)
					beam = player:FireBrimstone( Vector.FromAngle(angle), eff, 2):ToLaser();
					--beam = EntityLaser.ShootAngle(1, eff.Position, angle, 5, Vector(0,-5), player):ToLaser()
					beam:AddTearFlags(player.TearFlags)
					beam.Position = eff.Position
					--beam.Damage = player.Damage * 2
					beam.CollisionDamage = player.Damage * 2
					beam.Timeout = 20
					beam.DisableFollowParent = true
					beam:SetColor(Color(0,0,0,1,0.8,0,1),9999999,99,false,false)
				else
					data.HitPoints = 0
				end
			end
			data.HitPoints = 0 --kill it
			data.beam = beam
		end
	elseif eff.SubType == 1 then
		if eff.FrameCount == 1 then
			if not data.setDespawn then data.setDespawn = math.random(300,400) end
			if not data.HitPoints then data.HitPoints = 10 end
			--eff.SpriteScale = Vector(1.5, 1.5);
		end

		for i, entenmies in pairs(Isaac.GetRoomEntities()) do
			--local ents = Isaac.GetRoomEntities() --shorten this damn thing lol
			if entenmies:IsEnemy() --[[and not entenmies:IsEffect() and not entenmies:IsInvulnurable()]] then
				if entenmies.Position:Distance(eff.Position) < entenmies.Size + eff.Size + 15 then
					if eff.FrameCount % 5 == (0) then
						entenmies.Velocity = entenmies.Velocity * 0.8
						entenmies:TakeDamage(player.Damage/2, 0, EntityRef(eff), 4)
						--data.HitPoints = data.HitPoints - 1
					end
					if eff.FrameCount % 8 == (0) then --suck
						entenmies.Velocity = (eff.Position - entenmies.Position):Resized(10)
					end
					--gotta nerf this sucking thing
					--entenmies.Velocity = (eff.Position - entenmies.Position):Resized(2)
				end
			end
		end
		if eff.FrameCount == data.setDespawn or data.HitPoints <= 0 then 
			eff:Remove()
			local numofParticles = math.random(1,3)
			for i = 1, numofParticles do
				local part = Isaac.Spawn(EntityType.ENTITY_EFFECT, ENTITY_HEARTPARTICLE, 0, eff.Position, Vector.FromAngle(1*math.random(1,360))*(math.random(2,4)), player) --heart effect
				if not GetEntityData(part).Small then GetEntityData(part).Small = true end
				part:GetSprite():ReplaceSpritesheet(0, "gfx/effects/heart_black.png") 
				part:GetSprite():LoadGraphics()
			end
		end
		if data.ChainExplode then
			for i, orb in pairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, ENTITY_EVILORB, -1, false, false)) do
				if orb.Position:Distance(eff.Position) < orb.Size + eff.Size + 120 then
					GetEntityData(orb).ChainExplode = true
				end
			end
			for i, entenmies in pairs(Isaac.GetRoomEntities()) do
				if entenmies:IsEnemy() then
					if entenmies.Position:Distance(eff.Position) < entenmies.Size + eff.Size + 140 then
						entenmies:TakeDamage(player.Damage*6.5, 0, EntityRef(eff), 4)
					end
				end
			end
			local part = Isaac.Spawn(EntityType.ENTITY_EFFECT, ENTITY_DARKBOOM2, 0, eff.Position, Vector(0,0), player);
			game:ShakeScreen(10)
			speaker:Play(SoundEffect.SOUND_FORESTBOSS_STOMPS, 1, 0, false, 0.5);
			eff:Remove();
		end
	end
end, ENTITY_EVILORB);

yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, function(_, eff)
	eff.SpriteScale = Vector(0, 0)
end, ENTITY_DARKMAW);

--darkmaw effect
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local player = Isaac.GetPlayer(0)
	local sprite = eff:GetSprite()
	local data = GetEntityData(eff)
	local playerdata = GetEntityData(player)
	
	local scaleNum 
	local range = -player.TearHeight/2
	if eff.FrameCount < range then scaleNum = eff.FrameCount else scaleNum = range end
		
	if eff:GetSprite():IsFinished("Die") then
		eff:Remove()
		for i, entenmies in pairs(Isaac.GetRoomEntities()) do
			if entenmies.Position:Distance(eff.Position) <= (scaleNum*8) + entenmies.Size then
				if entenmies:IsEnemy() and entenmies:IsVulnerableEnemy() then
					SchoolbagAPI.DoKnockbackTypeI(eff, entenmies, 0.1, false)
				end
			end
		end
	elseif not  eff:GetSprite():IsPlaying("Die") then
		for i, entenmies in pairs(Isaac.GetRoomEntities()) do
			if entenmies:IsEnemy() then
				if entenmies.Position:Distance(eff.Position) <= (scaleNum*8) + entenmies.Size then
					if eff.FrameCount % 10 == (0) then --damage
						entenmies:TakeDamage(player.Damage/5, 0, EntityRef(eff), 4)
					end
					if eff.FrameCount % 3 == (0) then --suck
						entenmies.Velocity = (eff.Position - entenmies.Position):Resized(4)
					end
				end
			end
		end
		
		local scaleNum2 = scaleNum/10
		eff.SpriteScale = Vector(scaleNum2, scaleNum2)

		eff.Velocity = player.Velocity
		eff.Position = player.Position
	end
	
end, ENTITY_DARKMAW);

--[[ NYI?
yandereWaifu:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, ent, damage, dmgFlag, dmgSource, dmgCountdownFrames)
	if dmgSource.Type == EntityType.ENTITY_EFFECT and dmgSource.Variant == ENTITY_EVILORB then
		if (ent.HitPoints - damage) <= 0 then
			print("howdy")
			for a = 0, 360, 360/8 do --too lazy to calculate what 36--360-16 is lol
				local matter = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0, dmgSource.Position, Vector.FromAngle(a)*(7), ent):ToTear() --feather attack
				matter.TearFlags = TearFlags.TEAR_HORN
			end
		end
	end
end)
]]

--dark boom effects
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local player = Isaac.GetPlayer(0)
	local sprite = eff:GetSprite()
	local data = eff:GetData()
	
	if eff.FrameCount == 1 then
		sprite:Play("Spawn", true) --normal attack
	elseif sprite:GetFrame() == 2 then
		--[[for i, entenmies in pairs(Isaac.GetRoomEntities()) do --suck enemies away
			if entenmies:IsEnemy() and entenmies:IsVulnerableEnemy() then
				if entenmies.Position:Distance(player.Position) < entenmies.Size + player.Size + 100 then
					entenmies.Velocity = (entenmies.Velocity - (entenmies.Position - player.Position)) * 0.8
				end
			end
		end]]
	elseif sprite:IsFinished("Spawn") then
		eff:Remove()
	end
end, ENTITY_DARKBOOM)
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local player = Isaac.GetPlayer(0)
	local sprite = eff:GetSprite()
	local data = eff:GetData()
	
	if eff.FrameCount == 1 then
		sprite:Play("Spawn", true) --normal attack
	elseif sprite:IsFinished("Spawn") then
		eff:Remove()
	end
end, ENTITY_DARKBOOM2)
--dark knife
function yandereWaifu:DarkKnifeRender(tr, _)
	if tr.Variant == ENTITY_DARKKNIFEFADE then
		local angleNum = (tr.Velocity):GetAngleDegrees();
		tr:GetSprite().Rotation = angleNum;
		tr:GetData().Rotation = tr:GetSprite().Rotation;
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, yandereWaifu.DarkKnifeRender)
yandereWaifu:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, function(_, tr)
	if tr.Variant == ENTITY_DARKKNIFEFADE then
		local part = Isaac.Spawn(EntityType.ENTITY_EFFECT, ENTITY_DARKKNIFEFADE, 0, tr.Position, Vector(0,0), tr) --heart effect
		part:GetSprite().Rotation = tr:GetData().Rotation
	end
end, EntityType.ENTITY_TEAR)

function yandereWaifu:DarkKnifeRender(tr, _)
	if tr.Variant == ENTITY_DARKKNIFE then
		tr:GetSprite():Play("RegularTear", false);
		--tr:GetSprite():LoadGraphics();
		
		local angleNum = (tr.Velocity):GetAngleDegrees();
		tr:GetSprite().Rotation = angleNum;
		tr:GetData().Rotation = tr:GetSprite().Rotation;
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_POST_TEAR_RENDER, yandereWaifu.DarkKnifeRender)

--bomb dark effect
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local player = Isaac.GetPlayer(0)
	local sprite = eff:GetSprite()
	local data = eff:GetData()
	
	if eff.FrameCount == 1 then
		sprite:Play("Explosion", true) --normal attack
		speaker:Play(SOUND_LASEREXPLOSION, 10, 0, false, 1);
		speaker:Play(SoundEffect.SOUND_BOSS1_EXPLOSIONS , 1, 0, false, 0.4);
		local ashes = Isaac.Spawn( EntityType.ENTITY_EFFECT, 18, 0, eff.Position, Vector( 0 , 0 ), player );
		ashes.SpriteScale = Vector(2.5, 2.5);
		for i, grid in pairs(SchoolbagAPI.GetRoomGrids()) do
			if (grid.Position-eff.Position):LengthSquared() <= 100 ^ 2 and grid ~= nil then
				if game:GetRoom():CheckLine(grid.Position, eff.Position, 2, 0) then
					grid:Destroy()
				end
			end
		end
	elseif eff.FrameCount >= 4 then
		for i, entenmies in pairs(Isaac.GetRoomEntities()) do
			--if entenmies:IsEnemy() then
				if entenmies.Position:Distance(eff.Position) <= (150) + entenmies.Size then
					--damage
					if entenmies:IsEnemy() then
						entenmies:TakeDamage(player.Damage*5, DamageFlag.DAMAGE_EXPLOSION, EntityRef(eff), 4)
					else
						entenmies:TakeDamage(2, DamageFlag.DAMAGE_EXPLOSION, EntityRef(eff), 4)
					end
					--suck
					entenmies.Velocity = (eff.Position - entenmies.Position):Resized(4)
				end
			--end
		end
		game:ShakeScreen(3)
	end
	if sprite:IsFinished("Explosion") then
		eff:Remove()
	end
end, ENTITY_DARKSUPERNOVA)
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local player = Isaac.GetPlayer(0)
	local sprite = eff:GetSprite()
	local data = GetEntityData(eff)
	
	if eff.FrameCount == 1 then
		if data.Sub then
			sprite:Play("SpinSmall", true) --normal attack
		else
			sprite:Play("Spin", true) --normal attack
		end
	elseif SchoolbagAPI.IsFinishedMultiple(sprite, "SpinSmall", "Spin")  then
		eff:Remove()
		local orb = Isaac.Spawn( EntityType.ENTITY_EFFECT, ENTITY_DARKSUPERNOVA, 0, eff.Position, Vector( 0 , 0 ), player );
	end
	if eff.FrameCount % 3 == 0 then
		speaker:Play(SOUND_DEEPELECTRIC, 5, 0, false, 1);
	end
	eff.Velocity = eff.Velocity * 0.9
end, ENTITY_DARKPLASMA)

--hole fabric effect
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, function(_, eff)
	local player = Isaac.GetPlayer(0)
	local sprite = eff:GetSprite()
	
	if player:HasWeaponType(WeaponType.WEAPON_ROCKETS) then
		sprite:ReplaceSpritesheet(0, "gfx/effects/hole_fabric_epic.png") 
	end
	if player:HasWeaponType(WeaponType.WEAPON_KNIFE) then
		sprite:ReplaceSpritesheet(2, "gfx/effects/hole_fabric_spike.png") 
	end
end, ENTITY_HOLEFABRIC);

yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local player = GetEntityData(eff).Parent:ToPlayer();
	local sprite = eff:GetSprite();
	local data = GetEntityData(eff);
	
	if eff.FrameCount == 1 then
		if not data.setDespawn then data.setDespawn = math.random( 300, 2000 ) end
		if not data.extraTears then data.extraTears = 0 end
		if player:HasCollectible(CollectibleType.COLLECTIBLE_INNER_EYE) and player:HasCollectible(CollectibleType.COLLECTIBLE_MUTANT_SPIDER) then
			data.extraTears = 7
		elseif player:HasCollectible(CollectibleType.COLLECTIBLE_INNER_EYE) then
			data.extraTears = 3
		elseif player:HasCollectible(CollectibleType.COLLECTIBLE_MUTANT_SPIDER) then
			data.extraTears = 4
		else
			data.extraTears = 1
		end
	end

	if eff.FrameCount == 1 then
		sprite:Play( "Appear", true ); --normal attack
		eff.SpriteOffset = Vector( 0, -20 );
		sprite:LoadGraphics();
		speaker:Play( SoundEffect.SOUND_MAW_OF_VOID, 1, 0, false, 1);
	elseif sprite:IsFinished("Appear") then
		if player:HasCollectible(CollectibleType.COLLECTIBLE_LITTLE_HORN) then
			sprite:Play( "IdleHorn", true );
		else
			sprite:Play( "Idle", true );
		end
	elseif sprite:IsPlaying("IdleHorn")then
		if sprite:IsEventTriggered("Grab") then
			speaker:Play(SoundEffect.SOUND_BOSS_LITE_ROAR, 1, 0, false, 1)
			speaker:Play(SoundEffect.SOUND_FORESTBOSS_STOMPS, 1, 0, false, 1)
			game:ShakeScreen(5)
			for i, entenmies in pairs(Isaac.GetRoomEntities()) do
				if entenmies:IsEnemy() then
					if entenmies.Position:Distance(eff.Position) <= (200) + entenmies.Size then
						--damage
						if entenmies.Position:Distance(eff.Position) <= (180) + entenmies.Size then
							if not entenmies:IsBoss() then
								entenmies:Kill()
							else
								entenmies:TakeDamage(player.Damage*10, 0, EntityRef(eff), 4)
							end
						end
						--succ
						entenmies.Velocity = (eff.Position - entenmies.Position):Resized(10)
					end
				end
			end
		end
	elseif sprite:IsPlaying("Idle")then
		if player:HasWeaponType(WeaponType.WEAPON_LASER) then --tech barrage
			if eff.FrameCount % 3 == 0 then
				local rng = math.random(1,360)
				local techlaser = player:FireTechLaser(eff.Position, 0, Vector.FromAngle(rng), false, true)
				techlaser.Timeout = 3;
				techlaser:SetMaxDistance(math.random(100,120))
				techlaser:SetHomingType(1)
				techlaser.CollisionDamage = player.Damage / 2;
				
				local customColor = Color(0, 0, 0, 0, 0, 0, 0)
				techlaser:SetColor(customColor, 2, 5, true, true)
			end
		end
		if sprite:IsEventTriggered("Suck") then
			local suck = Isaac.Spawn( EntityType.ENTITY_EFFECT, ENTITY_DARKBOOM, 0, eff.Position, Vector( 0 , 0 ), player );
			speaker:Play(SoundEffect.SOUND_BIRD_FLAP, 1, 0, false, 0.3);
			if player:HasWeaponType(WeaponType.WEAPON_KNIFE) then --knife synergy
				local randomNum = math.random(-30,30)
				for i = 0, 360, 360/8 do
					local tear = player:FireTear( eff.Position, Vector.FromAngle(i+randomNum):Resized(50), false, false, false):ToTear()
					tear.TearFlags = tear.TearFlags | TearFlags.TEAR_HOMING | TearFlags.TEAR_PIERCING;
					tear.CollisionDamage = player.Damage * 2;
					tear:ChangeVariant(ENTITY_DARKKNIFE);
				end
			end
			if player:HasWeaponType(WeaponType.WEAPON_TECH_X) then
				local random = math.random(3,6)
				for i = 1, random do
					local circle = player:FireTechXLaser(eff.Position, Vector.FromAngle(math.random(1,360))*(20), math.random(10,20))
					circle:SetColor(Color(0,0,0,0.7,170,170,210),9999999,99,false,false);
				end
			end
		elseif sprite:IsEventTriggered("Hyperbeam") then
			if player:HasWeaponType(WeaponType.WEAPON_BOMBS) then 
				sprite:Play("Death", true);
				local orb = Isaac.Spawn( EntityType.ENTITY_EFFECT, ENTITY_DARKPLASMA, 0, eff.Position, Vector( 0 , 0 ), player );
				
				if data.extraTears > 1 then
					local orb2 = Isaac.Spawn( EntityType.ENTITY_EFFECT, ENTITY_DARKPLASMA, 0, eff.Position, Vector.FromAngle(math.random(0,360)):Resized(5), player );
					GetEntityData(orb2).Sub = true
				end
			elseif not player:HasWeaponType(WeaponType.WEAPON_ROCKETS) then
				data.EnemyHasDefined = nil; --force it to nil
				data.highestHp = 0;
				for i, entities in pairs(Isaac.GetRoomEntities()) do
					if entities:IsEnemy() and entities.HitPoints > data.highestHp then
						data.highestHp = entities.HitPoints
						data.EnemyHasDefined = entities
					end
				end
				if data.EnemyHasDefined then
					local angle = (data.EnemyHasDefined.Position - eff.Position):GetAngleDegrees();
					data.targetAngle = angle;
					data.targetPos = data.EnemyHasDefined.Position;
					local laserType
					if player:HasCollectible(CollectibleType.COLLECTIBLE_POLYPHEMUS) then
						laserType = 6
					else
						laserType = 1
					end
					local hyperbeamlol = EntityLaser.ShootAngle(laserType, eff.Position, data.targetAngle, 10 * laserType, Vector(0,0), player):ToLaser();
					if not GetEntityData(hyperbeamlol).IsDark then 
						if laserType == 1 then
							GetEntityData(hyperbeamlol).IsDark = 1 
						else
							GetEntityData(hyperbeamlol).IsDark = 2 
						end
					end
					hyperbeamlol.DisableFollowParent = true;
					hyperbeamlol.CollisionDamage = (player.Damage * 1.77)/2
					hyperbeamlol.TearFlags = player.TearFlags | TearFlags.TEAR_HOMING
				end
			end
		elseif sprite:WasEventTriggered("Hyperbeam") then
			if player:HasWeaponType(WeaponType.WEAPON_ROCKETS) then 
				for i, entenmies in pairs(Isaac.GetRoomEntities()) do
					if entenmies:IsEnemy() then
						if entenmies.Position:Distance(eff.Position) <= (600) + entenmies.Size then
							--damage
							if entenmies.Position:Distance(eff.Position) <= (50) + entenmies.Size then
								entenmies:TakeDamage(player.Damage, 0, EntityRef(eff), 4)
							end
							--succ
							entenmies.Velocity = (eff.Position - entenmies.Position):Resized(10)
						end
					end
				end
			end
		end
		if math.random(1,5) == 5 then
			SpawnHeartParticles( 1, 1, eff.Position, RandomHeartParticleVelocity(), player, HeartParticleType.Evil );
		end
	elseif SchoolbagAPI.IsFinishedMultiple(sprite,"Idle","IdleHorn") then
		if data.extraTears > 1 then
			data.extraTears = data.extraTears - 1
			sprite:Play("Idle", true);
		else
			sprite:Play("Death", true);
			if player:HasWeaponType(WeaponType.WEAPON_ROCKETS) then 
				local orb = Isaac.Spawn( EntityType.ENTITY_EFFECT, ENTITY_DARKSUPERNOVA, 0, eff.Position, Vector( 0 , 0 ), player );
			end
		end
	elseif sprite:IsFinished("Death") then
		eff:Remove();
		for i, orb in pairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, ENTITY_EVILORB, -1, false, false)) do
			if orb.Position:Distance(eff.Position) < orb.Size + eff.Size + 100 then
				GetEntityData(orb).ChainExplode = true
			end
			local part = Isaac.Spawn(EntityType.ENTITY_EFFECT, ENTITY_DARKBOOM2, 0, eff.Position, Vector(0,0), player);
		end
	end
end, ENTITY_HOLEFABRIC);

end

--ETERNAL HEART--
do
--light boom effect
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local player = Isaac.GetPlayer(0)
	local sprite = eff:GetSprite()
	local data = eff:GetData()
	
	if eff.FrameCount == 1 then
		sprite:Play("Spawn", true) --normal attack
	elseif sprite:GetFrame() == 2 and not data.NotEternal then
		for i, entenmies in pairs(Isaac.GetRoomEntities()) do --push enemies away
			if entenmies:IsEnemy() and entenmies:IsVulnerableEnemy() then
				if entenmies.Position:Distance(player.Position) < entenmies.Size + player.Size + 100 then
					entenmies.Velocity = (entenmies.Velocity + (entenmies.Position - player.Position)) * 0.5
					if not entenmies:GetData().IsBlessed then entenmies:GetData().IsBlessed = math.random(90,800) end
				end
			end
		end
	elseif sprite:IsFinished("Spawn") then
		eff:Remove()
	end
end, ENTITY_LIGHTBOOM)

yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_,  fam) --eternal star
	local spr = fam:GetSprite()
	local rng = math.random(1, 100)
	local player = Isaac.GetPlayer(0)
	local data = GetEntityData(fam)
	
	local currentSide = nil
	local brideProtectorAngle = (fam.Player.Velocity):GetAngleDegrees()
	local willFlip = false
	local neededPosition = fam.Player.Position --+ Vector(-50,0):Rotated(brideProtectorAngle)
	
	if brideProtectorAngle >= 45 and brideProtectorAngle <= 135 and currentSide ~= "down" then
		currentSide = "down"
	elseif brideProtectorAngle <= -45 and brideProtectorAngle >= -135 and currentSide ~= "up" then
		currentSide = "up"
	elseif (brideProtectorAngle <= 0 and brideProtectorAngle >= -45) or (brideProtectorAngle >= 0 and brideProtectorAngle <= 45) and currentSide ~= "right" then
		currentSide = "right"
	elseif (brideProtectorAngle <= 180 and brideProtectorAngle >= 135) or (brideProtectorAngle >= -180 and brideProtectorAngle <= -135) and currentSide ~= "left" then
		currentSide = "left"
	end
	--delayed saved velocity
	data.delayedVel = data.delayedVel or nil
	SchoolbagAPI.SetTimer( 1, function()
		data.delayedVel = fam.Velocity * 1.2
	end)
	if data.delayedVel then
		fam.Velocity = fam.Velocity*0.95 + ((neededPosition - fam.Position)*0.02) ; 
	end
	if not SchoolbagAPI.IsPlayingMultiple(spr, "Idle6", "Idle4", "Idle0", "Idle2", "Idle1", "Idle7", "Idle3", "Idle5") then --sets playing sprite
		SchoolbagAPI.AnimWalkFrame(fam, true, "Idle6", "Idle4", "Idle0", "Idle2", "Idle1", "Idle7", "Idle3", "Idle5")
	end
	-- print(brideProtectorAngle)
	fam:AddEntityFlags(EntityFlag.FLAG_SLIPPERY_PHYSICS)
end, ENTITY_MORNINGSTAR);


yandereWaifu:AddCallback(ModCallbacks.MC_POST_FAMILIAR_RENDER, function(_,  fam) --eternal star
	--set chains
	
	--SchoolbagAPI.AttachChain(fam.Player, fam)
	--SchoolbagAPI.AttachChain3(fam.Player, fam, "gfx/effects/eternal/eternalmorningstar.anm2", "Chain", 48)
	
	local data = SchoolbagAPI.GetSAPIData(fam)
	if not data.Init then                                             
		data.spr = Sprite()                                                 
		data.spr:Load("gfx/effects/eternal/eternalmorningstar.anm2", true) 
		data.spr:SetFrame("Chain", 1)
		data.Init = true                                              
	end          
	SchoolbagAPI.DeadDrawRotatedTilingSprite(data.spr, Isaac.WorldToScreen(fam.Player.Position), Isaac.WorldToScreen(fam.Position), 16, nil, 8, true)
	--i hate you api
	data.sprOverlay = fam:GetSprite()
	data.sprOverlay:Render(Isaac.WorldToScreen(fam.Position))
end, ENTITY_MORNINGSTAR);

--eternal feather
function yandereWaifu:FeatherRender(tr, _)
	if tr.Variant == ENTITY_ETERNALFEATHER then
		local player, data, flags, scale = tr.Parent, GetEntityData(tr), tr.TearFlags, tr.Scale 
		local size = SchoolbagAPI.GetTearSizeTypeII(scale, flags)
		SchoolbagAPI.UpdateRegularTearAnimation(player, tr, data, flags, size);

		tr:GetSprite():Play("RegularTear4", false);
		tr:GetSprite():LoadGraphics();
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_POST_TEAR_RENDER, yandereWaifu.FeatherRender)

function yandereWaifu:FeatherUpdate(tr)
	local data = GetEntityData(tr)
	local player = tr.SpawnerEntity
	if tr.Variant == ENTITY_ETERNALFEATHER then
		data.EnemyHasDefined = nil --force it to nil
		data.closestEnt = 0
		--laggy
		SchoolbagAPI.SpawnTrail(tr)
		--so this thing floats forever
		if tr.FrameCount >= 1 and tr.FrameCount <= 10 then
			data.firstHeight = tr.Height
		else
			if tr.FrameCount >= 10 and tr.FrameCount <= 30 then
				if not tr:GetData().NotSmart then
					if --[[tr.FrameCount % 10 == 0]] not data.HasFoundTarget then
						data.HasFoundTarget = true
						local e 
						if SchoolbagAPI.GetStrongestEnemy(tr,10000) then
							e = SchoolbagAPI.GetStrongestEnemy(tr,10000)
						end
						if e then
							tr.Velocity = tr.Velocity * 0.9 + ((e.Position-tr.Position):Resized(16))
						end
					end
				end
			else
				data.firstHeight = nil
			end
			local angleNum = (tr.Velocity):GetAngleDegrees();
			tr.SpriteRotation = angleNum + 90;
			tr:GetData().Rotation = tr:GetSprite().Rotation;
		end
		if data.firstHeight --[[and tr.FrameCount < 120]] then
			if tr.Height >= data.firstHeight --[[-6]] then
				tr.Height = data.firstHeight
			end
		end
		if player.Position:Distance(tr.Position) >= 500 then
			tr:Remove()
		end
		if tr:IsDead() then
			local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.TEAR_POOF_A, 0, tr.Position, Vector(0,0), player) --poof e
			poof:GetSprite():ReplaceSpritesheet(0, "gfx/effects/featherpoof.png") 
		end
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, yandereWaifu.FeatherUpdate)

--featherbreak effect
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local player = Isaac.GetPlayer(0)
	local sprite = eff:GetSprite()
	local data = eff:GetData()
	
	--sprite:LoadGraphics()
	if eff.FrameCount == 1 then
		sprite:Play("Break",true)
	elseif sprite:IsFinished("Break") then
		eff:Remove()
	end
end, ENTITY_FEATHERBREAK)

--tearbreak functionality effect
yandereWaifu:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, function(_, tr)
	if tr.Variant == ENTITY_ETERNALFEATHER then
		local part = Isaac.Spawn(EntityType.ENTITY_EFFECT, ENTITY_FEATHERBREAK, 0, tr.Position, Vector(0,0), tr) --heart effect
		part:GetSprite().Rotation = tr:GetData().Rotation
	end
end, EntityType.ENTITY_TEAR)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, function(_,tear)
    local parent, spr, data = tear.Parent, tear:GetSprite(), GetEntityData(tear)
	--print(tear.Parent, "  ", parent.Variant, FamiliarVariant.INCUBUS)
    local player = parent:ToPlayer()
    if parent.Type == EntityType.ENTITY_FAMILIAR and parent.Variant == FamiliarVariant.INCUBUS then
      player = parent:ToFamiliar().Player
    end
	
	--tear:ChangeVariant(ENTITY_ETERNALFEATHER)
    --tear.TearFlags = tear.TearFlags | TearFlags.TEAR_SPECTRAL
	
    if player:GetPlayerType() == Reb and currentMode == REBECCA_MODE.EternalHearts and tear.TearFlags & TearFlags.TEAR_LUDOVICO ~= TearFlags.TEAR_LUDOVICO then
        tear:ChangeVariant(ENTITY_ETERNALFEATHER)
        tear.TearFlags = tear.TearFlags | TearFlags.TEAR_SPECTRAL
		tear:GetData().NotSmart = true
    end
end)
	
end

--BONE HEART--
do
function yandereWaifu:onFamiliarBoneStandInit(fam)
    fam.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
	local data = GetEntityData(fam)
	local player = fam.Player
	player.Visible = false
    local sprite = fam:GetSprite()
    sprite:Play("Spawn", true)
end
yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, yandereWaifu.onFamiliarBoneStandInit, ENTITY_BONESTAND);

yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_,  fam) --bone stand
	local spr = fam:GetSprite()
	local rng = math.random(1, 100)
	local player = fam.Player:ToPlayer()
	local data = GetEntityData(fam)
	local body = data.Body
	local controller = player.ControllerIndex
	
	player.Velocity = fam.Velocity
	player.Position = fam.Position
	
	if not data.TriggerFrame then data.TriggerFrame = 35 end --sets up how long the frame left to trigger before reverting back
	
	data.TriggerFrame = data.TriggerFrame - 1
	
	if not data.FireDelay then data.FireDelay = math.floor(player.MaxFireDelay/3) end --sets how much one can shoot depending on player stats
	if data.FireDelay > 0 then data.FireDelay = data.FireDelay - 1 end
	
	if spr:IsFinished("Spawn") then
		data.Angle = SchoolbagAPI.AnimShootFrame(fam, true, data.Angle, "MoveSideward", "MoveForward", "MoveBackward")
	end
	
	--use heaart reserve
	yandereWaifu:addReserveFill(player, -1)
	
	if SchoolbagAPI.IsFinishedMultiple(spr, "AttackSideward", "AttackForward", "AttackBackward") then --reset after done shooting
		SchoolbagAPI.AnimShootFrame(fam, true, Vector.FromAngle(data.Angle), "MoveSideward", "MoveForward", "MoveBackward")
	end
	
	if player:GetShootingInput():GetAngleDegrees() == data.Angle and (player:GetShootingInput().X ~= 0 or player:GetShootingInput().Y ~= 0 ) then-- and player:GetShootingInput().Y == Vector.FromAngle(data.Angle).Y then
		data.TriggerFrame = 35
		
		fam.Velocity = Vector.Zero --stop
		
		if data.FireDelay <= 0 then
			if rng < 51 then
				local tears = player:FireTear(fam.Position + Vector(0,20):Rotated(player:GetShootingInput():GetAngleDegrees()), player:GetShootingInput():Resized(10), false, false, false):ToTear()
				tears:ChangeVariant(ENTITY_RAPIDPUNCHTEAR)
				if (tears:GetSprite().Rotation >= -180 and tears:GetSprite().Rotation <= 0) then	
					tears:GetSprite().FlipX = false
				elseif (tears:GetSprite().Rotation >= 0 and tears:GetSprite().Rotation <= 180) then	
					tears:GetSprite().FlipX = true
				end
			else
				local tears = player:FireTear(fam.Position - Vector(0,20):Rotated(player:GetShootingInput():GetAngleDegrees()), player:GetShootingInput():Resized(10), false, false, false):ToTear()
				tears:ChangeVariant(ENTITY_RAPIDPUNCHTEAR)
				if (tears:GetSprite().Rotation >= -180 and tears:GetSprite().Rotation <= 0) then	
					tears:GetSprite().FlipX = false
				elseif (tears:GetSprite().Rotation >= 0 and tears:GetSprite().Rotation <= 180) then	
					tears:GetSprite().FlipX = true
				end
			end
			data.FireDelay = math.floor(player.MaxFireDelay/3) --reset
		end
		
		SchoolbagAPI.AnimShootFrame(fam, true,  Vector.FromAngle(data.Angle), "AttackSideward", "AttackForward", "AttackBackward")
	end
	if player:GetMovementInput().X ~= 0 or player:GetMovementInput().Y ~= 0 then --move code
		if SchoolbagAPI.IsPlayingMultiple(spr, "MoveSideward") then
			fam.Velocity = Vector(player:GetMovementInput().X, 0)*10
		end
		if SchoolbagAPI.IsPlayingMultiple(spr, "MoveForward", "MoveBackward") then
			fam.Velocity = Vector(0, player:GetMovementInput().Y)*10
		end
	else
		fam.Velocity = Vector.Zero
	end
			
	print(data.TriggerFrame, player:GetShootingInput(), Vector.FromAngle(data.Angle):Normalized(), data.Angle)
	
	if data.TriggerFrame <= 0 then
		GetEntityData(player).IsAttackActive = false
		fam:Remove()
		player.Visible = true;
		player.ControlsEnabled = true;
		player.GridCollisionClass = GetEntityData(player).LastGridCollisionClass;
		player.EntityCollisionClass = GetEntityData(player).LastEntityCollisionClass;
		GetEntityData(player).NoBoneSlamActive = true
		
		player.Position = body.Position
		body:Remove()
		--SchoolbagAPI.RefundActiveCharge(player, 1, true)
	end
	
end, ENTITY_BONESTAND);

--firing random stuff
function yandereWaifu:BoneHeartTearsRender(tr, _)
	if tr.Variant == ENTITY_RIBTEAR or tr.Variant == ENTITY_SKULLTEAR or tr.Variant == ENTITY_HEARTTEAR then
		local player, data, flags, scale = tr.Parent, GetEntityData(tr), tr.TearFlags, tr.Scale 
		local size = SchoolbagAPI.GetTearSizeTypeII(scale, flags)
		SchoolbagAPI.UpdateDynamicTearAnimation(player, tr, data, flags, "Stone", {"Move", "Idle"}, size)
	end
	--punch tear render
	if tr.Variant == ENTITY_RAPIDPUNCHTEAR and not GetEntityData(tr).Init then
		local rng = math.random(1,3)
		data.type = data.type or "a"
		tr:GetSprite():Play("Fist"..tostring(rng)..tostring(data.type))
		GetEntityData(tr).Init = true
		
		--initial angle as well
		local angleNum = (tr.Velocity):GetAngleDegrees();
		tr.SpriteRotation = angleNum;
		tr:GetData().Rotation = tr:GetSprite().Rotation
	end
	--print(tr.SpawnerEntity.Variant, "  ", tr.SpawnerVariant, FamiliarVariant.INCUBUS)
end
yandereWaifu:AddCallback(ModCallbacks.MC_POST_TEAR_RENDER, yandereWaifu.BoneHeartTearsRender)

function yandereWaifu:FistTearsUpdate(tr)
	tr = tr:ToTear()
	if tr.Variant == ENTITY_RAPIDPUNCHTEAR then
		local angleNum = (tr.Velocity):GetAngleDegrees();
		tr.SpriteRotation = angleNum;
		tr:GetData().Rotation = tr:GetSprite().Rotation;
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, yandereWaifu.FistTearsUpdate)

function yandereWaifu:BoneHeartTearsUpdate(tr)
	local data = GetEntityData(tr)
	local player = tr.Parent
	tr = tr:ToTear()
	if tr.Variant == ENTITY_RIBTEAR then
		local chosenNumofBarrage =  math.random( 2, 4 );
		for i = 1, chosenNumofBarrage do
			local tear = game:Spawn( EntityType.ENTITY_TEAR, TearVariant.BONE, tr.Position, Vector.FromAngle( math.random() * 360 ):Resized(BALANCE.GOLD_HEARTS_DASH_ATTACK_SPEED), tr, 0, 0):ToTear()
			tear.TearFlags = tear.TearFlags | TearFlags.TEAR_BONE
			tear.Scale = (tr.Scale) - math.random(1,5)/10;
			SchoolbagAPI.MakeTearLob(tear, 1.5, 9 );
		end
	elseif tr.Variant == ENTITY_SKULLTEAR then
		local chosenNumofBarrage =  math.random( 1, 3 );
		for i = 1, chosenNumofBarrage do
			local tear = game:Spawn( EntityType.ENTITY_TEAR, TearVariant.TOOTH, tr.Position, Vector.FromAngle( math.random() * 360 ):Resized(BALANCE.GOLD_HEARTS_DASH_ATTACK_SPEED), tr, 0, 0):ToTear()
			tear.TearFlags = tear.TearFlags | TearFlags.TEAR_BONE
			tear.Scale = (tr.Scale/2) - math.random(1,5)/10;
			SchoolbagAPI.MakeTearLob(tear, 1.5, 9 );
			tear.CollisionDamage = player:ToPlayer().Damage * 1.5
		end
	elseif tr.Variant == ENTITY_HEARTTEAR then
		local chosenNumofBarrage =  math.random( 3, 6 );
		for i = 1, chosenNumofBarrage do
			local tear = game:Spawn( EntityType.ENTITY_TEAR, TearVariant.BLOOD, tr.Position, Vector.FromAngle( math.random() * 360 ):Resized(3), tr, 0, 0):ToTear()
			tear.TearFlags = tear.TearFlags | TearFlags.TEAR_BONE
			tear.Scale = (tr.Scale) - math.random(1,5)/10;
			SchoolbagAPI.MakeTearLob(tear, 1.5, 9 );
			local puddle = game:Spawn( EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_RED, tr.Position, Vector(0,0), tr, 0, 0):ToEffect()
			puddle.Scale = math.random(12,14)/10
			puddle:PostRender()
		end
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, yandereWaifu.BoneHeartTearsUpdate, EntityType.ENTITY_TEAR)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, function(_,tear)
    local parent, spr, data = tear.Parent, tear:GetSprite(), GetEntityData(tear)
    local player = parent:ToPlayer()
	local lobHeight = math.floor((player:ToPlayer().TearHeight/2)*-1)
    if parent.Type == EntityType.ENTITY_FAMILIAR and parent.Variant == FamiliarVariant.INCUBUS then
      player = parent:ToFamiliar().Player
    end
    if currentMode == REBECCA_MODE.BoneHearts then
		if math.random(1,2) == 2 then
			local rng = math.random(1,10)
			if rng > 0 and rng < 5 then
				tear:ChangeVariant(TearVariant.BONE)
			elseif rng > 4 and rng < 8 then
				tear:ChangeVariant(TearVariant.TOOTH)
				tear.CollisionDamage = player.Damage * 2;
			elseif rng == 8 then
				tear:ChangeVariant(ENTITY_SKULLTEAR)
				SchoolbagAPI.MakeTearLob(tear, 1.5, lobHeight );
				tear.CollisionDamage = player.Damage * 2.5
			elseif rng == 9 then
				tear:ChangeVariant(ENTITY_RIBTEAR)
				SchoolbagAPI.MakeTearLob(tear, 1.5, lobHeight );
			else
				tear:ChangeVariant(ENTITY_HEARTTEAR)
				SchoolbagAPI.MakeTearLob(tear, 1.5, lobHeight );
			end
		end
    end
end)

--bone heart attack effect
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local player = Isaac.GetPlayer(0);
	local controller = player.ControllerIndex;
	local sprite = eff:GetSprite();
	local room =  Game():GetRoom();
	local data = GetEntityData(player);
    local roomClampSize = math.max( player.Size, 20 );
	--movement code
	eff.GridCollisionClass =  EntityGridCollisionClass.GRIDCOLL_NOPITS 
	
	local movementDirection = player:GetMovementInput();
	if movementDirection:Length() < 0.05 then
		eff.Velocity = eff.Velocity * 0.3;
		player.Position = room:GetClampedPosition(eff.Position, roomClampSize); --eff.Position;
		player.Velocity = eff.Velocity;
	else
		eff.Velocity = (eff.Velocity * 0.7) + movementDirection:Resized( BALANCE.BONE_HEARTS_DASH_TARGET_SPEED );
	end
	
	--function code
	player.Velocity = (room:GetClampedPosition(eff.Position, roomClampSize) - player.Position)*0.5;
	if eff.FrameCount == 1 then
		sprite:Play("Idle", true)
		player.ControlsEnabled = false
	elseif sprite:IsFinished("Idle") then
		sprite:Play("Blink",true)
		player.Visible = false
	elseif eff.FrameCount == 55 then
	
		--[[if BALANCE.SOUL_HEARTS_DASH_RETAINS_VELOCITY == false then
            player.Velocity = Vector( 0, 0 );
        else
            player.Velocity = eff.Velocity;
        end]]
    	if player.CanFly == true and room:GetType() ~= RoomType.ROOM_DUNGEON then
    		player.Position = eff.Position;
            if room:IsPositionInRoom(player.Position, 0) == false then
                player.Velocity = Vector( 0, 0 );
                player.Position = room:GetClampedPosition( player.Position, roomClampSize );
            end
    	else
            player.Position = room:FindFreeTilePosition( eff.Position, 0 )
            if room:IsPositionInRoom(player.Position, 0) == false then
                player.Velocity = Vector( 0, 0 );
                player.Position = room:FindFreeTilePosition( room:GetClampedPosition( player.Position, roomClampSize ), 0 );
            end
        end
		player.GridCollisionClass = data.LastGridCollisionClass;
		eff:Remove()
		local customBody = Isaac.Spawn(EntityType.ENTITY_EFFECT, ENTITY_EXTRACHARANIMHELPER, 0, eff.Position, Vector(0,0), eff)
		GetEntityData(customBody).IsSlamming = true
		GetEntityData(customBody).Player = player
		customBody.Visible = false
		player.Visible = false
		SpawnHeartParticles( 1, 1, eff.Position, RandomHeartParticleVelocity(), player, HeartParticleType.Bone );
	end
	--[[if eff.FrameCount < 55 then
		player.Velocity = Vector(0,0)
	end]]
end, ENTITY_BONETARGET)



--slamdust effect
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local player = Isaac.GetPlayer(0)
	local sprite = eff:GetSprite()
	local data = GetEntityData(eff)
	
	if eff.FrameCount == 1 then
		sprite:Play("Slam", true) --normal attack
	elseif sprite:IsFinished("Slam") then
		eff:Remove()
	end
	
end, ENTITY_SLAMDUST)

end

--BRIDE RED HEART--
do

function yandereWaifu:LabanInit(fam)
    local sprite = fam:GetSprite()
	local data = GetEntityData(fam)
	data.Stat = {
		FireDelay = 30,
		MaxFireDelay = 30,
		Damage = 15, 
		PlayerMaxDelay = 0,
		SlashDelay = 70,
		MaxChargeDelay = 70
	}
	fam.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS;
end
yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, yandereWaifu.LabanInit, ENTITY_LABAN);

yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_,  fam) --christian nerd
	local spr = fam:GetSprite()
	local rng = math.random(1, 100)
	local player = fam.Player
	local data = GetEntityData(fam)
	local playerdata = GetEntityData(player)
	
	local walkAnim
	if data.Stat.FireDelay > 0 then data.Stat.FireDelay = data.Stat.FireDelay - 1 end
	if data.Stat.SlashDelay > 0 then data.Stat.SlashDelay = data.Stat.SlashDelay - 1 end

	local currentSide = nil
	local brideProtectorAngle = (fam.Player.Velocity):GetAngleDegrees()
	local willFlip = false
	local neededPosition = fam.Player.Position + Vector(-30,0):Rotated(brideProtectorAngle)
	local addVel = Vector(0,0)
		--stop projectiles
		for i, e in pairs(Isaac.GetRoomEntities()) do
			if e.Type == EntityType.ENTITY_PROJECTILE then
				if (e.Position - player.Position):LengthSquared() <= 10 ^ 2 then
					e:Die()
				end
			end
		end
		--print(data.Stat.SlashDelay)
		--dash movement
		if playerdata.IsDashActive and data.Stat.SlashDelay <= 0 then
			local slashAnim 
			if not SchoolbagAPI.IsPlayingMultiple(spr, "SlashSide", "SlashFront", "SlashBack") then --init
				slashAnim = SchoolbagAPI.AnimShootFrame(fam, false, playerdata.DashVector, "SlashSide", "SlashFront", "SlashBack")
				fam.Velocity = fam.Velocity + playerdata.DashVector:Resized( BALANCE.RED_HEARTS_DASH_SPEED * 2);
			end
			if SchoolbagAPI.IsPlayingMultiple(spr, "SlashSide", "SlashFront", "SlashBack") then --slash damage
				if spr:GetFrame() >= 8 and spr:GetFrame() <= 10 then
					if spr:GetFrame() == 8 then
						speaker:Play( SoundEffect.SOUND_SHELLGAME, 1, 0, false, 1 );
					end
					local entities = Isaac.GetRoomEntities()
					for i = 1, #entities do
						if entities[i]:IsVulnerableEnemy() then
							if entities[i].Position:Distance(fam.Position) < entities[i].Size + fam.Size + 30 then
								entities[i]:TakeDamage(player.Damage * 2.5, 0, EntityRef(fam), 1)
							end
						end
						--projectiles
						if entities[i].Type == EntityType.ENTITY_PROJECTILE then
							if (entities[i].Position - player.Position):LengthSquared() <= 10 ^ 2 then
								entities[i]:Die()
							end
						end
					end
				end
			end
			if SchoolbagAPI.IsFinishedMultiple(spr, "SlashSide", "SlashFront", "SlashBack") then
				playerdata.IsDashActive = false
				data.Stat.SlashDelay = data.Stat.MaxChargeDelay
			end
		elseif playerdata.IsDashActive and data.Stat.SlashDelay > 0 then
			playerdata.IsDashActive = false
		elseif playerdata.IsAttackActive then
			if not SchoolbagAPI.IsPlayingMultiple(spr, "Special", "Special", "Special") then --init
				slashAnim = SchoolbagAPI.AnimShootFrame(fam, false, playerdata.AttackVector, "Special", "Special", "Special")
				if not data.entTable then data.entTable = {} end
			end
			if SchoolbagAPI.IsPlayingMultiple(spr, "Special", "Special", "Special") then --slash damage
				if not data.entTable then data.entTable = {} end
				if spr:IsEventTriggered("Start") then
					fam.Velocity = fam.Velocity + playerdata.AttackVector:Resized( BALANCE.BRIDE_RED_HEARTS_DASH_SPEED );
				elseif spr:WasEventTriggered("Start") and spr:GetFrame() < 42 then
					speaker:Play( SoundEffect.SOUND_SHELLGAME, 1, 0, false, 1 );
					local entities = Isaac.GetRoomEntities()
					for i = 1, #entities do
						if entities[i]:IsVulnerableEnemy() then
							if entities[i].Position:Distance(fam.Position) < entities[i].Size + fam.Size + 80 then
								entities[i]:TakeDamage(player.Damage * 1.3, 0, EntityRef(fam), 1)
								if not data.entTable[entities[i]] then data.entTable[entities[i]] = entities[i] end
							end
						end
						--projectiles
						if entities[i].Type == EntityType.ENTITY_PROJECTILE then
							if (entities[i].Position - player.Position):LengthSquared() <= 10 ^ 2 then
								entities[i]:Die()
							end
						end
					end
					fam.Velocity = fam.Velocity * 0.95
				else
					fam.Velocity = fam.Velocity * 0.8
				end
			end
			if spr:IsEventTriggered("Snap") then
				if data.entTable then
					for k, v in pairs (data.entTable) do
						if v:IsVulnerableEnemy() and not v:IsDead() then
							v:TakeDamage(player.Damage * 10, 0, EntityRef(fam), 1)
						end
					end
					data.entTable = {}
				end
			end
			if SchoolbagAPI.IsFinishedMultiple(spr, "Special", "Special", "Special") then
				playerdata.IsAttackActive = false
			end
		else
			--walk anims
			if not SchoolbagAPI.IsPlayingMultiple(spr, "ShootSide", "ShootFront", "ShootBack") then
				walkAnim = SchoolbagAPI.AnimWalkFrame(fam, false, "WalkSide", "WalkFront", "WalkBack")
			end
			
			--if not spr:IsPlaying("ShootSide") or not spr:IsPlaying("ShootFront") or not spr:IsPlaying("ShootBack")  then
			fam.Velocity = fam.Velocity * 2
			if brideProtectorAngle >= 45 and brideProtectorAngle <= 135 and currentSide ~= "down" then
				currentSide = "down"
			elseif brideProtectorAngle <= -45 and brideProtectorAngle >= -135 and currentSide ~= "up" then
				currentSide = "up"
			elseif (brideProtectorAngle <= 0 and brideProtectorAngle >= -45) or (brideProtectorAngle >= 0 and brideProtectorAngle <= 45) and currentSide ~= "right" then
				currentSide = "right"
			elseif (brideProtectorAngle <= 180 and brideProtectorAngle >= 135) or (brideProtectorAngle >= -180 and brideProtectorAngle <= -135) and currentSide ~= "left" then
				currentSide = "left"
			end
			
			if player:GetFireDirection() > -1 then
				local wA = data.walkAnim or walkAnim
				if data.Stat.FireDelay <= 0 then
					--print(wA)
					if wA then wA = math.floor(wA) end
					if not SchoolbagAPI.IsPlayingMultiple(spr, "ShootSide", "ShootFront", "ShootBack") then
						SchoolbagAPI.AnimShootFrame(fam, true, Vector.FromAngle(data.walkAnim or wA), "ShootSide", "ShootFront", "ShootBack")
					end
					local tears = player:FireTear(fam.Position, Vector.FromAngle(wA):Resized(10), false, false, false):ToTear()
					tears.CollisionDamage = data.Stat.Damage
					tears.Scale = 2
					data.Stat.FireDelay = data.Stat.MaxFireDelay
					data.walkAnim = walkAnim
					addVel = fam.Velocity + ((Vector(-15,0):Rotated(wA)):Resized(10))
					--print(wA)
				else
					if (not SchoolbagAPI.IsPlayingMultiple(spr, "ShootSide", "ShootFront", "ShootBack") or SchoolbagAPI.IsFinishedMultiple(spr, "ShootSide", "ShootFront", "ShootBack") ) and not SchoolbagAPI.IsPlayingMultiple(spr, "WalkSide", "WalkFront", "WalkBack") and data.walkAnim then
						SchoolbagAPI.AnimShootFrame(fam, true, Vector.FromAngle(data.walkAnim), "WalkSide", "WalkFront", "WalkBack")
					end
				end
			else
				data.walkAnim = nil
				fam.Velocity = (neededPosition - fam.Position)*0.2;
			end
			--stay where?
			--fam:FollowPosition ( neededPosition );
			fam.Velocity = (neededPosition - fam.Position)*0.2 + addVel;
		end
	--end
end, ENTITY_LABAN);

end

------
--Rebecca's Barrage and Specials
function yandereWaifu:barrageAndSP(player) 
	local data = GetEntityData(player)
	local controller = player.ControllerIndex
	 
	 
	if data.currentMode == REBECCA_MODE.RedHearts or data.currentMode == REBECCA_MODE.EvilHearts then
		if data.IsDashActive then --movement code
			local heartType = HeartParticleType.Red
			if data.currentMode == REBECCA_MODE.RedHearts then
				heartType = HeartParticleType.Red
			else
				heartType = HeartParticleType.Black
			end
			
			
			if not data.countdownFrames then data.countdownFrames = 7 end
			data.countdownFrames = data.countdownFrames - 1
			
			if data.countdownFrames < 0 then
				data.countdownFrames = 7
				data.IsDashActive = false
			end
			--if Isaac.GetFrameCount() % 3 == 0 then
			AddRebekahDashEffect(player)
			SpawnHeartParticles( 1, 3, player.Position, player.Velocity:Rotated(180):Resized( player.Velocity:Length() * (math.random() * 0.5 + 0.5) ), player, heartType );
			--end
		end
	end
	 
	if data.currentMode == REBECCA_MODE.EternalHearts then	
		if data.IsDashActive then --movement code
			if not data.countdownFrames then data.countdownFrames = 7 end
			data.countdownFrames = data.countdownFrames - 1
			local angle = player.Velocity:GetAngleDegrees()
			AddRebekahDashEffect(player)
			if data.countdownFrames < 0 then
				data.countdownFrames = 7
				data.IsDashActive = false
				
				--local lightboom = Isaac.Spawn(EntityType.ENTITY_EFFECT, ENTITY_LIGHTBOOM, 0, player.Position, Vector(0,0), player)
			end
		end
		if player:GetFireDirection() == -1 then --feather stack code
		
		local extraTears --this balances the fact you have mutant spider and inner eye but it slows down you feather stacks? wtf?
		if player:HasCollectible(CollectibleType.COLLECTIBLE_INNER_EYE) and player:HasCollectible(CollectibleType.COLLECTIBLE_MUTANT_SPIDER) then
			extraTears = 7
		elseif player:HasCollectible(CollectibleType.COLLECTIBLE_INNER_EYE) then
			extraTears = 3
		elseif player:HasCollectible(CollectibleType.COLLECTIBLE_MUTANT_SPIDER) then
			extraTears = 4
		else
			extraTears = 1
		end
		
		if not data.StackedFeathers then data.StackedFeathers = 0 end --stacked feathers is how much feathers you stacked while you aren't shooting.
		if not data.StackedFeathersTransition then data.StackedFeathersTransition = 0 end --this thing keeps track or counts on how long before a feather becomes added in the stack
		data.StackedFeathersTransition = data.StackedFeathersTransition + 1
		if data.StackedFeathersTransition >= 1*(player.MaxFireDelay/2) then
			if data.StackedFeathers < math.floor(100/(player.MaxFireDelay/5)) * extraTears then
				data.StackedFeathers = data.StackedFeathers + (1*extraTears)
			end
			data.StackedFeathersTransition = 0 --reset
		end
		else
			--head dir configuration, since the double tap direction aim system is only applied when a double attack is enabled. Sorry!
			if player:GetFireDirection() == 3 then --down
				data.AssignedHeadDir = 90
			elseif player:GetFireDirection() == 1 then --up
				data.AssignedHeadDir = -90
			elseif player:GetFireDirection() == 0 then --left
				data.AssignedHeadDir = 180
			elseif player:GetFireDirection() == 2 then --right
				data.AssignedHeadDir = 0
			end
			local numLimit = data.StackedFeathers
			for i = 1, numLimit do
                player.Velocity = player.Velocity * 0.8 --slow him down

                SchoolbagAPI.SetTimer( i, function()
                    local tear = player:FireTear(player.Position, Vector.FromAngle(data.AssignedHeadDir - math.random(-10,10))*(math.random(10,15)), false, false, false):ToTear()
                    tear:ChangeVariant(TearVariant.FIRE) --ENTITY_ETERNALFEATHER)
                    tear:AddTearFlags(TearFlags.TEAR_PIERCING)
                    tear.CollisionDamage = player.Damage * 0.8
                    --tear:GetData().NotSmart = true
                    --tear.BaseDamage = player.Damage * 2
                    if i == data.StackedFeathers then
                        speaker:Play(SoundEffect.SOUND_BIRD_FLAP, 1, 0, false, 1)
                        data.IsAttackActive = false
                    end
					
					--push back code
					player.Velocity = player.Velocity - Vector.FromAngle(data.AssignedHeadDir):Resized(0.3)
                end);
			end
			data.StackedFeathers = 0
		end
	end
	
	if data.currentMode == REBECCA_MODE.EvilHearts and game:GetFrameCount() >= 1 then	 --weird bug happens
		if player:GetHearts() <= 0 then
			if player:GetMovementInput():Length() < 1 and not data.OpenedMaw then
				local maw = Isaac.Spawn(EntityType.ENTITY_EFFECT, ENTITY_DARKMAW, 0, player.Position, player.Velocity, player) --feather attack
				data.OpenedMaw = maw
			elseif player:GetMovementInput():Length() >= 1 and data.OpenedMaw then
				data.OpenedMaw:GetSprite():Play("Die",true) --kill it
				data.OpenedMaw = nil
			end
		end
		if not data.EvilType then
			if player:GetHearts() <= 0 then
				data.EvilType = 1
			else
				data.EvilType = 0
			end
		end
		local currentType
		if player:GetHearts() <= 0 then
			currentType = 1
		else
			currentType = 0
		end
		if data.EvilType ~= currentType then
			player:AddCacheFlags(CacheFlag.CACHE_ALL);
			player:EvaluateItems()
			data.EvilType = currentType
			if data.EvilType == 1 then
				SchoolbagAPI.AnimateGiantbook(nil, nil, "Shake", "gfx/ui/giantbook/giantbook_void_black_heart.anm2", true)
			end
		end
	end
	
	if data.IsAttackActive and data.NoBoneSlamActive then	--attack code
		yandereWaifu:DoRebeccaBarrage(player, data.currentMode)
	end
end

function yandereWaifu:RenderUnderlay(player) 
	--local player = Isaac.GetPlayer(0)
	local psprite = player:GetSprite()
	if GetEntityData(player).currentMode == REBECCA_MODE.BrideRedHearts then	
		--local s = Sprite()
		--s:Load("gfx/weddingveil.anm2", true)
		--s:Update()
		--s:Play("Front", true)
		--s:Render(Isaac.WorldToScreen(player.Position), Vector(0,0), Vector(0,0))
		--s.RenderZOffset = 10000
		
		if psprite:IsPlaying("Trapdoor") or psprite:IsPlaying("Jump") or psprite:IsPlaying("HoleIn") or psprite:IsPlaying("HoleDeath") or psprite:IsPlaying("JumpOut") or psprite:IsPlaying("LightTravel") or psprite:IsPlaying("Appear") or psprite:IsPlaying("Death") or psprite:IsPlaying("TeleportUp") or psprite:IsPlaying("TeleportDown") then
			SchoolbagAPI.UnderlayVisible(player, false)
		else
			SchoolbagAPI.UnderlayMatchOwner(player)
			
			local plusOffset = 0

			if psprite:GetOverlayFrame() > 1 then
				plusOffset = 2
			end
			
			SchoolbagAPI.AddUnderlay(player, "gfx/weddingveil.anm2")
			if player.Velocity:Length() <= 1 then
				if player:GetHeadDirection() == 3 or player:GetHeadDirection() == -1 then --down
					SchoolbagAPI.PlayUnderlay(player, "Front", true)
					SchoolbagAPI.UnderlaySetUnder(player)
				elseif player:GetHeadDirection() == 1 then --up
					SchoolbagAPI.PlayUnderlay(player, "Back", true)
					SchoolbagAPI.UnderlaySetOver(player)
				elseif player:GetHeadDirection() == 0 then --left
					SchoolbagAPI.PlayUnderlay(player, "Side", true)
					SchoolbagAPI.UnderlaySetOver(player)
					SchoolbagAPI.FlipXUnderlay(player, true)
				elseif player:GetHeadDirection() == 2 then --right
					SchoolbagAPI.PlayUnderlay(player, "Side", true)
					SchoolbagAPI.UnderlaySetOver(player)
					SchoolbagAPI.FlipXUnderlay(player, false)
				end
			else
				if player:GetHeadDirection() == 3 or player:GetHeadDirection() == -1 then --down
					SchoolbagAPI.PlayUnderlay(player, "FrontMove", false)
					SchoolbagAPI.UnderlaySetUnder(player)
				elseif player:GetHeadDirection() == 1 then --up
					SchoolbagAPI.PlayUnderlay(player, "BackMove", false)
					SchoolbagAPI.UnderlaySetOver(player)
				elseif player:GetHeadDirection() == 0 then --left
					SchoolbagAPI.PlayUnderlay(player, "SideMove", false)
					SchoolbagAPI.UnderlaySetOver(player)
					SchoolbagAPI.FlipXUnderlay(player, true)
				elseif player:GetHeadDirection() == 2 then --right
					SchoolbagAPI.PlayUnderlay(player, "SideMove", false)
					SchoolbagAPI.UnderlaySetOver(player)
					SchoolbagAPI.FlipXUnderlay(player, false)
				end
			end
			SchoolbagAPI.UnderlayOffset(player, Vector(0,-1+plusOffset))
		end
	else
		SchoolbagAPI.RemoveUnderlay(player)
	end
end
--yandereWaifu:AddCallback(ModCallbacks.MC_POST_RENDER, yandereWaifu.RenderUnderlay) 

--pickup shizz, because i dont want you to ghost around and pick up random things
yandereWaifu:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, pickup)
	for p = 0, SAPI.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		if player:GetPlayerType() == Reb then
			local entityData = GetEntityData(player);
			if ( entityData.invincibleTime or 0 ) > 0 then
				pickup.Wait = 10;
			end
		end
	end
end)

--poof effect
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local sprite = eff:GetSprite();
	
	--sprite:LoadGraphics();
	if eff.FrameCount == 1 then
		sprite:Play("Poof", true);
	elseif sprite:IsFinished("Poof") then
		eff:Remove();
	end
end, ENTITY_HEARTPOOF)

--heart effect
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local sprite = eff:GetSprite()
	local data = GetEntityData(eff)
	
	--sprite:LoadGraphics()
	if eff.FrameCount == 1 then
		if data.Small then 
			--sprite:Play("Fly_small",true)
			sprite:SetFrame("Fly_small",1);
		elseif data.Large then
			--sprite:Play("Fly_large",true)
			sprite:SetFrame("Fly_large",1);
		else
			--sprite:Play("Fly",false)
			sprite:SetFrame("Fly",1);
		end
		if math.random(1,2) == 1 then
			sprite.FlipX = true
		end
	--elseif sprite:IsFinished("Fly") or sprite:IsFinished("Fly_small") or sprite:IsFinished("Fly_large") or eff.FrameCount > 32 then
	elseif eff.FrameCount > 16 then
		eff:Remove()
	end
	eff.Velocity = eff.Velocity - Vector( 0, math.random() + 0.5 );
	local alpha = ( 1 - (eff.FrameCount / 16) ) ^ 0.3;
	sprite.Color = Color( sprite.Color.R, sprite.Color.G, sprite.Color.G, alpha, 0, 0, 0 );
	sprite.Rotation = sprite.Rotation + eff.Velocity.X;
end, ENTITY_HEARTPARTICLE)

--lasers
function yandereWaifu:changetoDifferentLaser(lz)
	local entityData = GetEntityData(lz);
	 if entityData.IsDark == 1 then
		if lz.FrameCount == 1 then
			lz:GetSprite():Load("gfx/darkbrimstone.anm2", true)
			lz:GetSprite():Play("LargeRedLaser", true)
			if lz.Child ~= nil then
				lz.Child:GetSprite():Load("gfx/dark_impact.anm2", true)
				lz.Child:GetSprite():LoadGraphics()
				lz.Child.Color = lz.Parent:GetSprite().Color
			end
		end
	elseif entityData.IsDark == 2 then
		if lz.FrameCount == 1 then
			lz:GetSprite():Load("gfx/darkbrimstone_giant.anm2", true)
			lz:GetSprite():Play("LargeRedLaser", true)
			if lz.Child ~= nil then
				lz.Child:GetSprite():Load("gfx/dark_impact.anm2", true)
				lz.Child:GetSprite():LoadGraphics()
				lz.Child.Color = lz.Parent:GetSprite().Color
			end
		end
	end
	if entityData.IsLvlOneBeam then
		if lz.FrameCount == 1 then
			lz:GetSprite():Load("gfx/lightbeam.anm2", true)
			lz:GetSprite():Play("LargeRedLaser", true)
		end
	 end
	if entityData.IsLvlTwoBeam then
		if lz.FrameCount == 1 then
			lz:GetSprite():Load("gfx/lightbeam2.anm2", true)
			lz:GetSprite():Play("LargeRedLaser", true)
			if lz.Child ~= nil then
				lz.Child:GetSprite():Load("gfx/lvltwobrimimpact.anm2", true)
				lz.Child:GetSprite():LoadGraphics()
				lz.Child.Color = lz.Parent:GetSprite().Color
			end
		end
	 end
	if entityData.IsLvlThreeBeam then
		if lz.FrameCount == 1 then
			lz:GetSprite():Load("gfx/lightbeam3.anm2", true)
			lz:GetSprite():Play("LargeRedLaser", true)
			lz:GetSprite():LoadGraphics()
		end
	 end
	 if entityData.IsThickTechnology == 1 then
		if lz.FrameCount == 1 then
			lz:GetSprite():ReplaceSpritesheet(0, "gfx/effects/red_laser.png")
		end
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_POST_LASER_RENDER, yandereWaifu.changetoDifferentLaser)

--knife change sprite
yandereWaifu:AddCallback(ModCallbacks.MC_POST_KNIFE_UPDATE, function(_,  knf)
	local player = knf.Parent
	local knfdata = GetEntityData(knf);
	if knf.FrameCount == 1 then
		if knfdata.IsRed then
			knf:GetSprite():ReplaceSpritesheet(0, "gfx/effects/red/red_dagger.png")
			knf:GetSprite():LoadGraphics()
		end
	end
end)

--mechanic, like wtf. Sac Dac can kill enemies while you just stay in mid-air, so broken lol
--so this mechanic that makes vanilla orbitals hurt nothing in a certain case, like jumping in bone mode or teleporting in soul mode
yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_,  fam)
	local player = fam.Player
	player:ToPlayer()
	local data = GetEntityData(player);
	local famdata =  GetEntityData(fam);
	--print(tostring(fam.CollisionDamage))
	if player:GetPlayerType() == Reb then
		if fam.Variant == FamiliarVariant.FLY_ORBITAL or fam.Variant == FamiliarVariant.SACRIFICIAL_DAGGER or fam.Variant == FamiliarVariant.CUBE_OF_MEAT_1  or fam.Variant == FamiliarVariant.CUBE_OF_MEAT_2 or fam.Variant == FamiliarVariant.BALL_OF_BANDAGES_1 or fam.Variant == FamiliarVariant.BALL_OF_BANDAGES_2 or fam.Variant == FamiliarVariant.OBSESSED_FAN or fam.Variant == FamiliarVariant.MOMS_RAZOR or fam.Variant == FamiliarVariant.FOREVER_ALONE or fam.Variant == FamiliarVariant.DISTANT_ADMIRATION then --list of stuff, shut up it looks messy, I know
			if data.IsUninteractible then
				if not famdata.HasBeenModified then famdata.HasBeenModified = fam.CollisionDamage end --ill just dump in the info of their last entcoll so I use too less instructions here...
				fam.CollisionDamage = 0
			elseif not data.IsUninteractible and famdata.HasBeenModified then
				fam.CollisionDamage = famdata.HasBeenModified
				famdata.HasBeenModified = nil
			end
		end
	end
end)
yandereWaifu:AddCallback(ModCallbacks.MC_POST_KNIFE_UPDATE, function(_,  knf)
	local player = knf.Parent
	if player then
		player:ToPlayer()
		local data = GetEntityData(player);
		local knfdata =  GetEntityData(knf);
		if data.IsUninteractible and knf.FrameCount > 5 then
			if not knfdata.HasBeenModified then knfdata.HasBeenModified = knf.EntityCollisionClass end --ill just dump in the info of their last entcoll so I use too less instructions here...
			knf.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		elseif not data.IsUninteractible and knfdata.HasBeenModified then
			knf.EntityCollisionClass = knfdata.HasBeenModified
			knfdata.HasBeenModified = nil
		end
	end
end)

--arcane stuff
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local sprite = eff:GetSprite()
	local data = GetEntityData(eff)
	
	--sprite:LoadGraphics()
	if eff.FrameCount == 1 then
		sprite:Play("FadeIn", true)
	end
	if sprite:IsFinished("FadeIn") then
		sprite:Play("Pentagram", true)
	end
	if sprite:IsFinished("FadeOut") then
		eff:Remove()
	end
	eff.RenderZOffset = -10000;
end, ENTITY_ARCANE_CIRCLE)

--mirror
function yandereWaifu:MirrorMechanic(player) 
	local totalTypesofHearts = 0; --counts the total amount of hearts available
	local totalCurTypesofHearts = {};
	
	for p = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		local playerdata = GetEntityData(player);
		
		local heartTable = {
			ShowRed = false,
			ShowBlue = false,
			ShowGold = false,
			ShowEvil = false,
			ShowEternal = false,
			ShowBone = false,
			ShowRotten = false,
			ShowBroken = false
		}
		
		
		--health code

		--heart code checking
		if player:GetPlayerType() == Reb then
			if player:GetHearts() > 1 then heartTable.ShowRed = true end
			if player:GetSoulHearts() > 1 and (player:GetSoulHearts()-GetPlayerBlackHearts(player))> 0 then heartTable.ShowBlue = true end	
			if player:GetGoldenHearts() > 0 then heartTable.ShowGold = true end
			if GetPlayerBlackHearts(player) > 1 then heartTable.ShowEvil = true end
			if player:GetEternalHearts() > 0 then heartTable.ShowEternal = true end
			if player:GetBoneHearts() > 0 then heartTable.ShowBone = true end
			if player:GetRottenHearts() > 0 then heartTable.ShowRotten = true end
			if player:GetBrokenHearts() > 0 then heartTable.ShowBroken = true end
			
			if player:HasCollectible(CollectibleType.COLLECTIBLE_ISAACS_HEART) then heartBrideTable.Show = true end
		end

		--current heart collecting
		for i, heart in pairs (heartTable) do --8 because of eight hearts that exists in Isaac
			if heart == true then
				totalTypesofHearts = totalTypesofHearts + 1;
				table.insert(totalCurTypesofHearts, tostring(i));
			end
		end
	end
	
	for p = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		local playerdata = GetEntityData(player);
		
		local heartBrideTable = {
			Show = false
		}
		
		--mirror code
		for i, mir in pairs (Isaac.FindByType(EntityType.ENTITY_SLOT , ENTITY_REBMIRROR, -1, false, false)) do
			if not SchoolbagAPI.IsShowingItem(player) then
				local mirdata = GetEntityData(mir);
				local sprite = mir:GetSprite();
				
				if not mirdata.currentSavedHearts then
					mirdata.currentSavedHearts = totalCurTypesofHearts;
					mirdata.currentSavedHeartsNum = #totalCurTypesofHearts;
				end --this saves how much totalCurTypesofHearts you have when the mirror is in the process in presenting a bunch of hearts, so that it won't glitch
				
				if mir.FrameCount == 1 then
					if not mirdata.FirstPos then mirdata.FirstPos = mir.Position end --code to check if it's "broken", it's very wack, I hate it, but I can't do anything else, so deal with it
					if mir.SubType == 1 then
						local arcane = Isaac.Spawn( EntityType.ENTITY_EFFECT, ENTITY_ARCANE_CIRCLE, 0, player.Position, Vector(0,0), player );
						mirdata.Circle = arcane
					end
				end
				if mir.GridCollisionClass ~= 0 --[[mir.Position:Distance(mirdata.FirstPos) > 30]] then
					if not mirdata.Dead then
						mirdata.Dead = true;
					end 
				end
				if mir.SubType == 0 then
					if mirdata.Dead and not sprite:IsPlaying("Death") and not mirdata.DeadFinished then --heart only drop mechanic
						sprite:Play("Death", true);
						for j, pickup in pairs (Isaac.FindByType(EntityType.ENTITY_PICKUP, -1, -1, false, false)) do
							if (pickup.Position):Distance(mir.Position) <= 50 and pickup.FrameCount <= 1 then
								local newpickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, MirrorHeartDrop[math.random(1,6)], pickup.Position, pickup.Velocity, pickup)
								pickup:Remove()
							end
						end
						if not mirdata.DeadFinished then
							mirdata.DeadFinished = true;
						end 
					else
						if mir.FrameCount == 2 then
							if not sprite:IsPlaying("Appear") then
								sprite:Play("StartUp", true);
							end
							mirdata.currentHeart = 1 --keeps track of how much you went through to the totalCurTypesofHearts
						elseif mir.FrameCount >= 10 and not mirdata.Dead then
							if not mirdata.notAlive then
					
								if mirdata.currentHeart <= mirdata.currentSavedHeartsNum then
									if mirdata.IsDisplaying == nil or mirdata.IsDisplaying == false then --IsDisplaying tells if the mirror is playing something
										mirdata.IsDisplaying = true;
										sprite:Play(mirdata.currentSavedHearts[mirdata.currentHeart], true);
										--print("goes here"..tostring(mirdata.currentHeart)..tostring(totalCurTypesofHearts[mirdata.currentHeart]))
									elseif sprite:IsFinished(mirdata.currentSavedHearts[mirdata.currentHeart]) then
										mirdata.IsDisplaying = false;
											mirdata.currentHeart = mirdata.currentHeart + 1;
									end
								else
									mirdata.currentHeart = 1; --reset
									mirdata.currentSavedHearts = nil;
								end
								
								if sprite:IsFinished("Initiate") then
									mirdata.currentHeart = 1; --reset
									mirdata.currentSavedHearts = nil;
								end
								
								local newMode = GetEntityData(player).currentMode;
								if mir.Position:Distance( player.Position ) < mir.Size + player.Size and #totalCurTypesofHearts > 0 and player.EntityCollisionClass ~=  EntityCollisionClass.ENTCOLL_NONE and not player:GetSprite():IsPlaying("Trapdoor") then --if interacted
									if sprite:IsPlaying("ShowRed") and GetEntityData(player).currentMode ~= REBECCA_MODE.RedHearts 
										and player:GetHearts() > 1 then
										newMode = REBECCA_MODE.RedHearts;
									elseif sprite:IsPlaying("ShowBlue") and GetEntityData(player).currentMode ~= REBECCA_MODE.SoulHearts 
										and player:GetSoulHearts() > 1 and (player:GetSoulHearts()-GetPlayerBlackHearts(player))> 0 then
										newMode = REBECCA_MODE.SoulHearts
									elseif sprite:IsPlaying("ShowGold") and GetEntityData(player).currentMode ~= REBECCA_MODE.GoldHearts 
										and player:GetGoldenHearts() > 0 then
										newMode = REBECCA_MODE.GoldHearts
									elseif sprite:IsPlaying("ShowEvil") and GetEntityData(player).currentMode ~= REBECCA_MODE.EvilHearts 
										and GetPlayerBlackHearts(player) > 1 then
										newMode = REBECCA_MODE.EvilHearts
									elseif sprite:IsPlaying("ShowEternal") and GetEntityData(player).currentMode ~= REBECCA_MODE.EternalHearts 
										and player:GetEternalHearts() > 0 then
										newMode = REBECCA_MODE.EternalHearts;
									elseif sprite:IsPlaying("ShowBone") and GetEntityData(player).currentMode ~= REBECCA_MODE.BoneHearts 
										and player:GetBoneHearts() > 0 then
										newMode = REBECCA_MODE.BoneHearts;
									elseif sprite:IsPlaying("ShowRotten") and GetEntityData(player).currentMode ~= REBECCA_MODE.RottenHearts
										and player:GetRottenHearts() > 0 then
										newMode = REBECCA_MODE.RottenHearts;
									elseif sprite:IsPlaying("ShowBroken") and GetEntityData(player).currentMode ~= REBECCA_MODE.BrokenHearts 
										and player:GetBrokenHearts() > 0 then
										newMode = REBECCA_MODE.BrokenHearts;
									end
									if newMode ~= GetEntityData(player).currentMode and not sprite:IsPlaying("Initiate") then
										--mirdata.notAlive = true;
										player:AnimateSad();
										sprite:Play("Initiate", true);
										ChangeMode( player, newMode );
										--don't move
										player.Velocity = Vector(0,0)
										mirdata.currentHeart = 1; --reset
									end
								end
							else
								if sprite:IsFinished("Initiate") then
									if heartBrideTable.Show then
										local newpickup = Isaac.Spawn(EntityType.ENTITY_SLOT, ENTITY_REBMIRROR, 1, mir.Position, Vector(0,0), mir)
										mir:Remove()
									else
										sprite:Play("StartUp", true);
									end
								--elseif sprite:IsFinished("FinishedJob") then
								--	mir:Remove();
								end
							end
							if mir.Position:Distance(player.Position) > mir.Size + player.Size + 45 then --if close or far, speed up or not?
								mir:GetSprite().PlaybackSpeed = 3;
							else
								mir:GetSprite().PlaybackSpeed = 1;
							end
						end
					end
				elseif mir.SubType == 1 then
					if mirdata.Dead and not sprite:IsPlaying("Death") and not mirdata.DeadFinished then --heart only drop mechanic
						sprite:Play("Death", true);
						mirdata.Circle:GetSprite():Play("FadeOut",true)
						for j, pickup in pairs (Isaac.FindByType(EntityType.ENTITY_PICKUP, -1, -1, false, false)) do
							if (pickup.Position):Distance(mir.Position) <= 50 and pickup.FrameCount <= 1 then
								local newpickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, MirrorHeartDrop[math.random(1,6)], pickup.Position, pickup.Velocity, pickup)
								pickup:Remove()
							end
						end
						if not mirdata.DeadFinished then
							mirdata.DeadFinished = true;
						end 
					else
						if mirdata.Circle then mirdata.Circle.Position = mir.Position end
						if mir.FrameCount == 2 then
							if not sprite:IsPlaying("Appear") then
								sprite:Play("StartUp", true);
							end
						elseif mir.FrameCount >= 10 and not mirdata.Dead then
							if not mirdata.notAlive then
								if not sprite:IsPlaying("ShowBRed") then  sprite:Play("ShowBRed", true) end
								
								local newMode = GetEntityData(player).currentMode;
								if mir.Position:Distance( player.Position ) < mir.Size + player.Size and heartBrideTable.Show and player.EntityCollisionClass ~=  EntityCollisionClass.ENTCOLL_NONE and not player:GetSprite():IsPlaying("Trapdoor") then --if interacted
									if sprite:IsPlaying("ShowBRed") and GetEntityData(player).currentMode ~= REBECCA_MODE.BrideRedHearts then
										newMode = REBECCA_MODE.BrideRedHearts;
									end
									if newMode ~= GetEntityData(player).currentMode then
										mirdata.notAlive = true;
										player:AnimateSad();
										sprite:Play("Initiate", true);
										ChangeMode( player, newMode );
										--don't move
										player:RemoveCollectible(CollectibleType.COLLECTIBLE_ISAACS_HEART)
										player.Velocity = Vector(0,0)
										mirdata.Circle:GetSprite():Play("FadeOut",true)
										game:Darken(5,1200)
										SchoolbagAPI.AnimateGiantbook(nil, nil, "Marry", "gfx/ui/giantbook/giantbook_marriage.anm2", true, true)
									end
								end
							else
								if sprite:IsFinished("Initiate") then
									sprite:Play("FinishedJob", true);
								elseif sprite:IsFinished("FinishedJob") then
									mir:Remove();
								end
							end
							if mir.Position:Distance(player.Position) > mir.Size + player.Size + 45 then --if close or far, speed up or not?
								mir:GetSprite().PlaybackSpeed = 3;
							else
								mir:GetSprite().PlaybackSpeed = 1;
							end
						end
					end
				end
			end
		end
	end
end


yandereWaifu:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, function(_, ent)
	for p = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		local playerType = player:GetPlayerType()
		local room = game:GetRoom()
		
		if playerType == Reb then
			if ent.Type == EntityType.ENTITY_ISAAC or (ent.Type == EntityType.ENTITY_SATAN and not didKillSatan ) then -- isaac heart spawn
				if game:GetLevel():GetStage() == 10 then
					didKillSatan = true
					local spawnPosition = room:FindFreePickupSpawnPosition(room:GetGridPosition(97), 1);
					local newpickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, 100, CollectibleType.COLLECTIBLE_ISAACS_HEART, spawnPosition, Vector(0,0), player)
				end
			end
			local maxHealth = ent.MaxHitPoints
			yandereWaifu:addReserveFill(player, maxHealth/10)
		end
	end
end)


--meter
function yandereWaifu:meterLogic(player)
	--for i,player in ipairs(SAPI.players) do
		local data = GetEntityData(player)
		local room = game:GetRoom()
		local gameFrame = game:GetFrameCount();
		if player:GetPlayerType() == Reb then
			if player.Visible and not (room:GetType() == RoomType.ROOM_BOSS and not room:IsClear() and room:GetFrameCount() < 1) then
				moveMeter:SetOverlayRenderPriority(true)
				attackMeter:SetOverlayRenderPriority(true)
				bonestackMeter:SetOverlayRenderPriority(true)
				--move
				if data.specialBoneHeartStompCooldown and data.specialBoneHeartStompCooldown > 0 then --for special cooldown for bone heart
					if data.specialBoneHeartStompCooldown and data.specialBoneHeartStompCooldown > 0 then
						moveMeter:SetFrame("Charging", math.floor(data.specialBoneHeartStompCooldown*0.95/5))
						data.moveMeterFadeStartFrame = gameFrame;
					elseif data.specialBoneHeartStompCooldown == 0 then
						if not moveMeter:IsPlaying("Fade") then
							moveMeter:SetFrame("Fade",gameFrame - data.moveMeterFadeStartFrame);
						end
					end
				else
					if data.specialCooldown and data.specialMaxCooldown and data.specialCooldown > 0 then
						local FramePercentResult = math.floor((data.specialCooldown/data.specialMaxCooldown)*100)
						moveMeter:SetFrame("Charging", FramePercentResult)
						data.moveMeterFadeStartFrame = gameFrame;
					elseif data.specialCooldown == 0 then
						if not moveMeter:IsPlaying("Fade") then
							moveMeter:SetFrame("Fade",gameFrame - data.moveMeterFadeStartFrame);
						end
					end
				end
				
				--attack barrage chargeDelay
				if (data.chargeDelay and data.chargeDelay > 0 ) then
					local FramePercentResult = math.floor((data.chargeDelay/player.MaxFireDelay)*100)
					if FramePercentResult < 100 then
						attackMeter:SetFrame("Charging", FramePercentResult );
						data.attackMeterFadeStartFrame = gameFrame;
					else
						if not attackMeter:IsPlaying("ChargeBlink") then
							if not attackMeter:IsPlaying("JustCharged") then
								attackMeter:Play("JustCharged", true)
							else
								attackMeter:Play("ChargeBlink", true)
							end
						end
					end
				else
					--atack
					if data.specialActiveAtkCooldown and data.specialActiveAtkCooldown > 0 then
						local FramePercentResult = math.floor((data.specialActiveAtkCooldown/data.specialMaxActiveAtkCooldown)*100)
						attackMeter:SetFrame("Charging", FramePercentResult );
						data.attackMeterFadeStartFrame = gameFrame;
					else
						if not attackMeter:IsPlaying("Fade") then
							attackMeter:SetFrame("Fade", gameFrame - data.attackMeterFadeStartFrame);
						end
					end
				end
				--bone stack
				if data.BoneStacks then
					if data.BoneStacks > 0 then
						if data.BoneStacks <= 5 then
							bonestackMeter:SetFrame("Charging", data.BoneStacks );
							--bonestackMeter = gameFrame;
						else
							bonestackMeter:SetFrame("Charging", 5 );
							--data.bonestackMeterFadeStartFrame = gameFrame;
						end
					else
						if not bonestackMeter:IsPlaying("Fade") then
							bonestackMeter:SetFrame("Fade", gameFrame - data.bonestackMeterFadeStartFrame);
						end
					end
				end
				local playerLocation = Isaac.WorldToScreen(player.Position)
				--print(SchoolbagAPI.IsInMirroredFloor(player))
				if not SchoolbagAPI.IsInMirroredFloor(player) then
					moveMeter:Render(playerLocation + Vector(-20, -30), Vector(0,0), Vector(0,0));
					attackMeter:Render(playerLocation + Vector(-20, -10), Vector(0,0), Vector(0,0));
					bonestackMeter:Render(playerLocation + Vector(0, -45), Vector(0,0), Vector(0,0));
				end
			end
		end
	--end
end

function yandereWaifu:heartReserveRenderLogic(player)
	--for i,player in ipairs(SAPI.players) do
		local position = Vector(15,50)
		--print(player.Position.X)
		--if SchoolbagAPI.IsInMirroredFloor(player) then
			--position.X = position.X * -1
		--	 position = Isaac.WorldToScreen(Vector((player.Position.X * -1)-(player.Position.X * -1),player.Position.Y))
		--end
		--print(position.X)
		local data = GetEntityData(player)
		local room = game:GetRoom()
		local gameFrame = game:GetFrameCount();
		if player:GetPlayerType() == Reb then
			if not (room:GetType() == RoomType.ROOM_BOSS and not room:IsClear() and room:GetFrameCount() < 1) then
				heartReserve:SetOverlayRenderPriority(true)
				if data.heartReserveFill and data.heartReserveMaxFill then
					--local FramePercentResult = math.floor((data.heartReserveFill/data.heartReserveMaxFill)*100)
					--print(data.heartReserveFill, "hello")
					local renderFill = math.floor(data.heartReserveFill/10)
					heartReserve:SetFrame("Bar", renderFill) --math.floor(FramePercentResult/10
				end
				heartReserve:SetOverlayFrame("Number", yandereWaifu:getReserveStocks(player))
				heartReserve:Render(position, Vector(0,0), Vector(0,0))
			end
		end
	--end
end

-- composite of all callbacks to ensure proper callback order
yandereWaifu:AddCallback(ModCallbacks.MC_POST_UPDATE, function()

	for p = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		if player:GetPlayerType() == Reb then
			-- for debugging, remove when release
			Init();
			--if Game():GetFrameCount() - lastSaveTime >= OPTIONS.SAVE_INTERVAL then
			--	yandereWaifu:Save()
			--	lastSaveTime = Game():GetFrameCount();
			--end
			if GetEntityData(player).currentMode ~= REBECCA_MODE.BrideRedHearts then
				yandereWaifu:TrySpawnMirror();
			end
			yandereWaifu:heartReserveLogic(player);
			yandereWaifu:customMovesInput();
			yandereWaifu:ExtraStompCooldown();
			yandereWaifu:MirrorMechanic();
			
			--custom hurt sounds
			--I removed them right now because I have no good voice for her >:/
			--[[
			if OPTIONS.CUSTOM_DAMAGE_SOUND == true then
				if queueDamageSound == true then
					queueDamageSound = false;
					speaker:Stop(SoundEffect.SOUND_ISAAC_HURT_GRUNT);
					speaker:Play(OPTIONS.CUSTOM_DAMAGE_SOUND_ID, 1, 0, false, OPTIONS.CUSTOM_DAMAGE_SOUND_PITCH);
				end
			end
			if OPTIONS.CUSTOM_DEATH_SOUND == true then
				local isPlayerDead = player:IsDead() and player:GetSprite():IsPlaying("Death") and player:GetSprite():GetFrame() > 7;
				if isPlayerDead and not wasPlayerDead then
					speaker:Stop(SoundEffect.SOUND_ISAACDIES);
					speaker:Play(OPTIONS.CUSTOM_DEATH_SOUND_ID, 1, 0, false, OPTIONS.CUSTOM_DEATH_SOUND_PITCH);
				end
				wasPlayerDead = isPlayerDead;
			end]]
			if player:GetMovementInput() then
				GetEntityData(player).DASH_DOUBLE_TAP:Update( player:GetMovementInput() , player );
			end
			if player:GetShootingInput() then
				GetEntityData(player).ATTACK_DOUBLE_TAP:Update( player:GetShootingInput() , player );
			end
			SchoolbagAPI.UpdateTimers();
			
		end
		if player:HasCollectible(COLLECTIBLE_ETERNALBOND) then
			yandereWaifu:AddTinyCharacters(player)
		else
		--	yandereWaifu:RemoveTinyCharacters(player)
		end
	end
end);

yandereWaifu:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, function(_, player)
	--for i,player in ipairs(SAPI.players) do
		if player:GetPlayerType() == Reb then
			yandereWaifu:meterLogic(player);
			yandereWaifu:heartReserveRenderLogic(player);
		end
	--end
end);

function yandereWaifu:DoExtraBarrages(player, mode)
	local data = GetEntityData(player)
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


function yandereWaifu:DoTinyBarrages(player, vec)
	local data = GetEntityData(player)
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

--pheromones fart ring
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, function(_, eff)
	local sprite = eff:GetSprite()
	sprite:Play("Appear", true)
	eff.RenderZOffset = 10000;
	eff.SpriteOffset = Vector(0,-10)
end, ENTITY_PHEROMONES_RING);
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local sprite = eff:GetSprite();
	local data = GetEntityData(eff)
	local player = data.Player
	
	if sprite:IsFinished("Appear") then
		sprite:Play("Loop", true)
	end
	
	if eff.FrameCount == 20 then
		sprite:Play("Dissappear", true)
	end
	
	if sprite:IsFinished("Dissappear") then
		eff:Remove()
	end
	
	eff.Velocity = player.Velocity;
	eff.Position = player.Position;
	
	for k, ent in pairs(Isaac.GetRoomEntities()) do
		if ent:IsEnemy() and ent:IsVulnerableEnemy() then
		local num = 45
			if ent.Position:Distance( eff.Position ) < ent.Size + eff.Size + num then
				ent:AddCharmed(EntityRef(player), math.random(30,300))
			end
		end
	end
end, ENTITY_PHEROMONES_RING);

--snap fart
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, function(_, eff)
	local sprite = eff:GetSprite()
	local data = GetEntityData(eff)
	eff.RenderZOffset = 10000;
	eff.SpriteOffset = Vector(0,-10)
end, ENTITY_SNAP_HEARTBEAT);
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local sprite = eff:GetSprite();
	local data = GetEntityData(eff)
	local player = data.Player
	
	if not data.Init then
		if data.Snap then
			sprite:Play("Heartbeat_snap", true)
		else
			sprite:Play("Heartbeat", true)
		end
		data.Init = true
	end
	if sprite:GetFrame() == 7 then
		for k, enemy in pairs( Isaac.GetRoomEntities() ) do
			if enemy:IsEnemy() --[[and not enemy:IsEffect() and not enemy:IsInvulnurable()]] then
				if enemy.Position:Distance( eff.Position ) < enemy.Size + eff.Size + 35 then
					SchoolbagAPI.DoKnockbackTypeI(eff, enemy, 0.2)
				end
			end
		end
	end
		
	if sprite:IsFinished("Heartbeat") or sprite:IsFinished("Heartbeat_snap") then
		eff:Remove()
	end
end, ENTITY_SNAP_HEARTBEAT);

yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, function(_, eff)
	local sprite = eff:GetSprite()
	local data = GetEntityData(eff)
	--eff.RenderZOffset = 10000;
	eff.SpriteOffset = Vector(0,-30)
	speaker:Play( SOUND_ELECTRIC , 1, 0, false, 1.2 );
end, ENTITY_SNAP_EFFECT);
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local sprite = eff:GetSprite();
	local data = GetEntityData(eff)
	local player = data.Player
		
	if sprite:IsFinished("snap") then
		eff:Remove()
	end
end, ENTITY_SNAP_EFFECT);

--love hook effect
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local sprite = eff:GetSprite();
	local data = GetEntityData(eff)
	local player = data.Player
	--set chains
	SchoolbagAPI.AttachChain(data.Player, eff)
	
	if data.Attached and not data.Attached:IsDead() then
		eff.Visible = false
		eff.Velocity = data.Attached.Velocity
		eff.Position = data.Attached.Position
		local dist = data.Attached.Position:Distance((player.Position ))
		data.Attached:AddEntityFlags(EntityFlag.FLAG_BLEED_OUT)
		if dist > 250 and Isaac.GetFrameCount() % math.floor(10) == 0 then
			data.Attached:TakeDamage(1.5, 0, EntityRef(eff), 1)
		end
		if data.Attached.EntityCollisionClass == EntityCollisionClass.ENTCOLL_NONE then --remove cases
			SchoolbagAPI.RefundActiveCharge(player, 120)
			eff:Remove()
		end
	elseif data.Attached and data.Attached:IsDead() then
		SchoolbagAPI.RefundActiveCharge(player, 120)
		eff:Remove()
	else
		--rotation gimmick
		local angleNum = (eff.Velocity):GetAngleDegrees();
		eff:GetSprite().Rotation = angleNum;
		eff:GetData().Rotation = eff:GetSprite().Rotation;
		local entities = Isaac.GetRoomEntities()
		for i = 1, #entities do
			if entities[i]:IsVulnerableEnemy() then
				if entities[i].Position:Distance(eff.Position) < entities[i].Size + eff.Size + 8 then
					if entities[i].Size > 12 then
						data.Attached = entities[i]
						entities[i]:TakeDamage(player.Damage * 1.6, 0, EntityRef(eff), 1)
					else
						entities[i]:TakeDamage(player.Damage * 1.3, 0, EntityRef(eff), 1)
					end
				end
			end
		end
		if eff.FrameCount > 10 then --expiration
			SchoolbagAPI.RefundActiveCharge(player, 300)
			eff:Remove()
		end
	end
end, ENTITY_LOVEHOOK);

--cursed maw effect
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local player = Isaac.GetPlayer(0);
	local controller = player.ControllerIndex;
	local sprite = eff:GetSprite();
	local room =  Game():GetRoom();
	local data = GetEntityData(player)
    local roomClampSize = math.max( player.Size, 20 );
	--movement code
	eff.GridCollisionClass =  EntityGridCollisionClass.GRIDCOLL_GROUND;

	local movementDirection = player:GetMovementInput();

	--if movementDirection:Length() < 0.05 then
		--eff.Velocity = eff.Velocity * 0.3;
	player.Position = room:GetClampedPosition(eff.Position, roomClampSize);
		--player.Velocity = eff.Velocity;
	--else
		--eff.Velocity = (eff.Velocity * 0.9) + movementDirection:Resized( BALANCE.SOUL_HEARTS_DASH_TARGET_SPEED );
	--end

	--function code
	--player.Velocity = (room:GetClampedPosition(eff.Position, roomClampSize) - player.Position)*0.5;
	eff.Velocity = player.Velocity * 2
	eff.Position = player.Position
	local modulusnum = math.ceil((player.MaxFireDelay))
	if sprite:IsPlaying("Lick")then --shooting gimmick
		if Isaac.GetFrameCount() % ( modulusnum * 2)== 0 then
			local rng = math.random(-30,30)
			for i = 0, 360, 360/6 do
				if player:HasWeaponType(WeaponType.WEAPON_BRIMSTONE) then
					local brim = player:FireBrimstone( Vector.FromAngle(i + rng) ):ToLaser();
				elseif player:HasWeaponType(WeaponType.WEAPON_LASER) then --tech barrage
					local techlaser = player:FireTechLaser(player.Position, 0, Vector.FromAngle(i + rng), false, true)
					techlaser.OneHit = true;
					techlaser.Timeout = 1;
					techlaser.CollisionDamage = player.Damage * 2;
				else
					local tears = player:FireTear(player.Position, Vector.FromAngle(i + rng)*(8), false, false, false)
					--tears:ChangeVariant(TearVariant.BLOOD) --seems to bug
				end
			end
			
			--killaura thing
			for i, e in pairs(Isaac.GetRoomEntities()) do
				if e.Type ~= EntityType.ENTITY_PLAYER then
					if e:IsActiveEnemy() then
						if e:IsVulnerableEnemy() then
							if (eff.Position - e.Position):Length() < 75 then
								e:TakeDamage(player.Damage, 0, EntityRef(eff),4)
							end
						end
					end
				end
			end
		end
	end
	
	if eff.FrameCount == 1 then
		--player.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS;
		
		player.Visible = false
		player.ControlsEnabled = false;
	elseif sprite:IsFinished("Open") then
		sprite:Play("Lick",true);
		player.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE;
	elseif eff.FrameCount == 155 and sprite:IsPlaying("Lick") then
		sprite:Play("Spit",true);
	elseif sprite:IsEventTriggered("Spit") then
        if BALANCE.SOUL_HEARTS_DASH_RETAINS_VELOCITY == false then
            player.Velocity = Vector( 0, 0 );
        end
    	if player.CanFly == true and room:GetType() ~= RoomType.ROOM_DUNGEON then
    		player.Position = eff.Position;
            if room:IsPositionInRoom(player.Position, 0) == false then
                player.Velocity = Vector( 0, 0 );
                player.Position = room:GetClampedPosition( player.Position, roomClampSize );
            end
    	else
            player.Position = room:FindFreeTilePosition( eff.Position, 0 )
            if room:IsPositionInRoom(player.Position, 0) == false then
                player.Velocity = Vector( 0, 0 );
                player.Position = room:FindFreeTilePosition( room:GetClampedPosition( player.Position, roomClampSize ), 0 );
            end
        end
		player.Visible = true;
		player:AnimatePitfallOut()
		--player.GridCollisionClass = data.LastGridCollisionClass;
    	speaker:Play( SoundEffect.SOUND_WEIRD_WORM_SPIT, 1, 0, false, 1 );
	elseif sprite:IsEventTriggered("Spit2") then
		player.ControlsEnabled = true;
		player.EntityCollisionClass = data.LastEntityCollisionClass;
		
    	data.IsUninteractible = false;
    	speaker:Play( SoundEffect.SOUND_WEIRD_WORM_SPIT, 1, 0, false, 1 );
    end
	if sprite:IsFinished("Spit") then
		eff:Remove()
	end
	player:SetShootingCooldown(2)

end, ENTITY_CURSEDMAW);

yandereWaifu:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function(_,player)
	--local player = Isaac.GetPlayer(0);
    local room = Game():GetRoom();
	local data = GetEntityData(player)
	
	if player:GetPlayerType() == Reb then
		yandereWaifu:barrageAndSP( player );
		yandereWaifu:RenderUnderlay( player ) 
		--yandereWaifu:RenderExtraHair(player, data.hairpath) 
		--update the costumes when a new tem gets picked up
		
		if SchoolbagAPI.HasCollectiblesUpdated(player) == true then
			player:AddCacheFlags(CacheFlag.CACHE_ALL);
			player:EvaluateItems()
		end
		
		if player:GetSprite():GetFrame() == 12 and player:GetSprite():IsPlaying("Death") == true then
			local glasses = Isaac.Spawn(EntityType.ENTITY_EFFECT, ENTITY_BROKEN_GLASSES, 0, player.Position, Vector(-2,0) * 2, player)
		end
		
		--dash skill
		if not data.DASH_DOUBLE_TAP_READY then
			GetEntityData(player).DASH_DOUBLE_TAP:AttachCallback( function(vector, playerTapping)
				-- old random velocity code
				-- RandomHeartParticleVelocity()
				for p = 0, game:GetNumPlayers() - 1 do
					local player = Isaac.GetPlayer(p)
					print(GetPtrHash( playerTapping), "     vector!", GetPtrHash( player))
					if GetPtrHash( playerTapping ) == GetPtrHash( player) then
						local psprite = player:GetSprite()
						local playerdata = GetEntityData(player);

						print(playerdata.IsDashActive , playerdata.IsAttackActive , playerdata.NoBoneSlamActive)
						local trinketBonus = 0
						if player:HasTrinket(TRINKET_ISAACSLOCKS) then
							trinketBonus = 5
						end
						if not (psprite:IsPlaying("Trapdoor") or psprite:IsPlaying("Jump") or psprite:IsPlaying("HoleIn") or psprite:IsPlaying("HoleDeath") or psprite:IsPlaying("JumpOut") or psprite:IsPlaying("LightTravel") or psprite:IsPlaying("Appear") or psprite:IsPlaying("Death") or psprite:IsPlaying("TeleportUp") or psprite:IsPlaying("TeleportDown")) and not (playerdata.IsUninteractible) and not playerdata.IsAttackActive then
							if GetEntityData(player).currentMode == REBECCA_MODE.RedHearts then --IF RED HEART MODE
							
								player.Velocity = player.Velocity + vector:Resized( BALANCE.RED_HEARTS_DASH_SPEED );
								
								SpawnDashPoofParticle( player.Position, Vector(0,0), player, PoofParticleType.Red );

								playerdata.specialCooldown = BALANCE.RED_HEARTS_DASH_COOLDOWN - trinketBonus;
								playerdata.invincibleTime = BALANCE.RED_HEARTS_DASH_INVINCIBILITY_FRAMES;
								speaker:Play( SoundEffect.SOUND_CHILD_HAPPY_ROAR_SHORT, 1, 0, false, 1.5 );
								playerdata.IsDashActive = true
								
							elseif GetEntityData(player).currentMode == REBECCA_MODE.SoulHearts then --if blue
							
								local customBody = Isaac.Spawn(EntityType.ENTITY_EFFECT, ENTITY_EXTRACHARANIMHELPER, 0, player.Position, Vector(0,0), player) --body effect
								GetEntityData(customBody).Player = player
								GetEntityData(customBody).WizoobIn = true
								player.Velocity = Vector( 0, 0 );
								player.ControlsEnabled = false;
								SpawnPoofParticle( player.Position, Vector(0,0), player, PoofParticleType.Blue );
								SpawnHeartParticles( 3, 5, player.Position, RandomHeartParticleVelocity(), player, HeartParticleType.Blue );
								playerdata.specialCooldown = BALANCE.SOUL_HEARTS_DASH_COOLDOWN - trinketBonus;
								playerdata.invincibleTime = BALANCE.SOUL_HEARTS_DASH_INVINCIBILITY_FRAMES;
								speaker:Play( SoundEffect.SOUND_WEIRD_WORM_SPIT, 1, 0, false, 1 );
								playerdata.IsUninteractible = true
								playerdata.IsDashActive = true
								
								--set opened damage buff
								playerdata.SoulBuff = true
								player:AddCacheFlags(CacheFlag.CACHE_DAMAGE);
								player:EvaluateItems()
								--happy costume code
								ApplyCostumes( GetEntityData(player).currentMode, player , false)
								player:AddCostume(Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_NUMBER_ONE))
							elseif GetEntityData(player).currentMode == REBECCA_MODE.GoldHearts then --if yellow
								for k, enemy in pairs( Isaac.GetRoomEntities() ) do
									if enemy:IsEnemy() --[[and not enemy:IsEffect() and not enemy:IsInvulnurable()]] then
										if enemy.Position:Distance( player.Position ) < enemy.Size + player.Size + BALANCE.GOLD_HEARTS_DASH_KNOCKBACK_RANGE then
											SchoolbagAPI.DoKnockbackTypeI(player, enemy, 0.65)
										end
									end
								end
								--rock splash
								local chosenNumofBarrage =  math.random( 8, 15 );
								for i = 1, chosenNumofBarrage do
									player.Velocity = player.Velocity * 0.8; --slow him down
									--local tear = player:FireTear(player.Position, Vector.FromAngle(data.specialAttackVector:GetAngleDegrees() - math.random(-10,10))*(math.random(10,15)), false, false, false):ToTear()
									local tear = game:Spawn( EntityType.ENTITY_TEAR, TearVariant.ROCK, player.Position, Vector.FromAngle( math.random() * 360 ):Resized(BALANCE.GOLD_HEARTS_DASH_ATTACK_SPEED), player, 0, 0):ToTear()
									tear.Scale = math.random(2,12)/10;
									tear.FallingSpeed = -9 + math.random() * 2 ;
									tear.FallingAcceleration = 0.5;
									tear.CollisionDamage = player.Damage * 1.3;
									--tear.BaseDamage = player.Damage * 2
								end
								--tear projectiles defence
								for i, e in pairs(Isaac.GetRoomEntities()) do
									if e.Type == EntityType.ENTITY_PROJECTILE then
										if (e.Position - player.Position):Length() < 80 then
										local oldProj = e
										local projdata = GetEntityData(oldProj)
										projdata.Variant = oldProj.Variant
										projdata.Subtype = oldProj.Subtype
										projdata.Scale = oldProj.Scale
										projdata.CollisionDamage = oldProj.CollsionDamage
										--local newProj = game:Spawn( EntityType.ENTITY_PROJECTILE, projdata.Variant, oldProj.Position, Vector(0,0), player, 0, 0):ToProjectile();
										local crack = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACK_THE_SKY, 1, oldProj.Position, Vector(0,0), player) 
										--newProj:AddFallingSpeed(-9 + math.random() * 2) ;
										--newProj:AddFallingAccel(0.5);
										--newProj:AddProjectileFlags(ProjectileFlags.HIT_ENEMIES)
										oldProj:Remove()
										end
									elseif e:IsEnemy() then
										if (e.Position - player.Position):Length() < 80 then
											e:TakeDamage(player.Damage/2, 0, EntityRef(eff), 4)
										end
									end
								end
								--destroy grids
								for i = 1, 8 do --code that checks each eight directions
									--local checkingVector = (room:GetGridEntity(room:GetGridIndex(fam.Position + data.savedVelocity*4)))
									local gridStomped = room:GetGridEntity(room:GetGridIndex(player.Position + Vector(45,0):Rotated(45*(i-1)))) --grids around that Rebecca stepped on
									--if gridStomped:GetType() == GridEntityType.GRID_TNT or gridStomped:GetType() == GridEntityType.GRID_ROCK then
									--print( gridStomped:GetType())
									if gridStomped ~= nil then
										gridStomped:Destroy()
									end
									if i == 8 then 
										local gridStomped = room:GetGridEntity(room:GetGridIndex(player.Position)) --top grid
										if gridStomped ~= nil then
											gridStomped:Destroy()
										end
									end
								end
								
								Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 1, player.Position, Vector(0,0), player)
								
								--SpawnPoofParticle( player.Position, Vector(0,0), player, PoofParticleType.Gold );
								SpawnHeartParticles( 3, 5, player.Position, RandomHeartParticleVelocity(), player, HeartParticleType.Gold );
								playerdata.specialCooldown = BALANCE.GOLD_HEARTS_DASH_COOLDOWN - trinketBonus;
								playerdata.invincibleTime = BALANCE.GOLD_HEARTS_DASH_INVINCIBILITY_FRAMES;
								speaker:Play( SoundEffect.SOUND_FORESTBOSS_STOMPS, 1, 0, false, 1 );
							elseif GetEntityData(player).currentMode == REBECCA_MODE.EvilHearts then --if black
								player.Velocity = player.Velocity + vector:Resized( BALANCE.EVIL_HEARTS_DASH_SPEED );
								--if player:GetMaxHearts() > 0 then
								local orb = Isaac.Spawn( EntityType.ENTITY_EFFECT, ENTITY_EVILORB, 0, player.Position, Vector(0,0), player ); --heart effect
								GetEntityData(orb).Parent = player
								playerdata.specialCooldown = BALANCE.EVIL_HEARTS_DASH_COOLDOWN - trinketBonus;
								--else
								--	local orb = Isaac.Spawn( EntityType.ENTITY_EFFECT, ENTITY_EVILORB, 1, player.Position, Vector(0,0), player ); --heart effect
								--	playerdata.specialCooldown = BALANCE.EMPTY_EVIL_HEARTS_DASH_COOLDOWN - trinketBonus;
								--end
								SpawnPoofParticle( player.Position, Vector(0,0), player, PoofParticleType.Black );
								SpawnHeartParticles( 3, 5, player.Position, RandomHeartParticleVelocity(), player, HeartParticleType.Black );
								playerdata.invincibleTime = BALANCE.EVIL_HEARTS_DASH_INVINCIBILITY_FRAMES;
								speaker:Play( SoundEffect.SOUND_MAW_OF_VOID , 1, 0, false, 1 );
								
								playerdata.IsDashActive = true
							elseif GetEntityData(player).currentMode == REBECCA_MODE.EternalHearts then --if eternalhearts
								player.Velocity = player.Velocity + vector:Resized( BALANCE.ETERNAL_HEARTS_DASH_SPEED );
								SpawnDashPoofParticle( player.Position, Vector(0,0), player, PoofParticleType.Eternal );
								SpawnHeartParticles( 2, 5, player.Position, player.Velocity:Rotated(180):Resized( player.Velocity:Length() * (math.random() * 0.5 + 0.5) ), player, HeartParticleType.Eternal );
								local lightboom = Isaac.Spawn(EntityType.ENTITY_EFFECT, ENTITY_LIGHTBOOM, 0, player.Position, Vector(0,0), player);
								playerdata.specialCooldown = BALANCE.ETERNAL_HEARTS_DASH_COOLDOWN - trinketBonus;
								playerdata.invincibleTime = BALANCE.ETERNAL_HEARTS_DASH_INVINCIBILITY_FRAMES;
								playerdata.IsDashActive = true;
								speaker:Play(SoundEffect.SOUND_BIRD_FLAP, 1, 0, false, 0.5);
								speaker:Play(SoundEffect.SOUND_BIRD_FLAP, 1, 0, false, 0.5);
							elseif GetEntityData(player).currentMode == REBECCA_MODE.BoneHearts then --if bonehearts
								if not playerdata.IsDashActive and not playerdata.IsAttackActive and playerdata.NoBoneSlamActive then -- and playerdata.specialBoneHeartStompCooldown <= 0 then
									--local vault = Isaac.Spawn(EntityType.ENTITY_EFFECT, ENTITY_BONEVAULT, 0, player.Position, Vector(0,0), player) --vault effect
									--GetEntityData(vault).bonerOwner = player;
									--vault.DepthOffset = 5;
									local customBody = Isaac.Spawn(EntityType.ENTITY_EFFECT, ENTITY_EXTRACHARANIMHELPER, 0, player.Position, Vector(0,0), player) --body effect
									GetEntityData(customBody).Player = player
									GetEntityData(customBody).IsHopping = true
									playerdata.IsVaulting = true;
									SpawnDashPoofParticle( player.Position, Vector(0,0), player, PoofParticleType.Bone );
									SpawnHeartParticles( 2, 5, player.Position, player.Velocity:Rotated(180):Resized( player.Velocity:Length() * (math.random() * 0.5 + 0.5) ), player, HeartParticleType.Bone );
									playerdata.specialCooldown = BALANCE.BONE_HEARTS_DASH_COOLDOWN - trinketBonus;
									playerdata.invincibleTime = BALANCE.BONE_HEARTS_DASH_INVINCIBILITY_FRAMES;
									playerdata.IsDashActive = true;
									playerdata.NoBoneSlamActive = false;
								end
							elseif GetEntityData(player).currentMode == REBECCA_MODE.BrideRedHearts then --if red 
								player.Velocity = player.Velocity + vector:Resized( BALANCE.RED_HEARTS_DASH_SPEED );
								SpawnDashPoofParticle( player.Position, Vector(0,0), player, PoofParticleType.Red );
								SpawnHeartParticles( 3, 5, player.Position, player.Velocity:Rotated(180):Resized( player.Velocity:Length() * (math.random() * 0.5 + 0.5) ), player, HeartParticleType.Red );
								playerdata.specialCooldown = BALANCE.RED_HEARTS_DASH_COOLDOWN - trinketBonus;
								playerdata.invincibleTime = BALANCE.RED_HEARTS_DASH_INVINCIBILITY_FRAMES;
								speaker:Play( SoundEffect.SOUND_CHILD_HAPPY_ROAR_SHORT, 1, 0, false, 1.5 );
								
								playerdata.DashVector = vector;
								playerdata.IsDashActive = true;
							end
							playerdata.specialMaxCooldown = playerdata.specialCooldown --gain the max amount dash cooldown
							-- update the dash double tap cooldown based on Rebecca's mode specific cooldown
						end
						playerdata.DASH_DOUBLE_TAP.cooldown = playerdata.specialCooldown;
					end
				end
			end)
			data.DASH_DOUBLE_TAP_READY = true
		end
		


		--attack skill
		if player:HasCollectible(COLLECTIBLE_LOVECANNON) then
			if SchoolbagAPI.ConfirmUseActive( player, COLLECTIBLE_LOVECANNON ) then
			local vector = SchoolbagAPI.DirToVec(player:GetFireDirection())
			local playerdata = GetEntityData(player);
			local psprite = player:GetSprite()
			local controller = player.ControllerIndex;
			if not (psprite:IsPlaying("Trapdoor") or psprite:IsPlaying("Jump") or psprite:IsPlaying("HoleIn") or psprite:IsPlaying("HoleDeath") or psprite:IsPlaying("JumpOut") or psprite:IsPlaying("LightTravel") or psprite:IsPlaying("Appear") or psprite:IsPlaying("Death") or psprite:IsPlaying("TeleportUp") or psprite:IsPlaying("TeleportDown")) and not (playerdata.IsUninteractible) then
				--if --[[OPTIONS.HOLD_DROP_FOR_SPECIAL_ATTACK == false or Input.IsActionPressed(ButtonAction.ACTION_DROP, controller)]] playerdata.isReadyForSpecialAttack then
					if  yandereWaifu:getReserveStocks(player) >= 1 and playerdata.NoBoneSlamActive then --((player:GetSoulHearts() >= 2 and player:GetHearts() > 0) or player:GetHearts() > 2) and playerdata.NoBoneSlamActive then
						if GetEntityData(player).currentMode == REBECCA_MODE.RedHearts then --if red 
							playerdata.specialActiveAtkCooldown = 120;
							playerdata.invincibleTime = 10;
							playerdata.redcountdownFrames = 0;  --just in case, it kinda breaks occasionally, so that's weird
						elseif GetEntityData(player).currentMode == REBECCA_MODE.SoulHearts then --if blue 
							playerdata.specialActiveAtkCooldown = 60;
							playerdata.soulcountdownFrames = 0;
						elseif GetEntityData(player).currentMode == REBECCA_MODE.GoldHearts then --if yellow 
							playerdata.specialActiveAtkCooldown = 30;
						elseif GetEntityData(player).currentMode == REBECCA_MODE.EvilHearts then --if black 
							playerdata.specialActiveAtkCooldown = 75;
						elseif GetEntityData(player).currentMode == REBECCA_MODE.EternalHearts then --if black 
							playerdata.specialActiveAtkCooldown = 120;
						elseif GetEntityData(player).currentMode == REBECCA_MODE.BoneHearts then --if black 
							playerdata.specialActiveAtkCooldown = 20;
						elseif GetEntityData(player).currentMode == REBECCA_MODE.BrideRedHearts then --if bred 
							playerdata.specialActiveAtkCooldown = 80;
							playerdata.invincibleTime = 10;
							playerdata.redcountdownFrames = 0;  --just in case, it kinda breaks occasionally, so that's weird
						end
						playerdata.specialAttackVector = Vector( vector.X, vector.Y );
						playerdata.IsAttackActive = true;
									-- should probably play some sort of sound indicating damage
									--player:AddHearts(-1);
									
									--yandereWaifu:purchaseReserveStocks(player, 1)
									--[[
									consider as an alternative to simply removing a half heart
									player:TakeDamage( 1, DamageFlag.DAMAGE_NOKILL | DamageFlag.DAMAGE_RED_HEARTS, EntityRef(player), 0);
									player:ResetDamageCooldown()
									]]
						--playerdata.ATTACK_DOUBLE_TAP.cooldown = playerdata.specialActiveAtkCooldown;
						playerdata.isReadyForSpecialAttack = false;
						playerdata.AttackVector = vector;
									
						playerdata.specialMaxActiveAtkCooldown = playerdata.specialActiveAtkCooldown;
						SchoolbagAPI.ToggleShowActive(player, false, true)
						SchoolbagAPI.ConsumeActiveCharge(player, true)
					else
						yandereWaifu:purchaseReserveStocks(player, 1, true)
						--SchoolbagAPI.ToggleShowActive(player, false, true)
						speaker:Play( SoundEffect.SOUND_THUMBS_DOWN, 1, 0, false, 1 );
						--playerdata.ATTACK_DOUBLE_TAP.cooldown = OPTIONS.FAILED_SPECIAL_ATTACK_COOLDOWN;
					end
					--SchoolbagAPI.ConsumeActiveCharge(player, true)
					--yandereWaifu:purchaseReserveStocks(player, 1, true)
				end 
			--end
			end
		end

	
	end
	
	--items function!
	if player:HasCollectible(COLLECTIBLE_LUNCHBOX) and SchoolbagAPI.HasJustPickedCollectible( player, COLLECTIBLE_LUNCHBOX ) then
		for i = 0, 2, 1 do
			local spawnPosition = room:FindFreePickupSpawnPosition(player.Position, 1);
			local newpickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, MirrorHeartDrop[math.random(1,6)], spawnPosition, Vector(0,0), player)
		end
		player:AddNullCostume(LunchboxCos)
	end
	if player:HasCollectible(COLLECTIBLE_POWERLOVE) and SchoolbagAPI.HasJustPickedCollectible( player, COLLECTIBLE_POWERLOVE) then
		player:AddNullCostume(LovePower)
	end
	--love = Power
	local H = player:GetHearts()
	if player:HasCollectible(COLLECTIBLE_POWERLOVE) then
		if data.H ~= H then
			player:AddCacheFlags(CacheFlag.CACHE_DAMAGE);
			player:AddCacheFlags(CacheFlag.CACHE_SPEED);
			player:EvaluateItems()
		end
		data.H = H
	elseif not player:HasCollectible(COLLECTIBLE_POWERLOVE) and data.H then
		data.H = nil
		player:AddCacheFlags(CacheFlag.CACHE_DAMAGE);
		player:AddCacheFlags(CacheFlag.CACHE_SPEED);
		player:EvaluateItems()
	end
	--cursed spoon
	if player:HasCollectible(COLLECTIBLE_CURSEDSPOON) and SchoolbagAPI.HasJustPickedCollectible( player, COLLECTIBLE_CURSEDSPOON) then
		player:AddNullCostume(CursedMawCos)
	end
	--typical rom-command
	if player:HasCollectible(COLLECTIBLE_ROMCOM) then
		if SchoolbagAPI.ConfirmUseActive( player, COLLECTIBLE_ROMCOM ) then
			local vector = SchoolbagAPI.DirToVec(player:GetFireDirection())
			data.specialAttackVector = Vector( vector.X, vector.Y )
			SchoolbagAPI.ConsumeActiveCharge(player)
			SchoolbagAPI.ToggleShowActive(player, false)
			
			local rng = math.random(1,5)
			yandereWaifu:DoExtraBarrages(player, rng)
		end
	end
	--lovesick
	if player:HasCollectible(COLLECTIBLE_LOVESICK) then
		if SchoolbagAPI.HasJustPickedCollectible( player, COLLECTIBLE_LOVESICK) then
			player:AddNullCostume(LoveSickCos)
		end
		if Isaac.GetFrameCount() % 120 == 0 then
			SpawnHeartParticles( 1, 3, player.Position, RandomHeartParticleVelocity(), player, HeartParticleType.Red );
			local fart = Isaac.Spawn(EntityType.ENTITY_EFFECT, ENTITY_PHEROMONES_RING, 0, player.Position, Vector(0,0), player)
			GetEntityData(fart).Player = player
		end
	end
	--snap
	if player:HasCollectible(COLLECTIBLE_SNAP) then
		if SchoolbagAPI.HasJustPickedCollectible( player, COLLECTIBLE_SNAP) then
			player:AddNullCostume(UnsnappedCos)
		end
		local maxH, H = player:GetMaxHearts(), player:GetHearts()
		local ratioH
		if maxH - H == 0 then ratioH = 1 else ratioH = maxH - H end
		if H <= 2 then
			if not data.hasSnap then
				local fart = Isaac.Spawn(EntityType.ENTITY_EFFECT, ENTITY_SNAP_EFFECT, 0, player.Position, Vector(0,0), player)
				player:AnimateSad()
				
				player:AddNullCostume(SnappedCos)
				player:TryRemoveNullCostume(UnsnappedCos)
			end
			data.hasSnap = true
		else
			if data.hasSnap == true then
				data.hasSnap = false
				
				player:AddNullCostume(UnsnappedCos)
				player:TryRemoveNullCostume(SnappedCos)
			end
		end
		local modulusF = (math.floor(240/ratioH))
		if data.hasSnap then modulusF = 10 end
		--print(player.FireDelay.."  "..data.SnapDelay)
		if Isaac.GetFrameCount() % modulusF == 0 then
			local fart = Isaac.Spawn(EntityType.ENTITY_EFFECT, ENTITY_SNAP_HEARTBEAT, 0, player.Position, Vector(0,0), player)
			GetEntityData(fart).Snap = data.hasSnap
		end
		if (math.random(1,30)) >= 30 then
			if player.FireDelay > 0 and data.hasSnap then
				data.SnapDelay = math.random(math.floor(player.MaxFireDelay/3), player.MaxFireDelay/2)
				player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY);
				player:EvaluateItems()
			end
		end
	end
	--unrequited love
	if player:HasCollectible(COLLECTIBLE_UNREQUITEDLOVE) then
		if SchoolbagAPI.ConfirmUseActive( player, COLLECTIBLE_UNREQUITEDLOVE ) then
			local vector = SchoolbagAPI.DirToVec(player:GetFireDirection())
			local hook = Isaac.Spawn(EntityType.ENTITY_EFFECT, ENTITY_LOVEHOOK, 0, player.Position, vector:Resized(45), player)
			hook.RenderZOffset = -10000;
			GetEntityData(hook).Player = player
			SchoolbagAPI.ConsumeActiveCharge(player)
			SchoolbagAPI.ToggleShowActive(player, false)
			
		end
	end
	--yandereWaifu:EctoplasmLeaking(player) 
end)

--custom animation actions and other gimmicks that I can't name in one word lol
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local sprite = eff:GetSprite();
	local data = GetEntityData(eff);
	local room =  Game():GetRoom();
	if not data.Player then
		Isaac.DebugString("fool")
	end
    local roomClampSize = math.max( data.Player.Size, 20 );
	local controller = data.Player.ControllerIndex
	if not data.gravityData then data.gravityData = {} end
	local gravityData = data.gravityData
	
	
	if not GetEntityData(data.Player).BoneStacks then GetEntityData(data.Player).BoneStacks = 0 end
	
	if not data.DontFollowPlayer then
		eff.Position = data.Player.Position
		eff.Velocity = data.Player.Velocity
	end
	
    local bonerOwnerData = GetEntityData(data.Player);
	if data.IsHopping then
	
		local function End()
			print("how")
			--data.Player.GridCollisionClass = GetEntityData(data.Player).LastGridCollisionClass;
			--data.Player.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
			data.Player.Visible = true
			data.Player.FireDelay = 0
			GetEntityData(data.Player).IsDashActive = false
			GetEntityData(data.Player).NoBoneSlamActive = true
			GetEntityData(data.Player).IsVaulting = false
			GetEntityData(data.Player).IsUninteractible = false
			eff:Remove()
		end
		if eff.FrameCount == 1 then --beginning
			sprite:Load("gfx/effects/bone/bonedash.anm2",true)
			sprite:Play("StartSlam", true) --normal attack
			data.Player.Visible = false
			GetEntityData(data.Player).IsUninteractible = true
			--GetEntityData(data.Player).LastGridCollisionClass = data.Player.GridCollisionClass;
			--GetEntityData(data.Player).LastEntityCollisionClass = data.Player.EntityCollisionClass;
			data.BounceCount = 1 --this checks how much times you have been bouncing
		elseif sprite:IsFinished("StartSlam") then
			sprite:Play("Falling", true)
		elseif sprite:IsFinished("Falling") and data.BounceCount then
			if data.BounceCount < 3 then
				sprite:Play("Falling", true)
				data.BounceCount = data.BounceCount + 1
			else
				End()
			end
		elseif sprite:IsPlaying("Falling") then
			data.Player.Velocity = data.Player.Velocity * 1.15
			if (Input.IsActionPressed(ButtonAction.ACTION_SHOOTDOWN, controller) or Input.IsActionPressed(ButtonAction.ACTION_SHOOTUP, controller) 
			or Input.IsActionPressed(ButtonAction.ACTION_SHOOTLEFT, controller) or Input.IsActionPressed(ButtonAction.ACTION_SHOOTRIGHT, controller)) then
				local customBody = Isaac.Spawn(EntityType.ENTITY_EFFECT, ENTITY_EXTRACHARANIMHELPER, 0, data.Player.Position, Vector(0,0), data.Player) --body effect
				GetEntityData(customBody).Player = data.Player
				GetEntityData(customBody).IsVaulting = true
				GetEntityData(GetEntityData(customBody).Player).vaultVelocity = data.Player:ToPlayer():GetMovementInput():Resized( BALANCE.BONE_HEARTS_VAULT_VELOCITY );
				eff:Remove()
			end
		end
	elseif data.IsVaulting then
		if eff.FrameCount == 1 then --beginning
			sprite:Load("gfx/effects/bone/bonedash.anm2",true)
			sprite:Play("StartSlam", true) --normal attack
			if not data.CurrentAirSpan then data.CurrentAirSpan = 0 end
			data.Player.Visible = false
			GetEntityData(data.Player).IsUninteractible = true
			GetEntityData(data.Player).LastGridCollisionClass = data.Player.GridCollisionClass;
			GetEntityData(data.Player).LastEntityCollisionClass = data.Player.EntityCollisionClass;
		elseif sprite:IsFinished("StartSlam") then
			GetEntityData(data.Player).LastGridCollisionClass = data.Player.GridCollisionClass;
			sprite:Play("InAir")
			GetEntityData(data.Player).InAir = true
			data.Player.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
			data.Player.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		end
		--print(tostring(gravityData.ZOffsetFloat))
		if GetEntityData(data.Player).InAir then
			if not gravityData.Init then
				gravityData.InAirSpan = 30 --this tells how long does it take for Rebecca to be in air
				gravityData.ZOffsetVector = Vector(0,0) --tells how high the sprite is supposed to be
				gravityData.ZOffsetFloat = 0 --tells how high sprite is with a number, not a vector
				gravityData.IsSlamming = false --tells if Rebecca is going to slam down/ seems to be unused lol
				gravityData.AccelAddFloat = 10 --tells how fast Rebecca is going to go up and down
				gravityData.AirSpanMultiply = 1 --tells how fast the current air span should be going
                gravityData.Init = true
				GetEntityData(data.Player).BoneStacks = 0 --this tells how much you bounced...
			end
			data.CurrentAirSpan = data.CurrentAirSpan + (1*gravityData.AirSpanMultiply) --adds up special frame for how long they are in midair
			if not gravityData.IsSlamming then
				--arc code
				if data.CurrentAirSpan <= ((gravityData.InAirSpan/2)-6) then --if in the first half of the arc
					gravityData.ZOffsetVector = gravityData.ZOffsetVector + Vector(0,-(gravityData.AccelAddFloat))
					gravityData.ZOffsetFloat = gravityData.ZOffsetFloat + gravityData.AccelAddFloat 
				elseif data.CurrentAirSpan >= ((gravityData.InAirSpan/2)+6) and data.CurrentAirSpan < gravityData.InAirSpan then --if in the other half of the arc
					gravityData.ZOffsetVector = gravityData.ZOffsetVector - Vector(0,-(gravityData.AccelAddFloat))
					gravityData.ZOffsetFloat = gravityData.ZOffsetFloat - gravityData.AccelAddFloat 
				elseif data.CurrentAirSpan >= gravityData.InAirSpan then --if finished being in midair
					sprite:Play("EndLand", true)
					GetEntityData(data.Player).InAir = false
					data.CurrentAirSpan = 0
					speaker:Play( SoundEffect.SOUND_FETUS_LAND, 1, 0, false, 0.7 );
				end
            end
            --[[ this section keeps the player moving in the same direction they start vaulting
            while also slightly decaying that velocity and allowing minimal adjustments ]]
			
            data.Player.Velocity = bonerOwnerData.vaultVelocity;
            bonerOwnerData.vaultVelocity = bonerOwnerData.vaultVelocity * 0.95 + data.Player:GetMovementInput():Resized(0.5);

            eff.Velocity = data.Player.Position - eff.Position
			
			data.Player.Position = room:GetClampedPosition(data.Player.Position, roomClampSize);
			--eff.Position = data.Player.Position
			eff.SpriteOffset = gravityData.ZOffsetVector
			data.Player.FireDelay = data.Player.MaxFireDelay --keeps Rebecca from firing, it's creepy to see tears pop out of nowhere...
			--slamdown code!
			if (Input.IsActionPressed(ButtonAction.ACTION_SHOOTDOWN, controller) or Input.IsActionPressed(ButtonAction.ACTION_SHOOTUP, controller) 
			or Input.IsActionPressed(ButtonAction.ACTION_SHOOTLEFT, controller) or Input.IsActionPressed(ButtonAction.ACTION_SHOOTRIGHT, controller)) 
			and gravityData.ZOffsetFloat >= 50 and gravityData.ZOffsetFloat then --if you shoot and is in the other end of the arc process
				sprite:Play("SlamDown", true)
				GetEntityData(data.Player).InAir = false
                gravityData.IsSlamming = true
                data.Player.Velocity = data.Player.Velocity * 0.2;
                bonerOwnerData.vaultVelocity = bonerOwnerData.vaultVelocity * 0.2;
			end
			local homeEnt = SchoolbagAPI.GetClosestGenericEnemy(eff, 100)
			--friendly home effect
			if homeEnt and homeEnt:IsActiveEnemy() and homeEnt:IsVulnerableEnemy() then
				data.Player.Velocity = data.Player.Velocity + ((homeEnt.Position - data.Player.Position) * 0.05)
			end
		elseif sprite:IsPlaying("SlamDown") then
			--dashdown code
			if gravityData.ZOffsetFloat <= 0 then
				sprite:Play("EndSlam") --end slam anim
				GetEntityData(data.Player).InAir = false
				for i, entities in pairs(Isaac.GetRoomEntities()) do
					if entities:IsEnemy() and entities:IsVulnerableEnemy() and not entities:IsDead() then
						if entities.Position:Distance(data.Player.Position) < entities.Size + data.Player.Size + 45 then
							entities:TakeDamage(data.Player.Damage, 0, EntityRef(eff), 1)
							if entities.Position:Distance(data.Player.Position) < entities.Size + data.Player.Size and data.Player.Size <= (entities.Size - 2) then --if close enough and if the entity slammed on is bigger than Rebecca, cause it doesn't makes sense if you can bounce on a tiny thing like a fly...
                                bonerOwnerData.vaultVelocity = bonerOwnerData.vaultVelocity + data.Player:ToPlayer():GetMovementInput();
                                data.WillBounceAgain = true--this tells if you have successfully hit somebody wants told me the world is gonna- sorry
								data.HasBounced = true --this tells that you had bounced
							end
						end
					end
				end
				speaker:Play( SoundEffect.SOUND_FORESTBOSS_STOMPS, 1, 0, false, 1 );
				game:ShakeScreen(10);
			else
				gravityData.ZOffsetVector = gravityData.ZOffsetVector - Vector(0,-(gravityData.AccelAddFloat*2))
				gravityData.ZOffsetFloat = gravityData.ZOffsetFloat - (gravityData.AccelAddFloat*2)
			end
			eff.Velocity = data.Player.Velocity
			eff.Position = data.Player.Position
			eff.SpriteOffset = gravityData.ZOffsetVector
			data.Player.FireDelay = data.Player.MaxFireDelay --keeps Rebecca to not fire, it's creepy to see tears pop out of nowhere...
		end
		--finished job
		if sprite:IsPlaying("EndSlam") or sprite:IsPlaying("EndLand") then
			if sprite:IsPlaying("EndSlam") and sprite:GetFrame() == 1 then
				local gridStomped = room:GetGridEntityFromPos(eff.Position) --grid that Rebecca stepped on
				--if gridStomped:GetType() == GridEntityType.GRID_TNT or gridStomped:GetType() == GridEntityType.GRID_ROCK then
				if gridStomped ~= nil then
					gridStomped:Destroy()
				end
				if GetEntityData(data.Player).BoneStacks > 0 then
					GetEntityData(data.Player).specialBoneHeartStompCooldown = BALANCE.BONE_HEARTS_MODIFIED_DASH_COOLDOWN;
				end
				--elseif gridStomped:GetType() == GridEntityType.GRID_TNT
			end
			if not data.WillBounceAgain then
				eff.Velocity = eff.Velocity * 0.7
				data.Player.Velocity = Vector(0,0)
				data.Player.Position = eff.Position
			else
			--print("has went here")
				--reset!
				sprite:Play("InAir")
				GetEntityData(data.Player).InAir = true
				gravityData.InAirSpan = 45 
				gravityData.ZOffsetVector = Vector(0,0) 
				gravityData.ZOffsetFloat = 0 
				gravityData.IsSlamming = false 
				data.CurrentAirSpan = 0
				data.WillBounceAgain = false
				data.Player.Velocity = ((data.Player.Velocity * 0.9) + Vector.FromAngle(1*math.random(1,360))*(math.random(10,14))) * (2 + ((GetEntityData(data.Player).BoneStacks*5)/10))
				--difficulty added to each bounce made is done below:
				gravityData.AccelAddFloat = gravityData.AccelAddFloat + 2
				gravityData.AirSpanMultiply = gravityData.AirSpanMultiply + 0.3
				--add stacks
				GetEntityData(data.Player).BoneStacks = GetEntityData(data.Player).BoneStacks + 1
				--effect
				local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, ENTITY_SLAMDUST, 0, data.Player.Position, Vector(0,0), data.Player)		
			end
			if sprite:GetFrame() == 1 then
				local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, ENTITY_SLAMDUST, 0, data.Player.Position, Vector(0,0), data.Player)			
			end
		elseif sprite:IsFinished("EndSlam") or sprite:IsFinished("EndLand") then
			data.Player.Position = eff.Position
			--revert back player!
			if data.Player.CanFly == true and room:GetType() ~= RoomType.ROOM_DUNGEON then
    		data.Player.Position = eff.Position;
				if room:IsPositionInRoom(data.Player.Position, 0) == false then
					data.Player.Velocity = Vector( 0, 0 );
					data.Player.Position = room:GetClampedPosition( data.Player.Position, roomClampSize );
				end
			else
				data.Player.Position = room:FindFreeTilePosition( eff.Position, 0 )
				if room:IsPositionInRoom(data.Player.Position, 0) == false then
					data.Player.Velocity = Vector( 0, 0 );
					data.Player.Position = room:FindFreeTilePosition( room:GetClampedPosition( data.Player.Position, roomClampSize ), 0 );
				end
			end
			data.Player.GridCollisionClass = GetEntityData(data.Player).LastGridCollisionClass;
			data.Player.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
			data.Player.Visible = true
			data.Player.FireDelay = 0
			GetEntityData(data.Player).IsVaulting = false
			GetEntityData(data.Player).IsUninteractible = false
			GetEntityData(data.Player).IsDashActive = false
			GetEntityData(data.Player).NoBoneSlamActive = true
			--add special stuff to the code
			if data.HasBounced then --makes it that you can't vault immediately after successful bouncing
				--GetEntityData(data.Player).specialCooldown = BONE_HEARTS_MODIFIED_DASH_COOLDOWN;
				GetEntityData(data.Player).invincibleTime = BALANCE.BONE_HEARTS_DASH_INVINCIBILITY_FRAMES;
				data.HasBounced = false;
				--DASH_DOUBLE_TAP.cooldown = GetEntityData(data.Player).specialCooldown; --adds something new for the cooldowns, because the default stuff cant be used
			end
			eff:Remove()
		end
		--code just in case Rebecca is dead but this thing isn't lol
		if data.Player:IsDead() then eff:Remove() end
	elseif data.IsSlamming then
		data.Player.Velocity = Vector(0,0);
		if eff.FrameCount == 1 then --beginning
			--print(tostring(data.Player:GetData().BoneStacks))
			data.Player.Visible = false
			eff.Visible = true
			--GetEntityData(data.Player).invincibleTime = BALANCE.BONE_HEARTS_MODIFIED_DASH_INVINCIBILITY_FRAMES;
			sprite:Load("gfx/characters/slamdownsp.anm2",true)
			if not data.CurrentAirSpan then data.CurrentAirSpan = 0 end
			GetEntityData(data.Player).IsUninteractible = true
			data.Player.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
			data.Player.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
			if not GetEntityData(data.Player).BoneStacks or GetEntityData(data.Player).BoneStacks <= 1 and GetEntityData(data.Player).BoneStacks >= 0 then
				sprite:Play("BoneDown0",true)
				--print("gosh")
				sprite:Play("BoneDown"..tostring(GetEntityData(data.Player).BoneStacks),true)
			elseif GetEntityData(data.Player).BoneStacks and GetEntityData(data.Player).BoneStacks > 5 then
				sprite:Play("BoneDown5",true)
			elseif GetEntityData(data.Player).BoneStacks and GetEntityData(data.Player).BoneStacks >= 2 and GetEntityData(data.Player).BoneStacks <= 5 then
				sprite:Play("BoneDown"..tostring(GetEntityData(data.Player).BoneStacks),true)
				--print("woahs")
			end 
		elseif SchoolbagAPI.IsPlayingMultiple(sprite, "BoneDown2", "BoneDown3", "BoneDown4", "BoneDown5") then
			--sund
			if sprite:GetFrame() > 0 then
				speaker:Play( SOUND_PUNCH, 1, 0, false, 1 );
			end
		elseif sprite:IsFinished("BoneDown"..tostring(GetEntityData(data.Player).BoneStacks)) or sprite:IsFinished("BoneDown5") or sprite:IsFinished("BoneDown0")then
			
			--other stuff
			if data.Player.CanFly == true and room:GetType() ~= RoomType.ROOM_DUNGEON then
    		data.Player.Position = eff.Position;
				if room:IsPositionInRoom(data.Player.Position, 0) == false then
					data.Player.Velocity = Vector( 0, 0 );
					data.Player.Position = room:GetClampedPosition( data.Player.Position, roomClampSize );
				end
			else
				data.Player.Position = room:FindFreeTilePosition( eff.Position, 0 )
				if room:IsPositionInRoom(data.Player.Position, 0) == false then
					data.Player.Velocity = Vector( 0, 0 );
					data.Player.Position = room:FindFreeTilePosition( room:GetClampedPosition( data.Player.Position, roomClampSize ), 0 );
				end
			end

			data.Player.EntityCollisionClass = GetEntityData(data.Player).LastEntityCollisionClass
			data.Player.GridCollisionClass = GetEntityData(data.Player).LastGridCollisionClass
			data.Player.Position = eff.Position
			GetEntityData(data.Player).IsUninteractible = false
			data.Player.Visible = true
			data.Player.ControlsEnabled = true
			eff:Remove()
			local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, ENTITY_SLAMDUST, 0, data.Player.Position, Vector(0,0), data.Player);
			speaker:Play( SoundEffect.SOUND_FORESTBOSS_STOMPS, 1, 0, false, 1 );
			game:ShakeScreen(10);
			GetEntityData(data.Player).invincibleTime = BALANCE.BONE_HEARTS_DASH_INVINCIBILITY_FRAMES;
			--print(tostring(GetEntityData(data.Player).invincibleTime))
			--pound!
			for i, entities in pairs(Isaac.GetRoomEntities()) do
				if entities:IsEnemy() and entities:IsVulnerableEnemy() and not entities:IsDead() then
					if entities.Position:Distance(data.Player.Position) < entities.Size + data.Player.Size + 60 + (GetEntityData(data.Player).BoneStacks * 2) then
						entities:TakeDamage(data.Player.Damage * (2*(1+(GetEntityData(data.Player).BoneStacks*5))), 0, EntityRef(eff), 1)
					end
				end
			end
			--crackwaves
			for i = 0, 360, 360/4 do
				local crack = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACKWAVE, 0, data.Player.Position, Vector.FromAngle(i), ent):ToEffect()
				crack.LifeSpan = 0+(GetEntityData(data.Player).BoneStacks);
				crack:SetDamageSource (EntityType.ENTITY_PLAYER);
				crack.Rotation = i
			end
			GetEntityData(data.Player).BoneStacks = 0
			GetEntityData(data.Player).NoBoneSlamActive = true
		end
	elseif data.IsJumpingUp then --deprecated?
		if eff.FrameCount == 1 then --beginning
			data.Player.Visible = false
			eff.Visible = true
			sprite:Load("gfx/characters/slamdownsp.anm2",true)
			sprite:Play("JumpUp",true)
		elseif sprite:IsFinished("JumpUp") then
			eff:Remove()
		end
	elseif data.IsLeftover then
		if eff.FrameCount == 1 then --beginning
			--data.Player.Visible = false
			sprite:Load("gfx/effects/bone/bonebody.anm2",true)
			sprite:Play("Dies",true)
		elseif sprite:IsFinished("Dies") then
			sprite:Play("Chill",true)
		elseif sprite:IsFinished("Revives") then
			eff:Remove()
		end
	elseif data.WizoobIn then
		if eff.FrameCount == 1 then --beginning
			data.Player.Visible = false
			eff.Visible = true
			sprite:Load("gfx/characters/wizoobteleport.anm2",true)
			sprite:Play("Vanish",true)
		elseif sprite:IsFinished("Vanish") then
			eff:Remove()
			local target = Isaac.Spawn( EntityType.ENTITY_EFFECT, ENTITY_SOULTARGET, 0, data.Player.Position, Vector(0,0), data.Player );
			GetEntityData(target).Parent = data.Player
			data.Player.ControlsEnabled = true
		end
		
	elseif data.WizoobOut then
		data.Player.Position = eff.Position
		data.Player.Velocity = eff.Velocity
		if eff.FrameCount == 1 then --beginning
			data.Player.Visible = false
			eff.Visible = true
			sprite:Load("gfx/characters/wizoobteleport.anm2",true)
			sprite:Play("Appear",true)
		elseif eff.FrameCount == 5 then
			SpawnPoofParticle( data.Player.Position, Vector( 0, 0 ), data.Player, PoofParticleType.Blue );
			SpawnHeartParticles( 3, 5, data.Player.Position, RandomHeartParticleVelocity(), player, HeartParticleType.Blue );
			SpawnEctoplasm( data.Player.Position, Vector ( 0, 0 ) , math.random(13,15)/10, data.Player);
			GetEntityData(data.Player).LeaksJuices = 80;
			
			local chosenNumofBarrage =  math.random( 6, 9 );
			for i = 1, chosenNumofBarrage do
				data.Player.Velocity = data.Player.Velocity * 0.8; --slow him down
				--local tear = player:FireTear(player.Position, Vector.FromAngle(data.specialAttackVector:GetAngleDegrees() - math.random(-10,10))*(math.random(10,15)), false, false, false):ToTear()
				local tear = game:Spawn( EntityType.ENTITY_TEAR, 0, data.Player.Position, Vector.FromAngle( math.random() * 360 ):Resized(BALANCE.GOLD_HEARTS_DASH_ATTACK_SPEED), player, 0, 0):ToTear()
				SchoolbagAPI.MakeTearLob(tear, -9, 9 )
				tear:GetSprite():ReplaceSpritesheet(0, "gfx/tears_ecto.png")
				tear:GetSprite():LoadGraphics()
				tear.Scale = math.random() * 0.7 + 0.7;
				tear.CollisionDamage = data.Player.Damage * 1.3;
				--tear.BaseDamage = player.Damage * 2
			end
		elseif sprite:IsFinished("Appear") then
			GetEntityData(data.Player).IsDashActive = false
			eff:Remove()
			data.Player.Visible = true;
			data.Player.ControlsEnabled = true;
			data.Player.GridCollisionClass = GetEntityData(data.Player).LastGridCollisionClass;
			data.Player.EntityCollisionClass = GetEntityData(data.Player).LastEntityCollisionClass;
		end
	
	end
end, ENTITY_EXTRACHARANIMHELPER)

--custom animation actions and other gimmicks that I can't name in one word lol
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, function(_, eff)
	local sprite = eff:GetSprite();
	local data = GetEntityData(eff);
	local player = data.Player
	
	if data.DashEffect then
		local BOff = GetEntityData(player).countdownFrames
		local customColor = Color(1, 1, 1, 1, BOff, BOff, BOff)
		local sprite = player:GetSprite()
		--sprite:Render(Isaac.WorldToScreen(eff.Position), Vector(0,0), Vector(0,0))
		player.Visible = true
		player:RenderGlow(Isaac.WorldToScreen(eff.Position))
		player:RenderBody(Isaac.WorldToScreen(eff.Position))
		player:RenderHead(Isaac.WorldToScreen(eff.Position))
		player:RenderTop(Isaac.WorldToScreen(eff.Position))
		player:SetColor(customColor, 1, 1, true, true)
		--sprite.FlipX = true
		if GetEntityData(player).countdownFrames >= 7 then
			eff:Remove()
		end
	end
end, ENTITY_EXTRACHARANIMHELPER)

--Color(1, 1, 2.25, 1, 0, 0, 0)
local customColor = Color(1, 1, 2.25, 1, 0, 0, 0)

--NPC UPDATE!11!!1!!
do
yandereWaifu:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, ent)
	local player = Isaac.GetPlayer(0)
	local data = ent:GetData()
	
	--blessed effect
	if data.IsBlessed then
		ent:SetColor(customColor, 2, 5, true, true)
	end
	if data.IsBlessed then
		if ent:IsDead() then -- on death
			for i, entenmies in pairs(Isaac.GetRoomEntities()) do --affect others
				if entenmies:IsEnemy() and entenmies:IsVulnerableEnemy() then
					if entenmies:GetData().IsBlessed then
						entenmies:TakeDamage(player.Damage, 0, EntityRef(ent), 1)
					end
				end
			end
		end
	end
	
	--lovesick effect
	if ent:HasEntityFlags(EntityFlag.FLAG_CHARM) and player:HasCollectible(COLLECTIBLE_LOVESICK) then
		if game:GetFrameCount() % 120 == 0 then
			ent:TakeDamage(3.5, 0, EntityRef(player), 4)
		end
	end
end)
yandereWaifu:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, function(_, ent)
    local data = ent:GetData()
    if data.IsBlessed then

        if not game:IsPaused() then
            data.IsBlessed = data.IsBlessed - 1
            if data.IsBlessed <= 0 then
                data.IsBlessed = nil
            end
        end
    end
end)
end

----------
--ITEMS!--
----------
--Miraculous Womb Fams--

function yandereWaifu:EsauInit(fam)
    local sprite = fam:GetSprite()
    sprite:Play("FloatDown", true)
	fam.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
	fam:AddToOrbit(50)
	
	local data = GetEntityData(fam)
	data.Stat = {
		FireDelay = 25,
		MaxFireDelay = 25,
		Damage = 4.2, 
		PlayerMaxDelay = 0
	}
end
yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, yandereWaifu.EsauInit, ENTITY_ORBITALESAU);

yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_,  fam) 
    local spr = fam:GetSprite()
	local data = GetEntityData(fam)
	local player = fam.Player
	player:ToPlayer()
	
	fam.OrbitDistance = Vector(20, 20)
	fam.OrbitAngleOffset = fam.OrbitAngleOffset+0.06
	fam.Velocity = fam:GetOrbitPosition(player.Position+player.Velocity) - fam.Position
	
	if data.Stat.FireDelay > 0 then data.Stat.FireDelay = data.Stat.FireDelay - 1 end
	
	local playerDir = player:GetFireDirection()
	if playerDir > -1 then
		SchoolbagAPI.AnimShootFrame(fam, true, SchoolbagAPI.DirToVec(playerDir), "FloatShootSide", "FloatShootDown", "FloatShootUp")
		--if firedelay is ready then
		if data.Stat.FireDelay <= 0 then
			local tears = player:FireTear(fam.Position, SchoolbagAPI.DirToVec(playerDir), false, false, false):ToTear()
			tears.CollisionDamage = data.Stat.Damage * player.Damage
			data.Stat.FireDelay = data.Stat.MaxFireDelay
		end
		
		if data.Stat.PlayerMaxDelay ~= player.MaxFireDelay then --balance purposes. They are so broken if I don't do this
			data.Stat.MaxFireDelay = 25 + player.MaxFireDelay/2
			data.Stat.PlayerMaxDelay = player.MaxFireDelay
		end
	else
		spr:Play("FloatDown", true)
	end
	
end, ENTITY_ORBITALESAU);

function yandereWaifu:JacobInit(fam)
    local sprite = fam:GetSprite()
    sprite:Play("FloatDown", true)
	fam.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
	fam:AddToOrbit(50)
	
	local data = GetEntityData(fam)
	data.Stat = {
		FireDelay = 6,
		MaxFireDelay = 6,
		Damage = 2, 
		PlayerMaxDelay = 0
	}
end
yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, yandereWaifu.JacobInit, ENTITY_ORBITALJACOB);

yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_,  fam) 
    local spr = fam:GetSprite()
	local data = GetEntityData(fam)
	local player = fam.Player
	player:ToPlayer()
	
	fam.OrbitDistance = Vector(20, 20)
	fam.OrbitAngleOffset = fam.OrbitAngleOffset+0.06
	fam.Velocity = fam:GetOrbitPosition(player.Position+player.Velocity) - fam.Position
	
	if data.Stat.FireDelay > 0 then data.Stat.FireDelay = data.Stat.FireDelay - 1 end
	
	local playerDir = player:GetFireDirection()
	if playerDir > -1 then
		SchoolbagAPI.AnimShootFrame(fam, true, SchoolbagAPI.DirToVec(playerDir), "FloatShootSide", "FloatShootDown", "FloatShootUp")
		--if firedelay is ready then
		if data.Stat.FireDelay <= 0 then
			local tears = player:FireTear(fam.Position, SchoolbagAPI.DirToVec(playerDir), false, false, false):ToTear()
			tears.CollisionDamage = player.Damage - data.Stat.Damage
			data.Stat.FireDelay = data.Stat.MaxFireDelay
		end
		if data.Stat.PlayerMaxDelay ~= player.MaxFireDelay then --balance purposes. They are so broken if I don't do this
			data.Stat.MaxFireDelay = 6 + player.MaxFireDelay/4
			data.Stat.PlayerMaxDelay = player.MaxFireDelay
		end
	else
		spr:Play("FloatDown", true)
	end
	
end, ENTITY_ORBITALJACOB);
 
--ETERNAL BOND--
function yandereWaifu:TinyBeccaInit(fam)
	if fam.Variant == ENTITY_TINYBECCA then --Rebecca--
		local sprite = fam:GetSprite()
		local data = GetEntityData(fam)
		sprite:Play("StandingVert", true)
		fam.GridCollisionClass =  EntityGridCollisionClass.GRIDCOLL_GROUND;
		fam.EntityCollisionClass =  EntityCollisionClass.ENTCOLL_NONE;
		fam:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
		fam:AddEntityFlags(EntityFlag.FLAG_PERSISTENT)
		data.Stat = {
			FireDelay = 14,
			MaxFireDelay = 14,
			Damage = 1.77, 
			PlayerMaxDelay = 0,
			Wallet = 0,
			Mode = 0
		}
	end
	if fam.Variant == ENTITY_TINYISAAC then --Isaac--
		local sprite = fam:GetSprite()
		local data = GetEntityData(fam)
		sprite:Play("StandingVert", true)
		fam.GridCollisionClass =  EntityGridCollisionClass.GRIDCOLL_GROUND;
		fam.EntityCollisionClass =  EntityCollisionClass.ENTCOLL_NONE;
		fam:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
		fam:AddEntityFlags(EntityFlag.FLAG_PERSISTENT)
		data.Stat = {
			FireDelay = 14,
			MaxFireDelay = 14,
			Damage = 3, 
			PlayerMaxDelay = 0,
			Wallet = 0
		}
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_POST_NPC_INIT, yandereWaifu.TinyBeccaInit, ENTITY_TINYFELLOW);

yandereWaifu:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_,  iss) 
	local spr = iss:GetSprite()
	local data = GetEntityData(iss)
	local player = GetEntityData(iss).Parent
	local room = game:GetRoom()
	if iss.Variant == ENTITY_TINYBECCA then
		--bffs! synergy
		local extra = 0
		if player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
			extra = 2
			iss.Scale = 1.5
		else
			iss.Scale = 1
		end
		
		player:ToPlayer()
		if not player:HasCollectible(COLLECTIBLE_ETERNALBOND) then
			iss:Remove()
		end
		if not spr:IsPlaying("Drop") and not spr:IsPlaying("Rage") then
			SchoolbagAPI.AnimWalkFrame(iss, true, "WalkHori", "WalkVert")
		end
		if data.Stat.FireDelay > 0 then data.Stat.FireDelay = data.Stat.FireDelay - 1 end
		if spr:IsEventTriggered("Drop") then
			if player:GetPlayerType() == PlayerType.PLAYER_KEEPER then
				local newpickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, 0, iss.Position, iss.Velocity, iss)
			elseif player:GetPlayerType() == PlayerType.PLAYER_AZAZEL or player:GetPlayerType() == PlayerType.PLAYER_LILITH then
				local newpickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, 6, iss.Position, iss.Velocity, iss)
			elseif player:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN then
				local newpickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, 11, iss.Position, iss.Velocity, iss)
			else
				local tbl = {
					[1] = 3,
					[2] = 8
				}
				local newpickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, tbl[math.random(1,2)], iss.Position, iss.Velocity, iss)
			end
		end
		
		--iss.Velocity = player.Velocity * 0.8
		local enemy = SchoolbagAPI.GetClosestGenericEnemy(iss, 500, iss.Type)
		if data.Stat.Mode == 0 then
			if enemy and not enemy:IsDead() and enemy ~= nil and enemy.Type ~= EntityType.ENTITY_FIREPLACE and enemy:IsActiveEnemy() and  enemy:IsVulnerableEnemy() then
				if not data.specialAttackVector then  data.specialAttackVector = (enemy.Position - iss.Position) end
				if enemy.Position:Distance(iss.Position) > 100 then
					SchoolbagAPI.XalumMoveTowardsTarget(iss, enemy, 6, 0.9, false)
				else
					if Isaac.GetFrameCount() % 400 == 0 then
						yandereWaifu:DoTinyBarrages(iss, data.specialAttackVector)
					else
						SchoolbagAPI.MoveAwayFromTarget(iss, enemy, 4, 0.9)
						if data.Stat.FireDelay <= 0 then
							local tears =  Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0, iss.Position + Vector(0,-3):Rotated(data.specialAttackVector:GetAngleDegrees()), (enemy.Position - iss.Position):Resized(12), player):ToTear()
							tears.Scale = 0.3 + iss.Scale/2
							tears.CollisionDamage = data.Stat.Damage + extra/2
							local tears2 =  Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0, iss.Position + Vector(0,3):Rotated(data.specialAttackVector:GetAngleDegrees()), (enemy.Position - iss.Position):Resized(12), player):ToTear()
							tears2.Scale = 0.3 + iss.Scale/2
							tears2.CollisionDamage = data.Stat.Damage + extra/2
							data.Stat.FireDelay = data.Stat.MaxFireDelay
						end
					end
				end
				data.specialAttackVector = nil
			else
				local nearPickup, pos = SchoolbagAPI.GetClosestPickup(iss, 400, 10, -1)
				if nearPickup and (nearPickup.SubType == 1 or nearPickup.SubType == 2 or nearPickup.SubType == 9 ) then
					SchoolbagAPI.XalumMoveTowardsTarget(iss, nearPickup, 6, 0.9, false)
					if (nearPickup.Position-iss.Position):Length() < 5 and not nearPickup.Touched then
						local picked = SchoolbagAPI.PickupPickup(nearPickup)
						--print(data.Stat.Wallet.."   "..picked.Subtype)
						picked = picked:ToPickup()
						local earned = 0
						if picked.SubType == 1 or picked.SubType == 9 then
							earned = 2
						elseif picked.SubType == 2 then
							earned = 1
						end
						data.Stat.Wallet = data.Stat.Wallet + earned
					end
				else
					if data.Stat.Wallet > 4 and (not spr:IsPlaying("Drop") and not spr:IsPlaying("Rage")) then
						data.Stat.Wallet = data.Stat.Wallet - 5
						spr:Play("Drop", true)
					else
						if (not spr:IsPlaying("Drop") and not spr:IsPlaying("Rage")) then
							if Isaac.GetFrameCount() % 1200 == 0 then
								spr:Play("Drop", true)
							end
							if (iss.Position - player.Position):Length() > 100 then
								SchoolbagAPI.XalumMoveTowardsTarget(iss, player, 8, 0.9, false)
							end
						end
					end
				end
			end
		elseif data.Stat.Mode == 1 then
			if enemy and not enemy:IsDead() and enemy ~= nil and enemy.Type ~= EntityType.ENTITY_FIREPLACE and enemy:IsActiveEnemy() and  enemy:IsVulnerableEnemy() then
				data.specialAttackVector = (enemy.Position - iss.Position)
				if enemy.Position:Distance(iss.Position) > 100 then
					SchoolbagAPI.XalumMoveTowardsTarget(iss, enemy, 6, 0.9, false)
				else
					if Isaac.GetFrameCount() % 800 == 0 then
						yandereWaifu:DoTinyBarrages(iss, data.specialAttackVector)
					else
						SchoolbagAPI.MoveAwayFromTarget(iss, enemy, 4, 0.9)
						if data.Stat.FireDelay <= 0 then
							local tears = player:FireTear(iss.Position, data.specialAttackVector:Resized(8), false, false, false):ToTear()
							tears.Scale = 0.3
							tears.CollisionDamage = data.Stat.Damage
							data.Stat.FireDelay = data.Stat.MaxFireDelay
						end
					end
				end
			end
		end
		iss.Velocity = iss.Velocity * 0.8
	end
	if iss.Variant == ENTITY_TINYISAAC then
		player:ToPlayer()
		
		--bffs! synergy
		local extra = 0
		if player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
			extra = 2
			iss.Scale = 1.5
		else
			iss.Scale = 1
		end
		
		if not player:HasCollectible(COLLECTIBLE_ETERNALBOND) then
			iss:Remove()
		end
		if not spr:IsPlaying("Drop") and not spr:IsPlaying("Drop2") then
			SchoolbagAPI.AnimWalkFrame(iss, true, "WalkHori", "WalkVert")
		end
		if data.Stat.FireDelay > 0 then data.Stat.FireDelay = data.Stat.FireDelay - 1 end
		
		--iss.Velocity = player.Velocity * 0.8
		if spr:IsEventTriggered("Drop") then
			local maths = math.random(1,3)
			if maths == 1 then
				local newpickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_KEY, 0, iss.Position, iss.Velocity, iss)
			elseif maths == 2 then
				local newpickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, 0, iss.Position, iss.Velocity, iss)
			else
				local newpickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, MirrorHeartDrop[math.random(1,6)], iss.Position, iss.Velocity, iss)
			end
		end
		if spr:IsEventTriggered("Drop2") then
			local newpickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, -1, iss.Position, iss.Velocity, iss)
		end
		local enemy = SchoolbagAPI.GetClosestGenericEnemy(iss, 1000, iss.Type)
		if enemy and not enemy:IsDead() and enemy ~= nil and enemy.Type ~= EntityType.ENTITY_FIREPLACE and enemy:IsActiveEnemy() and  enemy:IsVulnerableEnemy() then
			if enemy.Position:Distance(iss.Position) > 100 then
				SchoolbagAPI.XalumMoveTowardsTarget(iss, enemy, 6, 0.9, false)
			else
				if not data.bomb or data.bomb:IsDead() then
					if Isaac.GetFrameCount() % 1200 == 0 then
						data.bomb = Isaac.Spawn(EntityType.ENTITY_BOMBDROP, 0, 0, iss.Position,  Vector.FromAngle((enemy.Position-iss.Position):GetAngleDegrees()):Resized( 9 ), player);
					else
						SchoolbagAPI.MoveAwayFromTarget(iss, enemy, 4, 0.9)
						if data.Stat.FireDelay <= 0 then
							local tears = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0, iss.Position, (enemy.Position - iss.Position):Resized(10), player):ToTear()
							tears.Scale = 0.3 + extra/4
							tears.CollisionDamage = data.Stat.Damage + extra
							data.Stat.FireDelay = data.Stat.MaxFireDelay
						end
					end
				else
					if enemy.Position:Distance(data.bomb.Position) < 100 then
						SchoolbagAPI.MoveAwayFromTarget(iss, data.bomb, 4, 0.9)
					end
				end
			end
		else
			local nearPickup, pos = SchoolbagAPI.GetClosestPickup(iss, 400, 20, -1)
			if nearPickup then
				SchoolbagAPI.XalumMoveTowardsTarget(iss, nearPickup, 6, 0.9, false)
				if (nearPickup.Position-iss.Position):Length() < 5 and not nearPickup.Touched then
					local picked = SchoolbagAPI.PickupPickup(nearPickup)
					--print(data.Stat.Wallet.."   "..picked.Subtype)
					picked = picked:ToPickup()
					local earned = 0
					if picked.SubType == 1 or picked.SubType == 5 then
						earned = 1
					elseif picked.SubType == 2 then
						earned = 5
					elseif picked.SubType == 3 then
						earned = 10
					elseif picked.SubType == 4 then
						earned = 2
					end
					data.Stat.Wallet = data.Stat.Wallet + earned
				end
			else
				if data.Stat.Wallet > 4 and (not spr:IsPlaying("Drop") and not spr:IsPlaying("Drop2"))then
					data.Stat.Wallet = data.Stat.Wallet - 5
					local rng = math.random(1,15)
					if rng < 15 then
						spr:Play("Drop", true)
					else
						spr:Play("Drop2", true)
					end
				else
					if (not spr:IsPlaying("Drop") and not spr:IsPlaying("Drop2")) then
						if player.Position:Distance(iss.Position) > 100 then
							if math.floor(Isaac.GetFrameCount() % math.random(30,60)) == 0 then
								if not pos then pos = Isaac.GetRandomPosition() end
							elseif Isaac.GetFrameCount() % 1200 == 0 then
								spr:Play("Drop", true)
							end
							if pos then
								SchoolbagAPI.MoveRandomlyTypeI(iss, pos, 8, 0.9, 0, 0, 0)
							end
						else
							SchoolbagAPI.MoveAwayFromTarget(iss, player, 4, 0.9)
						end
					end
				end
			end
		end
		iss.Velocity = iss.Velocity * 0.8
	end
end, ENTITY_TINYFELLOW);

function yandereWaifu:AddTinyCharacters(player)
	if player:GetPlayerType() == Reb then
		local isThere = false
		for i, iss in pairs (Isaac.FindByType(ENTITY_TINYFELLOW, ENTITY_TINYISAAC, -1, false, false)) do
			isThere = true
		end
		if not isThere then
			local becca = Isaac.Spawn( ENTITY_TINYFELLOW, ENTITY_TINYISAAC, 0, player.Position, Vector(0,0), player );
			GetEntityData(becca).Parent = player
		end
	else
		local isThere = false
		for i, iss in pairs (Isaac.FindByType(ENTITY_TINYFELLOW, ENTITY_TINYBECCA, -1, false, false)) do
			isThere = true
		end
		if not isThere then
			local becca = Isaac.Spawn( ENTITY_TINYFELLOW, ENTITY_TINYBECCA, 0, player.Position, Vector(0,0), player );
			GetEntityData(becca).Parent = player
		end
	end
end

function yandereWaifu:RemoveTinyCharacters(player)
	if player:GetPlayerType() == Reb then
		local isThere = false
		for i, iss in pairs (Isaac.FindByType(ENTITY_TINYISAAC, 663123, -1, false, false)) do
			iss:Remove()
		end
	else
		local isThere = false
		for i, iss in pairs (Isaac.FindByType(ENTITY_TINYBECCA, 663122, -1, false, false)) do
			iss:Remove()
		end
	end
end

yandereWaifu:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, damage, amount, damageFlag, damageSource, damageCountdownFrames) --invincibilityframe when dashing or whatnot
	local player = damage:ToPlayer();
	local data = GetEntityData(player)
	if player:GetPlayerType() == Reb then
		if GetEntityData(damage).invincibleTime > 0 then
			-- non-red heart damage
			if (damageFlag & DamageFlag.DAMAGE_RED_HEARTS) == 0
			-- things that don't break through invincibility
			and (damageFlag & DamageFlag.DAMAGE_INVINCIBLE) == 0 then
				return false;
			end
		else
			queueDamageSound = true;
		end
	end
	
	if player:HasCollectible(COLLECTIBLE_CURSEDSPOON) and (damageFlag & DamageFlag.DAMAGE_CURSED_DOOR) == 0 then
		data.LastEntityCollisionClass = player.EntityCollisionClass;
		data.LastGridCollisionClass = player.GridCollisionClass;

		local maw = Isaac.Spawn(EntityType.ENTITY_EFFECT, ENTITY_CURSEDMAW, 0, player.Position, Vector(0,0), player)
		player:AnimatePitfallIn()
		data.IsUninteractible = true
	end
end, EntityType.ENTITY_PLAYER)

-- Reset the information when moving rooms so that we don't have false positive double taps across rooms
function yandereWaifu:NewRoom()
	for p = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
	--for i,player in ipairs(SAPI.players) do
		local data = GetEntityData(player)
		local room = game:GetRoom()
		print(room:GetType())
		if player:GetPlayerType() == Reb then
			data.DASH_DOUBLE_TAP:Reset();
			data.ATTACK_DOUBLE_TAP:Reset();
			--neded for soul heart and bone heart movement lol
			--if this was tampered to being with
			if data.IsUninteractible then data.IsUninteractible = false end --reset orbitals
			if data.IsDashActive then data.IsDashActive = false end --stop any active dashes
			if data.NoBoneSlamActive ~= true then data.NoBoneSlamActive = true end

			if data.LastGridCollisionClass then player.GridCollisionClass = data.LastGridCollisionClass end
			if data.LastEntityCollisionClass then player.EntityCollisionClass = data.LastEntityCollisionClass end

			data.isReadyForSpecialAttack = false
			
			--workaround for when you go bald in the knife dimension, because theres no way to check what dimension you are in for some reason.......
			--ApplyCostumes( GetEntityData(player).currentMode, player )
			--print("im no bald")
		end
		if player:HasCollectible(COLLECTIBLE_ETERNALBOND) then
			for i, iss in pairs (Isaac.FindByType(ENTITY_TINYISAAC, 663123, -1, false, false)) do
				iss.Position = player.Position
			end
			for i, iss in pairs (Isaac.FindByType(ENTITY_TINYBECCA, 663122, -1, false, false)) do
				iss.Position = player.Position
			end
		end
		if player:HasTrinket(TRINKET_ISAACSLOCKS) and room:IsFirstVisit() then
			local rng = math.random(1,2)
			local seed = room:GetSpawnSeed()
			--print(room:GetSpawnSeed())
			if (room:GetType() == RoomType.ROOM_SHOP or room:GetType() == RoomType.ROOM_BOSS or room:GetType() == RoomType.ROOM_TREASURE) or (seed/100000000 < 5 and (room:GetType() == RoomType.ROOM_DEVIL or room:GetType() == RoomType.ROOM_ANGEL)) then
			local slot = Isaac.Spawn(EntityType.ENTITY_SLOT, 10, 0, room:FindFreePickupSpawnPosition(room:GetCenterPos(), 1), Vector(0,0), player)
			end
		end
		
	end
end
yandereWaifu:AddCallback( ModCallbacks.MC_POST_NEW_ROOM, yandereWaifu.NewRoom)

local REBECCA_MODE_COMMAND_KEYS = {
	red = REBECCA_MODE.RedHearts,
	soul = REBECCA_MODE.SoulHearts,
	blue = REBECCA_MODE.SoulHearts,
	eternal = REBECCA_MODE.EternalHearts,
	white = REBECCA_MODE.EternalHearts,
	gold = REBECCA_MODE.GoldHearts,
	black = REBECCA_MODE.EvilHearts,
	evil = REBECCA_MODE.EvilHearts,
	bone = REBECCA_MODE.BoneHearts,
	rotten = REBECCA_MODE.RottenHearts,
	broken = REBECCA_MODE.BrokenHearts,
	
	bred = REBECCA_MODE.BrideRedHearts
}

function yandereWaifu:SaveAchievement()
	local saveData = RecapRebekahData()
	Isaac.SaveModData(yandereWaifu, JSON.encode( saveData ) );
end

function yandereWaifu:ExecuteCommand( command, params )
	if command == "rebeccamode" or command == "becmode" then
		if REBECCA_MODE_COMMAND_KEYS[params] ~= nil then
			ChangeMode(Isaac.GetPlayer(0), REBECCA_MODE_COMMAND_KEYS[params], true, true);
		end
    end
	if command == "beccaresetachievement" then
		if params == "all" then
			CurrentRebeccaUnlocks = BaseRebeccaUnlocks
			yandereWaifu:SaveAchievement()
			print("Resetted "..tostring(params))
		end
	end
end
yandereWaifu:AddCallback( ModCallbacks.MC_EXECUTE_CMD, yandereWaifu.ExecuteCommand )
