class_name Game
extends Node2D

enum Phase {AWAIT_PLAYER_1, PLAYER_1, AWAIT_PLAYER_2, PLAYER_2, MAX}

@export var players: Array[Player]
@export var initial_deck: Array[CardData]

var curr_phase : Phase = Phase.AWAIT_PLAYER_1
var turn_idx: int

@export var active: bool

@export_group("Nodes")
@onready var standby_screen: ColorRect = $UI/StandbyScreen
@export var player_1_label: Label
@export var player_2_label: Label
@export var end_turn_button: Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for player: Player in players:
		player.died.connect(_on_player_died.bind(player))
		
		for data: CardData in initial_deck:
			var card: Card = preload("res://scenes/card/card.tscn").instantiate()
			card.card_resource = data
			player.deck.add_card(card)
	
	cycle()


func cycle() -> void:
	while active:
		curr_phase = (curr_phase + 1) % Phase.MAX
		await _standby()
		await _turn()


# Called when the player's health reaches an extreme
func _on_player_died(player: Player):
	active = false


func get_opponent(player: Player) -> Player:
	return players[(players.find(player) + 1) % players.size()]



# ui

# Rotates and flips player hands
func _turn() -> void:
	turn_idx += 1
	
	players.reverse()
	players[0].is_active = true
	players[0].rotation = 0
	players[0].update_disp()
	players[1].is_active = false
	players[1].rotation = PI
	players[1].update_disp()
	
	players[0].draw(1)
	
	await end_turn_button.pressed
	

# Hides the game state and waits for player input.
func _standby() -> void:
	standby_screen.show()
	
	while true:
		var event: InputEvent = await standby_screen.gui_input
		if event.is_action_pressed("click"):
			break
	
	standby_screen.hide()
