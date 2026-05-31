extends CharacterBody3D

const SPEED = 6.9
const JUMP_VELOCITY = 5.5
const DOUBLE_TAP_WINDOW = 0.3
const RUN_SPEED = 10.0
const SPRINT_SPEED = 14.0

var spawnPosition: Vector3 = Vector3(0,6,0)
var gravity: Vector3 = Vector3(0,-9.8,0)
var disabled: bool = false
var last_w_press_time: float = 0.0
var wants_sprint: bool = false
var camera_controller: Node3D
var fsm: FiniteStateMachine

var _w_was_pressed: bool = false
var _shift_was_pressed: bool = false
var _esc_was_pressed: bool = false

var w_just_pressed: bool = false
var shift_just_pressed: bool = false
var esc_just_pressed: bool = false

func kill(message: String):
	print("Reason for Death: " + message)
	self.position = spawnPosition

func get_input_dir() -> Vector2:
	var x = 0.0
	if Input.is_key_pressed(KEY_D): x += 1.0
	if Input.is_key_pressed(KEY_A): x -= 1.0
	var y = 0.0
	if Input.is_key_pressed(KEY_W): y += 1.0
	if Input.is_key_pressed(KEY_S): y -= 1.0
	return Vector2(x, y)

func get_player_relative_dir(input_dir: Vector2) -> Vector3:
	return (transform.basis * Vector3(input_dir.x, 0, -input_dir.y)).normalized()

func get_camera_relative_dir(input_dir: Vector2) -> Vector3:
	var cam_basis = camera_controller.transform.basis
	var forward = Vector3(-cam_basis.z.x, 0, -cam_basis.z.z).normalized()
	var right = Vector3(cam_basis.x.x, 0, cam_basis.x.z).normalized()
	return (forward * input_dir.y + right * input_dir.x).normalized()

func _input(_event: InputEvent) -> void:
	pass

func _ready() -> void:
	camera_controller = $camerAnchor/cameraController
	fsm = $movementStateMachine
	fsm.set_physics_process(false)

func _physics_process(delta: float) -> void:
	w_just_pressed = Input.is_key_pressed(KEY_W) and not _w_was_pressed
	_w_was_pressed = Input.is_key_pressed(KEY_W)

	shift_just_pressed = Input.is_key_pressed(KEY_SHIFT) and not _shift_was_pressed
	_shift_was_pressed = Input.is_key_pressed(KEY_SHIFT)

	esc_just_pressed = Input.is_key_pressed(KEY_ESCAPE) and not _esc_was_pressed
	_esc_was_pressed = Input.is_key_pressed(KEY_ESCAPE)

	if not is_on_floor():
		velocity += gravity * delta

	if esc_just_pressed:
		disabled = !disabled

	if disabled:
		move_and_slide()
		return

	if w_just_pressed:
		var now = Time.get_ticks_msec() / 1000.0
		if now - last_w_press_time < DOUBLE_TAP_WINDOW:
			wants_sprint = true
		last_w_press_time = now

	if fsm.current_state:
		fsm._state_down_call(fsm.current_state.id, "physics_update", delta)

	move_and_slide()
