
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
		table.insert(RebekahLocalSavedata.Data.newLoveRoomPool, { item = RebekahCurse.Items.COLLECTIBLE_LUNCHBOX, DecreaseBy=1, RemoveOn=0.1, Weight=1 })
	end
	if yandereWaifu.ACHIEVEMENT.LOVE_POWER:IsUnlocked() then
		table.insert(RebekahLocalSavedata.Data.newLoveRoomPool, { item = RebekahCurse.Items.COLLECTIBLE_POWERLOVE, DecreaseBy=1, RemoveOn=0.1, Weight=1 })
	end
	if yandereWaifu.ACHIEVEMENT.DICE_OF_FATE:IsUnlocked() then
		table.insert(RebekahLocalSavedata.Data.newLoveRoomPool, { item = RebekahCurse.Items.COLLECTIBLE_DICEOFFATE, DecreaseBy=1, RemoveOn=0.1, Weight=1 })
	end
	if yandereWaifu.ACHIEVEMENT.UNREQUITED_LOVE:IsUnlocked() then
		table.insert(RebekahLocalSavedata.Data.newLoveRoomPool, { item = RebekahCurse.Items.COLLECTIBLE_UNREQUITEDLOVE, DecreaseBy=1, RemoveOn=0.1, Weight=1 })
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

	--Thrift shop
	RebekahLocalSavedata.Data.newThriftShopPool = InutilLib.Deepcopy(yandereWaifu.ThriftShopPool)
end



function yandereWaifu.GetItemInPool(pool)
	--[[for i, v in ipairs(pool) do
		local rng = math.random(1,5)
		if rng == 5 and not v.IsNotAvailable then
			v.IsNotAvailable = true
			return v
		end
	end]]
	if #pool > 0 then
		local index = math.random( #pool )
		--print(index)
		return pool[index], index
	else
		return nil
	end
end


-------LOVE ROOM----------

function yandereWaifu.RebekahItemPools(_, hasstarted) --Init
	if not hasstarted then
		yandereWaifu.RebekahGenerateItemPools()
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, yandereWaifu.RebekahItemPools)

function yandereWaifu.RerollToRebekahPool(pickup, pool)
	--local index = math.random(0,#yandereWaifu.LoveRoomPool)
	local items = nil
	local attempts = 0
	local index
	local pool = pool or RebekahLocalSavedata.Data.newLoveRoomPool
	while (not items) and attempts < 5 do
		items, index = yandereWaifu.GetItemInPool(pool)
		attempts = attempts + 1
	end

	for i, v in ipairs(pool) do
	end

	local subtype
	if not items then
		subtype = CollectibleType.COLLECTIBLE_BREAKFAST --time to breakfast
	else
		subtype = items.item
		--items.IsNotAvailable = true
		table.remove(pool, index)
		--print(index)
	end

	pickup = pickup:ToPickup()
	--[[print(#yandereWaifu.LoveRoomPool)
	print(subtype)
	print(pickup.Type)
	]]
	local isShop = pickup:IsShopItem()
	pickup = pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, subtype, true, true, false)
	--items.Weight = items.Weight - items.DecreaseBy
	--if isShop then pickup.Price = 15 end
	--if items.Weight <= items.RemoveOn then
	--	table.remove(yandereWaifu.LoveRoomPool, index)
	--	print("remove")
	--end
	--print(#yandereWaifu.LoveRoomPool)
	--local newColl = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, yandereWaifu.LoveRoomPool[math.random(1,#yandereWaifu.LoveRoomPool)], position, Vector.Zero, ent)
end
yandereWaifu:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, pickup)
	local data = yandereWaifu.GetEntityData(pickup)
	data.justSpawned = false
	if not data.IsRerolled then data.IsRerolled = 0 end
	--print(StageAPI.GetCurrentRoomType())
	if StageAPI.GetCurrentRoomType() == "Love Room" then
		local validPickup = (pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE)
		for i, poof in pairs (Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, -1, false, false)) do
			if poof.Position:Distance(pickup.Position) < 1 and poof.FrameCount == 1 and ((data.IsRerolled + 15 < InutilLib.game:GetFrameCount())) then
				data.justSpawned = true
				data.IsRerolled = InutilLib.game:GetFrameCount()
			end
		end
		if validPickup and data.justSpawned and not pickup.SpawnerEntity then
			--if pickup.SubType ~= yandereWaifu.LoveRoomPool[j] then
				yandereWaifu.RerollToRebekahPool(pickup)
				--data.IsRerolled = false
			--end
		end
	elseif StageAPI.GetCurrentRoomType() == "Thrift Shop" then
		local validPickup = (pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE)
		for i, poof in pairs (Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, -1, false, false)) do
			if poof.Position:Distance(pickup.Position) < 1 and poof.FrameCount == 1 and ((data.IsRerolled + 15 < InutilLib.game:GetFrameCount())) then
				data.justSpawned = true
				data.IsRerolled = InutilLib.game:GetFrameCount()
			end
		end
		if validPickup and data.justSpawned and not pickup.SpawnerEntity then
			--if pickup.SubType ~= yandereWaifu.LoveRoomPool[j] then
				yandereWaifu.RerollToRebekahPool(pickup, RebekahLocalSavedata.Data.newThriftShopPool)
				--data.IsRerolled = false
				pickup.Price = math.floor(pickup.Price / 2)
				pickup.AutoUpdatePrice = false
				print("balls")
				print(pickup.Price)
			--end
		end
	end
end)

if StageAPI and StageAPI.Loaded then
yandereWaifu:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function() --love room pool gimmick
	if StageAPI.GetCurrentRoomType() == "Love Room" and InutilLib.room:IsFirstVisit() then
		for i, coll in pairs (Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, -1, false, false)) do
			--for j, collpool in pairs(yandereWaifu.LoveRoomPool) do
				if coll.SubType ~= yandereWaifu.LoveRoomPool[i] then
					yandereWaifu.RerollToRebekahPool(coll)
				end
			--end
		end
	elseif StageAPI.GetCurrentRoomType() == "Thrift Shop" and InutilLib.room:IsFirstVisit() then
		for i, coll in pairs (Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, -1, false, false)) do
			--for j, collpool in pairs(yandereWaifu.LoveRoomPool) do
				if coll.SubType ~= yandereWaifu.LoveRoomPool[i] then
					coll = coll:ToPickup()
					yandereWaifu.RerollToRebekahPool(coll, RebekahLocalSavedata.Data.newThriftShopPool)
					coll.Price = math.floor(coll.Price / 2)
					coll.AutoUpdatePrice = false
					print("balls")
					print(coll.Price)
				end
			--end
		end
	end
	--delete if mirror world
	if InutilLib.room:IsMirrorWorld() and InutilLib.room:IsFirstVisit() then
		for i, pickup in pairs (Isaac.GetRoomEntities()) do
			if pickup.Type == EntityType.ENTITY_PICKUP then
				pickup:Remove()
			end
		end
	end
end)

function yandereWaifu:useLoveRoom(collItem, rng) --dice pool reroll
	for i, coll in pairs (Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, -1, false, false)) do
		if StageAPI.GetCurrentRoomType() == "Love Room" then
			if coll.SubType ~= 0 then
				--if coll.SubType ~= yandereWaifu.LoveRoomPool[j] then
					yandereWaifu.RerollToRebekahPool(coll)
				--end
			end
		end
	end
end
--yandereWaifu:AddCallback(ModCallbacks.MC_USE_ITEM, yandereWaifu.useLoveRoom, CollectibleType.COLLECTIBLE_D6)
--yandereWaifu:AddCallback(ModCallbacks.MC_USE_ITEM, yandereWaifu.useLoveRoom, CollectibleType.COLLECTIBLE_D100)

end