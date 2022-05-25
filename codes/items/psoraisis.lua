local function IsRealDamage(flags)
    --if flags & DamageFlag.DAMAGE_NO_PENALTIES > 0 then return false end
    if flags & DamageFlag.DAMAGE_RED_HEARTS > 0 then return false end
    if flags & DamageFlag.DAMAGE_DEVIL > 0 then return false end
    --if flags & DamageFlag.DAMAGE_CURSED_DOOR > 0 then return false end
    if flags & DamageFlag.DAMAGE_IV_BAG > 0 then return false end
    --if flags & DamageFlag.DAMAGE_CHEST > 0 then return false end
    if flags & DamageFlag.DAMAGE_FAKE > 0 then return false end
    return true
end

yandereWaifu:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_,player)
	--local player = Isaac.GetPlayer(0);
    local room = Game():GetRoom();
	local data = yandereWaifu.GetEntityData(player)
	if player:HasCollectible(RebekahCurse.COLLECTIBLE_PSORAISIS) then
	if InutilLib.HasJustPickedCollectible( player, RebekahCurse.COLLECTIBLE_PSORAISIS ) then
		player:AddNullCostume(RebekahCurseCostumes.Psoriasis)
	end
		if not data.PsoriasisHealth or (player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) and player:GetName() == "Magdalene" and data.MaxPsoriasisHealth < 8) then
			if player:GetName() == "Magdalene" then
				if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) then
					data.PsoriasisHealth = 8
					data.MaxPsoriasisHealth = 8
				else
					data.PsoriasisHealth = 6
					data.MaxPsoriasisHealth = 6
				end
			elseif player:GetName() == "Judas" then
				data.PsoriasisHealth = 2
				data.MaxPsoriasisHealth = 2
			else
				data.PsoriasisHealth = 4
				data.MaxPsoriasisHealth = 4
			end
			--data.PsoriasisFrameCount = 2
		else
			if math.floor(player.FrameCount % 150) == 0 and data.MaxPsoriasisHealth > data.PsoriasisHealth then
				data.PsoriasisHealth = data.PsoriasisHealth + 1
				--data.PsoriasisFrameCount = 2
			end
		end
	end
end)

yandereWaifu:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, damage, amount, damageFlag, damageSource, damageCountdownFrames) 
	local data = yandereWaifu.GetEntityData(damage)
	if damage.Type == 1 and damage:ToPlayer():HasCollectible(RebekahCurse.COLLECTIBLE_PSORAISIS) and IsRealDamage(damageFlag) then
		--if data.PsoriasisFrameCount > 0 then
		--	data.PsoriasisFrameCount = data.PsoriasisFrameCount - 1
		--end
		if data.PsoriasisHealth > 0 then
			--if data.PsoriasisFrameCount > 0 then
				data.PsoriasisHealth = data.PsoriasisHealth - 1
			--end
			return false
		end
		--data.PsoriasisFrameCount = 2
	end
end)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, function(_,  pl) --render stuff
	local data = yandereWaifu.GetEntityData(pl)
	if data.PsoriasisHealth and pl:HasCollectible(RebekahCurse.COLLECTIBLE_PSORAISIS) then
		local Sprite = Sprite()
		Sprite:Load("gfx/ui/ui_rebekah_hearts.anm2", true)
		for i = 0, data.MaxPsoriasisHealth/2 - 1 do
			local state = "SkinFull"
			pos = Isaac.WorldToScreen(pl.Position) + Vector(-(4*(data.MaxPsoriasisHealth/2))+ i*12, 5) --heart position
			local multipliedIndex = (i*2) + 1
			if multipliedIndex <= data.PsoriasisHealth and multipliedIndex+1 > data.PsoriasisHealth then
				state = "SkinHalf"
			elseif multipliedIndex > data.PsoriasisHealth and multipliedIndex+1 > data.PsoriasisHealth then
				state = "SkinEmpty"
			end
			
			Sprite:Play(state, true)
			Sprite:Render(pos, Vector.Zero, Vector.Zero)
		end
	end
end);


