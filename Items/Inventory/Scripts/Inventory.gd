extends Control

@onready var grid = $InventoryUI/UIControl/Main/GridContainer
@onready var inventory_ui = $InventoryUI

const MAX_SLOTS = 24
const SLOT_SIZE = 48

var items_to_load := [
	"res://Items/Resources/dagger.tres",
	"res://Items/Resources/dagger1.tres"
]

func _ready():
	for i in MAX_SLOTS:
		var slot := InventorySlot.new()
		slot.init(ItemData.ItemType.MAIN, Vector2(SLOT_SIZE, SLOT_SIZE))
		grid.add_child(slot)
	for i in items_to_load.size():
		var item = InventoryItem.new()
		item.init(load(items_to_load[i]))
		grid.get_child(i).add_child(item)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("inventory"):
		inventory_ui.visible = !inventory_ui.visible
		if inventory_ui.visible:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _can_drop_data(at_position, data):
	return true
