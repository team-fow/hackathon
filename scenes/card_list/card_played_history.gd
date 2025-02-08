class_name CardPlayedHistory
extends Deck

var flipped


func _set_flipped(value: bool) -> void:
	flipped = value
	for card: Card in cards:
		card.set_flipped(value)
