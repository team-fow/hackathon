class_name Game
extends Node2D

signal turn_ended
signal round_ended

enum Phase {AWAIT_PLAYER_1, PLAYER_1, AWAIT_PLAYER_2, PLAYER_2, MAX}

@export var players: Array[Player]
@export var initial_deck: Array[CardData]

var curr_phase : Phase = Phase.AWAIT_PLAYER_1
var turn_idx: int
var active_effects : Array[CardData]

var heat_bonus: int
var heat_multiplier: int
var cold_bonus: int
var cold_multiplier: int
var reverse: int

@export var active: bool

@export_group("Nodes")
@onready var standby_screen: ColorRect = $UI/StandbyScreen
@export var active_player_disp: TextureRect
@export var inactive_player_disp: TextureRect
@export var end_turn_button: TextureButton


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
		await _standby()
		await _turn()
		if turn_idx % 2: round_ended.emit()


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
	active_player_disp.show_info(players[0])
	inactive_player_disp.show_info(players[1])
	players[0].is_active = true
	players[0].rotation = 0
	players[0].update_disp()
	players[1].is_active = false
	players[1].rotation = PI
	players[1].update_disp()
	
	players[0].draw(1)
	
	await end_turn_button.pressed
	turn_ended.emit()


# Hides the game state and waits for player input.
func _standby() -> void:
	standby_screen.show()
	
	while true:
		var event: InputEvent = await standby_screen.gui_input
		if event.is_action_pressed("click"):
			break
	
	standby_screen.hide()
