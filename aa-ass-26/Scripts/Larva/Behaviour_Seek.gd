class_name Behaviour_Seek extends Steering_Behaviour

@export_group("Gizmos")
@export var show_gizmos: bool = true
@export var col_seek: Color = Color(1.0, 0.5, 0.0, 0.9)

func calculate() -> Vector3:
	if not is_instance_valid(boid.target_food):
		return Vector3.ZERO

	var target_pos := (boid as Larva).target_food.global_position

	if show_gizmos:
		DebugDraw3D.draw_line(boid.global_position, target_pos, col_seek)
		DebugDraw3D.draw_sphere(target_pos, 0.2, col_seek)

	return boid.seek_force(target_pos)
