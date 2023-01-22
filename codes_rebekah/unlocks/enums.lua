yandereWaifu.ACHIEVEMENT = {
	--taken inspiration from FF to accomodate the FF achievement display

	{
		ID = "REBEKAH",
		AlwaysUnlocked = true,
		Note = "achievement_rebekah",
		Tags = {"Misc"},
		NoInsertTags = {"Misc"},
		Tooltip = {"t- t- t- t-", "thanks", "for playing!"}
	},

	-- Character Unlocks
    {
		ID = "REBEKAH_SOUL",
		Note = "achievement_soul_personality",
		Name = "rebekah the aloof",
		Tags = {"Rebekah Character"},
		--NoInsertTags = {"Rebekah Character"},
		Tooltip = {"unlock by", "defeating", "mom as rebekah"}
	},
    {
		ID = "REBEKAH_EVIL",
		Note = "achievement_evil_personality",
		Name = "rebekah the mischevious",
		Tags = {"Rebekah Character"},
		--NoInsertTags = {"Rebekah Character"},
		Tooltip = {"unlock by", "having", "6 evil hearts", "as any", "character"}
	},
	{
		ID = "REBEKAH_ETERNAL",
		Note = "achievement_evil_personality",
		Name = "rebekah the kind",
		Tags = {"Rebekah Character"},
		--NoInsertTags = {"Rebekah Character"},
		Tooltip = {"unlock by", "completing an", "eternal heart", "in one floor"}
	},
	{
		ID = "REBEKAH_IMMORTAL",
		Note = "achievement_evil_personality",
		Name = "rebekah the guardian",
		Tags = {"Rebekah Character"},
		--NoInsertTags = {"Rebekah Character"},
		Tooltip = {"unlock by", "holding holy", "mantle and", "wooden cross"}
	},
	{
		ID = "REBEKAH_GOLD",
		Note = "achievement_evil_personality",
		Name = "rebekah the royal",
		Tags = {"Rebekah Character"},
		--NoInsertTags = {"Rebekah Character"},
		Tooltip = {"unlock by", "holding", "a gold heart", "in two floors"}
	},
	{
		ID = "REBEKAH_BONE",
		Note = "achievement_evil_personality",
		Name = "rebekah the weird",
		Tags = {"Rebekah Character"},
		--NoInsertTags = {"Rebekah Character"},
		Tooltip = {"unlock by", "having", "3 bone hearts", "as rebekah"}
	},
	{
		ID = "REBEKAH_ROTTEN",
		Note = "achievement_evil_personality",
		Name = "rebekah the crazy",
		Tags = {"Rebekah Character"},
		--NoInsertTags = {"Rebekah Character"},
		Tooltip = {"unlock by", "holding 3", "rotten hearts", "as rebekah"}
	},
	{
		ID = "REBEKAH_BROKEN",
		Note = "achievement_evil_personality",
		Name = "rebekah the aware",
		Tags = {"Rebekah Character"},
		--NoInsertTags = {"Rebekah Character"},
		Tooltip = {"unlock by", "holding", "3 rotten hearts", "as rebekah"}
	},

    --Normal Rebekah Unlocks
    {
		ID = "TIGHT_HAIRTIE",
		Note = "achievement_tight_hairtie",
        Item = RebekahCurseItems.COLLECTIBLE_TIGHTHAIRTIE,
		Tooltip = {"beat", "mom", "as any rebekah"},
		Tags = {"Rebekah", "Character"}
	},
	{
		ID = "LUNCHBOX",
		Note = "achievement_lunchbox",
		Name = "a lunchbox",
		Item = RebekahCurseItems.COLLECTIBLE_LUNCHBOX,
		Tooltip = {"beat", "boss rush", "as any rebekah"},
		CompletionMark = {RebekahCurse.TECHNICAL_REB, "BossRush"},
		Tags = {"Rebekah", "Character"}
	},
    {
		ID = "MIRACULOUS_WOMB",
		Note = "achievement_miraculous_womb",
		Item = RebekahCurseItems.COLLECTIBLE_MIRACULOUSWOMB,
		Tooltip = {"beat", "mom's heart", "on hard", "as any rebekah"},
		CompletionMark = {RebekahCurse.TECHNICAL_REB, "Heart"},
		Tags = {"Rebekah", "Character"}
	},
    {
		ID = "CURSED_SPOON",
		Note = "achievement_cursed_spoon",
		Item = RebekahCurseItems.COLLECTIBLE_CURSEDSPOON,
		Tooltip = {"beat", "satan", "as any rebekah"},
		CompletionMark = {RebekahCurse.TECHNICAL_REB, "Satan"},
		Tags = {"Rebekah", "Character"}
	},
	{
		ID = "DICE_OF_FATE",
		Note = "achievement_dice_of_fate",
		Item = RebekahCurseItems.COLLECTIBLE_DICEOFFATE,
		Tooltip = {"beat", "isaac", "as any rebekah"},
		CompletionMark = {RebekahCurse.TECHNICAL_REB, "Isaac"},
		Tags = {"Rebekah", "Character"}
	},
	{
		ID = "ISAACS_LOCKS",
		Note = "achievement_isaacs_locks",
		Trinket = RebekahCurseTrinkets.TRINKET_ISAACSLOCKS,
		Tooltip = {"beat", "???", "as any rebekah"},
		CompletionMark = {RebekahCurse.TECHNICAL_REB, "BlueBaby"},
		Tags = {"Rebekah", "Character"}
	},
	{
		ID = "ETERNAL_BOND",
		Note = "achievement_eternal_bond",
		Item = RebekahCurseItems.COLLECTIBLE_ETERNALBOND,
		Tooltip = {"beat", "satan", "as any rebekah"},
		CompletionMark = {RebekahCurse.TECHNICAL_REB, "Lamb"},
		Tags = {"Rebekah", "Character"}
	},
	{
		ID = "LOVE_POWER",
		Note = "achievement_love_power",
		Item = RebekahCurseItems.COLLECTIBLE_POWERLOVE,
		Tooltip = {"beat", "ultra greed", "as any rebekah"},
		CompletionMark = {RebekahCurse.TECHNICAL_REB, "Greed"},
		Tags = {"Rebekah", "Character"}
	},
	{
		ID = "REBEKAHS_CAMERA",
		Note = "achievement_rebekahs_camera",
		Item = RebekahCurseItems.COLLECTIBLE_REBEKAHSCAMERA,
		Tooltip = {"beat", "ultra greedier", "as any rebekah"},
		CompletionMark = {RebekahCurse.TECHNICAL_REB, "Greedier"},
		Tags = {"Rebekah", "Character"}
	},
	{
		ID = "TYPICAL_ROMCOM",
		Note = "achievement_typical_romcom",
		Item = RebekahCurseItems.COLLECTIBLE_ROMCOM,
		Tooltip = {"beat", "hush", "as any rebekah"},
		CompletionMark = {RebekahCurse.TECHNICAL_REB, "Hush"},
		Tags = {"Rebekah", "Character"}
	},
	{
		ID = "WIKEPIDIA",
		Note = "achievement_wikepidia",
		Item = RebekahCurseItems.COLLECTIBLE_WIKEPIDIA,
		Tooltip = {"beat", "delirium", "as any rebekah"},
		CompletionMark = {RebekahCurse.TECHNICAL_REB, "Delirium"},
		Tags = {"Rebekah", "Character"}
	},
	

	--[[{
		ID = "FIEND",
		AlwaysUnlocked = true,
		Note = "achievement_fiend",
		Name = "fiend",
		Tags = {"Fiend"},
		NoInsertTags = {"Fiend"},
		Tooltip = {"the iconic", "trickster", "returns"}
	},
	{
		ID = "GOLEM",
		AlwaysUnlocked = true,
		Note = "achievement_golem",
		Name = "golem",
		Tags = {"Golem"},
		NoInsertTags = {"Golem"},
		Tooltip = {"the mother", "orb's riddle", "was finally", "cracked!"}
	},
	{
		ID = "BIEND", -- used for save data and code access, don't change!
		Note = "achievement_fiendb",
		Name = "tainted fiend",
		Tooltip = {"open a", "certain closet", "as fiend"},
		Tags = {"BiendUnlock", "Character", "Biend"},
		NoInsertTags = {"Biend"}
	},

	-- Fiend Unlocks
	{
		ID = "IMMORAL_HEART",
		Note = "immoral_heart",
		Tooltip = {"beat", "mom", "as fiend"},
		Tags = {"Fiend", "Character"}
	},
	{
		ID = "LIL_FIEND",
		Note = "lil_fiend",
		Item = yandereWaifu.ITEM.COLLECTIBLE.LIL_FIEND,
		Tooltip = {"beat", "mom's heart", "on hard", "as fiend"},
		CompletionMark = {yandereWaifu.PLAYER.FIEND, "Heart"},
		Tags = {"Fiend", "Character"}
	},
	{
		ID = "IMP_SODA",
		Note = "imp_soda",
		Item = yandereWaifu.ITEM.COLLECTIBLE.IMP_SODA,
		Tooltip = {"beat", "isaac", "as fiend"},
		CompletionMark = {yandereWaifu.PLAYER.FIEND, "Isaac"},
		Tags = {"Fiend", "Character"}
	},
	{
		ID = "HEART_OF_CHINA",
		Note = "heart_of_china",
		Item = yandereWaifu.ITEM.COLLECTIBLE.HEART_OF_CHINA,
		Tooltip = {"beat", "???", "as fiend"},
		CompletionMark = {yandereWaifu.PLAYER.FIEND, "BlueBaby"},
		Tags = {"Fiend", "Character"}
	},
	{
		ID = "FIEND_MIX",
		Note = "fiend_mix",
		Item = yandereWaifu.ITEM.COLLECTIBLE.FIEND_MIX,
		Tooltip = {"beat", "satan", "as fiend"},
		CompletionMark = {yandereWaifu.PLAYER.FIEND, "Satan"},
		Tags = {"Fiend", "Character"}
	},
	{
		ID = "PRANK_COOKIE",
		Note = "prank_cookie",
		Item = yandereWaifu.ITEM.COLLECTIBLE.PRANK_COOKIE,
		Tooltip = {"beat", "the lamb", "as fiend"},
		CompletionMark = {yandereWaifu.PLAYER.FIEND, "Lamb"},
		Tags = {"Fiend", "Character"}
	},
	{
		ID = "GMO_CORN",
		Note = "gmo_corn",
		Item = yandereWaifu.ITEM.COLLECTIBLE.GMO_CORN,
		Tooltip = {"beat", "boss rush", "as fiend"},
		CompletionMark = {yandereWaifu.PLAYER.FIEND, "BossRush"},
		Tags = {"Fiend", "Character"}
	},
	{
		ID = "PLUS_3_FIREBALLS",
		Note = "3_fireballs",
		Card = yandereWaifu.ITEM.CARD.PLUS_3_FIREBALLS,
		Name = "+3 fireballs",
		Tooltip = {"beat", "hush", "as fiend"},
		CompletionMark = {yandereWaifu.PLAYER.FIEND, "Hush"},
		Tags = {"Fiend", "Character"}
	},
	{
		ID = "FIENDS_HORN",
		Note = "fiends_horn",
		Item = yandereWaifu.ITEM.COLLECTIBLE.FIENDS_HORN,
		Name = "fiend's horn",
		Tooltip = {"beat", "delirium", "as fiend"},
		CompletionMark = {yandereWaifu.PLAYER.FIEND, "Delirium"},
		Tags = {"Fiend", "Character"}
	},
	{
		ID = "PYROMANCY",
		Note = "pyromancy",
		Item = yandereWaifu.ITEM.COLLECTIBLE.PYROMANCY,
		Tooltip = {"beat", "mega satan", "as fiend"},
		CompletionMark = {yandereWaifu.PLAYER.FIEND, "MegaSatan"},
		Tags = {"Fiend", "Character"}
	},
	{
		ID = "DEVILS_HARVEST",
		Note = "the_devils_harvest",
		Item = yandereWaifu.ITEM.COLLECTIBLE.DEVILS_HARVEST,
		Name = "the devil's harvest",
		Tooltip = {"beat", "mother", "as fiend"},
		CompletionMark = {yandereWaifu.PLAYER.FIEND, "Mother"},
		Tags = {"Fiend", "Character"}
	},
	{
		ID = "FETAL_FIEND",
		Note = "fetal_fiend",
		Item = yandereWaifu.ITEM.COLLECTIBLE.FETAL_FIEND,
		Tooltip = {"beat", "beast", "as fiend"},
		CompletionMark = {yandereWaifu.PLAYER.FIEND, "Beast"},
		Tags = {"Fiend", "Character"}
	},
	{
		ID = "COOL_SUNGLASSES",
		Note = "cool_sunglasses",
		Item = yandereWaifu.ITEM.COLLECTIBLE.COOL_SUNGLASSES,
		Tooltip = {"beat", "greed mode", "as fiend"},
		CompletionMark = {yandereWaifu.PLAYER.FIEND, "Greed"},
		Tags = {"Fiend", "Character"}
	},
	{
		ID = "JACK_CARDS",
		Note = "jack_cards",
		Card = {
			yandereWaifu.ITEM.CARD.JACK_OF_CLUBS,
			yandereWaifu.ITEM.CARD.MISPRINTED_JACK_OF_CLUBS,
			yandereWaifu.ITEM.CARD.JACK_OF_DIAMONDS,
			yandereWaifu.ITEM.CARD.JACK_OF_HEARTS,
			yandereWaifu.ITEM.CARD.JACK_OF_SPADES
		},
		Tooltip = {"beat", "greedier mode", "as fiend"},
		CompletionMark = {yandereWaifu.PLAYER.FIEND, "Greedier"},
		Tags = {"Fiend", "Character"}
	},
	{
		ID = "FIEND_FOLIO",
		Note = "yandereWaifu",
		Item = yandereWaifu.ITEM.COLLECTIBLE.FIEND_FOLIO,
		Name = "fiend folio",
		Tooltip = {"beat", "everything", "on hard", "as fiend"},
		CompletionMark = {yandereWaifu.PLAYER.FIEND, "All"},
		Tags = {"Fiend", "Character"}
	},

	-- Biend Unlocks
	{
		ID = "CHUNK_OF_TAR",
		Note = "chunk_of_tar",
		Trinket = yandereWaifu.ITEM.TRINKET.CHUNK_OF_TAR,
		Tooltip = {"beat isaac,", "???, satan", "and the lamb", "as tainted", "fiend"},
		CompletionMark = {yandereWaifu.PLAYER.BIEND, "Quartet"},
		Tags = {"Biend", "Character"}
	},
	{
		ID = "SOUL_OF_FIEND",
		Note = "soul_of_fiend",
		Card = yandereWaifu.ITEM.CARD.SOUL_OF_FIEND,
		Tooltip = {"beat boss", "rush and hush", "as tainted", "fiend"},
		CompletionMark = {yandereWaifu.PLAYER.BIEND, "Duet"},
		Tags = {"Biend", "Character"}
	},
	{
		ID = "GOLDEN_SLOT_MACHINE",
		Note = "golden_slot_machine",
		Tooltip = {"beat", "mega satan", "as tainted", "fiend"},
		CompletionMark = {yandereWaifu.PLAYER.BIEND, "MegaSatan"},
		Tags = {"Biend", "Character"}
	},
	{
		ID = "REVERSE_3_FIREBALLS",
		Note = "3_fireballs_evil",
		Card = yandereWaifu.ITEM.CARD.REVERSE_3_FIREBALLS,
		Name = "reverse +3 fireballs",
		Tooltip = {"beat", "greedier mode", "as tainted", "fiend"},
		CompletionMark = {yandereWaifu.PLAYER.BIEND, "Greedier"},
		Tags = {"Biend", "Character"}
	},
	{
		ID = "MALICE",
		Note = "malice",
		Item = yandereWaifu.ITEM.COLLECTIBLE.MALICE,
		Tooltip = {"beat", "delirium", "as tainted", "fiend"},
		CompletionMark = {yandereWaifu.PLAYER.BIEND, "Delirium"},
		Tags = {"Biend", "Character"}
	},
	{
		ID = "HATRED",
		Note = "hatred",
		Trinket = yandereWaifu.ITEM.TRINKET.HATRED,
		Tooltip = {"beat", "mother", "as tainted", "fiend"},
		CompletionMark = {yandereWaifu.PLAYER.BIEND, "Mother"},
		Tags = {"Biend", "Character"}
	},
	{
		ID = "MODERN_OUROBOROS",
		Note = "modern_ouroboros",
		Item = yandereWaifu.ITEM.COLLECTIBLE.MODERN_OUROBOROS,
		Tooltip = {"beat", "beast", "as tainted", "fiend"},
		CompletionMark = {yandereWaifu.PLAYER.BIEND, "Beast"},
		Tags = {"Biend", "Character"}
	},

	-- Golem Unlocks
	{
		ID = "PET_ROCK",
		Note = "pet_rock",
		Item = yandereWaifu.ITEM.COLLECTIBLE.PET_ROCK,
		Tooltip = {"beat", "mom's heart", "on hard", "as golem"},
		CompletionMark = {yandereWaifu.PLAYER.GOLEM, "Heart"},
		Tags = {"Golem", "Character"}
	},
	{
		ID = "GOLEMS_ROCK",
		Note = "golems_rock",
		Item = yandereWaifu.ITEM.COLLECTIBLE.GOLEMS_ROCK,
		Name = "golem's rock",
		Tooltip = {"beat", "isaac", "as golem"},
		CompletionMark = {yandereWaifu.PLAYER.GOLEM, "Isaac"},
		Tags = {"Golem", "Character"}
	},
	{
		ID = "GOLEMS_ORB",
		Note = "golems_orb",
		Item = yandereWaifu.ITEM.COLLECTIBLE.GOLEMS_ORB,
		Name = "golem's orb",
		Tooltip = {"beat", "???", "as golem"},
		CompletionMark = {yandereWaifu.PLAYER.GOLEM, "BlueBaby"},
		Tags = {"Golem", "Character"}
	},
	{
		ID = "CHERRY_BOMB",
		Note = "cherry_bomb",
		Item = yandereWaifu.ITEM.COLLECTIBLE.CHERRY_BOMB,
		Tooltip = {"beat", "satan", "as golem"},
		CompletionMark = {yandereWaifu.PLAYER.GOLEM, "Satan"},
		Tags = {"Golem", "Character"}
	},
	{
		ID = "BRIDGE_BOMBS",
		Note = "bridge_bombs",
		Item = yandereWaifu.ITEM.COLLECTIBLE.BRIDGE_BOMBS,
		Tooltip = {"beat", "the lamb", "as golem"},
		CompletionMark = {yandereWaifu.PLAYER.GOLEM, "Lamb"},
		Tags = {"Golem", "Character"}
	},
	{
		ID = "SOLEMN_VOW",
		Note = "solemn_vow",
		Trinket = yandereWaifu.ITEM.TRINKET.SOLEMN_VOW,
		Tooltip = {"beat", "boss rush", "as golem"},
		CompletionMark = {yandereWaifu.PLAYER.GOLEM, "BossRush"},
		Tags = {"Golem", "Character"}
	},
	{
		ID = "DICE_GOBLIN",
		Note = "dice_goblin",
		Item = yandereWaifu.ITEM.COLLECTIBLE.DICE_GOBLIN,
		Tooltip = {"beat", "hush", "as golem"},
		CompletionMark = {yandereWaifu.PLAYER.GOLEM, "Hush"},
		Tags = {"Golem", "Character"}
	},
	{
		ID = "PERFECTLY_GENERIC_OBJECT",
		Note = "pgo",
		Item = yandereWaifu.ITEM.COLLECTIBLE.PERFECTLY_GENERIC_OBJECT_4,
		Tooltip = {"beat", "delirium", "as golem"},
		CompletionMark = {yandereWaifu.PLAYER.GOLEM, "Delirium"},
		Tags = {"Golem", "Character"}
	},
	{
		ID = "MASSIVE_AMETHYST",
		Note = "massive_amethyst",
		Trinket = yandereWaifu.ITEM.TRINKET.MASSIVE_AMETHYST,
		Tooltip = {"beat", "mega satan", "as golem"},
		CompletionMark = {yandereWaifu.PLAYER.GOLEM, "MegaSatan"},
		Tags = {"Golem", "Character"}
	},
	{
		ID = "ETERNAL_D12",
		Note = "eternal_d12",
		Item = yandereWaifu.ITEM.COLLECTIBLE.ETERNAL_D12,
		Tooltip = {"beat", "mother", "as golem"},
		CompletionMark = {yandereWaifu.PLAYER.GOLEM, "Mother"},
		Tags = {"Golem", "Character"}
	},
	{
		ID = "ASTROPULVIS",
		Note = "astropulvis",
		Item = yandereWaifu.ITEM.COLLECTIBLE.ASTROPULVIS,
		Tooltip = {"beat", "beast", "as golem"},
		CompletionMark = {yandereWaifu.PLAYER.GOLEM, "Beast"},
		Tags = {"Golem", "Character"}
	},
	{
		ID = "MOLTEN_PENNY",
		Note = "molten_penny",
		Trinket = yandereWaifu.ITEM.TRINKET.MOLTEN_PENNY,
		Tooltip = {"beat", "greed mode", "as golem"},
		CompletionMark = {yandereWaifu.PLAYER.GOLEM, "Greed"},
		Tags = {"Golem", "Character"}
	},
	{
		ID = "NYX",
		Note = "nyx",
		Item = yandereWaifu.ITEM.COLLECTIBLE.NYX,
		Tooltip = {"beat", "greedier mode", "as golem"},
		CompletionMark = {yandereWaifu.PLAYER.GOLEM, "Greedier"},
		Tags = {"Golem", "Character"}
	},
	{
		ID = "SNOW_GLOBE",
		Note = "snow_globe",
		Item = yandereWaifu.ITEM.COLLECTIBLE.SNOW_GLOBE,
		Tooltip = {"beat", "everything", "on hard", "as golem"},
		CompletionMark = {yandereWaifu.PLAYER.GOLEM, "All"},
		Tags = {"Golem", "Character"}
	},

	-- Misc Unlocks
	{
		ID = "PURPLE_PUTTY",
		Note = "purple_putty",
		Item = yandereWaifu.ITEM.COLLECTIBLE.PURPLE_PUTTY,
		Tooltip = {"kill", "50 enemies", "with immoral", "minions"},
		Tags = {"Misc"}
	},
	{
		ID = "FIEND_HEART",
		Note = "aehrt",
		Name = ">3",
		Item = yandereWaifu.ITEM.COLLECTIBLE.FIEND_HEART,
		Tooltip = {"have 6 or", "more immoral", "hearts at once"},
		ViewerTooltip = {"have 6 or more immoral hearts", "at once"},
		Tags = {"Misc"},
		ViewerDisplayIf = function()
			return yandereWaifu.ACHIEVEMENT.IMMORAL_HEART:IsUnlocked()
		end,
	},
	{
		ID = "DEVILLED_EGG",
		Note = "devilled_egg",
		Item = yandereWaifu.ITEM.COLLECTIBLE.DEVILLED_EGG,
		Tooltip = {"kill", "greg the egg"},
		Tags = {"Misc"}
	},
	{
		ID = "SKIP_CARD",
		Note = "skip_card",
		Card = yandereWaifu.ITEM.CARD.SKIP_CARD,
		Tooltip = {"skip 20", "rooms"},
		Tags = {"Misc"}
	},
	{
		ID = "ZODIAC_BEGGAR",
		Note = "zodiac_beggar",
		Tooltip = {"enter a", "planetarium"},
		Tags = {"Misc"}
	},
	{
		ID = "FRAUDULENT_FUNGUS",
		Note = "fraudulent_fungus",
		Item = yandereWaifu.ITEM.COLLECTIBLE.FRAUDULENT_FUNGUS,
		Tooltip = {"have 3", "or more", "rotten hearts", "at once"},
		Tags = {"Misc"}
	},
	{
		ID = "EVIL_STICKER",
		Note = "evil_sticker",
		Item = yandereWaifu.ITEM.COLLECTIBLE.EVIL_STICKER,
		Tooltip = {"get the worst", "cursed penny", "payout"},
		Tags = {"Misc"}
	},
	{
		ID = "GOLDEN_CURSED_PENNY",
		Note = "golden_cursed_penny",
		Tooltip = {"pick up 50", "cursed pennies"},
		Tags = {"Misc"}
	},
	{
		ID = "BLACK_LANTERN",
		Note = "black_lantern",
		Item = yandereWaifu.ITEM.COLLECTIBLE.BLACK_LANTERN,
		Tooltip = {"kill", "gravedigger"},
		Tags = {"Misc"}
	},
	{
		ID = "RISKS_REWARD",
		Note = "risks_reward",
		Item = yandereWaifu.ITEM.COLLECTIBLE.RISKS_REWARD,
		Tooltip = {"kill", "psion"},
		Tags = {"Misc"}
	},
	{
		ID = "FLEA_OF_MELTDOWN",
		Note = "flea_of_meltdown",
		Trinket = yandereWaifu.ITEM.TRINKET.FLEA_MELTDOWN,
		Tooltip = {"kill", "meltdown", "3 times"},
		Tags = {"Misc"}
	},
	{
		ID = "FLEA_OF_DELUGE",
		Note = "flea_of_deluge",
		Trinket = yandereWaifu.ITEM.TRINKET.FLEA_DELUGE,
		Tooltip = {"kill", "meltdown", "3 times"},
		Tags = {"Misc"}
	},
	{
		ID = "FLEA_OF_POLLUTION",
		Note = "flea_of_pollution",
		Trinket = yandereWaifu.ITEM.TRINKET.FLEA_POLLUTION,
		Tooltip = {"kill", "pollution", "3 times"},
		Tags = {"Misc"}
	},
	{
		ID = "FLEA_OF_PROPAGANDA",
		Note = "flea_of_propaganda",
		Trinket = yandereWaifu.ITEM.TRINKET.FLEA_PROPAGANDA,
		Tooltip = {"kill", "pollution", "3 times"},
		Tags = {"Misc"}
	},
	{
		ID = "FLEA_CIRCUS",
		Note = "flea_circus",
		Trinket = yandereWaifu.ITEM.TRINKET.FLEA_CIRCUS,
		Tooltip = {"unlock every", "apocalypse", "flea"},
		Tags = {"Misc"}
	},
	{
		ID = "BEAST_BEGGAR",
		Note = "evil_beggar",
		Tooltip = {"kill", "the beast"},
		Tags = {"Misc"}
	},
	{
		ID = "SOUL_OF_RANDOM",
		Note = "soul_of_random",
		Card = yandereWaifu.ITEM.CARD.SOUL_OF_RANDOM,
		Tooltip = {"unlock half", "of all", "soul stones"},
		Tags = {"Misc"}
	},
	{
		ID = "MERN",
		Note = "mern",
		Item = yandereWaifu.ITEM.COLLECTIBLE.CORN_KERNEL,
		Tooltip = {"build a mern"},
		Tags = {"Misc"}
	},
	{
		ID = "BIFURCATED_STARS",
		Note = "bifurcated_stars",
		Trinket = yandereWaifu.ITEM.TRINKET.BIFURCATED_STARS,
		-- Tooltip = {"enter an", "item room", "you skipped", "during ascent"}, -- This quite heavily reads to me like you have to skip an item room during ascent and somehow get back to it
		Tooltip = {"enter an", "ascent item", "room you had", "previously", "skipped"},
		Tags = {"Misc"}
	},
	{
		ID = "DELUXE",
		Note = "the_deluxe",
		Item = yandereWaifu.ITEM.COLLECTIBLE.THE_DELUXE,
		Tooltip = {"unlock every", "type of heart"},
		Tags = {"Misc"}
	},
	{
		ID = "QUEEN_OF_CLUBS",
		Note = "queen_of_clubs",
		Card = yandereWaifu.ITEM.CARD.QUEEN_OF_CLUBS,
		Tooltip = {"kill", "singe"},
		Tags = {"Misc"}
	},
	{
		ID = "THIRTEEN_OF_STARS",
		Note = "13_of_stars",
		Card = yandereWaifu.ITEM.CARD.THIRTEEN_OF_STARS,
		Tooltip = {"chance when", "using a new", "tmtrainer", "item"},
		Tags = {"Misc"},
		Challenge = true,
	},
	{
		ID = "MINOR_ARCANA_KINGS",
		Note = "kings_minor_arcana",
		Card = {
			yandereWaifu.ITEM.CARD.KING_OF_WANDS,
			yandereWaifu.ITEM.CARD.KING_OF_PENTACLES,
			yandereWaifu.ITEM.CARD.KING_OF_SWORDS,
			yandereWaifu.ITEM.CARD.KING_OF_CUPS,
		},
		Tooltip = {"unlock:", "", "horse pills", "gold trinkets", "gold batteries"},
		ViewerTooltip = {"unlock horse pills, gold trinkets,", "and gold batteries"},
		Tags = {"Misc"}
	},
	{
		ID = "KING_OF_DIAMONDS",
		Note = "king_of_diamonds",
		Card = yandereWaifu.ITEM.CARD.KING_OF_DIAMONDS,
		Tooltip = {"blow up", "25 fool's", "gold rocks"},
		Tags = {"Misc"}
	},
	{
		ID = "PLAGUE_OF_DECAY",
		Note = "plague_of_decay",
		Card = yandereWaifu.ITEM.CARD.PLAGUE_OF_DECAY,
		Tooltip = {"bomb a", "rotten beggar"},
		Tags = {"Misc"}
	},
	{
		ID = "IMPLOSION",
		Note = "implosion",
		Card = yandereWaifu.ITEM.CARD.IMPLOSION,
		Tooltip = {"kill 50", "enemies using", "malice's", "fireball"},
		Tags = {"Misc"}
	},
	{
		ID = "SOUL_OF_GOLEM",
		Note = "soul_of_golem",
		Card = yandereWaifu.ITEM.CARD.SOUL_OF_GOLEM,
		Tooltip = {"use any", "soul stone", "as golem"},
		Tags = {"Misc"}
	},
	{
		ID = "GOLDEN_REWARD_PLATE",
		Note = "golden_button",
		Tooltip = {"press 79", "reward plates"},
		Tags = {"Misc"}
	},
	{
		ID = "GLASS_CHEST",
		Note = "glass_chest",
		Tooltip = {"kill a boss", "in the mirror", "dimension"},
		Tags = {"Misc"},
	},
	{
		ID = "HAUNTED_PENNY",
		Note = "haunted_penny",
		Tooltip = {"have 8", "virtues wisps", "at once"},
		Tags = {"Misc"},
	},
	{
		ID = "SHARD_OF_CHINA",
		Note = "shard_of_china",
		Trinket = yandereWaifu.ITEM.TRINKET.SHARD_OF_CHINA,
		Tooltip = {"die as china"},
		Tags = {"Misc"},
		Challenge = true,
	},
	{
		ID = "DIRE_CHEST",
		Note = "dire_chest",
		Trinket = yandereWaifu.ITEM.TRINKET.MIDDLE_HAND,
		-- Tooltip = {"complete the", "brown ritual"},
		Tooltip = {"convert a red", "chest into a", "dire chest", "using the", "secret method", "---------", "or make the", "middle hand"},
		ViewerTooltip = {"convert a red chest into a dire chest", "or make the middle hand"},
		Tags = {"Misc"},
	},
	{
		ID = "52_DECK",
		Note = "52_deck",
		Tooltip = {"trounce the", "poker table", "dealer and", "make him", "ragequit"},
		Tags = {"Misc"},
	},
	{
		ID = "RIGHT_HAND",
		Note = "the_right_hand",
		Trinket = yandereWaifu.ITEM.TRINKET.RIGHT_HAND,
		Tooltip = {"kill ???", "while holding", "the left hand"},
		Tags = {"Misc"},
	},
	{
		ID = "MORBUS",
		Note = "morbus",
		Tooltip = {"enter", "the corpse"},
		Tags = {"Misc"},
		NoMenu = true,
		AlwaysUnlock = true, -- Ignores canAchievementsUnlock and canChallengeAchievementsUnlock
	},
	{
		ID = "MORBID_HEART",
		Note = "morbid_heart",
		Item = {
			yandereWaifu.ITEM.COLLECTIBLE.DADS_DIP,
			yandereWaifu.ITEM.COLLECTIBLE.YICK_HEART,
		},
		Tooltip = {"kill mr dead"},
		Tags = {"Misc"},
	},

	-- Challenge Unlocks
	{
		ID = "SLIPPYS_ORGANS",
		Note = "slippys_organs",
		Name = "slippy's organs",
		Item = {
			yandereWaifu.ITEM.COLLECTIBLE.SLIPPYS_GUTS,
			yandereWaifu.ITEM.COLLECTIBLE.SLIPPYS_HEART,
			yandereWaifu.ITEM.COLLECTIBLE.FROG_HEAD
		},
		Trinket = yandereWaifu.ITEM.TRINKET.FROG_PUPPET,
		Tooltip = {"complete", "frog mode", "---------", "unlocks", "4 items"},
		ViewerTooltip = {"complete frog mode"},
		Tags = {"Challenge"},
		Challenge = true,
	},
	{
		ID = "DEIMOS",
		Note = "deimos",
		Item = yandereWaifu.ITEM.COLLECTIBLE.DEIMOS,
		Tooltip = {"complete", "isaac rebuilt"},
		Tags = {"Challenge"},
		Challenge = true,
	},
	{
		ID = "LAWN_DARTS",
		Note = "lawn_darts",
		Item = yandereWaifu.ITEM.COLLECTIBLE.LAWN_DARTS,
		Tooltip = {"complete", "tower offense"},
		Tags = {"Challenge"},
		Challenge = true,
	},
	{
		ID = "CHINAS_BELONGINGS",
		Note = "chinas_belongings",
		Name = "china's belongings",
		Trinket = {
			yandereWaifu.ITEM.TRINKET.HEARTACHE,
			yandereWaifu.ITEM.TRINKET.CURSED_URN,
		},
		Tooltip = {"complete", "handle with", "care", "---------", "unlocks", "2 items"},
		ViewerTooltip = {"complete handle with care"},
		Tags = {"Challenge"},
		Challenge = true,
	},
	{
		ID = "GAUNTLET_BEATEN",
		Note = "achievement_community",
		Name = "community achievement",
		Item = yandereWaifu.ITEM.COLLECTIBLE.COMMUNITY_ACHIEVEMENT,
		Tooltip = {"complete", "the gauntlet"},
		Tags = {"Challenge"},
		Challenge = true,
	},
	{
		ID = "BRICK_SEPARATOR",
		Note = "brick_seperator",
		Card = yandereWaifu.ITEM.CARD.BRICK_SEPERATOR,
		Tooltip = {"complete", "brick by brick"},
		Tags = {"Challenge"},
		Challenge = true,
	},
	{
		ID = "GREEN_HOUSE",
		Note = "green_house",
		Card = yandereWaifu.ITEM.CARD.GREEN_HOUSE,
		Tooltip = {"complete", "dad's home+"},
		Tags = {"Challenge"},
		Challenge = true,
	},
	{
		ID = "PETRIFIED_GEL",
		Note = "petrified_gel",
		Trinket = yandereWaifu.ITEM.TRINKET.PETRIFIED_GEL,
		Tooltip = {"complete", "dirty bubble", "challenge"},
		Tags = {"Challenge"},
		Challenge = true,
	},
	{
		ID = "SPARE_RIBS",
		Note = "spare_ribs",
		Item = yandereWaifu.ITEM.COLLECTIBLE.SPARE_RIBS,
		Tooltip = {"complete", "the real jon"},
		Tags = {"Challenge"},
		Challenge = true,
	},
	{
		ID = "RED_HAND",
		Note = "red_hand",
		Trinket = yandereWaifu.ITEM.TRINKET.REDHAND,
		Tooltip = {"complete", "hands on"},
		Tags = {"Challenge"},
		Challenge = true,
	},]]

	-- hidden tracker achievements
	{
		ID = "ETERNAL_REWARD_OBTAINED",
		NoMenu = true,
		Challenge = true,
		NoCountCompletion = true
	}
}