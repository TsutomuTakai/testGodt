# ActionResource.gd
extends  Resource
class_name Effect

@export var instant: bool = false

func apply_effect(target, power: int):
	# Implement the base effect logic
	pass

func calc_effect(inflicted: StatusDictionary,self_unit: Unit, enemy_unit: Unit, power: int, turn_array: Array) -> void :
	pass
