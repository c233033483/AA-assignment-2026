class_name Egg extends RigidBody3D

@export var hatch_time: float  = 20.0
@export var hatch_particle: GPUParticles3D

func _ready() -> void:
	add_to_group("eggs")
	print("Egg ready, larva_pref is: ", "res://Scenes/larva.tscn")
	var timer := Timer.new()
	timer.wait_time = hatch_time
	timer.one_shot  = true
	timer.autostart = true
	timer.timeout.connect(_hatch)
	add_child(timer)

func _hatch() -> void:
	hatch_particle.emitting = true
	var larva_scene := load("res://Scenes/larva.tscn") as PackedScene
	var larva := larva_scene.instantiate()	
	var spawn_pos := global_position
	get_parent().add_child(larva)
	larva.global_position = spawn_pos
	queue_free()
