function yandereWaifu:useNotebookOfDead(collItem, rng, player, flags, slot)
	local data = yandereWaifu.GetEntityData(player)
	if data.lastActiveUsedFrameCount then
		if ILIB.game:GetFrameCount() == data.lastActiveUsedFrameCount then
			return
		end
						
		data.lastActiveUsedFrameCount = ILIB.game:GetFrameCount()
	else
		data.lastActiveUsedFrameCount = ILIB.game:GetFrameCount()
	end
	InutilLib.SFX:Play(RebekahCurseSounds.SOUND_SCRIBBLING, 1, 0, false, 1.5)
	InutilLib.ToggleShowActive(player, true)
end

yandereWaifu:AddCallback( ModCallbacks.MC_USE_ITEM, yandereWaifu.useNotebookOfDead, RebekahCurseItems.COLLECTIBLE_NOTEBOOKOFTHEDEAD )

yandereWaifu:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_,player)
	--local player = Isaac.GetPlayer(0);
    local room = Game():GetRoom();
	local data = yandereWaifu.GetEntityData(player)
	--typical rom-command
	if player:HasCollectible(RebekahCurseItems.COLLECTIBLE_NOTEBOOKOFTHEDEAD) then
		if InutilLib.ConfirmUseActive( player, RebekahCurseItems.COLLECTIBLE_NOTEBOOKOFTHEDEAD ) then
			local vector = InutilLib.DirToVec(player:GetFireDirection())
			--data.specialAttackVector = Vector( vector.X, vector.Y )
			local mob = Isaac.Spawn( EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_DEATHNOTETARGET, 0, player.Position, vector:Resized(7), player );
			InutilLib.ConsumeActiveCharge(player)
			InutilLib.ToggleShowActive(player, false)
			yandereWaifu.GetEntityData(mob).Parent= player
		end
	end
end)



yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local sprite = eff:GetSprite()
	local data = yandereWaifu.GetEntityData(eff)
	local player = data.Parent
	
	local movementDirection = player:GetShootingInput();
	local roomClampSize = math.max( 5, 20 )
	local isClamping = false
	local function ClampToL()
		local target = data.target
		local highestHP = 0 -- labels the highest enemy hp
		if target then
			eff.Position = target.Position
			eff.Velocity = target.Velocity
			isClamping = true
		else data.target = InutilLib.GetStrongestEnemy(eff, 40)
		end
	end
	
	if movementDirection:Length() < 0.05 then
		eff.Velocity = Vector.Zero
		ClampToL()
	else
		eff.Position = ILIB.room:GetClampedPosition(eff.Position, roomClampSize);
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
		sprite:Play("Idle", false)
	end
	if isClamping then
		if not data.ClampCount then data.ClampCount = 0 end
		sprite:Play("Blink",false)
		if data.ClampCount > 30 then
			if data.target:IsBoss() then
				yandereWaifu.GetEntityData(data.target).HeartAttack = true
				yandereWaifu.GetEntityData(data.target).player = player
			else
				player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_BRIMSTONE, false, 1)
				local laser = player:FireTechXLaser(data.target.Position, Vector.Zero, 15, player, 1):ToLaser()
				laser.Timeout = 90
				yandereWaifu.GetEntityData(laser).IsDark = 1
				player:GetEffects():RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_BRIMSTONE, false, 1)
				data.target:Kill()
				ILIB.game:ShakeScreen(10)
			end
			--Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_ORBITALNUKE, 0, eff.Position, Vector.FromAngle(1*math.random(1,360))*(math.random(2,4)), player) --heart effect
			eff:Remove()
		end
		data.ClampCount = data.ClampCount + 1
		
	else
		sprite:Play("Idle", false)
		data.ClampCount = 0
	end
	--[[if eff.FrameCount < 55 then
		--player.Velocity = Vector(0,0)
		InutilLib.SFX:Play(RebekahCurseSounds.SOUND_REDCHARGELIGHT, 1, 0, false, data.SoundFrame)
		data.SoundFrame = data.SoundFrame - 0.01
	end]]
end, RebekahCurse.ENTITY_DEATHNOTETARGET)



yandereWaifu:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, ent)
	local data = yandereWaifu.GetEntityData(ent)
	if data.HeartAttack and ent.FrameCount % 3 == 0 then
		ent:TakeDamage( 1, 0, EntityRef(player), 0);
		if ent.HitPoints <= 1 and not ( ent.Type == 912 and ent.SubType == 1 ) then
			data.player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_BRIMSTONE, false, 1)
			local laser = data.player:FireTechXLaser(ent.Position, Vector.Zero, 15, data.player, 1):ToLaser()
			laser.Timeout = 90
			yandereWaifu.GetEntityData(laser).IsDark = 1
			data.player:GetEffects():RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_BRIMSTONE, false, 1)
			ILIB.game:ShakeScreen(10)
		end
	end
end)
