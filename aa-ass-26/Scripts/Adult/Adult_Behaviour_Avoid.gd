class_name Adult_Behaviour_Avoid extends Steering_Behaviour

@export var avoid_force: float = 6.0

@export_group("Gizmos")
@export var show_gizmos: bool = true
@export var col_avoid: Color  = Color(1.0, 0.3, 0.3, 0.3)
@export var col_push:  Color  = Color(1.0, 0.0, 0.0, 0.9)

func calculate() -> Vector3:
	var adult   := boid as Adult
	var threat  := adult.find_nearest_adult()
	if not threat:
		return Vector3.ZERO

	# Full 3D push away
	var away := (boid.global_position - threat.global_position).normalized() * avoid_force

	if show_gizmos:
		DebugDraw3D.draw_sphere(boid.global_position, adult.avoid_radius, col_avoid)
		DebugDraw3D.draw_line(boid.global_position, boid.global_position + away, col_push)

	return away
