yandereWaifu.LoveRoomPool = {
	[0] = { item = CollectibleType.COLLECTIBLE_HEART, DecreaseBy=1, RemoveOn=0.1, Weight=1 },
	[1] = { item = CollectibleType.COLLECTIBLE_YUM_HEART, DecreaseBy=1, RemoveOn=0.1, Weight=1 },
	[2] = { item = CollectibleType.COLLECTIBLE_SACRED_HEART, DecreaseBy=1, RemoveOn=0.1, Weight=1 },
	[3] = { item = CollectibleType.COLLECTIBLE_ISAACS_HEART, DecreaseBy=1, RemoveOn=0.1, Weight=1 },
	[4] = { item = CollectibleType.COLLECTIBLE_IMMACULATE_HEART, DecreaseBy=1, RemoveOn=0.1, Weight=1 },
	[5] = { item = CollectibleType.COLLECTIBLE_YUCK_HEART, DecreaseBy=1, RemoveOn=0.1, Weight=1 },
	[6] = { item = CollectibleType.COLLECTIBLE_CANDY_HEART, DecreaseBy=1, RemoveOn=0.1, Weight=1 },
	[7] = { item = CollectibleType.COLLECTIBLE_EMPTY_HEART, DecreaseBy=1, RemoveOn=0.1, Weight=1 },
	[8] = { item = CollectibleType.COLLECTIBLE_HEARTBREAK, DecreaseBy=1, RemoveOn=0.1, Weight=1 },
	[9] = { item = CollectibleType.COLLECTIBLE_BBF, DecreaseBy=1, RemoveOn=0.1, Weight=1 },
	[10] = { item = CollectibleType.COLLECTIBLE_BFFS, DecreaseBy=1, RemoveOn=0.1, Weight=1 },
	[11] = { item = CollectibleType.COLLECTIBLE_SKATOLE, DecreaseBy=1, RemoveOn=0.1, Weight=1 },
	[12] = { item = CollectibleType.COLLECTIBLE_MULLIGAN, DecreaseBy=1, RemoveOn=0.1, Weight=1 },
	[13] = { item = CollectibleType.COLLECTIBLE_MARROW, DecreaseBy=1, RemoveOn=0.1, Weight=1 },
	[14] = { item = CollectibleType.COLLECTIBLE_POUND_OF_FLESH, DecreaseBy=1, RemoveOn=0.1, Weight=1 },
	[15] = { item = CollectibleType.COLLECTIBLE_DIRTY_MIND, DecreaseBy=1, RemoveOn=0.1, Weight=1 },
	[16] = { item = CollectibleType.COLLECTIBLE_HYPERCOAGULATION, DecreaseBy=1, RemoveOn=0.1, Weight=1 },
	[17] = { item = CollectibleType.COLLECTIBLE_SOUL_LOCKET, DecreaseBy=1, RemoveOn=0.1, Weight=1 },
	[18] = { item = CollectibleType.COLLECTIBLE_BIRTHRIGHT, DecreaseBy=1, RemoveOn=0.1, Weight=1 },
	[19] = { item = RebekahCurseItems.COLLECTIBLE_TIGHTHAIRTIE, DecreaseBy=1, RemoveOn=0.1, Weight=1 },
	[20] = { item = RebekahCurseItems.COLLECTIBLE_HEARTSANDCRAFTS, DecreaseBy=1, RemoveOn=0.1, Weight=1 },
	[21] = { item = RebekahCurseItems.COLLECTIBLE_TECHHZ, DecreaseBy=1, RemoveOn=0.1, Weight=1 },
	[22] = { item = RebekahCurseItems.COLLECTIBLE_LUNCHBOX, DecreaseBy=1, RemoveOn=0.1, Weight=1 },
	[23] = { item = RebekahCurseItems.COLLECTIBLE_POWERLOVE, DecreaseBy=1, RemoveOn=0.1, Weight=1 },
	[24] = { item = RebekahCurseItems.COLLECTIBLE_LOVESICK, DecreaseBy=1, RemoveOn=0.1, Weight=1 },
	[25] = { item = RebekahCurseItems.COLLECTIBLE_SNAP, DecreaseBy=1, RemoveOn=0.1, Weight=1 },
	[26] = { item = RebekahCurseItems.COLLECTIBLE_REBEKAHSFAVORITE, DecreaseBy=1, RemoveOn=0.1, Weight=1 },
	[27] = { item = RebekahCurseItems.COLLECTIBLE_UNREQUITEDLOVE, DecreaseBy=1, RemoveOn=0.1, Weight=1 },
	[28] = { item = RebekahCurseItems.COLLECTIBLE_DICEOFFATE, DecreaseBy=1, RemoveOn=0.1, Weight=1 },
}

if ARACHNAMOD then
	if arachnaIsUnlocked("Witness", false, false) then
		table.insert(yandereWaifu.LoveRoomPool, { item = Isaac.GetItemIdByName("Yarn Heart"), DecreaseBy=1, RemoveOn=0.1, Weight=1 })
	end
end

if Deliverance then
	table.insert(yandereWaifu.LoveRoomPool, { item = Isaac.GetItemIdByName("D<3"), DecreaseBy=1, RemoveOn=0.1, Weight=1 })
	table.insert(yandereWaifu.LoveRoomPool, { item = Isaac.GetItemIdByName("Encharmed Penny"), DecreaseBy=1, RemoveOn=0.1, Weight=1 })
	table.insert(yandereWaifu.LoveRoomPool, { item = Isaac.GetItemIdByName("Good Old Friend"), DecreaseBy=1, RemoveOn=0.1, Weight=1 })
	table.insert(yandereWaifu.LoveRoomPool, { item = Isaac.GetItemIdByName("The Manuscript"), DecreaseBy=1, RemoveOn=0.1, Weight=1 })
	table.insert(yandereWaifu.LoveRoomPool, { item = Isaac.GetItemIdByName("Arterial Heart"), DecreaseBy=1, RemoveOn=0.1, Weight=1 })
	table.insert(yandereWaifu.LoveRoomPool, { item = Isaac.GetItemIdByName("The Covenant"), DecreaseBy=1, RemoveOn=0.1, Weight=1 })
	table.insert(yandereWaifu.LoveRoomPool, { item = Isaac.GetItemIdByName("Time Gal"), DecreaseBy=1, RemoveOn=0.1, Weight=1 })
end

if FiendFolio then
	table.insert(yandereWaifu.LoveRoomPool, { item = FiendFolio.ITEM.COLLECTIBLE.HEART_OF_CHINA, DecreaseBy=1, RemoveOn=0.1, Weight=1 })
	table.insert(yandereWaifu.LoveRoomPool, { item = FiendFolio.ITEM.COLLECTIBLE.X10BADUMP, DecreaseBy=1, RemoveOn=0.1, Weight=1 })
	table.insert(yandereWaifu.LoveRoomPool, { item = FiendFolio.ITEM.COLLECTIBLE.FIEND_HEART, DecreaseBy=1, RemoveOn=0.1, Weight=1 })
	table.insert(yandereWaifu.LoveRoomPool, { item = FiendFolio.ITEM.COLLECTIBLE.YICK_HEART, DecreaseBy=1, RemoveOn=0.1, Weight=1 })
end