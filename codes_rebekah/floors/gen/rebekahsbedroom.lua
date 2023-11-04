if StageAPI and StageAPI.Loaded then


	local RebekahRoomRoomList = StageAPI.RoomsList("Rebekah's Room", {
		Name = "Rebekah's Room",
		Rooms = require('resources.luarooms.rebekahsroom.rebekahsroom')
	})

function yandereWaifu.WillSpawnLoveRoom()
	local seed = Game():GetSeeds():GetStartSeed()
	local rng = RNG()
	rng:SetSeed(seed, 35)
	local randomChance = rng:RandomInt(100)
	if --[[seed % 100 <=]] math.abs(randomChance) < RebekahLocalSavedata.loveRoomReplacePercent and yandereWaifu.ACHIEVEMENT.REBEKAHS_ROOM:IsUnlocked() then
		return true
	else
		return false
	end
end

function yandereWaifu.OnEnterCurseRoom()
	local room = InutilLib.game:GetRoom()
	local level = InutilLib.game:GetLevel()
	-- if we're in a curse room and the room is new
	local isGreed = InutilLib.game.Difficulty == Difficulty.DIFFICULTY_GREED or InutilLib.game.Difficulty == Difficulty.DIFFICULTY_GREEDIER
	if (room:GetType() == RoomType.ROOM_CURSE and room:IsFirstVisit()) and StageAPI.GetCurrentRoomType() ~= "Love Room"  then

		local add = false
		-- iterate through the saved curse rooms
		for i, something in pairs(RebekahLocalSavedata.curseRoomsEntered) do 
			-- if we're in a room that had been cleared before, flag it
			if RebekahLocalSavedata.curseRoomsEntered[i][1] == level:GetCurrentRoomDesc().GridIndex and RebekahLocalSavedata.curseRoomsEntered[i][2] == level:GetStage() then
				add = true
			end
		end
		if not add then
			table.insert(RebekahLocalSavedata.curseRoomsEntered, {level:GetCurrentRoomDesc().GridIndex, level:GetStage()} );
		end
		RebekahLocalSavedata.savedloveRoomDepletePercent = RebekahLocalSavedata.savedloveRoomDepletePercent + 35
	end
end
yandereWaifu:AddCallback( ModCallbacks.MC_POST_NEW_ROOM, yandereWaifu.OnEnterCurseRoom)

local showDifference = false
local maincoords = Vector(0, 197.5+16)
local Alpha = 2.9
local rebroom_hudSprite = Sprite()
rebroom_hudSprite:Load("gfx/ui/rebekah_hudstats.anm2", true)
rebroom_hudSprite.Color = Color(1,1,1,0.5)
rebroom_hudSprite:SetFrame("IdleIcons", 2)
local font = Font()
font:Load("font/luaminioutlined.fnt")

function yandereWaifu.UpdateCurseRoomDeplete()
	if RebekahLocalSavedata.savedloveRoomDepletePercent then
		if --[[RebekahLocalSavedata.savedloveRoomDepletePercent]] 0 >= RebekahLocalSavedata.loveRoomReplacePercent + RebekahLocalSavedata.savedloveRoomDepletePercent then
			RebekahLocalSavedata.loveRoomReplacePercent = 0
		else
			--if the sum of saved and added percent is higher than 100...
			if RebekahLocalSavedata.loveRoomReplacePercent + RebekahLocalSavedata.savedloveRoomDepletePercent >= 100 then
				--make it flat 100%
				RebekahLocalSavedata.loveRoomReplacePercent = 100
			else
				RebekahLocalSavedata.loveRoomReplacePercent = RebekahLocalSavedata.loveRoomReplacePercent + RebekahLocalSavedata.savedloveRoomDepletePercent
			end
		end
		RebekahLocalSavedata.savedloveRoomDepletePercent = 0
		showDifference = true
		Alpha = 2.9
	end

end
yandereWaifu:AddCallback(ModCallbacks.MC_POST_CURSE_EVAL, yandereWaifu.UpdateCurseRoomDeplete)

local function TextAcceleration(frame) --Overfit distance profile for difference text slide in
	frame = frame - 14
	if frame > 0 then
		return 0
	end
	return -(15.1/(13*13))*frame*frame
end


function yandereWaifu:rebekahsroomDisplayonRender(shaderName)
	if yandereWaifu:shouldDeHook() then return end
	
	local isShader = shaderName == "UI_DrawRebekahHUD_DummyShader" and true or false
	if not yandereWaifu.ACHIEVEMENT.REBEKAHS_ROOM:IsUnlocked() then return end
	
	if not (Game():IsPaused() and Isaac.GetPlayer(0).ControlsEnabled) and not isShader then return end -- no render when unpaused 
	if (Game():IsPaused() and Isaac.GetPlayer(0).ControlsEnabled) and isShader then return end -- no shader when paused
	
	if shaderName ~= nil and not isShader then return end -- final failsafe
	
	--yandereWaifu:updateCheck()

	--account for screenshake offset
	local coords = maincoords + (Options.HUDOffset * Vector(20, 12))
	local textCoords = coords + Game().ScreenShakeOffset
	local valueOutput = string.format("%.1s%%", "?")
	if RebekahLocalSavedata.loveRoomReplacePercent then
		valueOutput = string.format("%.1f%%", RebekahLocalSavedata.loveRoomReplacePercent)
	else
	--	yandereWaifu:updatePlanetariumChance()
	end
	 font:DrawString(valueOutput, textCoords.X+16, textCoords.Y+1, KColor(1,1,1,0.5),0,true)
	 rebroom_hudSprite:Render(coords, Vector(0,0), Vector(0,0))

	--differential popup
	if Alpha and Alpha>0 then
		local alpha = Alpha
		if Alpha > 0.5 then
			alpha = 0.5
		end
		--if  storage.previousFloorSpawnChance == nil then 
		--	 storage.previousFloorSpawnChance =  storage.currentFloorSpawnChance
		--end
		local difference = RebekahLocalSavedata.loveRoomReplacePercent + RebekahLocalSavedata.savedloveRoomDepletePercent
		local differenceOutput = string.format("%.1f%%", difference)
		local slide = TextAcceleration((2.9 - Alpha)/(2 * 0.01))
		if difference>0 then --positive difference
			 font:DrawString("+"..differenceOutput, textCoords.X + 46 + slide, textCoords.Y+1, KColor(0,1,0,alpha),0,true)
		elseif difference<0 then --negative difference
			 font:DrawString(differenceOutput, textCoords.X + 46 + slide, textCoords.Y+1, KColor(1,0,0,alpha),0,true)
		end
		Alpha = Alpha-0.01
	end
end

yandereWaifu:AddCallback(ModCallbacks.MC_GET_SHADER_PARAMS, yandereWaifu.rebekahsroomDisplayonRender)
yandereWaifu:AddCallback(ModCallbacks.MC_POST_RENDER, yandereWaifu.rebekahsroomDisplayonRender)

--Replace curse rooms
StageAPI.AddCallback("RebekahCurse", "PRE_STAGEAPI_NEW_ROOM_GENERATION", 0, function(currentRoom, justGenerated, currentListIndex)
	if yandereWaifu.WillSpawnLoveRoom() then
		yandereWaifu.ReplaceCurseDoorstoMirrors()
		if (InutilLib.room:GetType() == RoomType.ROOM_CURSE) and not currentRoom --[[and InutilLib.room:IsFirstVisit()]] then
			local testRoom = StageAPI.LevelRoom("Love Curse Room", RebekahRoomRoomList, InutilLib.room:GetSpawnSeed(), InutilLib.room:GetRoomShape(), InutilLib.room.Type, nil, nil, nil, nil, nil, StageAPI.GetCurrentRoomID())
			MusicManager():Play(RebekahCurse.Music.MUSIC_HEARTROOM, 0.1)
			MusicManager():Queue(RebekahCurse.Music.MUSIC_HEARTROOM)
			MusicManager():UpdateVolume()
			replacesong = true
			
			RebekahLocalSavedata.savedloveRoomDepletePercent = RebekahLocalSavedata.savedloveRoomDepletePercent - 45
			return testRoom
		end
	end
end)

end