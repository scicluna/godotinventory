extends PanelContainer
class_name InventorySlot

@export var type: ItemData.ItemType

var slot_item: InventoryItem
var swapping := false
var origin_slot: InventorySlot
var glowing := false
var glow_shader_material: ShaderMaterial

func _ready():
	connect("mouse_exited", Callable(self, "_on_mouse_exited"))

func init(item_type: ItemData.ItemType, custom_min_size: Vector2) -> void:
	type = item_type
	self.custom_minimum_size = custom_min_size
	
func _process(delta):
	if swapping and slot_item:
		slot_item.force_drag(slot_item, slot_item.make_drag_preview(Vector2(0,0)))
		
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
				dragged_item.visible = true
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
			
	# Remove the glow after dropping
	remove_glow()
	dragged_item.visible = true

# Implement in sub-classes		
func equip_item(new_item: Variant) -> void:
	pass
