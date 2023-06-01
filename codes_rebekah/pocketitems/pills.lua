yandereWaifu:AddCallback(ModCallbacks.MC_USE_PILL, function(_, effect, player, flags)
    local pillColour = player:GetPill(0)
	local holdingHorsePill = pillColour & PillColor.PILL_GIANT_FLAG > 0
    --if PillColor.PILL_GIANT_FLAG
    if effect == RebekahCurse.Pills.GOOSEBUMPS then
        local multiplier = 1
        if holdingHorsePill then multiplier = 2 end
        for i, e in pairs(Isaac.GetRoomEntities()) do
			if e:IsEnemy() then
				e:AddFear(EntityRef(player), 90*multiplier)
			end
		end
    elseif effect == RebekahCurse.Pills.LAUGHTERSTHEBESTMEDICINE then
        local multiplier = 1
        if holdingHorsePill then multiplier = 2 end
        for i, e in pairs(Isaac.GetRoomEntities()) do
			if e:IsEnemy() then
				yandereWaifu.GetEntityData(e).IsLaughing = 90*multiplier
			end
		end
        SFXManager():Play( RebekahCurse.Sounds.SOUND_LAUGHTRACK , 1, 0, false, 1 );
    elseif effect == RebekahCurse.Pills.ENDORPHIN then
        
    elseif effect == RebekahCurse.Pills.HEMORRHAGE then
        local extra = 1
        if holdingHorsePill then extra = 2 end

        if player:GetPlayerType() == PlayerType.PLAYER_KEEPER then
            local rng = math.random(1,2)
            player:AddHearts(-rng)
            if player:GetHearts() < 1 then
                player:AddHearts(2)
            end
            for i = 0, (rng-1)*extra do
                player:AddBlueFlies(1, player.Position, player)
            end
        else
            local rng = math.random(4,7)
            for i = 1, rng*extra do
                player:AddHearts(-1)
                local clot = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLOOD_BABY, 0, player.Position, Vector(0, 0), player):ToFamiliar()
                if player:GetHearts() < 2 then break end
            end
            if player:GetHearts() < 2 then
                player:AddHearts(2)
			end
        end
    elseif effect == RebekahCurse.Pills.OVULATION then
        local extra = 0
        if holdingHorsePill then extra = 1 end
        for i = 0, 0+extra do
            yandereWaifu.SpawnEasterEgg(player.Position, player)
            SFXManager():Play(SoundEffect.SOUND_PLOP, 1, 0, false, 1 );
        end
    elseif effect == RebekahCurse.Pills.PROGESTIN then
        local multiplier = 1
        if holdingHorsePill then multiplier = 2 end
        for i, e in pairs(Isaac.GetRoomEntities()) do
			if e:IsEnemy() then
				yandereWaifu.GetEntityData(e).IsMenopaused = 200*multiplier
			end
		end
    end
end)