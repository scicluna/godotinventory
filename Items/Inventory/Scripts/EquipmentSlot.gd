extends InventorySlot
class_name EquipmentSlot

@export var equipment_type: EquipmentData.EquipmentType

func drop_is_valid(dragged_item: Variant) -> bool:
	if dragged_item is InventoryItem:
		if type == ItemData.ItemType.MAIN:
			if self.get_child_count() == 0:
				return true
			else:
				if type == dragged_item.get_parent().type:
					return true
				return self.get_child(0).data.ItemType == dragged_item.data.ItemType
		else:
			return dragged_item.data.item_type == type
	return false

# Hooks up to the player and updates their stats
func equip_item(new_item: Variant) -> void:
	var player := self.get_owner().get_owner()
	
	match equipment_type:
		EquipmentData.EquipmentType.HEAD:
			player.equipped_head = new_item.data
		EquipmentData.EquipmentType.CHEST:
			player.equipped_chest = new_item.data
		EquipmentData.EquipmentType.LEGS:
			player.equipped_legs = new_item.data
		EquipmentData.EquipmentType.FEET:
			player.equipped_feet = new_item.data
		EquipmentData.EquipmentType.ACCESSORY:
			player.equipped_accessory = new_item.data

	# Optionally, update player stats or any other relevant information
	# For example:
	# player.update_stats()

	print(player.bonus_stats)
