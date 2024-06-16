extends Control
class_name InventoryControl

@onready var grid = $InventoryUI/UIControl/PopupUI/Main/GridContainer
@onready var equipment_grid = $InventoryUI/UIControl/PopupUI/Equips/GridContainer
@onready var hotbar = $InventoryUI/UIControl/HotBar/GridContainer
@onready var inventory_ui = $InventoryUI/UIControl/PopupUI

const MAX_SLOTS = 24
const SLOT_SIZE = 48

var swapping = false
var dragging_item: InventoryItem

var items_to_load := [
	"res://Items/Resources/dagger.tres",
	"res://Items/Resources/dagger.tres",
	"res://Items/Resources/dagger1.tres",
	"res://Items/Resources/testarmor.tres",
	"res://Items/Resources/testarmor.tres",
	"res://Items/Resources/lesser_healing_potion.tres",
	"res://Items/Resources/lesser_healing_potion.tres",
	"res://Items/Resources/lesser_healing_potion.tres",
	"res://Items/Resources/lesser_healing_potion.tres",
	"res://Items/Resources/lesser_healing_potion.tres",
	"res://Items/Resources/lesser_healing_potion.tres",
	"res://Items/Resources/lesser_healing_potion.tres",
	"res://Items/Resources/lesser_healing_potion.tres",
	"res://Items/Resources/lesser_healing_potion.tres"
]

func _ready():
	for i in MAX_SLOTS:
		var slot := InventorySlot.new()
		slot.init(ItemData.ItemType.MAIN, Vector2(SLOT_SIZE, SLOT_SIZE))
		grid.add_child(slot)
	for i in items_to_load.size():
		add_item(load(items_to_load[i]), 1)
		
func _process(delta):
	if swapping and is_instance_valid(dragging_item):
		dragging_item.force_drag(dragging_item, dragging_item.make_drag_preview(Vector2(0,0)))
		

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("inventory"):
		inventory_ui.visible = !inventory_ui.visible
		if inventory_ui.visible:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# Literal Hacky Cheezemaster Garbage - Wow I hate this
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and inventory_ui.visible \
	and not swapping and not dragging_item and event.is_pressed():
		handle_right_click(event)


func handle_right_click(event: InputEventMouseButton) -> void:
	var mouse_pos = event.position
	var slots = grid.get_children()

	for slot in slots:
		if slot.get_global_rect().has_point(mouse_pos):
			if slot.slot_item and (slot.slot_item.data.item_type == ItemData.ItemType.WEAPON or slot.slot_item.data.item_type == ItemData.ItemType.EQUIPMENT):
				var temp_data = slot.slot_item.data
				self.quick_equip(temp_data)
				return
			elif slot.slot_item and slot.slot_item.data.item_type == ItemData.ItemType.CONSUMABLE:
				var temp_data = slot.slot_item.data
				self.quick_use(temp_data)
				return

func _can_drop_data(at_position, data):
	return true

func add_item(inventory_item_data: ItemData, quantity: int = 1) -> void:
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
			new_item.quantity = 1
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
			
func get_slot(item_data: ItemData, inventroy_reference = grid) -> InventorySlot:
	var slots = inventroy_reference.get_children()
	
	for slot in slots:
		var slotted_item = slot.get_child(0) if slot.get_children().size() > 0 else null
		if slotted_item != null and slotted_item.data == item_data:
			return slot
	
	return null

func get_equipment_slot(enum_type: ItemData.ItemType, equip_type = null) -> InventorySlot:
	var slots = equipment_grid.get_children()
	
	for slot in slots:
		if slot.type == enum_type:
			if equip_type != null:
				if slot.equipment_type == equip_type:
					return slot
			else:
				return slot
	
	return null


func quick_equip(new_data: ItemData) -> void:
	# sift inventory for item and get slot reference
	var slot = self.get_slot(new_data)

	print("quick equip")
	# if slot is not found, return early
	if not slot:
		return
		
	# if there's no item in the slot, return
	if not slot.slot_item:
		return
		
	# if slot is swapping for some reason, return early
	if self.swapping:
		return
		
	# deduct one from the slot item
	slot.slot_item.quantity -= 1
	slot.slot_item.update_quantity()

	# if the equipment slot is already full...
	var equipment_type = new_data.equipment_type if new_data is EquipmentData else null
	var target_slot = self.get_equipment_slot(new_data.item_type, equipment_type)
	if target_slot.slot_item:
		var temp_item_data = target_slot.slot_item.data
		target_slot.slot_item = null
		target_slot.clear_slot()
		self.add_item(temp_item_data)
	
	# add the equipment to equipment slot
	var item = InventoryItem.new()
	item.quantity = 1
	item.data = new_data
	target_slot.slot_item = item
	target_slot.add_child(item)
	
	# equip the weapon
	if new_data.item_type == ItemData.ItemType.WEAPON:
		owner.equip_weapon(new_data)
		
	# equip equipment
	if new_data.item_type == ItemData.ItemType.EQUIPMENT:
		owner.update_equipment_stats()
	
	# if slot is now empty, clear it
	if slot.slot_item.quantity <= 0:
		slot.slot_item = null
	
func quick_use(new_data: ItemData) -> void:
	# sift inventory for item and get slot reference
	var slot = self.get_slot(new_data)

	print("quick use")
	# if slot is not found, return early
	if not slot:
		return
		
	# if there's no item in the slot, return
	if not slot.slot_item:
		return
		
	# if slot is swapping for some reason, return early
	if self.swapping:
		return
		
	# actually use the consumable
	slot.slot_item.data.consume(owner)
		
	# deduct one from the slot item
	slot.slot_item.quantity -= 1
	
	#deduct one from any hotbar equivalents
	var hotbar_equivalent = self.get_slot(slot.slot_item.data, self.hotbar)
	if hotbar_equivalent:
		hotbar_equivalent.slot_item.quantity = slot.slot_item.quantity
		hotbar_equivalent.slot_item.update_quantity()
		
		if hotbar_equivalent.slot_item.quantity <= 0:
			hotbar_equivalent.slot_item = null

	#update quantity
	slot.slot_item.update_quantity()
	
	if slot.slot_item.quantity <= 0:
		slot.slot_item = null
