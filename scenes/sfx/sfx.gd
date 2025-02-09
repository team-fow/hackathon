extends Node


func play(filename: String) -> void:
	get_node(filename).play()
