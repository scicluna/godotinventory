extends PanelContainer
class_name InventorySlot

@export var type: ItemData.ItemType

var slot_item: InventoryItem
var origin_slot: InventorySlot
var glow_shader_material: ShaderMaterial

var glowing := false
var stackable := true

var parent_inventory

func _ready():
	parent_inventory = get_parent().get_parent().get_parent().get_parent().get_parent().get_parent()
	connect("mouse_exited", Callable(self, "_on_mouse_exited"))
		
func init(item_type: ItemData.ItemType, custom_min_size: Vector2) -> void:
	type = item_type
	self.custom_minimum_size = custom_min_size
	
# Slot Glowing Logic
func _on_mouse_exited():
	if glowing:
		fade_out_glow()

func _can_drop_data(_at_position, dragged_item) -> bool:
	dragged_item.visible = false
	if dragged_item and drop_is_valid(dragged_item):
		show_glow(Color(1, 1, 1))  # white glow for valid slot
	else:
		show_glow(Color(1, 0, 0))  # red glow for invalid slot
	glowing = true
	return true

func show_glow(color: Color) -> void:
	var stylebox = StyleBoxFlat.new()
	var tween = self.get_tree().create_tween()
	
	stylebox.set_border_width_all(4)
	stylebox.bg_color = Color(0, 0,0, .40)
	stylebox.border_color = color
	stylebox.border_blend = true
	self.add_theme_stylebox_override("panel", stylebox)
	
	tween.tween_property(stylebox, "border_color:a", 1.0, 0.5).set_ease(Tween.EASE_IN_OUT)

func remove_glow() -> void:
	self.remove_theme_stylebox_override("panel")
	
func fade_out_glow() -> void:
	var  tween = self.get_tree().create_tween()
	var stylebox = self.get_theme_stylebox("panel")
	
	tween.tween_property(stylebox, "border_color:a", 0.0, 0.5).set_ease(Tween.EASE_IN).connect("finished", Callable(self, "_on_fade_out_complete"))
	glowing = false

func _on_fade_out_complete() -> void:
	remove_glow()
	
func drop_is_valid(dragged_item: Variant) -> bool:
	if dragged_item is InventoryItem:
		if type == ItemData.ItemType.MAIN or type == ItemData.ItemType.MSC:
			return true
		else:
			return dragged_item.data.item_type == type
	return false

# handle drop signal
func _drop_data(at_position: Vector2, dragged_item: Variant) -> void:

	origin_slot = dragged_item.get_parent()
	
	if not is_instance_valid(origin_slot) or not origin_slot:
		return
	
	# handle removals from hotbar
	if origin_slot.type == ItemData.ItemType.MSC:
		origin_slot.slot_item = null
		origin_slot.remove_child(dragged_item)
		return

	if drop_is_valid(dragged_item):
		# if this slot is occupied...
		if is_instance_valid(self.slot_item):
			
			# check to see if we can try to stack the items
			if dragged_item.data == slot_item.data:
				
				# if not from the same slots...
				if origin_slot != self:

					# try to stack them
					slot_item.quantity += dragged_item.quantity
					
					# if overflow
					if slot_item.quantity > slot_item.MAX_QUANTITY:
						dragged_item.quantity = slot_item.quantity - slot_item.MAX_QUANTITY
						slot_item.quantity = slot_item.MAX_QUANTITY
						slot_item.update_quantity()
						dragged_item.update_quantity()
						
					# if combined successfully
					else:
						
						# clear out origin and unequip item if necessary
						origin_slot.slot_item = null
						if origin_slot.type != ItemData.ItemType.MAIN:
							origin_slot.equip_item(null)
							
						# update the quantity for this slot
						slot_item.update_quantity()

						# remove the origin_slot's item and set everything to neutral
						origin_slot.remove_child(dragged_item)
						dragged_item.visible = true
						parent_inventory.dragging_item = null
						parent_inventory.swapping = null
						return
				# if the origin slot was the same as the dropping slot...
				else:
					# set everything to neutral
					dragged_item.visible = true
					parent_inventory.dragging_item = null
					parent_inventory.swapping = null
					return
				
			# regular swap and not stacking
			else:
				# add dragged item to the slot
				dragged_item.reparent(self)

				# change dragging_item to the now former slot item
				parent_inventory.dragging_item = slot_item
				
				# slot_item now points to the item we had been dragging
				slot_item = dragged_item
				
				# set original slot to null, since we are now dragging it... unless we were already swapping.
				if self != origin_slot and not parent_inventory.swapping:
					origin_slot.slot_item = null

				# if swapping with an equipment slot
				if origin_slot.type != ItemData.ItemType.MAIN:
					# if we didn't just swap equipment...
					if not parent_inventory.swapping:
						origin_slot.equip_item(null)

				# swap items
				parent_inventory.swapping = true
				
		# if the slot was empty
		else:			
			# add dragged item to the slot
			dragged_item.reparent(self)
			
			# if origin slot was an equipment item...
			if origin_slot.type != ItemData.ItemType.MAIN:
				# if we didn't just swap equipment...
				if not parent_inventory.swapping:
					# empty the slot out and unequip the item
					origin_slot.slot_item = null
					origin_slot.equip_item(null)

			# if origin slot was not an equipment item...	
			else:
				# if we aren't swapping, clear out the origin slot
				if not parent_inventory.swapping:
					origin_slot.slot_item = null
				
			# slot_item now points to the item we had been dragging
			slot_item = dragged_item
			
			# turn off swapping
			parent_inventory.dragging_item = null
			parent_inventory.swapping = false
			
	# Remove the glow after dropping and make sure dragged item is now visible (probably not needed)
	remove_glow()
	dragged_item.visible = true

# Implement in sub-classes		
func equip_item(new_item: Variant) -> void:
	pass

func clear_slot():
	if slot_item:
		slot_item = null
	
	var children = self.get_children()
	if children.size():
		for child in children:
			child.queue_free()
		
func get_slot_item() -> InventoryItem:
	if slot_item:
		return slot_item
	else:
		return null
