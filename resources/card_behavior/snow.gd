extends CardBehavior


func play(game : Node) -> void:
	game.get_opponent(card.player).temperature -= 2
	card.player.temperature -= 2
