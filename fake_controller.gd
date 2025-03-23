extends Node

@export var player: Array[Unit] 
@export var enemy:  Array[Unit]  


func _on_set_damage_pressed() -> void:
	var a = player[0].actions[0].calculate_action(player[0], enemy[0], [])
	var b = player[0].actions[0].calculate_action(player[1], enemy[0], [])
	print(" foi")
	print(a)
	
	print('ainda nao')
	print(b)
	pass # Replace with function body.
