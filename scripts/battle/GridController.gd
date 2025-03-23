extends Node2D

class_name GridController

@export var grid_width: int = 5
@export var grid_height: int = 5
@export var tile_resources: Array[TileResource]
@export var tile_set: TileSet
@export var cell_size: int = 32
@export var highlight_texture: Texture2D # Export the highlight texture

var player_tilemap:  TileMapLayer
var enemy_tilemap: TileMapLayer

@onready var player_grid_data: Array
@onready var enemy_grid_data: Array
@onready var highlight_sprite: Sprite2D # Rename to highlight_sprite
#Vector2(-cell_size/2, -cell_size*3/4)
var initial_player_offset = Vector2()
var initial_enemy_offset = Vector2() # Adjust as needed
var team1_offset = Vector2()
var team2_offset = Vector2() # Adjust as needed
var team1_center = Vector2()
var team2_center = Vector2() # Adjust as needed
var offset_dict : Dictionary
enum GridType { PLAYER, ENEMY }
var tilemap_width = ((grid_width-1.0)/2.0) * cell_size / 2.0
var tilemap_height = ((grid_height -1.0)/2) * cell_size / 4.0
var internal_offset = Vector2(tilemap_width, tilemap_height)

func _ready():
	player_tilemap = TileMapLayer.new()
	enemy_tilemap = TileMapLayer.new()
	add_child(player_tilemap)
	add_child(enemy_tilemap)
	initial_player_offset =  calculate_offsets(GridType.PLAYER)
	initial_enemy_offset =  calculate_offsets(GridType.ENEMY)
	offset_dict[GridType.PLAYER] = initial_player_offset
	offset_dict[GridType.ENEMY] = initial_enemy_offset
	highlight_sprite = Sprite2D.new() # Rename to highlight_sprite
	highlight_sprite.texture = highlight_texture
	highlight_sprite.visible = false
	add_child(highlight_sprite) # Rename to highlight_sprite
	#draw_grid()
	initialize_grids()
	

func initialize_grids():
	player_grid_data = initialize_grid_data(grid_width, grid_height)
	enemy_grid_data = initialize_grid_data(grid_width, grid_height)
	display_grids()

func initialize_grid_data(width: int, height: int) -> Array:
	var grid_data = []
	for x in width:
		var column = []
		for y in height:
			var random_tile_index = randi() % tile_resources.size()
			column.append({
				"tile_resource": tile_resources[random_tile_index],
				"unit": null
			})
		grid_data.append(column)
	return grid_data

func display_grids():
	display_grid(player_tilemap, player_grid_data,initial_player_offset)
	display_grid(enemy_tilemap, enemy_grid_data,initial_enemy_offset)


func display_grid(tilemap: TileMapLayer, grid_data: Array, offset: Vector2):
	tilemap.clear()
	tilemap.tile_set = tile_set
	tilemap.position = offset
	for x in grid_data.size():
		for y in grid_data[x].size():
			var tile_resource = grid_data[x][y].tile_resource
			var cell_position = to_local(Vector2i(x, y))
			tilemap.set_cell( cell_position, 1, tile_resource.tile_atlas_pos) # layer 0, coords x y, source 0, atlas coords 0 0, tile data.
			#animate_tile_spawn(tilemap, cell_position)

func get_tile_data(grid_type: GridType, x: int, y: int):
	var grid_data = get_grid_data(grid_type)
	if x >= 0 and x < grid_data.size() and y >= 0 and y < grid_data[x].size():
		return grid_data[x][y]
	else:
		return null

func set_tile_data(grid_type: GridType, x: int, y: int, data: Dictionary):
	var grid_data = get_grid_data(grid_type)
	if x >= 0 and x < grid_data.size() and y >= 0 and y < grid_data[x].size():
		grid_data[x][y] = data

func set_unit_on_tile(grid_type: GridType, x: int, y: int, unit):
	var grid_data = get_grid_data(grid_type)
	if x >= 0 and x < grid_data.size() and y >= 0 and y < grid_data[x].size():
		grid_data[x][y].unit = unit

func get_unit_on_tile(grid_type: GridType, x: int, y: int):
	var grid_data = get_grid_data(grid_type)
	if x >= 0 and x < grid_data.size() and y >= 0 and y < grid_data[x].size():
		return grid_data[x][y].unit
	else:
		return null

func grid_to_world(grid_type: GridType, x: int, y: int):
	var tile_size = Vector2i(cell_size, cell_size)
	var player_grid_pos = Vector2i(x, y)
	var world_x = (x - y) * tile_size.x / 2.0
	var world_y = (x + y) * tile_size.y / 4.0
	if grid_type == GridType.PLAYER :
		return to_global(player_tilemap.map_to_local(player_grid_pos)) + offset_dict[grid_type]
	else:
		return to_global(enemy_tilemap.map_to_local(player_grid_pos)) + offset_dict[grid_type]

func world_to_grid(grid_type: GridType, world_position: Vector2):
	var tile_size = Vector2i(cell_size, cell_size)
	var grid_x = (world_position.x / tile_size.x + world_position.y / tile_size.y) 
	var grid_y = (world_position.y / tile_size.y - world_position.x / tile_size.x) 
	return Vector2i(round(grid_x), round(grid_y))

func apply_tile_effects(grid_type: GridType):
	var grid_data = get_grid_data(grid_type)
	for x in grid_data.size():
		for y in grid_data[x].size():
			var tile_data = grid_data[x][y]
			var tile_resource = tile_data.tile_resource
			for effect in tile_resource.tile_effects:
				var unit_on_tile = tile_data.unit
				if unit_on_tile:
					match effect.effect_type:
						"damage":
							unit_on_tile.take_damage(effect.effect_value)
						"heal":
							unit_on_tile.heal(effect.effect_value)

func get_grid_data(grid_type: GridType):
	if grid_type == GridType.PLAYER:
		return player_grid_data
	elif grid_type == GridType.ENEMY:
		return enemy_grid_data
	else:
		return null

func calculate_offsets(side: GridType):
	var team_offset = Vector2()
	
	
	if side ==GridType.PLAYER:
		team_offset = Vector2(-cell_size, 0)
	else:
		team_offset = Vector2((cell_size*(grid_width-1)/2), -(grid_height+1)* cell_size/4.0 )
	return team_offset - internal_offset

func animate_tile_spawn(tilemap: TileMapLayer, cell_position: Vector2i):
	var tile_node = tilemap.get_cell_tile_data(cell_position) # Get the tile data
	if tile_node:
		var tween = create_tween()
		tween.tween_property(tilemap, "position", Vector2(0, 0), 0.0) # Initial scale 0
		#tween.tween_property(tile_sprite, "position", target_position, 0.5).set_ease(Tween.EASE_OUT).set_delay(cell_position.x * 0.05 + cell_position.y * 0.05)
		tween.tween_property(tilemap, "position", Vector2(1, 1), 0.3).set_delay(cell_position.x * 0.05 + cell_position.y * 0.05) # Animate scale to 1 with delay


func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT: # Check for left mouse button click
			var mouse_pos = get_global_mouse_position()
			var player_mouse_local = player_tilemap.to_local(mouse_pos)
			var enemy_mouse_local = enemy_tilemap.to_local(mouse_pos)

			var player_grid_pos = player_tilemap.local_to_map(player_mouse_local)
			var enemy_grid_pos = enemy_tilemap.local_to_map(enemy_mouse_local)
			
			print("Global Mouse:", mouse_pos)
			print("Player Local:", player_mouse_local)
			print("Enemy Local:", enemy_mouse_local)
			print("Player Grid:", player_grid_pos)
			#print("Player Unit", player_grid_data[player_grid_pos.x[player_grid_pos.y]])
			print("Enemy Grid:", enemy_grid_pos)
