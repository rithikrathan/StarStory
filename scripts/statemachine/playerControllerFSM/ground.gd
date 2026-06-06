extends State

var player: CharacterBody3D

func enter() -> void:
	player = _finite_state_machine.get_parent() as CharacterBody3D

func logic_update(delta: float) -> void:
	pass

@warning_ignore("unused_parameter")
func physics_update(delta: float) -> void:
	if not player:
		player = _finite_state_machine.get_parent() as CharacterBody3D

	if not player.is_on_floor():
		transition("air/fall")
		return
