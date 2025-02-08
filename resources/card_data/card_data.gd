class_name CardData
extends Resource

@export var name : String = "Card"
@export var background : Texture2D = load("res://assets/card/backgrounds/sample.png")
@export_multiline var description : String = "Description"
@export var card_script : GDScript = load("res://resources/card_behavior/card_behavior.gd")
