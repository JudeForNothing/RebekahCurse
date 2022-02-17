local statusEffects = Sprite();
statusEffects:Load("gfx/ui/rebekahstatuseffects.anm2", true);

--romcom code
function yandereWaifu:useRomComBook(collItem, rng, player)
	--InutilLib.ToggleShowActive(player, true)
	for i, v in pairs (Isaac.GetRoomEntities()) do
		if v:IsEnemy() and v:IsVulnerableEnemy() and not v:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
			yandereWaifu.GetEntityData(v).IsLaughing = 300
			if math.random(1,2) == 2 then
				v:AddCharmed(EntityRef(player), 300)
			end
		end
	end
	if math.random(1,10) == 10 then
		SFXManager():Play( RebekahCurseSounds.SOUND_LAUGHUNSETTLING , 1, 0, false, 1 );
	else
		SFXManager():Play( RebekahCurseSounds.SOUND_LAUGHTRACK , 1, 0, false, 1 );
	end
	InutilLib.AnimateGiantbook("gfx/ui/giantbook/giantbook_romcom.png", nil, "Shake", _, true)
end
yandereWaifu:AddCallback( ModCallbacks.MC_USE_ITEM, yandereWaifu.useRomComBook, RebekahCurse.COLLECTIBLE_ROMCOM );

--[[yandereWaifu:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_,player)
	--local player = Isaac.GetPlayer(0);
    local room = Game():GetRoom();
	local data = yandereWaifu.GetEntityData(player)
	--typical rom-command
	if player:HasCollectible(RebekahCurse.COLLECTIBLE_ROMCOM) then
		if InutilLib.ConfirmUseActive( player, RebekahCurse.COLLECTIBLE_ROMCOM ) then
			local vector = InutilLib.DirToVec(player:GetFireDirection())
			data.specialAttackVector = Vector( vector.X, vector.Y )
			InutilLib.ConsumeActiveCharge(player)
			InutilLib.ToggleShowActive(player, false)
			
			local rng = math.random(1,5)
			yandereWaifu.DoExtraBarrages(player, 1)
		end
	end
end)]]
local customColor = Color(0, 1, 0, 1, 0, 0, 0)
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
end)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, function(_, ent)
	local data = yandereWaifu.GetEntityData(ent)
	local player = data.PlayerStruck
	
	--laughing
	if data.IsLaughing then
		ent:SetColor(customColor, 2, 5, true, true)
		if not data.laughingRenderFrame then data.laughingRenderFrame = 0 end
		local loc = Isaac.WorldToScreen(ent.Position)
		statusEffects:SetOverlayRenderPriority(true)
		statusEffects:SetFrame("Laughing", data.laughingRenderFrame)
		statusEffects:Render(loc + Vector(0, -30), Vector(0,0), Vector(0,0));
		data.laughingRenderFrame = data.laughingRenderFrame + 1
		if data.laughingRenderFrame >= 7 then data.laughingRenderFrame = 0 end
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