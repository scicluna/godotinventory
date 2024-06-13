extends TextureRect
class_name InventoryItem

@export var data: ItemData

const MAX_QUANTITY := 99
var quantity := 1
var item_label: Label

func _ready() -> void:
	if data:
		self.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		self.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		self.texture = data.item_icon
		self.tooltip_text = "%s\n%s\nDescription %s" % [data.item_name, data.item_type, data.description]
		
		item_label = Label.new()
		item_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		item_label.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
		item_label.custom_minimum_size = Vector2(64, 64)
		self.add_child(item_label)
		
		update_quantity()
		
func _get_drag_data(at_position: Vector2) -> Variant:
	set_drag_preview(make_drag_preview(at_position))
	return self
	
func make_drag_preview(at_position: Vector2) -> Control:
	var rect := TextureRect.new()
	rect.texture = self.texture
	rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	rect.custom_minimum_size = Vector2(48, 48)
	rect.position = -0.5 * rect.custom_minimum_size
	rect.modulate.a = 0.7
	
	var control := Control.new()
	control.z_index = 10
	control.add_child(rect)

	return control
	
func update_quantity():
	if data:
		item_label.text = "x" + str(quantity)
		if quantity <= 0:
			self.queue_free()
	
