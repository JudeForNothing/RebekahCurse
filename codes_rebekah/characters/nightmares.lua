RebekahCurse.CustomTrapdoors = {
	--[[Glacier = {
		Anm2 = "gfx/backdrop/revelcommon/hubroom_2.0/trapdoors/trapdoor_glacier.anm2"
	},
	Tomb = {
		Anm2 = "gfx/backdrop/revelcommon/hubroom_2.0/trapdoors/trapdoor_tomb.anm2"
	},
	Vestige = {
		Anm2 = "gfx/backdrop/revelcommon/hubroom_2.0/trapdoors/trapdoor_vestige.anm2"
	},]]
}

yandereWaifu.VanillaNightmares = nil

function yandereWaifu.ClearTransitionNightmare()
    StageAPI.TransitionNightmares = {}
end

function yandereWaifu.ResetNightmaresForUniquePlayers(_, hasstarted) --Init
    if not yandereWaifu.VanillaNightmares then
        yandereWaifu.VanillaNightmares = InutilLib.Deepcopy(StageAPI.TransitionNightmares)
    else
        yandereWaifu.ClearTransitionNightmare()
        StageAPI.TransitionNightmares = InutilLib.Deepcopy(yandereWaifu.VanillaNightmares)
    end
	--doesnt work on challenges for some reason
    for i=0, InutilLib.game:GetNumPlayers()-1 do
		local player = Isaac.GetPlayer(i)
        if yandereWaifu.IsNormalRebekah(player) then
            yandereWaifu.ClearTransitionNightmare()
            StageAPI.AddTransitionNightmare("gfx/ui/nightmares/basic/nightmare1.anm2")
            StageAPI.AddTransitionNightmare("gfx/ui/nightmares/basic/nightmare2.anm2")
        end
        break
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, yandereWaifu.ResetNightmaresForUniquePlayers)

-- Get the next stage type in case of Repentance level transition
-- Example, if the next stage will be dross or downpour, etc
function yandereWaifu.SimulateStageTransitionStageType(levelStage, isRepPath)
	local oldStage, oldStageType = InutilLib.level:GetAbsoluteStage(), InutilLib.level:GetStageType()
    local seeds = InutilLib.game:GetSeeds()
	local oldSeed = seeds:GetStartSeedString()
	
	local testStage = levelStage - 1
	local testStageType = isRepPath and StageType.STAGETYPE_REPENTANCE or StageType.STAGETYPE_ORIGINAL
	InutilLib.level:SetStage(testStage, testStageType)
	
	InutilLib.level:SetNextStage()
	local stageType = InutilLib.level:GetStageType()
	
	seeds:SetStartSeed(oldSeed)
    InutilLib.level:SetStage(oldStage, oldStageType)
	
    -- In case of curse of labyrinth and others it doesn't work
    if isRepPath and not (stageType == StageType.STAGETYPE_REPENTANCE or stageType == StageType.STAGETYPE_REPENTANCE_B) then
        local rng = RNG()
        rng:SetSeed(seeds:GetStageSeed(levelStage), 127)
        if rng:RandomFloat() < 0.5 or not yandereWaifu.HasUnlockedRepentanceAlt(levelStage) then
            stageType = StageType.STAGETYPE_REPENTANCE
        else
            stageType = StageType.STAGETYPE_REPENTANCE_B
        end
    end

	return stageType
end

local function spawnRebekahTrapdoor(gridIndex, gridFile)
	local levelStage = InutilLib.level:GetAbsoluteStage()
    local curses =	InutilLib.game:GetLevel():GetCurses()
	
	if curses & LevelCurse.CURSE_OF_LABYRINTH ~= 0 then
		levelStage = levelStage + 1
	end
	
	local stage
        local isRepPath = false
        local decrement = 0
        if InutilLib.room:GetType() == RoomType.ROOM_SECRET_EXIT --[[and not (InutilLib.level:GetStageType() == StageType.STAGETYPE_REPENTANCE or InutilLib.level:GetStageType() == StageType.STAGETYPE_REPENTANCE_B )]] then
            isRepPath = true
            if not (InutilLib.level:GetStageType() == StageType.STAGETYPE_REPENTANCE or InutilLib.level:GetStageType() == StageType.STAGETYPE_REPENTANCE_B ) then
                decrement = -1
            end
        elseif InutilLib.room:GetType() ~= RoomType.ROOM_SECRET_EXIT and (InutilLib.level:GetStageType() == StageType.STAGETYPE_REPENTANCE or InutilLib.level:GetStageType() == StageType.STAGETYPE_REPENTANCE_B) and (InutilLib.level:GetStage() % 2 == 1) then
            isRepPath = false
        end

		stage = {
			NormalStage = true,
			Stage = levelStage + 1 + decrement,
			StageType = yandereWaifu.SimulateStageTransitionStageType(levelStage + 1 + decrement, isRepPath)
		}

		if levelStage == LevelStage.STAGE4_2 and not (InutilLib.level:GetStageType() == StageType.STAGETYPE_REPENTANCE or InutilLib.level:GetStageType() == StageType.STAGETYPE_REPENTANCE_B ) then
			print("ripperoni")
			print(gridFile)
			if gridFile ~= "gfx/grid/Door_11_Wombhole.anm2" then
				stage.Stage = LevelStage.STAGE5
			end
		end

	
	local trapdoor
	if stage.Name then
		trapdoor = RebekahCurse.CustomTrapdoors[stage.Name:gsub(" 2", "")]
	end
	
	StageAPI.SpawnCustomTrapdoor(
		InutilLib.room:GetGridPosition(gridIndex), 
		stage, 
		trapdoor and trapdoor.Anm2, 
		trapdoor and trapdoor.Size or 24,
		false
	)
end

yandereWaifu:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
	--[[if revel.data.oldHubActive == 2 and isRevStage() 
	and StageAPI.GetCurrentRoomType() ~= hub2.ROOMTYPE_HUBCHAMBER then]]
    if yandereWaifu.IsNormalRebekah(Isaac.GetPlayer(0)) and InutilLib.room:GetFrameCount() > 1 then
		for i = 0, InutilLib.room:GetGridSize() do
			local grid = InutilLib.room:GetGridEntity(i)
			--not ascent stuff
			--if InutilLib.level:GetCurrentRoomIndex() ~= -10 and Game():GetLevel():GetStage() ~= LevelStage.STAGE3_2 then
				if grid and grid.Desc.Type == GridEntityType.GRID_TRAPDOOR and (grid:GetSprite():GetFilename() ~= "gfx/grid/trapdoor_corpse_big.anm2" and grid:GetSprite():GetFilename() ~= "gfx/grid/VoidTrapdoor.anm2") then
					print(grid:GetSprite():GetFilename())
					print(grid.Desc.Type)
					
					local gridFile = grid:GetSprite():GetFilename()
					InutilLib.room:RemoveGridEntity(i, 0, false)
					InutilLib.room:Update()
					
					spawnRebekahTrapdoor(i, gridFile)
					
					table.insert(RebekahLocalSavedata.Data.rebekahTrapdoors, {ListIndex=InutilLib.level:GetCurrentRoomDesc().ListIndex, GridIndex=i, GridFile=gridFile})
				end
			--end
		end
	end
end)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()

    if RebekahLocalSavedata.Data.rebekahTrapdoors and #RebekahLocalSavedata.Data.rebekahTrapdoors > 0 then
        for _, trapdoorData in ipairs(RebekahLocalSavedata.Data.rebekahTrapdoors) do
            if InutilLib.level:GetCurrentRoomDesc().ListIndex == trapdoorData.ListIndex then
                spawnRebekahTrapdoor(trapdoorData.GridIndex, trapdoorData.GridFile)
            end
        end
    end
end)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_CURSE_EVAL, function(_)
	--if not old then
        RebekahLocalSavedata.Data.rebekahTrapdoors = {}
    --end
end)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(_, old)
	if not old then
        RebekahLocalSavedata.Data.rebekahTrapdoors = {}
    end
end)