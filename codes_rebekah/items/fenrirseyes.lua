yandereWaifu:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_,player)
	local data = yandereWaifu.GetEntityData(player)
    if InutilLib.HasJustPickedCollectible( player, RebekahCurse.Items.COLLECTIBLE_FENRIRSEYE ) then
		player:AddNullCostume(RebekahCurse.Costumes.FenrirsEye)
	end
    if player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_FENRIRSEYE) then
        local angle = InutilLib.DirToVec(player:GetFireDirection()):GetAngleDegrees()
        if player:HasCollectible(CollectibleType.COLLECTIBLE_MARKED) then
            angle = player:GetAimDirection():GetAngleDegrees()
        end
        player:SetColor(Color(1,0.5,0.5,1,0,0,0),9999999,9999999,false,false)
        local ents = Isaac.FindInRadius(player.Position, 95, EntityPartition.ENEMY)
        for _, ent in pairs(ents) do
            if InutilLib.CuccoLaserCollision(player, angle, 700, ent, 15) then
                --ent:AddFear(EntityRef(ent), 10)
                yandereWaifu.GetEntityData(ent).isIntimidated = 60
            end
        end
    end
end)