class_name CardPlayed
extends CardList

signal send_to_hand(card)

const MAX_FAN_ROTATION: float = PI / 8 ## Maximum rotation for fanning.
const MAX_FAN_OFFSET: float = Card.SIZE.y / 4 ## Maximum vertical offset for fanning.
const HOVERED_CARD_SCALE := Vector2(1.2, 1.2) ## Scaling applied to the currently hovered card.
const TWEEN_DURATION: float = 0.1 ## Duration of tweening effects.

var accepting_card = true


func _on_card_moused(card: Card, mouse_inside: bool) -> void:
	card.z_index = mouse_inside
	card.scale = HOVERED_CARD_SCALE if mouse_inside else Vector2.ONE


func add_card(card: Card, idx: int = -1) -> void:
	super(card, idx)
	card.gui_input.connect(_on_card_input.bind(card))
	card.mouse_entered.connect(_on_card_moused.bind(card, true))
	card.mouse_exited.connect(_on_card_moused.bind(card, false))
	accepting_card = false


func remove_card(card: Card) -> void:
	super(card)
	accepting_card = true

# Handles grabbing cards.
func _on_card_input(event: InputEvent, card: Card) -> void:
	if event.is_action_pressed("click"):
		remove_card(card)
		send_to_hand.emit(card)
		
		
# Smoothly animates positioning and rotating a card.
func _tween_card(card: Card, pos: Vector2, rot: float) -> void:
	var tween: Tween = get_tree().create_tween().set_parallel().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(card, "position", pos, TWEEN_DURATION)
	tween.tween_property(card, "rotation", rot, TWEEN_DURATION)
	await tween.finished
