yandereWaifu:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, function(_,  tr)
	local player = tr.SpawnerEntity:ToPlayer()
	local pldata = yandereWaifu.GetEntityData(player)
    local data = yandereWaifu.GetEntityData(tr)
	if player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_CHEESYPIZZA) then
		--if math.random(1,5) == 5 then
            data.IsCheesyPizza = true
       -- end
	end
end);

--unlock
yandereWaifu:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function(_,  player)
    local data = yandereWaifu.GetEntityData(player)
	if player:HasCollectible(CollectibleType.COLLECTIBLE_ROTTEN_TOMATO) and player:HasCollectible(CollectibleType.COLLECTIBLE_SAUSAGE) then
		if player:HasCollectible(CollectibleType.COLLECTIBLE_MIDNIGHT_SNACK) or player:HasCollectible(CollectibleType.COLLECTIBLE_BREAKFAST) or player:HasCollectible(CollectibleType.COLLECTIBLE_WAFER) or player:HasCollectible(CollectibleType.COLLECTIBLE_SOY_MILK) or player:HasCollectible(CollectibleType.COLLECTIBLE_MILK) then
			if not yandereWaifu.ACHIEVEMENT.CHEESY_PIZZA:IsUnlocked() then
				yandereWaifu.ACHIEVEMENT.CHEESY_PIZZA:Unlock()
			end
		end
	end
end);

function yandereWaifu:CheesyPizzaTearRender(tr, _)
    if not tr.SpawnerEntity then return end
    local player, data, flags, scale = tr.SpawnerEntity:ToPlayer(), yandereWaifu.GetEntityData(tr), tr.TearFlags, tr.Scale 
    local isValidPizza = data.IsCheesyPizza or (tr:HasTearFlags(TearFlags.TEAR_LUDOVICO) and player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_CHEESYPIZZA))
	if isValidPizza and tr.FrameCount <= 1 then
		local size = InutilLib.GetTearSizeTypeI(scale, flags)
		InutilLib.UpdateRegularTearAnimation(player, tr, data, flags, size, "RegularTear");
		--InutilLib.UpdateDynamicTearAnimation(player, tr, data, flags, "Rotate", "", size)
	end
    if not isValidPizza then return end

	if not data.Init then                                             
		data.spr = Sprite()                      
		data.spr:Load("gfx/effects/items/cheese_string.anm2", true)
		data.Init = true                     
	end
    tr:SetColor(Color(1,0.5,0,1,0,0,0), 999, 999, true, false)
    data.spr:SetFrame("Chain", 0)--math.floor(tr.FrameCount % 4))
	InutilLib.DeadDrawRotatedTilingSprite(data.spr, Isaac.WorldToScreen(player.Position+Vector(0,-15)), Isaac.WorldToScreen(tr.Position+Vector(0,-15)), 30, nil, 8, true)
	--[[i hate you api
	data.sprOverlay = tr:GetSprite()
	data.sprOverlay:Render(Isaac.WorldToScreen(tr.Position))]]
end
yandereWaifu:AddCallback(ModCallbacks.MC_POST_TEAR_RENDER, yandereWaifu.CheesyPizzaTearRender)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, function(_,  tr)
    if not tr.SpawnerEntity then return end
    local player = tr.SpawnerEntity:ToPlayer()
	local pldata = yandereWaifu.GetEntityData(player)
	local data = yandereWaifu.GetEntityData(tr)
    local function cheese_string()
        local angle, dist = (tr.Position - player.Position):GetAngleDegrees(), (tr.Position - player.Position):Length()

        for i, ent in pairs (Isaac.FindInRadius(tr.Position, 9500, EntityPartition.ENEMY)) do
            if InutilLib.CuccoLaserCollision(player, angle, dist, ent, 30) then
                ent:AddBurn(EntityRef(player), 150, 2)
            end
        end
    end
	if tr.SpawnerEntity then
		if data.IsCheesyPizza then
			if not data.Player then data.Player = player end
			if tr.FrameCount % 5 == 0 then
				--[[tr.Velocity = tr.Velocity*0.9
				local tears = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0, tr.Position, Vector.Zero , player):ToTear()
				tears.Scale = tr.Scale * 0.5
				tears.Height = tr.Height
				tears.CollisionDamage = player.Damage * 0.5]]
				--InutilLib.MakeTearLob(tears, 1.5, 9 )
                cheese_string()
			end
		end
	end
    if tr:HasTearFlags(TearFlags.TEAR_LUDOVICO) and player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_CHEESYPIZZA) and tr.FrameCount % 5 == 0 then
        cheese_string()
    end
end);

yandereWaifu:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, function(_, tr)
    tr = tr:ToTear()
    if tr.SpawnerEntity then
        local player, data, flags, scale = tr.SpawnerEntity:ToPlayer(), yandereWaifu.GetEntityData(tr), tr.TearFlags, tr.Scale 
        local isValidPizza = data.IsCheesyPizza or (player and tr:HasTearFlags(TearFlags.TEAR_LUDOVICO) and player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_CHEESYPIZZA))
        if isValidPizza then
            local table = InutilLib.DeadGetTilingSprite((player.Position), (tr.Position), 30, nil, 8, true)
            for i, v in pairs(table) do
                local tears = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0, v, Vector.Zero , player):ToTear()
                tears.Scale = tears.Scale * 0.5
                tears.CollisionDamage = player.Damage * 0.5
                tears:SetColor(Color(1,0.5,0,1,0,0,0), 999, 999, true, false)
            end
        end
    end
end, EntityType.ENTITY_TEAR)

function yandereWaifu:CheesyPizzaKnifeRender(tr, _)
    if not tr.SpawnerEntity then return end
    local player, data, flags, scale = tr.SpawnerEntity:ToPlayer(), yandereWaifu.GetEntityData(tr), tr.TearFlags, tr.Scale 
    local isValidPizza = player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_CHEESYPIZZA)
	if isValidPizza and tr.FrameCount <= 1 then
		local size = InutilLib.GetTearSizeTypeI(scale, flags)
		InutilLib.UpdateRegularTearAnimation(player, tr, data, flags, size, "RegularTear");
		--InutilLib.UpdateDynamicTearAnimation(player, tr, data, flags, "Rotate", "", size)
	end
    if not isValidPizza then return end

	if not data.Init then                                             
		data.spr = Sprite()                      
		data.spr:Load("gfx/effects/items/cheese_string.anm2", true)
		data.Init = true                     
	end
    tr:SetColor(Color(1,0.5,0,1,0,0,0), 999, 999, true, false)
    data.spr:SetFrame("Chain", 0)--math.floor(tr.FrameCount % 4))
	InutilLib.DeadDrawRotatedTilingSprite(data.spr, Isaac.WorldToScreen(player.Position+Vector(0,-15)), Isaac.WorldToScreen(tr.Position+Vector(0,-15)), 30, nil, 8, true)
	--[[i hate you api
	data.sprOverlay = tr:GetSprite()
	data.sprOverlay:Render(Isaac.WorldToScreen(tr.Position))]]
end
yandereWaifu:AddCallback(ModCallbacks.MC_POST_KNIFE_RENDER, yandereWaifu.CheesyPizzaKnifeRender)


yandereWaifu:AddCallback(ModCallbacks.MC_POST_KNIFE_UPDATE, function(_, kn)

	local player = kn.SpawnerEntity:ToPlayer()
	local pldata = yandereWaifu.GetEntityData(player)
	if player and player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_CHEESYPIZZA) then
		local spr = kn:GetSprite()
        local function cheese_string()
            local angle, dist = (kn.Position - player.Position):GetAngleDegrees(), (kn.Position - player.Position):Length()

            for i, ent in pairs (Isaac.FindInRadius(kn.Position, 9500, EntityPartition.ENEMY)) do
                if InutilLib.CuccoLaserCollision(player, angle, dist, ent, 30) then
                    ent:AddBurn(EntityRef(player), 150, 2)
                end
            end
        end
		if player:HasWeaponType(WeaponType.WEAPON_KNIFE) then
			if kn:IsFlying() then
                cheese_string()
            end
		elseif player:HasWeaponType(WeaponType.WEAPON_BONE) then
			if kn:IsFlying() then
                cheese_string()
            end
		elseif player:HasWeaponType(WeaponType.WEAPON_SPIRIT_SWORD) then
			if kn:IsFlying() then
                cheese_string()
            end
		end
	end
end)