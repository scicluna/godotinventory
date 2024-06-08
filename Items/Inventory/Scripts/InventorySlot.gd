extends PanelContainer
class_name InventorySlot

@export var type: ItemData.ItemType
var slot_item: InventoryItem
var swapping := false

func init(item_type: ItemData.ItemType, custom_min_size: Vector2) -> void:
	type = item_type
	self.custom_minimum_size = custom_min_size
	
func _process(delta):
	if swapping and slot_item:
		slot_item.force_drag(slot_item, slot_item.make_drag_preview(Vector2(0,0)))
		
func _can_drop_data(_at_position, _data) -> bool:
	return true
	
func drop_is_valid(dragged_item: Variant) -> bool:
	if dragged_item is InventoryItem:
		if type == ItemData.ItemType.MAIN:
			if self.get_child_count() == 0:
				return true
			else:
				if dragged_item.get_parent() and type == dragged_item.get_parent().type:
					return true
				return self.get_child(0).data.ItemType == dragged_item.data.ItemType
		else:
			return dragged_item.data.item_type == type
	return false

# handle drop signal
func _drop_data(at_position: Vector2, dragged_item: Variant) -> void:

	if drop_is_valid(dragged_item):
		
		# if this slot is occupied...
		if self.get_child_count() > 0:

			# record the item we just dropped on
			if dragged_item != self.get_child(0):
				slot_item = self.get_child(0)
			else:
				slot_item = self.get_child(-1)
				
			# add dragged item to the slot
			dragged_item.reparent(self)
				
			# early return if the references are to the same item
			if dragged_item == slot_item:
				return

			# if this slot is not in the main inventory... or the former slot was not in the main inventory...
			if type != ItemData.ItemType.MAIN or slot_item.data.item_type != ItemData.ItemType.MAIN:
				# Function to handle equipment changes
				# Something like change_equipment(player, dragged_item, slot_item)
				pass
			# swap items
			swapping = true
		else:
			dragged_item.get_parent().swapping = false
			dragged_item.reparent(self)
