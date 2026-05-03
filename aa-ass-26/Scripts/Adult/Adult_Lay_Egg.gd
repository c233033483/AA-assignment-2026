class_name Adult_Lay_Egg extends State

func _enter() -> void:
	# Stop all movement while laying
	boid.get_behaviour("Behaviour_Wander").enabled = false
	boid.get_behaviour("Behaviour_Seek").enabled = false
	boid.get_behaviour("Behaviour_Avoid").enabled = false
	boid.get_behaviour("Behaviour_Bounds").enabled = true

	(boid as Adult).lay_egg()
	sm.change_state(sm.get_node("Adult_Wander") as State)
