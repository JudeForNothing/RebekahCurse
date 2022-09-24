local json = require("json")
function yandereWaifu.GetMenuSaveData()
	local data
	local savedata = yandereWaifu.GetSaveData().menudata
    if not savedata.menudata then
		data = {}
	else
		data = savedata.menudata
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

local rebekahdirectory = {
    main = {
    title = 'rebekah',
        buttons = {
            {str = 'resume game', action = 'resume'},
            {str = 'settings', dest = 'settings'},
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
                    return REBEKAH_OPTIONS.DASHKEY_ENABLE and 2 or 1
                end,
                store = function(var)
                    REBEKAH_OPTIONS.DASHKEY_ENABLE = var == 2
                end,
                tooltip = {strset = {'disable dash', 'for', 'rebekah'}}
            },
			{
                str = 'dash key',
                keybind = true,
                variable = 'DashKeybind',
                setting = -1,
                load = function()
                    return REBEKAH_OPTIONS.DASHKEY_BIND or -1
                end,
                store = function(var)
                    REBEKAH_OPTIONS.DASHKEY_BIND = var
                end,
                tooltip = {strset = {'optional', 'keybind', 'to dash', 'for scrubs'}}
            },
            {
                str = 'narrator volume',
                increment = 1, max = 10,
                variable = "volume",
                slider = true,
                setting = 10,
                load = function()
                    return REBEKAH_OPTIONS.VOICE_VOLUME
                end,
                store = function(var)
                    REBEKAH_OPTIONS.VOICE_VOLUME = var
                end,
                tooltip = {strset = {'how loud', 'narrator of', 'rebekah', 'needs to be?'}}
            },
			{
                str = 'unlock basic items',
                choices = {'no', 'yes'},
                variable = "unlockItems",
                setting = 2,
                load = function()
                    return REBEKAH_OPTIONS.UNLOCK_ITEMS and 2 or 1
                end,
                store = function(var)
                    REBEKAH_OPTIONS.UNLOCK_ITEMS = var == 2
                end,
                tooltip = {strset = {'progress should', 'be saved...', 'stop being a', 'casual!'}}
            },
        }
    },
	
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
			{str = 'main contributer team', fsize = 2},
			{str = '', nosel = true},
            {strpair = {{str = 'kakaodcat', color = 3}, {str = 'main ab+ dev'}}},
			{strpair = {{str = 'aegis vanilla'}, {str = 'main concept artist'}}},
			{strpair = {{str = 'goki_dev', color = 3}, {str = 'extra code'}}},
			{strpair = {{str = 'lambchop'}, {str = 'coder'}}},
			{strpair = {{str = ''}, {str = 'spriter'}}, nosel = true},
			{strpair = {{str = 'judeinutil'}, {str = 'coder'}}},
			{strpair = {{str = ''}, {str = 'spriter'}}, nosel = true},
			{strpair = {{str = ''}, {str = 'concept artist'}}, nosel = true},
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
			{strpair = {{str = 'kruntical', color = 2}, {str = 'spriter'}}},
			{str = '', nosel = true},
			{str = 'voice actors', fsize = 2},
			{strpair = {{str = 'rebekah'}, {str = 'may'}}},
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
			{str = '', nosel = true},
            {str = 'special thanks', fsize = 2},
			{strpair = {{str = 'agent cucco', color = 3}, {str = 'code help'}}},
			{strpair = {{str = '_kilburn', color = 3}, {str = 'code for hearts'}}},
			{strpair = {{str = 'tem', color = 3}, {str = 'code for players'}}},
			{strpair = {{str = 'sentinel', color = 3}, {str = 'code help'}}},
			{strpair = {{str = 'sanio', color = 3}, {str = 'code for mega mush'}}},
			{strpair = {{str = 'dumpy', color = 3}, {str = 'code help'}}},
			{strpair = {{str = 'warhamm2000', color = 3}, {str = 'code help'}}},
			{strpair = {{str = 'deadinfinity', color = 3}, {str = 'stageapi help'}}},
			{strpair = {{str = 'planetarium chance', color = 3}, {str = 'code reference'}}},
			{strpair = {{str = 'scooperman', color = 3}, {str = 'sprite advice'}}},
            {strpair = {{str = 'sgjd01', color = 3}, {str = 'code reference'}}},
            {strpair = {{str = 'tainted treasures', color = 3}, {str = 'code reference for synergy'}}},
            {strpair = {{str = 'fiend folio', color = 3}, {str = 'code reference'}}},
			{str = '', nosel = true},
			{str = 'and especially you!', fsize = 3},
            {str = '', nosel = true}
        },
        tooltip = {strset = {'epic credits', 'for epic', 'people!'}}
    }
}

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
