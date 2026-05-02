class_name LarvaGlobal
extends State

func _think() -> void:
	# Die if out of energy
	if boid.energy <= 0.0:
		boid.die()
		return
	
	# Evolve once energy is full
	if boid.energy >= boid.max_energy:
		boid.evolve_to_adult()
		#state_machine.change_state(AdultWander.new())
