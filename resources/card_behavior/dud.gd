extends CardBehavior


func play(game: Node) -> void:
	pass


func _init() -> void:
	_init_deferred.call_deferred()


func _init_deferred() -> void:
	card.card_resource.description = [
		"Sorry.",
		"My bad.",
		"Coming through!",
		"Excuse me...",
		"Loser.",
		"Sorry!",
		"Just passing through...",
		"Off to the great discard pile in the sky!",
	].pick_random()
