# node should be a child of your 3d camera

extends Node3D
class_name WeaponLayer

@onready var weapon_arm := $WeaponArm
@onready var animation_player := $WeaponAnimations
@onready var hit_box := $HitBox
@onready var hit_ray := $HitRay
@onready var cooldown_timer := $CooldownTimer

var weapon: WeaponData
var is_parrying = false

func _process(delta):
	#if is_parrying and hit_box.check_parry():
		#print("Parry successful!")
		## Logic for successful parry, e.g., setting up counter-attack
		## You can adjust player's stats or other game mechanics here
	#else:
		#print("Parry failed!")
	pass

func equip_weapon(weapon_data: WeaponData):
	# Clear Old Weapon
	var current_weapon = weapon_arm.get_children()
	for child in current_weapon:
		child.queue_free()
		
	# Equip New Weapon
	if weapon_data:
		weapon = weapon_data
		var new_weapon_instance = weapon.item_texture.instantiate()
		new_weapon_instance.equipped = true
		weapon_arm.add_child(new_weapon_instance)
		
		cooldown_timer.wait_time = weapon.attack_speed
		hit_box.update_area(weapon.attack_area)
		hit_ray.update_range(weapon.attack_range)


func stop():
	animation_player.stop()

func weapon_attack(total_player_stats):	
	if cooldown_timer.is_stopped() and not is_parrying:
		match weapon.weapon_category:
			WeaponData.weapon_type.DAGGER:
				if animation_player.has_animation("dagger_attack_1"): animation_player.play("dagger_attack_1")
			WeaponData.weapon_type.SWORD:
				pass
			WeaponData.weapon_type.HAMMER:
				pass
			_:
				print("error - bad weapon type")
			
		# var damage := calculate_damage(total_player_stats)
	
		if hit_box.check_collision():
			hit_box.record_hit(weapon.attack_damage)
		elif hit_ray.check_collision():
			hit_ray.record_hit(weapon.attack_damage)
		else:
			print("Miss")
	
		cooldown_timer.start()  # Start cooldown timer
			
	
func weapon_parry_start():
	if cooldown_timer.is_stopped():
		is_parrying = true
		stop()  # Stop any current animations
		match weapon.weapon_category:
			WeaponData.weapon_type.DAGGER:
				if animation_player.has_animation("dagger_parry_1"): animation_player.play("dagger_parry_1")
			WeaponData.weapon_type.SWORD:
				if animation_player.has_animation("sword_parry"): animation_player.play("sword_parry")
			WeaponData.weapon_type.HAMMER:
				if animation_player.has_animation("hammer_parry"): animation_player.play("hammer_parry")
			_:
				print("error - bad weapon type")

func weapon_parry_stop():
	is_parrying = false
	animation_player.stop()  # Stop parry animation
	cooldown_timer.start()  # Start cooldown timer

func calculate_damage(total_player_stats):
	pass
