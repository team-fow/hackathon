extends CardBehavior


func play(game: Node) -> void:
	super(game)
	for i: int in 2:
		var dud = load("res://resources/card_data/meta/dud.tres")
		var card = load("res://scenes/card/card.tscn")
		card.card_resource = dud
		card = card.instantiate()
		game.get_opponent(card.player).deck.add_card(card) 
