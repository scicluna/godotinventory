extends Node

# Dictionary to store the key bindings for hotbar slots
var key_bindings := {
	"hotbar_1": "hotbar_1",
	"hotbar_2": "hotbar_2",
	"hotbar_3": "hotbar_3",
	"hotbar_4": "hotbar_4",
	"hotbar_5": "hotbar_5",
	"hotbar_6": "hotbar_6",
	"hotbar_7": "hotbar_7",
	"hotbar_8": "hotbar_8",
	"hotbar_9": "hotbar_9"
}

func _ready():
	# Load key bindings from a config file if it exists
	load_key_bindings()

# Function to get the key binding for a specific hotbar slot
func get_key_binding(slot):
	return key_bindings.get(slot, "")

# Function to set a key binding for a specific hotbar slot
func set_key_binding(slot, key):
	key_bindings[slot] = key
	save_key_bindings()

# Save key bindings to a config file
func save_key_bindings():
	var config = ConfigFile.new()
	for slot in key_bindings.keys():
		config.set_value("key_bindings", slot, key_bindings[slot])
	config.save("user://key_bindings.cfg")

# Load key bindings from a config file
func load_key_bindings():
	var config = ConfigFile.new()
	var err = config.load("user://key_bindings.cfg")
	if err == OK:
		for slot in key_bindings.keys():
			key_bindings[slot] = config.get_value("key_bindings", slot, key_bindings[slot])
