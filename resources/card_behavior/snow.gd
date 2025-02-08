extends CardBehavior


func play(game_node : Node) -> void:
	super(game_node)
	add_damage(card.player, -2)
	add_damage(game.get_opponent(card.player), -2)
