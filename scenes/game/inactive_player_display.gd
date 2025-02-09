extends TextureRect

const TEMPERATURE_COLOR = preload("res://assets/temperature_color.tres")

@export var player: Player
@onready var temperature: Label = $Temperature
@onready var player_name: Label = $Name

func show_info(player: Player):
	player = player
	player_name.text = player.player_name
	temperature.text = str(player.temperature)
	temperature.modulate = TEMPERATURE_COLOR.sample((player.temperature + 10.0) / 20)
