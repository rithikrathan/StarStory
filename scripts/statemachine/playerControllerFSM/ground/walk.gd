extends State

#NOTE: perfect
var player: CharacterBody3D
var vModel: Node3D

@export var drainRate:float = 3.0

func enter() -> void:
	player = _finite_state_machine.get_parent() as CharacterBody3D
	vModel = %"viewModel"
	player.velocity.y = 0.0
	print("State: Walk")

func logic_update(delta: float) -> void:
		if player.stamina <= player.MAX_STAMINA:
			player.stamina = move_toward(player.stamina, 0, drainRate * delta)

func physics_update(delta: float) -> void:
	if _finite_state_machine.current_state != self:
		return

	if not player:
		player = _finite_state_machine.get_parent() as CharacterBody3D

	if player.wantsRun:
		player.wantsRun = false
		transition("ground/run")
		return

	if player.disabled:
		transition("ground/idle")

	var inputDir = player.get_input_dir()

	if inputDir.length() > 0:
		var dir = player.get_camera_relative_dir(inputDir)

		var target = dir *  player.SPEED
		player.velocity = player.velocity.lerp(target, player.walkAccleration * delta)

		# rotate view model
		var target_basis = Basis.looking_at(dir)
		var target_quat = Quaternion(target_basis)
		vModel.quaternion = vModel.quaternion.slerp(target_quat, delta * 10.0)

		if Input.is_action_just_pressed("sprint"):
			transition("ground/sprint")
			return
	else:
		transition("ground/idle")
		return
