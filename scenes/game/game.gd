class_name Game
extends Node2D

signal turn_ended
signal round_ended

enum Phase {TURN, ACTION, MAX}

@export var players: Array[Player]

var initial_deck: Dictionary = {
	# climate (heat)
	"climate/cold/fog": 2,
	"climate/cold/iceberg": 1,
	"climate/cold/rain": 2,
	"climate/cold/wind": 2,
	# climate (cold)
	"climate/heat/magnifier": 2,
	"climate/heat/meteorite": 2,
	"climate/heat/spicy_sauce": 2,
	"climate/heat/sun": 1,
	# climate (neutral)
	"climate/reverse": 2,
	# meta
	"meta/discard": 1,
	"meta/discard_hand": 1,
	"meta/draw_1": 4,
	"meta/draw_2": 4,
	"meta/duds_to_deck": 3,
	"meta/duds_to_hand": 3,
	"meta/dud": 0,
	# meter
	"meter/crystal_ball": 2,
	"meter/eyeball": 2,
	# thermal (heat)
	"thermal/heat/flame": 2,
	"thermal/heat/match": 3,
	"thermal/heat/torch": 4,
	"thermal/heat/strong_heat": 1,
	"thermal/heat/vent_heat": 2,
	# thermal (cold)
	"thermal/cold/ice_cube": 3,
	"thermal/cold/snow": 2,
	"thermal/cold/water_droplet": 4,
	"thermal/cold/strong_cold": 1,
	"thermal/cold/absorb_heat": 2
}

var curr_phase : Phase
var turn_idx: int

var heat_bonus: int
var heat_multiplier: int = 1
var cold_bonus: int
var cold_multiplier: int = 1
var reverse: int = 1
var card_queue: Array[Card]
var all_cards_played: Array[CardData]

@export var active: bool

@export_group("Nodes")
@onready var standby_screen: ColorRect = $UI/StandbyScreen
@export var active_player_disp: TextureRect
@export var inactive_player_disp: TextureRect
@export var end_turn_button: TextureButton
@export var active_effects_container: VBoxContainer
@onready var title_screen: ColorRect = $UI/TitleScreen
@export var card_queue_box: VBoxContainer
@onready var turn_timer: Timer = $UI/Top/Control/Timer/Timer
@onready var turn_timer_texture: TextureRect = $UI/Top/Control/Timer
@onready var music: AudioStreamPlayer = $GameMusic
@onready var end_screen: TextureRect = $UI/EndScreen
@onready var turn_timer_label: Label = $UI/Top/Control/Timer/Label
@onready var player_1: Player = $Player1
@onready var player_2: Player = $Player2


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
	
	# names
	$UI/PlayedCardLabels/Label.text = players[0].player_name
	$UI/PlayedCardLabels/Label2.text = players[1].player_name
	
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
	end_screen.set_winner(get_opponent(player), player)
	end_screen.show()
	active = false


func get_opponent(player: Player) -> Player:
	return players[(players.find(player) + 1) % players.size()]



# ui

# Rotates and flips player hands
func _turn() -> void:
	turn_idx += 1
	turn_timer.start()
	turn_timer.set_paused(true)
	
	turn_timer_texture.scale.y = 0
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
	var timer_tween = create_tween()
	timer_tween.tween_property(turn_timer_texture, "scale", Vector2(3, 3), 0.15)
	turn_timer.set_paused(false)
	timer_tween.tween_property(turn_timer_texture, "scale", Vector2.ONE, 0.15)
	await timer_tween.finished
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
	player_1.rotation = 0
	player_2.rotation = PI
	players[0].card_played_history.up = -1
	players[1].deck.up = 1
	players[1].card_played_history.up = 1
	active_player_disp.hide()
	inactive_player_disp.hide()
	$UI/Top.hide()
	$UI/PlayedCardLabels.show()
	
	music.volume_db = linear_to_db(0.5)
	
	await get_tree().create_timer(3 if turn_idx < 3 else 2.5).timeout
	
	for card in card_queue:
		var pile = card.player.card_played_history
		var center = card.player.card_played
		pile.remove_card(card)
		center.add_card(card)
		print("%s played %s" % [card.player.player_name, card.card_resource.name])
		print("Heat: + %s x %s\tCold: + %s x %s\tReverse: %s" %[
			heat_bonus,
			heat_multiplier,
			cold_bonus,
			cold_multiplier,
			reverse
		])
		await get_tree().create_timer(0.5).timeout
		if card.card_script.get_cardtype() == "climate": card.play(self)
		else: await card.play(self)
		center.remove_card(card)
		pile.add_card(card)
		all_cards_played.append(card.card_resource)
	
	card_queue.clear()
	for player : Player in players:
		player.card_played_history._order_cards()
	
	await get_tree().create_timer(1.0).timeout
	round_ended.emit()
	players.shuffle()


# Hides the game state and waits for player input.
func _standby() -> void:
	if curr_phase == Phase.ACTION:
		$UI/StandbyScreen/VBoxContainer/Label2.text = "Let both players peek!\nAnd pay attention."
	else:
		$UI/StandbyScreen/VBoxContainer/Label2.text = "Pass the computer\nto " + players[1].player_name + "!" 
	
	if standby_screen.modulate != Color(1,1,1,1):
		standby_screen.fadein()
	
	while true:
		var event: InputEvent = await standby_screen.gui_input
		if event.is_action_released("click"):
			break
			
	for player : Player in players:
		player.card_played_history._order_cards()
		player.hand.show()
		player.deck.show()
	active_player_disp.show()
	inactive_player_disp.show()
	$UI/Top.show()
	$UI/PlayedCardLabels.hide()
	
	music.volume_db = linear_to_db(1)
	standby_screen.fadeout()


func _end_turn() -> void:
	turn_ended.emit()


func _process(_delta: float) -> void:
	var time_left: int = int(turn_timer.time_left)
	turn_timer_label.text = str(time_left)
	turn_timer_texture.modulate = Color.RED if time_left <= 5 else Color.WHITE
