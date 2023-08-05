yandereWaifu:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, pickup)
	local chance = 1/2
	local rng = pickup:GetDropRNG()
	local challenge = InutilLib.game.Challenge == RebekahCurse.Challenges.EasterHunt
    if challenge and RebekahCurseGlobalData.EASTER_EGG_NO_MORPH_FRAME == 0 then
		local validPickup = (pickup.Variant == PickupVariant.PICKUP_CHEST or pickup.Variant == PickupVariant.PICKUP_TAROTCARD)
			--pickup.Wait = 10;
		if rng:RandomFloat() <= (chance) and validPickup and InutilLib.room:GetType() ~= RoomType.ROOM_BOSS and RebekahCurseGlobalData.EASTER_EGG_NO_MORPH_FRAME == 0 
		and (pickup:GetSprite():IsPlaying("Appear") or pickup:GetSprite():IsPlaying("AppearFast")) and pickup:GetSprite():GetFrame() == 1 and not pickup.SpawnerEntity then
			local newpickup = yandereWaifu.SpawnEasterEgg(pickup.Position, player, 1, pickup:IsShopItem())
			--local newpickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, RebekahCurse.Cards.CARD_EASTEREGG, pickup.Position, Vector(0,0), player):ToPickup()
			newpickup.OptionsPickupIndex = pickup.OptionsPickupIndex
			if pickup.Variant == PickupVariant.PICKUP_CHEST then
				for i = 0, math.random(2,3) do
					local newpickup = yandereWaifu.SpawnEasterEgg(pickup.Position, player, 1, pickup:IsShopItem())
					newpickup.OptionsPickupIndex = pickup.OptionsPickupIndex
				end
			end
			pickup:Remove()
		end
		if pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE and pickup.FrameCount <= 1 then
			for i = 0, math.random(5,8) do
				local newpickup = yandereWaifu.SpawnEasterEgg(pickup.Position, player, 1, pickup:IsShopItem())
				newpickup.OptionsPickupIndex = pickup.OptionsPickupIndex
			end
			pickup:Remove()
		end
	end
end)

yandereWaifu:AddCallback("MC_POST_CLEAR_ROOM", function(_, room)
	--StageAPI.AddCallback("RebekahCurse", "POST_ROOM_CLEAR", 2, function()
	local enemytbl = yandereWaifu.eastereggenemyList
		local challenge = InutilLib.game.Challenge == RebekahCurse.Challenges.EasterHunt
		if challenge and InutilLib.level:GetStage() > 1 and math.random(1,3) == 3 then
			for i = 0, 7 do
				local door = InutilLib.game:GetRoom():GetDoor(i)
				local currentLevelIDX = InutilLib.level:GetCurrentRoomDesc().GridIndex
				local rng = math.random(0,10)
				if door then
					Isaac.Spawn( enemytbl[rng].type, enemytbl[rng].variant, enemytbl[rng].subtype, InutilLib.room:FindFreePickupSpawnPosition(door.Position, 1), Vector(0,0), nil );
					if door:IsOpen() then
						door:Bar()
					end
					--InutilLib.room:SetClear(false)
				end
			end
		end
end)

if StageAPI and StageAPI.Loaded then	
	yandereWaifu.RabbetStageAPIRooms = {
		StageAPI.AddBossData("Rabbet", {
			Name = "Rabbet",
			Portrait = "gfx/ui/boss/portrait_rabbet.png",
			Offset = Vector(0,-15),
			Bossname = "gfx/ui/boss/name_rabbet.png",
			Weight = 2,
			Rooms = StageAPI.RoomsList("Rabbet Rooms", require("resources.luarooms.thriftshop.rabbet")),
			Entity =  {Type = RebekahCurse.Enemies.ENTITY_REBEKAH_ENEMY, Variant = RebekahCurse.Enemies.ENTITY_RABBET},
		})
	}
	yandereWaifu.HolediniStageAPIRooms = {
		StageAPI.AddBossData("Holedini", {
			Name = "Holedini",
			Portrait = "gfx/ui/boss/portrait_nincompoop.png",
			Offset = Vector(0,-15),
			Bossname = "gfx/ui/boss/name_holedini.png",
			Weight = 2,
			Rooms = StageAPI.RoomsList("Holedini Rooms", require("resources.luarooms.thriftshop.holedini")),
			Entity =  {Type = RebekahCurse.Enemies.ENTITY_REBEKAH_ENEMY, Variant = RebekahCurse.Enemies.ENTITY_HOLEDINI},
		})
	}
	yandereWaifu.DukeofFluffStageAPIRooms = {
		StageAPI.AddBossData("Duke of Fluff", {
			Name = "Duke of Fluff",
			Portrait = "gfx/ui/boss/portrait_nincompoop.png",
			Offset = Vector(0,-15),
			Bossname = "gfx/ui/boss/name_duke_of_fluff.png",
			Weight = 2,
			Rooms = StageAPI.RoomsList("Duke of Fluff Rooms", require("resources.luarooms.thriftshop.dukeoffluff")),
			Entity =  {Type = RebekahCurse.Enemies.ENTITY_REBEKAH_ENEMY, Variant = RebekahCurse.Enemies.ENTITY_DUKEOFFLUFF},
		})
	}
	yandereWaifu.PomPomsStageAPIRooms = {
		StageAPI.AddBossData("Pom Poms", {
			Name = "Pom Poms",
			Portrait = "gfx/ui/boss/portrait_nincompoop.png",
			Offset = Vector(0,-15),
			Bossname = "gfx/ui/boss/name_pom_poms.png",
			Weight = 2,
			Rooms = StageAPI.RoomsList("Pom Poms Rooms", require("resources.luarooms.thriftshop.pompoms")),
			Entity =  {Type = RebekahCurse.Enemies.ENTITY_REBEKAH_ENEMY, Variant = RebekahCurse.Enemies.ENTITY_POMPOMS},
		})
	}
	yandereWaifu.ThePuffStageAPIRooms = {
		StageAPI.AddBossData("The Puff", {
			Name = "The Puff",
			Portrait = "gfx/ui/boss/portrait_nincompoop.png",
			Offset = Vector(0,-15),
			Bossname = "gfx/ui/boss/name_the_puff.png",
			Weight = 2,
			Rooms = StageAPI.RoomsList("The Puff Rooms", require("resources.luarooms.thriftshop.thepuff")),
			Entity =  {Type = RebekahCurse.Enemies.ENTITY_REBEKAH_ENEMY, Variant = RebekahCurse.Enemies.ENTITY_THEPUFF},
		})
	}
	yandereWaifu.TheLordessStageAPIRooms = {
		StageAPI.AddBossData("The Demon Lordess", {
			Name = "The Demon Lordess",
			Portrait = "gfx/ui/boss/portrait_nincompoop.png",
			Offset = Vector(0,-15),
			Bossname = "gfx/ui/boss/name_the_demon_lordess.png",
			Weight = 2,
			Rooms = StageAPI.RoomsList("The Demon Lordess Rooms", require("resources.luarooms.thriftshop.thedemonlordess")),
			Entity =  {Type = RebekahCurse.Enemies.ENTITY_REBEKAH_ENEMY, Variant = RebekahCurse.Enemies.ENTITY_THEDEMONLORDESS},
		})
	}
end

StageAPI.AddCallback("RebekahCurse", "PRE_STAGEAPI_NEW_ROOM_GENERATION", 0, function(currentRoom, justGenerated, currentListIndex)
	local challenge = InutilLib.game.Challenge == RebekahCurse.Challenges.EasterHunt
    if challenge then
		if InutilLib.room:GetType() == RoomType.ROOM_BOSS and InutilLib.room:IsFirstVisit() then
			if InutilLib.level:GetStage() == LevelStage.STAGE1_1 then
				local newRoom = StageAPI.GenerateBossRoom({
					BossID = "Rabbet",
					NoPlayBossAnim = false,
					CheckEncountered = false,
				}, {
					RoomDescriptor = InutilLib.level:GetCurrentRoomDesc()
				})

				--StageAPI.SetLevelRoom(newRoom, InutilLib.level:GetCurrentRoomDesc().ListIndex)
				return newRoom, true
			elseif InutilLib.level:GetStage() == LevelStage.STAGE1_2 then
				local newRoom = StageAPI.GenerateBossRoom({
					BossID = "Holedini",
					NoPlayBossAnim = false,
					CheckEncountered = false,
				}, {
					RoomDescriptor = InutilLib.level:GetCurrentRoomDesc()
				})

				--StageAPI.SetLevelRoom(newRoom, InutilLib.level:GetCurrentRoomDesc().ListIndex)
				return newRoom, true
			elseif InutilLib.level:GetStage() == LevelStage.STAGE2_1 then
				local newRoom = StageAPI.GenerateBossRoom({
					BossID = "Duke of Fluff",
					NoPlayBossAnim = false,
					CheckEncountered = false,
				}, {
					RoomDescriptor = InutilLib.level:GetCurrentRoomDesc()
				})

				--StageAPI.SetLevelRoom(newRoom, InutilLib.level:GetCurrentRoomDesc().ListIndex)
				return newRoom, true
			elseif InutilLib.level:GetStage() == LevelStage.STAGE2_2 then
				local newRoom = StageAPI.GenerateBossRoom({
					BossID = "Pom Poms",
					NoPlayBossAnim = false,
					CheckEncountered = false,
				}, {
					RoomDescriptor = InutilLib.level:GetCurrentRoomDesc()
				})

				--StageAPI.SetLevelRoom(newRoom, InutilLib.level:GetCurrentRoomDesc().ListIndex)
				return newRoom, true
			elseif InutilLib.level:GetStage() == LevelStage.STAGE3_1 then
				local newRoom = StageAPI.GenerateBossRoom({
					BossID = "The Puff",
					NoPlayBossAnim = false,
					CheckEncountered = false,
				}, {
					RoomDescriptor = InutilLib.level:GetCurrentRoomDesc()
				})

				--StageAPI.SetLevelRoom(newRoom, InutilLib.level:GetCurrentRoomDesc().ListIndex)
				return newRoom, true
			elseif InutilLib.level:GetStage() == LevelStage.STAGE3_2 then
				local newRoom = StageAPI.GenerateBossRoom({
					BossID = "The Demon Lordess",
					NoPlayBossAnim = false,
					CheckEncountered = false,
				}, {
					RoomDescriptor = InutilLib.level:GetCurrentRoomDesc()
				})

				--StageAPI.SetLevelRoom(newRoom, InutilLib.level:GetCurrentRoomDesc().ListIndex)
				return newRoom, true
			end
		end
	end
end)