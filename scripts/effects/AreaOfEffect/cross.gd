extends AoE
class_name CircleAoE

func get_affected_cells() -> Array[Vector2i]:
	var affected_cells = []
	for x in range(-range, range + 1):
		for y in range(-range, range + 1):
			if Vector2(x, y).length() <= range:
				affected_cells.append(center + Vector2i(x, y))
	return affected_cells
