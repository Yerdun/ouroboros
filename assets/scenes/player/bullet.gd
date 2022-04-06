extends KinematicBody2D
var velocity = Vector2(1,0)
var speed = 400

func _physics_process(delta):
	position.x += 4
