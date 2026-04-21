class_name LarvaWander extends State

@export var wander_distance: float = 2.0
@export var wander_radius: float   = 1.0
@export var wander_jitter: float   = 1.5
@export var wander_speed: float    = 0.6

@export_group("Gizmos")
@export var show_gizmos: bool = true
@export var col_circle:  Color = Color(0.2, 0.6, 1.0, 0.8)   # blue  - wander circle
@export var col_target:  Color = Color(1.0, 0.9, 0.1, 1.0)   # yellow - current target
@export var col_detect:  Color = Color(0.2, 1.0, 0.4, 0.3)   # green  - food detection radius
@export var col_avoid:   Color = Color(1.0, 0.3, 0.3, 0.3)   # red    - avoid radius

var _wander_target: Vector3
var _world_target:  Vector3   # stored so gizmos can draw it

func _enter() -> void:
	var angle := randf_range(0.0, TAU)
	_wander_target = Vector3(cos(angle), 0.0, sin(angle)) * wander_radius

func _think(delta: float) -> void:
	# ── TRANSITIONS ──────────────────────────────────────────
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
	var jitter := Vector3(randf_range(-1.0, 1.0), 0.0, randf_range(-1.0, 1.0))
	_wander_target += jitter * wander_jitter * delta
	_wander_target   = _wander_target.normalized() * wander_radius

	var local_target := Vector3(0.0, 0.0, -wander_distance) + _wander_target
	_world_target     = boid.global_transform * local_target
	_world_target.y   = boid.global_position.y

	var steering := boid.seek_force(_world_target)
	boid.velocity.x  += steering.x * delta
	boid.velocity.z  += steering.z * delta

	var flat := Vector3(boid.velocity.x, 0.0, boid.velocity.z)
	flat = flat.limit_length(boid.speed * wander_speed)
	boid.velocity.x = flat.x
	boid.velocity.z = flat.z

	# ── GIZMOS ───────────────────────────────────────────────
	if show_gizmos:
		_draw_gizmos()

func _draw_gizmos() -> void:
	var origin := boid.global_position

	# Centre of the wander circle (projected ahead)
	var circle_centre := boid.global_transform * Vector3(0.0, 0.0, -wander_distance)
	circle_centre.y = origin.y

	# Line: boid → circle centre
	DebugDraw3D.draw_line(origin, circle_centre, col_circle)

	# The wander circle itself
	DebugDraw3D.draw_sphere(circle_centre, wander_radius, col_circle)

	# Line: circle centre → current target point
	DebugDraw3D.draw_line(circle_centre, _world_target, col_target)

	# Dot at the target point
	DebugDraw3D.draw_sphere(_world_target, 0.08, col_target)

	# Food detection radius (flat ring at ground level)
	DebugDraw3D.draw_sphere(origin, boid.food_detect_radius, col_detect)

	# Avoidance radius
	DebugDraw3D.draw_sphere(origin, boid.avoid_radius, col_avoid)
