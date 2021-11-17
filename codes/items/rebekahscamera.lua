function yandereWaifu:useRebekahCamera(collItem, rng, player, _, slot)
	--local player = Isaac.GetPlayer(0);
    local room = Game():GetRoom();
	local data = yandereWaifu.GetEntityData(player)
	--typical rom-command
	--if player:HasCollectible(RebekahCurse.COLLECTIBLE_REBEKAHSCAMERA) then
		--if InutilLib.ConfirmUseActive( player, RebekahCurse.COLLECTIBLE_REBEKAHSCAMERA ) then
			if not data.PersistentPlayerData.savedCameraEnemies then
				data.PersistentPlayerData.savedCameraEnemies = {}
				for i, e in pairs(Isaac.GetRoomEntities()) do
					if e:IsEnemy() and e:IsVulnerableEnemy() and not e:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
						table.insert(data.PersistentPlayerData.savedCameraEnemies, e)
						e:AddFreeze(EntityRef(player), math.random(30,60))
					end
				end

			else
				for i, e in pairs(data.PersistentPlayerData.savedCameraEnemies) do
					print(i)
					local minion = Isaac.Spawn(e.Type, e.Variant, e.SubType, player.Position, Vector.Zero, player):ToNPC()
					minion:AddCharmed(EntityRef(player), -1)
					minion.HitPoints = minion.MaxHitPoints/2
				end
				data.PersistentPlayerData.savedCameraEnemies = nil
			end
		--end
	--end
	if slot == ActiveSlot.SLOT_POCKET then
		slot = true
	else
		slot = false
	end
	InutilLib.ShowActiveItem(player, slot)
	InutilLib.AnimateGiantbook(nil, nil, "Shake", "gfx/ui/giantbook/giantbook_rebekahs_camera.anm2", true)
	InutilLib.ShowActiveItem(player, slot)
end
yandereWaifu:AddCallback( ModCallbacks.MC_USE_ITEM, yandereWaifu.useRebekahCamera, RebekahCurse.COLLECTIBLE_REBEKAHSCAMERA );
--[[
yandereWaifu:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_,player)
	--local player = Isaac.GetPlayer(0);
    local room = Game():GetRoom();
	local data = yandereWaifu.GetEntityData(player)
	--typical rom-command
	if player:HasCollectible(RebekahCurse.COLLECTIBLE_REBEKAHSCAMERA) then
		--if InutilLib.ConfirmUseActive( player, RebekahCurse.COLLECTIBLE_REBEKAHSCAMERA ) then
			if not data.PersistentPlayerData.savedCameraEnemies then
				data.PersistentPlayerData.savedCameraEnemies = {}
				for i, e in pairs(Isaac.GetRoomEntities()) do
					if e:IsEnemy() and e:IsVulnerableEnemy() and not e:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
						table.insert(data.PersistentPlayerData.savedCameraEnemies, e)
						e:AddFreeze(EntityRef(player), math.random(30,60))
					end
				end

			else
				for i, e in pairs(data.PersistentPlayerData.savedCameraEnemies) do
					print(i)
					local minion = Isaac.Spawn(e.Type, e.Variant, e.SubType, player.Position, Vector.Zero, player):ToNPC()
					minion:AddCharmed(EntityRef(player), -1)
					minion.HitPoints = minion.MaxHitPoints/2
				end
				data.PersistentPlayerData.savedCameraEnemies = nil
				InutilLib.ToggleShowActive(player, false)
			end
		--end
	end
end)]]