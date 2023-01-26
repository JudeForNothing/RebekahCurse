yandereWaifu:AddCallback(ModCallbacks.MC_POST_BOMB_INIT, function(_, bb)
	local sprite = bb:GetSprite()
	if bb.SpawnerType == 1 then
		local player = bb.SpawnerEntity:ToPlayer()
		if player:HasCollectible(RebekahCurseItems.COLLECTIBLE_HAPHEPHOBICBOMBS) then
			--update sprite--
			if (bb.Variant > 4 or bb.Variant < 3) then
				if bb.Variant == 0 then
					--bb.Variant = 3780
                    yandereWaifu.GetEntityData(bb).SensitiveBombs = true
				elseif bb.Variant == 19 then
					yandereWaifu.GetEntityData(bb).SensitiveBombs = true
				end
			end
		end
	end
end)


yandereWaifu:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE, function(_,  bb)
    local data = yandereWaifu.GetEntityData(bb)
    if data.SensitiveBombs then
		local player = bb.SpawnerEntity:ToPlayer()
        local pldata = yandereWaifu.GetEntityData(player)
        --bb:AddFear(EntityRef(player), 30)
        if bb.FrameCount % 7 == 0 then
            bb:SetColor(Color(0.5, 0, 1, 1, 0, 0, 0), 5, 1, false, false)
        end

        if bb:CollidesWithGrid() then
            if not data.hasbeenharrassedtoinduceseverepainsofphobia then
                bb:SetExplosionCountdown(1)
                data.hasbeenharrassedtoinduceseverepainsofphobia = true
                SFXManager():Play( RebekahCurseSounds.SOUND_IMDIECHIME , 1, 0, false, 1.2 )
            end
        end
    end
end);

yandereWaifu:AddCallback(ModCallbacks.MC_PRE_BOMB_COLLISION, function(_,  bb, collider, bool)
    local data = yandereWaifu.GetEntityData(bb)
    if data.SensitiveBombs then
		if collider:IsEnemy() then
            if not data.hasbeenharrassedtoinduceseverepainsofphobia then
                 bb:SetExplosionCountdown(1)
                 data.hasbeenharrassedtoinduceseverepainsofphobia = true
                 SFXManager():Play( RebekahCurseSounds.SOUND_IMDIECHIME , 1, 0, false, 1.2 )
            end
        end
    end
end);
