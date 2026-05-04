extends Node3D

@export var colour: Color     = Color(0.2, 0.5, 0.9)
@export var fin_colour: Color = Color(0.1, 0.3, 0.7)
@export var wave_speed: float = 2.5
@export var fin_flap: float   = 0.4
@export var body_bob: float   = 0.05

var _body: MeshInstance3D
var _fin_l: Node3D
var _fin_r: Node3D
var _time: float = 0.0
var _boid: RigidBody3D

func _ready() -> void:
	_boid = get_parent() as RigidBody3D
	_build()

func _build() -> void:
	# ── BODY ─────────────────────────────────────────────────
	_body = MeshInstance3D.new()
	var body_mesh := BoxMesh.new()
	body_mesh.size = Vector3(0.3, 0.12, 0.9)
	var body_mat  := StandardMaterial3D.new()
	body_mat.albedo_color               = colour
	body_mat.emission_enabled           = true
	body_mat.emission                   = colour * 0.5
	body_mat.emission_energy_multiplier = 0.6
	_body.mesh              = body_mesh
	_body.material_override = body_mat
	add_child(_body)

	# ── FINS ─────────────────────────────────────────────────
	_fin_l = _make_fin(-0.3)   # left  — pivot on left side
	_fin_r = _make_fin( 0.3)   # right — pivot on right side

func _make_fin(x_offset: float) -> Node3D:
	var pivot    := Node3D.new()
	pivot.position = Vector3(x_offset, 0.0, 0.0)
	add_child(pivot)

	var mi   := MeshInstance3D.new()
	var mesh := BoxMesh.new()
	mesh.size = Vector3(0.45, 0.04, 0.55)
	var mat  := StandardMaterial3D.new()
	mat.albedo_color               = fin_colour
	mat.emission_enabled           = true
	mat.emission                   = fin_colour * 0.4
	mat.emission_energy_multiplier = 0.3
	mat.transparency               = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat.albedo_color.a             = 0.75
	mi.mesh              = mesh
	mi.material_override = mat
	# Extend the fin outward from the pivot
	mi.position = Vector3(x_offset * 0.75, 0.0, 0.0)
	pivot.add_child(mi)
	return pivot

func _process(delta: float) -> void:
	var speed := _boid.linear_velocity.length()
	_time     += delta * wave_speed * max(speed * 0.3, 0.4)

	_body.position.y = sin(_time) * body_bob

	# Both fins flap with opposite phase — one up while other is down
	_fin_l.rotation.z =  sin(_time)        * fin_flap
	_fin_r.rotation.z = -sin(_time)   * fin_flap

	wave_speed = lerpf(wave_speed, 1.5 + speed * 1.2, delta * 2.0)
