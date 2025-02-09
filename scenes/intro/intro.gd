extends TabContainer

signal done


func start() -> void:
	current_tab = 0
	show()
	$Music.play()


func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		if current_tab == get_child_count() - 2:
			done.emit()
			hide()
		else:
			current_tab += 1

func _on_p_1_text_changed(new_text: String) -> void:
	get_node("/root/Game/Player1").player_name = new_text


func _on_p_2_text_changed(new_text: String) -> void:
	get_node("/root/Game/Player2").player_name = new_text


func _on_settings_intro_requested() -> void:
	print(1)
	current_tab = 0
	show()
