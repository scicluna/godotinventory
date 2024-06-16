extends InventorySlot
class_name EquipmentSlot

@export var equipment_type: EquipmentData.EquipmentType

func drop_is_valid(dragged_item: Variant) -> bool:
	if dragged_item is InventoryItem:
		if type == ItemData.ItemType.MAIN:
			return true
		elif dragged_item.data.item_type == ItemData.ItemType.EQUIPMENT:
			return dragged_item.data.equipment_type == equipment_type
	return false
	
# handle drop signal
func _drop_data(at_position: Vector2, dragged_item: Variant) -> void:
	origin_slot = dragged_item.get_parent()

	if drop_is_valid(dragged_item):
		
		# if this slot is occupied...
		if self.slot_item:
			# early return if the references are to the same item
			if dragged_item.data == slot_item.data:
				dragged_item.visible = true
				return
				
			if dragged_item.quantity > 1:
				
				# Reduce the quantity of the dragged item by 1
				dragged_item.quantity -= 1
				dragged_item.update_quantity()
				
				# Create a new item with quantity 1 to add to the weapon slot
				var new_item = dragged_item.duplicate() as InventoryItem
				new_item.quantity = 1
				new_item.visible = true
				self.add_child(new_item)
				
				# change dragging_item to the now former slot item
				parent_inventory.dragging_item = slot_item
			
				# slot_item now points to the item we had been dragging and is equipped
				self.slot_item = new_item
				equip_item(new_item)
			else:
				# add dragged item to the slot
				dragged_item.reparent(self)
			
				# change dragging_item to the now former slot item
				parent_inventory.dragging_item = slot_item
			
				# slot_item now points to the item we had been dragging and is equipped
				slot_item = dragged_item
				
				# if not swapping
				if not parent_inventory.swapping:
					origin_slot.slot_item = null
					
				equip_item(dragged_item)
			
			# swap items
			origin_slot = self
			parent_inventory.swapping = true
		else:
			if dragged_item.quantity > 1:
				# Reduce the quantity of the dragged item by 1
				dragged_item.quantity -= 1
				dragged_item.update_quantity()
				
				# Create a new item with quantity 1 to add to the weapon slot
				var new_item = dragged_item.duplicate() as InventoryItem
				new_item.quantity = 1
				new_item.visible = true
				self.add_child(new_item)
				
				# slot_item now points to the item we had been dragging and is equipped
				slot_item = new_item
				equip_item(new_item)
				 
				# if we were swapping - update the dragging item and make sure that origin_slot still has slot item
				if parent_inventory.swapping:
					parent_inventory.dragging_item = dragged_item
					return
				else:
					parent_inventory.dragging_item = null
			else:
				# add dragged item to the slot
				dragged_item.reparent(self)
				
				# if we didn't just swap equipment...
				if not parent_inventory.swapping:
					origin_slot.slot_item = null
					origin_slot.equip_item(null)
					
				# slot_item now points to the item we had been dragging and is equipped
				slot_item = dragged_item
				equip_item(dragged_item)
			
			# turn off swapping
			parent_inventory.swapping = false

	# Remove the glow after dropping
	remove_glow()
	dragged_item.visible = true

# Hooks up to the player and updates their stats
func equip_item(_new_item: Variant) -> void:
	print("EQUIP ITEM: ", _new_item)
	var player := self.get_owner().get_owner()
	player.update_equipment_stats()
