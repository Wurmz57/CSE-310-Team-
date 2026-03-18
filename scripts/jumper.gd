extends CharacterBody2D

@export var door_id: StringName = &"NULL"
#I want to make sure it doesn't fire if there is no need for this behavior	
var direction = 1
var speed = 100
var dead := false

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

func _on_jump_timer_timeout() -> void:
	if is_on_floor():
		velocity.y = -400

func _on_enemy_hurtbox_hit() -> void:
	if get_parent().get_node('Player').position.x > position.x:
		if direction == 1:
			scale.x *= -1
		direction = -1
	else:
		if direction == -1:
			scale.x *= -1
		direction = 1
	if is_on_floor():
		velocity.y = -400
		
func die():
	if dead:
		return
	dead = true
	if door_id != &"NULL":
		DoorEvents.enemy_defeated.emit(door_id)
	queue_free()
