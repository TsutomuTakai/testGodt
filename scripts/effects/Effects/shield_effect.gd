# ActionResource.gd
extends  Effect
class_name ShieldEffect


func apply_effect(target, power: int):
	# Implement the base effect logic
	target.shield += power
