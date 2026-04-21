class_name Creature
extends CharacterBody3D

# Life Stage
enum Stage { LARVA, ADULT }
var stage: Stage = Stage.LARVA

# Stats and Vars
@export var speed: float = 2.0
@export var max_energy: float = 100.0
@export var energy_drain: float = 3.0
@export var flight_height: float = 2.0
@export var mate_detection_radius: float = 5.0
@export var bounds_radius: float = 10.0

var energy: float = 50.0
var lifespan_timer: float = 30.0   # seconds before adult dies of old age

# --- Targeting ---
var target_food: Node3D = null
var target_mate: Node3D = null
var has_mate: bool = false
var has_laid_egg: bool = false

# --- Internal refs ---
@onready var state_machine: StateMachine = $StateMachine
#@onready var larva_mesh: Node3D = $LarvaMesh
#@onready var adult_mesh: Node3D = $AdultMesh

func _ready() -> void:
	add_to_group("creatures")
	energy = max_energy * 0.5
	#adult_mesh.visible = false

func _physics_process(delta: float) -> void:
	energy -= energy_drain * delta
	energy = clamp(energy, 0.0, max_energy)

	if stage == Stage.ADULT:
		lifespan_timer -= delta

	if stage == Stage.LARVA:
		if not is_on_floor():
			velocity.y -= 9.8 * delta

	move_and_slide()

func evolve_to_adult() -> void:
	stage = Stage.ADULT
	speed = 3.5
	energy = max_energy
	lifespan_timer = 30.0
	#larva_mesh.visible = false
	#adult_mesh.visible = true
	print(name + " evolved into adult!")

func die() -> void:
	remove_from_group("creatures")
	queue_free()
