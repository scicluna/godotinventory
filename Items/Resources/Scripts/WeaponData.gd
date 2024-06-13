extends ItemData
class_name WeaponData

enum weapon_type {
	DAGGER,
	SWORD,
	HAMMER
}

@export var attack_damage: int
@export var attack_speed: float
@export var attack_range: float
@export var attack_area := { "x": 0.0, "y": 0.0, "z": 0.0}
@export var weapon_category: weapon_type

func hotbar_action(player: Player):
	print("Player tries to equip me on the hotbar!")
	player.equip_weapon(self)
