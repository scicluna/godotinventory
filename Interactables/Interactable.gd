# InteractableComponent.gd
extends Area3D
class_name Interactable

@export_multiline var tooltip: String = "E"

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		print("body entered")
		body.interactor.add_nearby_interactable(self)

func _on_body_exited(body: Node3D) -> void:
	if body is Player:
		print("body exited")
		body.interactor.remove_nearby_interactable(self)

func interact(body: Node3D) -> void:
	if body is Player:
		print(body)
	print("interacted")
	
	#implement interacted behavior
