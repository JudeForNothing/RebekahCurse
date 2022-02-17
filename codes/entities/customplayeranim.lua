
--custom animation actions and other gimmicks that I can't name in one word lol
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local sprite = eff:GetSprite();
	local data = yandereWaifu.GetEntityData(eff);
	local room =  Game():GetRoom();
	if not data.Player then
	--	Isaac.DebugString("fool")
	end
    local roomClampSize = math.max( data.Player.Size, 20 );
	local controller = data.Player.ControllerIndex
	if not data.gravityData then data.gravityData = {} end
	local gravityData = data.gravityData
	
	
	if not yandereWaifu.GetEntityData(data.Player).BoneStacks then yandereWaifu.GetEntityData(data.Player).BoneStacks = 0 end
	
	if not data.DontFollowPlayer then
		eff.Position = data.Player.Position
		eff.Velocity = data.Player.Velocity
	end
	
    local bonerOwnerData = yandereWaifu.GetEntityData(data.Player);
	if data.IsHopping then
		data.Player:SetShootingCooldown(2)
		--print("hello")
		local function End()
			--print("how")
			--data.Player.GridCollisionClass = yandereWaifu.GetEntityData(data.Player).LastGridCollisionClass;
			--data.Player.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
			data.Player.Visible = true
			data.Player.FireDelay = 0
			yandereWaifu.GetEntityData(data.Player).IsDashActive = false
			yandereWaifu.GetEntityData(data.Player).NoBoneSlamActive = true
			yandereWaifu.GetEntityData(data.Player).IsVaulting = false
			yandereWaifu.GetEntityData(data.Player).IsUninteractible = false
			eff:Remove()
			--data.Player.ControlsEnabled = true
		end
		if eff.FrameCount == 1 then --beginning
			sprite.PlaybackSpeed = 1.5
			sprite:Load("gfx/effects/bone/bonedash.anm2",true)
			sprite:Play("StartSlam", true) --normal attack
			data.Player.Visible = false
			yandereWaifu.GetEntityData(data.Player).IsUninteractible = true
			--yandereWaifu.GetEntityData(data.Player).LastGridCollisionClass = data.Player.GridCollisionClass;
			--yandereWaifu.GetEntityData(data.Player).LastEntityCollisionClass = data.Player.EntityCollisionClass;
			data.BounceCount = 1 --this checks how much times you have been bouncing
			--data.Player.ControlsEnabled = false
		elseif eff.FrameCount == 2 then
			data.Player.Velocity = data.Player.Velocity*5
		elseif sprite:IsFinished("StartSlam") then
			sprite:Play("Falling", true)
		elseif sprite:IsFinished("Falling") and data.BounceCount then
			if data.BounceCount < 1 then
				sprite:Play("Falling", true)
				data.BounceCount = data.BounceCount + 1
			else
				End()
			end
		elseif sprite:IsPlaying("Falling") then
			data.Player.Velocity = data.Player.Velocity * 1.15
			if (Input.IsActionPressed(ButtonAction.ACTION_SHOOTDOWN, controller) or Input.IsActionPressed(ButtonAction.ACTION_SHOOTUP, controller) 
			or Input.IsActionPressed(ButtonAction.ACTION_SHOOTLEFT, controller) or Input.IsActionPressed(ButtonAction.ACTION_SHOOTRIGHT, controller)) then
				local customBody = Isaac.Spawn(EntityType.ENTITY_EFFECT, ENTITY_EXTRACHARANIMHELPER, 0, data.Player.Position, Vector(0,0), data.Player) --body effect
				yandereWaifu.GetEntityData(customBody).Player = data.Player
				yandereWaifu.GetEntityData(customBody).IsVaulting = true
				yandereWaifu.GetEntityData(yandereWaifu.GetEntityData(customBody).Player).vaultVelocity = data.Player:ToPlayer():GetMovementInput():Resized( BALANCE.BONE_HEARTS_VAULT_VELOCITY );
				eff:Remove()
				data.Player.ControlsEnabled = true
			end
		end
	elseif data.IsVaulting then
		data.Player:SetShootingCooldown(2)
		if eff.FrameCount == 1 then --beginning
			sprite:Load("gfx/effects/bone/bonedash.anm2",true)
			sprite:Play("StartSlam", true) --normal attack
			if not data.CurrentAirSpan then data.CurrentAirSpan = 0 end
			data.Player.Visible = false
			yandereWaifu.GetEntityData(data.Player).IsUninteractible = true
			yandereWaifu.GetEntityData(data.Player).LastGridCollisionClass = data.Player.GridCollisionClass;
			yandereWaifu.GetEntityData(data.Player).LastEntityCollisionClass = data.Player.EntityCollisionClass;
		elseif sprite:IsFinished("StartSlam") then
			yandereWaifu.GetEntityData(data.Player).LastGridCollisionClass = data.Player.GridCollisionClass;
			sprite:Play("InAir")
			yandereWaifu.GetEntityData(data.Player).InAir = true
			data.Player.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
			data.Player.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		end
		--print(tostring(gravityData.ZOffsetFloat))
		if yandereWaifu.GetEntityData(data.Player).InAir then
			if not gravityData.Init then
				gravityData.InAirSpan = 25 --this tells how long does it take for Rebecca to be in air
				gravityData.ZOffsetVector = Vector(0,0) --tells how high the sprite is supposed to be
				gravityData.ZOffsetFloat = 0 --tells how high sprite is with a number, not a vector
				gravityData.IsSlamming = false --tells if Rebecca is going to slam down/ seems to be unused lol
				gravityData.AccelAddFloat = 10 --tells how fast Rebecca is going to go up and down
				gravityData.AirSpanMultiply = 1 --tells how fast the current air span should be going
                gravityData.Init = true
				yandereWaifu.GetEntityData(data.Player).BoneStacks = 0 --this tells how much you bounced...
			end
			data.CurrentAirSpan = data.CurrentAirSpan + (1*gravityData.AirSpanMultiply) --adds up special frame for how long they are in midair
			if not gravityData.IsSlamming then
				--arc code
				if data.CurrentAirSpan <= ((gravityData.InAirSpan/2)-6) then --if in the first half of the arc
					gravityData.ZOffsetVector = gravityData.ZOffsetVector + Vector(0,-(gravityData.AccelAddFloat))
					gravityData.ZOffsetFloat = gravityData.ZOffsetFloat + gravityData.AccelAddFloat 
				elseif data.CurrentAirSpan >= ((gravityData.InAirSpan/2)+6) and data.CurrentAirSpan < gravityData.InAirSpan then --if in the other half of the arc
					gravityData.ZOffsetVector = gravityData.ZOffsetVector - Vector(0,-(gravityData.AccelAddFloat))
					gravityData.ZOffsetFloat = gravityData.ZOffsetFloat - gravityData.AccelAddFloat 
				elseif data.CurrentAirSpan >= gravityData.InAirSpan then --if finished being in midair
					sprite:Play("EndLand", true)
					yandereWaifu.GetEntityData(data.Player).InAir = false
					data.CurrentAirSpan = 0
					speaker:Play( SoundEffect.SOUND_FETUS_LAND, 1, 0, false, 0.7 );
				end
            end
            --[[ this section keeps the player moving in the same direction they start vaulting
            while also slightly decaying that velocity and allowing minimal adjustments ]]
			
            data.Player.Velocity = bonerOwnerData.vaultVelocity;
            bonerOwnerData.vaultVelocity = bonerOwnerData.vaultVelocity * 0.95 + data.Player:GetMovementInput():Resized(0.5);

            eff.Velocity = data.Player.Position - eff.Position
			
			data.Player.Position = room:GetClampedPosition(data.Player.Position, roomClampSize);
			--eff.Position = data.Player.Position
			eff.SpriteOffset = gravityData.ZOffsetVector
			data.Player.FireDelay = data.Player.MaxFireDelay --keeps Rebecca from firing, it's creepy to see tears pop out of nowhere...
			--slamdown code!
			if (Input.IsActionPressed(ButtonAction.ACTION_SHOOTDOWN, controller) or Input.IsActionPressed(ButtonAction.ACTION_SHOOTUP, controller) 
			or Input.IsActionPressed(ButtonAction.ACTION_SHOOTLEFT, controller) or Input.IsActionPressed(ButtonAction.ACTION_SHOOTRIGHT, controller)) 
			and gravityData.ZOffsetFloat >= 50 and gravityData.ZOffsetFloat then --if you shoot and is in the other end of the arc process
				sprite:Play("SlamDown", true)
				yandereWaifu.GetEntityData(data.Player).InAir = false
                gravityData.IsSlamming = true
                data.Player.Velocity = data.Player.Velocity * 0.2;
                bonerOwnerData.vaultVelocity = bonerOwnerData.vaultVelocity * 0.2;
			end
			local homeEnt = InutilLib.GetClosestGenericEnemy(eff, 100)
			--friendly home effect
			if homeEnt and homeEnt:IsActiveEnemy() and homeEnt:IsVulnerableEnemy() then
				data.Player.Velocity = data.Player.Velocity + ((homeEnt.Position - data.Player.Position) * 0.05)
			end
		elseif sprite:IsPlaying("SlamDown") then
			--dashdown code
			if gravityData.ZOffsetFloat <= 0 then
				sprite:Play("EndSlam") --end slam anim
				yandereWaifu.GetEntityData(data.Player).InAir = false
				for i, entities in pairs(Isaac.GetRoomEntities()) do
					if entities:IsEnemy() and entities:IsVulnerableEnemy() and not entities:IsDead() then
						if entities.Position:Distance(data.Player.Position) < entities.Size + data.Player.Size + 45 then
							entities:TakeDamage(data.Player.Damage, 0, EntityRef(eff), 1)
							if entities.Position:Distance(data.Player.Position) < entities.Size + data.Player.Size and data.Player.Size <= (entities.Size - 2) then --if close enough and if the entity slammed on is bigger than Rebecca, cause it doesn't makes sense if you can bounce on a tiny thing like a fly...
                                bonerOwnerData.vaultVelocity = bonerOwnerData.vaultVelocity + data.Player:ToPlayer():GetMovementInput();
                                data.WillBounceAgain = true--this tells if you have successfully hit somebody wants told me the world is gonna- sorry
								data.HasBounced = true --this tells that you had bounced
							end
						end
					end
				end
				speaker:Play( SoundEffect.SOUND_FORESTBOSS_STOMPS, 1, 0, false, 1 );
				ILIB.game:ShakeScreen(10);
			else
				gravityData.ZOffsetVector = gravityData.ZOffsetVector - Vector(0,-(gravityData.AccelAddFloat*2))
				gravityData.ZOffsetFloat = gravityData.ZOffsetFloat - (gravityData.AccelAddFloat*2)
			end
			eff.Velocity = data.Player.Velocity
			eff.Position = data.Player.Position
			eff.SpriteOffset = gravityData.ZOffsetVector
			data.Player.FireDelay = data.Player.MaxFireDelay --keeps Rebecca to not fire, it's creepy to see tears pop out of nowhere...
		end
		--finished job
		if sprite:IsPlaying("EndSlam") or sprite:IsPlaying("EndLand") then
			if sprite:IsPlaying("EndSlam") and sprite:GetFrame() == 1 then
				local gridStomped = room:GetGridEntityFromPos(eff.Position) --grid that Rebecca stepped on
				--if gridStomped:GetType() == GridEntityType.GRID_TNT or gridStomped:GetType() == GridEntityType.GRID_ROCK then
				if gridStomped ~= nil then
					gridStomped:Destroy()
				end
				if yandereWaifu.GetEntityData(data.Player).BoneStacks > 0 then
					yandereWaifu.GetEntityData(data.Player).specialBoneHeartStompCooldown = BALANCE.BONE_HEARTS_MODIFIED_DASH_COOLDOWN;
				end
				--elseif gridStomped:GetType() == GridEntityType.GRID_TNT
			end
			if not data.WillBounceAgain then
				eff.Velocity = eff.Velocity * 0.7
				data.Player.Velocity = Vector(0,0)
				data.Player.Position = eff.Position
			else
			--print("has went here")
				--reset!
				sprite:Play("InAir")
				yandereWaifu.GetEntityData(data.Player).InAir = true
				gravityData.InAirSpan = 45 
				gravityData.ZOffsetVector = Vector(0,0) 
				gravityData.ZOffsetFloat = 0 
				gravityData.IsSlamming = false 
				data.CurrentAirSpan = 0
				data.WillBounceAgain = false
				data.Player.Velocity = ((data.Player.Velocity * 0.9) + Vector.FromAngle(1*math.random(1,360))*(math.random(10,14))) * (2 + ((yandereWaifu.GetEntityData(data.Player).BoneStacks*5)/10))
				--difficulty added to each bounce made is done below:
				--gravityData.AccelAddFloat = gravityData.AccelAddFloat + 2
				--gravityData.AirSpanMultiply = gravityData.AirSpanMultiply + 0.3
				--add stacks
				yandereWaifu.GetEntityData(data.Player).BoneStacks = yandereWaifu.GetEntityData(data.Player).BoneStacks + 1
				--effect
				local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, ENTITY_SLAMDUST, 0, data.Player.Position, Vector(0,0), data.Player)		
			end
			if sprite:GetFrame() == 1 then
				local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, ENTITY_SLAMDUST, 0, data.Player.Position, Vector(0,0), data.Player)			
			end
		elseif sprite:IsFinished("EndSlam") or sprite:IsFinished("EndLand") then
			data.Player.Position = eff.Position
			--revert back player!
			if data.Player.CanFly == true and room:GetType() ~= RoomType.ROOM_DUNGEON then
    		data.Player.Position = eff.Position;
				if room:IsPositionInRoom(data.Player.Position, 0) == false then
					data.Player.Velocity = Vector( 0, 0 );
					data.Player.Position = room:GetClampedPosition( data.Player.Position, roomClampSize );
				end
			else
				data.Player.Position = room:FindFreeTilePosition( eff.Position, 0 )
				if room:IsPositionInRoom(data.Player.Position, 0) == false then
					data.Player.Velocity = Vector( 0, 0 );
					data.Player.Position = room:FindFreeTilePosition( room:GetClampedPosition( data.Player.Position, roomClampSize ), 0 );
				end
			end
			data.Player.GridCollisionClass = yandereWaifu.GetEntityData(data.Player).LastGridCollisionClass;
			data.Player.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
			data.Player.Visible = true
			data.Player.FireDelay = 0
			yandereWaifu.GetEntityData(data.Player).IsVaulting = false
			yandereWaifu.GetEntityData(data.Player).IsUninteractible = false
			yandereWaifu.GetEntityData(data.Player).IsDashActive = false
			yandereWaifu.GetEntityData(data.Player).NoBoneSlamActive = true
			--add special stuff to the code
			if data.HasBounced then --makes it that you can't vault immediately after successful bouncing
				--yandereWaifu.GetEntityData(data.Player).specialCooldown = BONE_HEARTS_MODIFIED_DASH_COOLDOWN;
				yandereWaifu.GetEntityData(data.Player).invincibleTime = BALANCE.BONE_HEARTS_DASH_INVINCIBILITY_FRAMES;
				data.HasBounced = false;
				--DASH_DOUBLE_TAP.cooldown = yandereWaifu.GetEntityData(data.Player).specialCooldown; --adds something new for the cooldowns, because the default stuff cant be used
			end
			eff:Remove()
		end
		--code just in case Rebecca is dead but this thing isn't lol
		if data.Player:IsDead() then eff:Remove() end
	elseif data.IsSlamming then
		data.Player.Velocity = Vector(0,0);
		if eff.FrameCount == 1 then --beginning
			--print(tostring(data.Player:GetData().BoneStacks))
			data.Player.Visible = false
			eff.Visible = true
			--yandereWaifu.GetEntityData(data.Player).invincibleTime = BALANCE.BONE_HEARTS_MODIFIED_DASH_INVINCIBILITY_FRAMES;
			sprite:Load("gfx/characters/slamdownsp.anm2",true)
			if not data.CurrentAirSpan then data.CurrentAirSpan = 0 end
			yandereWaifu.GetEntityData(data.Player).IsUninteractible = true
			data.Player.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
			data.Player.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
			if not yandereWaifu.GetEntityData(data.Player).BoneStacks or yandereWaifu.GetEntityData(data.Player).BoneStacks <= 1 and yandereWaifu.GetEntityData(data.Player).BoneStacks >= 0 then
				sprite:Play("BoneDown0",true)
				--print("gosh")
				sprite:Play("BoneDown"..tostring(yandereWaifu.GetEntityData(data.Player).BoneStacks),true)
			elseif yandereWaifu.GetEntityData(data.Player).BoneStacks and yandereWaifu.GetEntityData(data.Player).BoneStacks > 5 then
				sprite:Play("BoneDown5",true)
			elseif yandereWaifu.GetEntityData(data.Player).BoneStacks and yandereWaifu.GetEntityData(data.Player).BoneStacks >= 2 and yandereWaifu.GetEntityData(data.Player).BoneStacks <= 5 then
				sprite:Play("BoneDown"..tostring(yandereWaifu.GetEntityData(data.Player).BoneStacks),true)
				--print("woahs")
			end 
		elseif InutilLib.IsPlayingMultiple(sprite, "BoneDown2", "BoneDown3", "BoneDown4", "BoneDown5") then
			--sund
			if sprite:GetFrame() > 0 then
				speaker:Play( SOUND_PUNCH, 1, 0, false, 1 );
			end
		elseif sprite:IsFinished("BoneDown"..tostring(yandereWaifu.GetEntityData(data.Player).BoneStacks)) or sprite:IsFinished("BoneDown5") or sprite:IsFinished("BoneDown0")then
			
			--other stuff
			if data.Player.CanFly == true and room:GetType() ~= RoomType.ROOM_DUNGEON then
    		data.Player.Position = eff.Position;
				if room:IsPositionInRoom(data.Player.Position, 0) == false then
					data.Player.Velocity = Vector( 0, 0 );
					data.Player.Position = room:GetClampedPosition( data.Player.Position, roomClampSize );
				end
			else
				data.Player.Position = room:FindFreeTilePosition( eff.Position, 0 )
				if room:IsPositionInRoom(data.Player.Position, 0) == false then
					data.Player.Velocity = Vector( 0, 0 );
					data.Player.Position = room:FindFreeTilePosition( room:GetClampedPosition( data.Player.Position, roomClampSize ), 0 );
				end
			end

			data.Player.EntityCollisionClass = yandereWaifu.GetEntityData(data.Player).LastEntityCollisionClass
			data.Player.GridCollisionClass = yandereWaifu.GetEntityData(data.Player).LastGridCollisionClass
			data.Player.Position = eff.Position
			yandereWaifu.GetEntityData(data.Player).IsUninteractible = false
			data.Player.Visible = true
			data.Player.ControlsEnabled = true
			eff:Remove()
			local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, ENTITY_SLAMDUST, 0, data.Player.Position, Vector(0,0), data.Player);
			speaker:Play( SoundEffect.SOUND_FORESTBOSS_STOMPS, 1, 0, false, 1 );
			ILIB.game:ShakeScreen(10);
			yandereWaifu.GetEntityData(data.Player).invincibleTime = BALANCE.BONE_HEARTS_DASH_INVINCIBILITY_FRAMES;
			--print(tostring(yandereWaifu.GetEntityData(data.Player).invincibleTime))
			--pound!
			for i, entities in pairs(Isaac.GetRoomEntities()) do
				if entities:IsEnemy() and entities:IsVulnerableEnemy() and not entities:IsDead() then
					if entities.Position:Distance(data.Player.Position) < entities.Size + data.Player.Size + 60 + (yandereWaifu.GetEntityData(data.Player).BoneStacks * 2) then
						entities:TakeDamage(data.Player.Damage * (2*(1+(yandereWaifu.GetEntityData(data.Player).BoneStacks*5))), 0, EntityRef(eff), 1)
					end
				end
			end
			--crackwaves
			for i = 0, 360, 360/4 do
				local crack = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACKWAVE, 0, data.Player.Position, Vector.FromAngle(i), ent):ToEffect()
				crack.LifeSpan = 0+(yandereWaifu.GetEntityData(data.Player).BoneStacks);
				crack:SetDamageSource (EntityType.ENTITY_PLAYER);
				crack.Rotation = i
			end
			yandereWaifu.GetEntityData(data.Player).BoneStacks = 0
			yandereWaifu.GetEntityData(data.Player).NoBoneSlamActive = true
		end
	elseif data.IsJumpingUp then --deprecated?
		if eff.FrameCount == 1 then --beginning
			data.Player.Visible = false
			eff.Visible = true
			sprite:Load("gfx/characters/slamdownsp.anm2",true)
			sprite:Play("JumpUp",true)
		elseif sprite:IsFinished("JumpUp") then
			eff:Remove()
		end
	elseif data.IsLeftover then
		if eff.FrameCount == 1 then --beginning
			--data.Player.Visible = false
			sprite:Load("gfx/effects/bone/bonebody.anm2",true)
			sprite:Play("Dies",true)
		elseif sprite:IsFinished("Dies") then
			sprite:Play("Chill",true)
		elseif sprite:IsFinished("Revives") or eff.FrameCount > 90 then
			eff:Remove()
		end
	elseif data.WizoobIn then
		if eff.FrameCount == 1 then --beginning
			data.Player.Visible = false
			eff.Visible = true
			sprite:Load("gfx/characters/wizoobteleport.anm2",true)
			sprite:Play("Vanish",true)
		elseif sprite:GetFrame() == 2 then
			local target = Isaac.Spawn( EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_SOULTARGET, 0, data.Player.Position, Vector(0,0), data.Player );
			yandereWaifu.GetEntityData(target).Parent = data.Player
			data.Player.ControlsEnabled = true
			data.DontFollowPlayer = true
		elseif sprite:IsFinished("Vanish") then
			yandereWaifu.SpawnEctoplasm( eff.Position, Vector ( 0, 0 ) , math.random(13,15)/10, data.Player);
			local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, 132, 0, eff.Position, Vector.Zero, data.Player):ToEffect()
			poof:GetSprite():ReplaceSpritesheet(0, "gfx/effects/soul/splash_big_ectoplasm.png")
			poof:GetSprite():LoadGraphics()
			eff:Remove()
		end
		
	elseif data.WizoobOut then
		data.Player.Position = eff.Position
		data.Player.Velocity = eff.Velocity
		if eff.FrameCount == 1 then --beginning
			data.Player.Visible = false
			eff.Visible = true
			sprite:Load("gfx/characters/wizoobteleport.anm2",true)
			sprite:Play("Appear",true)
			--poof smoke thing
			Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 1, data.Player.Position, Vector(0,0), data.Player)
		elseif eff.FrameCount == 5 then
			yandereWaifu.SpawnPoofParticle( data.Player.Position, Vector( 0, 0 ), data.Player, RebekahPoofParticleType.Blue );
			yandereWaifu.SpawnHeartParticles( 3, 5, data.Player.Position, yandereWaifu.RandomHeartParticleVelocity(), player, RebekahHeartParticleType.Blue );
			yandereWaifu.SpawnEctoplasm( data.Player.Position, Vector ( 0, 0 ) , math.random(13,15)/10, data.Player);
			yandereWaifu.GetEntityData(data.Player).LeaksJuices = 80;
			
			local chosenNumofBarrage =  math.random( 6, 9 );
			for i = 1, chosenNumofBarrage do
				data.Player.Velocity = data.Player.Velocity * 0.8; --slow him down
				--local tear = player:FireTear(player.Position, Vector.FromAngle(data.specialAttackVector:GetAngleDegrees() - math.random(-10,10))*(math.random(10,15)), false, false, false):ToTear()
				local tear = ILIB.game:Spawn( EntityType.ENTITY_TEAR, 0, data.Player.Position, Vector.FromAngle( math.random() * 360 ):Resized(REBEKAH_BALANCE.GOLD_HEARTS_DASH_ATTACK_SPEED), player, 0, 0):ToTear()
				InutilLib.MakeTearLob(tear, -9, 9 )
				tear:GetSprite():ReplaceSpritesheet(0, "gfx/tears_ecto.png")
				tear:GetSprite():LoadGraphics()
				tear.Scale = math.random() * 0.7 + 0.7;
				tear.CollisionDamage = data.Player.Damage * 1.3;
				--tear.BaseDamage = player.Damage * 2
			end
			
			local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, 132, 0, data.Player.Position, Vector.Zero, data.Player):ToEffect()
			poof:GetSprite():ReplaceSpritesheet(0, "gfx/effects/soul/splash_big_ectoplasm.png")
			poof:GetSprite():LoadGraphics()
		elseif sprite:IsFinished("Appear") then
			--local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_PERSONALITYPOOF, 0, data.Player.Position, Vector.Zero, data.Player)
		
			yandereWaifu.GetEntityData(data.Player).IsDashActive = false
			eff:Remove()
			data.Player.Visible = true;
			data.Player.ControlsEnabled = true;
			data.Player.GridCollisionClass = yandereWaifu.GetEntityData(data.Player).LastGridCollisionClass;
			data.Player.EntityCollisionClass = yandereWaifu.GetEntityData(data.Player).LastEntityCollisionClass;
			
			--reset
			yandereWaifu.GetEntityData(data.Player).LastEntityCollisionClass = nil
			yandereWaifu.GetEntityData(data.Player).LastGridCollisionClass = nil
			
			InutilLib.SetTimer( 60*3, function()
				if yandereWaifu.GetEntityData(data.Player).SoulBuff then --give lenience to the barrage
					yandereWaifu.GetEntityData(data.Player).SoulBuff = false
					data.Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE);
					data.Player:EvaluateItems()
					--become depressed again
					yandereWaifu.ApplyCostumes( yandereWaifu.GetEntityData(data.Player).currentMode, data.Player , false, false)
					data.Player:RemoveCostume(Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_NUMBER_ONE))
				end
			end)
		end
	elseif data.IsGreivous then
		if eff.FrameCount == 1 then --beginning
			eff.Visible = true
			sprite:Load("gfx/effects/red/swords/grievousintro.anm2",true)
			sprite:Play("Intro",false)
		elseif sprite:IsFinished("Intro") then
			local cut = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_SLASH, 1, data.Player.Position--[[+Vector.FromAngle(direction:GetAngleDegrees()):Resized(40)]], Vector(0,0), data.Player);
			yandereWaifu.GetEntityData(cut).PermanentAngle = data.PermanentAngle
			yandereWaifu.GetEntityData(cut).MultiTears = data.MultiTears
			yandereWaifu.GetEntityData(cut).TearDelay = data.TearDelay
			yandereWaifu.GetEntityData(data.Player).isPlayingCustomAnim = false
			eff:Remove()
		end
	elseif data.DashBrokenGlitch then
		if eff.FrameCount == 1 then --beginning
			eff.Visible = true
			sprite:Load("gfx/effects/broken/dash_remnant.anm2",true)
		end
		sprite:Play("Remnant_0",false)
	elseif data.DashBrokenFragment then
		if eff.FrameCount == 1 then --beginning
			eff.Visible = true
			sprite:Load("gfx/effects/broken/dash_remnant_fragments.anm2",true)
		end
		sprite:Play("Remnant_0",false)
	elseif data.TildeConsole then
		eff.Position = data.Player.Position
		eff.Velocity = data.Player.Velocity
			
		if eff.FrameCount == 1 then --beginning
			sprite:Load("gfx/effects/broken/tilde_parry.anm2",true)
			
			sprite:Play("Parry",true)
		end
		
		if sprite:IsOverlayFinished("Overlay_0") then
			sprite:Play("Success",true)
			sprite:RemoveOverlay()
		end
		if sprite:IsPlaying("SuccessLoop") and not data.Debug then
			
			if not data.DebugOption then 
				eff.RenderZOffset = 1000
				--sprite:SetFrame("Success",0)
				data.DebugOption = 1 
				sprite:PlayOverlay("Overlay_"..tostring(data.DebugOption),true)
			end
			
			if sprite:IsOverlayFinished("Overlay_"..tostring(data.DebugOption)) then
				if data.DebugOption < 13 then
					data.DebugOption = data.DebugOption + 1
					sprite:PlayOverlay("Overlay_"..tostring(data.DebugOption),true)
				else
					data.DebugOption = nil
					sprite:PlayOverlay("Overlay_0", true)
					data.Debug = true
					sprite:Play("Success",true)
				end
			end
			
			if (data.Player:GetShootingInput().X ~= 0 or data.Player:GetShootingInput().Y ~= 0) then
				
				--debug 1
				if sprite:IsOverlayPlaying("Overlay_1") then
					for i, entenmies in pairs(Isaac.GetRoomEntities()) do --affect others
						if entenmies:IsEnemy() and entenmies:IsVulnerableEnemy() then
							local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0, entenmies.Position, Vector(0,0), nil):ToTear()
							tear.Height = -150
						end
					end
				end
				--debug 2
				if sprite:IsOverlayPlaying("Overlay_2") then
					--print("2222222222222222")
					for i, grid in pairs(InutilLib.GetRoomGrids()) do
						--print(grid)
						if math.random(1,3) == 3 and grid and not grid.State == 2 then
							if grid:GetType() == 2 or grid:GetType() == 14 then
								local item = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, 0, ILIB.game:GetRoom():FindFreePickupSpawnPosition(grid.Position, 1), Vector(0,0), nil) --body effect
								grid:Destroy()
							end
						end
					end
				end
				--debug 3
				if sprite:IsOverlayPlaying("Overlay_3") then
					if math.random(1,3) == 3 then
						data.Player:AddHearts(data.Player:GetMaxHearts())
					else
						for i = 1, math.random(3,6) do
							local h = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, RebekahMirrorHeartDrop[1], room:FindFreePickupSpawnPosition(eff.Position, 1), Vector(0,0), nil) --body effect
						end
					end
				end
				--debug 4
				if sprite:IsOverlayPlaying("Overlay_4") then
					--set opened damage buff
					yandereWaifu.GetEntityData(data.Player).BrokenBuff = true
					data.Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE);
					data.Player:EvaluateItems()
				end
				--debug 5
				if sprite:IsOverlayPlaying("Overlay_5") then
					if math.random(1,5) == 5 then
						data.Player:UseCard(Card.CARD_EMERGENCY_CONTACT, 0)
					else
						data.Player:UseActiveItem(CollectibleType.COLLECTIBLE_DADS_KEY, true, false, false, false, -1)
					--data.Player:UseActiveItem(CollectibleType.COLLECTIBLE_DADS_KEY, 0, -1)
					end
				end
				--debug 6
				if sprite:IsOverlayPlaying("Overlay_6") then
					--data.Player:UseActiveItem(CollectibleType.COLLECTIBLE_MEGA_MUSH, true, false, false, false, -1)
					for i = 1, 16 do
						data.Player:AddWisp(-1, data.Player.Position, false, false)
					end
				end
				--debug 7
				if sprite:IsOverlayPlaying("Overlay_7") then
					Isaac.ExecuteCommand("debug 7")
					data.debug7 = true
					for i = 1, 2 do
						data.Player:UseCard(Card.CARD_TOWER, 0)
					end
				end
				--debug 8
				if sprite:IsOverlayPlaying("Overlay_8") then
					local rng = math.random(1,10)
					--data.Player:UseActiveItem(CollectibleType.COLLECTIBLE_MEGA_MUSH, true, false, false, false, -1)
					if rng == 5 then
						for i = 1, 2 do
							if i == 1 and data.Player:GetActiveItem(ActiveSlot.SLOT_PRIMARY) ~= 0 then
								InutilLib.RefundActiveCharge(data.Player, 0, false)
							elseif data.Player:GetActiveItem(ActiveSlot.SLOT_POCKET) ~= 0 then
								InutilLib.RefundActiveCharge(data.Player, 0, true)
							end
						end
					elseif rng == 10 then
						for i = 1, math.random(2,4) do
							local item = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_LIL_BATTERY, math.random(1,3), room:FindFreePickupSpawnPosition(eff.Position, 1), Vector(0,0), nil) --body effect
						end
					else
						for i = 1, 2 do
							if i == 1 and data.Player:GetActiveItem(ActiveSlot.SLOT_PRIMARY) ~= 0 then
								InutilLib.RefundActiveCharge(data.Player, 0, false)
								data.Player:SetActiveCharge(math.floor(InutilLib.config:GetCollectible(data.Player:GetActiveItem(ActiveSlot.SLOT_PRIMARY)).MaxCharges/2), ActiveSlot.SLOT_PRIMARY)
							elseif data.Player:GetActiveItem(ActiveSlot.SLOT_POCKET) ~= 0 then
								InutilLib.RefundActiveCharge(data.Player, 0, true)
								data.Player:SetActiveCharge(math.floor(InutilLib.config:GetCollectible(data.Player:GetActiveItem(ActiveSlot.SLOT_POCKET)).MaxCharges/2), ActiveSlot.SLOT_POCKET)
							end
						end
					end
				end
				--debug 9
				if sprite:IsOverlayPlaying("Overlay_9") then
					yandereWaifu.GetEntityData(data.Player).BrokenLuck = true
					data.Player:AddCacheFlags(CacheFlag.CACHE_LUCK);
					data.Player:EvaluateItems()
				end
				--debug 10
				if sprite:IsOverlayPlaying("Overlay_10") then
					for i, entenmies in pairs(Isaac.GetRoomEntities()) do --affect others
						if entenmies:IsEnemy() and entenmies:IsVulnerableEnemy() then
							entenmies.HitPoints = entenmies.HitPoints - entenmies.MaxHitPoints/10
							entenmies:TakeDamage(data.Player.Damage/10, 0, EntityRef(eff), 4)
						end
					end
				end
				--debug 11
				if sprite:IsOverlayPlaying("Overlay_11") then
					data.Player:UseActiveItem(CollectibleType.COLLECTIBLE_PAUSE, true, false, false, false, -1)
				end
				--debug 12
				if sprite:IsOverlayPlaying("Overlay_12") then
					local rng = math.random(1,10)
					if rng == 5 then
						local item = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, -1, room:FindFreePickupSpawnPosition(eff.Position, 1), Vector(0,0), nil) --body effect
					elseif rng == 6 then
						for i = 1, 13 do
							local item = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, 0, room:FindFreePickupSpawnPosition(eff.Position, 1), Vector(0,0), nil) --body effect
						end
					elseif rng == 7 then
						for i = 1, 5 do
							local item = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, 0, room:FindFreePickupSpawnPosition(eff.Position, 1), Vector(0,0), nil) --body effect
						end
					elseif rng == 8 then
						for i = 1, 5 do
							local item = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_CHEST, 0, room:FindFreePickupSpawnPosition(eff.Position, 1), Vector(0,0), nil) --body effect
						end
					elseif rng == 9 then
						for i = 1, 8 do
							if math.random(1,2) == 2 then
								local item = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_GRAB_BAG, 0, room:FindFreePickupSpawnPosition(eff.Position, 1), Vector(0,0), nil) --body effect
							else
								local item = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_PILL, 0, room:FindFreePickupSpawnPosition(eff.Position, 1), Vector(0,0), nil) --body effect
							end
						end
					elseif rng == 10 then
						for i = 1, 12 do
							local rng2 = math.random(1,5)
							if rng2 == 1 then
								local item = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_GRAB_BAG, 0, room:FindFreePickupSpawnPosition(eff.Position, 1), Vector(0,0), nil) --body effect
							elseif rng2 == 2 then
								local item = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMBCHEST, 0, room:FindFreePickupSpawnPosition(eff.Position, 1), Vector(0,0), nil) --body effect
							elseif rng2 == 2 then
								local item = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_ETERNALCHEST, 0, room:FindFreePickupSpawnPosition(eff.Position, 1), Vector(0,0), nil) --body effect
							end
							local item = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, 0, room:FindFreePickupSpawnPosition(eff.Position, 1), Vector(0,0), nil) --body effect
							if math.random(1,5) == 5 then
								local item = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, 0, room:FindFreePickupSpawnPosition(eff.Position, 1), Vector(0,0), nil) --body effect
							end
							if math.random(1,10) == 10 then
								local item = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_THROWABLEBOMB, 0, room:FindFreePickupSpawnPosition(eff.Position, 1), Vector(0,0), nil) --body effect
							end
						end
					else
						for i = 1, 12 do
							local rng = math.random(1,3)
							if rng == 1 then
								local item = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, 0, room:FindFreePickupSpawnPosition(eff.Position, 1), Vector(0,0), nil) --body effect
							elseif rng == 2 then
								local item = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_KEY, 0, room:FindFreePickupSpawnPosition(eff.Position, 1), Vector(0,0), nil) --body effect
							elseif rng == 2 then
								local item = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, 0, room:FindFreePickupSpawnPosition(eff.Position, 1), Vector(0,0), nil) --body effect
							end
						end
					end
				end
				--debug 13
				if sprite:IsOverlayPlaying("Overlay_13") then
					yandereWaifu.GetEntityData(data.Player).IsParryInvul = false
					data.Player:TakeDamage( 5, 0, EntityRef(data.Player), 0);
				end
				sprite:Play("Success",true)
			end
		end
		if sprite:IsFinished("Fail") or sprite:IsFinished("Parry") or sprite:IsFinished("Success") then
			eff:Remove()
			yandereWaifu.GetEntityData(data.Player).IsParryInvul = false
			
			local customBody = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_EXTRACHARANIMHELPER, 0, data.Player.Position, Vector(0,0), nil) --body effect
			yandereWaifu.GetEntityData(customBody).Player = data.Player
			yandereWaifu.GetEntityData(customBody).DontFollowPlayer = true
			yandereWaifu.GetEntityData(customBody).DashBrokenFragment = true
		end
	elseif data.LabanHelper then
		--print(#data.LabanTargets)
		--print(TableLength(data.LabanTargets))
		if not data.Init then 
			data.Init = true
			local trail = InutilLib.SpawnTrail(eff, Color(1,1,1,1))
		end
		if not data.CurrentTarget then
			for i, t in pairs(data.LabanTargets) do
				--print(t)
				data.CurrentTarget = t
				break
			end
			if #data.LabanTargets <= 0 then
				eff:Remove()
			end
		else
			for i, entities in pairs(Isaac.GetRoomEntities()) do
				if entities:IsEnemy() and entities:IsVulnerableEnemy() and not entities:IsDead() then
					if entities.Position:Distance(eff.Position) < eff.Size + entities.Size + 45 then
						entities:TakeDamage(data.Damage, 0, EntityRef(eff), 1)
					end
				end
			end
			if not yandereWaifu.GetEntityData(data.CurrentTarget).LabanTouched then
				InutilLib.MoveDirectlyTowardsTarget(eff, data.CurrentTarget, 50, 0.9)
				if (data.CurrentTarget.Position - eff.Position):Length() <= 50 then
					yandereWaifu.GetEntityData(e).IsTargetedByLaban = nil
					entities:TakeDamage(data.Damage*2, 0, EntityRef(eff), 1)
				end
			end
		end
	elseif data.BoneJumpOffFromJockey then
		--eff.Position = data.Player.Position
		--eff.Velocity = data.Player.Velocity
			
		if eff.FrameCount == 1 then --beginning
			sprite:Load("gfx/effects/bone/slamdownsp.anm2",true)
			data.Player.Visible = false
			sprite:Play("JumpUp",true)
		end
		
		if sprite:IsFinished("JumpUp") then
			eff:Remove()
			local target = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_BONETARGET, 0, eff.Position, Vector(0,0), eff)
			yandereWaifu.GetEntityData(target).Player = data.Player
			yandereWaifu.GetEntityData(target).FinishedLeech = true
		end
	elseif data.BoneJumpDownFromJockey then
		--eff.Position = data.Player.Position
		--eff.Velocity = data.Player.Velocity
			
		if eff.FrameCount == 1 then --beginning
			sprite:Load("gfx/effects/bone/slamdownsp.anm2",true)
			
			sprite:Play("BoneDown0",true)
		end
		
		if sprite:IsFinished("BoneDown0") then
			eff:Remove()

			local player = data.Player
			
			player.Visible = true
			yandereWaifu.GetEntityData(player).IsAttackActive = false
			yandereWaifu.RebekahCanShoot(player, true)
			--player.GridCollisionClass = yandereWaifu.GetEntityData(player).LastGridCollisionClass
			--player.EntityCollisionClass = yandereWaifu.GetEntityData(player).LastEntityCollisionClass
			--yandereWaifu.GetEntityData(player).LastGridCollisionClass = nil
			--yandereWaifu.GetEntityData(player).LastEntityCollisionClass = nil
			
			yandereWaifu.GetEntityData(player).IsLeftover = false
			yandereWaifu.GetEntityData(player).NoBoneSlamActive = true
			player.Position = eff.Position
			
			ILIB.game:ShakeScreen(5)
			--crackwaves
			for i = 0, 360-360/4, 360/4 do
				local crack = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACKWAVE, 0, player.Position, Vector.FromAngle(i), player):ToEffect()
				crack.LifeSpan = 9;
				crack:SetDamageSource (EntityType.ENTITY_PLAYER);
				crack.Rotation = i
			end
		end
	end
end, RebekahCurse.ENTITY_EXTRACHARANIMHELPER)

--custom animation actions and other gimmicks that I can't name in one word lol
yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, function(_, eff)
	local sprite = eff:GetSprite();
	local data = yandereWaifu.GetEntityData(eff);
	local player = data.Player
	
	if data.DashEffect then
		local BOff = yandereWaifu.GetEntityData(player).countdownFrames
		local customColor = Color(1, 1, 1, 1, BOff, BOff, BOff)
		local sprite = player:GetSprite()
		--sprite:Render(Isaac.WorldToScreen(eff.Position), Vector(0,0), Vector(0,0))
		player.Visible = true
		player:RenderGlow(Isaac.WorldToScreen(eff.Position))
		player:RenderBody(Isaac.WorldToScreen(eff.Position))
		player:RenderHead(Isaac.WorldToScreen(eff.Position))
		player:RenderTop(Isaac.WorldToScreen(eff.Position))
		player:SetColor(customColor, 1, 1, true, true)
		--sprite.FlipX = true
		if yandereWaifu.GetEntityData(player).countdownFrames >= 7 then
			eff:Remove()
		end
	elseif data.DashBrokenGlitch then
		local text = yandereWaifu.GetEntityData(player).tankAmount
		Isaac.RenderText(tostring(text),Isaac.WorldToScreen(eff.Position).X, Isaac.WorldToScreen(eff.Position).Y-15, 1 ,1 ,1 ,1 )
	end
end, RebekahCurse.ENTITY_EXTRACHARANIMHELPER)
