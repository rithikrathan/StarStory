extends State


func enter() -> void:
	print("State: Ascend")  # [debug]


@warning_ignore("unused_parameter")
func update(delta: float) -> void:
	pass


@warning_ignore("unused_parameter")
func physics_update(delta: float) -> void:
	pass
