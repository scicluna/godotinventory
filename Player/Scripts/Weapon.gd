# node should be a child of your 3d camera

extends Node3D
class_name WeaponLayer

@onready var weapon_arm := $WeaponArm
@onready var animation_player := $WeaponAnimations
@onready var hit_box := $HitBox
@onready var cooldown_timer := $CooldownTimer

var weapon: WeaponData

func equip_weapon(weapon_data: WeaponData):
	# Clear Old Weapon
	var old_weapon_node = get_node_or_null("Weapon")
	if old_weapon_node:
		old_weapon_node.queue_free()  # Remove the old weapon node
		weapon = null
	
	# Equip New Weapon
	if weapon_data:
		weapon = weapon_data
		var new_weapon_instance = weapon.item_texture.instantiate()
		new_weapon_instance.name = "Weapon"
		new_weapon_instance.equipped = true
		weapon_arm.add_child(new_weapon_instance)
		
		cooldown_timer.wait_time = weapon.attack_speed
		hit_box.update_range(weapon.attack_range)

func stop():
	animation_player.stop()

func weapon_attack(total_player_stats):
	if cooldown_timer.is_stopped():
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
	
		if hit_box:
			hit_box.enabled = true
			hit_box.check_hit(weapon.attack_damage)
	
		cooldown_timer.start()  # Start cooldown timer
			
	
func weapon_parry(total_player_stats):
	pass

