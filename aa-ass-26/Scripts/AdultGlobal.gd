class_name AdultGlobal
extends State

func _think() -> void:
	if boid.energy <= 0.0:
		boid.die()
		return
	
	if boid.lifespan_timer <= 0.0:
		# Ran out of time without reproducing — just die
		boid.die()
