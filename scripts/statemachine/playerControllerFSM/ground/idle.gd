extends State
#NOTE: perfect

@export var regainRate: float = 42.0

var player: CharacterBody3D

const FRICTION: float = 12.0


func enter() -> void:
	player = _finite_state_machine.get_parent() as CharacterBody3D
	player.velocity.y = 0.0
	print("State: Idle")  # [debug]


func update(delta: float) -> void:
	if player.stamina <= player.MAX_STAMINA:
		player.stamina = move_toward(player.stamina, player.MAX_STAMINA, regainRate * delta)


func physics_update(delta: float) -> void:
	if _finite_state_machine.current_state != self:
		return

	if player.wantsRun:
		player.wantsRun = false
		transition("ground/run")
		return

	var input_dir = player.get_input_dir()

	if input_dir.length() > 0 and !player.disabled:
		if Input.is_action_just_pressed("sprint"):
			transition("ground/sprint")
		else:
			transition("ground/walk")
	else:
		# reset velocity so velocity of the previous states wont be affecting this state

		# player.velocity.x = move_toward(player.velocity.x, 0.0, FRICTION * delta)
		# player.velocity.z = move_toward(player.velocity.z, 0.0, FRICTION * delta)

		player.velocity = player.velocity.lerp(Vector3.ZERO, FRICTION * delta)

	if Input.is_action_just_pressed("jump") and not player.disabled:
		transition("ground/idle_jump_windup")
		return
