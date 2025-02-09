extends PanelContainer

signal intro_requested
signal end_requested


func _on_settings_pressed() -> void:
	get_tree().paused = true
	show()


func _on_continue_pressed() -> void:
	get_tree().paused = false
	hide()


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_music_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(1, linear_to_db(value))


func _on_sfx_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(2, linear_to_db(value))


func _on_texture_progress_bar_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("click") or event is InputEventMouse and Input.is_action_pressed("click"):
		$Panel/Margins/VBox/TextureProgressBar.value = event.position.x / $Panel/Margins/VBox/TextureProgressBar.get_rect().size.x


func _on_texture_progress_bar_2_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("click") or event is InputEventMouse and Input.is_action_pressed("click"):
		$Panel/Margins/VBox/TextureProgressBar2.value = event.position.x / $Panel/Margins/VBox/TextureProgressBar2.get_rect().size.x


func _on_button_pressed() -> void:
	_on_continue_pressed()
	intro_requested.emit()
