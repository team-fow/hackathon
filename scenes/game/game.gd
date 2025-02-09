class_name Game
extends Node2D

signal turn_ended
signal round_ended

enum Phase {AWAIT_PLAYER_1, PLAYER_1, AWAIT_PLAYER_2, PLAYER_2, ACTION}

@export var players: Array[Player]
@export var initial_deck: Array[CardData]

var curr_phase : Phase = Phase.AWAIT_PLAYER_1
var turn_idx: int

var heat_bonus: int
var heat_multiplier: int = 1
var cold_bonus: int
var cold_multiplier: int = 1
var reverse: int = 1
var card_queue: Array[Card]

@export var active: bool

@export_group("Nodes")
@onready var standby_screen: ColorRect = $UI/StandbyScreen
@export var active_player_disp: TextureRect
@export var inactive_player_disp: TextureRect
@export var end_turn_button: TextureButton
@onready var active_effects_container: VBoxContainer = $UI/Margins/VBox2/EffectsScroll/ActiveEffectsContainer
@onready var begin_game: Button = $UI/TitleScreen/BeginGame
@onready var title_screen: ColorRect = $UI/TitleScreen


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	title_screen.show()
	standby_screen.modulate = Color(1,1,1,1)
	await begin_game.pressed
	title_screen.hide()
	active = true
	#initial_deck = initial_deck.filter(func(card) -> bool: return card is ClimateCardData)
	for player: Player in players:
		player.died.connect(_on_player_died.bind(player))
		player.add_card_to_queue.connect(func(c:Card): card_queue.append(c))
		player.play_card.connect(func(c:Card): 
			c.play(self) 
			var active_effect = c.card_resource
			active_effects_container.add_effect(active_effect))
		
		for data: CardData in initial_deck:
			var card: Card = preload("res://scenes/card/card.tscn").instantiate()
			card.card_resource = data
			player.deck.add_card(card)
			player.deck.shuffle()
		
		player.draw(5)
	
	cycle()


func cycle() -> void:
	while active:
		await _standby()
		await _turn()
		if !turn_idx%2:
			await _standby()
			await _resolve_cards()


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
	
	var active_effects = players[0].active_effects
	active_effects_container.load_effects(active_effects)
	
	players[0].is_active = true
	players[0].rotation = 0
	players[0].update_disp()
	players[1].is_active = false
	players[1].rotation = PI
	players[1].update_disp()
	
	players[0].draw(1)
	
	print(1)
	await end_turn_button.pressed
	while players[0].hand.cards.size() < 3:
		players[0].draw(1)
	turn_ended.emit()


func _resolve_cards() -> void:
	for player : Player in players:
		player.is_active = false
		player.update_disp()
	active_player_disp.hide()
	inactive_player_disp.hide()
	active_effects_container.hide()
	
	for card in card_queue:
		var pile = card.player.card_played_history
		var center = card.player.card_played
		pile.remove_card(card)
		center.add_card(card)
		await get_tree().create_timer(0.5).timeout
		await card.play(self)
		center.remove_card(card)
		pile.add_card(card)

	card_queue.clear()
	for player : Player in players:
		player.card_played_history._order_cards()
	await end_turn_button.pressed
	active_player_disp.show()
	inactive_player_disp.show()
	active_effects_container.show()
	round_ended.emit()


# Hides the game state and waits for player input.
func _standby() -> void:
	if standby_screen.modulate != Color(1,1,1,1):
		standby_screen.fadein()
	
	while true:
		var event: InputEvent = await standby_screen.gui_input
		if event.is_action_pressed("click"):
			break
	
	standby_screen.fadeout()
