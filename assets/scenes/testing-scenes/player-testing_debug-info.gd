extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# TODO: Figure out how to shorten the whole var2str thing
	set_text(
		"Position: " + var2str(get_node("../../Player").position) +
		"\nSpeed: " + var2str(get_node("../../Player").velocity) +
		"\ncanJump: " + var2str(get_node("../../Player").canJump) +
		"\ncoyoteTimer: " + var2str(get_node("../../Player").coyoteTimer) +
		"\nX-Axis Inputs: " + var2str(Input.get_action_strength("moveLeft") - Input.get_action_strength("moveRight"))
		)
