class_name Larva_Seek extends State

@export var arrival_radius: float = 0.5

func _enter() -> void:
	boid.get_behaviour("Seek").enabled   = true
	boid.get_behaviour("Bounds").enabled = true
	boid.get_behaviour("Wander").enabled = false
	boid.get_behaviour("Avoid").enabled  = false

func _think(_delta: float) -> void:
	if boid.find_nearest_larva():
		sm.change_state(sm.get_node("LarvaAvoid") as State)
		return

	if not is_instance_valid(boid.target_food):
		boid.target_food = null
		sm.change_state(sm.get_node("LarvaWander") as State)
		return

	if boid.global_position.distance_to(boid.target_food.global_position) < arrival_radius:
		boid.target_food.queue_free()
		boid.target_food = null
		sm.change_state(sm.get_node("LarvaWander") as State)
