extends ColorRect

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func fadein():
	animation_player.play("fadein")
	mouse_filter = MOUSE_FILTER_STOP
	

func fadeout():
	animation_player.play("fadeout")
	mouse_filter = MOUSE_FILTER_IGNORE


func _ready() -> void:
	show()
