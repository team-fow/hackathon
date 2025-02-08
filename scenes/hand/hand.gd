class_name Hand
extends Node2D

const CARD_SEPARATION: float = Card.SIZE.x / 2
const MAX_CARD_Y_OFFSET: float = Card.SIZE.y / 2
const MAX_CARD_ROTATION: float = PI / 4
const DROP_AREA := Rect2(-400, -200, 800, 400)

var cards: Array[Card] ## List of cards in the hand.
var held_card: Card ## The currently held card.


## Adds a [Card] to the hand.
func add_card(card: Card) -> void:
	add_child(card)
	card.gui_input.connect(_on_card_input.bind(card))
	card.set_input(true)
	
	cards.append(card)
	_order_cards()


## Removes [param card] from [member cards] and stores it in [member held_card].
func grab_card(card: Card) -> void:
	held_card = card
	held_card.rotation = 0
	held_card.set_input(false)
	
	cards.erase(card)
	_order_cards()


func _on_held_card_dropped() -> void:
	if DROP_AREA.has_point(get_local_mouse_position()):
		held_card.set_input(true)
		cards.append(held_card)
		_order_cards()
	else:
		held_card.gui_input.disconnect(_on_card_input)
	held_card = null



# ordering

# Positions and rotates cards in the hand.
func _order_cards() -> void:
	var width: float = CARD_SEPARATION * (cards.size() - 1)
	var left: float = -width / 2
	var half_count: float = (cards.size() - 1) / 2.0
	
	for i: int in cards.size():
		var percent: float = (i - half_count) / cards.size()
		cards[i].position.x = left + CARD_SEPARATION * i
		cards[i].position.y = abs(percent) * MAX_CARD_Y_OFFSET
		cards[i].rotation = percent * MAX_CARD_ROTATION



# input

# Handles grabbing and dropping cards.
func _on_card_input(event: InputEvent, card: Card) -> void:
	if event.is_action_pressed("click"):
		grab_card(card)


# Moves [member held_card] to the mouse position.
func _unhandled_input(event: InputEvent) -> void:
	if held_card:
		if event is InputEventMouseMotion:
			held_card.position = get_local_mouse_position()
		elif event.is_action_released("click"):
			_on_held_card_dropped()
