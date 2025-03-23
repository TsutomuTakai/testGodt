# GridHighlight.gd
extends Control

@onready var grid_manager: GridController = get_parent() # Assign your GridManager in the Inspector
@export var highlight_texture: Texture2D # Assign your highlight texture in the Inspector

var highlight_sprite: Sprite2D

func _ready():
	highlight_sprite = Sprite2D.new()
	highlight_sprite.texture = highlight_texture
	highlight_sprite.visible = false
	add_child(highlight_sprite)

func _process(delta):
	update_highlight()

func update_highlight():
	var mouse_pos = get_global_mouse_position()

	var player_mouse_local = grid_manager.player_tilemap.to_local(mouse_pos)
	var enemy_mouse_local = grid_manager.enemy_tilemap.to_local(mouse_pos)

	var player_grid_pos = grid_manager.player_tilemap.local_to_map(player_mouse_local)
	var enemy_grid_pos = grid_manager.enemy_tilemap.local_to_map(enemy_mouse_local)
	#player_tilemap.material.set_shader_parameter("highlight_tile", Vector2(2, 2))
	
	if player_grid_pos.x >= 0 and player_grid_pos.x < grid_manager.grid_width and player_grid_pos.y >= 0 and player_grid_pos.y < grid_manager.grid_height:
		highlight_sprite.visible = true
		highlight_sprite.position = grid_manager.to_global(grid_manager.player_tilemap.map_to_local(player_grid_pos)) + grid_manager.initial_player_offset
	elif enemy_grid_pos.x >= 0 and enemy_grid_pos.x < grid_manager.grid_width and enemy_grid_pos.y >= 0 and enemy_grid_pos.y < grid_manager.grid_height:
		highlight_sprite.visible = true
		highlight_sprite.position = grid_manager.to_global(grid_manager.enemy_tilemap.map_to_local(enemy_grid_pos)) + grid_manager.initial_enemy_offset
	else:
		highlight_sprite.visible = false
