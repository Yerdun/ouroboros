extends KinematicBody2D


# Movement and jump speeds
export var movementSpeed = 24
export var jumpSpeed = -1000
# Deceleration forces
export var gravity = 2400
export var friction = 20
# Movement speed limits
export var maxSpeedHor = 320
export var shortHopSpeed = -300
export var slowFallSpeed = 600
export var terminalVelocity = 1200
# Used for storing player data
var velocity = Vector2.ZERO
var canJump = false


# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass	# Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Based somewhat off https://info.sonicretro.org/Category:Sonic_Physics_Guide
	
	_grabInput()
	_movePlayer(delta)
	move_and_slide(velocity, Vector2.UP)	# Must be before ground checking
	_checkGround()
	
	_debugInfo()	# Remove at some point


func _grabInput():
	# TODO: Add the ability to buffer jumps to make maintaining momentum easier
	# Move left and right at movementSpeed pixels/second
	velocity.x += (Input.get_action_strength("moveRight") - Input.get_action_strength("moveLeft")) * movementSpeed# * delta
	# When jump is pressed, move upward at jumpSpeed pixels/second
	if Input.is_action_just_pressed("jump") and canJump:
		velocity.y = jumpSpeed
		canJump = false


func _movePlayer(delta):
	# Falling
	# Always accelerate downward at gravity pixels/second^2
	velocity.y += gravity * delta	# TODO: Figure out why every 4 frames it does this while grounded
	
	# Modify x movement
	# Make sure player doesn't go over maxSpeedHor
	# TODO: Allow a way to preserve momentum by jumping, like bunny hopping in Quake/CS
	if abs(velocity.x) > abs(maxSpeedHor):
		velocity.x = maxSpeedHor * sign(velocity.x)
	# Apply friction if not actively moving and on ground
	# TODO: Account for turnarounds, since right now it's faster to stop moving by letting go than moving in the other direction
	if Input.get_action_strength("moveRight") - Input.get_action_strength("moveLeft") == 0 and velocity.x != 0 and is_on_floor():
		velocity.x -= min(abs(velocity.x), friction) * sign(velocity.x)# * delta
	
	# Modify y movement
	# Allow for variable jump height
	if !is_on_floor() and !Input.is_action_pressed("jump") and velocity.y < shortHopSpeed:
		velocity.y = shortHopSpeed
	# After apex of jump, if jump is held in midair, fall slowly
	elif !is_on_floor() and Input.is_action_pressed("jump") and velocity.y > 0:
		if velocity.y > slowFallSpeed:
			velocity.y = slowFallSpeed
	# Don't allow player to fall faster than terminal velocity
	elif velocity.y > terminalVelocity:
		velocity.y = terminalVelocity


func _checkGround():
	# TODO: Implement some sort of limited coyote time
	# NOTE: You can build up speed (up to maxSpeedHor) if you continually run into a wall. Debating on whether or not to add a check for this
	# If grounded, reset downward velocity and allow jump
	if is_on_floor():
		velocity.y = 0
		canJump = true
	# Stop rising and bonk downward when hitting a ceiling
	elif is_on_ceiling():
		print("bonk")
		velocity.y = 100


func _debugInfo():
	# TODO: Put this information in HUD instead of console
	print(velocity)
#	print("left movement: ", Input.get_action_strength("moveLeft"), " right movement: ", Input.get_action_strength("moveRight"))
