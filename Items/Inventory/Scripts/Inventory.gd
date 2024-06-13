extends Control

@onready var grid = $InventoryUI/UIControl/Main/GridContainer
@onready var inventory_ui = $InventoryUI

const MAX_SLOTS = 24
const SLOT_SIZE = 48

var items_to_load := [
	"res://Items/Resources/dagger.tres",
	"res://Items/Resources/dagger.tres",
	"res://Items/Resources/dagger1.tres"
]

func _ready():
	for i in MAX_SLOTS:
		var slot := InventorySlot.new()
		slot.init(ItemData.ItemType.MAIN, Vector2(SLOT_SIZE, SLOT_SIZE))
		grid.add_child(slot)
	for i in items_to_load.size():
		add_item(load(items_to_load[i]), 1)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("inventory"):
		inventory_ui.visible = !inventory_ui.visible
		if inventory_ui.visible:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _can_drop_data(at_position, data):
	return true

func add_item(inventory_item_data: ItemData, quantity: int):
	var slots = grid.get_children()
	
	# First try to add to existing slots with the same item
	for slot in slots:
		var slotted_item =  slot.get_child(0) if slot.get_children().size() > 0 else null
		if slotted_item != null and slotted_item.data == inventory_item_data:
			slotted_item.quantity += quantity
			slotted_item.update_quantity()
			return
	
	for slot in slots:
		if slot.get_child_count() == 0:
			var new_item = InventoryItem.new()
			new_item.data = inventory_item_data
			
			# Add item to slot
			slot.slot_item = new_item
			slot.add_child(new_item)
			return
		
func remove_item(origin_slot: InventorySlot, inventory_item: InventoryItem, quantity: int = 1) -> void:
	# get inventory
	var slots = origin_slot.get_parent().get_children()
	
	for slot in slots:
		if slot == origin_slot:
			inventory_item.quantity -= quantity
			inventory_item.visible = true
			inventory_item.update_quantity()
			if inventory_item.quantity <= 0:
				origin_slot.remove_child(inventory_item)
				origin_slot.slot_item = null
			return
