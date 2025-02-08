@tool
class_name Deck
extends CardList

const CARD_SEPARATION: float = 4 ## Vertical spacing between cards.

var up: int = -1 : set = _set_up



# display

func _order_cards() -> void:
	for i: int in cards.size():
		_tween_card(cards[i], Vector2(0, CARD_SEPARATION * i * up), 0)


func _set_up(value: int) -> void:
	up = value
	_order_cards()
