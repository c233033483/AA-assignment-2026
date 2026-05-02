class_name Behaviour_Wander extends Steering_Behaviour

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
	var angle    := randf_range(0.0, TAU)
	_wander_target = Vector3(cos(angle), 0.0, sin(angle)) * wander_radius

func calculate() -> Vector3:
	var delta := get_process_delta_time()

	var jitter     := Vector3(randf_range(-1.0, 1.0), 0.0, randf_range(-1.0, 1.0))
	_wander_target += jitter * wander_jitter * delta
	_wander_target  = _wander_target.normalized() * wander_radius

	var flat_vel      := Vector3(boid.velocity.x, 0.0, boid.velocity.z)
	var forward       := flat_vel.normalized() if flat_vel.length() > 0.1 \
						 else -boid.global_transform.basis.z

	var circle_origin := boid.global_position + forward * wander_distance
	_world_target      = circle_origin + _wander_target
	_world_target.y    = boid.global_position.y

	if show_gizmos:
		_draw_gizmos(circle_origin)

	return boid.seek_force(_world_target)

func _draw_gizmos(circle_origin: Vector3) -> void:
	var origin := boid.global_position
	DebugDraw3D.draw_line(origin, circle_origin, col_circle)
	DebugDraw3D.draw_sphere(circle_origin, wander_radius, col_circle)
	DebugDraw3D.draw_line(circle_origin, _world_target, col_target)
	DebugDraw3D.draw_sphere(_world_target, 0.12, col_target)
