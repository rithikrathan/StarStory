extends Node

@onready var cat = %cat
@onready var mainSpawn = %mainSpawn
@onready var buildings = %buildings
@onready var terrain = %terrain
@onready var slope = %slope
@onready var crouch = %crouch
@onready var platforms = %platforms
@onready var player = %player
	
func print_init_messages():
	cat.print_message(cat.col(Color.GREEN, "Oi!"))
	cat._proceed_command("/help")

func _ready() -> void:
	cat.register_command("ping", ping, false)
	cat.register_command("tp", tp)
	cat.register_command("kill", kill)
	print_init_messages()

func print_info(text:String):
	pass

func print_err(text:String):
	pass

func print_warn(text:String):
	pass

func ping() -> void:
	cat.print_message("Pong!")

func kill(args: Array) -> void:
	cat.print_message("Entity killed")
	match args[0]:
		"@p":
			player.kill("Killed by command")
		_:
			cat.print_message("Invalid target, nothing was killed")

func tp(args: Array) -> void:
	match args[0]:
		"mainSpawn": 
			cat.print_message("teleporting to: " + args[0] + "....")
			player.spawnPosition = mainSpawn.position
			player.position = mainSpawn.position
		"buildings": 
			cat.print_message("teleporting to: " + args[0] + "....")
			player.spawnPosition = buildings.position
			player.position = buildings.position
		"terrain": 
			cat.print_message("teleporting to: " + args[0] + "....")
			player.spawnPosition = terrain.position
			player.position = terrain.position
		"slope": 
			cat.print_message("teleporting to: " + args[0] + "....")
			player.spawnPosition = slope.position
			player.position = slope.position
		"crouch": 
			cat.print_message("teleporting to: " + args[0] + "....")
			player.spawnPosition = crouch.position
			player.position = crouch.position
		"platforms": 
			cat.print_message("teleporting to: " + args[0] + "....")
			player.spawnPosition = platforms.position
			player.position = platforms.position
		"help":
			cat.print_message("Available spawn points: ")
			cat.print_message("    1) " + "mainSpawn")
			cat.print_message("    2) " + "buildings")  
			cat.print_message("    3) " + "terrain")
			cat.print_message("    4) " + "slope")   
			cat.print_message("    5) " + "crouch")   
			cat.print_message("    6) " + "platforms")   
		_:
			cat.print_message("invalid argument")
