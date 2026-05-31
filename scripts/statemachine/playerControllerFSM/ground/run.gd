extends State

var player: CharacterBody3D

func enter() -> void:
	player = _finite_state_machine.get_parent() as CharacterBody3D
	player.velocity.y = 0.0
	print("State: Run")

@warning_ignore("unused_parameter")
func physics_update(delta: float) -> void:
	if _finite_state_machine.current_state != self:
		return

	if not player:
		player = _finite_state_machine.get_parent() as CharacterBody3D

	var inputDir = player.get_input_dir()

	if inputDir.y > 0:
		#movement code here
		if Input.is_action_just_pressed("sprint"):
			transition("ground/sprint")
			return

	else:
		transition("ground/idle")
		return
