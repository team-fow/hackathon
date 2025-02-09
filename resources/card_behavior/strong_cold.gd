extends CardBehavior


func play(game: Node) -> void:
	super(game)
	add_damage(card.player, -7)
