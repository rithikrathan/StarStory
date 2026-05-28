extends Node

@onready var primary_console = $HBoxContainer/PrimaryConsole

func _ready() -> void:
	primary_console.register_command("cheat", cheat, false)
	primary_console.register_command("test", test)
	print_init_messages()

func print_init_messages():
	primary_console.print_message(primary_console.col(Color.GREEN, "Hi!"))
	primary_console.print_message(primary_console.bold(primary_console.col("#984447", "This is bold and red dummy text")))
	primary_console.print_message(primary_console.italic(primary_console.crossed("This is italic and crossed dummy text")))
	primary_console.print_message(primary_console.col(Color.BLUE_VIOLET, primary_console.underline("It is already " + primary_console.timestamp() + "! A late time!")))

	primary_console._on_text_input_line_text_submitted("/help")
	primary_console.print_message(primary_console.col(Color.AQUA, "Try out some of the commands above, you can also use the buttons to interact."))
	primary_console.print_message(primary_console.col(Color.AQUA, "Each console window has it's seperately defined history and registered commands. This means `/help` will differ between consoles."))
	primary_console.print_message(primary_console.col(Color.AQUA, "To try the `/test` command which is only available in this console you will first need to use the button on the left `PrimaryToggleCLI` which will show/hide the command input."))

func cheat() -> void:
	primary_console.print_message("The cheating command was called!")

func test(args: Array) -> void:
	primary_console.print_message("The test command was called with these arguments: " + " ".join(PackedStringArray(args)))

