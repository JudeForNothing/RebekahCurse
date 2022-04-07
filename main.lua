-- Welcome to my crappy code

yandereWaifu = RegisterMod("Rebekah", 1)

-- Good Lord what have I done

-- Require up those extra modules
yandereWaifuCodes = {
	init = nil,
	enums = require('codes.enums'),
	library = require('codes.library'),
	savedata = require('codes.savedata'),
	minimenu = require('codes.minimenu'),
	config = require('codes.config'),
	rebekahA = {
		gui = require('codes.rebekah_A.gui'),
		lovelove = require('codes.rebekah_A.lovelovereserve'),
		basic = require('codes.rebekah_A.basic'),
		personalities = {
			red  = require('codes.rebekah_A.personalities.red'),
			soul = require('codes.rebekah_A.personalities.soul'),
			evil = require('codes.rebekah_A.personalities.evil'),
			gold = require('codes.rebekah_A.personalities.gold'),
			eternal = require('codes.rebekah_A.personalities.eternal'),
			bone = require('codes.rebekah_A.personalities.bone'),
			rotten = require('codes.rebekah_A.personalities.rotten'),
			broken = require('codes.rebekah_A.personalities.broken')
		}
	},
	isaacC = require('codes.isaac_C.basic'),
	entities = {
		basiceffects = require('codes.entities.basiceffects'),
		customplayeranim = require('codes.entities.customplayeranim'),
		mirrorentities = require('codes.entities.mirrorentities'),
		--liminal = {
		--	faceling = require('codes.entities.liminal.faceling'),
		--	maggy = require('codes.entities.liminal.thescum'),
		--},
		bosses = {
			maggy = require('codes.entities.bosses.magdalene'),
			eve = require('codes.entities.bosses.eve'),
			bloodsins = require('codes.entities.bosses.eve.bloodsins'),
			lilith = require('codes.entities.bosses.lilith'),
			bloodsins = require('codes.entities.bosses.lilith.familiars'),
		}
	},
	items = {
		candyweddingring = require('codes.items.candyweddingring'),
		lovedeluxe = require('codes.items.lovedeluxe'),
		greatpheonix = require('codes.items.greatpheonix'),
		lovemelovemenot = require('codes.items.lovemelovemenot'),
		doorstopper = require('codes.items.doorstopper'),
		fingerfinger = require('codes.items.fingerfinger'),
		moriahdiary = require('codes.items.moriahdiary'),
		theshining = require('codes.items.theshining'),
		ohimdie = require('codes.items.ohimdie'),
		typicalromcom = require('codes.items.typicalromcom'),
		wikepdia = require('codes.items.encyclopedia'),
		bagofbristlebricks = require('codes.items.bagofbristlebricks'),
		nutwater = require('codes.items.nutwater'),
		twinvision = require('codes.items.twinvision'),
		
		lunchbox = require('codes.items.lunchbox'),
		miraculouswomb = require('codes.items.miraculouswomb'),
		diceoffate = require('codes.items.diceoffate'),
		eternalbond = require('codes.items.eternalbond'),
		rebekahscamera = require('codes.items.rebekahscamera'),
		lovesick = require('codes.items.lovesick'),
		lovepower = require('codes.items.lovepower'),
		snap = require('codes.items.snap'),
		cursedspoon = require('codes.items.cursedspoon'),
		patriarchsliar = require('codes.items.patriarchsliar'),
		unrequitedlove = require('codes.items.unrequitedlove'),
		rebekahsfavorite = require('codes.items.rebekahsfavorite'),
		
		isaacslocks = require('codes.items.isaacslocks'),
		
		wishfulthinking = require('codes.items.tainted.wishful_thinking')
	},
	slots = {
		mirror = require('codes.slots.mirror')
	},
	shaders = require('codes.shaders'),
	stages = {
		gen = {
			rebekahsroom = require('codes.floors.gen.rebekahsbedroom'),
			},
		rebekahsroom = nil,
		--liminal = require('codes.floors.backrooms')
	},
	unlocks = {
	},
	descriptions = require('codes.descriptions'),
	commands = require('codes.commands')
}
-- Reset the information when moving rooms so that we don't have false positive double taps across rooms
