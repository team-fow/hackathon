extends Button


func _pressed() -> void:
	var hand: Hand = get_node("/root/Game/Player/Hand")
	hand.flipped = !hand.flipped
