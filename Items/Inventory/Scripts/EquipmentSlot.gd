extends InventorySlot
class_name EquipmentSlot

@export var equipment_type: EquipmentData.EquipmentType

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
			
			# add dragged item to the slot
			dragged_item.reparent(self)
			
			# change dragging_item to the now former slot item
			parent_inventory.dragging_item = slot_item
			
			# slot_item now points to the item we had been dragging and is equipped
			slot_item = dragged_item
			equip_item(dragged_item)
			
						# if not swapping
			if not parent_inventory.swapping:
				origin_slot.slot_item = null
		
			# swap items
			origin_slot = self
			parent_inventory.swapping = true
		else:
			# add dragged item to the slot
			dragged_item.reparent(self)
			origin_slot.slot_item = null
			
			# slot_item now points to the item we had been dragging and is equipped
			slot_item = dragged_item
			equip_item(dragged_item)
			
			# turn off swapping
			origin_slot.swapping = false

	# Remove the glow after dropping
	remove_glow()
	dragged_item.visible = true

# Hooks up to the player and updates their stats
func equip_item(new_item: Variant) -> void:
	print("equipped...", new_item)
	var player := self.get_owner().get_owner()
	
	if new_item.data is EquipmentData:
		match new_item.data.equipment_type:
			EquipmentData.EquipmentType.HEAD:
				player.equipped_head = new_item.data
			EquipmentData.EquipmentType.CHEST:
				player.equipped_chest = new_item.data
			EquipmentData.EquipmentType.LEGS:
				player.equipped_legs = new_item.data
			EquipmentData.EquipmentType.FEET:
				player.equipped_feet = new_item.data
			EquipmentData.EquipmentType.ACCESSORY:
				player.equipped_accessory = new_item.data
			_:
				print("error - equipped mysterious slot for item: ", new_item.data.name)
				

	# Call update player stats

