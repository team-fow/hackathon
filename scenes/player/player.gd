class_name Player
extends Node2D

signal died

@export_range(-10, 10) var temperature : int
@export var is_active: bool

@onready var hand: Hand = $Hand
@onready var deck: Deck = $Deck
@onready var card_played: CardPlayed = $CardPlayed


func _ready() -> void:
	var view_rect = get_viewport_rect()
	hand.position.y = view_rect.size.y/4.0
	deck.position.y = view_rect.size.y/4.0
	deck.position.x = view_rect.size.x/3.0
	card_played.position.x = view_rect.size.x/16.0
	card_played.send_to_hand.connect(_send_card_to_hand)
	hand.move_card_to_played.connect(_send_card_to_played)
	update_disp()
	for i in 5:
		var card: Card = preload("res://scenes/card/card.tscn").instantiate()
		card.card_resource = load("res://resources/card_data/test.tres")
		deck.add_card(card)


# Checks whether the player's temperature is at an extreme
func check_temperature() -> bool:
	if temperature < -10 or temperature > 10:
		died.emit()
		return true
	return false


# Moves the card in the played zone back to the player's hand
func _send_card_to_hand(card: Card) -> void:
	hand.add_card(card)


# Moves a card from the player's hand to their played card zone
func _send_card_to_played(card: Card) -> void:
	if card_played.accepting_card:
		hand._tween_card(card, card_played.position, 0)
		card.reparent(card_played, true)
		card.scale = Vector2.ONE
		card_played.add_card(card)
	else:
		hand._add_card_to_list(card, hand.held_card_idx)


func update_disp():
	match is_active:
		true:
			rotation_degrees = 0
			deck.show()
		false:
			rotation_degrees = 180
			deck.hide()
