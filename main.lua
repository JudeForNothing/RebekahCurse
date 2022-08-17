-- Welcome to my crappy code

yandereWaifu = RegisterMod("Rebekah", 1)

-- Good Lord what have I done

-- Require up those extra modules

inutillib_main = require('codes_rebekah.inutillib_main')

yandereWaifuCodes = {
	init = nil,
	savedata = require('codes_rebekah.savedata'),
	dss = {
		dsstutorials = require('codes_rebekah.dss.dsstutorials'),
		deadseascrolls = require('codes_rebekah.dss.deadseascrolls'),
	},
	--dssmenucore = require('codes_rebekah.dssmenucore'),
	
	enums = require('codes_rebekah.enums'),
	library = require('codes_rebekah.library'),
	itempools = {
		loveroom = require('codes_rebekah.itempools.loveroom'),
	},
	itempool = require('codes_rebekah.itempools'),
	minimenu = require('codes_rebekah.minimenu'),
	--config = require('codes_rebekah.config'),
	characters = {
		rebekahA = {
			gui = require('codes_rebekah.characters.rebekah_A.gui'),
			lovelove = require('codes_rebekah.characters.rebekah_A.lovelovereserve'),
			basic = require('codes_rebekah.characters.rebekah_A.basic'),
			characterselect = require('codes_rebekah.characters.rebekah_A.characterselect'),
			personalities = {
				red  = require('codes_rebekah.characters.rebekah_A.personalities.red'),
				soul = require('codes_rebekah.characters.rebekah_A.personalities.soul'),
				evil = require('codes_rebekah.characters.rebekah_A.personalities.evil'),
				gold = require('codes_rebekah.characters.rebekah_A.personalities.gold'),
				eternal = require('codes_rebekah.characters.rebekah_A.personalities.eternal'),
				bone = require('codes_rebekah.characters.rebekah_A.personalities.bone'),
				rotten = require('codes_rebekah.characters.rebekah_A.personalities.rotten'),
				broken = require('codes_rebekah.characters.rebekah_A.personalities.broken'),
				immortal = require('codes_rebekah.characters.rebekah_A.personalities.immortal')
			}
		},
		isaacC = require('codes_rebekah.characters.isaac_C.basic'),
	},
	entities = {
		basiceffects = require('codes_rebekah.entities.basiceffects'),
		basicentities = require('codes_rebekah.entities.basicentities'),
		customplayeranim = require('codes_rebekah.entities.customplayeranim'),
		mirrorentities = require('codes_rebekah.entities.mirrorentities'),
		--liminal = {
		--	faceling = require('codes_rebekah.entities.liminal.faceling'),
		--	maggy = require('codes_rebekah.entities.liminal.thescum'),
		--},
		bosses = {
			maggy = require('codes_rebekah.entities.bosses.magdalene'),
			eve = require('codes_rebekah.entities.bosses.eve'),
			bloodsins = require('codes_rebekah.entities.bosses.eve.bloodsins'),
			lilith = require('codes_rebekah.entities.bosses.lilith'),
			lilithfamiliars = require('codes_rebekah.entities.bosses.lilith.familiars'),
			thestolid = require('codes_rebekah.entities.bosses.thestolid'),
			nincompoop = require('codes_rebekah.entities.bosses.nincompoop'),
		}
	},
	pocketitems = {
		egg = require('codes_rebekah.pocketitems.easteregg'),
	},
	items = {
		glowinghourglass = require('codes_rebekah.items.glowinghourglass'),
		
		candyweddingring = require('codes_rebekah.items.candyweddingring'),
		lovedeluxe = require('codes_rebekah.items.lovedeluxe'),
		greatpheonix = require('codes_rebekah.items.greatpheonix'),
		lovemelovemenot = require('codes_rebekah.items.lovemelovemenot'),
		doorstopper = require('codes_rebekah.items.doorstopper'),
		fingerfinger = require('codes_rebekah.items.fingerfinger'),
		moriahdiary = require('codes_rebekah.items.moriahdiary'),
		theshining = require('codes_rebekah.items.theshining'),
		ohimdie = require('codes_rebekah.items.ohimdie'),
		typicalromcom = require('codes_rebekah.items.typicalromcom'),
		wikepdia = require('codes_rebekah.items.encyclopedia'),
		bagofbristlebricks = require('codes_rebekah.items.bagofbristlebricks'),
		nutwater = require('codes_rebekah.items.nutwater'),
		twinvision = require('codes_rebekah.items.twinvision'),
		
		lunchbox = require('codes_rebekah.items.lunchbox'),
		miraculouswomb = require('codes_rebekah.items.miraculouswomb'),
		diceoffate = require('codes_rebekah.items.diceoffate'),
		eternalbond = require('codes_rebekah.items.eternalbond'),
		rebekahscamera = require('codes_rebekah.items.rebekahscamera'),
		lovesick = require('codes_rebekah.items.lovesick'),
		lovepower = require('codes_rebekah.items.lovepower'),
		snap = require('codes_rebekah.items.snap'),
		cursedspoon = require('codes_rebekah.items.cursedspoon'),
		patriarchsliar = require('codes_rebekah.items.patriarchsliar'),
		unrequitedlove = require('codes_rebekah.items.unrequitedlove'),
		rebekahsfavorite = require('codes_rebekah.items.rebekahsfavorite'),
		
		isaacslocks = require('codes_rebekah.items.isaacslocks'),
		
		wishfulthinking = require('codes_rebekah.items.tainted.wishful_thinking'),
		abeautifulgrave = require('codes_rebekah.items.abeautifulgrave'),
		tighthairtie = require('codes_rebekah.items.tighthairtie'),
		basketofeggs = require('codes_rebekah.items.basketofeggs'),
		rabbitsfoot = require('codes_rebekah.items.rabbitsfoot'),
		eggshellwalk = require('codes_rebekah.items.eggshellwalk'),
		destroyedlullaby = require('codes_rebekah.items.destroyedlullaby'),
		oversizedsweater = require('codes_rebekah.items.oversizedsweater'),
		heartsandcrafts = require('codes_rebekah.items.heartsandcrafts'),
		techhz = require('codes_rebekah.items.techhz'),
		angelsmorningstar = require('codes_rebekah.items.angelsmorningstar'),
		potatosnack = require('codes_rebekah.items.potatosnack'),
		originalsin = require('codes_rebekah.items.originalsin'),
		enchiridion = require('codes_rebekah.items.enchiridion'),
		bodydysmorphia = require('codes_rebekah.items.bodydysmorphia'),
		eyesofthedead = require('codes_rebekah.items.eyesofthedead'),
		notebookofthedead = require('codes_rebekah.items.notebookofthedead'),
		psoraisis = require('codes_rebekah.items.psoraisis'),
	},
	slots = {
		mirror = require('codes_rebekah.slots.mirror'),
		mirrorconverter = require('codes_rebekah.slots.mirrorconverter')
	},
	shaders = require('codes_rebekah.shaders'),
	stages = {
		gen = {
			rebekahsroom = require('codes_rebekah.floors.gen.rebekahsbedroom'),
			},
		rebekahsroom = require('codes_rebekah.floors.rebekahsbedroom'),
		--liminal = require('codes_rebekah.floors.backrooms')
	},
	unlocks = {
	},
	descriptions = require('codes_rebekah.dss.descriptions'),
	commands = require('codes_rebekah.commands')
}
