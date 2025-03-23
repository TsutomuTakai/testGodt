# BattleUI.gd

extends Control

var unit_labels: Dictionary = {}

func _ready():
	var battle_controller = get_parent() # Get the BattleController
	#battle_controller.unit_health_changed.connect(_on_unit_health_changed)
	

func _create_unit_labels(unit_dict: Dictionary):
	for unit_id in unit_dict.keys(): 
		var unit = unit_dict[unit_id]
		var label = Label.new()
		label.text = str(unit_id, ' : ', unit.health)
		add_child(label)
		unit_labels[unit_id] = label
		label.position = Vector2(-100, -100 + len(unit_labels) * 20) # Arrange labels vertically

func _on_unit_health_changed(unit_id: String, new_health: int):
	if unit_labels.has(unit_id):
		unit_labels[unit_id].text = str(new_health)
