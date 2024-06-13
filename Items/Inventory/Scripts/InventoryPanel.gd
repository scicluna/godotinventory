extends Panel
class_name InventoryPanel

@onready var grid_container := $GridContainer
var origin_slot: InventorySlot

func _can_drop_data(_at_position, dragged_item) -> bool:
	dragged_item.visible = false
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
			
	# if we found a closest slot and its valid
	if closest_slot and drop_is_valid(closest_slot, dragged_item):
		
		origin_slot = dragged_item.get_parent()

		# if this slot is occupied...
		if closest_slot.slot_item:
		
			# early return if the references are to the same item
			if dragged_item.data == closest_slot.slot_item.data:
				dragged_item.visible = true
				return
			
			# add dragged item to the slot
			dragged_item.reparent(closest_slot)

			# change dragging_item to the now former slot item
			closest_slot.dragging_item = closest_slot.slot_item
			
			# slot_item now points to the item we had been dragging
			closest_slot.slot_item = dragged_item
			
			# if not swapping
			if not closest_slot.swapping:
				origin_slot.slot_item = null

			# swap items
			closest_slot.origin_slot = closest_slot
			closest_slot.swapping = true
		else:			
			# add dragged item to the slot
			dragged_item.reparent(closest_slot)
			
			# if origin slot was an equipment item...
			if origin_slot.type != ItemData.ItemType.MAIN:
				
				# if we didn't just swap equipment...
				if not origin_slot.swapping:
					origin_slot.equip_item(null)
					origin_slot.slot_item = null
					
			# if origin slot was not an equipment item...	
			else:
				origin_slot.slot_item = null
				
			# slot_item now points to the item we had been dragging
			closest_slot.slot_item = dragged_item
			
			# turn off swapping
			origin_slot.swapping = false
			
	# Remove the glow after dropping
	closest_slot.remove_glow()
	dragged_item.visible = true
