extends CharacterBody2D

var direction = 1
var speed = 0
var activated = false
@export var slime_ball_scene: PackedScene

func _ready():
	$RayCast2D.add_exception(get_parent().get_node('Player'))
	$AnimatedSprite2D.play('default')

func _process(delta):
	if position.distance_squared_to(get_parent().get_node('Player').position) <= 100000 and not activated:
		speed = 60
		$AttackTimer.start()
		activated = true
	if $RayCast2D.is_colliding():
		direction *= -1
		scale.x *= -1
	if not is_on_floor():
		velocity += get_gravity() * delta
	velocity.x = speed * direction
	if $StunTimer.is_stopped():
		move_and_slide()

func _on_enemy_hurtbox_hit() -> void:
	$StunTimer.start()
	$Invulnerability.start()
	speed *= 1.15
	$EnemyHurtbox.get_node('CollisionShape2D').set_deferred('disabled', true)

func _on_stun_timer_timeout() -> void:
	if get_parent().get_node('Player').position.x > position.x:
		if direction == 1:
			scale.x *= -1
		direction = -1
	else:
		if direction == -1:
			scale.x *= -1
		direction = 1

func _on_invulnerability_timeout() -> void:
	$EnemyHurtbox.get_node('CollisionShape2D').set_deferred('disabled', false)

func _on_attack_timer_timeout() -> void:
	var slime_ball = slime_ball_scene.instantiate()
	slime_ball.position = position
	slime_ball.velocity = Vector2(randf_range(-100, 100), -250)
	get_parent().add_child(slime_ball)
