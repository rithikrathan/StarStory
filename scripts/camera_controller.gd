extends Node3D

@export var mouse_sensitivity: float = 0.002
@export var vertical_limit: float = 90.0

const BASE_FOV: float = 75.0
const FOV_INCREASE: float = 15.0
const MAX_SPEED: float = 14.0

var player: CharacterBody3D
var camera: Camera3D

func _ready() -> void:
	player = get_parent().get_parent() as CharacterBody3D
	camera = $SpringArm3D/Camera3D
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	if player.disabled:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		if event is InputEventMouseMotion:
			rotation.y -= event.relative.x * mouse_sensitivity
			rotation.x -= event.relative.y * mouse_sensitivity
			rotation.x = clamp(rotation.x, deg_to_rad(-vertical_limit), deg_to_rad(vertical_limit))

func _process(delta: float) -> void:
	var speed = Vector3(player.velocity.x, 0, player.velocity.z).length()
	var target_fov = BASE_FOV + (speed / MAX_SPEED) * FOV_INCREASE
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0)
