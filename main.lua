-- Welcome to my crappy code

yandereWaifu = RegisterMod("Rebekah", 1)

-- Good Lord what have I done

-- Require up those extra modules

yandereWaifuCodes = {
	init = nil,
	enums = require('codes.enums'),
	library = require('codes.library'),
	itempools = {
		loveroom = require('codes.itempools.loveroom'),
	},
	itempool = require('codes.itempools'),
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
		basicentities = require('codes.entities.basicentities'),
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
			lilithfamiliars = require('codes.entities.bosses.lilith.familiars'),
			thestalwart = require('codes.entities.bosses.thestalwart'),
		}
	},
	pocketitems = {
		egg = require('codes.pocketitems.easteregg'),
	},
	items = {
		glowinghourglass = require('codes.items.glowinghourglass'),
		
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
		
		wishfulthinking = require('codes.items.tainted.wishful_thinking'),
		abeautifulgrave = require('codes.items.abeautifulgrave'),
		tighthairtie = require('codes.items.tighthairtie'),
		basketofeggs = require('codes.items.basketofeggs'),
		rabbitsfoot = require('codes.items.rabbitsfoot'),
		eggshellwalk = require('codes.items.eggshellwalk'),
		destroyedlullaby = require('codes.items.destroyedlullaby'),
		oversizedsweater = require('codes.items.oversizedsweater'),
		heartsandcrafts = require('codes.items.heartsandcrafts'),
		techhz = require('codes.items.techhz'),
		angelsmorningstar = require('codes.items.angelsmorningstar'),
		potatosnack = require('codes.items.potatosnack'),
		originalsin = require('codes.items.originalsin'),
		enchiridion = require('codes.items.enchiridion'),
		bodydysmorphia = require('codes.items.bodydysmorphia'),
		eyesofthedead = require('codes.items.eyesofthedead'),
		notebookofthedead = require('codes.items.notebookofthedead'),
		psoraisis = require('codes.items.psoraisis'),
	},
	slots = {
		mirror = require('codes.slots.mirror'),
		mirrorconverter = require('codes.slots.mirrorconverter')
	},
	shaders = require('codes.shaders'),
	stages = {
		gen = {
			rebekahsroom = require('codes.floors.gen.rebekahsbedroom'),
			},
		rebekahsroom = require('codes.floors.rebekahsbedroom'),
		--liminal = require('codes.floors.backrooms')
	},
	unlocks = {
	},
	descriptions = require('codes.descriptions'),
	commands = require('codes.commands')
}
