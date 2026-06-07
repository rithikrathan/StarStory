extends State

@export var chargeRate: float = 5.0

var player: CharacterBody3D
# var vModel: Node3D

func enter() -> void:
	player = _finite_state_machine.get_parent() as CharacterBody3D
#	vModel = %viewModel
	player.jump_charge_time = 0.0
	print("State: JumpWindup")

func logic_update(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	if not player:
		player = _finite_state_machine.get_parent() as CharacterBody3D

	if Input.is_action_pressed("jump"):
		player.jump_charge_time = min(player.jump_charge_time + delta * chargeRate, 10.0)
#		var squat = 1.0 - (player.jump_charge_time / 10.0) * 0.3
#		vModel.scale.y = squat
	else:
		pass
#		vModel.scale.y = 1.0
		transition("air/ascend")
