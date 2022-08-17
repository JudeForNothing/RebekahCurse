function yandereWaifu.GetOrangeMirror()
	for i, mir in pairs (Isaac.FindByType(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_EXTRACHARANIMHELPER, -1, false, false)) do
		local mirdata = yandereWaifu.GetEntityData(mir)
		if mirdata.DashBrokenFragment --[[and GetPtrDash(mirdata.Player) == GetPtrDash(player)]] then
			if mirdata.IsOrange then
				return mir
			end
		end
	end
end
function yandereWaifu.GetBlueMirror()
	for i, mir in pairs (Isaac.FindByType(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_EXTRACHARANIMHELPER, -1, false, false)) do
		local mirdata = yandereWaifu.GetEntityData(mir)
		if mirdata.DashBrokenFragment --[[and GetPtrDash(mirdata.Player) == GetPtrDash(player)]] then
			if mirdata.IsBlue then
				return mir
			end
		end
	end
end
function yandereWaifu.ClearLastMirror(isorange)
	local orange = yandereWaifu.GetOrangeMirror()
	local blue = yandereWaifu.GetBlueMirror()
	if isorange then
		orange:Remove()
	else
		blue:Remove()
	end
end

function yandereWaifu.BrokenRebekahDash(player, vel)
	local trinketBonus = 0
	local data = yandereWaifu.GetEntityData(player)
	if player:HasTrinket(RebekahCurse.TRINKET_ISAACSLOCKS) then
		trinketBonus = 5
	end
	--[[for i, v in pairs (Isaac.GetRoomEntities()) do
		if v:IsVulnerableEnemy() and not v:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
			v.Velocity = v.Velocity + vel:Resized(80)
		end
	end]]
	if not data.BrokenPortal or data.BrokenPortal == 2 then
		data.BrokenPortal = 1
	else
		data.BrokenPortal = 2
	end
	if data.BrokenPortal == 2 and yandereWaifu.GetBlueMirror() then
		yandereWaifu.ClearLastMirror(false)
	elseif data.BrokenPortal == 1 and yandereWaifu.GetOrangeMirror() then
		yandereWaifu.ClearLastMirror(true)
	end
	data.MirrorBrokenCooldown = 30
	local customBody = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_EXTRACHARANIMHELPER, 0, player.Position, Vector(0,0), nil) --body effect
	yandereWaifu.GetEntityData(customBody).Player = player
	yandereWaifu.GetEntityData(customBody).DontFollowPlayer = true
	yandereWaifu.GetEntityData(customBody).DashBrokenFragment = true
	data.specialCooldown = REBEKAH_BALANCE.BROKEN_HEARTS_DASH_COOLDOWN - trinketBonus;
	if data.BrokenPortal == 2 then
		yandereWaifu.GetEntityData(customBody).IsBlue = true
	elseif data.BrokenPortal == 1 then
		yandereWaifu.GetEntityData(customBody).IsOrange = true
	elseif not yandereWaifu.GetOrangeMirror() and not yandereWaifu.GetBlueMirror() then
		yandereWaifu.GetEntityData(customBody).IsOrange = true
	end
	print(data.BrokenPortal)
end

--[[yandereWaifu:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, function(_,tear)
		local parent, spr, data = tear.Parent, tear:GetSprite(), yandereWaifu.GetEntityData(tear)
		local player = parent:ToPlayer()
		
		if yandereWaifu.IsNormalRebekah(player) and yandereWaifu.GetEntityData(player).currentMode == REBECCA_MODE.BrokenHearts then
			if yandereWaifu.GetEntityData(player).BrokenBuff then
				yandereWaifu.GetEntityData(player).BrokenBuff = false
				player:AddCacheFlags(CacheFlag.CACHE_DAMAGE);
				player:EvaluateItems()
			end
		end
end)]]


yandereWaifu:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_,player)
	local data = yandereWaifu.GetEntityData(player)
	if yandereWaifu.GetEntityData(player).currentMode == REBECCA_MODE.BrokenHearts then
		if (player:GetShootingInput().X ~= 0 or player:GetShootingInput().Y ~= 0) then --if firing
			if math.random(1,10) + player.Luck >= 10 and player.FrameCount % 30 == 0 then
				local mode = math.random(1,8)
				print(mode)
				if mode == 1 then
					--yandereWaifu.RebekahRedNormalBarrage(player, data, player:GetShootingInput(), 40, 1, 0)
					yandereWaifu.DoExtraBarrages(player, 1)
				elseif mode == 2 then
					--yandereWaifu.RebekahSoulNormalBarrage(player, data, player:GetShootingInput(), 40, math.ceil((player.MaxFireDelay/5)), 1)v
					yandereWaifu.DoExtraBarrages(player, 5)
				elseif mode == 3 then
					local didtrigger = false
					--[[if player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BRIMSTONE) < 2 then
						player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_BRIMSTONE, false, player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BRIMSTONE)+2)
						didtrigger = true
					end]]
					local beam = player:FireBrimstone( player:GetShootingInput(), player, 2):ToLaser();
					beam.Position = player.Position
					beam.MaxDistance = 100
					beam.Timeout = 20
					beam.DisableFollowParent = true
					yandereWaifu.GetEntityData(beam).IsEvil = true
					--[[if didtrigger then
						player:GetEffects():RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_BRIMSTONE, player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BRIMSTONE)+2)
					end]]
				elseif mode == 4 then
					local ned = Isaac.Spawn( EntityType.ENTITY_FAMILIAR, RebekahCurse.ENTITY_NED_NORMAL, 0, player.Position, Vector( 0, 0 ), player):ToFamiliar();
				elseif mode == 5 then
					yandereWaifu.RebekahEternalBarrage(player, player:GetShootingInput())
				elseif mode == 6 then
					for i = 1, 2 do --extra carrion worm thingies when extra tears!!
						local leech = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, RebekahCurse.ENTITY_BONEJOCKEY, 10, player.Position, Vector(0,0), player)
						yandereWaifu.GetEntityData(leech).ParentLeech = player
						yandereWaifu.GetEntityData(leech).DeathFrame = 600
					end
				elseif mode == 7 then
					local ball = Isaac.Spawn( EntityType.ENTITY_FAMILIAR, RebekahCurse.ENTITY_FLYTEAR, 0, player.Position, Vector(0,0), player):ToFamiliar();
				elseif mode == 8 then
					local ball = Isaac.Spawn( EntityType.ENTITY_FAMILIAR, FamiliarVariant.ANGELIC_PRISM, 0, player.Position, Vector(0,0), player):ToFamiliar();
				end
			end
		end
	end
end)