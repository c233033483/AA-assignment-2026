extends Node3D

@export var segment_count: int    = 7
@export var body_length: float    = 0.5
@export var arch_height: float    = 0.15
@export var wave_speed: float     = 5.0
@export var colour: Color         = Color(0.4, 0.8, 0.5)

var _segments: Array[MeshInstance3D] = []
var _trail: Array[Vector3]           = []   # world positions history
var _time: float = 0.0
var _boid: CharacterBody3D

# Spacing between trail sample points
var _sample_spacing: float

func _ready() -> void:
	_boid     = get_parent() as CharacterBody3D
	_sample_spacing = body_length / float(segment_count - 1)
	_build_segments()
	# Initialise trail at boid position
	for i in segment_count:
		_trail.append(_boid.global_position)

func _build_segments() -> void:
	for i in segment_count:
		var mi   := MeshInstance3D.new()
		var mesh := SphereMesh.new()

		# Head biggest, tapers to tail
		var t      := float(i) / float(segment_count - 1)  # 0=head, 1=tail
		var radius := lerpf(0.1, 0.04, t)
		mesh.radius = radius
		mesh.height = radius * 2.0

		var mat := StandardMaterial3D.new()
		mat.albedo_color               = colour.lerp(colour * 0.4, t)
		mat.emission_enabled           = true
		mat.emission                   = colour * 0.3
		mat.emission_energy_multiplier = lerpf(0.5, 0.1, t)
		mi.mesh              = mesh
		mi.material_override = mat

		add_child(mi)
		_segments.append(mi)

func _process(delta: float) -> void:
	var speed := Vector3(_boid.velocity.x, 0.0, _boid.velocity.z).length()
	_time += delta * wave_speed

	# Push head position into front of trail
	_trail.push_front(_boid.global_position)

	# Keep trail from growing forever — only need enough points
	while _trail.size() > segment_count * 20:
		_trail.pop_back()

	for i in segment_count:
		var target_dist := float(i) * _sample_spacing
		# Place each segment along the trail at even spacing
		var dist_acc: float = 0.0
		var trail_idx: int  = 0
		var placed: bool
		# Walk along trail until we've covered target_dist
		while trail_idx + 1 < _trail.size():
			var step := _trail[trail_idx].distance_to(_trail[trail_idx + 1])
			if dist_acc + step >= target_dist:
				var t_lerp := (target_dist - dist_acc) / step
				var world_pos := _trail[trail_idx].lerp(_trail[trail_idx + 1], t_lerp)

				# Arch — middle segments rise up
				var seg_t  := float(i) / float(segment_count - 1)
				var arch: float = sin(seg_t * PI) * arch_height * (0.5 + sin(_time - seg_t * PI) * 0.5)
				world_pos.y += arch

				# Place in world space (node is child of boid so convert)
				_segments[i].global_position = world_pos
				placed = true
				break
			dist_acc  += step
			trail_idx += 1
			
			# Fallback if no valid segment found
		if not placed:
			_segments[i].global_position = _trail.back()
