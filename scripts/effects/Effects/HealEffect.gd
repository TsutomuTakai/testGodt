# ActionResource.gd
extends Effect
class_name HealEffect


func apply_effect(target, power: int):
	# Implement the base effect logic
	target.health += power
