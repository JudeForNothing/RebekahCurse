
local game = Game(); --Calls the Game

--global table that will keep all these enums in
RebekahCurse = {
-- don't potentially overwrite information in global tables, keep this local
	
	ENTITY_ORBITALESAU = Isaac.GetEntityVariantByName("Orbital Esau"),
	ENTITY_ORBITALJACOB = Isaac.GetEntityVariantByName("Orbital Jacob"),
	--ENTITY_TINYFELLOW = Isaac.GetEntityTypeByName("Tiny Becca"),
	ENTITY_TINYBECCA = Isaac.GetEntityVariantByName("Tiny Becca"),
	ENTITY_TINYISAAC = Isaac.GetEntityVariantByName("Tiny Isaac"),
	ENTITY_PHEROMONES_RING = Isaac.GetEntityVariantByName("Pheromone Ring"),
	ENTITY_SNAP_HEARTBEAT = Isaac.GetEntityVariantByName("Snap Heartbeat"),
	ENTITY_SNAP_EFFECT = Isaac.GetEntityVariantByName("Snap Effect"),
	ENTITY_LOVEHOOK = Isaac.GetEntityVariantByName("Love Hook"),
	ENTITY_CURSEDMAW = Isaac.GetEntityVariantByName("Cursed Maw"),
	
	ENTITY_HAIRWHIP = Isaac.GetEntityVariantByName("Hairwhip Effect"),
	ENTITY_DOORSTOPPER = Isaac.GetEntityVariantByName("Doorstopper"),
	ENTITY_FINGER_CLICKER = Isaac.GetEntityVariantByName("Finger Clicker"),
	ENTITY_LOVESICK_SLASH = Isaac.GetEntityVariantByName("Lovesick Slash"), -- am i even using this?
	ENTITY_PLUCKED_PETAL = Isaac.GetEntityVariantByName("Plucked Petal"),
	
	ENTITY_OHIMPOLTY = Isaac.GetEntityVariantByName("Oh, I'm Polty"),
	ENTITY_GRAVEBABY = Isaac.GetEntityVariantByName("Grave Baby"),
	ENTITY_BUNBUN_FAMILIAR = Isaac.GetEntityVariantByName("Bun Bun (Familiar)"),
	ENTITY_RABBET_FAMILIAR = Isaac.GetEntityVariantByName("Rabbet (Familiar)"),

	ENTITY_CARDIAC = Isaac.GetEntityVariantByName("Cardiac Armor"),
	ENTITY_FENRIR = Isaac.GetEntityVariantByName("Fenrir"),
	ENTITY_JACOBSTEARS = Isaac.GetEntityVariantByName("Jacob's Tears"),
	
	ENTITY_SINGINGTEAR = Isaac.GetEntityVariantByName("Singing Tear"),
	ENTITY_METALTEAR = Isaac.GetEntityVariantByName("Metal Tear"),
	
	--others
	ENTITY_ARCANE_CIRCLE = Isaac.GetEntityVariantByName("Arcane Circle"),
	ENTITY_SPECIALBEAM = Isaac.GetEntityVariantByName("Special Beam"),
	ENTITY_BROKEN_GLASSES = Isaac.GetEntityVariantByName("Broken Glasses"),
	ENTITY_REBEKAH_ENTITY_REPLACE = Isaac.GetEntityVariantByName("Rebekah Entity Replace"),
	ENTITY_REBEKAHS_CARPET_REPLACE = Isaac.GetEntityVariantByName("Rebekah&apos;s Carpet (Rebekah Entity Replace)"),
	ENTITY_LABAN_DUDE = Isaac.GetEntityVariantByName("Laban"),
	ENTITY_LABAN_DUDE_REPLACE = Isaac.GetEntityVariantByName("Laban (Entity Replace)"),
	
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
	ENTITY_EVILTARGET = Isaac.GetEntityVariantByName("Evil Target"),
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
	ENTITY_DARKSPIRITSWORD = Isaac.GetEntityVariantByName("Dark Spirit Sword"),
	--eternal heart mode
	ENTITY_ETERNALFEATHER = Isaac.GetEntityVariantByName("Eternal Feather"),
	ENTITY_LIGHTBOOM = Isaac.GetEntityVariantByName("Light Boom"),
	ENTITY_FEATHERBREAK = Isaac.GetEntityVariantByName("Feather Break"),
	ENTITY_MORNINGSTAR = Isaac.GetEntityVariantByName("Morning Star"),
	ENTITY_TINY_OPHANIM = Isaac.GetEntityVariantByName("Tiny Ophanim"),
	ENTITY_TINY_OPHANIM2 = Isaac.GetEntityVariantByName("Tiny Ophanim with an Eye"),
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
	ENTITY_ROTTENBIRTHRIGHTTARGET = Isaac.GetEntityVariantByName("Rotten Birthright Target"),
	--broken heart mode
	ENTITY_BROKENCONSOLE = Isaac.GetEntityVariantByName("Broken Console"),
	--bride red heart mode
	ENTITY_LABAN = Isaac.GetEntityVariantByName("Best Man"),
	--immortal heart mode
	ENTITY_IMMORTAL_PRISM = Isaac.GetEntityVariantByName("Immortal Prism"),
	--misc
	ENTITY_HEARTPOOF = Isaac.GetEntityVariantByName("Heart Poof"),
	ENTITY_HEARTPARTICLE = Isaac.GetEntityVariantByName("Heart Particle"),
	ENTITY_REBMIRROR = Isaac.GetEntityVariantByName("Rebecca's Mirror"),
	ENTITY_LOVELOVEPARTICLE = Isaac.GetEntityVariantByName("Love Love Particle"),
	ENTITY_HEARTGULP = Isaac.GetEntityVariantByName("Heart Gulp"),
	ENTITY_REBEKAHENTITYWEAPON = Isaac.GetEntityVariantByName("Hugs N Roses (Weapon)"),
	ENTITY_DEBORAHENTITYWEAPON = Isaac.GetEntityVariantByName("Deborah's Revolver (Weapon)"),
	ENTITY_PERSONALITYPOOF = Isaac.GetEntityVariantByName("Personality Poof Effect"),
	ENTITY_REBEKAH_DUST = Isaac.GetEntityVariantByName("Rebekah Dust Effect"),
	
	ENTITY_BACKGROUNDTINT = Isaac.GetEntityVariantByName("Background Tint"),
	ENTITY_UNGENERICTRACER = Isaac.GetEntityVariantByName("Ungeneric Tracer"),
	ENTITY_PINGEFFECT = Isaac.GetEntityVariantByName("Ping Effect"),
	
	ENTITY_EVESUMMONCIRCLE = Isaac.GetEntityVariantByName("Eve Summon Circle"),
	ENTITY_GOLEMFIST = Isaac.GetEntityVariantByName("Patriarch's Fist"),
	ENTITY_WICKEDLIMB = Isaac.GetEntityVariantByName("Wicked Limb"),
	ENTITY_BEAUTIFULGRAVEDROP = Isaac.GetEntityVariantByName("Beautiful Grave Drop"),
	ENTITY_EGGSHELLS = Isaac.GetEntityVariantByName("Eggshells"),
	ENTITY_DEATHNOTETARGET = Isaac.GetEntityVariantByName("Death Note Target"),
	ENTITY_SOLOMONNEDBABY = Isaac.GetEntityVariantByName("Solomon Ned Baby"),
	
	ENTITY_BODYDYSMORPHIAAURA = Isaac.GetEntityVariantByName("Body Dysmorphia Aura"),

	ENTITY_WRATHCRYSTALFRAGMENT = Isaac.GetEntityVariantByName("Wrath Crystal Fragment"),

	ENTITY_REBEKAHCURSEDWEAPON = Isaac.GetEntityVariantByName("Rebekah Cursed Weapon"),
	ENTITY_TAINTEDCURSEDASHTARGET = Isaac.GetEntityVariantByName("Tainted Curse Dash Target"),
	ENTITY_TAINTEDCURSEENEMYTARGET = Isaac.GetEntityVariantByName("Tainted Curse Enemy Target"),
	ENTITY_SWORDOFHOPEEFFECT = Isaac.GetEntityVariantByName("Sword of Hope Effect"),

	ENTITY_CURSEDTECHZERODOT = Isaac.GetEntityVariantByName("Cursed Tech Zero Dot"),
	ENTITY_CURSEDGODHEADAURA = Isaac.GetEntityVariantByName("Cursed Godhead Aura"),

	ENTITY_AFFIRMATIONHEART = Isaac.GetEntityVariantByName("Affirmation Heart"),
	ENTITY_COINPIECE = Isaac.GetEntityVariantByName("Coin Piece"),
	ENTITY_TRIPLEBOMBS = Isaac.GetEntityVariantByName("Triple Bombs"),

	ENTITY_TAPIOCATEAR = Isaac.GetEntityVariantByName("Tapioca Tear"),
	ENTITY_PLATFORMCAKE = Isaac.GetEntityVariantByName("Platform Cake"),
	ENTITY_DEBORAHDEADEYETARGET = Isaac.GetEntityVariantByName("Deborah Dead Eye Target"),

	ENTITY_HOUSE_BACKDROP = Isaac.GetEntityVariantByName("Phantasm House"),
	ENTITY_HOUSE_BACKDROP_REPLACE = Isaac.GetEntityVariantByName("Phantasm House (replace)"),

	TECHNICAL_REB = Isaac.GetPlayerTypeByName("Technical Rebekah"),
	REB = Isaac.GetPlayerTypeByName("Rebekah"),
	REB_RED = Isaac.GetPlayerTypeByName("Red Rebekah"), --Sets an ID for this -- no, this is a Christian channel now
	REB_SOUL = Isaac.GetPlayerTypeByName("Soul Rebekah"),
	REB_EVIL = Isaac.GetPlayerTypeByName("Evil Rebekah"),
	REB_ETERNAL = Isaac.GetPlayerTypeByName("Eternal Rebekah"),
	REB_GOLD = Isaac.GetPlayerTypeByName("Gold Rebekah"),
	REB_BONE = Isaac.GetPlayerTypeByName("Bone Rebekah"),
	REB_ROTTEN = Isaac.GetPlayerTypeByName("Rotten Rebekah"),
	REB_BROKEN = Isaac.GetPlayerTypeByName("Broken Rebekah"),
	REB_IMMORTAL = Isaac.GetPlayerTypeByName("Immortal Rebekah"),
	
	SADREBEKAH = Isaac.GetPlayerTypeByName("Technical B Rebekah", true),
	REB_CURSED = Isaac.GetPlayerTypeByName("Cursed Rebekah", true),
	WISHFUL_ISAAC = Isaac.GetPlayerTypeByName("Wishful Isaac", false),
	HAPPYJACOB = Isaac.GetPlayerTypeByName("Happy Jacob", false),
	DEBORAH = Isaac.GetPlayerTypeByName("Deborah", false),
}

RebekahCurse.Trinkets = {
	TRINKET_RABBITSFOOT = Isaac.GetTrinketIdByName("Rabbit's Foot"),
	TRINKET_DESTROYEDLULLABY = Isaac.GetTrinketIdByName("Destroyed Lullaby"),
	TRINKET_ORIGINALSIN = Isaac.GetTrinketIdByName("Original Sin"),
	TRINKET_REBEKAHSKEY = Isaac.GetTrinketIdByName("Rebekah's Key"),
	TRINKET_ISAACSLOCKS = Isaac.GetTrinketIdByName("Isaac's Locks"),
	TRINKET_MOMSBLESSING = Isaac.GetTrinketIdByName("Mom's Blessing"),
	TRINKET_JOHNANDROMANS = Isaac.GetTrinketIdByName("John and Romans"),
	TRINKET_CANNEDLAUGHTER = Isaac.GetTrinketIdByName("Canned Laughter"),
	TRINKET_NOSCOPE = Isaac.GetTrinketIdByName("No Scope!"),
	TRINKET_DEBORAHSDEADEYE = Isaac.GetTrinketIdByName("Deborah's Dead Eye"),
}

RebekahCurse.Items = {
	--items
	COLLECTIBLE_LOVECANNON = Isaac.GetItemIdByName("Hugs N' Roses"),
	COLLECTIBLE_WIZOOBTONGUE = Isaac.GetItemIdByName("Wizoob Tongue"),
	COLLECTIBLE_APOSTATE = Isaac.GetItemIdByName("Apostate"),
	COLLECTIBLE_PSALM45 = Isaac.GetItemIdByName("Psalm .45"),
	COLLECTIBLE_BARACHIELSPETAL = Isaac.GetItemIdByName("Barachiel's Petal"),
	COLLECTIBLE_FANG = Isaac.GetItemIdByName("Fang"),
	COLLECTIBLE_BEELZEBUBSBREATH = Isaac.GetItemIdByName("Beelzebub's Breath"),
	COLLECTIBLE_MAINLUA = Isaac.GetItemIdByName("main.lua"),
	
	COLLECTIBLE_COMFORTERSWING = Isaac.GetItemIdByName("Comforter's Wing"),
	
	COLLECTIBLE_CANDYWEDDINGRING = Isaac.GetItemIdByName("Candy Wedding Ring!"),
	COLLECTIBLE_LOVEDELUXE = Isaac.GetItemIdByName("Love Deluxe"),
	COLLECTIBLE_GREATPHEONIX = Isaac.GetItemIdByName("Great Pheonix"),
	COLLECTIBLE_LOVEMELOVEMENOT = Isaac.GetItemIdByName("Love me, love me not"),
	COLLECTIBLE_LOVEMELOVEMENOT2 = Isaac.GetItemIdByName(" Love me, love me not "),
	COLLECTIBLE_LOVEMELOVEMENOT3 = Isaac.GetItemIdByName("  Love me, love me not  "),
	COLLECTIBLE_DOORSTOPPER = Isaac.GetItemIdByName("Doorstopper"),
	COLLECTIBLE_FINGERFINGER = Isaac.GetItemIdByName("Finger Finger"),
	COLLECTIBLE_MORIAHDIARY = Isaac.GetItemIdByName("Moriah Diary"),
	COLLECTIBLE_THESHINING = Isaac.GetItemIdByName("The Shining"),
	COLLECTIBLE_OHIMDIE = Isaac.GetItemIdByName("Defuse = Rewards"),
	
	COLLECTIBLE_WIKEPIDIA = Isaac.GetItemIdByName("Wikepidia"),
	COLLECTIBLE_WIKEPIDIA1 = Isaac.GetItemIdByName(" Wikepidia "),
	COLLECTIBLE_WIKEPIDIA2 = Isaac.GetItemIdByName("  Wikepidia  "),
	COLLECTIBLE_WIKEPIDIA3 = Isaac.GetItemIdByName("   Wikepidia   "),
	COLLECTIBLE_WIKEPIDIA4 = Isaac.GetItemIdByName("    Wikepidia    "),
	COLLECTIBLE_WIKEPIDIA5 = Isaac.GetItemIdByName("     Wikepidia     "),
	COLLECTIBLE_WIKEPIDIA6 = Isaac.GetItemIdByName("      Wikepidia      "),
	COLLECTIBLE_WIKEPIDIA7 = Isaac.GetItemIdByName("Wikepidia "),
	COLLECTIBLE_WIKEPIDIA8 = Isaac.GetItemIdByName("Wikepidia  "),
	COLLECTIBLE_WIKEPIDIA9 = Isaac.GetItemIdByName("Wikepidia   "),
	COLLECTIBLE_WIKEPIDIA10 = Isaac.GetItemIdByName("Wikepidia    "),
	COLLECTIBLE_WIKEPIDIA11 = Isaac.GetItemIdByName("Wikepidia     "),
	COLLECTIBLE_WIKEPIDIA12 = Isaac.GetItemIdByName(" Wikepidia"),
	COLLECTIBLE_WIKEPIDIA13 = Isaac.GetItemIdByName("  Wikepidia"),
	COLLECTIBLE_WIKEPIDIA14 = Isaac.GetItemIdByName("   Wikepidia"),
	COLLECTIBLE_WIKEPIDIAPASSIVE = Isaac.GetItemIdByName("Wikepidia (passive)"),
	COLLECTIBLE_BAGOFBRISTLEBRICKS = Isaac.GetItemIdByName("Bag of Bristle Bricks"),
	COLLECTIBLE_NUTWATER = Isaac.GetItemIdByName("Nut Water"),
	COLLECTIBLE_TWINVISION = Isaac.GetItemIdByName("Twin Vision"),
	
	COLLECTIBLE_ABEAUTIFULGRAVE = Isaac.GetItemIdByName("A Beautiful Grave"),
	COLLECTIBLE_TIGHTHAIRTIE = Isaac.GetItemIdByName("Tight Hairtie"),
	COLLECTIBLE_BASKETOFEGGS = Isaac.GetItemIdByName("Basket of Eggs"),
	COLLECTIBLE_EGGSHELLWALK = Isaac.GetItemIdByName("Eggshell Walk"),
	COLLECTIBLE_OVERSIZEDSWEATER = Isaac.GetItemIdByName("Oversized Sweater"),
	COLLECTIBLE_HEARTSANDCRAFTS = Isaac.GetItemIdByName("Hearts and Crafts"),
	COLLECTIBLE_TECHHZ = Isaac.GetItemIdByName("Tech Hz"),
	COLLECTIBLE_ANGELSMORNINGSTAR = Isaac.GetItemIdByName("Angel's Morningstar"),
	COLLECTIBLE_POTATOSNACK = Isaac.GetItemIdByName("Potato Snack"),
	COLLECTIBLE_THEENCHIRIDION = Isaac.GetItemIdByName("The Enchiridion"),
	COLLECTIBLE_BODYDYSMORHIA = Isaac.GetItemIdByName("Body Dysmorphia"),
	COLLECTIBLE_EYESOFTHEDEAD = Isaac.GetItemIdByName("Eyes of the Dead"),
	COLLECTIBLE_PSORAISIS = Isaac.GetItemIdByName("Psoriasis"),
	COLLECTIBLE_NOTEBOOKOFTHEDEAD = Isaac.GetItemIdByName("Notebook of the Dead"),
	COLLECTIBLE_WICKEDWEAVES = Isaac.GetItemIdByName("Wicked Weaves"),
	COLLECTIBLE_LUNCHBOX = Isaac.GetItemIdByName("A Lunchbox"),
	COLLECTIBLE_ROMCOM = Isaac.GetItemIdByName("Typical Rom-Com"),
	COLLECTIBLE_MIRACULOUSWOMB = Isaac.GetItemIdByName("Miraculous Womb"),
	COLLECTIBLE_ETERNALBOND = Isaac.GetItemIdByName("Eternal Bond"),
	COLLECTIBLE_REBEKAHSCAMERA = Isaac.GetItemIdByName("Rebekah's Camera"),
	COLLECTIBLE_POWERLOVE = Isaac.GetItemIdByName("Love = Power"),
	COLLECTIBLE_CURSEDSPOON = Isaac.GetItemIdByName("Cursed Spoon"),
	COLLECTIBLE_DICEOFFATE = Isaac.GetItemIdByName("Dice of Fate"),
	COLLECTIBLE_LOVESICK = Isaac.GetItemIdByName("Lovesick"),
	COLLECTIBLE_SNAP = Isaac.GetItemIdByName("Snap!"),
	COLLECTIBLE_PATRIARCHSLIAR = Isaac.GetItemIdByName("Patriarch's Liar"),
	COLLECTIBLE_REBEKAHSFAVORITE = Isaac.GetItemIdByName("Rebekah's Favorite"),
	
	COLLECTIBLE_SKIMMEDMILK = Isaac.GetItemIdByName("Skimmed Milk"),
	COLLECTIBLE_HAPHEPHOBICBOMBS = Isaac.GetItemIdByName("Haphephobic Bombs"),
	COLLECTIBLE_JUMPYDUMPTY = Isaac.GetItemIdByName("Jumpy Dumpty"),
	COLLECTIBLE_PENCILSHARPENER = Isaac.GetItemIdByName("Pencil Sharpener"),
	COLLECTIBLE_NARCOLEPSY = Isaac.GetItemIdByName("Narcolepsy"),
	COLLECTIBLE_APPRECIATIONCAKE = Isaac.GetItemIdByName("Appreciation Cake"),
	COLLECTIBLE_JELLYDONUT = Isaac.GetItemIdByName("Jelly Donut"),
	COLLECTIBLE_SPIKEDPARTYPUNCH = Isaac.GetItemIdByName("Spiked Party Punch"),
	COLLECTIBLE_BOBATEA = Isaac.GetItemIdByName("Boba Tea"),
	COLLECTIBLE_CHEESYPIZZA = Isaac.GetItemIdByName("Cheesy Pizza"),
	COLLECTIBLE_BURGER = Isaac.GetItemIdByName("Bur-ger"),
	COLLECTIBLE_FENRIRSEYE = Isaac.GetItemIdByName("Fenrir's Eyes"),
	COLLECTIBLE_FENRIRSTOOTH = Isaac.GetItemIdByName("Fenrir's Tooth"),
	COLLECTIBLE_FENRIRSHEAD = Isaac.GetItemIdByName("Fenrir's Head"),
	COLLECTIBLE_FENRIRSPAW = Isaac.GetItemIdByName("Fenrir's Paw"),
	COLLECTIBLE_FENRIRSLEASH = Isaac.GetItemIdByName("Fenrir's Leash"),
	COLLECTIBLE_HEARTACHES = Isaac.GetItemIdByName("Heartaches..."),
	COLLECTIBLE_SILPHIUM = Isaac.GetItemIdByName("Silphium"),
	COLLECTIBLE_GIDDYUP = Isaac.GetItemIdByName("Giddy up!"),

	COLLECTIBLE_JACOBSTEARS = Isaac.GetItemIdByName("Jacob's Tears"),
	COLLECTIBLE_UNDERPAY = Isaac.GetItemIdByName("Underpay"),
	COLLECTIBLE_PLATFORMCOTTA = Isaac.GetItemIdByName("Platform Cotta"),
	COLLECTIBLE_MILKWINE = Isaac.GetItemIdByName("Milk Wine"),
	COLLECTIBLE_SILENTTREATMENT = Isaac.GetItemIdByName("Silent Treatment"),
	COLLECTIBLE_SILENCER = Isaac.GetItemIdByName("Silencer"),

	COLLECTIBLE_FULLFATMILK = Isaac.GetItemIdByName("Full Fat Milk"),

	COLLECTIBLE_UNREQUITEDLOVE = Isaac.GetItemIdByName("Unrequited Love"),
	
	COLLECTIBLE_REBEKAHSSCRAPBOOK = Isaac.GetItemIdByName("Rebekah's Scrapbook"),
	COLLECTIBLE_WISHFULTHINKING = Isaac.GetItemIdByName("Wishful Thinking"),

	COLLECTIBLE_SHATTEREDKEY = Isaac.GetItemIdByName("Shattered Key"),
	COLLECTIBLE_UNSTABLECANDLE = Isaac.GetItemIdByName("Unstable Candle"),
	COLLECTIBLE_OINKYBANK = Isaac.GetItemIdByName("Oink-y Bank"),
	COLLECTIBLE_9BATTS = Isaac.GetItemIdByName("9 Batts"),
	COLLECTIBLE_ARESBOX = Isaac.GetItemIdByName("Ares' Box"),
	COLLECTIBLE_SEABATTERY = Isaac.GetItemIdByName("Sea Battery"),
	COLLECTIBLE_VITAMINC = Isaac.GetItemIdByName("Vitamin C"),
	COLLECTIBLE_IOU = Isaac.GetItemIdByName("I.O.U."),
	COLLECTIBLE_SUSPICIOUSSTEW = Isaac.GetItemIdByName("Suspicious Stew"),
	COLLECTIBLE_FOMOBOMBS = Isaac.GetItemIdByName("FOMO Bombs"),
	

	COLLECTIBLE_TAINTEDQ = Isaac.GetItemIdByName("Sword of Hope")
}

RebekahCurse.LastItem = RebekahCurse.Items.COLLECTIBLE_TAINTEDQ

RebekahCurse.Cards = {
	CARD_EASTEREGG = Isaac.GetCardIdByName("redegg"),
	CARD_AQUA_EASTEREGG = Isaac.GetCardIdByName("aquaegg"),
	CARD_YELLOW_EASTEREGG = Isaac.GetCardIdByName("yellowegg"),
	CARD_GREEN_EASTEREGG = Isaac.GetCardIdByName("greenegg"),
	CARD_BLUE_EASTEREGG = Isaac.GetCardIdByName("blueegg"),
	CARD_PINK_EASTEREGG = Isaac.GetCardIdByName("pinkegg"),
	CARD_STRIPE_EASTEREGG = Isaac.GetCardIdByName("redstripeegg"),
	CARD_STRIPE_AQUA_EASTEREGG = Isaac.GetCardIdByName("aquastripeegg"),
	CARD_ZIGZAG_YELLOW_EASTEREGG = Isaac.GetCardIdByName("yellowzigzagegg"),
	CARD_ZIGZAG_GREEN_EASTEREGG = Isaac.GetCardIdByName("greenzigzagegg"),
	CARD_ZIGZAG_BLUE_EASTEREGG = Isaac.GetCardIdByName("bluezigzagegg"),
	CARD_STRIPE_PINK_EASTEREGG = Isaac.GetCardIdByName("pinkstripeegg"),
	
	CARD_CURSED_EASTEREGG = Isaac.GetCardIdByName("cursedegg"),
	CARD_BLESSED_EASTEREGG = Isaac.GetCardIdByName("blessedegg"),
	CARD_GOLDEN_EASTEREGG = Isaac.GetCardIdByName("goldenegg"),

	CARD_WORDSOFAFFIRMATION = Isaac.GetCardIdByName("affirmation"),
	CARD_GIFTGIVING = Isaac.GetCardIdByName("giftgiving"),
	CARD_ACTOFSERVICE = Isaac.GetCardIdByName("actofservice"),
	CARD_QUALITYTIME = Isaac.GetCardIdByName("qualitytime"),
	CARD_PHYSICALTOUCH = Isaac.GetCardIdByName("physicaltouch"),

}

RebekahCurse.Sounds = {
	SOUND_REBHURT = Isaac.GetSoundIdByName("RebekahHurt"),
	SOUND_REBDIE = Isaac.GetSoundIdByName("RebekahDie"),
	
	SOUND_GROUNDCRACK = Isaac.GetSoundIdByName("Ground Crack"),
	
	SOUND_REDCHARGELIGHT = Isaac.GetSoundIdByName("RedCharge Light"),
	SOUND_REDCHARGEHEAVY = Isaac.GetSoundIdByName("RedCharge Heavy"),
	SOUND_REDSHOTLIGHT = Isaac.GetSoundIdByName("RedShot Light"),
	SOUND_REDSHOTMEDIUM = Isaac.GetSoundIdByName("RedShot Medium"),
	SOUND_REDSHOTHEAVY = Isaac.GetSoundIdByName("RedShot Heavy"),
	SOUND_REDSPIT = Isaac.GetSoundIdByName("Red Spit"),
	SOUND_REDELECTRICITY = Isaac.GetSoundIdByName("Red Electricity"),
	
	SOUND_REDJINGLE = Isaac.GetSoundIdByName("Red Jingle"),
	SOUND_REDCRASH = Isaac.GetSoundIdByName("Red Crash"),
	SOUND_REDFETUS1 = Isaac.GetSoundIdByName("Red Fetus1"),
	SOUND_REDFETUS2 = Isaac.GetSoundIdByName("Red Fetus2"),
	
	SOUND_SOULCHARGELIGHT = Isaac.GetSoundIdByName("SoulCharge Light"),
	SOUND_SOULSHOTLIGHT = Isaac.GetSoundIdByName("SoulShot Light"),
	SOUND_SOULSHOTMEDIUM = Isaac.GetSoundIdByName("SoulShot Medium"),
	SOUND_SOULSHOTHEAVY = Isaac.GetSoundIdByName("SoulShot Heavy"),
	SOUND_SOULSPIT = Isaac.GetSoundIdByName("Soul Spit"),
	SOUND_SOULELECTRICITY = Isaac.GetSoundIdByName("Soul Electricity"),
	
	SOUND_SOULJINGLE = Isaac.GetSoundIdByName("Soul Jingle"),
	SOUND_SOULCRASH = Isaac.GetSoundIdByName("Soul Crash"),
	SOUND_SOULFETUS1 = Isaac.GetSoundIdByName("Soul Fetus1"),
	SOUND_SOULFETUS2 = Isaac.GetSoundIdByName("Soul Fetus2"),
	SOUND_SOULGARGLE = Isaac.GetSoundIdByName("Soul Gargle"),
	
	SOUND_EVILSUMMONAPOSTATE = Isaac.GetSoundIdByName("Evil Spawn"),
	
	SOUND_ETERNALJINGLE = Isaac.GetSoundIdByName("Eternal Jingle"),
	SOUND_IMMORTALJINGLE = Isaac.GetSoundIdByName("Immortal Jingle"),
	
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
	SOUND_SPARKELECTRIC = Isaac.GetSoundIdByName("Spark Effect"),
	SOUND_PUNCH = Isaac.GetSoundIdByName("Punch Effect"),
	
	SOUND_IMDIEBEEP = Isaac.GetSoundIdByName("Im Die Beep"),
	SOUND_IMDIECHIME = Isaac.GetSoundIdByName("Im Die Chime"),
	SOUND_LAUGHTRACK = Isaac.GetSoundIdByName("Laugh Track"),
	SOUND_LAUGHUNSETTLING = Isaac.GetSoundIdByName("Laugh Unsettling"),
	SOUND_CAMERAUSE = Isaac.GetSoundIdByName("Camera Use"),
	SOUND_PATRIARCHSLIARBELL = Isaac.GetSoundIdByName("Patriarch's Fist Bell"),
	SOUND_WICKEDWEAVES = Isaac.GetSoundIdByName("Wicked Weaves Spawn"),
	SOUND_UNREQUITEDLOVECHAIN = Isaac.GetSoundIdByName("Unrequited Love Chain"),
	SOUND_PSALM23UTTER = Isaac.GetSoundIdByName("Psalm 23 Utter"),
	SOUND_BODYDYSMORPHIAGROAN = Isaac.GetSoundIdByName("Body Dysmorphia Groan"),
	
	SOUND_KAPPA = Isaac.GetSoundIdByName("Easter Kappa"),
	SOUND_ISAAC_HIDDEN = Isaac.GetSoundIdByName("Easter Isaac Hidden"),
	SOUND_FOES_HIDDEN = Isaac.GetSoundIdByName("Easter Foes Hidden"),
	SOUND_LOOT_HIDDEN = Isaac.GetSoundIdByName("Easter Loot Hidden"),
	SOUND_DYSLEXIA = Isaac.GetSoundIdByName("Easter Dyslexia"),
	SOUND_DOGMAS_VISION = Isaac.GetSoundIdByName("Easter Dogma's Vision"),
	SOUND_MORE_GORE = Isaac.GetSoundIdByName("Easter More Gore"),
	SOUND_MEGAHEAD = Isaac.GetSoundIdByName("Easter Megahead"),
	SOUND_TINYHEAD = Isaac.GetSoundIdByName("Easter Tinyhead"),
	SOUND_SILLOUHETTE = Isaac.GetSoundIdByName("Easter Sillouhette"),
	SOUND_RELAX = Isaac.GetSoundIdByName("Easter Relax"),
	SOUND_RELAX2 = Isaac.GetSoundIdByName("Easter Relax 2"),
	SOUND_ROCK_ON = Isaac.GetSoundIdByName("Easter Rock On"),
	SOUND_ROCK_ON2 = Isaac.GetSoundIdByName("Easter Rock On 2"),
	SOUND_SLIPPERY_SLOPE = Isaac.GetSoundIdByName("Easter Slippery Slope"),
	SOUND_CHRISTMAS = Isaac.GetSoundIdByName("Easter Christmas"),
	SOUND_RETRO_VISION = Isaac.GetSoundIdByName("Easter Retro Vision"),
	SOUND_LOOT_ROTS = Isaac.GetSoundIdByName("Easter Loot Rots"),
	SOUND_BRAVERY = Isaac.GetSoundIdByName("Easter Bravery"),
	SOUND_COWARDICE = Isaac.GetSoundIdByName("Easter Cowardice"),
	SOUND_CURSE_DARKNESS = Isaac.GetSoundIdByName("Easter Darkness"),
	SOUND_CURSE_LABYRINTH = Isaac.GetSoundIdByName("Easter Labyrinth"),
	SOUND_CURSE_LOST = Isaac.GetSoundIdByName("Easter Lost"),
	SOUND_CURSE_UNKNOWN = Isaac.GetSoundIdByName("Easter Unknown"),
	SOUND_CURSE_MAZE = Isaac.GetSoundIdByName("Easter Maze"),
	SOUND_CURSE_BLINDNESS = Isaac.GetSoundIdByName("Easter Blindness"),
	SOUND_CURSE_CURSED = Isaac.GetSoundIdByName("Easter Curse"),
	SOUND_ORIGINALSIN_SHATTER = Isaac.GetSoundIdByName("Original Sin Shatter"),
	SOUND_SCRIBBLING = Isaac.GetSoundIdByName("Scribbling"),

	SOUND_VOCAL_C0 = Isaac.GetSoundIdByName("Vocal C0"),
	SOUND_VOCAL_CSHARP0 = Isaac.GetSoundIdByName("Vocal C#0"),
	SOUND_VOCAL_D0 = Isaac.GetSoundIdByName("Vocal D0"),
	SOUND_VOCAL_DSHARP0 = Isaac.GetSoundIdByName("Vocal D#0"),
	SOUND_VOCAL_E0 = Isaac.GetSoundIdByName("Vocal E0"),
	SOUND_VOCAL_F0 = Isaac.GetSoundIdByName("Vocal F0"),
	SOUND_VOCAL_FSHARP0 = Isaac.GetSoundIdByName("Vocal F#0"),
	SOUND_VOCAL_G0 = Isaac.GetSoundIdByName("Vocal G0"),
	SOUND_VOCAL_GSHARP0 = Isaac.GetSoundIdByName("Vocal G#0"),
	SOUND_VOCAL_A0 = Isaac.GetSoundIdByName("Vocal A0"),
	SOUND_VOCAL_ASHARP0 = Isaac.GetSoundIdByName("Vocal A#0"),
	SOUND_VOCAL_B0 = Isaac.GetSoundIdByName("Vocal B0"),

	SOUND_VOCAL_C1 = Isaac.GetSoundIdByName("Vocal C1"),
	SOUND_VOCAL_CSHARP1 = Isaac.GetSoundIdByName("Vocal C#1"),
	SOUND_VOCAL_D1 = Isaac.GetSoundIdByName("Vocal D1"),
	SOUND_VOCAL_DSHARP1 = Isaac.GetSoundIdByName("Vocal D#1"),
	SOUND_VOCAL_E1 = Isaac.GetSoundIdByName("Vocal E1"),
	SOUND_VOCAL_F1 = Isaac.GetSoundIdByName("Vocal F1"),
	SOUND_VOCAL_FSHARP1 = Isaac.GetSoundIdByName("Vocal F#1"),
	SOUND_VOCAL_G1 = Isaac.GetSoundIdByName("Vocal G1"),
	SOUND_VOCAL_GSHARP1 = Isaac.GetSoundIdByName("Vocal G#1"),
	SOUND_VOCAL_A1 = Isaac.GetSoundIdByName("Vocal A1"),
	SOUND_VOCAL_ASHARP1 = Isaac.GetSoundIdByName("Vocal A#1"),
	SOUND_VOCAL_B1 = Isaac.GetSoundIdByName("Vocal B1"),
	SOUND_VOCAL_C2 = Isaac.GetSoundIdByName("Vocal C2"),

	SOUND_VOCAL_CSHARP2 = Isaac.GetSoundIdByName("Vocal C#2"),
	SOUND_VOCAL_D2 = Isaac.GetSoundIdByName("Vocal D2"),
	SOUND_VOCAL_DSHARP2 = Isaac.GetSoundIdByName("Vocal D#2"),
	SOUND_VOCAL_E2 = Isaac.GetSoundIdByName("Vocal E2"),
	SOUND_VOCAL_F2 = Isaac.GetSoundIdByName("Vocal F2"),
	SOUND_VOCAL_FSHARP2 = Isaac.GetSoundIdByName("Vocal F#2"),
	SOUND_VOCAL_G2 = Isaac.GetSoundIdByName("Vocal G2"),
	SOUND_VOCAL_GSHARP2 = Isaac.GetSoundIdByName("Vocal G#2"),
	SOUND_VOCAL_A2 = Isaac.GetSoundIdByName("Vocal A2"),
	SOUND_VOCAL_ASHARP2 = Isaac.GetSoundIdByName("Vocal A#2"),
	SOUND_VOCAL_B2 = Isaac.GetSoundIdByName("Vocal B2"),

	SOUND_STOLID_SING = Isaac.GetSoundIdByName("Stolid Sing"),
	SOUND_STOLID_APPEAR = Isaac.GetSoundIdByName("Stolid Appear"),

	SOUND_HOUND_CHARGE = Isaac.GetSoundIdByName("Hound Charge"),
	SOUND_HOUND_SPAWN = Isaac.GetSoundIdByName("Hound Spawn"),
	SOUND_HOUND_DEATH = Isaac.GetSoundIdByName("Hound Death"),

	SOUND_PROSPECTOR_GRUNT = Isaac.GetSoundIdByName("Prospector Grunt"),
	SOUND_PROSPECTOR_SHOOT = Isaac.GetSoundIdByName("Prospector Shoot"),
	SOUND_PROSPECTOR_LAUGH = Isaac.GetSoundIdByName("Prospector Laugh"),
	SOUND_PROSPECTOR_YEEE_HOO = Isaac.GetSoundIdByName("Prospector Yeee-hoo"),
	SOUND_PROSPECTOR_GOING_UP = Isaac.GetSoundIdByName("Prospector Going Up"),
	SOUND_PROSPECTOR_SENTRY_DOWN = Isaac.GetSoundIdByName("Prospector Sentry Down"),
	SOUND_PROSPECTOR_DEATH = Isaac.GetSoundIdByName("Prospector Death"),
	SOUND_PROSPECTOR_SHOTGUN = Isaac.GetSoundIdByName("Prospector Shotgun"),
	SOUND_PROSPECTOR_WRENCH = Isaac.GetSoundIdByName("Prospector Wrench"),

	SOUND_NINCOMPOOP_PANT = Isaac.GetSoundIdByName("Nincompoop Pant"),
	SOUND_NINCOMPOOP_SPIT = Isaac.GetSoundIdByName("Nincompoop Spit"),
	SOUND_NINCOMPOOP_WHISTLE = Isaac.GetSoundIdByName("Nincompoop Whistle"),
	SOUND_NINCOMPOOP_PASS_BY = Isaac.GetSoundIdByName("Nincompoop Pass By"),
	SOUND_NINCOMPOOP_CHARGE = Isaac.GetSoundIdByName("Nincompoop Charge"),

	SOUND_POLTYGEIST_SPIT = Isaac.GetSoundIdByName("Poltygeist Spit"),
	SOUND_POLTYGEIST_THROW = Isaac.GetSoundIdByName("Poltygeist Throw"),
	SOUND_POLTYGEIST_TONGUE = Isaac.GetSoundIdByName("Poltygeist Tongue"),
	SOUND_POLTYGEIST_TAUNT = Isaac.GetSoundIdByName("Poltygeist Taunt"),
	SOUND_POLTYGEIST_TAUNTY = Isaac.GetSoundIdByName("Poltygeist Taunty"),
	SOUND_POLTYGEIST_DEATH = Isaac.GetSoundIdByName("Poltygeist Death"),

	SOUND_ROLANDAHH = Isaac.GetSoundIdByName("Roland Ahh"),

	SOUND_CURSED_SLAM = Isaac.GetSoundIdByName("Cursed Slam"),
	SOUND_CURSED_HEAVY_STRIKE = Isaac.GetSoundIdByName("Cursed Heavy Strike"),
	SOUND_CURSED_WILD_SWING = Isaac.GetSoundIdByName("Cursed Wild Swing"),
	SOUND_CURSED_RAGE = Isaac.GetSoundIdByName("Cursed Rage"),
	SOUND_CURSED_POP = Isaac.GetSoundIdByName("Cursed Pop"),
	SOUND_CURSED_ROCKET_LAUNCH = Isaac.GetSoundIdByName("Cursed Rocket Launch"),
	SOUND_CURSED_BEEP = Isaac.GetSoundIdByName("Cursed Beep"),
	SOUND_CURSED_BEEP_DEAD = Isaac.GetSoundIdByName("Cursed Beep Dead"),

	SOUND_SPRING_SOUND = Isaac.GetSoundIdByName("Spring Sound"),
	SOUND_QUALITY_TIME_IN = Isaac.GetSoundIdByName("Quality Time In"),
	SOUND_QUALITY_TIME_OUT = Isaac.GetSoundIdByName("Quality Time Out"),

	SOUND_LABAN_CLAP = Isaac.GetSoundIdByName("Laban Clap"),
	SOUND_LABAN_WHEEZE_1 = Isaac.GetSoundIdByName("Laban Wheeze 1"),
	SOUND_LABAN_WHEEZE_2 = Isaac.GetSoundIdByName("Laban Wheeze 2"),
	SOUND_LABAN_LAUGH = Isaac.GetSoundIdByName("Laban Laugh"),
	SOUND_LABAN_COUGH = Isaac.GetSoundIdByName("Laban Cough"),
}

RebekahCurse.Music = {
	MUSIC_HEARTROOM = Isaac.GetMusicIdByName("Calm Before the Storm"),
	MUSIC_BACKROOMS = Isaac.GetMusicIdByName("Backrooms"),
	MUSIC_BACKROOMSBOSS = Isaac.GetMusicIdByName("Moist"),
	MUSIC_TICKTOCK = Isaac.GetMusicIdByName("Tick Tock"),
}

RebekahCurse.Enemies = {
	ENTITY_FACELING = Isaac.GetEntityVariantByName("Faceling"),
	ENTITY_HOUNDPUPPY = Isaac.GetEntityVariantByName("Hound Puppy"),

	ENTITY_THE_STOLID = Isaac.GetEntityVariantByName("The Stolid"),
	ENTITY_OVUM_EGG = Isaac.GetEntityVariantByName("Ovum Egg"),
	ENTITY_OVUM_EGG_EFFECT = Isaac.GetEntityVariantByName("Ovum Egg Effect"),
	ENTITY_NINCOMPOOP = Isaac.GetEntityVariantByName("Nincompoop"),
	ENTITY_POLTYGEIST = Isaac.GetEntityVariantByName("Poltygeist"),
	ENTITY_POLTY_TONGUE = Isaac.GetEntityVariantByName("Polty Tongue"),
	ENTITY_GIANTGRIDPROJECTILE = Isaac.GetEntityVariantByName("Giant Grid Projectile"),
	ENTITY_GIANTGRIDBREAK = Isaac.GetEntityVariantByName("Giant Grid Break"),
	ENTITY_THEPROSPECTOR = Isaac.GetEntityVariantByName("The Prospector"),
	ENTITY_SENTRYROCKETTARGET = Isaac.GetEntityVariantByName("Sentry Rocket Target"),
	ENTITY_SENTRYROCKETNUKE = Isaac.GetEntityVariantByName("Sentry Rocket Rocket"),

	ENTITY_ENYO = Isaac.GetEntityVariantByName("Enyo"),
	ENTITY_DEINO = Isaac.GetEntityVariantByName("Deino"),
	ENTITY_PEMPHREDO = Isaac.GetEntityVariantByName("Pemphredo"),
	ENTITY_GREYSISTEREYE = Isaac.GetEntityVariantByName("Grey Eye"),

	ENTITY_REBEKAH_ENEMY = Isaac.GetEntityTypeByName("Rebekah Entities"),
	ENTITY_REDTATO = Isaac.GetEntityVariantByName("Red Tato"),
	ENTITY_MAGDALENE_HEART = Isaac.GetEntityVariantByName("Magdalene Hearts"),
	
	ENTITY_MAGDALENE_BOSS = Isaac.GetEntityVariantByName("Magdalene (Boss)"),
	
	ENTITY_THE_SCUM = Isaac.GetEntityVariantByName("The Scum"),
	ENTITY_THE_HOUND = Isaac.GetEntityVariantByName("The Hound"),

	ENTITY_EVE_BOSS = Isaac.GetEntityVariantByName("Eve (Boss)"),
	ENTITY_BLOOD_SLOTH = Isaac.GetEntityVariantByName("Blood Sloth"),
	ENTITY_BLOOD_WRATH = Isaac.GetEntityVariantByName("Blood Wrath"),
	
	ENTITY_LILITH_BOSS = Isaac.GetEntityVariantByName("Lilith (Boss)"),
	ENTITY_BOBSBRAIN_ENEMY = Isaac.GetEntityVariantByName("Bob's Brain (Enemy)"),
	ENTITY_DEMONBABY_ENEMY = Isaac.GetEntityVariantByName("Demon Baby (Enemy)"),
	ENTITY_MULTIDIMENSIONALBABY_ENEMY = Isaac.GetEntityVariantByName("Multidimensional Baby (Enemy)"),
	ENTITY_ROBOBABY_ENEMY = Isaac.GetEntityVariantByName("Robo Baby (Enemy)"),

	--undercrofts
	ENTITY_SISTER = Isaac.GetEntityVariantByName("Sister"),
	ENTITY_BUMBAB = Isaac.GetEntityVariantByName("Bumbab"),
	ENTITY_BUMBAB_PUNCH = Isaac.GetEntityVariantByName("Bumbab Punch"),
	ENTITY_ROACH = Isaac.GetEntityVariantByName("Roach"),
	ENTITY_MONK = Isaac.GetEntityVariantByName("Monk"),
	ENTITY_LONGITS = Isaac.GetEntityVariantByName("Longits"),
	ENTITY_LOAFERING = Isaac.GetEntityVariantByName("Loafering"),
	ENTITY_FRUITFLY = Isaac.GetEntityVariantByName("Fruit Fly"),
	--academy
	ENTITY_EVALUATOR = Isaac.GetEntityVariantByName("Evaluator"),
	ENTITY_DEVOTEE = Isaac.GetEntityVariantByName("Devotee"),
	ENTITY_GOSSIPER = Isaac.GetEntityVariantByName("Gossiper"),
	ENTITY_FOUNDATION = Isaac.GetEntityVariantByName("Foundation"),
	ENTITY_NPC = Isaac.GetEntityVariantByName("Npc"),
}

RebekahCurse.Pills = {
	GOOSEBUMPS = Isaac.GetPillEffectByName("Goosebumps!"),
	ENDORPHIN = Isaac.GetPillEffectByName("Endorphin"),
	LAUGHTERSTHEBESTMEDICINE = Isaac.GetPillEffectByName("Laughter's the best medicine"),
	HEMORRHAGE = Isaac.GetPillEffectByName("Hemorrhage"),
	OVULATION = Isaac.GetPillEffectByName("Ovulation"),
	PROGESTIN = Isaac.GetPillEffectByName("Progestin"),
}

RebekahCurse.DustEffects = {
	ENTITY_REBEKAH_GENERIC_DUST = 0,
	ENTITY_REBEKAH_GENERIC_DUST_FRONT = 1,
	ENTITY_REBEKAH_GENERIC_DUST_ANGLED = 2,
	ENTITY_REBEKAH_GENERIC_DUST_ANGLED_BACK = 3,
	ENTITY_REBEKAH_CHARGE_DUST = 4,
	ENTITY_REBEKAH_LUDO_LIGHTNING = 5,
	ENTITY_REBEKAH_SOUL_ARCANE_CIRCLE = 6,
	ENTITY_REBEKAH_SOUL_PUKE_EFFECT = 7,
	ENTITY_REBEKAH_SPECIAL_ARCANE_CIRCLE = 8,
	ENTITY_REBEKAH_LUDO_MOUTH = 9,
	ENTITY_REBEKAH_GENERIC_DUST_BIG = 10,
	ENTITY_REBEKAH_GENERIC_DUST_FRONT_BIG = 11,
	ENTITY_REBEKAH_GENERIC_DUST_ANGLED_BIG = 12,
	ENTITY_REBEKAH_GENERIC_DUST_ANGLED_BACK_BIG = 13,
	ENTITY_REBEKAH_GOLD_FORCE_FIELD = 14,
	ENTITY_REBEKAH_CURSED_SLAM = 30,
	ENTITY_REBEKAH_CURSED_SLAM_DEFAULT = 31,
	ENTITY_REBEKAH_CURSED_HEAVY_STRIKE = 32,
	ENTITY_REBEKAH_CURSED_WILD_SWING = 33,
	ENTITY_REBEKAH_SLAM_HAND_THING = 34,
	ENTITY_REBEKAH_RAGE_CIRCLE = 35,
	ENTITY_REBEKAH_CURSED_GODHEAD_STRIKE = 36,
	ENTITY_REBEKAH_CURSED_EMOJI_SLAM = 37,
	ENTITY_REBEKAH_CURSED_EMOJI_HEAVY_STRIKE = 38,
	
}

RebekahCurse.Grids = {
	LABAN_DUDE = StageAPI.CustomGrid("Laban", {
		BaseType = GridEntityType.GRID_ROCKB, 
		Anm2 = "gfx/none.anm2", 
		Animation = "SmallIdle",
        SpawnerEntity = {
            Type = 656,
            Variant = 177,
        },
	})
}

RebekahCurse.Challenges ={
	TheTrueFamilyGuy = Isaac.GetChallengeIdByName("[CaB] The True Family Guy"),
	IdentityCrisis = Isaac.GetChallengeIdByName("[CaB] Identity Crisis"),
	EasterHunt = Isaac.GetChallengeIdByName("[CaB] Easter Hunt"),
}

local wasFromTaintedLocked = false

local IsaacPresent = false
local JacobPresent = false

RebekahCurse.Costumes = {
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

	RebekahSpitsOut = Isaac.GetCostumeIdByPath("gfx/characters/rebekahspitsout.anm2"),
	WizoobHairGoingDown = Isaac.GetCostumeIdByPath("gfx/characters/costumes/soul/wizoobhairgoingdown.anm2"),

	BloodGush = Isaac.GetCostumeIdByPath("gfx/characters/blood_gush.anm2"),
	HeadlessHead = Isaac.GetCostumeIdByPath("gfx/characters/costumes/rebekah_hair/rottenmode_headremove.anm2"),
	SkinlessHead = Isaac.GetCostumeIdByPath("gfx/characters/costumes/rebekah_hair/rottenmode_skinremove.anm2"),

	HalfFace = Isaac.GetCostumeIdByPath("gfx/characters/halfface.anm2"),
	HalfSoulFace = Isaac.GetCostumeIdByPath("gfx/characters/halfsoulface.anm2"),
	BlendedIdle = Isaac.GetCostumeIdByPath("gfx/characters/blendedidle.anm2"),
	BlendedSillyMe = Isaac.GetCostumeIdByPath("gfx/characters/blendedsillyme.anm2"),

	BridalHair = Isaac.GetCostumeIdByPath("gfx/characters/bridalhair.anm2"),
	--BridalStockings = Isaac.GetCostumeIdByPath("gfx/characters/weddedstockings.anm2"),
	FulfilledFace = Isaac.GetCostumeIdByPath("gfx/characters/fulfilled.anm2"),
	IsaacOverdose = Isaac.GetCostumeIdByPath("gfx/characters/isaac_overdose.anm2"),
	JacobEsauGlad = Isaac.GetCostumeIdByPath("gfx/characters/maternallove_aura.anm2"),
	
	CandyWeddingRing = Isaac.GetCostumeIdByPath("gfx/characters/candyweddingring.anm2"),
	LovePower = Isaac.GetCostumeIdByPath("gfx/characters/love_power.anm2"),
	LunchboxCos = Isaac.GetCostumeIdByPath("gfx/characters/lunchbox.anm2"),
	CursedMawCos = Isaac.GetCostumeIdByPath("gfx/characters/cursedmaw.anm2"),
	LoveSickCrazyCos = Isaac.GetCostumeIdByPath("gfx/characters/lovesick.anm2"),
	LoveSickBansheeCos = Isaac.GetCostumeIdByPath("gfx/characters/lovesick_banshee.anm2"),
	LoveSickBansheeShriekCos = Isaac.GetCostumeIdByPath("gfx/characters/lovesick_banshee_shriek.anm2"),
	UnsnappedCos = Isaac.GetCostumeIdByPath("gfx/characters/unsnapped.anm2"),
	SnappedCos = Isaac.GetCostumeIdByPath("gfx/characters/snap.anm2"),
	
	GreatPheonix = Isaac.GetCostumeIdByPath("gfx/characters/great_pheonix.anm2"),
	NutWater = Isaac.GetCostumeIdByPath("gfx/characters/nutwater.anm2"),
	TightHairtie = Isaac.GetCostumeIdByPath("gfx/characters/tighthairtie.anm2"),
	BasketOfEggs = Isaac.GetCostumeIdByPath("gfx/characters/basket_of_eggs.anm2"),
	OversizedSweater = Isaac.GetCostumeIdByPath("gfx/characters/oversizedsweater.anm2"),
	TechHz = Isaac.GetCostumeIdByPath("gfx/characters/techhz.anm2"),
	OriginalSin = Isaac.GetCostumeIdByPath("gfx/characters/originalsin.anm2"),
	PotatoSnack = Isaac.GetCostumeIdByPath("gfx/characters/potatosnack.anm2"),
	EyesOfTheDead = Isaac.GetCostumeIdByPath("gfx/characters/eyesofthedead.anm2"),
	AdventureTime = Isaac.GetCostumeIdByPath("gfx/characters/adventuretime.anm2"),
	Psoriasis = Isaac.GetCostumeIdByPath("gfx/characters/psoriasis.anm2"),

	BodyDysmorphia = Isaac.GetCostumeIdByPath("gfx/characters/body_dysmorphia.anm2"),
	WickedWeaves = Isaac.GetCostumeIdByPath("gfx/characters/wickedweaves.anm2"),

	DeborahBody = Isaac.GetCostumeIdByPath("gfx/characters/oldermaidbody.anm2"),
	FenrirsEye = Isaac.GetCostumeIdByPath("gfx/characters/fenrirs_eye.anm2"),

	KomiCant = Isaac.GetCostumeIdByPath("gfx/characters/komicant.anm2"),
}


RebekahCurse.REBEKAH_BALANCE = {
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
	SOUL_HEARTS_DASH_COOLDOWN = 160, --120
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
	BONE_HEARTS_DASH_COOLDOWN = 8, --80
	BONE_HEARTS_DASH_INVINCIBILITY_FRAMES = 15,
	BONE_HEARTS_MODIFIED_DASH_COOLDOWN = 30, --150
	BONE_HEARTS_MODIFIED_DASH_INVINCIBILITY_FRAMES = 160,
	BONE_HEARTS_VAULT_VELOCITY = 6,
	BONE_HEARTS_DASH_VELOCITY = 2,
	BONE_HEARTS_DASH_TARGET_SPEED = 3,
	BONE_HEARTS_BONE_JOCKEY_DASH_SPEED = 48,
	BONE_HEARTS_BONE_JOCKEY_CONTINUOUS_DASH_SPEED = 20,
	BONE_HEARTS_BONE_JOCKEY_DASH_COOLDOWN_FRAME = 55,
	ROTTEN_HEARTS_DASH_COOLDOWN = 80,
	ROTTEN_HEARTS_DASH_SPEED = 20,
	ROTTEN_HEARTS_FLYBALL_SPEED = 1.5, 
	BROKEN_HEARTS_DASH_COOLDOWN = 55,
	IMMORTAL_HEARTS_DASH_COOLDOWN = 55,
	BRIDE_RED_HEARTS_DASH_SPEED = 25
}

RebekahCurse.REBEKAH_OPTIONS = {
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
	DOUBLE_TAP_ANGLE_ROUNDING = 1,
	
	DASHKEY_DISABLE = true,
	DASHKEY_BIND = Keyboard.KEY_LEFT_CONTROL,
	VOICE_VOLUME = 5,
	UNLOCK_ITEMS = 0,
	MENU_INIT = 0,
	--DashKeyboardBinding = ModConfigMenu.Config["Cursed Rebekah"]["Rebekah Dash Keyboard Binding"],
	--DashControllerBinding
}

RebekahCurse.REBECCA_MODE = {
	EmptyHearts = 0,
	RedHearts = 1,
	SoulHearts = 2,
	EternalHearts = 3,
	GoldHearts = 4,
	EvilHearts = 5,
	BoneHearts = 6,
	RottenHearts = 7,
	BrokenHearts = 8,
	ImmortalHearts = 9,
	IllusionHearts = 10,
	SunHearts = 11,
	BrideRedHearts = 12,
	BlendedHearts = 13,
	ScaredRedHearts = 14,
	TwinRedHearts = 15,
	HalfRedHearts = 16,
	HalfSoulHearts = 17,

	CursedCurse = 30
}

RebekahCurse.RebeccaModeNames = {
	[RebekahCurse.REBECCA_MODE.EmptyHearts] = "empty", --,
	[RebekahCurse.REBECCA_MODE.RedHearts] = "red", --InnocentHair,
	[RebekahCurse.REBECCA_MODE.SoulHearts] = "soul", --WizoobHair,
	[RebekahCurse.REBECCA_MODE.GoldHearts] = "gold", --SwagHair,
	[RebekahCurse.REBECCA_MODE.EvilHearts] = "evil", --HadFunHair,
	[RebekahCurse.REBECCA_MODE.EternalHearts] = "eternal", --AoDHair,
	[RebekahCurse.REBECCA_MODE.BoneHearts] =  "bone", --DeadHair,
	[RebekahCurse.REBECCA_MODE.RottenHearts] =  "rotten",
	[RebekahCurse.REBECCA_MODE.BrokenHearts] =  "broken",
	[RebekahCurse.REBECCA_MODE.ImmortalHearts] =  "immortal",
	[RebekahCurse.REBECCA_MODE.BrideRedHearts] = "bride", --BridalHair

	[RebekahCurse.REBECCA_MODE.ScaredRedHearts] = "red", --InnocentHair,
	[RebekahCurse.REBECCA_MODE.TwinRedHearts] = "red", --InnocentHair,
	[RebekahCurse.REBECCA_MODE.BlendedHearts] = "soul", --InnocentHair,
	[RebekahCurse.REBECCA_MODE.HalfRedHearts] = "red", --InnocentHair,
	[RebekahCurse.REBECCA_MODE.HalfSoulHearts] = "soul", --InnocentHair,

	[RebekahCurse.REBECCA_MODE.CursedCurse] =  "cursed",
}


RebekahCurse.RebeccaModeCostumes = {
	[RebekahCurse.REBECCA_MODE.EmptyHearts] = "innocenthair", --InnocentHair,
	[RebekahCurse.REBECCA_MODE.RedHearts] = "emergenthair", --InnocentHair,
	[RebekahCurse.REBECCA_MODE.SoulHearts] = "wizoobhair", --WizoobHair,
	[RebekahCurse.REBECCA_MODE.GoldHearts] = "swaghair", --SwagHair,
	[RebekahCurse.REBECCA_MODE.EvilHearts] = "hadfunhair", --HadFunHair,
	[RebekahCurse.REBECCA_MODE.EternalHearts] = "angelofdeathhair", --AoDHair,
	[RebekahCurse.REBECCA_MODE.BoneHearts] =  "deadhair", --DeadHair,
	[RebekahCurse.REBECCA_MODE.RottenHearts] =  "crazyhair",
	[RebekahCurse.REBECCA_MODE.BrokenHearts] =  "fourthwallhair",
	[RebekahCurse.REBECCA_MODE.ImmortalHearts] =  "heyheyhair",
	[RebekahCurse.REBECCA_MODE.BrideRedHearts] = "bridalhair", --BridalHair

	[RebekahCurse.REBECCA_MODE.ScaredRedHearts] = "emergenwithnobadendingthair", --InnocentHair,
	[RebekahCurse.REBECCA_MODE.TwinRedHearts] = "emergenwithnobadendingthair", --InnocentHair,
	[RebekahCurse.REBECCA_MODE.BlendedHearts] = "emergentwizoobhair", --InnocentNotReallyHair,
	[RebekahCurse.REBECCA_MODE.HalfRedHearts] = "emergenwithnobadendingthair", --InnocentHair,
	[RebekahCurse.REBECCA_MODE.HalfSoulHearts] = "wizoobhair", --InnocentHair,

	[RebekahCurse.REBECCA_MODE.CursedCurse] = "haunted_hairstyle" --BridalHair
}

RebekahCurse.RebeccaModeEffects = {
	[RebekahCurse.REBECCA_MODE.RedHearts] = CollectibleType.COLLECTIBLE_20_20,
	--[RebekahCurse.REBECCA_MODE.SoulHearts] = N/A,
	[RebekahCurse.REBECCA_MODE.GoldHearts] = CollectibleType.COLLECTIBLE_HEAD_OF_THE_KEEPER,
	[RebekahCurse.REBECCA_MODE.EvilHearts] = CollectibleType.COLLECTIBLE_SERPENTS_KISS,
	[RebekahCurse.REBECCA_MODE.EternalHearts] = CollectibleType.COLLECTIBLE_FATE,
	[RebekahCurse.REBECCA_MODE.BoneHearts] = CollectibleType.COLLECTIBLE_COMPOUND_FRACTURE,
	
	[RebekahCurse.REBECCA_MODE.BrideRedHearts] = CollectibleType.COLLECTIBLE_20_20
}

RebekahCurse.RebekahHeartParticleType = {
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

RebekahCurse.RebekahHeartParticleSpriteByType = {
	[RebekahCurse.RebekahHeartParticleType.Red] = "gfx/effects/heart_red.png",
	[RebekahCurse.RebekahHeartParticleType.Blue] = "gfx/effects/heart_blue.png",
	[RebekahCurse.RebekahHeartParticleType.Soul] = "gfx/effects/heart_blue.png",
	[RebekahCurse.RebekahHeartParticleType.Gold] = "gfx/effects/heart_gold.png",
	[RebekahCurse.RebekahHeartParticleType.Black] = "gfx/effects/heart_black.png",
	[RebekahCurse.RebekahHeartParticleType.Evil] = "gfx/effects/heart_black.png",
	[RebekahCurse.RebekahHeartParticleType.White] = "gfx/effects/heart_eternal.png",
	[RebekahCurse.RebekahHeartParticleType.Eternal] = "gfx/effects/heart_eternal.png",
	[RebekahCurse.RebekahHeartParticleType.Bone] = "gfx/effects/heart_bone.png"
}

RebekahCurse.RebekahHeartParticleTypeByMode = {
	[RebekahCurse.REBECCA_MODE.RedHearts] = RebekahCurse.RebekahHeartParticleType.Red,
	[RebekahCurse.REBECCA_MODE.SoulHearts] = RebekahCurse.RebekahHeartParticleType.Blue,
	[RebekahCurse.REBECCA_MODE.GoldHearts] = RebekahCurse.RebekahHeartParticleType.Gold,
	[RebekahCurse.REBECCA_MODE.EvilHearts] = RebekahCurse.RebekahHeartParticleType.Evil,
	[RebekahCurse.REBECCA_MODE.EternalHearts] = RebekahCurse.RebekahHeartParticleType.Eternal,
	[RebekahCurse.REBECCA_MODE.BoneHearts] = RebekahCurse.RebekahHeartParticleType.Bone
}

RebekahCurse.RebekahPoofParticleType = {
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

RebekahCurse.RebekahPoofParticleSpriteByType = {
	[RebekahCurse.RebekahPoofParticleType.Red] = "gfx/effects/poof_red.png",
	[RebekahCurse.RebekahPoofParticleType.Blue] = "gfx/effects/poof_blue.png",
	[RebekahCurse.RebekahPoofParticleType.Soul] = "gfx/effects/poof_blue.png",
	[RebekahCurse.RebekahPoofParticleType.Gold] = "gfx/effects/poof_gold.png",
	[RebekahCurse.RebekahPoofParticleType.Black] = "gfx/effects/poof_black.png",
	[RebekahCurse.RebekahPoofParticleType.Evil] = "gfx/effects/poof_black.png",
	[RebekahCurse.RebekahPoofParticleType.Eternal] = "gfx/effects/poof_eternal.png",
	[RebekahCurse.RebekahPoofParticleType.White] = "gfx/effects/poof_eternal.png",
	[RebekahCurse.RebekahPoofParticleType.Bone] = "gfx/effects/poof_bone.png"
}

RebekahCurse.RebekahPoofParticleTypeByMode = {
	[RebekahCurse.REBECCA_MODE.RedHearts] = RebekahCurse.RebekahPoofParticleType.Red,
	[RebekahCurse.REBECCA_MODE.SoulHearts] = RebekahCurse.RebekahPoofParticleType.Blue,
	[RebekahCurse.REBECCA_MODE.GoldHearts] = RebekahCurse.RebekahPoofParticleType.Gold,
	[RebekahCurse.REBECCA_MODE.EvilHearts] = RebekahCurse.RebekahPoofParticleType.Evil,
	[RebekahCurse.REBECCA_MODE.EternalHearts] = RebekahCurse.RebekahPoofParticleType.Eternal,
	[RebekahCurse.REBECCA_MODE.BoneHearts] = RebekahCurse.RebekahPoofParticleType.Bone
}

RebekahCurse.RebekahMirrorHeartDrop = {
	[1] = 1, --red
	[2] = 3, --soul
	[3] = 4, --eternal
	[4] = 6, --evil
	[5] = 7, --gold
	[6] = 11, --bone
	[7] = 12
}

--Stage
yandereWaifu.STAGE = {}

local REBECCA_INFO = InutilLib.Players:New({}, RebekahCurse.REB_RED, RebekahCurse.Sounds.SOUND_REBHURT, RebekahCurse.Sounds.SOUND_REBDIE, {InutilLib.DefaultInstructions, "gfx/backdrop/controls_rebecca_extra.png"}, {"gfx/characters/big_rebekah.anm2", "gfx/characters/big_rebekah.png"});
local REBECCA_SOUL_INFO = InutilLib.Players:New({}, RebekahCurse.REB_SOUL, RebekahCurse.Sounds.SOUND_REBHURT, RebekahCurse.Sounds.SOUND_REBDIE, {InutilLib.DefaultInstructions, "gfx/backdrop/controls_rebecca_extra.png"}, {"gfx/characters/big_rebekah.anm2", "gfx/characters/big_rebekah.png"});
local REBECCA_EVIL_INFO = InutilLib.Players:New({}, RebekahCurse.REB_EVIL, RebekahCurse.Sounds.SOUND_REBHURT, RebekahCurse.Sounds.SOUND_REBDIE, {InutilLib.DefaultInstructions, "gfx/backdrop/controls_rebecca_extra.png"}, {"gfx/characters/big_rebekah.anm2", "gfx/characters/big_rebekah.png"});
local REBECCA_GOLD_INFO = InutilLib.Players:New({}, RebekahCurse.REB_GOLD, RebekahCurse.Sounds.SOUND_REBHURT, RebekahCurse.Sounds.SOUND_REBDIE, {InutilLib.DefaultInstructions, "gfx/backdrop/controls_rebecca_extra.png"}, {"gfx/characters/big_rebekah.anm2", "gfx/characters/big_rebekah.png"});
local REBECCA_ETERNAL_INFO = InutilLib.Players:New({}, RebekahCurse.REB_ETERNAL, RebekahCurse.Sounds.SOUND_REBHURT, RebekahCurse.Sounds.SOUND_REBDIE, {InutilLib.DefaultInstructions, "gfx/backdrop/controls_rebecca_extra.png"}, {"gfx/characters/big_rebekah.anm2", "gfx/characters/big_rebekah.png"});
local REBECCA_BONE_INFO = InutilLib.Players:New({}, RebekahCurse.REB_BONE, RebekahCurse.Sounds.SOUND_REBHURT, RebekahCurse.Sounds.SOUND_REBDIE, {InutilLib.DefaultInstructions, "gfx/backdrop/controls_rebecca_extra.png"}, {"gfx/characters/big_rebekah.anm2", "gfx/characters/big_rebekah.png"});
local REBECCA_BROKEN_INFO = InutilLib.Players:New({}, RebekahCurse.REB_BROKEN, RebekahCurse.Sounds.SOUND_REBHURT, RebekahCurse.Sounds.SOUND_REBDIE, {InutilLib.DefaultInstructions, "gfx/backdrop/controls_rebecca_extra.png"}, {"gfx/characters/big_rebekah.anm2", "gfx/characters/big_rebekah.png"});
local REBECCA_ROTTEN_INFO = InutilLib.Players:New({}, RebekahCurse.REB_ROTTEN, RebekahCurse.Sounds.SOUND_REBHURT, RebekahCurse.Sounds.SOUND_REBDIE, {InutilLib.DefaultInstructions, "gfx/backdrop/controls_rebecca_extra.png"}, {"gfx/characters/big_rebekah.anm2", "gfx/characters/big_rebekah.png"});

--local REBECCA_SCARED_INFO = InutilLib.Players:New({}, RebekahCurse.REB_RED, RebekahCurse.Sounds.SOUND_REBHURT, RebekahCurse.Sounds.SOUND_REBDIE, {InutilLib.DefaultInstructions, "gfx/backdrop/controls_rebecca_extra.png"}, {"gfx/characters/big_rebekah.anm2", "gfx/characters/big_rebekah.png"});

local REBECCA_CURSED_INFO = InutilLib.Players:New({}, RebekahCurse.REB_CURSED, RebekahCurse.Sounds.SOUND_REBHURT, RebekahCurse.Sounds.SOUND_REBDIE, {InutilLib.DefaultInstructions, "gfx/backdrop/controls_rebecca_extra.png"}, {"gfx/characters/big_rebekah.anm2", "gfx/characters/big_rebekah.png"});
if StageAPI and StageAPI.Loaded then
    StageAPI.AddPlayerGraphicsInfo(RebekahCurse.REB_RED, 
	{
	Portrait =  "gfx/ui/stage/playerportrait_rebekah.png", 
	Name = "gfx/ui/boss/name_rebekah.png",
	PortraitBig = "gfx/ui/stage/playerportraitbig_rebekah.png",
	NoShake = nil,
	Controls = "gfx/backdrop/stageapi_rebekah_controls.png",
	ControlsFrame = 2,
	ControlsOffset = nil
	}, "gfx/ui/boss/name_rebekah.png", "gfx/ui/stage/playerportrait_rebekah.png")
	StageAPI.AddPlayerGraphicsInfo(RebekahCurse.REB_SOUL, 
	{
	Portrait =  "gfx/ui/stage/playerportrait_soul_rebekah.png", 
	Name = "gfx/ui/boss/name_rebekah.png",
	PortraitBig = "gfx/ui/stage/playerportrait_soul_rebekah.png",
	NoShake = nil,
	Controls = "gfx/backdrop/stageapi_rebekah_controls.png",
	ControlsFrame = 2,
	ControlsOffset = nil
	}, "gfx/ui/boss/name_rebekah.png", "gfx/ui/stage/playerportrait_soul_rebekah.png")
	StageAPI.AddPlayerGraphicsInfo(RebekahCurse.REB_EVIL, 
	{
	Portrait =  "gfx/ui/stage/playerportrait_evil_rebekah.png", 
	Name = "gfx/ui/boss/name_rebekah.png",
	PortraitBig = "gfx/ui/stage/playerportrait_evil_rebekah.png",
	NoShake = nil,
	Controls = "gfx/backdrop/stageapi_rebekah_controls.png",
	ControlsFrame = 2,
	ControlsOffset = nil
	}, "gfx/ui/boss/name_rebekah.png", "gfx/ui/stage/playerportrait_evil_rebekah.png")
	StageAPI.AddPlayerGraphicsInfo(RebekahCurse.REB_GOLD, 
	{
	Portrait =  "gfx/ui/stage/playerportrait_gold_rebekah.png", 
	Name = "gfx/ui/boss/name_rebekah.png",
	PortraitBig = "gfx/ui/stage/playerportrait_gold_rebekah.png",
	NoShake = nil,
	Controls = "gfx/backdrop/stageapi_rebekah_controls.png",
	ControlsFrame = 2,
	ControlsOffset = nil
	}, "gfx/ui/boss/name_rebekah.png", "gfx/ui/stage/playerportraitbig_rebekah.png")
	StageAPI.AddPlayerGraphicsInfo(RebekahCurse.REB_ETERNAL, 
	{
	Portrait =  "gfx/ui/stage/playerportrait_eternal_rebekah.png", 
	Name = "gfx/ui/boss/name_rebekah.png",
	PortraitBig = "gfx/ui/stage/playerportrait_eternal_rebekah.png",
	NoShake = nil,
	Controls = "gfx/backdrop/stageapi_rebekah_controls.png",
	ControlsFrame = 2,
	ControlsOffset = nil
	}, "gfx/ui/boss/name_rebekah.png", "gfx/ui/stage/playerportrait_eternal_rebekah.png")
	StageAPI.AddPlayerGraphicsInfo(RebekahCurse.REB_BONE, 
	{
	Portrait =  "gfx/ui/stage/playerportrait_bone_rebekah.png", 
	Name = "gfx/ui/boss/name_rebekah.png",
	PortraitBig = "gfx/ui/stage/playerportrait_bone_rebekah.png",
	NoShake = nil,
	Controls = "gfx/backdrop/stageapi_rebekah_controls.png",
	ControlsFrame = 2,
	ControlsOffset = nil
	}, "gfx/ui/boss/name_rebekah.png", "gfx/ui/stage/playerportraitbig_rebekah.png")
	StageAPI.AddPlayerGraphicsInfo(RebekahCurse.REB_ROTTEN, 
	{
	Portrait =  "gfx/ui/stage/playerportrait_rebekah.png", 
	Name = "gfx/ui/boss/name_rebekah.png",
	PortraitBig = "gfx/ui/stage/playerportraitbig_rebekah.png",
	NoShake = nil,
	Controls = "gfx/backdrop/stageapi_rebekah_controls.png",
	ControlsFrame = 2,
	ControlsOffset = nil
	}, "gfx/ui/boss/name_rebekah.png", "gfx/ui/stage/playerportraitbig_rebekah.png")
	StageAPI.AddPlayerGraphicsInfo(RebekahCurse.REB_BROKEN, 
	{
	Portrait =  "gfx/ui/stage/playerportrait_rebekah.png", 
	Name = "gfx/ui/boss/name_rebekah.png",
	PortraitBig = "gfx/ui/stage/playerportraitbig_rebekah.png",
	NoShake = nil,
	Controls = "gfx/backdrop/stageapi_rebekah_controls.png",
	ControlsFrame = 2,
	ControlsOffset = nil
	}, "gfx/ui/boss/name_rebekah.png", "gfx/ui/stage/playerportraitbig_rebekah.png")
end