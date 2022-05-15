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
		"\nisJumpBuffered: " + var2str(get_node("../../Player").isJumpBuffered) +
		"\njumpBufferTimer: " + var2str(get_node("../../Player").jumpBufferTimer) +
		"\nis_on_wall(): " + var2str(get_node("../../Player").is_on_wall()) +
		"\nX-Axis Inputs: " + var2str(Input.get_action_strength("moveLeft") - Input.get_action_strength("moveRight")) +
		"\ncanBoost: " + var2str(get_node("../../Player").canBoost) +
		"\nglobal mouse position: " + var2str(get_global_mouse_position()) +
		"\nmouse angle (rad): " + var2str(get_node("../../Player").get_angle_to(get_global_mouse_position())) +	# could be incorrect
		"\nboost value: " + var2str(Vector2(get_node("../../Player").boostSpeed, 0).rotated(get_node("../../Player").get_angle_to(get_node("../../Player").get_global_mouse_position())))
		)
