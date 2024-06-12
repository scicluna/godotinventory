extends Area3D

# This is the hitbox node script

@onready var collision_shape := $HitBoxShape

func update_area(area_dict: Dictionary):
	var shape = BoxShape3D.new()
	shape.extents = Vector3(area_dict.x, area_dict.y, area_dict.z)
	collision_shape.shape = shape
	collision_shape.position = Vector3(area_dict.x-(area_dict.x-1), 0, 0)
	
func check_collision():
	return get_overlapping_bodies().size() > 0

func record_hit(damage: int):
	print("hitbox hit")
	for body in get_overlapping_bodies():
		print("Hit: %s" % body.name)
	
		if body.has_method("take_damage"):
			body.call("take_damage", damage)
