extends TextureRect

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func set_winner(winner: Player, loser: Player) -> void:
	animation_player.play("fadein")
	
	if abs(winner.temperature) > 10 and abs(loser.temperature) > 10:
		$VBoxContainer/GridContainer/Label2.text = "%s lost..." % winner.player_name
		$VBoxContainer/GridContainer/Label3.text = "With a temperature of %s." % winner.temperature
		$VBoxContainer/GridContainer/Label4.text = "%s llost..." % loser.player_name
		$VBoxContainer/GridContainer/Label5.text = "With a temperature of %s." % loser.temperature
		
		if randf() > 0.5: $Hot.show()
		else: $Cold.show()
	else:
		$VBoxContainer/GridContainer/Label2.text = "%s won!" % winner.player_name
		$VBoxContainer/GridContainer/Label3.text = "With a temperature of %s." % winner.temperature
		$VBoxContainer/GridContainer/Label4.text = "%s lost..." % loser.player_name
		$VBoxContainer/GridContainer/Label5.text = "With a temperature of %s." % loser.temperature
		
		if loser.temperature > 0:
			$Hot.show()
		else:
			$Cold.show()


func _on_button_pressed() -> void:
	get_tree().reload_current_scene()
