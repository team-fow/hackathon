class_name CardData
extends Resource

enum Element {NEUTRAL, HEAT, COLD}

@export var name : String = "Card"
@export var front : Texture2D = load("res://assets/card/front/meta/dud.png")
@export var back : Texture2D = load("res://assets/card/back/dud.png")
@export_multiline var description : String = "Description"
@export var card_script : GDScript = load("res://resources/card_behavior/card_behavior.gd")

@export var element: Element
@export var changes_temperature: bool
