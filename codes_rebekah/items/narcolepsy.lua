local goodDreamItems = {
	[1] = CollectibleType.COLLECTIBLE_BRIMSTONE,
	[2] = CollectibleType.COLLECTIBLE_SPOON_BENDER,
	[3] = CollectibleType.COLLECTIBLE_DR_FETUS,
	[4] = CollectibleType.COLLECTIBLE_CHOCOLATE_MILK,
	[5] = CollectibleType.COLLECTIBLE_TECHNOLOGY,
	[6] = CollectibleType.COLLECTIBLE_PHD,
	[7] = CollectibleType.COLLECTIBLE_PARASITE,
	[8] = CollectibleType.COLLECTIBLE_MOMS_KNIFE,
	[9] = CollectibleType.COLLECTIBLE_EPIC_FETUS,
	[10] = CollectibleType.COLLECTIBLE_LOST_CONTACT,
	[11] = CollectibleType.COLLECTIBLE_MOMS_WIG,
	[12] = CollectibleType.COLLECTIBLE_GODHEAD,
	[13] = CollectibleType.COLLECTIBLE_PUPULA_DUPLEX,
	[14] = CollectibleType.COLLECTIBLE_TECH_X,
	[15] = CollectibleType.COLLECTIBLE_CHAOS,
	[16] = CollectibleType.COLLECTIBLE_SINUS_INFECTION,
	[17] = CollectibleType.COLLECTIBLE_JACOBS_LADDER,
	[18] = CollectibleType.COLLECTIBLE_TECHNOLOGY_ZERO,
	[19] = CollectibleType.COLLECTIBLE_IMMACULATE_HEART,
	[20] = CollectibleType.COLLECTIBLE_SPIRIT_SWORD
}

function yandereWaifu.GiveRandomAbilties(player)
	local rng = math.random(1,20)
	InutilLib.AddInnateItem(player, goodDreamItems[rng])
	--player:AddCollectible(goodDreamItems[rng])
	if not yandereWaifu.GetEntityData(player).DreamItems then
		yandereWaifu.GetEntityData(player).DreamItems = {}
	end
	table.insert(yandereWaifu.GetEntityData(player).DreamItems, goodDreamItems[rng])
end

function yandereWaifu.WakeUp(player)
	local data = yandereWaifu.GetEntityData(player)
	if data.DreamItems then
		for i, v in pairs(data.DreamItems) do
			InutilLib.RemoveInnateItem(player, v)
		end
		yandereWaifu.GetEntityData(player).DreamItems = nil
		player:TryRemoveNullCostume(NullItemID.ID_LOST_CURSE)
		player.Position = data.narcolepsyCustomBody.Position
		data.narcolepsyCustomBody:Remove()
		data.SleepyCount = math.random(120,240) 
		data.IsDreamCharacter = false
	end
end



yandereWaifu:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function(_,player)
	--local player = Isaac.GetPlayer(0);
    local room = Game():GetRoom();
	local data = yandereWaifu.GetEntityData(player)
	local sprite = player:GetSprite()
	--items function!
	if player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_NARCOLEPSY) then
		--[[if InutilLib.HasJustPickedCollectible( player, RebekahCurse.Items.COLLECTIBLE_BASKETOFEGGS ) then
			for i = 0, 4, 1 do
				local spawnPosition = room:FindFreePickupSpawnPosition(player.Position, 1);
				yandereWaifu.SpawnEasterEgg(spawnPosition, player)
				--local newpickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, RebekahCurse.Cards.CARD_EASTEREGG, spawnPosition, Vector(0,0), player)
			end
			player:AddNullCostume(RebekahCurse.Costumes.BasketOfEggs)
		end]]
		if not data.SleepyCount then data.SleepyCount = math.random(120,240) end
		if not InutilLib.room:IsClear() then
			if data.SleepyCount == 0 and not data.IsDreamCharacter then
				local animName = sprite:GetFilename()

				data.narcolepsyCustomBody = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_EXTRACHARANIMHELPER, 0, player.Position, Vector(0,0), player) --body effect
				yandereWaifu.GetEntityData(data.narcolepsyCustomBody).Player = player
				yandereWaifu.GetEntityData(data.narcolepsyCustomBody).DontFollowPlayer = true
				data.narcolepsyCustomBody:GetSprite():Load(animName, true)
				data.narcolepsyCustomBody:GetSprite():Play("Death")
				yandereWaifu.GetEntityData(data.narcolepsyCustomBody).narcolepsyCustomBody = true
				player:AddNullCostume(NullItemID.ID_LOST_CURSE)
				data.IsDreamCharacter = true

				yandereWaifu.GiveRandomAbilties(player)
			else
				data.SleepyCount = data.SleepyCount - 1
			end
		end


		if data.IsDreamCharacter then
			player:SetColor(Color(1,1,0.2,1,0,0,0), 2, 1)
		end
		if player:CollidesWithGrid() then
			if data.IsDreamCharacter then
				yandereWaifu.WakeUp(player)
			else
				data.SleepyCount = math.random(120,240)
			end
		end
	end
end)

yandereWaifu:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, e)
	if e.Type == 1 then
		local player = e:ToPlayer()
		local data = yandereWaifu.GetEntityData(player)
		if data.IsDreamCharacter then
			yandereWaifu.WakeUp(player)
			player:TakeDamage( 1, 0, EntityRef(player), 0);
			player:ResetDamageCooldown()
		end
	end
end)

function yandereWaifu:NarcolepsyNewRoom()	
	for p = 0, InutilLib.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		local data = yandereWaifu.GetEntityData(player)
		local room = InutilLib.game:GetRoom()
		if player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_NARCOLEPSY) then
			yandereWaifu.WakeUp(player)
		end		
	end
end
yandereWaifu:AddCallback( ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, yandereWaifu.NarcolepsyNewRoom)
