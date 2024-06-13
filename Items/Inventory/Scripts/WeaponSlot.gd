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
				dragging_item = slot_item
			
				# slot_item now points to the item we had been dragging and is equipped
				slot_item = new_item
				equip_item(new_item)
			else:
				# add dragged item to the slot
				dragged_item.reparent(self)
			
				# change dragging_item to the now former slot item
				dragging_item = slot_item
			
				# slot_item now points to the item we had been dragging and is equipped
				slot_item = dragged_item
				equip_item(dragged_item)
			
				# if not swapping
				if not swapping:
					origin_slot.slot_item = null
		
			# swap items
			origin_slot = self
			swapping = true
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
				
			else:
				# add dragged item to the slot
				dragged_item.reparent(self)
				origin_slot.slot_item = null
				
				# slot_item now points to the item we had been dragging and is equipped
				slot_item = dragged_item
				equip_item(dragged_item)

				# if we didn't just swap equipment...
				if not swapping:
					origin_slot.equip_item(null)
					origin_slot.slot_item = null
			
			# turn off swapping
			origin_slot.swapping = false

	# Remove the glow after dropping
	remove_glow()
	dragged_item.visible = true

# Hooks up to the player and changes their equipped weapon
func equip_item(new_item: Variant) -> void:
	print("EQUIP ITEM: ", new_item)
	var player := self.get_owner().get_owner()
	
	if new_item != null and new_item.data is WeaponData:
		player.equip_weapon(new_item.data)
	else:
		player.equip_weapon(null)
