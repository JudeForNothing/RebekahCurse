
local game = Game(); --Calls the Game

--global table that will keep all these enums in
RebekahCurse = {
-- don't potentially overwrite information in global tables, keep this local
	--items
	COLLECTIBLE_LOVECANNON = Isaac.GetItemIdByName("Hugs N' Roses"),

	--unlockables
	COLLECTIBLE_LUNCHBOX = Isaac.GetItemIdByName("A Lunchbox"),
	COLLECTIBLE_ROMCOM = Isaac.GetItemIdByName("Typical Rom-Com"),
	COLLECTIBLE_MIRACULOUSWOMB = Isaac.GetItemIdByName("Miraculous Womb"),
	COLLECTIBLE_ETERNALBOND = Isaac.GetItemIdByName("Eternal Bond"),
	COLLECTIBLE_POWERLOVE = Isaac.GetItemIdByName("Love = Power"),
	COLLECTIBLE_CURSEDSPOON = Isaac.GetItemIdByName("Cursed Spoon"),
	COLLECTIBLE_DICEOFFATE = Isaac.GetItemIdByName("Dice of Fate"),
	TRINKET_ISAACSLOCKS = Isaac.GetTrinketIdByName("Isaac's Locks"),
	COLLECTIBLE_LOVESICK = Isaac.GetItemIdByName("Lovesick"),
	COLLECTIBLE_SNAP = Isaac.GetItemIdByName("Snap!"),

	COLLECTIBLE_UNREQUITEDLOVE = Isaac.GetItemIdByName("Unrequited Love"),

	ENTITY_ORBITALESAU = Isaac.GetEntityVariantByName("Orbital Esau"),
	ENTITY_ORBITALJACOB = Isaac.GetEntityVariantByName("Orbital Jacob"),
	ENTITY_TINYFELLOW = Isaac.GetEntityTypeByName("Tiny Becca"),
	ENTITY_TINYBECCA = Isaac.GetEntityVariantByName("Tiny Becca"),
	ENTITY_TINYISAAC = Isaac.GetEntityVariantByName("Tiny Isaac"),
	ENTITY_PHEROMONES_RING = Isaac.GetEntityVariantByName("Pheromone Ring"),
	ENTITY_SNAP_HEARTBEAT = Isaac.GetEntityVariantByName("Snap Heartbeat"),
	ENTITY_SNAP_EFFECT = Isaac.GetEntityVariantByName("Snap Effect"),
	ENTITY_LOVEHOOK = Isaac.GetEntityVariantByName("Love Hook"),
	ENTITY_CURSEDMAW = Isaac.GetEntityVariantByName("Cursed Maw"),
	
	--others
	ENTITY_ARCANE_CIRCLE = Isaac.GetEntityVariantByName("Arcane Circle"),
	ENTITY_SPECIALBEAM = Isaac.GetEntityVariantByName("Special Beam"),
	ENTITY_BROKEN_GLASSES = Isaac.GetEntityVariantByName("Broken Glasses"),
	
	--red heart mode
	ENTITY_ORBITALTARGET = Isaac.GetEntityVariantByName("Orbital Target"),
	ENTITY_ORBITALNUKE = Isaac.GetEntityVariantByName("Nuclear Rocket"),
	ENTITY_REDKNIFE = Isaac.GetEntityVariantByName("Red Knife"),
	ENTITY_SLASH = Isaac.GetEntityVariantByName("Slash Effect"),
	--soul heart mode
	ENTITY_SOULTARGET = Isaac.GetEntityVariantByName("Soul Target"),
	ENTITY_HAUNTEDKNIFE = Isaac.GetEntityVariantByName("Haunted Knife"),
	ENTITY_ECTOPLASMA = Isaac.GetEntityVariantByName("Ectoplasma Tear"),
	ENTITY_WIZOOB_MISSILE = Isaac.GetEntityVariantByName("Wizoob Missile"),
	ENTITY_SBOMBBUNDLE = Isaac.GetEntityVariantByName("S. Bomb Bundle"),
	ENTITY_GHOSTTARGET = Isaac.GetEntityVariantByName("Soul Nuke Target"),
	ENTITY_SOULNUKECRACK = Isaac.GetEntityVariantByName("Soul Nuke Crack"),
	ENTITY_GHOSTMISSILE = Isaac.GetEntityVariantByName("Ghost Missile"),
	ENTITY_SWORDDROP = Isaac.GetEntityVariantByName("Sword Drop"),
	--gold heart mode
	--ENTITY_NED = Isaac.GetEntityTypeByName("Ned"),
	ENTITY_NED_NORMAL = Isaac.GetEntityVariantByName("Ned"),
	ENTITY_PSEUDO_KNIFE = Isaac.GetEntityVariantByName("Psuedo Knife"),
	ENTITY_PSEUDO_ROCKET = Isaac.GetEntityVariantByName("Psuedo Rocket"),
	ENTITY_SQUIRENED = Isaac.GetEntityVariantByName("Ned the Squire"),
	ENTITY_WIND_SLASH = Isaac.GetEntityVariantByName("Wind Slash"),
	ENTITY_CHRISTIANNED = Isaac.GetEntityVariantByName("Christian Ned"),
	ENTITY_CHRISTIANNEDEXTRA = Isaac.GetEntityVariantByName("Christian Ned Extra"),
	ENTITY_SCREAMINGNED = Isaac.GetEntityVariantByName("Screaming Ned"),
	ENTITY_BARBARICNED = Isaac.GetEntityVariantByName("Barbaric Ned"),
	ENTITY_DEFENDINGNED = Isaac.GetEntityVariantByName("Defending Ned"),
	ENTITY_SPEAR_NED = Isaac.GetEntityVariantByName("Spear Ned"),
	ENTITY_STORMTROOPER_NED = Isaac.GetEntityVariantByName("Stormtrooper Ned"),
	--evil heart mode
	ENTITY_ARCANE_EXPLOSION = Isaac.GetEntityVariantByName("Arcane Explosion"),
	ENTITY_LABAN_STOMP = Isaac.GetEntityVariantByName("Laban Stomp"),
	ENTITY_DARKBEAMINTHESKY = Isaac.GetEntityVariantByName("Dark Beam In The Sky"),
	ENTITY_EVILORB = Isaac.GetEntityVariantByName("Evil Orb"),
	ENTITY_HOLEFABRIC = Isaac.GetEntityVariantByName("Hole Fabric"),
	ENTITY_DARKBOOM = Isaac.GetEntityVariantByName("Dark Boom"),
	ENTITY_DARKBOOM2 = Isaac.GetEntityVariantByName("Dark Boom 2"),
	ENTITY_DARKMAW = Isaac.GetEntityVariantByName("Dark Maw"),
	ENTITY_DARKKNIFE = Isaac.GetEntityVariantByName("Dark Knife Tear"),
	ENTITY_DARKKNIFEFADE = Isaac.GetEntityVariantByName("Dark Knife Tear Fade"),
	ENTITY_DARKPLASMA = Isaac.GetEntityVariantByName("Dark Plasma"),
	ENTITY_DARKSUPERNOVA = Isaac.GetEntityVariantByName("Dark Supernova"),
	--eternal heart mode
	ENTITY_ETERNALFEATHER = Isaac.GetEntityVariantByName("Eternal Feather"),
	ENTITY_LIGHTBOOM = Isaac.GetEntityVariantByName("Light Boom"),
	ENTITY_FEATHERBREAK = Isaac.GetEntityVariantByName("Feather Break"),
	ENTITY_MORNINGSTAR = Isaac.GetEntityVariantByName("Morning Star"),
	ENTITY_TINY_OPHANIM = Isaac.GetEntityVariantByName("Tiny Ophanim"),
	ENTITY_BIG_OPHANIM = Isaac.GetEntityVariantByName("Big Ophanim"),
	ENTITY_ETERNALSLASH = Isaac.GetEntityVariantByName("Eternal Slash"),
	ENTITY_ETERNALEPICFIRE = Isaac.GetEntityVariantByName("Eternal Epic Fire"),
	ENTITY_EPICFIRETARGET = Isaac.GetEntityVariantByName("Epic Fire Target"),
	ENTITY_HOLYBOMBTEAR = Isaac.GetEntityVariantByName("Holy Bomb Tear"),
	--bone heart mode
	ENTITY_BONESTAND = Isaac.GetEntityVariantByName("Bone Stand"),
	ENTITY_BONEJOCKEY = Isaac.GetEntityVariantByName("Bone Jockey"),
	ENTITY_EXTRACHARANIMHELPER = Isaac.GetEntityVariantByName("Extra Character Anim Helper"),
	ENTITY_BONEVAULT = Isaac.GetEntityVariantByName("Bone Vault"),
	ENTITY_SLAMDUST = Isaac.GetEntityVariantByName("Slamdust Effect"),
	ENTITY_BONETARGET = Isaac.GetEntityVariantByName("Bone Target"),
	ENTITY_RIBTEAR = Isaac.GetEntityVariantByName("Rib Tear"),
	ENTITY_SKULLTEAR = Isaac.GetEntityVariantByName("Skull Tear"),
	ENTITY_HEARTTEAR = Isaac.GetEntityVariantByName("Heart Tear"),
	ENTITY_RAPIDPUNCHTEAR = Isaac.GetEntityVariantByName("Rapid Punch Tear"),
	ENTITY_BONEPUNCH = Isaac.GetEntityVariantByName("Dash Punch"),
	ENTITY_BONESPEAR = Isaac.GetEntityVariantByName("Bone Spear"),
	ENTITY_LUDOBONE = Isaac.GetEntityVariantByName("Ludo Bone"),
	ENTITY_EPICBONE = Isaac.GetEntityVariantByName("Epic Bone Jockey"),
	--rotten heart mode
	ENTITY_ROTTENHEAD = Isaac.GetEntityVariantByName("Rotten Crazyhead"),
	ENTITY_ROTTENSMALLMAGGOT = Isaac.GetEntityVariantByName("Rotten Small Maggot"),
	ENTITY_MAGGOTTEAR = Isaac.GetEntityVariantByName("Maggot Tear"),
	ENTITY_FLYTEAR = Isaac.GetEntityVariantByName("Fly Tear"),
	ENTITY_ROTTENFLY = Isaac.GetEntityVariantByName("Rotten Fly"),
	ENTITY_ROTTENFLYBALL = Isaac.GetEntityVariantByName("Rotten Fly Ball"),
	--bride red heart mode
	ENTITY_LABAN = Isaac.GetEntityVariantByName("Best Man"),
	--misc
	ENTITY_HEARTPOOF = Isaac.GetEntityVariantByName("Heart Poof"),
	ENTITY_HEARTPARTICLE = Isaac.GetEntityVariantByName("Heart Particle"),
	ENTITY_REBMIRROR = Isaac.GetEntityVariantByName("Rebecca's Mirror"),
	ENTITY_PERSONALITYPOOF = Isaac.GetEntityVariantByName("Personality Poof Effect"),
	
	REB = Isaac.GetPlayerTypeByName("Rebekah"), --Sets an ID for this -- no, this is a Christian channel now
	SADREBEKAH = Isaac.GetPlayerTypeByName("RebekahB", true)
}

RebekahCurseSounds = {
	SOUND_REBHURT = Isaac.GetSoundIdByName("RebekahHurt"),
	SOUND_REBDIE = Isaac.GetSoundIdByName("RebekahDie"),

	SOUND_CHRISTIAN_CHANT = Isaac.GetSoundIdByName("Christian Chant"),
	SOUND_CHRISTIAN_OVERTAKE = Isaac.GetSoundIdByName("Christian Overtake"),
	SOUND_CHRISTIAN_READ = Isaac.GetSoundIdByName("Christian Read"),
	SOUND_BARBARIAN_LAUGH = Isaac.GetSoundIdByName("Barbarian Laugh"),
	SOUND_BARBARIAN_GRUNT = Isaac.GetSoundIdByName("Barbarian Grunt"),
	SOUND_SCREAMING_SCREAM = Isaac.GetSoundIdByName("Screaming Scream"),
	SOUND_STRIKE = Isaac.GetSoundIdByName("Metal Strike"),
	SOUND_RATTLEARMOR = Isaac.GetSoundIdByName("Armor Rattle"),

	SOUND_LASEREXPLOSION = Isaac.GetSoundIdByName("Laser Explosion"),
	SOUND_DEEPELECTRIC = Isaac.GetSoundIdByName("Deep Electricity"),
	SOUND_ELECTRIC = Isaac.GetSoundIdByName("Electricity"),
	SOUND_PUNCH = Isaac.GetSoundIdByName("Punch Effect")
}

local wasFromTaintedLocked = false

local IsaacPresent = false
local JacobPresent = false

RebekahCurseCostumes = {
	InnocentHair = Isaac.GetCostumeIdByPath("gfx/characters/innocenthair.anm2"),
	NerdyGlasses = Isaac.GetCostumeIdByPath("gfx/characters/nerdyglasses.anm2"),
	WizoobHair = Isaac.GetCostumeIdByPath("gfx/characters/wizoobhair.anm2"),
	SwagHair = Isaac.GetCostumeIdByPath("gfx/characters/swaghair.anm2"),
	HadFunHair = Isaac.GetCostumeIdByPath("gfx/characters/hadfunhair.anm2"),
	AoDHair = Isaac.GetCostumeIdByPath("gfx/characters/angelofdeathhair.anm2"),
	RebeccasFate = Isaac.GetCostumeIdByPath("gfx/characters/rebeccasfate.anm2"),
	DeadHair = Isaac.GetCostumeIdByPath("gfx/characters/deadhair.anm2"),
	GlitchEffect = Isaac.GetCostumeIdByPath("gfx/characters/glitch_costume.anm2"),
	boneStackForAnim = 0, --asks how much number is there for the anim

	HeadlessHead = Isaac.GetCostumeIdByPath("gfx/characters/costumes/rebekah_hair/rottenmode_headremove.anm2"),
	SkinlessHead = Isaac.GetCostumeIdByPath("gfx/characters/costumes/rebekah_hair/rottenmode_skinremove.anm2"),

	BridalHair = Isaac.GetCostumeIdByPath("gfx/characters/bridalhair.anm2"),
	--BridalStockings = Isaac.GetCostumeIdByPath("gfx/characters/weddedstockings.anm2"),
	FulfilledFace = Isaac.GetCostumeIdByPath("gfx/characters/fulfilled.anm2"),
	IsaacOverdose = Isaac.GetCostumeIdByPath("gfx/characters/isaac_overdose.anm2"),
	JacobEsauGlad = Isaac.GetCostumeIdByPath("gfx/characters/maternallove_aura.anm2"),

	LovePower = Isaac.GetCostumeIdByPath("gfx/characters/love_power.anm2"),
	LunchboxCos = Isaac.GetCostumeIdByPath("gfx/characters/lunchbox.anm2"),
	CursedMawCos = Isaac.GetCostumeIdByPath("gfx/characters/cursedmaw.anm2"),
	LoveSickCos = Isaac.GetCostumeIdByPath("gfx/characters/lovesick.anm2"),
	UnsnappedCos = Isaac.GetCostumeIdByPath("gfx/characters/unsnapped.anm2"),
	SnappedCos = Isaac.GetCostumeIdByPath("gfx/characters/snap.anm2")
}


REBEKAH_BALANCE = {
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
	EVIL_HEARTS_DASH_COOLDOWN = 60, --60
	EMPTY_EVIL_HEARTS_DASH_COOLDOWN = 30,
	EVIL_HEARTS_DASH_SPEED = 5,
	EVIL_HEARTS_DASH_INVINCIBILITY_FRAMES = 0,
	BONE_HEARTS_DASH_COOLDOWN = 8, --80
	BONE_HEARTS_DASH_INVINCIBILITY_FRAMES = 15,
	BONE_HEARTS_MODIFIED_DASH_COOLDOWN = 30, --150
	BONE_HEARTS_MODIFIED_DASH_INVINCIBILITY_FRAMES = 160,
	BONE_HEARTS_VAULT_VELOCITY = 6,
	BONE_HEARTS_DASH_VELOCITY = 2,
	BONE_HEARTS_DASH_TARGET_SPEED = 3,
	BONE_HEARTS_BONE_JOCKEY_DASH_SPEED = 32,
	BONE_HEARTS_BONE_JOCKEY_CONTINUOUS_DASH_SPEED = 20,
	BONE_HEARTS_BONE_JOCKEY_DASH_COOLDOWN_FRAME = 10,
	ROTTEN_HEARTS_DASH_COOLDOWN = 80,
	ROTTEN_HEARTS_DASH_SPEED = 20,
	ROTTEN_HEARTS_FLYBALL_SPEED = 1.5, 
	BROKEN_HEARTS_DASH_COOLDOWN = 55,
	BRIDE_RED_HEARTS_DASH_SPEED = 25
}

REBEKAH_OPTIONS = {
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

REBECCA_MODE = {
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

RebeccaModeCostumes = {
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

RebeccaModeEffects = {
	[REBECCA_MODE.RedHearts] = CollectibleType.COLLECTIBLE_20_20,
	--[REBECCA_MODE.SoulHearts] = N/A,
	[REBECCA_MODE.GoldHearts] = CollectibleType.COLLECTIBLE_HEAD_OF_THE_KEEPER,
	[REBECCA_MODE.EvilHearts] = CollectibleType.COLLECTIBLE_SERPENTS_KISS,
	[REBECCA_MODE.EternalHearts] = CollectibleType.COLLECTIBLE_FATE,
	[REBECCA_MODE.BoneHearts] = CollectibleType.COLLECTIBLE_COMPOUND_FRACTURE,
	
	[REBECCA_MODE.BrideRedHearts] = CollectibleType.COLLECTIBLE_20_20
}

RebekahHeartParticleType = {
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

RebekahHeartParticleSpriteByType = {
	[RebekahHeartParticleType.Red] = "gfx/effects/heart_red.png",
	[RebekahHeartParticleType.Blue] = "gfx/effects/heart_blue.png",
	[RebekahHeartParticleType.Soul] = "gfx/effects/heart_blue.png",
	[RebekahHeartParticleType.Gold] = "gfx/effects/heart_gold.png",
	[RebekahHeartParticleType.Black] = "gfx/effects/heart_black.png",
	[RebekahHeartParticleType.Evil] = "gfx/effects/heart_black.png",
	[RebekahHeartParticleType.White] = "gfx/effects/heart_eternal.png",
	[RebekahHeartParticleType.Eternal] = "gfx/effects/heart_eternal.png",
	[RebekahHeartParticleType.Bone] = "gfx/effects/heart_bone.png"
}

RebekahHeartParticleTypeByMode = {
	[REBECCA_MODE.RedHearts] = RebekahHeartParticleType.Red,
	[REBECCA_MODE.SoulHearts] = RebekahHeartParticleType.Blue,
	[REBECCA_MODE.GoldHearts] = RebekahHeartParticleType.Gold,
	[REBECCA_MODE.EvilHearts] = RebekahHeartParticleType.Evil,
	[REBECCA_MODE.EternalHearts] = RebekahHeartParticleType.Eternal,
	[REBECCA_MODE.BoneHearts] = RebekahHeartParticleType.Bone
}

RebekahPoofParticleType = {
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

RebekahPoofParticleSpriteByType = {
	[RebekahPoofParticleType.Red] = "gfx/effects/poof_red.png",
	[RebekahPoofParticleType.Blue] = "gfx/effects/poof_blue.png",
	[RebekahPoofParticleType.Soul] = "gfx/effects/poof_blue.png",
	[RebekahPoofParticleType.Gold] = "gfx/effects/poof_gold.png",
	[RebekahPoofParticleType.Black] = "gfx/effects/poof_black.png",
	[RebekahPoofParticleType.Evil] = "gfx/effects/poof_black.png",
	[RebekahPoofParticleType.Eternal] = "gfx/effects/poof_eternal.png",
	[RebekahPoofParticleType.White] = "gfx/effects/poof_eternal.png",
	[RebekahPoofParticleType.Bone] = "gfx/effects/poof_bone.png"
}

RebekahPoofParticleTypeByMode = {
	[REBECCA_MODE.RedHearts] = RebekahPoofParticleType.Red,
	[REBECCA_MODE.SoulHearts] = RebekahPoofParticleType.Blue,
	[REBECCA_MODE.GoldHearts] = RebekahPoofParticleType.Gold,
	[REBECCA_MODE.EvilHearts] = RebekahPoofParticleType.Evil,
	[REBECCA_MODE.EternalHearts] = RebekahPoofParticleType.Eternal,
	[REBECCA_MODE.BoneHearts] = RebekahPoofParticleType.Bone
}

RebekahMirrorHeartDrop = {
	[1] = 1, --red
	[2] = 3, --soul
	[3] = 4, --eternal
	[4] = 6, --evil
	[5] = 7, --gold
	[6] = 11 --bone
}

local REBECCA_INFO = SchoolbagAPI.Players:New({}, RebekahCurse.REB, --[[RebekahCurse.SOUND_REBHURT, RebekahCurse.SOUND_REBDIE,]] nil, nil, {SchoolbagAPI.DefaultInstructions, "gfx/backdrop/controls_rebecca_extra.png"}, {"gfx/characters/big_rebekah.anm2", "gfx/characters/big_rebekah.png"});