extends CharacterBody2D

var direction = 1
var speed = 100

func _ready():
	$RayCast2D.add_exception(get_parent().get_node('Player'))
	$AnimatedSprite2D.play('default')

func _process(delta):
	if $RayCast2D.is_colliding():
		direction *= -1
		scale.x *= -1
	if not is_on_floor():
		velocity += get_gravity() * delta
	velocity.x = speed * direction
	move_and_slide()
