extends RigidBody2D


# Variables here
export var maxHP = 8 # Enemy HP
export var dmg = 1 # Damage
var currentHP # Enemy current HP


# Called when the node enters the scene tree for the first time.
func _ready():
	currentHP = maxHP # Sets current health to max HP


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_tryDying()


# Function to check if enemy has died
func _tryDying():
	if currentHP <= 0:
		queue_free()

