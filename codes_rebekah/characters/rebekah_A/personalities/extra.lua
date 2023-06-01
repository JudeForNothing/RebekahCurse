function yandereWaifu.HalfRedHeartDash(player, vector)
	local playerdata = yandereWaifu.GetEntityData(player)
	local SubType = 0
	local trinketBonus = 0
	if player:HasTrinket(RebekahCurse.Trinkets.TRINKET_ISAACSLOCKS) then
		trinketBonus = 5
	end
	
	player.Velocity = player.Velocity + vector:Resized( RebekahCurse.REBEKAH_BALANCE.RED_HEARTS_DASH_SPEED/2 );
	
	local velAng = math.floor(player.Velocity:Rotated(-90):GetAngleDegrees())
	local subtype = RebekahCurse.DustEffects.ENTITY_REBEKAH_GENERIC_DUST
	if (velAng >= 180 - 15 and velAng <= 180 + 15) or (velAng >= -180 - 15 and  velAng <= -180 + 15) or (velAng >= 0 - 15 and  velAng <= 0 + 15) then
		subtype = RebekahCurse.DustEffects.ENTITY_REBEKAH_GENERIC_DUST_FRONT 
	end
	if (velAng >= 45 - 15 and  velAng <= 45 + 15) or (velAng >= -45 - 15 and  velAng <= -45 + 15) then
		subtype = RebekahCurse.DustEffects.ENTITY_REBEKAH_GENERIC_DUST_ANGLED
	end
	if (velAng >= 135 - 15 and  velAng <= 135 + 15) or (velAng >= -135 - 15 and  velAng <= -135 + 15) then
		subtype = RebekahCurse.DustEffects.ENTITY_REBEKAH_GENERIC_DUST_ANGLED_BACK
	end
	
	local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_REBEKAH_DUST, subtype, player.Position, Vector.Zero, player)
	--print(velAng)
	if (velAng >= 90 - 15 and velAng <= 90 + 15 and velAng >= 0) or (((velAng >= -135 - 15 and  velAng <= -135 + 15)  or (velAng >= -45 - 15 and  velAng <= -45 + 15)) and velAng <= 0) then
		poof:GetSprite().FlipX = true
	end
	--yandereWaifu.SpawnDashPoofParticle( player.Position, Vector(0,0), player, RebekahCurse.RebekahPoofParticleType.Red );

	playerdata.specialCooldown = RebekahCurse.REBEKAH_BALANCE.RED_HEARTS_DASH_COOLDOWN/2 - trinketBonus;
	playerdata.invincibleTime = RebekahCurse.REBEKAH_BALANCE.RED_HEARTS_DASH_INVINCIBILITY_FRAMES /2;
	InutilLib.SFX:Play( SoundEffect.SOUND_CHILD_HAPPY_ROAR_SHORT, 1, 0, false, 0.9);
	playerdata.IsDashActive = true

end

yandereWaifu:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function(_,player)
	--local player = Isaac.GetPlayer(0);
    local room = Game():GetRoom();
	local data = yandereWaifu.GetEntityData(player)
	if yandereWaifu.IsNormalRebekah(player) then
        if data.currentMode == RebekahCurse.REBECCA_MODE.ScaredRedHearts then
            local ents = Isaac.FindInRadius(player.Position, 100, EntityPartition.ENEMY)
            local oops = false
            for _, ent in pairs(ents) do
                oops = true
                break;
            end
            if oops then
                if player.FrameCount % 120 == 0 then
                    SFXManager():Play( SoundEffect.SOUND_SCARED_WHIMPER, 5, 0, false, 1 );
                end
                if player.FrameCount % 30 == 0 then
                    player:AddFear(EntityRef(player), 15)
                end
                if not data.KomiCantCostume then
                    player:AddNullCostume(RebekahCurse.Costumes.KomiCant)
                    data.KomiCantCostume = true
                end
            else
                if data.KomiCantCostume then
                    player:TryRemoveNullCostume(RebekahCurse.Costumes.KomiCant)
                    data.KomiCantCostume = false
                end
            end
        end
        if data.currentMode == RebekahCurse.REBECCA_MODE.TwinRedHearts then
            if not data.TwinRedRebekah then
                data.TwinRedRebekah = InutilLib:SpawnCustomStrawman(RebekahCurse.REB_RED, Isaac.GetPlayer(0), true)
            end
        else
            if data.TwinRedRebekah then
                data.TwinRedRebekah:Kill()
                data.TwinRedRebekah = nil
            end
        end
        if data.currentMode == RebekahCurse.REBECCA_MODE.HalfRedHearts then
            if not data.HasHalfFaceCos then
                player:AddNullCostume(RebekahCurse.Costumes.HalfFace);
                data.HasHalfFaceCos = true
                player:AddEntityFlags(EntityFlag.FLAG_BLEED_OUT)
            end
        else
            if data.HasHalfFaceCos then
                data.HasHalfFaceCos = false
                player:TryRemoveNullCostume(RebekahCurse.Costumes.HalfFace);
                player:ClearEntityFlags(EntityFlag.FLAG_BLEED_OUT)
            end
        end
        if data.currentMode == RebekahCurse.REBECCA_MODE.HalfSoulHearts then
            if math.random(1,15) == 15 and player.FrameCount % 30 == 0 then
                yandereWaifu.SoulHeartTeleport(player, player:GetMovementInput())
            end
            if math.random(1,5) == 5 and player.FrameCount % 15 == 0 then
                yandereWaifu.SpawnEctoplasm( player.Position, Vector ( 0, 0 ) , math.random(35,40)/10, player);
            end
            if not data.HasHalfSoulFaceCos then
                player:AddNullCostume(RebekahCurse.Costumes.HalfSoulFace);
                data.HasHalfSoulFaceCos = true
            end
        else
            if data.HasHalfSoulFaceCos then
                data.HasHalfSoulFaceCos = false
                player:TryRemoveNullCostume(RebekahCurse.Costumes.HalfSoulFace);
            end
        end
        if data.currentMode == RebekahCurse.REBECCA_MODE.BlendedHearts then
            local function aloofDrop()
                data.AloofDidDropLikeTheGoofballSheIs = true
                SFXManager():Play(SoundEffect.SOUND_WEIRD_WORM_SPIT, 1, 2, false, 1)
                data.AloofDidDropframecount = 0

                local customBody = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_EXTRACHARANIMHELPER, 0, player.Position, Vector(0,0), player) --body effect
                yandereWaifu.GetEntityData(customBody).Player = player
                yandereWaifu.GetEntityData(customBody).WizoobDrop = true
            end
            if not data.HasBlendedCos then
                player:AddNullCostume(RebekahCurse.Costumes.BlendedIdle);
                data.HasBlendedCos = true
            end
            if not data.AloofDidDropLikeTheGoofballSheIs then
                if math.random(1,20) == 20 and player.FrameCount % 30 == 0 then
                    player:TryRemoveNullCostume(RebekahCurse.Costumes.BlendedIdle);
                    --player:AddNullCostume(RebekahCurse.Costumes.BlendedSillyMe);
                    aloofDrop()
                    local bomb = player:FireBomb( player.Position, Vector.Zero):ToBomb()
                elseif math.random(1,30) == 30 and player.FrameCount % 15 == 0 and player:GetTrinket(0) > 0 then
                    player:DropTrinket(player.Position)
                    aloofDrop()
                elseif math.random(1,30) == 30 and player.FrameCount % 15 == 0 and (player:GetCard(0) > 0 or player:GetPill(0) > 0) then
                    player:DropPocketItem(0, player.Position)
                    aloofDrop()
                end
            end
            if data.AloofDidDropLikeTheGoofballSheIs then
                if data.AloofDidDropframecount == 42*2 then
                    print(player:GetSprite():GetOverlayFrame() )
                    data.AloofDidDropLikeTheGoofballSheIs = false
                    player:AddNullCostume(RebekahCurse.Costumes.BlendedIdle)
                    --player:TryRemoveNullCostume(RebekahCurse.Costumes.BlendedSillyMe)
                else
                    data.AloofDidDropframecount = data.AloofDidDropframecount + 1
                end
            end
        else
            if data.HasBlendedCos then
                data.HasBlendedCos = false
                player:TryRemoveNullCostume(RebekahCurse.Costumes.BlendedIdle);
                player:TryRemoveNullCostume(RebekahCurse.Costumes.BlendedSillyMe);
            end
        end
    end
end)