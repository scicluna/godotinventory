extends Movement
class_name Dash

const DASH_SPEED = 25.0
const DASH_COOLDOWN = 0.4
const DASH_DURATION = 0.2
const DOUBLE_TAP_TIME = 0.2

var dash_time_left = 0.0
var dash_direction = Vector3.ZERO

var last_tap_times = {
	"move_forward": 0.0,
	"move_backward": 0.0,
	"strafe_left": 0.0,
	"strafe_right": 0.0
}

@onready var dash_timer = $DashTimer
@onready var dash_cooldown_timer = $DashCooldown
@onready var dash_effect = $Dash_Blur
@onready var dash_sound = $DashSound

func _ready():
	dash_timer.connect("timeout", Callable(self, "_on_DashTimer_timeout"))

func process_input(player, delta):
	var current_time = Time.get_ticks_msec() / 1000.0
	for key in last_tap_times.keys():
		if Input.is_action_just_pressed(key):
			if current_time - last_tap_times[key] < DOUBLE_TAP_TIME:
				start_dash(player, key)
			last_tap_times[key] = current_time

func apply_movement(player, delta):
	if dash_time_left > 0:
		dash_time_left -= delta
		if dash_time_left <= 0:
			end_dash(player)
		player.velocity.x = dash_direction.x * DASH_SPEED
		player.velocity.z = dash_direction.z * DASH_SPEED

func start_dash(player, direction_key):
	if dash_cooldown_timer.is_stopped():
		reset_dash_timers()
		dash_cooldown_timer.start(DASH_COOLDOWN)
		dash_time_left = DASH_DURATION
		player.dashing = true
		dash_effect.material.set_shader_parameter("effect_intensity", 1.0)
		dash_sound.play()
		
		match direction_key:
			"move_forward":
				dash_direction = player.neck.transform.basis.z.normalized() * -1
			"move_backward":
				dash_direction = player.neck.transform.basis.z.normalized()
			"strafe_left":
				dash_direction = player.neck.transform.basis.x.normalized() * -1
			"strafe_right":
				dash_direction = player.neck.transform.basis.x.normalized()

func reset_dash_timers():
	for key in last_tap_times.keys():
		last_tap_times[key] = 0.0

func end_dash(player):
	player.dashing = false
	dash_timer.start(0.5)

func _on_DashTimer_timeout():
	var effect_intensity = dash_effect.material.get_shader_parameter("effect_intensity")
	if effect_intensity > 0.0:
		dash_effect.material.set_shader_parameter("effect_intensity", effect_intensity - 0.1)
		dash_timer.start(0.05)
	else:
		dash_effect.material.set_shader_parameter("effect_intensity", 0.0)
