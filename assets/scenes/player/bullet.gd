extends KinematicBody2D
var velocity = Vector2(1,0)
var speed = 10

func _physics_process(delta):
	
	position.x += speed
