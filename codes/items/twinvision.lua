local function IsRealDamage(flags)
    if flags & DamageFlag.DAMAGE_NO_PENALTIES > 0 then return false end
    if flags & DamageFlag.DAMAGE_RED_HEARTS > 0 then return false end
    if flags & DamageFlag.DAMAGE_DEVIL > 0 then return false end
    if flags & DamageFlag.DAMAGE_CURSED_DOOR > 0 then return false end
    if flags & DamageFlag.DAMAGE_IV_BAG > 0 then return false end
    if flags & DamageFlag.DAMAGE_CHEST > 0 then return false end
    if flags & DamageFlag.DAMAGE_FAKE > 0 then return false end
    return true
end

local function spawnTwins(player)
	local data = yandereWaifu.GetEntityData(player)
	data.redTwin = InutilLib:SpawnCustomStrawman(player:GetPlayerType(), player, true)
	data.redTwin:RespawnFamiliars()
	data.redTwin.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
	data.redTwin.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
	data.redTwin:AddMaxHearts(-data.redTwin:GetMaxHearts())
	data.redTwin:AddSoulHearts(-data.redTwin:GetSoulHearts())
	data.redTwin:AddBoneHearts(-data.redTwin:GetBoneHearts())
	data.redTwin:AddGoldenHearts(-data.redTwin:GetGoldenHearts())
	data.redTwin:AddEternalHearts(-data.redTwin:GetEternalHearts())
	data.redTwin:AddHearts(-data.redTwin:GetHearts())
	data.redTwin:AddMaxHearts(2)
	data.redTwin:AddHearts(2)
	yandereWaifu.GetEntityData(data.redTwin).isredTwin = true
	
	data.blueTwin = InutilLib:SpawnCustomStrawman(player:GetPlayerType(), player, true)
	data.blueTwin:RespawnFamiliars()
	data.blueTwin.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
	data.blueTwin.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
	data.blueTwin:AddMaxHearts(-data.blueTwin:GetMaxHearts())
	data.blueTwin:AddSoulHearts(-data.blueTwin:GetSoulHearts())
	data.blueTwin:AddBoneHearts(-data.blueTwin:GetBoneHearts())
	data.blueTwin:AddGoldenHearts(-data.blueTwin:GetGoldenHearts())
	data.blueTwin:AddEternalHearts(-data.blueTwin:GetEternalHearts())
	data.blueTwin:AddHearts(-data.blueTwin:GetHearts())
	data.blueTwin:AddMaxHearts(2)
	data.blueTwin:AddHearts(2)
	yandereWaifu.GetEntityData(data.blueTwin).isblueTwin = true
	
	for i=1, InutilLib.GetMaxCollectibleID() do
		if not data.blueTwin:HasCollectible(i) or not data.redTwin:HasCollectible(i) then
			for j=1, player:GetCollectibleNum(i) do
				data.redTwin:AddCollectible(i, 0, false)
				data.blueTwin:AddCollectible(i, 0, false)
			end
		end
	end
end
function yandereWaifu:TwinVisionNewFloor()
	for p = 0, ILIB.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		local data = yandereWaifu.GetEntityData(player)
		local room = ILIB.game:GetRoom()
		if not (data.isredTwin or data.isblueTwin) and not (data.redTwin or data.blueTwin) then
			if player:HasCollectible(RebekahCurse.COLLECTIBLE_TWINVISION) then
				spawnTwins(player)
			end
		end
	end
end
yandereWaifu:AddCallback( ModCallbacks.MC_POST_NEW_LEVEL, yandereWaifu.TwinVisionNewFloor)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, pickup)
	for p = 0, ILIB.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		local entityData = yandereWaifu.GetEntityData(player);
		if entityData.isredTwin or entityData.isblueTwin then
			pickup.Wait = 10;
		end
	end
end)


yandereWaifu:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, function(_,player)
	--local player = Isaac.GetPlayer(0);
    local room = Game():GetRoom();
	local data = yandereWaifu.GetEntityData(player)
	if data.isredTwin then
		player:SetColor(Color(1,0.5,0.5,1,0,0,0),3,1,false,false)
	end
	if data.isblueTwin then
		player:SetColor(Color(0.5,0.5,1,1,0,0,0),3,1,false,false)
	end
	if player:HasCollectible(RebekahCurse.COLLECTIBLE_TWINVISION) and data.redTwin and data.blueTwin then
		player:SetColor(Color(0.2,0.2,0.2,0.4,0,0,0),3,1,false,false)
	end
end)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_,player)
	--local player = Isaac.GetPlayer(0);
    local room = Game():GetRoom();
	local data = yandereWaifu.GetEntityData(player)
	if InutilLib.HasJustPickedCollectible( player, RebekahCurse.COLLECTIBLE_TWINVISION) and not (data.isredTwin or data.isblueTwin) and not (data.redTwin or data.blueTwin) then
		spawnTwins(player)
	end
	--[[if data.isredTwin then
		player:SetColor(Color(1,0,0,1,0,0,0),3,1,false,false)
	end
	if data.isblueTwin then
		player:SetColor(Color(0,0,1,1,0,0,0),3,1,false,false)
	end
	if player:HasCollectible(RebekahCurse.COLLECTIBLE_TWINVISION) and data.redTwin and data.blueTwin then
		player:SetColor(Color(0,0,0,0.2,0,0,0),3,1,false,false)
	end]]
end)

yandereWaifu:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, damage, amount, damageFlag, damageSource, damageCountdownFrames) 
	local data = yandereWaifu.GetEntityData(damage)
	if damage.Type == 1 and damage:ToPlayer():HasCollectible(RebekahCurse.COLLECTIBLE_TWINVISION) and IsRealDamage(damageFlag) then
		if data.redTwin and data.blueTwin then
			data.redTwin:Die()
			data.blueTwin:Die()
			data.redTwin = nil
			data.blueTwin = nil
		end
	end
	if data.isredTwin or data.isblueTwin then
		return false
	end
end)