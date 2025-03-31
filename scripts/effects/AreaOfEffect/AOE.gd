# AoE.gd
extends Resource
class_name AoE

var center: Vector2i # Center of the AoE
var range: int # Range of the AoE

enum target {
	FRONT,
	BACK,
	SKIP_FRONT,
	SKIP_BACK
}

func get_affected_cells(pos: Vector2i) -> Array[Vector2i]:
	# Implement the logic to calculate affected cells
	return [] # Return an array of Vector2i
