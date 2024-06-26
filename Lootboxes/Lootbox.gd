extends Resource
class_name Lootbox

@export var item_pool: Array[Loot]

func select_item() -> Array:
	var total_weight: float = 0.0
	for loot in item_pool:
		total_weight += loot.weight

	var random_value: float = randf() * total_weight
	for loot in item_pool:
		random_value -= loot.weight
		if random_value <= 0:
			return [loot.data, loot.quantity]

	# Fallback, in case something goes wrong
	return [null, 0]
