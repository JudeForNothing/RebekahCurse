yandereWaifu.LoveRoomPool = {
	{ item = CollectibleType.COLLECTIBLE_HEART, DecreaseBy=1, RemoveOn=0.1, Weight=1 },
	{ item = CollectibleType.COLLECTIBLE_YUM_HEART, DecreaseBy=1, RemoveOn=0.1, Weight=1 },
	{ item = CollectibleType.COLLECTIBLE_YUCK_HEART, DecreaseBy=1, RemoveOn=0.1, Weight=1 },
	{ item = CollectibleType.COLLECTIBLE_CANDY_HEART, DecreaseBy=1, RemoveOn=0.1, Weight=1 },
	{ item = CollectibleType.COLLECTIBLE_EMPTY_HEART, DecreaseBy=1, RemoveOn=0.1, Weight=1 },
	{ item = CollectibleType.COLLECTIBLE_HEARTBREAK, DecreaseBy=1, RemoveOn=0.1, Weight=1 },
	{ item = CollectibleType.COLLECTIBLE_BBF, DecreaseBy=1, RemoveOn=0.1, Weight=1 },
	{ item = CollectibleType.COLLECTIBLE_BFFS, DecreaseBy=1, RemoveOn=0.1, Weight=1 },
	{ item = CollectibleType.COLLECTIBLE_SKATOLE, DecreaseBy=1, RemoveOn=0.1, Weight=1 },
	{ item = CollectibleType.COLLECTIBLE_MULLIGAN, DecreaseBy=1, RemoveOn=0.1, Weight=1 },
	{ item = CollectibleType.COLLECTIBLE_DIRTY_MIND, DecreaseBy=1, RemoveOn=0.1, Weight=1 },
	{ item = CollectibleType.COLLECTIBLE_HYPERCOAGULATION, DecreaseBy=1, RemoveOn=0.1, Weight=1 },
	{ item = CollectibleType.COLLECTIBLE_SOUL_LOCKET, DecreaseBy=1, RemoveOn=0.1, Weight=1 },
	{ item = RebekahCurseItems.COLLECTIBLE_TIGHTHAIRTIE, DecreaseBy=1, RemoveOn=0.1, Weight=1 },
	{ item = RebekahCurseItems.COLLECTIBLE_HEARTSANDCRAFTS, DecreaseBy=1, RemoveOn=0.1, Weight=1 },
	{ item = RebekahCurseItems.COLLECTIBLE_TECHHZ, DecreaseBy=1, RemoveOn=0.1, Weight=1 },
	{ item = RebekahCurseItems.COLLECTIBLE_LOVESICK, DecreaseBy=1, RemoveOn=0.1, Weight=1 },
	{ item = RebekahCurseItems.COLLECTIBLE_SNAP, DecreaseBy=1, RemoveOn=0.1, Weight=1 },
	{ item = RebekahCurseItems.COLLECTIBLE_REBEKAHSFAVORITE, DecreaseBy=1, RemoveOn=0.1, Weight=1 },
}

function yandereWaifu.RebekahGenerateItemPools() --Ini
	print("TRIGGER HOW MUCH DO I NEED TO ADD")
	RebekahLocalSavedata.Data.newLoveRoomPool = InutilLib.Deepcopy(yandereWaifu.LoveRoomPool)

	if Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_SACRED_HEART):IsAvailable() then
		table.insert(RebekahLocalSavedata.Data.newLoveRoomPool, { item = CollectibleType.COLLECTIBLE_SACRED_HEART, DecreaseBy=1, RemoveOn=0.1, Weight=1 })
	end
	if Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_ISAACS_HEART):IsAvailable() then
		table.insert(RebekahLocalSavedata.Data.newLoveRoomPool, { item = CollectibleType.COLLECTIBLE_ISAACS_HEART, DecreaseBy=1, RemoveOn=0.1, Weight=1 })
	end
	if Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_IMMACULATE_HEART):IsAvailable() then
		table.insert(RebekahLocalSavedata.Data.newLoveRoomPool, { item = CollectibleType.COLLECTIBLE_IMMACULATE_HEART, DecreaseBy=1, RemoveOn=0.1, Weight=1 })
	end
	if Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_MARROW):IsAvailable() then
		table.insert(RebekahLocalSavedata.Data.newLoveRoomPool, { item = CollectibleType.COLLECTIBLE_MARROW, DecreaseBy=1, RemoveOn=0.1, Weight=1 })
	end
	if Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_POUND_OF_FLESH):IsAvailable() then
		table.insert(RebekahLocalSavedata.Data.newLoveRoomPool, { item = CollectibleType.COLLECTIBLE_POUND_OF_FLESH, DecreaseBy=1, RemoveOn=0.1, Weight=1 })
	end
	if Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT):IsAvailable() then
		table.insert(RebekahLocalSavedata.Data.newLoveRoomPool, { item = CollectibleType.COLLECTIBLE_BIRTHRIGHT, DecreaseBy=1, RemoveOn=0.1, Weight=1 })
	end
	if yandereWaifu.ACHIEVEMENT.LUNCHBOX:IsUnlocked() then
		table.insert(RebekahLocalSavedata.Data.newLoveRoomPool, { item = RebekahCurseItems.COLLECTIBLE_LUNCHBOX, DecreaseBy=1, RemoveOn=0.1, Weight=1 })
	end
	if yandereWaifu.ACHIEVEMENT.LOVE_POWER:IsUnlocked() then
		table.insert(RebekahLocalSavedata.Data.newLoveRoomPool, { item = RebekahCurseItems.COLLECTIBLE_POWERLOVE, DecreaseBy=1, RemoveOn=0.1, Weight=1 })
	end
	if yandereWaifu.ACHIEVEMENT.DICE_OF_FATE:IsUnlocked() then
		table.insert(RebekahLocalSavedata.Data.newLoveRoomPool, { item = RebekahCurseItems.COLLECTIBLE_DICEOFFATE, DecreaseBy=1, RemoveOn=0.1, Weight=1 })
	end
	if yandereWaifu.ACHIEVEMENT.UNREQUITED_LOVE:IsUnlocked() then
		table.insert(RebekahLocalSavedata.Data.newLoveRoomPool, { item = RebekahCurseItems.COLLECTIBLE_UNREQUITEDLOVE, DecreaseBy=1, RemoveOn=0.1, Weight=1 })
	end
	if ARACHNAMOD then
		if arachnaIsUnlocked("Witness", false, false) then
			table.insert(RebekahLocalSavedata.Data.newLoveRoomPool, { item = Isaac.GetItemIdByName("Yarn Heart"), DecreaseBy=1, RemoveOn=0.1, Weight=1 })
		end
	end
	if Deliverance then
		table.insert(RebekahLocalSavedata.Data.newLoveRoomPool, { item = Isaac.GetItemIdByName("D<3"), DecreaseBy=1, RemoveOn=0.1, Weight=1 })
		table.insert(RebekahLocalSavedata.Data.newLoveRoomPool, { item = Isaac.GetItemIdByName("Encharmed Penny"), DecreaseBy=1, RemoveOn=0.1, Weight=1 })
		table.insert(RebekahLocalSavedata.Data.newLoveRoomPool, { item = Isaac.GetItemIdByName("Good Old Friend"), DecreaseBy=1, RemoveOn=0.1, Weight=1 })
		table.insert(RebekahLocalSavedata.Data.newLoveRoomPool, { item = Isaac.GetItemIdByName("The Manuscript"), DecreaseBy=1, RemoveOn=0.1, Weight=1 })
		table.insert(RebekahLocalSavedata.Data.newLoveRoomPool, { item = Isaac.GetItemIdByName("Arterial Heart"), DecreaseBy=1, RemoveOn=0.1, Weight=1 })
		table.insert(RebekahLocalSavedata.Data.newLoveRoomPool, { item = Isaac.GetItemIdByName("The Covenant"), DecreaseBy=1, RemoveOn=0.1, Weight=1 })
		table.insert(RebekahLocalSavedata.Data.newLoveRoomPool, { item = Isaac.GetItemIdByName("Time Gal"), DecreaseBy=1, RemoveOn=0.1, Weight=1 })
	end

	if FiendFolio then
		table.insert(RebekahLocalSavedata.Data.newLoveRoomPool, { item = FiendFolio.ITEM.COLLECTIBLE.HEART_OF_CHINA, DecreaseBy=1, RemoveOn=0.1, Weight=1 })
		table.insert(RebekahLocalSavedata.Data.newLoveRoomPool, { item = FiendFolio.ITEM.COLLECTIBLE.X10BADUMP, DecreaseBy=1, RemoveOn=0.1, Weight=1 })
		table.insert(RebekahLocalSavedata.Data.newLoveRoomPool, { item = FiendFolio.ITEM.COLLECTIBLE.FIEND_HEART, DecreaseBy=1, RemoveOn=0.1, Weight=1 })
		table.insert(RebekahLocalSavedata.Data.newLoveRoomPool, { item = FiendFolio.ITEM.COLLECTIBLE.YICK_HEART, DecreaseBy=1, RemoveOn=0.1, Weight=1 })
	end
end
