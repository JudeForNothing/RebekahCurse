
--BRIDE RED HEART--
do

function yandereWaifu:LabanInit(fam)
    local sprite = fam:GetSprite()
	local data = GetEntityData(fam)
	data.Stat = {
		FireDelay = 30,
		MaxFireDelay = 30,
		Damage = 15, 
		PlayerMaxDelay = 0,
		SlashDelay = 70,
		MaxChargeDelay = 70
	}
	fam.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS;
end
yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, yandereWaifu.LabanInit, ENTITY_LABAN);

yandereWaifu:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_,  fam) --christian nerd
	local spr = fam:GetSprite()
	local rng = math.random(1, 100)
	local player = fam.Player
	local data = GetEntityData(fam)
	local playerdata = GetEntityData(player)
	
	local walkAnim
	if data.Stat.FireDelay > 0 then data.Stat.FireDelay = data.Stat.FireDelay - 1 end
	if data.Stat.SlashDelay > 0 then data.Stat.SlashDelay = data.Stat.SlashDelay - 1 end

	local currentSide = nil
	local brideProtectorAngle = (fam.Player.Velocity):GetAngleDegrees()
	local willFlip = false
	local neededPosition = fam.Player.Position + Vector(-30,0):Rotated(brideProtectorAngle)
	local addVel = Vector(0,0)
		--stop projectiles
		for i, e in pairs(Isaac.GetRoomEntities()) do
			if e.Type == EntityType.ENTITY_PROJECTILE then
				if (e.Position - player.Position):LengthSquared() <= 10 ^ 2 then
					e:Die()
				end
			end
		end
		--print(data.Stat.SlashDelay)
		--dash movement
		if playerdata.IsDashActive and data.Stat.SlashDelay <= 0 then
			local slashAnim 
			if not InutilLib.IsPlayingMultiple(spr, "SlashSide", "SlashFront", "SlashBack") then --init
				slashAnim = InutilLib.AnimShootFrame(fam, false, playerdata.DashVector, "SlashSide", "SlashFront", "SlashBack")
				fam.Velocity = fam.Velocity + playerdata.DashVector:Resized( BALANCE.RED_HEARTS_DASH_SPEED * 2);
			end
			if InutilLib.IsPlayingMultiple(spr, "SlashSide", "SlashFront", "SlashBack") then --slash damage
				if spr:GetFrame() >= 8 and spr:GetFrame() <= 10 then
					if spr:GetFrame() == 8 then
						speaker:Play( SoundEffect.SOUND_SHELLGAME, 1, 0, false, 1 );
					end
					local entities = Isaac.GetRoomEntities()
					for i = 1, #entities do
						if entities[i]:IsVulnerableEnemy() then
							if entities[i].Position:Distance(fam.Position) < entities[i].Size + fam.Size + 30 then
								entities[i]:TakeDamage(player.Damage * 2.5, 0, EntityRef(fam), 1)
							end
						end
						--projectiles
						if entities[i].Type == EntityType.ENTITY_PROJECTILE then
							if (entities[i].Position - player.Position):LengthSquared() <= 10 ^ 2 then
								entities[i]:Die()
							end
						end
					end
				end
			end
			if InutilLib.IsFinishedMultiple(spr, "SlashSide", "SlashFront", "SlashBack") then
				playerdata.IsDashActive = false
				data.Stat.SlashDelay = data.Stat.MaxChargeDelay
			end
		elseif playerdata.IsDashActive and data.Stat.SlashDelay > 0 then
			playerdata.IsDashActive = false
		elseif playerdata.IsAttackActive then
			if not InutilLib.IsPlayingMultiple(spr, "Special", "Special", "Special") then --init
				slashAnim = InutilLib.AnimShootFrame(fam, false, playerdata.AttackVector, "Special", "Special", "Special")
				if not data.entTable then data.entTable = {} end
			end
			if InutilLib.IsPlayingMultiple(spr, "Special", "Special", "Special") then --slash damage
				if not data.entTable then data.entTable = {} end
				if spr:IsEventTriggered("Start") then
					fam.Velocity = fam.Velocity + playerdata.AttackVector:Resized( BALANCE.BRIDE_RED_HEARTS_DASH_SPEED );
				elseif spr:WasEventTriggered("Start") and spr:GetFrame() < 42 then
					speaker:Play( SoundEffect.SOUND_SHELLGAME, 1, 0, false, 1 );
					local entities = Isaac.GetRoomEntities()
					for i = 1, #entities do
						if entities[i]:IsVulnerableEnemy() then
							if entities[i].Position:Distance(fam.Position) < entities[i].Size + fam.Size + 80 then
								entities[i]:TakeDamage(player.Damage * 1.3, 0, EntityRef(fam), 1)
								if not data.entTable[entities[i]] then data.entTable[entities[i]] = entities[i] end
							end
						end
						--projectiles
						if entities[i].Type == EntityType.ENTITY_PROJECTILE then
							if (entities[i].Position - player.Position):LengthSquared() <= 10 ^ 2 then
								entities[i]:Die()
							end
						end
					end
					fam.Velocity = fam.Velocity * 0.95
				else
					fam.Velocity = fam.Velocity * 0.8
				end
			end
			if spr:IsEventTriggered("Snap") then
				if data.entTable then
					for k, v in pairs (data.entTable) do
						if v:IsVulnerableEnemy() and not v:IsDead() then
							v:TakeDamage(player.Damage * 10, 0, EntityRef(fam), 1)
						end
					end
					data.entTable = {}
				end
			end
			if InutilLib.IsFinishedMultiple(spr, "Special", "Special", "Special") then
				playerdata.IsAttackActive = false
			end
		else
			--walk anims
			if not InutilLib.IsPlayingMultiple(spr, "ShootSide", "ShootFront", "ShootBack") then
				walkAnim = InutilLib.AnimWalkFrame(fam, false, "WalkSide", "WalkFront", "WalkBack")
			end
			
			--if not spr:IsPlaying("ShootSide") or not spr:IsPlaying("ShootFront") or not spr:IsPlaying("ShootBack")  then
			fam.Velocity = fam.Velocity * 2
			if brideProtectorAngle >= 45 and brideProtectorAngle <= 135 and currentSide ~= "down" then
				currentSide = "down"
			elseif brideProtectorAngle <= -45 and brideProtectorAngle >= -135 and currentSide ~= "up" then
				currentSide = "up"
			elseif (brideProtectorAngle <= 0 and brideProtectorAngle >= -45) or (brideProtectorAngle >= 0 and brideProtectorAngle <= 45) and currentSide ~= "right" then
				currentSide = "right"
			elseif (brideProtectorAngle <= 180 and brideProtectorAngle >= 135) or (brideProtectorAngle >= -180 and brideProtectorAngle <= -135) and currentSide ~= "left" then
				currentSide = "left"
			end
			
			if player:GetFireDirection() > -1 then
				local wA = data.walkAnim or walkAnim
				if data.Stat.FireDelay <= 0 then
					--print(wA)
					if wA then wA = math.floor(wA) end
					if not InutilLib.IsPlayingMultiple(spr, "ShootSide", "ShootFront", "ShootBack") then
						InutilLib.AnimShootFrame(fam, true, Vector.FromAngle(data.walkAnim or wA), "ShootSide", "ShootFront", "ShootBack")
					end
					local tears = player:FireTear(fam.Position, Vector.FromAngle(wA):Resized(10), false, false, false):ToTear()
					tears.Position = fam.Position
					tears.CollisionDamage = data.Stat.Damage
					tears.Scale = 2
					data.Stat.FireDelay = data.Stat.MaxFireDelay
					data.walkAnim = walkAnim
					addVel = fam.Velocity + ((Vector(-15,0):Rotated(wA)):Resized(10))
					--print(wA)
				else
					if (not InutilLib.IsPlayingMultiple(spr, "ShootSide", "ShootFront", "ShootBack") or InutilLib.IsFinishedMultiple(spr, "ShootSide", "ShootFront", "ShootBack") ) and not InutilLib.IsPlayingMultiple(spr, "WalkSide", "WalkFront", "WalkBack") and data.walkAnim then
						InutilLib.AnimShootFrame(fam, true, Vector.FromAngle(data.walkAnim), "WalkSide", "WalkFront", "WalkBack")
					end
				end
			else
				data.walkAnim = nil
				fam.Velocity = (neededPosition - fam.Position)*0.2;
			end
			--stay where?
			--fam:FollowPosition ( neededPosition );
			fam.Velocity = (neededPosition - fam.Position)*0.2 + addVel;
		end
	--end
end, ENTITY_LABAN);

end
