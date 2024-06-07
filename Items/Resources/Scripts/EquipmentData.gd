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

# Challenge for Later
#@export var ability_added:
#@export var movement_added:
