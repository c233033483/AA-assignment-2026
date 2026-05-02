class_name AdultState extends Node

var boid: Adult
var sm: StateMachine

func _ready() -> void:
	sm   = get_parent() as StateMachine
	boid = sm.get_parent() as Adult

func _enter() -> void:
	pass

func _exit() -> void:
	pass

func _think(_delta: float) -> void:
	pass
