@tool
class_name CardList
extends Node2D
## A list of [Card] nodes.

const TWEEN_DURATION: float = 0.1 ## Duration of tweening effects.

@export var flipped: bool : set = _set_flipped ## Whether cards are face-up and can be interacted with.

var cards: Array[Card] ## All cards stored in this list.
var tween: Tween


# modifying list

## Adds a card at index [member idx].
func add_card(card: Card, idx: int = -1) -> void:
	if card.is_inside_tree():
		card.reparent(self)
	else:
		add_child(card)
	
	move_child(card, idx)
	_add_card_to_list(card, idx)


## Removes a card.
func remove_card(card: Card) -> void:
	_remove_card_from_list(card)


# Adds a card to cards at index idx. Does not add it as a child.
func _add_card_to_list(card: Card, idx: int) -> void:
	if idx == -1:
		cards.append(card)
	else:
		cards.insert(idx, card)
	_order_cards()


# Removes a card from cards. Does not remove it as a child.
func _remove_card_from_list(card: Card) -> void:
	cards.erase(card)
	_order_cards()



# display

## Overwrite this to control how cards in [member cards] are displayed.
func _order_cards() -> void:
	for card: Card in cards:
		_tween_card(card, Vector2.ZERO, 0)


# Smoothly animates positioning and rotating a card.
func _tween_card(card: Card, pos: Vector2, rot: float) -> void:
	tween = get_tree().create_tween().set_parallel().set_trans(Tween.TRANS_CUBIC)
	card.tween = tween
	tween.tween_property(card, "position", pos, TWEEN_DURATION)
	tween.tween_property(card, "rotation", rot, TWEEN_DURATION)
	await tween.finished
	card.tween = null


func _set_flipped(value: bool) -> void:
	flipped = value
	for card: Card in cards:
		card.set_flipped(value)



# editor

func _draw() -> void:
	draw_rect(Rect2(-Card.SIZE/2, Card.SIZE), Color.GRAY, false)
