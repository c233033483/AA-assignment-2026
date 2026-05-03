class_name Egg extends RigidBody3D

@export var hatch_time: float  = 20.0
@export var larva_scene: PackedScene

func _ready() -> void:
	add_to_group("eggs")
	var timer := get_tree().create_timer(hatch_time)
	timer.timeout.connect(_hatch)

func _hatch() -> void:
	if larva_scene == null:
		print("No larva scene assigned to egg!")
		return
	var larva       := larva_scene.instantiate()
	var spawn_pos   := global_position
	get_parent().add_child(larva)
	larva.global_position = spawn_pos
	queue_free()
