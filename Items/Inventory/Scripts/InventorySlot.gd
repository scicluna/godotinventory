extends PanelContainer
class_name InventorySlot

@export var type: ItemData.ItemType
var slot_item: InventoryItem
var swapping := false
var origin_slot: InventorySlot

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

	origin_slot = dragged_item.get_parent()

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
				
			# if the origin slot is empty, and the slot type of the origin was an equipment slot... unequip the item.
			if origin_slot.slot_item == null and origin_slot.type != ItemData.ItemType.MAIN:
				origin_slot.equip_item(null)
				pass

			# if this slot is not in the main inventory... or the former slot was not in the main inventory...
			if type != ItemData.ItemType.MAIN or slot_item.data.item_type != ItemData.ItemType.MAIN:
				# Function to handle equipment changes
				equip_item(dragged_item)
				pass
			# swap items
			origin_slot = self
			swapping = true
		else:
			dragged_item.get_parent().swapping = false
			dragged_item.reparent(self)
			
			# if the origin slot is empty, and the slot type of the origin was an equipment slot... unequip the item.
			if origin_slot.slot_item == null and origin_slot.type != ItemData.ItemType.MAIN:
				origin_slot.equip_item(null)
				pass
			
			if type != ItemData.ItemType.MAIN:
				equip_item(dragged_item)
				pass
			
			origin_slot.slot_item = null
			
# Implement in sub-classes		
func equip_item(new_item: Variant) -> void:
	pass
