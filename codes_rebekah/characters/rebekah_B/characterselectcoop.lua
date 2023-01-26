--i got an idea on how to code with with c-side characters, so if there's similarities, you know why

local coopmenu=Sprite()
coopmenu:Load('gfx/ui/coop/rebekah_a coop menu.anm2',true)
coopmenu:SetFrame('Main',1)

local technical_character = RebekahCurse.SADREBEKAH 
local maxplayer = #yandereWaifu.ListOfRegTaintedPersonalities
local minplayer = technical_character

local arrows=Sprite()
arrows:Load('gfx/ui/coop menu.anm2',true)
arrows:Play('Arrows',true)
arrows.PlaybackSpeed=0.25

local sfxmanager=SFXManager()

function yandereWaifu:ShowTaintedRebekahCoopMenu(player) --Activates when Technical character is not the first player
	local data = yandereWaifu.GetEntityData(player)
    data.ShowCoopSelectionMenu=true
	data.RebekahCurrentPersonality=1
	return false
end 

function yandereWaifu:ChangePlayerTypeToTaintedRebekahCoop(player, currentPlayer)
	player:ChangePlayerType(currentPlayer)
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
	--yandereWaifu.ApplyCostumes( data.currentMode, player );
end

function yandereWaifu:renderT(player) --function that activates the co op menu after Technical character spawns
	local data = yandereWaifu.GetEntityData(player)
	local player_type=player:GetPlayerType()
	if data.ShowCoopSelectionMenu 
	and player_type == technical_character then
		player.ControlsEnabled=false
		if Input.IsActionTriggered(ButtonAction.ACTION_MENURIGHT,player.ControllerIndex) then
			--[[while skipids[data.RebekahCurrentPersonality] do
				data.RebekahCurrentPersonality=data.RebekahCurrentPersonality+1
			end]]
			if data.RebekahCurrentPersonality < maxplayer then
				data.RebekahCurrentPersonality = data.RebekahCurrentPersonality + 1
			else
				data.RebekahCurrentPersonality = 1
			end
			sfxmanager:Play(195,1)
		elseif Input.IsActionTriggered(ButtonAction.ACTION_MENULEFT,player.ControllerIndex) then
			--[[while skipids[data.RebekahCurrentPersonality] do
				data.RebekahCurrentPersonality=data.RebekahCurrentPersonality-1
			end]]
			if data.RebekahCurrentPersonality <= 1 then
				data.RebekahCurrentPersonality = maxplayer
			else
				data.RebekahCurrentPersonality = data.RebekahCurrentPersonality - 1
			end
			sfxmanager:Play(194,1)
		end
		if Input.IsActionTriggered(ButtonAction.ACTION_MENUCONFIRM,player.ControllerIndex) and data.ClickPastFirstFrame then
			if yandereWaifu.ListOfRegUnlockedTaintedPersonalities[data.RebekahCurrentPersonality].name == "Tutorial" then return end
				data.ClickPastFirstFrame=nil
				data.ShowCoopSelectionMenu=false
				player.ControlsEnabled=true
				data.ClickPastFirstFrame=nil
				yandereWaifu:ChangePlayerTypeToTaintedRebekahCoop(player, yandereWaifu.ListOfRegTaintedPersonalities[data.RebekahCurrentPersonality].playerId)
				Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.POOF01,0,player.Position,Vector(0,0),nil)
		elseif not data.ClickPastFirstFrame then
			data.ClickPastFirstFrame=true
		end
		--local Frame=data.RebekahCurrentPersonality
		coopmenu:SetFrame(0)
		coopmenu:ReplaceSpritesheet(0, yandereWaifu.ListOfRegTaintedPersonalities[data.RebekahCurrentPersonality].coopGraphics or "gfx/ui/coop/icons/red.png")
		coopmenu:LoadGraphics()
		coopmenu:RenderLayer(0,Isaac.WorldToScreen(player.Position)-Vector(0,45),Vector(0,0),Vector(0,0))
		arrows:Render(Isaac.WorldToScreen(player.Position)-Vector(0,45),Vector(0,0),Vector(0,0))
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER,yandereWaifu.renderT)


--[[function Mod:checkCharacter(detectChr, player) --check if a character is unlocked
  if data.CurrentPersonality == detectChr[1] then
    if Mod:GetAchievement("CHARACTER_"..detectChr[2])>0 then
      return true
    else
		local effect=Isaac.Spawn(1000,effectName,0,player.Position-Vector(0,30),Vector(0,0),player)
		effect.Parent=player
		effect.DepthOffset=999
		player:ToPlayer():AnimateSad()
    end
  end
  return false
end]]
--[[
function Mod:FixStats(player) --Stats being fixed after the check of the unlock
	
  if Mod:checkCharacter(trIsaacDetect, player) then
	player:ChangePlayerType(data.CurrentPersonality)
	---------------------
    player:AddBombs(1)
    
  elseif Mod:checkCharacter(trMaggyDetect, player) then
	player:ChangePlayerType(data.CurrentPersonality)
	---------------------
    player:AddMaxHearts(2)
    player:AddHearts(2)

  elseif Mod:checkCharacter(trCainDetect, player) then
	player:ChangePlayerType(data.CurrentPersonality)
	----------------------
    player:AddMaxHearts(-2)
    player:AddKeys(1)

  elseif Mod:checkCharacter(trJudasDetect, player) then
	player:ChangePlayerType(data.CurrentPersonality)
	-----------------------
    player:AddMaxHearts(-2)
    player:AddBlackHearts(2)
    player:AddCollectible(CollectibleType.COLLECTIBLE_DUALITY)
	
  elseif Mod:checkCharacter(trEdenDetect, player) then --Fix eden co op first
  player:ChangePlayerType(data.CurrentPersonality)
	-----------------------
		Mod.Mod_Eden:EdenStats(player)
		player:AddKeys(1)

  elseif player:GetPlayerType()== Mod.technical_character then  -- Character is not unlocked; Fall back to Isaac
    player:ChangePlayerType(PlayerType.PLAYER_ISAAC)
    -----------------------
    player:AddBombs(1)
    player:AddCollectible(CollectibleType.COLLECTIBLE_D6, 6) --what if no D6 unlocked?
  end
end]]
