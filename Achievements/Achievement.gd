extends Resource
class_name Achievement

@export var name: String
@export_multiline var description: String
@export var icon: Texture
@export var announcement: Announcement
@export var reward: String  # Implement with loot boxes
@export var unlocked: bool = false

# Accepts a parameter to evaluate conditions
func check_conditions(player: Player):
	# Example condition check
	pass

func unlock(player: Player):
	if not unlocked and check_conditions(player):
		pass

