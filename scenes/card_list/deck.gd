class_name Deck
extends CardList

const CARD_SEPARATION: float = 4



# display

func _order_cards() -> void:
	for i: int in cards.size():
		cards[i].position.y = CARD_SEPARATION * -i
