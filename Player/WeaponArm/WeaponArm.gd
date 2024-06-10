# node should be a child of your 3d camera

extends Node3D
class_name WeaponArm

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
		self.add_child(new_weapon_instance)
