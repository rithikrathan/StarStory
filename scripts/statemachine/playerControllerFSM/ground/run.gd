#INFO:
# -----------------------------------------------------------------------------
# Script: run.gd
# Version: 0.1
# Author: RITHIK RATHAN C. <github.com/rithikrathan>
# License: 
# Repository: 
# Project: star-story
# Created: 2026-06-06
# Description: test descritption bro
# -----------------------------------------------------------------------------

extends State

var player: CharacterBody3D
var vModel: Node3D
# var viewModel: Node3D = _finite_state_machine.get_parent().get_child("viewModel")

func enter() -> void:
	vModel = %"viewModel"
	player = _finite_state_machine.get_parent() as CharacterBody3D
	player.velocity.y = 0.0
	print("State: Run")

func logic_update(delta: float) -> void:
	pass

@warning_ignore("unused_parameter")
func physics_update(delta: float) -> void:
	if _finite_state_machine.current_state != self:
		return

	if not player:
		player = _finite_state_machine.get_parent() as CharacterBody3D

	if player.disabled:
		transition("ground/idle")

	var inputDir = player.get_input_dir()
	if inputDir.y > 0:
		var dir = player.get_camera_relative_dir(inputDir)
		var target = dir *  player.RUN_SPEED
		player.velocity = player.velocity.lerp(target, player.runAccleration * delta)

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
