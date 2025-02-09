extends CardBehavior


func play(game: Node) -> void:
	super(game)
	add_damage(card.player, 7)
	add_damage(game.get_opponent(card.player), -3)
	
	# drawing
	var i: int = 0
	for deckcard: Card in card.player.deck.cards:
		if deckcard.card_resource.element == CardData.Element.COLD:
			card.player.deck.remove_card(deckcard)
			card.player._send_card_to_hand(deckcard)
			i += 1
			if i == 3: break
	
	SFX.play("draw")
	if card.player.hand.cards.size() > card.player.MAX_HAND_SIZE:
		card.player.discard(card.player.hand.cards.size() - card.player.MAX_HAND_SIZE)
