local savedItems = {}

yandereWaifu.RebekahTaintedPersonalities = {} --table turned into a class
yandereWaifu.ListOfRegTaintedPersonalities = {} --future list of players

function yandereWaifu.RebekahTaintedPersonalities:New(o, name, playerId, graphics, coopGraphics, lockedgraphics, locked)

	o = o or {};
	o.name = name
	o.playerId = playerId
	o.graphics = graphics
	o.coopGraphics = coopGraphics
	o.lockedgraphics = lockedgraphics
	o.LockedState = locked
	o.isLocked = nil
	--o.giantAnim = giantAnim
	
	setmetatable(o,self);
	self.__index = self;
	yandereWaifu.ListOfRegTaintedPersonalities[#yandereWaifu.ListOfRegTaintedPersonalities+1] = o
	return o;
end

function yandereWaifu.RebekahTaintedPersonalities:GetPersonalityByName(name)
	for i, v in pairs (yandereWaifu.ListOfRegTaintedPersonalities) do
		if v.name == name then
			return v
		end
	end
end

--[[function yandereWaifu.RebekahTaintedPersonalities:Unlock(name)
	local id = yandereWaifu.RebekahTaintedPersonalities:GetPersonalityByName(name)
	if id.isLocked then
		id.isLocked = false
	end
end]]

yandereWaifu.RebekahTaintedPersonalities:New({}, "Cursed Personality", RebekahCurse.REB_CURSED, "gfx/ui/rebekah select/cursed.png", "gfx/ui/coop/icons/red.png", "gfx/ui/rebekah select/locked.png", function() return yandereWaifu.ACHIEVEMENT.REBEKAH:IsUnlocked() end)
--[[yandereWaifu.RebekahTaintedPersonalities:New({}, "Soul Personality", RebekahCurse.REB_SOUL, "gfx/ui/rebekah select/soul.png", "gfx/ui/coop/icons/soul.png", "gfx/ui/rebekah select/locked.png", function() return yandereWaifu.ACHIEVEMENT.REBEKAH_SOUL:IsUnlocked() end)
yandereWaifu.RebekahTaintedPersonalities:New({}, "Evil Personality", RebekahCurse.REB_EVIL, "gfx/ui/rebekah select/evil.png", "gfx/ui/coop/icons/evil.png", "gfx/ui/rebekah select/locked.png", function() return yandereWaifu.ACHIEVEMENT.REBEKAH_EVIL:IsUnlocked() end)
yandereWaifu.RebekahTaintedPersonalities:New({}, "Eternal Personality", RebekahCurse.REB_ETERNAL, "gfx/ui/rebekah select/eternal.png", "gfx/ui/coop/icons/eternal.png", "gfx/ui/rebekah select/locked.png", function() return yandereWaifu.ACHIEVEMENT.REBEKAH_ETERNAL:IsUnlocked() end)
yandereWaifu.RebekahTaintedPersonalities:New({}, "Immortal Personality", RebekahCurse.REB_IMMORTAL, "gfx/ui/rebekah select/immortal.png", "gfx/ui/coop/icons/eternal.png", "gfx/ui/rebekah select/locked.png", function() return yandereWaifu.ACHIEVEMENT.REBEKAH_IMMORTAL:IsUnlocked() end)
yandereWaifu.RebekahTaintedPersonalities:New({}, "Gold Personality", RebekahCurse.REB_GOLD, "gfx/ui/rebekah select/gold.png", "gfx/ui/coop/icons/gold.png", "gfx/ui/rebekah select/locked.png", function() return yandereWaifu.ACHIEVEMENT.REBEKAH_GOLD:IsUnlocked() end)
yandereWaifu.RebekahTaintedPersonalities:New({}, "Bone Personality", RebekahCurse.REB_BONE, "gfx/ui/rebekah select/bone.png", "gfx/ui/coop/icons/bone.png", "gfx/ui/rebekah select/locked.png", function() return yandereWaifu.ACHIEVEMENT.REBEKAH_BONE:IsUnlocked() end)
yandereWaifu.RebekahTaintedPersonalities:New({}, "Rotten Personality", RebekahCurse.REB_ROTTEN, "gfx/ui/rebekah select/rotten.png", "gfx/ui/coop/icons/rotten.png", "gfx/ui/rebekah select/locked.png", function() return yandereWaifu.ACHIEVEMENT.REBEKAH_ROTTEN:IsUnlocked() end)
yandereWaifu.RebekahTaintedPersonalities:New({}, "Broken Personality", RebekahCurse.REB_BROKEN, "gfx/ui/rebekah select/broken.png", "gfx/ui/coop/icons/broken.png", "gfx/ui/rebekah select/locked.png", function() return yandereWaifu.ACHIEVEMENT.REBEKAH_BROKEN:IsUnlocked() end)
]]

--initialization for unlocked personalities
yandereWaifu.ListOfRegUnlockedTaintedPersonalities = {}
function yandereWaifu:onNewGameTaintedPersonalitiesInit(player)
	--tutorial
	local tutorialTable = {
		name = "Tutorial",
		playerId = nil,
		graphics = "gfx/ui/rebekah select/tutorial_b.png",
		coopGraphics = "gfx/ui/coop/icons/red.png",
		lockedgraphics = "gfx/ui/rebekah select/red.png",
		isLocked = false
	}
	yandereWaifu.ListOfRegUnlockedTaintedPersonalities[1] = tutorialTable
	
	for i, v in pairs (yandereWaifu.ListOfRegTaintedPersonalities) do
		local currentPlayerId = v
		local returnTable = {
			name = currentPlayerId.name,
			playerId = currentPlayerId.playerId,
			graphics = currentPlayerId.graphics,
			coopGraphics = currentPlayerId.coopGraphics,
			lockedgraphics = currentPlayerId.lockedgraphics,
			isLocked = not currentPlayerId.LockedState()
		}
		--print(currentPlayerId.name)
		--print(currentPlayerId.LockedState)
		--currentPlayerId.isLocked = currentPlayerId.LockedState()
		--print(returnTable.IsLocked)
		yandereWaifu.ListOfRegUnlockedTaintedPersonalities[i+1] = returnTable
		--print(yandereWaifu.ListOfRegUnlockedTaintedPersonalities[i].IsLocked)
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT,yandereWaifu.onNewGameTaintedPersonalitiesInit)


local shouldRenderAchievement = false
local menuUI = Sprite()
local currentSprite = ""
menuUI:Load("gfx/ui/rebekah select/select screen.anm2", true)
menuUI:ReplaceSpritesheet(4, "gfx/ui/rebekah select/bg_tainted.png")
local menuUIDelay = 0
local hasSelectedPersonality = false

local currentPlayerSelected --saved current personality detail saved
local currentPlayerId = 1 -- current id of personality

function yandereWaifu.SelectTaintedRebekahPersonality(currentPlayer, menuUI)
	if not currentPlayer.isLocked then
		Isaac.ExecuteCommand("restart "..currentPlayer.playerId --[[RebekahCurse.REB_RED]])
		InutilLib.SetTimer(12, function()
			for i, v in pairs(savedItems) do
				Isaac.GetPlayer(0):AddCollectible(v, 0, false)
			end
		end)
		hasSelectedPersonality = true
		menuUI:Play("Dissapear", true)
		yandereWaifu.ListOfRegUnlockedTaintedPersonalities = {}
	else
		InutilLib.SFX:Play(SoundEffect.SOUND_BOSS2INTRO_ERRORBUZZ, 1, 0, false, 1)
		--Isaac.GetPlayer(0):ChangePlayerType(currentPlayer.playerId)
	end
end

function yandereWaifu.AnimateTIsaacMenu(currentPlayer, sound, doPause, time)
	if doPause == nil then
		doPause = true
	end

	--local safe = InutilLib.RoomIsSafe()
	--[[if shouldRenderAchievement or ((doPause and not pauseEnabled) and not safe) then
		InutilLib.SetTimer(12, function()
			yandereWaifu.AnimateTIsaacMenu(currentPlayer, spritesheet, sound, doPause, time)
		end)
		return
	end]]

	if doPause and not pauseEnabled then
		for _,proj in pairs(Isaac.GetRoomEntities()) do
			if proj.Variant == EntityType.ENTITY_PROJECTILE then
				proj:Die()
			end
		end
	end
  local spritesheet = currentPlayer.graphics
  if currentPlayer.isLocked then
	spritesheet = currentPlayer.lockedgraphics
  end
  if spritesheet then
    currentSprite = spritesheet
		menuUI:ReplaceSpritesheet(3, spritesheet)
    menuUI:LoadGraphics()
  else
    currentSprite = ""
	end

	menuUI:Play("Appear", true)
	shouldRenderAchievement = true
	menuUIDelay = time or AchievementDur

	if not sound then
		sound = SoundEffect.SOUND_CHOIR_UNLOCK
	end
	InutilLib.SFX:Play(sound, 1, 0, false, 1)
	currentPlayerSelected=currentPlayer
end

--[[function InutilLib.GetShowingAchievement()
	return shouldRenderAchievement, currentSprite
end]]

yandereWaifu:AddCallback(ModCallbacks.MC_POST_RENDER, function()
	if Isaac.GetFrameCount() % 2 == 0 then
		menuUI:Update()
		if menuUI:IsFinished("Appear") then
			menuUI:Play("Idle", true)
		end
		if menuUI:IsPlaying("Idle") then
			if menuUIDelay > 0 then
				--menuUIDelay = menuUIDelay - 1
			elseif menuUIDelay == 0 then
				menuUI:Play("Dissapear", true)
			end
		end
		if menuUI:IsFinished("Dissapear") then
      shouldRenderAchievement = false

		for p = 0, InutilLib.game:GetNumPlayers() - 1 do
			local player = Isaac.GetPlayer(p)
			player:GetData().prevAchCharge = nil
			end
		end
	end

	if shouldRenderAchievement then
		menuUI:Render(InutilLib.AlphaGetScreenCenterPosition(), Vector(0,0), Vector(0,0))
    end

  if shouldRenderAchievement then
		for p = 0, InutilLib.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
      	local data =  player:GetData()
     	 data.prevAchCharge = data.prevAchCharge or player:GetActiveCharge()
     	if data.prevAchCharge > player:GetActiveCharge() then
        	player:SetActiveCharge(data.prevAchCharge)

        	if not IsAnimOn(menuUI, "Dissapear") then
         		 menuUI:Play("Dissapear", true)
			end
		end

      	if (Input.IsActionTriggered(ButtonAction.ACTION_MENUCONFIRM, player.ControllerIndex) or
            Input.IsActionTriggered(ButtonAction.ACTION_MENUBACK, player.ControllerIndex)) and
            not InutilLib.IsAnimated(menuUI, "Dissapear") and not menuUI:IsPlaying("Appear") and not InutilLib.game:IsPaused() then
				if yandereWaifu.ListOfRegUnlockedTaintedPersonalities[currentPlayerId].name == "Tutorial" then return end
				yandereWaifu.SelectTaintedRebekahPersonality(currentPlayerSelected, menuUI)
			elseif not hasSelectedPersonality then
	  
				if Input.IsActionTriggered(ButtonAction.ACTION_LEFT, player.ControllerIndex) or Input.IsActionTriggered(ButtonAction.ACTION_SHOOTLEFT, player.ControllerIndex) then
					if currentPlayerId <= 1 then
					currentPlayerId = #yandereWaifu.ListOfRegUnlockedTaintedPersonalities
					yandereWaifu.AnimateTIsaacMenu(yandereWaifu.ListOfRegUnlockedTaintedPersonalities[currentPlayerId], SoundEffect.SOUND_PAPER_OUT, false, 900)
					else
					yandereWaifu.AnimateTIsaacMenu(yandereWaifu.ListOfRegUnlockedTaintedPersonalities[currentPlayerId-1], SoundEffect.SOUND_PAPER_OUT, false, 900)
					currentPlayerId = currentPlayerId - 1
					end
				elseif Input.IsActionTriggered(ButtonAction.ACTION_RIGHT, player.ControllerIndex) or Input.IsActionTriggered(ButtonAction.ACTION_SHOOTRIGHT, player.ControllerIndex) then
					if currentPlayerId < #yandereWaifu.ListOfRegUnlockedTaintedPersonalities then
					yandereWaifu.AnimateTIsaacMenu(yandereWaifu.ListOfRegUnlockedTaintedPersonalities[currentPlayerId+1], SoundEffect.SOUND_PAPER_IN, false, 900)
					currentPlayerId = currentPlayerId + 1
					else
					currentPlayerId = 1
					yandereWaifu.AnimateTIsaacMenu(yandereWaifu.ListOfRegUnlockedTaintedPersonalities[currentPlayerId], SoundEffect.SOUND_PAPER_IN, false, 900)
					end
				end
			end
   		end
  	end
end)

function yandereWaifu:ShowTaintedPersonalityBook()
	InutilLib.game:GetHUD():SetVisible(false)
	yandereWaifu.AnimateTIsaacMenu(yandereWaifu.ListOfRegUnlockedTaintedPersonalities[1], SoundEffect.SOUND_PAPER_IN, false, 900)
	currentPlayerId = 1
end

function yandereWaifu:onTechnicalTaintedCharacterInit(player)
	local playerCount = InutilLib.game:GetNumPlayers()
	local playerType = player:GetPlayerType()
	local data = yandereWaifu.GetEntityData(player)
	if playerType == RebekahCurse.SADREBEKAH 
	and playerCount == 1 then
		yandereWaifu:ShowTaintedPersonalityBook()
		hasSelectedPersonality = false
		savedItems = {}
	elseif playerType == RebekahCurse.SADREBEKAH and playerCount ~= 1 then --this is a bainaid solution, since theres no coop selection screen for her
		yandereWaifu:ShowTaintedRebekahCoopMenu(player)
		
		yandereWaifu.ApplyCostumes( data.currentMode, player );
		--[[player:ChangePlayerType(RebekahCurse.REB_RED)
		if player.FrameCount <= 1 then --trying to make it visually pleasing when she spawns in
			player.Visible = false
		end
		local data = yandereWaifu.GetEntityData(player)
		
		--personalized doubletap classes
		data.DASH_DOUBLE_TAP = InutilLib.DoubleTap:New();
		data.ATTACK_DOUBLE_TAP = InutilLib.DoubleTap:New();
		-- start the meters invisible
		data.moveMeterFadeStartFrame = -20;
		data.attackMeterFadeStartFrame = -20;
		data.bonestackMeterFadeStartFrame = 0;
		
		RebeccaInit(player)
		yandereWaifu.ApplyCostumes( data.currentMode, player );

		if not data.NoBoneSlamActive then data.NoBoneSlamActive = true end
		--yandereWaifu:ShowCoopMenu(player)]]
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT,yandereWaifu.onTechnicalTaintedCharacterInit)



yandereWaifu:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_,player)
	local playerType = player:GetPlayerType()
	if playerType == RebekahCurse.SADREBEKAH then 
		player.Velocity = Vector.Zero
		player.Position = player.Position
		if player.FrameCount == 2 then
			--[[if player:HasCollectible(CollectibleType.COLLECTIBLE_EDENS_BLESSING) then
				for i=1, player:GetCollectibleNum(CollectibleType.COLLECTIBLE_EDENS_BLESSING) do
					player:RemoveCollectible(CollectibleType.COLLECTIBLE_EDENS_BLESSING)
				end
			end]]
			
			for i=1, InutilLib.GetMaxCollectibleID() do
				--print(player:HasCollectible(i))
				if player:HasCollectible(i) then 
					--print(tostring(i).."weeeeP")
					for j=1, player:GetCollectibleNum(i) do
						--if i~= CollectibleType.COLLECTIBLE_EDENS_BLESSING then
							table.insert(savedItems, i)
						--	player:AddCollectible(CollectibleType.COLLECTIBLE_EDENS_BLESSING, 0, false)
						--	print("wooo")
						--end
					end
				end
			end
		end
	end
end)