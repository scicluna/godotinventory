extends Panel
class_name InventoryPanel

@onready var grid_container := $GridContainer
var origin_slot: InventorySlot

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
		
		origin_slot = dragged_item.get_parent()
		
		# if this slot is occupied...
		if closest_slot.get_child_count() > 0:

			# record the item we just dropped on
			if dragged_item != closest_slot.get_child(0):
				closest_slot.slot_item = closest_slot.get_child(0)
			else:
				closest_slot.slot_item = closest_slot.get_child(-1)
				
			# add dragged item to the slot
			dragged_item.reparent(closest_slot)
				
			# early return if the references are to the same item
			if dragged_item == closest_slot.slot_item:
				return
				
			# if the origin slot is empty, and the slot type of the origin was an equipment slot... unequip the item.
			if origin_slot.slot_item == null and origin_slot.type != ItemData.ItemType.MAIN:
				origin_slot.equip_item(null)
				pass

			# if this slot is not in the main inventory... or the former slot was not in the main inventory...
			if closest_slot.type != ItemData.ItemType.MAIN or closest_slot.slot_item.data.item_type != ItemData.ItemType.MAIN:
				# Function to handle equipment changes
				closest_slot.equip_item(dragged_item)
				pass
				
			# swap items
			origin_slot = closest_slot
			closest_slot.swapping = true
		else:
			dragged_item.get_parent().swapping = false
			dragged_item.reparent(closest_slot)
			
			# if the origin slot is empty, and the slot type of the origin was an equipment slot... unequip the item.
			if origin_slot.slot_item == null and origin_slot.type != ItemData.ItemType.MAIN:
				origin_slot.equip_item(null)
				pass
			
			if closest_slot.type != ItemData.ItemType.MAIN:
				closest_slot.equip_item(dragged_item)
				pass
			
			origin_slot.slot_item = null
		
		

