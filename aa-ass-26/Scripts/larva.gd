class_name Larva extends CharacterBody3D

@export var food_eaten: int
@export var food_to_evolve: int = 5
@export var adult_pref: PackedScene

@export var speed: float = 3.0
@export var max_force: float = 6.0
@export var turn_speed: float = 4.0
@export var food_detect_radius: float = 8.0
@export var avoid_radius: float = 2.0
@export var bounds_radius: float = 9.0

var target_food: Node3D = null

@onready var _behaviours: Array[Steering_Behaviour] = []

func _ready() -> void:
	add_to_group("larvas")
	for child in $Behaviours.get_children():
		if child is Steering_Behaviour:
			_behaviours.append(child)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= 9.8 * delta

	# Accumulate steering forces in priority order
	var force_acc := Vector3.ZERO
	for b in _behaviours:
		if not b.enabled:
			continue
		var f := b.calculate() * b.weight
		if is_nan(f.x) or is_nan(f.y) or is_nan(f.z):
			continue
		force_acc += f
		if force_acc.length() > max_force:
			force_acc = force_acc.limit_length(max_force)
			break

	# Lerp velocity toward desired force for smooth turning
	var flat := Vector3(velocity.x, 0.0, velocity.z)
	flat = flat.lerp(force_acc, turn_speed * delta)
	velocity.x = flat.x
	velocity.z = flat.z

	move_and_slide()

	var flat_vel := Vector3(velocity.x, 0.0, velocity.z)
	if flat_vel.length() > 0.1:
		look_at(global_position + flat_vel, Vector3.UP)

func seek_force(target_pos: Vector3) -> Vector3:
	var desired := (target_pos - global_position).normalized() * speed
	return (desired - velocity).limit_length(max_force)

func get_behaviour(behaviour_name: String) -> Steering_Behaviour:
	return $Behaviours.get_node(behaviour_name) as Steering_Behaviour

func find_nearest_food() -> Node3D:
	var nearest: Node3D = null
	var best_dist := food_detect_radius
	for f: Node3D in get_tree().get_nodes_in_group("food"):
		var d := global_position.distance_to(f.global_position)
		if d < best_dist:
			best_dist = d
			nearest = f
	return nearest

func find_nearest_larva() -> Node3D:
	var nearest: Node3D = null
	var best_dist := avoid_radius
	for l: Node3D in get_tree().get_nodes_in_group("larvas"):
		if l == self:
			continue
		var d := global_position.distance_to(l.global_position)
		if d < best_dist:
			best_dist = d
			nearest = l
	return nearest

func eat_food() -> void:
	food_eaten += 1
	print("Food eaten: %d / %d" % [food_eaten, food_to_evolve])
	if food_eaten >= food_to_evolve:
		evolve()

func evolve() -> void:
	if adult_pref == null:
		print("No adult scene assigned!")
		return
	var adult := adult_pref.instantiate()
	adult.global_position = global_position
	get_parent().add_child(adult)
	queue_free()
