extends CharacterBody3D

@export var target:Node3D

@export var speed = 2.0
@export var acceleration:Vector3 = Vector3.ZERO
@export var force:Vector3 = Vector3.ZERO

@export var seek_enabled:bool = false

func _physics_process(delta: float) -> void:
	var currentForce = calculate_force()
	 

func calculate_force():
	var f:Vector3
	return f


func arrive():
	var to_target = target.global_position
