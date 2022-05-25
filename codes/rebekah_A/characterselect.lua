
yandereWaifu.RebekahPersonalities = {} --table turned into a class
yandereWaifu.ListOfRegPersonalities = {} --future list of players

function yandereWaifu.RebekahPersonalities:New(o, name, playerId, graphics, tainted)

	o = o or {};
	o.name = name
	o.playerId = playerId
	o.graphics = graphics
	o.tainted = tainted
	--o.giantAnim = giantAnim
	
	setmetatable(o,self);
	self.__index = self;
	yandereWaifu.ListOfRegPersonalities[#yandereWaifu.ListOfRegPersonalities+1] = o
	return o;
end

yandereWaifu.RebekahPersonalities:New({}, "Red Personality", RebekahCurse.REB_RED, "gfx/ui/rebekah select/red.png", false)
yandereWaifu.RebekahPersonalities:New({}, "Soul Personality", RebekahCurse.REB_SOUL, "gfx/ui/rebekah select/soul.png", false)
yandereWaifu.RebekahPersonalities:New({}, "Evil Personality", RebekahCurse.REB_EVIL, "gfx/ui/rebekah select/evil.png", false)
yandereWaifu.RebekahPersonalities:New({}, "Eternal Personality", RebekahCurse.REB_ETERNAL, "gfx/ui/rebekah select/eternal.png", false)
yandereWaifu.RebekahPersonalities:New({}, "Gold Personality", RebekahCurse.REB_GOLD, "gfx/ui/rebekah select/gold.png", false)
yandereWaifu.RebekahPersonalities:New({}, "Bone Personality", RebekahCurse.REB_BONE, "gfx/ui/rebekah select/bone.png", false)
yandereWaifu.RebekahPersonalities:New({}, "Rotten Personality", RebekahCurse.REB_ROTTEN, "gfx/ui/rebekah select/rotten.png", false)
yandereWaifu.RebekahPersonalities:New({}, "Broken Personality", RebekahCurse.REB_BROKEN, "gfx/ui/rebekah select/broken.png", false)


local shouldRenderAchievement = false
local menuUI = Sprite()
local currentSprite = ""
menuUI:Load("gfx/ui/rebekah select/select screen.anm2", true)
local menuUIDelay = 0

function yandereWaifu.SelectRebekahPersonality(currentPlayer)
	Isaac.ExecuteCommand("restart "..currentPlayer.playerId --[[RebekahCurse.REB_RED]])
	--Isaac.GetPlayer(0):ChangePlayerType(currentPlayer.playerId)
end


local currentPlayerSelected --saved current personality detail saved
local currentPlayerId = 1 -- current id of personality
function yandereWaifu.AnimateIsaacMenu(currentPlayer, spritesheet, sound, doPause, time)
	if doPause == nil then
		doPause = true
	end

	--local safe = InutilLib.RoomIsSafe()
	--[[if shouldRenderAchievement or ((doPause and not pauseEnabled) and not safe) then
		InutilLib.SetTimer(12, function()
			yandereWaifu.AnimateIsaacMenu(currentPlayer, spritesheet, sound, doPause, time)
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

function InutilLib.GetShowingAchievement()
	return shouldRenderAchievement, currentSprite
end

InutilLib:AddCallback(ModCallbacks.MC_POST_RENDER, function()
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

		for p = 0, ILIB.game:GetNumPlayers() - 1 do
			local player = Isaac.GetPlayer(p)
			player:GetData().prevAchCharge = nil
			end
		end
	end

	if shouldRenderAchievement then
		menuUI:Render(InutilLib.AlphaGetScreenCenterPosition(), Vector(0,0), Vector(0,0))
    end

  if shouldRenderAchievement then
	for p = 0, ILIB.game:GetNumPlayers() - 1 do
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
            not InutilLib.IsAnimated(menuUI, "Dissapear") and not menuUI:IsPlaying("Appear") and not ILIB.game:IsPaused() then
        menuUI:Play("Dissapear", true)
		yandereWaifu.SelectRebekahPersonality(currentPlayerSelected)
      end
	  
	  if Input.IsActionTriggered(ButtonAction.ACTION_LEFT, player.ControllerIndex) then
		if currentPlayerId <= 1 then
		  currentPlayerId = #yandereWaifu.ListOfRegPersonalities
		  yandereWaifu.AnimateIsaacMenu(yandereWaifu.ListOfRegPersonalities[currentPlayerId], yandereWaifu.ListOfRegPersonalities[currentPlayerId].graphics, SoundEffect.SOUND_PAPER_OUT, false, 900)
		else
		  yandereWaifu.AnimateIsaacMenu(yandereWaifu.ListOfRegPersonalities[currentPlayerId-1], yandereWaifu.ListOfRegPersonalities[currentPlayerId-1].graphics, SoundEffect.SOUND_PAPER_OUT, false, 900)
		  currentPlayerId = currentPlayerId - 1
		end
	  elseif Input.IsActionTriggered(ButtonAction.ACTION_RIGHT, player.ControllerIndex) then
	    if currentPlayerId < #yandereWaifu.ListOfRegPersonalities then
		  yandereWaifu.AnimateIsaacMenu(yandereWaifu.ListOfRegPersonalities[currentPlayerId+1], yandereWaifu.ListOfRegPersonalities[currentPlayerId+1].graphics, SoundEffect.SOUND_PAPER_IN, false, 900)
		  currentPlayerId = currentPlayerId + 1
		else
		  currentPlayerId = 1
		  yandereWaifu.AnimateIsaacMenu(yandereWaifu.ListOfRegPersonalities[currentPlayerId], yandereWaifu.ListOfRegPersonalities[currentPlayerId].graphics, SoundEffect.SOUND_PAPER_IN, false, 900)
		end
	  end
    end
  end
end)

function yandereWaifu:ShowPersonalityBook()
	ILIB.game:GetHUD():SetVisible(false)
	yandereWaifu.AnimateIsaacMenu(yandereWaifu.ListOfRegPersonalities[1], yandereWaifu.ListOfRegPersonalities[1].graphics, SoundEffect.SOUND_PAPER_IN, false, 900)
	currentPlayerId = 1
end

function yandereWaifu:onTechnicalCharacterInit(player)
	local playerCount = ILIB.game:GetNumPlayers()
	local playerType = player:GetPlayerType()
	if playerType == RebekahCurse.TECHNICAL_REB 
	and playerCount == 1 then
		yandereWaifu:ShowPersonalityBook()
	else
		--yandereWaifu:ShowCoopMenu(player)
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT,yandereWaifu.onTechnicalCharacterInit)



yandereWaifu:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_,player)
	local playerType = player:GetPlayerType()
	if playerType == RebekahCurse.TECHNICAL_REB then 
		player.Velocity = Vector.Zero
		player.Position = player.Position
	end
end)