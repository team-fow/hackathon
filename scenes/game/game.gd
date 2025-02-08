extends Node

enum Phase {AWAIT_PLAYER_1, PLAYER_1, AWAIT_PLAYER_2, PLAYER_2, MAX}

@export var players: Array[Player]

var curr_phase : Phase = Phase.AWAIT_PLAYER_1
var active: bool

@onready var phase_label: Label = $UI/Margins/VBoxContainer/Phase_Label
@onready var standby_screen: ColorRect = $UI/StandbyScreen


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for player: Player in players:
		player.died.connect(_on_player_died.bind(player))
	
	cycle()


func cycle() -> void:
	while active:
		curr_phase = (curr_phase + 1) % Phase.MAX
		phase_label.text = "Current Phase: " + str(curr_phase)
		await _standby()
		await _turn()


# Called when the player's health reaches an extreme
func _on_player_died(player: Player):
	active = false



# ui

# Rotates and flips player hands
func _turn() -> void:
	players.reverse()
	players[0].flipped = true
	players[0].rotation = 0
	players[1].flipped = false
	players[1].rotation = PI
	await get_tree().create_timer(2).timeout
	

# Hides the game state and waits for player input.
func _standby() -> void:
	standby_screen.show()
	
	while true:
		var event: InputEvent = await standby_screen.gui_input
		if event.is_action_pressed("click"):
			break
	
	standby_screen.hide()
	
