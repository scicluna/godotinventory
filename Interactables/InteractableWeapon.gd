extends Interactable
class_name InteractableWeapon

@onready var item_data = get_parent().data

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		if not self.get_parent().equipped:
			print("body entered")
			body.interactor.add_nearby_interactable(self)

func _on_body_exited(body: Node3D) -> void:
	if body is Player:
		if not self.get_parent().equipped:
			print("body exited")
			body.interactor.remove_nearby_interactable(self)

func interact(body: Node3D) -> void:
	print("interacted")
	body.inventory.add_item(item_data, 1)
	self.get_parent().queue_free()
