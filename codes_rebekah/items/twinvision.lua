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
	data.redTwin = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLOOD_BABY, InutilLib.PSEUDO_CLONE, player.Position, Vector(0, 0), player):ToFamiliar()
	data.redTwin:GetData().DontRender = true
	yandereWaifu.GetEntityData(data.redTwin).isredTwin = true
	data.blueTwin = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLOOD_BABY, InutilLib.PSEUDO_CLONE, player.Position, Vector(0, 0), player):ToFamiliar()
	data.blueTwin:GetData().DontRender = true
	yandereWaifu.GetEntityData(data.blueTwin).isblueTwin = true
	--[[data.redTwin = InutilLib:SpawnCustomStrawman(player:GetPlayerType(), player, true)
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
	end]]
end
function yandereWaifu:TwinVisionNewFloor()
	for p = 0, InutilLib.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		local data = yandereWaifu.GetEntityData(player)
		local room = InutilLib.game:GetRoom()
		if not (data.isredTwin or data.isblueTwin) and not (data.redTwin or data.blueTwin) then
			if player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_TWINVISION) then
				spawnTwins(player)
				data.PersistentPlayerData.SpawnTwins = true
			end
		end
	end
end
yandereWaifu:AddCallback( ModCallbacks.MC_POST_NEW_LEVEL, yandereWaifu.TwinVisionNewFloor)
function yandereWaifu:TwinVisionNewRoom()
	for p = 0, InutilLib.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		local data = yandereWaifu.GetEntityData(player)
		local room = InutilLib.game:GetRoom()
		if not (data.redTwin or data.blueTwin) and data.PersistentPlayerData.SpawnTwins then
			if player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_TWINVISION) then
				spawnTwins(player)
			end
		end
	end
end
--yandereWaifu:AddCallback( ModCallbacks.MC_POST_NEW_ROOM, yandereWaifu.TwinVisionNewRoom)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, pickup)
	for p = 0, InutilLib.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		local entityData = yandereWaifu.GetEntityData(player);
		if entityData.isredTwin or entityData.isblueTwin then
			--pickup.Wait = 10;
			
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
	if player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_TWINVISION) and data.redTwin and data.blueTwin then
	--	player:SetColor(Color(0.2,0.2,0.2,0.4,0,0,0),3,1,false,false)
	end
end)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_,player)
	--local player = Isaac.GetPlayer(0);
    local room = Game():GetRoom();
	local data = yandereWaifu.GetEntityData(player)
	if player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_TWINVISION) and InutilLib.HasJustPickedCollectible( player, RebekahCurse.Items.COLLECTIBLE_TWINVISION) and not (data.isredTwin or data.isblueTwin) and not (data.redTwin or data.blueTwin) then
		spawnTwins(player)
		data.PersistentPlayerData.SpawnTwins = true
	end
	--[[if data.isredTwin then
		player:SetColor(Color(1,0,0,1,0,0,0),3,1,false,false)
	end
	if data.isblueTwin then
		player:SetColor(Color(0,0,1,1,0,0,0),3,1,false,false)
	end
	if player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_TWINVISION) and data.redTwin and data.blueTwin then
		player:SetColor(Color(0,0,0,0.2,0,0,0),3,1,false,false)
	end]]
	if InutilLib.room:IsClear() then
		if data.PersistentPlayerData and data.PersistentPlayerData.SpawnTwins then
			if player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_TWINVISION) and data.redTwin and data.blueTwin then
				data.redTwin:Die()
				data.blueTwin:Die()
				data.redTwin = nil
				data.blueTwin = nil
			end
		end
	end
	if not InutilLib.room:IsClear() and data.PersistentPlayerData.SpawnTwins and player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_TWINVISION) and not (data.redTwin and data.blueTwin) then
		spawnTwins(player)
	end
end)

yandereWaifu:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, damage, amount, damageFlag, damageSource, damageCountdownFrames) 
	local data = yandereWaifu.GetEntityData(damage)
	if damage.Type == 1 and damage:ToPlayer():HasCollectible(RebekahCurse.Items.COLLECTIBLE_TWINVISION) and IsRealDamage(damageFlag) then
		if data.redTwin and data.blueTwin then
			data.PersistentPlayerData.SpawnTwins = false
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

local redTwinSprite = Sprite()
redTwinSprite:Load("gfx/characters/twin_vision/red_twin.anm2", true)
local blueTwinSprite = Sprite()
blueTwinSprite:Load("gfx/characters/twin_vision/blue_twin.anm2", true)
local function handleBlueAndRedBabiesVisual(_, familiar, offset)
	local data = yandereWaifu.GetEntityData(familiar)
	if familiar.SubType ~= InutilLib.PSEUDO_CLONE then return end
	local player = familiar.Player
	if not player or player:IsDead() then return end
	familiar:GetSprite().Color = Color(0, 0, 0, 0)

	local render_pos = familiar.Position + Vector(0,5)
	if InutilLib.room:IsMirrorWorld() then --Vector(2*ScreenHelper.GetScreenCenter().X-render_pos.X,render_pos.Y)
		--render_pos = Vector(2*ScreenHelper.GetScreenCenter().X-render_pos.X,render_pos.Y)
		player.FlipX = (not player.FlipX)
	end
		local render_pos = Isaac.WorldToScreen(familiar.Position + familiar.PositionOffset)
		local sprite = player:GetSprite()
		if data.isblueTwin then
			blueTwinSprite:SetFrame(sprite:GetAnimation(), sprite:GetFrame())
			blueTwinSprite:SetOverlayFrame(sprite:GetOverlayAnimation(), sprite:GetOverlayFrame())
			blueTwinSprite:Render(render_pos)
			blueTwinSprite.Color = Color(1,1,1,0.5)
		elseif data.isredTwin then
			redTwinSprite:SetFrame(sprite:GetAnimation(), sprite:GetFrame())
			redTwinSprite:SetOverlayFrame(sprite:GetOverlayAnimation(), sprite:GetOverlayFrame())
			redTwinSprite:Render(render_pos)
			redTwinSprite.Color = Color(1,1,1,0.5)
		end
end
yandereWaifu:AddCallback(ModCallbacks.MC_POST_FAMILIAR_RENDER, handleBlueAndRedBabiesVisual, FamiliarVariant.BLOOD_BABY)

function yandereWaifu:handleBlueAndRedBabiestears(tear)
	if (tear.SpawnerEntity) and (tear.SpawnerEntity:ToFamiliar()) then
		local data = yandereWaifu.GetEntityData(tear)
		if not data.init then
			local baby = tear.SpawnerEntity:ToFamiliar()
			tear = tear:ToTear()
			if (baby.Type == 3) and (baby.Variant == 238) and (baby.SubType == InutilLib.PSEUDO_CLONE) then
				if yandereWaifu.GetEntityData(baby).isblueTwin then
					tear:ChangeVariant(TearVariant.MULTIDIMENSIONAL)
				elseif yandereWaifu.GetEntityData(baby).isredTwin then
					tear:ChangeVariant(TearVariant.BLOOD)
				end
				local damage = baby.SpawnerEntity:ToPlayer().Damage * 0.5
				tear.CollisionDamage = damage
			end
			data.init = true
		end
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, yandereWaifu.handleBlueAndRedBabiestears)
