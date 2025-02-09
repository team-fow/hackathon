extends TextureRect

@onready var win_label: Label = $HBoxContainer/VBoxContainer/WinLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var cardplayedgrid: GridContainer = $HBoxContainer/VBoxContainer2/ScrollContainer/cardplayedgrid



func set_winner(playername : String, oppname : String) -> void:
	win_label.text = playername + " has defeated " + oppname + "!"
	animation_player.play("fadein")


func load_card_grid(cardlist : Array[CardData]) -> void:
	cardplayedgrid.add_cards(cardlist)
