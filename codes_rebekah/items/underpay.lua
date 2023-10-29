local hasUnderpay = false

yandereWaifu:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, pickup)
	local chance = 1/2
    local rng = pickup:GetDropRNG()
    local spr = pickup:GetSprite()
    if pickup.Variant == RebekahCurse.ENTITY_COINPIECE then
        if spr:IsEventTriggered("DropSound") then
            InutilLib.SFX:Play(SoundEffect.SOUND_PENNYDROP, 1, 0, false, 1.2);
        elseif spr:IsPlaying("Collect") and spr:GetFrame() == 2 then
            InutilLib.SFX:Play(SoundEffect.SOUND_PENNYPICKUP, 1, 0, false, 1.2);
            pickup.Velocity = Vector.Zero
            pickup.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        end
    end

    for p = 0, InutilLib.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		local entityData = yandereWaifu.GetEntityData(player);
		local validPickup = (pickup.Variant == PickupVariant.PICKUP_COIN)
		if (player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_UNDERPAY)) then
			if rng:RandomFloat() <= (chance) and validPickup and InutilLib.room:GetType() ~= RoomType.ROOM_BOSS and RebekahCurseGlobalData.EASTER_EGG_NO_MORPH_FRAME == 0 
		and (pickup:GetSprite():IsPlaying("Appear") or pickup:GetSprite():IsPlaying("AppearFast")) and pickup:GetSprite():GetFrame() == 1 and not pickup.SpawnerEntity then
				if pickup.SubType == CoinSubType.COIN_NICKEL then
					for i = 0, math.random(10,15) do
						local newpickup = yandereWaifu.SpawnCoinPiece(pickup.Position, player, pickup:IsShopItem())
						newpickup.OptionsPickupIndex = pickup.OptionsPickupIndex
                        newpickup.Velocity = Vector.FromAngle(math.random(1,360)):Resized(math.random(3,5))
					end
                elseif pickup.SubType == CoinSubType.COIN_DIME then
					for i = 0, math.random(20,30) do
						local newpickup = yandereWaifu.SpawnCoinPiece(pickup.Position, player, pickup:IsShopItem())
						newpickup.OptionsPickupIndex = pickup.OptionsPickupIndex
                        newpickup.Velocity = Vector.FromAngle(math.random(1,360)):Resized(math.random(3,5))
					end
                elseif pickup.SubType == CoinSubType.COIN_DOUBLEPACK then
					for i = 0, math.random(4,8) do
						local newpickup = yandereWaifu.SpawnCoinPiece(pickup.Position, player, pickup:IsShopItem())
						newpickup.OptionsPickupIndex = pickup.OptionsPickupIndex
                        newpickup.Velocity = Vector.FromAngle(math.random(1,360)):Resized(math.random(3,5))
					end
                else
					for i = 0, math.random(1,3) do
						local newpickup = yandereWaifu.SpawnCoinPiece(pickup.Position, player, pickup:IsShopItem())
						newpickup.OptionsPickupIndex = pickup.OptionsPickupIndex
                        newpickup.Velocity = Vector.FromAngle(math.random(1,360)):Resized(math.random(3,5))
					end
				end
				pickup:Remove()
			end
		end
	end
	
end)

function yandereWaifu.VerifyDecimalCoins()
    local player = Isaac.GetPlayer(0)
    local data = yandereWaifu.GetEntityData(player)
    if not data.PersistentPlayerData.DecimalUnderpaidCoins then
        data.PersistentPlayerData.DecimalUnderpaidCoins = 0
    end
end

function yandereWaifu.GetDecimalCoins()
    local player = Isaac.GetPlayer(0)
    local data = yandereWaifu.GetEntityData(player)
    yandereWaifu.VerifyDecimalCoins()
    return data.PersistentPlayerData.DecimalUnderpaidCoins
end

function yandereWaifu.AddDecimalCoins(num)
    local player = Isaac.GetPlayer(0)
    local data = yandereWaifu.GetEntityData(player)
    yandereWaifu.VerifyDecimalCoins()
    data.PersistentPlayerData.DecimalUnderpaidCoins = yandereWaifu.GetDecimalCoins() + num
end

yandereWaifu:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)
    hasUnderpay = false
	--if player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_UNDERPAY) then
		local pickups = Isaac.FindByType(5, RebekahCurse.ENTITY_COINPIECE, 177, false, false)
        --Isaac.FindInRadius(player.Position, player.Size + 15, EntityPartition.PICKUP)
		for _, pickup in pairs(pickups) do
            if player.Position:Distance(pickup.Position) < player.Size + pickup.Size then
                pickup = pickup:ToPickup()
                if pickup and pickup.Wait <= 0 then
                    local picked = InutilLib.PickupPickup(pickup)
                    yandereWaifu.AddDecimalCoins(math.random(1,2))
                end
            end
		end
	--end
    if player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_UNDERPAY) then
        hasUnderpay = true
    end
    local savedata = nil
    if FiendFolio then
        savedata = FiendFolio.savedata.run
    end
    if FiendFolio and savedata and savedata.dadsdebt and savedata.dadsdebt > 0 then
        if yandereWaifu.GetDecimalCoins() > 0 then
            local remainder = math.abs(savedata.dadsdebt - (math.abs(yandereWaifu.GetDecimalCoins()))/10)
            savedata.dadsdebt = savedata.dadsdebt - math.abs((math.abs(yandereWaifu.GetDecimalCoins()))/10)
            if math.floor(savedata.dadsdebt) == 0.1 then
                savedata.dadsdebt = 0.1
            end
            yandereWaifu.AddDecimalCoins(-yandereWaifu.GetDecimalCoins())
            --debtChange = true
            if savedata.dadsdebt <= 0 then
                savedata.dadsdebt = nil
                if remainder > 0 then
                    player:AddCoins(math.floor(remainder))
                    --yandereWaifu.AddDecimalCoins(remainder % 10)
                end
            end
        end
    else
    
        if yandereWaifu.GetDecimalCoins() >= 10 then
            yandereWaifu.AddDecimalCoins(-10)
            player:AddCoins(1)
        end
    end
end)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, function(_, ent)
	local spr = ent:GetSprite()
	local data = yandereWaifu.GetEntityData(ent)
    if ent:IsEnemy() or ent:IsVulnerableEnemy() then
        if hasUnderpay and math.random(1,3) == 3 then
            for i = 0, math.random(1,3) do
                local newpickup = yandereWaifu.SpawnCoinPiece(ent.Position, player, false)
                newpickup.Velocity = Vector.FromAngle(math.random(1,360)):Resized(math.random(3,5))
            end
        end
    end
end)


--render stuff
local TempestFont = Font()
TempestFont:Load("font/pftempestasevencondensed.fnt")

--inspired BY FF
yandereWaifu:AddCallback(ModCallbacks.MC_POST_RENDER, function()
	if StageAPI and StageAPI.Loaded and StageAPI.IsHUDAnimationPlaying() then
		return
	end
    local savedata
	local coins = yandereWaifu.GetDecimalCoins()
    if FiendFolio then
        savedata = FiendFolio.savedata.run
    end
    if FiendFolio and savedata and savedata.dadsdebt and savedata.dadsdebt > 0 then
        --[[if savedata.dadsdebt then
            local debt = FiendFolio.getField(FiendFolio.savedata, 'run', 'dadsdebt')

            if debt and debt > 0 then
                local hudOffset = Options.HUDOffset * 10
                local coinOffset = Vector(46, 33) + Vector(hudOffset * 2, hudOffset * 1.2)
                TempestFont:DrawStringScaled("." .. tostring(coins), coinOffset.X, coinOffset.Y, 1, 1, KColor(0.631, 0.278, 0.278, 1), 0, false)
            end
        end]]
    else
        if (coins and coins > 0) or (hasUnderpay) then
            local hudOffset = Options.HUDOffset * 10
            local coinOffset = Vector(28, 33) + Vector(hudOffset * 2, hudOffset * 1.2)
            TempestFont:DrawStringScaled("." .. tostring(coins), coinOffset.X, coinOffset.Y, 1, 1, KColor(1, 1, 1, 1), 0, false)
        end
    end
end)

--[[
    yandereWaifu:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)
	local savedata = FiendFolio.savedata.run

	local debtChange
	if player:HasCollectible(CollectibleType.COLLECTIBLE_DADS_WALLET) then
		local pickups = Isaac.FindInRadius(player.Position, player.Size, EntityPartition.PICKUP)
		for _, pickup in ipairs(pickups) do
			pickup = pickup:ToPickup()
			if pickup and pickup:IsShopItem() and pickup.Price > player:GetNumCoins()
			and FiendFolio.CanPurchasePickup(player, pickup)
			and player:IsExtraAnimationFinished() then
				local coins = player:GetNumCoins()
				local debt = pickup.Price - coins
				if not savedata.dadsdebt then
					savedata.dadsdebt = 0
				end

				if (savedata.dadsdebt + debt) <= 99 then
					pickup.Price = PickupPrice.PRICE_FREE
					pickup.AutoUpdatePrice = false
					savedata.dadsdebt = savedata.dadsdebt + debt
					player:AddCoins(-coins)
					debtChange = true
				end
			end
		end
	end
	if savedata.dadsdebt and player:GetNumCoins() > 0 then
		local coins = player:GetNumCoins()
		player:AddCoins(-savedata.dadsdebt)
		savedata.dadsdebt = savedata.dadsdebt - coins
		debtChange = true
		if savedata.dadsdebt <= 0 then
			savedata.dadsdebt = nil
		end
	end

	if debtChange then
		player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
		player:EvaluateItems()
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
	if StageAPI and StageAPI.Loaded and StageAPI.IsHUDAnimationPlaying() then
		return
	end

	local debt = mod.getField(FiendFolio.savedata, 'run', 'dadsdebt')

	if debt and debt > 0 then
		local hudOffset = Options.HUDOffset * 10
		local coinOffset = Vector(30, 33) + Vector(hudOffset * 2, hudOffset * 1.2)
		mod.TempestFont:DrawStringScaled("-" .. tostring(debt), coinOffset.X, coinOffset.Y, 1, 1, KColor(0.631, 0.278, 0.278, 1), 0, false)
	end
end)
]]