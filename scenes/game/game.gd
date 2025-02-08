extends Node

@onready var phase_label: Label = $UI/Margins/VBoxContainer/Phase_Label
@onready var player: Player = $Player
enum {AWAIT_PLAYER_1, PLAYER_1, AWAIT_PLAYER_2, PLAYER_2}
var curr_phase : int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.died.connect(_on_player_died)
	curr_phase = AWAIT_PLAYER_1
	player.died.connect(_on_player_died)
	while true:
		await get_tree().create_timer(1).timeout
		next_phase()


# Called when the player's health reaches an extreme
func _on_player_died():
	pass
	

# Advances the current phase to the next phase in the enum
func next_phase() -> int:
	curr_phase += 1
	if curr_phase > PLAYER_2:
		curr_phase = 0
	phase_label.text = "Current Phase: " + str(curr_phase)
	return curr_phase		
