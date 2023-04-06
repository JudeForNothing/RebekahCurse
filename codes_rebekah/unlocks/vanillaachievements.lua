--TAKEN FROM REVELATIONS

-- Some workarounds for not being able to access achievement data
-- dumb way being to just consider them unlocked if they have been
-- found vanilla at least once

-- REP FLOOR UNLOCK DETECTION

local StageToData = {
    [LevelStage.STAGE1_1] = "unlockedDross",
    [LevelStage.STAGE1_2] = "unlockedDross",
    [LevelStage.STAGE2_1] = "unlockedAshpit",
    [LevelStage.STAGE2_2] = "unlockedAshpit",
    [LevelStage.STAGE3_1] = "unlockedGehenna",
    [LevelStage.STAGE3_2] = "unlockedGehenna",
}

function yandereWaifu.HasUnlockedRepentanceAlt(levelStage)
    if StageToData[levelStage] then
        return revel.data[StageToData[levelStage]]
    end
    error(("HasUnlockedRepentanceAlt: no rep alt for stage '%d'"):format(levelStage), 2)
end


local function repAltDetectPostNewLevel()
    local levelStage, stageType = InutilLib.level:GetStage(), InutilLib.level:GetStageType()

    if stageType == StageType.STAGETYPE_REPENTANCE_B
    and StageToData[levelStage]
    and not RebekahLocalSavedata.Data[StageToData[levelStage]] then
        RebekahLocalSavedata.Data[StageToData[levelStage]] = true
    end
end

yandereWaifu:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, repAltDetectPostNewLevel)
