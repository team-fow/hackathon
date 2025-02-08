class_name CardList
extends Node2D
## A list of [Card] nodes.

var cards: Array[Card] ## All cards stored in this list.



# modifying list

## Adds a card at index [member idx].
func add_card(card: Card, idx: int = -1) -> void:
	if idx == -1:
		_add_card_to_list(card, cards.size())
		add_child(card)
	else:
		_add_card_to_list(card, idx)
		cards[idx - 1].add_sibling(card)


## Removes a card.
func remove_card(card: Card) -> void:
	_remove_card_from_list(card)
	remove_child(card)


# Adds a card to cards at index idx. Does not add it as a child.
func _add_card_to_list(card: Card, idx: int) -> void:
	cards.insert(idx, card)
	_order_cards()


# Removes a card from cards. Does not remove it as a child.
func _remove_card_from_list(card: Card) -> void:
	cards.erase(card)
	_order_cards()



# display

## Overwrite this to control how cards in [member cards] are displayed.
func _order_cards() -> void:
	pass
