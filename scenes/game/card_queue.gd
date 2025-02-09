extends VBoxContainer


func add_card(res: CardData):
	var display = load("res://scenes/game/active_effect.tscn").instantiate()
	display.card_resource = res
	add_child(display)
	

func load_effects(effects: Array[CardData]) -> void:
	kill_children()
	for eff in effects:
		add_card(eff)


func kill_children() ->void:
	for child in get_children():
		child.queue_free()
