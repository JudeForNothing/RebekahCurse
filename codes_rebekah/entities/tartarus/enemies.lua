local isPlayerDmg = false

yandereWaifu:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, ent)
	local spr = ent:GetSprite()
	local data = yandereWaifu.GetEntityData(ent)
	local player = ent:GetPlayerTarget()
	if ent.Variant == RebekahCurse.Enemies.ENTITY_REMINDER then

        if not data.Init then
            if spr:IsFinished("Appear") then
                data.Init = true
            end
            if not spr:IsPlaying("Appear") then
            	spr:Play("Appear")
            end
            data.FlipX = false
            data.State = 0
            data.SpawnPoint = ent.Position
        else
            if data.State == 0 then
                if not spr:IsPlaying("Idle") then
                    spr:Play("Idle", true)
                end
                InutilLib.MoveRandomlyTypeI(ent, data.SpawnPoint, 0.8, 0.9, 15, 0, 45)
                --local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, Vector.FromAngle(math.random(1,360)):Resized(11))
                if ent.FrameCount % 45 == 0 and math.random(1,4) == 4  then
                    data.State = 1 
                end
                ent.Velocity = ent.Velocity * 0.9
                data.targetedVec = Vector(math.random(1,360), math.random(1,360));
                local emberParticle = Isaac.Spawn(1000,66, 0, ent.Position, data.targetedVec:Resized(math.random(4,7)):Rotated(-35 + math.random(70)), ent):ToEffect()
				emberParticle.SpriteOffset = Vector(0, -20)
				emberParticle:Update()

				local smoke = Isaac.Spawn(1000, EffectVariant.DARK_BALL_SMOKE_PARTICLE, 0, ent.Position, data.targetedVec:Resized(math.random(4,7)):Rotated(-35 + math.random(70)), ent)
				smoke.SpriteRotation = math.random(360)
				smoke.Color = Color(1,1,1,0.3,75 / 255,70 / 255,50 / 255)
				--smoke.SpriteScale = Vector(2,2)
				smoke.SpriteOffset = Vector(0, -20)
				smoke.RenderZOffset = 300
				smoke:Update()

            elseif data.State == 1 then --recoil
                if spr:IsFinished("Spit") then
                    data.State = 0
                elseif not spr:IsPlaying("Spit") then
                    spr:Play("Spit", true)
                else
                    if spr:IsEventTriggered("Spit") then
                        local int = 1;
                        local rng_course = math.random(-50,50);
                        for i = 0, 360, 360/16 do
                             local proj = InutilLib.FireGenericProjAttack(ent, 0, 1, ent.Position, Vector(0,4*int):Rotated(i+rng_course))
                             proj:AddProjectileFlags(ProjectileFlags.TRIANGLE)
                             proj.Scale = 0.4*int
                             if int == 2 then
                                int = 1;
                             else
                                int = int + 1;
                             end
                             yandereWaifu.GetEntityData(proj).Bloodbend2 = true
                        end
                    end
                end
                ent.Velocity = ent.Velocity * 0.7
            end
            InutilLib.FlipXByVec(ent, true)
        end
    end
	
end, RebekahCurse.Enemies.ENTITY_REBEKAH_ENEMY)
