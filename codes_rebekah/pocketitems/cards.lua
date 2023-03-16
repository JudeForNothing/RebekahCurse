local mod = yandereWaifu
function mod.NoCardNaturalSpawn(card, rng)
	--[[if mod.NoNaturalSpawnCards[card] then
		return true
	end

	if not FiendFolio.CardsEnabled and mod.CardsByID[card] then
		return true
	end

	if FiendFolio.CardConfig.ArcanaKingCardsDisabled and mod.MinorArcanaKingCards[card] then
		return true
	end

	if FiendFolio.CardConfig.PlayingKingCardsDisabled and mod.PlayingKingCards[card] then
		return true
	end

	if FiendFolio.CardConfig.ArcanaQueenCardsDisabled and mod.MinorArcanaQueenCards[card] then
		return true
	end

	if FiendFolio.CardConfig.PlayingQueenCardsDisabled and mod.PlayingQueenCards[card] then
		return true
	end

	if FiendFolio.CardConfig.ArcanaJackCardsDisabled and mod.MinorArcanaJackCards[card] then
		return true
	end

	if FiendFolio.CardConfig.PlayingJackCardsDisabled and mod.PlayingJackCards[card] then
		return true
	end

	if FiendFolio.CardConfig.ArcanaTwoCardsDisabled and mod.MinorArcanaTwoCards[card] then
		return true
	end

	if FiendFolio.CardConfig.ArcanaThreeCardsDisabled and mod.MinorArcanaThreeCards[card] then
		return true
	end

	if FiendFolio.CardConfig.PlayingThreeCardsDisabled and mod.PlayingThreeCards[card] then
		return true
	end

	if card == mod.ITEM.CARD.SKIP_CARD and game.Challenge > 0 then
		return true
	end

	if card == mod.ITEM.CARD.TAINTED_TREASURE_DISC and not TaintedCollectibles then
		return true
	end

	if rng then
		if mod.StupidRareCards[card] and rng:RandomFloat() < 0.5 then
			return true
		end

		if card == mod.ITEM.CARD.RUNE_ANSUS and rng:RandomFloat() > 1/1000000 then
			return true
		end
	end]]

	return yandereWaifu.IsCardLocked(card)
end
