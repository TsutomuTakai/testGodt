# Unit.gd
extends AnimatableBody2D
class_name Unit
@export var unit_name: String = "Base Unit"
@export var health: int = 10:
	set(value):
		health =+ value
		emit_signal("health_changed", health)
@export var poison: int = 0 
@export var actions: Array[ActionResource] = []
@export var unit_type: UnitType = UnitType.PLAYER # Default to player
@export var active: bool = false
@export var turn_dict: StatusDictionary
@export var reflect: int = 0
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var area_2d: Area2D = $Area2D


enum UnitType { PLAYER, ENEMY }
enum State { IDLE, ATTACK }

var grid_position: Vector2i
var current_state : State = State.IDLE
var face: String


signal unit_selected(unit)
signal health_changed(new_health)

# Init 
func _ready():
	area_2d.input_pickable = true
	face = "back" if unit_type == UnitType.PLAYER else "front"
	set_state(State.IDLE)

# State 
func get_animation_name_from_state(state: State):
	match state:
		State.IDLE:
			return "idle_"  + face
		State.ATTACK:
			return "attack_" + face
		_:
			return "idle_" + face # Default case

func set_state(new_state: State):
	current_state = new_state
	var animation_name = get_animation_name_from_state(new_state)
	animated_sprite.play(animation_name)


func play_animation(animation_name: String):
	if animated_sprite.has_animation(animation_name):
		animated_sprite.play(animation_name)
	else:
		print("Animation", animation_name, "not found.")

func move_to(target_position: Vector2):
	var tween = create_tween()
	tween.tween_property(self, "position", target_position, 0.5) # Smooth move over 0.5 seconds


func set_grid_position(grid_pos: Vector2i, grid_controller: Node2D):
	grid_position = grid_pos
	if unit_type == UnitType.PLAYER:
		position =grid_controller.grid_to_world(grid_controller.GridType.PLAYER, grid_pos.x, grid_pos.y)
	elif unit_type == UnitType.ENEMY:
		position = grid_controller.grid_to_world(grid_controller.GridType.ENEMY, grid_pos.x, grid_pos.y) 
	
