extends Node3D

@export var food_count: int = 12
@export var spawn_radius: float = 7.0

func _ready() -> void:
	_spawn_food()

func _spawn_food() -> void:
	for i in food_count:
		_spawn_one_food()

func _spawn_one_food() -> void:
	var food := Node3D.new()
	food.add_to_group("food")
	food.position = Vector3(
		randf_range(-spawn_radius, spawn_radius),
		0.15,
		randf_range(-spawn_radius, spawn_radius)
	)
	var mesh_inst := MeshInstance3D.new()
	var sphere    := SphereMesh.new()
	sphere.radius = 0.15
	sphere.height = 0.3
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(0.2, 0.8, 0.2)
	mesh_inst.mesh              = sphere
	mesh_inst.material_override = mat
	food.add_child(mesh_inst)
	add_child(food)
