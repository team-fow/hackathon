extends VBoxContainer


func add_effect(res: ClimateCardData):
	var display = load("res://scenes/game/active_effect.tscn").instantiate()
	display.card_resource = res
	add_child(display)
	

func load_effects(effects: Array[ClimateCardData]) -> void:
	for child in get_children():
		child.queue_free()
	for eff in effects:
		add_effect(eff)
