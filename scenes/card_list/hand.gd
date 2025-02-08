@tool
class_name Hand
extends CardList

signal move_card_to_played(card)

const CARD_SEPARATION: float = Card.SIZE.x / 2 ## Horizontal spacing between cards.
const MAX_FAN_ROTATION: float = PI / 8 ## Maximum rotation for fanning.
const MAX_FAN_OFFSET: float = Card.SIZE.y / 4 ## Maximum vertical offset for fanning.
const HOVERED_CARD_SCALE := Vector2(1.2, 1.2) ## Scaling applied to the currently hovered card.

var held_card: Card ## The card currently being dragged out of the hand.
var held_card_idx: int ## The previous index of [member held_card] in the list.
var drop_area := Rect2(0, -Card.SIZE.y/2, 0, Card.SIZE.y + MAX_FAN_OFFSET) ## The area in which [member held_card] can be dropped without playing it.


# grabbing cards

# Handles grabbing cards.
func _on_card_input(event: InputEvent, card: Card) -> void:
	if event.is_action_pressed("click"):
		held_card = card
		held_card_idx = cards.find(held_card)
		_remove_card_from_list(card)


# Handles dragging/dropping the held card.
# If the card is dropped in drop_area, reinserts the card into the list; otherwise, plays the card.
func _unhandled_input(event: InputEvent) -> void:
	if held_card:
		if event is InputEventMouseMotion:
			held_card.position = get_local_mouse_position()
		
		elif event.is_action_released("click"):
			if drop_area.has_point(get_local_mouse_position()):
				_add_card_to_list(held_card, held_card_idx)
			else:
				move_card_to_played.emit(held_card)
			held_card = null



# display

func _order_cards() -> void:
	var width: float = CARD_SEPARATION * (cards.size() - 1)
	var left: float = -width / 2.0
	
	if cards.size() == 1: # displaying single card
		_tween_card(cards[0], Vector2(0, MAX_FAN_OFFSET), 0)
	
	elif cards.size() > 1: # fanning multiple cards
		var half_count: float = (cards.size() - 1) / 2.0
		for i: int in cards.size():
			var percent: float = (i - half_count) / half_count
			_tween_card(
				cards[i],
				Vector2(left + CARD_SEPARATION * i, abs(percent) * MAX_FAN_OFFSET),
				percent * MAX_FAN_ROTATION
			)
	
	# resizing drop area
	drop_area.position.x = left - CARD_SEPARATION
	drop_area.size.x = width + CARD_SEPARATION * 2


func _on_card_moused(card: Card, mouse_inside: bool) -> void:
	if not held_card:
		card.z_index = mouse_inside
		card.scale = HOVERED_CARD_SCALE if mouse_inside else Vector2.ONE
		
		if mouse_inside:
			_tween_card(card, card.position, 0)
		elif cards.size() > 1:
			var half_count: float = (cards.size() - 1) / 2.0
			var percent: float = (cards.find(card) - half_count) / half_count
			_tween_card(card, card.position, percent * MAX_FAN_ROTATION)


# modifying list

func add_card(card: Card, idx: int = -1) -> void:
	super(card, idx)
	card.gui_input.connect(_on_card_input.bind(card))
	card.mouse_entered.connect(_on_card_moused.bind(card, true))
	card.mouse_exited.connect(_on_card_moused.bind(card, false))
	card.set_flipped(flipped)


func remove_card(card: Card) -> void:
	super(card)
	card.gui_input.disconnect(_on_card_input)
	card.mouse_entered.disconnect(_on_card_moused)
	card.mouse_exited.disconnect(_on_card_moused)
	card.scale = Vector2.ONE


func _add_card_to_list(card: Card, idx: int) -> void:
	super(card, idx)
	card.set_input(true)


func _remove_card_from_list(card: Card) -> void:
	super(card)
	card.set_input(false)
	card.rotation = 0
