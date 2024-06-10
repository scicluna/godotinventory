extends TextureRect
class_name InventoryItem

@export var data: ItemData

func _ready() -> void:
	if data:
		self.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		self.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		self.texture = data.item_icon
		self.tooltip_text = "%s\n%s\nDescription %s" % [data.item_name, data.item_type, data.description]
		
func init(item_data: ItemData) -> void:
	data = item_data
	
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
	
	
