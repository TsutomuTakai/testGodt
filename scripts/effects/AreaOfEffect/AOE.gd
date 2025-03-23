# AoE.gd
extends Resource
class_name AoE

var center: Vector2i # Center of the AoE
var range: int # Range of the AoE

func get_affected_cells() -> Array[Vector2i]:
	# Implement the logic to calculate affected cells
	return [] # Return an array of Vector2i
