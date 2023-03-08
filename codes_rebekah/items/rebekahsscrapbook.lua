local entities = {
	RebekahCurseEnemies.ENTITY_HOUNDPUPPY,
	RebekahCurseEnemies.ENTITY_OVUM_EGG,
	RebekahCurseEnemies.ENTITY_REDTATO,
	RebekahCurseEnemies.ENTITY_MAGDALENE_HEART,
	RebekahCurseEnemies.ENTITY_SISTER,
	RebekahCurseEnemies.ENTITY_BUMBAB,
	RebekahCurseEnemies.ENTITY_ROACH,
	RebekahCurseEnemies.ENTITY_MONK,
	RebekahCurseEnemies.ENTITY_LONGITS,
	RebekahCurseEnemies.ENTITY_LOAFERING,
	RebekahCurseEnemies.ENTITY_BLOOD_SLOTH,
}
function yandereWaifu:useRebekahsScrapbook(collItem, rng, player)
	local data = yandereWaifu.GetEntityData(player)
	local enti = entities[math.random(1, #entities)]
	print(enti)
	local ent = Isaac.Spawn( RebekahCurseEnemies.ENTITY_REBEKAH_ENEMY, enti, 0, player.Position, Vector(0,0), player );
	ent:AddEntityFlags(EntityFlag.FLAG_CHARM | EntityFlag.FLAG_FRIENDLY | EntityFlag.FLAG_PERSISTENT)
	yandereWaifu.GetEntityData(ent).CharmedToParent = player
	return {
		ShowAnim = true
	}
end
yandereWaifu:AddCallback( ModCallbacks.MC_USE_ITEM, yandereWaifu.useRebekahsScrapbook, RebekahCurseItems.COLLECTIBLE_REBEKAHSSCRAPBOOK);
