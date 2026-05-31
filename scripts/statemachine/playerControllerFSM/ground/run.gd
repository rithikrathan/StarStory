extends State

var player: CharacterBody3D
var vModel: Node3D
# var viewModel: Node3D = _finite_state_machine.get_parent().get_child("viewModel")

func enter() -> void:
	vModel = %"viewModel"
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
		var dir = player.get_camera_relative_dir(inputDir)
		player.velocity.x = dir.x * player.RUN_SPEED 
		player.velocity.z = dir.z * player.RUN_SPEED 
		vModel.look_at(vModel.global_position + dir)

		if Input.is_action_just_pressed("sprint"):
			transition("ground/sprint")
			return

	else:
		transition("ground/idle")
		return
