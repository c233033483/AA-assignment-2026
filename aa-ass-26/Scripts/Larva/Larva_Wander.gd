class_name Larva_Wander extends State

func _enter() -> void:
	boid.get_behaviour("Behaviour_Wander").enabled = true
	boid.get_behaviour("Behaviour_Bounds").enabled = true
	boid.get_behaviour("Behaviour_Seek").enabled   = false
	boid.get_behaviour("Behaviour_Avoid").enabled  = false

func _think(_delta: float) -> void:
	var food := (boid as Larva).find_nearest_food()
	if food:
		boid.target_food = food
		sm.change_state(sm.get_node("Larva_Seek") as State)
		return

	if boid.find_nearest_larva():
		sm.change_state(sm.get_node("Larva_Avoid") as State)
