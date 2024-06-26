extends ConsumableData
class_name LootBoxData

@export var loot_table: Lootbox

func hotbar_action(player: Player) -> void:
	player.inventory.quick_use(self)   
	
func open_box(player: Player) -> void:
	var selected_item = loot_table.select_item()
	player.inventory.add_item(selected_item[0], selected_item[1])
	# Play Some kind of animation?
