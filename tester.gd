extends Node2D

@onready var controller = $BattleController


func _on_button_pressed() -> void:
	var x = controller.player_units.get(0).actions.get(0)
	
	print(x.action_name)
