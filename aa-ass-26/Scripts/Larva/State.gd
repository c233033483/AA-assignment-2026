class_name State extends Node

var boid: Node3D
var sm: StateMachine

func _ready() -> void:
	sm = get_parent() as StateMachine
	boid = sm.get_parent() as Node3D

func _enter() -> void:
	pass

func _exit() -> void:
	pass

func _think(_delta: float) -> void:
	pass
