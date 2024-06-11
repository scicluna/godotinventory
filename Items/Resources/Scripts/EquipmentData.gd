extends ItemData
class_name EquipmentData

enum EquipmentType {
	HEAD,
	CHEST,
	LEGS,
	FEET,
	ACCESSORY
}

@export var equipment_type: EquipmentType
@export var str_change: int
@export var agi_change: int
@export var sta_change: int
@export var int_change: int
@export var movement_abilities: Array[PackedScene] # Movement Scenes as Packed Scenes
@export var combat_abilities: Array[PackedScene] # Abilities as Packed Scenes

# Challenge for Later
#@export var ability_added:
#@export var movement_added:
