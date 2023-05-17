local replacesong = false
yandereWaifu:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(_, new)
	if not new then
        replacesong = false
    end
end)

local function spawnBody(player, old)
	local data = yandereWaifu.GetEntityData(player)
	
	data.TickTockBody = Isaac.Spawn(EntityType.ENTITY_EFFECT, RebekahCurse.ENTITY_EXTRACHARANIMHELPER, 0, player.Position, Vector(0,0), player) --body effect
	yandereWaifu.GetEntityData(data.TickTockBody).Player = player
	data.TickTockBody:GetSprite():Load("gfx/characters/tick_tock_isaac.anm2", true)
	if not old then
		data.TickTockBody:GetSprite():Play("Transform")
		InutilLib.SFX:Play(SoundEffect.SOUND_THUMBSUP_AMPLIFIED, 1, 0, false, 1);
	else
		data.TickTockInit = true
	end
	player.Visible = false
end

function yandereWaifu:useGiddyUp(collItem, rng, player)
	local data = yandereWaifu.GetEntityData(player)

	if data.lastActiveUsedFrameCount then
		if InutilLib.game:GetFrameCount() == data.lastActiveUsedFrameCount then
			return
		end
						
		data.lastActiveUsedFrameCount = InutilLib.game:GetFrameCount()
	else
		data.lastActiveUsedFrameCount = InutilLib.game:GetFrameCount()
	end

	spawnBody(player)
	replacesong = true
	data.TickTockFrame = 600
	if player:HasCollectible(CollectibleType.COLLECTIBLE_CAR_BATTERY) then
		data.TickTockFrame = 1200
	end
end
yandereWaifu:AddCallback( ModCallbacks.MC_USE_ITEM, yandereWaifu.useGiddyUp, RebekahCurse.Items.COLLECTIBLE_GIDDYUP );

yandereWaifu:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_,player)
    local data = yandereWaifu.GetEntityData(player)
	if data.TickTockFrame then data.TickTockFrame = data.TickTockFrame - 1 end
	if data.TickTockFrame and data.TickTockFrame <= 0 then
		if data.TickTockBody and data.TickTockBody:IsDead() then
			spawnBody(player, true)
		end
		if data.TickTockBody:GetSprite():IsFinished("TransformBack") then
			data.TickTockInit = nil
			data.TickTockFrame = nil
			data.TickTockBody:Remove()
			data.TickTockBody = nil
			player.Visible = true
			replacesong = false
			if MMC then
				MusicManager():Play(MMC.GetMusicTrack(), 0.1)
				--MusicManager():Queue(RebekahCurse.Music.MUSIC_TICKTOCK)
				MusicManager():UpdateVolume()
			end
		elseif not data.TickTockBody:GetSprite():IsPlaying("TransformBack") then
			data.TickTockBody:GetSprite():Play("TransformBack", true)
			InutilLib.SFX:Play(SoundEffect.SOUND_THUMBSDOWN_AMPLIFIED, 1, 0, false, 1);
		end
		player.Velocity = Vector.Zero
		player.Position = player.Position
	end
	--init
	if not data.TickTockInit and data.TickTockBody then
		if data.TickTockBody and data.TickTockBody:IsDead() then --force spawn incase
			spawnBody(player, true)
			return
		end
		if data.TickTockBody:GetSprite():IsFinished("Transform") then
			data.TickTockInit = true
			SFXManager():Play(RebekahCurse.Sounds.SOUND_ROLANDAHH, 1, 0, false, 0.9)
			MusicManager():Play(RebekahCurse.Music.MUSIC_TICKTOCK, 0.1)
			--MusicManager():Queue(RebekahCurse.Music.MUSIC_TICKTOCK)
			if not MusicManager():IsLayerEnabled(0) and player:HasCollectible(CollectibleType.COLLECTIBLE_CAR_BATTERY) then
				MusicManager():EnableLayer(0, true)
			end
			MusicManager():UpdateVolume()
		end
		player.Velocity = Vector.Zero
	end
	if data.TickTockFrame and data.TickTockFrame > 0 and data.TickTockInit then
		player.Visible = false
		if data.TickTockBody and data.TickTockBody:IsDead() then
			spawnBody(player, true)
		end
		if not MusicManager():IsLayerEnabled(0) and player:HasCollectible(CollectibleType.COLLECTIBLE_CAR_BATTERY) then
			MusicManager():EnableLayer(0, true)
		end
		if player:GetFireDirection() > -1 then
			if not InutilLib.IsPlayingMultiple(data.TickTockBody:GetSprite(), "AttackRight", "AttackDown", "AttackUp", "AttackLeft") then
				data.Angle = InutilLib.AnimShootFrame(data.TickTockBody, true, InutilLib.DirToVec(player:GetFireDirection()), "AttackRight", "AttackDown", "AttackUp", "AttackLeft")
			else
				if data.TickTockBody:GetSprite():GetFrame() == 10 then
					local function explosion(pos)
						return Isaac.Spawn(EntityType.ENTITY_BOMBDROP, 0, 0, pos, Vector(0,0), player):ToBomb()
					end
					local dir = player:GetFireDirection()
					for j = 0, 200, 40 do
						InutilLib.SetTimer(math.floor(0+j/5), function()
							local bomb = explosion(player.Position + Vector((40+j),0):Rotated(InutilLib.DirToVec(dir):GetAngleDegrees()))
							bomb:SetExplosionCountdown(0)
							bomb.GridCollisionClass = GridCollisionClass.COLLISION_NONE
							yandereWaifu.GetEntityData(bomb).NoHarm = true
						end)
					end
				end
			end
			player.Velocity = Vector.Zero
		else
			if player.Velocity:Length() > 1 then
				if not InutilLib.IsPlayingMultiple(data.TickTockBody:GetSprite(), "HeadRight", "HeadDown", "HeadUp", "HeadLeft") then
					data.Angle = InutilLib.AnimShootFrame(data.TickTockBody, true, player.Velocity, "HeadRight", "HeadDown", "HeadUp", "HeadLeft")
				end
				if data.TickTockBody:GetSprite():GetFrame() == 9 --[[or data.TickTockBody:GetSprite():GetFrame() == 19 ]] then
					local dust = Isaac.Spawn( EntityType.ENTITY_EFFECT, EffectVariant.DUST_CLOUD, 0, player.Position, Vector(0,0), player ):ToEffect()
					dust:GetSprite().PlaybackSpeed = 0.3
					dust.Timeout = 6
					dust.LifeSpan = 6
					InutilLib.game:ShakeScreen(10)
					InutilLib.SFX:Play(SoundEffect.SOUND_FORESTBOSS_STOMPS, 1, 0, false, 0.8);
				end
			else
				data.TickTockBody:GetSprite():Play("WalkIdle")
			end
		end
	end
end)

yandereWaifu:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local sprite = eff:GetSprite();
	local data = yandereWaifu.GetEntityData(eff);
	local room =  Game():GetRoom();

	if data.IsTickTock then
		
	end
end, RebekahCurse.ENTITY_EXTRACHARANIMHELPER)

yandereWaifu:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, player, amount, damageFlag, damageSource, damageCountdownFrames)
    player = player:ToPlayer()
    local data = yandereWaifu.GetEntityData(player)
	if data.TickTockBody then
		if damageFlag & DamageFlag.DAMAGE_SPIKES == 0 and damageFlag & DamageFlag.DAMAGE_NO_MODIFIERS == 0 and damageFlag & DamageFlag.DAMAGE_INVINCIBLE == 0 and damageFlag & DamageFlag.DAMAGE_NO_PENALTIES == 0 then
			return false
		end
	end
end, EntityType.ENTITY_PLAYER)


if MMC then
	MMC.AddMusicCallback(yandereWaifu, function(self, music)
		if replacesong then
			return RebekahCurse.Music.MUSIC_TICKTOCK
		end
	end)
end