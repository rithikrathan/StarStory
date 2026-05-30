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
	if input_dir.y > 0:
		var local_dir = player.get_camera_relative_dir(input_dir)
		var dir = (player.transform.basis * local_dir).normalized()
		player.velocity.x = dir.x * player.SPRINT_SPEED
		player.velocity.z = dir.z * player.SPRINT_SPEED

		var target_angle = player.camera_controller.rotation.y
		player.rotation.y = lerp_angle(player.rotation.y, target_angle, delta * 10.0)
	else:
		transition("ground/walk")
		return
