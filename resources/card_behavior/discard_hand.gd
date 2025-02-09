extends CardBehavior


func play(game: Node) -> void:
	game.get_opponent(card.player).discard(game.get_opponent(card.player).hand.cards.size())
