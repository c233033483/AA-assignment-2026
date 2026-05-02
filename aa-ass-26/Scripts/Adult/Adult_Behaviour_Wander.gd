class_name Adult_Behaviour_Wander extends Steering_Behaviour

@export var wander_distance: float = 3.0
@export var wander_radius:   float = 2.0
@export var wander_jitter:   float = 30.0

@export_group("Gizmos")
@export var show_gizmos: bool = true
@export var col_circle: Color = Color(0.2, 0.6, 1.0, 0.8)
@export var col_target: Color = Color(1.0, 0.9, 0.1, 1.0)

var _wander_target: Vector3
var _world_target:  Vector3

func _ready() -> void:
	super()
	var angle      := randf_range(0.0, TAU)
	var phi        := randf_range(-PI * 0.5, PI * 0.5)
	_wander_target  = Vector3(cos(angle) * cos(phi), sin(phi), sin(angle) * cos(phi)) * wander_radius

func calculate() -> Vector3:
	var delta  := get_process_delta_time()
	var adult  := boid as Adult

	# Jitter in 3D
	var jitter     := Vector3(randf_range(-1.0,1.0), randf_range(-0.5,0.5), randf_range(-1.0,1.0))
	_wander_target += jitter * wander_jitter * delta
	_wander_target  = _wander_target.normalized() * wander_radius

	# Clamp Y so it stays in fly height range
	_wander_target.y = clampf(_wander_target.y, -wander_radius * 0.5, wander_radius * 0.5)

	var vel           := adult.linear_velocity
	var forward       := vel.normalized() if vel.length() > 0.1 else -boid.global_transform.basis.z
	var circle_origin := boid.global_position + forward * wander_distance
	_world_target      = circle_origin + _wander_target

	# Keep within fly height
	_world_target.y = clampf(_world_target.y, adult.fly_height_min, adult.fly_height_max)

	if show_gizmos:
		DebugDraw3D.draw_line(boid.global_position, circle_origin, col_circle)
		DebugDraw3D.draw_sphere(circle_origin, wander_radius, col_circle)
		DebugDraw3D.draw_line(circle_origin, _world_target, col_target)
		DebugDraw3D.draw_sphere(_world_target, 0.12, col_target)

	return boid.seek_force(_world_target)
