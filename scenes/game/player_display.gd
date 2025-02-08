extends HBoxContainer

@export var player: Player

@onready var temperature_label: Label = $Temperature


func _ready() -> void:
	player.temperature_changed.connect(_on_temperature_changed)


func _on_temperature_changed(value: int) -> void:
	temperature_label.text = str(value)
