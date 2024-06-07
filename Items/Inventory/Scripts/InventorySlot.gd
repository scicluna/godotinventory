extends PanelContainer
class_name InventorySlot

@export var type: ItemData.ItemType

func init(item_type: ItemData.ItemType, custom_min_size: Vector2) -> void:
	type = item_type
	self.custom_minimum_size = custom_min_size
	
func _can_drop_data(_at_position: Vector2, item: Variant) -> bool:
	if item is InventoryItem:
		if type == ItemData.ItemType.MAIN:
			if self.get_child_count() == 0:
				return true
			else:
				if type == item.get_parent().type:
					return true
				return self.get_child(0).data.ItemType == item.data.ItemType
		else:
			return item.data.item_type == type
	return false

# handle drop signal
func _drop_data(_at_position: Vector2, new_item: Variant) -> void:
	
	# if this slot is occupied...
	if self.get_child_count() > 0:
		
		# record the current item
		var my_item := self.get_child(0)

		# if they are the same, do nothing
		if my_item == new_item:
			return
			
		# swap items
		my_item.reparent(new_item.get_parent())
		
		# if this slot is not in the main inventory... or the former slot was not in the main inventory...
		if type != ItemData.ItemType.MAIN or my_item.data.item_type != ItemData.ItemType.MAIN:
			# Function to handle equipment changes
			# Something like change_equipment(player, new_item, my_item)
			pass
	
	new_item.reparent(self)
