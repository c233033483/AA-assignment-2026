class_name Behaviour_Bounds extends Steering_Behaviour

## Pushes the boid back toward centre when it exceeds bounds_radius
func calculate() -> Vector3:
	var flat_pos := Vector3(boid.global_position.x, 0.0, boid.global_position.z)
	if flat_pos.length() < boid.bounds_radius:
		return Vector3.ZERO
	return boid.seek_force(Vector3.ZERO)
