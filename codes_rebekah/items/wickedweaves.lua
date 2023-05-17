local uiFootReserve = Sprite();
uiFootReserve:Load("gfx/ui/ui_lovedeluxe_reserve.anm2", true);
uiFootReserve:ReplaceSpritesheet(3,"gfx/ui/ui_weaves_foot_reserve.png")
uiFootReserve:LoadGraphics()

local uiArmReserve = Sprite();
uiArmReserve:Load("gfx/ui/ui_lovedeluxe_reserve.anm2", true);
uiArmReserve:ReplaceSpritesheet(3,"gfx/ui/ui_weaves_fist_reserve.png")
uiArmReserve:LoadGraphics()


local armCooldown = 300
local footCooldown = 60
local function DoubleTapWWPunch(vector, playerTapping)
	for p = 0, InutilLib.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		--print(GetPtrHash( playerTapping), "     vector!", GetPtrHash( player))
		if GetPtrHash( playerTapping ) == GetPtrHash( player) then
			local psprite = player:GetSprite()
			local playerdata = yandereWaifu.GetEntityData(player);

			--print(playerdata.IsDashActive , playerdata.IsAttackActive , playerdata.NoBoneSlamActive)
			--checks if you can dash without interrupting something
			local isFree = not (psprite:IsPlaying("Trapdoor") or psprite:IsPlaying("Jump") or psprite:IsPlaying("HoleIn") or psprite:IsPlaying("HoleDeath") or psprite:IsPlaying("JumpOut") or
			psprite:IsPlaying("LightTravel") or psprite:IsPlaying("Appear") or psprite:IsPlaying("Death") 
			or psprite:IsPlaying("TeleportUp") or psprite:IsPlaying("TeleportDown")) and not (playerdata.IsUninteractible)
			and playerdata.WWArmCooldown >= armCooldown and not DeadSeaScrollsMenu.IsOpen()
			if isFree then
				local pos
				local wall = InutilLib.VecToAppoxDir(vector)
				if wall == Direction.UP then
					pos = (Vector(0,90))
				elseif wall == Direction.DOWN then
					pos = (Vector(0,-90))
				elseif wall == Direction.RIGHT then
					pos = (Vector(-90,0))
				elseif wall == Direction.LEFT then
					pos = (Vector(90,0))
				end
				local golemfist = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_WICKEDLIMB, 0, (player.Position - pos), Vector(0,0), player)
				if wall == Direction.UP then
					yandereWaifu.GetEntityData(golemfist).Angle = 270
				elseif wall == Direction.DOWN then
					yandereWaifu.GetEntityData(golemfist).Angle = 90
				elseif wall == Direction.LEFT then
					yandereWaifu.GetEntityData(golemfist).Angle = 180
				elseif wall == Direction.RIGHT then
					yandereWaifu.GetEntityData(golemfist).Angle = 0
				end
				yandereWaifu.GetEntityData(golemfist).Player = player
				--playerdata.specialMaxCooldown = playerdata.specialCooldown --gain the max amount dash cooldown
				-- update the dash double tap cooldown based on Rebecca's mode specific cooldown
				playerdata.WWArmCooldown = 0
			end
		end
	end
end

yandereWaifu:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function(_,player)
	local data = yandereWaifu.GetEntityData(player)
	--costume addition
	--[[if player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_WICKEDWEAVES) and InutilLib.HasJustPickedCollectible( player, RebekahCurse.Items.COLLECTIBLE_WICKEDWEAVES) then
		player:AddNullCostume(RebekahCurse.Costumes.WickedWeaves)
	end]]
	if player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_WICKEDWEAVES) then
		local wall = InutilLib.ClosestWall(player)
		local fist
		local room = InutilLib.room
		local footReleased = false
		for i, ent in pairs (Isaac.GetRoomEntities()) do
			if ent.Type == EntityType.ENTITY_EFFECT and ent.Variant == RebekahCurse.ENTITY_WICKEDLIMB then
				fist = true
				break
			end
		end
		local vector = player:GetShootingInput()
		if not data.WW_ATTACK_DOUBLE_TAP_READY then
			data.WW_ATTACK_DOUBLE_TAP = InutilLib.DoubleTap:New();
			data.WW_ATTACK_DOUBLE_TAP.cooldown = 45
			data.WW_ATTACK_DOUBLE_TAP_READY = true
			data.WW_ATTACK_DOUBLE_TAP:AttachCallback( function( vector, player)
				DoubleTapWWPunch(vector, player)
			end)
		end
		if not data.WWArmCooldown then data.WWArmCooldown = 0 else data.WWArmCooldown = data.WWArmCooldown + 1 end
		if player:GetShootingInput() then
			data.WW_ATTACK_DOUBLE_TAP:Update( player:GetShootingInput() , player );
		end
		if not data.WWFootCooldown then data.WWFootCooldown = 0 end

		if not fist and (player.FrameCount % 3) <= 0 and (player:GetShootingInput().X ~= 0 or player:GetShootingInput().Y ~= 0) then
			data.WWFootCooldown = data.WWFootCooldown + 1
			data.WWLastShootingInput = player:GetShootingInput()
		end
		if (player:GetShootingInput().X == 0 and player:GetShootingInput().Y == 0) then
			if data.WWFootCooldown >= footCooldown then
				footReleased = true
			end
			data.WWFootCooldown = 0
		end
		if footReleased then
			local pos
			local wall = InutilLib.VecToAppoxDir(data.WWLastShootingInput)
			if wall == Direction.UP then
				pos = (Vector(0,70))
			elseif wall == Direction.DOWN then
				pos = (Vector(0,-70))
			elseif wall == Direction.RIGHT then
				pos = (Vector(-70,0))
			elseif wall == Direction.LEFT then
				pos = (Vector(70,0))
			end
			local golemfist = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_WICKEDLIMB, 1, (player.Position - pos), Vector(0,0), player)
			yandereWaifu.GetEntityData(golemfist).Player = player
			footReleased= false
		end
	end
end)


yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local sprite = eff:GetSprite()
	local data = yandereWaifu.GetEntityData(eff)
	local player = data.Player
	
	if data.Angle and eff.SubType == 0 then
		if InutilLib.IsFinishedMultiple(sprite, "Punch", "Punch2", "PunchDown")then
			eff:Remove()
		end
		if eff.FrameCount == 1 then
			if data.Angle == 90 then
				sprite:Play("PunchDown")
			elseif data.Angle == 270 then
				sprite:Play("PunchDown")
				sprite.Rotation = 180
			elseif data.Angle == 180 then
				sprite:Play("Punch2")
			else
				sprite:Play("Punch")
			end
			InutilLib.SFX:Play(RebekahCurse.Sounds.SOUND_WICKEDWEAVES, 10, 0, false, 1)
		elseif InutilLib.IsPlayingMultiple(sprite, "Punch", "Punch2", "PunchDown") and sprite:GetFrame() >= 3 and sprite:GetFrame() <= 6 then
			local radisu = 70
			InutilLib.game:MakeShockwave(eff.Position, 0.055, 0.025, 10)
			for i, ent in pairs (Isaac.GetRoomEntities()) do
				if (ent:IsEnemy()) or ent.Type == EntityType.ENTITY_FIREPLACE and not ent:IsDead() then
					if ent.Position:Distance(eff.Position) <= radisu + ent.Size then
						ent:TakeDamage(player.Damage, 0, EntityRef(player), 1)
							
						InutilLib.game:ShakeScreen(5)
						ent.Velocity = (ent.Position - eff.Position):Rotated(data.Angle):Resized(50)
						ent:AddEntityFlags(EntityFlag.FLAG_APPLY_IMPACT_DAMAGE)
					end
				end
			end
			for x = math.ceil(radisu/40)*-1, math.ceil(radisu/40) do
				for y = math.ceil(radisu/40)*-1, math.ceil(radisu/40) do
					local grid = InutilLib.room:GetGridEntityFromPos(Vector(eff.Position.X+40*x, eff.Position.Y+40*y))
					if grid and (grid:ToRock() or grid:ToPoop() or grid:ToTNT()) then
						if InutilLib.GetGridsInRadius(eff.Position, grid.Position, radisu) then
							grid:Destroy()
						end
					end
				end
			end
			eff.Velocity = eff.Velocity * 0.8
		else
			eff.Velocity = eff.Velocity * 0.8
		end
	elseif eff.SubType == 1 then
		if sprite:IsFinished("Stomp") then
			eff:Remove()
		elseif not sprite:IsPlaying("Stomp") then
			sprite:Play("Stomp", true)
			InutilLib.SFX:Play(RebekahCurse.Sounds.SOUND_WICKEDWEAVES, 10, 0, false, 1)
		elseif sprite:IsPlaying("Stomp") then
			if sprite:GetFrame() == 6 then
				InutilLib.game:ShakeScreen(5)
				InutilLib.game:MakeShockwave(eff.Position, 0.055, 0.025, 10)
				local radisu = 70
				for i, ent in pairs (Isaac.GetRoomEntities()) do
					if (ent:IsEnemy()) or ent.Type == EntityType.ENTITY_FIREPLACE and not ent:IsDead() then
						if ent.Position:Distance(eff.Position) <= radisu + ent.Size then
							ent:TakeDamage(player.Damage*4, 0, EntityRef(player), 1)
								
							InutilLib.game:ShakeScreen(10)
						end
					end
				end
				for x = math.ceil(radisu/40)*-1, math.ceil(radisu/40) do
					for y = math.ceil(radisu/40)*-1, math.ceil(radisu/40) do
						local grid = InutilLib.room:GetGridEntityFromPos(Vector(eff.Position.X+40*x, eff.Position.Y+40*y))
						if grid and (grid:ToRock() or grid:ToPoop() or grid:ToTNT()) then
							if InutilLib.GetGridsInRadius(eff.Position, grid.Position, radisu) then
								grid:Destroy()
							end
						end
					end
				end
			end
		end
	end
end, RebekahCurse.ENTITY_WICKEDLIMB)


function yandereWaifu:ForWickedWeavesNewRoom()	
	for p = 0, InutilLib.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		local data = yandereWaifu.GetEntityData(player)
		local room = InutilLib.game:GetRoom()
		if player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_WICKEDWEAVES) and data.WW_ATTACK_DOUBLE_TAP then
			data.WW_ATTACK_DOUBLE_TAP:Reset();
		end
	end
end
yandereWaifu:AddCallback( ModCallbacks.MC_POST_NEW_ROOM, yandereWaifu.ForWickedWeavesNewRoom)

yandereWaifu:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_,player, cacheF) --The thing the checks and updates the game, i guess?
	local data = yandereWaifu.GetEntityData(player)
	if player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_WICKEDWEAVES) then
		if cacheF == CacheFlag.CACHE_FIREDELAY then
			player.MaxFireDelay = player.MaxFireDelay - 5
		end
		if cacheF == CacheFlag.CACHE_DAMAGE then
			player.Damage = player.Damage * 0.7
		end
	end
end)



yandereWaifu:AddCallback(ModCallbacks.MC_POST_RENDER, function(_, _)
	local excludeBetaFiends = 0 --yeah thats right, esau and strawmen are beta fiends
	for p = 0, InutilLib.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		if player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_WICKEDWEAVES) and Options.ChargeBars then
			yandereWaifu.wickedWeavesUi(player)

		end
	end
end);

function yandereWaifu.wickedWeavesUi(player)
		local data = yandereWaifu.GetEntityData(player)
		local room = InutilLib.game:GetRoom()
		local gameFrame = InutilLib.game:GetFrameCount();
		local tick = data.WWFootCooldown
		if player.Visible and not (room:GetType() == RoomType.ROOM_BOSS and not room:IsClear() and room:GetFrameCount() < 1) and tick then
			uiFootReserve:SetOverlayRenderPriority(true)
		
			if tick > 0 then
				if tick < footCooldown then
					local FramePercentResult = math.floor((tick/footCooldown)*100)
					uiFootReserve:SetFrame("Charging", FramePercentResult)
					data.wwFootBarFade = gameFrame
					data.FinishedWWFootUICharge = false
				elseif tick >= footCooldown then
					if not data.FinishedWWFootUICharge then
						uiFootReserve:SetFrame("StartCharged",gameFrame - data.wwFootBarFade)
						if uiFootReserve:GetFrame() == 11 then
							data.wwFootBarFade = gameFrame
							data.FinishedWWFootUICharge = true
						end
					elseif data.FinishedWWFootUICharge then
						if uiFootReserve:GetFrame() == 5 then
							data.wwFootBarFade = gameFrame
						end
						uiFootReserve:SetFrame("Charged",gameFrame - data.wwFootBarFade)
					end
				end
			else
				if not uiFootReserve:IsPlaying("Disappear") and data.wwFootBarFade then
					uiFootReserve:SetFrame("Disappear",gameFrame - data.wwFootBarFade);
				end
			end
	
				local playerLocation = Isaac.WorldToScreen(player.Position)
				--print(InutilLib.IsInMirroredFloor(player))
				if not InutilLib.IsInMirroredFloor(player) then
					uiFootReserve:Render(playerLocation + Vector(-15, 5), Vector(0,0), Vector(0,0));
				end
			end


			local tick2 = data.WWArmCooldown
			if player.Visible and not (room:GetType() == RoomType.ROOM_BOSS and not room:IsClear() and room:GetFrameCount() < 1) and tick then
				uiArmReserve:SetOverlayRenderPriority(true)
			
				if tick2 > 0 then
					if tick2 < armCooldown then
						local FramePercentResult = math.floor((tick2/armCooldown)*100)
						uiArmReserve:SetFrame("Charging", FramePercentResult)
						data.wwArmBarFade = gameFrame
						data.FinishedWWArmUICharge = false
					elseif tick2 >= armCooldown then
						if not data.FinishedWWArmUICharge then
							uiArmReserve:SetFrame("StartCharged",gameFrame - data.wwArmBarFade)
							if uiArmReserve:GetFrame() == 11 then
								data.wwArmBarFade = gameFrame
								data.FinishedWWArmUICharge = true
							end
						elseif data.FinishedWWArmUICharge then
							if uiArmReserve:GetFrame() == 5 then
								data.wwArmBarFade = gameFrame
							end
							uiArmReserve:SetFrame("Charged",gameFrame - data.wwArmBarFade)
						end
					end
				else
					if not uiArmReserve:IsPlaying("Disappear") and data.wwArmBarFade then
						uiArmReserve:SetFrame("Disappear",gameFrame - data.wwArmBarFade);
					end
				end
		
					local playerLocation = Isaac.WorldToScreen(player.Position)
					--print(InutilLib.IsInMirroredFloor(player))
					if not InutilLib.IsInMirroredFloor(player) then
						uiArmReserve:Render(playerLocation + Vector(15, 5), Vector(0,0), Vector(0,0));
					end
				end
	--end
end
