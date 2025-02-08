extends CardBehavior


func play(game: Node) -> void:
	super(game)
	for i: int in 2:
		var card = load("res://scenes/card/card.tscn").instantiate()
		card.card_resource = load("res://resources/card_data/meta/dud.tres")
		game.get_opponent(card.player)._send_card_to_hand(card) 
