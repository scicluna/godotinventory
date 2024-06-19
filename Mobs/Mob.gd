extends Node3D
class_name Mob

@export var health: int = 100
@export var max_health: int = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func take_damage(damage: int) -> void:
	health -= damage
	show_damage_number(damage)
	if health <= 0:
		queue_free()
		
func show_damage_number(damage: int) -> void:
	var damage_number = preload("res://UI/DamageNumbers.tscn").instantiate()
	damage_number.text = str(damage)
	
	var angle = randf() * 2 * PI  # Random angle in radians
	var radius = 0.5  # Distance from the center
	damage_number.position = Vector3(self. position.x + (cos(angle) * radius), self.position.y + .5, self.position.z + (sin(angle) * radius))
	
	get_parent().add_child(damage_number)
	pass
