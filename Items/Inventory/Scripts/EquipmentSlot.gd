extends InventorySlot
class_name EquipmentSlot

@export var equipment_type: EquipmentData.EquipmentType

func _can_drop_item(_at_position: Vector2, item: Variant) -> bool:
	if item is InventoryItem and item.equipment_type == equipment_type:
		if type == ItemData.ItemType.MAIN:
			if self.get_child_count() == 0:
				return true
			else:
				if type == item.get_parent().ItemType:
					return true
				return self.get_child(0).data.ItemType == item.data.ItemType
		else:
			return item.data.ItemType == type
	return false
