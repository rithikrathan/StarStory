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

	if player.disabled:
		transition("ground/idle")

	var inputDir = player.get_input_dir()
	if inputDir.y > 0:
		var dir = player.get_camera_relative_dir(inputDir)
		var target = dir *  player.SPRINT_SPEED
		player.velocity = player.velocity.lerp(target, player.sprintAccleration * delta)

		# rotate view model
		var target_basis = Basis.looking_at(dir)
		var target_quat = Quaternion(target_basis)
		vModel.quaternion = vModel.quaternion.slerp(target_quat, delta * 10.0)

		if Input.is_action_just_pressed("moveForward"):
			transition("ground/walk")
			return

		if Input.is_action_just_pressed("sprint"):
			transition(_finite_state_machine.from_state.id)
			return
	else:
		transition("ground/idle")
		return
