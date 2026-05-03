class_name Egg extends RigidBody3D

@export var hatch_time: float  = 20.0
@export var larva_pref: Resource

func _ready() -> void:
	add_to_group("eggs")
	print("Egg ready, larva_pref is: ", larva_pref)
	var timer := Timer.new()
	timer.wait_time = hatch_time
	timer.one_shot  = true
	timer.autostart = true
	timer.timeout.connect(_hatch)
	add_child(timer)

func _hatch() -> void:
	print("Hatching! larva_scene is: ", larva_pref)
	if larva_pref == null:
		print("No larva scene assigned to egg!")
		return
	var larva := (larva_pref as PackedScene).instantiate()
	var spawn_pos := global_position
	get_parent().add_child(larva)
	larva.global_position = spawn_pos
	queue_free()
