extends Achievement

func check_conditions(player: Player) -> bool:
	if player.weapon_layer.weapon:
		return true
	return false

func unlock(player: Player) -> void:
	if not unlocked and check_conditions(player):
		unlocked = true
