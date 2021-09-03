
--RED HEART MODE--
do

function yandereWaifu.RedHeartDash(player, vector)
	local playerdata = yandereWaifu.GetEntityData(player)
	local SubType = 0
	local trinketBonus = 0
	if player:HasTrinket(RebekahCurse.TRINKET_ISAACSLOCKS) then
		trinketBonus = 5
	end
	
	player.Velocity = player.Velocity + vector:Resized( REBEKAH_BALANCE.RED_HEARTS_DASH_SPEED );
								
	yandereWaifu.SpawnDashPoofParticle( player.Position, Vector(0,0), player, RebekahPoofParticleType.Red );

	playerdata.specialCooldown = REBEKAH_BALANCE.RED_HEARTS_DASH_COOLDOWN - trinketBonus;
	playerdata.invincibleTime = REBEKAH_BALANCE.RED_HEARTS_DASH_INVINCIBILITY_FRAMES;
	SchoolbagAPI.SFX:Play( SoundEffect.SOUND_CHILD_HAPPY_ROAR_SHORT, 1, 0, false, 1.5 );
	playerdata.IsDashActive = true

end

--heart bomb effect
yandereWaifu:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE, function(_, bb)
	--for p = 0, SAPI.game:GetNumPlayers() - 1 do
	if yandereWaifu.GetEntityData(bb).IsByAFanGirl then
		local player = bb.SpawnerEntity:ToPlayer()
		local controller = player.ControllerIndex;
		local sprite = bb:GetSprite();
		
		if bb.FrameCount == 1 then
			--print("callie")
			if bb.Variant ~= BombVariant.BOMB_ROCKET then
				bb:GetSprite():Load("gfx/items/pick ups/bombs/bomb2_reb", true)
				bb:GetSprite():Play("Pulse")
				bb:GetSprite():ReplaceSpritesheet(0, "gfx/items/pick ups/bombs/red_barrage_bomb.png")
				bb:GetSprite():LoadGraphics();
			else
				bb:GetSprite():Load("gfx/items/pick ups/bombs/rocket2_reb", true)
				bb:GetSprite():Play("Pulse")
				bb:GetSprite():ReplaceSpritesheet(0, "gfx/items/pick ups/bombs/red_barrage_rocket.png")
				bb:GetSprite():LoadGraphics();
			end
		end
		if bb.Variant == BombVariant.BOMB_ROCKET then
			if bb.FrameCount % 3 == 0 then
				for i = 1, 3 do
					local tear = game:Spawn( EntityType.ENTITY_TEAR, 0, bb.Position, Vector.FromAngle(bb.Velocity:GetAngleDegrees()+math.random(-35,35)+180):Resized(8), bb, 0, 0):ToTear()
					tear.Scale = math.random() * 0.7 + 0.7;
				end
			end
		end
		local function DoTinyBarrages(player, vec, ent)
			local data = yandereWaifu.GetEntityData(ent)
			--SchoolbagAPI.SetFrameLoop(40,function()
				if not data.BarFrames then data.BarFrames = 0 end
				if not data.BarAngle then data.BarAngle = 0 end --incase if nil

				data.BarFrames = data.BarFrames + 1
				
				local angle = ent.Velocity:GetAngleDegrees()
					
				----barrage angle modifications are here :3
				if data.BarFrames % 2 then
					if data.BarFrames == 0 then
						data.BarAngle = 0
					elseif data.BarFrames > 1 and data.BarFrames < 10 then
						data.BarAngle = data.BarAngle - 1
					elseif data.BarFrames > 10 and data.BarFrames < 20 then
						data.BarAngle = data.BarAngle + 2
					elseif data.BarFrames > 20 and data.BarFrames < 30 then
						data.BarAngle = data.BarAngle - 2
					elseif data.BarFrames > 30 and data.BarFrames < 40 then
						data.BarAngle = data.BarAngle + 4
					else
						data.BarAngle = 0
					end
				end
				
				local modulusnum = 3
				if data.BarFrames == 1 then
					--direction:GetAngleDegrees() = angle
				elseif --[[data.BarFrames >= 1 and data.BarFrames < 40 and]] data.BarFrames % modulusnum == (0) then
					--ent.Velocity = ent.Velocity * 0.8 --slow him down
					for i= 1, 4, 1 do
						local tear = player:FireTear( bb.Position, Vector.FromAngle((data.BarAngle + vec:GetAngleDegrees())+(i*90)-45)*(20), false, false, false):ToTear()
						tear.Position = bb.Position + Vector.FromAngle((data.BarAngle + vec:GetAngleDegrees())+(i*90)-45)*(20)
					end
					--local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0, ent.Position, Vector.FromAngle(data.BarAngle + vec:GetAngleDegrees())*(20), ent):ToTear()
					SchoolbagAPI.SFX:Play(SoundEffect.SOUND_TEARS_FIRE, 1, 0, false, 1.2)
				elseif data.BarFrames == 40 then
					data.BarFrames = nil
					data.BarAngle = nil
				end
			--end)
		end
		
		
			yandereWaifu.SpawnHeartParticles( 1, 1, bb.Position, yandereWaifu.RandomHeartParticleVelocity(), player, RebekahHeartParticleType.Red );
			--for i= 1, 4, 1 do
			DoTinyBarrages(player, (bb.Position + Vector(30,0)), bb)
			--end
			bb.ExplosionDamage = player.Damage * 17.7013;
			bb.RadiusMultiplier = 1.2;
			--[[bb.Flags = player.TearFlags
			bb.Variant = 10
			--print(tostring(bomb.Variant))
			--bb:Update()
			--bb:GetSprite():Load("gfx/love_bomb.anm2", true)
			--bb:GetSprite():LoadGraphics()
			if bb.FrameCount == 1 then
				bb:GetSprite():Load("gfx/love_bomb.anm2", true)
				bb:GetSprite():Play("Pulse", false)
				bb:GetSprite():LoadGraphics()
			elseif bb:GetSprite():IsFinished("Pulse") then
				bb:GetSprite():Play("Explode", true)
				bb:GetSprite():LoadGraphics()
			elseif bb:GetSprite():IsFinished("Explode") then
				bb:Remove()
			bb:GetSprite():ReplaceSpritesheet(0, "gfx/effects/bomb_rebeccawantsisaacalittlebittoomuch.png")
			end
			bb:GetSprite():LoadGraphics()]]
	end
end)
--[[yandereWaifu:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, damage, amount, damageFlag, damageSource, damageCountdownFrames)
	print(tostring(damageSource.Type))
	if damageSource.Type == 4 then
		print("wholesome")
		if damageSource:ToEntity():GetData().IsByAFanGirl then
			return false
		end
	end
end, EntityType.ENTITY_PLAYER)]]

--orbital target
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
		local sprite = eff:GetSprite()
		local data = yandereWaifu.GetEntityData(eff)
		local player = data.Parent
		
		local movementDirection = player:GetShootingInput();
		local roomClampSize = math.max( 5, 20 )
		if movementDirection:Length() < 0.05 then
			eff.Velocity = Vector.Zero
		else
			eff.Position = SAPI.room:GetClampedPosition(eff.Position, roomClampSize);
			eff.Velocity = (eff.Velocity * 0.9) + movementDirection:Resized( REBEKAH_BALANCE.SOUL_HEARTS_DASH_TARGET_SPEED );
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
			sprite:Play("Idle", true)
			yandereWaifu.RebekahCanShoot(player, false)
		elseif sprite:IsFinished("Idle") then
			sprite:Play("Blink",true)
		elseif eff.FrameCount >= 55 then
			Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_ORBITALNUKE, 0, eff.Position, Vector.FromAngle(1*math.random(1,360))*(math.random(2,4)), player) --heart effect
			yandereWaifu.RebekahCanShoot(player, true)
			player.FireDelay = 30
			eff:Remove()
			if yandereWaifu.GetEntityData(player).barrageNumofShots > 1 then
				for i = 1, yandereWaifu.GetEntityData(player).barrageNumofShots do
					SchoolbagAPI.SetTimer( i*30, function()
						Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_ORBITALNUKE, 1, eff.Position,( Vector(0,1):Resized(math.random(8,12))):Rotated(math.random(0,360)), player) --SAPI.room:FindFreeTilePosition( SAPI.room:GetClampedPosition((Vector.FromAngle(1*math.random(1,360))+ eff.Position*(math.random(20,50))), roomClampSize ), 0)
					end)
				end
			end
		end
		if eff.FrameCount < 35 then
			--player.Velocity = Vector(0,0)
		end
end, RebekahCurse.ENTITY_ORBITALTARGET)


yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, function(_,  eff) --orbital target
	local sprite = eff:GetSprite()
	local data = yandereWaifu.GetEntityData(eff)
	local player = data.Parent
	if not data.Init then      
		eff.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NOPITS 
		data.spr = Sprite()                                                 
		data.spr:Load("gfx/effects/red/orbital_target.anm2", true) 
		data.spr:Play("Line", true)
		data.Init = true                                              
	end      
		
	SchoolbagAPI.DeadDrawRotatedTilingSprite(data.spr, Isaac.WorldToScreen(player.Position), Isaac.WorldToScreen(eff.Position), 16, nil, 8, true)
end, RebekahCurse.ENTITY_ORBITALTARGET);


--kim jun- i mean, rebeccas rockets
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	for p = 0, SAPI.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		local controller = player.ControllerIndex
		local sprite = eff:GetSprite()
		local data = yandereWaifu.GetEntityData(eff)
		eff.GridCollisionClass =  EntityGridCollisionClass.GRIDCOLL_NOPITS 
		
		local room =  Game():GetRoom()
		--function code
		if sprite:GetFrame() == 25 then
			eff.Velocity = Vector.Zero
		else
			eff.Velocity = eff.Velocity * 0.8
		end
		if eff.FrameCount == 1 then
			if eff.SubType == 0 then
				sprite:Play("Falling", true)
			elseif eff.SubType == 1 then
				sprite:Play("FallingSingular", true)
			end
		elseif sprite:IsEventTriggered("Blow") then
			local megumin = Isaac.Spawn(EntityType.ENTITY_BOMBDROP, 0, 0, eff.Position, Vector(0,0), eff):ToBomb() --this is a workaround to make explosions larger
			megumin:SetExplosionCountdown(1)
			megumin.Visible = false
			megumin.RadiusMultiplier = data.CustomRadius or 2.2 --my favorite part
			megumin.ExplosionDamage = data.CustomDamage or player.Damage*5
			for i, ent in pairs(Isaac.GetRoomEntities()) do
				if ent:IsEnemy() and not ent:IsVulnerableEnemy() then
					ent:AddPoison(EntityRef(eff), 5, player.Damage*17)
				end
			end
			if player:HasWeaponType(WeaponType.WEAPON_LASER) then
				for i = 0, 360, 360/8 do
					local techlaser = player:FireTechLaser(eff.Position, 0, Vector.FromAngle(i), false, true)
					techlaser.CollisionDamage = player.Damage * 5
					--techlaser.Damage = player.Damage * 5 doesn't exist lol
				end
			elseif player:HasWeaponType(WeaponType.WEAPON_BRIMSTONE) then
				for i = 0, 360, 360/8 do
					local brim = player:FireBrimstone(eff.Position, 0, Vector.FromAngle(i), false, true)
					brim.CollisionDamage = player.Damage * 5
				end
			end
		elseif sprite:IsFinished("Falling") or sprite:IsFinished("FallingSingular") then
			eff:Remove()
		end
		if eff.FrameCount < 35 and eff.SubType == 0 then
			player.Velocity = Vector(0,0)
		end
	end
end, RebekahCurse.ENTITY_ORBITALNUKE)

--red knife
function yandereWaifu:RedKnifeRender(tr, _)
	if tr.Variant == RebekahCurse.ENTITY_REDKNIFE and tr.FrameCount == 1 then
		tr:GetSprite():Play("RegularTear", false);
		--tr:GetSprite():LoadGraphics();
		
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_POST_TEAR_RENDER, yandereWaifu.RedKnifeRender)

function yandereWaifu:RedKnifeUpdate(tr)
	local data = yandereWaifu.GetEntityData(tr)
	if tr.Variant == RebekahCurse.ENTITY_REDKNIFE then
		local angleNum = (tr.Velocity):GetAngleDegrees();
		tr:GetSprite().Rotation = angleNum + 90;
		tr:GetData().Rotation = tr:GetSprite().Rotation;
		tr.Velocity = tr.Velocity * 0.9
	end
end
yandereWaifu:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, yandereWaifu.RedKnifeUpdate)

local RebekahNormalSword = {
	[1] = "1.png",
	[2] = "2.png",
	[3] = "3.png",
	[4] = "4.png",
	[5] = "5.png",
	[6] = "6.png"
}

local RebekahBigNormalSword = {
	[1] = "1.png",
	[2] = "2.png",
	[3] = "3.png",
	[4] = "4.png",
	[5] = "5.png",
	[6] = "6.png"
}

local RebekahSwordTable = {
	[1] = "1.png",
	[2] = "2.png",
	[3] = "3.png",
	[4] = "4.png",
	[5] = "5.png",
	[6] = "6.png",
	[7] = "7.png",
	[8] = "8.png",
	[9] = "9.png",
	[10] = "10.png",
	[11] = "11.png",
	[12] = "12.png",
	[13] = "13.png",
	[14] = "14.png",
	[15] = "15.png",
	[16] = "16.png",
	[17] = "17.png",
	[18] = "18.png"
}

local RebekahBigSwordTable = {
	[1] = "1.png",
	[2] = "2.png",
	[3] = "3.png",
	[4] = "4.png",
	[5] = "5.png",
	[6] = "6.png",
	[7] = "7.png"
}

local LightSaberTable = {
	[1] = "1_laser.png",
	[2] = "2_laser.png",
	[3] = "3_laser.png",
	[4] = "4_laser.png",
	[5] = "5_laser.png",
	[6] = "6_laser.png",
	[7] = "7_laser.png",
	[8] = "8_laser.png"
}

--slash effect
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	for i,player in ipairs(SAPI.players) do
		local controller = player.ControllerIndex
		local sprite = eff:GetSprite()
		local data = yandereWaifu.GetEntityData(eff)
		eff.GridCollisionClass =  EntityGridCollisionClass.GRIDCOLL_NOPITS 
		
		local function HasGiantModifyingStuff() --checks if giant tear stuff exists
			if player:HasCollectible(CollectibleType.COLLECTIBLE_IPECAC) or player:HasCollectible(CollectibleType.COLLECTIBLE_POLYPHEMUS) then
				return true
			end
			return false
		end
		
		local room =  Game():GetRoom()
		--function code
		if eff.FrameCount == 1 then
			sprite:Play("Zenith", true)
			if not data.PermanentAngle then  data.PermanentAngle = eff.Velocity end
			if eff.SubType == 0 then
				local swordTable --thing stores what kind of sword table will be used 
				if HasGiantModifyingStuff() then
					swordTable = RebekahBigSwordTable
				else
					swordTable = RebekahSwordTable
				end
				local chosenNum = math.random(1,#swordTable)
				for i = 0, 15 do 
					if i == 0 or i == 4 or i == 8 or i == 12 then
						chosenNum = math.random(1,#swordTable)
					end
					if math.random(1,3) == 3 then --sets if you will get special swords to pop out
						if HasGiantModifyingStuff() then
							sprite:ReplaceSpritesheet(i, "gfx/effects/red/swords/big_special/"..RebekahBigSwordTable[chosenNum])
						else
							sprite:ReplaceSpritesheet(i, "gfx/effects/red/swords/special/"..RebekahSwordTable[chosenNum])
						end
					else
						if HasGiantModifyingStuff () then
							sprite:ReplaceSpritesheet(i, "gfx/effects/red/swords/big_normal/"..RebekahBigSwordTable[math.random(1,#RebekahNormalSword)])
						else
							sprite:ReplaceSpritesheet(i, "gfx/effects/red/swords/normal/"..RebekahSwordTable[math.random(1,#RebekahBigNormalSword)])
						end
					end
					--if HasGiantModifyingStuff() then
					--	sprite.PlaybackSpeed = 0.5
					--end
					sprite:LoadGraphics()
				end
			elseif eff.SubType == 1 then
				local chosenNum = math.random(1,#LightSaberTable)
				for i = 0, 15 do 
					if i == 0 or i == 4 or i == 8 or i == 12 then
						chosenNum = math.random(1,#LightSaberTable)
					end
					sprite:ReplaceSpritesheet(i, "gfx/effects/red/swords/starwars/"..LightSaberTable[chosenNum])
					sprite:LoadGraphics()
				end
			end
		elseif --[[eff.FrameCount == 40 or]] yandereWaifu.GetEntityData(player).IsAttackActive == false then
			eff:Remove()
		elseif sprite:IsFinished("Zenith") then
			sprite:Play("Zenith", true)
		end
		--close hitbox
		if eff.FrameCount % data.MultiTears == (0) then
			if eff.FrameCount < yandereWaifu.GetEntityData(player).redcountdownFrames then
				for i, ent in pairs (Isaac.GetRoomEntities()) do
					if ent:IsEnemy() and ent:IsVulnerableEnemy() and not ent:IsDead() then
						if ent.Position:Distance((eff.Position)) <= 50 then
							ent:TakeDamage((player.Damage * data.MultiTears) * 3, 0, EntityRef(eff), 1)
						end
					end
				end
				--player.Velocity = Vector(0,0)
			end
			--mid hitbox
			--local customBody = Isaac.Spawn(EntityType.ENTITY_EFFECT, 5, 0, eff.Position + (Vector(100,0):Rotated(data.PermanentAngle:GetAngleDegrees())), Vector(0,0), player) --body effect
			if eff.FrameCount < yandereWaifu.GetEntityData(player).redcountdownFrames then
				for i, ent in pairs (Isaac.GetRoomEntities()) do
					if ent:IsEnemy() and ent:IsVulnerableEnemy() and not ent:IsDead() then
						if ent.Position:Distance(eff.Position + (Vector(100,0):Rotated(data.PermanentAngle:GetAngleDegrees()))) <= 70 then
							ent:TakeDamage((player.Damage * data.MultiTears) * 1.5, 0, EntityRef(eff), 1)
						end
					end
				end
				--player.Velocity = Vector(0,0)
			end
			--far hitbox
			if eff.FrameCount < yandereWaifu.GetEntityData(player).redcountdownFrames then
				for i, ent in pairs (Isaac.GetRoomEntities()) do
					if ent:IsEnemy() and ent:IsVulnerableEnemy() and not ent:IsDead() then
						if ent.Position:Distance((eff.Position + (Vector(200,0):Rotated(data.PermanentAngle:GetAngleDegrees())))) <= 100 or
						ent.Position:Distance((eff.Position + (Vector(300,0):Rotated(data.PermanentAngle:GetAngleDegrees())))) <= 70 or
						ent.Position:Distance((eff.Position + (Vector(400,0):Rotated(data.PermanentAngle:GetAngleDegrees())))) <= 50 then
							ent:TakeDamage((player.Damage * data.MultiTears), 0, EntityRef(eff), 1)
						end
					end
				end
				--player.Velocity = Vector(0,0)
			end
		end
		eff.Velocity = player.Velocity*2
		eff:GetSprite().Rotation = data.PermanentAngle:GetAngleDegrees();
	end
end, RebekahCurse.ENTITY_SLASH)
end