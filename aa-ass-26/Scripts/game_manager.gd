extends Node3D

@export var spawn_radius: float = 7.0
@export var food_count: int = 12
@export var food_spawn_interval: float = 8.0  #seconds
@export var fly_height_min: float = 3.0
@export var fly_height_max: float = 7.0

@export var larva_count: int = 5
@export var larva_pref: PackedScene

@export var feed_audio: AudioStreamPlayer3D

func _ready() -> void:
	_spawn_larva()
	_spawn_food_wave()
	# Repeatedly drop new food on a timer
	var timer := Timer.new()
	timer.wait_time = food_spawn_interval
	timer.autostart = true
	timer.timeout.connect(_spawn_food_wave)
	add_child(timer)

func _spawn_food_wave() -> void:
	for i in food_count:
		_spawn_one_food()

func _spawn_one_food() -> void:
	feed_audio.play()
	var food := RigidBody3D.new()
	food.add_to_group("food")
	food.gravity_scale = 0.08   # drifts down slowly like fish food
	food.linear_damp   = 1.5    # floaty, won't bounce
	food.position = Vector3(
		randf_range(-spawn_radius, spawn_radius),
		randf_range(fly_height_min, fly_height_max),
		randf_range(-spawn_radius, spawn_radius)
	)

	# Mesh
	var mesh_inst := MeshInstance3D.new()
	var sphere    := SphereMesh.new()
	sphere.radius = 0.15
	sphere.height = 0.3
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(0.2, 0.8, 0.2)
	mesh_inst.mesh              = sphere
	mesh_inst.material_override = mat
	food.add_child(mesh_inst)

	# Collision so it lands on the ground properly
	var col   := CollisionShape3D.new()
	var shape := SphereShape3D.new()
	shape.radius = 0.15
	col.shape    = shape
	food.add_child(col)

	add_child(food)

func _spawn_larva() -> void:
	for i in larva_count:
		if larva_pref == null:
			return
		var larva := larva_pref.instantiate()
		larva.position = Vector3(
			randf_range(-spawn_radius, spawn_radius),
			0.25,
			randf_range(-spawn_radius, spawn_radius)
		)
		add_child(larva)
