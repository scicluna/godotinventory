extends ItemData
class_name ConsumableData

func hotbar_action(player: Player) -> void:
	player.quick_use(self)                                                                                                  
	

func consume(player: Player) -> void:
	pass
