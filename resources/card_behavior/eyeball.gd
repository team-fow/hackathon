extends CardBehavior
var element


func play(game: Node):
	super(game)
	var player = card.player
	var opponent = game.get_opponent(card.player)
	var scale = card.scale.x
	var tween = game.get_tree().create_tween() 
	tween.tween_property(card, "scale:x", 0, 0.3)
	await tween.finished
	if player.temperature < 0:
		element = CardData.Element.COLD
		card.background.texture = load("res://assets/card/back/cold_climate.png")
	elif player.temperature > 0:
		element = CardData.Element.HEAT
		card.background.texture = load("res://assets/card/back/hot_climate.png")
	else:
		element = CardData.Element.NEUTRAL
	tween = game.get_tree().create_tween()
	tween.tween_property(card, "scale:x", scale, 0.3)
	await tween.finished
	player.card_played.create_particles(element)
	await game.get_tree().create_timer(0.5).timeout
	
