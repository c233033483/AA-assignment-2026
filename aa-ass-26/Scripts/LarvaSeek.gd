class_name LarvaSeek extends State

@export var arrival_radius: float = 0.5   # how close = "eaten"

func _think(delta: float) -> void:
	# ── TRANSITIONS ──────────────────────────────────────────
	if not boid.can_change_state():
		return
	if not is_instance_valid(boid.target_food):
		boid.target_food = null
		sm.change_state(sm.get_node("LarvaWander") as State)
		return

	var threat := boid.find_nearest_larva()
	if threat:
		sm.change_state(sm.get_node("LarvaAvoid") as State)
		return

	# ── SEEK STEERING ────────────────────────────────────────
	var target_pos := boid.target_food.global_position
	var dist       := boid.global_position.distance_to(target_pos)

	if dist < arrival_radius:
		# Arrived — consume food and go back to wandering
		boid.target_food.queue_free()
		boid.target_food = null
		sm.change_state(sm.get_node("LarvaWander") as State)
		return

	var desired := boid.seek_force(target_pos)
	var flat := Vector3(boid.velocity.x, 0.0, boid.velocity.z)
	flat = flat.lerp(desired, boid.turn_speed * delta)
	boid.velocity.x = flat.x
	boid.velocity.z = flat.z
