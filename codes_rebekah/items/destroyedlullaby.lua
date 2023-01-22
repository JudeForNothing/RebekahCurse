local function TEARFLAG(x)
    return x >= 64 and BitSet128(0,1<<(x-64)) or BitSet128(1<<x,0)
end

yandereWaifu:AddCallback(ModCallbacks.MC_POST_TEAR_INIT, function(_, tr)
	if (tr.SpawnerEntity and tr.SpawnerEntity.Type == 3) then
		local player = tr.SpawnerEntity:ToFamiliar().Player:ToPlayer()
		if player:HasTrinket(RebekahCurseTrinkets.TRINKET_DESTROYEDLULLABY) then
			--because chaos card is too op
			local randomVariant = math.random(0,49)
			if randomVariant == 9 then randomVariant = 0 end
			tr:ChangeVariant(randomVariant)
			tr:AddTearFlags(TEARFLAG(math.random(1,81)))
		end
	end
end)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, function(_, tr)
	if (tr.SpawnerEntity and tr.SpawnerEntity.Type == 3 and tr.SpawnerEntity.Variant == FamiliarVariant.INCUBUS) and tr.FrameCount == 1 then
		local player = tr.SpawnerEntity:ToFamiliar().Player:ToPlayer()
		if player:HasTrinket(RebekahCurseTrinkets.TRINKET_DESTROYEDLULLABY) then
			--because chaos card is too op
			local randomVariant = math.random(0,49)
			if randomVariant == 9 then randomVariant = 0 end
			tr:ChangeVariant(randomVariant)
			tr:AddTearFlags(TEARFLAG(math.random(1,81)))
		end
	end
end)
