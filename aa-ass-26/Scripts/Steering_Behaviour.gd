class_name Steering_Behaviour extends Node

@export var enabled: bool = false
@export var weight:  float = 1.0

var boid: Node3D

func _ready() -> void:
	boid = get_parent().get_parent() as Node3D

## Override this in each behaviour — return a steering force Vector3
func calculate() -> Vector3:
	return Vector3.ZERO
