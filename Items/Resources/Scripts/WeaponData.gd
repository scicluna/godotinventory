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
@export var weapon_category: weapon_type
