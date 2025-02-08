class_name CardList
extends Node2D
## A list of [Card] nodes.

@export var drop_area := Rect2(-400, -200, 800, 400) ## Area in which cards can be dropped to add them to the list.

var cards: Array[Card] ## Cards in the list.
var held_card: Card ## Card currently being dragged out of the list.



# modifying

## Adds [param card].
func add_card(card: Card) -> void:
	_add_card_to_list(card)
	add_child(card)
	
	card.gui_input.connect(_on_card_input.bind(card))


## Removes [param card].
func remove_card(card: Card) -> void:
	_remove_card_from_list(card)
	remove_child(card)
	
	card.gui_input.disconnect(_on_card_input)


# Adds [param card] to [member cards].
# Does not add [param card] as a child.
func _add_card_to_list(card: Card) -> void:
	cards.append(card)
	card.set_input(true)
	_order_cards()
	
	card.set_input(true)


# Removes [param card] from [member cards].
# Does not remove [param card] as a child.
func _remove_card_from_list(card: Card) -> void:
	cards.erase(card)
	card.set_input(false)
	_order_cards()
	
	card.set_input(false)



# held card

## Removes [param card] from the list and stores it in [member held_card].
func grab_card(card: Card) -> void:
	held_card = card
	_remove_card_from_list(card)


# Called when [member held_card] is released.
# If the card is dropped in [member drop_area], the card is reinserted into the list.
func _on_held_card_dropped() -> void:
	if drop_area.has_point(get_local_mouse_position()):
		_add_card_to_list(held_card)
	else:
		pass
	
	held_card = null



# display

## Overwrite this to control how cards in the list are displayed.
func _order_cards() -> void:
	pass



# input

# Handles grabbing cards.
func _on_card_input(event: InputEvent, card: Card) -> void:
	if event.is_action_pressed("click"):
		grab_card(card)


# Handles moving and dropping the held card.
func _unhandled_input(event: InputEvent) -> void:
	if held_card:
		if event is InputEventMouseMotion:
			held_card.position = get_local_mouse_position()
		elif event.is_action_released("click"):
			_on_held_card_dropped()
