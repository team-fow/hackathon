class_name ClimateCardBehavior
extends CardBehavior


func play(game_node: Node) -> void:
	game = game_node
	
	var res: CardData = card.card_resource
	
	match res.player_affected:
		0:
			card.player.active_effects.append(res)
			card.player[res.effect] += res.value
			await wait_rounds(res.duration)
			card.player[res.effect] -= res.value
			card.player.active_effects.erase(res)
		1:	
			game.get_opponent(card.player).active_effects.append(res)
			game.get_opponent(card.player)[res.effect] += res.value
			await wait_rounds(res.duration)
			game.get_opponent(card.player)[res.effect] -= res.value
			game.get_opponent(card.player).active_effects.erase(res)
		_: 
			if res.effect == "reverse": game.reverse = res.value
			else: game[res.effect] += res.value
			
			card.player.active_effects.append(res)
			game.get_opponent(card.player).active_effects.append(res)
			
			await wait_rounds(res.duration)
			
			card.player.active_effects.erase(res)
			game.get_opponent(card.player).active_effects.erase(res)
			
			if res.effect == "reverse": game.reverse = 0
			else: game[res.effect] -= res.value


func wait_rounds(rounds: int) -> void:
	for i: int in rounds:
		await game.round_ended
