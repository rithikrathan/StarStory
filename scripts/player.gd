# INFO: 
# -----------------------------------------------------------------------------
# Script: player.gd
# Version: 0.1
# Author: RITHIK RATHAN C. <github.com/rithikrathan>
# License:
# Repository: https://github.com/rithikrathan/StarStory.git
# Project: star-story
# Created: 2026-06-06
# Description:
#			Main script of the player controller, this has all the
# properties and helper functions and statemachine initializations
# -----------------------------------------------------------------------------

extends CharacterBody3D

const SPEED = 6.9
const RUN_SPEED = 10.0
const SPRINT_SPEED = 14.0
const JUMP_VELOCITY = 5.5
const DOUBLE_TAP_WINDOW = 0.3

const MAX_STAMINA = 500

@export var walkAccleration: float = 2.0
@export var runAccleration: float = 7.0
@export var sprintAccleration: float = 9.0
@export var sprintTimeout: float = 34.0

# Stamina is the time remaining => stamina / drainRate = seconds left of sprint.
@export var stamina: float = 300

var spawnPosition: Vector3 = Vector3(0, 6, 0)
var gravVel: Vector3
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var last_forward_press_time: float = 0.0
var health = 100
var isDed = false
var disabled: bool = false
var wantsRun: bool = false

var camera_controller: Node3D
var fsm: FiniteStateMachine
var jump_charge_time: float = 0.0

# =-=-=-=-=-=-=-= [ TIMERS ] =-=-=-=-=-=-=-=
var sprintTimer = Timer.new()


func kill(message: String = "fuxk you in perticular") -> void:
	print("Reason for Death: " + message)  # [debug]
	self.position = spawnPosition


# NOTE: No changes needed
func get_player_relative_dir(input_dir: Vector2) -> Vector3:
	return (transform.basis * Vector3(input_dir.x, 0, -input_dir.y)).normalized()


# NOTE: No changes needed
func get_camera_relative_dir(input_dir: Vector2) -> Vector3:
	var cam_basis = camera_controller.transform.basis
	var forward = Vector3(-cam_basis.z.x, 0, -cam_basis.z.z).normalized()
	var right = Vector3(cam_basis.x.x, 0, cam_basis.x.z).normalized()
	return (forward * input_dir.y + right * input_dir.x).normalized()


func _input(_event: InputEvent) -> void:
	pass


func _ready() -> void:
	camera_controller = $camerAnchor/cameraController
	fsm = $movementStateMachine
	fsm.set_physics_process(false)


func get_input_dir() -> Vector2:
	# return Input.get_vector("moveRight","moveLeft", "moveForward", "moveBackward")
	return Input.get_vector("moveLeft", "moveRight", "moveBackward", "moveForward")


@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("esc"):
		disabled = !disabled

	if Input.is_action_just_pressed("moveForward"):
		var now = Time.get_ticks_msec() / 1000.0
		if now - last_forward_press_time < DOUBLE_TAP_WINDOW:
			wantsRun = true
			print("will run in next input")  # [debug]
		last_forward_press_time = now

	if stamina > MAX_STAMINA:
		stamina = MAX_STAMINA  # cap stamina incase it goes out of reach
	elif stamina < 0:
		stamina = 0  # cap stamina incase it goes negative


func _physics_process(delta: float) -> void:
	# gravity and y velocity, so just make it to use floor normal
	if not is_on_floor():
		velocity += (
			Vector3.ZERO
			if is_on_floor()
			else gravVel.move_toward(Vector3(0, velocity.y - gravity, 0), gravity * delta)
		)
	if fsm.current_state:
		fsm._state_down_call(fsm.current_state.id, "physics_update", delta)

	move_and_slide()
