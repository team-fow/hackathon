extends Button


func _pressed() -> void:
	var card: Card = preload("res://scenes/card/card.tscn").instantiate()
	card.card_resource = load("res://resources/card_data/test.tres")
	get_node("/root/Game/Hand").add_card(card)
