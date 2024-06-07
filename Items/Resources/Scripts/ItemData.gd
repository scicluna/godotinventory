extends Resource
class_name ItemData

enum ItemType {
	WEAPON,
	EQUIPMENT,
	CONSUMABLE,
	MSC,
	MAIN
}

@export var item_type: ItemType
@export var item_name: String
@export_multiline var description: String
@export var item_icon: Texture2D
@export var item_texture: PackedScene
