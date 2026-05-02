class_name Adult_Behaviour_Bounds extends Steering_Behaviour

func calculate() -> Vector3:
	var adult    := boid as Adult
	var pos      := boid.global_position
	var flat_pos := Vector3(pos.x, 0.0, pos.z)
	var force    := Vector3.ZERO

	# Horizontal boundary
	if flat_pos.length() > adult.bounds_radius:
		force += boid.seek_force(Vector3(0.0, pos.y, 0.0))

	# Vertical boundary — push back into fly height range
	if pos.y < adult.fly_height_min:
		force += boid.seek_force(Vector3(pos.x, adult.fly_height_min, pos.z))
	elif pos.y > adult.fly_height_max:
		force += boid.seek_force(Vector3(pos.x, adult.fly_height_max, pos.z))

	return force
