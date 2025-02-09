extends GridContainer


func add_cards(cardlist : Array[CardData]) -> void:
	for card in cardlist:
		var cardobject = load("res://scenes/card/card.tscn").instantiate()
		cardobject.card_resource = card
		cardobject.custom_minimum_size = cardobject.get_child(0).size
		add_child(cardobject)
