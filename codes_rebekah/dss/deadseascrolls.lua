local json = require("json")

local cached_saved_data
function yandereWaifu.GetMenuSaveData()
	local data
    if not cached_saved_data then
        cached_saved_data = RebekahLocalSavedata.menudata
    end
    if not cached_saved_data then
		data = {}
	else
		data = cached_saved_data
    end
    return data
end

function yandereWaifu.StoreSaveData()
	yandereWaifu.Save()
    --Isaac.SaveModData(yandereWaifu, json.encode(yandereWaifu.menusavedata))
end

--
-- End of generic data storage manager
--

--
-- Start of menu code
--

-- Change this variable to match your mod. The standard is "Dead Sea Scrolls (Mod Name)"
local DSSModName = "Dead Sea Scrolls (Rebekah)"

-- DSSCoreVersion determines which menu controls the mod selection menu that allows you to enter other mod menus.
-- Don't change it unless you really need to and make sure if you do that you can handle mod selection and global mod options properly.
local DSSCoreVersion = 4

-- Every MenuProvider function below must have its own implementation in your mod, in order to handle menu save data.
local MenuProvider = {}

function MenuProvider.SaveSaveData()
    yandereWaifu.StoreSaveData()
end

function MenuProvider.GetPaletteSetting()
    return yandereWaifu.GetMenuSaveData().MenuPalette
end

function MenuProvider.SavePaletteSetting(var)
    yandereWaifu.GetMenuSaveData().MenuPalette = var
end

function MenuProvider.GetHudOffsetSetting()
    if not REPENTANCE then
        return yandereWaifu.GetMenuSaveData().HudOffset
    else
        return Options.HUDOffset * 10
    end
end

function MenuProvider.SaveHudOffsetSetting(var)
    if not REPENTANCE then
        yandereWaifu.GetMenuSaveData().HudOffset = var
    end
end

function MenuProvider.GetGamepadToggleSetting()
    return yandereWaifu.GetMenuSaveData().GamepadToggle
end

function MenuProvider.SaveGamepadToggleSetting(var)
    yandereWaifu.GetMenuSaveData().GamepadToggle = var
end

function MenuProvider.GetMenuKeybindSetting()
    return yandereWaifu.GetMenuSaveData().MenuKeybind
end


function MenuProvider.GetMenuHintSetting()
    return yandereWaifu.GetMenuSaveData().MenuHint
end



function MenuProvider.SaveMenuHintSetting(var)
    yandereWaifu.GetMenuSaveData().MenuHint = var
end

function MenuProvider.GetMenuBuzzerSetting()
    return yandereWaifu.GetMenuSaveData().MenuBuzzer
end

function MenuProvider.SaveMenuBuzzerSetting(var)
    yandereWaifu.GetMenuSaveData().MenuBuzzer = var
end


function MenuProvider.SaveMenuKeybindSetting(var)
    yandereWaifu.GetMenuSaveData().MenuKeybind = var
end

function MenuProvider.GetMenusNotified()
    return yandereWaifu.GetMenuSaveData().MenusNotified
end

function MenuProvider.SaveMenusNotified(var)
    yandereWaifu.GetMenuSaveData().MenusNotified = var
end

function MenuProvider.GetMenusPoppedUp()
    return yandereWaifu.GetMenuSaveData().MenusPoppedUp
end

function MenuProvider.SaveMenusPoppedUp(var)
    yandereWaifu.GetMenuSaveData().MenusPoppedUp = var
end

local DSSInitializerFunction = include('codes_rebekah.dss.dssmenucore')
local dssmod = DSSInitializerFunction(DSSModName, DSSCoreVersion, MenuProvider)

yandereWaifu.DSS_MOD = dssmod

local NOTE1_RENDER_OFFSET = Vector(-116, -27)
local NOTE2_RENDER_OFFSET = Vector(-32, -27)
local NOTE3_RENDER_OFFSET = Vector(-74, -27)

local completionNoteSprite = Sprite()
completionNoteSprite:Load("gfx/ui/completion_widget.anm2")
completionNoteSprite:SetFrame("Idle", 0)
--completionNoteSprite.Scale = Vector.One / 2

local completionHead = Sprite()
completionHead:Load("gfx/ui/completion_heads_cab.anm2")
completionHead:SetFrame("Fiend", 0)

local completionDoor = Sprite()
completionDoor:Load("gfx/ui/completion_doors_cab.anm2")
completionDoor:SetFrame("Fiend", 0)

local completionCharacterSets = {
    {
        {HeadName = "Rebekah", PlayerID = RebekahCurse.TECHNICAL_REB, IsUnlocked = function() return true end},
        --{HeadName = "Rebekah", PlayerID = RebekahCurse.TECHNICAL_REB, IsUnlocked = function() return FiendFolio.ACHIEVEMENT.BIEND:IsUnlocked() end},
    },
    {
        {HeadName = "Tainted Rebekah", PlayerID = RebekahCurse.SADREBEKAH, IsUnlocked = function() return true end},
        --{HeadName = "Rebekah", PlayerID = RebekahCurse.TECHNICAL_REB, IsUnlocked = function() return FiendFolio.ACHIEVEMENT.BIEND:IsUnlocked() end},
    }
}

-- Sorry I ALSO need these here too for the note rendering!
local function getScreenBottomRight()
    return Game():GetRoom():GetRenderSurfaceTopLeft() * 2 + Vector(442,286)
end

local function getScreenCenterPosition()
    return getScreenBottomRight() / 2
end

----
--local dssmod = yandereWaifu.DSS_MOD

local achievementGroups = {
    {
        Name = "miscellaneous",
        Tag = "Misc",
        Icon = "misc"
    },
    {
        Name = "rebekah character",
        Tag = "Rebekah Character",
        Icon = "rebekah character"
    },
    {
        Name = "rebekah",
        Tag = "Rebekah",
        Icon = "rebekah"
    },
    --[[{
        Name = "sadrebekah",
        Tag = "SadRebekah",
        Icon = "sadrebekah",
        DisplayIf = rebekahUnlocked
    },]]
    {
        Name = "challenge",
        Tag = "Challenge",
        Icon = "challenge"
    },
    {
        Name = "everything",
        Icon = "everything",
        TagToName = {
            --[[Misc = "miscellaneous",
            RebekahCharacter = "rebekah character",
            SadRebekah = "sadrebekah",
            Rebekah = "rebekah",
            Challenge = "challenge"]]
        },
        TagToDisplayIf = {
            SadRebekah = rebekahUnlocked
        },
        Achievements = {}
    }
    --[[{
        Name = "fiend",
        Tag = "Fiend",
        Icon = "fiend"
    },
    {
        Name = "tainted fiend",
        Tag = "Biend",
        Icon = "biend",
        DisplayIf = biendUnlocked
    },
    {
        Name = "golem",
        Tag = "Golem",
        Icon = "golem"
    },
    {
        Name = "challenge",
        Tag = "Challenge",
        Icon = "challenge"
    },
    {
        Name = "everything",
        Icon = "everything",
        TagToName = {
            Misc = "miscellaneous",
            Fiend = "fiend",
            Biend = "tainted fiend",
            Golem = "golem",
            Challenge = "challenge"
        },
        TagToDisplayIf = {
            Biend = biendUnlocked
        },
        Achievements = {}
    }]]
}

for _, group in ipairs(achievementGroups) do
    local sprite = Sprite()
    sprite:Load("gfx/ui/achievement/group_icons/group_icon.anm2", false)
    sprite:ReplaceSpritesheet(0, "gfx/ui/achievement/group_icons/icon_" .. group.Icon .. ".png")
    sprite:LoadGraphics()
    sprite:SetFrame("Idle", 0)
    group.Icon = sprite
end

local arrow = Sprite()
arrow:Load("gfx/ui/achievement/group_icons/arrow_icon.anm2", true)

local achievementLockedSprite = Sprite()
achievementLockedSprite:Load("gfx/ui/achievement/_cab_achievement.anm2", false)
achievementLockedSprite:ReplaceSpritesheet(0, "gfx/nothing.png")
achievementLockedSprite:ReplaceSpritesheet(2, "gfx/ui/achievement/achievement_locked.png")
achievementLockedSprite:LoadGraphics()

local achievementTooltipSprites = {
    Shadow = "gfx/ui/achievement/group_note/menu_achievement_shadow.png",
    Back = "gfx/ui/achievement/group_note/menu_achievement_back.png",
    Face = "gfx/ui/achievement/group_note/menu_achievement_face.png",
    Border = "gfx/ui/achievement/group_note/menu_achievement_border.png",
    Mask = "gfx/ui/achievement/group_note/menu_achievement_mask.png",
}

for k, v in pairs(achievementTooltipSprites) do
    local sprite = Sprite()
    sprite:Load("gfx/ui/achievement/group_note/menu_achievement.anm2", false)
    sprite:ReplaceSpritesheet(0, v)
    sprite:LoadGraphics()
    achievementTooltipSprites[k] = sprite
end


local displayIndexToScale = {
    [0] = Vector(1, 1),
    [1] = Vector(0.75, 0.75),
    [2] = Vector(0.5, 0.5),
    [3] = Vector(0, 0),
    [4] = Vector(0, 0)
}

local displayIndexToColor = {
    [0] = Color.Default,
    [1] = Color(0.9, 0.9, 0.9, 1, 0, 0, 0),
    [2] = Color(0.8, 0.8, 0.8, 1, 0, 0, 0),
    [3] = Color(0.8, 0.8, 0.8, 0, 0, 0, 0),
    [4] = Color(0, 0, 0, 0, 0, 0, 0)
}

local displayIndexToYPos = {
    [0] = -50,
    [1] = -40,
    [2] = -30,
    [3] = -20,
    [4] = 5000
}

yandereWaifu.achievementviewer = {
    format = {
        Panels = {
            {
                Panel = {
                    StartAppear = function(panel)
                        dssmod.playSound(dssmod.menusounds.Open)
                        panel.AppearFrame = 0
                        panel.Idle = false
                        Isaac.DebugString("did go her")
                    end,
                    UpdateAppear = function(panel)
                        Isaac.DebugString("did go eeeeeeee")
                        if panel.SpriteUpdateFrame then
                            panel.AppearFrame = panel.AppearFrame + 1
                            if panel.AppearFrame >= 10 then
                                panel.AppearFrame = nil
                                panel.Idle = true
                                return true
                            end
                        end
                    end,
                    StartDisappear = function(panel)
                        dssmod.playSound(dssmod.menusounds.Close)
                        panel.DisappearFrame = 0
                    end,
                    UpdateDisappear = function(panel)
                        if panel.SpriteUpdateFrame then
                            panel.DisappearFrame = panel.DisappearFrame + 1
                            if panel.DisappearFrame >= 11 then
                                return true
                            end
                        end
                    end,
                    RenderBack = function(panel, panelPos, tbl)
                        local anim, frame = "TrueIdle", 0
                        if panel.AppearFrame then
                            anim, frame = "AppearVert", panel.AppearFrame
                        elseif panel.DisappearFrame then
                            anim, frame = "DisappearVert", panel.DisappearFrame
                        end

                        if panel.ShiftFrame then
                            panel.ShiftFrame = panel.ShiftFrame + 1
                            if panel.ShiftFrame > panel.ShiftLength then
                                panel.ShiftLength = nil
                                panel.ShiftFrame = nil
                                panel.ShiftDirection = nil
                            end
                        end

                        local item = yandereWaifu.achievementviewer
                        local group = achievementGroups[item.achievementgroupselected]
                        local numAchievements = #group.Achievements

                        local displayedAchievements = {}

                        local displayedCount = 7 - 1
                        for i = -(displayedCount / 2), displayedCount / 2, 1 do
                            local listIndex = #displayedAchievements + 1
                            local indexOffset = 0
                            local shiftPercent
                            if panel.ShiftFrame then
                                shiftPercent = panel.ShiftFrame / panel.ShiftLength
                                indexOffset = ((1 - shiftPercent) * panel.ShiftDirection)
                            end

                            local percent = ((listIndex + indexOffset) - 1) / displayedCount
                            local xPos = InutilLib.ProAPILerp(-280, 280, percent)

                            local scale = displayIndexToScale[math.abs(i)]
                            local color = displayIndexToColor[math.abs(i)]
                            local yPos = displayIndexToYPos[math.abs(i)]
                            if shiftPercent then
                                local shiftedScale = displayIndexToScale[math.abs(i + panel.ShiftDirection)]
                                scale = InutilLib.ProAPILerp(shiftedScale, scale, shiftPercent)
                                local shiftedColor = displayIndexToColor[math.abs(i + panel.ShiftDirection)]
                                color = Color.Lerp(shiftedColor, color, shiftPercent)
                                local shiftedY = displayIndexToYPos[math.abs(i + panel.ShiftDirection)]
                                yPos = InutilLib.ProAPILerp(shiftedY, yPos, shiftPercent)
                            end

                            local index = (((item.selectedingroup[group.Name] + i) - 1) % numAchievements) + 1
                            local achievement = group.Achievements[index]
                            displayedAchievements[#displayedAchievements + 1] = {
                                Achievement = achievement.Achievement,
                                Position = Vector(xPos, yPos),
                                Scale = scale,
                                Color = color
                            }
                        end

                        table.sort(displayedAchievements, function(a, b)
                            return a.Position.Y > b.Position.Y
                        end)

                        for _, display in ipairs(displayedAchievements) do
                            local achievement = display.Achievement
                            local useSprite = achievement.Sprite
                            if not achievement:IsUnlocked(true) then
                                useSprite = achievementLockedSprite
                            end

                            useSprite:SetFrame(anim, frame)
                            useSprite.Scale = display.Scale
                            useSprite.Color = display.Color
                            useSprite:Render(panelPos + display.Position + Vector(0, 30), Vector.Zero, Vector.Zero)
                        end
                    end,
                    HandleInputs = function(panel, input, item, itemswitched, tbl)
                        if not itemswitched then
                            local menuinput = input.menu
                            local rawinput = input.raw
                            if rawinput.left > 0 or rawinput.right > 0 then
                                local group = achievementGroups[item.achievementgroupselected]
                                local name = group.Name
                                local numAchievements = #group.Achievements


                                local change
                                if not panel.ShiftFrame then
                                    local usingInput, setChange
                                    if rawinput.right > 0 then
                                        usingInput = rawinput.right
                                        setChange = 1
                                    elseif rawinput.left > 0 then
                                        usingInput = rawinput.left
                                        setChange = -1
                                    end

                                    local shiftLength = 10
                                    if usingInput >= 88 then
                                        shiftLength = 7
                                    end

                                    if (usingInput == 1 or (usingInput >= 18 and usingInput % (shiftLength + 1) == 0)) then
                                        change = setChange
                                        panel.ShiftLength = shiftLength
                                    end
                                end

                                if change then
                                    panel.ShiftFrame = 0
                                    panel.ShiftDirection = change
                                    item.selectedingroup[name] = ((item.selectedingroup[name] + change -  1) % numAchievements) + 1
                                    dssmod.playSound(dssmod.menusounds.Pop3)
                                end
                            elseif menuinput.down or menuinput.up then
                                local change
                                if menuinput.down then
                                    change = 1
                                elseif menuinput.up then
                                    change = -1
                                end

                                if change then
                                    local done = false
                                    while not done do
                                        item.achievementgroupselected = ((item.achievementgroupselected + change - 1) % #achievementGroups) + 1
                                        local group = achievementGroups[item.achievementgroupselected]
                                        if not group.DisplayIf or group.DisplayIf() then
                                            done = true
                                        end
                                    end

                                    dssmod.playSound(dssmod.menusounds.Pop2)
                                end
                            end
                        end
                    end
                },
                Offset = Vector.Zero,
                Color = Color.Default
            },
            {
                Panel = {
                    Sprites = achievementTooltipSprites,
                    Bounds = {-115, -22, 115, 22},
                    Height = 44,
                    TopSpacing = 2,
                    BottomSpacing = 0,
                    DefaultFontSize = 2,
                    DrawPositionOffset = Vector(2, 2),
                    Draw = function(panel, pos, item, tbl)
                        local drawings = {}
                        local group = achievementGroups[item.achievementgroupselected]
                        if item.selectedingroup[group.Name] then
                            local achievementDat = group.Achievements[item.selectedingroup[group.Name]]
                            local achievement = achievementDat.Achievement
                            local tooltipConcat = ""
                            local tooltipConcat2 = ""
                            local singleLineLimit = 3
                            if not achievement.ViewerTooltip then
                                for i, entry in ipairs(achievement.Tooltip) do
                                    local toConcat = entry
                                    if i ~= #achievement.Tooltip and i ~= singleLineLimit then
                                        toConcat = toConcat .. " "
                                    end

                                    if i > singleLineLimit then
                                        tooltipConcat2 = tooltipConcat2 .. toConcat
                                    else
                                        tooltipConcat = tooltipConcat .. toConcat
                                    end
                                end
                            end

                            local name = achievement.Name
                            if not achievement:IsUnlocked(true) then
                                name = "locked!"
                            end

                            local buttons = {
                                {str = "- " .. achievementDat.Group .. " -", fsize = 1},
                                {str = name, fsize = 2},
                            }

                            if tooltipConcat ~= "" then
                                buttons[#buttons + 1] = {str = tooltipConcat, fsize = 1}
                            end

                            if tooltipConcat2 ~= "" then
                                buttons[#buttons + 1] = {str = tooltipConcat2, fsize = 1}
                            end

                            if achievement.ViewerTooltip then
                                for _, str in ipairs(achievement.ViewerTooltip) do
                                    buttons[#buttons + 1] = {str = str, fsize = 1}
                                end
                            end

                            local drawItem = {
                                valign = -1,
                                buttons = buttons
                            }
                            drawings = dssmod.generateMenuDraw(drawItem, drawItem.buttons, pos, panel.Panel)
                        end

                        if group then
                            table.insert(drawings, {type = "spr", pos = Vector(-96, 1), sprite = group.Icon, noclip = true, root = pos, usemenuclr = true})
                            table.insert(drawings, {type = "spr", pos = Vector(-96, -14), anim = "Idle", frame = 0, sprite = arrow, noclip = true, root = pos, usemenuclr = true})
                            table.insert(drawings, {type = "spr", pos = Vector(-96, 16), anim = "Idle", frame = 1, sprite = arrow, noclip = true, root = pos, usemenuclr = true})
                        end

                        for _, drawing in ipairs(drawings) do
                            dssmod.drawMenu(tbl, drawing)
                        end
                    end,
                    DefaultRendering = true
                },
                Offset = Vector(0, 100),
                Color = 1
            }
        }
    },
    generate = function(item, tbl)
        for _, group in ipairs(achievementGroups) do
            group.Achievements = {}
        
            local achievements
            if group.Tag then
                achievements = yandereWaifu.GetAchievementsWithTag(group.Tag)
            else
                achievements = yandereWaifu.ACHIEVEMENT_ORDERED
            end
        
            for _, achieve in ipairs(achievements) do
                if achieve.Sprite then
                    local groupName = group.Name
                    if group.TagToName then
                        for tag, name in pairs(group.TagToName) do
                            if achieve.Tags[tag] then
                                groupName = name
                                break
                            end
                        end
                    end

                    local display = true
                    if group.TagToDisplayIf then
                        for tag, func in pairs(group.TagToDisplayIf) do
                            if achieve.Tags[tag] and not func() then
                                display = false
                                break
                            end
                        end
                    end

                    if achieve.ViewerDisplayIf and not achieve.ViewerDisplayIf() then
                        display = false
                    end
                    
                    if display then
                        group.Achievements[#group.Achievements + 1] = {Achievement = achieve, Group = groupName}
                    end
                end
            end
        
            item.selectedingroup[group.Name] = 1
        end
    end,
    achievementgroupselected = 1,
    selectedingroup = {}
}


---

local rebekahdirectory = {
    main = {
    title = 'rebekah',
        buttons = {
            {str = 'resume game', action = 'resume'},
            {str = 'settings', dest = 'settings'},
            {str = 'unlocks', dest = 'unlocks'},
			{str = 'tutorials', dest = 'tutoriallist'},
			{str = 'credits', dest = 'credits'},
        },
        tooltip = dssmod.menuOpenToolTip
    },
	
    settings = {
        title = 'settings',
        buttons = {
            dssmod.gamepadToggleButton,
            dssmod.menuKeybindButton,
            dssmod.paletteButton,
			{
                str = 'disable double tap',
                choices = {'no', 'yes'},
                variable = "disableDoubleTapDash",
                setting = 2,
                load = function()
                    return RebekahLocalSavedata.Config.disablerebekahdash and 2 or 1
                end,
                store = function(var)
                    RebekahLocalSavedata.Config.disablerebekahdash = var == 2
                end,
                tooltip = {strset = {'disable dash', 'for', 'rebekah'}}
            },
			{
                str = 'dash key',
                keybind = true,
                setting = -1,
                variable = 'DashKeybind',
                load = function()
                    return  RebekahLocalSavedata.Config.rebekahdashkey or -1
                end,
                store = function(var)
                    RebekahLocalSavedata.Config.rebekahdashkey = var
                end,
                tooltip = {strset = {'optional', 'keybind', 'to dash', 'for scrubs'}}
            },
            {
                str = 'rebekah init',
                choices = {'default', 'no menu'},
                variable = "rebekahInit",
                setting = 2,
                load = function()
                    return RebekahLocalSavedata.Config.menu_init and 2 or 1
                end,
                store = function(var)
                    RebekahLocalSavedata.Config.menu_init = var == 2
                end,
                tooltip = {strset = {'pick whether', 'have menu or', 'nott'}}
            },
            --[[ {
                str = 'narrator volume',
                increment = 1, max = 10,
                variable = "volume",
                slider = true,
                setting = 10,
                load = function()
                    return RebekahLocalSavedata.Config.narratorvolume
                end,
                store = function(var)
                    RebekahLocalSavedata.Config.narratorvolume = var
                end,
                tooltip = {strset = {'how loud', 'narrator of', 'rebekah', 'needs to be?'}}
            }]]--[[,
			{
                str = 'unlock basic items',
                choices = {'no', 'yes'},
                variable = "unlockItems",
                setting = 2,
                load = function()
                    return RebekahCurse.REBEKAH_OPTIONS.UNLOCK_ITEMS and 2 or 1
                end,
                store = function(var)
                    RebekahCurse.REBEKAH_OPTIONS.UNLOCK_ITEMS = var == 2
                end,
                tooltip = {strset = {'progress should', 'be saved...', 'stop being a', 'casual!'}}
            },]]
            {
                str = 'have rebekah items',
                choices = {'no', 'yes'},
                variable = 'enableItems',
                setting = 2,
                load = function()
                    return RebekahLocalSavedata.Config.itemsEnabled and 2 or 1
                end,
                store = function(var)
                    RebekahLocalSavedata.Config.itemsEnabled = var == 2
                end,
                tooltip = {strset = {'disable', 'all rebekah', 'items for', 'some reason'}}
            },
        }
    },

    unlocks = {
        title = 'unlocks!',
        buttons = {
            {str = 'achievements', dest = 'achievementviewer'},
            {str = 'completion notes', dest = 'completionnotes'},
            {str = 'unlock manager', dest = 'unlockmanager'},
        },
        tooltip = {strset = {'check out', 'what you', 'unlocked!'}}
    },
	
    achievementviewer = yandereWaifu.achievementviewer,

    unlockmanager = {
        title = "unlocks manager",
        fsize = 2,

        buttons = {
            {str = "", nosel = true},
            {
                str = "achievements",
                fsize = 3,
                choices = {"enabled", "disabled"},
                variable = "AchievementsEnabled",
                setting = 1,
                load = function()
                    if RebekahLocalSavedata.Config.disableAchievements then
                        return 2
                    else
                        return 1
                    end
                end,
                store = function(var)
                    RebekahLocalSavedata.Config.disableAchievements = var == 2
                end,
                tooltip = {strset = {'switch this', 'to enable or', 'disable all', 'unlocks!'}}
            },
            {str = "", nosel = true},
            {str = "unlock all", dest = "areyousure", func = function() areYouSureUnlockTag = nil isUnlockingAll = true end},
            {str = "lock all", dest = "areyousure", func = function() areYouSureUnlockTag = nil isUnlockingAll = false end},
            {str = "", nosel = true},
            {str = "-----------------", fsize = 3, nosel = true},
            {str = "", fsize = 1, nosel = true},
            {str = "character unlocks", fsize = 3, nosel = true},
            {str = "", nosel = true},
            {str = "rebekah", fsize = 3, dest = "rebekahaunlocks"},

            --[[
            {str = "tainted fiend", fsize = 3, dest = "biendunlocks", displayif = function() return FiendFolio.ACHIEVEMENT.BIEND:IsUnlocked() end},
            {str = "golem", fsize = 3, dest = "golemunlocks"},
            {str = "", nosel = true},
            {str = "unlock all", dest = "areyousure", func = function() areYouSureUnlockTag = "Character" isUnlockingAll = true end},
            {str = "lock all", dest = "areyousure", func = function() areYouSureUnlockTag = "Character" isUnlockingAll = false end},
            {str = "", nosel = true},

            {str = "-----------------", fsize = 3, nosel = true},
            {str = "", fsize = 1, nosel = true},
            {str = "challenge unlocks", fsize = 3, nosel = true},
            {str = "", fsize = 3, nosel = true},
            -- this isn't a real button, gets replaced later with list of unlocks automatically
            {insertUnlockTag = "Challenge"},
            {str = "", nosel = true},
            {str = "unlock all", dest = "areyousure", func = function() areYouSureUnlockTag = "Challenge" isUnlockingAll = true end},
            {str = "lock all", dest = "areyousure", func = function() areYouSureUnlockTag = "Challenge" isUnlockingAll = false end},
            {str = "", nosel = true},

            {str = "-----------------", fsize = 3, nosel = true},
            {str = "", fsize = 1, nosel = true},
            {str = "other unlocks", fsize = 3, nosel = true},
            {str = "", fsize = 1, nosel = true},
            {insertUnlockTag = "Misc"},
            {str = "", fsize = 3, nosel = true},
            {str = "unlock all", dest = "areyousure", func = function() areYouSureUnlockTag = "Misc" isUnlockingAll = true end},
            {str = "lock all", dest = "areyousure", func = function() areYouSureUnlockTag = "Misc" isUnlockingAll = false end},]]
        },
    },
    ---
    completionnotes = {
        title = "completion notes",
        nocursor = true,
        buttons = {
            {str = ""},
            {str = ""},

            {str = "", nosel = true},
            {str = "", nosel = true},
            {str = "", nosel = true},
            {str = "", nosel = true},
            {str = "", nosel = true},
            {str = "", fsize = 2, nosel = true},

            {
                str = "press down for tainted rebekah",
                nosel = true,
                fsize = 1,

                displayif = function(_, item)
                    return item.bsel == 1
                end,
            },
            {
                str = "press up for rebekah",
                nosel = true,
                fsize = 1,

                displayif = function(_, item)
                    return item.bsel > 1
                end,
            },
        },

        postrender = function(item, tbl)
            if item.bsel > 2 then item.bsel = 1 end -- Idk why DSS is letting me pick a third option in the menu with only 2 non-nosel buttons but whatever

            local centre = getScreenCenterPosition()
            local renderDataset = completionCharacterSets[item.bsel]
            local offsets = {NOTE1_RENDER_OFFSET, NOTE2_RENDER_OFFSET}
            if #renderDataset == 1 then offsets = {NOTE3_RENDER_OFFSET} end

            for index, renderData in pairs(renderDataset) do
                if renderData.IsUnlocked() then
                    local dataset = yandereWaifu.GetCompletionNoteLayerDataFromPlayerType(renderData.PlayerID)
                    for index, value in pairs(dataset) do
                        completionNoteSprite:SetLayerFrame(index, value)
                    end
                    completionHead:SetFrame(renderData.HeadName, 0)

                    completionNoteSprite:Render(centre + offsets[index], Vector.Zero, Vector.Zero)
                    completionHead:Render(centre + offsets[index] + Vector(30, 85), Vector.Zero, Vector.Zero)
                else
                    completionHead:SetFrame(renderData.HeadName, 1)
                    completionHead:Render(centre + offsets[index] + Vector(30, 85), Vector.Zero, Vector.Zero)

                    completionDoor:SetFrame(renderDataset[index - 1].HeadName, 0)
                    completionDoor:Render(centre + offsets[index], Vector.Zero, Vector.Zero)
                end
            end
        end,
        
        generate = function(item)
            local numAchievements = yandereWaifu.TOTAL_COMPLETION_ACHIEVEMENTS
            local numCompleted = yandereWaifu.GetNumCompletedAchievements() + 5
            local asPercent = string.format("%.f%%", (numCompleted / numAchievements) * 100)
            local extra = ""
            if numCompleted > numAchievements then
                extra = "!?!"
            elseif numCompleted == numAchievements then
                extra = "!!"
            end
            item.tooltip = {strset = {"you're", asPercent, "done with", "this mod! wow!" .. extra}}
        end
    },
    ---
	tutoriallist = {
        title = 'tutorials',
        buttons = {
		   {str = 'rebekah', fsize = 3, clr = 3},
           {str = 'basics', dest = 'tutorialrebbasic', fsize = 2--[[, displayif = function() return lib.GetSaveData().CakeUnlocked end]]},
		   {str = 'advanced', dest = 'tutorialrebadvanced', fsize = 2--[[, displayif = function() return lib.GetSaveData().CakeUnlocked end]]},
        },
		tooltip = {strset = {'learn', 'confusing', 'concepts!'}}
    },
	
	tutorialrebbasic = yandereWaifu.dss_rebekahbasics,
	tutorialrebadvanced = yandereWaifu.dss_rebekahadvanced,
	
	credits = {
        title = 'credits',
        fsize = 1,
        buttons = {
            {str = 'current team', fsize = 2},
            {strpair = {{str = 'judeinutil'}, {str = 'coder'}}},
			{strpair = {{str = ''}, {str = 'spriter'}}, nosel = true},
			{strpair = {{str = ''}, {str = 'concept artist'}}, nosel = true},
            {strpair = {{str = 'aegis vanilla'}, {str = 'main concept artist'}}},
			{str = 'old contributer team', fsize = 2},
			{str = '', nosel = true},
            {strpair = {{str = 'kakaodcat', color = 3}, {str = 'main ab+ dev'}}},
			{strpair = {{str = 'goki_dev', color = 3}, {str = 'extra code'}}},
			{strpair = {{str = 'lambchop'}, {str = 'coder'}}},
			{strpair = {{str = ''}, {str = 'spriter'}}, nosel = true},
			{strpair = {{str = 'mayonez'}, {str = 'music'}}},
			{strpair = {{str = ''}, {str = 'sound design'}}, nosel = true},
			{strpair = {{str = 'shuckster'}, {str = 'quality assurance'}}},
			{str = '', nosel = true},
			{strpair = {{str = 'frithian', color = 3}, {str = 'public relations'}}},
			{strpair = {{str = 'sabra', color = 3}, {str = 'wiki manager'}}},
			{strpair = {{str = 'scorch71', color = 3}, {str = 'coder'}}},
            {strpair = {{str = 'impupzables', color = 3}, {str = 'spriter'}}},
			{strpair = {{str = 'deadvoxel', color = 3}, {str = 'spriter'}}},
			{strpair = {{str = 'aladar', color = 3}, {str = 'spriter'}}},
			{strpair = {{str = 'zer0', color = 3}, {str = 'spriter'}}},
			{strpair = {{str = 'susuke', color = 3}, {str = 'spriter'}}},
			{strpair = {{str = 'scroto', color = 3}, {str = 'spriter'}}},
			--[[{strpair = {{str = 'kruntical', color = 2}, {str = 'spriter'}}},]] --bad weirdo
			{str = '', nosel = true},
            {str = 'mod contributers', fsize = 2},
            {strpair = {{str = 'lost', color = 2}, {str = 'made the grey sisters!'}}},
            {strpair = {{str = 'mr burns', color = 2}, {str = 'tainted rebekah sounds'}}},
            --[[{strpair = {{str = 'skulgan', color = 2}, {str = 'made peewee!'}}},]] --taken out of this mod
			{str = 'voice actors', fsize = 2},
			{strpair = {{str = 'ab+ rebekah'}, {str = 'may'}}},
            {strpair = {{str = 'rebekah'}, {str = 'plupa'}}},
			{strpair = {{str = 'knights of rebekah'}, {str = 'kakaodcat'}}},
			{strpair = {{str = 'pill narrator'}, {str = 'frithian'}}},
			{strpair = {{str = 'free sounds'}, {str = 'soundbible'}}},
			{strpair = {{str = ''}, {str = 'freesound'}}, nosel = true},
			{strpair = {{str = ''}, {str = 'zapslapt'}}, nosel = true},
			{strpair = {{str = ''}, {str = 'soundsnap'}}, nosel = true},
            {str = '', nosel = true},
			{str = 'beta testers', fsize = 2},
			{str = 'cube-erry cherry'},
			{str = 'thememeingofisaac/ysak'},
			{str = 'abyss knight/baraka'},
			{str = 'apostle'},
			{str = 'zanariff/zana'},
			{str = 'mars'},
			{str = 'kaethela'},
			{str = 'masquerade'},
			{str = 'collided'},
			{str = 'shadeshadow227'},
			{str = 'duo'},
			{str = 'mr. l'},
			{str = 'skyline222'},
			{str = 'shuckster'},
			{str = 'nixility'},
            {str = 'bruh power'},
            {str = 'beelzeon'},
            {str = 'serathespookster'},
            {str = 'rougewatermelon'},
            {str = 'serathespookster'},
            {str = 'suese'},
			{str = '', nosel = true},
            {str = 'special thanks', fsize = 2},
			{strpair = {{str = 'agent cucco', color = 3}, {str = 'code help'}}},
			{strpair = {{str = '_kilburn', color = 3}, {str = 'code for hearts'}}},
			{strpair = {{str = 'tem', color = 3}, {str = 'code for players'}}},
			{strpair = {{str = 'sentinel', color = 3}, {str = 'code help'}}},
            {strpair = {{str = 'xalum', color = 3}, {str = 'code help'}}},
            {strpair = {{str = 'aevilok', color = 3}, {str = 'innate item script'}}},
			{strpair = {{str = 'sanio', color = 3}, {str = 'code for mega mush'}}},
			{strpair = {{str = 'dumpy', color = 3}, {str = 'code help'}}},
			{strpair = {{str = 'warhamm2000', color = 3}, {str = 'code help'}}},
			{strpair = {{str = 'deadinfinity', color = 3}, {str = 'stageapi help'}}},
			{strpair = {{str = 'planetarium chance', color = 3}, {str = 'code reference'}}},
			{strpair = {{str = 'scooperman', color = 3}, {str = 'sprite advice'}}},
            {strpair = {{str = 'sgjd01', color = 3}, {str = 'code reference'}}},
            {strpair = {{str = 'tainted treasures', color = 3}, {str = 'code reference'}}},
            {strpair = {{str = 'fiend folio', color = 3}, {str = 'code reference'}}},
            {str = 'gorange'},
			{str = '', nosel = true},
			{str = 'and especially you!', fsize = 3},
            {str = '', nosel = true}
        },
        --tooltip = {strset = {'epic credits', 'for epic', 'people!'}}
    },
    rebekahaunlocks = {
        title = "rebekah unlocks",
        fsize = 2,
        buttons = {
            {str = "", nosel = true},
            --{str = "completion note", fsize = 3, dest = "rebekahacompletion", tooltip = completionNoteTip},
            {str = "", nosel = true},
            {str = "-----------------", fsize = 3, nosel = true},
            {str = "", fsize = 1, nosel = true},
            --{insertUnlockTag = "RebekahB"},
            {str = "", nosel = true},
            {str = "-----------------", fsize = 3, nosel = true},
            {str = "personalities", fsize = 3, dest = "rebekahapersonalityunlocks"},
            {str = "-----------------", fsize = 3, nosel = true},
            {str = "", fsize = 1, nosel = true},
            {str = "item unlocks", fsize = 3, nosel = true},
            {str = "", fsize = 3, nosel = true},
            {insertUnlockTag = "Rebekah"},
            {str = "", nosel = true},
            {str = "unlock all", dest = "areyousure", func = function() areYouSureUnlockTag = "Rebekah" isUnlockingAll = true end},
            {str = "lock all", dest = "areyousure", func = function() areYouSureUnlockTag = "Rebekah" isUnlockingAll = false end},
            {str = "", nosel = true},
            {str = "-----------------", fsize = 3},
            {str = "-----------------", fsize = 3},
            {str = "-----------------", fsize = 3},
            {str = "-----------------", fsize = 3},
            {str = "-----------------", fsize = 3},
            {str = "-----------------", fsize = 3},
            {str = "-----------------", fsize = 3},
            {str = "-----------------", fsize = 3},
            {str = "-----------------", fsize = 3},
        }
    },
    rebekahacompletion = {
        title = "rebekah completion",
        fsize = 2,
        buttons = {
            {
                str = "mom's heart / it lives",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "fiend_heart",
                setting = 1,

                load = function()
                    return RebekahLocalSavedata.CompletionMarks["technical rebekah"].heart + 1 or 1
                end,

                store = function(var)
                    RebekahLocalSavedata.CompletionMarks["technical rebekah"].heart = var - 1
                end,

                tooltip = {strset = {"lil fiend", "", "unlocks on", "hard"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "isaac",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "rebekah_isaac",
                setting = 1,
                
                load = function()
                    return RebekahLocalSavedata.CompletionMarks["technical rebekah"].isaac + 1 or 1
                end,

                store = function(var)
                    RebekahLocalSavedata.CompletionMarks["technical rebekah"].isaac = var - 1
                end,

                tooltip = {strset = {"imp soda", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "???",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "rebekah_bluebaby",
                setting = 1,
                
                load = function()
                    return RebekahLocalSavedata.CompletionMarks["technical rebekah"].bbaby + 1 or 1
                end,

                store = function(var)
                    RebekahLocalSavedata.CompletionMarks["technical rebekah"].bbaby = var - 1
                end,

                tooltip = {strset = {"shard of", "china", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "satan",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "rebekah_satan",
                setting = 1,
                
                load = function()
                    return RebekahLocalSavedata.CompletionMarks["technical rebekah"].satan + 1 or 1
                end,

                store = function(var)
                    RebekahLocalSavedata.CompletionMarks["technical rebekah"].satan = var - 1
                end,

                tooltip = {strset = {"rebekah mix", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "the lamb",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "rebekah_lamb",
                setting = 1,
                
                load = function()
                    return RebekahLocalSavedata.CompletionMarks["technical rebekah"].lamb + 1 or 1
                end,

                store = function(var)
                    RebekahLocalSavedata.CompletionMarks["technical rebekah"].lamb = var - 1
                end,

                tooltip = {strset = {"prank cookie", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "boss rush",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "rebekah_rush",
                setting = 1,
                
                load = function()
                    return RebekahLocalSavedata.CompletionMarks["technical rebekah"].rush + 1 or 1
                end,

                store = function(var)
                    RebekahLocalSavedata.CompletionMarks["technical rebekah"].rush = var - 1
                end,

                tooltip = {strset = {"gmo corn", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "hush",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "rebekah_hush",
                setting = 1,
                
                load = function()
                    return RebekahLocalSavedata.CompletionMarks["technical rebekah"].hush + 1 or 1
                end,

                store = function(var)
                    RebekahLocalSavedata.CompletionMarks["technical rebekah"].hush = var - 1
                end,

                tooltip = {strset = {"+3 fireballs", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "mega satan",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "rebekah_megasatan",
                setting = 1,
                
                load = function()
                    return RebekahLocalSavedata.CompletionMarks["technical rebekah"].mega + 1 or 1
                end,

                store = function(var)
                    RebekahLocalSavedata.CompletionMarks["technical rebekah"].mega = var - 1
                end,

                tooltip = {strset = {"pyromancy", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "ultra greed(ier)",
                choices = {"uncompleted", "completed: greed", "completed: greedier"},
                variable = "rebekah_greed",
                setting = 1,

                load = function()
                    return RebekahLocalSavedata.CompletionMarks["technical rebekah"].greed + 1 or 1
                end,

                store = function(var)
                    RebekahLocalSavedata.CompletionMarks["technical rebekah"].greed = var - 1
                end,

                tooltip = {strset = {"cool", "sunglasses", "unlocks on", "greed+", "", "jack cards", "unlock on", "greedier"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "delirium",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "rebekah_delirium",
                setting = 1,
                
                load = function()
                    return RebekahLocalSavedata.CompletionMarks["technical rebekah"].deli + 1 or 1
                end,

                store = function(var)
                    RebekahLocalSavedata.CompletionMarks["technical rebekah"].deli = var - 1
                end,

                tooltip = {strset = {"rebekahs horn", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "mother",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "rebekah_mother",
                setting = 1,
                
                load = function()
                    return RebekahLocalSavedata.CompletionMarks["technical rebekah"].mother + 1 or 1
                end,

                store = function(var)
                    RebekahLocalSavedata.CompletionMarks["technical rebekah"].mother = var - 1
                end,

                tooltip = {strset = {"the devils", "harvest", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "beast",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "rebekah_beast",
                setting = 1,
                
                load = function()
                    return RebekahLocalSavedata.CompletionMarks["technical rebekah"].beast + 1 or 1
                end,

                store = function(var)
                    RebekahLocalSavedata.CompletionMarks["technical rebekah"].beast = var - 1
                end,

                tooltip = {strset = {"fetal rebekah", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {str = "the rebekah folio", nosel = true},
            {str = "unlocked by beating everything on hard", fsize = 1, nosel = true},
            {str = "", nosel = true},
        },
    },
    rebekahapersonalityunlocks = {
        title = "personality unlocks",
        fsize = 2,
        buttons = {
            {insertUnlockTag = "Rebekah Character"},
            {str = "", nosel = true},
            {str = "unlock all", dest = "areyousure", func = function() areYouSureUnlockTag = "Rebekah" isUnlockingAll = true end},
            {str = "lock all", dest = "areyousure", func = function() areYouSureUnlockTag = "Rebekah" isUnlockingAll = false end},
            {str = "", nosel = true},
        }
    }
}

local function insertUnlockTags(item)
    for i, v in ipairs(item.buttons) do
        if v.insertUnlockTag then
            local buttons = yandereWaifu.GetMenuButtonsForAchievementTag(v.insertUnlockTag)
            for b, button in ipairs(buttons) do
                table.insert(item.buttons, i + b, button)
            end
        end
    end
    
    for i = #item.buttons, 1, -1 do
        local v = item.buttons[i]
        if v.insertUnlockTag then
            table.remove(item.buttons, i)
        end
    end
end

insertUnlockTags(rebekahdirectory.unlockmanager)
insertUnlockTags(rebekahdirectory.rebekahaunlocks)
insertUnlockTags(rebekahdirectory.rebekahapersonalityunlocks)

local rebekahdirectorykey = {
    Item = rebekahdirectory.main,
    Main = 'main',
    Idle = false,
    MaskAlpha = 1,
    Settings = {},
    SettingsChanged = false,
    Path = {},
}

DeadSeaScrollsMenu.AddMenu("Rebekah", {Run = dssmod.runMenu, Open = dssmod.openMenu, Close = dssmod.closeMenu, Directory = rebekahdirectory, DirectoryKey = rebekahdirectorykey})
