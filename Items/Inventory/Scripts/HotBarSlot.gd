extends InventorySlot
class_name HotBarSlot

@export var slot_number := 0

func _ready():
	parent_inventory = get_parent().get_parent().get_parent().get_parent().get_parent()
	connect("mouse_exited", Callable(self, "_on_mouse_exited"))

# handle drop signal
func _drop_data(at_position: Vector2, dragged_item: Variant) -> void:
	
	origin_slot = dragged_item.get_parent()
	
	if drop_is_valid(dragged_item):
		
		if origin_slot == self:
			dragged_item.visible = true
			return
			
		# handle hotbar to hotbar
		if origin_slot.type == ItemData.ItemType.MSC:
			origin_slot.slot_item = null
			origin_slot.remove_child(dragged_item)
					
			# remove former children
			if slot_item:
				self.remove_child(slot_item)
			
			self.add_child(dragged_item)
			dragged_item.visible = true
			return
			
		# remove former children
		if slot_item:
			self.remove_child(slot_item)
			
		# clone for hotbar use
		var new_item = dragged_item.duplicate() as InventoryItem
		new_item.quantity = 1
		new_item.visible = true
		self.add_child(new_item)
		
		# assign slot item
		slot_item = new_item

	# Remove the glow after dropping
	self.remove_glow()
	if not parent_inventory.swapping:
		dragged_item.visible = true
