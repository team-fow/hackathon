extends CardBehavior


func play(game_node : Node) -> void:
	super(game_node)
	add_damage(game.get_opponent(card.player), -1)
