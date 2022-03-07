extends KinematicBody2D


# Movement and jump speeds
export var movementSpeed = 12
export var jumpSpeedInit = 900

# Natural forces
export var gravity = 20
export var friction = 8

# Movement speed limits
export var maxSpeedHor = 320
export var shortHopSpeed = -300
export var slowFallSpeed = 600
export var terminalVelocity = 1200

# Used for storing player data
var playerVelocity = Vector2.ZERO
var canJump = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass	# Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# TODO: Split this logic into several functions for better readability
	# Based somewhat off https://info.sonicretro.org/Category:Sonic_Physics_Guide
	
	# Move left and right at movementSpeed pixels/second
	playerVelocity.x += (Input.get_action_strength("moveRight") - Input.get_action_strength("moveLeft")) * movementSpeed
	# Make sure player doesn't go over movementSpeed
	if abs(playerVelocity.x) > abs(maxSpeedHor):
		playerVelocity.x = maxSpeedHor * sign(playerVelocity.x)
	
	# Reset downward velocity to 0 if grounded
	if is_on_floor():
		playerVelocity.y = 0
		canJump = true
	# Stop rising if hitting ceiling
	elif is_on_ceiling():
		playerVelocity.y = 100
	# Otherwise move downward at gravity pixels/second
	else:
		playerVelocity.y += gravity
	
	# Jumping
	if Input.is_action_just_pressed("jump") and canJump:
		playerVelocity.y = -jumpSpeedInit
		canJump = false
	
	# Allow for variable jump height
	if !is_on_floor() and !Input.is_action_pressed("jump") and playerVelocity.y < shortHopSpeed:
		playerVelocity.y = shortHopSpeed
		print(playerVelocity)
	# If jump is held in midair, fall slowly
	elif !is_on_floor() and Input.is_action_pressed("jump") and playerVelocity.y > slowFallSpeed:
		playerVelocity.y = slowFallSpeed
	# If falling faster than terminalVelocity, keep it there
	elif playerVelocity.y > terminalVelocity:
		playerVelocity.y = terminalVelocity
	
	# Apply friction if not actively moving and on ground
	if Input.get_action_strength("moveRight") - Input.get_action_strength("moveLeft") == 0 and playerVelocity.x != 0 and is_on_floor():
		playerVelocity.x -= min(abs(playerVelocity.x), friction) * sign(playerVelocity.x)
	
	move_and_slide(playerVelocity, Vector2.UP)
	print(playerVelocity)
	
