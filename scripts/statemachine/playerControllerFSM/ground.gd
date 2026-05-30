extends State

var player: CharacterBody3D

func enter() -> void:
	player = _finite_state_machine.get_parent() as CharacterBody3D

func physics_update(delta: float) -> void:
	if not player:
		player = _finite_state_machine.get_parent() as CharacterBody3D

	var wants = player.wants_sprint
	player.wants_sprint = false
	if wants:
		transition("ground/sprint")
		return

	if not player.is_on_floor():
		transition("air/fall")
		return
