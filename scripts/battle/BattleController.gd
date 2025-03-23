# BattleController.gd
extends Node

@export var player_team: TeamData
@export var enemy_team: TeamData
@onready var player_units: Array[Node2D]
@onready var enemy_units: Array[Node2D]
@export var grid_controller: GridController
@export var iu_controller: Control
enum BattleState {
	PREPARE_PLAYER,
	PREPARE_ENEMY,
	ASSIGN_PLAYER,
	EXECUTE_PLAYER,
	EXECUTE_ENEMY,
	POST_TURN
}
var current_state: BattleState = BattleState.PREPARE_PLAYER
var player_actions: Dictionary = {} # Dictionary to store player actions (unit_id: [action1, action2, ...])
var action_history: Array[Dictionary] = [] # Array of action dictionaries for undo
var unit_dict: Dictionary
var grid_ready: bool = false

func _ready():
	spawn_units()
	iu_controller._create_unit_labels(unit_dict)
	#start_battle()

func spawn_units():
	if player_team and grid_controller:
		var player_unit_index = 0
		var available_player_cells = get_available_cells(grid_controller.GridType.PLAYER) # Get available cells
		for unit_scene in player_team.unit_scenes:
			if available_player_cells.size() > 0:
				var random_index = randi() % available_player_cells.size()
				var grid_pos = available_player_cells[random_index]
				available_player_cells.erase(random_index) # Remove the used cell

				var player_unit_instance = unit_scene.instantiate()
				player_unit_instance.unit_type = player_unit_instance.UnitType.PLAYER
				add_child(player_unit_instance)

				player_unit_instance.set_grid_position(Vector2i(1,1), grid_controller)
				grid_controller.set_unit_on_tile(grid_controller.GridType.PLAYER, grid_pos.x, grid_pos.y, player_unit_instance)

				player_unit_index += 1
				print('dex' , player_unit_index ,'pos ',grid_pos)
				unit_dict['player']  = player_unit_instance
	
	if enemy_team and grid_controller:
		var available_enemy_cells = get_available_cells(grid_controller.GridType.ENEMY) # Get available cells
		for unit_scene in enemy_team.unit_scenes:
			if available_enemy_cells.size() > 0:
				var random_index = randi() % available_enemy_cells.size()
				var grid_pos = available_enemy_cells[random_index]
				available_enemy_cells.erase(random_index) # Remove the used cell

				var enemy_unit_instance = unit_scene.instantiate()
				enemy_unit_instance.unit_type = enemy_unit_instance.UnitType.ENEMY
				add_child(enemy_unit_instance)

				enemy_unit_instance.set_grid_position(Vector2i(1,1), grid_controller)
				grid_controller.set_unit_on_tile(grid_controller.GridType.ENEMY, grid_pos.x, grid_pos.y, enemy_unit_instance)
				unit_dict['enem']  = enemy_unit_instance
				

func get_available_cells(grid_type: int) -> Array[Vector2i]:
	var available_cells: Array[Vector2i] = []
	var grid_data = grid_controller.get_grid_data(grid_type)
	if grid_data:
		for x in grid_data.size():
			for y in grid_data[x].size():
				if grid_data[x][y].unit == null:
					available_cells.append(Vector2i(x, y))
	return available_cells
	
func start_battle():
	print("Battle started!")
	start_state()

func start_state():
	match current_state:
		BattleState.PREPARE_PLAYER:
			print("Prepare Player Phase")
			prepare_player()
		BattleState.PREPARE_ENEMY:
			print("Prepare Enemy Phase")
			prepare_enemy()
		BattleState.ASSIGN_PLAYER:
			print("Assign Player Phase")
			assign_player()
		BattleState.EXECUTE_PLAYER:
			print("Execute Player Phase")
			execute_player()
		BattleState.EXECUTE_ENEMY:
			print("Execute Enemy Phase")
			execute_enemy()
		BattleState.POST_TURN:
			print("Post Turn Phase")
			post_turn()

func prepare_player():
	# Placeholder: Implement player team setup logic
	current_state = BattleState.PREPARE_ENEMY
	start_state()

func prepare_enemy():
	# Placeholder: Implement enemy action assignment logic
	assign_enemy_actions()
	current_state = BattleState.ASSIGN_PLAYER
	start_state()

func assign_player():
	# Placeholder: Implement player unit movement and action selection logic
	# Store player actions in the player_actions dictionary
	# When player finishes assigning actions, call execute_player()
	pass

func execute_player():
	record_actions() # Record player actions before execution
	execute_player_actions()
	current_state = BattleState.EXECUTE_ENEMY
	start_state()

func execute_enemy():
	execute_enemy_actions()
	current_state = BattleState.POST_TURN
	start_state()

func post_turn():
	apply_end_of_turn_effects()
	check_battle_end()
	current_state = BattleState.PREPARE_ENEMY
	start_state()

func assign_enemy_actions():
	# Placeholder: Implement random enemy action assignment
	print('kd')
	for unit in enemy_units:
		# Assign random actions to enemy units
		print(unit.name)

func execute_player_actions():
	# Placeholder: Implement player action execution
	# Iterate through player_actions and execute actions
	pass

func execute_enemy_actions():
	# Placeholder: Implement enemy action execution
	pass

func apply_end_of_turn_effects():
	for unit in player_units:
		unit.end_of_turn()
	for unit in enemy_units:
		unit.end_of_turn()

func check_battle_end():
	if player_units.size() == 0 or enemy_units.size() == 0:
		print("Battle ended!")
		# Implement battle end logic
		queue_free() # For now, just end the battle
	else:
		return false

func record_actions():
	action_history.append(player_actions.duplicate(true)) # Duplicate the dictionary for history

func undo_action():
	if action_history.size() > 1: #Keep one action for the current turn
		action_history.pop_back()
		player_actions = action_history.back().duplicate(true)
		# Update UI to reflect the undone actions
	else:
		print("Cannot undo further.")


func _on_set_pressed() -> void:
	
	pass # Replace with function body.
