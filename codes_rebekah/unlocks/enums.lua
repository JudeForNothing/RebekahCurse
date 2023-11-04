yandereWaifu.ACHIEVEMENT = {
	--taken inspiration from FF to accomodate the FF achievement display

	{
		ID = "REBEKAH",
		AlwaysUnlocked = true,
		Note = "achievement_rebekah",
		Name = "rebekah!",
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
		Note = "achievement_eternal_personality",
		Name = "rebekah the kind",
		Tags = {"Rebekah Character"},
		--NoInsertTags = {"Rebekah Character"},
		Tooltip = {"unlock by", "becoming an", "angel as", "any rebekah"}
	},
	{
		ID = "REBEKAH_IMMORTAL",
		Note = "achievement_immortal_personality",
		Name = "rebekah the guardian",
		Tags = {"Rebekah Character"},
		--NoInsertTags = {"Rebekah Character"},
		Tooltip = {"unlock by", "holding holy", "mantle and", "wooden cross"}
	},
	{
		ID = "REBEKAH_GOLD",
		Note = "achievement_gold_personality",
		Name = "rebekah the royal",
		Tags = {"Rebekah Character"},
		--NoInsertTags = {"Rebekah Character"},
		Tooltip = {"unlock by", "holding", "a gold heart", "in two floors"}
	},
	{
		ID = "REBEKAH_BONE",
		Note = "achievement_bone_personality",
		Name = "rebekah the weird",
		Tags = {"Rebekah Character"},
		--NoInsertTags = {"Rebekah Character"},
		Tooltip = {"unlock by", "holding 3", "bone hearts"}
	},
	{
		ID = "REBEKAH_ROTTEN",
		Note = "achievement_rotten_personality",
		Name = "rebekah the crazy",
		Tags = {"Rebekah Character"},
		--NoInsertTags = {"Rebekah Character"},
		Tooltip = {"unlock by", "holding 3", "rotten hearts"}
	},
	{
		ID = "REBEKAH_BROKEN",
		Note = "achievement_broken_personality",
		Name = "rebekah the aware",
		Tags = {"Rebekah Character"},
		--NoInsertTags = {"Rebekah Character"},
		Tooltip = {"unlock by", "holding 12", "broken hearts"}
	},

	{
		ID = "TAINTED_REBEKAH", -- used for save data and code access, don't change!
		Note = "achievement_rebekahb",
		Name = "tainted rebekah",
		Tooltip = {"open a", "certain closet", "as rebekah"},
		Tags = {"Rebekah Character", "Character", "Rebekah"},
		NoInsertTags = {"Tainted Rebekah"}
	},

    --Normal Rebekah Unlocks
    {
		ID = "TIGHT_HAIRTIE",
		Note = "achievement_tight_hairtie",
		Name = "tight hairtie",
        Item = RebekahCurse.Items.COLLECTIBLE_TIGHTHAIRTIE,
		Tooltip = {"beat", "mom", "as any rebekah"},
		Tags = {"Rebekah", "Character"}
	},
	{
		ID = "LUNCHBOX",
		Note = "achievement_lunchbox",
		Name = "a lunchbox",
		Item = RebekahCurse.Items.COLLECTIBLE_LUNCHBOX,
		Tooltip = {"beat", "boss rush", "as any rebekah"},
		CompletionMark = {RebekahCurse.TECHNICAL_REB, "BossRush"},
		Tags = {"Rebekah", "Character"}
	},
    {
		ID = "MIRACULOUS_WOMB",
		Note = "achievement_miraculous_womb",
		Name = "miraculous womb",
		Item = RebekahCurse.Items.COLLECTIBLE_MIRACULOUSWOMB,
		Tooltip = {"beat", "mom's heart", "on hard", "as any rebekah"},
		CompletionMark = {RebekahCurse.TECHNICAL_REB, "Heart"},
		Tags = {"Rebekah", "Character"}
	},
    {
		ID = "CURSED_SPOON",
		Note = "achievement_cursed_spoon",
		Name = "cursed spoon",
		Item = RebekahCurse.Items.COLLECTIBLE_CURSEDSPOON,
		Tooltip = {"beat", "satan", "as any rebekah"},
		CompletionMark = {RebekahCurse.TECHNICAL_REB, "Satan"},
		Tags = {"Rebekah", "Character"}
	},
	{
		ID = "DICE_OF_FATE",
		Note = "achievement_dice_of_fate",
		Name = "dice of fate",
		Item = RebekahCurse.Items.COLLECTIBLE_DICEOFFATE,
		Tooltip = {"beat", "isaac", "as any rebekah"},
		CompletionMark = {RebekahCurse.TECHNICAL_REB, "Isaac"},
		Tags = {"Rebekah", "Character"}
	},
	{
		ID = "REBEKAHS_ROOM",
		Note = "achievement_rebekahs_room",
		Name = "rebekah's room",
		Tooltip = {"beat", "mega satan", "as any rebekah"},
		CompletionMark = {RebekahCurse.TECHNICAL_REB, "MegaSatan"},
		Tags = {"Rebekah", "Character"}
	},
	{
		ID = "REBEKAHS_KEY",
		Note = "achievement_rebekahs_key",
		Name = "rebekah's key",
		Item = RebekahCurse.Trinkets.TRINKET_REBEKAHSKEY,
		Tooltip = {"beat", "mega satan", "as any rebekah"},
		Tags = {"Rebekah", "Character"}
	},
	{
		ID = "ISAACS_LOCKS",
		Note = "achievement_isaacs_locks",
		Name = "isaac's room",
		Trinket = RebekahCurse.Trinkets.TRINKET_ISAACSLOCKS,
		Tooltip = {"beat", "???", "as any rebekah"},
		CompletionMark = {RebekahCurse.TECHNICAL_REB, "BlueBaby"},
		Tags = {"Rebekah", "Character"}
	},
	{
		ID = "ETERNAL_BOND",
		Note = "achievement_eternal_bond",
		Name = "eternal bond",
		Item = RebekahCurse.Items.COLLECTIBLE_ETERNALBOND,
		Tooltip = {"beat", "satan", "as any rebekah"},
		CompletionMark = {RebekahCurse.TECHNICAL_REB, "Lamb"},
		Tags = {"Rebekah", "Character"}
	},
	{
		ID = "LOVE_POWER",
		Note = "achievement_love_power",
		Name = "love = power",
		Item = RebekahCurse.Items.COLLECTIBLE_POWERLOVE,
		Tooltip = {"beat", "ultra greed", "as any rebekah"},
		CompletionMark = {RebekahCurse.TECHNICAL_REB, "Greed"},
		Tags = {"Rebekah", "Character"}
	},
	{
		ID = "REBEKAHS_CAMERA",
		Note = "achievement_rebekahs_camera",
		Name = "rebekah's camera",
		Item = RebekahCurse.Items.COLLECTIBLE_REBEKAHSCAMERA,
		Tooltip = {"beat", "ultra greedier", "as any rebekah"},
		CompletionMark = {RebekahCurse.TECHNICAL_REB, "Greedier"},
		Tags = {"Rebekah", "Character"}
	},
	{
		ID = "TYPICAL_ROMCOM",
		Note = "achievement_typical_romcom",
		Name = "typical rom com",
		Item = RebekahCurse.Items.COLLECTIBLE_ROMCOM,
		Tooltip = {"beat", "hush", "as any rebekah"},
		CompletionMark = {RebekahCurse.TECHNICAL_REB, "Hush"},
		Tags = {"Rebekah", "Character"}
	},
	{
		ID = "WIKEPIDIA",
		Note = "achievement_wikipedia",
		Name = "wikipedia",
		Item = RebekahCurse.Items.COLLECTIBLE_WIKEPIDIA,
		Tooltip = {"beat", "delirium", "as any rebekah"},
		CompletionMark = {RebekahCurse.TECHNICAL_REB, "Delirium"},
		Tags = {"Rebekah", "Character"}
	},
	{
		ID = "MOMS_BLESSING",
		Note = "achievement_moms_blessing",
		Name = "mom's blessing",
		Item = RebekahCurse.Trinkets.TRINKET_MOMSBLESSING,
		Tooltip = {"beat", "mother", "as any rebekah"},
		CompletionMark = {RebekahCurse.TECHNICAL_REB, "Mother"},
		Tags = {"Rebekah", "Character"}
	},
	{
		ID = "TWIN_VISION",
		Note = "achievement_twin_vision",
		Name = "twin vision",
		Item = RebekahCurse.Items.COLLECTIBLE_TWINVISION,
		Tooltip = {"beat", "beast", "as any rebekah"},
		CompletionMark = {RebekahCurse.TECHNICAL_REB, "Beast"},
		Tags = {"Rebekah", "Character"}
	},
	{
		ID = "UNREQUITED_LOVE",
		Note = "achievement_unrequited_love",
		Name = "unrequited love",
		Tooltip = {"do all basic", "rebekah unlocks"},
		Tags = {"Rebekah", "Character"}
	},
	
	-- Challenge Unlocks
	{
		ID = "TRUE_FAMILY_GUY",
		Note = "achievement_twin_vision",
		Name = "true family guy",
		--Item = RebekahCurse.Items.COLLECTIBLE_TWINVISION,
		Tooltip = {"complete", "true family", "guy"},
		ViewerTooltip = {"complete true family guy"},
		Tags = {"Challenge"},
		Challenge = true,
	},
	{
		ID = "IDENTITY_CRISIS",
		Note = "achievement_body_dysmorphia",
		Name = "identity crisis",
		Item = RebekahCurse.Items.COLLECTIBLE_BODYDYSMORHIA,
		Tooltip = {"complete", "identity crisis"},
		ViewerTooltip = {"complete identity crisis"},
		Tags = {"Challenge"},
		Challenge = true,
	},
	{
		ID = "EASTER_HUNT",
		Note = "achievement_surprise_ovum",
		Name = "easter hunt",
		Item = {
			RebekahCurse.Items.COLLECTIBLE_BASKETOFEGGS,
			RebekahCurse.Items.COLLECTIBLE_EGGSHELLWALK,
		},
		Trinket = RebekahCurse.Trinkets.TRINKET_RABBITSFOOT,
		Tooltip = {"complete", "easter hunt"},
		ViewerTooltip = {"complete easter hunt"},
		Tags = {"Challenge"},
		Challenge = true,
	},
	{
		ID = "OLD_MAID",
		Note = "achievement_deborah_stuff",
		Name = "old maid",
		Item = {
			RebekahCurse.Items.COLLECTIBLE_UNDERPAY,
			RebekahCurse.Items.COLLECTIBLE_MILKWINE,
			RebekahCurse.Items.COLLECTIBLE_SKIMMEDMILK,
			RebekahCurse.Items.COLLECTIBLE_SILENTTREATMENT,
			RebekahCurse.Items.COLLECTIBLE_SILENCER,
			RebekahCurse.Items.COLLECTIBLE_FULLFATMILK,
		},
		Trinket = {
			RebekahCurse.Trinkets.TRINKET_NOSCOPE,
			RebekahCurse.Trinkets.TRINKET_DEBORAHSDEADEYE,
		},
		Tooltip = {"complete", "old maid"},
		ViewerTooltip = {"complete old maid"},
		Tags = {"Challenge"},
		Challenge = true,
	},
	-- Misc
	{
		ID = "NOTEBOOK_OF_THE_DEAD",
		Note = "achievement_notebook_of_the_dead",
		Name = "notebook of the dead",
		Item = {
			RebekahCurse.Items.COLLECTIBLE_NOTEBOOKOFTHEDEAD,
		},
		Tooltip = {"obtain potato", "snack for the", "first time"},
		ViewerTooltip = {"obtain potato snack for the first time"},
		Tags = {"Misc"},
	},
	{
		ID = "WICKED_WEAVES",
		Note = "achievement_wicked_weaves",
		Name = "wicked weaves",
		Item = {
			RebekahCurse.Items.COLLECTIBLE_WICKEDWEAVES,
		},
		Tooltip = {"get 3 evil hearts", "as any rebekah"},
		ViewerTooltip = {"get 3 evil hearts as any rebekah"},
		Tags = {"Misc"},
	},
	{
		ID = "OH_IM_DIE",
		Note = "achievement_defuse_rewards",
		Name = "defuse = rewards",
		Item = {
			RebekahCurse.Items.COLLECTIBLE_OHIMDIE,
		},
		Tooltip = {"defeat poltygeist", "with any explosion"},
		ViewerTooltip = {"defeat poltygeist with any explosion"},
		Tags = {"Misc"},
	},
	{
		ID = "HEARTS_AND_CRAFTS",
		Note = "achievement_hearts_and_crafts",
		Name = "hearts and crafts",
		Item = {
			RebekahCurse.Items.COLLECTIBLE_HEARTSANDCRAFTS,
		},
		Tooltip = {"enter rebekahs", "room for the", "first time"},
		ViewerTooltip = {"enter rebekahs room for the first time"},
		Tags = {"Misc"},
	},
	{
		ID = "CHEESY_PIZZA",
		Note = "achievement_cheesy_pizza",
		Name = "cheesy pizza",
		Item = {
			RebekahCurse.Items.COLLECTIBLE_CHEESYPIZZA,
		},
		Tooltip = {"have tomato", "sausage and anything", "bread or milk"},
		ViewerTooltip = {"have tomato, sausage, and anything bread or milk"},
		Tags = {"Misc"},
	},
	{
		ID = "OVERSIZED_SWEATER",
		Note = "achievement_oversized_sweater",
		Name = "oversized sweater",
		Item = {
			RebekahCurse.Items.COLLECTIBLE_OVERSIZEDSWEATER,
		},
		Tooltip = {"get hurt", "with self-harm", "as rebekah"},
		ViewerTooltip = {"get hurt with self-harm as rebekah"},
		Tags = {"Misc"},
	},
	{
		ID = "PSORAISIS",
		Note = "achievement_psoraisis",
		Name = "psoraisis",
		Item = {
			RebekahCurse.Items.COLLECTIBLE_PSORAISIS,
		},
		Tooltip = {"die as", "tainted rebekah"},
		ViewerTooltip = {"gdie as tainted rebekah"},
		Tags = {"Misc"},
	},
	{
		ID = "FENRIRS_COLLAR",
		Note = "achievement_fenrirs_collar",
		Name = "fenrir's collar",
		Item = {
			RebekahCurse.Items.COLLECTIBLE_FENRIRSLEASH,
		},
		Tooltip = {"collect at", "least 3", "fenrir items"},
		ViewerTooltip = {"collect at least 3 fenrir items"},
		Tags = {"Misc"},
	},
	--[[{
		ID = "NARCOLEPSY",
		Note = "achievement_narcolepsy",
		Name = "narcolepsy",
		Item = {
			RebekahCurse.Items.COLLECTIBLE_NARCOLEPSY,
		},
		Tooltip = {"sleep in", "rebekahs bed"},
		ViewerTooltip = {"sleep in rebekahs bed"},
		Tags = {"Misc"},
	},]]
	{
		ID = "HEARTACHES",
		Note = "achievement_heartaches",
		Name = "heartaches...",
		Item = {
			RebekahCurse.Items.COLLECTIBLE_HEARTACHES,
		},
		Tooltip = {"die as", "rebekah the", "aware"},
		ViewerTooltip = {"die as rebekah the aware"},
		Tags = {"Misc"},
	},
	{
		ID = "GIDDY_UP",
		Note = "achievement_giddy_up",
		Name = "giddy up",
		Item = {
			RebekahCurse.Items.COLLECTIBLE_GIDDYUP,
		},
		Tooltip = {"destroy", "prospector's", "grimace"},
		ViewerTooltip = {"destroy prospector's grimace"},
		Tags = {"Misc"},
		ViewerDisplayIf = function()
			return yandereWaifu.ACHIEVEMENT.GIDDY_UP:IsUnlocked()
		end,
	},
	{
		ID = "CUTIE_PATOOTIE",
		Note = "achievement_cutie_patootie",
		Name = "cutie patootie",
		Item = {
			RebekahCurse.Items.COLLECTIBLE_CUTIEPATOOTIE,
		},
		Tooltip = {"blow up", "a mirror in", "rebekah's room"},
		ViewerTooltip = {"blow up a mirror in rebekah's room"},
		Tags = {"Misc"},
		ViewerDisplayIf = function()
			return yandereWaifu.ACHIEVEMENT.CUTIE_PATOOTIE:IsUnlocked()
		end,
	},

	--t rebekah unlocks
	{
		ID = "REBEKAHS_SCRAPBOOK",
		Note = "achievement_rebekahs_scrapbook",
		Name = "rebekahs scrapbook",
		Item = RebekahCurse.Items.COLLECTIBLE_REBEKAHSSCRAPBOOK,
		Tooltip = {"beat isaac,", "???, satan", "and the lamb", "as tainted", "rebekah"},
		CompletionMark = {RebekahCurse.SADREBEKAH, "Quartet"},
		Tags = {"Tainted Rebekah", "Character"}
	},
	{

		ID = "SOUL_OF_REBEKAH",
		Note = "achievement_rebekahs_soul",
		Name = "soul of rebekah",
		Card = {
			RebekahCurse.Cards.SOUL_REBEKAHNORMAL,
			RebekahCurse.Cards.SOUL_REBEKAHBLIND,
   			RebekahCurse.Cards.SOUL_REBEKAHDARKNESS,
    		RebekahCurse.Cards.SOUL_REBEKAHLABYRINTH,
    		RebekahCurse.Cards.SOUL_REBEKAHLOST,
    		RebekahCurse.Cards.SOUL_REBEKAHUNKNOWN,
    		RebekahCurse.Cards.SOUL_REBEKAHMAZE,
		},
		Tooltip = {"beat boss", "rush and hush", "as tainted", "rebekah"},
		CompletionMark = {RebekahCurse.SADREBEKAH, "Duet"},
		Tags = {"Tainted Rebekah", "Character"}
	},
	{
		ID = "REBEKAHS_STUDIO",
		Note = "achievement_rebekahs_studio",
		Name = "rebekahs studio",
		Tooltip = {"beat", "mega satan", "as tainted", "rebekah"},
		CompletionMark = {RebekahCurse.SADREBEKAH, "MegaSatan"},
		Tags = {"Tainted Rebekah", "Character"}
	},
	{
		ID = "LABANS_SHOP",
		Note = "achievement_labans_shop",
		Name = "labans_shop",
		Tooltip = {"beat", "greedier mode", "as tainted", "rebekah"},
		CompletionMark = {RebekahCurse.SADREBEKAH, "Greedier"},
		Tags = {"Tainted Rebekah", "Character"}
	},
	{
		ID = "WISHFUL_THINKING",
		Note = "achievement_wishful_thinking",
		Name = "wishful thinking",
		Item = RebekahCurse.Items.COLLECTIBLE_WISHFULTHINKING,
		Tooltip = {"beat", "delirium", "as tainted", "rebekah"},
		CompletionMark = {RebekahCurse.SADREBEKAH, "Delirium"},
		Tags = {"Tainted Rebekah", "Character"}
	},
	{
		ID = "5_LANGUAGES_OF_LOVE",
		Note = "achievement_5_languages_of_love",
		Card = {
			RebekahCurse.Cards.CARD_QUALITYTIME,
			RebekahCurse.Cards.CARD_ACTOFSERVICE,
			RebekahCurse.Cards.CARD_GIFTGIVING,
			RebekahCurse.Cards.CARD_PHYSICALTOUCH,
			RebekahCurse.Cards.CARD_WORDSOFAFFIRMATION,
		},
		Name = "5 languages of love",
		Tooltip = {"beat", "mother", "as tainted", "rebekah"},
		CompletionMark = {RebekahCurse.SADREBEKAH, "Mother"},
		Tags = {"Tainted Rebekah", "Character"}
	},
	{
		ID = "JACOBS_TEARS",
		Note = "achievement_jacobs_tears",
		Name = "jacobs tears",
		Item =  RebekahCurse.Items.JACOBS_TEARS,
		Tooltip = {"beat", "beast", "as tainted", "rebekah"},
		CompletionMark = {RebekahCurse.SADREBEKAH, "Beast"},
		Tags = {"Tainted Rebekah", "Character"}
	},

}