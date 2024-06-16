extends CharacterBody3D
class_name Player

# speed consts
const MAX_SPEED = 8.0
const BACKPEDAL_SPEED = 3.0
const ACCELERATION = 20.0
const DECELERATION = 20.0
const gravity = 12.50

# jump consts
const AIR_DECELERATION = 8.0
const JUMP_VELOCITY = 6

# camera nodes
@onready var neck := $Neck
@onready var camera := $Neck/Camera3D

# dependencies (plug in modules)
@onready var inventory = $Inventory
@onready var hotbar = $Inventory/InventoryUI/UIControl/HotBar/GridContainer
@onready var weapon_layer = $Neck/Camera3D/WeaponLayer
@onready var interactor = $Interactor

# movement flags
var dashing = false

# player stats
@export var player_resources: PlayerResources
@export var player_stats: PlayerStats

# abilities
var movement_abilities: Array[Movement]

# start logic
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
	if event is InputEventMouseButton and event.pressed and not inventory.inventory_ui.visible:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			neck.rotate_y(-event.relative.x * 0.01)
			camera.rotate_x(-event.relative.y * 0.01)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-80), deg_to_rad(80))
			
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not inventory.inventory_ui.visible:
		if event.pressed:
			if weapon_layer.weapon:
				weapon_layer.weapon_attack(null)  # Pass in player stats if necessary
			else:
				if weapon_layer.weapon:
					weapon_layer.stop()
			
	#if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and not inventory_open:
		#if event.pressed:
			#if weapon_arm.current_weapon:
				#weapon_arm.current_weapon.parry()
		#else:
			#if weapon_arm.current_weapon:
				#weapon_arm.current_weapon.stop()
				
	# hotbar actions
	for child in hotbar.get_children():
		if Input.is_action_just_pressed(child.name):
			if child.slot_item:
				if not inventory.swapping and not inventory.dragging_item:
					child.slot_item.data.hotbar_action(self)
				
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

func equip_weapon(new_weapon: WeaponData):
	weapon_layer.equip_weapon(new_weapon)

# Your update_equipment_stats function in the Player or Inventory script:
func update_equipment_stats():
	var slots = inventory.equipment_grid.get_children()
	
	# Reset equip_stats to 0
	for key in player_stats.equip_stats.keys():
		player_stats.equip_stats[key] = 0
	
	# Loop through equipment slots and accumulate stats
	for slot in slots:
		var item = slot.get_slot_item()
		if item:
			for key in player_stats.equip_stats.keys():
				player_stats.equip_stats[key] += item.data.stats[key]
					
	# Update total_stats
	player_stats.update_total_stats()
	
func unequip_weapon():
	print("unequipped weapon")

func receive_damage(damage: int) -> void:
	# var modified_damage = modified_damage(damage)
	player_resources.take_damage(damage)

