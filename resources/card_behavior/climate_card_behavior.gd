class_name ClimateCardBehavior
extends CardBehavior


func play(game: Node) -> void:
	self.game = game
	
	var res: CardData = card.card_resource
	
	game.active_effects.append(res)
	if res.effect == "reverse": game.reverse = res.value
	else: game[res.effect] += res.value
	
	await wait_rounds(res.duration)
	
	if res.effect == "reverse": game.reverse = 0
	else: game[res.effect] -= res.value
	game.active_effects.erase(res)


func wait_rounds(rounds: int) -> void:
	for i: int in rounds:
		await game.round_ended
