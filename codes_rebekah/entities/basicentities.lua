--Color(1, 1, 2.25, 1, 0, 0, 0)
local customColor = Color(1, 1, 2.25, 1, 0, 0, 0)

--NPC UPDATE!11!!1!!
--[[do
yandereWaifu:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, ent)
	local player = Isaac.GetPlayer(0)
	local data = GetEntityData(ent)
	
	--blessed effect
	if data.IsBlessed then
		ent:SetColor(customColor, 2, 5, true, true)
	end
	if data.IsBlessed then
		if ent:IsDead() then -- on death
			for i, entenmies in pairs(Isaac.GetRoomEntities()) do --affect others
				if entenmies:IsEnemy() and entenmies:IsVulnerableEnemy() then
					if entenmies:GetData().IsBlessed then
						entenmies:TakeDamage(player.Damage, 0, EntityRef(ent), 1)
					end
				end
			end
		end
	end
	if data.BurstGuts then
		if ent:HasMortalDamage() then
			local amount = math.ceil(ent.Size / 3)
			for i = 0, amount do
				local var = TearVariant.BLOOD
				if math.random(1,3) == 3 then
					var = TearVariant.BONE
				end
				local tears =  Isaac.Spawn(EntityType.ENTITY_TEAR, var, 0, ent.Position, Vector(0,-8):Rotated(math.random(0,360)), player):ToTear()
				InutilLib.MakeTearLob(tears, 1.5, 9 )
			end
		end
		data.BurstGuts = false
	end
	
	--lovesick effect
	if ent:HasEntityFlags(EntityFlag.FLAG_CHARM) and player:HasCollectible(COLLECTIBLE_LOVESICK) then
		if game:GetFrameCount() % 120 == 0 then
			ent:TakeDamage(3.5, 0, EntityRef(player), 4)
		end
	end
end)
yandereWaifu:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, function(_, ent)
    local data = ent:GetData()
    if data.IsBlessed then

        if not game:IsPaused() then
            data.IsBlessed = data.IsBlessed - 1
            if data.IsBlessed <= 0 then
                data.IsBlessed = nil
            end
        end
    end
end)
end
]]

--rebekah miniisaac thing
function yandereWaifu:MiniIsaacReplaceSpritesheet(fam)
	local player = fam.Player
	local sprite = fam:GetSprite()
	if yandereWaifu.IsNormalRebekah(player) then
		sprite:ReplaceSpritesheet(0, "gfx/familiar/familiar_minisaac_rebekah.png")
		sprite:ReplaceSpritesheet(1, "gfx/familiar/familiar_minisaac_rebekah.png")
	end
	sprite:LoadGraphics()
end
yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, yandereWaifu.MiniIsaacReplaceSpritesheet, FamiliarVariant.MINISAAC)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	for k, v in pairs(Isaac.GetRoomEntities()) do
		local data = yandereWaifu.GetEntityData(v)
		
		if data.CharmedToParent then
			v.Position = data.CharmedToParent.Position
		end
	end
end)


yandereWaifu:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, ent)
	local player = Isaac.GetPlayer(0)
	local data = yandereWaifu.GetEntityData(ent)
	
	--teleport cooldown of broken mirror
	if data.MirrorBrokenCooldown then
		if data.MirrorBrokenCooldown > 0 then
			data.MirrorBrokenCooldown = data.MirrorBrokenCooldown - 1
			local customColor = Color(1, 0.5, 1, 1, 0, 0, 0)
			ent:SetColor(customColor, 2, 1, false, false)
		end
	end
end)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, ent)
	local player = Isaac.GetPlayer(0)
	local data = yandereWaifu.GetEntityData(ent)
	
	--teleport cooldown of broken mirror
	if data.MirrorBrokenCooldown then
		if data.MirrorBrokenCooldown > 0 then
			data.MirrorBrokenCooldown = data.MirrorBrokenCooldown - 1
			local customColor = Color(1, 0.5, 1, 1, 0, 0, 0)
			ent:SetColor(customColor, 2, 1, false, false)
		end
	end
end)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, ent)
	local player = Isaac.GetPlayer(0)
	local data = yandereWaifu.GetEntityData(ent)
	
	--teleport cooldown of broken mirror
	if data.MirrorBrokenCooldown then
		if data.MirrorBrokenCooldown > 0 then
			data.MirrorBrokenCooldown = data.MirrorBrokenCooldown - 1
			local customColor = Color(1, 0.5, 1, 1, 0, 0, 0)
			ent:SetColor(customColor, 2, 1, false, false)
		end
	end
end)