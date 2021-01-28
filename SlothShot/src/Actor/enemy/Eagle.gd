extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var velocity = Vector2()
var SPEED = 100
var direction = -1
var startpos


# Called when the node enters the scene tree for the first time.
func _ready():
	startpos = transform.get_origin().x # just gets starting x coordinate



func _physics_process(delta):
	if transform.get_origin().x != clamp(transform.origin.x, startpos - 100 , startpos +100): # we want the eagle to stay withing a range ...
	# and not just fall off
		direction *= -1
		$AnimatedSprite.flip_h = !($AnimatedSprite.flip_h) # Flip sprite every change in direction

	velocity.x = SPEED * direction
	var collision = move_and_collide(velocity * delta)
#	if collision:
#		print("I collided with ", collision.collider.name)


