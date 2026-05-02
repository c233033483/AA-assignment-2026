class_name Adult_Wander extends State

func _enter() -> void:
	boid.get_behaviour("Behaviour_Wander").enabled = true
	boid.get_behaviour("Behaviour_Bounds").enabled = true
	boid.get_behaviour("Behaviour_Seek").enabled   = false
	boid.get_behaviour("Behaviour_Avoid").enabled  = false

func _think(_delta: float) -> void:
	var food := (boid as Adult).find_nearest_food()
	if food:
		boid.target_food = food
		sm.change_state(sm.get_node("Adult_Seek") as State)
		return

	if boid.find_nearest_adult():
		sm.change_state(sm.get_node("Adult_Avoid") as State)
