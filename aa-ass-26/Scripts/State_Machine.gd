class_name StateMachine
extends Node

@export var initial_state: PackedScene
@export var global_state: PackedScene

var current_state: State
var global_state_node: State
var previous_state: State
var boid: Node

func _ready() -> void:
	boid = get_parent()
	
	if global_state:
		global_state_node = global_state.instantiate()
		global_state_node.boid = boid
		global_state_node.state_machine = self
		add_child(global_state_node)
		global_state_node.call_deferred("_enter")
	
	if initial_state:
		var first_state: State = initial_state.instantiate()
		call_deferred("change_state", first_state)

func _process(_delta: float) -> void:
	if current_state:
		current_state._think()
	if global_state_node:
		global_state_node._think()
	
	# Debug display (remove if you don't have DebugDraw2D installed)
	if current_state and current_state.get_script():
		var cur = current_state.get_script().resource_path.get_file()
		var glob = global_state_node.get_script().resource_path.get_file() if global_state_node else "none"
		DebugDraw2D.set_text("SM: " + boid.name, cur + "  |  global: " + glob)

func change_state(new_state: State) -> void:
	if current_state:
		previous_state = current_state
		current_state._exit()
		boid.remove_child(current_state)
		current_state.queue_free()
	
	current_state = new_state
	
	if current_state:
		current_state.boid = boid
		current_state.state_machine = self
		boid.add_child(current_state)
		current_state._enter()
	
	_log_transition()

func revert_to_previous_state() -> void:
	if previous_state:
		change_state(previous_state.duplicate())

func _log_transition() -> void:
	if current_state and current_state.get_script():
		var state_name = current_state.get_script().resource_path.get_file().get_basename()
		print("[%s] → %s" % [boid.name, state_name])
