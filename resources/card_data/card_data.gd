class_name CardData
extends Resource

@export var name : String = "Card"
@export var front : Texture2D = load("res://assets/card/backgrounds/fish_dud.png")
@export var back : Texture2D = load("res://assets/card/backgrounds/fish_dud.png")
@export_multiline var description : String = "Description"
@export var card_script : GDScript = load("res://resources/card_behavior/card_behavior.gd")
