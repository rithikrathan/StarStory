extends State

var player: CharacterBody3D

func enter() -> void:
	player = _finite_state_machine.get_parent() as CharacterBody3D
	player.velocity.y = 0.0
	print("State: Walk")

func physics_update(delta: float) -> void:
	if _finite_state_machine.current_state != self:
		return

	if not player:
		player = _finite_state_machine.get_parent() as CharacterBody3D

	var input_dir = player.get_input_dir()
	if input_dir.length() > 0:
		var dir = player.get_player_relative_dir(input_dir)
		player.velocity.x = dir.x * player.SPEED
		player.velocity.z = dir.z * player.SPEED

		if player.shift_just_pressed:
			transition("ground/run")
			return
	else:
		transition("ground/idle")
		return
