# TileEffectResource.gd
extends Resource
class_name TileEffectResource

@export var effect_name: String = "Default Effect"
@export var effect_type: String = "damage" # "damage", "heal", etc.
@export var effect_value: int = 10
@export var effect_duration: int = 1 # Turns.
# Add other properties as needed.
