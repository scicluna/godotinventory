extends Node3D
class_name Interactor

@onready var hovering_tooltip = $InteractionLayer/Tooltip

# Make it so player can pick up something. Okay?

@onready var player := get_parent()
var nearby_interactables: Array[Interactable] = []

func interact_with_nearest():
	if nearby_interactables.size() > 0:
		var nearest = nearby_interactables[0]  # Assuming the nearest is the first in the list (bad assumption?)
		nearest.interact(player)

func add_nearby_interactable(interactable):
	if not nearby_interactables.has(interactable):
		nearby_interactables.append(interactable)
		update_tooltip()

func remove_nearby_interactable(interactable):
	if nearby_interactables.has(interactable):
		nearby_interactables.erase(interactable)
		update_tooltip()
		
func update_tooltip():
	if nearby_interactables.size() > 0:
		hovering_tooltip.text = nearby_interactables[0].get_parent().tooltip
		hovering_tooltip.visible = true
		print("show tooltip")
	else:
		print("hide tooltip")
		hovering_tooltip.visible = false
		
func _input(event: InputEvent) -> void:
		if event is InputEventKey and event.is_action_pressed("interact"):
			if event.pressed:
				interact_with_nearest()
