extends AoE
class_name LineAoE

var direction: Vector2i = Vector2i(0,1)

func get_affected_cells() -> Array[Vector2i]:
	var affected_cells = []
	for i in range(range + 1):
		affected_cells.append(center + direction * i)
	return affected_cells
