extends Panel
class_name InventoryPanel

@onready var grid_container := $GridContainer
var slot_item: InventoryItem

func _can_drop_data(_at_position, _data) -> bool:
	return true
	
func drop_is_valid(closest_slot: Control, dragged_item: Variant) -> bool:
	if dragged_item is InventoryItem:
		if closest_slot.type == ItemData.ItemType.MAIN:
			if closest_slot.get_child_count() == 0:
				return true
			else:
				if dragged_item.get_parent() and closest_slot.type == dragged_item.get_parent().type:
					return true
				return closest_slot.get_child(0).data.ItemType == dragged_item.type
		else:
			return dragged_item.data.item_type == closest_slot.type
	return false
	
# handle drop signal if dropped in the panel instead of the grid container
func _drop_data(at_position: Vector2, dragged_item: Variant) -> void:
	var closest_slot = null
	var closest_distance = INF
	
	for slot in grid_container.get_children():
		var slot_rect = slot.get_global_rect()
		var slot_center = slot_rect.position + slot_rect.size / 2
		var distance = slot_center.distance_to(get_global_mouse_position())
		
		if distance < closest_distance:
			closest_slot = slot
			closest_distance = distance
			
	# if this slot is occupied...
	if closest_slot and drop_is_valid(closest_slot, dragged_item):
		
		# if this slot is occupied...
		if closest_slot.get_child_count() > 0:
			# record the item we just dropped on
			if dragged_item != closest_slot.get_child(0):
				slot_item = closest_slot.get_child(0)
			else:
				slot_item = closest_slot.get_child(-1)
				
			# add dragged item to the slot
			dragged_item.reparent(closest_slot)
				
			# early return if the references are to the same item
			if dragged_item == slot_item:
				return

			# if this slot is not in the main inventory... or the former slot was not in the main inventory...
			if closest_slot.type != ItemData.ItemType.MAIN or slot_item.data.item_type != ItemData.ItemType.MAIN:
				# Function to handle equipment changes
				# Something like change_equipment(player, dragged_item, slot_item)
				pass
				
			# swap items
			closest_slot.swapping = true
			closest_slot.slot_item = slot_item
		else:
			dragged_item.get_parent().swapping = false
			dragged_item.reparent(closest_slot)
			slot_item = null
		
		

