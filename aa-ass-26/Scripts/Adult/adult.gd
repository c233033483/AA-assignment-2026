class_name Adult extends RigidBody3D

@export var speed: float = 4.0
@export var max_force: float = 6.0
@export var turn_speed: float = 2.0
@export var food_detect_radius: float = 8.0
@export var avoid_radius: float = 2.0
@export var bounds_radius: float = 9.0
@export var fly_height_min: float = 1.0
@export var fly_height_max: float = 6.0

var target_food: Node3D = null
var food_eaten: int = 0

@export var food_to_lay_egg: int = 5
@export var egg_scene: Resource

@onready var _behaviours: Array[Steering_Behaviour] = []

func _ready() -> void:
	add_to_group("adults")
	gravity_scale = 0.0
	for child in $Behaviours.get_children():
		if child is Steering_Behaviour:
			_behaviours.append(child)

func _physics_process(delta: float) -> void:
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

	linear_velocity = linear_velocity.lerp(linear_velocity + force_acc, turn_speed * delta)

	if linear_velocity.length() > 0.1:
		look_at(global_position + linear_velocity, Vector3.UP)

func seek_force(target_pos: Vector3) -> Vector3:
	var desired := (target_pos - global_position).normalized() * speed
	return (desired - linear_velocity).limit_length(max_force)

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
 
func find_nearest_adult() -> Node3D:
	var nearest: Node3D = null
	var best_dist := avoid_radius
	for a: Node3D in get_tree().get_nodes_in_group("adults"):
		if a == self:
			continue
		var d := global_position.distance_to(a.global_position)
		if d < best_dist:
			best_dist = d
			nearest = a
	return nearest
 
func eat_food() -> void:
	food_eaten += 1
	print("Adult food eaten: %d / %d" % [food_eaten, food_to_lay_egg])
	if food_eaten >= food_to_lay_egg:
		food_eaten = 0
		$StateMachine.change_state($StateMachine.get_node("Adult_Lay_Egg") as State)
 
func lay_egg() -> void:
	if egg_scene == null:
		print("No egg scene assigned!")
		return
	var egg := (egg_scene as PackedScene).instantiate()
	var spawn_pos := global_position
	get_parent().add_child(egg)
	egg.global_position = spawn_pos
	print("Egg laid!")
