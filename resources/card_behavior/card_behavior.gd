class_name CardBehavior

var card: Card
var game: Node


func play(game: Node) -> void:
	self.game = game


func add_damage(player: Player, damage_value: int) -> void:
	damage_value *= game.reverse
	if damage_value < 0:
		player.temperature -= (damage_value + game.cold_bonus) * game.cold_multiplier
	elif damage_value > 0:
		player.temperature += (damage_value + game.cold_bonus) * game.cold_multiplier
	else:
		pass
