extends RayCast3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func update_range(range: float) -> void:
	set_target_position(Vector3(0, 0, -range))

func check_collision() -> bool:
	force_raycast_update()
	return is_colliding()

func record_hit(damage) -> void:
	print("ray hit")
	var collider = get_collider()
	if collider:
		# Apply damage or other effects to the collider
		print("Hit: %s" % collider.name)
		# Assuming the collider has a method to receive damage
		if collider.has_method("take_damage"):
			collider.call("take_damage", damage)
	else:
		print("No hit detected")
