extends Node3D
class_name Item

var data: ItemData
var equipped := false

# Rotation speed in degrees per second
var rotation_speed: float = 45.0

func _process(delta: float) -> void:
	if not equipped:
		rotation_degrees.y += rotation_speed * delta
