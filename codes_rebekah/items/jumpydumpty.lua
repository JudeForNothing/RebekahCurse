function yandereWaifu:useJumpydumpty(collItem, rng, player, flags, slot)
	local data = yandereWaifu.GetEntityData(player)
	if data.lastActiveUsedFrameCount then
		if InutilLib.game:GetFrameCount() == data.lastActiveUsedFrameCount then
			return
		end
						
		data.lastActiveUsedFrameCount = InutilLib.game:GetFrameCount()
	else
		data.lastActiveUsedFrameCount = InutilLib.game:GetFrameCount()
	end

	InutilLib.ToggleShowActive(player, false)
	return {
		Discharge = false
	}
end

yandereWaifu:AddCallback( ModCallbacks.MC_USE_ITEM, yandereWaifu.useJumpydumpty, RebekahCurse.Items.COLLECTIBLE_JUMPYDUMPTY )

yandereWaifu:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_,player)
	--local player = Isaac.GetPlayer(0);
    local room = Game():GetRoom();
	local data = yandereWaifu.GetEntityData(player)
	--typical rom-command
	if player:HasCollectible(RebekahCurse.Items.COLLECTIBLE_JUMPYDUMPTY) then
		if InutilLib.ConfirmUseActive( player, RebekahCurse.Items.COLLECTIBLE_JUMPYDUMPTY ) then
			local vector = InutilLib.DirToVec(player:GetFireDirection())
				--data.specialAttackVector = Vector( vector.X, vector.Y )
				local bomb = player:FireBomb( player.Position, vector:Resized(7))
				yandereWaifu.GetEntityData(bomb).IsLarge = true
				yandereWaifu.GetEntityData(bomb).IsJumpyDumptyBombs = true
				yandereWaifu.GetEntityData(bomb).Player = player
				bomb.ExplosionDamage = player.Damage*3
				InutilLib.MakeBombLob(bomb, 1, 15, 3 )
				bomb:SetExplosionCountdown(90)

				if player:HasCollectible(CollectibleType.COLLECTIBLE_CAR_BATTERY) then
					InutilLib.SetTimer( 15, function()
						local bomb = player:FireBomb( player.Position, vector:Resized(7))
						yandereWaifu.GetEntityData(bomb).IsLarge = true
						yandereWaifu.GetEntityData(bomb).IsJumpyDumptyBombs = true
						yandereWaifu.GetEntityData(bomb).Player = player
						bomb.ExplosionDamage = player.Damage*6
						InutilLib.MakeBombLob(bomb, 1, 17, 3 )
						bomb:SetExplosionCountdown(55)
					end)
				end
				InutilLib.ConsumeActiveCharge(player)
				InutilLib.ToggleShowActive(player, false)
				if not player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES) then return end
				player:AddWisp(RebekahCurse.Items.COLLECTIBLE_DOORSTOPPER, player.Position, false, false)
		end
	end
end)

yandereWaifu:AddCallback(ModCallbacks.MC_PRE_BOMB_COLLISION, function(_,  bb, collider, bool)
    local data = yandereWaifu.GetEntityData(bb)
    if data.IsJumpyDumptyBombs --[[and data.IsSmall]] then
		if collider:IsEnemy() then
            if not data.hasbeentouchcc then
                 bb:SetExplosionCountdown(1)
                 data.hasbeentouchcc = true
            end
        end
    end
end);


yandereWaifu:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, function(_, bb)
	local data = yandereWaifu.GetEntityData(bb)
	if  data.IsJumpyDumptyBombs and not data.IsSmall then
		local player = data.Player
		for i = 0, math.random(6,8) do
			local bomb = player:FireBomb( bb.Position, Vector.FromAngle(math.random(1,360)):Resized(3))
			yandereWaifu.GetEntityData(bomb).IsSmall = true
			yandereWaifu.GetEntityData(bomb).IsJumpyDumptyBombs = true
			yandereWaifu.GetEntityData(bomb).Player = player
			bomb.ExplosionDamage = player.Damage*2
			InutilLib.MakeBombLob(bomb, 1, math.random(10,15) )
			--bomb.Visible = false
			bomb.SubType = 1
		end
	end
end, EntityType.ENTITY_BOMB)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE, function(_, bb)
	if yandereWaifu.GetEntityData(bb).IsJumpyDumptyBombs or bb.Variant == 3781 then
		local sprite = bb:GetSprite();
			
			if bb.FrameCount == 1 then
				bb.Visible = true
				bb.Variant = 3781
				if yandereWaifu.GetEntityData(bb).IsSmall or bb.SubType == 1 then
					bb:GetSprite():Load("gfx/items/pick ups/bombs/bomb0_dumpty.anm2", true)
					--bb.SpriteScale =  Vector(0.5,0.5)
					--bb.SizeMulti = Vector(0.9,0.9)
					bb:SetExplosionCountdown(math.random(295,305))
				elseif  yandereWaifu.GetEntityData(bb).IsLarge then
					bb:GetSprite():Load("gfx/items/pick ups/bombs/bomb3_dumpty.anm2", true)
					--bb.SpriteScale =  Vector(1.5,1.5)
					bb.SizeMulti = Vector(1.5,1.5)
				else
					bb:GetSprite():Load("gfx/items/pick ups/bombs/bomb2_dumpty.anm2", true)
				end
				bb:GetSprite():Play("Pulse")
				bb:GetSprite():LoadGraphics();
			end

	end
end)