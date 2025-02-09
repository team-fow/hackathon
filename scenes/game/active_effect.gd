extends PanelContainer

@export var card_resource: ClimateCardData
@onready var effect_name: Label = $VBox/EffectName
@onready var effect_description: Label = $VBox/EffectDescription


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	effect_name.text = card_resource.name
	effect_description.text = card_resource.description
	print(effect_name)
