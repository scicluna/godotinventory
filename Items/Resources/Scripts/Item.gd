extends Node3D
class_name Item

@export_multiline var tooltip := "E"
var data: ItemData
var equipped := false

# Rotation speed in degrees per second
var rotation_speed: float = 45.0

func _ready():
	var interactable_area = InteractableWeapon.new()
	interactable_area.scale = Vector3(1.1, 1.1, 1.1)
	self.add_child(interactable_area)
	
	# Create a CollisionShape node
	var collision_shape = CollisionShape3D.new()
	
	# Create a BoxShape for the collision
	var box_shape = BoxShape3D.new()
	box_shape.size = Vector3(2, 1, 2) # Adjust size as needed
	
	# Set the shape of the CollisionShape node
	collision_shape.shape = box_shape
	
	# Add the CollisionShape to the InteractableWeapon
	interactable_area.add_child(collision_shape)

func _process(delta: float) -> void:
	if not equipped:
		rotation_degrees.y += rotation_speed * delta
