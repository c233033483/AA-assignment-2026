class_name Adult_Avoid extends State

func _enter() -> void:
	boid.get_behaviour("Behaviour_Avoid").enabled  = true
	boid.get_behaviour("Behaviour_Bounds").enabled = true
	boid.get_behaviour("Behaviour_Wander").enabled = false
	boid.get_behaviour("Behaviour_Seek").enabled   = false

func _think(_delta: float) -> void:
	if not boid.find_nearest_adult():
		if is_instance_valid(boid.target_food):
			sm.change_state(sm.get_node("Adult_Seek") as State)
		else:
			sm.change_state(sm.get_node("Adult_Wander") as State)e
