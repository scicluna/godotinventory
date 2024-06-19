# res://UI/DamageNumber.gd
extends Label3D

@export var rise_duration: float = .5
@export var rise_distance: float = .4
@export var pop_scale: float = 1.5
@export var pop_duration: float = 0.15

func _ready() -> void:
	# Start with the pop animation
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector3.ONE * pop_scale, pop_duration).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector3.ONE, pop_duration).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	tween.connect("finished", Callable(self, "_on_pop_finished"))

func _on_pop_finished():
	# Start the rise and fade animation after the pop effect
	var tween = create_tween()
	tween.tween_property(self, "position", Vector3(position.x, position.y + rise_distance, position.z), rise_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "modulate", Color(modulate.r, modulate.g, modulate.b, 0), rise_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.connect("finished", Callable(self, "_on_tween_finished"))

func _on_tween_finished() -> void:
	queue_free()
