extends State

var player: CharacterBody3D
var vModel: Node3D

func enter() -> void:
	player = _finite_state_machine.get_parent() as CharacterBody3D
	vModel = %viewModel
	player.velocity.y = 0.0
	print("State: Sprint")

@warning_ignore("unused_parameter")
func physics_update(delta: float) -> void:
	if _finite_state_machine.current_state != self:
		return

	if not player:
		player = _finite_state_machine.get_parent() as CharacterBody3D

	var inputDir = player.get_input_dir()

	if inputDir.y > 0:
		var dir = player.get_camera_relative_dir(inputDir)
		player.velocity.x = dir.x * player.SPRINT_SPEED 
		player.velocity.z = dir.z * player.SPRINT_SPEED 
		vModel.look_at(vModel.global_position + dir)

		if Input.is_action_just_pressed("moveForward"):
			transition("ground/walk")
			return

		if Input.is_action_just_pressed("moveForward"):
			transition("ground/walk")
			return
	else:
		transition("ground/idle")
		return
