class_name Player
extends Node2D

signal died

@export_range(-10, 10) var temperature : int

@onready var hand: Hand = $Hand


# Checks whether the player's temperature is at an extreme
func check_temperature() -> bool:
	if temperature < -10 or temperature > 10:
		died.emit()
		return true
	return false
