class_name Larva_Wander extends State

func _enter() -> void:
	boid.get_behaviour("Wander").enabled = true
	boid.get_behaviour("Bounds").enabled = true
	boid.get_behaviour("Seek").enabled   = false
	boid.get_behaviour("Avoid").enabled  = false

func _think(_delta: float) -> void:
	var food := boid.find_nearest_food()
	if food:
		boid.target_food = food
		sm.change_state(sm.get_node("LarvaSeek") as State)
		return

	if boid.find_nearest_larva():
		sm.change_state(sm.get_node("LarvaAvoid") as State)
