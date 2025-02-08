class_name ClimateCardData
extends CardData

@export_enum("heat_bonus", "heat_multipler", "cold_bonus", "cold_multiplier", "reverse") var effect: String = "heat_bonus"
@export var value: int
@export var duration: int
