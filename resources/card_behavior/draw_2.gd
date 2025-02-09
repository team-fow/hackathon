extends CardBehavior


func play(game : Node) -> void:
	super(game)
	card.player.draw(3)
	add_damage(card.player, -2)
