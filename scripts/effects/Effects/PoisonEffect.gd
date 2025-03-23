# ActionResource.gd
extends  Effect
class_name PoisonEffect


func apply_effect(target, power: int):
	# Implement the base effect logic
	target.poison += power
