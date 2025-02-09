class_name Game
extends Node2D

signal turn_ended
signal round_ended

enum Phase {TURN, ACTION, MAX}

@export var players: Array[Player]

var initial_deck: Dictionary = {
	# climate (heat)
	"climate/cold/fog": 1,
	"climate/cold/iceberg": 1,
	"climate/cold/rain": 1,
	"climate/cold/wind": 1,
	# climate (cold)
	"climate/heat/magnifier": 1,
	"climate/heat/meteorite": 1,
	"climate/heat/spicy_sauce": 1,
	"climate/heat/sun": 1,
	# climate (neutral)
	"climate/reverse": 1,
	# meta
	"meta/discard": 1,
	"meta/discard_hand": 1,
	"meta/draw_1": 1,
	"meta/draw_2": 1,
	"meta/duds_to_deck": 1,
	"meta/duds_to_hand": 1,
	"meta/dud": 0,
	# meter
	"meter/crystal_ball": 1,
	"meter/eyeball": 1,
	# thermal (heat)
	"thermal/heat/flame": 1,
	"thermal/heat/match": 1,
	"thermal/heat/torch": 1,
	# thermal (cold)
	"thermal/cold/ice_cube": 1,
	"thermal/cold/snow": 1,
	"thermal/cold/water_droplet": 1,
}

var curr_phase : Phase
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
@onready var active_effects_container: VBoxContainer = $UI/Top/VBox2/EffectsScroll/ActiveEffectsContainer
@onready var title_screen: ColorRect = $UI/TitleScreen
@onready var card_queue_box: VBoxContainer = $UI/Top/VBox3/QueueScroll/CardQueue
@onready var turn_timer: Timer = $UI/Top/VBox/Timer/Timer
@onready var turn_timer_label: Label = $UI/Top/VBox/Timer/Label
@onready var music: AudioStreamPlayer = $GameMusic


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# setup
	for player: Player in players:
		player.died.connect(_on_player_died.bind(player))
		player.add_card_to_queue.connect(_add_to_card_queue)
		player.play_card.connect(func(c:Card): 
			c.play(self) 
			var active_effect = c.card_resource
			active_effects_container.add_effect(active_effect))
		
		for type: String in initial_deck:
			var resource: CardData = load("res://resources/card_data/%s.tres" % type)
			
			for i: int in initial_deck[type]:
				var card: Card = preload("res://scenes/card/card.tscn").instantiate()
				card.card_resource = resource
				player.deck.add_card(card)
		
		player.deck.shuffle()
		player.draw(4)
	
	# intro
	$UI/Intro.start()
	await $UI/Intro.done
	$GameMusic.play()
	
	# starting
	active = true
	cycle()


func cycle() -> void:
	while active:
		curr_phase = Phase.TURN
		await _standby()
		await _turn()
		if !turn_idx%2:
			curr_phase = Phase.ACTION
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
	card_queue_box.kill_children()
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
	await get_tree().create_timer(1).timeout
	
	players[0].draw(1)
	while players[0].hand.cards.size() < 3:
		players[0].draw(1)
	
	turn_timer.start()
	await turn_ended
	turn_timer.stop()
	
	SFX.play("turn_end")


func _add_to_card_queue(card : Card) -> void:
	card_queue.append(card)
	card_queue_box.add_card(card.card_resource)


func _resolve_cards() -> void:
	card_queue_box.kill_children()
	for player : Player in players:
		player.is_active = false
		player.update_disp()
		player.hand.hide()
		player.deck.hide()
	
	players[0].deck.up = -1
	players[0].card_played_history.up = -1
	players[1].deck.up = 1
	players[1].card_played_history.up = 1
	
	music.volume_db = linear_to_db(0.5)
	
	await get_tree().create_timer(1).timeout
	
	for card in card_queue:
		var pile = card.player.card_played_history
		var center = card.player.card_played
		pile.remove_card(card)
		center.add_card(card)
		await get_tree().create_timer(0.5).timeout
		if card.card_script.get_cardtype() == "climate": card.play(self)
		else: await card.play(self)
		center.remove_card(card)
		pile.add_card(card)

	card_queue.clear()
	for player : Player in players:
		player.card_played_history._order_cards()
	
	await end_turn_button.pressed
	round_ended.emit()
	
	for player : Player in players:
		player.card_played_history._order_cards()
		player.hand.show()
		player.deck.show()
	
	music.volume_db = linear_to_db(1)


# Hides the game state and waits for player input.
func _standby() -> void:
	if curr_phase == Phase.ACTION:
		$UI/StandbyScreen/VBoxContainer/Label2.text = "Let both players peek!\nAnd pay attention."
	else:
		$UI/StandbyScreen/VBoxContainer/Label2.text = "Pass the computer\nto the next player!"
	
	if standby_screen.modulate != Color(1,1,1,1):
		standby_screen.fadein()
	
	while true:
		var event: InputEvent = await standby_screen.gui_input
		if event.is_action_released("click"):
			break
	
	standby_screen.fadeout()


func _end_turn() -> void:
	turn_ended.emit()


func _process(_delta: float) -> void:
	var time_left: int = int(turn_timer.time_left)
	turn_timer_label.text = str(time_left)
	turn_timer_label.modulate = Color.RED if time_left <= 5 else Color.WHITE
