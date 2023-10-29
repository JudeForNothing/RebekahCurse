

yandereWaifu:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, function(_,  tr)
	local player = tr.SpawnerEntity:ToPlayer()
	local pldata = yandereWaifu.GetEntityData(player)
    local data = yandereWaifu.GetEntityData(tr)
	if player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_BOBATEA) then
		if tr.Variant ~= RebekahCurse.ENTITY_TAPIOCATEAR and math.random(1,5) == 5 then
            tr:ChangeVariant(RebekahCurse.ENTITY_TAPIOCATEAR)
            data.IsTapiocaTear = true
            tr:AddTearFlags(TearFlags.TEAR_HYDROBOUNCE)
            InutilLib.MakeTearLob(tr, 1.5, 9 )
        end
	end
end);

function yandereWaifu:BobaTeaTearRender(tr, _)
	if tr.Variant == RebekahCurse.ENTITY_TAPIOCATEAR and tr.FrameCount <= 1 then
		local player, data, flags, scale = tr.SpawnerEntity:ToPlayer(), yandereWaifu.GetEntityData(tr), tr.TearFlags, tr.Scale 
		local size = InutilLib.GetTearSizeTypeI(scale, flags)
		InutilLib.UpdateRegularTearAnimation(player, tr, data, flags, size, "RegularTear");
		--InutilLib.UpdateDynamicTearAnimation(player, tr, data, flags, "Rotate", "", size)
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_POST_TEAR_RENDER, yandereWaifu.BobaTeaTearRender)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, function(_,  tr)
	if tr.SpawnerEntity then
		local player = tr.SpawnerEntity:ToPlayer()
		local pldata = yandereWaifu.GetEntityData(player)
		local data = yandereWaifu.GetEntityData(tr)
		if data.IsTapiocaTear then
			if not data.Player then data.Player = player end
			if tr.FrameCount % 5 == 0 then
				tr.Velocity = tr.Velocity*0.9
				local tears = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0, tr.Position, Vector.Zero --[[Vector.FromAngle(math.random(1,360)):Resized(player.ShotSpeed*4)]], player):ToTear()
				tears.Scale = tr.Scale * 0.5
				tears.Height = tr.Height
				tears.CollisionDamage = player.Damage * 0.5
				--InutilLib.MakeTearLob(tears, 1.5, 9 )
			end
		end
	end
end);

yandereWaifu:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, function(_,  tr)
	if tr.Variant == RebekahCurse.ENTITY_TAPIOCATEAR then
		local puddle = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_RED, 0, tr.Position, Vector.Zero, tr):ToTear()
        if not puddle then return end
		InutilLib.RevelSetCreepData(puddle)
		InutilLib.RevelUpdateCreepSize(puddle, 0.2, true)
        puddle:SetColor(Color(1,1,1,1,255,255,255), 999999,999999)
    end
end, EntityType.ENTITY_TEAR);
