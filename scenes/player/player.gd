class_name Player
extends Node2D

signal temperature_changed
signal died

@export_range(-10, 10) var temperature : int : set = _set_temperature
@export var is_active: bool

@onready var hand: Hand = $Hand
@onready var deck: Deck = $Deck
@onready var card_played: CardPlayed = $CardPlayed
@onready var card_played_history: CardPlayedHistory = $CardPlayedHistory


func _ready() -> void:
	var view_rect = get_viewport_rect()
	card_played.send_to_hand.connect(_send_card_to_hand)
	hand.move_card_to_played.connect(_send_card_to_played)
	update_disp()
	
	for i in 5:
		var card: Card = preload("res://scenes/card/card.tscn").instantiate()
		card.card_resource = load("res://resources/card_data/test.tres")
		deck.add_card(card)
	
	for i in 5:
		var card: Card = preload("res://scenes/card/card.tscn").instantiate()
		card.card_resource = load("res://resources/card_data/test.tres")
		hand.add_card.call_deferred(card)


func draw(amount: int) -> void:
	for i: int in amount:
		var card: Card = deck.cards[-1]
		deck.remove_card(card)
		_send_card_to_hand(card)
		discard_random(1)


func discard_random(amount: int) -> void:
	for i: int in amount:
		var card: Card = hand.cards.pick_random()
		hand.remove_card(card)
		card.rotation = 0
		card_played_history.add_card(card)


# Checks whether the player's temperature is at an extreme
func check_temperature() -> bool:
	if temperature < -10 or temperature > 10:
		died.emit()
		return true
	return false


func _set_temperature(value: int) -> void:
	temperature = value
	temperature_changed.emit(value)


# Moves the card in the played zone back to the player's hand
func _send_card_to_hand(card: Card) -> void:
	hand.add_card(card)
	card.player = self


# Moves a card from the player's hand to their played card zone
func _send_card_to_played(card: Card) -> void:
	if card_played.accepting_card:
		hand.remove_card(card)
		card_played.add_card(card)
		await card.play(get_tree().current_scene)
		card_played.remove_card(card)
		card_played_history.add_card(card)
	else:
		hand._add_card_to_list(card, hand.held_card_idx)


func update_disp():
	deck.flipped = !is_active
	hand.flipped = !is_active
	card_played_history.flipped = !is_active
