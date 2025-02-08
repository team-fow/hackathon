class_name Card
extends Control

const SIZE := Vector2(200, 300)

@export var card_resource: CardData

var card_script : Object

@onready var background: TextureRect = $Background
@onready var info: VBoxContainer = $Info
@onready var cardname: Label = $Info/CardName
@onready var art: TextureRect = $Info/Art
@onready var description: Label = $Info/Description


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var card = card_resource
	background.texture = card.background
	cardname.text = card.name
	art.texture = card.art
	description.text = card.description
	card_script = card.card_script.new()
	modulate = Color(randf(), randf(), randf()) # temp


func play():
	card_script.play()


func set_input(value: bool) -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP if value else Control.MOUSE_FILTER_IGNORE


func set_flipped(value: bool) -> void:
	info.visible = not value
	set_input(not value)
