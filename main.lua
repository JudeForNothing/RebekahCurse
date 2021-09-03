-- Welcome to my crappy code

yandereWaifu = RegisterMod("Rebekah", 1)

-- Good Lord what have I done

-- Require up those extra modules
yandereWaifuCodes = {
	init = nil,
	enums = require('codes.enums'),
	library = require('codes.library'),
	savedata = require('codes.savedata'),
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
	entities = {
		basiceffects = require('codes.entities.basiceffects'),
		customplayeranim = require('codes.entities.customplayeranim')
	},
	slots = {
		mirror = require('codes.slots.mirror')
	},
	unlocks = {
	},
	commands = require('codes.commands')
}
-- Reset the information when moving rooms so that we don't have false positive double taps across rooms
