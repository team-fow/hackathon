class_name Card
extends Control

const SIZE := Vector2(200, 300)

@export var card_resource: CardData

var card_script: CardBehavior
var player: Player
var tween: Tween

@onready var background: TextureRect = $Panel/Background
@onready var info: VBoxContainer = $Panel/Margins/VBox
@onready var cardname: Label = $Panel/Margins/VBox/Name
@onready var description: Label = $Panel/Margins/VBox/Description


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var card = card_resource
	background.texture = card.front
	cardname.text = card.name
	description.text = card.description
	card_script = card.card_script.new()
	card_script.card = self


func play(game: Node):
	await card_script.play(game)


func set_input(value: bool) -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP if value else Control.MOUSE_FILTER_IGNORE


func set_flipped(value: bool) -> void:
	info.visible = not value
	background.texture = card_resource.back if value else card_resource.front
	set_input(not value)
