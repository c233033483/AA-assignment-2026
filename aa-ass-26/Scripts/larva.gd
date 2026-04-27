class_name Larva extends CharacterBody3D

@export var speed: float = 3.0
@export var max_force: float = 4.0
@export var turn_speed: float = 4.0
@export var food_detect_radius: float = 8.0
@export var avoid_radius: float = 2.0
@export var bounds_radius: float = 9.0

var target_food: Node3D = null

# State cooldown — prevents flickering between states
var _state_cooldown: float = 0.0
const MIN_STATE_TIME: float = 0.4

func _ready() -> void:
	add_to_group("larvas")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= 9.8 * delta

	move_and_slide()

	_state_cooldown -= delta

	var flat_pos := Vector3(global_position.x, 0.0, global_position.z)
	if flat_pos.length() > bounds_radius:
		var push := -flat_pos.normalized() * speed
		velocity.x = push.x
		velocity.z = push.z

	var flat_vel := Vector3(velocity.x, 0.0, velocity.z)
	if flat_vel.length() > 0.1:
		look_at(global_position + flat_vel, Vector3.UP)

# Clamped seek force — can't exceed max_force per second
func seek_force(target_pos: Vector3) -> Vector3:
	var desired := (target_pos - global_position).normalized() * speed
	var steering := desired - velocity
	return steering.limit_length(max_force)

func can_change_state() -> bool:
	return _state_cooldown <= 0.0

func reset_state_cooldown() -> void:
	_state_cooldown = MIN_STATE_TIME

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
