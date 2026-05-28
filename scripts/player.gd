extends CharacterBody3D


const SPEED = 6.9
const JUMP_VELOCITY = 5.5
var lastSpawnPosition: Vector3 = Vector3(0,69,0)
var gravity: Vector3 = Vector3(0,-9.8,0)

func kill(message:String):
	print("Reason for Death:" + message)
	self.position = lastSpawnPosition

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		# velocity += get_gravity() * delta
		velocity += gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	var input_dir := Input.get_vector("moveLeft", "moveRight", "moveForward", "moveBackward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	move_and_slide()
