local customColor = Color(1, 0.5, 1, 1, 0, 0, 0)
yandereWaifu:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function(_,player)
	local data = yandereWaifu.GetEntityData(player)
	--cursed spoon
	if player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_CURSEDSPOON) and InutilLib.HasJustPickedCollectible( player, RebekahCurse.Items.COLLECTIBLE_CURSEDSPOON) then
		player:AddNullCostume(RebekahCurse.Costumes.CursedMawCos)
	end
	if player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_CURSEDSPOON) and (not data.HasSpoonShadow or data.HasSpoonShadow:IsDead()) then
		player:SetColor(customColor, 2, 5, true, true)
	end
end)

yandereWaifu:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, damage, amount, damageFlag, damageSource, damageCountdownFrames) --invincibilityframe when dashing or whatnot
	local player = damage:ToPlayer();
	local data = yandereWaifu.GetEntityData(player)

	if player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_CURSEDSPOON) and (damageFlag & DamageFlag.DAMAGE_CURSED_DOOR) == 0 and (not data.PsoriasisHealth or data.PsoriasisHealth <= 0) then
		if not data.HasSpoonShadow or data.HasSpoonShadow:IsDead() then
			--data.LastEntityCollisionClass = player.EntityCollisionClass;
			--data.LastGridCollisionClass = player.GridCollisionClass;

			local maw = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_CURSEDMAW, 0, player.Position, Vector(0,0), player)
			--player:AnimatePitfallIn()
			--data.IsUninteractible = true
			data.HasSpoonShadow = maw
			yandereWaifu.GetEntityData(maw).Player = player
		end
	end
	
end, EntityType.ENTITY_PLAYER)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local sprite = eff:GetSprite()
	local data = yandereWaifu.GetEntityData(eff)
	local player = data.Player
	
	local room =  Game():GetRoom()
	
	--function code
	if sprite:IsFinished("Appear") then
		sprite:Play("Idle")
	end 
	
	if sprite:IsPlaying("Idle") then
		if (data.Player.Position - eff.Position):Length() > 250 then
			InutilLib.MoveDirectlyTowardsTarget(eff, player, 1, 0.9)
		end
		if math.random(1,3) == 3 and math.floor(eff.FrameCount % 30) == 0 then
			sprite:Play("Attack", true)
			local target = InutilLib.GetStrongestEnemy(eff, 300)
			local dir = target.Position - eff.Position
			data.dir = dir
		end
		InutilLib.StrafeAroundTarget(eff, player, 0.5, 0.9, 90)
	end
	
	if sprite:IsPlaying("Attack") then
		if sprite:GetFrame() >= 5 and sprite:GetFrame() <= 25 then
			eff.Velocity = eff.Velocity * 0.7
		elseif sprite:GetFrame() >= 25 and sprite:GetFrame() <= 45 then
			if data.dir then
				eff.Velocity = data.dir:Resized(15)
			end
			for i, ent in pairs (Isaac.GetRoomEntities()) do
				if (ent:IsEnemy() and ent:IsVulnerableEnemy()) or ent.Type == EntityType.ENTITY_FIREPLACE and not ent:IsDead() then
					if eff.FrameCount % 5 == 0 then
						if ent.Position:Distance(eff.Position) <= 120 then
							ent:TakeDamage(2+player.Damage/3, 0, EntityRef(eff), 1)
						end
					end
				--[[elseif ent.Type == 1 then
					if ent.Position:Distance(eff.Position) <= 55 then
						ent:TakeDamage(1, 0, EntityRef(player), 10)
					end]]
				end
			end
		elseif sprite:GetFrame() > 45 then
			eff.Velocity = eff.Velocity * 0.9
		end
	end
	
	if sprite:IsFinished("Attack") then
		sprite:Play("Idle")
	end
	
end, RebekahCurse.ENTITY_CURSEDMAW)

