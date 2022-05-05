extends KinematicBody2D
var velocity = Vector2(1,0)
var speed = 10
var direction = Vector2.RIGHT

#func _ready():
	

func _physics_process(delta):
	#moves bullet right
	position.x += speed
	
