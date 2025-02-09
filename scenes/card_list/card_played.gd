@tool
class_name CardPlayed
extends CardList

signal send_to_hand(card)

const MAX_FAN_ROTATION: float = PI / 8 ## Maximum rotation for fanning.
const MAX_FAN_OFFSET: float = Card.SIZE.y / 4 ## Maximum vertical offset for fanning.
const HOVERED_CARD_SCALE := Vector2(1.2, 1.2) ## Scaling applied to the currently hovered card.

@onready var cloud_particles: GPUParticles2D = $Clouds
@onready var heat_particles: GPUParticles2D = $Heat
@onready var cold_particles: GPUParticles2D = $Cold

var accepting_card = true


func _on_card_moused(card: Card, mouse_inside: bool) -> void:
	card.z_index = mouse_inside
	card.scale = HOVERED_CARD_SCALE if mouse_inside else Vector2.ONE


func add_card(card: Card, idx: int = -1) -> void:
	super(card, idx)
	accepting_card = false
	create_particles(card.card_resource.element)


func create_particles(element : CardData.Element) -> void:	
	match element:
		CardData.Element.HEAT:
			cloud_particles.modulate = Color("#fa3e16bf")
			heat_particles.restart()
			SFX.play("heat")
		CardData.Element.COLD:
			cloud_particles.modulate = Color("4797d2bf")
			cold_particles.restart()
			SFX.play("cold")
		CardData.Element.NEUTRAL:
			cloud_particles.modulate = Color("#ded56bbf")
			SFX.play("neutral")
	cloud_particles.restart()


func remove_card(card: Card) -> void:
	super(card)
	accepting_card = true
