extends KinematicBody2D


# TODO: Split variables into grouepd properties (see gdscript exports)
# Character attributes
export var movementSpeed = 24
export var jumpSpeed = 960
export var turnaroundDecel = 60
export var maxCoyoteTime = 0.5	# in seconds
export var maxJumpBuffer = 0.25	# in seconds
export var horMoveJumpBoost = 0.075	# multiplier for horizontal velocity added to jump speed
export var maxSpeedHorFloor = 320
export var maxSpeedHorWall = 80
# Acceleration forces
export var gravity = 2400
export var friction = 20
# Movement speed limits
export var shortHopSpeed = -300
export var slowFallSpeed = 600
export var terminalVelocity = 1200
var maxSpeedHor = maxSpeedHorFloor
# Used for storing player data
var velocity = Vector2.ZERO
var canJump = false
var coyoteTimer = 0
var isJumpBuffered = false
var jumpBufferTimer = 0
const bulletPath = preload("res://assets/scenes/player/bullet.tscn")
var directio = Vector2.RIGHT
var initial 

# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Based somewhat off https://info.sonicretro.org/Category:Sonic_Physics_Guide
	_grabInput(delta)
	_movePlayer(delta)
	move_and_slide(velocity, Vector2.UP)	# Must be before ground checking
	_checkGround(delta)
	shoot(delta)
	

func _grabInput(delta):
	# TODO: Make this just for grabbing input, and manipulate position in movePlayer
	# Move left and right at movementSpeed pixels/second
	initial = velocity.x
	velocity.x += (Input.get_action_strength("moveRight") - Input.get_action_strength("moveLeft")) * movementSpeed# * delta
	
	# When jump is pressed, move upward at jumpSpeed pixels/second
	# TODO: Make jumping its own function (or handled in _movePlayer), keep in mind it's also used by floor checking
	if Input.is_action_just_pressed("jump"):
		if canJump:
			velocity.y = -jumpSpeed - abs(velocity.x) * horMoveJumpBoost
			canJump = false


func _movePlayer(delta):
	# Falling
	# Always accelerate downward at gravity pixels/second^2
	velocity.y += gravity * delta
	
	# Modify x movement
	# TODO: Allow a way to preserve momentum by jumping, like bunny hopping in Quake/CS
	# TODO: Make x positional accelerations dependent on delta
	# Make sure player doesn't go over maxSpeedHor
	if abs(velocity.x) > abs(maxSpeedHor):
		velocity.x = maxSpeedHor * sign(velocity.x)
	# When turning around, decelerate faster (turnaroundDecel)
	if Input.get_action_strength("moveRight") - Input.get_action_strength("moveLeft") != 0 and sign(velocity.x) != Input.get_action_strength("moveRight") - Input.get_action_strength("moveLeft"):
		velocity.x -= turnaroundDecel * sign(velocity.x)
	# Apply friction if not actively moving and on ground
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


func _checkGround(delta):
	# If grounded
	if is_on_floor():
		# Jump if buffered and under jump buffer timeframe
		if isJumpBuffered and jumpBufferTimer < maxJumpBuffer:
			velocity.y = -jumpSpeed - abs(velocity.x) * horMoveJumpBoost
			canJump = false
			isJumpBuffered = false
		# Otherwise, stop moving downward and reset jump-related variables
		else:
			velocity.y = 0
			canJump = true
			coyoteTimer = 0
			jumpBufferTimer = 0
			isJumpBuffered = false
	# Stop rising and bonk downward when hitting a ceiling
	elif is_on_ceiling():
		velocity.y = 120
	# If in midair
	elif !is_on_floor():
		# Disable jumping when over coyote time
		if coyoteTimer > maxCoyoteTime:
			canJump = false
		# Add to coyote timer if you can jump
		elif canJump:
			coyoteTimer += delta
		# If jump is buffered, elapse jump buffer timer
		if isJumpBuffered and jumpBufferTimer < maxJumpBuffer:
			jumpBufferTimer += delta
		# Buffer a jump when jump is pressed while falling (only allowed once per jump)
		elif Input.is_action_just_pressed("jump") and velocity.y > 0 and !isJumpBuffered:
			isJumpBuffered = true
			
	# Check for walls: change horizontal max speed depending on such
	if is_on_wall():
		maxSpeedHor = maxSpeedHorWall
	elif !is_on_wall():
		maxSpeedHor = maxSpeedHorFloor
		
func shoot(delta):
	if Input.is_action_just_pressed("ui_accept"):
		var bullet = bulletPath.instance()
		get_parent().add_child(bullet)
		bullet.global_position = $Position2D.global_position
		
	
