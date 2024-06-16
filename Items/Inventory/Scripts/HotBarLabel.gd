
extends Label

@export var slot_number := 0

func _ready():
	update_key_binding()

func update_key_binding():
	var slot_name = "hotbar_" + str(slot_number)
	var events = InputMap.action_get_events(slot_name)
	if events.size() > 0:
		var key_event = events[0]
		if key_event:
			text = key_event.as_text().replace("(Physical)", "")
		else:
			text = "Unbound"
	else:
		text = "Unbound"
