class_name Behaviour_Avoid extends Steering_Behaviour

@export var avoid_force: float = 6.0

@export_group("Gizmos")
@export var show_gizmos: bool = true
@export var col_avoid: Color  = Color(1.0, 0.3, 0.3, 0.3)
@export var col_push:  Color  = Color(1.0, 0.0, 0.0, 0.9)

func calculate() -> Vector3:
	var threat := (boid as Larva).find_nearest_larva()
	if not threat:
		return Vector3.ZERO

	var away := (boid.global_position - threat.global_position)
	away.y = 0.0
	away   = away.normalized() * avoid_force

	if show_gizmos:
		DebugDraw3D.draw_sphere(boid.global_position, boid.avoid_radius, col_avoid)
		DebugDraw3D.draw_line(boid.global_position, boid.global_position + away, col_push)

	return away
