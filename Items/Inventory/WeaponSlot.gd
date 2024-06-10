extends InventorySlot
class_name WeaponSlot

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

# Hooks up to the player and changes their equipped weapon
func equip_item(new_item: Variant) -> void:
	print("EQUIP ITEM: ", new_item)
	var player := self.get_owner().get_owner()
	
	if new_item != null and new_item.data is WeaponData:
		player.equip_weapon(new_item.data)
	else:
		player.equip_weapon(new_item)
