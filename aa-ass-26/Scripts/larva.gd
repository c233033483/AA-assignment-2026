class_name Larva
extends CharacterBody3D

# Stats
@export var speed: float = 2.0
@export var max_energy: float = 100.0
@export var energy_drain: float = 3.0
@export var bounds_radius: float = 10.0

var energy: float = 50.0

# Targeting
var target_food: Node3D = null

# Internal refs
@onready var state_machine: StateMachine = $StateMachine
@onready var mesh: Node3D = $Mesh

func _ready() -> void:
	add_to_group("creatures")
	energy = max_energy * 0.5

func _physics_process(delta: float) -> void:
	energy -= energy_drain * delta
	energy = clamp(energy, 0.0, max_energy)

	# Gravity
	if not is_on_floor():
		velocity.y -= 9.8 * delta

	move_and_slide()


#func evolve() -> void:
	#var adult_scene = preload("res://scenes/Adult.tscn")
	#var adult: Adult = adult_scene.instantiate()
	#adult.global_position = global_position
	## Pass along anything the adult should inherit
	#adult.energy = max_energy  # born with full energy after evolving
	#get_tree().current_scene.add_child(adult)
	#die()

func die() -> void:
	remove_from_group("creatures")
	queue_free()

func seek_force(target: Vector3) -> Vector3:
	var desired = (target - global_position).normalized() * speed
	return desired - velocity
