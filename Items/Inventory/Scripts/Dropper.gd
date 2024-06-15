extends Control
class_name Dropper


# custom route to the player's 3d camera
@onready var player := get_parent().get_parent().get_parent()
@onready var camera := player.get_node("Neck/Camera3D")

func _can_drop_data(_at_position, _data) -> bool:
	return true
	
func drop_is_valid(closest_slot: Control, dragged_item: Variant) -> bool:
	return true
	
# handle drop signal if dropped outside of the panels
func _drop_data(at_position: Vector2, dragged_item: Variant) -> void:
	var origin_slot = dragged_item.get_parent()
	
	# handle removals from hotbar
	if origin_slot.type == ItemData.ItemType.MSC:
		origin_slot.slot_item = null
		origin_slot.remove_child(dragged_item)
		return

	var item_instance = dragged_item.data.item_texture.duplicate(true).instantiate()	
	var forward_vector = -camera.global_transform.basis.z.normalized()
	var drop_position = camera.global_transform.origin + (forward_vector * 2.5)  # Drop the item 1 unit in front of the camera
	drop_position.y = player.global_transform.origin.y + 1.25  # Keep the drop height consistent with the player's position
	
	item_instance.position = drop_position

	#spawn item model in the world
	item_instance.data = dragged_item.data
	
	player.get_parent().add_child(item_instance)
	player.inventory.remove_item(origin_slot, dragged_item)

	#check whether or not we need to unequip the item
	if origin_slot.slot_item == null and origin_slot.type != ItemData.ItemType.MAIN:
		origin_slot.equip_item(null)
		
	player.inventory.swapping = false
