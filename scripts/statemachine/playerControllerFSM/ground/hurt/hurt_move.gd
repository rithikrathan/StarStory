extends State

var player: CharacterBody3D


func enter() -> void:
	player = _finite_state_machine.get_parent() as CharacterBody3D


@warning_ignore("unused_parameter")
func update(delta: float) -> void:
	pass


@warning_ignore("unused_parameter")
func physics_update(delta: float) -> void:
	if _finite_state_machine.current_state != self:
		return

	pass
