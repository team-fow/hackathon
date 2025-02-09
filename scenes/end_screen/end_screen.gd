extends TextureRect

@onready var win_label: Label = $HBoxContainer/VBoxContainer/WinLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var cardplayedgrid: GridContainer = $HBoxContainer/VBoxContainer2/ScrollContainer/cardplayedgrid


func set_winner(winner: Player, loser: Player) -> void:
	win_label.text = winner.playername + " has defeated " + loser.oppname + "!"
	animation_player.play("fadein")
	
	$VBoxContainer/GridContainer/Label2.text = "%s won!" % winner.playername
	$VBoxContainer/GridContainer/Label3.text = "With a temperature of %s." % winner.temperature
	$VBoxContainer/GridContainer/Label4.text = "%s lost..." % loser.playername
	$VBoxContainer/GridContainer/Label5.text = "With a temperature of %s." % loser.temperature


func load_card_grid(cardlist : Array[CardData]) -> void:
	cardplayedgrid.add_cards(cardlist)


func _on_button_pressed() -> void:
	get_tree().reload_current_scene()
