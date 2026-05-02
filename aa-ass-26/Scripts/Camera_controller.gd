extends Camera3D

@export var move_speed: float  = 10.0
@export var fast_mult: float   = 3.0   # hold Shift to go faster
@export var sensitivity: float = 0.003

var _mouse_captured := false

func _ready() -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	# Right click to capture/release mouse
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		_mouse_captured = event.pressed
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED if _mouse_captured else Input.MOUSE_MODE_VISIBLE)

	# Mouse look (only when captured)
	if event is InputEventMouseMotion and _mouse_captured:
		rotate_y(-event.relative.x * sensitivity)
		rotate_object_local(Vector3.RIGHT, -event.relative.y * sensitivity)
		# Clamp vertical so you can't flip upside down
		var rot := rotation_degrees
		rot.x = clampf(rot.x, -89.0, 89.0)
		rotation_degrees = rot

func _process(delta: float) -> void:
	if not _mouse_captured:
		return

	var speed := move_speed * (fast_mult if Input.is_key_pressed(KEY_SHIFT) else 1.0)
	var dir   := Vector3.ZERO

	if Input.is_key_pressed(KEY_W): dir -= global_transform.basis.z
	if Input.is_key_pressed(KEY_S): dir += global_transform.basis.z
	if Input.is_key_pressed(KEY_A): dir -= global_transform.basis.x
	if Input.is_key_pressed(KEY_D): dir += global_transform.basis.x
	if Input.is_key_pressed(KEY_E): dir += Vector3.UP
	if Input.is_key_pressed(KEY_Q): dir -= Vector3.UP

	global_position += dir.normalized() * speed * delta
