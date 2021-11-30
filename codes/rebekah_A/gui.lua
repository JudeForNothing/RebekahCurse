--hud
local moveMeter = Sprite();
moveMeter:Load("gfx/special_move_meter.anm2", true);
local attackMeter = Sprite();
attackMeter:Load("gfx/special_attack_meter.anm2", true);
local bonestackMeter = Sprite();
bonestackMeter:Load("gfx/special_bonestack_meter.anm2", true);

local heartReserve = Sprite();
heartReserve:Load("gfx/ui/ui_heart_reserve.anm2", true);

local heartBReserve = Sprite();
heartBReserve:Load("gfx/ui/ui_bone_heart_reserve.anm2", true);

local eternalFeatherReserve = Sprite();
eternalFeatherReserve:Load("gfx/ui/ui_eternal_reserve.anm2", true);

local knifeSpearReserve = Sprite();
knifeSpearReserve:Load("gfx/ui/ui_spear_reserve.anm2", true);

--meter
function yandereWaifu.meterLogic(player)
	--for i,player in ipairs(ILIB.players) do
		local data = yandereWaifu.GetEntityData(player)
		local room = ILIB.game:GetRoom()
		local gameFrame = ILIB.game:GetFrameCount();
		if player:GetPlayerType() == RebekahCurse.REB then
			if player.Visible and not (room:GetType() == RoomType.ROOM_BOSS and not room:IsClear() and room:GetFrameCount() < 1) then
				moveMeter:SetOverlayRenderPriority(true)
				attackMeter:SetOverlayRenderPriority(true)
				bonestackMeter:SetOverlayRenderPriority(true)
				--move
				if data.specialBoneHeartStompCooldown and data.specialBoneHeartStompCooldown > 0 then --for special cooldown for bone heart
					if data.specialBoneHeartStompCooldown and data.specialBoneHeartStompCooldown > 0 then
						moveMeter:SetFrame("Charging", math.floor(data.specialBoneHeartStompCooldown*0.95/5))
						data.moveMeterFadeStartFrame = gameFrame;
					elseif data.specialBoneHeartStompCooldown == 0 then
						if not moveMeter:IsPlaying("Fade") then
							moveMeter:SetFrame("Fade",gameFrame - data.moveMeterFadeStartFrame);
						end
					end
				else
					if data.specialCooldown and data.specialMaxCooldown and data.specialCooldown > 0 then
						local FramePercentResult = math.floor((data.specialCooldown/data.specialMaxCooldown)*100)
						moveMeter:SetFrame("Charging", FramePercentResult)
						data.moveMeterFadeStartFrame = gameFrame;
					elseif data.specialCooldown == 0 then
						if not moveMeter:IsPlaying("Fade") then
							moveMeter:SetFrame("Fade",gameFrame - data.moveMeterFadeStartFrame);
						end
					end
				end
				
				--attack barrage chargeDelay
				if (data.chargeDelay and data.chargeDelay > 0 ) then
					local FramePercentResult = math.floor((data.chargeDelay/player.MaxFireDelay)*100)
					if FramePercentResult < 100 then
						attackMeter:SetFrame("Charging", FramePercentResult );
						data.attackMeterFadeStartFrame = gameFrame;
					else
						if not attackMeter:IsPlaying("ChargeBlink") then
							if not attackMeter:IsPlaying("JustCharged") then
								attackMeter:Play("JustCharged", true)
							else
								attackMeter:Play("ChargeBlink", true)
							end
						end
					end
				else
					--atack
					if data.specialActiveAtkCooldown and data.specialActiveAtkCooldown > 0 then
						local FramePercentResult = math.floor((data.specialActiveAtkCooldown/data.specialMaxActiveAtkCooldown)*100)
						attackMeter:SetFrame("Charging", FramePercentResult );
						data.attackMeterFadeStartFrame = gameFrame;
					else
						if not attackMeter:IsPlaying("Fade") then
							attackMeter:SetFrame("Fade", gameFrame - data.attackMeterFadeStartFrame);
						end
					end
				end
				--bone stack
				if data.BoneStacks then
					if data.BoneStacks > 0 then
						if data.BoneStacks <= 5 then
							bonestackMeter:SetFrame("Charging", data.BoneStacks );
							--bonestackMeter = gameFrame;
						else
							bonestackMeter:SetFrame("Charging", 5 );
							--data.bonestackMeterFadeStartFrame = gameFrame;
						end
					else
						if not bonestackMeter:IsPlaying("Fade") then
							bonestackMeter:SetFrame("Fade", gameFrame - data.bonestackMeterFadeStartFrame);
						end
					end
				end
				local playerLocation = Isaac.WorldToScreen(player.Position)
				--print(InutilLib.IsInMirroredFloor(player))
				if not InutilLib.IsInMirroredFloor(player) then
					moveMeter:Render(playerLocation + Vector(-20, -30), Vector(0,0), Vector(0,0));
					attackMeter:Render(playerLocation + Vector(-20, -10), Vector(0,0), Vector(0,0));
					bonestackMeter:Render(playerLocation + Vector(0, -45), Vector(0,0), Vector(0,0));
				end
			end
		end
	--end
end

function yandereWaifu.heartReserveRenderLogic(player, id)
	local data = yandereWaifu.GetEntityData(player)
	if ILIB.game:GetHUD():IsVisible() and not player.Parent then
		local position = Vector(54,44)
		if id == 1 then
			position = Vector(338,74)
		elseif id == 2 then
			position = Vector(58,210)
		elseif id == 3 then
			position = Vector(338,210)
		end
		--print(player.Position.X)
		--if InutilLib.IsInMirroredFloor(player) then
			--position.X = position.X * -1
		--	 position = Isaac.WorldToScreen(Vector((player.Position.X * -1)-(player.Position.X * -1),player.Position.Y))
		--end
		--print(position.X)
		
		local room = ILIB.game:GetRoom()
		local gameFrame = ILIB.game:GetFrameCount();
		if player:GetPlayerType() == RebekahCurse.REB then
			if not (room:GetType() == RoomType.ROOM_BOSS and not room:IsClear() and room:GetFrameCount() < 1) then
				--heartReserve:SetOverlayRenderPriority(true)
				if data.heartReserveFill and data.heartReserveMaxFill then
					--local FramePercentResult = math.floor((data.heartReserveFill/data.heartReserveMaxFill)*100)
					--print(data.heartReserveFill, "hello")
					local renderFill = math.floor(data.heartReserveFill/10)
					
					if not data.heartStocksMax then data.heartStocksMax = 3 end --incase
					
					if yandereWaifu.getReserveStocks(player) < data.heartStocksMax then
						heartReserve:SetFrame("Bar", renderFill) --math.floor(FramePercentResult/10
					else
						heartReserve:SetFrame("Bar", 10)
					end
				end
				heartReserve:SetOverlayFrame("Number", yandereWaifu.getReserveStocks(player))
				heartReserve:Render((position), Vector(0,0), Vector(0,0))
				heartReserve.Color = Color(1,1,1,0.5,0,0,0)
				--heartReserve:RenderLayer(1, (position), Vector(0,0), Vector(0,0))
			end
		end
	end
end

function yandereWaifu.heartBoneReserveRenderLogic(player)
	--for i,player in ipairs(ILIB.players) do
		local position = player.Position - Vector(24,-18)
		--print(player.Position.X)
		--if InutilLib.IsInMirroredFloor(player) then
			--position.X = position.X * -1
		--	 position = Isaac.WorldToScreen(Vector((player.Position.X * -1)-(player.Position.X * -1),player.Position.Y))
		--end
		--print(position.X)
		local data = yandereWaifu.GetEntityData(player)
		local room = ILIB.game:GetRoom()
		local gameFrame = ILIB.game:GetFrameCount();
		if player:GetPlayerType() == RebekahCurse.REB then
			if not (room:GetType() == RoomType.ROOM_BOSS and not room:IsClear() and room:GetFrameCount() < 1) then
				--heartBReserve:SetOverlayRenderPriority(true)
				if data.BoneJockeyTimeLeft then
					--local FramePercentResult = math.floor((data.heartReserveFill/data.heartReserveMaxFill)*100)
					--print(data.heartReserveFill, "hello")
					local renderFill = math.floor(data.BoneJockeyTimeLeft/10)
					heartBReserve:SetFrame("Bar", renderFill) --math.floor(FramePercentResult/10
					
					--move
					if yandereWaifu.GetEntityData(data.hasLeech).specialCooldown and yandereWaifu.GetEntityData(data.hasLeech).specialCooldown > 0 then
						local FramePercentResult = math.floor((yandereWaifu.GetEntityData(data.hasLeech).specialCooldown/yandereWaifu.GetEntityData(data.hasLeech).specialMaxCooldown)*100)
						moveMeter:SetFrame("Charging", FramePercentResult)
						data.moveMeterFadeStartFrame = gameFrame;
					elseif yandereWaifu.GetEntityData(data.hasLeech).specialCooldown == 0 then
						if not moveMeter:IsPlaying("Fade") then
							moveMeter:SetFrame("Fade",gameFrame - data.moveMeterFadeStartFrame);
						end
					end
					
					local playerLocation = Isaac.WorldToScreen(player.Position)
					
					if yandereWaifu.GetEntityData(data.hasLeech).JockeySpear then
						local leechData = yandereWaifu.GetEntityData(data.hasLeech)
						local MaxSpearCharge = leechData.MaxSpearCharge
						if leechData.SpearCharge < MaxSpearCharge then
							local FramePercentResult = math.floor((leechData.SpearCharge/MaxSpearCharge)*100)
							knifeSpearReserve:SetFrame("Charging", FramePercentResult)
							data.spearBarFade = gameFrame
							data.FinishedSpearUICharge = false
						elseif leechData.SpearCharge >= MaxSpearCharge then
							if not data.FinishedSpearUICharge then
								knifeSpearReserve:SetFrame("StartCharged",gameFrame - data.spearBarFade)
								if knifeSpearReserve:GetFrame() == 11 then
									data.spearBarFade = gameFrame
									data.FinishedSpearUICharge = true
								end
							elseif data.FinishedSpearUICharge then
								if knifeSpearReserve:GetFrame() == 5 then
									data.spearBarFade = gameFrame
								end
								knifeSpearReserve:SetFrame("Charged",gameFrame - data.spearBarFade)
							end
						end
						if not InutilLib.IsInMirroredFloor(player) then
							knifeSpearReserve:Render(playerLocation + Vector(0, -50), Vector(0,0), Vector(0,0));
						end
					end
					if not InutilLib.IsInMirroredFloor(player) then
						moveMeter:Render(playerLocation + Vector(-20, -30), Vector(0,0), Vector(0,0))
					end
				end
				--heartBReserve:SetOverlayFrame("Number", yandereWaifu:getReserveStocks(player))
				heartBReserve:Render(Isaac.WorldToScreen(position), Vector(0,0), Vector(0,0))
			end
		end
	--end
end


yandereWaifu:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, function(_, _)
	if Options.ChargeBars then
		for p = 0, ILIB.game:GetNumPlayers() - 1 do
			local player = Isaac.GetPlayer(p)
			if player:GetPlayerType() == RebekahCurse.REB then
				yandereWaifu.meterLogic(player);
			end
		end
	end
end);

yandereWaifu:AddCallback(ModCallbacks.MC_POST_RENDER, function(_, _)
	local excludeBetaFiends = 0 --yeah thats right, esau and strawmen are beta fiends
	for p = 0, ILIB.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		if player:GetPlayerType() == PlayerType.PLAYER_ESAU or player.Parent then
			excludeBetaFiends = excludeBetaFiends + 1
		elseif player:GetPlayerType() == RebekahCurse.REB then
			yandereWaifu.heartReserveRenderLogic(player, p - excludeBetaFiends);
			if yandereWaifu.GetEntityData(player).IsLeftover then
				yandereWaifu.heartBoneReserveRenderLogic(player)
			end
			if yandereWaifu.GetEntityData(player).currentMode == REBECCA_MODE.EternalHearts and Options.ChargeBars then
				yandereWaifu.eternalBarLogic(player)
			end
		end
	end
end);

function yandereWaifu.eternalBarLogic(player)
	--for i,player in ipairs(ILIB.players) do
		local data = yandereWaifu.GetEntityData(player)
		local room = ILIB.game:GetRoom()
		local gameFrame = ILIB.game:GetFrameCount();
		if player:GetPlayerType() == RebekahCurse.REB then
			local maxEternalFeather = data.maxEternalFeather
			if player.Visible and not (room:GetType() == RoomType.ROOM_BOSS and not room:IsClear() and room:GetFrameCount() < 1) then
				eternalFeatherReserve:SetOverlayRenderPriority(true)

				if data.StackedFeathers then
					if data.StackedFeathers < maxEternalFeather then
						local FramePercentResult = math.floor((data.StackedFeathers/maxEternalFeather)*100)
						eternalFeatherReserve:SetFrame("Charging", FramePercentResult)
						data.eternalBarFade = gameFrame
						data.FinishedEternalUICharge = false
					elseif data.StackedFeathers >= maxEternalFeather then
						if not data.FinishedEternalUICharge then
							eternalFeatherReserve:SetFrame("StartCharged",gameFrame - data.eternalBarFade)
							if eternalFeatherReserve:GetFrame() == 11 then
								data.eternalBarFade = gameFrame
								data.FinishedEternalUICharge = true
							end
						elseif data.FinishedEternalUICharge then
							if eternalFeatherReserve:GetFrame() == 5 then
								data.eternalBarFade = gameFrame
							end
							eternalFeatherReserve:SetFrame("Charged",gameFrame - data.eternalBarFade)
						end
					end
				--[[elseif data.StackedFeathers == 0 then
					if not eternalFeatherReserve:IsPlaying("Disappear") then
						eternalFeatherReserve:SetFrame("Disappear",gameFrame - data.eternalBarFade);
					end]]
				end
		
				local playerLocation = Isaac.WorldToScreen(player.Position)
				--print(InutilLib.IsInMirroredFloor(player))
				if not InutilLib.IsInMirroredFloor(player) then
					eternalFeatherReserve:Render(playerLocation + Vector(0, -50), Vector(0,0), Vector(0,0));
				end
			end
		end
	--end
end
