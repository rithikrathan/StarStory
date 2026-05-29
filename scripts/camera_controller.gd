extends Node3D

@export var mouse_sensitivity: float = 0.002
@export var vertical_limit: float = 90.0
 
var player 

func _ready() -> void:
	player  = get_parent().get_parent()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x * mouse_sensitivity
		rotation.x -= event.relative.y * mouse_sensitivity
		rotation.x = clamp(rotation.x, deg_to_rad(-vertical_limit), deg_to_rad(vertical_limit))
	if player.disabled:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	# if event.is_action_pressed("ui_cancel"):
	# 	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
	# 		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	# 	else:
	# 		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
