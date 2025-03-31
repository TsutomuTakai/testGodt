# ActionResource.gd
extends Resource

class_name ActionResource

@export var action_name: String = "Attack"
@export var effects: Array[Effect] # List of Effect classes
@export var animation_name: String = "attack"
@export var energy_cost: int = 2
@export var power: int = 1
@export var range: int = 1
@export var aoe: AoE
@export var instant: bool = false
@export var repeats: int = 0
@export var target: target_type = target_type.FRONT 

enum target_type {
	FRONT,
	BACK,
	SELF,
	FRONT_SKIP,
	BACK_SKIPT,
	ALL_SELF,
	ALL
}



var action_dict = StatusDictionary.new()
func ready():
	for effect in effects:
		if effect.instant:
			self.instant = true
	
func get_targets(pos: Vector2i) -> void:
	pass

func execute_action(unit: Unit) -> void:
	print(action_dict)
	pass 

func calculate_action(unit: Unit, enem: Unit, turn_array : Array) -> StatusDictionary:
	var d = StatusDictionary.new()
	for effect in effects:
		effect.calc_effect(d,unit,enem, power, turn_array)
	return d
