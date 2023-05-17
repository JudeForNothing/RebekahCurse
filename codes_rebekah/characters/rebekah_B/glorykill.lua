
local count = 0

yandereWaifu:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, function(_, ent)
    local player = Isaac.GetPlayer(0)
	local data = yandereWaifu.GetEntityData(ent)
    --print(ent.HitPoints)
    --if ent.HitPoints <= 0 then
        local playerdata = yandereWaifu.GetEntityData(player)
        if player and yandereWaifu.IsTaintedRebekah(player) then
            count = 0
            for i, ent in pairs (Isaac.GetRoomEntities()) do
                if (ent:IsBoss() and ent.HitPoints > 0) then
                    count =  count + 1
                end
            end
        end
    --end
end)


yandereWaifu:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, ent)
    local player = Isaac.GetPlayer(0)
	local data = yandereWaifu.GetEntityData(ent)
    --print(ent.HitPoints)
    local HitPointLimit = ent.HitPoints <= ent.MaxHitPoints/15
    if HitPointLimit and ent:IsBoss() and player and yandereWaifu.IsTaintedRebekah(player) then
        if count < 1 then
            --[[local animName = ent:GetSprite():GetFilename()
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

            ent:Remove()]]
            
            
            
            
            --data.isGlorykillProc = true
            
            
            
            
            --ent.HitPoints = ent.MaxHitPoints/15

            --yandereWaifu.GetEntityData(player).IsGlorykillMode = true
        end
    end
    if not data.LastNPCFrame then data.LastNPCFrame = ent.FrameCount end
    if data.LastNPCFrame < ent.FrameCount then
         data.TheoreticalDmg = 0
         data.LastNPCFrame = ent.FrameCount
    end
end)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, function(_, ent)
	for p = 0, InutilLib.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		local playerType = player:GetPlayerType()
		local room = InutilLib.game:GetRoom()
		local data = yandereWaifu.GetEntityData(player)
		
		if yandereWaifu.IsTaintedRebekah(player) and ent:IsBoss() and count < 1 then
			ent:BloodExplode()
			if not ent:IsInvincible() then
				for i = 1, math.ceil(ent.MaxHitPoints/15)  do
					local heart = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_LOVELOVEPARTICLE, 1, ent.Position, Vector.FromAngle((Vector(0,10)):GetAngleDegrees() + math.random(-90,90) + 180):Resized(30), ent)
					yandereWaifu.GetEntityData(heart).Parent = player
					yandereWaifu.GetEntityData(heart).maxHealth = 15
					--print(math.ceil(maxHealth/3))
				end
			end
            local crystalCount = 1
            --[[if data.HitCount >= 30 then
                crystalCount = 2
            end]]
            for i = 1, crystalCount + math.random(0,1) do
                local poof = Isaac.Spawn(EntityType.ENTITY_PICKUP, RebekahCurse.ENTITY_WRATHCRYSTALFRAGMENT, 0, ent.Position, Vector.FromAngle(math.random(1,360)):Resized(math.random(4,6)), player)
            end
		end
	end
end)

--[[
yandereWaifu:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, eff)
	local sprite = eff:GetSprite();
	local data = yandereWaifu.GetEntityData(eff);
	local player = data.Player
	
	if data.isGlorykill then

        if data.HitCount then
            if data.HitCount >= 10 and not data.Bleed then
                InutilLib.room:EmitBloodFromWalls(2, 10)
                InutilLib.game:ShakeScreen(1)
                data.Bleed = true
                eff:BloodExplode()
            elseif data.HitCount >= 20 and not data.Bleed2 then
                InutilLib.room:EmitBloodFromWalls(2, 10)
                InutilLib.game:ShakeScreen(2)
                data.Bleed2 = true
                eff:BloodExplode()
            elseif data.HitCount >= 30 and not data.Bleed3 then
                InutilLib.room:EmitBloodFromWalls(4, 10)
                InutilLib.game:ShakeScreen(2)
                data.Bleed3 = true
                eff:BloodExplode()
            elseif data.HitCount >= 40 and not data.Bleed4 then
                InutilLib.room:EmitBloodFromWalls(4, 10)
                InutilLib.game:ShakeScreen(2)
                data.Bleed4 = true
                eff:BloodExplode()
            elseif data.HitCount >= 50 and not data.Bleed5 then
                InutilLib.room:EmitBloodFromWalls(8, 20)
                InutilLib.game:ShakeScreen(5)
                data.Bleed5 = true
                eff:BloodExplode()
            elseif data.HitCount >= 60 and not data.Bleed6 then
                InutilLib.room:EmitBloodFromWalls(8, 20)
                InutilLib.game:ShakeScreen(5)
                data.Bleed6 = true
            elseif data.HitCount >= 70 and not data.Bleed7 then
                InutilLib.room:EmitBloodFromWalls(10, 30)
                InutilLib.game:ShakeScreen(5)
                data.Bleed7 = true
            elseif data.HitCount >= 80 and not data.Bleed8 then
                InutilLib.room:EmitBloodFromWalls(10, 40)
                InutilLib.game:ShakeScreen(5)
                data.Bleed8 = true
            elseif data.HitCount >= 90 and not data.Bleed9 then
                InutilLib.room:EmitBloodFromWalls(10, 50)
                InutilLib.game:ShakeScreen(5)
                data.Bleed9 = true
            elseif data.HitCount >= 100 and not data.BleedUltimate then
                InutilLib.room:EmitBloodFromWalls(10, 50)
                InutilLib.game:ShakeScreen(5)
                InutilLib.game:MakeShockwave(eff.Position, 0.095, 0.025, 10)
                data.BleedUltimate = true
                eff:BloodExplode()
            end
        end
	end
end)


yandereWaifu:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, function(_, eff)
	local sprite = eff:GetSprite();
	local data = yandereWaifu.GetEntityData(eff);
	
	if data.isGlorykill then
		if not data.Countdown then data.Countdown = 300 end
        data.Countdown = data.Countdown - 1
        if data.Countdown <= 0 then
            eff:Remove()
            yandereWaifu.GetEntityData(data.GloryKillPlayer).IsGlorykillMode = false
            data.HitCount = 0

            eff:BloodExplode()
			if not eff:IsInvincible() then
				for i = 1, math.ceil(eff.MaxHitPoints/150) +  data.HitCount do
					local heart = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_LOVELOVEPARTICLE, 1, eff.Position, Vector.FromAngle((data.GloryKillPlayer.Position - eff.Position):GetAngleDegrees() + math.random(-90,90) + 180):Resized(30), eff)
					yandereWaifu.GetEntityData(heart).Parent = player
					yandereWaifu.GetEntityData(heart).maxHealth = 15
					--print(math.ceil(maxHealth/3))
				end
			end
            local crystalCount = 1
            if data.HitCount >= 30 then
                crystalCount = 2
            end
            for i = 1, crystalCount do
                local poof = Isaac.Spawn(EntityType.ENTITY_PICKUP, RebekahCurse.ENTITY_WRATHCRYSTALFRAGMENT, 0, eff.Position, Vector.FromAngle(math.random(1,360)):Resized(math.random(4,6)), player)
            end
        end
	end
end)


yandereWaifu:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, ent, amount, damageFlag, damageSource, damageCountdownFrames)
    local data = yandereWaifu.GetEntityData(ent);
    local player = InutilLib.GetPlayerFromDmgSrc(damageSource)
    if ent:ToNPC() then
        if not data.TheoreticalDmg then data.TheoreticalDmg = 0 end
        data.TheoreticalDmg = data.TheoreticalDmg + amount
    end
    print("Start")
    print(data.TheoreticalDmg)
    if (data.isGlorykillProc or data.isGlorykill) or (ent:IsBoss() and count < 1 and ent.HitPoints <= amount + data.TheoreticalDmg and yandereWaifu.IsTaintedRebekah(player)) then
        if data.isGlorykillProc then
            data.isGlorykillProc = false
            data.isGlorykill = true
            if not data.HitCount then data.HitCount = 0 end
            ent:AddEntityFlags(EntityFlag.FLAG_HELD)
            ent.Target = nil
            if player then
                data.GloryKillPlayer = player
                yandereWaifu.GetEntityData(player).IsGlorykillMode = true
            end
        else
            if not data.HitCount then data.HitCount = 0 end
            data.isGlorykillProc = false
            ent.HitPoints = ent.MaxHitPoints/15

            print("hits")
        end
        data.HitCount = data.HitCount + 1
        return false
    end
end)


local combo = Sprite();
combo:Load("gfx/ui/combo_glorykill_counter.anm2", true);

yandereWaifu:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, function(_, ent)
	local sprite = ent:GetSprite();
	local data = yandereWaifu.GetEntityData(ent);

	if data.isGlorykill then
		if data.HitCount then
            combo:SetFrame("Count", data.HitCount)

            local loc = Isaac.WorldToScreen(ent.Position + Vector(-10, -10) + Vector(math.random(-2, 2), math.random(-2, 2)))
			combo:Render(loc + Vector(-5, -50), Vector(0,0), Vector(0,0));
        end
	end
    if data.isGlorykillProc and ent.HitPoints <= ent.MaxHitPoints/15 then
        ent.HitPoints = ent.MaxHitPoints/15
        ent:Morph(ent.Type, ent.Variant, ent.SubType, ent:GetChampionColorIdx())
    end
end)]]