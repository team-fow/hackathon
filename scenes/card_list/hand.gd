class_name Hand
extends CardList

const CARD_SEPARATION: float = Card.SIZE.x / 2
const MAX_CARD_Y_OFFSET: float = Card.SIZE.y / 2
const MAX_CARD_ROTATION: float = PI / 4



# display

func _order_cards() -> void:
	var width: float = CARD_SEPARATION * (cards.size() - 1)
	var left: float = -width / 2
	var half_count: float = (cards.size() - 1) / 2.0
	
	for i: int in cards.size():
		var percent: float = (i - half_count) / cards.size()
		cards[i].position.x = left + CARD_SEPARATION * i
		cards[i].position.y = abs(percent) * MAX_CARD_Y_OFFSET
		cards[i].rotation = percent * MAX_CARD_ROTATION


func _remove_card_from_list(card: Card) -> void:
	super(card)
	card.rotation = 0
