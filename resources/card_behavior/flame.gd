extends CardBehavior


func play(game: Node) -> void:
	super(game)
	add_damage(card.player, 2)
	add_damage(game.get_opponent(card.player), 2)
