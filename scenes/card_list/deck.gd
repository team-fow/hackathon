class_name Deck
extends CardList

const CARD_SEPARATION: float = 4 ## Vertical spacing between cards.



# display

func _order_cards() -> void:
	for i: int in cards.size():
		cards[i].position = Vector2(0, CARD_SEPARATION * -i)
