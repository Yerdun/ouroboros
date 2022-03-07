extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var movementSpeed = 240
var jumpSpeed = 100

var gravity = 200
var friction = 5

var velocity = Vector2.ZERO
var canJump = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass	# Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity.x += (Input.get_action_strength("moveRight") - Input.get_action_strength("moveLeft")) * movementSpeed * delta
	velocity.y += gravity * delta
	
	if (Input.get_action_strength("moveRight") - Input.get_action_strength("moveLeft") == 0 and velocity.x != 0):
		velocity.x -= min(abs(velocity.x), friction) * sign(velocity.x)
	
	move_and_slide(velocity)
	
