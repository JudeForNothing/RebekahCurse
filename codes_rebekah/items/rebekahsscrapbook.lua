local entities = {
	RebekahCurse.Enemies.ENTITY_HOUNDPUPPY,
	RebekahCurse.Enemies.ENTITY_OVUM_EGG,
	RebekahCurse.Enemies.ENTITY_REDTATO,
	RebekahCurse.Enemies.ENTITY_MAGDALENE_HEART,
	RebekahCurse.Enemies.ENTITY_SISTER,
	RebekahCurse.Enemies.ENTITY_BUMBAB,
	RebekahCurse.Enemies.ENTITY_ROACH,
	RebekahCurse.Enemies.ENTITY_MONK,
	RebekahCurse.Enemies.ENTITY_LONGITS,
	RebekahCurse.Enemies.ENTITY_LOAFERING,
	RebekahCurse.Enemies.ENTITY_BLOOD_SLOTH,
	RebekahCurse.Enemies.ENTITY_EVALUATOR,
	RebekahCurse.Enemies.ENTITY_DEVOTEE,
	RebekahCurse.Enemies.ENTITY_GOSSIPER,
	--RebekahCurse.Enemies.ENTITY_FOUNDATION,
	RebekahCurse.Enemies.ENTITY_NPC,
	RebekahCurse.Enemies.ENTITY_DUSTBUNNY,
	RebekahCurse.Enemies.ENTITY_BUNCARPET,
}
function yandereWaifu:useRebekahsScrapbook(collItem, rng, player)
	local data = yandereWaifu.GetEntityData(player)
	local enti = entities[math.random(1, #entities)]
	print(enti)
	local ent = Isaac.Spawn( RebekahCurse.Enemies.ENTITY_REBEKAH_ENEMY, enti, 0, player.Position, Vector(0,0), player );
	ent:AddEntityFlags(EntityFlag.FLAG_CHARM | EntityFlag.FLAG_FRIENDLY | EntityFlag.FLAG_PERSISTENT)
	yandereWaifu.GetEntityData(ent).CharmedToParent = player
	return {
		ShowAnim = true
	}
end
yandereWaifu:AddCallback( ModCallbacks.MC_USE_ITEM, yandereWaifu.useRebekahsScrapbook, RebekahCurse.Items.COLLECTIBLE_REBEKAHSSCRAPBOOK);
