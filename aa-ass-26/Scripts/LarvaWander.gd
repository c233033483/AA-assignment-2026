class_name LarvaWander extends State

@export var wander_distance: float = 3.0
@export var wander_radius: float   = 2.0
@export var wander_jitter: float   = 30.0  # high because it's multiplied by delta
@export var wander_speed: float    = 0.6

@export_group("Gizmos")
@export var show_gizmos: bool = true
@export var col_circle: Color = Color(0.2, 0.6, 1.0, 0.8)
@export var col_target: Color = Color(1.0, 0.9, 0.1, 1.0)
@export var col_detect: Color = Color(0.2, 1.0, 0.4, 0.3)
@export var col_avoid:  Color = Color(1.0, 0.3, 0.3, 0.3)

var _wander_target: Vector3
var _world_target:  Vector3

func _enter() -> void:
	var angle := randf_range(0.0, TAU)
	_wander_target = Vector3(cos(angle), 0.0, sin(angle)) * wander_radius

func _think(delta: float) -> void:
	# ── TRANSITIONS ──────────────────────────────────────────
	if not boid.can_change_state():
		return
	var food := boid.find_nearest_food()
	if food:
		boid.target_food = food
		sm.change_state(sm.get_node("LarvaSeek") as State)
		return

	var threat := boid.find_nearest_larva()
	if threat:
		sm.change_state(sm.get_node("LarvaAvoid") as State)
		return

	# ── WANDER STEERING ──────────────────────────────────────
	# Jitter the target around the circle
	var jitter := Vector3(randf_range(-1.0, 1.0), 0.0, randf_range(-1.0, 1.0))
	_wander_target += jitter * wander_jitter * delta
	_wander_target   = _wander_target.normalized() * wander_radius

	# Use velocity direction as forward rather than transform basis,
	# so the circle projects correctly even before look_at fires
	var flat_vel := Vector3(boid.velocity.x, 0.0, boid.velocity.z)
	var forward  := flat_vel.normalized() if flat_vel.length() > 0.1 \
					else -boid.global_transform.basis.z

	var circle_origin := boid.global_position + forward * wander_distance
	_world_target      = circle_origin + _wander_target
	_world_target.y    = boid.global_position.y

	var desired := boid.seek_force(_world_target)
	var flat    := Vector3(boid.velocity.x, 0.0, boid.velocity.z)
	flat = flat.lerp(desired, boid.turn_speed * delta)
	boid.velocity.x = flat.x
	boid.velocity.z = flat.z

	if show_gizmos:
		_draw_gizmos(circle_origin)

func _draw_gizmos(circle_origin: Vector3) -> void:
	var origin := boid.global_position

	# Line: boid → circle centre
	DebugDraw3D.draw_line(origin, circle_origin, col_circle)
	# Wander circle
	DebugDraw3D.draw_sphere(circle_origin, wander_radius, col_circle)
	# Line: circle centre → target point on circle
	DebugDraw3D.draw_line(circle_origin, _world_target, col_target)
	# Target dot
	DebugDraw3D.draw_sphere(_world_target, 0.12, col_target)
	# Detection radii
	DebugDraw3D.draw_sphere(origin, boid.food_detect_radius, col_detect)
	DebugDraw3D.draw_sphere(origin, boid.avoid_radius, col_avoid)
