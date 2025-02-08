class_name CardData
extends Resource

@export var name : String
@export var background : Texture2D
@export var art : Texture2D
@export_multiline var description : String
@export var card_script : GDScript = load("res://resources/card_behavior/card_behavior.gd")
