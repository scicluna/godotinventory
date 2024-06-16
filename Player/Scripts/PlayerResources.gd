extends Resource
class_name PlayerResources

@export var hp: int
@export var max_hp: int

@export var mp: int
@export var max_mp: int

@export var gp: int

func take_damage(damage: int) -> void:
	hp -= damage
	if hp <= 0:
		print("you have died")
		
func heal_damage(damage: int) -> void:
	hp += damage
	if hp > max_hp:
		hp = max_hp

func spend_mp(mana: int) -> void:
	mp -= mana
	if mp < 0:
		mp = 0

func restore_mp(mana: int) -> void:
	mp += mana
	if mana > max_mp:
		mp = max_mp

func has_enough_gold(gold: int) -> bool:
	return gold <= gp
		
func gain_gold(gold: int) -> void:
	gp += gold

func spend_gold(gold: int) -> void:
	gp -= gold
	if gp < 0:
		gp = 0
