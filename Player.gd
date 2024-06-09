extends CharacterBody3D


# speed consts
const MAX_SPEED = 8.0
const BACKPEDAL_SPEED = 3.0
const ACCELERATION = 20.0
const DECELERATION = 20.0
const gravity = 12.50

# jump consts
const AIR_DECELERATION = 8.0
const JUMP_VELOCITY = 6

@onready var neck := $Neck
@onready var camera := $Neck/Camera3D

var dashing = false

# dependencies (plug in modules)
@onready var inventory = $Inventory
@onready var movement_abilities: Array[Movement] = []

var base_stats := {
	"STR": 0,
	"AGI": 0,
	"STA": 0,
	"INT": 0
}

var bonus_stats := {
	"STR": 0,
	"AGI": 0,
	"STA": 0,
	"INT": 0
}

var equipped_weapon: WeaponData
var equipped_head: EquipmentData
var equipped_chest: EquipmentData
var equipped_legs: EquipmentData
var equipped_feet: EquipmentData
var equipped_accessory: EquipmentData

func _ready():
	# Placeholder Movement Ability Granted
	# Will eventually need to obtain this in game
	var dash_ability = load("res://Movement/Techniques/Dash.tscn")
	if dash_ability:
		dash_ability = dash_ability.instantiate()
	else:
		print("Failed to load dash ability")
	add_child(dash_ability)
	movement_abilities.append(dash_ability)

func _physics_process(delta):
	for ability in movement_abilities:
		ability.apply_movement(self, delta)
	apply_gravity(delta)
	handle_jump()
	handle_movement(delta)
	cap_speed()
	move_and_slide()
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and not inventory.visible:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			neck.rotate_y(-event.relative.x * 0.01)
			camera.rotate_x(-event.relative.y * 0.01)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-80), deg_to_rad(80))
			
	#if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not inventory_open:
		#if event.pressed:
			#if weapon_arm.current_weapon:
				#weapon_arm.current_weapon.attack(null)  # Pass in player stats if necessary
			#else:
				#if weapon_arm.current_weapon:
					#weapon_arm.current_weapon.stop()
			
	#if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and not inventory_open:
		#if event.pressed:
			#if weapon_arm.current_weapon:
				#weapon_arm.current_weapon.parry()
		#else:
			#if weapon_arm.current_weapon:
				#weapon_arm.current_weapon.stop()
				
	for ability in movement_abilities:
		ability.process_input(self, get_process_delta_time())
	
func apply_gravity(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

func handle_jump():
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

func handle_movement(delta):
	var input_dir = Input.get_vector("strafe_left", "strafe_right", "move_forward", "move_backward")
	var direction = (neck.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction.length() > 1:
		direction = direction.normalized()

	var deceleration = DECELERATION if is_on_floor() else AIR_DECELERATION
	if not dashing:
		if direction:
			var target_speed = BACKPEDAL_SPEED if input_dir.y > 0 else MAX_SPEED
			velocity.x = move_toward(velocity.x, direction.x * target_speed, ACCELERATION * delta)
			velocity.z = move_toward(velocity.z, direction.z * target_speed, ACCELERATION * delta)
		else:
			velocity.x = move_toward(velocity.x, 0, deceleration * delta)
			velocity.z = move_toward(velocity.z, 0, deceleration * delta)

func cap_speed():
	if not dashing:
		var horizontal_speed = Vector3(velocity.x, 0, velocity.z).length()
		if horizontal_speed > MAX_SPEED:
			var speed_ratio = MAX_SPEED / horizontal_speed
			velocity.x *= speed_ratio
			velocity.z *= speed_ratio
