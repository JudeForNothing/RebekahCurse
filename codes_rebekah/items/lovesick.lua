local uiReserve = Sprite();
uiReserve:Load("gfx/ui/ui_lovesick_reserve.anm2", true);

yandereWaifu:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_,player)
	--local player = Isaac.GetPlayer(0);
    local room = Game():GetRoom();
	local data = yandereWaifu.GetEntityData(player)
	--lovesick
	if player:HasCollectible(RebekahCurseItems.COLLECTIBLE_LOVESICK) and InutilLib.HasJustPickedCollectible( player, RebekahCurseItems.COLLECTIBLE_LOVESICK) then
		player:AddNullCostume(RebekahCurseCostumes.LoveSickBansheeCos)
	end
	if player:HasCollectible(RebekahCurseItems.COLLECTIBLE_LOVESICK) then
		if data.hasTurnedToLovesickBanshee then
			if not data.BansheeLovesickCountdown then data.BansheeLovesickCountdown = 3000 end
			data.BansheeLovesickCountdown = data.BansheeLovesickCountdown - 1
			
			if data.BansheeLovesickCountdown <= 0 then
				data.hasTurnedToLovesickBanshee = false
			else
			
				--because pre player coll is broken
				--[[for k, ent in pairs(Isaac.GetRoomEntities()) do
					if ent:IsEnemy() and ent:IsVulnerableEnemy() then
						local num = 45
						if ent.Position:Distance( player.Position ) < ent.Size + player.Size + num and player.FrameCount % 5 == 0 then
							print("Push")
							print(data.BansheeLovesickCountdown)
							local slash = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_LOVESICK_SLASH, 0, player.Position, Vector(0,0), player)
							slash:GetSprite().Rotation = (ent.Position - player.Position):GetAngleDegrees() - 90
							yandereWaifu.GetEntityData(slash).Player = player
						end
					end
				end]]
			end
		end
		if player:GetFireDirection() == -1 then --if not firing
			if data.lovesickTick and data.lovesickDir then
				if data.lovesickTick >= 30 then

					local cut = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SIREN_RING, 0, player.Position, Vector(0,0), player);
					for i = 0, 360 - 360/16, 360/16 do
						--local tear = player:FireTear(player.Position, Vector.FromAngle(i)*(13), false, false, false):ToTear()
						local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0, player.Position, Vector.FromAngle(i)*(13), player):ToTear()
						tear:ChangeVariant(TearVariant.BLOOD)
					end
					data.SirenDidShriek = true
					
					player:AddNullCostume(RebekahCurseCostumes.LoveSickBansheeShriekCos)
					player:TryRemoveNullCostume(RebekahCurseCostumes.LoveSickBansheeCos)
					
					data.lovesickframecount = 0
					--tear projectiles defence
					for i, e in pairs(Isaac.GetRoomEntities()) do
						if e.Type == EntityType.ENTITY_PROJECTILE then
							if (e.Position - player.Position):Length() < 80 then
								e.Velocity = (e.Position - player.Position):Resized(8)
							end
						elseif e:IsEnemy() then
							if (e.Position - player.Position):Length() < 80 then
								e.Velocity = e.Velocity + (e.Position - player.Position):Resized(8)
							end
						end
					end
				end
			end
			data.lovesickTick = 0
		else
			if data.SirenDidShriek then
				--if player:GetSprite():GetOverlayFrame() == 19 then
					data.SirenDidShriek = false
					player:AddNullCostume(RebekahCurseCostumes.LoveSickBansheeCos)
					player:TryRemoveNullCostume(RebekahCurseCostumes.LoveSickBansheeShriekCos)
				--end
			end
			if not data.SirenDidShriek then data.SirenDidShriek = false end
			if not data.lovesickTick then data.lovesickTick = 0 end
			
			data.lovesickTick = data.lovesickTick + 1
			
			local dir
			if player:GetFireDirection() == 3 then --down
				dir = 90
			elseif player:GetFireDirection() == 1 then --up
				dir = -90
			elseif player:GetFireDirection() == 0 then --left
				dir = 180
			elseif player:GetFireDirection() == 2 then --right
				dir = 0
			end
			data.lovesickDir = dir
		end
		if data.SirenDidShriek then
			if data.lovesickframecount == 19 then
				data.SirenDidShriek = false
				player:AddNullCostume(RebekahCurseCostumes.LoveSickBansheeCos)
				player:TryRemoveNullCostume(RebekahCurseCostumes.LoveSickBansheeShriekCos)
			else
				data.lovesickframecount = data.lovesickframecount + 1
			end
		end
	end
end)

--[[InutilLib.AddCustomCallback(yandereWaifu, ILIBCallbacks.MC_POST_PLAYER_TEAR, function(_, tear)
	local data = yandereWaifu.GetEntityData(tear)
	local player = tear.SpawnerEntity:ToPlayer()
	if player:HasCollectible(RebekahCurseItems.COLLECTIBLE_LOVESICK) then
		if math.random(1,4) == 4 then
			data.IsLovesick = true
		end
	end
end)]]

--[[function yandereWaifu:LovesickTearUpdate(tr)
	local data = yandereWaifu.GetEntityData(tr)
	local player = tr.SpawnerEntity
	if data.IsLovesick then
		if Isaac.GetFrameCount() % 30 == 0 then
			yandereWaifu.SpawnHeartParticles( 1, 3, tr.Position, yandereWaifu.RandomHeartParticleVelocity(), tr, RebekahHeartParticleType.Red );
			local fart = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_PHEROMONES_RING, 0, tr.Position, Vector(0,0), player)
			yandereWaifu.GetEntityData(fart).Player = tr
		end
	end
	
	if player then
		player = player:ToPlayer()
		if player:HasCollectible(RebekahCurseItems.COLLECTIBLE_LOVESICK) and player:HasWeaponType(WeaponType.WEAPON_LUDOVICO_TECHNIQUE) then
			if Isaac.GetFrameCount() % 30 == 0 and math.random(1,3) == 3 then
				yandereWaifu.SpawnHeartParticles( 1, 3, tr.Position, yandereWaifu.RandomHeartParticleVelocity(), tr, RebekahHeartParticleType.Red );
				local fart = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_PHEROMONES_RING, 0, tr.Position, Vector(0,0), player)
				yandereWaifu.GetEntityData(fart).Player = tr
			end
		end
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, yandereWaifu.LovesickTearUpdate)]]

--pheromones fart ring
--[[
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, function(_, eff)
	local sprite = eff:GetSprite()
	sprite:Play("Appear", true)
	eff.RenderZOffset = 10000;
	eff.SpriteOffset = Vector(0,-10)
end, RebekahCurse.ENTITY_PHEROMONES_RING);

yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local sprite = eff:GetSprite();
	local data = yandereWaifu.GetEntityData(eff)
	local player = data.Player
	
	if sprite:IsFinished("Appear") then
		sprite:Play("Loop", true)
	end
	
	if eff.FrameCount == 20 then
		sprite:Play("Dissappear", true)
	end
	
	if sprite:IsFinished("Dissappear") then
		eff:Remove()
	end
	
	eff.Velocity = player.Velocity;
	eff.Position = player.Position;
	
	for k, ent in pairs(Isaac.GetRoomEntities()) do
		if ent:IsEnemy() and ent:IsVulnerableEnemy() then
		local num = 45
			if ent.Position:Distance( eff.Position ) < ent.Size + eff.Size + num then
				ent:AddCharmed(EntityRef(player), math.random(30,90))
			end
		end
	end
end, RebekahCurse.ENTITY_PHEROMONES_RING);]]

yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, function(_, eff)
	local sprite = eff:GetSprite()
	sprite:Play("Slash", true)
	eff.RenderZOffset = 10000;
	eff.SpriteOffset = Vector(0,-10)
end, RebekahCurse.ENTITY_LOVESICK_SLASH);

yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local sprite = eff:GetSprite();
	local data = yandereWaifu.GetEntityData(eff)
	local player = data.Player:ToPlayer()
	
	if sprite:IsFinished("Slash") then
		eff:Remove()
	end
	
	eff.Velocity = player.Velocity;
	eff.Position = player.Position;
	
	for k, ent in pairs(Isaac.GetRoomEntities()) do
		if ent:IsEnemy() and ent:IsVulnerableEnemy() then
		local num = 25
			if ent.Position:Distance( eff.Position ) < ent.Size + eff.Size + num then
				ent:AddCharmed(EntityRef(player), math.random(30,90))
				ent:TakeDamage(player.Damage*3, 0, EntityRef(player), 1)
			end
		end
	end
end, RebekahCurse.ENTITY_LOVESICK_SLASH);

--[[InutilLib:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, damage, amount, damageFlag, damageSource, damageCountdownFrames) 
	if damage.Type == 1 and damage:ToPlayer():HasCollectible(RebekahCurseItems.COLLECTIBLE_LOVESICK) then
		local data = yandereWaifu.GetEntityData(damage)
		damage = damage:ToPlayer()
		local hearts = damage:GetHearts() + damage:GetSoulHearts() + damage:GetGoldenHearts() + damage:GetEternalHearts() + damage:GetBoneHearts() + damage:GetRottenHearts()
		if not data.hasTurnedToLovesickBanshee and hearts <= 2 then
			damage = damage:ToPlayer()
			damage:AnimateSad()
				
			damage:AddNullCostume(RebekahCurseCostumes.SnappedCos)

			data.hasTurnedToLovesickBanshee = true
			
			damage:AddCacheFlags(CacheFlag.CACHE_ALL);
			damage:EvaluateItems()
		end
		if data.hasTurnedToLovesickBanshee then
			
			return false
		end
	end
	
end)]]

--stat cache for each mode
function yandereWaifu:lovesickbansheecacheregister(player, cacheF) --The thing the checks and updates the game, i guess?
	local data = yandereWaifu.GetEntityData(player)
	if player:HasCollectible(RebekahCurseItems.COLLECTIBLE_LOVESICK) and data.hasTurnedToLovesickBanshee then
		--if data.SnapDelay then
		--	if cacheF == CacheFlag.CACHE_FIREDELAY then
		--		player.FireDelay = player.FireDelay - data.SnapDelay
		--	end
		--end
		if cacheF == CacheFlag.CACHE_FIREDELAY then
			player.FireDelay = player.FireDelay - 2
		end
		if cacheF == CacheFlag.CACHE_SPEED then
			player.MoveSpeed = player.MoveSpeed + 0.25
		end
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, yandereWaifu.lovesickbansheecacheregister)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, function(_,tear)
    local parent, spr, data = tear.Parent, tear:GetSprite(), yandereWaifu.GetEntityData(tear)
    local player = parent:ToPlayer()
	local lobHeight = math.floor((player:ToPlayer().TearHeight/2)*-1)
    if parent.Type == EntityType.ENTITY_FAMILIAR and parent.Variant == FamiliarVariant.INCUBUS then
		player = parent:ToFamiliar().Player
    end
    if player:HasCollectible(RebekahCurseItems.COLLECTIBLE_LOVESICK) then
		tear:ChangeVariant(RebekahCurse.ENTITY_SINGINGTEAR)
		tear:AddTearFlags(TearFlags.TEAR_WIGGLE)
		tear:AddTearFlags(TearFlags.TEAR_SPECTRAL)
		if math.random(1,3) == 3 then
			tear:AddTearFlags(TearFlags.TEAR_CHARM)
		end
    end
end)

--firing random stuff
function yandereWaifu:LovesickTearRender(tr, _)
	if tr.Variant == RebekahCurse.ENTITY_SINGINGTEAR then
		local player, data, flags, scale = tr.SpawnerEntity:ToPlayer(), yandereWaifu.GetEntityData(tr), tr.TearFlags, tr.Scale 
		local size = InutilLib.GetTearSizeTypeII(scale, flags)
		InutilLib.UpdateRegularTearAnimation(player, tr, data, flags, size, "Rotate");
		--InutilLib.UpdateDynamicTearAnimation(player, tr, data, flags, "Rotate", "", size)
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_POST_TEAR_RENDER, yandereWaifu.LovesickTearRender)

--[[
yandereWaifu:AddCallback(ModCallbacks.MC_INPUT_ACTION, function(_, ent, hook, action)
	if ent and ent:ToPlayer() then
		if ent:ToPlayer():HasCollectible(RebekahCurseItems.COLLECTIBLE_LOVESICK) then
		print("exodus")
			local returnvalue = Input.GetActionValue(buttonAction, player.ControllerIndex)
				if inputHook == InputHook.GET_ACTION_VALUE then
					--move either AI determined direction or player instructed direction
					if buttonAction == 0 then --left
						if returnvalue == 1 then
							holdingleft[j] = true
						else
							holdingleft[j] = false
						end
						if moveX[j] == -1 and (holdingright[j] == false or subplayer) then --move left
							returnvalue = 1
						elseif subplayer then
							returnvalue = 0
						end
					end
					if buttonAction == 1 then --right
						if returnvalue == 1 then
							holdingright[j] = true
						else
							holdingright[j] = false
						end
						if moveX[j] == 1 and (holdingleft[j] == false or subplayer) then --move right
							returnvalue = 1
						elseif subplayer then
							returnvalue = 0
						end
					end
					if buttonAction == 2 then --up
						if returnvalue == 1 then
							holdingup[j] = true
						else
							holdingup[j] = false
						end
						if moveY[j] == -1 and (holdingdown[j] == false or subplayer) then --move up
							returnvalue = 1
						elseif subplayer then
							returnvalue = 0
						end
					end
					if buttonAction == 3 then --down
						if returnvalue == 1 then
							holdingdown[j] = true
						else
							holdingdown[j] = false
						end
						if moveY[j] == 1 and (holdingup[j] == false or subplayer) then --move down
							returnvalue = 1
						elseif subplayer then
							returnvalue = 0
						end
					end
					--shooting directions
					if buttonAction == 4 then --attack left
						if returnvalue > 0.75 then
							attackingleft[j] = true
						else
							attackingleft[j] = false
						end
						if subplayer and shootX[j] == 0 and attackingleft[j] then
							returnvalue = 0
                            player:SetShootingCooldown(1)
						elseif shootX[j] == -1 and (attackingright[j] == false or subplayer) then
							returnvalue = 1
						elseif subplayer then
							returnvalue = 0
						end
					end
					if buttonAction == 5 then --attack right
						if returnvalue > 0.75 then
							attackingright[j] = true
						else
							attackingright[j] = false
						end
						if subplayer and shootX[j] == 0 and attackingright[j] then
							returnvalue = 0
                            player:SetShootingCooldown(1)
						elseif shootX[j] == 1 and (attackingleft[j] == false or subplayer) then
							returnvalue = 1
						elseif subplayer then
							returnvalue = 0
						end
					end
					if buttonAction == 6 then --attack up
						if returnvalue > 0.75 then
							attackingup[j] = true
						else
							attackingup[j] = false
						end
						if subplayer and shootY[j] == 0 and attackingup[j] then
							returnvalue = 0
                            player:SetShootingCooldown(1)
						elseif shootY[j] == -1 and (attackingdown[j] == false or subplayer) then
							returnvalue = 1
						elseif subplayer then
							returnvalue = 0
						end
					end
					if buttonAction == 7 then --attack down
						if returnvalue > 0.75 then
							attackingdown[j] = true
						else
							attackingdown[j] = false
						end
						if subplayer and shootY[j] == 0 and attackingdown[j] then
							returnvalue = 0
                            player:SetShootingCooldown(1)
						elseif shootY[j] == 1 and (attackingup[j] == false or subplayer) then
							returnvalue = 1
						elseif subplayer then
							returnvalue = 0
						end
						--make character face down if charging with no target
						if mymod:isChargeWeapon(player) and shootX[j] == 0 and shootY[j] == 0 and (player:GetName() ~= "Moth" or Game():GetFrameCount() % 60 < 5) then
							returnvalue = 1
						end
					end
					return returnvalue
				end
		end
	end
end);]]

yandereWaifu:AddCallback(ModCallbacks.MC_POST_RENDER, function(_, _)
	local excludeBetaFiends = 0 --yeah thats right, esau and strawmen are beta fiends
	for p = 0, ILIB.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		if player:HasCollectible(RebekahCurseItems.COLLECTIBLE_LOVESICK) and Options.ChargeBars then
			yandereWaifu.lovesickUI(player)

		end
	end
end);

function yandereWaifu.lovesickUI(player)
		local data = yandereWaifu.GetEntityData(player)
		local room = ILIB.game:GetRoom()
		local gameFrame = ILIB.game:GetFrameCount();
		local tick = data.lovesickTick
		if player.Visible and not (room:GetType() == RoomType.ROOM_BOSS and not room:IsClear() and room:GetFrameCount() < 1) and tick then
			uiReserve:SetOverlayRenderPriority(true)
		
			if tick > 0 then
				if tick < 30 then
					local FramePercentResult = math.floor((tick/30)*100)
					uiReserve:SetFrame("Charging", FramePercentResult)
					data.lovesickBarFade = gameFrame
					data.FinishedlovesickUICharge = false
				elseif tick >= 30 then
					if not data.FinishedlovesickUICharge then
						uiReserve:SetFrame("StartCharged",gameFrame - data.lovesickBarFade)
						if uiReserve:GetFrame() == 11 then
							data.lovesickBarFade = gameFrame
							data.FinishedlovesickUICharge = true
						end
					elseif data.FinishedlovesickUICharge then
						if uiReserve:GetFrame() == 5 then
							data.lovesickBarFade = gameFrame
						end
						uiReserve:SetFrame("Charged",gameFrame - data.lovesickBarFade)
					end
				end
			else
				if not uiReserve:IsPlaying("Disappear") and data.lovesickBarFade then
					uiReserve:SetFrame("Disappear",gameFrame - data.lovesickBarFade);
				end
			end
	
				local playerLocation = Isaac.WorldToScreen(player.Position)
				--print(InutilLib.IsInMirroredFloor(player))
				if not InutilLib.IsInMirroredFloor(player) then
					uiReserve:Render(playerLocation + Vector(-15, -15), Vector(0,0), Vector(0,0));
				end
			end
	--end
end
