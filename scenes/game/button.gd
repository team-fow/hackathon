extends Button

@export var target: CardList


func _pressed() -> void:
	var card: Card = preload("res://scenes/card/card.tscn").instantiate()
	card.card_resource = load("res://resources/card_data/test.tres")
	get_node("/root/Game/Player/Hand").add_card(card)
