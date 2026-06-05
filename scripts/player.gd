extends CharacterBody3D

@export var walkAccleration:float = 8.0
@export var runAccleration:float = 12.0
@export var sprintAccleration:float = 14.0


const SPEED = 6.9
const RUN_SPEED = 10.0
const SPRINT_SPEED = 14.0
const JUMP_VELOCITY = 5.5
const DOUBLE_TAP_WINDOW = 0.3

var spawnPosition: Vector3 = Vector3(0,6,0)
var disabled: bool = false

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var gravVel: Vector3

var last_forward_press_time: float = 0.0
var wantsRun: bool = false

var camera_controller: Node3D
var fsm: FiniteStateMachine

var health = 100
var isDed = false

func kill(message: String = "fuxk you in perticular"):
	print("Reason for Death: " + message)
	self.position = spawnPosition

# NOTE: No changes needed
func get_player_relative_dir(input_dir: Vector2) -> Vector3:
	return (transform.basis * Vector3(input_dir.x, 0, -input_dir.y)).normalized()

# NOTE: No changes needed
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

func get_input_dir() -> Vector2:
	# return Input.get_vector("moveRight","moveLeft", "moveForward", "moveBackward")
	return Input.get_vector("moveLeft","moveRight", "moveBackward", "moveForward")

@warning_ignore("unused_parameter")
func _process(delta: float):
	if Input.is_action_just_pressed("esc"):
		disabled = !disabled

	if Input.is_action_just_pressed("moveForward"):
		var now = Time.get_ticks_msec() / 1000.0
		if now - last_forward_press_time < DOUBLE_TAP_WINDOW:
			wantsRun = true
			print("will run in next input")
		last_forward_press_time = now

	# if fsm.current_state:
	# 	fsm._state_down_call(fsm.current_state.id, "logic_update", delta)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += Vector3.ZERO if is_on_floor() else gravVel.move_toward(Vector3(0, velocity.y - gravity, 0), gravity * delta)
	if fsm.current_state:
		fsm._state_down_call(fsm.current_state.id, "physics_update", delta)

	move_and_slide()
