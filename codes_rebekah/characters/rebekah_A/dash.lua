local dash = {}

--double tap local dash function
function dash.RebekahDoubleTapDash(vector, playerTapping)
	print(#StageAPI.TransitionNightmares)
	for p = 0, InutilLib.game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		--print(GetPtrHash( playerTapping), "     vector!", GetPtrHash( player))
		if GetPtrHash( playerTapping ) == GetPtrHash( player) then
			local psprite = player:GetSprite()
			local playerdata = yandereWaifu.GetEntityData(player);
			local trinketBonus = 0
			if player:HasTrinket(RebekahCurseTrinkets.TRINKET_ISAACSLOCKS) then
				trinketBonus = 5
			end
			--print(playerdata.IsDashActive , playerdata.IsAttackActive , playerdata.NoBoneSlamActive)
			--checks if you can dash without interrupting something
			local isFree = not (psprite:IsPlaying("Trapdoor") or psprite:IsPlaying("Jump") or psprite:IsPlaying("HoleIn") or psprite:IsPlaying("HoleDeath") or psprite:IsPlaying("JumpOut") or
			psprite:IsPlaying("LightTravel") or psprite:IsPlaying("Appear") or psprite:IsPlaying("Death") 
			or psprite:IsPlaying("TeleportUp") or psprite:IsPlaying("TeleportDown")) and not (playerdata.IsUninteractible)
			and not playerdata.IsAttackActive and playerdata.specialCooldown <= 0 and not playerdata.IsParalysed and not DeadSeaScrollsMenu.IsOpen()
			
			if isFree then
				if yandereWaifu.GetEntityData(player).currentMode == REBECCA_MODE.RedHearts then --IF RED HEART MODE
					yandereWaifu.RedHeartDash(player, vector)
				elseif yandereWaifu.GetEntityData(player).currentMode == REBECCA_MODE.SoulHearts then --if blue
					yandereWaifu.SoulHeartTeleport(player, vector)
				elseif yandereWaifu.GetEntityData(player).currentMode == REBECCA_MODE.GoldHearts then --if yellow
					yandereWaifu.GoldHeartSlam(player, vector)
				elseif yandereWaifu.GetEntityData(player).currentMode == REBECCA_MODE.EvilHearts then --if black
					yandereWaifu.EvilHeartTeleport(player, vector)
					--yandereWaifu.EvilHeartDash(player, vector)
				elseif yandereWaifu.GetEntityData(player).currentMode == REBECCA_MODE.EternalHearts then --if eternalhearts
					yandereWaifu.EternalHeartDash(player, vector)
				elseif yandereWaifu.GetEntityData(player).currentMode == REBECCA_MODE.BoneHearts then --if bonehearts
					yandereWaifu.BoneHeartPunch(player, vector)
				elseif yandereWaifu.GetEntityData(player).currentMode == REBECCA_MODE.RottenHearts then
					yandereWaifu.RottenTossHead(player, vector)
				elseif yandereWaifu.GetEntityData(player).currentMode == REBECCA_MODE.BrideRedHearts then --if red 
					player.Velocity = player.Velocity + vector:Resized( REBEKAH_BALANCE.RED_HEARTS_DASH_SPEED );
					yandereWaifu.SpawnDashPoofParticle( player.Position, Vector(0,0), player, RebekahPoofParticleType.Red );
					yandereWaifu.SpawnHeartParticles( 3, 5, player.Position, player.Velocity:Rotated(180):Resized( player.Velocity:Length() * (math.random() * 0.5 + 0.5) ), player, RebekahHeartParticleType.Red );
					playerdata.specialCooldown = REBEKAH_BALANCE.RED_HEARTS_DASH_COOLDOWN - trinketBonus;
					playerdata.invincibleTime = REBEKAH_BALANCE.RED_HEARTS_DASH_INVINCIBILITY_FRAMES;
					InutilLib.SFX:Play( SoundEffect.SOUND_CHILD_HAPPY_ROAR_SHORT, 1, 0, false, 0.8 );
					
					playerdata.DashVector = vector;
					playerdata.IsDashActive = true;
				elseif yandereWaifu.GetEntityData(player).currentMode == REBECCA_MODE.BrokenHearts then
					yandereWaifu.BrokenRebekahDash(player, vector)
				elseif yandereWaifu.GetEntityData(player).currentMode == REBECCA_MODE.ImmortalHearts then
					
					--[[local mantle = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_ANGLEDHOLYMANTLE, 0, player.Position, vector:Resized(5), player):ToEffect() --body effect
					local velAng = math.floor(vector:GetAngleDegrees())
					mantle:GetSprite():Play("Front", true)
					if (velAng >= 180 - 15 and velAng <= 180 + 15) or (velAng >= -180 - 15 and  velAng <= -180 + 15) or (velAng >= 0 - 15 and  velAng <= 0 + 15) then
						mantle:GetSprite():Play("Side", true)
						if (velAng >= 0 - 15 and  velAng <= 0 + 15) then
							mantle.FlipX = true
						end
					end
					if (velAng >= 45 - 15 and  velAng <= 45 + 15) or (velAng >= -45 - 15 and  velAng <= -45 + 15) then
						mantle:GetSprite():Play("Side", true)
					end
					if (velAng >= -90 - 15 and  velAng <= -90 + 15) or (velAng >= -135 - 15 and  velAng <= -135 + 15) or (velAng >= -45 - 15 and  velAng <= -45 + 15) then
						mantle:GetSprite():Play("Back", true)
					end]]
					local effect=Isaac.Spawn(1000,188,0,player.Position,8.6*vector,player):ToEffect()
					effect.Rotation=vector:GetAngleDegrees()
					effect.Timeout=15
					effect:GetSprite():ReplaceSpritesheet(0, "gfx/effects/immortal/angled_mantle.png")
					effect:GetSprite():LoadGraphics()
					--InutilLib.speaker:Play(568,1.0)
					playerdata.specialCooldown = REBEKAH_BALANCE.IMMORTAL_HEARTS_DASH_COOLDOWN - trinketBonus;
				end
				playerdata.specialMaxCooldown = playerdata.specialCooldown --gain the max amount dash cooldown
				-- update the dash double tap cooldown based on Rebecca's mode specific cooldown
			end
			if playerdata.DASH_DOUBLE_TAP then
				playerdata.DASH_DOUBLE_TAP.cooldown = playerdata.specialCooldown;
			end
		end
	end
end

return dash