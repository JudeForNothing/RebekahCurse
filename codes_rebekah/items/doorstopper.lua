function yandereWaifu:useBookstopper(collItem, rng, player, flags, slot)
	local data = yandereWaifu.GetEntityData(player)
	if data.lastActiveUsedFrameCount then
		if ILIB.game:GetFrameCount() == data.lastActiveUsedFrameCount then
			return
		end
						
		data.lastActiveUsedFrameCount = ILIB.game:GetFrameCount()
	else
		data.lastActiveUsedFrameCount = ILIB.game:GetFrameCount()
	end

	InutilLib.ToggleShowActive(player, false)
	return {
		Discharge = false
	}
end

yandereWaifu:AddCallback( ModCallbacks.MC_USE_ITEM, yandereWaifu.useBookstopper, RebekahCurseItems.COLLECTIBLE_DOORSTOPPER )
--[[
function yandereWaifu:useBookstopperBookBelial(collItem, rng, player, flags, slot)
	local data = yandereWaifu.GetEntityData(player)
	print("bookasd")
	--return false
	return {
		Discharge = false, 
		ShowAnim = true
	}
end

yandereWaifu:AddCallback( ModCallbacks.MC_USE_ITEM, yandereWaifu.useBookstopperBookBelial, CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL )
]]
yandereWaifu:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_,player)
	--local player = Isaac.GetPlayer(0);
    local room = Game():GetRoom();
	local data = yandereWaifu.GetEntityData(player)
	--typical rom-command
	if player:HasCollectible(RebekahCurseItems.COLLECTIBLE_DOORSTOPPER) then
		if player:GetName() == "Judas" and player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) then
			if InutilLib.ConfirmUseActive( player, RebekahCurseItems.COLLECTIBLE_DOORSTOPPER ) then
				local vector = InutilLib.DirToVec(player:GetFireDirection())
				--data.specialAttackVector = Vector( vector.X, vector.Y )
				local mob = Isaac.Spawn( EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_DOORSTOPPER, 0, player.Position, vector:Resized(7), player );
				if player:HasCollectible(CollectibleType.COLLECTIBLE_CAR_BATTERY) then
					InutilLib.SetTimer( 15, function()
						local mob2 = Isaac.Spawn( EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_DOORSTOPPER, 0, player.Position, vector:Resized(10), player );
						yandereWaifu.GetEntityData(mob2).DontCharge = true
						mob2:GetSprite():ReplaceSpritesheet(0, "gfx/effects/items/doorstopper_extra.png")
						mob2:GetSprite():LoadGraphics()
						yandereWaifu.GetEntityData(mob2).Player = player
						mob2:GetSprite():Play("Thrown", true)
						yandereWaifu.GetEntityData(mob2).Brother = mob
					end)
				end
				InutilLib.ConsumeActiveCharge(player)
				InutilLib.ToggleShowActive(player, false)
				yandereWaifu.GetEntityData(mob).Player = player
				mob:GetSprite():Play("Thrown", true)
				yandereWaifu.GetEntityData(mob).DontCharge = true
				yandereWaifu.GetEntityData(mob).IsBelial = true
				mob:GetSprite():ReplaceSpritesheet(0, "gfx/effects/items/doorstopper_belial.png")
				player:UseActiveItem(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL, 0, -1)
				mob:GetSprite():LoadGraphics()
				if not player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES) then return end
				player:AddWisp(RebekahCurseItems.COLLECTIBLE_DOORSTOPPER, player.Position, false, false)
			end
		else
			if InutilLib.ConfirmUseActive( player, RebekahCurseItems.COLLECTIBLE_DOORSTOPPER ) then
				local vector = InutilLib.DirToVec(player:GetFireDirection())
				--data.specialAttackVector = Vector( vector.X, vector.Y )
				local mob = Isaac.Spawn( EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_DOORSTOPPER, 0, player.Position, vector:Resized(7), player );
				if player:HasCollectible(CollectibleType.COLLECTIBLE_CAR_BATTERY) then
					InutilLib.SetTimer( 15, function()
						local mob2 = Isaac.Spawn( EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_DOORSTOPPER, 0, player.Position, vector:Resized(10), player );
						yandereWaifu.GetEntityData(mob2).DontCharge = true
						mob2:GetSprite():ReplaceSpritesheet(0, "gfx/effects/items/doorstopper_extra.png")
						mob2:GetSprite():LoadGraphics()
						yandereWaifu.GetEntityData(mob2).Player = player
						mob2:GetSprite():Play("Thrown", true)
						yandereWaifu.GetEntityData(mob2).Brother = mob
					end)
				end
				InutilLib.ConsumeActiveCharge(player)
				InutilLib.ToggleShowActive(player, false)
				yandereWaifu.GetEntityData(mob).Player = player
				mob:GetSprite():Play("Thrown", true)
				if not player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES) then return end
				player:AddWisp(RebekahCurseItems.COLLECTIBLE_DOORSTOPPER, player.Position, false, false)
			end
		end
	end
end)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local sprite = eff:GetSprite()
	local data = yandereWaifu.GetEntityData(eff)
	local player = data.Player
	eff.GridCollisionClass =  EntityGridCollisionClass.GRIDCOLL_NOPITS 
	
	local room =  Game():GetRoom()
	
	--function code
	if sprite:IsFinished("Thrown") then
		sprite:Play("Idle")
	end 
	
	local function Pickup()
		for i=0, ILIB.game:GetNumPlayers()-1 do
			local pl = Isaac.GetPlayer(i)
			if GetPtrHash(pl) == GetPtrHash(player) then
				if pl.Position:Distance(eff.Position) <= 40 then 
					if pl:GetActiveItem(ActiveSlot.SLOT_PRIMARY) == RebekahCurseItems.COLLECTIBLE_DOORSTOPPER then
						eff:Remove()
						if not data.DontCharge then
							pl:FullCharge(ActiveSlot.SLOT_PRIMARY, true)
						end
					end
				end
			end
		end
		for i, ent in pairs (Isaac.GetRoomEntities()) do
			if ent.Position:Distance(eff.Position) <= 20 and ent.Type ~= EntityType.ENTITY_PLAYER and ent.Type ~= EntityType.ENTITY_EFFECT and ent.Type ~= EntityType.ENTITY_TEAR then
				local vec = ent.Position-eff.Position
				ent.Velocity = vec:Resized(10)
				if ent.Type == EntityType.ENTITY_PROJECTILE then
					ent:Die()
				end
			end
		end
	end
	
	if sprite:IsPlaying("Idle") then
		Pickup()
	end
	
	if sprite:IsPlaying("Thrown") then
		if sprite:IsEventTriggered("Floor") then
			local mob = Isaac.Spawn( EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 2, eff.Position, Vector(0,0), player );
			InutilLib.SFX:Play( SoundEffect.SOUND_FORESTBOSS_STOMPS, 1, 0, false, 1);
			ILIB.game:ShakeScreen(5)
			eff.Velocity = Vector.Zero
			for i, ent in pairs (Isaac.GetRoomEntities()) do
				if (ent:IsEnemy() and ent:IsVulnerableEnemy()) or ent.Type == EntityType.ENTITY_FIREPLACE and not ent:IsDead() then
					if ent.Position:Distance(eff.Position) <= 80 or (ent.Position:Distance(eff.Position) <= 260 and data.IsBelial) then
						if data.IsBelial then
							ent:TakeDamage(15, 0, EntityRef(eff), 1)
						else
							ent:TakeDamage(7.5, 0, EntityRef(eff), 1)
						end
					end
				end
				if ent.Position:Distance(eff.Position) <= 120 and ent.Type ~= EntityType.ENTITY_PLAYER and ent.Type ~= EntityType.ENTITY_EFFECT then
					InutilLib.DoKnockbackTypeI(eff, ent, 0.35)
				end
			end
			--destroy grids
			for i = 1, 8 do --code that checks each eight directions
				--local checkingVector = (room:GetGridEntity(room:GetGridIndex(fam.Position + data.savedVelocity*4)))
				local gridStomped = room:GetGridEntity(room:GetGridIndex(eff.Position + Vector(45,0):Rotated(45*(i-1)))) --grids around that Rebecca stepped on
				--if gridStomped:GetType() == GridEntityType.GRID_TNT or gridStomped:GetType() == GridEntityType.GRID_ROCK then
				--print( gridStomped:GetType())
				if gridStomped ~= nil then
					gridStomped:Destroy()
				end
				if i == 8 then 
					local gridStomped = room:GetGridEntity(room:GetGridIndex(eff.Position)) --top grid
					if gridStomped ~= nil then
						gridStomped:Destroy()
					end
				end
			end
		elseif sprite:WasEventTriggered("Floor") then
			Pickup()
		else
			if eff.FrameCount % 3 == 0 then
				for i, ent in pairs (Isaac.GetRoomEntities()) do
					if (ent:IsEnemy() and ent:IsVulnerableEnemy()) or ent.Type == EntityType.ENTITY_FIREPLACE and not ent:IsDead() then
						if ent.Position:Distance(eff.Position) <= 50 then
							ent:TakeDamage(3.5, 0, EntityRef(eff), 1)
						end
					end
				end
			end
		end
	end
	if data.Brother then --this is for the other book spawned with car battery
		if data.Brother:IsDead() then
			eff:Remove()
		end
	end
end, RebekahCurse.ENTITY_DOORSTOPPER)

