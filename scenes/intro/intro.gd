extends TabContainer

signal done


func start() -> void:
	show()
	$Music.play()


func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		if current_tab == get_child_count() - 2:
			done.emit()
			queue_free()
		else:
			current_tab += 1
	
	elif event.is_action_pressed("right_click"):
		current_tab = max(0, current_tab - 1)


func _on_p_1_text_changed(new_text: String) -> void:
	get_node("/root/Game/Player1").player_name = new_text


func _on_p_2_text_changed(new_text: String) -> void:
	get_node("/root/Game/Player2").player_name = new_text
