# TileResource.gd
extends Resource
class_name TileResource

@export var tile_name: String = "Default Tile"
@export var tile_atlas_pos:  Vector2i = Vector2i(0,0)
@export var id: int = 1
@export var tile_effects: Array[TileEffectResource] # Assuming you have TileEffectResource.
@export var is_walkable: bool = true
# Add other properties as needed (e.g., collision shape, animation data).
