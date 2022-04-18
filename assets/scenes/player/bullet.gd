extends Area2D
var velocity = Vector2(1,0)
var speed = 10

func _process(delta):
	
	position.x += speed
	

func _on_Area2D_body_entered(body):
	if body.has_method("takeDamage"):
		body.takeDamage()
		queue_free()
