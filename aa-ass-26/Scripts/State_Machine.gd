class_name StateMachine extends Node

@export var initial_state: NodePath

var current_state: State
var boid: Larva

func _ready() -> void:
	boid = get_parent() as Larva
	if initial_state:
		current_state = get_node(initial_state) as State
		current_state.call_deferred("_enter")

func change_state(new_state: State) -> void:
	if current_state:
		current_state._exit()
	current_state = new_state
	boid.reset_state_cooldown()
	if current_state:
		current_state._enter()
	print("[SM] → ", current_state.name)

func _process(delta: float) -> void:
	if current_state:
		current_state._think(delta)
