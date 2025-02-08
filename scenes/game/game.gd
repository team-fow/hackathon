extends Node

@onready var player: Player = $Player


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.died.connect(_on_player_died)


# Called when the player's health reaches an extreme
func _on_player_died():
	pass
