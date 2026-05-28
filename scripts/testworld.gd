extends Node3D

@onready var cat = %cat
@onready var player = %player

func _input(_event: InputEvent) -> void:
	pass

func _ready() -> void:
	pass 

func _process(_delta: float) -> void:
	if cat.visible:
		player.disabled = true
	else:
		player.disabled = false


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		body.kill("Death by void")
