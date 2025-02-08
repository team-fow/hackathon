extends VBoxContainer

func add_effect(res: CardData):
	var display = load("res://scenes/game/active_effect.tscn")
	display.card_resource = res
	add_child(display.instantiate())
	

func remove_effect(res: CardData) -> bool:
	var children = get_children()
	for child in children:
		if child.card_resource == res:
			child.queue_free()
			return true
	return false
