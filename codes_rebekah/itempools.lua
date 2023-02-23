
-------LOVE ROOM----------

function yandereWaifu.RebekahItemPools(_, hasstarted) --Init
	if not hasstarted then
		yandereWaifu.RebekahGenerateItemPools()
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, yandereWaifu.RebekahItemPools)

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

function yandereWaifu.RerollToLoveRoomPool(pickup)
	--local index = math.random(0,#yandereWaifu.LoveRoomPool)
	local items = nil
	local attempts = 0
	local index
	while (not items) and attempts < 5 do
		print("I love everything")
		items, index = yandereWaifu.GetItemInPool(RebekahLocalSavedata.Data.newLoveRoomPool)
		attempts = attempts + 1
	end

	for i, v in ipairs(RebekahLocalSavedata.Data.newLoveRoomPool) do
		print(v.item)
	end

	local subtype
	if not items then
		subtype = CollectibleType.COLLECTIBLE_BREAKFAST --time to breakfast
	else
		subtype = items.item
		--items.IsNotAvailable = true
		table.remove(RebekahLocalSavedata.Data.newLoveRoomPool, index)
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
	if StageAPI.GetCurrentRoomType() == "Love Room" then
		if not data.IsRerolled then data.IsRerolled = 0 end
		local validPickup = (pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE)
		for i, poof in pairs (Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, -1, false, false)) do
			if poof.Position:Distance(pickup.Position) < 1 and poof.FrameCount == 1 and ((data.IsRerolled + 15 < ILIB.game:GetFrameCount())) then
				data.justSpawned = true
				data.IsRerolled = ILIB.game:GetFrameCount()
			end
		end
		if validPickup and data.justSpawned and not pickup.SpawnerEntity then
			--if pickup.SubType ~= yandereWaifu.LoveRoomPool[j] then
				yandereWaifu.RerollToLoveRoomPool(pickup)
				--data.IsRerolled = false
			--end
		end
	end
end)

if StageAPI and StageAPI.Loaded then
yandereWaifu:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function() --love room pool gimmick
	if StageAPI.GetCurrentRoomType() == "Love Room" and ILIB.room:IsFirstVisit() then
		for i, coll in pairs (Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, -1, false, false)) do
			--for j, collpool in pairs(yandereWaifu.LoveRoomPool) do
				if coll.SubType ~= yandereWaifu.LoveRoomPool[j] then
					yandereWaifu.RerollToLoveRoomPool(coll)
				end
			--end
		end
	end
	--delete if mirror world
	if ILIB.room:IsMirrorWorld() and ILIB.room:IsFirstVisit() then
		print("haelp")
		for i, pickup in pairs (Isaac.GetRoomEntities()) do
			if pickup.Type == EntityType.ENTITY_PICKUP then
				print("help")
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
					yandereWaifu.RerollToLoveRoomPool(coll)
				--end
			end
		end
	end
	
end
yandereWaifu:AddCallback(ModCallbacks.MC_USE_ITEM, yandereWaifu.useLoveRoom, CollectibleType.COLLECTIBLE_D6)
yandereWaifu:AddCallback(ModCallbacks.MC_USE_ITEM, yandereWaifu.useLoveRoom, CollectibleType.COLLECTIBLE_D100)

end