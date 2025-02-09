class_name Player
extends Node2D

signal temperature_changed
signal died
signal add_card_to_queue(card: Card)
signal play_card(card: Card)

const MAX_HAND_SIZE: int = 7 ## Maximum number of cards in the hand.

@export_range(-10, 10) var temperature : int : set = _set_temperature
@export var is_active: bool
@export var player_name : String

var active_effects : Array[ClimateCardData]
var heat_bonus: int
var heat_multiplier: int = 1
var cold_bonus: int
var cold_multiplier: int = 1

@onready var hand: Hand = $Hand
@onready var deck: Deck = $Deck
@onready var card_played: CardPlayed = $CardPlayed
@onready var card_played_history: CardPlayedHistory = $CardPlayedHistory


func _ready() -> void:
	var view_rect = get_viewport_rect()
	card_played.send_to_hand.connect(_send_card_to_hand)
	hand.move_card_to_played.connect(_send_card_to_played)
	update_disp()


func draw(amount: int) -> void:
	# safeproofing if deck is empty
	if deck.cards.is_empty():
		if not card_played_history.cards.is_empty():
			for played_card: Card in card_played_history.cards:
				card_played_history.remove_card(played_card)
				deck.add_card(played_card)
		else:
			return
	
	# drawing cards
	for i: int in amount:
		var card: Card = deck.cards.back()
		deck.remove_card(card)
		_send_card_to_hand(card)
	
	# discarding extra cards
	if hand.cards.size() > MAX_HAND_SIZE:
		discard(hand.cards.size() - MAX_HAND_SIZE)


func discard(amount: int) -> void:
	for i: int in amount:
		var card: Card = hand.cards.front()
		hand.remove_card(card)
		card_played_history.add_card(card)


func _set_temperature(value: int) -> void:
	temperature = value
	temperature_changed.emit(value)
	
	if absi(temperature) > 10:
		died.emit()


# Moves the card in the played zone back to the player's hand
func _send_card_to_hand(card: Card) -> void:
	hand.add_card(card)
	card.player = self


# Moves a card from the player's hand to their played card zone
func _send_card_to_played(card: Card) -> void:
	if card_played.accepting_card:
		hand.remove_card(card)
		card_played.add_card(card)
		
		await get_tree().create_timer(0.5).timeout
		
		add_card_to_queue.emit(card)
		card_played.remove_card(card)
		card_played_history.add_card(card)
	else:
		hand._add_card_to_list(card, hand.held_card_idx)


func update_disp():
	hand.flipped = !is_active
	deck.flipped = !is_active
	deck.up = -1 if is_active else 1
	card_played_history.flipped = !is_active
	card_played_history.up = -1 if is_active else 1
