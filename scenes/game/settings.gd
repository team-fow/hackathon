extends PanelContainer


func _on_settings_pressed() -> void:
	get_tree().paused = true
	show()


func _on_continue_pressed() -> void:
	get_tree().paused = false
	hide()


func _on_quit_pressed() -> void:
	get_tree().quit()
