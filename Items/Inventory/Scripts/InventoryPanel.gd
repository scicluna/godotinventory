extends Panel
class_name InventoryPanel

@onready var grid_container := $GridContainer
var origin_slot: InventorySlot

func _can_drop_data(_at_position, dragged_item) -> bool:
	dragged_item.visible = false
	return true
	
func drop_is_valid(closest_slot: Control, dragged_item: Variant) -> bool:
	if dragged_item is InventoryItem:
		if closest_slot.type == ItemData.ItemType.MAIN or closest_slot.type == ItemData.ItemType.MSC:
			return true
		elif dragged_item.data.item_type == ItemData.ItemType.EQUIPMENT:
			return dragged_item.data.equipment_type == closest_slot.equipment_type
		elif dragged_item.data.item_type == ItemData.ItemType.WEAPON:
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
		closest_slot._drop_data(at_position, dragged_item)
		return
