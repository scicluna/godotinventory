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
@export var stats = {
	"STR": 0,
	"AGI": 0,
	"STA": 0,
	"INT": 0,
	"CHA": 0
}

@export var movement_abilities: Array[PackedScene] # Movement Scenes as Packed Scenes
@export var combat_abilities: Array[PackedScene] # Abilities as Packed Scenes

# Challenge for Later
#@export var ability_added:
#@export var movement_added:
func hotbar_action(player: Player) -> void:
	print("Player tries to equip me on the hotbar!")
	player.quick_equip(self)
