class_name Larva_Avoid extends State

@export var avoid_force: float = 6.0   # how hard to push away

func _think(delta: float) -> void:
	var threat := boid.find_nearest_larva()

	# ── TRANSITIONS ──────────────────────────────────────────
	if not boid.can_change_state():
		return
	if not threat:
		# Safe — resume food seek if we still have a target, else wander
		if is_instance_valid(boid.target_food):
			sm.change_state(sm.get_node("LarvaSeek") as State)
		else:
			sm.change_state(sm.get_node("LarvaWander") as State)
		return

	# ── AVOIDANCE STEERING ───────────────────────────────────
	var away := (boid.global_position - threat.global_position)
	away.y = 0.0
	away   = away.normalized() * avoid_force

	boid.velocity.x += away.x * delta
	boid.velocity.z += away.z * delta

	var flat := Vector3(boid.velocity.x, 0.0, boid.velocity.z)
	flat = flat.limit_length(boid.speed)
	boid.velocity.x = flat.x
	boid.velocity.z = flat.z
