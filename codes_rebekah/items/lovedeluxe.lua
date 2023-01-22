LoveDeluxeHairColor = {
	BLACK = 0,
	WHITE = 1, 
	BROWN = 2,
	RED = 3, 
	ORANGE = 4, 
	STRAWBERRY = 5, 
	YELLOW = 6
}

local CharacterHair = {}

local uiReserve = Sprite();
uiReserve:Load("gfx/ui/ui_lovedeluxe_reserve.anm2", true);

function yandereWaifu.RegisterCharacterHairColor(playerName, color)
	CharacterHair[playerName] = color
end

yandereWaifu.RegisterCharacterHairColor("Isaac", LoveDeluxeHairColor.STRAWBERRY)
yandereWaifu.RegisterCharacterHairColor("Cain", LoveDeluxeHairColor.BLACK)
yandereWaifu.RegisterCharacterHairColor("Magdalene", LoveDeluxeHairColor.YELLOW)
yandereWaifu.RegisterCharacterHairColor("Judas", LoveDeluxeHairColor.BLACK)
yandereWaifu.RegisterCharacterHairColor("???", LoveDeluxeHairColor.STRAWBERRY)
yandereWaifu.RegisterCharacterHairColor("Lilith", LoveDeluxeHairColor.RED)
yandereWaifu.RegisterCharacterHairColor("Lazarus", LoveDeluxeHairColor.ORANGE)
yandereWaifu.RegisterCharacterHairColor("Azazel", LoveDeluxeHairColor.BLACK)
yandereWaifu.RegisterCharacterHairColor("Eden", LoveDeluxeHairColor.WHITE)
yandereWaifu.RegisterCharacterHairColor("Keeper", LoveDeluxeHairColor.WHITE)
yandereWaifu.RegisterCharacterHairColor("Samson", LoveDeluxeHairColor.BROWN)
yandereWaifu.RegisterCharacterHairColor("Eve", LoveDeluxeHairColor.BLACK)
yandereWaifu.RegisterCharacterHairColor("The Lost", LoveDeluxeHairColor.WHITE)
yandereWaifu.RegisterCharacterHairColor("Bethany", LoveDeluxeHairColor.BROWN)
yandereWaifu.RegisterCharacterHairColor("Jacob", LoveDeluxeHairColor.STRAWBERRY)
yandereWaifu.RegisterCharacterHairColor("Esau", LoveDeluxeHairColor.BROWN)
yandereWaifu.RegisterCharacterHairColor("The Forgotten", LoveDeluxeHairColor.WHITE)
yandereWaifu.RegisterCharacterHairColor("The Soul", LoveDeluxeHairColor.WHITE)
yandereWaifu.RegisterCharacterHairColor("Rebekah", LoveDeluxeHairColor.BLACK)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_,player)
	local data = yandereWaifu.GetEntityData(player)
	if player:HasCollectible(RebekahCurseItems.COLLECTIBLE_LOVEDELUXE) then
		if player:GetFireDirection() == -1 then --if not firing
			if data.loveDeluxeTick and data.loveDeluxeDir then
				if data.loveDeluxeTick >= 30 then
					local subtype = 0
					subtype = CharacterHair[player:GetName()] or 0
					

					local cut = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_HAIRWHIP, subtype, player.Position, Vector(0,0), player);
					yandereWaifu.GetEntityData(cut).PermanentAngle = data.loveDeluxeDir
					yandereWaifu.GetEntityData(cut).Player = player
				end
			end
			data.loveDeluxeTick = 0
		else
			if not data.loveDeluxeTick then data.loveDeluxeTick = 0 end
			
			data.loveDeluxeTick = data.loveDeluxeTick + 1
			
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
			data.loveDeluxeDir = dir
		end
	end
end)


yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local sprite = eff:GetSprite()
	local data = yandereWaifu.GetEntityData(eff)
	local player = data.Player
	eff.GridCollisionClass =  EntityGridCollisionClass.GRIDCOLL_NOPITS 
	
	local room =  Game():GetRoom()
	
	--function code
	if eff.FrameCount == 1 then
		--print(SubType)
		if eff.SubType == 1 then
			sprite:ReplaceSpritesheet(1, "gfx/effects/items/hairwhip/white.png")
		elseif eff.SubType == 2 then
			sprite:ReplaceSpritesheet(1, "gfx/effects/items/hairwhip/brown.png")
		elseif eff.SubType == 3 then
			sprite:ReplaceSpritesheet(1, "gfx/effects/items/hairwhip/red.png")
		elseif eff.SubType == 4 then
			sprite:ReplaceSpritesheet(1, "gfx/effects/items/hairwhip/orange.png")
		elseif eff.SubType == 5 then
			sprite:ReplaceSpritesheet(1, "gfx/effects/items/hairwhip/strawberry.png")
		elseif eff.SubType == 6 then
			sprite:ReplaceSpritesheet(1, "gfx/effects/items/hairwhip/yellow.png")
		end
		sprite:LoadGraphics()
		sprite:Play("AttackHori", true)
	end
	if sprite:IsFinished("AttackHori") then
		eff:Remove()
	end 
	
	eff.Position = player.Position
	eff.Velocity = player.Velocity
	
	--close hitbox
	if sprite:GetFrame() >= 4 and sprite:GetFrame() <= 6 then
		for i, ent in pairs (Isaac.GetRoomEntities()) do
			if (ent:IsEnemy() and ent:IsVulnerableEnemy()) or ent.Type == EntityType.ENTITY_FIREPLACE and not ent:IsDead() then
				if InutilLib.CuccoLaserCollision(eff, data.PermanentAngle, 240, ent, 20) then
				--if ent.Position:Distance((eff.Position)+ (Vector(50,0):Rotated(data.PermanentAngle))) <= 90 then
					ent:TakeDamage(player.Damage/1.5 +1*ILIB.level:GetStage(), 0, EntityRef(eff), 1)
				end
			end
		end
	end
			--player.Velocity = Vector(0,0)
		--end
	if sprite:GetFrame() == 3 then
		InutilLib.SFX:Play(SoundEffect.SOUND_WHIP_HIT, 1, 0, false, 0.8);
	end
	--[[	local grid = room:GetGridEntity(room:GetGridIndex((eff.Position)+ (Vector(50,0):Rotated(data.PermanentAngle)))) --grids around that Rebecca stepped on
		if grid ~= nil then 
			--print( grid:GetType())
			if grid:GetType() == GridEntityType.GRID_TNT or grid:GetType() == GridEntityType.GRID_POOP then
				grid:Destroy()
			end
		end
	end]]
	eff:GetSprite().Rotation = data.PermanentAngle
end, RebekahCurse.ENTITY_HAIRWHIP)


yandereWaifu:AddCallback(ModCallbacks.MC_POST_RENDER, function(_, _)
	local excludeBetaFiends = 0 --yeah thats right, esau and strawmen are beta fiends
	for p = 0, ILIB.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		if player:HasCollectible(RebekahCurseItems.COLLECTIBLE_LOVEDELUXE) and Options.ChargeBars then
			yandereWaifu.loveDeluxeUI(player)

		end
	end
end);

function yandereWaifu.loveDeluxeUI(player)
		local data = yandereWaifu.GetEntityData(player)
		local room = ILIB.game:GetRoom()
		local gameFrame = ILIB.game:GetFrameCount();
		local tick = data.loveDeluxeTick
		if player.Visible and not (room:GetType() == RoomType.ROOM_BOSS and not room:IsClear() and room:GetFrameCount() < 1) and tick then
			uiReserve:SetOverlayRenderPriority(true)
		
			if tick > 0 then
				if tick < 30 then
					local FramePercentResult = math.floor((tick/30)*100)
					uiReserve:SetFrame("Charging", FramePercentResult)
					data.loveDeluxeBarFade = gameFrame
					data.FinishedLoveDeluxeUICharge = false
				elseif tick >= 30 then
					if not data.FinishedLoveDeluxeUICharge then
						uiReserve:SetFrame("StartCharged",gameFrame - data.loveDeluxeBarFade)
						if uiReserve:GetFrame() == 11 then
							data.loveDeluxeBarFade = gameFrame
							data.FinishedLoveDeluxeUICharge = true
						end
					elseif data.FinishedLoveDeluxeUICharge then
						if uiReserve:GetFrame() == 5 then
							data.loveDeluxeBarFade = gameFrame
						end
						uiReserve:SetFrame("Charged",gameFrame - data.loveDeluxeBarFade)
					end
				end
			else
				if not uiReserve:IsPlaying("Disappear") and data.loveDeluxeBarFade then
					uiReserve:SetFrame("Disappear",gameFrame - data.loveDeluxeBarFade);
				end
			end
	
				local playerLocation = Isaac.WorldToScreen(player.Position)
				--print(InutilLib.IsInMirroredFloor(player))
				if not InutilLib.IsInMirroredFloor(player) then
					uiReserve:Render(playerLocation + Vector(-15, -40), Vector(0,0), Vector(0,0));
				end
			end
	--end
end
