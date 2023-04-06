
--mirror
function yandereWaifu.ConverterMirrorMechanic(player) 
	local totalTypesofHearts = 0; --counts the total amount of hearts available
	local totalCurTypesofHearts = {};
	local totalUnlockedTypesofHearts = {}
	local getRebekahsPresent = 0
	
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
		--if yandereWaifu.IsNormalRebekah(player) then
			if player:GetHearts() > 2 then heartTable.ShowRed = true end
			if player:GetSoulHearts() > 2 and (player:GetSoulHearts()-yandereWaifu.GetPlayerBlackHearts(player))> 2 then heartTable.ShowBlue = true end	
			if player:GetGoldenHearts() > 0 then heartTable.ShowGold = true end
			if yandereWaifu.GetPlayerBlackHearts(player) > 2 then heartTable.ShowEvil = true end
			if player:GetEternalHearts() > 0 then heartTable.ShowEternal = true end
			if player:GetBoneHearts() > 0 then heartTable.ShowBone = true end
			if player:GetRottenHearts() > 0 then heartTable.ShowRotten = true end
			if player:GetBrokenHearts() > 0 then heartTable.ShowBroken = true end
			
			
		--	getRebekahsPresent = getRebekahsPresent + 1
		--end

		--current heart collecting
		for i, heart in pairs (heartTable) do --8 because of eight hearts that exists in Isaac
			if heart == true then
				totalTypesofHearts = totalTypesofHearts + 1;
				table.insert(totalCurTypesofHearts, tostring(i));
			end
		end
		--[[for i, heart in pairs (heartTableUnlocks) do --8 because of eight hearts that exists in Isaac
			if heart == true then
				totalTypesofHearts = totalTypesofHearts + 1;
				table.insert(totalUnlockedTypesofHearts, tostring(i));
			end
		end]]
	end
	
	for p = 0, InutilLib.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		local playerdata = yandereWaifu.GetEntityData(player);
		
		local heartBrideTable = {
			Show = false
		}
		
		if player:HasCollectible(CollectibleType.COLLECTIBLE_ISAACS_HEART) then heartBrideTable.Show = true end
		--mirror code
		for i, mir in pairs (Isaac.FindByType(EntityType.ENTITY_SLOT, RebekahCurse.ENTITY_REBMIRROR, -1, false, false)) do
			if not InutilLib.IsShowingItem(player) and mir.SubType == 20 then
				local mirdata = yandereWaifu.GetEntityData(mir);
				local sprite = mir:GetSprite();
				
				if not mirdata.currentSavedHearts then
					--if mir.SubType ~= 10 then
						mirdata.currentSavedHearts = totalCurTypesofHearts;
						mirdata.currentSavedHeartsNum = #totalCurTypesofHearts;
					--[[else --makes all hearts available
						mirdata.currentSavedHearts = totalUnlockedTypesofHearts;
						mirdata.currentSavedHeartsNum = #totalUnlockedTypesofHearts;
					end]]
				end --this saves how much totalCurTypesofHearts you have when the mirror is in the process in presenting a bunch of hearts, so that it won't glitch
				if not mirdata.currentHeart then mirdata.currentHeart = 1 end
				if mir.FrameCount == 1 then
					if not mirdata.FirstPos then mirdata.FirstPos = mir.Position end --code to check if it's "broken", it's very wack, I hate it, but I can't do anything else, so deal with it
					if mir.SubType == 1 then
						local arcane = Isaac.Spawn( EntityType.ENTITY_EFFECT, ENTITY_ARCANE_CIRCLE, 0, player.Position, Vector(0,0), player );
						mirdata.Circle = arcane
					end
					--if not mirdata.Use then mirdata.Use = getRebekahsPresent end --InutilLib.game:GetNumPlayers() end
					if not mirdata.Init then mirdata.Init = true end
				end
				if mir.GridCollisionClass ~= 0 --[[mir.Position:Distance(mirdata.FirstPos) > 30]] then
					if not mirdata.Dead then
						mirdata.Dead = true;
					end 
				end
				if mir.SubType ~= 1 then 
					if not mirdata.Init --[[and not sprite:IsPlaying("Idle")]] then
						if not sprite:IsPlaying("Appear") then
							sprite:Play("Appear")
						end
						if sprite:IsFinished("Appear") then
							--sprite:Play("StartUp");
							--sprite:PlayOverlay(tostring(mirdata.Use).."_Use", true)
							mirdata.notAlive = false
							--sprite:Play("StartUp", true);
							mirdata.currentHeart = 1
							sprite:Play(mirdata.currentSavedHearts[mirdata.currentHeart], true)
							mirdata.Init = true
							--break
						end
					elseif not sprite:IsPlaying("Appear") and mirdata.Init then
						if mirdata.Dead and not sprite:IsPlaying("Death") and not mirdata.DeadFinished then 
							for j, pickup in pairs (Isaac.FindByType(EntityType.ENTITY_PICKUP, -1, -1, false, false)) do
								if (pickup.Position):Distance(mir.Position) <= 50 and pickup.FrameCount <= 1 then
									local newpickup = Isaac.Spawn(RebekahCurse.Enemies.ENTITY_REBEKAH_ENEMY, RebekahCurse.Enemies.ENTITY_REDTATO, 0, pickup.Position,  pickup.Velocity, pickup)
									--local newpickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, RebekahCurse.RebekahMirrorHeartDrop[math.random(1,6)], pickup.Position, pickup.Velocity, pickup)
									pickup:Remove()
								end
							end
							--mir:Remove()
							if not sprite:IsFinished("Death") then
								sprite:Play("Death")
							end
						else
							if not mirdata.ForceOverlay then
								--sprite:PlayOverlay(tostring(mirdata.Use).."_Use", true)
								mirdata.ForceOverlay = true
							end
							if mir.FrameCount == 2 then
								if not sprite:IsPlaying("Appear") then
									--sprite:Play("StartUp", true);
									--sprite:PlayOverlay(tostring(mirdata.Use).."_Use", true)
								end
								mirdata.currentHeart = 1 --keeps track of how much you went through to the totalCurTypesofHearts
							elseif mir.FrameCount >= 10 and not mirdata.Dead then
								if sprite:IsFinished("Initiate") then
									mirdata.notAlive = false
									--sprite:Play("StartUp", true);
									mirdata.currentHeart = 1
									sprite:Play(mirdata.currentSavedHearts[mirdata.currentHeart], true)
									--mirdata.Use = mirdata.Use - 1
									--if mirdata.Use > 0 then
									--	sprite:PlayOverlay(tostring(mirdata.Use).."_Use", true)
									--else
									--	mirdata.notAlive = true;
									--end
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
									local data = yandereWaifu.GetEntityData(player)
									if mir.Position:Distance( player.Position ) < mir.Size + player.Size and #totalCurTypesofHearts > 0 and player.EntityCollisionClass ~=  EntityCollisionClass.ENTCOLL_NONE and not player:GetSprite():IsPlaying("Trapdoor") and not sprite:IsPlaying("Initiate") and not yandereWaifu.GetEntityData(player).IsAttackActive then --if interacted
										--print("trigger")
									
										if sprite:IsPlaying("ShowRed") 
											and (player:GetHearts() >= 1 or mir.SubType == 10) then
											local rng = math.random(1,6)
											if rng == 1 then
												data.PersistentPlayerData.RedStatBuffDamage = data.PersistentPlayerData.RedStatBuffDamage + 1
											elseif rng == 2 then
												data.PersistentPlayerData.RedStatBuffFireDelay = data.PersistentPlayerData.RedStatBuffFireDelay + 1
											elseif rng == 3 then
												data.PersistentPlayerData.RedStatBuffLuck = data.PersistentPlayerData.RedStatBuffLuck + 1
											elseif rng == 4 then
												data.PersistentPlayerData.RedStatBuffRange = data.PersistentPlayerData.RedStatBuffRange + 1
											elseif rng == 5 then
												data.PersistentPlayerData.RedStatBuffShotSpeed = data.PersistentPlayerData.RedStatBuffShotSpeed + 1
											elseif rng == 6 then
												data.PersistentPlayerData.RedStatBuffSpeed = data.PersistentPlayerData.RedStatBuffSpeed + 1
											end
											player:AddHearts(-2)
										elseif sprite:IsPlaying("ShowBlue") 
											and ((player:GetSoulHearts() >= 1 and (player:GetSoulHearts()-yandereWaifu.GetPlayerBlackHearts(player))> 0) or mir.SubType == 10) then
											data.PersistentPlayerData.SoulStatBuff = data.PersistentPlayerData.SoulStatBuff + 1
											player:AddSoulHearts(-2)
										elseif sprite:IsPlaying("ShowGold") 
											and (player:GetGoldenHearts() >= 1 or mir.SubType == 10) then
											data.PersistentPlayerData.GoldStatBuff = data.PersistentPlayerData.GoldStatBuff + 1
											player:AddGoldenHearts(-1)
										elseif sprite:IsPlaying("ShowEvil") 
											and (yandereWaifu.GetPlayerBlackHearts(player) >= 1 or mir.SubType == 10) then
											data.PersistentPlayerData.EvilStatBuff = data.PersistentPlayerData.EvilStatBuff + 1
											player:AddBlackHearts(-2)
										elseif sprite:IsPlaying("ShowEternal") 
											and (player:GetEternalHearts() >= 1 or mir.SubType == 10) then
											data.PersistentPlayerData.EternalStatBuff = data.PersistentPlayerData.EternalStatBuff + 1
											player:AddEternalHearts(-1)
										elseif sprite:IsPlaying("ShowBone") 
											and (player:GetBoneHearts() >= 1 or mir.SubType == 10) then
											data.PersistentPlayerData.BoneStatBuff = data.PersistentPlayerData.BoneStatBuff + 1
											player:AddBoneHearts(-1)
										elseif sprite:IsPlaying("ShowRotten") 
											and (player:GetRottenHearts() >= 1 or mir.SubType == 10) then
											data.PersistentPlayerData.RottenStatBuff = data.PersistentPlayerData.RottenStatBuff + 1
											player:AddRottenHearts(-1)
										elseif sprite:IsPlaying("ShowBroken") 
											and (player:GetBrokenHearts() >= 1 or mir.SubType == 10) then
											data.PersistentPlayerData.BrokenStatBuff = data.PersistentPlayerData.BrokenStatBuff + 1
											player:AddBrokenHearts(-1)
										end
										if not sprite:IsPlaying("Initiate") then
											local isFree = mir.SubType == 10
											
											--mirdata.notAlive = true;
											player:AnimateSad();
											sprite:Play("Initiate", true);
											
											--yandereWaifu.ChangeMode( player, newMode, isFree, false);
											player:AddCacheFlags(CacheFlag.CACHE_ALL);
											player:EvaluateItems();
											--don't move
											player.Velocity = Vector(0,0)
											mirdata.currentHeart = 1; --reset
											if math.random(1,7) == 7 then
												--Isaac.Explode(mir.Position, player, 0)
												mir.GridCollisionClass = 1
												mir:Die()
												mir.Velocity = (mir.Position - player.Position):Resized(6)
											end
											--print("happy")
											--local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, ENTITY_PERSONALITYPOOF, 0, player.Position, Vector.Zero, player)
										end
									end
									
									--EID displaying
									if sprite:GetFrame() == 0 and EID then
										local Description
										if sprite:IsPlaying("ShowRed") then
											Description = EIDMakeupStation.Red
										elseif sprite:IsPlaying("ShowBlue") then
											Description = EIDMakeupStation.Soul
										elseif sprite:IsPlaying("ShowGold") then
											Description = EIDMakeupStation.Gold
										elseif sprite:IsPlaying("ShowEvil") then
											Description = EIDMakeupStation.Evil
										elseif sprite:IsPlaying("ShowEternal") then
											Description = EIDMakeupStation.Eternal
										elseif sprite:IsPlaying("ShowBone") then
											Description = EIDMakeupStation.Bone
										elseif sprite:IsPlaying("ShowRotten") then
											Description = EIDMakeupStation.Rotten
										elseif sprite:IsPlaying("ShowBroken") then
											Description = EIDMakeupStation.Broken
										end
										mir:GetData()["EID_Description"] = Description
									end
								else
									if --[[mirdata.Use <= 0 and]] mir.SubType ~= 10 then
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
									mir:GetSprite().PlaybackSpeed = 1;
								end
							end
						end
					end
				end
			end
		end
	end
end

yandereWaifu:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
	yandereWaifu.ConverterMirrorMechanic(player) 
end)

yandereWaifu:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_,player, cacheF) --The thing the checks and updates the game, i guess?
	local data = yandereWaifu.GetEntityData(player)
	if data.PersistentPlayerData then
		if not data.PersistentPlayerData.RedStatBuffSpeed then data.PersistentPlayerData.RedStatBuffSpeed = 0 end
		if not data.PersistentPlayerData.RedStatBuffFireDelay then data.PersistentPlayerData.RedStatBuffFireDelay = 0 end
		if not data.PersistentPlayerData.RedStatBuffDamage then data.PersistentPlayerData.RedStatBuffDamage = 0 end
		if not data.PersistentPlayerData.RedStatBuffShotSpeed then data.PersistentPlayerData.RedStatBuffShotSpeed = 0 end
		if not data.PersistentPlayerData.RedStatBuffLuck then data.PersistentPlayerData.RedStatBuffLuck = 0 end
		if not data.PersistentPlayerData.RedStatBuffRange then data.PersistentPlayerData.RedStatBuffRange = 0 end
		if not data.PersistentPlayerData.SoulStatBuff then data.PersistentPlayerData.SoulStatBuff = 0 end
		if not data.PersistentPlayerData.GoldStatBuff then data.PersistentPlayerData.GoldStatBuff = 0 end
		if not data.PersistentPlayerData.EvilStatBuff then data.PersistentPlayerData.EvilStatBuff = 0 end
		if not data.PersistentPlayerData.EternalStatBuff then data.PersistentPlayerData.EternalStatBuff = 0 end
		if not data.PersistentPlayerData.BoneStatBuff then data.PersistentPlayerData.BoneStatBuff = 0 end
		if not data.PersistentPlayerData.RottenStatBuff then data.PersistentPlayerData.RottenStatBuff = 0 end
		if not data.PersistentPlayerData.BrokenStatBuff then data.PersistentPlayerData.BrokenStatBuff = 0 end
		if cacheF == CacheFlag.CACHE_SPEED then
			player.MoveSpeed = player.MoveSpeed + 0.05*data.PersistentPlayerData.RedStatBuffSpeed + 0.1*data.PersistentPlayerData.EternalStatBuff + 0.05*data.PersistentPlayerData.SoulStatBuff + 0.1*data.PersistentPlayerData.BoneStatBuff
		end
		if cacheF == CacheFlag.CACHE_FIREDELAY then
			player.MaxFireDelay = player.MaxFireDelay - 0.5*data.PersistentPlayerData.RedStatBuffFireDelay - 1*data.PersistentPlayerData.EternalStatBuff - 0.5*data.PersistentPlayerData.SoulStatBuff
		end
		if cacheF == CacheFlag.CACHE_DAMAGE then
			player.Damage = player.Damage + 0.5*data.PersistentPlayerData.RedStatBuffDamage + 1.2*data.PersistentPlayerData.EternalStatBuff + 1*data.PersistentPlayerData.EvilStatBuff + 2*data.PersistentPlayerData.GoldStatBuff + 1.5*data.PersistentPlayerData.BoneStatBuff + 1*data.PersistentPlayerData.RottenStatBuff
		end
		if cacheF == CacheFlag.CACHE_SHOTSPEED then
			player.ShotSpeed = player.ShotSpeed + 0.05*data.PersistentPlayerData.RedStatBuffShotSpeed + 0.1*data.PersistentPlayerData.EternalStatBuff + 0.05*data.PersistentPlayerData.EvilStatBuff
		end
		if cacheF == CacheFlag.CACHE_LUCK then
			player.Luck = player.Luck + 0.5*data.PersistentPlayerData.RedStatBuffLuck + 1*data.PersistentPlayerData.EternalStatBuff + 2*data.PersistentPlayerData.GoldStatBuff
		end
		if cacheF == CacheFlag.CACHE_RANGE then
			player.TearRange = player.TearRange + 2*data.PersistentPlayerData.RedStatBuffRange + 4*data.PersistentPlayerData.EternalStatBuff + 4*data.PersistentPlayerData.RottenStatBuff
		end
	end
end)