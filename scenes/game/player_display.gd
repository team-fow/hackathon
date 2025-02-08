extends TextureRect

@export var player: Player
@onready var player_name: Label = $Name


func show_info(player: Player):
	player = player
	player_name.text = player.player_name
