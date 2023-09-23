
if EID then
	EID:setModIndicatorName("Rebekah: Cursed and Heartbroken")
	EID:setModIndicatorIcon("Heart")
    -- EID items
	EID:addCollectible(RebekahCurse.Items.COLLECTIBLE_CANDYWEDDINGRING, "On pickup, gains 0.2 speed and one heart")
	EID:addCollectible(RebekahCurse.Items.COLLECTIBLE_LOVEDELUXE, "After releasing the fire keys after holding for more than 2 seconds unleashes a hait whip#Hair damage is 2.5 damage per frame#Does not scale of Isaac's Damage")
	EID:addCollectible(RebekahCurse.Items.COLLECTIBLE_GREATPHEONIX, "Every 30 shots fired, spawn two random locusts")
	
	EID:addCollectible(RebekahCurse.Items.COLLECTIBLE_DOORSTOPPER, "On use, aim to throw a giant book which deals 7.5 damage on landing# Deals 2.5 damage while flying in air #Get close to book in the floor to pick it up")
	EID:addCollectible(RebekahCurse.Items.COLLECTIBLE_FINGERFINGER, "Enemies killed spawn a finger familiar, which surrounds and deal damage to the first enemy you damaged in the room until death")
	EID:addCollectible(RebekahCurse.Items.COLLECTIBLE_MORIAHDIARY, "Enemies and projectiles show a visual line on where they might go # Using the item also unlocks hitboxes and warning")
	EID:addCollectible(RebekahCurse.Items.COLLECTIBLE_THESHINING, "On use, all doors in the room bleed with creep, blood tears and end with brimstone # Tears and brimstone follow your tearflags")
	EID:addCollectible(RebekahCurse.Items.COLLECTIBLE_TWINVISION, "On new floor, spawns two invulnerable clones of you # Clones disappear on your damage")
	EID:addCollectible(RebekahCurse.Items.COLLECTIBLE_NUTWATER, "On pickup, drops a heart based on your character + DMG + Speed")
	EID:addCollectible(RebekahCurse.Items.COLLECTIBLE_ABEAUTIFULGRAVE, "Gain a familiar that shoots fear tears # When an enemy is feared, he grabs them # If boss, he damages them, else he kills them instantly")
	EID:addCollectible(RebekahCurse.Items.COLLECTIBLE_OHIMDIE, "When charged, a familiar ticks and shows a color order for you to defuse # Rewards dropped are exactly a locked chest # Failure to defuse on time or doing 3 mistakes blows you up # Difficuty spikes up the more successes you have by shorter timer and explosion damage")
	EID:addCollectible(RebekahCurse.Items.COLLECTIBLE_REBEKAHSCAMERA, "Captures enemies in room on first use, respawns them as charmed on second use")
	EID:addCollectible(RebekahCurse.Items.COLLECTIBLE_LUNCHBOX, "On pickup, drops 3 random hearts")
	EID:addCollectible(RebekahCurse.Items.COLLECTIBLE_MIRACULOUSWOMB, "On pickup, adds an orbital of Jacob and Esau#Jacob Familiar has less damage but shoots slighly faster # Esau Familiar shoots less but has more damage")
	EID:addCollectible(RebekahCurse.Items.COLLECTIBLE_DICEOFFATE, "Use to reroll any pedestal into any heart based item")
	EID:addCollectible(RebekahCurse.Items.COLLECTIBLE_SNAP, "On hurt, gain buffs # After next room, gain debuff until next room")
	EID:addCollectible(RebekahCurse.Items.COLLECTIBLE_ETERNALBOND, "Spawns a Tiny Isaac and Tiny Rebekah# Both types of familiars shoot tears at enemies# Rebekah can burst tears similar to Red Personality's {{Collectible"..RebekahCurse.Items.COLLECTIBLE_LOVECANNON .."}} # Rebekah can pick up heart pickups and drop certain hearts # Isaac can pick up coins and drop various rewards")
	EID:addCollectible(RebekahCurse.Items.COLLECTIBLE_LOVESICK, "Tears are replaced by charming notes # Charging your fire keys shoots a ring of tears around Isaac with weak knockback")
	EID:addCollectible(RebekahCurse.Items.COLLECTIBLE_POWERLOVE, "Each filled half red heart gives 0.50 damage# Each empty half red heart gives 0.10 speed")
	EID:addCollectible(RebekahCurse.Items.COLLECTIBLE_ROMCOM, "Gives every vulnerable enemy the Laughing effect # Laughing effect disables the ability to shoot projectiles")
	EID:addCollectible(RebekahCurse.Items.COLLECTIBLE_CURSEDSPOON, "On hurt, spawns a Mom's Shadow-esque entity which only deals contact damage to both enemies and Isaac when she dashes")
	EID:addCollectible(RebekahCurse.Items.COLLECTIBLE_PATRIARCHSLIAR, "Occasionally spawns a giant fist punching at your direction from a wall # Damages enemies")
	EID:addCollectible(RebekahCurse.Items.COLLECTIBLE_UNREQUITEDLOVE, "Shoot a spear to enemy # If enemy is attached, use arrow keys to swing around attached enemy # Enemies eventually detach naturally or if they collide in the walls")
	EID:addCollectible(RebekahCurse.Items.COLLECTIBLE_REBEKAHSFAVORITE, "Spawns a Happy Jacob # This Jacob gains damage, range, tears and other stats depending on how many items given to him")
	EID:addCollectible(RebekahCurse.Items.COLLECTIBLE_WIKEPIDIA, "Can act like every vanilla book # Switch book page with the Drop key like DInfinity")
	EID:addCollectible(RebekahCurse.Items.COLLECTIBLE_TIGHTHAIRTIE, "Gives + .2 Speed and +2 Range")
	EID:addCollectible(RebekahCurse.Items.COLLECTIBLE_BASKETOFEGGS, "Drops 5 eggs on pickup")
	EID:addCollectible(RebekahCurse.Items.COLLECTIBLE_EGGSHELLWALK, "On new room, eggs spawn # Walking around the eggs breaks egg to spawn a Bun Bun, which helps fight enemies # If breaking an egg with 2 Bun Buns are in the room, a Rabbet spawns instead, collecting eggs in the room + collision damage to you # If Rabbet is active and you break an egg, Rabbet becomes angry")
	EID:addTrinket(RebekahCurse.Trinkets.TRINKET_ISAACSLOCKS, "When entering either a {{Shop}}, {{BossRoom}}, {{TreasureRoom}}, {{DevilRoom}} or {{AngelRoom}}, a reroll slot machine spawns # A reroll machine spawning in {{DevilRoom}} or {{AngelRoom}} is chance-based")
	EID:addTrinket(RebekahCurse.Trinkets.TRINKET_RABBITSFOOT, "Pickups have a chance to be replaced by easter ovum")
	EID:addCollectible(RebekahCurse.Items.COLLECTIBLE_WISHFULTHINKING, "On death, respawn as Wishful Isaac # Wishful Isaac has 10 Luck")
	EID:addTrinket(RebekahCurse.Trinkets.TRINKET_DESTROYEDLULLABY, "Familiars have random tears and tearflags")
	EID:addCollectible(RebekahCurse.Items.COLLECTIBLE_OVERSIZEDSWEATER, "Picking up hearts also spawn their respective clot versions")
	EID:addCollectible(RebekahCurse.Items.COLLECTIBLE_HEARTSANDCRAFTS, "Spawn a charmed Rebekah's room enemy")
	EID:addCollectible(RebekahCurse.Items.COLLECTIBLE_TECHHZ, "Moving and shooting at the same time spawns a Tech X beam around you")
	EID:addCollectible(RebekahCurse.Items.COLLECTIBLE_ANGELSMORNINGSTAR, "Spawns a familiar morningstar which can hurt enemies and grids")
	EID:addCollectible(RebekahCurse.Items.COLLECTIBLE_POTATOSNACK, "Grants 2 soul hearts")
	EID:addTrinket(RebekahCurse.Trinkets.TRINKET_ORIGINALSIN, "Protects your devil deal chance on first hurt each floor")
	EID:addCollectible(RebekahCurse.Items.COLLECTIBLE_THEENCHIRIDION, "Weakens every enemy on the room while gaining a damage buff for the entire room")
	EID:addCollectible(RebekahCurse.Items.COLLECTIBLE_BODYDYSMORHIA, "Exchange hearts for stats depending on heart chosen")
	EID:addCollectible(RebekahCurse.Items.COLLECTIBLE_EYESOFTHEDEAD, "On pickup, saves your last damage * 2 # Enemies have numbers under them, upon death grant temporary damage up depending on said numbers # Damage cap is the saved last damage before pickup * 1.5 # Damage cap can be increased if new damage is higher than cap" )
	EID:addCollectible(RebekahCurse.Items.COLLECTIBLE_PSORAISIS, "Grants skin armor points # saves you from damage at cost of one armor point # armor points regenerate slowly overtime")
	EID:addCollectible(RebekahCurse.Items.COLLECTIBLE_NOTEBOOKOFTHEDEAD, "Choose an enemy to insta-kill # Bosses drain their health overtime # Killed enemies spawn a dark laser beam around them")
	EID:addTrinket(RebekahCurse.Trinkets.TRINKET_REBEKAHSKEY, "Adds 20% more chance to replace curse rooms with Rebekah's room")
	EID:addCollectible(RebekahCurse.Items.COLLECTIBLE_HAPHEPHOBICBOMBS, "Bombs explode on enemy contact # +7 bombs")
	EID:addCollectible(RebekahCurse.Items.COLLECTIBLE_JUMPYDUMPTY, "On use, drops a bouncing bomb that explodes and leaves smaller bombs")
	EID:addCollectible(RebekahCurse.Items.COLLECTIBLE_PENCILSHARPENER, "After every 7 shots, Isaac shoots a 5 spread piercing shot")
	EID:addCollectible(RebekahCurse.Items.COLLECTIBLE_NARCOLEPSY, "On an uncleared room, after a while, transform into dream mode # Dream mode gives Isaac temporary high quality items # Damage or colliding on grids wake you up # Inflicted damage in dream mode is doubled")
	EID:addTrinket(RebekahCurse.Trinkets.TRINKET_MOMSBLESSING, "1/4 chance to replace chests to Mom's chest")
	EID:addTrinket(RebekahCurse.Trinkets.TRINKET_JOHNANDROMANS, "On new floor, spawn charmed angel babies and innate Salvation # Salvation disappears on damage")
	EID:addCollectible(RebekahCurse.Items.COLLECTIBLE_APPRECIATIONCAKE, "All stats up # Every 4th shot spawns a red candle flame")
	EID:addCollectible(RebekahCurse.Items.COLLECTIBLE_CHEESYPIZZA, "Every shot tear has a hot cheese string connected to Isaac # String burns enemies on contact")
	EID:addCollectible(RebekahCurse.Items.COLLECTIBLE_JELLYDONUT, "+1 soul heart")
	EID:addCollectible(RebekahCurse.Items.COLLECTIBLE_SPIKEDPARTYPUNCH, "+1.40 damage")
	EID:addCollectible(RebekahCurse.Items.COLLECTIBLE_BOBATEA, "Chance to replace tears with tapioca tears # Tapioca tears bounce and leave tiny tears and a puddle on death")
	EID:addCollectible(RebekahCurse.Items.COLLECTIBLE_BURGER, "+.2 speed # Drops a foot-based trinket")
	EID:addCollectible(RebekahCurse.Items.COLLECTIBLE_FENRIRSEYE, "Enemies in Isaac's line of sight get weakness")
	EID:addCollectible(RebekahCurse.Items.COLLECTIBLE_FENRIRSPAW, "Digs the floor for rewards or bone-based enemies")
	EID:addCollectible(RebekahCurse.Items.COLLECTIBLE_FENRIRSHEAD, "1/10 chance to double damage")
	EID:addCollectible(RebekahCurse.Items.COLLECTIBLE_FENRIRSTOOTH, "Howls when nearby adjacent Ultra Secret Rooms")
	EID:addCollectible(RebekahCurse.Items.COLLECTIBLE_FENRIRSLEASH, "Spawns a Fenrir familiar # Bites occasionally and inflicts Weakness")
	EID:addTrinket(RebekahCurse.Trinkets.TRINKET_CANNEDLAUGHTER, "On an uncleared room, 1/5 chance to inflict Laughter to all enemies")
	EID:addCollectible(RebekahCurse.Items.COLLECTIBLE_HEARTACHES, "On new floor, opens red rooms around the level # On room enter, chance to duplicate all pickups # On cleared rooms, chance to unclear room again")
	EID:addCollectible(RebekahCurse.Items.COLLECTIBLE_SILPHIUM, "On new floor, spawns heart orbitals and block tears # Amount spawned is based on Isaac's max hearts # Magdalene has a multiplier for hearts spawned")
	EID:addCollectible(RebekahCurse.Items.COLLECTIBLE_GIDDYUP, "Become invulnerable and be godcrafted with chiseled abs, chunky bottom and a gigachad vizard")
	EID:addCollectible(RebekahCurse.Items.COLLECTIBLE_REBEKAHSSCRAPBOOK, "Spawn a charmed scrapped enemy of the mod")
	EID:addTrinket(RebekahCurse.Trinkets.TRINKET_NOSCOPE, "Turning from one head direction to another briefly increases damage # doing a 360 can increase multiplier")
	EID:addCollectible(RebekahCurse.Items.COLLECTIBLE_UNDERPAY, "Coins have a chance to get replaced with coin pieces # Coin pieces can give .1 to .2 coins # Coin drop is increased")
	EID:addCollectible(RebekahCurse.Items.COLLECTIBLE_SKIMMEDMILK, "Tear velocity increases tear damage")
	EID:addCollectible(RebekahCurse.Items.COLLECTIBLE_MILKWINE, "Isaac's Damage fluctuate from low up to twice his original damage every other 15 ticks")
	EID:addCollectible(RebekahCurse.Items.COLLECTIBLE_JACOBSTEARS, "Shooting familiar that fills up each shot # When reaching its limit, does an Isaac's Tears burst and empties")
	EID:addCollectible(RebekahCurse.Items.COLLECTIBLE_SILENTTREATMENT, "High tear velocity # Tear shrinks # *3 damage multiplier # Tears down")
	EID:addCollectible(RebekahCurse.Items.COLLECTIBLE_SILENCER, "On enemy damage, chance to inflict Silenced status effect # Silenced enemies cannot spawn, shoot and lose track of their target for a while")
	EID:addTrinket(RebekahCurse.Trinkets.TRINKET_DEBORAHSDEADEYE, "On room enter, empty targets spawn attached to each enemy # Guide spawned red targets to empty targets # After a few seconds, all targeted enemies receive high damage")
	EID:addCollectible(RebekahCurse.Items.COLLECTIBLE_FULLFATMILK, "Only one tear can exist at a time # Each new tear spawned from Isaac increases the first original tear's damage and size and removes newer tears # Another tear is allowed to exist after no more older tears exist")
	EID:addCollectible(RebekahCurse.Items.COLLECTIBLE_CUTIEPATOOTIE, "Orbital that inflicts Stringed status effect on enemies on collision # When one Stringed enemy dies, every other Stringed enemy receives damage")
	EIDRebekahsMirror = {
		Red = {
			["Name"] = "{{Heart}} Rebekah the Nerd", -- Display name of Personality
			["Description"] = "Double Tap is a dash, similiar to Mars#{{Collectible"..RebekahCurse.Items.COLLECTIBLE_LOVECANNON .."}} activates a barrage of tears, which changes depending on how you shoot" -- Description
		},
		Soul = {
			["Name"] = "{{SoulHeart}} Rebekah the Aloof", 
			["Description"] = "Double Tap is teleport, control the target to where to spawn#{{Collectible"..RebekahCurse.Items.COLLECTIBLE_LOVECANNON .."}} activates a barrage of tears, similar to a Wizoob#↑ Gains a short damage multiplier right after teleport" -- Description
		},
		Evil = {
			["Name"] = "{{BlackHeart}} Rebekah the Mischevious",
			["Description"] = "Double Tap is a horizontal dash, similar to Heretic, leaving a flame# Stacking flames upgrades flames, which can now occasionally shoot#{{Collectible"..RebekahCurse.Items.COLLECTIBLE_LOVECANNON .."}} fires a {{Collectible118}} to the closest flame if present, chaining to the next furthest flame and cycle repeats #{{Warning}} {{Collectible"..RebekahCurse.Items.COLLECTIBLE_LOVECANNON .."}} activates a short brimstone if no flame is present" -- Description
		},
		Gold = {
			["Name"] = "{{GoldenHeart}} Rebekah the Royal", 
			["Description"] = "Double Tap is a stomp#↑ Stomp can kill nearby projectiles #{{Collectible"..RebekahCurse.Items.COLLECTIBLE_LOVECANNON .."}} spawns an upgradable Keeper #New levels upgrade your Keepers" -- Description
		},
		Eternal = {
			["Name"] = "{{EthernalHeart}} Rebekah the Kind",
			["Description"] = "#↓Rebekah can no longer fire#Rebekah can instead fire {{Collectible640}}-esque flames and a cost of charges #Stacking charges is similar to Neptunus#Double Tap is a dash, similiar to Mars#{{Collectible"..RebekahCurse.Items.COLLECTIBLE_LOVECANNON .."}} activates a light beam and seeking feathers" -- Description
		},
		Bone = {
			["Name"] = "{{EmptyBoneHeart}} Rebekah the Weird",
			["Description"] = "Double Tap triggers a melee attack to specified direction#{{Collectible"..RebekahCurse.Items.COLLECTIBLE_LOVECANNON .."}} spawns a controllable Corpse Carrier #On Corpse Carrier mode, quickly fire bones and double tap to dash" -- Description
		},
		Rotten = {
			["Name"] = "{{HalfHeart}} Rebekah the Crazy",
			["Description"] = "Double Tap pushes your orbiting flies in specified direction #Double Tap also decapitates your head or pushes head if already decapitated# Occasionally spawn orbiting flies while pressing fire keys#{{Collectible"..RebekahCurse.Items.COLLECTIBLE_LOVECANNON .."}} spits out a ball of flies which spawn seeker flies" -- Description
		},
		Broken = {
			["Name"] = "{{BlendedHeart}} Rebekah the Aware",
			["Description"] = "Double Tap leaves a glitched mirror-portal# Enemies can teleport through # Pickups teleported have a chance to be rerolled #{{Collectible"..RebekahCurse.Items.COLLECTIBLE_LOVECANNON .."}} spawns a cursor to hold bosses for a duration" -- Description
		}
	}
	EIDMakeupStation = {
		Red = {
			["Name"] = "{{Heart}} Red Heart", -- Display name of Personality
			["Description"] = "Gives a random stat" -- Description
		},
		Soul = {
			["Name"] = "{{SoulHeart}} Soul Heart", 
			["Description"] = "Gives speed stat" -- Description
		},
		Evil = {
			["Name"] = "{{BlackHeart}} Evil Heart",
			["Description"] = "Gives damage stat" -- Description
		},
		Gold = {
			["Name"] = "{{GoldenHeart}} Gold Heart", 
			["Description"] = "Gives luck stat" -- Description
		},
		Eternal = {
			["Name"] = "{{EthernalHeart}} Eternal Heart",
			["Description"] = "Gives all stats up" -- Description
		},
		Bone = {
			["Name"] = "{{EmptyBoneHeart}} Bone Heart",
			["Description"] = "Gives a small speed stat and damage stat" -- Description
		},
		Rotten = {
			["Name"] = "{{HalfHeart}} Rotten Heart",
			["Description"] = "Gives a damage and shot speed stat" -- Description
		}
	}

	__eidCardDescriptions[RebekahCurse.Cards.CARD_QUALITYTIME] = "Stops time and allows Isaac to move for 5 seconds."
	__eidCardDescriptions[RebekahCurse.Cards.CARD_WORDSOFAFFIRMATION] = "Spawn a giant heart that deals massive damage."
	__eidCardDescriptions[RebekahCurse.Cards.CARD_ACTOFSERVICE] = "Spawns a knight that helps Isaac."
	__eidCardDescriptions[RebekahCurse.Cards.CARD_GIFTGIVING] = "Spawns two item pedestals."
	__eidCardDescriptions[RebekahCurse.Cards.CARD_PHYSICALTOUCH] = "Spawns a group of heart wisp orbitals."

	__eidCardDescriptions[RebekahCurse.Cards.SOUL_REBEKAHNORMAL] = "Gives{{Collectible"..CollectibleType.COLLECTIBLE_BIRTHRIGHT .."}} for the whole stage # if a curse is in the floor, clears curse and drops respective spirit stone of curse"
	__eidCardDescriptions[RebekahCurse.Cards.SOUL_REBEKAHCURSED] = "On each room enter, every enemy gets 50 flat damage"
	__eidCardDescriptions[RebekahCurse.Cards.SOUL_REBEKAHLOST] = "Spawns a dead Fenrir familiar"
	__eidCardDescriptions[RebekahCurse.Cards.SOUL_REBEKAHUNKNOWN] = "Converts Isaac's current health into stats similar to Rebekah's vanity."
	__eidCardDescriptions[RebekahCurse.Cards.SOUL_REBEKAHMAZE] = "Spawns a pillar familiar # Familiar digs under ground and pops underneath enemies for damage # While above, familiar can block projectiles and enemies."
	__eidCardDescriptions[RebekahCurse.Cards.SOUL_REBEKAHLABYRINTH] = "Duplicates items after room is cleared for the whole floor."
	__eidCardDescriptions[RebekahCurse.Cards.SOUL_REBEKAHBLIND] = "Spawns a skull and attaches itself to the closest pedestal # Each damage it takes from Isaac rerolls the attached pedestal"
	__eidCardDescriptions[RebekahCurse.Cards.SOUL_REBEKAHDARKNESS] = "Increases tear rate, damage and speed for whole floor. # Stacks"
end