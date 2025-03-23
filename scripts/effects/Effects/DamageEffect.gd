# ActionResource.gd
extends  Effect
class_name DamageEffect


func apply_effect(target, power: int):
	# Implement the base effect logic
	target.health += power

func calc_effect(inflicted: StatusDictionary,self_unit: Unit, enemy_unit: Unit, power: int, turn_array: Array) -> void :
	if enemy_unit.reflect > 0:
		inflicted.health += power
		inflicted.self_damage += enemy_unit.reflect
	elif enemy_unit.reflect < 0:
		inflicted.health += power
		inflicted.self_damage += power
	inflicted.health += power
	
