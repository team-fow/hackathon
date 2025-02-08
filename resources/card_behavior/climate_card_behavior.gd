class_name ClimateCardBehavior
extends CardBehavior

var game: Game


func play(game: Node) -> void:
	self.game = game
	
	if card.effect == "reverse": game.reverse = card.value
	else: game[card.effect] += card.value
	
	await wait_rounds(card.duration)
	
	if card.effect == "reverse": game.reverse = 0
	else: game[card.effect] -= card.value


func wait_rounds(rounds: int) -> void:
	for i: int in rounds:
		await game.round_ended
