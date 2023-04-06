local time = 90

yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local sprite = eff:GetSprite()
	local data = yandereWaifu.GetEntityData(eff)
	local player = data.Player
	local parent = data.Parent
	
	local movementDirection = player:GetShootingInput();
	local roomClampSize = math.max( 5, 20 )
	--local isClamping = false

    if eff.SubType == 0 then
        local function ClampToL()
            local target = data.target
            local highestHP = 0 -- labels the highest enemy hp
            if target then
                eff.Position = target.Position
                --eff.Velocity = target.Velocity
            else
                if movementDirection:Length() < 0.05 then
                    local closestDist = 177013 --saved Dist to check who is the closest enemy
                    local minDist = 50
                    for i, e in pairs(Isaac.GetRoomEntities()) do
                        if e:ToEffect() and e.Variant == eff.Variant and e.SubType == 1 and not yandereWaifu.GetEntityData(e).isClamping then
                            if (eff.Position - e.Position):Length() < minDist + e.Size then
                                if (eff.Position - e.Position):Length() < closestDist + e.Size then
                                    closestDist = (eff.Position - e.Position):Length()
                                    data.target = e
                                end
                            end
                        end
                    end
                    if data.target then
                        data.Parent = yandereWaifu.GetEntityData(data.target).Parent
                        data.isClamping = true
                        yandereWaifu.GetEntityData(data.target).isClamping = true
                    end
                end
            end
        end
        
        if movementDirection:Length() < 0.05 then
            eff.Velocity = Vector.Zero
            ClampToL()
        elseif not data.isClamping then
            eff.Position = InutilLib.room:GetClampedPosition(eff.Position, roomClampSize);
            eff.Velocity = --[[(eff.Velocity * 0.8) +]] movementDirection:Resized( 18 );
            data.target = nil
        end
        
        --for i, orb in pairs (Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.TARGET, -1, false, false)) do
        --	if not data.HasParent then
        --		data.HasParent = orb
        --	else
        --		if not data.HasParent:IsDead() then
        --eff.Velocity = Vector.Zero
        --			eff.Position = data.HasParent.Position
        --		else
        --			eff.Velocity = eff.Velocity * 0.8
        --		end
        --	end
        --end
        
        local room =  Game():GetRoom()
        --function code
        if eff.FrameCount == 1 then
            sprite:Play("Cursor", false)
        end
        if data.isClamping then
            if not data.Parent or data.Parent:IsDead() then
                eff:Remove()
            end
        end
        eff.RenderZOffset = 1000000
    elseif eff.SubType == 1 then
        if eff.FrameCount == 1 then
            sprite:Play("Slot", false)
        end
        eff.Position = data.Parent.Position - data.ParentPos
        eff.Velocity = parent.Velocity
        eff.RenderZOffset = 100000
        if data.isClamping then
            sprite.Color = Color(0,0,0,0)
        end

        if not data.Parent or data.Parent:IsDead() then
            eff:Remove()
        end
    end
    if InutilLib.room:GetFrameCount() >= time then
        if eff.SubType == 1 and data.isClamping then
            data.Parent:TakeDamage( player.Damage*5, 0, EntityRef(player), 0);
            Isaac.Spawn(1000,144,1,eff.Position,Vector.Zero,eff)
            SFXManager():Play(SoundEffect.SOUND_DEMON_HIT)
        end
        eff:Remove()
    end
end, RebekahCurse.ENTITY_DEBORAHDEADEYETARGET)

function yandereWaifu:DeborahEyeActivate()
	for p = 0, InutilLib.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		local data = yandereWaifu.GetEntityData(player)
		local room = InutilLib.game:GetRoom()
		if player:HasTrinket(RebekahCurse.Trinkets.TRINKET_DEBORAHSDEADEYE) and not room:IsClear() then
            data.HasMoreTargetsDeadEye = true
			SFXManager():Play( RebekahCurse.Sounds.SOUND_LAUGHTRACK , 1, 0, false, 1 );
            for i, e in pairs(Isaac.GetRoomEntities()) do
                if e:IsEnemy() and e:IsVulnerableEnemy() then
                    e:AddSlowing(EntityRef(player), time, 2.0, (Color(1.0, 1.0, 1.0, 1.0)))
                    local limit = 0
                    if e:IsBoss() then
                        limit = 2
                    end
                    for i = 0, limit do
                        local target = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_DEBORAHDEADEYETARGET, 1, e.Position, Vector.Zero, player)
                        yandereWaifu.GetEntityData(e).DeadEyeTarget = target
                        yandereWaifu.GetEntityData(target).Parent = e
                        yandereWaifu.GetEntityData(target).Player = player
                        yandereWaifu.GetEntityData(target).ParentPos = Vector(math.random(-3*(math.floor(e.Size/2)),3*math.floor(e.Size/2)), math.random(-10,4*math.floor(e.Size/2)))
                    end
                end
            end
		end
	end
end
yandereWaifu:AddCallback( ModCallbacks.MC_POST_NEW_ROOM, yandereWaifu.DeborahEyeActivate)


yandereWaifu:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_,player)
	local data = yandereWaifu.GetEntityData(player)
	local room = InutilLib.game:GetRoom()
	if player:HasTrinket(RebekahCurse.Trinkets.TRINKET_DEBORAHSDEADEYE) and not room:IsClear() and room:GetFrameCount() < time then
        if (not data.DeborahDeadEye or data.DeborahDeadEye:IsDead() or yandereWaifu.GetEntityData(data.DeborahDeadEye).isClamping) and data.HasMoreTargetsDeadEye then
            local closestDist = 177013 --saved Dist to check who is the closest enemy
            local minDist = 650
            data.HasMoreTargetsDeadEye = false
            for i, e in pairs(Isaac.GetRoomEntities()) do
                if e:ToEffect() and e.Variant == RebekahCurse.ENTITY_DEBORAHDEADEYETARGET and e.SubType == 1 and not yandereWaifu.GetEntityData(e).isClamping then
                    if (player.Position - e.Position):Length() < minDist + e.Size then
                        if (player.Position - e.Position):Length() < closestDist + e.Size then
                            data.HasMoreTargetsDeadEye = true
                            break
                        end
                    end
                end
            end
            if data.HasMoreTargetsDeadEye then
                data.DeborahDeadEye = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_DEBORAHDEADEYETARGET, 0, player.Position, Vector.Zero, player):ToEffect()
                yandereWaifu.GetEntityData(data.DeborahDeadEye).Player = player
            end
        end
    end
end)