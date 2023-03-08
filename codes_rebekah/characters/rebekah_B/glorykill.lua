
local count = 0

yandereWaifu:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, function(_, ent)
    local player = Isaac.GetPlayer(0)
	local data = yandereWaifu.GetEntityData(ent)
    --print(ent.HitPoints)
    if ent.HitPoints <= 0 then
        local playerdata = yandereWaifu.GetEntityData(player)
        if player and yandereWaifu.IsTaintedRebekah(player) then
            count = 0
            for i, ent in pairs (Isaac.GetRoomEntities()) do
                if (ent:IsBoss() and ent.HitPoints > 0) then
                    count =  count + 1
                end
            end
        end
    end
end)


yandereWaifu:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, ent)
    local player = Isaac.GetPlayer(0)
	local data = yandereWaifu.GetEntityData(ent)
    --print(ent.HitPoints)
    if ent.HitPoints <= 0 and ent:IsBoss() and player and yandereWaifu.IsTaintedRebekah(player) then
        if count < 1 then
            local animName = ent:GetSprite():GetFilename()
            local animIsPlayingName = ent:GetSprite():GetAnimation()
            local animName = ent:GetSprite():GetFilename()
            local frame = ent:GetSprite():GetFrame()
            local animIsPlayingOverlayName = ent:GetSprite():GetOverlayAnimation()
            data.glorykillBody = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_EXTRACHARANIMHELPER, 0, ent.Position, Vector(0,0), ent) --body effect
			yandereWaifu.GetEntityData(data.glorykillBody).Player = player
			yandereWaifu.GetEntityData(data.glorykillBody).DontFollowPlayer = true
			data.glorykillBody:GetSprite():Load(animName, true)
            data.glorykillBody:GetSprite():SetFrame(animIsPlayingName, frame)
            data.glorykillBody:GetSprite():SetOverlayFrame(animIsPlayingOverlayName, frame)
            yandereWaifu.GetEntityData(data.glorykillBody).MaxHitPoints = ent.MaxHitPoints
            yandereWaifu.GetEntityData(data.glorykillBody).IsGlorykill = true

            ent:Remove()

            yandereWaifu.GetEntityData(player).IsGlorykillMode = true
        end
    end
end)


yandereWaifu:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, eff)
	local sprite = eff:GetSprite();
	local data = yandereWaifu.GetEntityData(eff);
	local player = data.Player
	
	if data.IsGlorykillMode then

        if data.HitCount then
            if data.HitCount >= 10 and not data.Bleed then
                ILIB.room:EmitBloodFromWalls(2, 10)
                ILIB.game:ShakeScreen(1)
                data.Bleed = true
                eff:BloodExplode()
            elseif data.HitCount >= 20 and not data.Bleed2 then
                ILIB.room:EmitBloodFromWalls(2, 10)
                ILIB.game:ShakeScreen(2)
                data.Bleed2 = true
                eff:BloodExplode()
            elseif data.HitCount >= 30 and not data.Bleed3 then
                ILIB.room:EmitBloodFromWalls(4, 10)
                ILIB.game:ShakeScreen(2)
                data.Bleed3 = true
                eff:BloodExplode()
            elseif data.HitCount >= 40 and not data.Bleed4 then
                ILIB.room:EmitBloodFromWalls(4, 10)
                ILIB.game:ShakeScreen(2)
                data.Bleed4 = true
                eff:BloodExplode()
            elseif data.HitCount >= 50 and not data.Bleed5 then
                ILIB.room:EmitBloodFromWalls(8, 20)
                ILIB.game:ShakeScreen(5)
                data.Bleed5 = true
                eff:BloodExplode()
            elseif data.HitCount >= 60 and not data.Bleed6 then
                ILIB.room:EmitBloodFromWalls(8, 20)
                ILIB.game:ShakeScreen(5)
                data.Bleed6 = true
            elseif data.HitCount >= 70 and not data.Bleed7 then
                ILIB.room:EmitBloodFromWalls(10, 30)
                ILIB.game:ShakeScreen(5)
                data.Bleed7 = true
            elseif data.HitCount >= 80 and not data.Bleed8 then
                ILIB.room:EmitBloodFromWalls(10, 40)
                ILIB.game:ShakeScreen(5)
                data.Bleed8 = true
            elseif data.HitCount >= 90 and not data.Bleed9 then
                ILIB.room:EmitBloodFromWalls(10, 50)
                ILIB.game:ShakeScreen(5)
                data.Bleed9 = true
            elseif data.HitCount >= 100 and not data.BleedUltimate then
                ILIB.room:EmitBloodFromWalls(10, 50)
                ILIB.game:ShakeScreen(5)
                ILIB.game:MakeShockwave(eff.Position, 0.095, 0.025, 10)
                data.BleedUltimate = true
                eff:BloodExplode()
            end
        end
	end
end)


yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local sprite = eff:GetSprite();
	local data = yandereWaifu.GetEntityData(eff);
	local player = data.Player
	
	if data.IsGlorykill then
		if not data.Countdown then data.Countdown = 30*5 end
        data.Countdown = data.Countdown - 1
        if data.Countdown <= 0 then
            eff:Remove()
            yandereWaifu.GetEntityData(player).IsGlorykillMode = false
            yandereWaifu.GetEntityData(player).HitCount = 0

            eff:BloodExplode()

            local maxHealth = data.MaxHitPoints
			if not eff:IsInvincible() then
				for i = 1, math.ceil(maxHealth/150) +  yandereWaifu.GetEntityData(player).HitCount do
					local heart = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_LOVELOVEPARTICLE, 1, eff.Position, Vector.FromAngle((player.Position - eff.Position):GetAngleDegrees() + math.random(-90,90) + 180):Resized(30), eff)
					yandereWaifu.GetEntityData(heart).Parent = player
					yandereWaifu.GetEntityData(heart).maxHealth = 15
					--print(math.ceil(maxHealth/3))
				end
			end
            local count = 1
            if yandereWaifu.GetEntityData(player).HitCount >= 30 then
                count = 2
            end
            for i = 1, count do
                local poof = Isaac.Spawn(EntityType.ENTITY_PICKUP, RebekahCurse.ENTITY_WRATHCRYSTALFRAGMENT, 0, eff.Position, Vector.FromAngle(math.random(1,360)):Resized(math.random(4,6)), player)
            end
        end
	end
end, RebekahCurse.ENTITY_EXTRACHARANIMHELPER)

local combo = Sprite();
combo:Load("gfx/ui/combo_glorykill_counter.anm2", true);

yandereWaifu:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, function(_, eff)
	local sprite = eff:GetSprite();
	local data = yandereWaifu.GetEntityData(eff);
	local player = data.Player
	
	if data.IsGlorykillMode then
		if data.HitCount then
            combo:SetFrame("Count", data.HitCount)

            local loc = Isaac.WorldToScreen(eff.Position + Vector(-10, -10) + Vector(math.random(-2, 2), math.random(-2, 2)))
			combo:Render(loc + Vector(0, -50), Vector(0,0), Vector(0,0));
        end
	end
end)