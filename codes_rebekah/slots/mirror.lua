local mirrorRoomData = RebekahLocalSavedata.Data.mirrorRoomData --keeps mirror data in each room on each grid

function yandereWaifu.MirrorRoomInit(_, hasstarted) --Init
	if not hasstarted then
		RebekahLocalSavedata.Data.mirrorRoomData = {}
		RebekahLocalSavedata.Data.bossRoomsCleared = {}
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, yandereWaifu.MirrorRoomInit)

--stuff to check how much boss room you cleared
function yandereWaifu.TrySpawnMirror()
	--print(game:GetLevel():GetCurrentRoomDesc().GridIndex)
	for p = 0, InutilLib.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		if yandereWaifu.IsNormalRebekah(player)  then
			local room = InutilLib.game:GetRoom()
			local level = InutilLib.game:GetLevel()
			-- if we're in a boss room and the room is clear
			local isGreed = InutilLib.game.Difficulty == Difficulty.DIFFICULTY_GREED or InutilLib.game.Difficulty == Difficulty.DIFFICULTY_GREEDIER
			if (room:GetType() == RoomType.ROOM_BOSS or (isGreed and level:GetCurrentRoomDesc().GridIndex--[[GetCurrentRoomIndex()]] == 110 --[[room:GetType() == RoomType.ROOM_SHOP]])) and room:IsClear() then
				local add = false
		
				-- iterate through the saved boss rooms
				for i, something in pairs(RebekahLocalSavedata.Data.bossRoomsCleared) do 
					-- if we're in a room that had been cleared before, flag it
					if RebekahLocalSavedata.Data.bossRoomsCleared[i][1] == level:GetCurrentRoomDesc().GridIndex and RebekahLocalSavedata.Data.bossRoomsCleared[i][2] == level:GetStage() then
						add = true

					end
				end
				-- if not flagged, add a mirror entity at the center of the room
				if not add then
					table.insert(RebekahLocalSavedata.Data.bossRoomsCleared, {level:GetCurrentRoomDesc().GridIndex, level:GetStage()} );
					local spawnPosition = room:FindFreePickupSpawnPosition(room:GetCenterPos(), 1);
					local subtype = 0
					--bride --if ( yandereWaifu.GetEntityData(player).currentMode==REBECCA_MODE.RedHearts and level:GetStage() == 10 ) then subtype = 1 else subtype = 0 end
					local mir = Isaac.Spawn(EntityType.ENTITY_SLOT, RebekahCurse.ENTITY_REBMIRROR, subtype, spawnPosition, Vector(0,0), player);
					yandereWaifu.GetEntityData(mir).Init = false
					mir:GetSprite():Play("Appear")
				end
			end
		end
	end
end

function yandereWaifu.HandleMirrorData()
	if not RebekahLocalSavedata.Data.mirrorRoomData then return end
	--if mirrorRoomData then
		for i, mir in pairs (Isaac.FindByType(EntityType.ENTITY_SLOT, RebekahCurse.ENTITY_REBMIRROR, -1, false, false)) do
			local room = InutilLib.game:GetRoom()
			local level = InutilLib.game:GetLevel()
			if not RebekahLocalSavedata.Data.mirrorRoomData[i] then RebekahLocalSavedata.Data.mirrorRoomData[i] = {} end
			RebekahLocalSavedata.Data.mirrorRoomData[i][1] = level:GetCurrentRoomDesc().GridIndex
			RebekahLocalSavedata.Data.mirrorRoomData[i][2] = room:GetGridIndex(mir.Position)
			RebekahLocalSavedata.Data.mirrorRoomData[i][3] = yandereWaifu.GetEntityData(mir).Use
			--print(room:GetGridIndex(mir.Position))
		end
	--end
end

function yandereWaifu.InsertMirrorData()
	if not RebekahLocalSavedata.Data.mirrorRoomData then return end
	for i, something in pairs(RebekahLocalSavedata.Data.mirrorRoomData) do 
		--if it has, then insert
		if RebekahLocalSavedata.Data.mirrorRoomData[i][1] == InutilLib.level:GetCurrentRoomDesc().GridIndex then
			for m, mir in pairs (Isaac.FindByType(EntityType.ENTITY_SLOT, RebekahCurse.ENTITY_REBMIRROR, -1, false, false)) do
				if InutilLib.room:GetGridIndex(mir.Position) == RebekahLocalSavedata.Data.mirrorRoomData[i][2] then
				--	print("scar")
					yandereWaifu.GetEntityData(mir).Use = RebekahLocalSavedata.Data.mirrorRoomData[i][3]
				--	print(mirrorRoomData[i][3])
				--	print("yeah"..tostring(yandereWaifu.GetEntityData(mir).Use))
				end
			end
		end
	end
end



--mirror
function yandereWaifu.MirrorMechanic(player) 
	local totalTypesofHearts = 0; --counts the total amount of hearts available
	local totalCurTypesofHearts = {};
	local totalUnlockedTypesofHearts = {}
	local getRebekahsPresent = 0
	
	
	local heartTableUnlocks = {
			ShowRed = true,
			ShowBlue = true,
			ShowGold = true,
			ShowEvil = true,
			ShowEternal = true,
			ShowBone = true,
			ShowRotten = true,
			ShowBroken = true
	}
	
	for p = 0, InutilLib.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		local playerdata = yandereWaifu.GetEntityData(player);
		
		local heartTable = {
			ShowRed = false,
			ShowBlue = false,
			ShowGold = false,
			ShowEvil = false,
			ShowEternal = false,
			ShowBone = false,
			ShowRotten = false,
			ShowBroken = false
		}
		
		--health code

		--heart code checking
		if yandereWaifu.IsNormalRebekah(player) then
			if player:GetHearts() > 1 then heartTable.ShowRed = true end
			if player:GetSoulHearts() > 1 and (player:GetSoulHearts()-yandereWaifu.GetPlayerBlackHearts(player))> 0 then heartTable.ShowBlue = true end	
			if player:GetGoldenHearts() > 0 then heartTable.ShowGold = true end
			if yandereWaifu.GetPlayerBlackHearts(player) > 1 then heartTable.ShowEvil = true end
			if player:GetEternalHearts() > 0 then heartTable.ShowEternal = true end
			if player:GetBoneHearts() > 0 then heartTable.ShowBone = true end
			if player:GetRottenHearts() > 0 then heartTable.ShowRotten = true end
			if player:GetBrokenHearts() > 0 then heartTable.ShowBroken = true end
			
			
			getRebekahsPresent = getRebekahsPresent + 1
		end

		--current heart collecting
		for i, heart in pairs (heartTable) do --8 because of eight hearts that exists in Isaac
			if heart == true then
				totalTypesofHearts = totalTypesofHearts + 1;
				table.insert(totalCurTypesofHearts, tostring(i));
			end
		end
		for i, heart in pairs (heartTableUnlocks) do --8 because of eight hearts that exists in Isaac
			if heart == true then
				totalTypesofHearts = totalTypesofHearts + 1;
				table.insert(totalUnlockedTypesofHearts, tostring(i));
			end
		end
	end
	
	for p = 0, InutilLib.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		local playerdata = yandereWaifu.GetEntityData(player);
		
		local heartBrideTable = {
			Show = false
		}
		
		if player:HasCollectible(CollectibleType.COLLECTIBLE_ISAACS_HEART) then heartBrideTable.Show = true end
		
		--mirror code
		for i, mir in pairs (Isaac.FindByType(EntityType.ENTITY_SLOT , RebekahCurse.ENTITY_REBMIRROR, -1, false, false)) do
			if not InutilLib.IsShowingItem(player) and mir.SubType ~= 20 then
				local mirdata = yandereWaifu.GetEntityData(mir);
				local sprite = mir:GetSprite();
				
				if not mirdata.currentSavedHearts then
					if mir.SubType ~= 10 then
						mirdata.currentSavedHearts = totalCurTypesofHearts;
						mirdata.currentSavedHeartsNum = #totalCurTypesofHearts;
					else --makes all hearts available
						mirdata.currentSavedHearts = totalUnlockedTypesofHearts;
						mirdata.currentSavedHeartsNum = #totalUnlockedTypesofHearts;
					end
				end --this saves how much totalCurTypesofHearts you have when the mirror is in the process in presenting a bunch of hearts, so that it won't glitch
				if not mirdata.currentHeart then mirdata.currentHeart = 1 end
				if mir.FrameCount == 1 then
					if not mirdata.FirstPos then mirdata.FirstPos = mir.Position end --code to check if it's "broken", it's very wack, I hate it, but I can't do anything else, so deal with it
					if mir.SubType == 1 then
						local arcane = Isaac.Spawn( EntityType.ENTITY_EFFECT, ENTITY_ARCANE_CIRCLE, 0, player.Position, Vector(0,0), player );
						mirdata.Circle = arcane
					end
					if not mirdata.Use then mirdata.Use = getRebekahsPresent end --InutilLib.game:GetNumPlayers() end
					if not mirdata.Init then mirdata.Init = true end
				end
				if mir.GridCollisionClass ~= 0 --[[mir.Position:Distance(mirdata.FirstPos) > 30]] then
					if not mirdata.Dead then
						mirdata.Dead = true;
					end 
				end
				if mir.SubType ~= 1 then --temporary as i still dont know what to do with bride mirror
					if not mirdata.Init --[[and not sprite:IsPlaying("Idle")]] then
						if not sprite:IsPlaying("Appear") then
							sprite:Play("Appear")
						end
						if sprite:IsFinished("Appear") then
							--sprite:Play("StartUp");
							sprite:PlayOverlay(tostring(mirdata.Use).."_Use", true)
							mirdata.notAlive = false
							--sprite:Play("StartUp", true);
							mirdata.currentHeart = 1
							sprite:Play(mirdata.currentSavedHearts[mirdata.currentHeart], true)
							mirdata.Init = true
							--break
						end
					elseif not sprite:IsPlaying("Appear") and mirdata.Init then
						if mirdata.Dead and not sprite:IsPlaying("Death") and not mirdata.DeadFinished then 
							if mir.SubType ~= 10 then
								--heart only drop mechanic
								sprite:Play("Death", true);
								for j, pickup in pairs (Isaac.FindByType(EntityType.ENTITY_PICKUP, -1, -1, false, false)) do
									if (pickup.Position):Distance(mir.Position) <= 50 and pickup.FrameCount <= 1 then
										if math.random(1,4) == 4 then
											local newpickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, RebekahMirrorHeartDrop[math.random(1,6)], pickup.Position, pickup.Velocity, pickup)
										elseif math.random(1,2) == 2 then
											local newpickup = Isaac.Spawn(RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY, RebekahCurseEnemies.ENTITY_REDTATO, math.random(0,6), pickup.Position,  pickup.Velocity, pickup)
										end
										pickup:Remove()
									end
								end
								if not mirdata.DeadFinished then
									mirdata.DeadFinished = true;
								end 
							else
								Isaac.Spawn(EntityType.ENTITY_SLOT, RebekahCurse.ENTITY_REBMIRROR, 10, mir.Position, Vector(0,0), player)
								for j, pickup in pairs (Isaac.FindByType(EntityType.ENTITY_PICKUP, -1, -1, false, false)) do
									if (pickup.Position):Distance(mir.Position) <= 50 and pickup.FrameCount <= 1 then
										local newpickup = Isaac.Spawn(RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY, RebekahCurseEnemies.ENTITY_REDTATO, 1, pickup.Position,  Vector.FromAngle( math.random() * 360 ):Resized(math.random(1,6)), pickup)
										yandereWaifu.GetEntityData(newpickup).NoDrop = true
										pickup:Remove()
									end
								end
								mir:Remove()
							end
						else
							if not mirdata.ForceOverlay then
								sprite:PlayOverlay(tostring(mirdata.Use).."_Use", true)
								mirdata.ForceOverlay = true
							end
							if mir.FrameCount == 2 then
								if not sprite:IsPlaying("Appear") then
									--sprite:Play("StartUp", true);
									sprite:PlayOverlay(tostring(mirdata.Use).."_Use", true)
								end
								mirdata.currentHeart = 1 --keeps track of how much you went through to the totalCurTypesofHearts
							elseif mir.FrameCount >= 10 and not mirdata.Dead then
								if sprite:IsFinished("Initiate") then
									mirdata.notAlive = false
									--sprite:Play("StartUp", true);
									mirdata.currentHeart = 1
									sprite:Play(mirdata.currentSavedHearts[mirdata.currentHeart], true)
									mirdata.Use = mirdata.Use - 1
									if mirdata.Use > 0 then
										sprite:PlayOverlay(tostring(mirdata.Use).."_Use", true)
									else
										mirdata.notAlive = true;
									end
								end
								if not mirdata.notAlive then
									--print(mirdata.currentHeart)
									if mirdata.currentSavedHeartsNum and mirdata.currentHeart then
										--print("film")
										if mirdata.currentHeart <= mirdata.currentSavedHeartsNum then
											
											if mirdata.IsDisplaying == nil or mirdata.IsDisplaying == false then --IsDisplaying tells if the mirror is playing something
											--	print(mirdata.IsDisplaying)
												
												mirdata.IsDisplaying = true;
												sprite:Play(mirdata.currentSavedHearts[mirdata.currentHeart], true);
											--	print("goes here"..tostring(mirdata.currentHeart)..tostring(totalCurTypesofHearts[mirdata.currentHeart]))
											elseif sprite:IsFinished(mirdata.currentSavedHearts[mirdata.currentHeart]) then
												mirdata.IsDisplaying = false;
												mirdata.currentHeart = mirdata.currentHeart + 1;
											end
										else
											mirdata.currentHeart = 1; --reset
											mirdata.currentSavedHearts = nil;
										end
									elseif not mirdata.currentSavedHearts then
										if mir.SubType ~= 10 then
											mirdata.currentSavedHearts = totalCurTypesofHearts;
											mirdata.currentSavedHeartsNum = #totalCurTypesofHearts;
										else --makes all hearts available
											mirdata.currentSavedHearts = totalUnlockedTypesofHearts;
											mirdata.currentSavedHeartsNum = #totalUnlockedTypesofHearts;
										end
									end
									
									--if sprite:IsFinished("Initiate") then
									--	mirdata.currentHeart = 1; --reset
									--	mirdata.currentSavedHearts = nil;
									--	print("cross")
									--end
									
									local newMode = yandereWaifu.GetEntityData(player).currentMode;
									if mir.Position:Distance( player.Position ) < mir.Size + player.Size and #totalCurTypesofHearts > 0 and player.EntityCollisionClass ~=  EntityCollisionClass.ENTCOLL_NONE and not player:GetSprite():IsPlaying("Trapdoor") and not sprite:IsPlaying("Initiate") and not yandereWaifu.GetEntityData(player).IsAttackActive then --if interacted
										--print("trigger")
										if sprite:IsPlaying("ShowRed") and yandereWaifu.GetEntityData(player).currentMode ~= REBECCA_MODE.RedHearts 
											and (player:GetHearts() > 1 or mir.SubType == 10) then
											newMode = REBECCA_MODE.RedHearts;
										elseif sprite:IsPlaying("ShowBlue") and yandereWaifu.GetEntityData(player).currentMode ~= REBECCA_MODE.SoulHearts 
											and ((player:GetSoulHearts() > 1 and (player:GetSoulHearts()-yandereWaifu.GetPlayerBlackHearts(player))> 0) or mir.SubType == 10) then
											newMode = REBECCA_MODE.SoulHearts
										elseif sprite:IsPlaying("ShowGold") and yandereWaifu.GetEntityData(player).currentMode ~= REBECCA_MODE.GoldHearts 
											and (player:GetGoldenHearts() > 0 or mir.SubType == 10) then
											newMode = REBECCA_MODE.GoldHearts
										elseif sprite:IsPlaying("ShowEvil") and yandereWaifu.GetEntityData(player).currentMode ~= REBECCA_MODE.EvilHearts 
											and (yandereWaifu.GetPlayerBlackHearts(player) > 1 or mir.SubType == 10) then
											newMode = REBECCA_MODE.EvilHearts
										elseif sprite:IsPlaying("ShowEternal") and yandereWaifu.GetEntityData(player).currentMode ~= REBECCA_MODE.EternalHearts 
											and (player:GetEternalHearts() > 0 or mir.SubType == 10) then
											newMode = REBECCA_MODE.EternalHearts;
										elseif sprite:IsPlaying("ShowBone") and yandereWaifu.GetEntityData(player).currentMode ~= REBECCA_MODE.BoneHearts 
											and (player:GetBoneHearts() > 0 or mir.SubType == 10) then
											newMode = REBECCA_MODE.BoneHearts;
										elseif sprite:IsPlaying("ShowRotten") and yandereWaifu.GetEntityData(player).currentMode ~= REBECCA_MODE.RottenHearts
											and (player:GetRottenHearts() > 0 or mir.SubType == 10) then
											newMode = REBECCA_MODE.RottenHearts;
										elseif sprite:IsPlaying("ShowBroken") and yandereWaifu.GetEntityData(player).currentMode ~= REBECCA_MODE.BrokenHearts 
											and (player:GetBrokenHearts() > 0 or mir.SubType == 10) then
											newMode = REBECCA_MODE.BrokenHearts;
										end
										if newMode ~= yandereWaifu.GetEntityData(player).currentMode and not sprite:IsPlaying("Initiate") and yandereWaifu.IsNormalRebekah(player) then
											local isFree = mir.SubType == 10
											
											mirdata.notAlive = true;
											player:AnimateSad();
											sprite:Play("Initiate", true);
											yandereWaifu.ChangeMode( player, newMode, isFree, false);
											--don't move
											player.Velocity = Vector(0,0)
											mirdata.currentHeart = 1; --reset
											--print("happy")
											--local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, ENTITY_PERSONALITYPOOF, 0, player.Position, Vector.Zero, player)
										end
									end
									
									--EID displaying
									if sprite:GetFrame() == 0 and EID and EIDRebekahsMirror then
										local Description
										if sprite:IsPlaying("ShowRed") then
											Description = EIDRebekahsMirror.Red
										elseif sprite:IsPlaying("ShowBlue") then
											Description = EIDRebekahsMirror.Soul
										elseif sprite:IsPlaying("ShowGold") then
											Description = EIDRebekahsMirror.Gold
										elseif sprite:IsPlaying("ShowEvil") then
											Description = EIDRebekahsMirror.Evil
										elseif sprite:IsPlaying("ShowEternal") then
											Description = EIDRebekahsMirror.Eternal
										elseif sprite:IsPlaying("ShowBone") then
											Description = EIDRebekahsMirror.Bone
										elseif sprite:IsPlaying("ShowRotten") then
											Description = EIDRebekahsMirror.Rotten
										elseif sprite:IsPlaying("ShowBroken") then
											Description = EIDRebekahsMirror.Broken
										end
										mir:GetData()["EID_Description"] = Description
									end
								else
									if mirdata.Use <= 0 and mir.SubType ~= 10 then
										if heartBrideTable.Show then
											local newpickup = Isaac.Spawn(EntityType.ENTITY_SLOT, RebekahCurse.ENTITY_REBMIRROR, 1, mir.Position, Vector(0,0), mir)
											mir:Remove()
										else
											sprite:Play("FinishedJob", false);
											sprite:RemoveOverlay()
										end
										if sprite:IsFinished("FinishedJob") then
											mir:Remove();
										end
									else
										mirdata.notAlive = false --just to make sure it reactivates, you know?
									end
								end
								if mir.Position:Distance(player.Position) > mir.Size + player.Size + 45 then --if close or far, speed up or not?
									mir:GetSprite().PlaybackSpeed = 2;
								else
									mir:GetSprite().PlaybackSpeed = 0.002;
								end
							end
						end
					end
				elseif mir.SubType == 1 then
					if mirdata.Dead and not sprite:IsPlaying("Death") and not mirdata.DeadFinished then --heart only drop mechanic
						sprite:Play("Death", true);
						mirdata.Circle:GetSprite():Play("FadeOut",true)
						for j, pickup in pairs (Isaac.FindByType(EntityType.ENTITY_PICKUP, -1, -1, false, false)) do
							if (pickup.Position):Distance(mir.Position) <= 50 and pickup.FrameCount <= 1 then
								local newpickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, RebekahMirrorHeartDrop[math.random(1,6)], pickup.Position, pickup.Velocity, pickup)
								pickup:Remove()
							end
						end
						if not mirdata.DeadFinished then
							mirdata.DeadFinished = true;
						end 
					else
						if mirdata.Circle then mirdata.Circle.Position = mir.Position end
						if mir.FrameCount == 2 then
							if not sprite:IsPlaying("Appear") then
								sprite:Play("StartUp", true);
							end
						elseif mir.FrameCount >= 10 and not mirdata.Dead then
							if not mirdata.notAlive then
								if not sprite:IsPlaying("ShowBRed") then  sprite:Play("ShowBRed", true) end
								
								local newMode = yandereWaifu.GetEntityData(player).currentMode;
								if yandereWaifu.IsNormalRebekah(player) then
									if mir.Position:Distance( player.Position ) < mir.Size + player.Size and heartBrideTable.Show and player.EntityCollisionClass ~=  EntityCollisionClass.ENTCOLL_NONE and not player:GetSprite():IsPlaying("Trapdoor") then --if interacted
										if sprite:IsPlaying("ShowBRed") and yandereWaifu.GetEntityData(player).currentMode ~= REBECCA_MODE.BrideRedHearts then
											newMode = REBECCA_MODE.BrideRedHearts;
										end
										if newMode ~= yandereWaifu.GetEntityData(player).currentMode then
											mirdata.notAlive = true;
											player:AnimateSad();
											sprite:Play("Initiate", true);
											yandereWaifu.ChangeMode( player, newMode );
											--don't move
											player:RemoveCollectible(CollectibleType.COLLECTIBLE_ISAACS_HEART)
											player.Velocity = Vector(0,0)
											mirdata.Circle:GetSprite():Play("FadeOut",true)
											InutilLib.game:Darken(5,1200)
											InutilLib.AnimateGiantbook(nil, nil, "Marry", "gfx/ui/giantbook/giantbook_marriage.anm2", true, true)
										end
									end
								end
							else
								if sprite:IsFinished("Initiate") then
									sprite:Play("FinishedJob", true);
								elseif sprite:IsFinished("FinishedJob") then
									mir:Remove();
								end
							end
							if mir.Position:Distance(player.Position) > mir.Size + player.Size + 45 then --if close or far, speed up or not?
								mir:GetSprite().PlaybackSpeed = 3;
							else
								mir:GetSprite().PlaybackSpeed = 1;
							end
						end
					end
				end
			end
		end
	end
end

