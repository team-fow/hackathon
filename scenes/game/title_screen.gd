extends ColorRect



func _on_p_1_name_input_text_changed(text: String) -> void:
	get_node("/root/Game/Player1").player_name = text


func _on_p_2_name_input_text_changed(text: String) -> void:
	get_node("/root/Game/Player2").player_name = text
