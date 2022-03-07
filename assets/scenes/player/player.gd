extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var movementSpeed = 12
var maxSpeed = 320
var jumpForce = 700

var gravity = 20
var friction = 8

var velocity = Vector2.ZERO
var canJump = true


# Called when the node enters the scene tree for the first time.
func _ready():
	pass	# Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	# Move left and right at movementSpeed pixels/second
	velocity.x += (Input.get_action_strength("moveRight") - Input.get_action_strength("moveLeft")) * movementSpeed
#	# Make sure player doesn't go over movementSpeed
	if abs(velocity.x) > abs(maxSpeed):
		velocity.x = maxSpeed * sign(velocity.x)
	
	# Reset downward velocity to 0 if grounded
	if is_on_floor():
		velocity.y = 0
		canJump = true
	# Otherwise move downward at gravity pixels/second
	else:
		velocity.y += gravity
	
	# TODO: Implement vaguely similar jump mechanics to https://info.sonicretro.org/SPG:Jumping
	# Thinking something more similar to Mario, where you can hold jump to fall slower, might need states for this
	if Input.is_action_just_pressed("jump") and canJump:
		velocity.y = -jumpForce
		canJump = false
	
	# Apply friction if not actively moving: function copied from Sonic Retro's Classic Sonic physics breakdown
	# TODO: Only apply this while on the ground, in midair there should be no resistance
	if (Input.get_action_strength("moveRight") - Input.get_action_strength("moveLeft") == 0 and velocity.x != 0):
		velocity.x -= min(abs(velocity.x), friction) * sign(velocity.x)
	
	move_and_slide(velocity, Vector2.UP)
	print(velocity)
	
