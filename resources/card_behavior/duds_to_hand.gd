extends CardBehavior


func play(game: Node) -> void:
	super(game)
	for i: int in 2:
		var card = load("res://scenes/card/card.tscn").instantiate()
		card.card_resource = load("res://resources/card_data/meta/dud.tres")
		game.get_opponent(card.player).hand.add_card(card) 
		game.get_opponent(card.player).deck.shuffle()
