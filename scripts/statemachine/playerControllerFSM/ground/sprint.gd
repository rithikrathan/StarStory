extends State

var player: CharacterBody3D

func enter() -> void:
	player = _finite_state_machine.get_parent() as CharacterBody3D
	player.velocity.y = 0.0
	print("State: Sprint")

func physics_update(delta: float) -> void:
	if _finite_state_machine.current_state != self:
		return

	if not player:
		player = _finite_state_machine.get_parent() as CharacterBody3D

	var input_dir = player.get_input_dir()

	if input_dir.length() > 0:
		var dir = player.get_camera_relative_dir(input_dir).normalized()
		player.velocity.x = dir.x * player.SPRINT_SPEED
		player.velocity.z = dir.z * player.SPRINT_SPEED
		player.rotation.y = lerp_angle(player.rotation.y, atan2(dir.x, -dir.z), delta * 10.0)

		if Input.is_action_just_pressed("moveForward"):
			transition("ground/walk")
			return

		if Input.is_action_just_pressed("moveForward"):
			transition("ground/walk")
			return
	else:
		transition("ground/idle")
		return
