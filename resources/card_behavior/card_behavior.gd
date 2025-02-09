class_name CardBehavior

var card: Card
var game: Node


func play(game_node: Node) -> void:
	game = game_node
	

func add_damage(player: Player, damage_value: int) -> void:
	damage_value *= game.reverse
	if damage_value < 0:
		player.temperature -= (abs(damage_value) + game.cold_bonus + player.cold_bonus) * game.cold_multiplier * player.cold_multiplier
	elif damage_value > 0:
		player.temperature += (damage_value + game.heat_bonus + player.heat_bonus) * game.heat_multiplier * player.heat_multiplier
	else:
		pass


func get_cardtype() -> String: return "effect"
