local statusEffects = Sprite();
statusEffects:Load("gfx/ui/rebekahstatuseffects.anm2", true);

local greenLaughterColor = Color(0, 1, 0, 1, 0, 0, 0)
local purpleDrunkColor = Color(0.5, 0, 0.7, 1, 0, 0, 0)
yandereWaifu:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, ent)
	local data = yandereWaifu.GetEntityData(ent)
	local player = data.PlayerStruck
	
	--laughing
	if data.IsLaughing then
		if not ILIB.game:IsPaused() then
            data.IsLaughing = data.IsLaughing - 1
            if data.IsLaughing <= 0 then
                data.IsLaughing = nil
            end
        end
	end

    --drunk
	if data.IsDrunk then
		if not ILIB.game:IsPaused() then
            data.IsDrunk = data.IsDrunk - 1
            ent.Target = InutilLib.GetClosestGenericEnemy(ent, 700)
            --print(ent.Target.Type)
           -- ent:AddEntityFlags(EntityFlag.FLAG_CHARM)
            if ent.Velocity:Length() < 7 then
                ent.Velocity = (ent.Velocity * (1.2))
            end
            if data.IsDrunk <= 0 then
                data.IsDrunk = nil
                ent.Target = InutilLib.GetClosestPlayer(ent, 700)
                --ent:ClearEntityFlags(EntityFlag.FLAG_CHARM)
            end
        end
	end
end)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, function(_, ent)
	local data = yandereWaifu.GetEntityData(ent)
	local player = data.PlayerStruck
	
	--laughing
	if data.IsLaughing then
		ent:SetColor(greenLaughterColor, 2, 5, true, true)
		if not data.laughingRenderFrame then data.laughingRenderFrame = 0 end
		local loc = Isaac.WorldToScreen(ent.Position)
		statusEffects:SetOverlayRenderPriority(true)
		statusEffects:SetFrame("Laughing", data.laughingRenderFrame)
		statusEffects:Render(loc + Vector(0, -30), Vector(0,0), Vector(0,0));
		data.laughingRenderFrame = data.laughingRenderFrame + 1
		if data.laughingRenderFrame >= 7 then data.laughingRenderFrame = 0 end
	end

    --drunk
	if data.IsDrunk then
		ent:SetColor(purpleDrunkColor, 2, 5, true, true)
		if not data.drunkRenderFrame then data.drunkRenderFrame = 0 end
		local loc = Isaac.WorldToScreen(ent.Position)
		statusEffects:SetOverlayRenderPriority(true)
		statusEffects:SetFrame("Drunk", data.drunkRenderFrame)
		statusEffects:Render(loc + Vector(0, -30), Vector(0,0), Vector(0,0));
		data.drunkRenderFrame = data.drunkRenderFrame + 1
		if data.drunkRenderFrame >= 11 then data.drunkRenderFrame = 0 end
	end
end)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, function(_, proj)
	local data = yandereWaifu.GetEntityData(proj)
	if proj.SpawnerEntity then
		local spawnerData = yandereWaifu.GetEntityData(proj.SpawnerEntity)
		if proj.SpawnerEntity and proj.FrameCount == 1 then
			if spawnerData.IsLaughing then
				proj:Remove()
			end
		end
	end
end)
