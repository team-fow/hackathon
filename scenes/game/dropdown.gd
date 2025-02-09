extends TextureRect

@export var open: bool : set = _set_open


func _set_open(value: bool) -> void:
	if not is_node_ready(): await ready
	
	open = value
	texture = preload("res://assets/ui/dropdown.png") if value else preload("res://assets/ui/dropdown_collapsed.png")
	get_child(0).get_child(1).visible = value


func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		open = !open
