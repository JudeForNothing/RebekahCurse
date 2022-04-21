
if EID then
	EID:setModIndicatorName("Rebekah: Cursed and Heartbroken")
	EID:setModIndicatorIcon("Heart")
    -- EID items
	EID:addCollectible(RebekahCurse.COLLECTIBLE_CANDYWEDDINGRING, "On pickup, gains 0.2 speed and one heart")
	EID:addCollectible(RebekahCurse.COLLECTIBLE_LOVEDELUXE, "After releasing the fire keys after holding for more than 2 seconds unleashes a hait whip#Hair damage is 2.5 damage per frame#Does not scale of Isaac's Damage")
	EID:addCollectible(RebekahCurse.COLLECTIBLE_GREATPHEONIX, "Every 30 shots fired, spawn two random locusts")
	
	EID:addCollectible(RebekahCurse.COLLECTIBLE_DOORSTOPPER, "On use, aim to throw a giant book which deals 7.5 damage on landing# Deals 2.5 damage while flying in air #Get close to book in the floor to pick it up")
	EID:addCollectible(RebekahCurse.COLLECTIBLE_FINGERFINGER, "Enemies killed spawn a finger familiar, which surrounds and deal damage to the first enemy you damaged in the room until death")
	EID:addCollectible(RebekahCurse.COLLECTIBLE_MORIAHDIARY, "Enemies and projectiles show a visual line on where they might go # Using the item also unlocks hitboxes and warning")
	EID:addCollectible(RebekahCurse.COLLECTIBLE_THESHINING, "On use, all doors in the room bleed with creep, blood tears and end with brimstone # Tears and brimstone follow your tearflags")
	EID:addCollectible(RebekahCurse.COLLECTIBLE_TWINVISION, "On new floor, spawns two invulnerable clones of you # Clones disappear on your damage")
	EID:addCollectible(RebekahCurse.COLLECTIBLE_NUTWATER, "On pickup, drops a heart based on your character + DMG + Speed")
	EID:addCollectible(RebekahCurse.COLLECTIBLE_ABEAUTIFULGRAVE, "Gain a familiar that shoots fear tears # When an enemy is feared, he grabs them # If boss, he damages them, else he kills them instantly")
	EID:addCollectible(RebekahCurse.COLLECTIBLE_OHIMDIE, "When charged, a familiar ticks and shows a color order for you to defuse # Rewards dropped are exactly a locked chest # Failure to defuse on time or doing 3 mistakes blows you up # Difficuty spikes up the more successes you have by shorter timer and explosion damage")
	EID:addCollectible(RebekahCurse.COLLECTIBLE_REBEKAHSCAMERA, "Captures enemies in room on first use, respawns them as charmed on second use")
	EID:addCollectible(RebekahCurse.COLLECTIBLE_LUNCHBOX, "On pickup, drops 3 random hearts")
	EID:addCollectible(RebekahCurse.COLLECTIBLE_MIRACULOUSWOMB, "On pickup, adds an orbital of Jacob and Esau#Jacob Familiar has less damage but shoots slighly faster # Esau Familiar shoots less but has more damage")
	EID:addCollectible(RebekahCurse.COLLECTIBLE_DICEOFFATE, "Use to reroll your hearts# Each half heart is rerolled into another heart # Broken Hearts do not get rerolled")
	EID:addCollectible(RebekahCurse.COLLECTIBLE_SNAP, "On hurt, gain buffs # After next room, gain debuff until next room")
	EID:addCollectible(RebekahCurse.COLLECTIBLE_ETERNALBOND, "Spawns a Tiny Isaac and Tiny Rebekah# Both types of familiars shoot tears at enemies# Rebekah can burst tears similar to Red Personality's {{Collectible"..RebekahCurse.COLLECTIBLE_LOVECANNON .."}} # Rebekah can pick up heart pickups and drop certain hearts # Isaac can pick up coins and drop various rewards")
	EID:addCollectible(RebekahCurse.COLLECTIBLE_LOVESICK, "Tears are replaced by charming notes # Charging your fire keys shoots a ring of tears around Isaac with weak knockback")
	EID:addCollectible(RebekahCurse.COLLECTIBLE_POWERLOVE, "Each filled half red heart gives 0.50 damage# Each empty half red heart gives 0.10 speed")
	EID:addCollectible(RebekahCurse.COLLECTIBLE_ROMCOM, "Gives every vulnerable enemy the Laughing effect # Laughing effect disables the ability to shoot projectiles")
	EID:addCollectible(RebekahCurse.COLLECTIBLE_CURSEDSPOON, "On hurt, spawns a Mom's Shadow-esque entity which only deals contact damage to both enemies and Isaac when she dashes")
	EID:addCollectible(RebekahCurse.COLLECTIBLE_PATRIARCHSLIAR, "Occasionally spawns a giant fist punching at your direction from a wall # Damages enemies")
	EID:addCollectible(RebekahCurse.COLLECTIBLE_UNREQUITEDLOVE, "Shoot a spear to enemy # If enemy is attached, use arrow keys to swing around attached enemy # Enemies eventually detach naturally or if they collide in the walls")
	EID:addCollectible(RebekahCurse.COLLECTIBLE_REBEKAHSFAVORITE, "Spawns a Happy Jacob # This Jacob gains damage, range, tears and other stats depending on how many items given to him")
	EID:addCollectible(RebekahCurse.COLLECTIBLE_WIKEPIDIA, "Can act like every vanilla book # Switch book page with the Drop key like DInfinity")
	EID:addCollectible(RebekahCurse.COLLECTIBLE_TIGHTHAIRTIE, "Gives + .2 Speed and +2 Range")
	EID:addCollectible(RebekahCurse.COLLECTIBLE_BASKETOFEGGS, "Drops 5 eggs on pickup")
	EID:addCollectible(RebekahCurse.COLLECTIBLE_EGGSHELLWALK, "On new room, eggs spawn # Walking around the eggs breaks egg to spawn a Bun Bun, which helps fight enemies # If breaking an egg with 2 Bun Buns are in the room, a Rabbet spawns instead, collecting eggs in the room + collision damage to you # If Rabbet is active and you break an egg, Rabbet becomes angry")
	EID:addTrinket(RebekahCurse.TRINKET_ISAACSLOCKS, "When entering either a {{Shop}}, {{BossRoom}}, {{TreasureRoom}}, {{DevilRoom}} or {{AngelRoom}}, a reroll slot machine spawns # A reroll machine spawning in {{DevilRoom}} or {{AngelRoom}} is chance-based")
	EID:addTrinket(RebekahCurse.TRINKET_RABBITSFOOT, "Pickups have a chance to be replaced by easter eggs")
	EID:addCollectible(RebekahCurse.COLLECTIBLE_WISHFULTHINKING, "On death, respawn as Wishful Isaac # Wishful Isaac has 10 Luck")
	
	-- EID mirror render
	EIDRebekahsMirror = {
		Red = {
			["Name"] = "{{Heart}} Red Personality", -- Display name of Personality
			["Description"] = "Double Tap is a dash, similiar to Mars#{{Collectible"..RebekahCurse.COLLECTIBLE_LOVECANNON .."}} activates a barrage of tears, which changes depending on how you shoot" -- Description
		},
		Soul = {
			["Name"] = "{{SoulHeart}} Soul Personality", 
			["Description"] = "Double Tap is teleport, control the target to where to spawn#{{Collectible"..RebekahCurse.COLLECTIBLE_LOVECANNON .."}} activates a barrage of tears, similar to a Wizoob#↑ Gains a short damage multiplier right after teleport" -- Description
		},
		Evil = {
			["Name"] = "{{BlackHeart}} Evil Personality",
			["Description"] = "Double Tap is a short dash, leaving a flame# Stacking flames upgrades flames, which can now occasionally shoot#{{Collectible"..RebekahCurse.COLLECTIBLE_LOVECANNON .."}} fires a {{Collectible118}} to the closest flame if present, chaining to the next furthest flame and cycle repeats #{{Warning}} {{Collectible"..RebekahCurse.COLLECTIBLE_LOVECANNON .."}} activates a short brimstone if no flame is present" -- Description
		},
		Gold = {
			["Name"] = "{{GoldenHeart}} Gold Personality", 
			["Description"] = "Double Tap is a stomp#↑ Stomp can kill nearby projectiles #{{Collectible"..RebekahCurse.COLLECTIBLE_LOVECANNON .."}} spawns an upgradable Keeper #New levels upgrade your Keepers" -- Description
		},
		Eternal = {
			["Name"] = "{{EthernalHeart}} Eternal Personality",
			["Description"] = "#↓Rebekah can no longer fire#Rebekah can instead fire {{Collectible640}}-esque flames and a cost of charges #Stacking charges is similar to Neptunus#Double Tap is a dash, similiar to Mars#{{Collectible"..RebekahCurse.COLLECTIBLE_LOVECANNON .."}} activates a light beam and seeking feathers" -- Description
		},
		Bone = {
			["Name"] = "{{EmptyBoneHeart}} Bone Personality",
			["Description"] = "Double Tap triggers a melee attack to specified direction#{{Collectible"..RebekahCurse.COLLECTIBLE_LOVECANNON .."}} spawns a controllable Corpse Carrier #On Corpse Carrier mode, quickly fire bones and double tap to dash" -- Description
		},
		Rotten = {
			["Name"] = "{{HalfHeart}} Rotten Personality",
			["Description"] = "Double Tap pushes your orbiting flies in specified direction #Double Tap also decapitates your head or pushes head if already decapitated# Occasionally spawn orbiting flies while pressing fire keys#{{Collectible"..RebekahCurse.COLLECTIBLE_LOVECANNON .."}} spits out a ball of flies which spawn seeker flies" -- Description
		},
		Broken = {
			["Name"] = "{{BlendedHeart}} Broken Personality",
			["Description"] = "Double Tap is a parry with a small window#↑ Successful parries gives rewards based on the number you chose by fire keys #{{Collectible"..RebekahCurse.COLLECTIBLE_LOVECANNON .."}} spawns a fragment of yourself, allowing you to take damage without hurt #Your fragment indicates how long you can collide #{{Warning}} Upon leaving room with fragment present hurts you #{{Warning}} If counter reaches 50, a huge penalty occurs" -- Description
		}
	}
end