local mod

--the version of this helper mod script
local currentVersion = 8

--remove any previous versions that may exist, piber style
local callbacksAlreadyLoaded = nil
if InutilLib then
	local thisVersion = 1
	if InutilLib.Version then
		thisVersion = InutilLib.Version
	end
	if thisVersion < currentVersion then
		InutilLib = nil
		InutilLibFiles = {}
		Isaac.DebugString("Removed older inutillib helper (version " .. thisVersion .. ")")
	end
	if  thisVersion == currentVersion then

		Isaac.DebugString("Removed last instance inutillib helper (version " .. thisVersion .. ")")
	end
end

if not InutilLib then
	InutilLib = {}
	mod = RegisterMod("InutilLib", 1)
	InutilLib.Version = currentVersion

	Isaac.DebugString("Loading inutillib helper version " .. InutilLib.Version)

	-- THE InutilLib Ext --

	--The InutilLib is an API that expands the API with wacky ways, making modding much more easier to do.--

	--Features:
	--Custom Achievement unlock animation
	--Custom Character hurt
	--Custom CHaracter instruction register

	InutilLibFiles = {}

	--ENMUS--
	InutilLib.game = Game()
	InutilLib.config = Isaac.GetItemConfig()

	InutilLib.level = InutilLib.game:GetLevel()
	InutilLib.room = InutilLib.game:GetRoom()

	InutilLib.music = MusicManager()
	InutilLib.pool = InutilLib.game:GetItemPool()

	InutilLib.itemPool = InutilLib.game:GetItemPool()
	InutilLib.seeds = InutilLib.game:GetSeeds()

	InutilLib.SFX = SFXManager()

	JSON = require("json");

	--require('luafiles.p20helper')

	InutilLib.DEG_TO_RAD = math.pi / 180;
	InutilLib.RAD_TO_DEG = 180 / math.pi;


	--Encrypted Data
	--_ILIB_EX_DATA = _ILIB_EX_DATA or {};
	--function InutilLib.GetILIBData( entity )
	--	if entity then
		
	--	local hash = GetPtrHash( entity );
	--		if _ILIB_EX_DATA[hash] == nil then
	--			_ILIB_EX_DATA[hash] = {
	--				_hash = GetPtrHash( entity )
	--			};
	--		end
	--		return _ILIB_EX_DATA[hash];
	--	end
	--end

	function InutilLib.GetILIBData( entity )
		local data = entity:GetData();
		if data.ILIB_DATA == nil then
			data.ILIB_DATA = {};
		end
		return data.ILIB_DATA;
	end


	_ENCRYPTED_DATA = _ENCRYPTED_DATA or {};
	function InutilLib.GetEncryptedData( entity , id ) --not yet tested
	local hash = GetPtrHash( entity );
		if not id then id = 0 end
		if _ENCRYPTED_DATA[id][hash] == nil then
			_ENCRYPTED_DATA[id][hash] = {
				_hash = GetPtrHash( entity )
			};
		end
		return _ENCRYPTED_DATA[id][hash];
	end

	-----------------------
	-- GENERIC LIBRARY I --
	-----------------------
	InutilLib.player = Isaac.GetPlayer(0)
	InutilLib.game = Game()
	InutilLib.roomEntities = {}
	InutilLib.roomPlayers = {}
	InutilLib.roomTears = {}
	InutilLib.roomFamiliars = {}
	InutilLib.roomBombs = {}
	InutilLib.roomPickups = {}
	InutilLib.roomSlots = {}
	InutilLib.roomLasers = {}
	InutilLib.roomKnives = {}
	InutilLib.roomProjectiles = {}
	InutilLib.roomEnemies = {}
	InutilLib.roomEffects = {}

	function InutilLib.TestPing()
		print("Testing! This is Version 2!")
	end

	--Special called vars
	do
		mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, damage, amount, damageFlag, damageSource, damageCountdownFrames) 
			local data = InutilLib.GetILIBData( damage ) 
			if damage.Type == 1 then
				InutilLib.players = {}
				for i=0, InutilLib.game:GetNumPlayers()-1 do
					table.insert(InutilLib.players, Isaac.GetPlayer(i)) --dont use, its crap
				end
			end
		end)

		mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, function()
			InutilLib.player = Isaac.GetPlayer(0)
			InutilLib.players = {}
			for i=0, InutilLib.game:GetNumPlayers()-1 do
				table.insert(InutilLib.players, Isaac.GetPlayer(i)) --dont use, its crap
			end
		end)
		mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
			InutilLib.level = InutilLib.game:GetLevel()
		end)
		mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function(_, room)
			InutilLib.room = InutilLib.game:GetRoom()
			InutilLib.currentCharge = InutilLib.player:GetActiveCharge() --purpose fo discharging in "empty" rooms

			if InutilLib.room:GetBackdropType() ~= BackdropType.DUNGEON_BEAST then 
				InutilLib.ChangeShading("_default")
			end
			Isaac.RunCallback("POST_SHADING_INIT", room)
		end)

		--[[mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, function() --jumpstart InutilLib variables (cause the normal ones don't run on startup.
			InutilLib.player = Isaac.GetPlayer(0)
			InutilLib.players = {}
			for i=0, InutilLib.game:GetNumPlayers()-1 do
				table.insert(InutilLib.players, Isaac.GetPlayer(i))
			end
			InutilLib.level = InutilLib.game:GetLevel()
			InutilLib.room = InutilLib.game:GetRoom()
		end)]]
	end

	function InutilLib:OptimizedGetEntities() -- I got this from Coming Home, pls don't kill me ;-;
		InutilLib.roomEntities = Isaac.GetRoomEntities()
		InutilLib.roomPlayers = {}
		InutilLib.roomTears = {}
		InutilLib.roomFamiliars = {}
		InutilLib.roomBombs = {}
		InutilLib.roomPickups = {}
		InutilLib.roomSlots = {}
		InutilLib.roomLasers = {}
		InutilLib.roomKnives = {}
		InutilLib.roomProjectiles = {}
		InutilLib.roomEnemies = {}
		InutilLib.roomEffects = {}
		InutilLib.roomVulnurableEnemies = {}
		for _,e in ipairs(InutilLib.roomEntities) do
			if e.Type == EntityType.ENTITY_PLAYER then table.insert(InutilLib.roomPlayers, e)
			elseif e.Type == EntityType.ENTITY_TEAR then table.insert(InutilLib.roomTears, e)
			elseif e.Type == EntityType.ENTITY_FAMILIAR then table.insert(InutilLib.roomFamiliars, e)
			elseif e.Type == EntityType.ENTITY_BOMBDROP then table.insert(InutilLib.roomBombs, e)
			elseif e.Type == EntityType.ENTITY_PICKUP then table.insert(InutilLib.roomPickups, e)
			elseif e.Type == EntityType.ENTITY_SLOT then table.insert(InutilLib.roomSlots, e)
			elseif e.Type == EntityType.ENTITY_LASER then table.insert(InutilLib.roomLasers, e)
			elseif e.Type == EntityType.ENTITY_KNIFE then table.insert(InutilLib.roomKnives, e)
			elseif e.Type == EntityType.ENTITY_PROJECTILE then table.insert(InutilLib.roomProjectiles, e)
			elseif e:IsEnemy() then 
				if e:IsVulnerableEnemy() and not e:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then 
					table.insert(InutilLib.roomVulnurableEnemies, e)
					table.insert(InutilLib.roomEnemies, e)
				else
					table.insert(InutilLib.roomEnemies, e)
				end
			elseif e.Type == EntityType.ENTITY_EFFECT then table.insert(InutilLib.roomEffects, e) 
			end
		end
	end

	--mod:AddCallback(ModCallbacks.MC_POST_RENDER, InutilLib.OptimizedGetEntities)
	--mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, InutilLib.OptimizedGetEntities)
	-------------------------
	--CUSTOM CALLBACKS--
	---------------------

	--The majority of this code comes from piber20 ported into Repentance

	ILIBCallbacks = {
		--use these callbacks with InutilLib.AddCustomCallback(modRef, callbackID, callbackFunction, extraVar)
		--using a vanilla callback id will register the callback to modRef normally but consolidated into a single callback if you use this multiple times
		
		--custom callback functions that run when a mod adds a callback through InutilLibhelper's custom callback function (crazy huh?)
		--specify a callback id to make your code trigger for only that specific callback
		--function(modRef, callbackID, callbackFunction, extraVar)
		MC_PRE_ADD_CUSTOM_CALLBACK = 300,
		MC_POST_ADD_CUSTOM_CALLBACK = 301,
		
		--ENTITY callbacks which use all callbacks for every entity type
		--specifying an entity type will redirect your addcallback to a vanilla callback id that matches the entity type if it exists
		--this will not work for entity types where there is no possible callback to match (like slots)
		MC_POST_ENTITY_INIT = 302,
		MC_POST_ENTITY_UPDATE = 303,
		MC_POST_ENTITY_RENDER = 304,
		MC_PRE_ENTITY_COLLISION = 305,
		
		--MC_POST_GAME_STARTED that only triggers once, if the player starts another run this callback will not be triggered
		MC_POST_FIRST_GAME_START = 306,
		
		--collected callbacks are triggered when this thinks a pickup has been collected or a pickup registered and working within the InutilLibhelper system is being collected
		--specifying an entity variant will make it so your function is only triggered with pickups of the variant provided
		--return true in MC_PRE_PICKUP_COLLECTED to prevent the pickup from being collected and to prevent stuff being added to the player
		--function(pickup, player)
		
		--MC_PRE_PICKUP_COLLECTED = 307,
		--MC_POST_PICKUP_COLLECTED = 308,
		
		--this is triggered when a player tear is inited, works with the player's tears and incubus tears
		--function(tear, player)
		MC_POST_PLAYER_TEAR = 309,

		MC_POST_INCUBUS_TEAR = 310,

		--this is triggered when the room is cleared
		--MC_POST_ROOM_CLEAR = 313,
		
		--this is triggered when a greed wave ends
		--MC_POST_GREED_WAVE = 314,
		
		--this is triggered on the first frame for each player after a new floor is loaded, for use to work around items like the holy mantle
		--function(player)
		--MC_POST_PLAYER_NEW_LEVEL = 315,
		
		--this is triggered when a player uses an active item, use this callback over the default one
		--function(player, itemID, itemRNG, isCarBatteryUse)
		--MC_POST_USE_ITEM = 316,
		
		--this is triggered when a player uses a pill, use this callback over the default one
		--function(player, pillColor, pillEffect, pillEffectRNG)
		--MC_POST_USE_PILL = 317,
		
		--this is triggered when a player uses a card, use this callback over the default one
		--function(player, cardID, cardRNG, isTarotClothUse), takes cardID as value
		--MC_POST_USE_CARD = 318,
		
		--this is triggered when a player obtains a collectible
		--function(player, itemID)
		--MC_POST_ITEM_COLLECTED = 319,
		
		--this is triggered when the room's ambush is finished (like in boss rush)
		--MC_POST_AMBUSH_DONE = 320,
		
		--update and render callbacks for slot entities. this works by going through all slots in a MC_POST_UPDATE callback and a MC_POST_RENDER callback.
		--specifying an entity variant will make it so your function is only triggered with slot entities of the variant provided
		--function(entity)
		MC_POST_SLOT_UPDATE = 321,
		MC_POST_SLOT_RENDER = 322,
			
		--use these callbacks with InutilLib.AddCustomCallback(modRef, callbackID, callbackFunction, extraVar)
		--using a vanilla callback id will register the callback to modRef normally but consolidated into a single callback if you use this multiple times
			
		--custom callback functions that run when a mod adds a callback through InutilLibhelper's custom callback function (crazy huh?)
		--specify a callback id to make your code trigger for only that specific callback
		--function(modRef, callbackID, callbackFunction, extraVar)
		MC_POST_FIRE_LASER = 400,
		MC_POST_FIRE_BOMB = 401
	}


	ILIBCallbackData = ILIBCallbackData or {}

	--Ading custom callbacks
		function InutilLib.AddCustomCallback(modRef, callbackID, callbackFunction, extraVar)
			if not modRef then
				error("AddCustomCallback Error: No valid mod reference provided")
				return
			end
			if not callbackID then
				error("AddCustomCallback Error: No valid callback ID provided")
				return
			end
			if not callbackFunction then
				error("AddCustomCallback Error: No valid callback function provided")
				return
			end
			ILIBCallbackData = ILIBCallbackData or {}
			
			--MC_PRE_ADD_CUSTOM_CALLBACK
			if ILIBCallbackData[ILIBCallbacks.MC_PRE_ADD_CUSTOM_CALLBACK] then
				for _, callbackData in ipairs(ILIBCallbackData[ILIBCallbacks.MC_PRE_ADD_CUSTOM_CALLBACK]) do
					if not callbackData.extraVariable or callbackData.extraVariable == callbackID then
						local returned = callbackData.functionToCall(modRef, callbackID, callbackFunction, extraVar)
						if returned == false then
							return
						end
					end
				end
			end
			
			ILIBCallbackData[callbackID] = ILIBCallbackData[callbackID] or {}
			ILIBCallbackData[callbackID][#ILIBCallbackData[callbackID]+1] = {modReference = modRef, functionToCall = callbackFunction, extraVariable = extraVar}
			
			--MC_POST_ADD_CUSTOM_CALLBACK
			if ILIBCallbackData[ILIBCallbacks.MC_POST_ADD_CUSTOM_CALLBACK] then
				for _, callbackData in ipairs(ILIBCallbackData[ILIBCallbacks.MC_POST_ADD_CUSTOM_CALLBACK]) do
					if not callbackData.extraVariable or callbackData.extraVariable == callbackID then
						callbackData.functionToCall(modRef, callbackID, callbackFunction, extraVar)
					end
				end
			end
		end
		
		--slot callbacks
		InutilLib.AddCustomCallback(mod, ModCallbacks.MC_POST_UPDATE, function()
			if ILIBCallbackData[ILIBCallbacks.MC_POST_SLOT_UPDATE] then
				for _, slot in ipairs(Isaac.FindByType(EntityType.ENTITY_SLOT, -1, -1, false, false)) do
					for _, callbackData in ipairs(ILIBCallbackData[ILIBCallbacks.MC_POST_SLOT_UPDATE]) do
						if not callbackData.extraVariable or callbackData.extraVariable == slot.Variant then
							callbackData.functionToCall(callbackData.modReference, slot)
						end
					end
				end
			end
		end)
		
		InutilLib.AddCustomCallback(mod, ModCallbacks.MC_POST_RENDER, function()
			if ILIBCallbackData[ILIBCallbacks.MC_POST_SLOT_RENDER] then
				for _, slot in ipairs(Isaac.FindByType(EntityType.ENTITY_SLOT, -1, -1, false, false)) do
					for _, callbackData in ipairs(ILIBCallbackData[ILIBCallbacks.MC_POST_SLOT_RENDER]) do
						if not callbackData.extraVariable or callbackData.extraVariable == slot.Variant then
							callbackData.functionToCall(callbackData.modReference, slot)
						end
					end
				end
			end
		end)

	--add special handling for vanilla callbacks - merges all the functions into a singular callback
		local callbacksCompareExtraVar = {
			[ModCallbacks.MC_USE_ITEM] = true,
			[ModCallbacks.MC_USE_CARD] = true,
			[ModCallbacks.MC_USE_PILL] = true,
			[ModCallbacks.MC_PRE_USE_ITEM] = true
		}
		local callbacksCompareTypeExtraVar = {
			[ModCallbacks.MC_NPC_UPDATE] = true,
			[ModCallbacks.MC_ENTITY_TAKE_DMG] = true,
			[ModCallbacks.MC_POST_NPC_INIT] = true,
			[ModCallbacks.MC_POST_NPC_RENDER] = true,
			[ModCallbacks.MC_POST_NPC_DEATH] = true,
			[ModCallbacks.MC_PRE_NPC_COLLISION] = true,
			[ModCallbacks.MC_POST_ENTITY_REMOVE] = true,
			[ModCallbacks.MC_POST_ENTITY_KILL] = true,
			[ModCallbacks.MC_PRE_NPC_UPDATE] = true
		}
		local callbacksCompareVariantExtraVar = {
			[ModCallbacks.MC_FAMILIAR_UPDATE] = true,
			[ModCallbacks.MC_FAMILIAR_INIT] = true,
			[ModCallbacks.MC_POST_FAMILIAR_RENDER] = true,
			[ModCallbacks.MC_PRE_FAMILIAR_COLLISION] = true,
			[ModCallbacks.MC_POST_PICKUP_INIT] = true,
			[ModCallbacks.MC_POST_PICKUP_UPDATE] = true,
			[ModCallbacks.MC_POST_PICKUP_RENDER] = true,
			[ModCallbacks.MC_PRE_PICKUP_COLLISION] = true,
			[ModCallbacks.MC_POST_TEAR_INIT] = true,
			[ModCallbacks.MC_POST_TEAR_UPDATE] = true,
			[ModCallbacks.MC_POST_TEAR_RENDER] = true,
			[ModCallbacks.MC_PRE_TEAR_COLLISION] = true,
			[ModCallbacks.MC_POST_PROJECTILE_INIT] = true,
			[ModCallbacks.MC_POST_PROJECTILE_UPDATE] = true,
			[ModCallbacks.MC_POST_PROJECTILE_RENDER] = true,
			[ModCallbacks.MC_PRE_PROJECTILE_COLLISION] = true,
			[ModCallbacks.MC_POST_LASER_INIT] = true,
			[ModCallbacks.MC_POST_LASER_UPDATE] = true,
			[ModCallbacks.MC_POST_LASER_RENDER] = true,
			[ModCallbacks.MC_POST_KNIFE_INIT] = true,
			[ModCallbacks.MC_POST_KNIFE_UPDATE] = true,
			[ModCallbacks.MC_POST_KNIFE_RENDER] = true,
			[ModCallbacks.MC_PRE_KNIFE_COLLISION] = true,
			[ModCallbacks.MC_POST_EFFECT_INIT] = true,
			[ModCallbacks.MC_POST_EFFECT_UPDATE] = true,
			[ModCallbacks.MC_POST_EFFECT_RENDER] = true,
			[ModCallbacks.MC_POST_BOMB_INIT] = true,
			[ModCallbacks.MC_POST_BOMB_UPDATE] = true,
			[ModCallbacks.MC_POST_BOMB_RENDER] = true,
			[ModCallbacks.MC_PRE_BOMB_COLLISION] = true
		}
		InutilLibCallbackModsSetUp = InutilLibCallbackModsSetUp or {}
		InutilLib.AddCustomCallback(mod, ILIBCallbacks.MC_POST_ADD_CUSTOM_CALLBACK, function(modRef, callbackID, callbackFunction, extraVar)
			if not modRef.InutilLibModID then
				modRef.InutilLibModID = #InutilLibCallbackModsSetUp+1
				InutilLibCallbackModsSetUp[#InutilLibCallbackModsSetUp+1] = modRef
			end
			modRef.InutilLibMergedCallbacksAdded = modRef.InutilLibMergedCallbacksAdded or {}
			if callbackID <= ModCallbacks.MC_PRE_ROOM_ENTITY_SPAWN and not modRef.InutilLibMergedCallbacksAdded[callbackID] then
				modRef:AddCallback(callbackID, function(...)
					local args = {...}
					--args[1] is the mod reference
					--args[2] would be the entity or item id
					if ILIBCallbackData and ILIBCallbackData[callbackID] then
						for _, callbackData in ipairs(ILIBCallbackData[callbackID]) do
							if args[1].InutilLibModID == callbackData.modReference.InutilLibModID then
								if not callbackData.extraVariable
								or (callbackData.extraVariable
									and ((callbacksCompareExtraVar[callbackID] and args[2] == callbackData.extraVariable)
									or (callbacksCompareTypeExtraVar[callbackID] and args[2].Type == callbackData.extraVariable)
									or (callbacksCompareVariantExtraVar[callbackID] and args[2].Variant == callbackData.extraVariable))
								) then
									local toReturn = callbackData.functionToCall(...)
									if toReturn ~= nil then
										return toReturn
									end
								end
							end
						end
					end
				end)
				modRef.InutilLibMergedCallbacksAdded[callbackID] = true
			end
		end)

		local fakeCachedDataToReturn = {
			Game = Game,
			Level = function() return Game():GetLevel() end,
			Room = function() return Game():GetRoom() end,
			ItemPool = function() return Game():GetItemPool() end,
			Seeds = function() return Game():GetSeeds() end,
			ItemConfig = Isaac.GetItemConfig,
			Music = MusicManager,
			SFX = SFXManager
		}
		setmetatable(InutilLib, {

			__index = function(this, key)

				if fakeCachedDataToReturn[key] then
				
					return fakeCachedDataToReturn[key]()
					
				end

			end

		})
		
		function InutilLib.ReCacheData()
			-- InutilLib.Game = Game()
			-- InutilLib.Level = InutilLib.Game:GetLevel()
			-- InutilLib.Room = InutilLib.Game:GetRoom()
			-- InutilLib.ItemPool = InutilLib.Game:GetItemPool()
			-- InutilLib.Seeds = InutilLib.Game:GetSeeds()
			-- InutilLib.ItemConfig = Isaac.GetItemConfig()
			-- InutilLib.Music = MusicManager()
			-- InutilLib.SFX = SFXManager()
		end
		-- InutilLib.ReCacheData()
		-- InutilLib.AddCustomCallback(mod, ModCallbacks.MC_POST_RENDER, function()
			-- InutilLib.ReCacheData()
		-- end)
		-- InutilLib.AddCustomCallback(mod, ModCallbacks.MC_POST_NEW_ROOM, function()
			-- InutilLib.ReCacheData()
		-- end)
		-- InutilLib.AddCustomCallback(mod, ModCallbacks.MC_POST_NEW_LEVEL, function()
			-- InutilLib.ReCacheData()
		-- end)
		-- InutilLib.AddCustomCallback(mod, ModCallbacks.MC_POST_PLAYER_INIT, function()
			-- InutilLib.ReCacheData()
		-- end)

		--ENTITY callbacks setup
		local entityCallbacksToSetUp = {
			{
				ID = ILIBCallbacks.MC_POST_ENTITY_INIT,
				Callbacks = {
					ModCallbacks.MC_FAMILIAR_INIT,
					--ModCallbacks.MC_POST_PLAYER_INIT,
					ModCallbacks.MC_POST_NPC_INIT,
					ModCallbacks.MC_POST_PICKUP_INIT,
					ModCallbacks.MC_POST_TEAR_INIT,
					ModCallbacks.MC_POST_PROJECTILE_INIT,
					ModCallbacks.MC_POST_LASER_INIT,
					ModCallbacks.MC_POST_KNIFE_INIT,
					ModCallbacks.MC_POST_EFFECT_INIT,
					ModCallbacks.MC_POST_BOMB_INIT
				},
				EntityTypeCallbacks = {
					[EntityType.ENTITY_FAMILIAR] = ModCallbacks.MC_FAMILIAR_INIT,
					--[EntityType.ENTITY_PLAYER] = ModCallbacks.MC_POST_PLAYER_INIT,
					[EntityType.ENTITY_PICKUP] = ModCallbacks.MC_POST_PICKUP_INIT,
					[EntityType.ENTITY_TEAR] = ModCallbacks.MC_POST_TEAR_INIT,
					[EntityType.ENTITY_PROJECTILE] = ModCallbacks.MC_POST_PROJECTILE_INIT,
					[EntityType.ENTITY_LASER] = ModCallbacks.MC_POST_LASER_INIT,
					[EntityType.ENTITY_KNIFE] = ModCallbacks.MC_POST_KNIFE_INIT,
					[EntityType.ENTITY_EFFECT] = ModCallbacks.MC_POST_EFFECT_INIT,
					[EntityType.ENTITY_BOMBDROP] = ModCallbacks.MC_POST_BOMB_INIT
				},
				NPCCallback = ModCallbacks.MC_POST_NPC_INIT
			},
			{
				ID = ILIBCallbacks.MC_POST_ENTITY_UPDATE,
				Callbacks = {
					ModCallbacks.MC_NPC_UPDATE,
					ModCallbacks.MC_FAMILIAR_UPDATE,
					ModCallbacks.MC_POST_PLAYER_UPDATE,
					ModCallbacks.MC_POST_PICKUP_UPDATE,
					ModCallbacks.MC_POST_TEAR_UPDATE,
					ModCallbacks.MC_POST_PROJECTILE_UPDATE,
					ModCallbacks.MC_POST_LASER_UPDATE,
					ModCallbacks.MC_POST_KNIFE_UPDATE,
					ModCallbacks.MC_POST_EFFECT_UPDATE,
					ModCallbacks.MC_POST_BOMB_UPDATE,
					ILIBCallbacks.MC_POST_SLOT_UPDATE
				},
				EntityTypeCallbacks = {
					[EntityType.ENTITY_FAMILIAR] = ModCallbacks.MC_FAMILIAR_UPDATE,
					[EntityType.ENTITY_PLAYER] = ModCallbacks.MC_POST_PLAYER_UPDATE,
					[EntityType.ENTITY_PICKUP] = ModCallbacks.MC_POST_PICKUP_UPDATE,
					[EntityType.ENTITY_TEAR] = ModCallbacks.MC_POST_TEAR_UPDATE,
					[EntityType.ENTITY_PROJECTILE] = ModCallbacks.MC_POST_PROJECTILE_UPDATE,
					[EntityType.ENTITY_LASER] = ModCallbacks.MC_POST_LASER_UPDATE,
					[EntityType.ENTITY_KNIFE] = ModCallbacks.MC_POST_KNIFE_UPDATE,
					[EntityType.ENTITY_EFFECT] = ModCallbacks.MC_POST_EFFECT_UPDATE,
					[EntityType.ENTITY_BOMBDROP] = ModCallbacks.MC_POST_BOMB_UPDATE,
					[EntityType.ENTITY_SLOT] = ILIBCallbacks.MC_POST_SLOT_UPDATE
				},
				NPCCallback = ModCallbacks.MC_NPC_UPDATE
			},
			{
				ID = ILIBCallbacks.MC_POST_ENTITY_RENDER,
				Callbacks = {
					ModCallbacks.MC_POST_FAMILIAR_RENDER,
					ModCallbacks.MC_POST_NPC_RENDER,
					ModCallbacks.MC_POST_PLAYER_RENDER,
					ModCallbacks.MC_POST_PICKUP_RENDER,
					ModCallbacks.MC_POST_TEAR_RENDER,
					ModCallbacks.MC_POST_PROJECTILE_RENDER,
					ModCallbacks.MC_POST_LASER_RENDER,
					ModCallbacks.MC_POST_KNIFE_RENDER,
					ModCallbacks.MC_POST_EFFECT_RENDER,
					ModCallbacks.MC_POST_BOMB_RENDER,
					ILIBCallbacks.MC_POST_SLOT_RENDER
				},
				EntityTypeCallbacks = {
					[EntityType.ENTITY_FAMILIAR] = ModCallbacks.MC_POST_FAMILIAR_RENDER,
					[EntityType.ENTITY_PLAYER] = ModCallbacks.MC_POST_PLAYER_RENDER,
					[EntityType.ENTITY_PICKUP] = ModCallbacks.MC_POST_PICKUP_RENDER,
					[EntityType.ENTITY_TEAR] = ModCallbacks.MC_POST_TEAR_RENDER,
					[EntityType.ENTITY_PROJECTILE] = ModCallbacks.MC_POST_PROJECTILE_RENDER,
					[EntityType.ENTITY_LASER] = ModCallbacks.MC_POST_LASER_RENDER,
					[EntityType.ENTITY_KNIFE] = ModCallbacks.MC_POST_KNIFE_RENDER,
					[EntityType.ENTITY_EFFECT] = ModCallbacks.MC_POST_EFFECT_RENDER,
					[EntityType.ENTITY_BOMBDROP] = ModCallbacks.MC_POST_BOMB_RENDER,
					[EntityType.ENTITY_SLOT] = ILIBCallbacks.MC_POST_SLOT_RENDER
				},
				NPCCallback = ModCallbacks.MC_POST_NPC_RENDER
			},
			{
				ID = ILIBCallbacks.MC_PRE_ENTITY_COLLISION,
				Callbacks = {
					ModCallbacks.MC_PRE_FAMILIAR_COLLISION,
					ModCallbacks.MC_PRE_NPC_COLLISION,
					ModCallbacks.MC_PRE_PLAYER_COLLISION,
					ModCallbacks.MC_PRE_PICKUP_COLLISION,
					ModCallbacks.MC_PRE_TEAR_COLLISION,
					ModCallbacks.MC_PRE_PROJECTILE_COLLISION,
					ModCallbacks.MC_PRE_KNIFE_COLLISION,
					ModCallbacks.MC_PRE_BOMB_COLLISION
				},
				EntityTypeCallbacks = {
					[EntityType.ENTITY_FAMILIAR] = ModCallbacks.MC_PRE_FAMILIAR_COLLISION,
					[EntityType.ENTITY_PLAYER] = ModCallbacks.MC_PRE_PLAYER_COLLISION,
					[EntityType.ENTITY_PICKUP] = ModCallbacks.MC_PRE_PICKUP_COLLISION,
					[EntityType.ENTITY_TEAR] = ModCallbacks.MC_PRE_TEAR_COLLISION,
					[EntityType.ENTITY_PROJECTILE] = ModCallbacks.MC_PRE_PROJECTILE_COLLISION,
					[EntityType.ENTITY_KNIFE] = ModCallbacks.MC_PRE_KNIFE_COLLISION,
					[EntityType.ENTITY_BOMBDROP] = ModCallbacks.MC_PRE_BOMB_COLLISION
				},
				NPCCallback = ModCallbacks.MC_PRE_NPC_COLLISION
			}
		}
		for _, entityCallbackDataToSetUp in ipairs(entityCallbacksToSetUp) do
			InutilLib.AddCustomCallback(mod, ILIBCallbacks.MC_POST_ADD_CUSTOM_CALLBACK, function(modRef, callbackID, callbackFunction, extraVar)
				if extraVar then
					local singleCallback = entityCallbackDataToSetUp.EntityTypeCallbacks[extraVar] or entityCallbackDataToSetUp.NPCCallback
					InutilLib.AddCustomCallback(modRef, singleCallback, callbackFunction)
				else
					for _, entityCallbackID in ipairs(entityCallbackDataToSetUp.Callbacks) do
						InutilLib.AddCustomCallback(modRef, entityCallbackID, callbackFunction)
					end
				end
			end, entityCallbackDataToSetUp.ID)
		end
		
		--MC_POST_FIRST_GAME_START
		--[[InutilLib.AddCustomCallback(mod, ILIBCallbacks.MC_POST_ADD_CUSTOM_CALLBACK, function(modRef, callbackID, callbackFunction, extraVar)
			if not modRef.InutilLibAddedFirstGameStartCallback then
				InutilLib.AddCustomCallback(modRef, ModCallbacks.MC_POST_GAME_STARTED, function(modRef, fromSave)
					if not modRef.InutilLibFirstGameStartTracker then
						modRef.InutilLibFirstGameStartTracker = true
						if ILIBCallbackData[ILIBCallbacks.MC_POST_FIRST_GAME_START] then
							for _, callbackData in ipairs(ILIBCallbackData[ILIBCallbacks.MC_POST_FIRST_GAME_START]) do
								if modRef.InutilLibModID == callbackData.modReference.InutilLibModID then
									callbackData.functionToCall(modRef, fromSave)
								end
							end
						end
					end
				end, extraVar)
			end
			modRef.InutilLibAddedFirstGameStartCallback = true
		end, ILIBCallbacks.MC_POST_FIRST_GAME_START)]]
	
	mod:AddCallback(ModCallbacks.MC_POST_LASER_RENDER, function(_, lz)
		local data = InutilLib.GetILIBData(lz)
		if not data.LaserInit then
			local parent = lz.Parent
			if parent and parent.Type == EntityType.ENTITY_PLAYER then
				data.LaserInit = true
				Isaac.RunCallback("MC_POST_FIRE_LASER", lz)
			end
		end
	end)

	--[[InutilLib.AddCustomCallback(mod, ModCallbacks.MC_POST_LASER_RENDER, function(_, lz)
		local data = InutilLib.GetILIBData(lz)
		if not data.LaserInit then
			local parent = lz.Parent
			if parent and parent.Type == EntityType.ENTITY_PLAYER then
				data.LaserInit = true
				if ILIBCallbackData[ILIBCallbacks.MC_POST_FIRE_LASER] then
					for _, callbackData in ipairs(ILIBCallbackData[ILIBCallbacks.MC_POST_FIRE_LASER]) do
						if not callbackData.extraVariable or callbackData.extraVariable == lz.variant then
							callbackData.functionToCall(callbackData.modReference, lz, player)
						end
					end
				end
			end
		end
	end)]]
	mod:AddCallback(ModCallbacks.MC_POST_BOMB_RENDER, function(_, bb)
		local data = InutilLib.GetILIBData(bb)
		if not data.BombInit then
			local parent = bb.Parent
			if parent and parent.Type == EntityType.ENTITY_PLAYER then
				data.BombInit = true
				Isaac.RunCallback("MC_POST_FIRE_BOMB", bb)
			end
		end
	end)

	--[[InutilLib.AddCustomCallback(mod, ModCallbacks.MC_POST_BOMB_RENDER, function(_, bb)
		local data = InutilLib.GetILIBData(bb)
		if not data.BombInit then
			local parent = bb.Parent
			if parent and parent.Type == EntityType.ENTITY_PLAYER then
				data.BombInit = true
				if ILIBCallbackData[ILIBCallbacks.MC_POST_FIRE_BOMB] then
					for _, callbackData in ipairs(ILIBCallbackData[ILIBCallbacks.MC_POST_FIRE_BOMB]) do
						if not callbackData.extraVariable or callbackData.extraVariable == bb.variant then
							callbackData.functionToCall(callbackData.modReference, bb, player)
						end
					end
				end
			end
		end
	end)]]


	-----LIBRARY??------------

	function InutilLib.ProAPILerp(first,second,percent) --stolen from FF's library
		return (first + (second - first)*percent)
	end

	--function to tell where to vectors/entities are located then product changed into an angle
	function InutilLib.ObjToTargetAngle(obj, targetPos, angleResult)
		if angleResult == true then
			return (targetPos.Position - obj.Position):GetAngleDegrees()
		else
			return (targetPos.Position - obj.Position)
		end
	end

	-- Math Functions --

	--Non-mod related
	function Round(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
	end

	function TableLength(tbl) 
		local i = 0 
		for _ in pairs(tbl) do 
			i = i+1 
		end 
		return i 
	end

	--doesn't work with negative numbers
	function Oscilate(Num, Range, Object, Invert) --eg. 0, 15, data, false
		if Object.State then
			if Object.Progress < 2 then
				if Object.State == "Increment" then
					--print(tostring(Object.State))
					local NewVal = math.min(Range, Num + 1)
					if NewVal >= Range then 
						Object.State = "Reverse" 
						Object.Progress = Object.Progress + 1
					end
					return NewVal
				elseif Object.State == "Reverse" then
					--print(tostring(Object.State))
					local NewVal = math.max(0, Num - 1)
					if NewVal <= 0 then 
						Object.State = "Increment" 
						Object.Progress = Object.Progress + 1
					end
					return NewVal
				end
			end
		else
			local returnV
			if Invert then
				Object.State = "Reverse"
				returnV = math.max(Num, Range)
			else
				Object.State = "Increment"
				returnV = math.min(Range, Num + 1)
			end
			Object.Progress = 0
			--print(tostring(Object.State))
			return returnV
		end
	end


	function InutilLib.Lerp(vec1, vec2, percent)
		return vec1 * (1 - percent) + vec2 * percent
	end

	function InutilLib.AngleDifference( targetAngle, startingAngle )
		return math.atan( math.sin( targetAngle - startingAngle ), math.cos( targetAngle - startingAngle ) );
	end

	function InutilLib.RoundToNearestMultiple(number, multiple)
		return math.floor(((number + multiple/2) / multiple)) * multiple;
	end


	function InutilLib.VecToAppoxDir(vec)
		local result
		local angle = vec:GetAngleDegrees()
		if angle >= 45 and angle <= 135 then --front
			result = 3
		elseif angle <= -45 and angle >= -135 then --back
			result = 1
		elseif (angle >= 135 and angle <= 180) or (angle <= -135 and angle >= -180) then
			result = 0
		elseif (angle >= 0 and angle <= 45) or (angle <= 0 and angle >= -45) then
			result = 2
		end
		return result
	end

	function InutilLib.DirToVec(dir)
		local result
		if dir == 0 then
			result = Vector(-10,0)
		elseif dir == 1 then
			result = Vector(0,-10)
		elseif dir == 2 then
			result = Vector(10,0)
		elseif dir == 3 then
			result = Vector(0,10)
		else
			result = Vector(0,0)
		end
		return result
	end

	--from : http://lua-users.org/wiki/CopyTable
	function InutilLib.Deepcopy(orig)
		local orig_type = type(orig)
		local copy
		if orig_type == 'table' then
			copy = {}
			for orig_key, orig_value in next, orig, nil do
				copy[InutilLib.Deepcopy(orig_key)] = InutilLib.Deepcopy(orig_value)
			end
			setmetatable(copy, InutilLib.Deepcopy(getmetatable(orig)))
		else -- number, string, boolean, etc
			copy = orig
		end
		return copy
	end

	--Save/Load Functions and Codes --
	local JSON = require("json")
	function InutilLib.RevalidateSaveData(force)
		if Isaac.HasModData(InutilLib) then
			local raw = InutilLib:LoadData()
			local data = JSON.decode(Isaac.LoadModData(raw))
			local saveData = InutilLib.SaveData

			if data == nil or force then
				saveData.CollectibleList = {};
				saveData.thisExist = true

				Isaac.SaveModData(InutilLib, JSON.encode( saveData ) )
			end
		end
	end
	--Knockback Code--
	--knockback function where target gets thrown off the origin vector point
	--[[ origin - the main vector point where the target gets knocked away from
		target - the knocked away one
		velocity - how strong the knockback is
	]]
	function InutilLib.DoKnockbackTypeI(origin, target, velocity, ignoreMass)
		local knockbackline = (target.Position - origin.Position)
		if not ignoreMass then
			target.Velocity = (target.Velocity + knockbackline) * (velocity * (target.Size/10))
		else
			target.Velocity = (target.Velocity + knockbackline) * velocity
		end
	end

	--slow down--
	function InutilLib.EntSlowDown(ent, margin)
		ent.Velocity = ent.Velocity * margin
	end

	function InutilLib.GetClosestGenericEnemy(obj, dist, blacklist, checkLine, mode, GridTreshHold, ignoreWalls, ignoreCrushables, pathfindable)
		local closestDist = 177013 --saved Dist to check who is the closest enemy
		local returnV
		for i, e in pairs(Isaac.GetRoomEntities()) do
			if GetPtrHash(obj) ~= GetPtrHash(e) and e:IsEnemy() and e:IsVulnerableEnemy() and not e:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
				if blacklist then
					if e.Type ~= blacklist then
						local minDist = dist or 100
						if (obj.Position - e.Position):Length() < minDist + e.Size then
							if (obj.Position - e.Position):Length() < closestDist + e.Size then
								closestDist = (obj.Position - e.Position):Length()
								returnV = e
							end
						end
					end
				else
					local minDist = dist or 100
					if (obj.Position - e.Position):Length() < minDist + e.Size then
						if (obj.Position - e.Position):Length() < closestDist + e.Size then
							local path
							local pass = true
							if pathfindable then
								path = InutilLib.GenerateAStarPath(obj.Position, e.Position)
							end
							if not path and pathfindable then --literally only declines pass if its pathfinding to begin with
								pass = false
							end
							if pass then --if path is possible or path is not even required
								if checkLine then
									if InutilLib.room:CheckLine(obj.Position, e.Position, mode, GridTreshHold, ignoreWalls, ignoreCrushables) then
										closestDist = (obj.Position - e.Position):Length()
										returnV = e
									end
								else
									closestDist = (obj.Position - e.Position):Length()
									returnV = e
								end
							end
						end
					end
				end
			end
		end
		return returnV
	end

	function InutilLib.GetClosestPlayer(obj, dist)
		local closestDist = 177013 --saved Dist to check who is the closest enemy
		local returnV
		for p = 0, InutilLib.game:GetNumPlayers() - 1 do
			local e = Isaac.GetPlayer(p)
			if not e:IsDead() then
				local minDist = dist or 100
				if (obj.Position - e.Position):Length() < minDist then
					if (obj.Position - e.Position):Length() < closestDist then
						closestDist = (obj.Position - e.Position):Length()
						returnV = e
					end
				end
			end
		end
		return returnV
	end

	function InutilLib.GetClosestProjectile(obj, dist)
		local closestDist = 177013 --saved Dist to check who is the closest enemy
		local returnV
		for _, v in ipairs(Isaac.FindByType(EntityType.ENTITY_PROJECTILE, -1, -1, false, true)) do
			local e =v
			--if not e:IsDead() then
				local minDist = dist or 100
				if (obj.Position - e.Position):Length() < minDist then
					if (obj.Position - e.Position):Length() < closestDist then
						closestDist = (obj.Position - e.Position):Length()
						returnV = e
					end
				end
			--end
		end
		return returnV
	end

	function InutilLib.GetStrongestEnemy(obj, dist, isEnemy)
		local highestHP = 0
		local returnV
		for i, e in pairs(Isaac.GetRoomEntities()) do
			if e:IsActiveEnemy() then
				local minDist = dist or 100
				if (obj.Position - e.Position):Length() <= minDist and e.HitPoints > highestHP and ((isEnemy and GetPtrHash(e) ~= GetPtrHash(obj)) or ( not isEnemy)) then
					highestHP = e.HitPoints
					returnV = e
				end
			end
		end
		return returnV
	end

	--helps detect what wall is closest to the enemy
	function InutilLib.ClosestWall(npc)
			local room = InutilLib.room
			local leftWall = math.abs(room:GetTopLeftPos().X-npc.Position.X)
			local rightWall = math.abs(room:GetBottomRightPos().X-npc.Position.X)
			local topWall = math.abs(room:GetTopLeftPos().Y-npc.Position.Y)
		local bottomWall = math.abs(room:GetBottomRightPos().Y-npc.Position.Y)
		if rightWall <= leftWall and rightWall <= topWall and rightWall <= bottomWall then
			return Direction.RIGHT
		elseif leftWall <= rightWall and leftWall <= topWall and leftWall <= bottomWall then
			return Direction.LEFT
		elseif topWall <= leftWall and topWall <= rightWall and topWall <= bottomWall then
			return Direction.UP
		elseif bottomWall <= leftWall and bottomWall <= rightWall and bottomWall <= topWall then
			return Direction.DOWN
		end
	end

	function InutilLib.ClosestHorizontalWall(npc)
			local room = InutilLib.room
			local leftWall = math.abs(room:GetTopLeftPos().X-npc.Position.X)
			local rightWall = math.abs(room:GetBottomRightPos().X-npc.Position.X)
			--local topWall = math.abs(room:GetTopLeftPos().Y-npc.Position.Y)
		--local bottomWall = math.abs(room:GetBottomRightPos().Y-npc.Position.Y)
		if rightWall <= leftWall then --and rightWall <= topWall and rightWall <= bottomWall then
			return Direction.RIGHT
		elseif leftWall <= rightWall then--and leftWall <= topWall and leftWall <= bottomWall then
			return Direction.LEFT
		--elseif topWall <= leftWall and topWall <= rightWall and topWall <= bottomWall then
		--	return Direction.UP
	-- elseif bottomWall <= leftWall and bottomWall <= rightWall and bottomWall <= topWall then
		--	return Direction.DOWN
		end
	end

	--i saw it at modding server
	function InutilLib.GetExpectedCenterPos(room)
		return InutilLib.room:IsLShapedRoom() and Vector(580, 420) or InutilLib.room:GetCenterPos()
	end

	-----------------------------------------------
	--assigning each player object to its "owner"--
	-----------------------------------------------

	--most of the code is from Rev but i coded it in my needs--

	mod:AddCallback(ModCallbacks.MC_POST_BOMB_INIT, function(_, bomb)
		if bomb.SpawnerType == 1 then
			local data = InutilLib.GetILIBData(bomb)
			if not bomb.Parent then --applies to normally dropped bomb, not dr fetus for instance
				data.player = InutilLib.GetClosestPlayer(bomb, 100)
			else
				data.player = bomb.Parent:ToPlayer()
			end
		end
	end)


	--this doesnt work
	mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, function(_, eff)
		local data = InutilLib.GetILIBData(eff)
		if eff.Variant == EffectVariant.TARGET then --epic fetus target
			data.player = InutilLib.GetClosestPlayer(eff, 100)
		elseif eff.Variant == EffectVariant.ROCKET then --epic fetus missile
			local target
			local closestDist = 177013
			for i, t in pairs(Isaac.FindByType(1000, 30, -1, false, true), eff) do
				local data = InutilLib.GetILIBData(eff);
				local minDist = dist or 100
				if (t.Position - eff.Position):Length() < minDist then
					if (t.Position - eff.Position):Length() < closestDist then
						closestDist = (t.Position - eff.Position):Length()
						target = eff
					end
				end
			end
			if target then
				data.player = InutilLib.GetClosestPlayer(eff, 100)
			end
		end
	end)

	function InutilLib.GetPlayerObjectOwner(obj)
		local data = InutilLib.GetILIBData(obj)
		if data.player then
			return data.player
		end
	end

	function InutilLib.GetPlayerLudo(player)
		local data = InutilLib.GetILIBData(player)
		if data.Ludo then
			if not data.Ludo:IsDead() and data.Ludo:Exists() then
				--print(InutilLib.GetILIBData(player).Ludo)
				return data.Ludo
			end
		end
		data.Ludo = nil --incase ludotear just changes and doesnt get the memo
		return nil
	end

	--FAMILIAR RELATED STUFF--
	function InutilLib.AddHomingIfBabyBender(player, thing)
		if player:HasTrinket(TrinketType.TRINKET_BABY_BENDER) then
			thing:AddTearFlags(TearFlags.TEAR_HOMING)
		end
	end


	--LUDO STUFF--

	mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, function(_, tr)
		if tr.FrameCount == 1 then
			local data = InutilLib.GetILIBData(tr)
			
			if tr.TearFlags & TearFlags.TEAR_LUDOVICO == TearFlags.TEAR_LUDOVICO then
				local player = tr.SpawnerEntity --InutilLib.GetClosestPlayer(tr, 100) --screw this, kil made the api work :D
				--just in case something stupid happens
				if player then
					if InutilLib.GetILIBData(player).Ludo then
						if InutilLib.GetILIBData(player).Ludo:IsDead() and not InutilLib.GetILIBData(player).Ludo:Exists() then
							InutilLib.GetILIBData(player).Ludo = nil
						end
					end
					if not InutilLib.GetILIBData(player).Ludo then
						data.player = player
						InutilLib.GetILIBData(data.player).Ludo = tr
					end
				end
			end
		end
	end)

	mod:AddCallback(ModCallbacks.MC_POST_LASER_UPDATE, function(_, tr)
		if tr.FrameCount == 1 then --some reason it starts at 1
			local data = InutilLib.GetILIBData(tr)
			--print(tr.TearFlags)
			--print(tr:HasTearFlags(TearFlags.TEAR_LUDOVICO))
			if tr.TearFlags & TearFlags.TEAR_LUDOVICO == TearFlags.TEAR_LUDOVICO or tr.SubType == LaserSubType.LASER_SUBTYPE_RING_LUDOVICO then
				print("trying this out")
				local player = tr.SpawnerEntity
				--just in case something stupid happens
				if player then
					if InutilLib.GetILIBData(player).Ludo then
						if InutilLib.GetILIBData(player).Ludo:IsDead() and not InutilLib.GetILIBData(player).Ludo:Exists() then
							InutilLib.GetILIBData(player).Ludo = nil
						end
					end
					if not InutilLib.GetILIBData(player).Ludo then
						data.player = player
						InutilLib.GetILIBData(data.player).Ludo = tr
					end
				end
			end
			--print(tr.Variant, "   ", tr.SubType)
		end
		local color = tr:GetColor()
		--print(color.R, "  ", color.G, "  ", color.B, "  ", color.A, "  ", color.GO, "  ", color.BO, "  ", color.RO)
	end)

	mod:AddCallback(ModCallbacks.MC_POST_KNIFE_UPDATE, function(_, kn)
		--kn:SetColor(Color(0,0,0,0.7,170,170,210), 999, 999)
		if kn.Parent then
			if (kn.Parent.Type == 3 and kn.Parent.SubType == 177) then
				--kn:SetColor(Color(0,0,0,0,170,170,210), 999, 999)
				if not InutilLib.GetILIBData(kn).CustomKnife == nil then
					kn:SetColor(Color(0,0,0,0,170,170,210), 999, 999)
					--kn:Remove()
				end
			else
				if kn.Parent.Type == 1 then
					--kn:SetColor(Color(0,0,0,0.9,255,0,0), 999, 999)
				elseif kn.Parent.Type == 8 then
					--print(InutilLib.GetILIBData(kn).CustomKnife)
					--kn:SetColor(Color(0,0,0,0.9,255,255,0), 999, 999)
				end
				--print(kn.Parent.Type)
			end
		else
			kn:Remove()
		end
		local data = InutilLib.GetILIBData(kn)
		if kn.TearFlags & TearFlags.TEAR_LUDOVICO == TearFlags.TEAR_LUDOVICO then --knife ludo
			local player = kn.SpawnerEntity 
			--just in case something stupid happens
			if player then

				if InutilLib.GetILIBData(player).Ludo then
					if InutilLib.GetILIBData(player).Ludo:IsDead() and not InutilLib.GetILIBData(player).Ludo:Exists() then
						InutilLib.GetILIBData(player).Ludo = nil
					end
				end
				if not InutilLib.GetILIBData(player).Ludo then
					data.player = player
					InutilLib.GetILIBData(data.player).Ludo = kn
				end
			end
		end
		if kn.FrameCount == 1 then
			--hide knife 
			if kn.SpawnerEntity then
				if kn.SpawnerEntity.Variant == FamiliarVariant.INCUBUS and InutilLib.GetILIBData(kn.SpawnerEntity).KnifeHelper then
					kn.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
					kn.Visible = false
				end
				--print(kn.SpawnerEntity.Type)
				if kn.SpawnerEntity.Type == 1 and  InutilLib.GetILIBData(kn.SpawnerEntity).Knife then
					kn.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
					kn.Visible = false
				end
			end
		end
	end)

	--TARGET STUFF--

	function InutilLib.GetMainPlayerTarget(target, player)
		local mainTarget
		if target.Parent.Variant == EntityType.ENTITY_PLAYER and player:HasCollectible(CollectibleType.COLLECTIBLE_EPIC_FETUS) then
			local player = target.Parent:ToPlayer();
			mainTarget = player:GetActiveWeaponEntity();
		end
		return mainTarget
	end

	mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, tr)
		if tr.FrameCount == 1 then
			local data = InutilLib.GetILIBData(tr)
		end
	end, EffectVariant.TARGET)

	function InutilLib.AnimWalkFrame(ent, boo, hori, vert, opUp, opHori2, NE, NW, SE, SW) --because I want to make a more flexible version of npc:AnimWalkFrame + I wanted this to work for other types of entities as well
		local spr, angle = ent:GetSprite(), ent.Velocity:GetAngleDegrees()
		local velLength = ent.Velocity:Length()
		
		if velLength <= 2 then
			spr:SetFrame(vert, 1)
		else
			if type(NE) == 'string' or type(NW) == 'string' or type(SE) == 'string' or type(SW) == 'string' then --if true, opUp is assumed to be valid
				--coming soon, not available yet
				if angle >= 45 and angle <= 135 then --front
					spr:Play(vert, boo)
				elseif angle >= 135 and angle <= 157 then --SW
					spr:Play(SW, boo)
				elseif angle <= -45 and angle >= -135 then --back
					spr:Play(opUp, boo)
				elseif angle <= -135 and angle >= -157 then --NW
					spr:Play(NW, boo)
				elseif (angle >= 157 and angle <= 180) or (angle <= -157 and angle >= -180) then --left
					local op = hori
					if opHori2 then
						op = opHori2
					end
					spr:Play(op, boo)
					if not opHori2 then spr.FlipX = true end
				elseif (angle >= 0 and angle <= 23) or (angle <= 0 and angle >= -23) then --right
					spr:Play(hori, boo)
					spr.FlipX = false
				elseif (angle >= 23 and angle <= 45)then --se
					spr:Play(SE, boo)
				elseif (angle <= -23 and angle >= -45) then --NE
					spr:Play(NE, boo)
				end
			else
				if type(opUp) == 'string' then
					if angle >= 45 and angle <= 135 then --front
						spr:Play(vert, boo)
					elseif angle <= -45 and angle >= -135 then --back
						spr:Play(opUp, boo)
					elseif (angle >= 135 and angle <= 180) or (angle <= -135 and angle >= -180) then --left
						local op = hori
						if opHori2 then
							op = opHori2
						end
						spr:Play(op, boo)
						if not opHori2 then spr.FlipX = true end
					elseif (angle >= 0 and angle <= 45) or (angle <= 0 and angle >= -45) then --right
						spr:Play(hori, boo)
						spr.FlipX = false
					end
				else
					if (angle >= 45 and angle <= 135) or (angle <= -45 and angle >= -135) then --hori
						spr:Play(vert)
					elseif (angle >= 135 and angle <= 180) or (angle <= -135 and angle >= -180) then --left
						local op = hori
						if opHori2 then
							op = opHori2
						end
						spr:Play(op)
						if not opHori2 then spr.FlipX = true end
					elseif (angle >= 0 and angle <= 45) or (angle <= 0 and angle >= -45) then --right
						spr:Play(hori)
						spr.FlipX = false
					end
				end
			end
		end
		return angle
	end

	function InutilLib.WillFlip(angle, invert)
		local result
		if angle >= -90 and angle <= 90 then -- Left
			if invert == true then result = true else result = false end
		elseif angle >= 90 or angle <= -90 then -- Right
			if invert == true then result = false else result = true end
		end
		return result
	end

	function InutilLib.FlipXByVec(ent, invert) --invert exists just in case some guy did his sprite the other way and it's making the sprite go backwards each time
		local angle = (ent.Velocity):GetAngleDegrees()
		local result = InutilLib.WillFlip(angle, invert)
			ent:GetSprite().FlipX = result
		return result
	end


	function InutilLib.FlipXByTarget(ent, target, invert) --invert exists just in case some guy did his sprite the other way and it's making the sprite go backwards each time
		local angle = (ent.Position - target.Position):GetAngleDegrees()
		local result = InutilLib.WillFlip(angle, invert)
			ent:GetSprite().FlipX = result
		return result
	end



	function InutilLib.AnimShootFrame(ent, boo, vec, hori, vert, opUp, opHori2, NE, NW, SE, SW) --because I want to make a more flexible version of npc:AnimWalkFrame + I wanted this to work for other types of entities as well
		local spr, angle = ent:GetSprite(), vec:GetAngleDegrees()
		local velLength = vec:Length()
		
		if angle then
			if type(NE) == 'string' or type(NW) == 'string' or type(SE) == 'string' or type(SW) == 'string' then --if true, opUp is assumed to be valid
			
			else
				if type(opUp) == 'string' then
					if angle >= 45 and angle <= 135 then --front
						spr:Play(vert, boo)
					elseif angle <= -45 and angle >= -135 then --back
						spr:Play(opUp, boo)
					elseif (angle >= 135 and angle <= 180) or (angle <= -135 and angle >= -180) then --left
						local op = hori
						if opHori2 then
							op = opHori2
						end
						spr:Play(op, boo)
						if not opHori2 then spr.FlipX = true end
					elseif (angle >= 0 and angle <= 45) or (angle <= 0 and angle >= -45) then --right
						spr:Play(hori, boo)
						spr.FlipX = false
					end
				else
					if (angle >= 45 and angle <= 135) or (angle <= -45 and angle >= -135) then --hori
						spr:Play(vert)
					elseif (angle >= 135 and angle <= 180) or (angle <= -135 and angle >= -180) then --left
						local op = hori
						if opHori2 then
							op = opHori2
						end
						spr:Play(op)
						if not opHori2 then spr.FlipX = true end
					elseif (angle >= 0 and angle <= 45) or (angle <= 0 and angle >= -45) then --right
						spr:Play(hori)
						spr.FlipX = false
					end
				end
			end
		end
		return angle
	end

	--animation functions
	--from Revelations! Thanks! 
	--from InutilLib.IsFinishedMultiple() 'til InutilLib.GetShowingActive()

	function InutilLib.IsFinishedMultiple(sprite, ...)
		for _, anim in ipairs({...}) do
			if sprite:IsFinished(anim) then
				return true
			end
		end
		return false
	end

	function InutilLib.IsPlayingMultiple(sprite, ...)
		for _, anim in ipairs({...}) do
			if sprite:IsPlaying(anim) then
				return true
			end
		end
		return false
	end

	function InutilLib.IsOverlayFinishedMultiple(sprite, ...)
		for _, anim in ipairs({...}) do
			if sprite:IsOverlayFinished(anim) then
				return true
			end
		end
		return false
	end

	function InutilLib.IsOverlayPlayingMultiple(sprite, ...)
		for _, anim in ipairs({...}) do
			if sprite:IsOverlayPlaying(anim) then
				return true
			end
		end
		return false
	end

	function InutilLib.MultiAnimOnCheck(sprite, ...)
		return InutilLib.IsFinishedMultiple(sprite, ...) or InutilLib.IsPlayingMultiple(sprite, ...)
	end

	function InutilLib.IsShowingItem(player)
	return InutilLib.MultiAnimOnCheck(player:GetSprite(), "UseItem", "PlayerPickupSparkle", "LiftItem", "PickupWalkDown", "PickupWalkUp", "PickupWalkLeft", "PickupWalkRight")
	end

	--Show active until active button is pressed again

	function InutilLib.ShowActiveItem(player, ispocket)
		ispocket = ispocket or false
		local data = InutilLib.GetILIBData( player )

		if ispocket then
			data.LastShownItem = player:GetActiveItem(ActiveSlot.SLOT_POCKET)
		else
			data.LastShownItem = player:GetActiveItem(0)
		end
		data.LastPocketItemUsed = ispocket
		player:AnimateCollectible(data.LastShownItem, "LiftItem", "PlayerPickup")
		player.FireDelay = 15
	end

	function InutilLib.HideActiveItem(player, ispocket)
		ispocket = ispocket or false
		local data = InutilLib.GetILIBData( player )
		local id
		if ispocket then
			id = player:GetActiveItem(ActiveSlot.SLOT_POCKET)
		else
			id = player:GetActiveItem(0)
		end
		data.LastPocketItemUsed = ispocket
		player:AnimateCollectible(id, "HideItem", "PlayerPickup")
		data.LastShownItem = nil
		player.FireDelay = player.MaxFireDelay
	end

	mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function(_, player)
		local data = InutilLib.GetILIBData( player )
		if data.LastShownItem and InutilLib.IsShowingItem(player) then
			player.FireDelay = 15
		end
	end)

	function InutilLib.RefundActiveCharge(player, delay, ispocket, isDouble)
		ispocket = ispocket or false
		isDouble = isDouble or false
		delay = delay or 1
		local slot
		local maxcharge
		if ispocket and player:GetActiveItem(ActiveSlot.SLOT_POCKET) ~= 0 then
			maxcharge = InutilLib.config:GetCollectible(player:GetActiveItem(ActiveSlot.SLOT_POCKET)).MaxCharges
			slot = ActiveSlot.SLOT_POCKET

		elseif player:GetActiveItem(ActiveSlot.SLOT_PRIMARY) ~= 0 then
			maxcharge = InutilLib.config:GetCollectible(player:GetActiveItem(ActiveSlot.SLOT_PRIMARY)).MaxCharges
			slot = ActiveSlot.SLOT_PRIMARY

		end
		--if not isDouble or (isDouble and not (player:GetActiveCharge(slot) >= maxcharge)) then
		InutilLib.SetTimer(delay, function()
			isDouble = isDouble
			local charge = player:GetActiveCharge(slot) + maxcharge
			--if player:GetActiveItem(ActiveSlot.SLOT_PRIMARY) ~= 0 or player:GetActiveItem(ActiveSlot.SLOT_POCKET) ~= 0 then
			if isDouble then
				charge = maxcharge
			end
			player:SetActiveCharge(charge, slot)
			--end
		end)
		--end
		--print(player:GetActiveCharge() + maxcharge, "  how", maxcharge, "  ", player:GetActiveCharge())
	end

	function InutilLib.ConsumeActiveCharge(player, ispocket)
		ispocket = ispocket or false
		local slot
		local maxcharge
		if ispocket then
			maxcharge = InutilLib.config:GetCollectible(player:GetActiveItem(ActiveSlot.SLOT_POCKET)).MaxCharges
			slot = ActiveSlot.SLOT_POCKET
		else
			maxcharge = InutilLib.config:GetCollectible(player:GetActiveItem(ActiveSlot.SLOT_PRIMARY)).MaxCharges
			slot = ActiveSlot.SLOT_PRIMARY
		end

		player:SetActiveCharge(player:GetActiveCharge(slot) - maxcharge, slot)
	end

	function InutilLib.ToggleShowActive(player, refundCharge, ispocket)
		ispocket = ispocket or false
		local data = InutilLib.GetILIBData( player )
		if refundCharge then
			InutilLib.RefundActiveCharge(player, 1, ispocket)
		end
		if not player:GetEffects():GetCollectibleEffect(CollectibleType.COLLECTIBLE_MEGA_MUSH) then --lazy way to avoid softlock
			if data.LastShownItem and InutilLib.IsShowingItem(player) then
				InutilLib.HideActiveItem(player, ispocket)

				return false
			else
				InutilLib.ShowActiveItem(player, ispocket)
				
				return true
			end
		end
	end

	function InutilLib.GetShowingActive(player)
		local data = InutilLib.GetILIBData( player )
		return InutilLib.IsShowingItem(player) and data.LastShownItem
	end

	function InutilLib.GetShowingActiveSlot(player)
		local data = InutilLib.GetILIBData( player )
		if InutilLib.IsShowingItem(player) then
			return data.LastPocketItemUsed
		end
	end

	function InutilLib:setLastShownItem(collItem, rng, player, flag, slot)
		local data = InutilLib.GetILIBData( player )
		data.LastShownItemByTrigger = collItem
		data.LastShownItemByTriggerBySlot = slot
	end
	mod:AddCallback(ModCallbacks.MC_USE_ITEM, InutilLib.setLastShownItem)

	function InutilLib.GetLastShownItem(player)
		local data = InutilLib.GetILIBData( player )
		return data.LastShownItemByTrigger
	end

	function InutilLib.GetLastShownItemBySlot(player)
		local data = InutilLib.GetILIBData( player )
		return data.LastShownItemByTriggerBySlot
	end

	--from rev, again
	function InutilLib.IsAnimated(spr, anim)
		return spr:IsPlaying(anim) or spr:IsFinished(anim)
	end

	function InutilLib.GetRoomGrids()
		local returnT = {}
		for i = 1, 1000 do
			local grid = InutilLib.room:GetGridEntity(i)
			table.insert(returnT, grid)
		end
		return returnT
	end

	function InutilLib.GetClosestGrid(obj, dist, type)
		local closestDist = 177013 --saved Dist to check who is the closest enemy
		local returnV
		for j, grid in pairs (InutilLib.GetRoomGrids()) do
			--local data = InutilLib.GetILIBData(grid);
			local minDist = dist or 100
			if (obj.Position - grid.Position):Length() < minDist then
				if (obj.Position - grid.Position):Length() < closestDist and (grid.State ~= 2 and grid.State ~= 1000) and grid:GetType() == type then
					closestDist = (obj.Position - grid.Position):Length()
					returnV = grid
				end
			end
		end
		return returnV
	end


	function InutilLib.GetRoomGridCount()
		local returnT = 0
		for i = 1, 1000 do
			local grid = InutilLib.room:GetGridEntity(i)
			if grid ~= nil and (grid.State ~= 0 and grid.State ~= 2) then
				if grid:GetType() ~= GridEntityType.GRID_WALL and grid:GetType() ~= GridEntityType.GRID_DOOR then
					returnT = returnT + 1
				end
			end
		end
		return returnT
	end

	function InutilLib.PressPressurePlate(grid)
		if grid.State == 0 then
			grid.State = 3
			InutilLib.SFX:Play( SoundEffect.SOUND_BUTTON_PRESS, 1, 0, false, 1 );
			grid:GetSprite():Play("On", true)
			grid:Update()
		end
	end

	--https://www.redblobgames.com/grids/circle-drawing/ this one is a good one
	function InutilLib.GetGridsInRadius(center, tile, radius)
		local dx = center.X - tile.X
		local dy = center.Y - tile.Y;
		local distance_squared = dx*dx + dy*dy;
		return distance_squared <= radius*radius;
	end
	--underlay effects
	local ENTITY_ENTUNDERLAY = Isaac.GetEntityVariantByName("Underlay");
	mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
		local data = InutilLib.GetILIBData( eff )
		local sprite = eff:GetSprite();
		if data.Parent then
			eff.Position = data.Parent.Position
			eff.Velocity = data.Parent.Velocity
		end
	end, ENTITY_ENTUNDERLAY)

	function InutilLib.AddUnderlay(ent, anm2)
		local data = InutilLib.GetILIBData( ent )
		if not data.Underlay or data.Underlay:IsDead() then
			data.Underlay = Isaac.Spawn( EntityType.ENTITY_EFFECT, ENTITY_ENTUNDERLAY, subvariant or 0, ent.Position,  Vector(0,0), ent );
			data.Underlay:GetSprite():Load(anm2 , true)
			InutilLib.GetILIBData(data.Underlay).Parent = ent
			
			if not data.UnderlayState then data.UnderlayState = false end
			
			return data.Underlay
		end
	end

	function InutilLib.PlayUnderlay(ent, anim, force)
		local data = InutilLib.GetILIBData( ent )
		if data.Underlay then
			data.Underlay:GetSprite():Play(anim, force)
		end
	end

	function InutilLib.UnderlaySetOver(ent)
		local data = InutilLib.GetILIBData( ent )
		if data.Underlay then
			data.UnderlayState = false
		end
	end

	function InutilLib.UnderlaySetUnder(ent)
		local data = InutilLib.GetILIBData( ent )
		if data.Underlay then
			data.UnderlayState = true
		end
	end

	function InutilLib.StopUnderlay(ent)
		local data = InutilLib.GetILIBData( ent )
		if data.Underlay then
			data.Underlay:GetSprite():Stop()
		end
	end

	function InutilLib.UnderlayOffset(ent, offset)
		local finalOffset
		local data = InutilLib.GetILIBData( ent )
		if type(data.UnderlayState) == "boolean" then
			if data.UnderlayState == true then
				data.Underlay.RenderZOffset = -10
			elseif data.UnderlayState == false then
				data.Underlay.RenderZOffset = 10
			end
			finalOffset = offset
			if data.Underlay then
				data.Underlay:GetSprite().Offset = finalOffset
			end
		end
	end

	function InutilLib.GetFrameUnderlay(ent)
		local data = InutilLib.GetILIBData( ent )
		if data.Underlay then
			return data.Underlay:GetSprite():GetFrame()
		end
	end

	function InutilLib.IsPlayingUnderlay(ent, anim)
		local data = InutilLib.GetILIBData( ent )
		if data.Underlay:GetSprite():IsPlaying(anim) then
			return true
		end
		return false
	end

	function InutilLib.IsFinishedUnderlay(ent, anim)
		local data = InutilLib.GetILIBData( ent )
		if data.Underlay:GetSprite():IsFinished(anim) then
			return true
		end
		return false
	end

	function InutilLib.RemoveUnderlay(ent)
		local data = InutilLib.GetILIBData( ent )
		if data.Underlay then 
			data.Underlay:Remove()
			data.Underlay = nil 
		end
	end

	function InutilLib.UnderlayVisible(ent, boolean)
		local data = InutilLib.GetILIBData( ent )
		if data.Underlay then 
			data.Underlay.Visible = boolean
		end
	end

	function InutilLib.UnderlayMatchOwner(ent)
		local data = InutilLib.GetILIBData( ent )
		if data.Underlay then 
			data.Underlay.Visible = ent.Visible
			data.Underlay:SetColor(ent:GetColor(),5, 1, true, true)
			data.Underlay.SpriteScale = ent.SpriteScale
		end
	end

	function InutilLib.FlipXUnderlay(ent, boolean)
		local data = InutilLib.GetILIBData( ent )
		if data.Underlay then 
			data.Underlay.FlipX = boolean or false
		end
	end

	-------

	--This exists because the underlay doesnt have a layer system, so go away
	function InutilLib.AddOverlay(ent, anm2)
		local data = InutilLib.GetILIBData( ent )
		if not data.Overlay or data.Overlay:IsDead() then

			data.Overlay = Isaac.Spawn( EntityType.ENTITY_EFFECT, ENTITY_ENTUNDERLAY, subvariant or 0, ent.Position,  Vector(0,0), ent );
			data.Overlay:GetSprite():Load(anm2 , true)
			InutilLib.GetILIBData(data.Overlay).Parent = ent
			
			if not data.OverlayState then data.OverlayState = false end
			
			return data.Overlay
		end
	end

	function InutilLib.PlayOverlay(ent, anim, force)
		local data = InutilLib.GetILIBData( ent )
		if data.Overlay then
			data.Overlay:GetSprite():Play(anim, force)
		end
	end

	function InutilLib.SetOverlayFrame(ent, anim, num)
		local data = InutilLib.GetILIBData( ent )
		if data.Overlay then
			data.Overlay:GetSprite():SetFrame(anim, num)
		end
	end

	function InutilLib.OverlaySetOver(ent)
		local data = InutilLib.GetILIBData( ent )
		if data.Overlay then
			data.OverlayState = false
		end
	end

	function InutilLib.OverlaySetUnder(ent)
		local data = InutilLib.GetILIBData( ent )
		if data.Overlay then
			data.OverlayState = true
		end
	end

	function InutilLib.StopOverlay(ent)
		local data = InutilLib.GetILIBData( ent )
		if data.Overlay then
			data.Overlay:GetSprite():Stop()
		end
	end

	function InutilLib.OverlayOffset(ent, offset)
		local finalOffset
		local data = InutilLib.GetILIBData( ent )
		if type(data.OverlayState) == "boolean" then
			if data.OverlayState == true then
				data.Overlay.RenderZOffset = -10
			elseif data.OverlayState == false then
				data.Overlay.RenderZOffset = 10
			end
			finalOffset = offset
			if data.Overlay then
				data.Overlay:GetSprite().Offset = finalOffset
			end
		end
	end

	function InutilLib.GetFrameOverlay(ent)
		local data = InutilLib.GetILIBData( ent )
		if data.Overlay then
			return data.Overlay:GetSprite():GetFrame()
		end
	end

	function InutilLib.IsPlayingOverlay(ent, anim)
		local data = InutilLib.GetILIBData( ent )
		if data.Overlay:GetSprite():IsPlaying(anim) then
			return true
		end
		return false
	end

	function InutilLib.IsFinishedOverlay(ent, anim)
		local data = InutilLib.GetILIBData( ent )
		if data.Overlay:GetSprite():IsFinished(anim) then
			return true
		end
		return false
	end

	function InutilLib.RemoveOverlay(ent)
		local data = InutilLib.GetILIBData( ent )
		if data.Overlay then 
			data.Overlay:Remove()
			data.Overlay = nil 
		end
	end

	function InutilLib.OverlayVisible(ent, boolean)
		local data = InutilLib.GetILIBData( ent )
		if data.Overlay then 
			data.Overlay.Visible = boolean
		end
	end

	function InutilLib.OverlayMatchOwner(ent)
		local data = InutilLib.GetILIBData( ent )
		if data.Overlay then 
			data.Overlay.Visible = ent.Visible
			data.Overlay:SetColor(ent:GetColor(),5, 1, true, true)
			data.Overlay.SpriteScale = ent.SpriteScale
		end
	end

	function InutilLib.FlipXOverlay(ent, boolean)
		local data = InutilLib.GetILIBData( ent )
		if data.Overlay then 
			data.Overlay.FlipX = boolean or false
		end
	end

	--- MEGA MUSH Stuff

	local COLLECTIBLE_MEGA_MUSH_B = Isaac.GetItemIdByName(" Mega Mush ");
	local ENTITY_MEGAMUSHOVERLAY = Isaac.GetEntityVariantByName("MegaMushOverlay");

	mod:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, function(_, item, rng, player, flag, pocket)
		local data = InutilLib.GetILIBData(player)
		if data.IsMegaMush then 
			local ispocket = false
			if pocket == 2 then 
				ispocket = true
			end
			InutilLib.RefundActiveCharge(player, 0, ispocket)
			return false
			
			--print("rachie")
			---if data.MushOverlay then data.MushOverlay:Remove() end --force restart if already active
			--if data.MushHeadOverlay then data.MushHeadOverlay:Remove() end
			--data.IsMegaMush = false
		end
		data.StartMegaMushAnim = true
	end, CollectibleType.COLLECTIBLE_MEGA_MUSH) --COLLECTIBLE_MEGA_MUSH_B)

	--if TransformationAPI ~= nil then TransformationAPI:addItemsToTransformation("funguy", {COLLECTIBLE_MEGA_MUSH_B}) end

	--deprecated
	--[[
	mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function(_,player)
		--local player = Isaac.GetPlayer(0);
		local room = Game():GetRoom();
		local data = InutilLib.GetILIBData(player)
		local playerInfo
		local playerType = player:GetPlayerType()
		if InutilLib.ListOfRegPlayers[playerType] then playerInfo = InutilLib.ListOfRegPlayers[playerType] end
		
		if playerType ~= 35 then -- tainted forgotten
			local giantAnim
			if playerInfo then
				if playerInfo.giantAnim[1] then
					giantAnim = tostring(playerInfo.giantAnim[1])
				else
					giantAnim = "gfx/characters/big_boi.anm2"
				end
			else
				giantAnim = "gfx/characters/big_boi.anm2"
			end
			
				--mega mush custom sprite
				if player:GetEffects():GetCollectibleEffect(CollectibleType.COLLECTIBLE_MEGA_MUSH) and not data.IsMegaMush then
					if player.FrameCount <= 1 then
						data.IsMegaMush = true
					else
						data.StartMegaMushAnim = true
						player.Visible = false
					end
				end
				if not player:GetEffects():GetCollectibleEffect(CollectibleType.COLLECTIBLE_MEGA_MUSH) and data.IsMegaMush then
					if not data.EndMegaMushAnim then data.EndMegaMushAnim = true end
					data.IsMegaMush = false
					if data.MushHeadOverlay then data.MushHeadOverlay:Remove() end
					if data.MushOverlay then data.MushOverlay:Remove() end
					player.Visible = false
				end
			
			if data.StartMegaMushAnim then
				player.Velocity = Vector(0,0)
				player:SetShootingCooldown(2)
				if not data.MushOverlay or data.MushOverlay:IsDead() then
					player.Visible = false
					data.MushOverlay = Isaac.Spawn( EntityType.ENTITY_FAMILIAR, ENTITY_MEGAMUSHOVERLAY, subvariant or 0, player.Position,  Vector(0,0), player );
					data.MushOverlay:GetSprite():Load(giantAnim , true)
					InutilLib.GetILIBData(data.MushOverlay).Parent = player
					
					data.MushOverlay:GetSprite():Play("Transform", true)
				else
					if data.MushOverlay:GetSprite():GetFrame() >= 1 and data.MushOverlay:GetSprite():GetFrame() <= 9 then
						if data.MushOverlay:GetSprite():GetFrame() == 1 then
							SFXManager():Play( SoundEffect.SOUND_VAMP_GULP, 1, 0, false, 1 );
						end
						if data.MushOverlay:GetSprite():GetFrame() == 5 or data.MushOverlay:GetSprite():GetFrame() == 7 or data.MushOverlay:GetSprite():GetFrame() == 9 then
							SFXManager():Play( SoundEffect.SOUND_THUMBSUP, 1, 0, false, 1 + (data.MushOverlay:GetSprite():GetFrame()-2)/10);
						end
					end
					--print("try"..tostring(data.MushOverlay:GetSprite():IsFinished("Transform")))
					if data.MushOverlay:GetSprite():IsFinished("Transform") then
						data.StartMegaMushAnim = false
						player.Visible = true
						data.IsMegaMush = true
						data.MushOverlay:Remove()
						--player:UseActiveItem(CollectibleType.COLLECTIBLE_MEGA_MUSH, 0, -1)
						--if player:HasCollectible(CollectibleType.COLLECTIBLE_CAR_BATTERY) then
						--	player:UseActiveItem(CollectibleType.COLLECTIBLE_MEGA_MUSH, UseFlag.USE_CARBATTERY, -1)
						--end
					end
				end
			end
			if data.EndMegaMushAnim then
				player.Velocity = Vector(0,0)
				player:SetShootingCooldown(2)
				if not data.MushOverlay or data.MushOverlay:IsDead()  then
					player.Visible = false
					data.MushOverlay = Isaac.Spawn( EntityType.ENTITY_FAMILIAR, ENTITY_MEGAMUSHOVERLAY, subvariant or 0, player.Position,  Vector(0,0), player ):ToFamiliar();
					data.MushOverlay:ClearEntityFlags(EntityFlag.FLAG_APPEAR )
					data.MushOverlay:GetSprite():Load(giantAnim , true)
					InutilLib.GetILIBData(data.MushOverlay).Parent = player
					data.MushOverlay:GetSprite():Play("TransformBack", true)
				else
					data.MushOverlay:GetSprite():Play("TransformBack", false)
					--print("try"..tostring(data.MushOverlay:GetSprite():IsFinished("TransformBack")))
					if data.MushOverlay:GetSprite():IsFinished("TransformBack") then
						data.EndMegaMushAnim = false
						data.IsMegaMush = false
						player.Visible = true
						data.MushOverlay:Remove()
					else
						player.Visible = false
						data.MushOverlay:SetColor(player:GetColor(),5, 1, true, true)
						data.MushOverlay.SpriteScale = player.SpriteScale
					end
				end
			end
		end
	end)
	]]
	--[[
	function InutilLib:RenderMegaMushOverlay() 
		--local player = Isaac.GetPlayer(0)
		for p = 0, InutilLib.game:GetNumPlayers() - 1 do
			local player = Isaac.GetPlayer(p)
			local psprite = player:GetSprite()
			local data = InutilLib.GetILIBData(player)
			local playerType = player:GetPlayerType()
			local playerInfo
			if InutilLib.ListOfRegPlayers[playerType] then playerInfo = InutilLib.ListOfRegPlayers[playerType] end
				
			--if playerType ~= 35 then -- tainted forgotten
			local giantAnim
			if playerInfo then
				--print(playerInfo.giantAnim[1])
				--print(playerInfo.giantAnim[2])
				if playerInfo.giantAnim[1] then
					giantAnim = tostring(playerInfo.giantAnim[1])
				else
					giantAnim = "gfx/characters/big_boi.anm2"
				end
				if playerInfo.giantAnim[2] then
					local itemConfig = Isaac.GetItemConfig()
					local itemCostume = itemConfig:GetCollectible(625)
					player:ReplaceCostumeSprite(itemCostume, tostring(playerInfo.giantAnim[2]), 0)
					player:ReplaceCostumeSprite(itemCostume, tostring(playerInfo.giantAnim[2]), 1)
				end
			else
				giantAnim = "gfx/characters/big_boi.anm2"
			end
			--print(playerType)
			if playerType == 35 then
			--	print(player.Velocity:Length())
			end
			--print("loud")
			--print(psprite:GetAnimation())
			--print( psprite:IsPlaying("Transform") )
			if InutilLib.GetILIBData(player).IsMegaMush and playerType ~= 35 then -- tainted forgotten
				--if not data.MushOverlay or data.MushOverlay:IsDead() then
				--	player.Visible = false
				--	data.MushOverlay = Isaac.Spawn( EntityType.ENTITY_EFFECT, ENTITY_MEGAMUSHOVERLAY, subvariant or 0, player.Position,  Vector(0,0), player );
				--	data.MushOverlay:GetSprite():Load(giantAnim , true)
				--	InutilLib.GetILIBData(data.MushOverlay).Parent = player
				--	print("fellow")
				--end
						
				local extraHeadsPresent = false
				--code that checks if extra heads exist
				for i, v in pairs (Isaac.GetRoomEntities()) do
					if v.Type == EntityType.ENTITY_FAMILIAR then
						if v.Variant == FamiliarVariant.SCISSORS or v.Variant == FamiliarVariant.DECAP_ATTACK then
							extraHeadsPresent = true
						end
					end
				end
						
				if not extraHeadsPresent then
					if not data.MushHeadOverlay or data.MushHeadOverlay:IsDead() then
						player.Visible = true
						data.MushHeadOverlay = Isaac.Spawn( EntityType.ENTITY_FAMILIAR, ENTITY_MEGAMUSHOVERLAY, subvariant or 0, player.Position,  Vector(0,0), player ):ToFamiliar();
						data.MushHeadOverlay:ClearEntityFlags(EntityFlag.FLAG_APPEAR )
						data.MushHeadOverlay:GetSprite():Load(giantAnim, true)
						InutilLib.GetILIBData(data.MushHeadOverlay).Parent = player
					end
					if psprite:IsPlaying("Trapdoor") or psprite:IsPlaying("Jump") or psprite:IsPlaying("HoleIn") or psprite:IsPlaying("HoleDeath") or psprite:IsPlaying("JumpOut") or psprite:IsPlaying("LightTravel") or psprite:IsPlaying("Appear") or psprite:IsPlaying("Death") or psprite:IsPlaying("TeleportUp") or psprite:IsPlaying("TeleportDown") then
						--	data.MushOverlay.Visible = false
					else
						player.Visible = true
						--data.MushOverlay.Position = player.Position
						data.MushHeadOverlay.Position = player.Position + Vector(0,5)
						data.MushHeadOverlay.Velocity = player.Velocity
						-- -----data.MushOverlay.Visible = player.Visible
						--data.MushOverlay:SetColor(player:GetColor(),5, 1, true, true)
						--data.MushOverlay.SpriteScale = player.SpriteScale
						data.MushHeadOverlay:SetColor(player:GetColor(),5, 1, true, true)
						data.MushHeadOverlay.SpriteScale = player.SpriteScale
						
						--print(psprite:GetFrame())
						local plusOffset = 0
						
						if psprite:GetFrame() >= 6 and psprite:GetFrame() <= 14 then
							plusOffset = 2
							if psprite:GetFrame() >= 9 and psprite:GetFrame() <= 12 then
								plusOffset = plusOffset + 2
							end
						end
						if psprite:GetFrame() >= 13 and psprite:GetFrame() <= 19 then
							plusOffset = 2
							if psprite:GetFrame() >= 15 and psprite:GetFrame() <= 18 then
								plusOffset = plusOffset + 2
							end
						end
						--data.MushOverlay.RenderZOffset = -11
						
						--if player.Velocity:Length() > 0.08 then
						--	data.MushOverlay:GetSprite():SetFrame(psprite:GetAnimation(), psprite:GetFrame())
						--else
						--	data.MushOverlay:GetSprite():Play("WalkIdle", true)
						--end
						data.MushHeadOverlay.RenderZOffset = 100
						data.MushHeadOverlay:GetSprite():SetFrame(psprite:GetOverlayAnimation(), psprite:GetOverlayFrame())
						data.MushHeadOverlay:GetSprite().Offset = Vector(0,(-37+plusOffset)-5)
					end
				else
					if data.MushHeadOverlay then data.MushHeadOverlay:Remove() end
					
					for i, v in pairs (Isaac.GetRoomEntities()) do
						if v.Type == EntityType.ENTITY_FAMILIAR then
							
							if v.Variant == FamiliarVariant.SCISSORS or v.Variant == FamiliarVariant.DECAP_ATTACK then
								
								local vData = InutilLib.GetILIBData(v)
								if not vData.MushHeadOverlay or vData.MushHeadOverlay:IsDead() then
									vData.MushHeadOverlay = Isaac.Spawn( EntityType.ENTITY_FAMILIAR, ENTITY_MEGAMUSHOVERLAY, subvariant or 0, v.Position,  Vector(0,0), v );
									vData.MushHeadOverlay:GetSprite():Load(giantAnim, true)
									vData.MushHeadOverlay:GetSprite():LoadGraphics()
									--InutilLib.GetILIBData(vData.MushHeadOverlay).Parent = v
								end

								if psprite:IsPlaying("Trapdoor") or psprite:IsPlaying("Jump") or psprite:IsPlaying("HoleIn") or psprite:IsPlaying("HoleDeath") or psprite:IsPlaying("JumpOut") or psprite:IsPlaying("LightTravel") or psprite:IsPlaying("Appear") or psprite:IsPlaying("Death") or psprite:IsPlaying("TeleportUp") or psprite:IsPlaying("TeleportDown") then
								else
									vData.MushHeadOverlay.Position = v.Position + Vector(0,5)
									vData.MushHeadOverlay.Velocity = v.Velocity
									vData.MushHeadOverlay:SetColor(v:GetColor(),5, 1, true, true)
									vData.MushHeadOverlay.SpriteScale = v.SpriteScale
									vData.MushHeadOverlay.RenderZOffset = 100
									
									local plusOffset = 0
														
									if psprite:GetFrame() >= 6 and psprite:GetFrame() <= 14 then
										plusOffset = 2
										if psprite:GetFrame() >= 9 and psprite:GetFrame() <= 12 then
											plusOffset = plusOffset + 2
										end
									end
									if psprite:GetFrame() >= 13 and psprite:GetFrame() <= 19 then
										plusOffset = 2
										if psprite:GetFrame() >= 15 and psprite:GetFrame() <= 18 then
											plusOffset = plusOffset + 2
										end
									end
									
									vData.MushHeadOverlay:GetSprite().Offset = Vector(0,(-37+plusOffset)-5-2)
									vData.MushHeadOverlay:GetSprite():SetFrame(psprite:GetOverlayAnimation(), psprite:GetOverlayFrame())
									
								end
							elseif not data.StartMegaMushAnim and not data.EndMegaMushAnim then
								if data.MushHeadOverlay then data.MushHeadOverlay:Remove() end
							end
						end
					end
				end
			else
				if not data.StartMegaMushAnim and not data.EndMegaMushAnim then
					if data.MushOverlay then data.MushOverlay:Remove() end
					if data.MushHeadOverlay then data.MushHeadOverlay:Remove() end
				end
			end
				--end
		end
	end
	mod:AddCallback(ModCallbacks.MC_POST_RENDER, InutilLib.RenderMegaMushOverlay) ]]

	--chains like begotten
	function InutilLib.AttachChain(parent, child, anm2, anim)
		local data = InutilLib.GetILIBData( child )
		local amount = 10
		if data.chainEffect == nil then data.chainEffect = {} end
		
		local Anim = anim or "Idle"
		
		if #data.chainEffect < amount and InutilLib.level:GetCurrentRoom():GetFrameCount() % 2 == 0 then
			local chain = Isaac.Spawn(1000, 114, 0, parent.Position, child.Velocity, child)
			chain:ClearEntityFlags(EntityFlag.FLAG_APPEAR )
			table.insert(data.chainEffect, chain)
		end
		--render chain
		for i = 1, #data.chainEffect do
			if data.chainEffect[i]:IsDead() then
				data.chainEffect = nil
				break
			end
			if type(anm2) == "string" then
				data.chainEffect[i]:GetSprite():Load(anm2 , true)
			end
			--get position
			local distance = child.Position-parent.Position
			local step = i*0.1 - 0.05
			local linkpos = parent.Position + (distance*step)
			data.chainEffect[i].Position = linkpos
			data.chainEffect[i]:GetSprite():SetFrame(Anim, 0)
			data.chainEffect[i].PositionOffset = Vector(0, -15)
		end
	end

	--chains like ball and chain
	function InutilLib.AttachChain2(parent, child, anm2, anim, section)
		local data = InutilLib.GetILIBData(parent)
		child = child.Position
		parent = parent.Position
		if not data.Init then                                             
			data.spr = Sprite()                                                 
			data.spr:Load(anm2, true)                                                        
			data.Init = true                                              
		end                                                                         

		if data.spr:IsLoaded() then                                                                                                        
			
			local diffVec = child - parent;                                           
			local angle = diffVec:GetAngleDegrees();                             
			local sections = diffVec:Length() / section;                            
			
			data.spr.Rotation = angle;                                          
			data.spr:SetFrame(anim, 0)
			
			--sections stack to each other
			for i = 1, sections do                                                
				data.spr:Render(Isaac.WorldToScreen(parent))                      
				parent = parent + Vector.One * section * Vector.FromAngle(angle)               
			end                                                                                                
		end   
	end

	--chains like brimstone? --credits to Dead for this pieace of code
	function InutilLib.DeadDrawRotatedTilingSprite(sprite, pos1, pos2, tileLength, cutStart, cutEnd, hori)
		
		local diff = pos2 - pos1
		local length = diff:Length()
		local angle = diff:GetAngleDegrees()
		local norm = diff / length

		if cutStart then
			pos1 = pos1 + norm * cutStart
			length = length - cutStart
		end

		if cutEnd then
			length = length - cutEnd
		end

		sprite.Rotation = angle

		local numRenders = math.ceil(length / tileLength)
		local remainingLength = length % tileLength
		local addVector = Vector(tileLength, 0):Rotated(angle)
		for i = 0, numRenders - 1 do
			local rpos = pos1 + addVector * i
			local bottomrightclamp = Vector.Zero
			if i == numRenders - 1 and remainingLength > 0 then
				if hori then
					bottomrightclamp = Vector(0, tileLength - remainingLength)
				else
					bottomrightclamp = Vector(tileLength - remainingLength, 0)
				end
			end
			sprite:Render(rpos, Vector.Zero, bottomrightclamp)
		end
	end

	function InutilLib.DeadGetTilingSprite(pos1, pos2, tileLength, cutStart, cutEnd, hori)
		
		local diff = pos2 - pos1
		local length = diff:Length()
		local angle = diff:GetAngleDegrees()
		local norm = diff / length

		if cutStart then
			pos1 = pos1 + norm * cutStart
			length = length - cutStart
		end

		if cutEnd then
			length = length - cutEnd
		end

		local numRenders = math.ceil(length / tileLength)
		local remainingLength = length % tileLength
		local addVector = Vector(tileLength, 0):Rotated(angle)
		local table_pos = {} -- for storing the places where the new segment starts
		for i = 0, numRenders - 1 do
			local rpos = pos1 + addVector * i
			local bottomrightclamp = Vector.Zero
			if i == numRenders - 1 and remainingLength > 0 then
				if hori then
					bottomrightclamp = Vector(0, tileLength - remainingLength)
				else
					bottomrightclamp = Vector(tileLength - remainingLength, 0)
				end
			end
			table.insert(table_pos, rpos)
		end
		return table_pos
	end


	--deprecated?
	function InutilLib.AttachChain3(parent, child, anm2, anim, section)
		local data = InutilLib.GetILIBData(parent)
		child = child.Position
		parent = parent.Position
		if not data.Init then                                             
			data.spr = Sprite()                                                 
			data.spr:Load(anm2, true)                                                        
			data.Init = true                                              
		end                                                                         

		if data.spr:IsLoaded() then                                                                                                        
			
			local diffVec = child - parent;                                           
			local angle = diffVec:GetAngleDegrees();                             
			local sections = (diffVec:Length() / section);                            
			
			data.spr.Rotation = angle;                                          
			data.spr:SetFrame(anim, 0)
			
			--sections stack to each other
			for i = 1, sections + 1 do
				if sections + 1 ~= i then --if not the remainding length to render
					data.spr:Render(Isaac.WorldToScreen(parent))                      
					parent = parent + Vector.One * section * Vector.FromAngle(angle) 
				else
					data.spr:Render(Isaac.WorldToScreen(parent), Vector.Zero, Vector.Zero)                      
					parent = parent + Vector.One * section * Vector.FromAngle(angle) 
				end
			end                                                                                                
		end   
	end

	--zamiel's code
	function InutilLib.SpawnTrail(player, color, customPlace, z)
		if not customPlace then
			customPlace = player.Position
		end
		if z then
			customPlace = customPlace - z
		end
		local c = color or Color(1, 0, 1, 0.5) -- sets the color of the trail
		local trail = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SPRITE_TRAIL, 0, customPlace, Vector.Zero, nil):ToEffect()
		if z then
			local data = InutilLib.GetILIBData( trail )
			data.Parent = player
			data.CustomPos = z
		else
			trail:FollowParent(player) -- parents the trail to another entity and makes it follow it around
		end
		trail:GetSprite().Color = c
		trail.MinRadius = 0.05 -- fade rate, lower values yield a longer trail
		--trail.SpriteOffset = z or Vector(0,0)
		trail:Update()
		return trail
	end
	mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
		local data = InutilLib.GetILIBData( eff )
		if data.CustomPos then
			eff.Position = data.Parent.Position - data.CustomPos
		end
	end, EffectVariant.SPRITE_TRAIL)

	--based from bert character flip thingy
	local lastMirrorBool = false
	function InutilLib.IsInMirroredFloor(player)
		local controller = player.ControllerIndex
		local right, left = Input.GetActionValue(ButtonAction.ACTION_RIGHT, controller), Input.GetActionValue(ButtonAction.ACTION_LEFT, controller)
		local movementX = player:GetMovementInput().X
		local sx = (left * -1) + right
		--print(movementX, "   ", sx)
		if sx ~= 0 then
			if (movementX < 0 and sx > 0) or (movementX > 0 and sx < 0) then
				lastMirrorBool = true
			else
				lastMirrorBool = false
			end
		end
		return lastMirrorBool
	end

	--based from Rev's clear room
	function InutilLib.RoomIsSafe()
		local roomHasDanger = false

		for i, e in pairs(Isaac.GetRoomEntities()) do
			if e:IsEnemy() and e:IsVulnerableEnemy() then
				roomHasDanger = true
				return false
			end
		end
		if InutilLib.room and InutilLib.room:IsClear() and not roomHasDanger then
			return true
		end
		return true
	end

	function InutilLib.AlphaGetScreenCenterPosition() --credits to alphaapi
		local room = Game():GetRoom()
		local shape = room:GetRoomShape()
		local centerOffset = (room:GetCenterPos()) - room:GetTopLeftPos()
		local pos = room:GetCenterPos()
		if centerOffset.X > 260 then
			pos.X = pos.X - 260
		end
		if shape == RoomShape.ROOMSHAPE_LBL or shape == RoomShape.ROOMSHAPE_LTL then
			pos.X = pos.X - 260
		end
		if centerOffset.Y > 140 then
			pos.Y = pos.Y - 140
		end
		if shape == RoomShape.ROOMSHAPE_LTR or shape == RoomShape.ROOMSHAPE_LTL then
			pos.Y = pos.Y - 140
		end
		
		return Isaac.WorldToRenderPosition(pos, false)
	end

	function InutilLib.FFgetScreenBottomRight()
		return InutilLib.game:GetRoom():GetRenderSurfaceTopLeft() * 2 + Vector(442,286)
	end
	
	function InutilLib.FFgetScreenCenterPosition()
		return InutilLib.FFgetScreenBottomRight() / 2
	end

	--stage api code
	InutilLib.FloorEffectCreep = {
		T = EntityType.ENTITY_EFFECT,
		V = 22,
		S = 9002
	}

	function InutilLib.SpawnFloorEffect(pos, velocity, spawner, anm2, loadGraphics, variant)
		local eff = Isaac.Spawn(InutilLib.FloorEffectCreep.T, InutilLib.FloorEffectCreep.V, InutilLib.FloorEffectCreep.S, pos or zeroVector, velocity or zeroVector, spawner)
		eff.Variant = variant or 9002
		if anm2 then
			eff:GetSprite():Load(anm2, loadGraphics)
		end

		return eff
	end

	-- Timer Function --

	-- keep track of timers and their expiration callbacks
	local timers = {};
	function InutilLib.SetTimer(frames,callback)
		if frames <= 0 then
			callback();
		else
			table.insert( timers, {frames,callback});
		end
	end
	function InutilLib.UpdateTimers()
		for i=#timers,1,-1 do
			timers[i][1] = timers[i][1] - 1;
			if timers[i][1] <= 0 then
				timers[i][2]();
				table.remove( timers, i );
			end
		end
	end

	mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function(_)
		InutilLib.UpdateTimers()
	end)

	local abe = {};
	function InutilLib.SetFrameLoop(frames,callback)
		if frames <= 0 then
			callback();
		else
			table.insert( abe, {frames,callback});
		end
	end
	function InutilLib.UpdateFrameLoop()
		for i=#abe,1,-1 do
			abe[i][1] = abe[i][1] - 1;
			abe[i][2]();
			if abe[i][1] <= 0 then
				table.remove( abe, i );
			end
		end
	end

	--genericlib1.lua's Post_update!
	mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function(_,player)
		InutilLib.UpdateFrameLoop()
		InutilLib.UpdateTimers()
	end)



	-------------------------------
	-- ENTITY MOVEMENT FUNCTIONS --
	-------------------------------

	--movement for moving directly at the target
	function InutilLib.MoveDirectlyTowardsTarget(ent, targetPos, vel, friction)
		--ent.Velocity = ent.Velocity * 0.9
		ent.Velocity = ent.Velocity * friction + ((targetPos.Position - ent.Position):Resized(1) * vel)
	end

	--movement for moving away from the target
	function InutilLib.MoveAwayFromTarget(ent, targetPos, vel, friction)
		if Round(ent.Velocity:Length(),0) > vel then --this acts like a filter; if the current velocity is higher than the supposed velocity, it makes it slow down first :D
			ent.Velocity = ent.Velocity * 0.9
		else
			ent.Velocity = ent.Velocity * friction + ((ent.Position - targetPos.Position):Resized(1) * vel)
		end
	end

	--Xalum's Code for typical enemies pathfinding! Not the best, but it works.
	--[[ XalumMoveTowardsTarget(ent, targetPos, vel, friction, cansmashrocks)
		ent - the entity
		targetPos - where the ent heads
		vel - how fast
		friction - friction :/
		cansmashrocks - tells if it can smash rocks!
	]]
	function InutilLib.XalumMoveTowardsTarget(ent, targetPos, vel, friction, cansmashrocks)
		local data = InutilLib.GetILIBData( ent )
		if data.path == nil then data.path = ent.Pathfinder end
		if cansmashrocks ~= data.path:SetCanCrushRocks() then data.path:SetCanCrushRocks(cansmashrocks) end
		
		if Round(ent.Velocity:Length(),0) > vel then --this acts like a filter; if the current velocity is higher than the supposed velocity, it makes it slow down first :D
			ent.Velocity = ent.Velocity * 0.9
		else
			if InutilLib.room:CheckLine(ent.Position,targetPos.Position, 0, 1, false, false) and not ent:CollidesWithGrid() then
				ent.Velocity = (ent.Velocity * friction) + (targetPos.Position - ent.Position):Resized(vel/2)
			else
				data.path:FindGridPath(targetPos.Position, vel/2, 1, false)
			end
		end
	end


	--[[ MoveRandomlyTypeI(ent, targetPos, vel, friction)
		ent - the entity
		targetPos - where the ent heads
		vel - how fast
		friction - friction :/
		angleoffset - sets the angle offset additional with ent's movement (or something, dunno how to describe it lol)
	]]
	function InutilLib.MoveRandomlyTypeI(ent, targetPos, vel, friction, angleoffset, changeangleframemin, changeangleframemax)
		local data = InutilLib.GetILIBData( ent )
		if not changeangleframemin and not changeangleframemax then
			changeangleframemin = 5
			changeangleframemax = 10
		end
		if not targetPos then targetPos = targetPos end
		if Round(ent.Velocity:Length(),0) > vel then --this acts like a filter; if the current velocity is higher than the supposed velocity, it makes it slow down first :D
			ent.Velocity = ent.Velocity * friction
		else
			if data.dir == nil then
				data.dir = (targetPos - ent.Position):GetAngleDegrees() + math.random(-angleoffset, angleoffset)
				data.AngleFrame = math.random(changeangleframemin, changeangleframemax)
			end
			
			data.AngleFrame = data.AngleFrame - 1
			if data.AngleFrame <= 0 then
				data.dir = (targetPos - ent.Position):GetAngleDegrees() + math.random(-angleoffset, angleoffset)
				data.AngleFrame = math.random(changeangleframemin, changeangleframemax)
			end
			ent.Velocity = (ent.Velocity * friction) + ((Vector.FromAngle(data.dir)):Resized(1) * vel)
		end
	end

	function GetRandomNumByGameCount()
		local product = RNG():GetSeed() + InutilLib.game:GetFrameCount()
		return product
	end

	--MoveDiagonalTypeI(ent, vel, moverandom, canknockback)
	--This piece of code came from Revelations! I only edited it to my needs, but please credit Rev for this, not me!
	--[[ vel - the speed of the entity
		moverandom - boolean value, it asks if it would move randomly or move with the same direction with the other similar entities
		canknockback - can it be knockbacked?
	]]
	function InutilLib.MoveDiagonalTypeI(ent, vel, moverandom, cantknockback)

	table.diagonalmovement = { --optimization
	(Vector.FromAngle(1*45)*vel),
	(Vector.FromAngle(1*135)*vel),
	(Vector.FromAngle(1*225)*vel),
	(Vector.FromAngle(1*315)*vel),
	}
		if cantknockback then
			ent:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
		end
		local data = InutilLib.GetILIBData( ent )
		--print(tostring(GetRandomNumByGameCount()%5, 0, 1, 2 .. "a"))
		--print(tostring(ent.Velocity.X .. " " .. ent.Velocity.Y))
		
		local velocity = ent.Velocity
		if Round(velocity:Length(),0) > vel then --this acts like a filter; if the current velocity is higher than the supposed velocity, it makes it slow down first :D
			ent.Velocity = ent.Velocity * 0.9
		else
			if velocity.X < 0 then velocity.X = velocity.X*-1 end
			if velocity.Y < 0 then velocity.Y = velocity.Y*-1 end
			if velocity.X + velocity.Y <= vel/2 then -- if the velocity is smaller than the needed velocity
				if data.ForceDirection then
					ent.Velocity = table.diagonalmovement[data.ForceDirection]
				else
					if moverandom == true then
						ent.Velocity = table.diagonalmovement[math.random(1,4)]
					elseif moverandom == false then
						local randomnum = Round(GetRandomNumByGameCount(),0)%5
						if randomnum == 0 then
							randomnum = randomnum + 1
							ent.Velocity = table.diagonalmovement[randomnum]
						else
							ent.Velocity = table.diagonalmovement[randomnum]
						end
					end
				end
			end
			ent.Velocity = ent.Velocity:Resized(vel)
		end
	end

	function InutilLib.MoveBackForthTypeI(ent, vel, moverandom, cantknockback)

	table.diagonalmovement = { --optimization
	(Vector.FromAngle(1*0)*vel),
	(Vector.FromAngle(1*90)*vel),
	(Vector.FromAngle(1*180)*vel),
	(Vector.FromAngle(1*270)*vel),
	}
		if cantknockback then
			ent:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
		end
		local data = InutilLib.GetILIBData( ent )
		--print(tostring(GetRandomNumByGameCount()%5, 0, 1, 2 .. "a"))
		--print(tostring(ent.Velocity.X .. " " .. ent.Velocity.Y))
		
		local velocity = ent.Velocity
		if Round(velocity:Length(),0) > vel then --this acts like a filter; if the current velocity is higher than the supposed velocity, it makes it slow down first :D
			ent.Velocity = ent.Velocity * 0.9
		else
			if velocity.X < 0 then velocity.X = velocity.X*-1 end
			if velocity.Y < 0 then velocity.Y = velocity.Y*-1 end
			if velocity.X + velocity.Y <= vel then -- if the velocity is smaller than the needed velocity
				--[[if data.ForceDirection then
					ent.Velocity = table.diagonalmovement[data.ForceDirection]
				else
					ent.Velocity = ent.Velocity*2
				end]]
				if not data.initVel then
					if velocity.X + velocity.Y <= 0 then
						if moverandom == true then
							ent.Velocity = table.diagonalmovement[math.random(1,4)]
						elseif moverandom == false then
							local randomnum = Round(GetRandomNumByGameCount(),0)%5
							if randomnum == 0 then
								randomnum = randomnum + 1
								ent.Velocity = table.diagonalmovement[randomnum]
							else
								ent.Velocity = table.diagonalmovement[randomnum]
							end
						end
					end
					data.initVel = true
				else
					ent.Velocity = ent.Velocity*(300*2)
				end
			end
			ent.Velocity = ent.Velocity:Resized(vel)
		end
	end


	--MoveOrbitAroundTargetType1(ent, targetPos, vel, friction, orbitDist, startingNum)
	--This piece of code came from Revelations! I only edited it to my needs, but please credit Rev for this, not me!
	--This makes the entity orbit around a target, and if far enough, will speed up quickly to the parent position it needs to rotate to
	--[[ ent -- the entity.
		targetPos -- the position of the targeted place
		vel -- how fast it will go
		friction - friction
		orbitDist --how far it is from the parent point it orbits
		startingNum --this is where it will start from orbiting, so you can manipulate where it will begin from here
	]]
	function InutilLib.MoveOrbitAroundTargetType1(ent, targetPos, vel, friction, orbitDist, startingNum)
		local data = InutilLib.GetILIBData( ent )
		ent.Velocity = ent.Velocity * 0.3
		ent.Velocity = ((targetPos.Position+(Vector.FromAngle((ent.FrameCount+startingNum)*vel)*(orbitDist*10))) - ent.Position)*0.2
	end

	function InutilLib.StrafeAroundTarget(ent, targetPos, vel, friction, angleStrafe)
		--if round(ent.Velocity:Length(),0) > vel*2 then
		--	ent.Velocity = ent.Velocity * 0.3
		--else
			local angleMovement = ((targetPos.Position - ent.Position):Rotated(angleStrafe):Resized(1) * vel)
			ent.Velocity = ent.Velocity * friction + angleMovement
		--end
	end

	function InutilLib.CreateGenericGridIndexTable()
		local tbl = {}
		tbl.gridSet = {}
		tbl.emptySet = {}
		for i = 0, InutilLib.room:GetGridSize()  do
			if InutilLib.room:GetGridEntity(i) then
				--Isaac.DebugString(InutilLib.room:GetGridEntity(i):GetType())
				--Isaac.DebugString(i)
				--local spear = Isaac.Spawn(EntityType.ENTITY_BOMBDROP, 0, 0, Game():GetRoom():GetGridEntity(i).Position, Vector.Zero, _)
				tbl.gridSet[i] = InutilLib.room:GetGridPosition(i)
			else
				tbl.emptySet[i] = InutilLib.room:GetGridPosition(i)
			end
		end
		return tbl
	end

	mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
		local tbl = InutilLib.CreateGenericGridIndexTable()
		for k, v in pairs(InutilLib.CreateGenericGridIndexTable().gridSet) do
			--Isaac.DebugString(k, "  ", v)
			--Isaac.RenderText("hey", 100, 100, 1 ,1 ,1 ,1 )
			--local spear = Isaac.Spawn(EntityType.ENTITY_BOMBDROP, 0, 0, v.Position, Vector.Zero, _)
		end
	end)

	function InutilLib.CreateGenericPathfinder(ent, target, vel, directly) --hold that in there
		local data = InutilLib.GetILIBData( ent )
		data.path = {} --table which keeps the indexes where the pathfinder can walk to
		
		local tbl = InutilLib.CreateGenericGridIndexTable()
		for k, v in pairs(InutilLib.CreateGenericGridIndexTable().emptySet) do
			--Isaac.DebugString(k, "  ", v)
			local gridData = {v, "hey"}
			table.insert(data.path, gridData)
			for k2, v2 in pairs(data.path) do
				Isaac.RenderText(v2[2], Isaac.WorldToScreen(v2[1]).X-10, Isaac.WorldToScreen(v2[1]).Y-10, 1 ,1 ,1 ,1 )
			end
		end
	end


	function InutilLib.IsGridPassable(index, ground, general, ignorePits, ignoreSpikes)
		room = InutilLib.room
		ground = ground or true --defaultly true
		general = general or true
		ignorePits = ignorePits or false
		local collision = room:GetGridCollision(index)
		if ground then
			if collision ~= 0 and (not ignorePits or collision ~= GridEntityType.GRID_PIT) then
				return false
			elseif not ignorePits then
				local grid = room:GetGridEntity(index)
				if grid and (grid.Desc.Type == GridEntityType.GRID_SPIKES or grid.Desc.Type == GridEntityType.GRID_SPIKES_ONOFF) and grid.State ~= 1 and not ignoreSpikes then
					return false
				end
			end
		end
		if general then
			if collision == GridCollisionClass.COLLISION_WALL or collision == GridCollisionClass.COLLISION_WALL_EXCEPT_PLAYER then
				return false
			end
		end
		--[[if room:GetGridEntity(index) then
			return false
		end]]
		return true
	end

	function InutilLib.GenerateAStarPath(ent, target, ignoreSpikes, render)
		ignoreSpikes = ignoreSpikes or false
		if target then
			local open = {}
			local closed = {}
			
			local gCost, hCost = 0, (target - ent):Length() 
			local fCost = gCost + math.abs(hCost)
			
			--set starting index as first index in node
			open[InutilLib.room:GetGridIndex(target)] = {InutilLib.room:GetGridIndex(target), fCost, nil} --partarget is nil
			
			--Isaac.DebugString("START")
			while TableLength(open) > 0 do
				local k, v
				local shortestDist = 999999999
				for key, value in pairs(open) do
					if value[2] < shortestDist then
						k = key
						v = value
						shortestDist = value[2] 
					end
				end
				
				local vPos = InutilLib.room:GetGridPosition(v[1])
				
				--if path has been found
				if v[1] == InutilLib.room:GetGridIndex(ent) then
					open[v[1]] = nil
					local gCost, hCost = (target - vPos):Length(), (ent - vPos):Length() 
					local fCost = math.abs(gCost) + math.abs(hCost)
					closed[v[1]] = {v[1], fCost, v[3]}
					
					if render then
						vPos = InutilLib.room:GetGridPosition(v[1])
						Isaac.RenderText(tostring(v[3]), Isaac.WorldToScreen(vPos).X-10, Isaac.WorldToScreen(vPos).Y-5, 1 ,1 ,1 ,1 )
					end
					return closed
				end
				
				--search block code
				
				for i = 1, 4 do --code that checks each four directions
					local angle = i-1
					local selectedGrid = InutilLib.room:GetGridIndex((vPos + Vector(0,0)) + Vector(45,0):Rotated(90*(angle))) --grids around the currtarget selected grid
					if not closed[selectedGrid] and InutilLib.IsGridPassable(selectedGrid, true, true, false, ignoreSpikes)  then --and not open[InutilLib.room:GetGridIndex(selectedGrid)] then --if grid is passable and not in closed table
						local gCost, hCost = (target - vPos):Length(), (ent - vPos):Length() 
						local fCost = math.abs(gCost) + math.abs(hCost)
						open[selectedGrid] =  {selectedGrid, fCost, v[1]}
						--Isaac.DebugString("searching")
					end
				end
					
				--remove from open list
				open[v[1]] = nil
				closed[v[1]] = {v[1], fCost, v[3]}
				
				if render then
					Isaac.RenderText(tostring((v[3])), Isaac.WorldToScreen(vPos).X-10, Isaac.WorldToScreen(vPos).Y-5, 1 ,1 ,1 ,1 )
					Isaac.RenderText("end", Isaac.WorldToScreen(InutilLib.room:GetGridPosition(InutilLib.room:GetGridIndex(ent))).X-10, Isaac.WorldToScreen(InutilLib.room:GetGridPosition(InutilLib.room:GetGridIndex(ent))).Y-10, 1 ,1 ,1 ,1 )
				end
			end
			--[[while TableLength(open) > 0 do
				local k, v
				local shortestDist = 999999999
				for key, value in pairs(open) do
					if value[2] < shortestDist then
						k = key
						v = value
					end
					--Isaac.DebugString(k)
					--Isaac.DebugString("crash")
					--Isaac.DebugString(v[1])
				end
					
					vPos = InutilLib.room:GetGridPosition(v[1])
					for i = 1, 4 do --code that checks each four directions
						local angle = i-1
						local selectedGrid = InutilLib.room:GetGridIndex((vPos + Vector(0,0)) + Vector(45,0):Rotated(90*(angle))) --grids around the currtarget selected grid
						--print(90*(i))
						if not closed[selectedGrid] and InutilLib.IsGridPassable(selectedGrid, true, true, false, ignoreSpikes) then --and not open[InutilLib.room:GetGridIndex(selectedGrid)] then --if grid is passable and not in closed table
							--if open[selectedGrid]  == nil then
							--Isaac.RenderText("pizza", Isaac.WorldToScreen(InutilLib.room:GetGridPosition(selectedGrid)).X-10, Isaac.WorldToScreen(InutilLib.room:GetGridPosition(selectedGrid)).Y-2, 1 ,1 ,1 ,1 )
							--Isaac.RenderText("0", Isaac.WorldToScreen(InutilLib.room:GetGridPosition(selectedGrid)).X, Isaac.WorldToScreen(InutilLib.room:GetGridPosition(selectedGrid)).Y, 1 ,1 ,1 ,1 )
							local gCost, hCost = (target - vPos):Length(), (ent - vPos):Length() 
							local fCost = math.abs(gCost) + math.abs(hCost)
							--table.insert(open, {selectedGrid, fCost, nil})
							open[selectedGrid] =  {selectedGrid, fCost, nil}
							Isaac.DebugString("searching")
						else
							--Isaac.RenderText("-1", Isaac.WorldToScreen(InutilLib.room:GetGridPosition(selectedGrid)).X, Isaac.WorldToScreen(InutilLib.room:GetGridPosition(selectedGrid)).Y, 1 ,1 ,1 ,1 )
						end
					end
					end
			
			]]
			--Isaac.DebugString("END")
			
			--for k, v in pairs(closed) do
			--	vPos = InutilLib.room:GetGridPosition(v[1])
			--	Isaac.RenderText("close", Isaac.WorldToScreen(vPos).X-10, Isaac.WorldToScreen(vPos).Y-15, 1 ,1 ,1 ,1 )
			--end
		else
			return nil
		end
	end

	function InutilLib.FollowPath(ent, target, path, vel, friction)
		friction = friction or 0.9
		
		if path then
		
			--local paths = {}
			
			local data = InutilLib.GetILIBData(ent)
			
			--make index as the parent of the current grid you are standing at
			if path[InutilLib.room:GetGridIndex(ent.Position)] then
				local index = path[InutilLib.room:GetGridIndex(ent.Position)][3]

				if index then
					local pos = InutilLib.room:GetGridPosition(index)
					ent.Velocity = ent.Velocity * friction + (pos - ent.Position):Resized(vel)
				end
			end
		else
			print("[ERR: Attempt to use FollowPath with no Path!]")
		end
		ent.Velocity = ent.Velocity * friction
	end


	---------------------------------
	-- SHOOT PROJECTILES FUNCTIONS --
	---------------------------------

	--credits to Lil Dumpy for this set of code
	function InutilLib.DumpySetCanShoot(Player, CanShoot)
	local OldChallenge=Game().Challenge
		Game().Challenge = CanShoot and 0 or 6
		Player:UpdateCanShoot()
		Game().Challenge = OldChallenge
	-- end
	end

	--Shoot Projectiles--
	--my custom fire projectile function, but a bit more limited to FireProjectile(). This feels more efficient than Isaac.Spawn though
	--[[ ent - entity, variant and subtype is the ent's... you know
		position - proj's position
		velocity - proj's movement
	]]
	function InutilLib.FireGenericProjAttack(ent, variant, subtype, position, velocity)
		local proj = Isaac.Spawn(9, variant, subtype, position, velocity, ent:ToNPC()):ToProjectile()
		proj.Parent = ent
		if ent:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
			local data  = ProjectileFlags.CANT_HIT_PLAYER | ProjectileFlags.HIT_ENEMIES
			proj.ProjectileFlags = proj.ProjectileFlags | data
		elseif ent:HasEntityFlags(EntityFlag.FLAG_CHARM) then
			local data = ProjectileFlags.CANT_HIT_PLAYER
			proj.ProjectileFlags = proj.ProjectileFlags | data
		end
		return proj
	end

	function InutilLib.MakeProjectileLob(tear, acc, height )
		local accel = accel or 1
		local heightTo = height or 13
		local data = InutilLib.GetILIBData( tear )
		if not data.LobInit then
			tear.FallingSpeed = (heightTo)*-1;
			tear.FallingAccel = accel;
			data.LobInit = true
		end
	end

	--Get Tear Size functions

	function InutilLib.GetTearSizeTypeI(scale, flags)
		local result
		if flags & TearFlags.TEAR_GROW == TearFlags.TEAR_GROW or flags & TearFlags.TEAR_LUDOVICO == TearFlags.TEAR_LUDOVICO then
			result = 13
		elseif scale < 0.30 then
			result = 1
		elseif scale < 0.55 then
			result = 2
		elseif scale < 0.675 then
			result = 3
		elseif scale < 0.80 then
			result = 4
		elseif scale < 0.925 then
			result = 5
		elseif scale < 1.05 then
			result = 6
		elseif scale < 1.175 then
			result = 7
		elseif scale < 1.425 then
			result = 8
		elseif scale < 1.675 then
			result = 9
		elseif scale < 1.975 then
			result = 10
		elseif scale < 2.175 then
			result = 11
		elseif scale < 2.55 then
			result = 12
		else
			result = 13
		end
		return result
	end


	function InutilLib.GetTearSizeTypeII(scale, flags)
		local result
		if flags & TearFlags.TEAR_GROW == TearFlags.TEAR_GROW or flags & TearFlags.TEAR_LUDOVICO == TearFlags.TEAR_LUDOVICO then
			result = 6
		elseif scale < 0.675 then
			result = 1
		elseif scale < 0.925 then
			result = 2
		elseif scale < 1.175 then
			result = 3
		elseif scale < 1.675 then
			result = 4
		elseif scale < 2.175 then
			result = 5
		else
			result = 6
		end
		return result
	end

	function InutilLib.GetCustomUserTearSize(scale, flags, ...) --not tested
		local result
		local frame = 1
		for k, v in ipairs({...}) do
			if scale < v then
				result = frame
				break
			end
			frame = (frame + 1) or 1
		end
		return result
	end

	function InutilLib.UpdateRegularTearAnimation(player, tear, data, flags, sizeCallback, animName)
		local lastLength, lastSize = data.lastLength, data.lastSize
		local Size, Length = sizeCallback, tear.Velocity:Length()
		local animName = animName or "RegularTear"
		
		if Size ~= lastSize then
			tear:GetSprite():Play(animName .. Size, true)
			tear:GetSprite():LoadGraphics();
		end

		data.lastLength = Length
		data.lastSize = Size
	end

	function InutilLib.UpdateDynamicTearAnimation(player, tear, data, flags, prefix, suffix, sizeCallback)

		local lastLength, lastSuffix, lastSize = data.lastLength or 0, data.lastSuffix or suffix[1], data.lastSize or 0
		local Size, Length, Suffix = sizeCallback, tear.Velocity:Length(), suffix
		
		--got this from taiga's rocket mod, it works a lot.
		if flags & TearFlags.TEAR_BOUNCE == TearFlags.TEAR_BOUNCE and tear:CollidesWithGrid() then
			Suffix = lastSuffix
		elseif flags & TearFlags.TEAR_LUDOVICO == TearFlags.TEAR_LUDOVICO and player:GetFireDirection() ~= Direction.NO_DIRECTION then
			Suffix = suffix[1]
		elseif math.abs(Length - lastLength) < 0.0001 then
			Suffix = lastSuffix
		elseif Length < lastLength then
			Suffix = suffix[2]
		elseif Length > lastLength then
			Suffix = suffix[1]
		else
			Suffix = lastSuffix
		end

		if Size ~= lastSize or Suffix ~= lastSuffix then
			tear:GetSprite():Play(prefix .. Size .. Suffix, true)
			tear:GetSprite():LoadGraphics();
		end

		data.lastLength = Length
		data.lastSuffix = Suffix
		data.lastSize = Size
	end

	function InutilLib.UpdateUserCustomTearAnimation(player, tear, data, flags, prefix, suffix, sizeCallback, dynamic) --not tested

		local lastLength, lastSuffix, lastSize = data.lastLength or 0, data.lastSuffix or suffix[1], data.lastSize or 0
		local Size, Length, Suffix = sizeCallback, tear.Velocity:Length(), suffix
		
		if dynamic == true then
			if flags & TearFlags.TEAR_BOUNCE ~= TearFlags.TEAR_BOUNCE and tear:CollidesWithGrid() then
				Suffix = lastSuffix
			elseif flags & TearFlags.TEAR_LUDOVICO ~= TearFlags.TEAR_LUDOVICO and player:GetFireDirection() ~= Direction.NO_DIRECTION then
				Suffix = suffix[1]
			elseif math.abs(Length - lastLength) < 0.0001 then
				Suffix = lastSuffix
			elseif Length < lastLength then
				Suffix = suffix[2]
			elseif Length > lastLength then
				Suffix = suffix[1]
			else
				Suffix = lastSuffix
			end
		end

		if Size ~= lastSize or Suffix ~= lastSuffix then
			if type(Suffix) =='string' then
				tear:GetSprite():Play(prefix .. Size .. Suffix)
			else
				tear:GetSprite():Play(prefix .. Size)
			end
		end

		data.lastLength = Length
		data.lastSuffix = Suffix
		data.lastSize = Size
	end

	function InutilLib.MakeTearLob(tear, acc, height )
		local accel = accel or 1
		local heightTo = height or 13
		local data = InutilLib.GetILIBData( tear )
		if not data.LobInit then
			tear.FallingSpeed = (heightTo)*-1;
			tear.FallingAcceleration = accel;
			data.LobInit = true
		end
	end


	--MC_POST_PLAYER_TEAR callback
	function InutilLib.OnPlayerTearInit(tear, player)
		local data = InutilLib.GetILIBData(tear)
		data.TearInit = true	
		--MC_POST_PLAYER_TEAR
		if ILIBCallbackData[ILIBCallbacks.MC_POST_PLAYER_TEAR] then
			for _, callbackData in ipairs(ILIBCallbackData[ILIBCallbacks.MC_POST_PLAYER_TEAR]) do
				if not callbackData.extraVariable or callbackData.extraVariable == tear.variant then
					callbackData.functionToCall(callbackData.modReference, tear, player)
				end
			end
		end
	end
	--[[
	InutilLib.AddCustomCallback(mod, ModCallbacks.MC_POST_FIRE_TEAR, function(_, tear)
		local data = InutilLib.GetILIBData(tear)
		if not data.TearInit then
			if tear.SpawnerType == 1 then
				local player = tear.Parent:ToPlayer()
				if player then
					InutilLib.OnPlayerTearInit(tear, player)
				end
			end
		end
	end)]]

	--MC_POST_INCUBUS_TEAR callback
	function InutilLib.OnIncubusTearInit(tear, fam)
		local data = InutilLib.GetILIBData(tear)
		--MC_POST_INCUBUS_TEAR
		if ILIBCallbackData[ILIBCallbacks.MC_POST_INCUBUS_TEAR] then
			for _, callbackData in ipairs(ILIBCallbackData[ILIBCallbacks.MC_POST_INCUBUS_TEAR]) do
				if not callbackData.extraVariable or callbackData.extraVariable == tear.variant then
					callbackData.functionToCall(callbackData.modReference, tear, fam)
				end
			end
		end
	end

	InutilLib.AddCustomCallback(mod, ModCallbacks.MC_POST_TEAR_RENDER, function(_, tear)
		local data = InutilLib.GetILIBData(tear)
		if not data.TearInit then
			local parent = tear.Parent
			local spawnerEnt = tear.SpawnerEntity
			--[[print("am i going insane??")
			print(parent.Type)
			print(spawnerEnt.Type)]]
			if spawnerEnt and spawnerEnt.Type == EntityType.ENTITY_FAMILIAR and spawnerEnt.Variant == FamiliarVariant.INCUBUS and not data.IsIncubusTear then
				data.IsIncubusTear = true
				local player = spawnerEnt:ToFamiliar().Player

				if player then
					InutilLib.OnPlayerTearInit(tear, player)
					InutilLib.OnIncubusTearInit(tear, spawnerEnt:ToFamiliar())
				end
			else
				if parent then
					local player = parent.Player
					InutilLib.OnPlayerTearInit(tear, player)
				end
			end
			data.TearInit = true
		end
	end)
	--FIRE KNIFE--

	--KNIFE MODES--
	--[[
	0 - stationary
	1 - fire once and go back
	2 - fire out and disappears
	3 - fire constantly
	]]
	SchoolbagKnifeMode = {
		STATIONARY = 0,
		FIRE_ONCE = 1,
		FIRE_OUT_ONLY = 2,
		FIRE_CONSTANTLY = 3
	}
	function InutilLib.SpawnKnife(player, vel, overwrite, var, mode, charge, range, entPos, independent)
		local spawner
		independent = independent or false
		if entPos then
			spawner = entPos-- or InutilLib:SpawnKnifeHelper(entPos, player, independent)
		else
			spawner = player
		end
		--InutilLib.SpawnKnife(Isaac.GetPlayer(0), Vector(0,10), false, 0, SchoolbagKnifeMode.FIRE_OUT_ONLY, 1, 120, fam)
		
		local knife
		if entPos then
			if spawner.incubus then
				knife = player:FireKnife(spawner.incubus, vel, false):ToKnife()
				knife.Parent = spawner.incubus
				InutilLib.GetILIBData(knife).CustomKnife = true
			else
				knife = player:FireKnife(spawner.player, vel, false):ToKnife()
				knife.Parent = spawner.player
				InutilLib.GetILIBData(knife).CustomKnife = true
			end
		else
			knife = player:FireKnife(spawner, vel, false):ToKnife()
			knife.Parent = spawner
		end
		--print(spawner.Type, "  ", knife.Parent.Type)
		--spawner:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		
		--local knife = Isaac.Spawn(EntityType.ENTITY_KNIFE, var, -1, player.Position, vel, player):ToKnife()
		
		local data = InutilLib.GetILIBData(knife)
		
		knife:Shoot(charge, range)
		data.charge = charge
		data.range = range
		data.mode = mode
		
		data.customBehavour = true
		
		if spawner.incubus then
			--print("hre"..knife.SpawnerEntity.SubType.."   "..knife.SpawnerEntity.Variant)
			if knife.Parent.Type ~= 8 and knife.Parent.SubType == 177 and InutilLib.GetILIBData(knife).CustomKnife then--if (spawner.incubus.Variant == 80 and spawner.incubus.SubType == 177) then
				local helperData = InutilLib.GetILIBData(spawner.incubus)
				if helperData.KnifeHelper then --if incubus
					if not helperData.KnifeTable or TableLength(helperData.KnifeTable) == 0 then 
						helperData.KnifeTable = {} --add first
					end
					--if data.customBehavour then
						table.insert(helperData.KnifeTable, knife)
					--end
				end
			else
				knife:Remove()
				
				--knife.Position = knife.Parent.Position
			end
		end
		return knife
	end

	--KNIFE STATES--
	-- 0 - stationary
	-- 1 - launching
	-- 2 - retracting
	mod:AddCallback(ModCallbacks.MC_POST_KNIFE_UPDATE, function(_, kn)
		local data = InutilLib.GetILIBData(kn)
		if kn.FrameCount == 1 then
			data.state = -1
			data.refreshStateFrame = 0
			data.lastVel = kn:GetKnifeVelocity()
			data.lastState = nil
		end
		--print(data.state, "state")
		if kn:GetKnifeVelocity() > 0 then
			data.lastState = data.state
			data.state = 1
		elseif kn:GetKnifeVelocity() < 0 and data.state == 1 then
			data.lastState = data.state
			data.state = 2
			data.refreshStateFrame = kn.FrameCount
		elseif kn:GetKnifeDistance() == 0 and data.state == 2 then
			data.lastState = data.state
			data.state = 0
		end
		data.lastVel = kn:GetKnifeVelocity()
		
		--print(data.state, "  ", kn:GetKnifeDistance())
		if data.mode == SchoolbagKnifeMode.FIRE_ONCE then
			if kn.FrameCount > 1 and data.state == 0 then
				kn:Remove()
			end
		elseif data.mode == SchoolbagKnifeMode.FIRE_OUT_ONLY then
			if data.state == 2 then
				kn:Remove()
			end
		elseif data.mode == SchoolbagKnifeMode.FIRE_CONSTANTLY then
			if kn.FrameCount > 1 and data.state == 0 then
				kn:Shoot(data.charge, data.range)
			end
		end
	end)

	-- Can be used for other things other than knifes in the future, dont worry
	function InutilLib:NewRoom()
		for i,kn in ipairs(InutilLib.roomKnives) do
			if InutilLib.GetILIBData(kn).customBehavour == true then
				kn:Remove()
			end
		end
	end
	mod:AddCallback( ModCallbacks.MC_POST_NEW_ROOM, InutilLib.NewRoom)

	--im_tem credits
	function InutilLib:SpawnCustomStrawman(PlayerType, Player, Parented)
		Parented = Parented or false
		PlayerType=PlayerType or 0
		Player = Player or Isaac.GetPlayer(0)
		ControllerIndex=Player.ControllerIndex or 0
		local LastPlayerIndex=InutilLib.game:GetNumPlayers()-1
		if LastPlayerIndex>=63 then return nil else
			Isaac.ExecuteCommand('addplayer '..PlayerType..' '..ControllerIndex)	--spawn the dude
			local Strawman=Isaac.GetPlayer(LastPlayerIndex+1)
			if Parented then
				Strawman.Parent=Player		--required for strawman hud
				Game():GetHUD():AssignPlayerHUDs()
			end
			return Strawman
		end
	end

	function InutilLib:GetKnifePlayer() --independent knife player manager
		local knifeHelper = nil
		for p = 0, InutilLib.game:GetNumPlayers() - 1 do
			local player = Isaac.GetPlayer(p)
			if InutilLib.GetILIBData(player).Knife then
				knifeHelper = player
				break
			end
		end
		if knifeHelper == nil then
			local knife = Isaac.GetPlayerTypeByName("KnifeHelper")
			knifeHelper = InutilLib:SpawnCustomStrawman(10, nil, true)
			InutilLib.GetILIBData(knifeHelper).Knife = true
			InutilLib.DumpySetCanShoot(knifeHelper, false)
			knifeHelper:AddCollectible(CollectibleType.COLLECTIBLE_MOMS_KNIFE)
			--knifeHelper.Position = Isaac.GetPlayer(0)
			knifeHelper.GridCollisionClass = GridCollisionClass.COLLISION_NONE;
			knifeHelper.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE;
			knifeHelper.Visible = false
		end
		return knifeHelper
	end

	function InutilLib:SpawnKnifeHelper(position, player, independent)
		local given = {}
		if independent then
			player = InutilLib:GetKnifePlayer()
		end
		local incubus = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.INCUBUS, 177, position.Position, Vector(0,0), player)
		--incubus:ClearEntityFlags(EntityFlag.FLAG_APPEAR )
		InutilLib.GetILIBData(incubus).KnifeHelper = true
		given.incubus = incubus
		given.player = player
		return given
	end

	mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, function(_,  fam)
		local data = InutilLib.GetILIBData(fam)
		if fam.SubType == 177 then
			fam:GetSprite():ReplaceSpritesheet(0, "gfx/invis_incubus.png")
			fam:GetSprite():ReplaceSpritesheet(1, "gfx/invis_incubus.png")
			fam:GetSprite():ReplaceSpritesheet(2, "gfx/invis_incubus.png")
			fam:GetSprite():LoadGraphics()
			fam.Visible = false
		end
	end, FamiliarVariant.INCUBUS)

	--currently having too much knives makes it panic and not die
	mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_,  fam)	
		local data = InutilLib.GetILIBData(fam)
		
		local function RemoveParent()
			if InutilLib.GetILIBData(fam.Player).Knife then
				fam.Player:Kill()
			end
		end
		
		if fam.SubType == 177 and fam.FrameCount > 1 then
			local spr = fam:GetSprite()
			--keep it still, might be laggy but i have no better idea to keep it still
			fam.Velocity = Vector(0,0)
			
			--if not data.KnifeTable then data.KnifeTable = {} end
			if data.KnifeTable then
				for i, something in pairs(data.KnifeTable) do 
					--data.KnifeTable[i]:SetColor(Color(0,0,0,0.7,170,170,210), 999, 999)
					--print(data.KnifeTable[i].SpawnerEntity)
					if not data.KnifeTable[i]:Exists() or not InutilLib.GetILIBData(data.KnifeTable[i]).CustomKnife then
					--	data.KnifeTable[i]:Remove()
						table.remove(data.KnifeTable, i)
					end
				end
				if TableLength(data.KnifeTable) == 0 then
					fam:Remove()
					RemoveParent()
				end
				--print(TableLength(data.KnifeTable))
			else
				fam:Remove()
				RemoveParent()
			end
		end
	end, FamiliarVariant.INCUBUS);


	---- Custom Plyaer Knife Helper Stuff ----
	do
	mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function(_,  pl)
		local data = InutilLib.GetILIBData(pl)
		if data.Knife then
			pl.Position = Isaac.GetPlayer(0).Position
			--if OPTIONS.CUSTOM_DEATH_SOUND == true then
				if pl:IsDead() and (pl:GetSprite():IsPlaying("LostDeath") or pl:GetSprite():IsPlaying("Death")) then
					if pl:GetSprite():GetFrame() == 0 then
						pl.Visible = false
					end
					if pl:GetSprite():GetFrame() == 8 and not wasPlayerDead then
						SFXManager():Stop(SoundEffect.SOUND_ISAACDIES);

						--speaker:Play(OPTIONS.CUSTOM_DEATH_SOUND_ID, 1, 0, false, OPTIONS.CUSTOM_DEATH_SOUND_PITCH);
					end
				end
				wasPlayerDead = isPlayerDead;
			--end
		end
	end);

	function InutilLib:KnifeHelperInput(entity, inputHook, buttonAction)
		for j = 1, Game():GetNumPlayers() do
			local player = Isaac.GetPlayer(j-1)
			if entity ~= nil and entity.Index == player.Index then
				if InutilLib.GetILIBData(entity).Knife then --checks if its the knife handler
					if inputHook == InputHook.GET_ACTION_VALUE then
						if buttonAction == ButtonAction.ACTION_BOMB then 
							return false
						end
					end
				end
			end
		end
	end
	mod:AddCallback(ModCallbacks.MC_INPUT_ACTION , InutilLib.KnifeHelperInput)

	--stop pickup
	mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, function(_, pickup, pl)
		if pl and pl.Type == EntityType.ENTITY_PLAYER then
			pl:ToPlayer()
			local data = InutilLib.GetILIBData(pl)
			if data.Knife then
				return false
			end
		end
	end, pl, -1)

	end
	InutilLib.PSEUDO_CLONE = 180
	--taken from epiphany, all thanks to CBTBSD!
	function InutilLib.GetPseudoCloneCount(player)
		local pdata = player:GetData()
		pdata.PsuedoCloneAmount = 0
		return pdata.PsuedoCloneAmount
	end

	--[[local function updatepesudoClones(_, player, flags)
		if flags & CacheFlag.CACHE_FAMILIARS == CacheFlag.CACHE_FAMILIARS then
			--replace clones with actual incubi
			for _, ent in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLOOD_BABY, 180)) do
				if ent:Exists() then
					local inc = Isaac.Spawn( ent.Type, ent.Variant, 0, player.Position,  Vector(0,0), ent.SpawnerEntity ):ToFamiliar()
					inc.Player = player
					inc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
					ent:Remove()
				end
			end
			--spawn
			
			if InutilLib.GetPseudoCloneCount(player) > 0 then
				for index = 0, InutilLib.GetPseudoCloneCount(player) do
					local clone = Isaac.Spawn( EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLOOD_BABY, 180, player.Position,  Vector(0,0), player ):ToFamiliar()
					clone.Player = player
				end
			end
			
		end
	end
	mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, updatepesudoClones)]]

	--this might be the update multiplier?
	--[[function InutilLib.spawnpseudoClones(_, player)
		local fullAmount = InutilLib.GetPseudoCloneCount(player) + player:GetCollectibleCount(CollectibleType.COLLECTIBLE_INCUBUS)
			local pdata = player:GetData()
			if fullAmount - InutilLib.GetPseudoCloneCount(player) - 1 > 0 then
				player:CheckFamiliar(FamiliarVariant.BLOOD_BABY, player:GetCollectibleCount(CollectibleType.COLLECTIBLE_INCUBUS) - 1, RNG(), nil, 0)
			end
			if InutilLib.GetPseudoCloneCount(player) > 0 and not player:IsDead() then
				--returnVal = Isaac.Spawn( EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLOOD_BABY, InutilLib.PSEUDO_CLONE, player.Position,  Vector(0,0), player );
				
				--player:CheckFamiliar(FamiliarVariant.BLOOD_BABY, InutilLib.GetPseudoCloneCount(player), RNG(), nil, InutilLib.PSEUDO_CLONE)
				
				--print(fam.Type)
				--local index = 0
				--for _, ent in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLOOD_BABY InutilLib.PSEUDO_CLONE)) do
				--	local shadow = ent:ToFamiliar()
					--if GetPtrHash(shadow.Player) == GetPtrHash(player) then
					--	shadow:GetData().TRJCloneIndex = index
					--	shadow:GetData().TRJCloneIndex = index
					--	index = index + 1
					--end
				--end
			end
	end
	mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, InutilLib.spawnpseudoClones)]]

	local function initpesudoClone(_, familiar)
		if familiar.SubType == InutilLib.PSEUDO_CLONE then
			familiar:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			if Sewn_API then
				familiar:GetData().Sewn_noUpgrade = Sewn_API.Enums.NoUpgrade.ANY
			end
		end
	end
	mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, initpesudoClone, FamiliarVariant.BLOOD_BABY)

	local function updatepesudoClone(_, familiar)
		if familiar.SubType == InutilLib.PSEUDO_CLONE then
			--familiar.DepthOffset = 10
			--familiar:RemoveFromFollowers()
			local player = familiar.Player
			local pdata = InutilLib.GetILIBData( player )
			--local angle = 2 * math.pi * (familiar:GetData().TRJCloneIndex + 1) / (Mod_Judas.GetJudasCloneCount(player))
			--local mat_x = Vector(math.cos(angle),-math.sin(angle))
			--local mat_y = Vector(math.sin(angle),math.cos(angle))
			--local target_position = player.Position + pdata["JUDAS_DESCENT_TARGET_POSITION"] + Vector(Mod:vecDot(mat_x,vecdiff),Mod:vecDot(mat_y,vecdiff))
			--familiar.Position = target_position
			--familiar.Velocity = player.Velocity * 2.55
		end
	end
	mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, updatepesudoClone, FamiliarVariant.BLOOD_BABY)

	local skip = nil
	local function handlepseudocloneDamage(_, ent, amount, flags, source, countdown)
		if skip and GetPtrHash(skip) == GetPtrHash(ent) then return end
		if not source then return end
		if not source.Entity then return end

		local srcent = source.Entity
		local spawner = srcent.SpawnerEntity
		if (srcent.Type == EntityType.ENTITY_FAMILIAR and srcent.Variant == FamiliarVariant.BLOOD_BABY and srcent.SubType == InutilLib.PSEUDO_CLONE) or (spawner and (spawner.Type == EntityType.ENTITY_FAMILIAR and spawner.Variant == FamiliarVariant.BLOOD_BABY and spawner.SubType == InutilLib.PSEUDO_CLONE)) then
			local player = nil
			local multi = 1
			if spawner and spawner:ToFamiliar() and spawner:ToFamiliar().Player then
				player = spawner:ToFamiliar().Player
			elseif srcent:ToFamiliar() and srcent:ToFamiliar().Player then
				player = srcent:ToFamiliar().Player
			end
			--if player and isJudas(player:ToPlayer():GetPlayerType()) then
			--	multi = player:GetData()["JUDAS_DESCENT_DAMAGE_MULTIPLIER"]
			--end

			skip = ent
			ent:TakeDamage(amount * (1 / 0.75) * multi, flags, source, countdown)
			skip = nil
			return false
		end
	end
	mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, handlepseudocloneDamage)

	--local shadowSprite = Sprite()
	--shadowSprite:Load("gfx/characters/corrupted_judas_1.anm2", true)
	local function handlepesudocloneVisual(_, familiar, offset)
		if familiar.SubType ~= InutilLib.PSEUDO_CLONE then return end
		local player = familiar.Player
		if not player or player:IsDead() then return end
		familiar:GetSprite().Color = Color(0, 0, 0, 0)

		--[[local originalShadowOpacity = math.max(0.2, math.min(0.6, player:GetData()["JUDAS_DESCENT_DAMAGE_MULTIPLIER"]))
		local shadowOpacity = originalShadowOpacity+(math.random()-0.5)*0.5 * (originalShadowOpacity/0.7)
		shadowSprite.Color = Color(0, 0, 0, shadowOpacity)]]
		local render_pos = familiar.Position + Vector(0,5)
		if InutilLib.room:IsMirrorWorld() then --Vector(2*ScreenHelper.GetScreenCenter().X-render_pos.X,render_pos.Y)
			--render_pos = Vector(2*ScreenHelper.GetScreenCenter().X-render_pos.X,render_pos.Y)
			player.FlipX = (not player.FlipX)
		end
		if not familiar:GetData().DontRender then
			local sprite = player:GetSprite()
			player.Visible = true
			player:GetSprite():Render(Isaac.WorldToScreen(render_pos), Vector.Zero, Vector.Zero)
			--player:Render((Isaac.ScreenToWorld(Player.Position)))
			player:RenderGlow(Isaac.WorldToScreen(render_pos))
			player:RenderBody(Isaac.WorldToScreen(render_pos))
			player:RenderHead(Isaac.WorldToScreen(render_pos))
			player:RenderTop(Isaac.WorldToScreen(render_pos))
			--shadowSprite:SetFrame(sprite:GetAnimation(), sprite:GetFrame())
			--shadowSprite:SetOverlayFrame(sprite:GetOverlayAnimation(), sprite:GetOverlayFrame())
		end
	end
	mod:AddCallback(ModCallbacks.MC_POST_FAMILIAR_RENDER, handlepesudocloneVisual, FamiliarVariant.BLOOD_BABY)

	local function explodepsuedoClones(_, ent)
		local player = ent:ToPlayer()
		--if not player or not Mod_Judas.isJudas(player:GetPlayerType()) then return end

		for _, ent in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLOOD_BABY, InutilLib.PSEUDO_CLONE)) do
			local shadow = ent:ToFamiliar()
			if GetPtrHash(shadow.Player) == GetPtrHash(player) then
				--DescentEffect(shadow.Position, shadow:GetSprite().Scale)
				shadow:Remove()
			end
			
		end

		SFXManager():Play(SoundEffect.SOUND_BLACK_POOF)
		InutilLib.game:ShakeScreen(15)
	end
	mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, explodepsuedoClones, EntityType.ENTITY_PLAYER)

	local function handleTearVisual(_, tear)
		if not tear.SpawnerEntity then return end
		if not (tear.SpawnerEntity.Type == EntityType.ENTITY_FAMILIAR and tear.SpawnerEntity.Variant == FamiliarVariant.BLOOD_BABY and tear.SpawnerEntity.SubType == InutilLib.PSEUDO_CLONE) then return end
		--local shadowTearOpacity = math.max(0.4, math.min(0.8, tear.SpawnerEntity:ToFamiliar().Player:GetData()["JUDAS_DESCENT_DAMAGE_MULTIPLIER"]))+(math.random()-0.5)*0.3
		--tear.Color = Color(0, 0, 0, shadowTearOpacity)
		if tear:GetData().TRJShaded then return end
		tear.Scale = tear.Scale * 1.0666666666
		tear:GetData().TRJShaded = true
	end
	mod:AddCallback(ModCallbacks.MC_POST_TEAR_RENDER, handleTearVisual)

	local function handleLaserVisual(_, laser)
		if not laser.SpawnerEntity then return end
		if not (laser.SpawnerEntity.Type == EntityType.ENTITY_FAMILIAR and laser.SpawnerEntity.Variant == FamiliarVariant.BLOOD_BABY and laser.SpawnerEntity.SubType == InutilLib.PSEUDO_CLONE) then return end
		--laser.Color = Color(0, 0, 0, laser.SpawnerEntity:ToFamiliar().Player:GetData()["JUDAS_DESCENT_DAMAGE_MULTIPLIER"])
		if laser:GetData().TRJShaded then return end
		laser.SpriteScale = laser.SpriteScale * 2
		laser.Radius = laser.Radius * 1.33333333
		laser:GetData().TRJShaded = true
	end
	mod:AddCallback(ModCallbacks.MC_POST_LASER_RENDER, handleLaserVisual)

	local function handleKnifeVisual(_, knife)
		if not knife.SpawnerEntity then return end
		if not (knife.SpawnerEntity.Type == EntityType.ENTITY_FAMILIAR and knife.SpawnerEntity.Variant == FamiliarVariant.BLOOD_BABY and knife.SpawnerEntity.SubType == InutilLib.PSEUDO_CLONE) then return end
		--knife.Color = Color(0, 0, 0, knife.SpawnerEntity:ToFamiliar().Player:GetData()["JUDAS_DESCENT_DAMAGE_MULTIPLIER"])
		knife.SpriteScale = Vector(1, 1)
	end
	mod:AddCallback(ModCallbacks.MC_POST_KNIFE_UPDATE, handleKnifeVisual)

	mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, damage, amount, damageFlag, damageSource, damageCountdownFrames) 
		if damage.Variant == FamiliarVariant.BLOOD_BABY and damage.SubType == InutilLib.PSEUDO_CLONE then
			return false
		end
	end, EntityType.ENTITY_FAMILIAR)


	--yare yare, i hate this work around but i have to remove the smoke spawn without removing flag appear, as flag appear seems to break the knives
	mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, function(_,  eff)--, var, subt, pos, vel, spawner, seed)
		--print(eff,"  ",var,"  ",subt, "  ", spawner)
		if eff.Variant == 15  then
			for i, e in ipairs(InutilLib.roomFamiliars) do
				if e.Variant == 80 and e.SubType == 177 then
					if eff.Position:Distance(e.Position) <= 50 then
						eff:Remove()
					end
				end
			end
		end
	end)
	mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, function(_,  fam)--, var, subt, pos, vel, spawner, seed)
		--print(eff,"  ",var,"  ",subt, "  ", spawner)
		if fam.SubType == 177 then
			for i, e in pairs(Isaac.GetRoomEntities()) do
				if e.Variant == 1000 and e.Variant == 15 then
					if e.Position:Distance(fam.Position) <= 50 and e.FrameCount <= 1 then
						e.Visible = false
						e:Remove()
					end
				end
			end
		end
	end, FamiliarVariant.INCUBUS)

	--this is legacy
	function InutilLib.UpdateLaserSize(laser, size, withMultiplier)
		--if withMultiplier == nil then withMultiplier = true end
		local data = InutilLib.GetILIBData(laser)
		data.isSchoolbagModified = true
		data.size = size
		--data.withMultiplier = withMultiplier
	end

	function InutilLib.UpdateRepLaserSize(laser, size, withMultiplier)
		--if withMultiplier == nil then withMultiplier = true end
		local data = InutilLib.GetILIBData(laser)
		data.isInutilLibModified = true
		data.size = size
		--data.withMultiplier = withMultiplier
	end

	function InutilLib.UpdateBrimstoneDamage(laser, dmg)
		--if withMultiplier == nil then withMultiplier = true end
		local data = InutilLib.GetILIBData(laser)
		data.BrimstoneDamage = dmg
	end


	mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, damage, amount, damageFlag, damageSource, damageCountdownFrames) 
		local data = InutilLib.GetILIBData( damage ) 
		local laser
		if damageSource.Type == 7 then
			laser = damageSource.Entity:ToLaser()
		elseif damageSource.Entity and damageSource.Entity.SpawnerEntity and damageSource.Entity.SpawnerEntity.Type == 7 then
			laser = damageSource.Entity.SpawnerEntity:ToLaser()
		end
		if laser and not data.DontTakeLoopBrimDmg and InutilLib.GetILIBData(laser).BrimstoneDamage then
			data.DontTakeLoopBrimDmg = true
			damage:TakeDamage(InutilLib.GetILIBData(laser).BrimstoneDamage, damageFlag, damageSource, damageCountdownFrames)
			data.DontTakeLoopBrimDmg = nil
		end
	end)


	mod:AddCallback(ModCallbacks.MC_POST_LASER_UPDATE, function(_, lz)
		local data = InutilLib.GetILIBData(lz)

		if lz.FrameCount == 0 then data.isSchoolbagModified = false end
		--print(data.isSchoolbagModified)
		if data.isSchoolbagModified == true then --lil dumpy, thanks SO MUCH MAN
			local scale = data.size
			--for k,v in pairs(Isaac.FindByType(7)) do
			if not data.withMultiplier then
				lz.Size = scale
			else
				lz.Size = 16 * scale
				lz:GetSprite().Scale=Vector(scale,scale)
			end
			lz:Update()
			--end
			data.isSchoolbagModified = false --some reason you need to set this because other lasers get affected
		end
		if data.BrimstoneDamage then
			lz.CollisionDamage = data.BrimstoneDamage
		end
		if data.isInutilLibModified == true then --lil dumpy, thanks SO MUCH MAN
			local scale = data.size
			--for k,v in pairs(Isaac.FindByType(7)) do
			if not data.withMultiplier then
				lz.Size = scale
			else
				lz.Size = 16 * scale
				--lz:GetSprite().Scale=Vector(scale,scale)
			end

			--lz:Update()
			if lz.Size < 6 then
				lz:GetSprite():Play("Laser0", true)
			elseif lz.Size <= 11 then
				lz:GetSprite():Play("Laser1", true)
			elseif lz.Size <= 20 then
				lz:GetSprite():Play("Laser2", true)
			else
				lz:GetSprite():Play("Laser3", true)
			end
			--end
			data.isInutilLibModified = false --some reason you need to set this because other lasers get affected
		end
	end)


	--[[function REVEL.CollidesWithLine(position, lineStart, lineEnd, lineWidth)
		return lineStart:Distance(position) + lineEnd:Distance(position) - lineStart:Distance(lineEnd) < lineWidth
	end]]

	--attributed to Cucco
	function InutilLib.CuccoLaserCollision(laser, angle, length, target, lineWidth)
		--= It's recommended to pass these 2 attributes to save a big chunk of performance.
		angle = angle or (laser.Angle % 360)
		length = length or (laser.EndPoint - laser.Position):Length()
		lineWidth = lineWidth or 1
		
		--= Check if the laser collided with an enemy.
		local eVec = (target.Position - laser.Position):Rotated(-angle)
		local absY = eVec.Y < 0 and eVec.Y * -1 or eVec.Y
		
		if (eVec.X >= 0 and eVec.X <= length) and absY <= target.Size + lineWidth then
			return true
		else
			return false
		end
	end

	function InutilLib.CuccoLaserCollisionToGrid(laser, angle, length, target, lineWidth)
		--= It's recommended to pass these 2 attributes to save a big chunk of performance.
		angle = angle or (laser.Angle % 360)
		length = length or (laser.EndPoint - laser.Position):Length()
		lineWidth = lineWidth or 1
		
		--= Check if the laser collided with an enemy.
		local eVec = (target.Position - laser.Position):Rotated(-angle)
		local absY = eVec.Y < 0 and eVec.Y * -1 or eVec.Y
		
		if (eVec.X >= 0 and eVec.X <= length) and absY <= 40 + lineWidth then
			return true
		else
			return false
		end
	end

	--BOMB Stuff
	function InutilLib.MakeBombLob(tear, acc, height, tim )
		local accel = acc or 4
		local heightTo = height or 13
		local data = InutilLib.GetILIBData( tear )
		local times = tim or 1
		if not data.gravityData then data.gravityData = {} end
		
		local gravityData = data.gravityData
		if not data.LobInit then
			if not gravityData.Init then
				gravityData.InAirSpan = heightTo --this tells how long does it take for bomb is to be in air
				--gravityData.ZOffsetVector = Vector(0,0) --tells how high the sprite is supposed to be
				gravityData.AccelAddFloat = accel --tells how fast bomb is going to go up and down
				gravityData.ZOffsetFloat = gravityData.AccelAddFloat*((gravityData.InAirSpan/2)-1) --tells how high sprite is with a number, not a vector
				gravityData.AirSpanMultiply = 1 --tells how fast the current air span should be going
				gravityData.Init = true
				gravityData.ZProduct = 0 -- the y that tells how high something should be
				
				if not data.CurrentAirSpan then data.CurrentAirSpan = 0 end
			end
			data.LobTimes = times
			data.LobInit = true
		end

	end

	mod:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE, function(_, bb)
		local data = InutilLib.GetILIBData( bb )
		if data.LobInit then
			local gravityData = data.gravityData
			
			data.CurrentAirSpan = data.CurrentAirSpan + (1*gravityData.AirSpanMultiply) --adds up special frame for how long they are in midair
			--arc code
			if data.CurrentAirSpan <= ((gravityData.InAirSpan/2)-1) then --if in the first half of the arc
				--gravityData.ZOffsetVector = gravityData.ZOffsetVector + Vector(0,-(gravityData.AccelAddFloat))
				if not gravityData.InitialPoint then gravityData.InitialPoint = gravityData.ZOffsetFloat ^ 2 end
				gravityData.ZOffsetFloat = gravityData.ZOffsetFloat - gravityData.AccelAddFloat 
				gravityData.ZProduct = gravityData.ZOffsetFloat ^ 2
			end
			if data.CurrentAirSpan >= ((gravityData.InAirSpan/2)+1) and data.CurrentAirSpan < gravityData.InAirSpan then --if in the other half of the arc
				--gravityData.ZOffsetVector = gravityData.ZOffsetVector - Vector(0,-(gravityData.AccelAddFloat))
				gravityData.ZOffsetFloat = gravityData.ZOffsetFloat + gravityData.AccelAddFloat 
				gravityData.ZProduct = gravityData.ZOffsetFloat ^ 2
			end
			if data.CurrentAirSpan >= gravityData.InAirSpan then --if finished being in midair
				data.CurrentAirSpan = 0
				if data.LobTimes == 1 then 
					data.LobInit = false
				else
					data.LobTimes = data.LobTimes - 1
				end
			end
		
			bb.SpriteOffset = Vector(0,(gravityData.ZProduct)-gravityData.InitialPoint) --gravityData.ZOffsetVector
		end
	end)

	--originally from Revelations, I found this in discord while seraching. not mine
	local animSets = {
		Blood = {},
		SmallBlood = {},
		BigBlood = {},
		BiggestBlood = {}
	}

	for k, tbl in pairs(animSets) do
		for i = 1, 6 do
			animSets[k][i] = k .. "0" .. tostring(i)
		end
	end

	function InutilLib.RevelSetCreepData(npc)
		local data = InutilLib.GetILIBData(npc)
		for _, animSet in pairs(animSets) do
			for i, anim in ipairs(animSet) do
				if npc:GetSprite():IsPlaying(anim) or npc:GetSprite():IsFinished(anim) then
					data.Animation = "0" .. tostring(i)
					break
				end
			end
		end

	data.OriginalSize = npc.Size
	data.RelativeSpriteScale = npc.SpriteScale / npc.Size
	end

	function InutilLib.RevelUpdateCreepSize(creep, size, shouldChangeAnim)
		local data, sprite = InutilLib.GetILIBData(creep), creep:GetSprite()
		if data.OriginalSize and data.RelativeSpriteScale and data.Animation then
			local scale = data.RelativeSpriteScale * size
			if shouldChangeAnim then
				local originalFrame = sprite:GetFrame()
				local anim
				if size <= data.OriginalSize / 2 then
					scale = scale * 2
					anim = "SmallBlood" .. data.Animation
				elseif size >= data.OriginalSize * 4 then
					scale = scale / 4
					anim = "BiggestBlood" .. data.Animation
				elseif size >= data.OriginalSize * 2 then
					scale = scale / 2
					anim = "BigBlood" .. data.Animation
				else
					anim = "Blood" .. data.Animation
				end

				sprite:Play(anim, true)
				if originalFrame > 0 then
					for i = 1, originalFrame do
						sprite:Update()
					end
				end
			end

			creep.SpriteScale = scale
			creep.Size = size
		end
	end

	--Fire rockets
	--inspired from epic fetus synergies mod
	function InutilLib.spawnEpicRocket(player, pos, friendly, delay)
		local del = delay or 10
		local rocket = Isaac.Spawn(1000, 31, 0, pos, Vector.Zero, player):ToEffect()
		rocket:SetTimeout(del)
		rocket:Update()
		if friendly then
			InutilLib.GetILIBData(rocket).NoHarm = true
		end
		return rocket
	end

	mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, damage, amount, damageFlag, damageSource, damageCountdownFrames) --invincibilityframe when dashing or whatnot
		local player = damage:ToPlayer();
		if player then
			local data = InutilLib.GetILIBData(player)
			if damageSource.Entity and InutilLib.GetILIBData(damageSource.Entity).NoHarm then return false end
		end
	end)

	-----------------------
	-- DOUBLE TAP SYSTEM --
	-----------------------
	--Originally from yatboim, this class-oriented system allows for double-tap detection in the game.

	local DOUBLE_TAP_ANGLE_ROUNDING = 1

	-- double tap class for handling vector based double taps (movement, shooting)
		InutilLib.DoubleTap = {};
		function InutilLib.DoubleTap:New(o)
			o = o or {};
			o.callbacks = {};
			o.lastVector = Vector( 0, 0 );
			o.lastFrame = 0;
			o.lastActivationFrame = 0;
			o.active = false;
			o.angleThreshold = 15;
			o.inputFrameThreshold = 6;
			o.minimumVectorLength = 0.05;
			o.onRelease = false;
			o.cooldown = 15;
			-- if the double tap was activated this many frames or less before the cooldown was over, queue one up with a timer
			o.leniency = 3;
			
			--local playerInfo = o
			
			setmetatable(o,self);
			self.__index = self;
			return o;
		end

		function InutilLib.DoubleTap:AttachCallback( func )
			table.insert(self.callbacks, func);
			--print(#self.callbacks)
		end

		function InutilLib.DoubleTap:Reset()
			self.lastFrame = 0;
			self.lastActivationFrame = 0;
			self.lastVector = Vector(0,0);
			self.active = false;
			self.cooldown = 15;
		end

		function InutilLib.DoubleTap:Update( vector , player )
			if DOUBLE_TAP_ANGLE_ROUNDING >= 1 then
				local currentAngle = vector:GetAngleDegrees();
				local targetAngle = InutilLib.RoundToNearestMultiple( currentAngle, DOUBLE_TAP_ANGLE_ROUNDING );
				vector = vector:Rotated( targetAngle - currentAngle );
			end
			local vectorAngleDegrees = vector:GetAngleDegrees();
			local vectorLength = vector:Length();
			-- Used for timing differences
			local gameFrame = Game():GetFrameCount();

			-- If the movement Vector is smaller than the minimum required length consider the player not moving
			if vectorLength < self.minimumVectorLength then
				-- If we were moving last frame and double tap on release is true then store the current frame as the last frame of movement
				if self.active == true and self.onRelease == true then
					self.lastFrame = gameFrame;
				end
				self.active = false;
			-- If the movement vector is greater than or equal to the minimum required length consider the player moving
			elseif vectorLength >= self.minimumVectorLength then
				-- If the player wasn't moving before and the input frame threshold hasn't been exceeded
				if self.active == false and gameFrame - (self.lastFrame or 0) <= self.inputFrameThreshold then
					local DEG_TO_RAD = InutilLib.DEG_TO_RAD
					local angleDifference = InutilLib.AngleDifference( self.lastVector:GetAngleDegrees()*DEG_TO_RAD, vectorAngleDegrees*DEG_TO_RAD);
					-- If the difference between the last movement angle and the attempted dash direction is within the acceptable threshold
					if math.abs(angleDifference) <= self.angleThreshold * DEG_TO_RAD then
						-- If the cooldown is not active
						if gameFrame - (self.lastActivationFrame or 0) > self.cooldown then
							-- Dash
							for j=1,#self.callbacks,1 do
								self.callbacks[j](vector, player); --NOTE TO FUTURE KAKAO, YOU COULD PUT player BOTH IN THIS PARAM AND THE BEGINNING OF THIS METHOD IF YOU WANT TO TAKE AND GIVE THE PROPER PLAYER. NO NEED TO THANK ME LOL, GET YOUR CONTROLLER ALREADY.
							end --RESPONSE TO KAKAO, THIS IS JUDE NOW BUT THANKS, THIS BECAME SO HANDY MAN, THX
							self.lastActivationFrame = gameFrame;
						-- If the cooldown was active but within leniency
						elseif gameFrame - (self.lastActivationFrame or 0) > self.cooldown - self.leniency then
							local framesUntilCooled = math.abs(gameFrame - (self.lastActivationFrame or 0) - self.cooldown);
							InutilLib.SetTimer( framesUntilCooled, function()
								for j=1,#self.callbacks,1 do
									self.callbacks[j](vector, player);
								end
							end);
							self.lastActivationFrame = gameFrame + framesUntilCooled;
						end
					end
				end
				-- If the player is moving and double table on release is false and the player wasn't moving last frame
				if self.onRelease == false and self.active == false then
					-- The last movement frame we want is the one where the player first starts to move
					self.lastFrame = gameFrame;
				end
				self.active = true;
				-- Store the movement vector
				self.lastVector = vector;
			end
		end
		
	-------------------------
	-- CHARACTER FUNCTIONS --
	-------------------------
	local JSON = require("json")
	local playerIndexCount = 0
	mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, function(_, player)
		--Isaac.DebugString(player:GetName())
		InutilLib.GetILIBData( player ).PlayerIndex = playerIndexCount
		playerIndexCount = playerIndexCount + 1
	end)

	function InutilLib.GetPlayerIndex(player)
		return InutilLib.GetILIBData( player ).PlayerIndex
	end

	--taken from the docs
	function InutilLib.GetMaxCollectibleID()
		local id = CollectibleType.NUM_COLLECTIBLES-1
		local step = 16
		while step > 0 do
			if Isaac.GetItemConfig():GetCollectible(id+step) ~= nil then
				id = id + step
			else
				step = step // 2
			end
		end
		
		return id
	end

	-- from aevilok
	function InutilLib.AddInnateItem(player, collectibleID)
		local itemWisp = player:AddItemWisp(collectibleID, Vector(-100,-100), true)
		itemWisp:RemoveFromOrbit()
		itemWisp.Velocity = Vector(-100,-100)
		itemWisp:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		local data = InutilLib.GetILIBData(itemWisp)
		data.IsInnate = true
		itemWisp.Visible = false
		itemWisp.CollisionDamage = 0
		itemWisp.Parent = player
		return itemWisp
	end

	function InutilLib.RemoveInnateItem(player, collectibleId)
		local itemWisps = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.ITEM_WISP, collectibleId)
		if #itemWisps > 0 then
			for i = 1, #itemWisps do
				local data = InutilLib.GetILIBData(itemWisps[i])
				if GetPtrHash(itemWisps[i].Parent) == GetPtrHash(player) then
					if (itemWisps[i].Velocity.X == -100 and itemWisps[i].Velocity.Y == -100) then
						itemWisps[i].Visible = false
						itemWisps[i]:Kill()
						break
					end
				end
			end
		end
	end

	--function to see if the collectible count has been changed the last frame, if so true, if not false
	function InutilLib.HasCollectiblesUpdated(player)
		local result
		local data = InutilLib.GetILIBData( player )
		local collectibleCount = player:GetCollectibleCount();
		if not data.collectibleCount then 
			data.collectibleCount = collectibleCount;
			result = true
		end
		if collectibleCount ~= data.collectibleCount then
			data.collectibleCount = collectibleCount;
			result = true
		else 
			result = false
		end
		return result
	end

	--thanks to xalum
	function InutilLib.CollectPlayerItems(player)
		local config = Isaac.GetItemConfig()
		local max = config:GetCollectibles().Size

		local items = {}
		local n

		for i = 1, max do
			n = player:GetCollectibleNum(i, true)
			if n > 0 then table.insert(items, {i, n}) end
		end

		local i = (1 << 32) - 1
		while config:GetCollectible(i) do
			n = player:GetCollectibleNum(i, true)
			if n > 0 then table.insert(items, {i, n}) end
			i = i - 1
		end

		return items
	end

	function InutilLib.GenerateCollectibleList(player)
		--local data = JSON.decode(Isaac.LoadModData(InutilLib))
		local maxNum = InutilLib.GetMaxCollectibleID() 
		--if not data then
		--	InutilLib.RevalidateSaveData(force)
		--end
		local playerIdx = InutilLib.GetPlayerIndex(player)
		local tbl = {}
		for i = 1, maxNum do
			if i ~= 43 and i ~= 59 and i ~= 61 and i ~= 235 then
				if player:HasCollectible(i) then
					tbl[i] = {
						[1] = i, --coll id
						[2] = false, --has just pcked up?
						[3] = player:GetCollectibleNum(i) --how much items
					}
					if not tbl[i][1] then tbl[i][1] = true end
				end
			end
		end
		if not InutilLib.Data.CollectibleList then InutilLib.Data.CollectibleList = {} end
		InutilLib.Data.CollectibleList[playerIdx] = tbl
		return InutilLib.Data.CollectibleList[playerIdx] 
	end

	function InutilLib.RefreshCollectibleList(player)
		--local data = JSON.decode(Isaac.LoadModData(InutilLib))
		local maxNum = InutilLib.GetMaxCollectibleID() 
		--if not data then
		--	InutilLib.RevalidateSaveData(force)
		--end
		local tbl = InutilLib.GetCollectibleList(player)
		local playerIdx = InutilLib.GetPlayerIndex(player)
		--for p = 0, InutilLib.game:GetNumPlayers() - 1 do
			for i = 1, maxNum do
				--if i ~= (43 or 59 or 61 or 235 or 263) then
					--print("demondice lets gooo")
					if player:HasCollectible(i) then
						if tbl[i] == nil then
							tbl[i] = {
								[1] = i, 
								[2] = true,
								[3] = player:GetCollectibleNum(i)
							}
						elseif tbl[i][2] == true then
							tbl[i] = {
								[1] = i, 
								[2] = false,
								[3] = player:GetCollectibleNum(i)
							}
						elseif tonumber(tostring(tbl[i][3])) < player:GetCollectibleNum(i) then
							local highestCollNum 
							if tbl[i][3] > player:GetCollectibleNum(i) then
								highestCollNum = tbl[i][3]
							else
								highestCollNum = player:GetCollectibleNum(i)
							end
							if player:GetCollectibleNum(i) <= 0 then
								tbl[i] = {
									[1] = i, 
									[2] = false,
									[3] = highestCollNum --player:GetCollectibleNum(i)
								}
							else
								tbl[i] = {
									[1] = i, 
									[2] = true,
									[3] = highestCollNum -- player:GetCollectibleNum(i)
								}
							end
						end
					elseif not player:HasCollectible(i) then
						--tbl[i] = nil
						--if not tbl[p][i][1] then tbl[p][i][1] = true end
					end
			--end
			end
		--end
		InutilLib.Data.CollectibleList[playerIdx]  = tbl
	end

	function InutilLib.GetCollectibleList(player)
		local returnV 
		if InutilLib.Data then
			if not InutilLib.Data.CollectibleList or not InutilLib.Data.CollectibleList[InutilLib.GetPlayerIndex(player)] then
				returnV = InutilLib.GenerateCollectibleList(player)
			else
				returnV = InutilLib.Data.CollectibleList[InutilLib.GetPlayerIndex(player)]
			end
			return returnV
		end
	end

	function InutilLib.ClearCollectibleList(player)
		if InutilLib.Data then
			if InutilLib.Data.CollectibleList or  InutilLib.Data.CollectibleList[InutilLib.GetPlayerIndex(player)] then
				InutilLib.Data.CollectibleList[InutilLib.GetPlayerIndex(player)] = nil
			end
		end
	end

	function InutilLib:useRerollToClearItemList(collItem, rng, player)
			InutilLib.ClearCollectibleList(player)
		end
		mod:AddCallback(ModCallbacks.MC_USE_ITEM, InutilLib.useRerollToClearItemList, CollectibleType.COLLECTIBLE_D4)
		mod:AddCallback(ModCallbacks.MC_USE_ITEM, InutilLib.useRerollToClearItemList, CollectibleType.COLLECTIBLE_D100)

	function InutilLib.ClearSpecificCollectibleData(player, coll)
		for k, v in pairs(collList) do
			if collList[k][1] == coll then
				collList[k] = nil
			end
		end
		return result
	end

	function InutilLib.HasJustPickedCollectible( player, coll )
		local result
		--print(tostring(collList[coll])..tostring(coll))
		--print(player.FrameCount)
		if player.FrameCount > 30 and InutilLib.Data then
			local collList = collList or InutilLib.GetCollectibleList(player)
			for k, v in pairs(collList) do
				if collList[k][1] == coll then
					if collList[k][2] == true then
						--print("b"..coll..tostring(collList[k][2]))
						collList[k][2] = false
						result = true
						--InutilLib.FalsifyJustPickedCollectible(player, coll)
					else
						result = false
					end
				end
			end
			return result
		else

		end
	end

	function InutilLib.ConfirmUseActive( player, coll )
		local data = InutilLib.GetILIBData(player)
		if data.LastShownItem == coll and InutilLib.IsShowingItem(player) then
			local fireDirection = player:GetFireDirection()
			if fireDirection ~= Direction.NO_DIRECTION then
				return true
			else
				return false
			end
		end
	end

	local updateCollectibleList = false
	mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
		for i=0, InutilLib.game:GetNumPlayers()-1 do
			local player = Isaac.GetPlayer(i)
			local data = InutilLib.GetILIBData(player)
			if updateCollectibleList then
				InutilLib.RefreshCollectibleList(player)
			end
		end
		updateCollectibleList = false
	end)

	function InutilLib:useGlowHourglass(collItem, rng, player) --glowsquids suck btw
		--[[print("brug")
		if InutilLib.Data then
			for i=0, InutilLib.game:GetNumPlayers()-1 do
				local player = Isaac.GetPlayer(i)
				local data = InutilLib.GetILIBData(player)
				print(InutilLib.Data.CollectibleList[InutilLib.GetPlayerIndex(player)])
				for i, v in pairs (data.oldCollectibleList ) do
					for i, v2 in pairs (v) do
						print(i)
						print(v2)
					end
				end
				InutilLib.Data.CollectibleList[InutilLib.GetPlayerIndex(player)] = data.oldCollectibleList 
			end
		end]]
		updateCollectibleList = true
		--InutilLib.RefreshCollectibleList(player)
	end

	mod:AddCallback(ModCallbacks.MC_USE_ITEM, InutilLib.useGlowHourglass, CollectibleType.COLLECTIBLE_GLOWING_HOUR_GLASS)

	---------------------------------
	-- CUSTOMIZABLE PLAYERS SYSTEM --
	---------------------------------

	InutilLib.Players = {} --table turned into a class
	InutilLib.ListOfRegPlayers = {} --future list of players

	function InutilLib.Players:New(o, id, hurtSound, deathSound, instructions, giantAnim)

		o = o or {};
		o.id = id
		o.hurtSound = hurtSound
		o.deathSound = deathSound
		o.instructions = instructions
		--o.giantAnim = giantAnim
		
		setmetatable(o,self);
		self.__index = self;
		InutilLib.ListOfRegPlayers[id] = o
		return o;
	end

	--the big boi stuff is deprecated
	local BLUEBABY_INFO = InutilLib.Players:New({}, 4, nil, nil, nil, {"gfx/characters/big_boiblue.anm2"});
	local AZAZEL_INFO = InutilLib.Players:New({}, 7, nil, nil, nil, {"gfx/characters/big_boiblack.anm2"});
	local THELOST_INFO = InutilLib.Players:New({}, 10, nil, nil, nil, {"gfx/characters/big_boiwhite.anm2"});
	local DARKJUDAS_INFO = InutilLib.Players:New({}, 12, nil, nil, nil, {"gfx/characters/big_boiblack.anm2"});
	local LILITH_INFO = InutilLib.Players:New({}, 12, nil, nil, nil, {"gfx/characters/big_boiblack.anm2"});
	local KEEPER_INFO = InutilLib.Players:New({}, 14, nil, nil, nil, {"gfx/characters/big_boigrey.anm2"});
	local APOLLYON_INFO = InutilLib.Players:New({}, 15, nil, nil, nil, {"gfx/characters/big_boigrey.anm2"});
	local FORGOTTEN_INFO = InutilLib.Players:New({}, 16, nil, nil, nil, {"gfx/characters/big_boigrey.anm2"});
	local THESOUL_INFO = InutilLib.Players:New({}, 17, nil, nil, nil, {"gfx/characters/big_boiwhite.anm2"});
	local ESAU_INFO = InutilLib.Players:New({}, 20, nil, nil, nil, {"gfx/characters/big_boired.anm2"});

	--tainteds
	local BLUEBABY_B_INFO = InutilLib.Players:New({}, 25, nil, nil, nil, {"gfx/characters/big_boiblue.anm2"});
	local AZAZEL_B_INFO = InutilLib.Players:New({}, 28, nil, nil, nil, {"gfx/characters/big_boiblack.anm2"});
	local THELOST_B_INFO = InutilLib.Players:New({}, 31, nil, nil, nil, {"gfx/characters/big_boigrey.anm2"});
	local DARKJUDAS_B_INFO = InutilLib.Players:New({}, 24, nil, nil, nil, {"gfx/characters/big_boiblack.anm2"});
	local LILITH_B_INFO = InutilLib.Players:New({}, 32, nil, nil, nil, {"gfx/characters/big_boiblack.anm2"});
	local KEEPER_B_INFO = InutilLib.Players:New({}, 33, nil, nil, nil, {"gfx/characters/big_boigrey.anm2"});
	local APOLLYON_B_INFO = InutilLib.Players:New({}, 34, nil, nil, nil, {"gfx/characters/big_boigrey.anm2"});
	local FORGOTTEN_B_INFO = InutilLib.Players:New({}, 35, nil, nil, nil, {"gfx/characters/big_boigrey.anm2"});
	local THESOUL_B_INFO = InutilLib.Players:New({}, 36, nil, nil, nil, {"gfx/characters/big_boiwhite.anm2"});
	local JACOB_B_INFO = InutilLib.Players:New({}, 38, nil, nil, nil, {"gfx/characters/big_boiwhite.anm2"});
	local LOSTJACOB_B_INFO = InutilLib.Players:New({}, 39, nil, nil, nil, {"gfx/characters/big_boiwhite.anm2"});

	local burningBasementColor = Color(0.5,0.5,0.5,1,0,0,0)
	local glacierColor = Color(0,0,0,1,85,120,155)

	InutilLib.DefaultInstructions = "gfx/backdrop/controls_default.png"

	--taken from rev, for compatibility and such.
	--this is probably useless now lol
	function InutilLib.SpawnStartingRoomControls()
		local centerPos = InutilLib.room:GetCenterPos()
		local playerType = Isaac.GetPlayer(0):GetPlayerType()
		local playerInfo 
		if InutilLib.ListOfRegPlayers[playerType] then playerInfo = InutilLib.ListOfRegPlayers[playerType] end
		local stageType = InutilLib.level:GetStageType()
		local controlsPos = centerPos
		
		--controlsPos = centerPos + Vector(0,-65)
		
		if playerInfo then
			if playerInfo.instructions then
				local column = TableLength(playerInfo.instructions)
				local Pos = {}
				if column then
					if column == 1 then --definitions
						Pos[1] = Vector(0,0)
					elseif column == 2 then 
						Pos[1] = Vector(0,-55)
						Pos[2] = Vector(0, 55)
					elseif column == 3 then
						Pos[1] = Vector(0,-95)
						Pos[2] = Vector(0,0)
						Pos[3] = Vector(0, 95)
					end
					for i = 1, column do 
						local controlsEffect = InutilLib.SpawnFloorEffect(controlsPos + Pos[i], Vector(0,0), nil, "gfx/backdrop/controls.anm2", true)
						local controlsSprite = controlsEffect:GetSprite()
						controlsSprite:Play("Idle")
						controlsSprite:ReplaceSpritesheet(0, playerInfo.instructions[i])
						controlsSprite:LoadGraphics()
						if column == 3 then controlsEffect.SpriteScale = Vector(0.8, 0.8) end
						
						if stageType == StageType.STAGETYPE_AFTERBIRTH then
							controlsSprite.Color = burningBasementColor
						elseif REVEL then
							if REVEL.STAGE.Glacier:IsStage() then
								controlsSprite.Color = glacierColor
							end
						end
					end
				end
			end
		elseif CommunityRemixRemixed and playerType == p20PlayerType.PLAYER_ADAM then --crr compat, I have to do this unless they like to fix it in their side
			--do nothing
		else
			if playerType ~= PlayerType.PLAYER_THEFORGOTTEN and playerType ~= PlayerType.PLAYER_THESOUL then
				local controlsEffect = InutilLib.SpawnFloorEffect(controlsPos, Vector(0,0), nil, "gfx/backdrop/controls.anm2", true)
				local controlsSprite = controlsEffect:GetSprite()
				controlsSprite:Play("Idle")
				--controlsSprite:ReplaceSpritesheet(0, InutilLib.DefaultInstructions)
				controlsSprite:LoadGraphics()

				if stageType == StageType.STAGETYPE_AFTERBIRTH then
					controlsSprite.Color = burningBasementColor
				elseif REVEL then
					if REVEL.STAGE.Glacier:IsStage() then
						controlsSprite.Color = glacierColor
					end
				end
			end
		end
	end

	mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
		if not InutilLib.game:IsGreedMode() and InutilLib.level:GetCurrentRoomIndex() == InutilLib.level:GetStartingRoomIndex() and InutilLib.level:GetStage() == 1 then
			
			local playerType = Isaac.GetPlayer(0):GetPlayerType()
			local playerInfo 
			if InutilLib.ListOfRegPlayers[playerType] then playerInfo = InutilLib.ListOfRegPlayers[playerType] end
			local stageType = InutilLib.level:GetStageType()
			local controlsPos = centerPos
			
			--controlsPos = centerPos + Vector(0,-65)
			
			if playerInfo then	
				if not StageAPI then
					InutilLib.SpawnStartingRoomControls()
					--[[for i, v in pairs(Isaac.GetRoomEntities()) do
						if v.Type == StageAPI.E.FloorEffectCreep.T and v.Variant == StageAPI.E.FloorEffectCreep.V and v.SubType == StageAPI.E.FloorEffectCreep.S then
							v:Remove()
							print("fire")
						end
					end]]
				end
			end
		end
	end)


	--stage api code
	InutilLib.LegacyShading = {
		T = EntityType.ENTITY_EFFECT,
		V = 12539,
		--S = 9002
	}

	--legacy stageapi code i copied

		local shadingDefaultOffset = Vector(-80,-80)
		local shadingIhOffset = Vector(-80,-160)
		local shadingIvOffset = Vector(-240,-80)
		function InutilLib.ChangeShading(name, prefix)
			local room = InutilLib.room
			prefix = prefix or "legacy stageapi/shading/shading"
			local shading = Isaac.FindByType(InutilLib.LegacyShading.T, InutilLib.LegacyShading.V, -1, false, false)
			for _, e in ipairs(shading) do
				e:Remove()
			end

			local shadingEntity = Isaac.Spawn(InutilLib.LegacyShading.T, InutilLib.LegacyShading.V, 0, Vector.Zero, Vector.Zero, nil)
			local roomShape = room:GetRoomShape()

			local topLeft = room:GetTopLeftPos()
			local renderPos = topLeft + shadingDefaultOffset
			local sheet

			if roomShape == RoomShape.ROOMSHAPE_1x1 then sheet = ""
			elseif roomShape == RoomShape.ROOMSHAPE_1x2 then sheet = "_1x2"
			elseif roomShape == RoomShape.ROOMSHAPE_2x1 then sheet = "_2x1"
			elseif roomShape == RoomShape.ROOMSHAPE_2x2 then sheet = "_2x2"
			elseif roomShape == RoomShape.ROOMSHAPE_IH then
				sheet = "_ih"
				renderPos = topLeft + shadingIhOffset
			elseif roomShape == RoomShape.ROOMSHAPE_IIH then
				sheet = "_iih"
				renderPos = topLeft + shadingIhOffset
			elseif roomShape == RoomShape.ROOMSHAPE_IV then
				sheet = "_iv"
				renderPos = topLeft + shadingIvOffset
			elseif roomShape == RoomShape.ROOMSHAPE_IIV then
				sheet = "_iiv"
				renderPos = topLeft + shadingIvOffset
			elseif roomShape == RoomShape.ROOMSHAPE_LBL then sheet = "_lbl"
			elseif roomShape == RoomShape.ROOMSHAPE_LBR then sheet = "_lbr"
			elseif roomShape == RoomShape.ROOMSHAPE_LTL then sheet = "_ltl"
			elseif roomShape == RoomShape.ROOMSHAPE_LTR then sheet = "_ltr"
			end

			sheet = prefix .. sheet .. name .. ".png"

			--[[
			local sprite = shadingEntity:GetSprite()
			sprite:Load("stageapi/Shading.anm2", false)
			sprite:ReplaceSpritesheet(0, sheet)
			sprite:LoadGraphics()
			sprite:Play("Default", true)]]

			shadingEntity:GetData().Sheet = sheet
			shadingEntity.Position = renderPos
			shadingEntity:AddEntityFlags(EntityFlag.FLAG_DONT_OVERWRITE)
		end

		local shadingSprite = Sprite()
		shadingSprite:Load("legacy stageapi/Shading.anm2", false)
		shadingSprite:Play("Default", true)
		local lastUsedShadingSpritesheet
		mod:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, function(_, eff)
			--StageAPI.CallCallbacks("PRE_SHADING_RENDER", false, eff)

			local sheet = eff:GetData().Sheet
			if sheet and sheet ~= lastUsedShadingSpritesheet then
				shadingSprite:ReplaceSpritesheet(0, sheet)
				shadingSprite:LoadGraphics()
				lastUsedShadingSpritesheet = sheet
			end

			shadingSprite:Render(Isaac.WorldToScreen(eff.Position), zeroVector, zeroVector)
		-- StageAPI.CallCallbacks("POST_SHADING_RENDER", false, eff)
		end, InutilLib.LegacyShading.V)


	local queueDamageSound = false;
	local wasPlayerDead = false;
	
	local nowClear = false

	mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function(_)
		nowClear = InutilLib.room:IsClear()
	end)
	
	mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
		if not nowClear and InutilLib.room:IsClear() then
			Isaac.RunCallback("MC_POST_CLEAR_ROOM", InutilLib.room)
			nowClear = true
		end
	end)

	mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, damage, amount, damageFlag, damageSource, damageCountdownFrames) 
		local playerInfo 
		local playerType = damage:ToPlayer():GetPlayerType()
		if InutilLib.ListOfRegPlayers[playerType] then playerInfo = InutilLib.ListOfRegPlayers[playerType] end
		if playerInfo and playerInfo.hurtSound then
			queueDamageSound = true;
		end
		--[[if InutilLib.GetILIBData(damage).StartMegaMushAnim or InutilLib.GetILIBData(damage).EndMegaMushAnim then
			return false
		end]]
		
	end, EntityType.ENTITY_PLAYER)
	--custom hurt sounds
	mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
		local speaker = SFXManager();
		for p = 0, InutilLib.game:GetNumPlayers() - 1 do
			local player = Isaac.GetPlayer(p)
			local playerInfo 
			local playerType = player:GetPlayerType()
			if InutilLib.ListOfRegPlayers[playerType] then playerInfo = InutilLib.ListOfRegPlayers[playerType] end

			if playerInfo then

				if playerInfo.hurtSound then
					if queueDamageSound == true then
						queueDamageSound = false;
						if player:GetSprite():IsPlaying("Hit") then
							
							speaker:Stop(SoundEffect.SOUND_ISAAC_HURT_GRUNT);
							speaker:Play(playerInfo.hurtSound, 1, 0, false, 1);
						end
					end
				end
				if playerInfo.deathSound then
					local isPlayerDead = (player:GetSprite():IsPlaying("Death") or player:GetSprite():IsPlaying("HoleDeath") or player:GetSprite():IsPlaying("LostDeath") );
					if isPlayerDead and player:GetSprite():WasEventTriggered("DeathSound") then
						speaker:Stop(SoundEffect.SOUND_ISAACDIES);
						if player:GetSprite():IsEventTriggered("DeathSound") then
							speaker:Play(playerInfo.deathSound, 1, 0, false, 1);
						end
					end
					--wasPlayerDead = isPlayerDead;
				end
			end
		end
	end);

	--Charactercustom.lua's Post_update!
	mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function(_,player)
		if InutilLib.HasCollectiblesUpdated(player) == true then
			--InutilLib.SetFrameLoop( 4, function()
				InutilLib.RefreshCollectibleList(player)
			--end)
			--InutilLib.FalsifyJustPickedCollectibles(player)
		end
	end)

	mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, e)
		if e.Type == 1 then
			if e:ToPlayer():GetPlayerType() == PlayerType.PLAYER_EDEN_B then
				InutilLib.RefreshCollectibleList(player)
			end
		end
	end)


	----------------------
	-- ACHIEVEMENT UI!! --
	----------------------
	--based on piber20helper and rev's code
	--honestly, just credit both of them, im a scum who just copied their code  --KakaoDCat
	do

	local AchievementDur = 60

	local shouldRenderAchievement = false
	local achievementUI = Sprite()
	local currentSprite = ""
	achievementUI:Load("gfx/ui/achievement/achievements.anm2", true)
	local achievementUIDelay = 0
	function InutilLib.AnimateIsaacAchievement(spritesheet, sound, doPause, time)
		if doPause == nil then
			doPause = true
		end

		local safe = InutilLib.RoomIsSafe()
		if shouldRenderAchievement or ((doPause and not pauseEnabled) and not safe) then
			InutilLib.SetTimer(12, function()
				InutilLib.AnimateIsaacAchievement(spritesheet, sound, doPause, time)
			end)
			return
		end

		if doPause and not pauseEnabled then
			for _,proj in pairs(Isaac.GetRoomEntities()) do
				if proj.Variant == EntityType.ENTITY_PROJECTILE then
					proj:Die()
				end
			end
		end

	if spritesheet then
		currentSprite = spritesheet
			achievementUI:ReplaceSpritesheet(3, spritesheet)
		achievementUI:LoadGraphics()
	else
		currentSprite = ""
		end

		achievementUI:Play("Appear", true)
		shouldRenderAchievement = true
		achievementUIDelay = time or AchievementDur

		if not sound then
			sound = SoundEffect.SOUND_CHOIR_UNLOCK
		end
		InutilLib.SFX:Play(sound, 1, 0, false, 1)
	end

	function InutilLib.GetShowingAchievement()
		return shouldRenderAchievement, currentSprite
	end

	mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
		if Isaac.GetFrameCount() % 2 == 0 then
			achievementUI:Update()
			if achievementUI:IsFinished("Appear") then
				achievementUI:Play("Idle", true)
			end
			if achievementUI:IsPlaying("Idle") then
				if achievementUIDelay > 0 then
					achievementUIDelay = achievementUIDelay - 1
				elseif achievementUIDelay == 0 then
					achievementUI:Play("Dissapear", true)
				end
			end
			if achievementUI:IsFinished("Dissapear") then
		shouldRenderAchievement = false

			for p = 0, InutilLib.game:GetNumPlayers() - 1 do
				local player = Isaac.GetPlayer(p)
				player:GetData().prevAchCharge = nil
				end
			end
		end

		if shouldRenderAchievement then
			achievementUI:Render(InutilLib.FFgetScreenCenterPosition(), Vector(0,0), Vector(0,0))
	end

	if shouldRenderAchievement then
		for p = 0, InutilLib.game:GetNumPlayers() - 1 do
			local player = Isaac.GetPlayer(p)
		local data =  player:GetData()
		data.prevAchCharge = data.prevAchCharge or player:GetActiveCharge()
		if data.prevAchCharge > player:GetActiveCharge() then
			player:SetActiveCharge(data.prevAchCharge)

			if not IsAnimOn(achievementUI, "Dissapear") then
			achievementUI:Play("Dissapear", true)
			end
		end

		if (Input.IsActionTriggered(ButtonAction.ACTION_MENUCONFIRM, player.ControllerIndex) or
				Input.IsActionTriggered(ButtonAction.ACTION_MENUBACK, player.ControllerIndex)) and
				not InutilLib.IsAnimated(achievementUI, "Dissapear") and not achievementUI:IsPlaying("Appear") then
			achievementUI:Play("Dissapear", true)
		end
		end
	end
	end)

	mod:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, function()
	if shouldRenderAchievement then
		return true
	end
	end)

	mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, e)
	if e.Type == 1 and shouldRenderAchievement then
		return false
	end
	end)



	end


	------------------
	-- GIANTBOOK UI --
	------------------
	--based on piber20helper code and revel, again

	do

	local shouldRenderGiantbook = false
	local isHideHud = false
	local giantbookUI = Sprite()
	giantbookUI:Load("gfx/ui/giantbook/giantbook.anm2", true)
	local giantBookAnimationFile = "gfx/ui/giantbook/giantbook.anm2"
	local giantBookSpritesheetFile
	local giantbookAnimation = "Appear"

	function InutilLib.AnimateGiantbook(spritesheet, sound, animationToPlay, animationFile, doPause, hideHUD)
		if doPause == nil then
			doPause = true
		end

		--[[
		if doPause and pauseEnabled then
			REVEL.GiantbookPause()
		end
		]]

		if not animationToPlay then
			animationToPlay = "Appear"
		end

		if not animationFile then
			animationFile = "gfx/ui/giantbook/giantbook.anm2"
			if animationToPlay == "Appear" or animationToPlay == "Shake" then
				animationFile = "gfx/ui/giantbook/giantbook.anm2"
			elseif animationToPlay == "Static" then
				animationToPlay = "Effect"
				animationFile = "gfx/ui/giantbook/giantbook_clicker.anm2"
			elseif animationToPlay == "Flash" then
				animationToPlay = "Idle"
				animationFile = "gfx/ui/giantbook/giantbook_mama_mega.anm2"
			elseif animationToPlay == "Sleep" then
				animationToPlay = "Idle"
				animationFile = "gfx/ui/giantbook/giantbook_sleep.anm2"
			elseif animationToPlay == "AppearBig" or animationToPlay == "ShakeBig" then
				if animationToPlay == "AppearBig" then
					animationToPlay = "Appear"
				elseif animationToPlay == "ShakeBig" then
					animationToPlay = "Shake"
				end
				animationFile = "gfx/ui/giantbook/giantbookbig.anm2"
			end
		end

		giantbookAnimation = animationToPlay
		if giantBookAnimationFile ~= animationFile then
			giantbookUI:Load(animationFile, true)
			giantBookAnimationFile = animationFile
		end
		if spritesheet ~= giantBookSpritesheetFile then
			giantbookUI:ReplaceSpritesheet(0, spritesheet)
			giantbookUI:LoadGraphics()
			giantBookSpritesheetFile = spritesheet
		end
		giantbookUI:Play(animationToPlay, true)
		shouldRenderGiantbook = true

		if sound then
			InutilLib.SFX:Play(sound, 1, 0, false, 1)
		end
		
		if hideHUD then
			InutilLib.game:GetSeeds():AddSeedEffect(SeedEffect.SEED_NO_HUD)
			isHideHud = true
		end
	end

	mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
		if Isaac.GetFrameCount() % 2 == 0 then
			giantbookUI:Update()
			if giantbookUI:IsFinished(giantbookAnimation) then
				shouldRenderGiantbook = false
				if isHideHud then
					isHideHud = false
					InutilLib.game:GetSeeds():RemoveSeedEffect(SeedEffect.SEED_NO_HUD)
				end
			end
		end
		if shouldRenderGiantbook then
			giantbookUI:Render(InutilLib.FFgetScreenCenterPosition(), Vector(0,0), Vector(0,0))
		end
	end)

	end

	---------------------
	--PICKUP CODE--
	---------------------

	function InutilLib.GetClosestPickup(obj, dist, variant, subtype)
		local closestDist = 177013 --saved Dist to check who is the closest enemy
		local returnV
		for j, pickup in pairs (Isaac.FindByType(EntityType.ENTITY_PICKUP, variant, subtype, false, false)) do
			local data = InutilLib.GetILIBData(pickup);
			local minDist = dist or 100
			if (obj.Position - pickup.Position):Length() < minDist then
				if (obj.Position - pickup.Position):Length() < closestDist and not (pickup:GetSprite():IsPlaying("Open") or pickup:GetSprite():IsPlaying("Opened") or pickup:GetSprite():IsPlaying("Collect")) then
					closestDist = (obj.Position - pickup.Position):Length()
					returnV = pickup
				end
			end
		end
		return returnV
	end


	local chestVariables = {
		PickupVariant.CHEST,
		PickupVariant.BOMBCHEST,
		PickupVariant.SPIKEDCHEST,
		PickupVariant.ETERNALCHEST,
		PickupVariant.MIMICCHEST,
		PickupVariant.REDCHEST,
		PickupVariant.PICKUP_OLDCHEST,
		PickupVariant.PICKUP_WOODENCHEST,
		PickupVariant.PICKUP_MEGACHEST,
		PickupVariant.PICKUP_HAUNTEDCHEST
	}
	function InutilLib.PickupPickup(pickup)
		pickup = pickup:ToPickup()
		pickup:PlayPickupSound()
		pickup.Touched = true
		pickup.Wait = 100
		if pickup.Variant ~= (chestVariables) then
			if pickup.Variant == 20 and pickup.SubType == 6 then
				pickup:GetSprite():Play("Touched", true)
			else
				pickup:GetSprite():Play("Collect", true)
				InutilLib.GetILIBData(pickup).KillAfter = true
			end
		end
		--print("dum"..pickup.SubType)
		return pickup
	end

	mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, pickup)
		local data = InutilLib.GetILIBData(pickup);
		if data and data.KillAfter then
			if (pickup:GetSprite():IsFinished("Open") or pickup:GetSprite():IsFinished("Opened") or pickup:GetSprite():IsFinished("Collect")) then
				pickup:Remove()
			end
		end
	end)

	function InutilLib.CanPickAnyHearts(player) 
		if player:CanPickBlackHearts() or player:CanPickBoneHearts() or player:CanPickGoldenHearts() or player:CanPickRedHearts() or player:CanPickRottenHearts() or 	player:CanPickSoulHearts() then
			return true
		else
			return false
		end
	end

	function InutilLib.CanPickAllHearts(player) 
		if player:CanPickBlackHearts() and player:CanPickBoneHearts() and player:CanPickGoldenHearts() and player:CanPickRedHearts() and player:CanPickRottenHearts() and 	player:CanPickSoulHearts() then
			return true
		else
			return false
		end

	end

	function InutilLib.GetAllMajorHearts(player)
		return player:GetMaxHearts() + player:GetSoulHearts()
	end


	--from revelations again
	function InutilLib.GetEntFromRef(entRef)
		if entRef.Entity then
			local matching = Isaac.FindByType(entRef.Entity.Type, entRef.Entity.Variant, entRef.Entity.SubType, false, false)
			local result 
			local dist = 100000000
			local alsoDead = true
			for i,e in ipairs(matching) do
				local d = e.Position:DistanceSquared(entRef.Entity.Position)
				if (not dist or d < dist) and e:Exists() and (alsoDead or not e:IsDead()) then
					dist = d
					result = e
				end
			end
			return result
		end
	end

	function InutilLib.GetEntFromDmgSrc(src)
		local srcEnt, ent = InutilLib.GetEntFromRef(src), nil
			if srcEnt and srcEnt:IsEnemy() then
				ent = srcEnt
			elseif srcEnt and srcEnt.SpawnerType --[[and srcEnt.SpawnerType:IsEnemy()]] then
				if srcEnt.SpawnerEntity then
					ent = srcEnt.SpawnerEntity
				end
			end
		return ent, srcEnt
		end

	function InutilLib.GetPlayerFromDmgSrc(src)
	local srcEnt, player = InutilLib.GetEntFromRef(src), nil
		if srcEnt and srcEnt.Type == 1 then
				player = srcEnt:ToPlayer()
		elseif srcEnt and srcEnt.SpawnerType == 1 then
			if srcEnt.SpawnerEntity then
				player = srcEnt.SpawnerEntity:ToPlayer()
			end
		end
	return player, srcEnt
	end

	--taken from FF
	function InutilLib:GetPlayerFromKnife(knife)
		if knife.SpawnerEntity and knife.SpawnerEntity:ToPlayer() then
			return knife.SpawnerEntity:ToPlayer()
		elseif knife.SpawnerEntity and knife.SpawnerEntity:ToFamiliar() and knife.SpawnerEntity:ToFamiliar().Player then
			local familiar = knife.SpawnerEntity:ToFamiliar()
	
			if familiar.Variant == FamiliarVariant.INCUBUS or familiar.Variant == FamiliarVariant.SPRINKLER or
			   familiar.Variant == FamiliarVariant.TWISTED_BABY or familiar.Variant == FamiliarVariant.BLOOD_BABY or
			   familiar.Variant == FamiliarVariant.UMBILICAL_BABY or familiar.Variant == FamiliarVariant.CAINS_OTHER_EYE
			then
				return familiar.Player
			else
				return nil
			end
		else
			return nil
		end
	end
	

	InutilLib.Data = {}

	function InutilLib:Init(hasstarted) --Init
		for p = 0, InutilLib.game:GetNumPlayers() - 1 do
			local player = Isaac.GetPlayer(p)
			--Isaac.DebugString(player)
			if not hasstarted then
				--InutilLib.RevalidateSaveData(true)
				InutilLib.Data = {}
				InutilLib.GenerateCollectibleList(player)
				--[[for a,e in ipairs(player) do
					InutilLib.GenerateCollectibleList(e)
				end]]
			end
		end
	end
	mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, InutilLib.Init)

	-- Load Moddata
	mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, function(_, player)
		--Isaac.DebugString(player:GetName())
		if Isaac.HasModData(InutilLib) then
			--local data = JSON.decode(Isaac.LoadModData(InutilLib));
			if data ~= nil then
				InutilLib.RevalidateSaveData(true)
			end
		end
	end)

	local function save()
		Isaac.SaveModData(InutilLib, JSON.encode( InutilLib.Data ) );
	end
	--Save Moddata

	mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
		save()
	end)
	mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, function(_, boo)
		if boo then
			save()
		end
	end)
	mod:AddCallback(ModCallbacks.MC_POST_GAME_END, function(_, boo)
		save()
	end)

	Isaac.DebugString("loaded!")






end

return InutilLib