extends State

var player: CharacterBody3D

func enter() -> void:
	player = _finite_state_machine.get_parent() as CharacterBody3D
	player.velocity.y = 0.0
	print("State: Idle")

func physics_update(delta: float) -> void:
	if _finite_state_machine.current_state != self:
		return

	if not player:
		player = _finite_state_machine.get_parent() as CharacterBody3D

	var input_dir = player.get_input_dir()
	player.velocity.x = move_toward(player.velocity.x, 0, player.SPEED)
	player.velocity.z = move_toward(player.velocity.z, 0, player.SPEED)

	if input_dir.length() > 0:
		if Input.is_key_pressed(KEY_SHIFT):
			transition("ground/run")
		else:
			transition("ground/walk")
