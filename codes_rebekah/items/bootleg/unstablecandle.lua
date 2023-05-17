function yandereWaifu:useUnstableCandle(collItem, rng, player, flags, slot)
	local data = yandereWaifu.GetEntityData(player)
	if data.lastActiveUsedFrameCount then
		if InutilLib.game:GetFrameCount() == data.lastActiveUsedFrameCount then
			return
		end
						
		data.lastActiveUsedFrameCount = InutilLib.game:GetFrameCount()
	else
		data.lastActiveUsedFrameCount = InutilLib.game:GetFrameCount()
	end

	if rng:RandomFloat() < 0.20 then
		InutilLib.SFX:Play(RebekahCurse.Sounds.SOUND_SCRIBBLING, 1, 0, false, 1.5)
		InutilLib.ToggleShowActive(player, true)
	else
		if flags & UseFlag.USE_NOANIM == 0 then
			player:AnimateCollectible(RebekahCurse.Items.COLLECTIBLE_UNSTABLECANDLE, "UseItem", "PlayerPickupSparkle")
		end
	end
end

yandereWaifu:AddCallback( ModCallbacks.MC_USE_ITEM, yandereWaifu.useUnstableCandle, RebekahCurse.Items.COLLECTIBLE_UNSTABLECANDLE )

yandereWaifu:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_,player)
	--local player = Isaac.GetPlayer(0);
    local room = Game():GetRoom();
	local data = yandereWaifu.GetEntityData(player)
	--typical rom-command
	if player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_UNSTABLECANDLE) then
		if InutilLib.ConfirmUseActive( player, RebekahCurse.Items.COLLECTIBLE_UNSTABLECANDLE ) then
			for i = 0, math.random(40,50) do
				InutilLib.SetTimer(i*7, function()
					local vector = player:GetShootingInput() --InutilLib.DirToVec(player:GetFireDirection())
					--data.specialAttackVector = Vector( vector.X, vector.Y )
					--[[local fire = Isaac.Spawn( EntityType.ENTITY_EFFECT, 51, 0, player.Position, vector:Resized(12), player ):ToEffect();
					fire.Timeout = 60]]
					data.UnstableCandleFireVec = vector
					if data.UnstableCandleFireVec then
						local tear = player:FireTear(player.Position, (data.UnstableCandleFireVec):Resized(9):Rotated(math.random(-15,15)), false, false, false):ToTear()
						tear:ChangeVariant(TearVariant.FIRE) --ENTITY_ETERNALFEATHER)
						tear:AddTearFlags(TearFlags.TEAR_PIERCING)
						tear.CollisionDamage = player.Damage
						yandereWaifu.GetEntityData(tear).EternalFlame = true
						InutilLib.game:ShakeScreen(10)
					end
				end)
			end
			InutilLib.ConsumeActiveCharge(player)
			InutilLib.ToggleShowActive(player, false)
		end
	end
end)

