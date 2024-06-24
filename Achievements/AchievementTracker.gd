extends Node
class_name AchievementTracker

@onready var player = owner

# List of all achievements
var achievements: Array

func _ready():
	achievements = load_achievements()

func load_achievements() -> Array:
	var loaded_achievements = []
	var dir = DirAccess.open("res://achievements/Resources")
	if dir:
		dir.list_dir_begin()
		var filename = dir.get_next()
		while filename != "":
			if filename.ends_with(".tres"):
				var ach_res = load("res://achievements/Resources/" + filename)
				loaded_achievements.append(ach_res)
			filename = dir.get_next()
		dir.list_dir_end()
	return loaded_achievements

func check_achievements(player):
	for achievement in achievements:
		if achievement.check_conditions(player) and !achievement.unlocked:
			print(achievement.announcement.text)
			achievement.unlock(player)
