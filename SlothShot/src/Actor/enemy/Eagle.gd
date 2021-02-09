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
	get_node("EagleAnimatedSprite").play() # get the animated sprite to play	



func _physics_process(delta):
	if transform.get_origin().x != clamp(transform.origin.x, startpos - 100 , startpos +100): # we want the eagle to stay withing a range ...
	# and not just fall off
		direction *= -1
		$EagleAnimatedSprite.flip_h = !($EagleAnimatedSprite.flip_h) # Flip sprite every change in direction

	velocity.x = SPEED * direction
	var collision = move_and_collide(velocity * delta)
	if collision:
		if collision.collider.name == "Player":
			if is_instance_valid($EagleCollisionShape2D):
				$EagleCollisionShape2D.queue_free()
				print("collision node removed")
		


