extends Resource
class_name PlayerStats

# stats
@export var base_stats := {
	"STR": 0,
	"AGI": 0,
	"STA": 0,
	"INT": 0,
	"CHA": 0
}

@export var equip_stats := {
	"STR": 0,
	"AGI": 0,
	"STA": 0,
	"INT": 0,
	"CHA": 0
}

@export var bonus_stats := {
	"STR": 0,
	"AGI": 0,
	"STA": 0,
	"INT": 0,
	"CHA": 0
}

@export var total_stats := {
	"STR": 0,
	"AGI": 0,
	"STA": 0,
	"INT": 0,
	"CHA": 0
}

func update_total_stats():
	for key in total_stats.keys():
		total_stats[key] = base_stats[key] + equip_stats[key] + bonus_stats[key]
		
	# Print all updated stats
	print("Base Stats:")
	for key in base_stats.keys():
		print("%s: %d" % [key, base_stats[key]])

	print("Equip Stats:")
	for key in equip_stats.keys():
		print("%s: %d" % [key, equip_stats[key]])

	print("Bonus Stats:")
	for key in bonus_stats.keys():
		print("%s: %d" % [key, bonus_stats[key]])

	print("Total Stats:")
	for key in total_stats.keys():
		print("%s: %d" % [key, total_stats[key]])


